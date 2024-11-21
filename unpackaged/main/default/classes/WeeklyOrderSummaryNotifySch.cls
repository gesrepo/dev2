global class WeeklyOrderSummaryNotifySch implements Schedulable 
{
   global void execute(SchedulableContext ctx) 
   {
        database.executeBatch(new WeeklyOrdSummaryActiveNotify(),200);
   }   
}