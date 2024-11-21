/**
* @author Ethos Solutions
* @version 1.0
* @description Syncs the Opportunity with the Schedule
*
* 2016-12-09 : Ethos Solutions - Original
**/
global class GC_ShowSync implements Schedulable {
    global void execute(SchedulableContext sc) {
        String yesterdayFormatted = DateTime.now().addDays(-1).formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        System.debug(loggingLevel.Error, '*** yesterdayFormatted: ' + yesterdayFormatted);
        String query = 'select Id, Name, Show_Close_Date__c, Show_Name__r.Name, Job_Number__c, Amount, RecordType.Name, RecordType_Name__c, Facility__r.Name, Facility_City__c from Opportunity where Job_Number__c != null AND LastModifiedDate >= ' + yesterdayFormatted + ' order by Show_Close_Date__c desc limit 50000';
        try {
            GC_OpportunityToShowBatch batchProcess = new GC_OpportunityToShowBatch(query);
            Database.executeBatch(batchProcess);
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
    }
}