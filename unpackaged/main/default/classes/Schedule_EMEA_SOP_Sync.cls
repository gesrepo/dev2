global class Schedule_EMEA_SOP_Sync implements Schedulable {

    global void execute(SchedulableContext SC) {
      
        integer accCnt = [SELECT COUNT() FROM AsyncApexJob WHERE ApexClass.Name = 'SOP_UpsertWrapper_Batch_Account' AND (Status = 'Holding' OR Status = 'Queued' OR Status = 'Preparing' OR Status = 'Processing')];
        if (accCnt == 0) {
            Database.executeBatch(new SOP_UpsertWrapper_Batch_Account(), 1);
        }
        
        integer cntCnt = [SELECT COUNT() FROM AsyncApexJob WHERE ApexClass.Name = 'SOP_UpsertWrapper_Batch_Contact' AND (Status = 'Holding' OR Status = 'Queued' OR Status = 'Preparing' OR Status = 'Processing')];
        if (cntCnt == 0) {
            Database.executeBatch(new SOP_UpsertWrapper_Batch_Contact(), 1);
        }

   }
   
}