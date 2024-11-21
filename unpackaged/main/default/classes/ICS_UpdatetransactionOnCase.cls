public with sharing class ICS_UpdatetransactionOnCase {
    public static Set<Id>updatedCaseIDs;
        
    public static void handleApprovers(List<Customer_Service_Inquiries_ICS__c> updatedCases){
        updatedCaseIDs= new Set<Id>();
        List<Customer_Service_Inquiries_ICS__c> allCaseList =updatedCases;
        try{
            for(Customer_Service_Inquiries_ICS__c varCase : allCaseList ){
                updatedCaseIDs.add(varCase.Id);
            }
        }catch(exception e){
            system.debug('error==='+e.getMessage());
            system.debug('error==='+e.getStackTraceString());
        }
        List<Credit_Memo_ICS__c> allCreditMemo= new List<Credit_Memo_ICS__c>();
        try{
            
            List<Credit_Memo_ICS__c> updatedcreditMemo= new List<Credit_Memo_ICS__c>();
            List<AR_Adjustments__c> allARAdjustments= new List<AR_Adjustments__c>();
            List<AR_Adjustments__c> updatedARAdjustments= new List<AR_Adjustments__c>();
            List<Refunds_ICS__c> allRefunds= new List<Refunds_ICS__c>();
            List<Refunds_ICS__c> updatedRefunds= new List<Refunds_ICS__c>();
            
            List<Customer_Service_Inquiries_ICS__c>casesToBeUpdated= [SELECT Id,Case_Approval_Status__c,Account_Name__c, Opportunity_Name__c, Sales_Channel__c,(SELECT Id,Case_location__c,Case_Sales_Channel__c,Amount__c FROM AR_Adjustments_Approvals__r),(SELECT Id,Reason_Code_Category__c,Credit_Memo_Reason__c, Case_Sales_Channel__c, Case_Location__c, Total_Amount__c, Credit_LOB__c FROM ICS_Credit_Memo__r),(SELECT Id,Amount__c  FROM Refunds_ICS__r) FROM Customer_Service_Inquiries_ICS__c WHERE Case_Approval_Status__c ='Case Open' AND Id IN :updatedCaseIDs];
            for(Customer_Service_Inquiries_ICS__c tempCase:casesToBeUpdated){
                allCreditMemo.addAll(tempCase.ICS_Credit_Memo__r);
                allARAdjustments.addAll(tempCase.AR_Adjustments_Approvals__r);
                allRefunds.addAll(tempCase.Refunds_ICS__r);

            }
            if(allCreditMemo.size()>0){
                ICS_CreditMemo_Handler.updateReasonCategoryCode(allCreditMemo);
                updatedcreditMemo=ICS_CreditMemo_Handler.CMapproverdetails(allCreditMemo);
                update updatedcreditMemo;   
            }   
            if(allARAdjustments.size()>0){
                updatedARAdjustments=ICS_AR_Adjustments_Approver_Update.AR_Adjustments_Approverdetails(allARAdjustments);
                update updatedARAdjustments;
            }
            if(allRefunds.size()>0){
                updatedRefunds=ICS_Refunds_Approver_Update.Refunds_Approverdetails(allRefunds);
                update updatedRefunds;  
            }
            
        }catch(exception e){
            system.debug('allCreditMemo ==='+allCreditMemo );
            system.debug('allCreditMemo size ==='+allCreditMemo.size() );
            system.debug('error==='+e.getMessage());
            system.debug('error==='+e.getStackTraceString());
        }
    }
}