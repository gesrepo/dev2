trigger GT_MeetingPlanningCancellationTrigger on GT_Meeting_Planning__c (after update, before delete) {
    Set<Id> meetingPlanningIds = new Set<Id>();
    List<GT_Meeting_Planning__c> meetingPlanningList = new List<GT_Meeting_Planning__c>();
    Map<Id,List<GT_Brand__c>> meetingPlanningBrandMap = new Map<Id,List<GT_Brand__c>>();
    List<GT_Brand__c> tobeUpdatedBrands = new List<GT_Brand__c>();
    List<GT_Brand__c> brandsTobeDeleted = new List<GT_Brand__c>();
    
    if (Trigger.isUpdate) {
        for(GT_Meeting_Planning__c meetingPlanning: trigger.new){
            if( Trigger.isUpdate && meetingPlanning.Canceled__c != Trigger.oldMap.get(meetingPlanning.Id).Canceled__c || Trigger.isUpdate && meetingPlanning.Cancellation_Date__c != Trigger.oldMap.get(meetingPlanning.Id).Cancellation_Date__c || Trigger.isUpdate && meetingPlanning.Reason_for_Cancellation__c != Trigger.oldMap.get(meetingPlanning.Id).Reason_for_Cancellation__c){
                meetingPlanningIds.add(meetingPlanning.Id);
                meetingPlanningList.add(meetingPlanning);
            }
        }
        if(meetingPlanningIds.size() > 0) {

            for(GT_Brand__c brand : [SELECT Id,Canceled__c,Cancelled_Date__c,Reason_for_Cancellation__c,Meeting_Planning__c FROM GT_Brand__c WHERE Meeting_Planning__c IN :meetingPlanningIds])
            {
                if(!meetingPlanningBrandMap.containskey(brand.Meeting_Planning__c))
                {
                    meetingPlanningBrandMap.put(brand.Meeting_Planning__c,new List<GT_Brand__c>());
                }
                meetingPlanningBrandMap.get(brand.Meeting_Planning__c).add(brand);
            }         
            
            for(GT_Meeting_Planning__c meetingPlanning : meetingPlanningList)
            {
                if(meetingPlanningBrandMap.get(meetingPlanning.Id) != null)
                {
                    for(GT_Brand__c brand : meetingPlanningBrandMap.get(meetingPlanning.Id))
                    {
                        if(meetingPlanning.Canceled__c == true){
                            if(brand.Canceled__c == false){
                                brand.Canceled__c =  meetingPlanning.Canceled__c;
                                brand.Cancelled_Date__c = meetingPlanning.Cancellation_Date__c;
                                brand.Reason_for_Cancellation__c = meetingPlanning.Reason_for_Cancellation__c;
                                tobeUpdatedBrands.add(brand);
                            }
                        }
                        else{
                            brand.Canceled__c =  meetingPlanning.Canceled__c;
                            brand.Cancelled_Date__c = meetingPlanning.Cancellation_Date__c;
                            brand.Reason_for_Cancellation__c = meetingPlanning.Reason_for_Cancellation__c;
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
        for(GT_Meeting_Planning__c meetingPlanning: trigger.old){
            meetingPlanningIds.add(meetingPlanning.Id);
        }
        
        if(meetingPlanningIds.size() > 0) {
            for(GT_Brand__c brand : [SELECT Id,Meeting_Planning__c FROM GT_Brand__c WHERE Meeting_Planning__c IN :meetingPlanningIds])
            {
                if(meetingPlanningIds.contains(brand.Meeting_Planning__c)){
                    brandsTobeDeleted.add(brand);
                }
            }
        }
        if(brandsTobeDeleted.size() > 0){
            delete brandsTobeDeleted;
        }
    }
}