/**
* @author       Thiyagarajan Selvaraj
* @date         23/05/2016
* @description  Test Class for corvell controller
**/
@isTest(seeAllData=false)
private with sharing class CorvellControllerTest {
	
	/**
	* @author       Thiyagarajan Selvaraj
	* @date         23/05/2016
	* @description  Method to create the test data
	**/
	@testSetup
	private static void setUpTestData(){
		try{
			//create mapping 
			Claims__Mapping__c mappingRecord = TestDataCreator.createMapping();

			// Create incident reports 
			List<Claims__Incident_Report__c> incidentReportsList = TestDataCreator.createIncidentReports(2);

			// create account 
			List<Account> accountsList = TestDataCreator.createAccounts(1);

			// create clients 
			List<Claims__Client__c> clientsList = TestDataCreator.createClients(accountsList);

			// create policy types
			List<Claims__Policy_Type__c> policyTypesList = TestDataCreator.createPolicyTypes(1);

			// create policies 
			List<Claims__Policy__c> policiesList = TestDataCreator.createPolicies(clientsList,policyTypesList);

			// create cover type setup 
			List<Claims__Cover_Type_Setup__c> coverTypeSetupList = TestDataCreator.createCoverTypeSetUpList(policyTypesList);

			// Create policy detail
			List<Claims__Policy_Detail__c> coverTypesList = TestDataCreator.createCoverTypesList(policiesList,coverTypeSetupList);
		}catch(Exception ex){
		}
	}

	/**
	* @author       Thiyagarajan Selvaraj
	* @date         23/05/2016
	* @description  Method to get incident reports
	**/
	private static List<Claims__Incident_Report__c> getIncidentReports(){
		return [SELECT Id, Claims__Details_of_All_Any_Injuries__c, Job__c, Address_poilice_fire__c,Address_property_damage__c,Body_Part_Nature_of_Injury__c,Booth__c,Citations_Issued_For_what__c FROM Claims__Incident_Report__c];
	}

	/**
	* @author       Thiyagarajan Selvaraj
	* @date         23/05/2016
	* @description  Method to test claim creation
	**/
	static testMethod void test_CreateClaimFromIncidentReport(){
		Test.startTest();

		// get incident reports 
		List<Claims__Incident_Report__c> incidentReportsList = getIncidentReports();
		System.Test.setCurrentPage(new PageReference('/apex/x?'+Constants.INCIDENT_ID+'='+incidentReportsList[0].Id+'&'+Constants.SELECTED_FIELD+'='+Claims__Claim__c.SObjectType.Policy_Year__c.getDescribe().getName()));

		CreateClaimController cls = new CreateClaimController();
		cls.claim.Policy_Year__c = '2016-2017';

		System.assertNotEquals(null,cls.getBasicClaimInformationFields());
		System.assertEquals(8,cls.getMappedFields().size());

		cls.updateClaim();

		System.assertNotEquals(null,cls.cancel());

		System.assertEquals('Test-0',cls.claim.Loss_Description_Long__c);
		System.assertEquals('Developer',cls.claim.Job__c);
		System.assertEquals('12,weststreet',cls.claim.Police_Fire_EMT_Address__c);
		System.assertEquals('24,weststreet',cls.claim.Damaged_Property_Address__c);
		System.assertEquals('test',cls.claim.Body_Part_Nature_of_Injury__c);
		System.assertEquals('sheffield',cls.claim.Booth__c);
		System.assertEquals('test1',cls.claim.Citations_Issued_For_what__c);

		System.assertEquals(0,[SELECT count() FROM Claims__Claim__c]);

		cls.save();
		List<Claims__Claim__c> claimsList = [SELECT Id, Name FROM Claims__Claim__c];
		System.assertEquals(1,claimsList.size());
		System.assertEquals(1,[SELECT count() FROM Claims__Claim_Party__c]);

		// create carriers
		List<Carrier__c> carriersList = new List<Carrier__c>();
		carriersList.add(new Carrier__c(Name='Test Carrier 1',Claim_No__c=claimsList[0].Name,
			RecordTypeId=Schema.SObjectType.Carrier__c.getRecordTypeInfosByName().get('Corvel').getRecordTypeId()));
		insert carriersList;

		CorvellController corvelCls = new CorvellController(new ApexPages.standardController(claimsList[0]));
		System.assertEquals(1,corvelCls.carriers.size());

		Test.stopTest();
	}
}