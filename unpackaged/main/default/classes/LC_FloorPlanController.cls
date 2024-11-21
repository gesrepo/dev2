public with sharing class LC_FloorPlanController {
    
    @AuraEnabled
    public static string getPCId(string drfId){
        List <Floor_Plan_Request__c> fprs = new List <Floor_Plan_Request__c>();
        fprs = [SELECT Id, Connect2_Show__c FROM Floor_Plan_Request__c WHERE Id=:drfId];
        if(fprs.size() > 0 && fprs[0].Connect2_Show__c != null)
            return fprs[0].Connect2_Show__c;
        else 
            return '';
    }
}