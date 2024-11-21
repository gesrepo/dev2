global class ScheduleBatchImportOracleShowBooth implements schedulable {

    global void execute(SchedulableContext sc) {
               
        BatchImportOracleShowBooth ImportShowBooth = new BatchImportOracleShowBooth();
        ImportShowBooth.query = 'Select s.ZONE__c, s.THIRD_PARTY_FLAG__c, s.SystemModstamp, s.SHOW_ORG_FLAG__c, s.SHOW_OCCR_ID__c, s.SHOW_OCCR_CUST_ID__c, s.SHOW_ID__c, s.SERVICE_ZONE__c, s.PROJECT_NUMBER__c, s.PROJECT_NAME__c, s.OwnerId, s.Name, s.MASTER_FACILITY_HEADER_ID__c, s.LastModifiedDate, s.LastModifiedById, s.IsDeleted, s.Interface_Status__c, s.Interface_Process_Attempts__c, s.Interface_Error_Message__c, s.Interface_Batch_Number__c, s.Id, s.INVOICE_HOLD_FLAG__c, s.INACTIVE_FLAG__c, s.FACILITY_ID__c, s.FACILITY_HEADER_ID__c, s.EXHIBITOR_STATUS5__c, s.EXHIBITOR_STATUS4__c, s.EXHIBITOR_STATUS3__c, s.EXHIBITOR_STATUS2__c, s.EXHIBITOR_STATUS1__c, s.EXHIBITOR_FLAG__c, s.EVENT_CITY__c, s.ED_FLAG__c, s.CurrencyIsoCode, s.CreatedDate, s.CreatedById, s.CUST_ACCOUNT_ID__c, s.CUSTOMER_NAME__c, s.BOOTH_WIDTH__c, s.BOOTH_TYPE__c, s.BOOTH_SIZE__c, s.BOOTH_SHARED_FLAG__c, s.BOOTH_NUMBER__c, s.BOOTH_LENGTH__c, s.BOOTH_LAST_UPDATE_DATE__c, s.BOOTH_ID__c, s.BOOTH_CREATION_DATE__c From Staging_Oracle_Show_Booth__c s Where s.Interface_Status__c In (\'New\')';
        Database.executeBatch(ImportShowBooth);
        
    }
}