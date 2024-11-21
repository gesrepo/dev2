global class WeeklyOrderTaskSummaryEmailSch implements Schedulable 
{
   global void execute(SchedulableContext ctx) 
   {
        database.executeBatch(new WeeklyOrderTaskSummaryEmailNotification(),200);
   }   
}