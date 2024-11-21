trigger AgreementsSetSOD on Agreements__c (before insert, before update) 
{

	Set<Id> soSet = new Set<Id>();
	Set<Id> soSet2 = new Set<Id>();
	Set<Id> soSet3 = new Set<Id>();
	Set<Id> soSet4 = new Set<Id>();
	Set<Id> soSet5 = new Set<Id>();
	Set<Id> soSet6 = new Set<Id>();
	
	for (Agreements__c a : trigger.new)
    {
        if (a.Show_Occurrence__c != null)
        {
        	soSet.add(a.Show_Occurrence__c);
        }
        if (a.Show_Occurrence_2__c != null)
        {
        	soSet.add(a.Show_Occurrence_2__c);
        }
        if (a.Show_Occurrence_3__c != null)
        {
			soSet.add(a.Show_Occurrence_3__c);
        }
        if (a.Show_Occurrence_4__c != null)
        {
        	soSet.add(a.Show_Occurrence_4__c);
        }
        if (a.Show_Occurrence_5__c != null)
        {
            soSet.add(a.Show_Occurrence_5__c);
        }
        if (a.Show_Occurrence_6__c != null)
        {
			soSet.add(a.Show_Occurrence_6__c);
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
    
    for (Agreements__c a1 : trigger.new)
    {
        if (a1.Show_Occurrence__c != null && sodMap.get(a1.Show_Occurrence__c) != null)    	
        {            
            a1.Show_Occurrence_Details__c = sodMap.get(a1.Show_Occurrence__c);
        }
        if (a1.Show_Occurrence_2__c != null && sodMap.get(a1.Show_Occurrence_2__c) != null)
        {                         
			a1.Show_Occurrence_Public_2__c =  sodMap.get(a1.Show_Occurrence_2__c);
        }
        if (a1.Show_Occurrence_3__c != null && sodMap.get(a1.Show_Occurrence_3__c) != null)
        {                         
			a1.Show_Occurrence_Public_3__c =  sodMap.get(a1.Show_Occurrence_3__c);
        }
        if (a1.Show_Occurrence_4__c != null && sodMap.get(a1.Show_Occurrence_4__c) != null)
        {                         
			a1.Show_Occurrence_Public_4__c =  sodMap.get(a1.Show_Occurrence_4__c);
        }
        if (a1.Show_Occurrence_5__c != null && sodMap.get(a1.Show_Occurrence_5__c) != null)
        {                         
			a1.Show_Occurrence_Public_5__c =  sodMap.get(a1.Show_Occurrence_5__c);
        }
        if (a1.Show_Occurrence_6__c != null && sodMap.get(a1.Show_Occurrence_6__c) != null)
        {                         
			a1.Show_Occurrence_Public_6__c =  sodMap.get(a1.Show_Occurrence_6__c);
        }
    }	
	/*
    Agreements__c[] ts = trigger.new; 
    
    for (Agreements__c t : ts)
    {
        if (t.Show_Occurrence__c != null)
        {
             Show_Occurrence_Public__c sod = [select Show_Occurrence_Ref__c from Show_Occurrence_Public__c where Show_Occurrence_Ref__c = :t.Show_Occurrence__c];
             t.Show_Occurrence_Details__c = sod.Id;
        }
        if (t.Show_Occurrence_2__c != null)
        {
             Show_Occurrence_Public__c sod = [select Show_Occurrence_Ref__c from Show_Occurrence_Public__c where Show_Occurrence_Ref__c = :t.Show_Occurrence_2__c];
             t.Show_Occurrence_Public_2__c = sod.Id;
        }
        if (t.Show_Occurrence_3__c != null)
        {
             Show_Occurrence_Public__c sod = [select Show_Occurrence_Ref__c from Show_Occurrence_Public__c where Show_Occurrence_Ref__c = :t.Show_Occurrence_3__c];
             t.Show_Occurrence_Public_3__c = sod.Id;
        }
        if (t.Show_Occurrence_4__c != null)
        {
             Show_Occurrence_Public__c sod = [select Show_Occurrence_Ref__c from Show_Occurrence_Public__c where Show_Occurrence_Ref__c = :t.Show_Occurrence_4__c];
             t.Show_Occurrence_Public_4__c = sod.Id;
        }
        if (t.Show_Occurrence_5__c != null)
        {
             Show_Occurrence_Public__c sod = [select Show_Occurrence_Ref__c from Show_Occurrence_Public__c where Show_Occurrence_Ref__c = :t.Show_Occurrence_5__c];
             t.Show_Occurrence_Public_5__c = sod.Id;
        }
        if (t.Show_Occurrence_6__c != null)
        {
             Show_Occurrence_Public__c sod = [select Show_Occurrence_Ref__c from Show_Occurrence_Public__c where Show_Occurrence_Ref__c = :t.Show_Occurrence_6__c];
             t.Show_Occurrence_Public_6__c = sod.Id;
        }
    }
  	*/
}