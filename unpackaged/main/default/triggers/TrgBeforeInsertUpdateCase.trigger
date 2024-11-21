trigger TrgBeforeInsertUpdateCase on Case (before insert, before update) {
    /*
        Date Created: 09-Oct-2012
        Created By: Joy Varughese
        
        --------
        Purpose:
        --------
        This Trigger is fired evertime a case is inserted and/or updated.
        Since this is a before trigger, you have the ability to modify
        field values before they are committed.
        
        1. Default field value for field Owner_Manager__c. This is based on the case owner. 
        The field is required to support escalation notifications to case owner's manager.
        
        2. Default field value for field Date_Assigned_To_Current_Owner__c. Whenever owner is changed, 
        this date needs to be updated.
        
        3. Default field values for these fields below based on selection on UI:
            Booth__c
            AccountId
            Show_Opportunity__c
            Show_Name__c
        
        4. Mark a case as "Severe" (i.e. check Severe__c field) if this criteria is met:
            Reason__c = 'Freight - Reroute'
            OR Reason__c == 'Freight - Upgrade'
            OR Escalated_To__c = '2 - Director'
            OR Escalated_To__c = '1 - Senior Management'
        
        5. Do not allow user to close case if there is any open task.  
        
        6. If the priority changes from 'First Call Resolution' to any other priority
           Date Committed is required.
           
        7. Do not allow user to close case if there is no case comment.
        
    */
    
    //Create variables to stored the OwnerId, BoothId and OpptyId
    //selected on each case
    Set<Id> SoOwnerId = new Set<Id>();
    Set<Id> SoBoothId = new Set<Id>();
    Set<Id> SoOptyId = new Set<Id>();
    Set<Id> SoShowId = new Set<Id>();
    Set<Id> SoContactId = new set<Id>();
    Set<Id> SoAccountId = new set<Id>();
    
    //Create variables to map CaseId to BoothId and OptyId. These
    //maps could be used later in this trigger to retrive name/other
    //fields from Booth and Opportunity objects.
    Map<Id,Id> MoCaseIdToBoothId = new Map<Id,Id>();
    Map<Id,Id> MoCaseIdToOptyId = new Map<Id,Id>();
    Map<Id,Id> MoCaseIdToShowId = new Map<Id,Id>();
    Map<Id,Id> MoCaseIdToContactId = new Map<Id,Id>();
    Map<Id,Id> MoCaseIdToAccountId = new Map<Id,Id>();
    Map<Id,String> MoCaseIdToOldCustomerName = new Map<Id, String>();
    
    if(trigger.isUpdate){
        system.debug('inside updateCaseOwnerFromDelegate');
        checkUserHasPermission(trigger.new, trigger.oldMap); //SFDC-258 - Mass Close Case List View Button addeed in Ligthing and restricting to close case if user not has Manage_Cases permission - 02/16/24 - Sajid
        updateCaseOwnerFromDelegate(trigger.new, trigger.oldMap);
        
    }
    for(Case c : Trigger.New)
    {
        SoOwnerId.add(c.OwnerId);
        
        if (c.Booth__c != null)
        {
            MoCaseIdToBoothId.put(c.Id, c.Booth__c);
            SoBoothId.add(c.Booth__c);
        }
            
        if (c.Show_Opportunity__c != null)
        {
            MoCaseIdToOptyId.put(c.Id, c.Show_Opportunity__c);
            SoOptyId.add(c.Show_Opportunity__c);
        }
        
        if (c.Show_Name__c != null)
        {
            MoCaseIdToShowId.put(c.Id, c.Show_Name__c);
            SoShowId.add(c.Show_Name__c);
        }        
        
        if (c.ContactId != null)
        {
            MoCaseIdToContactId.put(c.Id, c.ContactId);
            SoContactId.add(c.ContactId);
        }
        
        if (c.AccountId != null)
        {
            MoCaseIdToAccountId.put(c.Id, c.AccountId);
            SoAccountId.add(c.AccountId);       
        }
        
        if (Trigger.isUpdate){
            MoCaseIdToOldCustomerName.put(c.Id, Trigger.oldMap.get(c.Id).Customer_Name__c);
            system.debug('inside MoCaseIdToOldCustomerName');
        }    
    }
    
    //Create a list of Case Owner managers and a map of OwnerId to Manager. This
    //map could be used later in this trigger to retrieve additional fields from the 
    //Manager user object.
    List<User> LoManagers = [Select Id, ManagerId From User Where Id In :SoOwnerId];
    Map<Id, Id> MoOwnerIdToManagerId = new Map<Id, Id>();
    
    for(User u : LoManagers)
    {
        if (u.ManagerId != null)
            MoOwnerIdToManagerId.put(u.Id, u.ManagerId);
    }
    //Retrieve and create list of Opportunity and Booth objects
    List<Opportunity> LoOpty = [Select Id, Name, Job_Number__c, Show_Name__r.Name, Show_Name__r.Show_ID__c From Opportunity Where Id In :SoOptyId];
    List<Oracle_Show_Booth__c> LoBooth = [Select Id, Name, Account__r.Name, Account__r.Oracle_AR_Cust_Number__c, Show_Occurrence__r.Name, Show_Occurrence__r.Job_Number__c, Show_Occurrence__r.Show_Name__r.Show_ID__c  From Oracle_Show_Booth__c Where Id In :SoBoothId];
    List<Contact> LoContact = [Select Id, Name, AccountId, Account.Name From Contact Where Id In :SoContactId];
    List<Account> LoAccount = [Select Id, Name From Account Where Id In :SoAccountId];
    
    //Retrieve list of open task count grouped by case id
    List<AggregateResult> LoOpenTaskResults = new List<AggregateResult>();
    
    if (Trigger.isUpdate)
        LoOpenTaskResults = [Select WhatId CaseId, Count(Id) Cnt From Task  Where Status != 'Completed' And WhatId In :Trigger.newMap.keySet() Group By WhatId];
    
    /***** START: CODE FOR CASE COMMENT REQUIREMENT *****/
    
    //Retrieve list of case comments grouped by case id
    List<AggregateResult> LoCaseCommentResults = new List<AggregateResult>();
    
    if (Trigger.isUpdate)    
        LoCaseCommentResults = [Select ParentId CaseId, Count(Id) Cnt From CaseComment Where ParentId In :Trigger.newMap.keySet() Group By ParentId];
    
    /***** END: CODE FOR CASE COMMENT REQUIREMENT  *****/
    
    //Again, create maps of OptyId and BoothId to their respective
    //objects to use them later to retrieve values for other fields
    //from these objects.
    Map<Id, Opportunity> MoOpty = new Map<Id, Opportunity>();
    Map<Id, Oracle_Show_Booth__c> MoBooth = new Map<Id, Oracle_Show_Booth__c>();
    Map<Id, Contact> MoContact = new Map<Id, Contact>();
    Map<Id, Account> MoAccount = new Map<Id, Account>();
        
    for(Opportunity o : LoOpty)
        MoOpty.put(o.Id, o);
        
    for(Oracle_Show_Booth__c b : LoBooth)
        MoBooth.put(b.Id, b);
        
    for(Contact con : LoContact)
        MoContact.put(con.Id, con);
        
    for(Account a : LoAccount)
        MoAccount.put(a.Id, a);
        
    //Variables to get count of Open Tasks
    Map<Id,Integer> MoCaseIdToOpenTaskCount = new Map<Id, Integer>();
    for(AggregateResult r : LoOpenTaskResults)
        MoCaseIdToOpenTaskCount.put((Id)r.get('CaseId'), (Integer)r.get('Cnt'));
        
    /***** START: CODE FOR CASE COMMENT REQUIREMENT  *****/
    
    //Variables to get count of Case Comments
    Map<Id,Integer> MoCaseIdToCaseCommentCount = new Map<Id, Integer>();
    
    if (LoCaseCommentResults != null && LoCaseCommentResults.size() > 0)
    {
        for(AggregateResult r : LoCaseCommentResults)
            MoCaseIdToCaseCommentCount.put((Id)r.get('CaseId'), (Integer)r.get('Cnt'));
    }
    
    /***** END: CODE FOR CASE COMMENT REQUIREMENT  *****/
            
    for(Case c : Trigger.New)
    {            
        string ShowGESId = '';
        string ProjectNumber = '';
        string CustomerName = '';
        string CustomerId = null;
        string OpportunityId = null;
        string ShowId = null;
        string ContactAccountId = null;
        string ContactAccountName = null;
        string AccountName = null;
        
        if (c.AccountId != null)
        {
            Account Acc = MoAccount.get(c.AccountId);
            
            if (Acc != null)
                AccountName = Acc.Name;
            else
                System.debug('TrgBeforeInsertUpdateCase: AccountId not found in MoAccount list for Case #: ' + c.CaseNumber + ' and AccountId: ' + c.AccountId);
        }
        else
        {
            System.debug('TrgBeforeInsertUpdateCase: AccountId field is blank on case, Case #: ' + c.CaseNumber + '.');
        }
                    
        //Set Case manager
        Id ManagerId = MoOwnerIdToManagerId.get(c.OwnerId);
        
        if (ManagerId != null)
            c.Owner_Manager__c = ManagerId;
        else
            c.Owner_Manager__c = null;
            
        //Update field report on contact status goal of contacting customers within 48 hours
        if (c.Status != 'Closed' && c.Contact_Status__c != null && c.Contact_Status__c != '' && c.Age__c <= 2 && c.Met_2_Day_Contact_Goal__c == 0)
            c.Met_2_Day_Contact_Goal__c = 1;
        else if (c.Status == 'Closed' && c.Age__c <= 2 && c.Contact_Status__c != null && c.Contact_Status__c != '' 
            && (c.Met_2_Day_Contact_Goal__c == null || c.Met_2_Day_Contact_Goal__c == 0))
            c.Met_2_Day_Contact_Goal__c = 1;
        
        //If Opportunity is selected, then retrive the ProjectNumber and
        //ShowId for the Opportunity.
        //NOTE: If Booth is also selected, these variables will be reset
        //to be based of the Booth.
        if (c.Show_Opportunity__c != null)
        {
            Opportunity o = MoOpty.get(c.Show_Opportunity__c);
            
            if (o != null)
            {
                ShowId = o.Show_Name__c;
                OpportunityId = c.Show_Opportunity__c;
                ProjectNumber = o.Job_Number__c;
                
                if (o.Show_Name__r != null)
                    ShowGESId = o.Show_Name__r.Show_ID__c;
            }
        }
        
        //If Booth is selected, then retrive the CustomerName from the 
        //Booth and ProjectNumber & ShowId from the related Opportunity.
        if (c.Booth__c != null)
        {
            Oracle_Show_Booth__c b = MoBooth.get(c.Booth__c);
            
            if (b != null)
            {
                CustomerId = b.Account__c;
                OpportunityId = b.Show_Occurrence__c;
                
                if (b.Account__r != null)
                    CustomerName = b.Account__r.Name;
                
                if (b.Show_Occurrence__r !=  null)
                {
                    ShowId = b.Show_Occurrence__r.Show_Name__c;
                    ProjectNumber = b.Show_Occurrence__r.Job_Number__c;
                    
                    if (b.Show_Occurrence__r.Show_Name__r != null)
                        ShowGESId = b.Show_Occurrence__r.Show_Name__r.Show_ID__c;
                }
            }           
        }
        
        //If ShowId is still null, meaning neither a booth nor an opportunity
        //has been selected, then check if user has selected a Show using the
        //lookup. If yes, then honor, user's selection
        if (ShowId == null)
            ShowId = c.Show_Name__c;
        
        if (c.ContactId != null)
        {
            Contact Con = MoContact.get(c.ContactId);
            ContactAccountId = Con.AccountId;
            ContactAccountName = Con.Account.Name;
        }
        
        //If Customer was never selected, most likely in the scenario during
        //insert when user selects only Show Opportunity, set the AccountId and the
        //Customer_Name__c free-form text field.
        if (c.AccountId == null && CustomerId != null)
        {           
            c.AccountId = CustomerId;
            c.Customer_Name__c = CustomerName;
        }
        //This condition will work when a Booth is selected (i.e it is not null) and
        //will occur when booth is created from:
        // 1. Booth Contact
        // 2. Booth
        // 3. Or When Booth is manually selected or changed
        //
        //When account on Booth is different from Account selected on Case, it means
        //user has selected a different account. In this case, the Customer_Name__c 
        //field should be same case Case Account (i.e. ignore the Account on Booth).
        //
        //NOTE: However, this logic should not be applied when the customer is generic
        //because for Generic Accounts the Customer Name field is not known and the
        //user must enter a value while creating a new case. This is enforced using
        //a validation rule on case object.
        //TODO: Perhaps this criteria does not require the condition on ContactAccountId
        //check and remove if applicable.
        else if (c.AccountId != null && ContactAccountId != null && c.Booth__c != null && AccountName != 'EXHIBITOR' && AccountName != 'NON-EXHIBITOR' )
        {
             //c.addError('c.AccountId: ' + c.AccountId + ' CustomerId: ' + CustomerId + ' Customer_Name__c: ' + c.Customer_Name__c + ' AccountName:' + AccountName + ' ContactAccountName: ' + ContactAccountName + ' CustomerName: ' + CustomerName);         
             if (c.AccountId == CustomerId) {
                c.Customer_Name__c = CustomerName;
             }
             else {
                c.Customer_Name__c = AccountName;
             }
        }
        //This condition will is satisfied when you create a booth via the Opportunity and select
        //an Account on case, but no Booth. In this case, Customer_Name__c should be set as the
        //Account Name, as long as the Account selected in not generic.
        //NOTE: CustomerId is null, only when Booth__c is null
        else if (c.AccountId != null && CustomerId == null && AccountName != 'EXHIBITOR' && AccountName != 'NON-EXHIBITOR')
        {
            c.Customer_Name__c = AccountName;
        }
        
        //Always update the Show Opportunity and Show Name to be same as the selected
        //booth
        c.Show_Opportunity__c = OpportunityId;
        c.Show_Name__c = ShowId;
        
        //Update the Subject field during both insert as well as update
        //based on latest selections
        // MW 8 Sept only do this for US based cases
        If(c.RecordTypeId == '0124000000019NQ')
        {
          c.Subject = ShowGESId + ' ' + ProjectNumber + ' ' + CustomerName;
        }
        
        //If it is an update, overwrite the relevant fields
        if (Trigger.isUpdate)
        {
            Case OldCase = Trigger.oldMap.get(c.Id);
            
            // If the priority changes from 'First Call Resolution' to any other priority
            // Date Committed is required.
            if (OldCase.Priority == 'First Call Resolution' && OldCase.Priority != c.Priority && c.Date_Committed__c == null)
            {
                c.addError('Date Committed is required.');
            }
            
            //If user selected another customer after the record was created, the Customer_Name__c
            //needs to be updated to the name of this customer.
            if (c.AccountId != OldCase.AccountId)
            {
                String OldCustomerName = MoCaseIdToOldCustomerName.get(c.Id);
                
                Account NewAccount = MoAccount.get(c.AccountId);
                String NewCustomerName = '';
                
                if (NewAccount != null)
                    NewCustomerName = NewAccount.name;
                
                if (NewCustomerName.toUpperCase() != 'EXHIBITOR' && NewCustomerName.toUpperCase() != 'NON-EXHIBITOR')
                    c.Customer_Name__c = NewCustomerName;
                else
                {
                    if (c.Customer_Name__c == null || c.Customer_Name__c == '' || OldCustomerName != 'PLEASE ENTER NAME')
                        c.Customer_Name__c = 'PLEASE ENTER NAME';
                }
            }
            
            //If Owner changed, update the Date_Assigned_To_Current_Owner__c field
            if (c.OwnerId != OldCase.OwnerId)
                c.Date_Assigned_To_Current_Owner__c = datetime.now();
        }
        
        if (c.Reason__c == 'Freight - Reroute' || c.Reason__c == 'Freight - Upgrade' || c.Escalated_To__c == '2 - Director' || c.Escalated_To__c == '1 - Senior Management')
            c.Severe__c = True;
            
        if (MoCaseIdToOpenTaskCount.get(c.Id) > 0 && c.Status == 'Closed')
            c.addError('This case has open tasks. All open tasks must be completed before Case close.');
            
        /***** TODO UNCOMMENT AFTER CONVERSION: START: CODE FOR CASE COMMENT REQUIREMENT *****/
        
        
        if (MoCaseIdToCaseCommentCount.get(c.Id) == null && c.Status == 'Closed' && c.EMEA_Onsite_Service_Request__c == FALSE)
            c.addError('This case has no case comment. At least one case comment is required before case close.');
        else {
            if (MoCaseIdToCaseCommentCount.get(c.Id) <= 0 && c.Status == 'Closed' && c.EMEA_Onsite_Service_Request__c == FALSE)
                c.addError('This case has no case comment. At least one case comment is required before case close.');
        }  
        
        
        /***** TODO UNCOMMENT AFTER CONVERSION: END: START: CODE FOR CASE COMMENT REQUIREMENT  *****/

        //Shyam Nair - 5/23/2018 - Logic added to update Last Survey Sent Date on related Contact
        if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
            Set<Id> contactSet = new Set<Id>();
            
            for(Case cs: Trigger.new){
                if(cs.Status == 'Closed' && cs.RecordTypeId == SObjectType.Case.getRecordTypeInfosByName().get('GES US Service').getRecordTypeId()){
                    contactSet.add(cs.ContactId);
                }
            }
            List<Contact> contactsToUpdate = new List<Contact>();
            if(!contactSet.isEmpty()){
                for(Contact contact :[SELECT Id, Last_Survey_Sent__c FROM Contact WHERE Id IN :contactSet]){
                    contact.Last_Survey_Sent__c = Date.Today();
                    contactsToUpdate.add(contact);
                }
            }

            if(!contactsToUpdate.isEmpty()){
                update contactsToUpdate;
            }
        }
        //End
    } 
    
    private static void updateCaseOwnerFromDelegate(List<Case> newList, Map<Id, Case> oldMap){
        for(Case c : newList){
            system.debug('inside updateCaseOwnerFromDelegate');
            Case oldCase = oldMap.get(c.Id);
            if(c.Reassign_To_Onsite_Owner__c == 'Approved' && oldCase.Reassign_To_Onsite_Owner__c != 'Approved'){
                c.OwnerId = c.Delegated_Owner__c;
                c.Reassign_To_Onsite_Owner__c = 'Done';
                c.Delegated_Owner__c = null;
            }
        }
    }
    
    //SFDC-258 - Mass Close Case List View Button addeed in Ligthing and restricting to close case if user not has Manage_Cases permission - 02/16/24 - Sajid
    public static void checkUserHasPermission(List<Case> newList, Map<Id, Case> oldMap){
        Boolean hasPermission = false;
        List<PermissionSet> ps = [select id,name from PermissionSet where name =: 'Manage_Cases' limit 1];
        if(!ps.isEmpty()){
            List<PermissionSetAssignment> psa = [select id from PermissionSetAssignment where AssigneeId =: userinfo.getuserid() and PermissionSetId =: ps.get(0).Id];
            hasPermission = !psa.isEmpty() ? true : false;
        }
        if(!hasPermission){
            Case c = newList.get(0);
            if(c.Is_Mass_Close_Case__c){
                c.addError('You do not have permission to close the case');
                return;
            }
        }else{
            for(Case c: newList){
                if(c.Is_Mass_Close_Case__c){
                    c.Is_Mass_Close_Case__c = false;  
                }
            }
        }
    }
}