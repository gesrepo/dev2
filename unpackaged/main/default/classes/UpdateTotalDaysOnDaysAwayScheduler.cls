global class UpdateTotalDaysOnDaysAwayScheduler implements Schedulable {
   
    /*
	* @description : Schdule method
	*/ 
   	global void execute(SchedulableContext sc) {
      	Database.executeBatch(new UpdateTotalDaysOnDaysAwayBatch());
   	}
}