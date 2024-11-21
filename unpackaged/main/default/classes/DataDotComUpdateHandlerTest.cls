@isTest
private class DataDotComUpdateHandlerTest {


	@testSetup static void setup() {
		//Insert tests
        Account falseSEU = new Account(Source_Exhibitor_Upload__c = false, Name = 'TestAccount1', BillingCountry = 'US', BillingState = 'CA',  BillingPostalCode = '94043-1352');
        Account oneField = new Account(Source_Exhibitor_Upload__c = true, Name = 'TestAccount2', BillingCountry = 'US', BillingState = 'CA',  BillingPostalCode = '94043-1355');
        Account twoFields = new Account(Source_Exhibitor_Upload__c = true, Name = 'TestAccount3', Website = 'www.google.com', BillingCountry = 'US', BillingState = 'CA',  BillingPostalCode = '94043-1356');
        Account google = new Account(Source_Exhibitor_Upload__c = true, BillingCity = 'Mountain View',
                                     BillingCountry = 'US', BillingState = 'CA', BillingPostalCode = '94043-1351',
                                     Name = 'Google Inc.', Website = 'www.google.com', Phone = '+1.650.253.0000');
        
		List<Account> accounts = new List<Account>();
		accounts.addAll(new List<Account> {falseSEU, oneField, twoFields, google});
        insert accounts;
	}	



    @isTest
    static void DataDotComUpdateHandlerTest() {
        Test.setMock(HttpCalloutMock.class, new DataDotComUpdateMock());

        Test.startTest();
		List<Account> accounts = [Select Id, NumberOfEmployees, Sic, SicDesc, Website, NaicsCode, 
											NaicsDesc, YearStarted, DunsNumber, Tradestyle, Name, BillingCity, 
											 Phone from Account];
        DataDotComUpdateHandler.updateAccounts(accounts , UserInfo.getSessionId());

        Test.stopTest();
        
        // Negative cases
        List<Account> negatives = [
            SELECT Id, Sic
            FROM Account
        ];
        
        System.assert(String.isBlank(negatives[0].Sic));
        System.assert(String.isBlank(negatives[1].Sic));
        System.assert(String.isBlank(negatives[2].Sic));

        // Positive case
        Account google = [
            SELECT Id, NumberOfEmployees, Sic, SicDesc, Website, NaicsCode, NaicsDesc, YearStarted, DunsNumber, Tradestyle
            FROM Account
            WHERE Name = 'Google Inc.'
        ];
        
        System.assertEquals(google.NumberOfEmployees, 61814);
        System.assertEquals(google.Sic, '4813');
        System.assertEquals(google.SicDesc, 'Telephone Communication, Except Radio');
        System.assertEquals(google.Website, 'www.google.com');
        System.assertEquals(google.NaicsCode, '517110');
        System.assertEquals(google.NaicsDesc, 'Wired Telecommunications Carriers');
        System.assertEquals(google.YearStarted, '1998');
        System.assertEquals(google.DunsNumber, '060902413');
        System.assertEquals(google.Tradestyle, 'Google');
    }
    
}