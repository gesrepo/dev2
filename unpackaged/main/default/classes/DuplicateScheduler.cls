public with sharing class DuplicateScheduler implements Schedulable
{
    public void execute(SchedulableContext ctx) 
    {
        Database.executeBatch(new DuplicateContactIdentifyBatch()); 
    }
}