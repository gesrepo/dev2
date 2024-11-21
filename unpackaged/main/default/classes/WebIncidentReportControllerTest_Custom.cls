/**
  * @author Andy Evans
  * @date 5/05/2014
  * @description This is a copy of the test class for the WebIncidentReportController.
  */
  
/**
  * @author Paul Battisson
  * @date 26/04/2012
  * @description This is the test class for the WebIncidentReportController.
  */
@isTest
private class WebIncidentReportControllerTest_Custom {
    @isTest
    private static void TestInitialiseNewIncidentReport()
    {
        WebIncidentReportController_Custom controller = new WebIncidentReportController_Custom();
        
        System.assertNotEquals(null, controller.report, 'Incident Report on the controller is null.'); 
    }
    
    @isTest
    private static void TestRetrieveRecordTypes()
    {
        WebIncidentReportController_Custom controller = new WebIncidentReportController_Custom();
        
        System.assert(controller.incidentTypes.size() != 0, 'No Record Types were returned.');
    }
    
    @isTest
    private static void TestSetRecordType()
    {
        WebIncidentReportController_Custom controller = new WebIncidentReportController_Custom();
        
        controller.selectedType = controller.incidentTypes[1].getValue();
        controller.report.Claims__Date_Reported__c = Date.today();
        controller.report.Claims__First_Name__c = 'Test';
        controller.report.Claims__IncidentDate__c = Date.today();
        controller.report.Claims__Last_Name__c = 'Test';
        controller.report.Claims__IncidentLocation__c = 'Sheffield';
        controller.report.Claims__Report_Completed_By__c = 'Test';
        controller.report.Claims__Email__c = 'test@test.com';
        controller.report.Claims__Report_Completion_Date__c = Date.Today();
        controller.report.Preparer_Full_Name__c = 'Test Test';
        controller.report.Preparer_Email_Address__c = 'test@test.com';
        System.assertNotEquals(null, controller.Save());
        
        System.assertEquals((Id) controller.incidentTypes[1].getValue(), controller.report.RecordTypeId, 'Record type not set correctly');
    }
    
    @isTest
    private static void TestSaveThrowException()
    {
        WebIncidentReportController_Custom controller = new WebIncidentReportController_Custom();
        
        controller.Save();
        
        System.assert(Apexpages.hasMessages(), 'No error messages given');
    }
    
    @isTest
    private static void TestSaveNoException()
    {
        WebIncidentReportController_Custom controller = new WebIncidentReportController_Custom();
        
        controller.selectedType = controller.incidentTypes[1].getValue();
        controller.report.Claims__Date_Reported__c = Date.today();
        controller.report.Claims__First_Name__c = 'Test';
        controller.report.Claims__IncidentDate__c = Date.today();
        controller.report.Claims__Last_Name__c = 'Test';
        controller.report.Claims__IncidentLocation__c = 'Sheffield';
        controller.report.Claims__Report_Completed_By__c = 'Test';
        controller.report.Claims__Email__c = 'test@test.com';
        controller.report.Claims__Report_Completion_Date__c = Date.Today();
        controller.report.Preparer_Full_Name__c = 'Test Test';
        controller.report.Preparer_Email_Address__c = 'test@test.com';

        Pagereference pr = controller.Save();
        System.assert(pr.getUrl().contains('webincidentreportattach'), 'Incorrect pagereference returned');
    }
    
    @isTest 
    private static void TestAttachNewFile()
    {
        WebIncidentReportController_Custom controller = new WebIncidentReportController_Custom();
        
        controller.selectedType = controller.incidentTypes[1].getValue();
        controller.report.Claims__Date_Reported__c = Date.today();
        controller.report.Claims__First_Name__c = 'Test';
        controller.report.Claims__IncidentDate__c = Date.today();
        controller.report.Claims__Last_Name__c = 'Test';
        controller.report.Claims__IncidentLocation__c = 'Sheffield';
        controller.report.Claims__Report_Completed_By__c = 'Test';
        controller.report.Preparer_Email_Address__c = 'test@test.com';
        controller.report.Claims__Report_Completion_Date__c = Date.Today();
        controller.report.Preparer_Full_Name__c = 'Test Test';
        Pagereference pr = controller.Save();
        
        System.assert(controller.attachments.size() == 0);
        
        controller.attach.Name = 'Test';
        controller.attach.Body = Blob.valueOf('Test String');
        
        controller.saveAttachment();
        
        System.assert(controller.attachments.size() == 1);
    }
    
    @isTest 
    private static void TestAttachNewFileThrowError()
    {
        WebIncidentReportController_Custom controller = new WebIncidentReportController_Custom();
        
        controller.selectedType = controller.incidentTypes[1].getValue();
        controller.report.Claims__Date_Reported__c = Date.today();
        controller.report.Claims__First_Name__c = 'Test';
        controller.report.Claims__IncidentDate__c = Date.today();
        controller.report.Claims__Last_Name__c = 'Test';
        controller.report.Claims__IncidentLocation__c = 'Sheffield';
        controller.report.Claims__Report_Completed_By__c = 'Test';
        controller.report.Claims__Email__c = 'test@test.com';
        controller.report.Claims__Report_Completion_Date__c = Date.Today();
        controller.report.Preparer_Full_Name__c = 'Test Test';
        controller.report.Preparer_Email_Address__c = 'test@test.com';
        
        Pagereference pr = controller.Save();
        
        System.assert(controller.attachments.size() == 0);
        
        controller.attach = null;
        controller.saveAttachment();
        
        System.assert(Apexpages.hasMessages(), 'No error messages given');
    }
    
    @isTest
    private static void TestSubmitReport()
    {
        WebIncidentReportController_Custom controller = new WebIncidentReportController_Custom();
        
        Pagereference pr = controller.submitReport();
        
        System.assert(pr.getUrl().contains('webincidentreportthanks'), 'Incorrect pagereference returned');
    }
    
    @isTest
    private static void TestSubmitAttemptWithErrors() 
    {
        WebIncidentReportController_Custom controller = new WebIncidentReportController_Custom();
        
        controller.Save();
        
        System.assertEquals(null, controller.submitReport(), 'Incorrect page reference returned.');
    }

    @isTest
    private static void  testSearchReport() {

        Id rc = Schema.SObjectType.Claims__Incident_Report__c.getRecordTypeInfosByName().get('Bodily Injury').getRecordTypeId();

        Claims__Incident_Report__c ic = new Claims__Incident_Report__c(Claims__Date_Reported__c = Date.today(), 
            Claims__First_Name__c = 'Test', Claims__IncidentDate__c = Date.today(),
            Claims__Last_Name__c = 'Test', Claims__IncidentLocation__c = 'Sheffield', Claims__Report_Completed_By__c = 'Test',
            Claims__Email__c = 'test@test.com', Claims__Report_Completion_Date__c = Date.Today(), RecordTypeId = rc,
            In_Progress_Report__c = true);

        insert ic;

        Claims__Incident_Report__c icInserted = [SELECT Id, Name FROM Claims__Incident_Report__c WHERE Id =:ic.Id LIMIT 1];

        WebIncidentReportController_Custom ct = new WebIncidentReportController_Custom();
        ct.searchString = icInserted.Name;
        PageReference pg = ct.searchIncidents();
        System.assertEquals(null, pg);
        System.assertEquals(ic.Id, ct.report.Id);
        System.assertEquals(ic.RecordTypeId, ct.report.RecordTypeId);

        ct.searchString = 'ABC';
        ct.searchIncidents();
        System.assertEquals(null, ct.report);

        ct.searchString = 'IR-XXXX';
        ct.searchIncidents();
        System.assertEquals(null, ct.report);
    }

    @isTest
    private static void  testSaveInProgress() {
        WebIncidentReportController_Custom controller = new WebIncidentReportController_Custom();

        controller.selectedType = controller.incidentTypes[1].getValue();
        controller.report.Claims__Date_Reported__c = Date.today();
        controller.report.Claims__First_Name__c = 'Test';
        controller.report.Claims__IncidentDate__c = Date.today();
        controller.report.Claims__Last_Name__c = 'Test';
        controller.report.Claims__IncidentLocation__c = 'Sheffield';
        controller.report.Claims__Report_Completed_By__c = 'Test';
        controller.report.Claims__Email__c = 'test@test.com';
        controller.report.Claims__Report_Completion_Date__c = Date.Today();
        controller.report.Preparer_Full_Name__c = 'Test Test';
        controller.report.Preparer_Email_Address__c = 'test@test.com';

        controller.saveWithouSubmission();

        Claims__Incident_Report__c[] ic = [SELECT Id, In_Progress_Report__c FROM Claims__Incident_Report__c];
        System.assertEquals(1, ic.size());
        System.assertEquals(true, ic[0].In_Progress_Report__c);

        PageReference pg = controller.saveWithouSubmitReport();
        System.assertNotEquals(null, pg);
        System.assertEquals(true, controller.notSubmitted);
    }

    @isTest
    private static void testStandardController(){

        Id rc = Schema.SObjectType.Claims__Incident_Report__c.getRecordTypeInfosByName().get('Bodily Injury').getRecordTypeId();

        Claims__Incident_Report__c ic = new Claims__Incident_Report__c(Claims__Date_Reported__c = Date.today(), 
            Claims__First_Name__c = 'Test', Claims__IncidentDate__c = Date.today(),
            Claims__Last_Name__c = 'Test', Claims__IncidentLocation__c = 'Sheffield', Claims__Report_Completed_By__c = 'Test',
            Claims__Email__c = 'test@test.com', Claims__Report_Completion_Date__c = Date.Today(), RecordTypeId = rc,
            In_Progress_Report__c = true);

        insert ic;
        ApexPages.standardController std = new ApexPages.standardController(ic);
        WebIncidentReportController_Custom controller = new WebIncidentReportController_Custom(std);
        System.assertNotEquals(null, controller.report);
    }
}