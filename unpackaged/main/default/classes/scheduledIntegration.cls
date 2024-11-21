global class scheduledIntegration implements Schedulable{
    global void execute(SchedulableContext sc) {
        BatchableIntegration a = new BatchableIntegration();
        if(!Test.isRunningTest()){
           database.executebatch(a,1);        
        }
        
    }
}