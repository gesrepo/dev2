trigger ICS_CreditMemo_Trigger_beforeInsert on Credit_Memo_ICS__c (before insert) {

     ICS_CreditMemo_Handler.updateReasonCategoryCode(trigger.new);
     system.debug('trigger.new==='+trigger.new);
     ICS_CreditMemo_Handler.CMapproverdetails(trigger.new);
}