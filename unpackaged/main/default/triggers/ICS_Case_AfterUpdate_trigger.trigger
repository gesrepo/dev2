trigger ICS_Case_AfterUpdate_trigger on Customer_Service_Inquiries_ICS__c (after update) {
    Set<Id> setCaseIds = new Set<Id>();
    List<Customer_Service_Inquiries_ICS__c> listCases = new List<Customer_Service_Inquiries_ICS__c>();
    for(Customer_Service_Inquiries_ICS__c icsCase : trigger.new) {
        if(icsCase.Case_Approval_Status__c != trigger.oldMap.get(icsCase.Id).Case_Approval_Status__c 
            && (icsCase.Case_Approval_Status__c == 'LOB Submitted' || icsCase.Case_Approval_Status__c == 'F&R Submitted' 
            || icsCase.Case_Approval_Status__c == 'AR1 Submitted' || icsCase.Case_Approval_Status__c == 'CSO Submitted'
            || icsCase.Case_Approval_Status__c == 'AR2 Submitted' || icsCase.Case_Approval_Status__c == 'Additional Submitted')) {
            setCaseIds.add(icsCase.Id);
            listCases.add(icsCase);
        }
    }
    if(setCaseIds.size() > 0) {
        ICS_CaseTriggerHandler.CaseStatus_AfterUpdate(setCaseIds, listCases);
    }
    ICS_UpdatetransactionOnCase.handleApprovers(trigger.new);
}