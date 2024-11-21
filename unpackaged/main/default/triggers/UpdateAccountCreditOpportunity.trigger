trigger UpdateAccountCreditOpportunity on Account_Credit_Opportunity__c (before insert, before update) 
{
	// fetch all private opportunity ids	
  	SET<ID> setOpportunityId = new SET<ID>();	
  	for(Account_Credit_Opportunity__c objAccCreditOpp: Trigger.New) 
  	{
    	if(objAccCreditOpp.Opportunity__c != null)
    	{
    		setOpportunityId.add(objAccCreditOpp.Opportunity__c);
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
  	for(Account_Credit_Opportunity__c objAccCreditOpp: Trigger.New) 
  	{
  		if(objAccCreditOpp.Opportunity__c != null)
  		{
  	  		if(mapOppPublic.containsKey(objAccCreditOpp.Opportunity__c))
  	  		{
  	  	 		objAccCreditOpp.Show_Opportunity_Public__c = mapOppPublic.get(objAccCreditOpp.Opportunity__c);
  	  		}
  		}
  	}  
}