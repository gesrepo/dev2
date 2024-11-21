/**
* @description : Batchable class for days away
**/
public class UpdateTotalDaysOnDaysAwayBatch implements Database.Batchable<sObject> {

	private String query;

	/**
	* @description : Constructor
	**/
	public UpdateTotalDaysOnDaysAwayBatch() {
		this.query = 'SELECT Id, Start_of_Time_Tracking__c, Total_Days_In_State__c FROM Days_Away__c WHERE Start_of_Time_Tracking__c != null LIMIT 50000000';
	}

	/**
	* @description : batch start method
	* @param : Inherit batchable context
	**/
	public Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

	/**
	* @description : batch execute method
	* @param : Inherit batchable context
	* @param : Days away scope
	**/
	public void execute(Database.BatchableContext BC, List<sObject> scope) {
		List<Days_Away__c> daysAwayList = (List<Days_Away__c>)scope;
		for (Days_Away__c daysAway : daysAwayList) {
			daysAway.Total_Days_In_State__c = daysAway.Start_of_Time_Tracking__c.daysBetween(System.today());
		}
		try {
			update daysAwayList;
		} catch (Exception ex) {}
	}

	/**
	* @description : batch finish method
	**/
	public void finish(Database.BatchableContext BC) {

	}

}