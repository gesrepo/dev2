/**
* @author SLK Software Services - www.slkgroup.com
* @description Trigger for CA_Sponsorship__c Object
* 2020-03-11 : Original Version, rsinha
**/

trigger CA_SponTrigger on CA_Sponsorship__c (before insert, before update, after insert, after update, before delete) {
    if(trigger.isAfter && trigger.isInsert && CA_SponTriggerHandler.runOnce()){
        // update the contact fields in a future method
        CA_SponTriggerHandler.updateContactFields(trigger.newMap.keySet());
        //cancel the products if exhibit is cancelled
        CA_SponTriggerHandler.cancelProducts(trigger.new,trigger.newMap.keySet());
    }
    if(trigger.isAfter && trigger.isUpdate && CA_SponTriggerHandler.runOnce()){
        // update the contact fields in a future method
        CA_SponTriggerHandler.updateContactFields(trigger.newMap.keySet());
        //cancel the products if exhibit is cancelled
        CA_SponTriggerHandler.cancelProducts(trigger.new,trigger.newMap.keySet());
    }
    
    if(trigger.isBefore && trigger.isDelete && CA_SponTriggerHandler.runOnce()){
        // update the contact fields in a future method
        CA_SponTriggerHandler.deleteProducts(Trigger.OldMap.keyset());
    }
	if(trigger.isBefore && trigger.isUpdate){
        // update the contact fields in a future method
        CA_SponTriggerHandler.updateCancelState(Trigger.new);
    }        
}