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
private class TestDetailPageShowPlan {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        //Create User (for Owner)
        ID OwnerId = UserInfo.getUserId();
        
        //Create User Sales Person
        ID SalesRepId = UserInfo.getUserId();
                
        RecordType FirmRecordType = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Firm'];
        Id FirmRecordTypeId = FirmRecordType.Id;
        
        //Create Firm Account
        Account Firm = new Account();
        Firm.Sales_Person__c = SalesRepId;
        Firm.Name = 'SONY ENTERTAINMENT INC';
        Firm.Phone = '7022631500';
        Firm.BillingStreet = '950 Grier Dr';
        Firm.BillingCity = 'Las Vegas';
        Firm.BillingPostalCode = '89119-0000';
        Firm.BillingState = 'NV';
        Firm.BillingCountry = 'US';
        Firm.RecordTypeId = FirmRecordTypeId;
        
        Database.Insert(Firm);
        
        Show__c Show = new Show__c();
        Show.Account__c = Firm.Id;
        Show.Name = 'Test Show';
        Show.Show_ID__c = 'TESTID';
        
        Database.Insert(Show);
        
        Contact Cont = new Contact();
        Cont.FirstName = 'Test First NAme';
        Cont.LastName = 'Test Last Name';
        Cont.Email = 'testtest@fakeges.com';
        
        Database.Insert(Cont);
        
        Show_Contact__c ShowContact = new Show_Contact__c();
        ShowContact.Contact__c = Cont.Id;
        ShowContact.Show__c = Show.Id;
        
        Database.Insert(ShowContact);
        
        Show_Plan__c ShowPlan = new Show_Plan__c();
        ShowPlan.Show_Name__c = Show.Id;
        
        Database.Insert(ShowPlan);
                
        ApexPages.Standardcontroller StdCtrlr = new ApexPages.Standardcontroller(ShowPlan);
        
        /*
        ApexPages.Pagereference DetailShowPlanPage = new ApexPages.Pagereference('/apex/DetailShowPlan');
        DetailShowPlanPage.getParameters().put('id', ShowPlan.Id);
        Test.setCurrentPageReference(DetailShowPlanPage);
        */
        
        //DetailPageShowPlan Controller = new DetailPageShowPlan(StdCtrlr);
        
        //List<Contact> LoContacts = Controller.getcntacts();
        
    }
}