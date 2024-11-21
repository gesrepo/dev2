trigger UpdateAdvancePayment on Advance_Payment__c (before insert, before update) 
{
	// fetch all private opportunity ids  
	SET<ID> setOpportunityId = new SET<ID>();  
  	for(Advance_Payment__c objAPI: Trigger.New) 
  	{
    	if(objAPI.Show_Occurrence__c != null)
    	{
      		setOpportunityId.add(objAPI.Show_Occurrence__c);
    	}  
  	}
  
 	// Map to hold private & public opportunities
  	MAP<Id,Id> mapOppPublic = new MAP<Id,Id>();
  
  	// create map for private opportunity & public opportunity
  	for(Show_Occurrence_Public__c op : [Select s.Show_Occurrence_Ref__c, s.Id From Show_Occurrence_Public__c s Where s.Show_Occurrence_Ref__c IN : setOpportunityId])
  	{
    	if(op.Show_Occurrence_Ref__c != null)
    	{
      		if(mapOppPublic.containsKey(op.Show_Occurrence_Ref__c) == false)
      		{  
        		mapOppPublic.put(op.Show_Occurrence_Ref__c, op.Id);
      		}
    	}
  	}
  
  	// check & populate show occurrence public field
  	for(Advance_Payment__c objAPI: Trigger.New) 
  	{
    	if(objAPI.Show_Occurrence__c != null)
    	{
      		if(mapOppPublic.containsKey(objAPI.Show_Occurrence__c))
      		{
         		objAPI.Show_Occurrence_Public__c = mapOppPublic.get(objAPI.Show_Occurrence__c);
      		}
		}
  	}
}