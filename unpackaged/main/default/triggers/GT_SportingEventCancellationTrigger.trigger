trigger GT_SportingEventCancellationTrigger on GT_Sporting_Event__c (after update, before delete) {
    Set<Id> sportingEventIds = new Set<Id>();
    List<GT_Sporting_Event__c> sportingEventList = new List<GT_Sporting_Event__c>();
    Map<Id,List<GT_Brand__c>> sportingEventBrandMap = new Map<Id,List<GT_Brand__c>>();
    List<GT_Brand__c> tobeUpdatedBrands = new List<GT_Brand__c>();
    List<GT_Brand__c> brandsTobeDeleted = new List<GT_Brand__c>();
    
    if (Trigger.isUpdate) {
        for(GT_Sporting_Event__c sportingEvent: trigger.new){
            if( Trigger.isUpdate && sportingEvent.Canceled__c != Trigger.oldMap.get(sportingEvent.Id).Canceled__c || Trigger.isUpdate && sportingEvent.Cancellation_Date__c != Trigger.oldMap.get(sportingEvent.Id).Cancellation_Date__c || Trigger.isUpdate && sportingEvent.Reason_for_Cancellation__c != Trigger.oldMap.get(sportingEvent.Id).Reason_for_Cancellation__c){
                sportingEventIds.add(sportingEvent.Id);
                sportingEventList.add(sportingEvent);
            }
        }
        if(sportingEventIds.size() > 0) {

            for(GT_Brand__c brand : [SELECT Id,Canceled__c,Cancelled_Date__c,Reason_for_Cancellation__c,Sporting_Event__c FROM GT_Brand__c WHERE Sporting_Event__c IN :sportingEventIds])
            {
                if(!sportingEventBrandMap.containskey(brand.Sporting_Event__c))
                {
                    sportingEventBrandMap.put(brand.Sporting_Event__c,new List<GT_Brand__c>());
                }
                sportingEventBrandMap.get(brand.Sporting_Event__c).add(brand);
            }         
            
            for(GT_Sporting_Event__c sportingEvent : sportingEventList)
            {
                if(sportingEventBrandMap.get(sportingEvent.Id) != null)
                {
                    for(GT_Brand__c brand : sportingEventBrandMap.get(sportingEvent.Id))
                    {
                        if(sportingEvent.Canceled__c == true){
                            if(brand.Canceled__c == false){
                                brand.Canceled__c =  sportingEvent.Canceled__c;
                                brand.Cancelled_Date__c = sportingEvent.Cancellation_Date__c;
                                brand.Reason_for_Cancellation__c = sportingEvent.Reason_for_Cancellation__c;
                                tobeUpdatedBrands.add(brand);
                            }
                        }
                        else{
                            brand.Canceled__c =  sportingEvent.Canceled__c;
                            brand.Cancelled_Date__c = sportingEvent.Cancellation_Date__c;
                            brand.Reason_for_Cancellation__c = sportingEvent.Reason_for_Cancellation__c;
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
        for(GT_Sporting_Event__c sportingEvent: trigger.old){
            sportingEventIds.add(sportingEvent.Id);
        }
        
        if(sportingEventIds.size() > 0) {
            for(GT_Brand__c brand : [SELECT Id,Sporting_Event__c FROM GT_Brand__c WHERE Sporting_Event__c IN :sportingEventIds])
            {
                if(sportingEventIds.contains(brand.Sporting_Event__c)){
                    brandsTobeDeleted.add(brand);
                }
            }
        }
        if(brandsTobeDeleted.size() > 0){
            delete brandsTobeDeleted;
        }
    }
}