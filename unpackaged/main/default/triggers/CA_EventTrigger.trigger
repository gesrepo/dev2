/**
* @author SLK Software Services - www.slkgroup.com
* @description Trigger for CA Event Object
* 2020-03-11 : Original Version, rsinha
**/

trigger CA_EventTrigger on CA_Event__c (before insert, before update, after insert, after update, before delete) {
    if(trigger.isAfter && trigger.isInsert && CA_EventTriggerHandler.runOnce()){
        // update the contact fields in a future method
        CA_EventTriggerHandler.updateContactFields(trigger.newMap.keySet());
        //cancel the products if exhibit is cancelled
        CA_EventTriggerHandler.cancelProducts(trigger.new,trigger.newMap.keySet());
    }
    if(trigger.isAfter && trigger.isUpdate && CA_EventTriggerHandler.runOnce()){
        // update the contact fields in a future method
        CA_EventTriggerHandler.updateContactFields(trigger.newMap.keySet());
        //cancel the products if exhibit is cancelled
        CA_EventTriggerHandler.cancelProducts(trigger.new,trigger.newMap.keySet());
    }
    
    if(trigger.isBefore && trigger.isDelete && CA_EventTriggerHandler.runOnce()){
        // update the contact fields in a future method
        CA_EventTriggerHandler.deleteProducts(Trigger.OldMap.keyset());
    }
    if(trigger.isBefore && trigger.isUpdate){
        // update the contact fields in a future method
        CA_EventTriggerHandler.updateCancelState(Trigger.New);
    }
}