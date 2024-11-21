@isTest
public class MessageTriggerTest {
    
    static testMethod void testMethod1() {
        
        Account Facility = new Account();
        Facility.Sales_Person__c = UserInfo.getUserId();
        Facility.Name = 'MyTestFacilityName';
        Facility.Type = 'Hotel';
        Facility.GES_Status__c = 'Preferred';
        Facility.LMS_Facility_ID__c = 'ABCFAC';
        Facility.BillingStreet = '950 Grier Dr';
        Facility.BillingCity = 'Las Vegas';
        Facility.BillingPostalCode = '89119-0000';
        Facility.BillingState = 'NV';
        Facility.BillingCountry = 'US';
        //Facility.RecordTypeId = FacilityRecordType.Id;
        Facility.RecordTypeId = SObjectType.Account.getRecordTypeInfosByName().get('Facility').getRecordTypeId();
        insert Facility;
        
        //Create Firm Account
        Account Firm = new Account();
        Firm.Sales_Person__c = UserInfo.getUserId();
        Firm.Name = 'SONY ENTERTAINMENT INC';
        Firm.Phone = '7022631500';
        Firm.BillingStreet = '950 Grier Dr';
        Firm.BillingCity = 'Las Vegas';
        Firm.BillingPostalCode = '89119-0000';
        Firm.BillingState = 'NV';
        Firm.BillingCountry = 'US';
        //Firm.RecordTypeId = FirmRecordType.Id;
        Firm.RecordTypeId = SObjectType.Account.getRecordTypeInfosByName().get('Firm').getRecordTypeId();
        insert Firm;
        
        Show__c show = TestDataUtil.CreateTestShow(firm.id);
        
        Opportunity Opp = new Opportunity();
        Opp.Job_Number__c = '20121231';
        Opp.Sales_Location__c = '110- Las Vegas';
        Opp.Name = 'MyTestShow 2';
        Opp.Prime_Contractor__c = null;
        Opp.Production_Location__c = '110- Las Vegas';
        Opp.Facility__c = facility.Id;
        Opp.StageName = 'SL1';
        Opp.Amount = 1000;
        Opp.Probability = 25;
        Opp.Type = 'ITYFTY';
        Opp.New_Repeat__c = 'New';
        Opp.Frequency__c = 'B1';
        Opp.AccountId = firm.Id;
        Opp.Show_Name__c = show.Id;
        Opp.RecordTypeId = TestDataUtil.OpportunitySalesRepRecordTypeId;        
        Opp.Show_Open_Date__c = Date.today();
        Opp.Show_Close_Date__c = Date.today() + 20;
        Opp.CloseDate = Date.today() + 20;
        insert Opp;
        
        Contact cont = new Contact();
        cont.LastName = 'Test Contact';
        cont.MobilePhone = '+19650102050';
        cont.Phone = '+19650102051';
        cont.Email = 'test@ges.com';
        cont.AccountId = Facility.Id;
        insert cont;
        
        Case c1 = new Case();
        c1.Subject = 'sub';
        c1.CORE_SQR_ID__c = '1';
        c1.GES_Type__c = 'Audio Visual';
        c1.reason__c = 'test';
        c1.Send_CORE_SQR_Status__c = 'In Process';
        c1.Status = 'Open';
        c1.Show_Opportunity__c = Opp.Id;
        insert c1;
        
        LiveChatVisitor visitor = new LiveChatVisitor();
        insert visitor;
        
        LiveChatTranscript chat = new LiveChatTranscript();
        chat.ContactId = cont.Id;
        chat.LiveChatVisitorId = visitor.Id;
        chat.CaseId = c1.Id;
        insert chat;
        
        List<TwilioSF__Message__c> listMsg = new List<TwilioSF__Message__c>();
        TwilioSF__Message__c tMsg = new TwilioSF__Message__c();
        tMsg.TwilioSF__Body__c='Body ';
        tMsg.TwilioSF__From_Number__c = '+19650102050';
        tMsg.TwilioSF__To_Number__c = '+17028205992';
        tMsg.TwilioSF__Direction__c = 'outbound';
        tMsg.TwilioSF__Date_Created__c = System.now();
        tMsg.TwilioSF__Contact__c = cont.Id;
        listMsg.add(tMsg);
        
        TwilioSF__Message__c tMsg2 = new TwilioSF__Message__c();
        tMsg2.TwilioSF__Body__c='Body ';
        tMsg2.TwilioSF__From_Number__c = '+17028205992';
        tMsg2.TwilioSF__To_Number__c = '+19650102050';
        tMsg2.TwilioSF__Direction__c = 'outbound';
        tMsg2.TwilioSF__Date_Created__c = System.now();
        tMsg2.TwilioSF__Contact__c = cont.Id;
        listMsg.add(tMsg2);
        
        TwilioSF__Message__c tMsg3 = new TwilioSF__Message__c();
        tMsg3.TwilioSF__Body__c='Body ';
        tMsg3.TwilioSF__From_Number__c = '+17027189991';
        tMsg3.TwilioSF__To_Number__c = '+19650102050';
        tMsg3.TwilioSF__Direction__c = 'outbound';
        tMsg3.TwilioSF__Date_Created__c = System.now();
        tMsg3.TwilioSF__Contact__c = cont.Id;
        listMsg.add(tMsg3);
        
        TwilioSF__Message__c tMsg4 = new TwilioSF__Message__c();
        tMsg4.TwilioSF__Body__c='This is my credit card 4222222222222';
        tMsg4.TwilioSF__From_Number__c = '+17027189991';
        tMsg4.TwilioSF__To_Number__c = '+19650102050';
        tMsg4.TwilioSF__Direction__c = 'outbound';
        tMsg4.TwilioSF__Date_Created__c = System.now();
        tMsg4.TwilioSF__Contact__c = cont.Id;
        listMsg.add(tMsg4);
        insert listMsg;  
    }
}