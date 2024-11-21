trigger ICS_CreditMemo_Trigger_beforeUpdate on Credit_Memo_ICS__c (before Update) {
    List<Credit_Memo_ICS__c> listCreditMemoApproverUpdate = new List<Credit_Memo_ICS__c>();
    for(Credit_Memo_ICS__c cm : trigger.new) {
        if(cm.Credit_Memo_Reason__c != trigger.oldMap.get(cm.id).Credit_Memo_Reason__c 
            || cm.Location__c != trigger.oldMap.get(cm.id).Location__c
            || cm.Sales_Channel__c != trigger.oldMap.get(cm.id).Sales_Channel__c
            || cm.Credit_LOB__c != trigger.oldMap.get(cm.id).Credit_LOB__c) {
            listCreditMemoApproverUpdate.add(cm);
        }
    }
    if( listCreditMemoApproverUpdate.size() > 0)
    { 
        ICS_CreditMemo_Handler.updateReasonCategoryCode(listCreditMemoApproverUpdate);
        ICS_CreditMemo_Handler.CMapproverdetails(listCreditMemoApproverUpdate);
    }    
}