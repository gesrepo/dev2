global class WeeklyOrderSummaryNotSch implements Schedulable 
{
   global void execute(SchedulableContext ctx) 
   {
        database.executeBatch(new WeeklyOrderSummaryNotification(),200);
   }   
}