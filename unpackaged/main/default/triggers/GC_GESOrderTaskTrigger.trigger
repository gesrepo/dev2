trigger GC_GESOrderTaskTrigger on GC_GES_Order_Task__c (before insert, before update, after insert, after update, after delete) {
    //if (GC_GESOrderTaskTriggerHandler.runOnce()) {
        if (trigger.isBefore) {
           
            /*if(Trigger.new != NULL && !Trigger.new.isEmpty()) {
                GC_GESOrderTaskTriggerHandler.HandleCancelStatus(Trigger.new);    
            }   */
            //GC_GESOrderTaskTriggerHandler.HandleOnHoldStatus(Trigger.new);
            GC_GESOrderTaskTriggerHandler.HandleCancelStatus(Trigger.new);       
        }

        if (trigger.isAfter && trigger.isInsert) {
            GC_GESOrderTaskTriggerHandler.UpdateShowTeamAccess(Trigger.new);
            GC_GESOrderTaskTriggerHandler.HandleOrderStatus(Trigger.new);
        }

        if (trigger.isAfter && trigger.isUpdate) {
            GC_GESOrderTaskTriggerHandler.HandleOrderStatus(Trigger.new);
            GC_GESOrderTaskTriggerHandler.HandleOrderNumbers(Trigger.oldMap, Trigger.newMap);
            GC_GESOrderTaskTriggerHandler.HandleEmailToOriginator(Trigger.oldMap, Trigger.newMap);
            GC_GESOrderTaskTriggerHandler.HandleFieldUpdateEmails(Trigger.oldMap, Trigger.newMap);
            GC_GESOrderTaskTriggerHandler.CheckChangeOwner(Trigger.oldMap, Trigger.newMap);
            GC_GESOrderTaskTriggerHandler.HandleOrderRevisions(Trigger.oldMap, Trigger.newMap);
            GC_GESOrderTaskTriggerHandler.HandleEmailToGraphics(Trigger.oldMap, Trigger.newMap);
        }
        if (trigger.isAfter && trigger.isDelete) {
            GC_GESOrderTaskTriggerHandler.HandleOrderStatus(Trigger.old);
        }
        
            //}
}