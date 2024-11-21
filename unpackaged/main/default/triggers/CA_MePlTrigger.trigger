/**
* @author SLK Software Services - www.slkgroup.com
* @description Trigger for CA_Meeting_Planning__c Object
* 2020-03-12 : Original Version, rsinha
**/

trigger CA_MePlTrigger on CA_Meeting_Planning__c (before insert, before update, after insert, after update, before delete) {
    if(trigger.isAfter && trigger.isInsert && CA_MePlTriggerHandler.runOnce()){
        // update the contact fields in a future method
        CA_MePlTriggerHandler.updateContactFields(trigger.newMap.keySet());
        //cancel the products if exhibit is cancelled
        CA_MePlTriggerHandler.cancelProducts(trigger.new,trigger.newMap.keySet());
    }
    if(trigger.isAfter && trigger.isUpdate && CA_MePlTriggerHandler.runOnce()){
        // update the contact fields in a future method
        CA_MePlTriggerHandler.updateContactFields(trigger.newMap.keySet());
        //cancel the products if exhibit is cancelled
        CA_MePlTriggerHandler.cancelProducts(trigger.new,trigger.newMap.keySet());
    }
    
    if(trigger.isBefore && trigger.isDelete && CA_MePlTriggerHandler.runOnce()){
        // update the contact fields in a future method
        CA_MePlTriggerHandler.deleteProducts(Trigger.OldMap.keyset());
    }
    if(trigger.isBefore && trigger.isUpdate ){
        // update the contact fields in a future method
        CA_MePlTriggerHandler.updateCancelState(trigger.new);
    }
}