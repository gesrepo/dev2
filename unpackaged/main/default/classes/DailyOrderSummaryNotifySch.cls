global class DailyOrderSummaryNotifySch implements Schedulable 
{
   global void execute(SchedulableContext ctx) 
   {
        database.executeBatch(new DailyOrderSummaryNotification(),200);
   }   
}