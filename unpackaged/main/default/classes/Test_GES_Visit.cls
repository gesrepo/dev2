@isTest
public class Test_GES_Visit {
    
    @testSetup static void setup() {
        
        List <Account> AllAccounts= new List<Account> ();
        
        // Create a unique UserName
        String uniqueUserName = 'Testuser' + DateTime.now().getTime() + '@testorg.com';
        // This code runs as the GES Administrator Interface
        Profile p = [SELECT Id FROM Profile WHERE Name='GES Administrator Interface'];
        User u = new User(Alias = 'standt', Email='Testuser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName=uniqueUserName);
        
        
        ///Test.startTest();
        ID OwnerId = UserInfo.getUserId();
        
        //Create User Sales Person
        ID SalesRepId = UserInfo.getUserId();
        
        Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('EMEA - Poken and Visit').getRecordTypeId();
        system.debug('devRecordTypeId===>'+devRecordTypeId);
        
        Id QuoteRecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('EMEA Visit').getRecordTypeId();
        //RecordType FacilityRecordType = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Facility'];
        Id FacilityRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Facility').getRecordTypeId();
        
        // RecordType FirmRecordType = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Firm'];
        Id FirmRecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Firm').getRecordTypeId();
        
        //  RecordType SalesRepRecordType = [Select Id From RecordType Where SObjectType = 'Opportunity' And Name = 'Sales Rep Show Occurrence'];
        Id SalesRepRecordTypeId =  Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Sales Rep Show Occurrence').getRecordTypeId();
        
        
        //Account acc = new Account(Name='Visit',RecordTypeId = FirmRecordTypeId);
        //AllAccounts.add(acc);
        
        //Create Facility Account
        Account Facility = new Account();
        Facility.Sales_Person__c = SalesRepId;
        Facility.Name = 'MyTestFacilityName';
        Facility.Type = 'Hotel';
        Facility.GES_Status__c = 'Preferred';
        Facility.LMS_Facility_ID__c = 'ABCFAC';
        Facility.BillingStreet = '950 Grier Dr';
        Facility.BillingCity = 'Las Vegas';
        Facility.BillingPostalCode = '89119-0000';
        Facility.BillingState = 'NV';
        Facility.BillingCountry = 'US';
        Facility.RecordTypeId = FacilityRecordTypeId;
        
        AllAccounts.add(Facility);
        
        //Create Firm Account
        Account Firm = new Account();
        Firm.Sales_Person__c = SalesRepId;
        Firm.Name = 'Visit';
        Firm.Phone = '7022631500';
        Firm.BillingStreet = '950 Grier Dr';
        Firm.BillingCity = 'Las Vegas';
        Firm.BillingPostalCode = '89119-0000';
        Firm.BillingState = 'NV';
        Firm.BillingCountry = 'US';
        Firm.RecordTypeId = FirmRecordTypeId;
        
        AllAccounts.add(Firm);
        
        System.runAs(u) {
            Database.insert(AllAccounts);
        }
        //Create Show
        Show__c Show = new Show__c();
        Show.Sales_Person__c = SalesRepId;
        Show.Account__c = Firm.Id;
        Show.Name ='International CES';
        Show.Show_Type__c = 'Food Sector';
        Show.Show_ID__c = '123456';
        
        Database.insert(Show);            
        
        
        product2 prod = new product2(Name='Test_Prod',IsActive=true,Inventory__c=true,Sendable__c=true,CurrencyIsoCode='USD',Weight_Kg__c=1);
        try{
            insert prod;
            system.debug('Product inserted===>'+prod);
        }
        catch(DMLexception e){
            System.debug('Error occured during product insert====>'+e);
        }
        
        
        
        //Id devAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('AV - Master').getRecordTypeId();
        //system.debug('devAccRecordTypeId===>'+devAccRecordTypeId);  ,RecordTypeId='devAccRecordTypeId'
        //Account acc1 = new Account(Name='Test_Account',BillingCity='Chicago',BillingStreet='Test',BillingState='',BillingPostalCode='12345',BillingCountry='HK');
        //AllAccounts.add(acc1);
        List<Asset> AllAssets = new List<Asset> ();
        Asset ass= new Asset();
        ass.AccountId=Firm.Id;
        ass.Product2Id=prod.Id;
        ass.Status='Available';
        ass.SerialNumber='1234567890';
        ass.Name=prod.Name;
        
        AllAssets.add(ass);
        
        Asset ass1= new Asset();
        ass1.AccountId=Firm.Id;
        ass1.Product2Id=prod.Id;
        ass1.Status='Available';
        ass1.SerialNumber='123456789';
        ass1.Name=prod.Name;
        
        AllAssets.add(ass1);
        try{
            insert AllAssets;
            system.debug('Asset inserted===>'+AllAssets);
        }
        catch(DMLexception e){
            System.debug('Error occured during Asset insert====>'+e);
        }
        
        // Get standard price book ID.
        Id StandardpricebookId = Test.getStandardPricebookId();
        
        // 1. Insert a price book entry for the standard price book.
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = StandardpricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 book = new Pricebook2(Name='Test_Book',IsActive=true);
        try{
            insert book;
            system.debug('Pricebook2 inserted===>'+book);
        }
        catch(DMLexception e){
            System.debug('Error occured during Pricebook2 insert====>'+e);
        }
        
        PricebookEntry bookEntry = new PricebookEntry(Pricebook2Id=book.Id,Product2Id=prod.Id,IsActive=true,UseStandardPrice=false,UnitPrice=500);
        try{
            insert bookEntry;
            system.debug('PricebookEntry inserted===>'+bookEntry);
        }
        catch(DMLexception e){
            System.debug('Error occured during PricebookEntry insert====>'+e);
        }
        
        
        
        Opportunity Opp1 = new Opportunity();
        Opp1.Job_Number__c = '201212313';   
        Opp1.Pricebook2Id=book.Id;
        Opp1.OwnerId = OwnerId;   
        Opp1.Sales_Person__c = SalesRepId;        
        Opp1.Sales_Location__c = '110- Las Vegas';        
        Opp1.Name = 'MyTestShow # 1';        
        Opp1.Prime_Contractor__c = null;        
        Opp1.Production_Location__c = '110- Las Vegas';        
        Opp1.Facility__c = Facility.Id;        
        Opp1.StageName = 'SL1';        
        Opp1.Amount = 1000;        
        Opp1.Probability = 25;        
        Opp1.Type = 'ITYFTY';        
        Opp1.New_Repeat__c = 'New';        
        Opp1.Frequency__c = 'B1';        
        Opp1.AccountId = Firm.Id;       
        Opp1.Show_Name__c = Show.Id;        
        Opp1.RecordTypeId = devRecordTypeId;                
        Opp1.Show_Open_Date__c = Date.newInstance(DateTime.now().yearGmt()-1,12,1);       
        Opp1.Show_Close_Date__c = Date.newInstance(DateTime.now().yearGmt()-1,12,2);        
        Opp1.CloseDate = Date.newInstance(DateTime.now().yearGmt()-1,12,2); 
        Opp1.Requested_Stage__c = '';
        
        System.runAs(u) {
            Test.startTest();
            Database.insert(Opp1);
            Test.stopTest();
        }
        
        /////////
        /*OpportunityLineitem OppLine= new OpportunityLineitem(Product2Id=prod.Id,Quantity=1,UnitPrice=500,Discount=0,OpportunityId=Opp1.Id,PricebookEntryId=bookEntry.Id);
        try{
            insert OppLine;
            system.debug('OpportunityLineitem Inserted ==>'+OppLine);
        }
        catch(DMLexception e){
            system.debug('OpportunityLineitem Inserted failed==>'+e);
        }*/
        
        
        Quote Qu= new Quote();
        Qu.Name='Test_Quote';
        Qu.OpportunityId=Opp1.Id;
        Qu.Status='Draft';
        Qu.Pricebook2Id=book.Id;
        Qu.RecordTypeId=QuoteRecordTypeId;
        try{
            insert Qu;
            system.debug('Quote inserted===>'+Qu);
        }        
        catch(DMLexception e){
            System.debug('Error occured during Quote insert====>'+e);
        }
        
        QuoteLineItem QuItems= new QuoteLineItem(Product2Id=prod.Id,Quantity=1,UnitPrice=500,Discount=0,QuoteId=Qu.Id,PricebookEntryId=bookEntry.Id);
        try{
            Insert QuItems;
            system.debug('QuoteLineItem inserted===>'+QuItems);
        }
        catch(DMLexception e){
            System.debug('Error occured during QuoteLineItem insert====>'+e);
        }
        
        
        
        
        
    }
    
    static testmethod void Test_EMEA_Visit_Order_Creation_Trigger(){
       
        Quote Qu=[Select Id from Quote where Name='Test_Quote'];        
        Qu.Status='Accepted';
        System.debug('Queried Quote===>'+Qu);
       Test.startTest();
        try{
            /*System.runAs(u) {
            update Qu;
            }*/
            update Qu;
            system.debug('Quote updated===>'+Qu);
        }
        catch(DMLexception e){
            System.debug('Error occured during Quote update====>'+e);
        }
        
        System.assertEquals(Qu.Status,'Accepted');
         
        Order Ord = [Select Id from Order where QuoteId=:Qu.Id];
        System.debug('Order==>'+Ord);
        Shipment__c ship = [Select Id from Shipment__c where OrderID__c=:Ord.Id];
        System.debug('Shipment==>'+ship);
        Test.stopTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(ship);
            
        ShipmentFulfillment_Controller checkout = new ShipmentFulfillment_Controller(sc);
        PageReference pageRef = Page.Shipment_Fulfillment;
         pageRef.getParameters().put('id', String.valueOf(ship.Id));
            //checkout.scannedId='123456789?';
            //checkout.SpecialCharacterCheck();
            checkout.scannedId='1234567890?';
            checkout.SpecialCharacterCheck();
        
        ApexPages.StandardController st = new ApexPages.StandardController(ship);
            ShipmentReturn_Controller checkin = new ShipmentReturn_Controller(st);
            //checkin.scannedId='123456789?';
            //checkin.SpecialCharacterCheck();
            checkin.scannedId='1234567890?';
            checkin.SpecialCharacterCheck();
        system.debug('End of test class');
        
        
    }
    
   /* static testmethod void Test_ShipmentFulfillment_Controller(){
        
        
        Quote Qu=[Select Id,Status from Quote where Name='Test_Quote'];
        Qu.Status='Accepted';
        Test.startTest();
        update Qu;
        Test.stopTest();
        System.debug('Quote==>'+Qu);
        Order Ord = [Select Id from Order where QuoteId=:Qu.Id];
        System.debug('Order==>'+Ord);
        Shipment__c ship = [Select Id from Shipment__c where OrderID__c=:Ord.Id];
        System.debug('Shipment==>'+ship);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(ship);
            
        ShipmentFulfillment_Controller checkout = new ShipmentFulfillment_Controller(sc);
            checkout.scannedId='123456789?';
            checkout.SpecialCharacterCheck();
            checkout.scannedId='1234567890?';
            checkout.SpecialCharacterCheck();
        
        ApexPages.StandardController st = new ApexPages.StandardController(ship);
            ShipmentReturn_Controller checkin = new ShipmentReturn_Controller(st);
            checkin.scannedId='123456789?';
            checkin.SpecialCharacterCheck();
            checkin.scannedId='1234567890?';
            checkin.SpecialCharacterCheck();
        system.debug('End of test class');
        
    }*/

}