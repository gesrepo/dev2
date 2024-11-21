global class GC_ShowOnTheGoRecordRemover_Scheduler implements Schedulable { 
   global void execute(SchedulableContext SC) { 
   GC_ShowOnTheGoRecordRemover remover = new GC_ShowOnTheGoRecordRemover();
      database.executebatch(remover,1);
   } 
}