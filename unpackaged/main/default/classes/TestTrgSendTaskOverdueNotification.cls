/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestTrgSendTaskOverdueNotification {

    public class SalesforceUpsertOrganisationMokup implements WebServiceMock {
        String sfID;
        public SalesforceUpsertOrganisationMokup(String SalesforceID) {
            sfID = SalesforceID;
        }

        public void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {

        SOP_VIAD_V2.SalesforceUpsertOrganisationResult suor = new SOP_VIAD_V2.SalesforceUpsertOrganisationResult();
        suor.EUSopID = 43621;
        suor.MESopID = 23231;
        suor.SalesforceID = this.sfID;
        suor.UKSopID = 23212;
        SOP_VIAD_V2.SalesforceUpsertOrganisationResponse_element respElement = new SOP_VIAD_V2.SalesforceUpsertOrganisationResponse_element();
        respElement.SalesforceUpsertOrganisationResult = suor;
        response.put('response_x', respElement); 
        }
    }

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Account Facility = TestDataUtil.CreateTestFacility();
        Test.setMock(WebServiceMock.class, new SalesforceUpsertOrganisationMokup(Facility.id));
        Account Firm = TestDataUtil.CreateTestFirm();
        Account Exhibitor = TestDataUtil.CreateTestExhibitor();
        Show__c Show = TestDataUtil.CreateTestShow(Firm.Id);
        Opportunity SalesRepOpp = TestDataUtil.CreateTestSalesRepOpp(Facility.Id, Firm.Id, Show.Id);
        Oracle_Show_Booth__c Booth = TestDataUtil.CreateTestBooth(Exhibitor.Id, SalesRepOpp.Id, SalesRepOpp.Job_Number__c, Show.Show_ID__c);
        Contact Con = TestDataUtil.CreateTestContact();
        Case Cse = TestDataUtil.CreateTestCase(Exhibitor.Id, Booth.Id, Con.Id, SalesRepOpp.Id);
        Task T = TestDataUtil.CreateTestOverDueTask(Cse.Id, Cse.OwnerId);
    }
}