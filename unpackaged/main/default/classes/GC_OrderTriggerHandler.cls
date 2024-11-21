public without sharing class GC_OrderTriggerHandler {
    public static void UpdateShowTeamAccess(List<GC_Order__c> orders) {
        Set<Id> orderIds = new Set<Id>();
        for (GC_Order__c order : orders) {
            orderIds.add(order.Id);
        }
        List<GC_Order__c> orderQuery = [select Id, Connect2_Show__c from GC_Order__c where Id In :orderIds];
        Set<Id> showIds = new Set<Id>();
        for (GC_Order__c order : orderQuery) {
            showIds.add(order.Connect2_Show__c);
        }
        List<GC_Show_Team_Member__c> showTeamMembers = [select Id, Name, User__c, Show_Role__c, Connect2_Show__c from GC_Show_Team_Member__c where Connect2_Show__c in :showIds];
        GC_ShowTeamMemberTriggerHandler.UpdateRecordAccessOrders(showTeamMembers, orderQuery);
    }

    public static void CheckChangeOwner(Map<Id, GC_Order__c> oldMap, Map<Id, GC_Order__c> newMap) {
        List<GC_Order__c> recalcRecords = new List<GC_Order__c>();
        for (Id orderId : Trigger.newMap.keySet()) {
            if (oldMap.get(orderId).OwnerId != newMap.get(orderId).OwnerId) {
                recalcRecords.add(newMap.get(orderId));
            }
        }
        if (recalcRecords.size() > 0) {
            UpdateShowTeamAccess(recalcRecords);
            UpdateVendorTasks(recalcRecords);
        }
    }

    public static void UpdateVendorTasks(List<GC_Order__c> orders) {
        Set<Id> orderIds = new Set<Id>();
        for (GC_Order__c order : orders) {
            orderIds.add(order.Id);
        }
        List<GC_Vendor_Order_Task__c> vendorTasks = [select Id, Vendor__c from GC_Vendor_Order_Task__c where Order__c In :orderIds AND Vendor__c != null];
        if (vendorTasks.size() > 0) {
            GC_VendorOrderTaskTriggerHandler.HandleVendorShares(vendorTasks);
        }
    }

}