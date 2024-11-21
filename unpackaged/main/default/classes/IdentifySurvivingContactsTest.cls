@isTest
public class IdentifySurvivingContactsTest {
    
    @isTest
    static void testIdentifySurvivingContacts() {
       
        Contact duplicateContact = new Contact(FirstName = 'John', LastName = 'Doe', Email = 'john.doe@example.com', Is_Surviving_Contact__c = false);
        insert duplicateContact;

        Contact mainContact = new Contact(FirstName = 'Jane', LastName = 'Doe', Email = 'jane.doe@example.com', Duplicate_of__c = duplicateContact.Id);
        insert mainContact;

        Test.startTest();
        IdentifySurvivingContacts batch = new IdentifySurvivingContacts();
        Database.executeBatch(batch);
        Test.stopTest();

        duplicateContact = [SELECT Is_Surviving_Contact__c FROM Contact WHERE Id = :duplicateContact.Id];
        System.assertEquals(true, duplicateContact.Is_Surviving_Contact__c, 'The Is_Surviving_Contact__c field should be true.');
    }
}