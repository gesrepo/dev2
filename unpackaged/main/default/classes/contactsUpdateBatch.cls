/*************************************************************************************************
Class     :  contactsUpdateBatch.cls
Developer :  Najmal M K Muhammed
Created   :  March 09,2023
Modified  :  March 09,2023
Objective :  This class provides for BoothUploadAll.apxt

*************************************************************************************************/
global class contactsUpdateBatch implements Database.Batchable<sObject>, Database.Stateful{
    
    global List<Contact> contactsTobeUpdate { get; set; }
    
    global contactsUpdateBatch(List<Contact> contacts) {
        contactsTobeUpdate = contacts;
    }
    
     global List<Contact> start(Database.BatchableContext BC) {
        return contactsTobeUpdate;
    }

    global void execute(Database.BatchableContext BC, List<Contact> contacts) {
        try{
        	update contacts;
        }catch(Exception e){
            System.debug(e.getMessage());
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        system.debug('Finished');
    }
}