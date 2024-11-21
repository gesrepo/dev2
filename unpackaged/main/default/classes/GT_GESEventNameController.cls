public class GT_GESEventNameController {
    
    public Static string EventName ;
    public Static String objectName ;
    
    @AuraEnabled
    public Static String getProfileName(){
        id userId = userinfo.getProfileId();
        LIST<profile> ProfileName = new LIST<profile>();
		ProfileName = [select Name from profile where id = :userId LIMIT 1];
        system.debug(ProfileName[0].Name);
        Return ProfileName[0].Name;
    }
    
    @AuraEnabled
    public Static sobject getGESEventName(string recordId){
        List<GT_Event__c> eventObject = new List<GT_Event__c>();
        List<sobject> returnObject = new List<sobject>();
        string returnEventNameObject;
        objectName = Id.valueOf(recordId).getSObjectType().getDescribe().getName();
        system.debug(objectName);
        system.debug(recordId);
        if(objectName == 'GT_Event__c'){
            eventObject = [SELECT Id, Name, Name_of_Event__c,Name_of_Congress__c FROM GT_Event__c WHERE Id =: Id.valueOf(recordId)];
            return eventObject[0];
        }
        else{
            String queryString = 'SELECT Id,Name, GES_Connect_Event__r.Name_of_Event__c,GES_Connect_Event__r.Name_of_Congress__c FROM ' + objectName + ' WHERE Id = ' + '\'' + recordId + '\'' ;
        	system.debug(queryString);
            returnObject = Database.query(queryString);
            system.debug(returnObject);
            return returnObject[0];
        }
        
        
    }
}