global class ScheduleBatchPurgeOracleStgSwBthContacts implements schedulable {

    global void execute(SchedulableContext sc) {
        BatchPurgeOracleStagingObjects PurgeShowBoothContactsBatch = new BatchPurgeOracleStagingObjects();
        PurgeShowBoothContactsBatch.query = 'Select Id From Staging_Oracle_Show_Booth_Contact__c Where (CreatedDate < LAST_N_DAYS:60 And Interface_Status__c Not In (\'New\')) or (CreatedDate < LAST_N_DAYS:15 And Interface_Status__c != \'New\' And (Not Interface_Status__c Like \'*F*\'))';
        Database.executeBatch(PurgeShowBoothContactsBatch);
    }
}