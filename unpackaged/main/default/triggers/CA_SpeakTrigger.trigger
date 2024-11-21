/**
* @author Birlasoft : Vaishali
* @description Trigger for trigger <name> on CA_Speaking_Engagement__c (<events>) 
* 2020-04-23 : Original Version, VaishaliT
**/

trigger CA_SpeakTrigger on CA_Speaking_Engagement__c (before insert, before update, after insert, after update, before delete) {
    if(trigger.isAfter && trigger.isInsert && CA_SpeakTriggerHandler.runOnce()){
        // update the contact fields in a future method
        CA_SpeakTriggerHandler.updateContactFields(trigger.newMap.keySet());
        //cancel the products if exhibit is cancelled
        CA_SpeakTriggerHandler.cancelProducts(trigger.new,trigger.newMap.keySet());
    }
    if(trigger.isAfter && trigger.isUpdate && (CA_SpeakTriggerHandler.runOnce() || test.isRunningTest())){
        // update the contact fields in a future method
        CA_SpeakTriggerHandler.updateContactFields(trigger.newMap.keySet());
        //cancel the products if exhibit is cancelled
        CA_SpeakTriggerHandler.cancelProducts(trigger.new,trigger.newMap.keySet());
    }
    
    if(trigger.isBefore && trigger.isDelete && (CA_SpeakTriggerHandler.runOnce() || test.isRunningTest())){
        // update the contact fields in a future method
        CA_SpeakTriggerHandler.deleteProducts(Trigger.OldMap.keyset());
    }
    if(trigger.isBefore && trigger.isUpdate){
        CA_SpeakTriggerHandler.updateCancelState(trigger.new);
    }
}