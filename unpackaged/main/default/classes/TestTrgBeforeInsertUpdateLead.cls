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
private class TestTrgBeforeInsertUpdateLead {

    static testMethod void myUnitTest() {

		//Create User (for Owner)
		ID OwnerId = UserInfo.getUserId();

		//Create User Sales Person
		ID SalesRepId = UserInfo.getUserId();
        
		Lead L1 = New Lead();
		L1.OwnerId = OwnerId;
		L1.FirstName = 'Coco';
		L1.LastName = 'Banana';
		L1.Company = 'Go Banana Crazy, Inc';
		L1.Status = 'Unable to Contact';
		L1.Street = '123 Banana Way';
		L1.City = 'Banana Forest';
		L1.State = 'NV';
		L1.Country = 'US';
		
		Database.insert(L1);
		
		L1.Status = 'Not interested at this time';
		
		Database.update(L1);
    }
}