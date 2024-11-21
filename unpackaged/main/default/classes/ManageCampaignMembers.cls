global class ManageCampaignMembers {

    global class CalloutException extends Exception {        
    }
    
    WebService static void AddShowBoothContacts(string campaignId, string opportunityId){
    	
    	if (opportunityId != null && campaignId != null)
    	{
    		opportunityId = (id)opportunityId;
    		
    		Opportunity ShowOccr = [Select Id, Job_Number__c From Opportunity Where Id = :opportunityId];
    		
    		
    		if (ShowOccr.Job_Number__c != null)
    		{
    			list<Oracle_Show_Booth__c> Booths = [Select Id, CUST_CONT_ID__c From Oracle_Show_Booth__c Where Show_Occurrence__c = :opportunityId];
    			
    			set<Id> SoBoothIds = new set<Id>();
    			set<string> SoCustContIds = new set<string>();
    			map<Id, string> MoBoothIdToCustContId = new map<Id, string>();
    			
    			for(Oracle_Show_Booth__c booth : Booths)
    			{
    				SoBoothIds.add(booth.Id);
    				SoCustContIds.add(booth.CUST_CONT_ID__c);
    				MoBoothIdToCustContId.put(booth.Id, booth.CUST_CONT_ID__c);
    			}
    			
    			set<Id> SoContactIds = new set<Id>();
    			map<Id, Id> MoContactIdToAccountId = new map<Id, Id>();
    			map<Id, Oracle_Show_Booth_Contact__c> MoContactIdToBoothContact = new map<Id, Oracle_Show_Booth_Contact__c>();
    			
    			list<Oracle_Show_Booth_Contact__c> BoothContacts = [Select Id, CUST_CONT_ID__c, Contact__c, Contact__r.Account.Id, PRIMARY_FLAG__c From Oracle_Show_Booth_Contact__c Where CUST_CONT_ID__c In :SoCustContIds];
    			
    			for(Oracle_Show_Booth_Contact__c cont : BoothContacts)
    			{
    				SoContactIds.add(cont.Contact__c);
    				MoContactIdToAccountId.put(cont.Contact__c, cont.Contact__r.Account.Id);
    				MoContactIdToBoothContact.put(cont.Contact__c, cont);
    			}	
    			    			
    			list<CampaignMember> CampMembers = [Select Id, ContactId From CampaignMember Where ContactId In :SoContactIds];
    			
    			set<Id> SoCampContactIds = new set<Id>();
    			
    			for(CampaignMember camp : CampMembers)
    			{
    				SoCampContactIds.add(camp.ContactId);
    			}
    			
    			set<Id> SoAddContactIds = new set<Id>();
    			
    			for(Id conId : SoContactIds)
    			{
    				if (!SoCampContactIds.contains(conId))
    				{
    					SoAddContactIds.add(conId);
    				}
    			}			
    			
    			if (SoAddContactIds.size() > 0)
    			{
    				list<CampaignMember> LoCampMembers = new list<CampaignMember>();
    				
    				integer listCount = 0;
    				
    				for(id contId : SoAddContactIds)
    				{
    					CampaignMember Mem = new CampaignMember();
    					Mem.CampaignId = campaignId;
    					Mem.ContactId = contId;
    					Mem.Status = 'Planned';
    					
    					string PrimaryFlag = (MoContactIdToBoothContact.get(contId)).PRIMARY_FLAG__c;
    					
    					Mem.Primary_Contact__c = (PrimaryFlag != '' && PrimaryFlag != null && PrimaryFlag.toUpperCase() == 'Y' ? true : false);
    					Mem.Exhibitor__c = MoContactIdToAccountId.get(contId);
    					
    					LoCampMembers.add(Mem);
    				
    					listCount++;
    					
    					if (listCount == 199)
    					{
    						Database.insert(LoCampMembers);
    						listCount = 0;
    						LoCampMembers = new list<CampaignMember>();
    					}
    				}
    				
    				if (listCount > 0)
    					Database.insert(LoCampMembers);
    			}
    		}
    		
    	
    	}
    }
}