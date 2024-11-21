trigger GC_Connect2ShowTrigger on GC_Connect2_Show__c (after insert, after update, before insert, before update) {
    if (trigger.isAfter && trigger.isInsert) {
        GC_Connect2ShowTriggerHandler.AddShowTeamMembers(trigger.New);
        //SAL-1315 - Notification to NSC for KYS Updates - 12/14/23 - Sajid
        GC_Connect2ShowTriggerHandler.sendEmailToNSC(trigger.new, null);
    }
    else if (trigger.isAfter && trigger.isUpdate) {
        GC_Connect2ShowTriggerHandler.CheckChangeOwner(trigger.oldMap, trigger.newMap);
        //SAL-1315 - Notification to NSC for KYS Updates - 12/14/23 - Sajid
        GC_Connect2ShowTriggerHandler.sendEmailToNSC(trigger.new, trigger.oldMap);
    }
    
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            //SAL-1315 - Notification to NSC for KYS Updates - 12/14/23 - Sajid
            GC_Connect2ShowTriggerHandler.updateKYSNoficationDate(trigger.new);
        }
        if(Trigger.isUpdate){
            //SAL-1315 - Notification to NSC for KYS Updates - 12/14/23 - Sajid
            GC_Connect2ShowTriggerHandler.updateKYSFields(trigger.new, trigger.oldMap);
        }
    }
}