@isTest
public class SQRServiceClient_Test
{
    static Testmethod void SQRServiceClient1()
    {
        Account acc = TestDataUtil.CreateTestFacility(); 
        Account acc1 = TestDataUtil.CreateTestFirm(); 
        Contact con = TestDataUtil.CreateTestContact(acc1.Id);
        Show__c show = TestDataUtil.CreateTestShow(acc1.id);
        
        Test.startTest();
        Opportunity opp = TestDataUtil.CreateTestSalesRepOpp(acc.Id, acc1.Id, show.Id);
        Oracle_Show_Booth__c booth = TestDataUtil.CreateTestBooth(acc1.Id, opp.id, '1111', show.Id);
        Test.stopTest();
        
        CaseToSQRSetting__c ct = new CaseToSQRSetting__c();
        ct.Name = 'CaseToSQR Webservice Authentication';
        ct.ApplicationID__c = 'SalesForce';
        ct.ApplicationKey__c =  '76v.H-_7};9^+4(]J.;3';
        ct.Authentication_EndPoint__c =  'https://qaapi.viad.com/Security/v2/AuthenticationService.svc';
        ct.Client_EndPoint__c =  '';
        ct.EndPoint__c =  'http://qaapi.viad.com/GES/v2/SqrService.svc';
        ct.Password__c =  'coresqr';
        ct.Username__c =  'welcome#123';
        insert ct;
        
        Test.setMock(WebServiceMock.class, new SQRServiceClientMockImpl());
        Case c = new Case();
        c.Subject = 'sub';
        c.Booth__c = booth.Id;
        insert c;
        
        CaseComment cc = new CaseComment();
        cc.parentId = c.Id;
        cc.commentbody = 'test';
        insert cc;
        
        SQRServiceClient.submitCaseSQRs(c.Id);  
    }   
    static Testmethod void SQRServiceClient2()
    {
        Account acc = TestDataUtil.CreateTestFacility(); 
        Account acc1 = TestDataUtil.CreateTestFirm(); 
        Contact con = TestDataUtil.CreateTestContact(acc1.Id);
        Show__c show = TestDataUtil.CreateTestShow(acc1.id);
        
        Test.startTest();
        Opportunity opp = TestDataUtil.CreateTestSalesRepOpp(acc.Id, acc1.Id, show.Id);
        Oracle_Show_Booth__c booth = TestDataUtil.CreateTestBooth(acc1.Id, opp.id, '1111', show.Id);
        Test.stopTest();
        
        CaseToSQRSetting__c ct = new CaseToSQRSetting__c();
        ct.Name = 'CaseToSQR Webservice Authentication';
        ct.ApplicationID__c = 'SalesForce';
        ct.ApplicationKey__c =  '76v.H-_7};9^+4(]J.;3';
        ct.Authentication_EndPoint__c =  'https://qaapi.viad.com/Security/v2/AuthenticationService.svc';
        ct.Client_EndPoint__c =  '';
        ct.EndPoint__c =  'http://qaapi.viad.com/GES/v2/SqrService.svc';
        ct.Password__c =  'coresqr';
        ct.Username__c =  'welcome#123';
        insert ct;
        
        Test.setMock(WebServiceMock.class, new SQRServiceClientMockImpl());
        Case c = new Case();
        c.Subject = 'sub';
        c.Booth__c = booth.Id;
        c.CORE_SQR_ID__c = '1';
        c.CORE_SQR_Last_Sent_Date__c = system.now();
        insert c;
        
        CaseComment cc = new CaseComment();
        cc.parentId = c.Id;
        cc.commentbody = 'test';
        insert cc;
        
        SQRServiceClient.submitCaseSQRs(c.Id);   
    } 
      
    static Testmethod void SQRServiceClient3()
    {
        Account acc = TestDataUtil.CreateTestFacility(); 
        Account acc1 = TestDataUtil.CreateTestFirm(); 
        Contact con = TestDataUtil.CreateTestContact(acc1.Id);
        Show__c show = TestDataUtil.CreateTestShow(acc1.id);
        User u = GC_TestUtils.createUser('System Administrator', 'Twilio', 'Integration');
        
        Test.startTest();
        Opportunity opp = TestDataUtil.CreateTestSalesRepOpp(acc.Id, acc1.Id, show.Id);
        Oracle_Show_Booth__c booth = TestDataUtil.CreateTestBooth(acc1.Id, opp.id, '1111', show.Id);
        Test.stopTest();
        
        CaseToSQRSetting__c ct = new CaseToSQRSetting__c();
        ct.Name = 'CaseToSQR Webservice Authentication';
        ct.ApplicationID__c = 'SalesForce';
        ct.ApplicationKey__c =  '76v.H-_7};9^+4(]J.;3';
        ct.Authentication_EndPoint__c =  'https://qaapi.viad.com/Security/v2/AuthenticationService.svc';
        ct.Client_EndPoint__c =  '';
        ct.EndPoint__c =  'http://qaapi.viad.com/GES/v2/SqrService.svc';
        ct.Password__c =  'coresqr';
        ct.Username__c =  'welcome#123';
        insert ct;
        
        Test.setMock(WebServiceMock.class, new SQRServiceClientMockImpl());
        List<Case> listCase = new List<Case>();
        
        System.runAs(u) {
            Case c1 = new Case();
            c1.Subject = 'sub';
            c1.Booth__c = booth.Id;
            c1.CORE_SQR_ID__c = '1';
            c1.ContactId = con.Id;
            c1.GES_Type__c = 'Labor';
            listCase.add(c1);
            
            insert listCase;
            
            CaseComment cc1 = new CaseComment();
            cc1.parentId = c1.Id;
            cc1.commentbody = 'test';
            insert cc1;
        }
        SQRServiceClient.submitCaseSQRs(listCase[0].Id);
    }
    
    static Testmethod void SQRServiceClient4()
    {
        Account acc = TestDataUtil.CreateTestFacility(); 
        Account acc1 = TestDataUtil.CreateTestFirm(); 
        Contact con = TestDataUtil.CreateTestContact(acc1.Id);
        Show__c show = TestDataUtil.CreateTestShow(acc1.id);
        User u = GC_TestUtils.createUser('System Administrator', 'Twilio', 'Integration');
        
        Test.startTest();
        Opportunity opp = TestDataUtil.CreateTestSalesRepOpp(acc.Id, acc1.Id, show.Id);
        Oracle_Show_Booth__c booth = TestDataUtil.CreateTestBooth(acc1.Id, opp.id, '1111', show.Id);
        Test.stopTest();
        
        CaseToSQRSetting__c ct = new CaseToSQRSetting__c();
        ct.Name = 'CaseToSQR Webservice Authentication';
        ct.ApplicationID__c = 'SalesForce';
        ct.ApplicationKey__c =  '76v.H-_7};9^+4(]J.;3';
        ct.Authentication_EndPoint__c =  'https://qaapi.viad.com/Security/v2/AuthenticationService.svc';
        ct.Client_EndPoint__c =  '';
        ct.EndPoint__c =  'http://qaapi.viad.com/GES/v2/SqrService.svc';
        ct.Password__c =  'coresqr';
        ct.Username__c =  'welcome#123';
        insert ct;
        
        Test.setMock(WebServiceMock.class, new SQRServiceClientMockImpl());
        List<Case> listCase = new List<Case>();
        
        System.runAs(u) {
            Case c1 = new Case();
            c1.Subject = 'sub';
            c1.Booth__c = booth.Id;
            c1.CORE_SQR_ID__c = '1';
            c1.ContactId = con.Id;
            c1.GES_Type__c = 'Labor';
            listCase.add(c1);
            
            insert listCase;
            
            List<Core_SQR__c> listCaseSQR = new List<Core_SQR__c>();
            Core_SQR__c cSQR2 = new Core_SQR__c();
            cSQR2.Name = '122345565';
            cSQR2.GES_Type__c = 'Labor';
            cSQR2.Case__c = c1.Id;
            listCaseSQR.add(cSQR2);
            
            insert listCaseSQR;
            
            CaseComment cc1 = new CaseComment();
            cc1.parentId = c1.Id;
            cc1.commentbody = 'test';
            insert cc1;
        }
        SQRServiceClient.submitCaseSQRs(listCase[0].Id);
    }
    
    
}