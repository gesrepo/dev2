/**
  * @author Nikhil Vedi
  * @description Test class for the Workers Compensation Page & Controller.
  */
@IsTest
public class WorkersCompensationControllerTest {

	private static Claims__Incident_Report__c incident;

	public static void setupIncidentData() {

		Id rc = 
		Schema.SObjectType.Claims__Incident_Report__c.getRecordTypeInfosByName().get(Constants.CLAIM_WORKERS_COMPENSATION_RECORDTYPE).getRecordTypeId();

		incident = new Claims__Incident_Report__c(Claims__Date_Reported__c = Date.today(),
		        Claims__First_Name__c = 'Test', Claims__IncidentDate__c = Date.today(),
		        Claims__Last_Name__c = 'Test', Claims__IncidentLocation__c = 'Sheffield', Claims__Report_Completed_By__c = 'Test Test',
		        Claims__Email__c = 'test@test.com', Claims__Report_Completion_Date__c = Date.Today(), RecordTypeId = rc,
		        In_Progress_Report__c = true);

	}

	/**
	  * @description Test Save with Submit
	  */
	@IsTest
	public static void testSaveWithSubmit() {

		setupIncidentData();

		ApexPages.standardController standardController;
		WorkersCompensationController controller = 
		new WorkersCompensationController(new ApexPages.standardController(incident));

		Controller.report = incident;

		//test save with submitting
		controller.Save();

		//ensure the incidents were inserted
		List<Claims__Incident_Report__c> incs = [SELECT name, id, In_Progress_Report__c 
		FROM Claims__Incident_Report__c 
		LIMIT 500];

		System.assertEquals(incs[0].In_Progress_Report__c, false);
		System.assertEquals(incs.size(), 1);

	}

	/**
	  * @description Test Save without Submit
	  */
	@IsTest
	public static void testSaveWithoutSubmit() {

		setupIncidentData();

		ApexPages.standardController standardController;
		WorkersCompensationController controller = 
		new WorkersCompensationController(new ApexPages.standardController(incident));

		Controller.report = incident;

		//test save without submitting
		controller.saveWithoutSubmission();

		//ensure the incidents were inserted
		List<Claims__Incident_Report__c> incs = [SELECT name, id, In_Progress_Report__c 
		FROM Claims__Incident_Report__c 
		LIMIT 500];

		System.assertEquals(incs[0].In_Progress_Report__c, true);
		System.assertEquals(incs.size(), 1);

	}

	/**
	  * @description Test saving attachments
	  */
	@IsTest
	public static void testSavingAttachements() {

		setupIncidentData();

		ApexPages.standardController standardController;
		WorkersCompensationController controller = 
		new WorkersCompensationController(new ApexPages.standardController(incident));

		Pagereference pr = controller.Save();

		System.assert(controller.attachments.size() == 0);

		controller.attach.Name = 'Test';
		controller.attach.Body = Blob.valueOf('Test String');

		controller.saveAttachment();

		System.assert(controller.attachments.size() == 1);
	}

	/**
	  * @description Test save attachment error handling
	  */
	@isTest
	private static void TestAttachNewFileThrowError() {

		setupIncidentData();

		ApexPages.standardController standardController;
		WorkersCompensationController controller = 
		new WorkersCompensationController(new ApexPages.standardController(incident));

		Pagereference pr = controller.Save();

		System.assert(controller.attachments.size() == 0);

		controller.attach = null;
		controller.saveAttachment();

		System.assert(Apexpages.hasMessages(), 'No error messages given');
	}

	/**
	* @description Test submitting report & returning thanks page
	*/
	@isTest
	private static void TestSubmitReport() {
		setupIncidentData();

		ApexPages.standardController standardController;
		WorkersCompensationController controller = 
		new WorkersCompensationController(new ApexPages.standardController(incident));

		Pagereference pr = controller.submitReport();

		System.assert(pr.getUrl().contains('workerscompthanks'), 'Incorrect pagereference');
	}

	/**
	* @description Test final save without submitting report & returning thanks page
	*/
	@isTest
	private static void TestNotSubmitReport() {
		setupIncidentData();

		ApexPages.standardController standardController;
		WorkersCompensationController controller = 
		new WorkersCompensationController(new ApexPages.standardController(incident));

		Pagereference pr = controller.saveWithoutSubmitReport();

		System.assert(pr == null);
	}

}