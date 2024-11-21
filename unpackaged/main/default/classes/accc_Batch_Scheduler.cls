global class accc_Batch_Scheduler implements Schedulable { 
   global void execute(SchedulableContext SC) { 
   acccValidatePatmentBatch a = new acccValidatePatmentBatch();
      database.executebatch(a,1);
   } 
}