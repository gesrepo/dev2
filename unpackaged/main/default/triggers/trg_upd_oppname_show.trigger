trigger trg_upd_oppname_show on Show__c (after update) 
{
    if (System.isFuture() || System.isBatch()) {
        return;
    }
    
    Map<Id, String> showNamesMap = new Map<Id, String>();
    for(Show__c oppshow : Trigger.New)
    {
        //If show id changed,then update the Related show Opportunity
        if(trigger.oldMap.get(oppshow.Id).Show_ID__c != oppshow.Show_ID__c)
        {
            if (!TriggerOptimizationUtility.trg_upd_oppname_show_Handled.contains(oppshow.Id)) {
                showNamesMap.put(oppshow.Id, oppshow.Show_ID__c);
                TriggerOptimizationUtility.trg_upd_oppname_show_Handled.add(oppshow.Id);
            }
        }
    }
    UpdateShowOpp.updateOppsFromShow_Mass(showNamesMap);
}