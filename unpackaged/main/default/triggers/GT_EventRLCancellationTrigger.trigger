trigger GT_EventRLCancellationTrigger on GT_Event_RL__c (after update, before delete) {
    Set<Id> eventIds = new Set<Id>();
    List<GT_Event_RL__c> eventList = new List<GT_Event_RL__c>();
    Map<Id,List<GT_Brand__c>> eventBrandMap = new Map<Id,List<GT_Brand__c>>();
    List<GT_Brand__c> tobeUpdatedBrands = new List<GT_Brand__c>();
    List<GT_Brand__c> brandsTobeDeleted = new List<GT_Brand__c>();
    
    if (Trigger.isUpdate) {
        for(GT_Event_RL__c event: trigger.new){
            if( Trigger.isUpdate && event.Canceled__c != Trigger.oldMap.get(event.Id).Canceled__c || Trigger.isUpdate && event.Cancellation_Date__c != Trigger.oldMap.get(event.Id).Cancellation_Date__c || Trigger.isUpdate && event.Reason_for_Cancellation__c != Trigger.oldMap.get(event.Id).Reason_for_Cancellation__c){
                eventIds.add(event.Id);
                eventList.add(event);
            }
        }
        if(eventIds.size() > 0) {

            for(GT_Brand__c brand : [SELECT Id,Canceled__c,Cancelled_Date__c,Reason_for_Cancellation__c,Event__c FROM GT_Brand__c WHERE Event__c IN :eventIds])
            {
                if(!eventBrandMap.containskey(brand.Event__c))
                {
                    eventBrandMap.put(brand.Event__c,new List<GT_Brand__c>());
                }
                eventBrandMap.get(brand.Event__c).add(brand);
            }         
            
            for(GT_Event_RL__c event : eventList)
            {
                if(eventBrandMap.get(event.Id) != null)
                {
                    for(GT_Brand__c brand : eventBrandMap.get(event.Id))
                    {
                        if(event.Canceled__c == true){
                            if(brand.Canceled__c == false){
                                brand.Canceled__c =  event.Canceled__c;
                                brand.Cancelled_Date__c = event.Cancellation_Date__c;
                                brand.Reason_for_Cancellation__c = event.Reason_for_Cancellation__c;
                                tobeUpdatedBrands.add(brand);
                            }
                        }
                        else{
                            brand.Canceled__c =  event.Canceled__c;
                            brand.Cancelled_Date__c = event.Cancellation_Date__c;
                            brand.Reason_for_Cancellation__c = event.Reason_for_Cancellation__c;
                            tobeUpdatedBrands.add(brand);
                        }
                    }
                }
            }
            if(tobeUpdatedBrands.size() > 0)
            {
                update tobeUpdatedBrands;
            }
        }
    }
    
    if (Trigger.isDelete) {
        for(GT_Event_RL__c event: trigger.old){
            eventIds.add(event.Id);
        }
        
        if(eventIds.size() > 0) {
            for(GT_Brand__c brand : [SELECT Id,Event__c FROM GT_Brand__c WHERE Event__c IN :eventIds])
            {
                if(eventIds.contains(brand.Event__c)){
                    brandsTobeDeleted.add(brand);
                }
            }
        }
        if(brandsTobeDeleted.size() > 0){
            delete brandsTobeDeleted;
        }
    }
}