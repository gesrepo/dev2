/**not
* @description This is the test class for the IncidentReportSelectionController.
*/
@isTest
private class IncidentReportSelectionController_Test {

	@isTest
	private static void controllerTest() {

        Id rc = Schema.SObjectType.Claims__Incident_Report__c.getRecordTypeInfosByName().get('Bodily Injury').getRecordTypeId();

        List<Claims__Incident_Report__c> incidentReports = TestDataCreator.createIncidentReports(3, rc);
        insert incidentReports;

        Test.startTest();
            IncidentReportSelectionController ct = new IncidentReportSelectionController();
            String queryStr = 'SELECT ID FROM Claims__Incident_Report__c';
            ct.reports = Database.query(queryStr);
            List<Claims__Incident_Report__c> reports =  ct.reportsCon;
            system.assertEquals(3, ct.noOfRecords);
        Test.stopTest();
	}
}