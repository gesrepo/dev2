trigger GC_ShowTeamAssignmentTrigger on GC_Show_Team_Assignment__c (before insert, before update, after insert) {
    if (trigger.isBefore) {
        GC_ShowTeamAssignmentTriggerHandler.UpdateShowTeamAssignmentUnique(trigger.new);
    }
    else if (trigger.isAfter && trigger.isInsert) {
        GC_ShowTeamAssignmentTriggerHandler.UpdateTaskAccess(trigger.new);
    }
}