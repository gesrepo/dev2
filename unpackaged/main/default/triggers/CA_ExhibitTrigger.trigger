trigger CA_ExhibitTrigger on CA_Exhibit__c (before insert, before update, after insert, after update, before delete) {
    if(trigger.isAfter && trigger.isInsert && CA_ExhibitTriggerHandler.runOnce()){
        // update the contact fields in a future method
        CA_ExhibitTriggerHandler.updateContactFields(trigger.newMap.keySet());
        //cancel the products if exhibit is cancelled
        CA_ExhibitTriggerHandler.cancelProducts(trigger.new,trigger.newMap.keySet());
    }
    if(trigger.isAfter && trigger.isUpdate && CA_ExhibitTriggerHandler.runOnce()){
        // update the contact fields in a future method
        CA_ExhibitTriggerHandler.updateContactFields(trigger.newMap.keySet());
        //cancel the products if exhibit is cancelled
        CA_ExhibitTriggerHandler.cancelProducts(trigger.new,trigger.newMap.keySet());
    }
    
    if(trigger.isBefore && trigger.isDelete && CA_ExhibitTriggerHandler.runOnce()){
        // update the contact fields in a future method
        CA_ExhibitTriggerHandler.deleteProducts(Trigger.OldMap.keyset());
    }
    if(trigger.isBefore && trigger.isUpdate ){
        CA_ExhibitTriggerHandler.updateCancelState(Trigger.New);
    }
    
}