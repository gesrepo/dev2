trigger GT_MeetingRoomCancellationTrigger on GT_Meeting_Room__c (after update, before delete) {
    Set<Id> meetingRoomIds = new Set<Id>();
    List<GT_Meeting_Room__c> meetingRoomList = new List<GT_Meeting_Room__c>();
    Map<Id,List<GT_Brand__c>> meetingRoomBrandMap = new Map<Id,List<GT_Brand__c>>();
    List<GT_Brand__c> tobeUpdatedBrands = new List<GT_Brand__c>();
    List<GT_Brand__c> brandsTobeDeleted = new List<GT_Brand__c>();
    
    if (Trigger.isUpdate) {
        for(GT_Meeting_Room__c meetingRoom: trigger.new){
            if( Trigger.isUpdate && meetingRoom.Canceled__c != Trigger.oldMap.get(meetingRoom.Id).Canceled__c || Trigger.isUpdate && meetingRoom.Cancellation_Date__c != Trigger.oldMap.get(meetingRoom.Id).Cancellation_Date__c || Trigger.isUpdate && meetingRoom.Reason_for_Cancellation__c != Trigger.oldMap.get(meetingRoom.Id).Reason_for_Cancellation__c){
                meetingRoomIds.add(meetingRoom.Id);
                meetingRoomList.add(meetingRoom);
            }
        }
        if(meetingRoomIds.size() > 0) {

            for(GT_Brand__c brand : [SELECT Id,Canceled__c,Cancelled_Date__c,Reason_for_Cancellation__c,Meeting_Room__c FROM GT_Brand__c WHERE Meeting_Room__c IN :meetingRoomIds])
            {
                if(!meetingRoomBrandMap.containskey(brand.Meeting_Room__c))
                {
                    meetingRoomBrandMap.put(brand.Meeting_Room__c,new List<GT_Brand__c>());
                }
                meetingRoomBrandMap.get(brand.Meeting_Room__c).add(brand);
            }         
            
            for(GT_Meeting_Room__c meetingRoom : meetingRoomList)
            {
                if(meetingRoomBrandMap.get(meetingRoom.Id) != null)
                {
                    for(GT_Brand__c brand : meetingRoomBrandMap.get(meetingRoom.Id))
                    {
                        if(meetingRoom.Canceled__c == true){
                            if(brand.Canceled__c == false){
                                brand.Canceled__c =  meetingRoom.Canceled__c;
                                brand.Cancelled_Date__c = meetingRoom.Cancellation_Date__c;
                                brand.Reason_for_Cancellation__c = meetingRoom.Reason_for_Cancellation__c;
                                tobeUpdatedBrands.add(brand);
                            }
                        }
                        else{
                            brand.Canceled__c =  meetingRoom.Canceled__c;
                            brand.Cancelled_Date__c = meetingRoom.Cancellation_Date__c;
                            brand.Reason_for_Cancellation__c = meetingRoom.Reason_for_Cancellation__c;
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
        for(GT_Meeting_Room__c meetingRoom: trigger.old){
            meetingRoomIds.add(meetingRoom.Id);
        }
        
        if(meetingRoomIds.size() > 0) {
            for(GT_Brand__c brand : [SELECT Id,Meeting_Room__c FROM GT_Brand__c WHERE Meeting_Room__c IN :meetingRoomIds])
            {
                if(meetingRoomIds.contains(brand.Meeting_Room__c)){
                    brandsTobeDeleted.add(brand);
                }
            }
        }
        if(brandsTobeDeleted.size() > 0){
            delete brandsTobeDeleted;
        }
    }
}