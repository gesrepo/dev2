@isTest
private class EMEA_SOP_Sync_ContactTest {
	
	@isTest static void test_method_one() {
		SOPService__c serv = new SOPService__c();
        serv.Name = 'Default';
        serv.URL__c = 'test';
        insert serv;
        
		SOPAuthentication__c newAuth = new SOPAuthentication__c();
    	newAuth.Name = 'Login Credentials';
    	newAuth.Password__c = 'lalalala';
    	newAuth.Username__c = 'lalalala';
    	insert newAuth;

    	String uid = [SELECT Id FROM User WHERE Alias = 'CorpAcct' LIMIT 1].Id;
    	Id FirmRTId = ((RecordType)[SELECT Id FROM RecordType WHERE Name = 'Firm' And SObjectType = 'Account']).Id;
    	
    	Account acc = new Account();
        acc.Name = 'name-firm';
        acc.RecordTypeId = FirmRTId;
        acc.BillingCity = 'city';
        acc.BillingCountry = 'US';
        acc.BillingState = 'AL';
        acc.BillingPostalCode = '12345-1234';
        acc.BillingStreet = 'street';
        acc.Phone = '12345';
        acc.EMEA__c = True;
        acc.EMEA_Finance_Approved__c = True;
        insert acc;
    	
    	Contact c = new Contact();
        c.LastName = 'lname';
        c.OwnerId = uid;
        c.AccountId = acc.Id;
        c.Email = 'lucian388212@vertiba.com';
        insert c;
	}
	
}