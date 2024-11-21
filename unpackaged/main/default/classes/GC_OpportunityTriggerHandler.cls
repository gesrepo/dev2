/**
* @author Ethos Solutions - www.ethos.com
* @description Trigger logic for Opportunity
* 2016-04-13 : Original Version
**/
public without sharing class GC_OpportunityTriggerHandler {

    private static Boolean run = true;
    public static Boolean runOnce() {
        if (run) {
            run = false;
            return true;
        }
        else {
            return run;
        }
    }

    public static Set<String> recordTypes = new Set<String> {
        'Field Security-CR',
        'Field Security-CV',
        'Field Security-DB',
        'Field Security-IA',
        'Field Security-LO',
        'Field Security-LPE',
        'Field Security-LPM',
        'Field Security-LR',
        'Field Security-NE',
        'Field Security-PS',
        'Field Security-TS',
        'Master Show Occurrence',
        'Sales Rep Show Occurrence'
    };

    // TODO we could look into putting this into a custom settings but for right now this is just easier.
    public static Map<String, String> shadowFieldMap = new Map<String, String> {
        'Id' => 'Opportunity_Id__c'
        //, 'Id' => 'Opportunity__c'    //---------------------added by-npatil-- for Sal-891- 11-April-2019
        , 'Name' => 'Opportunity_Name__c'
        //Amarab 06/24/2021 SAL-1255 Remove dates updating/sending to the Project Central show records in the Exhibition Operational Details
        /*, 'Exhibit_Hall_Hours_Day_1__c' => 'Exhibit_Hall_Hours_Day_1__c'
        , 'Exhibit_Hall_Hours_Day_2__c' => 'Exhibit_Hall_Hours_Day_2__c'
        , 'Exhibit_Hall_Hours_Day_3__c' => 'Exhibit_Hall_Hours_Day_3__c'
        , 'Exhibit_Hall_Hours_Day_4__c' => 'Exhibit_Hall_Hours_Day_4__c'
        , 'Exhibit_Hall_Hours_Day_5__c' => 'Exhibit_Hall_Hours_Day_5__c'
        , 'Exhibitor_Move_In_Date__c'   => 'Exhibitor_Move_In_Date2__c'
        , 'Move_Out__c'                 => 'Exhibitor_Move_Out_Date2__c'*/
        , 'Job_Number__c'               => 'Job_Number__c'
        , 'Show_Open_Date__c'           => 'Show_Start_Date__c'
        , 'Show_Close_Date__c'          => 'Show_End_Date__c'
        , 'LMS_Facility_ID__c'          => 'Facility_ID__c'
        , 'Facility__c'                 => 'Facility_lk__c'
        //Amarab 06/24/2021 SAL-1255 Remove dates updating/sending to the Project Central show records in the Exhibition Operational Details
        /*, 'GES_Move_In__c'              => 'GES_Move_In_Date_1__c'
        , 'GES_Move_In_Date_2__c'       => 'GES_Move_In_Date_2__c'
        , 'GES_Move_In_Date_1_Hours__c' => 'GES_Move_In_Date_1_Hours__c'
        , 'GES_Move_In_Date_2_Hours__c' => 'GES_Move_In_Date_2_Hours__c'
        , 'GES_Move_Out_Date_1__c'      => 'GES_Move_Out_Date_1__c'
        , 'GES_Move_Out_Date_2__c'      => 'GES_Move_Out_Date_2__c'
        , 'GES_Move_Out_Date_1_Hours__c' => 'GES_Move_Out_Date_1_Hours__c'
        , 'GES_Move_Out_Date_2_Hours__c' => 'GES_Move_Out_Date_2_Hours__c' */
        , 'Production_Location__c'      => 'Production_Location__c'
        , 'YRMO__c'                     => 'YRMO__c'
        , 'Amount'                      => 'Revenue__c'
        , 'StageName'                   => 'StageName__c'
    };

    public static void HandleOpps(List<Opportunity> opps) {
        Set<String> oppIds = new Set<String>();
        for (Opportunity opp : opps) {
            /*
            if ((recordTypes.contains(opp.RecordType_Name__c) && opp.Job_Number__c!=null)|| (System.Label.GC_Label_OppTypes.contains(opp.RecordType_Name__c)&& opp.SOP_Event_ID__c!=null)) {
                oppIds.add((String)opp.Id);
            }
          */
          /**For SAL 884**/
            //if (recordTypes.contains(opp.RecordType_Name__c)|| (System.Label.GC_Label_OppTypes.contains(opp.RecordType_Name__c)&& opp.SOP_Event_ID__c!=null)) {  //Amarab 06/24/2021 SAL-1255 Allow E&D record types to create Project Central show records
            if (recordTypes.contains(opp.RecordType_Name__c) || (System.Label.GC_Label_OppTypes.contains(opp.RecordType_Name__c) && opp.SOP_Event_ID__c!=null) || (System.Label.GC_Label_EDOppTypes.contains(opp.RecordType_Name__c) && opp.StageName == 'Closed Won')) {
                oppIds.add((String)opp.Id);
            }
        }
        
        //System.debug('oppIds==='+oppIds);
        //System.debug('oppIds size==='+oppIds.size());
        
        List<Opportunity> oppsToUpdate = GC_OpportunityDao.getInstance().getByOppIds(oppIds);
        DescribeSObjectResult objectDef = Schema.getGlobalDescribe().get('GC_Connect2_Show__c').getDescribe();
        Set<String> objectFields = objectDef.fields.getMap().keySet();
        Map<String, GC_Connect2_Show__c> existingShowMap = new Map<String, GC_Connect2_Show__c>();
        if (oppIds.Size() > 0) {
            String fieldDefsCommaSeparated = String.join(new List<String>(objectFields), ',').toLowerCase();
            String oppIdsCommaSeparated = String.join(new List<String>(oppIds), '\',\'').toLowerCase();
            String queryString = 'SELECT ' + fieldDefsCommaSeparated + ' FROM GC_Connect2_Show__c';
            queryString += ' WHERE (Opportunity_Id__c IN (\'' + oppIdsCommaSeparated + '\')';
            queryString += ' OR Opportunity__c IN (\'' + oppIdsCommaSeparated + '\'))';
            List<GC_Connect2_Show__c> existingShows = (List<GC_Connect2_Show__c>)(Database.Query(queryString));
            for (GC_Connect2_Show__c connectShow : existingShows) {
                if(connectShow.Opportunity__c!=null){
                    existingShowMap.put(connectShow.Opportunity__c, connectShow); //Added if else loop by rksinha on 22nd July, 2019 For Multiple Shows on Single Opportunity bug fix. Actual code was only the else part
                }else{
                    existingShowMap.put(connectShow.Opportunity_Id__c, connectShow);
                }
                
            }
        }
        List<GC_Connect2_Show__c> showsToAdd = new List<GC_Connect2_Show__c>();
        List<GC_Connect2_Show__c> showsToUpdate = new List<GC_Connect2_Show__c>();
        for (Opportunity opp : oppsToUpdate) {
            if (existingShowMap.containsKey(opp.Id)) {
                GC_Connect2_Show__c show = existingShowMap.get(opp.Id);
                try {
                    UpdateOpp(show, opp);
                }
                catch (Exception e) {
                    System.debug(e.getMessage());
                }
                showsToUpdate.add(show);
            }
            else {
                GC_Connect2_Show__c show = new GC_Connect2_Show__c();
                try {
                    UpdateOpp(show, opp);
                }
                catch (Exception e) {
                    System.debug(e.getMessage());
                }
                showsToAdd.add(show);
            }
        }
        Database.SaveResult[] saveR =Database.insert(showsToAdd, false);
        for (Database.SaveResult sr : saveR) {
    if (sr.isSuccess()) {
        // Operation was successful, so get the ID of the record that was processed
        System.debug('Successfully inserted account. Show ID: ' + sr.getId());
    }
    else {
        // Operation failed, so get all errors                
        for(Database.Error err : sr.getErrors()) {
            System.debug('The following error has occurred.');                    
            System.debug(err.getStatusCode() + ': ' + err.getMessage());
            System.debug('Show fields that affected this error: ' + err.getFields());
        }
    }
}
        Database.update(showsToUpdate, false);
        /*
        for(GC_Connect2_Show__c show :showsToAdd){
            System.debug('show id==='+show.id);
        }
        System.debug('showsToAdd size==='+showsToAdd.size());
        */
    }

    public static void UpdateOpp(GC_Connect2_Show__c show, Opportunity opp) {
        SObject sShow = (SObject)show;
        SObject sOpp = (SObject)opp;
        String keyEMEA='Id';
        for (String key : shadowFieldMap.keySet()) {
            try {
                if(key=='Job_Number__c' && System.Label.GC_Label_OppTypes.contains(opp.RecordType_Name__c)){
                    keyEMEA='SOP_Event_ID__c';
                    sShow.put(shadowFieldMap.get(key), string.valueOf(sOpp.get(keyEMEA)).leftPad(9,'0'));
                }else{
                    sShow.put(shadowFieldMap.get(key), sOpp.get(key));
                }
                
                continue;
            }
            catch (System.SObjectException e) {             
            }
            catch (Exception e) {
                System.debug(key + ' ' + e.getMessage());
                continue;
            }
            
            try {
                sShow.put(shadowFieldMap.get(key), String.valueOf(sOpp.get(key)));
            }
            catch (Exception e) {
                System.debug(key + ' ' + e.getMessage());
                continue;
            }   
        }
        sshow.put('Opportunity_Owner_Email__c', Opp.Owner.Email);  //Amarab 04/16/2021 SFDC-169 New Email Notification - Client Serv Manager
        try {
            sShow.put('Opportunity__c', sOpp.get('Id'));    //Added by rksinha on 22nd July, 2019 For Multiple Shows on Single Opportunity bug fix
            // Do the special Case's here for relationship fields.
            if (sOpp.getSObject('Facility__r') != null) {
                String facilityName =  (String)sOpp.getSObject('Facility__r').get('Name');
                String facilityId =  (String)sOpp.getSObject('Facility__r').get('Id');      //---------------------added by-npatil-- for Sal-891- 11-April-2019
                String facilityAddressStreet =  (String)sOpp.getSObject('Facility__r').get('BillingStreet');
                String facilityAddressCity =  (String)sOpp.getSObject('Facility__r').get('BillingCity');
                String facilityAddressPostalCode =  (String)sOpp.getSObject('Facility__r').get('BillingPostalCode');
                String facilityAddressState =  (String)sOpp.getSObject('Facility__r').get('BillingState');
                String facilityAddressCountry =  (String)sOpp.getSObject('Facility__r').get('BillingCountry');
                String facilityAddress = facilityAddressStreet;
                facilityAddress += '\r\n';
                facilityAddress += String.isNotBlank(facilityAddressCity) ? ' ' + facilityAddressCity + ',' : '';
                facilityAddress += String.isNotBlank(facilityAddressState) ? ' ' + facilityAddressState : '';
                facilityAddress += String.isNotBlank(facilityAddressPostalCode) ? ' ' + facilityAddressPostalCode : '';
                facilityAddress += String.isNotBlank(facilityAddressCountry) ? '\r\n' + facilityAddressCountry : '';
                sShow.put('Facility__c', facilityName);
                sShow.put('Facility_lk__c', facilityId);            //---------------------added by-npatil-- for Sal-891- 11-April-2019
                sShow.put('Facility_Address__c', facilityAddress);
            }
        }
        catch (Exception e) {
            System.debug(e.getMessage());
        }
        try {
            if (sOpp.getSObject('Show_Name__r') != null) {
                String showName =  (String)sOpp.getSObject('Show_Name__r').get('Name');
                sShow.put('Show_Name__c', showName);
                String shodId =  (String)sOpp.getSObject('Show_Name__r').get('Show_ID__c');
                sShow.put('Show_ID__c', shodId);
                String showType =  (String)sOpp.getSObject('Show_Name__r').get('Show_Type__c');
                sShow.put('Show_Type__c', showType);
            }
        }
        catch (Exception e) {
            System.debug(e.getMessage());
        }             
        try {
            if (sOpp.get('GC_Account_Manager__c') != null) {
                sShow.put('OwnerId', sOpp.get('GC_Account_Manager__c'));
            }
        }
        catch (Exception e) {
            System.debug(e.getMessage());
        }    
        try{
            if(sOpp.getSObject('Opportunity__r') != null) {
                String ShowOpenDate =  (String)sOpp.getSObject('Opportunity__r').get('Show_Open_Date__c');
                sShow.put('Show_Start_Date__c', ShowOpenDate);
                String ShowCloseDate =  (String)sOpp.getSObject('Opportunity__r').get('Show_Close_Date__c');
                sShow.put('Show_End_Date__c', ShowCloseDate);
            }
        }catch(Exception e){
            System.debug(e.getMessage());
        }
                        
        //Amarab 06/24/2021 SAL-1255 Allow E&D record types to create Project Central show records
        if (opp.RecordType_Name__c == 'E&D - Projects - Read Only' || opp.RecordType_Name__c == 'E&D - Projects - Proposal' || opp.RecordType_Name__c == 'E&D - Projects')
        {
            if(sOpp.getSObject('Show_Occurrence__r') != null) 
            {
                show.Show_Name__c = Opp.Show_Occurrence__r.Show_Name__r.Name;
                show.Show_ID__c = Opp.Show_Occurrence__r.Show_Name__r.Show_ID__c;
                show.Show_Type__c = Opp.Show_Occurrence__r.Show_Name__r.Show_Type__c;
                show.Show_Start_Date__c = Opp.Show_Occurrence__r.Show_Open_Date__c;
                show.Show_End_Date__c = Opp.Show_Occurrence__r.Show_Close_Date__c;
                show.Production_Location__c = Opp.EE_Production_Location__c; 
                show.Facility_ID__c = Opp.Show_Occurrence__r.LMS_Facility_ID__c;
                show.Facility__c = Opp.Show_Occurrence__r.Facility__r.Name;
                show.Facility_lk__c = Opp.Show_Occurrence__r.Facility__r.Id; 

                String EDfacilityAddress = Opp.Show_Occurrence__r.Facility__r.BillingStreet;
                EDfacilityAddress += '\r\n';
                EDfacilityAddress += String.isNotBlank(Opp.Show_Occurrence__r.Facility__r.BillingCity) ? ' ' + Opp.Show_Occurrence__r.Facility__r.BillingCity + ',' : '';
                EDfacilityAddress += String.isNotBlank(Opp.Show_Occurrence__r.Facility__r.BillingState) ? ' ' + Opp.Show_Occurrence__r.Facility__r.BillingState : '';
                EDfacilityAddress += String.isNotBlank(Opp.Show_Occurrence__r.Facility__r.BillingPostalCode) ? ' ' + Opp.Show_Occurrence__r.Facility__r.BillingPostalCode : '';
                EDfacilityAddress += String.isNotBlank(Opp.Show_Occurrence__r.Facility__r.BillingCountry) ? '\r\n' + Opp.Show_Occurrence__r.Facility__r.BillingCountry : '';
                show.Facility_Address__c = EDfacilityAddress;                       
            } 
            else 
            {
                show.Show_Name__c = Opp.Non_Show__r.Name; 
                show.Show_ID__c = Opp.Non_Show__r.Show_ID__c;
                show.Show_Start_Date__c = Opp.Non_Show__r.Show_Open__c;
                show.Show_End_Date__c = Opp.Non_Show__r.Show_Close__c;
                show.Facility_ID__c = Opp.Non_Show__r.LMS_Facility_ID__c;
                show.Facility__c = Opp.Non_Show__r.Facility__c != null ? Opp.Non_Show__r.Facility__r.Name : Opp.Non_Show__r.Ship_To_Company__c;
                Show.Facility_lk__c = Opp.Non_Show__r.Facility__r.Id;   
                
                String EDNonshowfacilityAddressStreet = Opp.Non_Show__r.Facility__c != null ? Opp.Non_Show__r.Facility__r.BillingStreet : Opp.Non_Show__r.Shipping_Street__c;
                String EDNonshowfacilityAddressCity = Opp.Non_Show__r.Facility__c != null ? Opp.Non_Show__r.Facility__r.BillingCity : Opp.Non_Show__r.Shipping_City__c;
                String EDNonshowfacilityAddressPostalCode = Opp.Non_Show__r.Facility__c != null ? Opp.Non_Show__r.Facility__r.BillingPostalCode  : Opp.Non_Show__r.Shipping_Zip_Postal_Code__c ;
                String EDNonshowfacilityAddressState =  Opp.Non_Show__r.Facility__c != null ? Opp.Non_Show__r.Facility__r.BillingState : Opp.Non_Show__r.Shipping_State_Province__c ;
                String EDNonshowfacilityAddressCountry =  Opp.Non_Show__r.Facility__c != null ? Opp.Non_Show__r.Facility__r.BillingCountry : Opp.Non_Show__r.Shipping_Country__c;
                
                String EDNonshowfacilityAddress = EDNonshowfacilityAddressStreet;
                EDNonshowfacilityAddress += '\r\n';
                EDNonshowfacilityAddress += String.isNotBlank(EDNonshowfacilityAddressCity) ? ' ' + EDNonshowfacilityAddressCity + ',' : '';
                EDNonshowfacilityAddress += String.isNotBlank(EDNonshowfacilityAddressState) ? ' ' + EDNonshowfacilityAddressState : '';
                EDNonshowfacilityAddress += String.isNotBlank(EDNonshowfacilityAddressPostalCode) ? ' ' + EDNonshowfacilityAddressPostalCode : '';
                EDNonshowfacilityAddress += String.isNotBlank(EDNonshowfacilityAddressCountry) ? '\r\n' + EDNonshowfacilityAddressCountry : '';
                
                show.Facility_Address__c = EDNonshowfacilityAddress;
                show.Production_Location__c = Opp.EE_Production_Location__c;       
            }       
        }        
    }    
}