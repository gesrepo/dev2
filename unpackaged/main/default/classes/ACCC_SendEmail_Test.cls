@isTest
public class ACCC_SendEmail_Test {     
    public static List<Case> Caselist{set;get;}
    static Testmethod void ACCC_SendEmail(){
        
        test.startTest();
        Account acc1 = TestDataUtil.CreateTestFirm(); 
        Opportunity opp = new Opportunity();
        opp.Job_Number__c = '20121231';
        opp.Sales_Location__c = '110- Las Vegas';
        opp.Name = 'MyTestShow # 1';
        opp.Prime_Contractor__c = null;
        opp.Production_Location__c = '110- Las Vegas';
        opp.StageName = 'SL1';
        opp.Amount = 1000;
        opp.Probability = 25;
        opp.Type = 'ITYFTY';
        opp.New_Repeat__c = 'New';
        opp.Frequency__c = 'B1';
        opp.AccountId = acc1.Id;
        opp.RecordTypeId = TestDataUtil.OpportunitySalesRepRecordTypeId;        
        opp.Show_Open_Date__c = Date.newInstance(2012,12,1);
        opp.Show_Close_Date__c = Date.newInstance(2012,12,2);
        opp.CloseDate = Date.newInstance(2012,12,2);
        Database.insert(opp);
        
        Oracle_Show_Booth__c booth = new  Oracle_Show_Booth__c();
        booth.Account__c = acc1.Id;
        booth.Show_Occurrence__c = opp.Id;        
        booth.BOOTH_CREATION_DATE__c = DateTime.now();
        booth.BOOTH_LAST_UPDATE_DATE__c = DateTime.now();
        booth.BOOTH_LENGTH__c = 10;
        booth.BOOTH_NUMBER__c = '10001';
        booth.BOOTH_SHARED_FLAG__c = 'N';
        booth.BOOTH_SIZE__c = 100;
        booth.BOOTH_TYPE__c = 'INLINE';
        booth.BOOTH_WIDTH__c = 10;
        booth.CUST_ACCOUNT_ID__c = '100001';
        booth.BOOTH_ID__c = '1000001';
        booth.ED_FLAG__c = false;
        booth.INACTIVE_FLAG__c = false;            
        booth.PROJECT_NUMBER__c = '111111';
        booth.THIRD_PARTY_FLAG__c = false;
        booth.SHOW_ORG_FLAG__c =  false;
        Database.insert(booth);
        test.stopTest();
        
        Case c = new Case();
        c.RecordTypeId = SObjectType.Case.getRecordTypeInfosByName().get('GES US Service').getRecordTypeId();
        c.Subject = 'Some subject';
        c.AccountId = acc1.Id;
        c.Booth__c = booth.id;
        c.Show_Opportunity__c = opp.Id;
        c.Show_Status__c = '1-Pre';
        c.GES_Type__c = 'Billing Error';
        c.Reason__c = 'Adv Receiving';
        c.Customer_Type__c = 'Exhibitor';
        c.Escalated_To__c = '8 - None';
        c.Priority = 'Low Priority';
        c.Status = 'Open';
        c.Substatus__c = 'None Required';
        insert c;
        Test.setMock(WebServiceMock.class, new ACCC_SendEmail_Mock());
        ACCC_SendEmail.sendMinimalPaymentMail(c.Id);
        
    }
    
    static Testmethod void ACCC_SendEmail2(){
        
        test.startTest();
        Account acc1 = TestDataUtil.CreateTestFirm(); 
        Opportunity opp = new Opportunity();
        opp.Job_Number__c = '20121231';
        opp.Sales_Location__c = '110- Las Vegas';
        opp.Name = 'MyTestShow # 1';
        opp.Prime_Contractor__c = null;
        opp.Production_Location__c = '110- Las Vegas';
        opp.StageName = 'SL1';
        opp.Amount = 1000;
        opp.Probability = 25;
        opp.Type = 'ITYFTY';
        opp.New_Repeat__c = 'New';
        opp.Frequency__c = 'B1';
        opp.AccountId = acc1.Id;
        opp.RecordTypeId = TestDataUtil.OpportunitySalesRepRecordTypeId;        
        opp.Show_Open_Date__c = Date.newInstance(2012,12,1);
        opp.Show_Close_Date__c = Date.newInstance(2012,12,2);
        opp.CloseDate = Date.newInstance(2012,12,2);
        Database.insert(opp);
        
        Oracle_Show_Booth__c booth = new  Oracle_Show_Booth__c();
        booth.Account__c = acc1.Id;
        booth.Show_Occurrence__c = opp.Id;        
        booth.BOOTH_CREATION_DATE__c = DateTime.now();
        booth.BOOTH_LAST_UPDATE_DATE__c = DateTime.now();
        booth.BOOTH_LENGTH__c = 10;
        booth.BOOTH_NUMBER__c = '10001';
        booth.BOOTH_SHARED_FLAG__c = 'N';
        booth.BOOTH_SIZE__c = 100;
        booth.BOOTH_TYPE__c = 'INLINE';
        booth.BOOTH_WIDTH__c = 10;
        booth.CUST_ACCOUNT_ID__c = '100001';
        booth.BOOTH_ID__c = '1000001';
        booth.ED_FLAG__c = false;
        booth.INACTIVE_FLAG__c = false;            
        booth.PROJECT_NUMBER__c = '111111';
        booth.THIRD_PARTY_FLAG__c = false;
        booth.SHOW_ORG_FLAG__c =  false;
        Database.insert(booth);
        test.stopTest();
        
        Case c = new Case();
        c.RecordTypeId = SObjectType.Case.getRecordTypeInfosByName().get('GES US Service').getRecordTypeId();
        c.Subject = 'Some subject';
        c.AccountId = acc1.Id;
        c.Booth__c = booth.id;
        c.Show_Opportunity__c = opp.Id;
        c.Show_Status__c = '1-Pre';
        c.GES_Type__c = 'Billing Error';
        c.Reason__c = 'Adv Receiving';
        c.Customer_Type__c = 'Exhibitor';
        c.Escalated_To__c = '8 - None';
        c.Priority = 'Low Priority';
        c.Status = 'Open';
        c.Substatus__c = 'None Required';
        insert c;
        
        Test.setMock(WebServiceMock.class, new ACCC_SendEmail_Mock());
        ACCC_SendEmail.sendAnEmail(c.Id);
    }
    
    static Testmethod void ACCC_SendEmail3(){
        
        Account acc1 = TestDataUtil.CreateTestFirm(); 
        Opportunity opp = new Opportunity();
        opp.Job_Number__c = '20121231';
        opp.Sales_Location__c = '110- Las Vegas';
        opp.Name = 'MyTestShow # 1';
        opp.Prime_Contractor__c = null;
        opp.Production_Location__c = '110- Las Vegas';
        opp.StageName = 'SL1';
        opp.Amount = 1000;
        opp.Probability = 25;
        opp.Type = 'ITYFTY';
        opp.New_Repeat__c = 'New';
        opp.Frequency__c = 'B1';
        opp.AccountId = acc1.Id;
        opp.RecordTypeId = TestDataUtil.OpportunitySalesRepRecordTypeId;        
        opp.Show_Open_Date__c = Date.newInstance(2012,12,1);
        opp.Show_Close_Date__c = Date.newInstance(2012,12,2);
        opp.CloseDate = Date.newInstance(2012,12,2);
        Database.insert(opp);
        
        
        test.startTest();
        Case c = new Case();
        c.RecordTypeId = SObjectType.Case.getRecordTypeInfosByName().get('GES US Service').getRecordTypeId();
        c.Subject = 'Some subject';
        c.AccountId = acc1.Id;
        c.Show_Opportunity__c = opp.Id;
        c.Show_Status__c = '1-Pre';
        c.GES_Type__c = 'Billing Error';
        c.Reason__c = 'Adv Receiving';
        c.Customer_Type__c = 'Exhibitor';
        c.Escalated_To__c = '8 - None';
        c.Priority = 'Low Priority';
        c.Status = 'Open';
        c.Substatus__c = 'None Required';
        insert c;
        
        Test.setMock(WebServiceMock.class, new ACCC_SendEmail_Mock());
        ACCC_SendEmail.sendAnEmail(c.Id);
        test.stopTest();
    }
}