public class CA_ExhibitApexController {
    
    @AuraEnabled
    public static CA_Personalized_Object_Setting__c getSettingObjectList(string objectName){
        User currentUser = [select id,Name,profile.name,IsPortalEnabled FROM User Where id =: userInfo.getUserId()];
        String profileName=currentUser.profile.name;
        CA_Personalized_Object_Setting__c sDebug = CA_ApexUtils.getHomeTableSettings(profileName, objectName, true);
        system.debug('-------' + sDebug);
        return sDebug;
    }
    
    @AuraEnabled
    public static string getParntObjName(string recordId){
        return CA_RecordBannerApexController.getParntObjName(recordId);
    }
    
    @AuraEnabled
    public static Pharma_Template__mdt getPickListValues(String productName){
        Pharma_Template__mdt therapeuticAndBusinessUnit;
        User currentUser = [select id,Name,profile.name,IsPortalEnabled FROM User Where id =: userInfo.getUserId()];
        String profileName=currentUser.profile.name;
        If (Test.isRunningTest()){profileName='GC Merck';}
        if (profileName=='GC Merck'){
            therapeuticAndBusinessUnit = [SELECT Business_Unit__c,Therapeutic_Area__c FROM Pharma_Template__mdt WHERE Product_Name__c =: productName AND DeveloperName like 'Merck%' LIMIT 1]; 
        }
        else{
        	therapeuticAndBusinessUnit = [SELECT Business_Unit__c,Therapeutic_Area__c FROM Pharma_Template__mdt WHERE Product_Name__c =: productName AND (NOT DeveloperName like 'Merck%') LIMIT 1]; 
        }
            return therapeuticAndBusinessUnit;
    }
}