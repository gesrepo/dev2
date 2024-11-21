trigger ICS_AR_updatecompleted on AR_Adjustments__c (after update){
     
     Set<Id> icsID = new Set<Id>();
    for(AR_Adjustments__c  var:Trigger.new)
          { 
          if(var.Completed_Transaction__c==true && var.Completed_Transaction__c!= Trigger.OldMap.get(var.Id).Completed_Transaction__c )
                icsID .add(var.AR_Adj_CSI_ID__c);
          }
    ICS_Competedcheck.CheckAllChildBoxes(icsID );
}