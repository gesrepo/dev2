/**
* @author SLK Software Services - www.slkgroup.com
* @description Trigger for CA_Meeting_Room__c Object
* 2020-03-11 : Original Version, rsinha
**/

trigger CA_MeRmTrigger on CA_Meeting_Room__c (before insert, before update, after insert, after update, before delete) {
    if(trigger.isAfter && trigger.isInsert && CA_MeRmTriggerHandler.runOnce()){
        // update the contact fields in a future method
        CA_MeRmTriggerHandler.updateContactFields(trigger.newMap.keySet());
        //cancel the products if exhibit is cancelled
        CA_MeRmTriggerHandler.cancelProducts(trigger.new,trigger.newMap.keySet());
    }
    if(trigger.isAfter && trigger.isUpdate && CA_MeRmTriggerHandler.runOnce()){
        // update the contact fields in a future method
        CA_MeRmTriggerHandler.updateContactFields(trigger.newMap.keySet());
        //cancel the products if exhibit is cancelled
        CA_MeRmTriggerHandler.cancelProducts(trigger.new,trigger.newMap.keySet());
    }
    
    if(trigger.isBefore && trigger.isDelete && CA_MeRmTriggerHandler.runOnce()){
        // update the contact fields in a future method
        CA_MeRmTriggerHandler.deleteProducts(Trigger.OldMap.keyset());
    }
    if(trigger.isBefore && trigger.isUpdate){
        // update the contact fields in a future method
        CA_MeRmTriggerHandler.updateCancelState(Trigger.New);
    }
}