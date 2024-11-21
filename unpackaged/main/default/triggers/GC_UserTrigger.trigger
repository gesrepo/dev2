trigger GC_UserTrigger on User (before insert, before update, after insert, after update) {
    if (Trigger.isBefore && Trigger.isInsert) {
        GC_UserTriggerHandler.handleBeforeInsert(Trigger.new);
    }

    if (Trigger.isBefore && Trigger.isUpdate) {
        GC_UserTriggerHandler.handleBeforeUpdate(Trigger.oldMap, Trigger.newMap);
        GC_UserTriggerHandler.updateCallCenter(Trigger.oldMap, Trigger.newMap);// SFDC-301 Call center updated when Role is changed - 10/14/24 - SM
    }
    
    if (Trigger.isAfter && Trigger.isInsert) {
        GC_UserTriggerHandler.handleAfterInsert(Trigger.new);
    }    

    if (Trigger.isAfter && Trigger.isUpdate) {
        GC_UserTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.OldMap);
    }    
}