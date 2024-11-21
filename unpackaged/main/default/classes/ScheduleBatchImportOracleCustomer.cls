global class ScheduleBatchImportOracleCustomer implements schedulable {

    global void execute(SchedulableContext sc) {
               
        BatchImportOracleCustomer ImportCustomer = new BatchImportOracleCustomer();
        ImportCustomer.query = 'Select s.Interface_Status__c, s.Interface_Process_Attempts__c, s.Interface_Error_Message__c, s.Interface_Batch_Number__c, s.Id, s.AR_CUST_STATUS__c, s.AR_CUST_LAST_UPDATE_DATE__c, s.AR_CUST_CREATION_DATE__c, s.AR_CUST_ACCOUNT_ID__c, s.AR_CUSTOMER_NAME__c, s.AR_CUSTOMER_DUNS_NUMBER__c, s.AR_CUSTOMER_NUMBER__c, s.AR_ADDR_CUST_ACCT_SITE_ID__c, s.AR_ADDR_CUST_SITE_STATUS__c, s.AR_ADDR_CUST_SITE_CREATION_DATE__c, s.AR_ADDR_CUST_SITE_LAST_UPDATE_DATE__c, s.AR_CUSTOMER_ADDRESS1__c, s.AR_CUSTOMER_ADDRESS2__c, s.AR_CUSTOMER_ADDRESS3__c, s.AR_CUSTOMER_ADDRESS4__c, s.AR_CUSTOMER_CITY__c, s.AR_CUSTOMER_STATE__c, s.AR_CUSTOMER_PROVINCE__c, s.AR_CUSTOMER_POSTAL_CODE__c, s.AR_CUSTOMER_COUNTRY__c, s.AR_ADDR_PARTY_SITE_LOC_ID__c, s.AR_ADDR_PARTY_SITE_LOC_CREATION_DATE__c, s.AR_ADDR_PARTY_SITE_LOC_LAST_UPDATE_DATE__c, s.AR_ADDR_CUST_SITE_USE_STATUS__c, s.AR_ADDR_CUST_SITE_USE_PRIMARY_FLAG__c,  s.AR_ADDR_CUST_SITE_USE_CREATION_DATE__c, s.AR_ADDR_CUST_SITE_USE_LAST_UPDATE_DATE__c From Staging_Oracle_AR_Customer__c s Where s.Interface_Status__c = \'New\'';
        Database.executeBatch(ImportCustomer);

    }
}