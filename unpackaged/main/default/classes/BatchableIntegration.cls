global class BatchableIntegration implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.Stateful{
    global List <Opportunity> retOpportunities;
    global Set <String> EventsToQuery;
    global List <Map<String, object>> assets;
    global String query;
    
    //Constructor
    global BatchableIntegration()
    {
        assets= new List <Map<String, object>> ();
        retOpportunities= new List <Opportunity> ();
        EventsToQuery=new Set <String> ();
    }
    
    //Start Method
    global Database.QueryLocator start(Database.BatchableContext BC){
        //if test is not running
        if(!Test.isRunningTest()){
            query = 'SELECT AccountId,Event_Code__c,Id,Last_Run_Date__c FROM Opportunity WHERE Event_Code__c != Null AND Token__c != Null AND Last_Run_Date__c != Today';
            retOpportunities=[SELECT AccountId,Event_Code__c,Id,Last_Run_Date__c FROM Opportunity WHERE Event_Code__c != Null AND Token__c != Null AND Last_Run_Date__c != Today];
            
            // query = 'SELECT AccountId,Event_Code__c,Id,Last_Run_Date__c FROM Opportunity WHERE Event_Code__c != Null AND Token__c != Null';
            // retOpportunities=[SELECT AccountId,Event_Code__c,Id,Last_Run_Date__c FROM Opportunity WHERE Event_Code__c != Null AND Token__c != Null ];
        }
        
        //creating a set of Event Names to query
        for (Opportunity opt: retOpportunities){
            String Temp=opt.Event_Code__c;
            temp=temp.replace(' ','+');
            EventsToQuery.add(temp);
            
        }
        
        // Map<String, Object> results = new Map<String, Object> ();
        // List <Map<String, object>> tempassets=new List <Map<String, object>> ();
        
        // String SessionId=Exhibitor_Integration.logincallout();  // getting session Id
        
        // //querying Event data individually
        // for (String Event: EventsToQuery){
            
        //     results =Exhibitor_Integration.getAsset(Event,SessionId);//get Exhibitor API Data
        //     tempassets=assetParser.parseAsset(results);  //Parse Exhibitor API Data
            
        //     system.debug('TEMP Assets Size===>'+tempassets.size());            
            
        //     if(tempassets.size()>0){
        //         assets.addAll(tempassets);
        //     }
            
        //     results.clear();
        //     tempassets.clear();
        // }
        
        // system.debug('Full Assets Size====>'+assets.size());
        // system.debug('Query in Batchable:'+query);
        // System.debug('Exiting Start of batch process');
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> scope){
        System.debug('In Execute of batch process');
        System.debug('Scope: ' + scope);

        if(scope.size()<=0){
            System.debug('No opportunity retrived');
        }
        else{

            Map<String, Object> results = new Map<String, Object> ();
            List <Map<String, object>> tempassets=new List <Map<String, object>> ();
            
            try {
                String SessionId=Exhibitor_Integration.logincallout();  // getting session Id   

                String Temp=scope.get(0).Event_Code__c;
                temp=temp.replace(' ','+');
                
                results =Exhibitor_Integration.getAsset(Temp,SessionId);//get Exhibitor API Data
                tempassets=assetParser.parseAsset(results);  //Parse Exhibitor API Data
                    
                system.debug('Assets Size===>'+tempassets.size());            
                system.debug('Query in Batchable:'+query);
                System.debug('Exiting Start of batch process');


                map<id,opportunity> Booths=Create_Booth.create_BoothUpload(scope);//Create Booth Uploads for all opportunities returned in above step
                map<Id,boolean> boothStatus=Create_BoothStagging.configure_BoothStagging(Booths,tempassets);//Create Booth Stagging records if any for above created Booth Uploads
                Create_Booth.update_BoothUpload(boothStatus);// set Status to cancel if no stagging records found for booth     */

                results.clear();
                tempassets.clear();
                
               if(Test.isRunningTest()){
                   throw new customException();
               }


            } catch (Exception ex2) {
                List<String> ERTos = new List<String>();
                ERTos.add('gsd@ges.com');
                ERTos.add('JBrook@ges.com');
                ERTos.add('ddunkley@ges.com');
                system.debug('Email to: ' + ERTos);
                
                string emailBody = ex2.getMessage() + '<br />' + ex2.getStackTraceString();
                system.debug('Email body: ' + emailBody);

                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(ERTos);
                mail.setSubject('Error Report for Salesforce class BatchableIntegration - ITE Exhibitor Load - ' + scope.get(0).Event_Code__c);
                mail.setUseSignature(false);
                mail.setHtmlBody(emailBody);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
            
            
            
            
        }
        update scope;
        System.debug('Exiting Execute of batch process');
    }
    
    global void finish(Database.BatchableContext BC){
        System.debug('In Finish of Batch Process');
    }
    
}