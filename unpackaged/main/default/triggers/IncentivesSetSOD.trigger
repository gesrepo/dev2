trigger IncentivesSetSOD on Incentives__c (before insert, before update) 
{
	
	Set<Id> soSet = new Set<Id>();
	for (Incentives__c t : trigger.new)
    {
        if (t.Show_Occurrence__c != null)
        {
        	soSet.add(t.Show_Occurrence__c);
        }
    }
    
    Map<Id,Id> sodMap = new Map<Id,Id>();
    for (Show_Occurrence_Public__c sod : [select Show_Occurrence_Ref__c from Show_Occurrence_Public__c where Show_Occurrence_Ref__c in :soSet])
    {
    	if(sodMap.get(sod.Show_Occurrence_Ref__c) == null)
    	{
    		sodMap.put(sod.Show_Occurrence_Ref__c, sod.Id);
    	}
    }            
    
    for (Incentives__c t1 : trigger.new)
    {
        if (t1.Show_Occurrence__c != null && sodMap.get(t1.Show_Occurrence__c) != null)    	
        {            
            t1.Show_Occurrence_Details__c = sodMap.get(t1.Show_Occurrence__c);
        }
    }
    
	/*
    Incentives__c[] ts = trigger.new;
    
    for (Incentives__c t : ts)
    {
        if (t.Show_Occurrence__c != null)
        {
            Show_Occurrence_Public__c sod = [select Show_Occurrence_Ref__c from Show_Occurrence_Public__c where Show_Occurrence_Ref__c = :t.Show_Occurrence__c];
            t.Show_Occurrence_Details__c = sod.Id;
        }
    }
    */
}