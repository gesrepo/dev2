/***************************************************************************************************
Author: Shyam Nair (SLK Software)
Date: 10/30/2019
Description: Trigger which will run on Contact for following events:
1. After Insert
2. After Update
Note: While adding new logics to the trigger, please maintain the business logic in a handler class.
Related Handler Class - ContactTriggerHandler
****************************************************************************************************/
trigger ContactTrigger on Contact (After Insert, After Update, before insert, before update) {
    
    List<Contact> contacts1 = new List<Contact>();
    List<Contact> contacts2 = new List<Contact>();
    List<Contact> contacts3 = new List<Contact>();
    List<Contact> contacts4 = new List<Contact>();
    
    if(Trigger.isBefore){
        if(ContactTriggerHandler.isFirstTime){
            ContactTriggerHandler.isFirstTime = false;
            
            for(Contact contact :Trigger.new){
                if((Trigger.isInsert 
                    || (Trigger.isUpdate && Trigger.oldMap.get(contact.Id).Primary_Contact__c != contact.Primary_Contact__c)) 
                   && contact.Primary_Contact__c){
                       contacts1.add(contact);
                   }
                
                if(Trigger.isUpdate 
                   && Trigger.oldMap.get(contact.Id).Primary_Contact__c != contact.Primary_Contact__c 
                   && !contact.Primary_Contact__c){
                       contacts2.add(contact);
                   }
            }
            
            if(!contacts1.isEmpty()){
                ContactTriggerHandler.setPrimaryOnAccount(contacts1);
            }
            
            if(!contacts2.isEmpty()){
                ContactTriggerHandler.unsetPrimaryContactOnAccount(contacts2);
            }
        }
    }
    
    
    if(Trigger.isBefore){
        Set<Id> setAccIds = new Set<Id>();
        Map<Id,Id> mapContIdToAccId = new Map<Id,Id>();
        for(Contact contact :Trigger.new){
            // Code added by Sajid - 03/06/23 (SFDC-232)
            if(((Trigger.isInsert && contact.Phone != null) ||(Trigger.isUpdate && (Trigger.oldMap.get(contact.Id).Phone != contact.Phone || Trigger.oldMap.get(contact.Id).MobilePhone != contact.MobilePhone || (contact.MobilePhone == null && contact.Phone != null)))) && !contact.EMEA_Contact__c){
                if(contact.MobilePhone == null){
                    if(contact.Phone != null && !contact.Phone.contains('whatsapp')){
                        contacts3.add(contact);
                        setAccIds.add(contact.AccountId);
                        mapContIdToAccId.put(contact.Id,contact.AccountId);
                    }
                }else if(!contact.MobilePhone.contains('whatsapp')){
                    contacts4.add(contact);
                    setAccIds.add(contact.AccountId);
                    mapContIdToAccId.put(contact.Id,contact.AccountId);
                }
            }
        }
        
        system.debug('setAccIds:: '+setAccIds);

        if(!contacts3.isEmpty()){
            ContactTriggerHandler.updateMobilePhone(contacts3, true, setAccIds,mapContIdToAccId);
        }
        if(!contacts4.isEmpty()){
            ContactTriggerHandler.updateMobilePhone(contacts4, false, setAccIds,mapContIdToAccId);
        }
        //code Ended
    }
}