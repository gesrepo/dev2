trigger GC_DesignRequestFormTrigger on GC_Design_Request_Form__c (before insert, before update, after insert, after update) {
    if (trigger.isBefore && trigger.isInsert) {
        GC_DesignRequestFormTriggerHandler.CheckMoreThanOneDRF(Trigger.new);
        GC_DesignRequestFormTriggerHandler.HandleBeforeUpdate(Trigger.new);
        GC_DesignRequestFormTriggerHandler.HandleValidRequester(Trigger.new);
    }
    if (trigger.isBefore && trigger.isUpdate) {
        GC_DesignRequestFormTriggerHandler.DetermineRequester(Trigger.oldMap, Trigger.newMap);
        GC_DesignRequestFormTriggerHandler.HandleBeforeUpdate(Trigger.new);
    }
    if (trigger.isAfter && trigger.isInsert) {
        GC_DesignRequestFormTriggerHandler.HandleShowTeamRecordAccess(Trigger.new);
        GC_DesignRequestFormTriggerHandler.PopulateLastYearsJobNumber(Trigger.new);
    }
    if (trigger.isAfter && trigger.isUpdate) {
        GC_DesignRequestFormTriggerHandler.HandleCancelActionTrigger(Trigger.new);
        GC_DesignRequestFormTriggerHandler.CheckChangeOwner(Trigger.oldMap, Trigger.newMap);
        GC_DesignRequestFormTriggerHandler.PopulateLastYearsJobNumber(Trigger.new);
    }
}