trigger CA_MainEventTrigger on CA_Main_Event__c (after insert, after update,before update) {
    if(trigger.isBefore && trigger.isUpdate ){
         CA_MainEventTriggerHandler.updateCancelState(trigger.new);
    }
    if(trigger.isAfter && trigger.isUpdate && CA_MainEventTriggerHandler.runOnce()){
        //cancel the activities if event is canceled
        CA_MainEventTriggerHandler.cancelActivities(trigger.new);
    }
}