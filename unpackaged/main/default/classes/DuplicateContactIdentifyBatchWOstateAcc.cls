public class DuplicateContactIdentifyBatchWOstateAcc implements Database.Batchable<SObject>, Database.Stateful {
    
    public String contentDocumentId;

    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([
            SELECT Id, FirstName, LastName, Email, AccountId, Account.Name 
            FROM Contact
            WHERE AccountId != null
            ORDER BY Account.Name, CreatedDate
        ]);
    }

    public void execute(Database.BatchableContext BC, List<Contact> scope) {
        List<Contact> contactsToUpdate = new List<Contact>();
        Map<String, Contact> firstContactMap = new Map<String, Contact>();

        // Load existing content version data only once
        if (String.isNotBlank(contentDocumentId)) {
            ContentVersion contentVersion = [SELECT VersionData FROM ContentVersion WHERE ContentDocumentId = :contentDocumentId ORDER BY CreatedDate DESC LIMIT 1];
            String jsonString = contentVersion.VersionData.toString();
            Map<String, Object> outerMap = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
            
            for (String key : outerMap.keySet()) {
                Map<String, Object> contactInfo = (Map<String, Object>)outerMap.get(key);
                firstContactMap.put(key, new Contact(
                    Id = (Id) contactInfo.get('Id'),
                    FirstName = (String) contactInfo.get('FirstName'),
                    Email = (String) contactInfo.get('Email'),
                    AccountId = (Id) contactInfo.get('AccountId')
                ));
            }
        }

        for (Contact con : scope) {
            String key = (String.isNotBlank(con.LastName) ? con.LastName.toLowerCase() : '') + ',' +
                         (String.isNotBlank(con.Account.Name) ? con.Account.Name.toLowerCase() : '');

            if (!firstContactMap.containsKey(key)) {
                firstContactMap.put(key, con);
            } else {
                Contact firstContact = firstContactMap.get(key);
                if (isDuplicate(con, firstContact)) {
                    con.Duplicate_of__c = firstContact.Id;
                    con.Reason_of_Duplicate__c = 'Same FirstName LastName Email Account Name & Id';
                    contactsToUpdate.add(con);
                }
            }
        }

        if (!contactsToUpdate.isEmpty()) {
            Database.Update(contactsToUpdate, false);
        }

        // Serialize and save the updated map only once
        String jsonString = JSON.serialize(firstContactMap);
        ContentVersion contentVersion = new ContentVersion();
        contentVersion.Title = 'DuplicateContactInfoMap';
        contentVersion.PathOnClient = 'DuplicateContactInfoMap.json';
        contentVersion.VersionData = Blob.valueOf(jsonString);
        if (contentDocumentId != null) {
            contentVersion.ContentDocumentId = contentDocumentId;
        }
        insert contentVersion;

        contentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id].ContentDocumentId;
    }

    private Boolean isDuplicate(Contact con, Contact firstContact) {
        return ((String.isNotBlank(con.FirstName) && con.FirstName.equalsIgnoreCase(firstContact.FirstName)) || 
                (String.isBlank(con.FirstName) && String.isBlank(firstContact.FirstName))) &&
                con.Email == firstContact.Email && 
                con.AccountId == firstContact.AccountId;
    }

    public void finish(Database.BatchableContext BC) {
        if (contentDocumentId != null) {
            List<ContentDocument> documentsToDelete = [SELECT Id FROM ContentDocument WHERE Id = :contentDocumentId];
            delete documentsToDelete;
        }
    }
}