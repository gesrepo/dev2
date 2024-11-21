global class deleteSpamCases implements Database.Batchable<sObject>, Schedulable {
    
    public void execute(SchedulableContext sc){
        Database.executeBatch(new deleteSpamCases());
    }
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'select id from Case where Owner.Name = \'SPAM\' AND Age__c >';
        query+=System.Label.Age_Weekdays;
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc,List<Case> records){
        delete records;
    }
    
    public void finish(Database.BatchableContext bc){}
}