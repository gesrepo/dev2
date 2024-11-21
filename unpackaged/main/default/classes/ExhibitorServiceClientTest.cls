/**************************************
Author          : Mohd Sajid
Release         : April 18, 2023
Created         : April 10, 2023
Functionality   : this class covers to ExhibitorServiceClient
Itrack#   		: sfdc-202

Modification History:
Itrack#        Date                Author                         Change  
****************************************************************************

***********************************************************************************/
@isTest
public class ExhibitorServiceClientTest {
    
    @testSetup static void setupTestData() {
        
        ShowsiteContactSetting__c ct = new ShowsiteContactSetting__c();
        ct.Name = 'ContactToCore Webservice Auth';
        ct.ApplicationID__c = 'SalesForce';
        ct.ApplicationKey__c =  '76v.H-_7};9^+4(]J.;3';
        ct.Authentication_EndPoint__c =  'https://qaapi.viad.com/Security/v2/AuthenticationService.svc';
        ct.Client_EndPoint__c =  '';
        ct.EndPoint__c =  'http://qaapi.viad.com/ges/v1/ExhibitorService.svc';
        ct.Password__c =  'coresqr';
        ct.Username__c =  'welcome#123';
        insert ct;
        
    }
	
    public static testMethod void AddShowSiteContactTest() {
		//Contact co = [Select id from Contact limit 1];
        //Oracle_Show_Booth__c bo = [Select id from Oracle_Show_Booth__c limit 1];
        
        Account acc = TestDataUtil.CreateTestFacility(); 
        Account acc1 = TestDataUtil.CreateTestFirm(); 
        Contact co = TestDataUtil.CreateTestContact(acc1.Id);
        Show__c show = TestDataUtil.CreateTestShow(acc1.id);
        Opportunity opp = TestDataUtil.CreateTestSalesRepOpp(acc.Id, acc1.Id, show.Id);
        Test.startTest();
        Oracle_Show_Booth__c bo = TestDataUtil.CreateTestBooth(acc1.Id, opp.id, '1111', show.Id);
        bo.SHOW_OCCR_CUST_ID__c = '232333';
        bo.BOOTH_ID__c = '112221';
        update bo;
        
        Test.setMock(WebServiceMock.class, new ExhibitorServiceClientMockImpl());
        
        Oracle_Show_Booth_Contact__c bc = new Oracle_Show_Booth_Contact__c();
        bc.Contact__c = co.Id;
        bc.Oracle_Show_Booth__c = bo.Id;
        bc.FIRST_NAME__c = 'Abc';
        bc.LAST_NAME__c = 'Test';
        //bc.CUST_CONT_ID__c = '123456';
        bc.SHOW_OCCR_CUST_ID__c = '123456';
        bc.CUST_BOOTH_ID__c = '123456';
        bc.PRIMARY_FLAG__c = 'Y';
        bc.COUNTRY_CODE__c = '1';
        bc.PHONE__c = '5123233333';
        bc.EXTENSION__c = 23444;
        bc.FAX__c = '234323333';
        bc.EMAIL__c = 'tset@test.test';
        insert bc;
        
        ExhibitorServiceClient.submitContactToCore(bc.Id);
        Test.stopTest();
    }
    
    public static testMethod void UpdateShowSiteContactTest() {
		Account acc = TestDataUtil.CreateTestFacility(); 
        Account acc1 = TestDataUtil.CreateTestFirm(); 
        Contact co = TestDataUtil.CreateTestContact(acc1.Id);
        Show__c show = TestDataUtil.CreateTestShow(acc1.id);
        Opportunity opp = TestDataUtil.CreateTestSalesRepOpp(acc.Id, acc1.Id, show.Id);
        Test.startTest();
        Oracle_Show_Booth__c bo = TestDataUtil.CreateTestBooth(acc1.Id, opp.id, '1111', show.Id);
        bo.SHOW_OCCR_CUST_ID__c = '232333';
        bo.BOOTH_ID__c = '112221';
        update bo;
        
        
        Test.setMock(WebServiceMock.class, new ExhibitorServiceClientMockImpl());
        
        Oracle_Show_Booth_Contact__c bc = new Oracle_Show_Booth_Contact__c();
        bc.Contact__c = co.Id;
        bc.Oracle_Show_Booth__c = bo.Id;
        bc.FIRST_NAME__c = 'Abc';
        bc.LAST_NAME__c = 'Test';
        bc.CUST_CONT_ID__c = '123456';
        bc.SHOW_OCCR_CUST_ID__c = '123456';
        bc.CUST_BOOTH_ID__c = '123456';
        bc.PRIMARY_FLAG__c = 'Y';
        bc.COUNTRY_CODE__c = '1';
        bc.PHONE__c = '5123233333';
        bc.EXTENSION__c = 23444;
        bc.FAX__c = '234323333';
        bc.EMAIL__c = 'tset@test.test';
        insert bc;
        
        ExhibitorServiceClient.submitContactToCore(bc.Id);
        Test.stopTest();
        
    }
    
}