public class DuplicateContactIdentifyBatchWOstateNew implements Database.Batchable<SObject> {
    

        public String contentDocumentId;
        
        public Database.QueryLocator start(Database.BatchableContext BC) {
            
            return Database.getQueryLocator([
                SELECT Id, FirstName, LastName, Email, AccountId, Account.RecordTypeId, Account.Name 
                FROM Contact
                WHERE AccountId != null  AND  Duplicate_Of_New__c = null 
                ORDER BY   Account.Name,LastName,Email Desc
            ]);
        }
        
        public void execute(Database.BatchableContext BC, List<Contact> scope) {
            List<Contact> contactsToUpdate = new List<Contact>();
            Set<Id> processedContactIds = new Set<Id>();
            Map<String, Map<String, Object>> firstContactInfoMap = new Map<String, Map<String, Object>>();
            Map<String, Object> outerMap = new Map<String, Object>();
            if (String.isNotBlank(contentDocumentId)) {
                ContentVersion contentVersion = [SELECT VersionData FROM ContentVersion WHERE ContentDocumentId = :contentDocumentId Order By CreatedDate Desc LIMIT 1];
                String jsonString = contentVersion.VersionData.toString();
                outerMap = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
                for(String key : outerMap.keyset()){
                    firstContactInfoMap.put(key , (Map<String, Object>)outerMap.get(key));
                }
            }
            for (Contact con : scope) {
                String key = (String.isNotBlank(con.LastName) ? con.LastName.toLowerCase() : '') + ('|') +
                    (String.isNotBlank(con.Account.Name) ? con.Account.Name.toLowerCase() : '');
                
                if (!firstContactInfoMap.containsKey(key)) {
                    firstContactInfoMap.put(key, new Map<String, Object>{
                        'Id' => con.Id,
                        'FirstName' => con.FirstName,
                        'Email' => con.Email,
                        'AccountId' => con.AccountId,
                        'AccountRecordTypeId' => con.Account.RecordTypeId
                    });
                    
                } else {
                    Contact contObj = new Contact();
                    Map<String, Object> firstContactInfo = firstContactInfoMap.get(key);
                    Id firstContactId = (Id) firstContactInfo.get('Id');
                    String firstName = (String) firstContactInfo.get('FirstName');
                    String firstEmail = (String) firstContactInfo.get('Email');
                    Id firstAccountId = (Id) firstContactInfo.get('AccountId');
                    Id firstAccountRecordTypeId = (Id) firstContactInfo.get('AccountRecordTypeId');
                    system.debug('first=<'+json.serialize(firstContactInfo)+' curr=>'+json.serialize(con));
                    // system.debug('11'+(String.isNotBlank(con.FirstName)));
                    // system.debug('151'+(con.FirstName.equalsIgnoreCase(firstName)));
                    // system.debug('117'+(String.isNotBlank(con.Email)));
                    // system.debug('1134'+(con.Email == firstEmail));
                    // system.debug('167'+(con.AccountId == firstAccountId));
                  
    
    
                    if ((String.isNotBlank(con.FirstName)  &&  con.FirstName.equalsIgnoreCase(firstName) ) && String.isNotBlank(con.Email) && con.Email == firstEmail && con.AccountId == firstAccountId ) {
                        
                            con.Duplicate_Of_New__c = firstContactId;
                            con.Reason_of_Duplicate_New__c = 'Same FirstName LastName Email Account Name & Id';
                            contactsToUpdate.add(con);
                            processedContactIds.add(con.Id);
                            if (!processedContactIds.contains(firstContactId)) {
                                    contObj.Id= firstContactId;
                                    contObj.Reason_of_Duplicate_New__c = 'Same FirstName LastName Email Account Name & Id';
                                    contObj.Duplicate_Of_New__c = con.Id;
                                    contactsToUpdate.add(contObj);
                                    processedContactIds.add(contObj.Id);
                            }
                    }
                    else
                    if ((String.isNotBlank(con.FirstName) && con.FirstName.equalsIgnoreCase(firstName))  && String.isBlank(con.Email)  && con.AccountId == firstAccountId ) {
                            con.Duplicate_Of_New__c = firstContactId;
                            con.Reason_of_Duplicate_New__c = 'Same FirstName LastName Account Name & Id Blank Email';
                            contactsToUpdate.add(con);
                            processedContactIds.add(con.Id);
                            if (!processedContactIds.contains(firstContactId)) {
                                    contObj.Id= firstContactId;
                                    contObj.Reason_of_Duplicate_New__c = 'Same FirstName LastName Account Name & Id Blank Email';
                                    contObj.Duplicate_Of_New__c = con.Id;
                                    contactsToUpdate.add(contObj);
                                    processedContactIds.add(contObj.Id);
                            }
                        
                    }
                    else
                    if (String.isBlank(con.FirstName)  &&  String.isNotBlank(con.Email)  && con.Email == firstEmail && con.AccountId == firstAccountId ) {
                        
                            con.Duplicate_Of_New__c = firstContactId;
                            con.Reason_of_Duplicate_New__c = 'Same LastName Email Account Name & Id Blank FirstName';
                            contactsToUpdate.add(con);
                            processedContactIds.add(con.Id);
                            if (!processedContactIds.contains(firstContactId)) {
                                    contObj.Id= firstContactId;
                                    contObj.Reason_of_Duplicate_New__c = 'Same LastName Email Account Name & Id Blank FirstName';
                                    contObj.Duplicate_Of_New__c = con.Id;
                                    contactsToUpdate.add(contObj);
                                    processedContactIds.add(contObj.Id);
                            }
                    }
                    else
                    if ((String.isNotBlank(con.FirstName)  && con.FirstName.equalsIgnoreCase(firstName) ) && String.isBlank(con.Email)  && con.AccountId != firstAccountId  ) {
                        
                            con.Duplicate_Of_New__c = firstContactId;
                            con.Reason_of_Duplicate_New__c = 'Same FirstName LastName Account Name Diff Account Id Blank Email';
                            contactsToUpdate.add(con);
                            processedContactIds.add(con.Id);
                            if (!processedContactIds.contains(firstContactId)) {
                                    contObj.Id= firstContactId;
                                    contObj.Reason_of_Duplicate_New__c = 'Same FirstName LastName Account Name Diff Account Id Blank Email';
                                    contObj.Duplicate_Of_New__c = con.Id;
                                    contactsToUpdate.add(contObj);
                                    processedContactIds.add(contObj.Id);
                            }
                        
                    }
                    else
                    if ((String.isNotBlank(con.FirstName)  && con.FirstName.equalsIgnoreCase(firstName)) && String.isNotBlank(con.Email)  && con.Email == firstEmail && con.AccountId != firstAccountId && con.Account.RecordTypeId == firstAccountRecordTypeId ) {
                        
                            con.Duplicate_Of_New__c = firstContactId;
                            con.Reason_of_Duplicate_New__c = 'Same FirstName LastName Email Account Name Record Type Diff Account Id';
                            contactsToUpdate.add(con);
                            processedContactIds.add(con.Id);
                            if (!processedContactIds.contains(firstContactId)) {
                                    contObj.Id= firstContactId;
                                    contObj.Reason_of_Duplicate_New__c = 'Same FirstName LastName Email Account Name Record Type Diff Account Id';
                                    contObj.Duplicate_Of_New__c = con.Id;
                                    contactsToUpdate.add(contObj);
                                    processedContactIds.add(contObj.Id);
                            }
                        
                    }
                    else
                    if ((String.isNotBlank(con.FirstName)  && con.FirstName.equalsIgnoreCase(firstName) ) && String.isNotBlank(con.Email)  && con.Email == firstEmail && con.AccountId != firstAccountId && con.Account.RecordTypeId != firstAccountRecordTypeId ) {
                        
                            con.Duplicate_Of_New__c = firstContactId;
                            con.Reason_of_Duplicate_New__c = 'Same FirstName LastName Email Account Name Diff Record Type & Account Id';
                            contactsToUpdate.add(con);
                            processedContactIds.add(con.Id);
                            if (!processedContactIds.contains(firstContactId)) {
                                    contObj.Id= firstContactId;
                                    contObj.Reason_of_Duplicate_New__c = 'Same FirstName LastName Email Account Name Diff Record Type & Account Id';
                                    contObj.Duplicate_Of_New__c = con.Id;
                                    contactsToUpdate.add(contObj);
                                    processedContactIds.add(contObj.Id);
                            }
                        
                    }
                    else
                    if (  con.AccountId == firstAccountId && String.isBlank(con.Email) && String.isBlank(con.FirstName) && String.isBlank(con.Email)) {
                        
                        con.Duplicate_Of_New__c = firstContactId;
                        con.Reason_of_Duplicate_New__c = 'Same LastName Account Name & Id Blank FirstName Email';
                        contactsToUpdate.add(con);
                        processedContactIds.add(con.Id);
                        if (!processedContactIds.contains(firstContactId)) {
                            contObj.Id= firstContactId;
                            contObj.Reason_of_Duplicate_New__c = 'Same LastName Account Name & Id Blank FirstName Email';
                            contObj.Duplicate_Of_New__c = con.Id;
                            contactsToUpdate.add(contObj);
                            processedContactIds.add(contObj.Id);
                        }
                    }
                    // else{
                        
                    //     con.Duplicate_Of_New__c = firstContactId;
                    //     con.Reason_of_Duplicate_New__c = 'Other';
                    //     contactsToUpdate.add(con);
                    //     processedContactIds.add(con.Id);
                    //     if (!processedContactIds.contains(firstContactId)) {
                    //         contObj.Id= firstContactId;
                    //         contObj.Reason_of_Duplicate_New__c = 'Other';
                    //         contObj.Duplicate_Of_New__c = con.Id;
                    //         contactsToUpdate.add(contObj);
                    //         processedContactIds.add(contObj.Id);
                    //     }
                    // }
                }
            }
            
            system.debug('updaterr=>'+contactsToUpdate);
            if (!contactsToUpdate.isEmpty()) {
                Database.Update(contactsToUpdate,false);
                //  update contactsToUpdate;
            }
            
            
            String jsonString = JSON.serialize(firstContactInfoMap);
            ContentVersion contentVersion = new ContentVersion();
            contentVersion.Title = 'DuplicateContactInfoMap';
            contentVersion.PathOnClient = 'DuplicateContactInfoMap.json';
            contentVersion.VersionData = Blob.valueOf(jsonString);
            if (contentDocumentId != null) {
                contentVersion.ContentDocumentId = contentDocumentId;
            }
           // insert contentVersion; 
            
            
           // contentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id].ContentDocumentId;
        }
        
        public void finish(Database.BatchableContext BC) {
            
            if (contentDocumentId != null) {
             //   List<ContentDocument> documentsToDelete = [SELECT Id FROM ContentDocument WHERE Id = :contentDocumentId];
             //  delete documentsToDelete;
            }
        }
    }