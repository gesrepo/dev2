global class ScheduleDuplicateContactIdentifyBatch implements Schedulable {
    
    global void execute(SchedulableContext SC) {
      
        DuplicateContactIdentifyBatchWOstate batch = new DuplicateContactIdentifyBatchWOstate();
        Database.executeBatch(batch,2000);
    }
}