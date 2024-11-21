global class GC_OpportunityToShowBatch implements Database.Batchable<sObject> {

    global final String query;

    global GC_OpportunityToShowBatch(String q) {
        query = q;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        GC_OpportunityTriggerHandler.HandleOpps(scope);
    }

    global void finish(Database.BatchableContext BC) {
        AsyncApexJob a = [SELECT Id,
                          Status, NumberOfErrors, JobItemsProcessed,
                          TotalJobItems, CreatedById, CreatedBy.Email
                          FROM AsyncApexJob WHERE Id = :BC.getJobId()];

        // Send an email to the Apex job's submitter
        //   notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTargetObjectId(a.CreatedById);
        mail.setSubject('Show to Copy Status: ' + a.Status);
        mail.setPlainTextBody
        ('The batch Apex job processed ' + a.TotalJobItems +
         ' batches with ' + a.NumberOfErrors + ' failures.');
        mail.setSaveAsActivity(false);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

}