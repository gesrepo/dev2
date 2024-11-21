/**
 * Class: InformaBatchable.cls
 * Developer: Marian Iovi (marian.iovi@vertiba.com)
 * Created: December 12, 2016
 * Modified: March 23, 2017
 * Objective: This class provides methods for verify if exist opportunities with an Event Code and Token, create Booth Upload 
 *              and get new infos from informa, for ScheduleInformaBatchable.cls
 *
 **/ 

global class InformaBatchable implements Database.Batchable<SObject>, Database.AllowsCallouts, Database.Stateful {
    public Map<Id, Booth_Upload__c> buList {get;set;}
    public Map<Id, List<Booth_Staging__c>> bsList {get;set;}

    public String query;
 
    global InformaBatchable(){
        buList = new Map<Id, Booth_Upload__c>();
        bsList = new Map<Id, List<Booth_Staging__c>>();
    }

    global Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext context, List<Opportunity> scope) {
        System.debug('****scope: ' + scope);
        Boolean haveErrors = false;
        String ERBody = 'Errors on inserting BoothStaging. <br/><br/><br/>';
        List<Opportunity> opToUpdate = new List<Opportunity>();

        if(scope.size() > 0){
                    //get url from custom setting Informa_API_Settings__c
            Informa_API_Settings__c informaCS = [Select Id, Name, Url_Value__c, Subscription_Key__c from Informa_API_Settings__c Limit 1];
            List<InformaIntegrationFields__c> informaCSf = [Select Name, Api_Informa__c, Booth_Staging_Api_Name__c from InformaIntegrationFields__c];
            Map<String, InformaIntegrationFields__c> informaCSfMap = new Map<String, InformaIntegrationFields__c>();

            String url = String.valueOf(informaCS.Url_Value__c);
            String subsKey = informaCS.Subscription_Key__c;

            //field type
            Map<String, Schema.SObjectField> MapF = Schema.SObjectType.Booth_Staging__c.fields.getMap();

            Integer count = 0;
            Map<Integer, Map<String,Map<String, String>>> bsMapString = new Map<Integer, Map<String,Map<String, String>>>();

            for(Opportunity op :scope){
                //System.debug('****opportunity: ' + op);

                //create Booth opload based on every oppty
                Boolean setCancel = false;
                Booth_Upload__c bu = new Booth_Upload__c();
                bu.Opportunity__c = op.Id;
                if(op.AccountId != null){
                    bu.Organiser_2__c = op.AccountId;
                }

                //pull records from informa based on op.Event_Code__c and op.Token__c
                JSONParser parser = null;
                if(!Test.isRunningTest()){
                    try{
                        ExternalInforma ei = new ExternalInforma(op.Event_Code__c, op.Token__c, url, subsKey);
                        //parse the JSON from Informa and add values in an OpportunityWrapper record
                        string response = ei.getRespose();
                        parser = JSON.createParser(response);
                        system.debug('response: ' + response);
                        
                        if (response.contains('HTTP Error 400. The request is badly formed.'))
                        {
                            haveErrors = true;
                        	ERBody += 'Informa Error: HTTP Error 400. The request is badly formed. <br/><br/>' +
                                'on opportunity: ' + op.id + '<br/><br/>';                            
                            Continue;
                        }                     
                    }catch(Exception ex){
                        haveErrors = true;
                        //System.debug('Informa Error: ' + ex.getMessage());
                        ERBody += 'Informa Error: ' + ex.getMessage() + ' <br/><br/>' +
                                'on opportunity: ' + op.id + '<br/><br/>';
                    }
                }else{
                    parser = JSON.createParser(InformaMockImpl.resp());
                }

                //convert json to a Custom map
                List<Map<String,Map<String, String>>> mapStringList = MapString(parser);

                //verify if bu is cancelled or not
                if(mapStringList.size() > 0){
                    Boolean passed = false;

                    for(Map<String,Map<String, String>> mapString: mapStringList){
                        List<String> owDateTime = mapString.get('Init').get('last_modified_date').split('T');
                        List<String> owDate = owDateTime[0].split('-');
                        List<String> owTime = owDateTime[1].split(':');

                        Datetime dt = Datetime.newInstance(Integer.valueOf(owDate[0]), Integer.valueOf(owDate[1]), Integer.valueOf(owDate[2]),
                                                            Integer.valueOf(owTime[0]), Integer.valueOf(owTime[1]), 0);

                        if(op.Last_Run_Date__c == null || (op.Last_Run_Date__c != null && dt > op.Last_Run_Date__c) ){
                            //System.debug('****mapped: ' + mapString);
                            passed = true;

                            Booth_Staging__c bs = new Booth_Staging__c();
                            bs.Opportunity__c = op.Id;
                            bs.Status__c = 'New';

                            if(bsList.containsKey(op.Id)) {
                                bsList.get(op.Id).add(bs);
                            } else {
                                bsList.put(op.Id, new List<Booth_Staging__c> { bs });
                            }

                            bsMapString.put(count, mapString);
                            count++;
                        }
                    }

                    //any mapSTring do not validate condition (dt < Datetime.now() && dt > Datetime.now().addDays(-1))
                    if(!passed){
                        setCancel = true;
                    }
                }else{
                    setCancel = true;
                }

                if(setCancel){
                    bu.Status__c = 'Cancel';
                }
                buList.put(op.Id, bu);
            }

            //update Last_Run_Date__c 
            for(Opportunity op: scope){
                op.Last_Run_Date__c = Datetime.now();
                opToUpdate.add(op);
            }
            try{
                update opToUpdate;
            }catch(DMLException ex){
                haveErrors = true;
                System.debug('Error on Update Opportunity: ' + ex.getMessage());
                ERBody += 'Error on Update Opportunity: ' + ex.getMessage() + '<br/><br/>';
            }

            if(buList.size() > 0){
                //insert Booth Upload List
                try{
                    insert buList.values();
                }catch(DMLException ex){
                    haveErrors = true;
                    System.debug('Error on insert Booth Upload: ' + ex.getMessage());
                    ERBody += 'Error on insert Booth Upload: ' + ex.getMessage() + '<br/><br/>';
                }
            }
            System.debug('***bsList: '+ bsList);
            List<Booth_Staging__c> bothStagingList = new List<Booth_Staging__c>();
            if(bsList.size() > 0){
                for(Id key: bsList.keySet()){
                    for(Booth_Staging__c b: bsList.get(key)){
                        b.Booth_Upload__c = buList.get(key).Id;
                        bothStagingList.add(b);
                    }
                }
            }
            //Mapping
            Integer bsCount = 0;
            //System.debug('***bsMapString: '+ bsMapString);
            for(Booth_Staging__c bs: bothStagingList){
                for(InformaIntegrationFields__c c: informaCSf){
                    informaCSfMap.put(c.Booth_Staging_Api_Name__c, c);
                    String key = '';
                    String vField = '';
                    if(String.valueOf(c.Api_Informa__c).split('\\.').size() > 1){
                        key = String.valueOf(c.Api_Informa__c).split('\\.')[0];
                        vField = String.valueOf(c.Api_Informa__c).split('\\.')[1];
                    }else{
                        key = 'Init';
                        vField = String.valueOf(c.Api_Informa__c);
                    }

                    Map<String, String> listm = bsMapString.get(bsCount).get(key);
                    for(String m: bsMapString.get(bsCount).get(key).keySet()){
                        if(m == vField){
                            Schema.SObjectField field = MapF.get(c.Booth_Staging_Api_Name__c);
                            Schema.DisplayType FldType = field.getDescribe().getType();

                            if(String.valueOf(FldType) == 'Decimal'){
                                bs.put(c.Booth_Staging_Api_Name__c, Decimal.valueOf(listm.get(m)));
                            }else if(String.valueOf(FldType) == 'Boolean'){
                                bs.put(c.Booth_Staging_Api_Name__c, Boolean.valueOf(listm.get(m)));
                            }else if(String.valueOf(FldType) == 'Integer'){
                                bs.put(c.Booth_Staging_Api_Name__c, Integer.valueOf(listm.get(m)));
                            }
                            else if(String.valueOf(FldType) == 'Double'){
                                bs.put(c.Booth_Staging_Api_Name__c, Double.valueOf(listm.get(m)));
                            }else if(String.valueOf(FldType) == 'PHONE' || String.valueOf(FldType) == 'FAX'){
                                if(String.valueOf(listm.get(m)).length() > 40){
                                    String ph = String.valueOf(listm.get(m)).substring(0, 38);
                                    bs.put(c.Booth_Staging_Api_Name__c, ph);
                                }else{
                                    bs.put(c.Booth_Staging_Api_Name__c, listm.get(m));
                                }
                                String ph = String.valueOf(listm.get(m));
                            }else if(String.valueOf(FldType) == 'EMAIL'){
                                String em = '';
                                if(String.valueOf(listm.get(m)).contains(',')){
                                    em = String.valueOf(listm.get(m)).split(',')[0];
                                }else if(String.valueOf(listm.get(m)).contains('<br>')){
                                    em = String.valueOf(listm.get(m)).split('<br>')[0];
                                }else{
                                    em = String.valueOf(listm.get(m));
                                }
                                    
                                String emailstr = '';
                                em = em.replaceAll( '\\s+', '');
                                if(validateEmail(em)){
                                    //System.debug('****email valid!');
                                    emailstr = em;
                                }else{
                                    emailstr = 'invalid@invalid.com';
                                }
                                
                                bs.put(c.Booth_Staging_Api_Name__c, emailstr);
                            }else{
                                bs.put(c.Booth_Staging_Api_Name__c, listm.get(m));
                            }
                        }
                    }
                }//end informaCSf for
                bsCount++;
                //System.debug('====================================other bs');
            }

            System.debug('***bothStagingList: '+ bothStagingList);

            //insert BoothStaging records
            if(bothStagingList.size() > 0){
                Database.SaveResult[] srList = Database.insert(bothStagingList, false);

                for(Integer i = 0; i < srList.size(); i++){
                    if (srList[i].isSuccess()) {
                        // Operation was successful, so get the ID of the record that was processed
                        System.debug('Successfully inserted BoothStaging. BoothStaging ID: ' + srList[i].getId());
                    }else{
                        haveErrors = true;
                        // Operation failed, so get all errors
                        for(Database.Error err : srList[i].getErrors()){
                            Schema.DescribeSObjectResult describeResult = Schema.getGlobalDescribe().get('Booth_Staging__c').getDescribe();
                            Map<String, Schema.SObjectField> fieldsMap = describeResult.fields.getMAp();
                            ERBody += 'The following error has occurred. <br/>';
                            ERBody += err.getStatusCode() + ': ' + err.getMessage() +'<br/>';
                            ERBody += 'On Informa Record: ';

                            for(String field: err.getFields()){
                                //verify if Booth_Staging__c contain the field
                                if(fieldsMap.containsKey(field)){
                                    Booth_Staging__c bs = bothStagingList[i];
                                    ERBody += String.valueOf(informaCSfMap.get('Exhibitor_GUID__c').Api_Informa__c) + ':' + bs.Exhibitor_GUID__c + '<br/>';
                                    ERBody += 'Field: "' + String.valueOf(informaCSfMap.get(field).Api_Informa__c) + '": ' + bs.get(field) + '; <br/>';
									ERBody += 'Booth Staging Company Name: ' + bs.Company__c + '; ';
                                }
                            }
                            ERBody += '<br/>';
                            ERBody += 'BoothStaging fields that affected this error: ' + err.getFields() +'<br/><br/>';
                        }//end for              
                    }
                }

                if(haveErrors || Test.isRunningTest()){
                    List<InformaApiErrorEmail__c> emails = [Select Id, Name, Email__c from InformaApiErrorEmail__c];

                    System.debug('***emails: ' + emails);
                    //send emails if get errors
                    if(emails.size() > 0){
                        Messaging.reserveSingleEmailCapacity(2);
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

                        // Strings to hold the email addresses to which you are sending the email.
                        String[] toAddresses = new List<String>();
                        for(Integer i = 0; i< emails.size();i++){
                            toAddresses.add(emails.get(i).Email__c);
                        }
                        System.debug('Email adress: ' + toAddresses);
                        
                        toAddresses.add('ddunkley@ges.com');

                        // Assign the addresses for the To and CC lists to the mail object.
                        mail.setToAddresses(toAddresses);
                        mail.setSenderDisplayName('Salesforce Support');
                        mail.setSubject('Informa integration errors');
                        mail.setUseSignature(false);
                        mail.setHtmlBody(ERBody);
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                    }
                }
            }
        }
    }
    
    global void finish(Database.BatchableContext context) {
    }

    global Boolean validateEmail(String email) {
        Boolean res = true;
        
    
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; 
        Pattern MyPattern = Pattern.compile(emailRegex);
        Matcher MyMatcher = MyPattern.matcher(email);

        if (!MyMatcher.matches()) 
            res = false;
        return res; 
    }

    global List<Map<String,Map<String, String>>> MapString(JSONParser parser){
        
        List<Map<String,Map<String, String>>> mapList = new List<Map<String,Map<String, String>>>();
        Map<String,Map<String, String>> mapString = new Map<String, Map<String, String>>();
        
        String field ='';
        String value ='';
        String arr = '';
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                while (parser.nextToken() != null) {
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        if(parser.getCurrentName() == null){
                            //System.debug('*parser.getCurrentName(): ' + parser.getCurrentName());
                            if(mapString.size()> 0){
                                //add to list
                                mapList.add(mapString);
                                //clear map
                                mapString = new Map<String, Map<String, String>>();
                            }
                            arr = 'Init';
                        }else{
                            arr = parser.getCurrentName();
                        }
                        mapString.put( arr, new Map<String, String>());
                    }else{
                        if(parser.getCurrentToken() == JSONToken.FIELD_NAME){
                            field = parser.getText();
                        }
                        if(parser.getCurrentToken() == JSONToken.VALUE_STRING){
                            value = parser.getText();
                            mapString.get(arr).put(field, value);
                        }
                    }
                }
            }
        }
        if(mapString.size()> 0){
            //add to list
            mapList.add(mapString);
        }

        System.debug('****mapList: ' + mapList);
        return mapList;
    }

}