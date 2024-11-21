/**
* @author       Thiyagarajan Selvaraj
* @date         23/05/2016
* @description  Test Class to test the create claim controller
**/
@isTest(seeAllData=false)
private class CreateClaimControllerTest {
	
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
		return [SELECT Id, Claims__Details_of_All_Any_Injuries__c, Job_Number__c, Address_poilice_fire__c,Address_property_damage__c,Body_Part_Nature_of_Injury__c,Booth__c,Citations_Issued_For_what__c FROM Claims__Incident_Report__c];
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
		System.assertEquals('Developer',cls.claim.Job_Number__c);
		System.assertEquals('12,weststreet',cls.claim.Police_Fire_EMT_Address__c);
		System.assertEquals('24,weststreet',cls.claim.Damaged_Property_Address__c);
		System.assertEquals('test',cls.claim.Body_Part_Nature_of_Injury__c);
		System.assertEquals('sheffield',cls.claim.Booth__c);
		System.assertEquals('test1',cls.claim.Citations_Issued_For_what__c);

		System.assertEquals(0,[SELECT count() FROM Claims__Claim__c]);

		cls.save();
		System.assertEquals(1,[SELECT count() FROM Claims__Claim__c]);
		System.assertEquals(1,[SELECT count() FROM Claims__Claim_Party__c]);

		Test.stopTest();
	}

	/**
	* @author       Thiyagarajan Selvaraj
	* @date         23/05/2016
	* @description  Method to test claim creation
	**/
	static testMethod void test_CreateNewClaimForBodilyInjury(){
		Test.startTest();

		// get incident reports 
		List<Claims__Incident_Report__c> incidentReportsList = getIncidentReports();
		System.Test.setCurrentPage(new PageReference('/apex/x?'+Constants.SELECTED_FIELD+'='+Claims__Claim__c.SObjectType.Policy_Year__c.getDescribe().getName()));

		CreateClaimController cls = new CreateClaimController(new ApexPages.standardController(new Claims__Claim__c(RecordTypeId=SchemaHelper.getRecordTypeInfosByName(Claims__Claim__c.sObjectType.getDescribe().getName(),Constants.CLAIM_BODILY_INJURY_RECORDTYPE))));
		cls.claim.Policy_Year__c = '2016-2017';

		System.assertNotEquals(null,cls.getBasicClaimInformationFields());
		System.assertEquals(8,cls.getMappedFields().size());

		cls.updateClaim();

		System.assertNotEquals(null,cls.cancel());

		System.assertEquals(null,cls.claim.Loss_Description_Long__c);
		System.assertEquals(null,cls.claim.Job_Number__c);
		System.assertEquals(null,cls.claim.Police_Fire_EMT_Address__c);
		System.assertEquals(null,cls.claim.Damaged_Property_Address__c);
		System.assertEquals(null,cls.claim.Body_Part_Nature_of_Injury__c);
		System.assertEquals(null,cls.claim.Booth__c);
		System.assertEquals(null,cls.claim.Citations_Issued_For_what__c);

		System.assertEquals(0,[SELECT count() FROM Claims__Claim__c]);

		cls.save();
		System.assertEquals(1,[SELECT count() FROM Claims__Claim__c]);
		System.assertEquals(0,[SELECT count() FROM Claims__Claim_Party__c]);

		Test.stopTest();
	}


	/**
	* @author       Thiyagarajan Selvaraj
	* @date         23/05/2016
	* @description  Method to test claim creation
	**/
	static testMethod void test_CreateNewClaimForMotorVehicle(){
		Test.startTest();

		// get incident reports 
		List<Claims__Incident_Report__c> incidentReportsList = getIncidentReports();
		System.Test.setCurrentPage(new PageReference('/apex/x?'+Constants.SELECTED_FIELD+'='+Claims__Claim__c.SObjectType.Policy_Year__c.getDescribe().getName()));

		CreateClaimController cls = new CreateClaimController(new ApexPages.standardController(new Claims__Claim__c(RecordTypeId=SchemaHelper.getRecordTypeInfosByName(Claims__Claim__c.sObjectType.getDescribe().getName(),Constants.CLAIM_MOTOR_VEHICLE_RECORDTYPE))));
		cls.claim.Policy_Year__c = '2016-2017';

		System.assertNotEquals(null,cls.getBasicClaimInformationFields());
		System.assertEquals(8,cls.getMappedFields().size());

		cls.updateClaim();

		System.assertNotEquals(null,cls.cancel());

		System.assertEquals(null,cls.claim.Loss_Description_Long__c);
		System.assertEquals(null,cls.claim.Job_Number__c);
		System.assertEquals(null,cls.claim.Police_Fire_EMT_Address__c);
		System.assertEquals(null,cls.claim.Damaged_Property_Address__c);
		System.assertEquals(null,cls.claim.Body_Part_Nature_of_Injury__c);
		System.assertEquals(null,cls.claim.Booth__c);
		System.assertEquals(null,cls.claim.Citations_Issued_For_what__c);

		System.assertEquals(0,[SELECT count() FROM Claims__Claim__c]);

		cls.save();
		System.assertEquals(1,[SELECT count() FROM Claims__Claim__c]);
		System.assertEquals(0,[SELECT count() FROM Claims__Claim_Party__c]);

		Test.stopTest();
	}

	/**
	* @author       Thiyagarajan Selvaraj
	* @date         23/05/2016
	* @description  Method to test claim update
	**/
	static testMethod void test_UpdateExistingClaimForBodilyInjury(){
		Test.startTest();

		// get incident reports 
		List<Claims__Incident_Report__c> incidentReportsList = getIncidentReports();
		System.Test.setCurrentPage(new PageReference('/apex/x?'+Constants.SELECTED_FIELD+'='+Claims__Claim__c.SObjectType.Policy_Year__c.getDescribe().getName()));

		// create claims 
		List<Claims__Claim__c> claimsList = TestDataCreator.createClaims(1,[SELECT Id FROM Claims__Client__c LIMIT 1][0].Id,[SELECT Id FROM Claims__Policy_Detail__c LIMIT 1][0].Id,incidentReportsList[0].Id);

		CreateClaimController cls = new CreateClaimController(new ApexPages.standardController(claimsList[0]));
		cls.claim.Policy_Year__c = '2016-2017';

		System.assertNotEquals(null,cls.getBasicClaimInformationFields());
		System.assertEquals(8,cls.getMappedFields().size());

		cls.updateClaim();

		System.assertNotEquals(null,cls.cancel());

		System.assertEquals(null,cls.claim.Loss_Description_Long__c);
		System.assertEquals(null,cls.claim.Job_Number__c);
		System.assertEquals(null,cls.claim.Police_Fire_EMT_Address__c);
		System.assertEquals(null,cls.claim.Damaged_Property_Address__c);
		System.assertEquals(null,cls.claim.Body_Part_Nature_of_Injury__c);
		System.assertEquals(null,cls.claim.Booth__c);
		System.assertEquals(null,cls.claim.Citations_Issued_For_what__c);

		System.assertEquals(1,[SELECT count() FROM Claims__Claim__c]);

		System.assertEquals(1,CreateClaimHelper.getClaims(new List<String>{'Id'},claimsList[0].Id).size());

		cls.save();
		System.assertEquals(1,[SELECT count() FROM Claims__Claim__c]);
		System.assertEquals(0,[SELECT count() FROM Claims__Claim_Party__c]);

		Test.stopTest();
	}

	/**
	* @author       Thiyagarajan Selvaraj
	* @date         23/05/2016
	* @description  Method to test claim update
	**/
	static testMethod void test_UpdateExistingClaimForMotorVehicle(){
		Test.startTest();

		// get incident reports 
		List<Claims__Incident_Report__c> incidentReportsList = getIncidentReports();
		System.Test.setCurrentPage(new PageReference('/apex/x?'+Constants.SELECTED_FIELD+'='+Claims__Claim__c.SObjectType.Policy_Year__c.getDescribe().getName()));

		// create claims 
		List<Claims__Claim__c> claimsList = TestDataCreator.createClaims(1,[SELECT Id FROM Claims__Client__c LIMIT 1][0].Id,[SELECT Id FROM Claims__Policy_Detail__c LIMIT 1][0].Id,incidentReportsList[0].Id);
		claimsList[0].RecordTypeId = Claims__Claim__c.sObjectType.getDescribe().getRecordTypeInfosByName().get(Constants.CLAIM_MOTOR_VEHICLE_RECORDTYPE).getRecordTypeId();
		update claimsList;

		CreateClaimController cls = new CreateClaimController(new ApexPages.standardController(claimsList[0]));
		cls.claim.Policy_Year__c = '2016-2017';

		System.assertNotEquals(null,cls.getBasicClaimInformationFields());
		System.assertEquals(8,cls.getMappedFields().size());

		cls.updateClaim();

		System.assertNotEquals(null,cls.cancel());

		System.assertEquals(null,cls.claim.Loss_Description_Long__c);
		System.assertEquals(null,cls.claim.Job_Number__c);
		System.assertEquals(null,cls.claim.Police_Fire_EMT_Address__c);
		System.assertEquals(null,cls.claim.Damaged_Property_Address__c);
		System.assertEquals(null,cls.claim.Body_Part_Nature_of_Injury__c);
		System.assertEquals(null,cls.claim.Booth__c);
		System.assertEquals(null,cls.claim.Citations_Issued_For_what__c);

		System.assertEquals(1,[SELECT count() FROM Claims__Claim__c]);

		System.assertEquals(1,CreateClaimHelper.getClaims(new List<String>{'Id'},claimsList[0].Id).size());

		cls.save();
		System.assertEquals(1,[SELECT count() FROM Claims__Claim__c]);
		System.assertEquals(0,[SELECT count() FROM Claims__Claim_Party__c]);

		Test.stopTest();
	}

	/**
	* @author       Thiyagarajan Selvaraj
	* @date         23/05/2016
	* @description  Method to test claim update
	**/
	static testMethod void test_getMotorVehicleClaimParties(){
		Test.startTest();
		List<Claims__Incident_Report__c> incidentReportsList = getIncidentReports();
		System.Test.setCurrentPage(new PageReference('/apex/x?'+Constants.INCIDENT_ID+'='+incidentReportsList[0].Id+'&'+Constants.SELECTED_FIELD+'='+Claims__Claim__c.SObjectType.Policy_Year__c.getDescribe().getName()));

		CreateClaimController cls = new CreateClaimController();
		cls.claim.Policy_Year__c = '2016-2017';

		System.assertNotEquals(null,cls.getBasicClaimInformationFields());
		System.assertEquals(8,cls.getMappedFields().size());

		cls.updateClaim();

		System.assertNotEquals(null,cls.cancel());

		System.assertEquals('Test-0',cls.claim.Loss_Description_Long__c);
		System.assertEquals('Developer',cls.claim.Job_Number__c);
		System.assertEquals('12,weststreet',cls.claim.Police_Fire_EMT_Address__c);
		System.assertEquals('24,weststreet',cls.claim.Damaged_Property_Address__c);
		System.assertEquals('test',cls.claim.Body_Part_Nature_of_Injury__c);
		System.assertEquals('sheffield',cls.claim.Booth__c);
		System.assertEquals('test1',cls.claim.Citations_Issued_For_what__c);

		System.assertEquals(0,[SELECT count() FROM Claims__Claim__c]);

		cls.save();
		System.assertEquals(1,[SELECT count() FROM Claims__Claim__c]);
		System.assertEquals(1,[SELECT count() FROM Claims__Claim_Party__c]);
		cls.createMotorVehicleClaimParties();
		System.assertEquals(3,CreateClaimHelper.getMotorVehicleClaimParties().size());
		Test.stopTest();
	}

	/**
	* @author       Thiyagarajan Selvaraj
	* @date         23/05/2016
	* @description  Method to test claim update
	**/
	static testMethod void test_getPropertyDamageClaimParties(){
		Test.startTest();
		List<Claims__Incident_Report__c> incidentReportsList = getIncidentReports();
		System.Test.setCurrentPage(new PageReference('/apex/x?'+Constants.INCIDENT_ID+'='+incidentReportsList[0].Id+'&'+Constants.SELECTED_FIELD+'='+Claims__Claim__c.SObjectType.Policy_Year__c.getDescribe().getName()));

		CreateClaimController cls = new CreateClaimController();
		cls.claim.Policy_Year__c = '2016-2017';

		System.assertNotEquals(null,cls.getBasicClaimInformationFields());
		System.assertEquals(8,cls.getMappedFields().size());

		cls.updateClaim();

		System.assertNotEquals(null,cls.cancel());

		System.assertEquals('Test-0',cls.claim.Loss_Description_Long__c);
		System.assertEquals('Developer',cls.claim.Job_Number__c);
		System.assertEquals('12,weststreet',cls.claim.Police_Fire_EMT_Address__c);
		System.assertEquals('24,weststreet',cls.claim.Damaged_Property_Address__c);
		System.assertEquals('test',cls.claim.Body_Part_Nature_of_Injury__c);
		System.assertEquals('sheffield',cls.claim.Booth__c);
		System.assertEquals('test1',cls.claim.Citations_Issued_For_what__c);

		System.assertEquals(0,[SELECT count() FROM Claims__Claim__c]);

		cls.save();
		System.assertEquals(1,[SELECT count() FROM Claims__Claim__c]);
		System.assertEquals(1,[SELECT count() FROM Claims__Claim_Party__c]);
		cls.createPropertyClaimParties();
		System.assertEquals(2,CreateClaimHelper.getPropertyDamageClaimParties().size());
		Test.stopTest();
	}

	/**
	* @description  Method to test Theft claim update
	**/
	static testMethod void test_getTheftClaimParties(){
		Test.startTest();
		List<Claims__Incident_Report__c> incidentReportsList = getIncidentReports();
		System.Test.setCurrentPage(new PageReference('/apex/x?'+Constants.INCIDENT_ID+'='+incidentReportsList[0].Id+'&'+Constants.SELECTED_FIELD+'='+Claims__Claim__c.SObjectType.Policy_Year__c.getDescribe().getName()));

		CreateClaimController cls = new CreateClaimController();
		cls.claim.Policy_Year__c = '2016-2017';

		System.assertNotEquals(null,cls.getBasicClaimInformationFields());
		System.assertEquals(8,cls.getMappedFields().size());

		cls.updateClaim();

		System.assertNotEquals(null,cls.cancel());

		System.assertEquals('Test-0',cls.claim.Loss_Description_Long__c);
		System.assertEquals('Developer',cls.claim.Job_Number__c);
		System.assertEquals('12,weststreet',cls.claim.Police_Fire_EMT_Address__c);
		System.assertEquals('24,weststreet',cls.claim.Damaged_Property_Address__c);
		System.assertEquals('test',cls.claim.Body_Part_Nature_of_Injury__c);
		System.assertEquals('sheffield',cls.claim.Booth__c);
		System.assertEquals('test1',cls.claim.Citations_Issued_For_what__c);

		System.assertEquals(0,[SELECT count() FROM Claims__Claim__c]);

		cls.save();
		System.assertEquals(1,[SELECT count() FROM Claims__Claim__c]);
		System.assertEquals(1,[SELECT count() FROM Claims__Claim_Party__c]);
		cls.createPropertyClaimParties();
		System.assertEquals(1,CreateClaimHelper.getTheftClaimParties().size());
		Test.stopTest();
	}

		/**
	* @description  Method to test Missing claim update
	**/
	static testMethod void test_getMissingClaimParties(){
		Test.startTest();
		List<Claims__Incident_Report__c> incidentReportsList = getIncidentReports();
		System.Test.setCurrentPage(new PageReference('/apex/x?'+Constants.INCIDENT_ID+'='+incidentReportsList[0].Id+'&'+Constants.SELECTED_FIELD+'='+Claims__Claim__c.SObjectType.Policy_Year__c.getDescribe().getName()));

		CreateClaimController cls = new CreateClaimController();
		cls.claim.Policy_Year__c = '2016-2017';

		System.assertNotEquals(null,cls.getBasicClaimInformationFields());
		System.assertEquals(8,cls.getMappedFields().size());

		cls.updateClaim();

		System.assertNotEquals(null,cls.cancel());

		System.assertEquals('Test-0',cls.claim.Loss_Description_Long__c);
		System.assertEquals('Developer',cls.claim.Job_Number__c);
		System.assertEquals('12,weststreet',cls.claim.Police_Fire_EMT_Address__c);
		System.assertEquals('24,weststreet',cls.claim.Damaged_Property_Address__c);
		System.assertEquals('test',cls.claim.Body_Part_Nature_of_Injury__c);
		System.assertEquals('sheffield',cls.claim.Booth__c);
		System.assertEquals('test1',cls.claim.Citations_Issued_For_what__c);

		System.assertEquals(0,[SELECT count() FROM Claims__Claim__c]);

		cls.save();
		System.assertEquals(1,[SELECT count() FROM Claims__Claim__c]);
		System.assertEquals(1,[SELECT count() FROM Claims__Claim_Party__c]);
		cls.createPropertyClaimParties();
		System.assertEquals(1,CreateClaimHelper.getMissingClaimParties().size());
		Test.stopTest();
	}

	/**
	* @author       Thiyagarajan Selvaraj
	* @date         23/05/2016
	* @description  Method to test claim update
	**/
	static testMethod void test_getFacilityDamageClaimParties(){
		Test.startTest();
		List<Claims__Incident_Report__c> incidentReportsList = getIncidentReports();
		System.Test.setCurrentPage(new PageReference('/apex/x?'+Constants.INCIDENT_ID+'='+incidentReportsList[0].Id+'&'+Constants.SELECTED_FIELD+'='+Claims__Claim__c.SObjectType.Policy_Year__c.getDescribe().getName()));

		CreateClaimController cls = new CreateClaimController();
		cls.claim.Policy_Year__c = '2016-2017';

		System.assertNotEquals(null,cls.getBasicClaimInformationFields());
		System.assertEquals(8,cls.getMappedFields().size());

		cls.updateClaim();

		System.assertNotEquals(null,cls.cancel());

		System.assertEquals('Test-0',cls.claim.Loss_Description_Long__c);
		System.assertEquals('Developer',cls.claim.Job_Number__c);
		System.assertEquals('12,weststreet',cls.claim.Police_Fire_EMT_Address__c);
		System.assertEquals('24,weststreet',cls.claim.Damaged_Property_Address__c);
		System.assertEquals('test',cls.claim.Body_Part_Nature_of_Injury__c);
		System.assertEquals('sheffield',cls.claim.Booth__c);
		System.assertEquals('test1',cls.claim.Citations_Issued_For_what__c);

		System.assertEquals(0,[SELECT count() FROM Claims__Claim__c]);

		cls.save();
		System.assertEquals(1,[SELECT count() FROM Claims__Claim__c]);
		System.assertEquals(1,[SELECT count() FROM Claims__Claim_Party__c]);
		cls.createFacilityClaimParties();
		System.assertEquals(2,CreateClaimHelper.getFacilityDamageClaimParties().size());
		Test.stopTest();
	}

	/**
	* @author       Thiyagarajan Selvaraj
	* @date         23/05/2016
	* @description  Method to test claim update
	**/
	static testMethod void test_getWorkersCompensationClaimParties(){
		Test.startTest();
		List<Claims__Incident_Report__c> incidentReportsList = getIncidentReports();
		System.Test.setCurrentPage(new PageReference('/apex/x?'+Constants.INCIDENT_ID+'='+incidentReportsList[0].Id+'&'+Constants.SELECTED_FIELD+'='+Claims__Claim__c.SObjectType.Policy_Year__c.getDescribe().getName()));

		CreateClaimController cls = new CreateClaimController();
		cls.claim.Policy_Year__c = '2016-2017';

		System.assertNotEquals(null,cls.getBasicClaimInformationFields());
		System.assertEquals(8,cls.getMappedFields().size());

		cls.updateClaim();

		System.assertNotEquals(null,cls.cancel());

		System.assertEquals('Test-0',cls.claim.Loss_Description_Long__c);
		System.assertEquals('Developer',cls.claim.Job_Number__c);
		System.assertEquals('12,weststreet',cls.claim.Police_Fire_EMT_Address__c);
		System.assertEquals('24,weststreet',cls.claim.Damaged_Property_Address__c);
		System.assertEquals('test',cls.claim.Body_Part_Nature_of_Injury__c);
		System.assertEquals('sheffield',cls.claim.Booth__c);
		System.assertEquals('test1',cls.claim.Citations_Issued_For_what__c);

		System.assertEquals(0,[SELECT count() FROM Claims__Claim__c]);

		cls.save();
		System.assertEquals(1,[SELECT count() FROM Claims__Claim__c]);
		System.assertEquals(1,[SELECT count() FROM Claims__Claim_Party__c]);
		cls.createWorkersCompensationClaimParties();
		System.assertEquals(1,CreateClaimHelper.getWorkersCompensationClaimParties().size());
		Test.stopTest();
	}
}