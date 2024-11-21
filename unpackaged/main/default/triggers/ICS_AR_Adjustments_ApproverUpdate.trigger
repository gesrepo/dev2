trigger ICS_AR_Adjustments_ApproverUpdate on AR_Adjustments__c (before insert, before Update) {
  if( (trigger.isinsert||trigger.isupdate) && trigger.isbefore)
      
 {    
     ICS_AR_Adjustments_Approver_Update.AR_Adjustments_Approverdetails(trigger.new);
  }
    
}