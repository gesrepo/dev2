trigger ICS_Refunds_ApproverUpdate on Refunds_ICS__c (before insert, before Update) {
    
    if( (trigger.isinsert||trigger.isupdate) && trigger.isbefore)
      
 {    
     ICS_Refunds_Approver_Update.Refunds_Approverdetails(trigger.new);
  }    
}