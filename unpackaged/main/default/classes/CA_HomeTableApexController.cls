public without sharing class CA_HomeTableApexController {   
    
    @AuraEnabled(cacheable=true)
    public static CA_Personalized_Object_Setting__c getSettingObjectList(){
        User currentUser = [select id,Name,profile.name,IsPortalEnabled FROM User Where id =: userInfo.getUserId()];
        String profileName=currentUser.profile.name;
        If (Test.isRunningTest()){profileName='GC BMS Profile';}
        CA_Personalized_Object_Setting__c sDebug = CA_ApexUtils.getHomeTableSettings(profileName, 'CA_Main_Event__c', true);
        system.debug('-------' + sDebug);
        return sDebug;
    }
        
    @AuraEnabled(cacheable=true)
    public static List<CA_Main_Event__c> getEventList(string columnNames, string recordTypeId){
        system.debug('recordTypeId=='+recordTypeId);
        //make a call to know the user profile
        //make a call to get the personalised object setting for that object
        //get the columns and filters and make the SOQL work using that only  on record type ID
        List<CA_Main_Event__c> eventList = new List<CA_Main_Event__c>();
        string queryString ='';
        if(!string.isBlank(columnNames)){
             queryString ='SELECT Id,Name,' + columnNames;    
        }
        else{
            queryString ='SELECT Id,Name ';    
        }
        queryString +=  ' FROM CA_Main_Event__c WHERE RecordTypeId = \'' + recordTypeId + '\'' + ' AND Event_Start_Date__c>=TODAY' +' ORDER BY Event_Start_Date__c';
        
        
        eventList = database.query(queryString);
        string queryString2=queryString.replace('>=', '<')+' DESC';
        system.debug('queryString2----' + queryString2);
        List<CA_Main_Event__c> eventList2 = new List<CA_Main_Event__c>();
        eventList2 = database.query(queryString2);
        
        string queryString3=queryString2.replace('<TODAY', '=NULL');
        system.debug('queryString3----' + queryString3);
        List<CA_Main_Event__c> eventList3 = new List<CA_Main_Event__c>();
        eventList3 = database.query(queryString3);
        
        eventList.addAll(eventList2);
        eventList.addAll(eventList3);
        return eventList;
    }
    
    @AuraEnabled
    public static void deleteActionApex(string recId){
        CA_RecordBannerApexController.deleteRecord(recId);
    }
}