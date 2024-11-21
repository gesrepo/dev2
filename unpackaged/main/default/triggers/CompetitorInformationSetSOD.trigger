trigger CompetitorInformationSetSOD on Competitor_Information__c (before insert, before update)
{
	Set<Id> soSet = new Set<Id>();
	for (Competitor_Information__c ci : trigger.new)
    {
        if (ci.Show_Occurrence__c != null)
        {
        	soSet.add(ci.Show_Occurrence__c);
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
    
    for (Competitor_Information__c ci1 : trigger.new)
    {
        if (ci1.Show_Occurrence__c != null && sodMap.get(ci1.Show_Occurrence__c) != null)    	
        {            
            ci1.Show_Occurrence_Details__c = sodMap.get(ci1.Show_Occurrence__c);
        }
    }
    
    /*
    Competitor_Information__c[] ts = trigger.new;
    
    for (Competitor_Information__c t : ts)
    {
        if (t.Show_Occurrence__c != null)
        {
            Show_Occurrence_Public__c sod = [select Show_Occurrence_Ref__c from Show_Occurrence_Public__c where Show_Occurrence_Ref__c = :t.Show_Occurrence__c];
            t.Show_Occurrence_Details__c = sod.Id;
        }
    }
    */
}