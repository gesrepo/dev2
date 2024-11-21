@isTest
public class DuplicateContactIdentifyBatchWOstateTest {
    
    @testSetup
    static void setupTestData() {
        
        Account acc1 = new Account(Name = 'Test Account 1', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId());
        Account acc2 = new Account(Name = 'Test Account 1', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId());
        Account acc3 = new Account(Name = 'Test Account 1', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Exhibitor').getRecordTypeId());
        insert new List<Account>{acc1, acc2,acc3};
            
        Contact con1 = new Contact(FirstName = 'John', LastName = 'Doe', Email = 'john.doe@example.com', AccountId = acc1.Id);
        Contact con2 = new Contact(FirstName = 'John', LastName = 'Doe', Email = 'john.doe@example.com', AccountId = acc2.Id);
        Contact con3 = new Contact(FirstName = 'John', LastName = 'Doe', Email = 'john.doe@example.com', AccountId = acc1.Id);
        Contact con4 = new Contact(FirstName = 'John', LastName = 'Doe',Email = '',  AccountId = acc1.Id);
        Contact con5 = new Contact(FirstName = '', LastName = 'Doe',Email = 'john.doe@example.com',  AccountId = acc1.Id);
        Contact con6 = new Contact(FirstName = 'John', LastName = 'Doe',Email = '',  AccountId = acc1.Id);
        Contact con7 = new Contact(FirstName = 'John', LastName = 'Doe', Email = 'john.doe@example.com', AccountId = acc3.Id);
        Contact con8 = new Contact(FirstName = '',LastName = 'Doe',Email = '',  AccountId = acc1.Id);
        insert con1 ;
        insert new List<Contact>{ con2, con3, con4,con5,con6,con7, con8 };
            }
    
    @isTest
    static void testBatchExecution() {
        
        Test.startTest();
        
        DuplicateContactIdentifyBatchWOstate batchJob = new DuplicateContactIdentifyBatchWOstate();
        Database.executeBatch(batchJob); 
        
        
        Test.stopTest();
        
        List<Contact> updatedContacts = [SELECT Id, Duplicate_of__c, Reason_of_Duplicate__c FROM Contact WHERE Duplicate_of__c != null];
        System.assertEquals(6, updatedContacts.size(), 'There should be  duplicate contacts identified.');
    }
}