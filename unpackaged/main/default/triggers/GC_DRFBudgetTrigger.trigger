trigger GC_DRFBudgetTrigger on GC_Design_Request_Form_Budget__c (before insert, before update, after insert, after update) {
    if (trigger.isBefore && trigger.isInsert) {
        GC_DRFBudgetTriggerHandler.HandleBeforeInsert(trigger.new);
        GC_DRFBudgetTriggerHandler.UpdateConnect2ShowField(trigger.new);
    }
    else if (trigger.isBefore && trigger.isUpdate) {
        GC_DRFBudgetTriggerHandler.UpdateConnect2ShowField(trigger.new);
    }
    else if (trigger.isAfter && trigger.isInsert) {
        GC_DRFBudgetTriggerHandler.HandleAfterInsert(trigger.new);
        GC_DRFBudgetTriggerHandler.HandleExistingBudgetInsert(trigger.new);
    }
    else if (trigger.isAfter && trigger.isUpdate) {
        GC_DRFBudgetTriggerHandler.CheckChangeOwner(trigger.oldMap, trigger.newMap);
    }
}