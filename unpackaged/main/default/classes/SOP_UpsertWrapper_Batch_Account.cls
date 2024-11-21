public class SOP_UpsertWrapper_Batch_Account implements Database.Batchable<sObject>, Database.AllowsCallouts {

    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('SELECT Id, Name, EMEA__c, EMEA_Finance_Approved__c, BillingCountry, Department__c, Cust_Type__c, ' +
                                                  'Business_Type_Numerical_Value__c, Tax__c, Vat_Number__c, BillingStreet, BillingCity, ' +
                                                  'BillingPostalCode, BillingState, Alternative_Org_Name_1__c, Alternative_Org_Name_2__c, ' +
                                                  'Alternative_Org_Name_3__c, CreatedDate, LastModifiedDate ' +
                                             'FROM Account WHERE SOP_Sync__c = false AND EMEA__c = true AND EMEA_Finance_Approved__c = true AND BillingCountry != null AND BillingCountry != \'\'');
    }
   
    public void execute(Database.BatchableContext BC, List<Account> scope){
        for (Account acct : scope) {
            //If Account.EMEA is true and is approved by finance, call the SOP service
            //EMEA_Finance_Approved__c  is automatically set for all except Firm and Contractor via a field update
            if(acct.EMEA__c == True && acct.EMEA_Finance_Approved__c == True)
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
                SOP_UpsertWrapper.UpsertOrganisationNoFuture(upsertSerialisedRequest);
            }
            acct.SOP_Sync__c = true;
            update acct;
        }
    }

    public void finish(Database.BatchableContext BC){
        
    }
}