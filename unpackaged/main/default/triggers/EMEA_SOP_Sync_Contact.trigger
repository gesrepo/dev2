trigger EMEA_SOP_Sync_Contact on Contact (before insert, before update, after insert, after update) {

   //Desc:  Below code to avoid trigger execute during the merge of account from Demand tool
    // Date: 25-May-2017
    // Added By : Kumud 
    
    if(Userinfo.getProfileID()==Label.MergeSystemAdminId){
      
        return;
    }
    
    //End here
   
   
    if (Trigger.isBefore) {
    
        for(Contact cnt : Trigger.New)
        {
            if (Trigger.isInsert) {
                cnt.SOP_Sync__c = false;
            } else {
                Contact cnt2 = Trigger.oldMap.get(cnt.Id);
                if (cnt2.SOP_Sync__c == true) {
                    cnt.SOP_Sync__c = false;
                }
            }
        }
    
    } else {
    
        //system.debug('In trigger');
        if(system.isFuture() || system.isBatch()) return;
        
        /*for(Contact cnt : Trigger.New)
        {
            // it must be linked to an account
            if(cnt.AccountId != null)
            {   
                // We have to find the loaded account first and make sure it is valid
                Account acct = [SELECT EMEA__c, EMEA_Finance_Approved__c, Name FROM Account WHERE Id = : cnt.AccountId];
    
                system.debug('Account selected was ' + acct.Name + ', id was ' + cnt.AccountId);
                    
                // we only want to sync contacts linked to a valid EMEA Account
                if(acct.EMEA__c == True && acct.EMEA_Finance_Approved__c == True)
                {
                    system.debug('EMEA flag on account was ' + acct.EMEA__c);
                    string upsertResult;
                    
                    SOP_VIAD_V2.SalesforceUpsertContactRequest upsertRequest = new SOP_VIAD_V2.SalesforceUpsertContactRequest();
                    
                    //Contact Details
                    upsertRequest.CustomerSalesforceID = acct.id;
                    upsertRequest.DOB = cnt.Birthdate;
                    upsertRequest.Forename = cnt.FirstName;
                    upsertRequest.Surname = cnt.LastName;
                    upsertRequest.Title = cnt.Salutation;
                    upsertRequest.RoleDescription = cnt.Title;
                    upsertRequest.Email = cnt.Email;
                    upsertRequest.Fax = cnt.fax;
                    upsertRequest.Mobile = cnt.MobilePhone;
                    upsertRequest.DaytimeTel = cnt.Phone;
                    upsertRequest.RoleXmlData = cnt.Contact_Type__c; 
                    
                    // Other values
                    upsertRequest.Created = cnt.CreatedDate;
                    upsertRequest.Updated = cnt.LastModifiedDate;
                    
                    // SOP Defaults
                    upsertRequest.AssociationType = 'IO';   
                    upsertRequest.ExpiredDate = DateTime.valueof('2100-01-01 00:00:00');
                    upsertRequest.IsDeleted = False;
                    upsertRequest.IsDuplicate = False;
                    upsertRequest.OwnerID = 69; // hard coded value for SOP
                    upsertRequest.RolePriority = 5; // hard coded value for SOP
                    upsertRequest.RoleType = 1;
                    upsertRequest.SalesforceID = cnt.Id;
                    
                    // We have to serialise this first though
                    system.debug('About to serialise');
                    
                    string upsertSerialisedRequest = JSON.serialize(upsertRequest);
                    //system.debug('trigger upsert contact');
                    
                    SOP_UpsertWrapper.UpsertContact(upsertSerialisedRequest);
                }    
            }
        }*/

        List<Contact> contacts = [SELECT Id,Birthdate,FirstName,LastName,Salutation,Title,Email,Fax,
        MobilePhone,Phone,Contact_Type__c,CreatedDate,LastModifiedDate,AccountId,Account.Name,
        Account.EMEA__c,Account.EMEA_Finance_Approved__c FROM Contact WHERE Id IN: Trigger.new];

        if(!contacts.isEmpty()){
            String[] upsertSerialisedRequest = new List<String>();
            for(Contact cnt :contacts){
                if(cnt.Account.EMEA__c && cnt.Account.EMEA_Finance_Approved__c && cnt.Email != null && cnt.Email != ''){
                    system.debug('EMEA flag on account was ' + cnt.Account.EMEA__c);
                    SOP_VIAD_V2.SalesforceUpsertContactRequest upsertRequest = new SOP_VIAD_V2.SalesforceUpsertContactRequest();
                    
                    //Contact Details
                    upsertRequest.CustomerSalesforceID = cnt.AccountId;
                    upsertRequest.DOB = cnt.Birthdate;
                    upsertRequest.Forename = cnt.FirstName;
                    upsertRequest.Surname = cnt.LastName;
                    upsertRequest.Title = cnt.Salutation;
                    upsertRequest.RoleDescription = cnt.Title;
                    upsertRequest.Email = cnt.Email;
                    upsertRequest.Fax = cnt.fax;
                    upsertRequest.Mobile = cnt.MobilePhone;
                    upsertRequest.DaytimeTel = cnt.Phone;
                    upsertRequest.RoleXmlData = cnt.Contact_Type__c; 
                    
                    // Other values
                    upsertRequest.Created = cnt.CreatedDate;
                    upsertRequest.Updated = cnt.LastModifiedDate;
                    
                    // SOP Defaults
                    upsertRequest.AssociationType = 'IO';   
                    upsertRequest.ExpiredDate = DateTime.valueof('2100-01-01 00:00:00');
                    upsertRequest.IsDeleted = False;
                    upsertRequest.IsDuplicate = False;
                    upsertRequest.OwnerID = 69; // hard coded value for SOP
                    upsertRequest.RolePriority = 5; // hard coded value for SOP
                    upsertRequest.RoleType = 1;
                    upsertRequest.SalesforceID = cnt.Id;
                    
                    // We have to serialise this first though
                    system.debug('About to serialise');
                    
                    upsertSerialisedRequest.add(JSON.serialize(upsertRequest));
                    //system.debug('trigger upsert contact');
                    
                }
            }

            if(!upsertSerialisedRequest.isEmpty()){
                SOP_UpsertWrapper.UpsertContact(upsertSerialisedRequest);
            }
            
        }
    }
}