trigger TrgBeforeInsertFreightItem on Freight_Item__c (before insert) {
    
	Set<Id> SoQuoteId = new Set<Id>();

	for(Freight_Item__c fi : Trigger.New)
	{
		SoQuoteId.add(fi.Quote__c);
	}
        
    List<Freight_Item__c> FreightItems = [Select Id, Name, Line_Number__c, Crated_Weight__c, Length__c, Width__c, Height__c, Quantity__c, Quote__c From Freight_Item__c Where Quote__c In :SoQuoteId Order By Quote__c, Name];
       
    Map<Id, List<Freight_Item__c>> MoQuoteIdToExistingFreightItems = new Map<Id, List<Freight_Item__c>>();
    
    List<Freight_Item__c> QuoteFreightItems = new List<Freight_Item__c>();
    
    Id CurrentQuoteId = null;
    Integer ItemCount = 0;
    
    if (FreightItems != null && FreightItems.size() > 0)
    {
		for(Freight_Item__c fi : FreightItems)
		{
			ItemCount++;
					
			if (CurrentQuoteId == null)
				CurrentQuoteId = fi.Quote__c;
				
			if (CurrentQuoteId == fi.Quote__c)
			{
				QuoteFreightItems.add(fi);
				
				if (ItemCount == FreightItems.size())
					MoQuoteIdToExistingFreightItems.put(CurrentQuoteId, QuoteFreightItems);
			}
			
			if (CurrentQuoteId != fi.Quote__c)
			{
				MoQuoteIdToExistingFreightItems.put(CurrentQuoteId, QuoteFreightItems);
				QuoteFreightItems.clear();
				CurrentQuoteId = fi.Quote__c;
				QuoteFreightItems.add(fi);
				
				if (ItemCount == FreightItems.size())
					MoQuoteIdToExistingFreightItems.put(CurrentQuoteId, QuoteFreightItems);			
			}
		}
	    
	    Map<Id, Integer> MoQuoteIdToCurrentMaxLineNumber = new Map<Id, Integer>();
	    
	    for(Id qteId : MoQuoteIdToExistingFreightItems.keySet())
	    {
	    	List<Freight_Item__c> QteFIs = MoQuoteIdToExistingFreightItems.get(qteId);
	    	
	    	Integer MaxLineNo = 0;
	    	
	    	for(Freight_Item__c f : QteFIs)
	    	{
	    		if (Integer.valueOf(f.Name) > MaxLineNo)
	    			MaxLineNo = Integer.valueOf(f.Line_Number__c);
	    	}
	    	
	    	MoQuoteIdToCurrentMaxLineNumber.put(qteId, MaxLineNo);
	    }
	    	    
		for(Freight_Item__c fi : Trigger.New)
		{
			Integer LineNumber = 0;
			
			if (MoQuoteIdToCurrentMaxLineNumber.get(fi.Quote__c) != null)
				LineNumber = MoQuoteIdToCurrentMaxLineNumber.get(fi.Quote__c);
				
			fi.Line_Number__c = LineNumber + 1;
			MoQuoteIdToCurrentMaxLineNumber.put(fi.Quote__c, LineNumber + 1);
		}
    }
    else //No existing freight lines
    {
	    Map<Id, Integer> MoQuoteIdToCurrentAssignedLineNumber = new Map<Id, Integer>();
	        	
		for(Freight_Item__c fi : Trigger.New)
		{
			Integer LineNumber = 0;
			
			if (MoQuoteIdToCurrentAssignedLineNumber.get(fi.Quote__c) == null)
				MoQuoteIdToCurrentAssignedLineNumber.put(fi.Quote__c, LineNumber);
			else
				LineNumber = MoQuoteIdToCurrentAssignedLineNumber.get(fi.Quote__c);
			
			fi.Line_Number__c = LineNumber + 1;
			MoQuoteIdToCurrentAssignedLineNumber.put(fi.Quote__c, LineNumber + 1);
		}
    }
	
}