/**
* @description : Test class for UpdateTotalDaysOnDaysAwayScheduler
**/
@isTest(seeAllData = false)
private with sharing class UpdateTotalDaysOnDaysAwaySchedulerTest {

	/**
	* @author       Thiyagarajan Selvaraj
	* @date         13/03/2018
	* @description  Method to test UpdateTotalDaysOnDaysAwayScheduler
	**/
	static testMethod void test_UpdateTotalDaysOnDaysAwayScheduler() {
		Test.startTest();
		String jobId = System.schedule('UpdateTotalDaysOnDaysAwayScheduler', '0 0 0 3 9 ? 2022',
		                               new UpdateTotalDaysOnDaysAwayScheduler());
		// Get the information from the CronTrigger API object
		CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
		// Verify the expressions are the same
		System.assertEquals('0 0 0 3 9 ? 2022', ct.CronExpression);
		// Verify the job has not run
		System.assertEquals(0, ct.TimesTriggered);
		Test.stopTest();
	}
}