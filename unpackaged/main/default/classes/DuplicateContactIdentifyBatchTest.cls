@isTest
public class DuplicateContactIdentifyBatchTest {
    
   
    static Account acc1;
    static Account acc2;
    
    @testSetup
    static void setupTestData() {
        
        Map<String, Schema.RecordTypeInfo> accountRecordTypes = Schema.SObjectType.Account.getRecordTypeInfosByName();
        Id accountRecordTypeId = accountRecordTypes.get('Exhibitor').getRecordTypeId();
        Id accountFacilityRecordTypeId = accountRecordTypes.get('Facility').getRecordTypeId();

      
        acc1 = new Account(Name = 'Account A', RecordTypeId = accountRecordTypeId);
        acc2 = new Account(Name = 'Account B', RecordTypeId = accountFacilityRecordTypeId);
        insert new List<Account>{acc1, acc2};
        Contact conO = new Contact(FirstName = 'John', LastName = 'Doe', Email = 'john.doe@example.com', AccountId = acc1.Id, Duplicate_of__c = null);
        Contact con1 = new Contact(FirstName = 'John', LastName = 'Doe', Email = 'john.doe@example.com', AccountId = acc1.Id, Duplicate_of__c = null);
        Contact con2 = new Contact(FirstName = 'John', LastName = 'Doe', Email = 'john.doe@example.com', AccountId = acc1.Id,Duplicate_of__c = null);
        Contact con3 = new Contact(FirstName = 'John', LastName = 'Doe', Email = null, AccountId = acc1.Id,Duplicate_of__c = null);
        Contact con4 = new Contact(FirstName = null, LastName = 'Doe', Email = 'john.doe@example.com', AccountId = acc1.Id,Duplicate_of__c = null);
        Contact con5 = new Contact(FirstName = 'John', LastName = 'Doe', Email = null, AccountId = acc2.Id,Duplicate_of__c = null);
        Contact con6 = new Contact(FirstName = 'John', LastName = 'Doe', Email = 'john.doe@example.com', AccountId = acc2.Id,Duplicate_of__c = null);
        insert new List<Contact>{conO, con1, con2, con3, con4, con5, con6};
        List<Contact> conn = [SELECT Id,FirstName,LastName,Email,Account.Name FROM Contact];
        system.debug('**'+conn);
    }
    
    @isTest
    static void testDuplicateContactIdentifyBatch() {
        Test.startTest();
        DuplicateContactIdentifyBatch batch = new DuplicateContactIdentifyBatch();
        Database.executeBatch(batch);
        Test.stopTest();
        
        List<Contact> updatedContacts = [SELECT Id, Duplicate_of__c, Reason_of_Duplicate__c FROM Contact WHERE Duplicate_of__c != null];
        
        System.debug('Updated Contacts: ' + updatedContacts);
        System.assertEquals(5, updatedContacts.size(), 'Five contacts should be marked as duplicates.');
        
        for (Contact con : updatedContacts) {
            if (con.Email == 'john.doe@example.com' && con.AccountId == acc1.Id) {
                System.assertEquals('Same FirstName LastName Email Account Name & Id', con.Reason_of_Duplicate__c, 'Reason should be "Same FirstName LastName Email Account Name & Id".');
            } else if (con.Email == null && con.AccountId == acc1.Id) {
                System.assertEquals('Same FirstName LastName Account Name & Id Blank Email', con.Reason_of_Duplicate__c, 'Reason should be "Same FirstName LastName Account Name & Id Blank Email".');
            } else if (con.FirstName == null && con.AccountId == acc1.Id) {
                System.assertEquals('Same LastName Email Account Name & Id Blank FirstName', con.Reason_of_Duplicate__c, 'Reason should be "Same LastName Email Account Name & Id Blank FirstName".');
            } else if (con.AccountId != acc1.Id && con.Account.RecordTypeId == acc1.RecordTypeId) {
                if (con.Email == null) {
                    System.assertEquals('Same FirstName LastName Account Name Diff Account Id Blank Email', con.Reason_of_Duplicate__c, 'Reason should be "Same FirstName LastName Account Name Diff Account Id Blank Email".');
                } else if (con.Email == 'john.doe@example.com') {
                    System.assertEquals('Same FirstName LastName Email Account Name Record Type Diff Account Id', con.Reason_of_Duplicate__c, 'Reason should be "Same FirstName LastName Email Account Name Record Type Diff Account Id".');
                }
            }
        }
    }
}