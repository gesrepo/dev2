trigger ICS_CreditMemo_updatecompleted on Credit_Memo_ICS__c (after update){
     
     Set<Id> icsID = new Set<Id>();
    for(Credit_Memo_ICS__c  var:Trigger.new)
          { 
          if(var.Completed_Transaction__c==true && var.Completed_Transaction__c!= Trigger.OldMap.get(var.Id).Completed_Transaction__c )
                icsID .add(var.CSI_ICS__c);
          }
    ICS_Competedcheck.CheckAllChildBoxes(icsID );
}