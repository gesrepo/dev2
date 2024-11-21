@isTest
public class CasetoSQR_Test {
    private static testMethod void casetosqr1(){
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
        
        Case c1 = new Case();
        c1.Subject = 'sub';
        c1.CORE_SQR_ID__c = '1';
        insert c1;
        
        CaseComment cc = new CaseComment();
        cc.parentId = c1.Id;
        cc.commentbody = 'test';
        insert cc;
        
        CasetoSQR cs1 = new CasetoSQR (new ApexPages.StandardController(c1));
        cs1.Cancel();
        cs1.save();
        
        
        Case c2 = new Case();
        c2.Subject = 'sub';
        c2.Booth__c = booth.Id;
        c2.CORE_SQR_ID__c = '1';
        insert c2;
        CasetoSQR cs2 = new CasetoSQR (new ApexPages.StandardController(c2));
        cs2.save();
        
        Case c3 = new Case();
        c3.Subject = 'sub';
        c3.Booth__c = booth.Id;
        c3.CORE_SQR_ID__c = '1';
        c3.GES_Type__c = 'Audio Visual';
        insert c3;
        CasetoSQR cs3 = new CasetoSQR (new ApexPages.StandardController(c3));
        cs3.save();
        
        Case c4 = new Case();
        c4.Subject = 'sub';
        c4.Booth__c = booth.Id;
        c4.CORE_SQR_ID__c = '1';
        c4.GES_Type__c = 'Audio Visual';
        c4.reason__c = 'test';
        insert c4;
        CasetoSQR cs4 = new CasetoSQR (new ApexPages.StandardController(c4));
        cs4.save();
        
        
        Case c5 = new Case();
        c5.Subject = 'sub';
        c5.Booth__c = booth.Id;
        c5.CORE_SQR_ID__c = '1';
        c5.GES_Type__c = 'Audio Visual';
        c5.reason__c = 'test';
        c5.Send_CORE_SQR_Status__c = 'In Process';
        insert c5;
        CasetoSQR cs5 = new CasetoSQR (new ApexPages.StandardController(c5));
        cs5.save();
        
        
        Case c6 = new Case();
        c6.Subject = 'sub';
        c6.Booth__c = booth.Id;
        c6.CORE_SQR_ID__c = '1';
        c6.GES_Type__c = 'Audio Visual';
        c6.reason__c = 'test';
        c6.Send_CORE_SQR_Status__c = 'In Process';
        insert c6;
        CasetoSQR cs6 = new CasetoSQR (new ApexPages.StandardController(c6));
        cs6.save();
        
    }
}