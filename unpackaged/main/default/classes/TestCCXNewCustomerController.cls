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
private class TestCCXNewCustomerController {

    static testMethod void myUnitTest() {
		
		//Create User (for Owner)
		ID OwnerId = UserInfo.getUserId();
		
		//Create User Sales Person
		ID SalesRepId = UserInfo.getUserId();
		        
		RecordType ExhibitorRecordType = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Exhibitor'];
		Id ExhibitorRecordTypeId = ExhibitorRecordType.Id;
				
		//Create Account
        Account Acnt = new Account();
        Acnt.Sales_Person__c = SalesRepId;
        Acnt.Name = 'SONY ENTERTAINMENT INC';
        Acnt.Phone = '7022631500';
        Acnt.BillingStreet = '950 Grier Dr';
        Acnt.BillingCity = 'Las Vegas';
        Acnt.BillingPostalCode = '89119-0000';
        Acnt.BillingState = 'NV';
        Acnt.BillingCountry = 'US';
        Acnt.RecordTypeId = ExhibitorRecordTypeId;
        Acnt.Create_New__c = false;
        
        Database.insert(Acnt);
        
        //Initialize Standard Controller (required to initialze the extension controller)		
		ApexPages.StandardController stdController = new ApexPages.StandardController(Acnt);
		
		//Initialize Extension Controller
        CCXNewCustomerController controler = new CCXNewCustomerController(stdController);
        
        PageReference ref = controler.accountExists();
        
        Account Acnt1 = (Account)stdController.getRecord();
        Acnt1.Create_New__c = true;
        
        ref = controler.accountExists();
        
        Acnt1.BillingStreet = '';
        Acnt1.BillingCity = '';
        Acnt1.BillingPostalCode = '';
        Acnt1.BillingState = '';
        Acnt1.BillingCountry = '';
        Acnt1.Name = '';
        Acnt1.Phone = '';
        
        ref = controler.accountExists();
        
        ref = controler.deleteAccount();
		
    }
}