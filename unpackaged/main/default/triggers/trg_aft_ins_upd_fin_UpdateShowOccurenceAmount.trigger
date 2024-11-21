trigger trg_aft_ins_upd_fin_UpdateShowOccurenceAmount on Financials__c (after insert, after update) 
{  
    Map<Id,Financials__c> MoFinIdToFinObject = new Map<Id,Financials__c>();
    
    for (Financials__c f : trigger.new)
    {
         //Include 'Actual Continuing' type financial record if related Show Occurence is not null and Revenue is > 0
        if ( f.Show_Occurrence__c != null && f.Revenue__c != null && f.Revenue__c > 0 && f.Type__c == 'Actual Continuing')
        {
            MoFinIdToFinObject.put(f.Show_Occurrence__c ,f);
        }
    }
    
    List<Opportunity> LoOptyToUpdate = new List<Opportunity>();
    
    for (Opportunity opty : [Select Opportunity.ID, Opportunity.Amount From Opportunity Where Id in : MoFinIdToFinObject.keySet()])
    {
        //To Get Related Financial Record.
        Financials__c f = MoFinIdToFinObject.get(opty.Id);
        opty.Amount = f.Revenue__c;
        LoOptyToUpdate.add(opty);
    }
    
    //Update multiple rows in a single DML
    if(LoOptyToUpdate.size() > 0)
    {
	    Integer BatchCount = 0;
	    List<Opportunity> LoOptyToUpdateBatch = new List<Opportunity>();
        
    	for(Opportunity opty : LoOptyToUpdate)
    	{
    		LoOptyToUpdateBatch.add(opty);
    		BatchCount++;
    		
    		if (BatchCount == 200)
    		{
        		Database.Update(LoOptyToUpdateBatch, false);
        		LoOptyToUpdateBatch.clear();
        		BatchCount = 0;
    		}
    	}
    	
    	//Invoke one last time
    	if (BatchCount > 0 && LoOptyToUpdateBatch.size() > 0)
    	{
    		Database.Update(LoOptyToUpdateBatch, false);
    		LoOptyToUpdateBatch.clear();
    		BatchCount = 0;    		
    	}
    }
}