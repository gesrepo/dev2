public with sharing class ICS_UpdateApproverFromMatrixHandler {
    public static Set<Id>updatedMatrixIDs;
        
    public static void handleApprovers(List<ICS_Approver_Matrix__c> updatedMatrices){
        updatedMatrixIDs= new Set<Id>();
    List<ICS_Approver_Matrix__c> allApproverMatrix =updatedMatrices;
    system.debug('updatedMatrices==='+updatedMatrices);
    system.debug('allApproverMatrix ==='+allApproverMatrix );
        //if(updatedMatrices!=null){
        try{
            for(ICS_Approver_Matrix__c varMatrix : allApproverMatrix ){
                updatedMatrixIDs.add(varMatrix.Id);
            }
        //}
        }catch(exception e){
            system.debug('error==='+e.getMessage());
            system.debug('error==='+e.getStackTraceString());
        }
        try{
            List<Credit_Memo_ICS__c> allCreditMemo= new List<Credit_Memo_ICS__c>();
            List<Credit_Memo_ICS__c> updatedcreditMemo= new List<Credit_Memo_ICS__c>();
            List<AR_Adjustments__c> allARAdjustments= new List<AR_Adjustments__c>();
            List<AR_Adjustments__c> updatedARAdjustments= new List<AR_Adjustments__c>();
            List<Refunds_ICS__c> allRefunds= new List<Refunds_ICS__c>();
            List<Refunds_ICS__c> updatedRefunds= new List<Refunds_ICS__c>();
            
            List<Customer_Service_Inquiries_ICS__c>casesToBeUpdated= [SELECT Id,Case_Approval_Status__c,(SELECT Id,Case_location__c,Case_Sales_Channel__c,Amount__c FROM AR_Adjustments_Approvals__r),(SELECT Id,Reason_Code_Category__c,Credit_Memo_Reason__c, Case_Sales_Channel__c, Case_Location__c, Total_Amount__c, Credit_LOB__c FROM ICS_Credit_Memo__r),(SELECT Id,Amount__c  FROM Refunds_ICS__r) FROM Customer_Service_Inquiries_ICS__c WHERE Case_Approval_Status__c ='Case Open'];
            for(Customer_Service_Inquiries_ICS__c tempCase:casesToBeUpdated){
                allCreditMemo.addAll(tempCase.ICS_Credit_Memo__r);
                allARAdjustments.addAll(tempCase.AR_Adjustments_Approvals__r);
                allRefunds.addAll(tempCase.Refunds_ICS__r);
            }
            if(allCreditMemo!=null){
                ICS_CreditMemo_Handler.updateReasonCategoryCode(allCreditMemo);
                updatedcreditMemo=ICS_CreditMemo_Handler.CMapproverdetails(allCreditMemo);
                update updatedcreditMemo;   
            }
            if(allARAdjustments!=null){
                updatedARAdjustments=ICS_AR_Adjustments_Approver_Update.AR_Adjustments_Approverdetails(allARAdjustments);
                update updatedARAdjustments;
            }
            if(allRefunds!=null){
                updatedRefunds=ICS_Refunds_Approver_Update.Refunds_Approverdetails(allRefunds);
                update updatedRefunds;  
            }
            
        }
        catch(exception e){
            system.debug('error==='+e.getMessage());
            system.debug('error==='+e.getStackTraceString());
        }
    }
}