@isTest
public class BatchableDNBIDRCallOutCoreExihibitorTest
{
    @TestSetup
    static void testData()
    {
        Client_API_Settings__c setting = new Client_API_Settings__c();
        setting.Name = 'DNB_IDR_API';
        setting.Client_API_Key__c = '1234';
        setting.Client_API_Secret__c = '5678';
        insert setting;
        
        CORE_EXHIBITOR__c ce = new CORE_EXHIBITOR__c();
        ce.Integration_Error_Message__c = 'No Match found for the given input criteria';
        ce.Oracle_Interface_Status__c = 'N';
        ce.Integration_Status__c = null;
        ce.Oracle_Key_Index__c = '1547591';
        insert ce;
    }
    @isTest
    static void authFailureTest()
    {
        Test.setMock(HttpCalloutMock.class, new DNBIDRDUNSCalloutTest.MockHttpResponseGeneratorFailure());
        
        Test.startTest();
        Database.executeBatch(new BatchableDNBIDRCallOutOnCoreExihibitor(), 10);
        Test.stopTest();
    }
    @isTest
    static void dunsFailure()
    {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorDUNSFailure());
        
        Test.startTest();
        Database.executeBatch(new BatchableDNBIDRCallOutOnCoreExihibitor(), 10);
        Test.stopTest();
    }
    
    public class MockHttpResponseGeneratorDUNSFailure implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            if(req.getEndPoint() == 'https://plus.dnb.com/v2/token'){
                res.setBody('{"example":"test"}');
                res.setStatusCode(200);
            }
            else {
                //res.setBody('{"matchCandidates":[{"organization":{"duns":"123"}}]}');
                res.setBody('{"error":{"errorMessage":"test"}}');
                res.setStatusCode(400);
            }            
            return res;
        }
    }
    @isTest
    static void dunsSuccess()
    {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorDUNSSuccess());
        
        Test.startTest();
        Database.executeBatch(new BatchableDNBIDRCallOutOnCoreExihibitor(), 10);
        Test.stopTest();
    }
    public class MockHttpResponseGeneratorDUNSSuccess implements HttpCalloutMock {
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
}