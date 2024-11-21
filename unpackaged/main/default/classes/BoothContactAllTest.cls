@isTest
private class BoothContactAllTest {     
    @isTest 
    static void test_method_one() {

        String uid = [SELECT Id FROM User WHERE Alias = 'CorpAcct' LIMIT 1].Id;
        Id TradeshowRTId = ((RecordType)[SELECT Id FROM RecordType WHERE Name = 'Sales Rep Show Occurrence' And SObjectType = 'Opportunity']).Id;
        Id FirmRTId = ((RecordType)[SELECT Id FROM RecordType WHERE Name = 'Firm' And SObjectType = 'Account']).Id;
        Id ExhibitorRTId = ((RecordType)[SELECT Id FROM RecordType WHERE Name = 'Exhibitor' And SObjectType = 'Account']).Id;

        Account acc = new Account();
        acc.Name = 'name-firm';
        acc.RecordTypeId = FirmRTId;
        acc.BillingCity = 'city';
        acc.BillingCountry = 'US';
        acc.BillingState = 'AL';
        acc.BillingPostalCode = '12345-1234';
        acc.BillingStreet = 'street';
        acc.Phone = '12345';
        insert acc;
        
        Account exh = new Account();
        exh.Name = 'name-exhibitor';
        exh.RecordTypeId = ExhibitorRTId;
        exh.BillingCity = 'city';
        exh.BillingCountry = 'US';
        exh.BillingState = 'AL';
        exh.BillingPostalCode = '12345-1234';
        exh.BillingStreet = 'street';
        exh.Phone = '12345';
        exh.Inactive__c = false;
        insert exh;     
        
        Contact c = new Contact();
        c.LastName = 'lname';
        c.OwnerId = uid;
        c.AccountId = exh.Id;
        c.Inactive__c = false;
        insert c;
             
        Campaign cmp = new Campaign();
        cmp.Status = 'In Progress';
        cmp.Name = 'name-12345xYZ'; //Make case different from that in Opportunity Job # just to make sure the trigger code handles it
        insert cmp;          
              
        Opportunity opp = new Opportunity();
        opp.RecordTypeId = TradeshowRTId;
        opp.CloseDate = date.today();
        opp.Name = 'name';
        opp.StageName = 'Closed Won';
        opp.Job_Number__c = '12345XYZ';
        //opp.Prime_Contractor__c = c.Id;
        opp.Amount = 1;
        opp.AccountId = acc.Id;
        insert opp; 
        
        Oracle_Show_Booth__c  b = new Oracle_Show_Booth__c();
        b.Show_Occurrence__c = opp.Id; 
        b.Account__c = exh.Id;
        insert b;
                
        Oracle_Show_Booth_Contact__c bc = new Oracle_Show_Booth_Contact__c();
        bc.Contact__c = c.Id;
        bc.Oracle_Show_Booth__c = b.Id;
        bc.Email__c = 'alex@vertiba.com';
        //bc.CreatedById = uid;
        insert bc;
        
        CampaignMember cm = new CampaignMember();
        cm.Booth__c = b.Id;
        cm.ContactId = c.Id;
        cm.CampaignId = cmp.Id;
        //insert cm;
        
        updcontactfrombooth ucfb = new updcontactfrombooth();
        updcontactfrombooth.updsyncmarketo(new map<Id, CampaignMember>([SELECT Id FROM CampaignMember]).keyset());
        /*
        //This unit test verifies that if the given contact (c) associated with booth contact (bc), is not already
        //a campaign member, it is added to the campaign
        
        Campaign cmp = [SELECT Id, Name FROM Campaign];
        
        System.debug('Campaign Id: ' + cmp.Id + ' Campaign Name: ' + cmp.Name);
        System.debug('Opportunity Id: ' + opp.Id + ' Opportunity Name: ' + opp.Name + ' Opportunity Job #: ' + opp.Job_Number__c);
        System.debug('Booth Id: ' + b.Id + ' Booth  Opportunity Id: ' + b.Show_Occurrence__c);
        System.debug('Booth Contact Id: ' + bc.Id + ' Booth Contact Email: ' + bc.Email__c);        
        
        CampaignMember cm = [SELECT Id, ContactId FROM CampaignMember WHERE CampaignId =: cmp.Id LIMIT 1];
        
        system.assertEquals(cm.ContactId, c.Id);
        
        //This unit test verifies that if the given contact (c1) associated with booth contact (bc1), is already
        //a campaign member, it should not be added to the campaign
        
        Contact c1 = new Contact();
        c1.LastName = 'lnamec1';
        c1.OwnerId = uid;
        c1.AccountId = exh.Id;
        insert c1;
        
        CampaignMember cm1 = new CampaignMember(ContactId = c1.Id, Status='Sent', Booth__c = b.Id, CampaignId = cmp.Id);
        insert cm1;
        
        Oracle_Show_Booth_Contact__c bc1 = new Oracle_Show_Booth_Contact__c();
        bc1.Contact__c = c1.Id;
        bc1.Oracle_Show_Booth__c = b.Id;
        bc1.Email__c = 'alex@vertiba.com';
        insert bc1; 
        */
    }
    @isTest
    static void test_method_two() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator']; 
        User u = new User(Alias = 'CorpAcct', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, FirstName = 'Corporate Accounts',
            TimeZoneSidKey='America/Los_Angeles', UserName='BoothContactAllTest@testorg.com');

        System.runAs(u) 
        {
            String uid = [SELECT Id FROM User WHERE Alias = 'CorpAcct' LIMIT 1].Id;
            Id TradeshowRTId = ((RecordType)[SELECT Id FROM RecordType WHERE Name = 'Sales Rep Show Occurrence' And SObjectType = 'Opportunity']).Id;
            Id FirmRTId = ((RecordType)[SELECT Id FROM RecordType WHERE Name = 'Firm' And SObjectType = 'Account']).Id;
            Id ExhibitorRTId = ((RecordType)[SELECT Id FROM RecordType WHERE Name = 'Exhibitor' And SObjectType = 'Account']).Id;
    
            Account acc = new Account();
            acc.Name = 'name-firm';
            acc.RecordTypeId = FirmRTId;
            acc.BillingCity = 'city';
            acc.BillingCountry = 'US';
            acc.BillingState = 'AL';
            acc.BillingPostalCode = '12345-1234';
            acc.BillingStreet = 'street';
            acc.Phone = '12345';
            insert acc;
            
            Account exh = new Account();
            exh.Name = 'name-exhibitor';
            exh.RecordTypeId = ExhibitorRTId;
            exh.BillingCity = 'city';
            exh.BillingCountry = 'US';
            exh.BillingState = 'AL';
            exh.BillingPostalCode = '12345-1234';
            exh.BillingStreet = 'street';
            exh.Phone = '12345';
            exh.Inactive__c = false;
            insert exh;     
            
            Contact c = new Contact();
            c.LastName = 'lname';
            c.OwnerId = uid;
            c.AccountId = exh.Id;
            c.Inactive__c = false;
            insert c;
            
            Opportunity opp = new Opportunity();
            opp.RecordTypeId = TradeshowRTId;
            opp.CloseDate = date.today();
            opp.Name = 'name';
            opp.StageName = 'Closed Won';
            opp.Job_Number__c = '12345XYZ';
            //opp.Prime_Contractor__c = c.Id;
            opp.Amount = 1;
            opp.AccountId = acc.Id;
            insert opp; 
            
            Oracle_Show_Booth__c  b = new Oracle_Show_Booth__c();
            b.Show_Occurrence__c = opp.Id; 
            b.Account__c = exh.Id;
            insert b;
                    
            Oracle_Show_Booth_Contact__c bc = new Oracle_Show_Booth_Contact__c();
            bc.Contact__c = c.Id;
            bc.Oracle_Show_Booth__c = b.Id;
            bc.Email__c = 'alex@vertiba.com';
            //database.insert(bc, false);
            insert bc;
        }
    }
    
    @isTest 
    static void TextingCampaignTest() {

        String uid = [SELECT Id FROM User WHERE Alias = 'CorpAcct' LIMIT 1].Id;
        Id TradeshowRTId = ((RecordType)[SELECT Id FROM RecordType WHERE Name = 'Sales Rep Show Occurrence' And SObjectType = 'Opportunity']).Id;
        Id FirmRTId = ((RecordType)[SELECT Id FROM RecordType WHERE Name = 'Firm' And SObjectType = 'Account']).Id;
        Id ExhibitorRTId = ((RecordType)[SELECT Id FROM RecordType WHERE Name = 'Exhibitor' And SObjectType = 'Account']).Id;

        Booth_Setting__c bs = new Booth_Setting__c(PhoneExtension__c = '+1null,EXT,ext,X');
        insert bs;
        
        Account acc = new Account();
        acc.Name = 'name-firm';
        acc.RecordTypeId = FirmRTId;
        acc.BillingCity = 'city';
        acc.BillingCountry = 'US';
        acc.BillingState = 'AL';
        acc.BillingPostalCode = '12345-1234';
        acc.BillingStreet = 'street';
        acc.Phone = '12345';
        insert acc;
        
        Account exh = new Account();
        exh.Name = 'name-exhibitor';
        exh.RecordTypeId = ExhibitorRTId;
        exh.BillingCity = 'city';
        exh.BillingCountry = 'US';
        exh.BillingState = 'AL';
        exh.BillingPostalCode = '12345-1234';
        exh.BillingStreet = 'street';
        exh.Phone = '12345';
        exh.Inactive__c = false;
        insert exh;     
        
        Contact c = new Contact();
        c.LastName = 'lname';
        c.OwnerId = uid;
        c.AccountId = exh.Id;
        c.Inactive__c = false;
        c.Phone = '+19898989898';
        c.MobilePhone = '+19898989898';
        c.Text_Opt_Out__c = false;
        insert c;
             
        Campaign cmp = new Campaign();
        cmp.Status = 'In Progress';
        cmp.Name = 'name-12345xYZ'; //Make case different from that in Opportunity Job # just to make sure the trigger code handles it
        insert cmp;          
              
        Opportunity opp = new Opportunity();
        opp.RecordTypeId = TradeshowRTId;
        opp.CloseDate = date.today();
        opp.Name = 'name';
        opp.StageName = 'Closed Won';
        opp.Job_Number__c = '12345XYZ';
        //opp.Prime_Contractor__c = c.Id;
        opp.Amount = 1;
        opp.AccountId = acc.Id;
        insert opp; 
        
        Oracle_Show_Booth__c  b = new Oracle_Show_Booth__c();
        b.Show_Occurrence__c = opp.Id; 
        b.Account__c = exh.Id;
        insert b;
                
        Oracle_Show_Booth_Contact__c bc = new Oracle_Show_Booth_Contact__c();
        bc.Contact__c = c.Id;
        bc.Oracle_Show_Booth__c = b.Id;
        bc.Email__c = 'alex@vertiba.com';
        //bc.CreatedById = uid;
        insert bc;
        
        
    }
}