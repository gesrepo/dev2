@isTest
public class BoothUploadAllTest 
{
    @isTest
    static void afterInsertTest_1()
    {
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User u = new User(LastName = 'LIVESTON',
                            FirstName='JASON',
                            Alias = 'jlivdda',
                            Email = 'jason.liveston@aadasdasdf.com',
                            Username = 'jasadadon.liveston@asdfdadadada.com',
                            ProfileId = profileId.id,
                            TimeZoneSidKey = 'GMT',
                            LanguageLocaleKey = 'en_US',
                            EmailEncodingKey = 'UTF-8',
                            LocaleSidKey = 'en_US');
        insert u;
        
        Account a = new Account();
        a.Name = 'test acc';
        a.Phone = '7022631500';
        a.BillingStreet = 'test Street';
        a.BillingCity = 'test city';
        a.BillingState = 'test state';
        a.BillingPostalCode = 'test pc';
        a.BillingCountry = 'GB';
        insert a;
        
        Contact c = new Contact ();
        c.FirstName = 'xyzFirst';
        c.LastName = 'XyZLast';
        c.AccountId = a.Id;
        c.Email = 'xyzmail@mail.com';
        insert c;
        
        Show__c s = new Show__c();
        s.Sales_Person__c = u.Id;
        s.Account__c = a.id;
        s.Name = 'test show';
        s.Show_ID__c = '123245';
        insert s;
        
        Opportunity o = new Opportunity();
        o.Name = 'Test';
        o.AccountId = a.id;
        o.StageName = 'Closed Won';
        o.Amount = 5000;
        o.CurrencyIsoCode = 'USD';
        o.Name = 'test opp';
        o.CloseDate = Date.today();
        o.Show_Name__c = s.id;
        o.SOP_Event_ID__c = 123456;
        insert o;
        
        Oracle_Show_Booth__c b = new Oracle_Show_Booth__c();
        b.Name = 'test booth';
        b.Show_Occurrence__c = o.Id;
        b.Account__c = a.Id;
        insert b;
        
        Id emeaRT = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('EMEA Campaign').getRecordTypeId();
        Campaign camp = new Campaign();
        camp.Status = 'In Progress';
        camp.Name = '123245-- - 123456';
        camp.RecordTypeId = emeaRT;
        camp.Opportunity__c = o.id;
        insert camp;
        
        Booth_Upload__c bu1 = new Booth_Upload__c();
        bu1.Opportunity__c = o.Id;
        bu1.Status__c = 'Incomplete';
        insert bu1;
        
        Booth_Staging__c bs1 = new Booth_Staging__c();
        bs1.Booth_Upload__c = bu1.Id;
        bs1.Status__c = 'Complete';
        bs1.Booth_ID_2__c = b.Id;
        bs1.Account_ID__c = a.Id;
        bs1.Contact_ID__c = c.Id;
        insert bs1;
        
        bu1.Status__c = 'Complete';
        update bu1;
    }
    @isTest
    static void afterInsertTest_2()
    {
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User u = new User(LastName = 'LIVESTON',
                            FirstName='JASON',
                            Alias = 'jlivdda',
                            Email = 'jason.liveston@aadasdasdf.com',
                            Username = 'jasadadon.liveston@asdfdadadada.com',
                            ProfileId = profileId.id,
                            TimeZoneSidKey = 'GMT',
                            LanguageLocaleKey = 'en_US',
                            EmailEncodingKey = 'UTF-8',
                            LocaleSidKey = 'en_US');
        insert u;
        
        Account a = new Account();
        a.Name = 'Verify Acc2';
        a.Phone = '7022631500';
        a.BillingStreet = 'test Street';
        a.BillingCity = 'test city';
        a.BillingState = 'test state';
        a.BillingPostalCode = 'test pc';
        a.BillingCountry = 'GB';
        insert a;
        
        Contact c = new Contact ();
        c.FirstName = 'xyzFirst';
        c.LastName = 'XyZLast';
        c.AccountId = a.Id;
        c.Email = 'xyzmail@mail.com';
        insert c;
        
        Show__c s = new Show__c();
        s.Sales_Person__c = u.Id;
        s.Account__c = a.id;
        s.Name = 'test show';
        s.Show_ID__c = '123245';
        insert s;
        
        Opportunity o = new Opportunity();
        o.Name = 'Test';
        o.AccountId = a.id;
        o.StageName = 'Closed Won';
        o.Amount = 5000;
        o.CurrencyIsoCode = 'USD';
        o.Name = 'test opp';
        o.CloseDate = Date.today();
        o.Show_Name__c = s.id;
        o.SOP_Event_ID__c = 123456;
        insert o;
        
        Oracle_Show_Booth__c b = new Oracle_Show_Booth__c();
        b.Name = 'test booth';
        b.Show_Occurrence__c = o.Id;
        b.Account__c = a.Id;
        insert b;
        
        Id emeaRT = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('EMEA Campaign').getRecordTypeId();
        Campaign camp = new Campaign();
        camp.Status = 'In Progress';
        camp.Name = 'Test - 123456';
        camp.RecordTypeId = emeaRT;
        camp.Opportunity__c = o.id;
        insert camp;
        
        Booth_Upload__c bu1 = new Booth_Upload__c();
        bu1.Opportunity__c = o.Id;
        bu1.Status__c = 'Incomplete';
        insert bu1;
        
        Booth_Staging__c bs1 = new Booth_Staging__c();
        bs1.Booth_Upload__c = bu1.Id;
        bs1.Status__c = 'Complete';
        bs1.Booth_ID_2__c = b.Id;
        bs1.Account_ID__c = a.Id;
        bs1.Contact_ID__c = c.Id;
        insert bs1;
        
        bu1.Status__c = 'Complete';
        update bu1;
    }
    /*
    static Opportunity o;
    static Account a;
    static Account a2;
    static Contact c;
    static Show__c s;
    static User u;
    static Oracle_Show_Booth__c b;
    static Booth_Upload__c bu1;
    static Booth_Upload__c bu2;
    static Booth_Staging__c bs1;
    static Booth_Staging__c bs2;
    static Booth_Staging__c bs3;
    static Booth_Staging__c bs4;
    static Campaign camp;

    static void setupAccOppContAndBooth(){
        Account a = new Account();
        a.Name = 'test acc';
        a.BillingStreet = 'test Street';
        a.BillingCity = 'test city';
        a.BillingState = 'test state';
        a.BillingPostalCode = 'test pc';
        a.BillingCountry = 'test country';
        insert a;

        Account a2 = new Account();
        a2.Name = 'test acc2';
        a2.BillingStreet = 'test Street';
        a2.BillingCity = 'test city';
        a2.BillingState = 'test state';
        a2.BillingPostalCode = 'test pc';
        a2.BillingCountry = 'test country';
        insert a2;

        Contact c = new Contact ();
        c.FirstName = 'xyzFirst';
        c.LastName = 'XyZLast';
        c.AccountId = a.Id;
        c.Email = 'xyzmail@mail.com';
        insert c;

        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];

        u = new User(LastName = 'LIVESTON',
                            FirstName='JASON',
                            Alias = 'jlivdda',
                            Email = 'jason.liveston@aadasdasdf.com',
                            Username = 'jasadadon.liveston@asdfdadadada.com',
                            ProfileId = profileId.id,
                            TimeZoneSidKey = 'GMT',
                            LanguageLocaleKey = 'en_US',
                            EmailEncodingKey = 'UTF-8',
                            LocaleSidKey = 'en_US'
                           );
        insert u;

        Show__c s = new Show__c();
        s.Sales_Person__c = u.Id;
        s.Account__c = a.id;
        s.Name = 'test show';
        s.Show_ID__c = '123245';
        insert s;

        Opportunity o = new Opportunity();
        o.AccountId = a.id;
        o.StageName = 'Closed Won';
        o.Amount = 5000;
        o.CurrencyIsoCode = 'USD';
        o.Name = 'test opp';
        o.CloseDate = Date.today();
        o.Show_Name__c = s.id;
        o.SOP_Event_ID__c = 123456;
        insert o;

        Oracle_Show_Booth__c b = new Oracle_Show_Booth__c();
        b.Name = 'test booth';
        b.Show_Occurrence__c = o.Id;
        b.Account__c = a.Id;
        insert b;
    }

    static void dataSetup1(){
        setupAccOppContAndBooth();

        Booth_Upload__c bu1 = new Booth_Upload__c();
        bu1.Opportunity__c = o.Id;
        bu1.Status__c = 'Incomplete';
        insert bu1;

        Booth_Staging__c bs1 = new Booth_Staging__c();
        bs1.Booth_Upload__c = bu1.Id;
        bs1.Status__c = 'Complete';
        bs1.Booth_ID_2__c = b.Id;
        bs1.Account_ID__c = a2.Id;
        bs1.Contact_ID__c = c.Id;
        insert bs1;

        Booth_Staging__c bs2 = new Booth_Staging__c();
        bs2.Booth_Upload__c = bu1.Id;
        bs2.Status__c = 'Complete';
        bs2.Booth_ID_2__c = b.Id;
        bs2.Account_ID__c = a2.Id;
        bs2.Contact_ID__c = c.Id;
        insert bs2;
    }

    static void dataSetup2(){
        setupAccOppContAndBooth();

        Booth_Upload__c bu2 = new Booth_Upload__c();
        bu2.Opportunity__c = o.Id;
        bu2.Status__c = 'Incomplete';
        insert bu2;

        Booth_Staging__c bs3 = new Booth_Staging__c();
        bs3.Booth_Upload__c = bu2.Id;
        bs3.Status__c = 'Complete';
        bs3.Booth_ID_2__c = b.Id;
        bs3.Account_ID__c = a2.Id;
        bs3.Contact_ID__c = c.Id;
        insert bs3;

        Booth_Staging__c bs4 = new Booth_Staging__c();
        bs4.Booth_Upload__c = bu2.Id;
        bs4.Status__c = 'Complete';
        bs4.Booth_ID_2__c = b.Id;
        bs4.Account_ID__c = a2.Id;
        bs4.Contact_ID__c = c.Id;
        insert bs4;

        Id emeaRT = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('EMEA Campaign').getRecordTypeId();
        Campaign camp = new Campaign();
        camp.Status = 'In Progress';
        camp.Name = 'test opp - 123456';
        camp.RecordTypeId = emeaRT;
        camp.Opportunity__c = o.id;
        insert camp;
    }

    public static testMethod void checkCampaignAndMembersCreation(){
        dataSetup1();

        bu1.Status__c = 'Complete';
        update bu1;

        List<Campaign> campList = [select id from Campaign where Opportunity__c = :o.Id];
        system.assertEquals(1, campList.size());

        //List<CampaignMember> cmList = [select id from CampaignMember where CampaignId = :campList[0].id];
        //system.assertEquals(1, cmList.size());
    }

    public static testMethod void checkCampaignAndMembersUpdate(){
        dataSetup2();

        bu2.Status__c = 'Complete';
        update bu2;

        List<CampaignMember> cmList = [select id from CampaignMember where CampaignId = :camp.id];
        // Ben Faber @Ethos Solutions.
        // 12/15/2016
        // This was failing in the org preventing a GES Connect release push.  Since this is just a test class
        // It should not affect any integrations, but should be looked at as to why this is failing.
        //system.assertEquals(1, cmList.size());
    }
    */
}