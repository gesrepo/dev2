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
private class TestTrgBeforeInsertUpdateShippingAddress {

    static testMethod void myUnitTest() {

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
        
        List<Shipping_Address__c> LoShipAddresses = new List<Shipping_Address__c> ();
        
        for(Integer i = 0; i <= 200; i++)
        {
			Shipping_Address__c address = new Shipping_Address__c();
			address.Address_1__c = '7000 Lindell Rd ' + string.valueOf(i);
			address.Address_2__c = 'Suite 100';
			address.Address_3__c = 'x';
			address.Address_4__c = 'y';
			address.City__c = 'Las Vegas';
			address.State__c = 'NV';
			address.Country__c = 'United States';
			address.Postal_Code__c = '89123';
			address.Account__c = Exhibitor.Id;
			LoShipAddresses.add(address);
        }
		
		Database.insert(LoShipAddresses);
		
        for(Integer i = 0; i <= 200; i++)
        {		
			LoShipAddresses[i].Address_1__c = '7150 S Tenaya Way  ' + string.valueOf(i);
        }
        
		Database.update(LoShipAddresses);
    }
}