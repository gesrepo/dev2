/*
 Class Name : DuplicateContactIdentifyBatch
 Author : Vijay
 Description : This batch will identify duplicate contacts and based on that updates field to handle later
 Test Class : DuplicateContactIdentifyBatch
*/
public class DuplicateContactIdentifyBatch implements Database.Batchable<SObject>, Database.Stateful {
     public Map<String, Map<String, Object>> firstContactInfoMap = new Map<String, Map<String, Object>>();
   
    public Database.QueryLocator start(Database.BatchableContext BC) {
       
        return Database.getQueryLocator([
            SELECT Id, FirstName, LastName, Email, AccountId,Account.RecordTypeId,Account.Name 
            FROM Contact
            WHERE Duplicate_of__c = null AND  Account.Name= 'EXHIBITOR' 
            ORDER BY  LastName,CreatedDate
        ]);
    }


public void execute(Database.BatchableContext BC, List<Contact> scope) {
    List<Contact> contactsToUpdate = new List<Contact>();
    system.debug('InitCon*'+scope);
    for (Contact con : scope) {
      
        String key = (String.isNotBlank(con.LastName)  ? con.LastName : '') + '|' +
                     (String.isNotBlank(con.Account.Name) ? con.Account.Name : '');

        if (!firstContactInfoMap.containsKey(key)) {
            firstContactInfoMap.put(key, new Map<String, Object>{
                'Id' => con.Id,
                'FirstName' => con.FirstName,
                'Email' => con.Email,
                'AccountId' => con.AccountId,
                'AccountRecordTypeId' => con.Account.RecordTypeId
            });
        } else {
            Map<String, Object> firstContactInfo = firstContactInfoMap.get(key);
            Id firstContactId = (Id) firstContactInfo.get('Id');
            String firstName = (String) firstContactInfo.get('FirstName');
            String firstEmail = (String) firstContactInfo.get('Email');
            Id firstAccountId = (Id) firstContactInfo.get('AccountId');
            Id firstAccountRecordTypeId = (Id) firstContactInfo.get('AccountRecordTypeId');
            system.debug('first=<'+json.serialize(firstContactInfo)+' curr=>'+json.serialize(con));
            if (((String.isNotBlank(con.FirstName) && con.FirstName.equalsIgnoreCase(firstName))||((String.isBlank(con.FirstName) && String.isBlank(firstName))) ) && con.Email == firstEmail && con.AccountId == firstAccountId ) {
                con.Duplicate_of__c = firstContactId;
                con.Reason_of_Duplicate__c = 'Same FirstName LastName Email Account Name & Id';
                contactsToUpdate.add(con);
               
            } else if (((String.isNotBlank(con.FirstName) && con.FirstName.equalsIgnoreCase(firstName))||((String.isBlank(con.FirstName) && String.isBlank(firstName))) ) && String.isBlank(con.Email) && con.AccountId == firstAccountId ) {
                con.Duplicate_of__c = firstContactId;
                con.Reason_of_Duplicate__c = 'Same FirstName LastName Account Name & Id Blank Email';
                contactsToUpdate.add(con);
               
            } else if (String.isBlank(con.FirstName) && con.Email == firstEmail && con.AccountId == firstAccountId ) {
                con.Duplicate_of__c = firstContactId;
                con.Reason_of_Duplicate__c = 'Same LastName Email Account Name & Id Blank FirstName';
                contactsToUpdate.add(con);
               
            } else if (((String.isNotBlank(con.FirstName) && con.FirstName.equalsIgnoreCase(firstName))||((String.isBlank(con.FirstName) && String.isBlank(firstName))) ) && String.isBlank(con.Email) && con.AccountId != firstAccountId && con.Account.RecordTypeId == firstAccountRecordTypeId ) {
                con.Duplicate_of__c = firstContactId;
                con.Reason_of_Duplicate__c = 'Same FirstName LastName Account Name Diff Account Id Blank Email';
                contactsToUpdate.add(con);
               
            } else if (((String.isNotBlank(con.FirstName) && con.FirstName.equalsIgnoreCase(firstName))||((String.isBlank(con.FirstName) && String.isBlank(firstName))) ) && con.Email == firstEmail && con.AccountId != firstAccountId && con.Account.RecordTypeId == firstAccountRecordTypeId ) {
                con.Duplicate_of__c = firstContactId;
                con.Reason_of_Duplicate__c = 'Same FirstName LastName Email Account Name Record Type Diff Account Id';
                contactsToUpdate.add(con);
               
            } else if (((String.isNotBlank(con.FirstName) && con.FirstName.equalsIgnoreCase(firstName))||((String.isBlank(con.FirstName) && String.isBlank(firstName))) ) && con.Email == firstEmail && con.AccountId != firstAccountId && con.Account.RecordTypeId != firstAccountRecordTypeId ) {
                con.Duplicate_of__c = firstContactId;
                con.Reason_of_Duplicate__c = 'Same FirstName LastName Email Account Name Diff Record Type & Account Id';
                contactsToUpdate.add(con);
               
            } else if ( con.Email == firstEmail && con.AccountId == firstAccountId && String.isBlank(con.Email) && String.isBlank(con.FirstName)) {
                con.Duplicate_of__c = firstContactId;
                con.Reason_of_Duplicate__c = 'Same LastName Account Name & Id Blank FirstName Email';
                contactsToUpdate.add(con);
               
            } else{
                con.Duplicate_of__c = firstContactId;
                con.Reason_of_Duplicate__c = 'Other';
                contactsToUpdate.add(con);
            }
        }
    }
    system.debug('$R'+contactsToUpdate);
    if (!contactsToUpdate.isEmpty()) {
        update contactsToUpdate;
    }
    
}


    public void finish(Database.BatchableContext BC) {
      
    }
}