trigger TrgAfterInsertUpdateCase on Case (after insert, after update) {

    Set<Id> SoPotCaseIds = new Set<Id>();
    Set<Id> SoPotCaseESMIds = new Set<Id>();
    List<Case> LoPotCases = new List<Case>();
    Map<Id, Case> MoPotCaseIdToCase = new Map<Id, Case>();
    Map<Id, Id> MoPotCaseIdToESMId = new Map<Id, Id>();
    
    decimal ApprovalAmount = decimal.valueOf(500);
    
    //It appears that custom setting is not accessible in the after trigger
    //as of right now 2/14/2013. Revisit later. This same code below works
    //fine in an anonymous block and returns all custom setting data. It 
    //just does not work in this trigger.
    /*
    List<GES_Lookup__c> LoGESLookups = GES_Lookup__c.getAll().values();
    System.debug('LoGESLookups Size: ' + LoGESLookups.size());
    
    for(GES_Lookup__c l : LoGESLookups)
    {   
        System.debug('INSIDE LOOP NOW');
        if (l.Type__c.toUpperCase() == 'CASE_THRESHOLD' && l.Name.toUpperCase() == 'REFUND_APPROVAL_AMOUNT')
        {
            System.debug('HE HE HE ENTERED');
            ApprovalAmount = decimal.valueOf(l.Value__c);
        }
    }  
    
    system.debug(string.valueOf('ApprovalAmount = ' + ApprovalAmount));
        
    GES_Lookup__c Lookup = GES_Lookup__c.getInstance('REFUND_APPROVAL_AMOUNT');
    
    if (Lookup != null && Lookup.Value__c != null)
        ApprovalAmount = decimal.valueOf(Lookup.Value__c);
    */
    
    //Identify potential candidate cases on which task for 
    //Exhibitor Services Manager needs to be created. Since,
    //some of them may already have this task, the list of
    //cases being created in this for block below will have
    //to be trimmed to eliminate those cases in which such
    //a task has already been created.
    for(Case c : Trigger.new)
    {
        if (c.Exhibitor_Services_Manager__c != null && c.Refund_Adj_Amount__c != null && 
            c.Refund_Adj_Amount__c > ApprovalAmount && c.Credit_Memo_Code__c != null && c.Status != 'Closed')
            {
                SoPotCaseIds.add(c.Id);
                LoPotCases.add(c);
                MoPotCaseIdToCase.put(c.Id, c);
                
                SoPotCaseESMIds.add(c.Exhibitor_Services_Manager__c);
                MoPotCaseIdToESMId.put(c.Id, c.Exhibitor_Services_Manager__c);
            }
    }
    
    List<Task> LoTasks = [Select Id, OwnerId, WhatId From Task Where WhatId In :SoPotCaseIds And Subject = 'Credit Memo approval required'];
    Map<Id, Case> MoCasesToSkip = new Map<Id, Case>();
    
    //Trim the list of cases using the for block below to only those cases
    //which need a new task for Exhibitor Services Manager
    for(Task t : LoTasks){
        
        Case c = MoPotCaseIdToCase.get(t.WhatId);
        
        if (c != null) {
            
            Id ESMId = c.Exhibitor_Services_Manager__c;
            
            if (ESMId == null || ESMId == t.OwnerId)
            { 
                //If Exhibitor Services Manager has not been assigned on the case, task
                //owner can't be assigned, so task can't be created. Also, if there is
                //an existing task for that ESM under the case, a new task should not
                //be created as that will be duplicate.
                MoCasesToSkip.put(c.Id, c);
            }
        }
    }
    
    List<Case> LoCases = new List<Case>();
    
    for(case c : LoPotCases)
    {
        if (!MoCasesToSkip.containsKey(c.Id))
            LoCases.add(c);
    }
        
    List<Task> LoNewTasks = new List<Task>();
    
    
    //Create new tasks here
    for(case c : LoCases)
    {
        Task t = new Task();
        t.WhatId = c.Id;
        t.OwnerId = c.Exhibitor_Services_Manager__c;
        t.subject = 'Credit Memo approval required';
        t.ActivityDate = Date.Today().addDays(2);
        //t.Comments = 'Credit memo approval required.'; Field not available to API
        t.Priority = 'Normal';
        t.Status = 'Not Started';
        //t.NotifyAssignee = True; No field available in API to notify assignee
        t.Type__c = 'Internal';
        t.Sub_Type__c = 'Follow-up';
        
        LoNewTasks.add(t);
    }
    
    List<Database.Saveresult> LoResults = Database.insert(LoNewTasks, false);
    
    for(Database.Saveresult r : LoResults)
    {
        for(Database.Error e : r.getErrors())
            System.debug('Error: ' + e.message);
    }
    
    //Start - SFDC-302 - Multiple SQR - SM - 10/29/24
    if(trigger.isAfter && trigger.isUpdate){
        for(Case c : Trigger.NEW){
            system.debug('SQRServiceClient.SQRInvoked:: '+SQRServiceClient.SQRInvoked);
            system.debug('GES_Type__c:: '+c.GES_Type__c);
            system.debug('old GES_Type__c:: '+Trigger.OldMap.get(c.Id).GES_Type__c);
            system.debug('ContactId:: '+c.ContactId);
            if(!SQRServiceClient.SQRInvoked && c.GES_Type__c != null && c.GES_Type__c != Trigger.OldMap.get(c.Id).GES_Type__c && c.GES_Type__c != 'Twilio Automatic Case Closure' && c.ContactId != null){
                SQRServiceClient.submitCaseSQRs(c.Id);
            }
        }
    }
    //End - SFDC-302
   
    if(trigger.isAfter)
    {
        if(trigger.isUpdate)
        {
            if(!system.isFuture())
            {
                for(Case c : Trigger.NEW)
                {
                    if(c.status != Trigger.OldMap.get(c.Id).status && c.status == 'Closed' && c.RecordTypeId == SObjectType.Case.getRecordTypeInfosByName().get('GES US Service').getRecordTypeId())
                    {
                        system.debug('SQR CaseId=='+c.Id);
                        SQRServiceClient.submitCaseSQRs(c.Id);  
                    }
                }              
            }
        }
    } 
}