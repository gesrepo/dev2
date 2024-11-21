@isTest
private class TriggerEmailMessage_Test {
    @isTest static void test_method_one() {

        Test.startTest();
        Profile profile1 = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User testUser = new User(
        ProfileId = profile1.Id,
        Username ='DarkKnight@test.com',
        Alias = 'batman',
        Email='bruc1e.wayne@wayneenterprises.com',
        EmailEncodingKey='UTF-8',
        Firstname='Bruce',
        Lastname='Wayne',
        LanguageLocaleKey='en_US',
        LocaleSidKey='en_US',
        TimeZoneSidKey='America/Chicago'
        );
        insert(testUser);

        Account a = new Account(
            Name = 'Goguta are firma',
            Business_Type__c = 'Contractor',
            EMEA__c = false,
            Sync_with_Marketo__c = true,
            BillingCountry = 'India',
            //BillingAddress = 'India',
            Cust_Type__c = '01 Organiser'
            );
        insert a;
        
        Contact co = new Contact( LastName = 'Sarmala',
             Accountid = a.id,
             Sync_with_Marketo__c = true,            
             Marketo_Ignore__c = true,
             Phone = '07656788987665',
             email = 'Sarmala@gmail.com'
             );
        insert co;
        
        Id CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.CaseRecordType).getRecordTypeId();
        Case c = new Case(
            Account = a,
            Contact = co,
            RecordTypeId = CaseRecordTypeId,
            Origin = 'Phone',
            Customer_Type__c = 'Exhibitor',
            Show_Status__c = 'Showsite (Breakdown)',
            GES_Type__c = 'Furnishings',
            Reason__c = 'Placed Order',
            Priority = 'Low Priority',
            Status = 'Open'
            );
        insert c;


        Opportunity op1 = new Opportunity();
        op1.Name = 'opp1';
        op1.stageName = 'oppStage';
        op1.closeDate = Date.today();
        insert op1;
        Booth_Upload__c bu = new Booth_Upload__c();
        bu.Opportunity__c = op1.id;
        insert bu;
        Booth_Staging__c b = new Booth_Staging__c();
        b.Booth_Upload__c = bu.id;
        b.Status__c = 'New';
        insert b;

        Show__c theShow = new Show__c();
        theShow.Sales_Person__c = testUser.id;
        theShow.Account__c = a.id;
        theShow.Name = 'TheShow';
        theShow.Show_Type__c = 'Food Sector';
        theShow.Show_ID__c = 'fasdsd';
        theShow.CurrencyIsoCode = 'USD';
        insert theShow;



        Oracle_Show_Booth__c bo = new Oracle_Show_Booth__c();
        bo.Name = 'boooooo';
        bo.Account__c = a.id;
        bo.Show_Occurrence__c = op1.id;
        insert bo;


        Case c2 = new Case(
            Account = a,
            Contact = co,
            RecordTypeId = CaseRecordTypeId,
            Origin = 'Phone',
            Customer_Type__c = 'Exhibitor',
            Show_Status__c = 'Showsite (Breakdown)',
            GES_Type__c = 'Furnishings',
            Reason__c = 'Placed Order',
            Priority = 'Low Priority',
            Status = 'Open',
            Booth__c = bo.id,
            Show_Opportunity__c = op1.id
            );
        insert c2;
        Test.stopTest();
        CaseComment CC = new CaseComment(
            CommentBody = 'this is a test comment',
            parentid = c2.id
        );
        Insert CC;
        
        c2.status = 'closed';
        update c2;
        
        EmailMessage EM = new EmailMessage(
            Incoming = true,
            ParentId = c2.id,
            ToAddress = 'test01To@gmail.com',
            FromAddress = 'test01From@gmail.com',
            subject = 'test case 001',
            status = '0'            
        );
        Insert EM;
        
        
    }
}