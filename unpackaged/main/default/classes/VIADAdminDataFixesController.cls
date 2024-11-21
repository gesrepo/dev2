public with sharing class VIADAdminDataFixesController {

    static final integer MaxBatchSize = 200;
    static final integer MaxDMLRows = 8000;
    static final integer MaxQueryRows = 50000;
     
    string fixType;
    
    public VIADAdminDataFixesController() {
    }
    
    public string getName() {
        return 'VIADAdminDataFixesController';
    }
    
    public List<SelectOption> getFixTypeOptions()
    {
        List<SelectOption> fixTypes = new List<SelectOption>();
        fixTypes.add(new SelectOption('RFC001155_SetTypeFieldOfOpenActivities','RFC001155_SetTypeFieldOfOpenActivities'));
        fixTypes.add(new SelectOption('RFC001155_SetTypeFieldOfCompletedActivities','RFC001155_SetTypeFieldOfCompletedActivities'));
        //fixTypes.add(new SelectOption('RFC001155_ChangeShowOpportunityPublicStageFromSLToSL4','RFC001155_ChangeShowOpportunityPublicStageFromSLToSL4'));
        fixTypes.add(new SelectOption('RFC001930_MoveAccountActivitiesToShow','RFC001930_MoveAccountActivitiesToShow'));
        fixTypes.add(new SelectOption('RFC001930_MoveAccountEventsToShow','RFC001930_MoveAccountEventsToShow'));
        fixTypes.add(new SelectOption('RFC001930_MoveShowOccurrenceActivitiesToShow','RFC001930_MoveShowOccurrenceActivitiesToShow'));
        fixTypes.add(new SelectOption('RFC001930_MoveShowOccurrenceEventsToShow','RFC001930_MoveShowOccurrenceEventsToShow'));

        return fixTypes;
    }
    
    public string getFixType() {
        return fixType;
    }
        
    public void setFixType(string value) {
        fixType = value;
    }
        
    public PageReference Save() {
        
        try {
                Integer RecordsProcessed = 0;
                
                /*
                if (FixType == 'RFC001155_SetTypeFieldOfOpenActivities')
                {
                    RecordsProcessed = RFC001155_SetTypeFieldOfOpenActivities();
                }
                else if (FixType == 'RFC001155_SetTypeFieldOfCompletedActivities')
                {
                    RecordsProcessed = RFC001155_SetTypeFieldOfCompletedActivities();
                }
                //else if (FixType == 'RFC001155_ChangeShowOpportunityPublicStageFromSLToSL4')
                //{
                //    RecordsProcessed = RFC001155_ChangeShowOpportunityPublicStageFromSLToSL4();
                //}
                else if (FixType == 'RFC001930_MoveAccountActivitiesToShow')
                {
                	RecordsProcessed = RFC001930_MoveAccountActivitiesToShow();
                }
                else if (Fixtype == 'RFC001930_MoveAccountEventsToShow')
                {
                	RecordsProcessed = RFC001930_MoveAccountEventsToShow();
                }
                else if (FixType == 'RFC001930_MoveShowOccurrenceActivitiesToShow')
                {
                	RecordsProcessed = RFC001930_MoveShowOccurrenceActivitiesToShow();
                }
                else if (FixType == 'RFC001930_MoveShowOccurrenceEventsToShow')
                {
                	RecordsProcessed = RFC001930_MoveShowOccurrenceEventsToShow();
                }
                */             
                ApexPages.Message Msg = new ApexPages.Message(ApexPages.Severity.INFO,'Selected Fix Type = \''+ this.fixType + '\'; Processed ' + RecordsProcessed + ' record(s).');
                ApexPages.addMessage(Msg);                
        }
        catch(Exception e)
        {
            ApexPages.addMessages(e);
        }
        
        PageReference p = ApexPages.currentPage();
        //p.setRedirect(true);
        
        return p;
    }
    
    /*
    
    public Integer RFC001155_SetTypeFieldOfCompletedActivities() {
            
        Integer TotalCount = 0;
        Integer CurrentBatchSize = 0;
        Integer ErrorCount = 0;
        
        Task[] Tasks = new Task[MaxBatchSize];
        
        for (Task Activity: [Select Id, Type, Type__c, Sub_Type__c, Sub_Sub_Type__c From Task Where Status = 'Completed' And Type__c = null Limit 4000])
        {
            //Add object to list
                            
            Activity.Type__c = 'Other';
            Activity.Sub_Type__c = RFC001155_GetNewActivitySubType(Activity.Type);
           
            Tasks[CurrentBatchSize] = Activity;
            
            CurrentBatchSize++;
            TotalCount++;
            
            if (CurrentBatchSize == MaxBatchSize)
            {       
                List<Database.Upsertresult> UpsertResults = Database.upsert(Tasks, false);
                 
                //Process any failures
                for(Database.Upsertresult result: UpsertResults)
                {
                    if (!result.isSuccess()){
                        ErrorCount++;
                    }
                }
                
                Tasks = new Task[MaxBatchSize];
                CurrentBatchSize = 0;
            }
            
            if (TotalCount == MaxDMLRows)
                break;
        }
        
        //If last batch has fewer than MaxBatchSize rows, invoke insert one last time
        if (CurrentBatchSize > 0)
        {
        	Task[] RemainingTasks = new Task[CurrentBatchSize];
        	
        	for (Integer i=0; i < CurrentBatchSize; i++)
        	{
        		RemainingTasks[i] = Tasks[i];
        	}
        	
            List<Database.Upsertresult> UpsertResults = Database.upsert(RemainingTasks, false);
            
            //Process any failures
            for(Database.Upsertresult result: UpsertResults)
            {
                if (!result.isSuccess()){
                    ErrorCount++;
                }
            }

        }       
        
        return TotalCount;
    }
    
    public Integer RFC001155_SetTypeFieldOfOpenActivities() {
            
        Integer TotalCount = 0;
        Integer CurrentBatchSize = 0;
        Integer ErrorCount = 0;
        
        Task[] Tasks = new Task[MaxBatchSize];
        
        for (Task Activity: [Select Id, Type, Type__c, Sub_Type__c, Sub_Sub_Type__c From Task Where Status != 'Completed'  And Type__c = null Limit 4000])
        {
            //Add object to list
            
            Activity.Type__c = RFC001155_GetNewActivityType(Activity.Type);
            Activity.Sub_Type__c = RFC001155_GetNewActivitySubType(Activity.Type);
                 
            Tasks[CurrentBatchSize] = Activity;
            
            CurrentBatchSize++;
            TotalCount++;
            
            if (CurrentBatchSize == MaxBatchSize)
            {       
                List<Database.Upsertresult> UpsertResults = Database.upsert(Tasks, false);
                 
                //Process any failures
                for(Database.Upsertresult result: UpsertResults)
                {
                    if (!result.isSuccess()){
                        ErrorCount++;
                    }
                }
                
                Tasks = new Task[MaxBatchSize];
                CurrentBatchSize = 0;
            }
            
            if (TotalCount == MaxDMLRows)
                break;            
        }
        
        //If last batch has fewer than MaxBatchSize rows, invoke insert one last time
        if (CurrentBatchSize > 0)
        {
        	Task[] RemainingTasks = new Task[CurrentBatchSize];
        	
        	for (Integer i=0; i < CurrentBatchSize; i++)
        	{
        		RemainingTasks[i] = Tasks[i];
        	}
        	        	
            List<Database.Upsertresult> UpsertResults = Database.upsert(RemainingTasks, false);
            
            //Process any failures
            for(Database.Upsertresult result: UpsertResults)
            {
                if (!result.isSuccess()){
                    ErrorCount++;
                }
            }
        }       
        
        return TotalCount;
    }
    
    public string RFC001155_GetNewActivityType(string oldType) {
        
        string newType = '';
        
        if (oldType == 'Phone' || oldType == 'Email' || oldType == 'Sent GES Show Business' || oldType ==  'Gift' || oldType ==  'Complete Competitor Show Report' || oldType == 'Sent Proposal' || oldType == 'Industry Event' || oldType == 'Meeting - External' || oldType ==  'Site Visit' || oldType == 'Face to Face' || oldType == 'Solutions Presentation' || oldType == 'Capabilities Presentation')
        {
            newType = 'External';
        }
        else if(oldType ==  'Reassignment' || oldType ==  'Follow-up' || oldType ==  'Account Planning'|| oldType ==  'Meeting - Internal' || oldType ==  'Task')
        {
            newType = 'Internal';
        }
        else if (oldType == 'Letter' || oldType == 'Attached Competitor Show Report')
        {
            newType = 'External';
        }
        else
        {
            newType = 'External';
        }
        
        return newType;
    }
    
    public string RFC001155_GetNewActivitySubType(string oldType) {
        
        string subType = '';
        
        if (oldType == 'Phone')
        {
            subType = 'Phone';
        }
        else if (oldType == 'Email')
        {
            subType = 'Email';          
        }
        else if (oldType == 'Sent GES Show Business')
        {
            subType = 'Sent GES Show Business';         
        }
        else if (oldType == 'Gift')
        {
            subType = 'Gift';           
        }
        else if (oldType ==  'Complete Competitor Show Report')
        {
            subType = 'Attached & Completed Competitor Show Report';           
        }
        else if (oldType == 'Sent Proposal')
        {
            subType = 'Sent Proposal';          
        }
        else if (oldType == 'Industry Event')
        {
            subType = 'Industry Event';         
        }
        else if (oldType == 'Meeting - External')
        {
            subType = 'Meeting';
        }
        else if (oldType ==  'Site Visit')
        {
            subType = 'Site Visit';
        }
        else if (oldType == 'Face to Face')
        {
            subType = 'Face-to-face Meeting';
        }
        else if (oldType == 'Solutions Presentation')
        {
            subType = 'Presentation';
        }
        else if (oldType == 'Capabilities Presentation')
        {
            subType = 'Presentation';
        }
        else if(oldType ==  'Reassignment')
        {
            subType = 'Reassignment';
        }
        else if (oldType ==  'Follow-up')
        {
            subType = 'Follow-up';
        }
        else if (oldType ==  'Account Planning')
        {
            subType = 'Account Planning';
        }
        else if (oldType ==  'Meeting - Internal')
        {
            subType = 'Meeting';
        }
        else if (oldType ==  'Task')
        {
            subType = 'Task';
        }
        else if (oldType == 'Letter')
        {
            subType = 'Letter';
        }
        else if (oldType == 'Attached Competitor Show Report')
        {
            subType = 'Attached & Completed Competitor Show Report';
        }
        
        return subType;
    } 
    */
    
    /*
    public Integer RFC001155_ChangeShowOpportunityPublicStageFromSLToSL4() {
            
        Integer TotalCount = 0;
        Integer CurrentBatchSize = 0;
        Integer ErrorCount = 0;
        
        Show_Occurrence_Public__c[] Optys = new Show_Occurrence_Public__c[MaxBatchSize];
        
        for (Show_Occurrence_Public__c Opty: [Select Id From Show_Occurrence_Public__c Where Stage__c = 'SL'])
        {
            //Add object to list
            
            Opty.Stage__c = 'SL4';
                             
            Optys[CurrentBatchSize] = Opty;
            
            CurrentBatchSize++;
            TotalCount++;
            
            if (CurrentBatchSize == MaxBatchSize)
            {       
                List<Database.Upsertresult> UpsertResults = Database.upsert(Optys, false);
                 
                //Process any failures
                for(Database.Upsertresult result: UpsertResults)
                {
                    if (!result.isSuccess()){
                        ErrorCount++;
                    }
                }
                
                Optys = new Show_Occurrence_Public__c[MaxBatchSize];
                CurrentBatchSize = 0;
            }
            
            if (TotalCount == MaxDMLRows)
                break;            
        }
        
        //If last batch has fewer than MaxBatchSize rows, invoke insert one last time
        if (CurrentBatchSize > 0)
        {
        	Show_Occurrence_Public__c[] RemainingOptys = new Show_Occurrence_Public__c[CurrentBatchSize];
        	
        	for (Integer i=0; i < CurrentBatchSize; i++)
        	{
        		RemainingOptys[i] = Optys[i];
        	}
        	
            List<Database.Upsertresult> UpsertResults = Database.upsert(RemainingOptys, false);
            
            //Process any failures
            for(Database.Upsertresult result: UpsertResults)
            {
                if (!result.isSuccess()){
                    ErrorCount++;
                }
            }
        }       
        
        return TotalCount;
    } 
    */ 
    
    /*
    public Integer RFC001930_MoveAccountActivitiesToShow() {
           
        Task[] Tasks = new Task[MaxBatchSize];
        
        //Retrieve list of all Shows.
        List<Show__c> ListOfAllShows = [Select Id, Account__c From Show__c Where Account__c != null And Account__r.RecordType.Name = 'Firm' Order By Account__c];
        
        //Create a Set of all Unique Account Ids. Also, for these Accounnts create
        //a Map of Account Ids to Show Id
        map<Id, Id> ShowAccountMap = new map<Id, Id>();
        set<Id> UniqueAccounts = new set<Id>();
        set<Id> RemoveAccounts = new set<Id>();
        
		//If An Account is not in the UniqueAccounts set, then add it.
		//However, if it exists in more than 1 Show, then remove it from
		//the set. We want a set and a map of only those Accounts, which
		//have 1 and only 1 Show
        	
        for (Show__c show : ListOfAllShows)
        {
        	if (!UniqueAccounts.contains(show.Account__c))
        	{
        		UniqueAccounts.add(show.Account__c);
	  			ShowAccountMap.put(show.Account__c, show.Id);
        	}
        	else
        	{
        		RemoveAccounts.add(Show.Account__c);
        	}
        }
        
        for(Id accountId : RemoveAccounts)  
        {
        	if (UniqueAccounts.contains(accountId))
        	{
        		UniqueAccounts.remove(accountId);
        		ShowAccountMap.remove(accountId);
        	}
        }
        
        Integer TotalCount = 0;
        Integer CurrentBatchSize = 0;
        Integer ErrorCount = 0;
                
        for (Task Activity: [Select Id, AccountId, WhatId From Task Where AccountId In :UniqueAccounts And Account.RecordType.Name In ('Firm') And WhatId NOT IN (Select Id From Opportunity) limit :MaxDMLRows])
        {   
        	
        	//	1. If an Activity is primarily related to a Show Occurrence, then it'll
        	//	be processed by the function that processes Show Occurrences. Do not
        	//	update this Activity here. Note the select statement above - it selects
        	//	only those Tasks which are not related to Opportunity (condition on WhatId
        	//	field)
        		
        	//	2. If an Activity is primarily related to an Account, update it to tie 
        	//	to the Show instead.
        		
        	//	3. All other cases, i.e. if Activity is related to a different object i.e
        	//	other than Account or Opportunity, tie them to the Show.
        		
        	//	NOTE: In both cases # 1 and # 2 don't attempt to null AccountId field
        	//	of the Task - this field is not updateable.
        	

        	string ShowId = ShowAccountMap.get(Activity.AccountId);

        	if (Activity.WhatId == Activity.AccountId)
        	{	        		
           		Activity.WhatId = ShowId;
        	}
        	else //Related other object, i.e. other than Account and Opportunity
        	{
        		Activity.WhatId = ShowId;
        	}
            
            Tasks[CurrentBatchSize] = Activity;
            
            CurrentBatchSize++;
            TotalCount++;
            
            if (CurrentBatchSize == MaxBatchSize || TotalCount == MaxDMLRows)
            {       
                List<Database.Upsertresult> UpsertResults = Database.upsert(Tasks, false);
                 
                //Process any failures
                for(Database.Upsertresult result: UpsertResults)
                {
                    if (!result.isSuccess()){
                        ErrorCount++;
                    }
                }
                
                Tasks = new Task[MaxBatchSize];
                CurrentBatchSize = 0;
            }
            
            if (TotalCount == MaxDMLRows)
                break;
        }
        
        //If last batch has fewer than MaxBatchSize rows and MaxDMLRows number of records
        //have not been processed, execute upsert one last time
        if (CurrentBatchSize > 0 && TotalCount < MaxDMLRows)
        {
        	Integer AllowedNumOfRows = MaxDMLRows - TotalCount;
        	
        	If (CurrentBatchSize <= AllowedNumOfRows)
        		AllowedNumOfRows = CurrentBatchSize;
        		
        	Task[] RemainingTasks = new Task[AllowedNumOfRows];
        	
        	for (Integer i=0; i < AllowedNumOfRows; i++)
        	{
        		RemainingTasks[i] = Tasks[i];
        	}
        	
            List<Database.Upsertresult> UpsertResults = Database.upsert(RemainingTasks, false);
            
            //Process any failures
            for(Database.Upsertresult result: UpsertResults)
            {
                if (!result.isSuccess()){
                    ErrorCount++;
                }
            }

        }       
        
        return TotalCount;
    } 
    
    public Integer RFC001930_MoveAccountEventsToShow() {
                   
        Event[] Events = new Event[MaxBatchSize];
        
        //Retrieve list of all Shows.
        List<Show__c> ListOfAllShows = [Select Id, Account__c From Show__c Where Account__c != null And Account__r.RecordType.Name = 'Firm' Order By Account__c];
        
        //Create a Set of all Unique Account Ids. Also, for these Accounnts create
        //a Map of Account Ids to Show Id
        map<Id, Id> ShowAccountMap = new map<Id, Id>();
        set<Id> UniqueAccounts = new set<Id>();
        set<Id> RemoveAccounts = new set<Id>();
        
		//If An Account is not in the UniqueAccounts set, then add it.
		//However, if it exists in more than 1 Show, then remove it from
		//the set. We want a set and map of only those Accounts, which
		//have 1 and only 1 Show
        	
        for (Show__c show : ListOfAllShows)
        {
        	if (!UniqueAccounts.contains(show.Account__c))
        	{
        		UniqueAccounts.add(show.Account__c);
	  			ShowAccountMap.put(show.Account__c, show.Id);
        	}
        	else
        	{
        		RemoveAccounts.add(Show.Account__c);
        	}
        }
        
        for(Id accountId : RemoveAccounts)  
        {
        	if (UniqueAccounts.contains(accountId))
        	{
        		UniqueAccounts.remove(accountId);
        		ShowAccountMap.remove(accountId);
        	}
        }        

        Integer TotalCount = 0;
        Integer CurrentBatchSize = 0;
        Integer ErrorCount = 0;
        
        for (Event MyEvent: [Select Id, AccountId, WhatId From Event Where AccountId In :UniqueAccounts And Account.RecordType.Name In ('Firm') And WhatId NOT IN (Select Id From Opportunity) limit :MaxDMLRows])
        {   
        	
        	//	1. If an Event is primarily related to a Show Occurrence, then it'll
        	//	be processed by the function that processes Show Occurrences. Do not
        	//	update these Events here. Note the select statement above - it selects
        	//	only those Events that are not related to Opportunity (condition on WhatId
        	//	field)
        		
        	//	2. If an Event is primarily related to an Account, update it to tie 
        	//	to the Show instead.
        		
        	//	3. All other cases, i.e. if Event is related to a different object i.e
        	//	other than Account or Opportunity, tie it to the Show.
        		
        	//	NOTE: In both cases # 1 and # 2 don't attempt to null AccountId field
        	//	of the Event - this field is not updateable.
        	
        	//string ShowId = SingleShowAccountsMap.get(MyEvent.AccountId);
        	string ShowId = ShowAccountMap.get(MyEvent.AccountId);        	

        	if (MyEvent.WhatId == MyEvent.AccountId)
        	{	        		
           		MyEvent.WhatId = ShowId;
        	}
        	else //Related other object, i.e. other than Account and Opportunity
        	{
        		MyEvent.WhatId = ShowId;
        	}
            
            Events[CurrentBatchSize] = MyEvent;
            
            CurrentBatchSize++;
            TotalCount++;
            
            if (CurrentBatchSize == MaxBatchSize || TotalCount == MaxDMLRows)
            {       
                List<Database.Upsertresult> UpsertResults = Database.upsert(Events, false);
                 
                //Process any failures
                for(Database.Upsertresult result: UpsertResults)
                {
                    if (!result.isSuccess()){
                        ErrorCount++;
                    }
                }
                
                Events = new Event[MaxBatchSize];
                CurrentBatchSize = 0;
            }
            
            if (TotalCount == MaxDMLRows)
                break;
        }
        
        //If last batch has fewer than MaxBatchSize rows and MaxDMLRows number of records
        //have not been processed, execute upsert one last time
        if (CurrentBatchSize > 0 && TotalCount < MaxDMLRows)
        {
        	Integer AllowedNumOfRows = MaxDMLRows - TotalCount;
        	
        	If (CurrentBatchSize <= AllowedNumOfRows)
        		AllowedNumOfRows = CurrentBatchSize;
        		        	        	
        	Event[] RemainingEvents = new Event[AllowedNumOfRows];
        	
        	for (Integer i=0; i < AllowedNumOfRows; i++)
        	{
        		RemainingEvents[i] = Events[i];
        	}
        	
            List<Database.Upsertresult> UpsertResults = Database.upsert(RemainingEvents, false);
            
            //Process any failures
            for(Database.Upsertresult result: UpsertResults)
            {
                if (!result.isSuccess()){
                    ErrorCount++;
                }
            }

        }       
        
        return TotalCount;
    }     

    public Integer RFC001930_MoveShowOccurrenceActivitiesToShow() 
    {              
        Task[] ArrayOfTasks = [Select Id, WhatId From Task Where WhatId In (Select Id From Opportunity Where Show_Name__c != null And RecordType.Name != 'E&D - Projects' And RecordType.Name != 'E&D - Projects - Proposal' And RecordType.Name != 'E&D - Project - Read Only' And RecordType.Name != 'E&D - Projects - Read Only') limit :MaxDMLRows];
        
        map<Id, Id> TasksOppMap = new map<Id, Id>();
        
        for(Task tsk: ArrayOfTasks)
        {
        	TasksOppMap.put(tsk.Id, tsk.WhatId);
        }
        
        Opportunity[] ListOfOpportunities = [Select Id, Show_Name__c From Opportunity Where Show_Name__c!= null And Id In :TasksOppMap.values()];
        
        map<Id, Id> OpportunityShowMap = new map<Id, Id>();
        
        for(Opportunity opp : ListOfOpportunities)
        {
        	OpportunityShowMap.put(opp.Id, opp.Show_Name__c);
        }
        
        Integer TotalCount = 0;
        Integer CurrentBatchSize = 0;
        Integer ErrorCount = 0;
        
        Task[] Tasks = new Task[MaxBatchSize];
        
        for (Task tsk: ArrayOfTasks)
        {   
        	string ShowId = OpportunityShowMap.get(tsk.WhatId);
        	
        	tsk.WhatId = ShowId;

            Tasks[CurrentBatchSize] = tsk;
            
            CurrentBatchSize++;
            TotalCount++;
            
            if (CurrentBatchSize == MaxBatchSize || TotalCount == MaxDMLRows)
            {       
                List<Database.Upsertresult> UpsertResults = Database.upsert(Tasks, false);
                 
                //Process any failures
                for(Database.Upsertresult result: UpsertResults)
                {
                    if (!result.isSuccess()){
                        ErrorCount++;
                    }
                }
                
                Tasks = new Task[MaxBatchSize];
                CurrentBatchSize = 0;
            }
            
            if (TotalCount == MaxDMLRows)
                break;
        }
        
        //If last batch has fewer than MaxBatchSize rows and MaxDMLRows number of records
        //have not been processed, execute upsert one last time
        if (CurrentBatchSize > 0 && TotalCount < MaxDMLRows)
        {
        	Integer AllowedNumOfRows = MaxDMLRows - TotalCount;
        	
        	If (CurrentBatchSize <= AllowedNumOfRows)
        		AllowedNumOfRows = CurrentBatchSize;
        	        	
        	Task[] RemainingTasks = new Task[AllowedNumOfRows];
        	       	
        	for (Integer j=0; j < AllowedNumOfRows; j++)
        	{
        		RemainingTasks[j] = Tasks[j];
        	}
        	
            List<Database.Upsertresult> UpsertResults = Database.upsert(RemainingTasks, false);
            
            //Process any failures
            for(Database.Upsertresult result: UpsertResults)
            {
                if (!result.isSuccess()){
                    ErrorCount++;
                }
            }

        }       
        
        return TotalCount;   
    } 
    
    public Integer RFC001930_MoveShowOccurrenceEventsToShow() 
    {        
        Event[] Events = new Event[MaxBatchSize];
                
        List<Event> ListOfEvents = [Select Id, WhatId From Event Where WhatId In (Select Id From Opportunity Where Show_Name__c != null And RecordType.Name != 'E&D - Projects' And RecordType.Name != 'E&D - Projects - Proposal' And RecordType.Name != 'E&D - Project - Read Only' And RecordType.Name != 'E&D - Projects - Read Only') limit :MaxDMLRows];
        
        map<Id, Id> EventsOppMap = new map<Id, Id>();
        
        for(Event evt: ListOfEvents)
        {
        	EventsOppMap.put(evt.Id, evt.WhatId);
        }
        
        List<Opportunity> ListOfOpportunities = [Select Id, Show_Name__c From Opportunity Where Show_Name__c != null And Id In :EventsOppMap.values()];
        
        map<Id, Id> OpportunityShowMap = new map<Id, Id>();
        
        for(Opportunity opp : ListOfOpportunities)
        {
        	OpportunityShowMap.put(opp.Id, opp.Show_Name__c);
        }
        
 		Integer TotalCount = 0;
        Integer CurrentBatchSize = 0;
        Integer ErrorCount = 0;
        
        for (Event MyEvent: [Select Id, WhatId From Event Where WhatId In :OpportunityShowMap.keySet()])
        {   
        	string ShowId = OpportunityShowMap.get(MyEvent.WhatId);
        	
        	MyEvent.WhatId = ShowId;

            Events[CurrentBatchSize] = MyEvent;
            
            CurrentBatchSize++;
            TotalCount++;
            
            if (CurrentBatchSize == MaxBatchSize || TotalCount == MaxDMLRows)
            {       
                List<Database.Upsertresult> UpsertResults = Database.upsert(Events, false);
                 
                //Process any failures
                for(Database.Upsertresult result: UpsertResults)
                {
                    if (!result.isSuccess()){
                        ErrorCount++;
                    }
                }
                
                Events = new Event[MaxBatchSize];
                CurrentBatchSize = 0;
            }
            
            if (TotalCount == MaxDMLRows)
                break;
        }
        
        //If last batch has fewer than MaxBatchSize rows and MaxDMLRows number of records
        //have not been processed, execute upsert one last time
        if (CurrentBatchSize > 0 && TotalCount < MaxDMLRows)
        {
        	Integer AllowedNumOfRows = MaxDMLRows - TotalCount;
        	
        	If (CurrentBatchSize <= AllowedNumOfRows)
        		AllowedNumOfRows = CurrentBatchSize;
        		        	
        	Event[] RemainingEvents = new Event[AllowedNumOfRows];
        	
        	for (Integer i=0; i < AllowedNumOfRows; i++)
        	{
        		RemainingEvents[i] = Events[i];
        	}
        	
            List<Database.Upsertresult> UpsertResults = Database.upsert(RemainingEvents, false);
            
            //Process any failures
            for(Database.Upsertresult result: UpsertResults)
            {
                if (!result.isSuccess()){
                    ErrorCount++;
                }
            }

        }       
        
        return TotalCount;   
    } 
    */     
}