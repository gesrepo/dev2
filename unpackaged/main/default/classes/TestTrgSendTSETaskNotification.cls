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
private class TestTrgSendTSETaskNotification {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        Account Facility = TestDataUtil.CreateTestFacility();
        Account Firm = TestDataUtil.CreateTestFirm();
        Account Exhibitor = TestDataUtil.CreateTestExhibitor();
        Show__c Show = TestDataUtil.CreateTestShow(Firm.Id);
        Opportunity SalesRepOpp = TestDataUtil.CreateTestSalesRepOpp(Facility.Id, Firm.Id, Show.Id);
        Oracle_Show_Booth__c Booth = TestDataUtil.CreateTestBooth(Exhibitor.Id, SalesRepOpp.Id, SalesRepOpp.Job_Number__c, Show.Show_ID__c);
        Contact Con = TestDataUtil.CreateTestContact();
        Case Cse = TestDataUtil.CreateTestCase(Exhibitor.Id, Booth.Id, Con.Id, SalesRepOpp.Id);
        
        Test.startTest();
         
        Task T = new Task();
        
        T.WhatId = Cse.Id;
        T.OwnerId = UserInfo.getUserId();
        T.Subject = 'Test TSE Task Notification Email.';
        T.Description = 'TSE Task Notification';
        T.Type = 'Electrical Problem Orders';
        
        Database.insert(T);
        
        Test.stopTest();
    }
}