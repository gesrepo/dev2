trigger EMEA_SOP_Sync_Account on Account (before insert, before update, after insert, after update) 
{
    
    system.debug('user profile id: ' + Userinfo.getProfileID());
    system.debug('Sys Admin profile id: ' + Label.System_Administrator_Profile_ID);

    if(Userinfo.getProfileID()==Label.MergeSystemAdminId || Userinfo.getProfileID()==Label.System_Administrator_Profile_ID){
        system.debug('trigger skipped');
        return;
    }
    
    private String sopInstance;

    if (Trigger.isBefore) {
    
        for(Account acct : Trigger.New)
        {
            if (Trigger.isInsert) {
                acct.SOP_Sync__c = false;
            } else {
                Account acct2 = Trigger.oldMap.get(acct.Id);
                if (acct2.SOP_Sync__c == true) {
                    acct.SOP_Sync__c = false;
                }
            }
        }
    
    } else {
        
        system.debug('trigger executing');
        if(system.isFuture() || system.isBatch()) 
            return;
        
        for(Account acct : Trigger.New)
        {
            //If Account.EMEA is true and is approved by finance, call the SOP service
            //EMEA_Finance_Approved__c  is automatically set for all except Firm and Contractor via a field update
            if(acct.EMEA__c == True && acct.EMEA_Finance_Approved__c == True && acct.BillingCountry != null && acct.BillingCountry != '' )
                
                {
                    system.debug('emea and finance check passed, about to call upsert org');
                    SOP_VIAD_V2.SalesforceUpsertOrganisationResult upsertResult; // = new SOP_VIAD_V2.SalesforceUpsertOrganisationResult();    
                    SOP_VIAD_V2.SalesforceUpsertOrganisationRequest upsertRequest  = new SOP_VIAD_V2.SalesforceUpsertOrganisationRequest();
                        
                    // set the organisation information
                    upsertRequest.OrgName = acct.Name;
                    upsertRequest.Country = acct.BillingCountry;
                    upsertRequest.Department = acct.Department__c; 
                    upsertRequest.CustCategory = acct.Cust_Type__c; // This is 99 for exhibitor etc
                    upsertRequest.OrgType = (integer) acct.Business_Type_Numerical_Value__c; // 1, 2 or 3
                    upsertRequest.SalesforceID = acct.id;
                    upsertRequest.NonVatable = acct.Tax__c;
                    upsertRequest.VatNumber = acct.Vat_Number__c;
                
                    // set the billing address details
                    upsertRequest.AddressLine1 = acct.BillingStreet;
                    upsertRequest.AddressLine2 = '';
                    upsertRequest.AddressLine3 = '';
                    upsertRequest.AddressLine4 = '';
                    upsertRequest.Town = acct.BillingCity;
                    upsertRequest.Postcode = acct.BillingPostalCode;
                    upsertRequest.County = acct.BillingState;
                    upsertRequest.Country = acct.BillingCountry;
                    upsertRequest.HouseNumber = '';
                    upsertRequest.AltOrgName1 = acct.Alternative_Org_Name_1__c;
                    upsertRequest.AltOrgName2 = acct.Alternative_Org_Name_2__c;
                    upsertRequest.AltOrgName3 = acct.Alternative_Org_Name_3__c;
                
                    //some defaults we have to set
                    upsertRequest.IsDeleted = False;
                    upsertRequest.IsDuplicate = False;
                    upsertRequest.OwnerID = 69; // hard coded value for SOP
                    
                    // set other defaults
                    upsertRequest.Created = acct.CreatedDate;
                    upsertRequest.Updated = acct.LastModifiedDate;
                    
                    //public String OrgNotes;
                    
                    string upsertSerialisedRequest = JSON.serialize(upsertRequest);
                    
                    system.debug(upsertSerialisedRequest);
                    SOP_UpsertWrapper.UpsertOrganisation(upsertSerialisedRequest);
                }
        }
    }
}