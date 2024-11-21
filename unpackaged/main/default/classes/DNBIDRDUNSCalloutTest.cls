@isTest
public class DNBIDRDUNSCalloutTest 
{   
    @TestSetup
    static void testData()
    {
        Client_API_Settings__c setting = new Client_API_Settings__c();
        setting.Name = 'DNB_IDR_API';
        setting.Client_API_Key__c = '1234';
        setting.Client_API_Secret__c = '5678';
        insert setting;
    }
    @isTest
    static void successTest()
    {
        CORE_EXHIBITOR__c ce = new CORE_EXHIBITOR__c();
        ce.Company_Name__c = 'Test';
        ce.Address1__c = 'Test1';
        ce.City__c = 'Irving';
        ce.State__c = 'TX';
        ce.Postal_Code__c = '75034';
        ce.Country__c  = 'US';
        ce.Integration_Status__c = 'Success';
        ce.Oracle_Interface_Status__c = 'P';       
        ce.Oracle_Key_Index__c = '1559173';     
        insert ce;
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorSuccess());
        Test.startTest();
        DNBIDRDUNSCallout.getDUNSResponse(ce, '13');
        Test.stopTest();
    }
    @isTest
    static void errorTest()
    {
        CORE_EXHIBITOR__c ce = new CORE_EXHIBITOR__c();
        ce.Company_Name__c = 'Test';
        ce.Address1__c = 'Test1';
        ce.City__c = 'Irving';
        ce.State__c = 'Texas';
        ce.Postal_Code__c = '75034';
        ce.Country__c  = 'US';
        ce.Integration_Status__c = 'Failed';
        ce.Oracle_Interface_Status__c = 'N';
        ce.Integration_Error_Message__c = 'Invalid Territory provided in the request';
        ce.Oracle_Key_Index__c = '1559173';
        insert ce;
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorFailure());
        Test.startTest();
        DNBIDRDUNSCallout.getDUNSResponse(ce, '13');
        Test.stopTest();
    }
    public class MockHttpResponseGeneratorSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            if(req.getEndPoint() == 'https://plus.dnb.com/v2/token'){
                res.setBody('{"example":"test"}');
                res.setStatusCode(200);
            }
            else {
                res.setBody('{"matchCandidates":[{"organization":{"duns":"123"}, "matchQualityInformation":{"confidenceCode":"13"}}], "cleanseAndStandardizeInformation":{"standardizedName":"Test", "standardizedAddress":{"postalCode":"1234", "postalCodeExtension":"5678", "streetAddress":{"line1":"A", "line2":"A"}, "addressLocality":{"name":"a"}, "addressCountry":{"isoAlpha2Code":"US"}, "addressRegion": {"abbreviatedName":"1", "name":"2"}}}}');
                res.setStatusCode(200);
            }            
            return res;
        }
    }
    public class MockHttpResponseGeneratorFailure implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"error":{"errorMessage":"test"}}');
            res.setStatusCode(400);
            return res;
        }
    }
    
    @isTest
    static void authSuccessTest()
    {
        Test.setMock(HttpCalloutMock.class, new AuthMockHttpResponseGeneratorSuccess());
        Test.startTest();
        DNBIDRDUNSCallout.AuthorizationResponse aResp = DNBIDRDUNSCallout.getAuthToken();
        aResp = DNBIDRDUNSCallout.getAuthToken();
        Test.stopTest();
    }
    @isTest
    static void authErrorTest()
    {
        Test.setMock(HttpCalloutMock.class, new AuthMockHttpResponseGeneratorFailure());
        Test.startTest();
        DNBIDRDUNSCallout.AuthorizationResponse aResp = DNBIDRDUNSCallout.getAuthToken();
        Test.stopTest();
    }
    public class AuthMockHttpResponseGeneratorSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json'); 
            res.setBody('{"example":"test"}');
            res.setStatusCode(200);        
            return res;
        }
    }
    public class AuthMockHttpResponseGeneratorFailure implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"error":{"errorMessage":"test"}}');
            res.setStatusCode(400);
            return res;
        }
    }
}