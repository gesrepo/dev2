trigger GC_VendorOrderTaskTrigger on GC_Vendor_Order_Task__c (after insert, after update) {
    if(trigger.isAfter && trigger.isInsert){
        GC_VendorOrderTaskTriggerHandler.HandleShowTeamCreation(Trigger.new);
        GC_VendorOrderTaskTriggerHandler.UpdateShowTeamAccess(Trigger.new);
        GC_VendorOrderTaskTriggerHandler.AddVendorToShow(Trigger.new);
        GC_VendorOrderTaskTriggerHandler.HandleVendorShares(Trigger.new);
        GC_VendorOrderTaskTriggerHandler.HandleGESOrderTaskShares(Trigger.new);
    }
    if(trigger.isAfter && trigger.isUpdate){
        GC_VendorOrderTaskTriggerHandler.AddVendorToShow(Trigger.oldMap, Trigger.newMap);
        GC_VendorOrderTaskTriggerHandler.CheckChangeOwner(Trigger.oldMap, Trigger.newMap);
        GC_VendorOrderTaskTriggerHandler.HandleGESOrderTaskShares(Trigger.oldMap, Trigger.newMap);
    }
}