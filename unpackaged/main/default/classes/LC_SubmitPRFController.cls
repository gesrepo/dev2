public class LC_SubmitPRFController {
    
    @AuraEnabled
    public static String updateOpportunity(id recordId){
        System.debug('recordId:: '+recordId);
        
        Opportunity opp = [select id, PRF_Submitted__c from Opportunity where id =: recordId];
        opp.PRF_Submitted__c = true;
        Database.SaveResult sr = Database.update(opp, false);

        if(sr.isSuccess()){
            List<OpportunityLineItem> oliList = [Select Id From OpportunityLineItem Where OpportunityId =:recordId];
            update oliList;
            return 'success';  
        }else{  
            List<Database.Error> objErr = sr.getErrors();
            String errorMsg = objErr[0].getMessage();
            System.debug('errorMsg:: '+errorMsg);
            return errorMsg;  
        }  
    }
}