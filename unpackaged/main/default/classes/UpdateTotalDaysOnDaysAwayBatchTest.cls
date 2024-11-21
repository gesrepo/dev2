/**
* @description : Test class for UpdateTotalDaysOnDaysAwayBatch
**/
@isTest(seeAllData = false)
private with sharing class UpdateTotalDaysOnDaysAwayBatchTest {

	/**
	* @author       Thiyagarajan Selvaraj
	* @date         13/03/2018
	* @description  Method to set up test data
	**/
	@testSetup
	private static void setupTestData() {
		// create account
		List<Account> accountsList = TestDataCreator.createAccounts(1);

		// create clients
		List<Claims__Client__c> clientsList = TestDataCreator.createClients(accountsList);

		// create policy types
		List<Claims__Policy_Type__c> policyTypesList = TestDataCreator.createPolicyTypes(1);

		// create policies
		List<Claims__Policy__c> policiesList =
		    TestDataCreator.createPolicies(clientsList, policyTypesList);

		// create cover type setup
		List<Claims__Cover_Type_Setup__c> coverTypeSetupList =
		    TestDataCreator.createCoverTypeSetUpList(policyTypesList);

		// Create policy detail
		List<Claims__Policy_Detail__c> coverTypesList =
		    TestDataCreator.createCoverTypesList(policiesList, coverTypeSetupList);

		// Create Claims
		List<Claims__Claim__c> claimsList =
		    TestDataCreator.createClaims(1, clientsList[0].Id, coverTypesList[0].Id, null);

		// Create days away
		List<Days_Away__c> daysAwayList = TestDataCreator.createDaysAway(1, new Set<Id> {claimsList[0].Id});
	}


	/**
	* @author       Thiyagarajan Selvaraj
	* @date         13/03/2018
	* @description  Method to test UpdateTotalDaysOnDaysAwayBatch
	**/
	static testMethod void test_UpdateTotalDaysOnDaysAwayBatch() {
		Test.startTest();
		// Before calling batch
		System.assertEquals(null, [SELECT Total_Days_In_State__c FROM Days_Away__c LIMIT 1].Total_Days_In_State__c);
		Database.executeBatch(new UpdateTotalDaysOnDaysAwayBatch());
		Test.stopTest();
		// after calling batch
		System.assertEquals(7, [SELECT Total_Days_In_State__c FROM Days_Away__c LIMIT 1].Total_Days_In_State__c);
	}

}