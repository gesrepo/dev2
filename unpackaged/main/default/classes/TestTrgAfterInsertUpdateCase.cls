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
private class TestTrgAfterInsertUpdateCase {
    
    @testSetup static void setup() {
        Account Facility = TestDataUtil.CreateTestFacility();
        Account Firm = TestDataUtil.CreateTestFirm();
        Contact Con = TestDataUtil.CreateTestContact(Firm.Id);
        //Account Exhibitor = TestDataUtil.CreateTestExhibitor();
        Show__c Show = TestDataUtil.CreateTestShow(Firm.Id);
        Opportunity SalesRepOpp = TestDataUtil.CreateTestSalesRepOpp(Facility.Id, Firm.Id, Show.Id);
        Test.startTest();
        Oracle_Show_Booth__c Booth = TestDataUtil.CreateTestBooth(Firm.Id, SalesRepOpp.Id, SalesRepOpp.Job_Number__c, Show.Show_ID__c);        
        Case Cse = TestDataUtil.CreateTestCase(Firm.Id, Booth.Id, Con.Id, SalesRepOpp.Id);
        Task T = TestDataUtil.CreateTestOverDueTask(Cse.Id, Cse.OwnerId);
        Test.stopTest();
    }
    
    static testMethod void myUnitTest() {
    
        CaseToSQRSetting__c newSetting = new CaseToSQRSetting__c();
       
        newSetting.Name='CaseToSQR Webservice Authentication';
        newSetting.ApplicationID__c='SalesForce';
        newSetting.ApplicationKey__c    ='76v.H-_7};9^+4(]J.;3';    
        newSetting.Authentication_EndPoint__c='https://qaapi.viad.com/Security/v2/AuthenticationService.svc';
        newSetting.Client_EndPoint__c='https://qaapi.viad.com/GES/v2/SqrService.svc';   
        newSetting.EndPoint__c='http://qaapi.viad.com/GES/v2/SqrService.svc';
        newSetting.Password__c  ='welcome#123';
        newSetting.Username__c='coresqr';
        
        insert newSetting;
        
        Task T =[SELECT id, status FROM Task WHERE Type='Email' LIMIT 1];
        Test.startTest();
        T.Status='Completed';
        update T;
        
        
        
        Case Cse =[SELECT id, Status,Refund_Adj_Amount__c,Refund_Adj_Reason_Code__c,Credit_Memo_Code__c,Exhibitor_Services_Manager__c FROM Case WHERE Status ='Open' LIMIT 1];
        Cse.Refund_Adj_Amount__c = 501;
        Cse.Refund_Adj_Reason_Code__c = 'Discount given';
        Cse.Credit_Memo_Code__c = '10-Good Faith';
        Cse.Exhibitor_Services_Manager__c = UserInfo.getUserId();
        //Database.update(Cse); 
        
        
        CaseComment newCom = new CaseComment();
        newCom.ParentId = Cse.id;
        newCom.CommentBody='test comments';
        
        insert newCom;
        
        Cse.Status = 'Closed';
        
        Database.update(Cse);
        Test.stopTest();
        Test.setMock(WebServiceMock.class, new SQRServiceClientMockImpl());
        SQRServiceClient.submitCaseSQRs(cse.Id);  
        
    }
    static testMethod void testCaseUpdate() {
        test.startTest();
        Case Cse =[SELECT id, Status,Refund_Adj_Amount__c,Refund_Adj_Reason_Code__c,Credit_Memo_Code__c,Exhibitor_Services_Manager__c FROM Case WHERE Status ='Open' LIMIT 1];
        Cse.Refund_Adj_Amount__c = 501;
        Cse.Refund_Adj_Reason_Code__c = 'Discount given';
        Cse.Credit_Memo_Code__c = '10-Good Faith';
        Cse.Exhibitor_Services_Manager__c = UserInfo.getUserId();
        
        Database.update(Cse);
        test.stopTest();
    }
    
    static testMethod void wwwViadComDataV2_SQRTest() {
        wwwViadComDataV2_SQR classVariable= new wwwViadComDataV2_SQR();
        wwwViadComDataV2_SQR.ArrayOfSqr ArrayOfSqr= new wwwViadComDataV2_SQR.ArrayOfSqr();
        wwwViadComDataV2_SQR.SqrCreateRequest SqrCreateRequest= new wwwViadComDataV2_SQR.SqrCreateRequest();
        wwwViadComDataV2_SQR.SqrItem SqrItem= new wwwViadComDataV2_SQR.SqrItem();
        wwwViadComDataV2_SQR.SqrItemProblem SqrItemProblem= new wwwViadComDataV2_SQR.SqrItemProblem();
        wwwViadComDataV2_SQR.SimpleSqrCreateRequest SimpleSqrCreateRequest= new wwwViadComDataV2_SQR.SimpleSqrCreateRequest();
        wwwViadComDataV2_SQR.ArrayOfSqrTally ArrayOfSqrTally= new wwwViadComDataV2_SQR.ArrayOfSqrTally();
        wwwViadComDataV2_SQR.ArrayOfLookupList ArrayOfLookupList= new wwwViadComDataV2_SQR.ArrayOfLookupList();
        wwwViadComDataV2_SQR.ArrayOfSqrOrderLine ArrayOfSqrOrderLine= new wwwViadComDataV2_SQR.ArrayOfSqrOrderLine();
        wwwViadComDataV2_SQR.ArrayOfSqrItem ArrayOfSqrItem= new wwwViadComDataV2_SQR.ArrayOfSqrItem();
        wwwViadComDataV2_SQR.ArrayOfSqrItemProblem ArrayOfSqrItemProblem= new wwwViadComDataV2_SQR.ArrayOfSqrItemProblem();
        wwwViadComDataV2_SQR.SqrDefaults SqrDefaults= new wwwViadComDataV2_SQR.SqrDefaults();
        wwwViadComDataV2_SQR.SqrTally SqrTally= new wwwViadComDataV2_SQR.SqrTally();
        wwwViadComDataV2_SQR.SimpleSqr SimpleSqr= new wwwViadComDataV2_SQR.SimpleSqr();
        wwwViadComDataV2_SQR.LookupList LookupList= new wwwViadComDataV2_SQR.LookupList();
        wwwViadComDataV2_SQR.ArrayOfSimpleSqr  ArrayOfSimpleSqr = new wwwViadComDataV2_SQR.ArrayOfSimpleSqr ();
        wwwViadComDataV2_SQR.Sqr  Sqr = new wwwViadComDataV2_SQR.Sqr ();
        wwwViadComDataV2_SQR.ArrayOfLookup  ArrayOfLookup = new wwwViadComDataV2_SQR.ArrayOfLookup ();
        wwwViadComDataV2_SQR.SqrOrderLine   SqrOrderLine  = new wwwViadComDataV2_SQR.SqrOrderLine();
        wwwViadComDataV2_SQR.Lookup  Lookup = new wwwViadComDataV2_SQR.Lookup ();
        wwwViadComDataV2_SQR.SqrSummary  SqrSummary = new wwwViadComDataV2_SQR.SqrSummary ();
        wwwViadComDataV2_SQR.ArrayOfSqrSummary   ArrayOfSqrSummary  = new wwwViadComDataV2_SQR.ArrayOfSqrSummary();
        wwwViadComDataV2_SQR.SqrCreateMultiItemRequest  SqrCreateMultiItemRequest = new wwwViadComDataV2_SQR.SqrCreateMultiItemRequest();
        wwwViadComDataV2_SQR.SqrUpdateRequest  SqrUpdateRequest = new wwwViadComDataV2_SQR.SqrUpdateRequest ();
    }
    
    static testMethod void wwwViadComV2_SQRTest() {
        wwwViadComV2_SQR wwwViadComV2_SQR= new wwwViadComV2_SQR();
        wwwViadComV2_SQR.UpdateSqr_element UpdateSqr_element= new wwwViadComV2_SQR.UpdateSqr_element();
        wwwViadComV2_SQR.GetSqrDefaultsResponse_element GetSqrDefaultsResponse_element= new wwwViadComV2_SQR.GetSqrDefaultsResponse_element();
        wwwViadComV2_SQR.GetSqrProblems_element GetSqrProblems_element= new wwwViadComV2_SQR.GetSqrProblems_element();
        wwwViadComV2_SQR.SubmitSqrResponse_element SubmitSqrResponse_element= new wwwViadComV2_SQR.SubmitSqrResponse_element();
        wwwViadComV2_SQR.GetSqrDetails_element GetSqrDetails_element= new wwwViadComV2_SQR.GetSqrDetails_element();
        wwwViadComV2_SQR.UpdateSqrResponse_element UpdateSqrResponse_element= new wwwViadComV2_SQR.UpdateSqrResponse_element();
        wwwViadComV2_SQR.SubmitSimpleSqrResponse_element SubmitSimpleSqrResponse_element= new wwwViadComV2_SQR.SubmitSimpleSqrResponse_element();
        wwwViadComV2_SQR.GetSimpleSqrsResponse_element  GetSimpleSqrsResponse_element = new wwwViadComV2_SQR.GetSimpleSqrsResponse_element ();
        wwwViadComV2_SQR.GetSqrTally_element GetSqrTally_element= new wwwViadComV2_SQR.GetSqrTally_element();
        wwwViadComV2_SQR.GetSqrSummary_element GetSqrSummary_element= new wwwViadComV2_SQR.GetSqrSummary_element();
        wwwViadComV2_SQR.GetSqrDefaults_element  GetSqrDefaults_element = new wwwViadComV2_SQR.GetSqrDefaults_element ();
        wwwViadComV2_SQR.SubmitMultiItemSqr_element   SubmitMultiItemSqr_element  = new wwwViadComV2_SQR.SubmitMultiItemSqr_element  ();
        wwwViadComV2_SQR.GetSimpleSqrs_element GetSimpleSqrs_element= new wwwViadComV2_SQR.GetSimpleSqrs_element();
        wwwViadComV2_SQR.SubmitMultiItemSqrResponse_element SubmitMultiItemSqrResponse_element= new wwwViadComV2_SQR.SubmitMultiItemSqrResponse_element();
        wwwViadComV2_SQR.SubmitSimpleSqr_element  SubmitSimpleSqr_element = new wwwViadComV2_SQR.SubmitSimpleSqr_element ();
        wwwViadComV2_SQR.SubmitSqr_element SubmitSqr_element= new wwwViadComV2_SQR.SubmitSqr_element();
        wwwViadComV2_SQR.GetSqrSummaryResponse_element  GetSqrSummaryResponse_element = new wwwViadComV2_SQR.GetSqrSummaryResponse_element ();
        wwwViadComV2_SQR.GetSqrDetailsResponse_element  GetSqrDetailsResponse_element = new wwwViadComV2_SQR.GetSqrDetailsResponse_element ();
        
    }
    
    
}