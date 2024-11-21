public class SOP_UpsertWrapper_Batch_Contact implements Database.Batchable<sObject>, Database.AllowsCallouts {

    public Database.QueryLocator start(Database.BatchableContext BC){
        /*return Database.getQueryLocator('SELECT Id, AccountId, Birthdate, FirstName, LastName, Salutation, Title, Email, ' +
                                                'Fax, MobilePhone, Phone, CreatedDate, LastModifiedDate ' +
                                             'FROM Contact WHERE SOP_Sync__c = false AND AccountId != null ' +
                                             'AND Account.EMEA__c = true AND Account.EMEA_Finance_Approved__c = true');*/
        return Database.getQueryLocator('SELECT Id,AccountId,Birthdate,FirstName,LastName,Salutation,Title,Email,'
                                        +'Fax,MobilePhone,Phone,CreatedDate,LastModifiedDate,'
                                        +'Account.EMEA__c,Account.EMEA_Finance_Approved__c,Account.Name '
                                        +'FROM Contact WHERE AccountId != NULL AND SOP_Sync__c = False '
                                        +'AND Account.EMEA__c = True AND Account.EMEA_Finance_Approved__c = True '
                                        + 'AND Email != null AND Email != \'\' ');
    }
   
    public void execute(Database.BatchableContext BC, List<Contact> scope){
        if(!scope.isEmpty() && scope[0] != null){
            String[] upsertSerialisedRequest = new List<String>();
            List<Contact> contactsToUpdate = new List<Contact>();
            for(Contact cnt :scope){
                if(cnt.Account.EMEA__c && cnt.Account.EMEA_Finance_Approved__c){
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
                    
                    cnt.SOP_Sync__c = True;
                    contactsToUpdate.add(cnt);
                }
            }

            if(!upsertSerialisedRequest.isEmpty()){
                SOP_UpsertWrapper.UpsertContactNoFuture(upsertSerialisedRequest);
            }

            if(!contactsToUpdate.isEmpty()){
                update contactsToUpdate;
            }
        }
        /*for (Contact cnt : scope) {
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
                    
                    SOP_UpsertWrapper.UpsertContactNoFuture(upsertSerialisedRequest);
                }    
            }
            cnt.SOP_Sync__c = true;
            try {
                update cnt;
            } catch (Exception ex) {}
        }*/

    }

    public void finish(Database.BatchableContext BC){
        
    }
    
}