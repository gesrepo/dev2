/***************************************************************************************************
Author: Shyam Nair (SLK Software)
Date: 10/30/2019
Description: Test class for ContactTriggerHandler class and ContactTrigger trigger.
****************************************************************************************************/
@isTest
private class ContactTriggerHandlerTest {

    static Id FirmRtId;

    static Id FirmRecordTypeId {
        get {
            if (FirmRtId == null) {
                //Determine RecordTypeId of "Facility" Account record type.
                RecordType Rt = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Firm'];
                FirmRtId = Rt.Id;
            }
            
            return FirmRtId;                
        }
    }

    static Account CreateTestFirm(){
        Account Firm = new Account();
        Firm.ORACLE_AR_CUST_ACCOUNT_ID__c = '10000001';
        Firm.Sales_Person__c = UserInfo.getUserId();
        Firm.Name = 'MyTestExhibitorName';
        Firm.Phone = '7022631500';
        Firm.BillingStreet = '950 Grier Dr';
        Firm.BillingCity = 'Las Vegas';
        Firm.BillingPostalCode = '89119-0000';
        Firm.BillingState = 'NV';
        Firm.BillingCountry = 'US';
        Firm.RecordTypeId = FirmRecordTypeId;
        return Firm;   
    }
    
    static List<Contact> createTestContacts(String accountId, Integer num){
        List<Contact> contacts = new List<Contact>();
        for(Integer i=0;i<num;i++){
            contacts.add(new Contact(FirstName='Test',LastName='Contact '+(i+1),Email='test@test.com',AccountId=accountId));
        }
        System.debug('contacts to insert--> '+contacts);
        return contacts;
    }  

    @testSetup static void setup(){
        
        SOPService__c serv = new SOPService__c();
        serv.Name = 'Default';
        serv.URL__c = 'test';
        insert serv;
        
        SOPAuthentication__c newAuth = new SOPAuthentication__c();
        newAuth.Name = 'Login Credentials';
        newAuth.Password__c = 'lalalala';
        newAuth.Username__c = 'lalalala';
        insert newAuth;
        
        List<CountryCode__c> listCS = new List<CountryCode__c>();
        CountryCode__c cs1 = new CountryCode__c(Name='US',Code__c='+1');
        CountryCode__c cs2 = new CountryCode__c(Name='IN',Code__c='+91');
        listCS.add(cs1);
        listCS.add(cs2);
        insert listCS; 
        
        Account testAccount = CreateTestFirm();
        insert testAccount;
        List<Contact> testContacts = createTestContacts(testAccount.Id,2);
        insert testContacts;
    }

    static testMethod void myUnitTest(){
        List<Contact> testContacts = [select Primary_Contact__c FROM Contact];
        List<Contact> contactsToUpdate = new List<Contact>();
        Account testAccount = new Account();

        Test.startTest();
        testContacts[0].Primary_Contact__c = true;
        contactsToUpdate.add(testContacts[0]);
        update contactsToUpdate;

        testAccount = [select Primary_Contact__c,Primary_Contact_Identified__c FROM Account];
        System.assert(testAccount.Primary_Contact__c == testContacts[0].Id);
        System.assert(testAccount.Primary_Contact_Identified__c);

        contactsToUpdate.clear();
        testContacts[1].Primary_Contact__c = true;
        contactsToUpdate.add(testContacts[1]);
        update contactsToUpdate;

        testAccount = [select Primary_Contact__c FROM Account];
        testContacts = [select Id,Primary_Contact__c FROM Contact];
        //System.assert(testAccount.Primary_Contact__c == testContacts[1].Id);
        //System.assert(!testContacts[0].Primary_Contact__c);
        Test.stopTest();
    }
    
    static testMethod void myUnitTest2(){
        
        Account testAccount = CreateTestFirm();
        testAccount.EMEA__c = false;
        insert testAccount;
        test.startTest();
        List<Contact> testContacts = createTestContacts(testAccount.Id,4);
        testContacts[0].Phone = '9898989898';
        testContacts[1].Phone = 'EXT-98989898';
        testContacts[1].MobilePhone = 'EXT-98989898';
        testContacts[2].Phone = '9998989898';
        testContacts[2].MobilePhone = '9998989898';
        insert testContacts;
        test.stopTest();
        
    }
    
    static testMethod void myUnitTest3(){
        List<Contact> testContacts = new List<Contact>();
        Account testAccount = CreateTestFirm();
        insert testAccount;
        List<Contact> listContacts = createTestContacts(testAccount.Id,2);
        listContacts[0].Primary_Contact__c = true;
        insert listContacts;
        
        List<Account> testAccList = [select Id, Primary_Contact__c FROM Account];
        testAccList[0].Primary_Contact__c = listContacts[0].Id;
        update testAccList[0];
        testContacts.add(listContacts[1]);
        test.startTest();
        ContactTriggerHandler.setPrimaryOnAccount(testContacts);
        ContactTriggerHandler.unsetPrimaryContactOnAccount(listContacts);
        test.stopTest();

    }

}