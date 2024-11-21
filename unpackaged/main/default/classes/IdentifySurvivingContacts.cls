public class IdentifySurvivingContacts implements Database.Batchable<SObject> {
    
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([
            SELECT Id, Is_Surviving_Contact__c, LastName, Account.Name, Reason_of_Duplicate__c, RecordType.Name, Owner.Name, Spiro__c, Account.RecordType.Name, Owner.IsActive , RecordTypeId 
            FROM Contact
            WHERE Duplicate_of__c != null 
            ORDER BY Account.Name,LastName,Reason_of_Duplicate__c
        ]);
    }
    
    public void execute(Database.BatchableContext BC, List<Contact> scope) {
        Map<String, List<Contact>> duplicateGroups = new Map<String, List<Contact>>();
              
        for (Contact con : scope) {
            String key = con.Account.Name + '|' + con.LastName + '|' + con.Reason_of_Duplicate__c;
            if (!duplicateGroups.containsKey(key)) {
                duplicateGroups.put(key, new List<Contact>());
            }
            duplicateGroups.get(key).add(con);
        }
        
        List<Contact> contactsToUpdate = new List<Contact>();
        
       
        for (List<Contact> duplicates : duplicateGroups.values()) {
            Contact survivingContact = null;
            
           
            if (duplicates.size() > 1) {
               
                survivingContact = getSurvivingContact(duplicates, 'Exhibitor', 'External Contact');
                if (survivingContact == null) {
                     survivingContact = getSurvivingContact(duplicates, 'Firm', null);
                }
                if (survivingContact == null) {
                    
                    survivingContact = getSurvivingContactByOwner(duplicates, 'Corporate Accounts Pool');
                }
                if (survivingContact == null) {
                   
                    survivingContact = getSurvivingContactByInactiveOwner(duplicates);
                }
                if (survivingContact == null) {
                    
                    survivingContact = getSurvivingContactBySpiro(duplicates);
                }
            }
            
           
            if (survivingContact != null) {
                survivingContact.Is_Surviving_Contact__c = true;
                contactsToUpdate.add(survivingContact);
            }
        }
        
        if (!contactsToUpdate.isEmpty()) {
            Database.Update(contactsToUpdate, false);
        }
    }
    
    public void finish(Database.BatchableContext BC) {
        
    }
    
   
    private Contact getSurvivingContact(List<Contact> duplicates, String recordTypeName, String excludeRecordTypeName) {
        for (Contact con : duplicates) {
            if (con.Account.RecordType.Name == recordTypeName && 
               ((excludeRecordTypeName == null && con.RecordTypeId == null )  || (con.RecordType.Name == excludeRecordTypeName))) {
                return con;
            }
        }
        return null;
    }
    
    private Contact getSurvivingContactByOwner(List<Contact> duplicates, String ownerName) {
        for (Contact con : duplicates) {
            if (con.Owner.Name == ownerName) {
                return con;
            }
        }
        return null;
    }
    
    private Contact getSurvivingContactByInactiveOwner(List<Contact> duplicates) {
        for (Contact con : duplicates) {
            if (con.Owner.IsActive == false) {
                return con;
            }
        }
        return null;
    }
    
    private Contact getSurvivingContactBySpiro(List<Contact> duplicates) {
        for (Contact con : duplicates) {
            if (con.Spiro__c) {
                return con;
            }
        }
        return null;
    }
}