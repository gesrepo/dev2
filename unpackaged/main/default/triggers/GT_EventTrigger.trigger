//added after insert to call wrike API when a record is created- rsinha SCA-467-468
trigger GT_EventTrigger on GT_Event__c (after insert,after update,before delete) {
    GT_EventTriggerHandler evtHandler = new GT_EventTriggerHandler();
    List<String> eventIds = new List<String>();
    
    //suggestion by rsinha please bulkify the truigger and dont write a for loop inside trigger
    if (Trigger.isUpdate) {
        for(GT_Event__c GT_event: trigger.new){
            if( Trigger.isUpdate && GT_event.Event_Cancelled__c != Trigger.oldMap.get(GT_event.Id).Event_Cancelled__c || Trigger.isUpdate && GT_event.Event_Cancellation_Date__c != Trigger.oldMap.get(GT_event.Id).Event_Cancellation_Date__c || Trigger.isUpdate && GT_event.Reason_for_Cancellation__c != Trigger.oldMap.get(GT_event.Id).Reason_for_Cancellation__c || Trigger.isUpdate && GT_event.Congress_Cancelled__c != Trigger.oldMap.get(GT_event.Id).Congress_Cancelled__c || Trigger.isUpdate && GT_event.Congress_Cancellation_Date__c != Trigger.oldMap.get(GT_event.Id).Congress_Cancellation_Date__c){
                eventIds.add(String.valueOf(GT_event.Id));
            }
        }
        GT_EventTriggerHandler.updateActivities(eventIds);
    }
    
    //to delete all the activities related to an event when it is deleted
   if (Trigger.isDelete) {
        GT_EventTriggerHandler.deleteRelatedActivities();
    }
    
    //added to call wrike API when a record is created- rsinha SCA-467-468
    if(trigger.isInsert && trigger.isAfter){
        GT_EventTriggerHandler.callWrikeApi(trigger.newMap.keySet());
    }
}