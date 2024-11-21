@isTest
private class SOP_UpsertWrapperTest {

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

    public class SalesforceUpsertContactMokup implements WebServiceMock {

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

        SOP_VIAD_V2.SalesforceUpsertContactResponse_element respElement = new SOP_VIAD_V2.SalesforceUpsertContactResponse_element();
        respElement.SalesforceUpsertContactResult = 'suor';
        response.put('response_x', respElement); 
        }
    }
	
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
        insert acc;

    	SOP_UpsertWrapper suw = new SOP_UpsertWrapper();
    	Test.startTest();
    	Test.setMock(WebServiceMock.class, new SalesforceUpsertOrganisationMokup(acc.id));
    	try{
    		SOP_UpsertWrapper.UpsertOrganisation(JSON.serialize(acc));
    	} catch(Exception e) {

    	}
    	Test.stopTest();

    	
	}

	@isTest static void test_method_two() {
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
        insert acc;

    	
    	 Contact c = new Contact();
        c.LastName = 'lname';
        c.OwnerId = uid;
        c.AccountId = acc.Id;
        c.Email = 'ddunkley@ges.com';
        insert c;

    	SOP_UpsertWrapper suw = new SOP_UpsertWrapper();

		Test.startTest();
    	Test.setMock(WebServiceMock.class, new SalesforceUpsertContactMokup());

    	try{
            SOP_UpsertWrapper.UpsertContact(new String[]{JSON.serialize(c)});
    	} catch(Exception e) {
    		
    	}
    	Test.stopTest();
	}

}