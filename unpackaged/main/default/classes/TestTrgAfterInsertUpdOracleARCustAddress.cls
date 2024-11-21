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
private class TestTrgAfterInsertUpdOracleARCustAddress {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
		//Create User (for Owner)
		ID OwnerId = UserInfo.getUserId();
		
		//Create User Sales Person
		ID SalesRepId = UserInfo.getUserId();
		        
		RecordType ExhibitorRecordType = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Exhibitor'];
		Id ExhibitorRecordTypeId = ExhibitorRecordType.Id;
		
        //Create Exhibitor Account
        Account Exhibitor = new Account();
        Exhibitor.Sales_Person__c = SalesRepId;
        Exhibitor.Name = 'SONY ENTERTAINMENT INC';
        Exhibitor.Phone = '7022631500';
        Exhibitor.BillingStreet = '950 Grier Dr';
        Exhibitor.BillingCity = 'Las Vegas';
        Exhibitor.BillingPostalCode = '89119-1111';
        Exhibitor.BillingState = 'NV';
        Exhibitor.BillingCountry = 'US';
        Exhibitor.RecordTypeId = ExhibitorRecordTypeId;
        
        Database.insert(Exhibitor);
        
        List<Oracle_AR_Customer_Address__c> LoOracleARAddresses = new List<Oracle_AR_Customer_Address__c> ();
        
        for(Integer i = 0; i <= 200; i++)
        {
			Oracle_AR_Customer_Address__c oracleAddress = new Oracle_AR_Customer_Address__c();
			oracleAddress.AR_CUST_SITE_ADDRESS1__c = '7000 Lindell Rd ' + string.valueOf(i);
			oracleAddress.AR_CUST_SITE_ADDRESS2__c = 'Suite 100';
			oracleAddress.AR_CUST_SITE_ADDRESS3__c = 'x';
			oracleAddress.AR_CUST_SITE_ADDRESS4__c = 'y';
			oracleAddress.AR_CUST_SITE_CITY__c = 'Las Vegas';
			oracleAddress.AR_CUST_SITE_STATE__c = 'NV';
			oracleAddress.AR_CUST_SITE_COUNTRY__c = 'United States';
			oracleAddress.AR_CUST_SITE_POSTAL_CODE__c = '89123';
			oracleAddress.Account__c = Exhibitor.Id;
			LoOracleARAddresses.add(oracleAddress);
        }
		
		Database.insert(LoOracleARAddresses);
		
        for(Integer i = 0; i <= 200; i++)
        {		
			LoOracleARAddresses[i].AR_CUST_SITE_ADDRESS1__c = '7150 S Tenaya Way  ' + string.valueOf(i);
        }
        
		Database.update(LoOracleARAddresses);
		
    }
}