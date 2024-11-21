trigger FinancialsSetSOD on Financials__c (before insert, before update) 
{
	Set<Id> soSet = new Set<Id>();
	for (Financials__c f : trigger.new)
    {
        if (f.Show_Occurrence__c != null)
        {
        	soSet.add(f.Show_Occurrence__c);        	
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
    
    for (Financials__c f1 : trigger.new)
    {
        if (f1.Show_Occurrence__c != null && sodMap.get(f1.Show_Occurrence__c) != null)    	
        {                    	
            f1.Show_Occurrence_Details__c = sodMap.get(f1.Show_Occurrence__c);
        }
    }	
	/*
    Financials__c[] fins = trigger.new;
    
    for (Financials__c f : fins)
    {
        if (f.Show_Occurrence__c != null)
        {
            Show_Occurrence_Public__c sod = [select Show_Occurrence_Ref__c from Show_Occurrence_Public__c where Show_Occurrence_Ref__c = :f.Show_Occurrence__c];
            f.Show_Occurrence_Details__c = sod.Id;
        }
    }
 	*/   
}