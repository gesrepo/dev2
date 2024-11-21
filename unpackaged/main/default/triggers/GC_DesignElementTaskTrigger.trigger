trigger GC_DesignElementTaskTrigger on GC_Design_Element__c (before insert, before update, after insert, after update) {
    if (trigger.isBefore && trigger.isInsert) {
        GC_DesignElementTaskTriggerHandler.CheckCreativeDirectorsAndDetailers(Trigger.new);
        GC_DesignElementTaskTriggerHandler.ClearRevisionInfo(Trigger.new);
        GC_DesignElementTaskTriggerHandler.SetAccountManager(Trigger.new);
        GC_DesignElementTaskTriggerHandler.updateApproverFields(Trigger.New); // SAL-1293 - to update the approval field on recrod insert - 02-09-24 - Sajid
    }
    else if (trigger.isBefore && trigger.isUpdate) {
        GC_DesignElementTaskTriggerHandler.CheckArchivedStatus(Trigger.oldMap, Trigger.newMap);
        GC_DesignElementTaskTriggerHandler.CheckApprovedStatus(Trigger.oldMap, Trigger.newMap);
        GC_DesignElementTaskTriggerHandler.CheckCreativeDirectorsAndDetailers(Trigger.new);
        //GC_DesignElementTaskTriggerHandler.CheckDetailer(Trigger.new);  //Amarab 04062021 SAL-1243 Remove check as assignment is managed in Workfront
        GC_DesignElementTaskTriggerHandler.HandleOnHoldBeforeUpdate(Trigger.new);
        GC_DesignElementTaskTriggerHandler.SetAccountManager(Trigger.new);
    }
    else if (trigger.isAfter && trigger.isInsert) {
        GC_DesignElementTaskTriggerHandler.AddAssignments(Trigger.newMap.keySet());
        GC_DesignElementTaskTriggerHandler.UpdateShowTeamAccess(Trigger.new);
    }
    else if (trigger.isAfter && trigger.isUpdate) {
        GC_DesignElementTaskTriggerHandler.CheckChangeOwner(Trigger.oldMap, Trigger.newMap);
        Set<Id> idsToUpdate = GC_DesignElementTaskTriggerHandler.GetTeamChanges(Trigger.oldMap, Trigger.newMap);
        if (idsToUpdate.size() > 0) {
            GC_DesignElementTaskTriggerHandler.AddAssignments(idsToUpdate);
            GC_DesignElementTaskTriggerHandler.UpdateAssignments(idsToUpdate);
        }
    }
}