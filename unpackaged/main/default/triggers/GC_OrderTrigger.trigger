trigger GC_OrderTrigger on GC_Order__c (after insert, after update) {
    if (trigger.isAfter && trigger.isInsert) {
        GC_OrderTriggerHandler.UpdateShowTeamAccess(Trigger.new);
    }
    else if (trigger.isAfter && trigger.isUpdate) {
        GC_OrderTriggerHandler.CheckChangeOwner(Trigger.oldMap, Trigger.newMap);
    }
}