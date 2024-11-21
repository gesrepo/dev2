global class ScheduleBatchImportOracleBoothContact implements schedulable {

    global void execute(SchedulableContext sc) {
               
        BatchImportOracleShowBoothContact ImportShowBoothContact = new BatchImportOracleShowBoothContact();
        ImportShowBoothContact.query = 'Select SystemModstamp, SHOW_OCCR_CUST_ID__c, PRIMARY_FLAG__c, PHONE__c, OwnerId, Name, LastModifiedDate, LastModifiedById, LAST_UPDATE_DATE__c, LAST_NAME__c, IsDeleted, Interface_Status__c, Interface_Process_Attempts__c, Interface_Error_Message__c, Interface_Batch_Number__c, Id, FIRST_NAME__c, FAX__c, EXTENSION__c, EMAIL_ADDRESS__c, CurrencyIsoCode, CreatedDate, CreatedById, CUST_CONT_ID__c, CUST_BTH_ID__c, CREATION_DATE__c, COUNTRY_CODE__c, CONTACT_TYPE__c, CONTACT_ROLE__c, AREA_CODE__c, SHOW_ID__c, BOOTH_NUMBER__c, CUSTOMER_NAME__c From Staging_Oracle_Show_Booth_Contact__c Where Interface_Status__c In (\'New\')';
        Database.executeBatch(ImportShowBoothContact);
    }
}