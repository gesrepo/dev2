trigger MeetingRoomTrigger on Meeting_Room__c (after update) 
{
    Set<Id> meetRoomIds = new set<Id>();
    Set<Id> meetingRoomCurrencyIds = new set<Id>();
    Map<Id,List<Brand__c>> mrBrandMap = new Map<Id,List<Brand__c>>();
    Map<Id,Meeting_Room__c> meetingRoomCurrencyMap = new Map<Id,Meeting_Room__c>();
    List<Brand__c> tobeUpdatedBrands = new List<Brand__c>();
    List<Meeting_Room__c> mrList = new List<Meeting_Room__c>();
    
    for(Meeting_Room__c records : trigger.new)
    {
       if(records.Canceled__c != Trigger.oldMap.get(records.Id).Canceled__c || records.CanceledDate__c != Trigger.oldMap.get(records.Id).CanceledDate__c || records.Cancel_Reason__c != Trigger.oldMap.get(records.Id).Cancel_Reason__c)
       {
           meetRoomIds.add(records.Id);
           mrList.add(records);
       }
    }
    
    for(Brand__c bran : [SELECT Id,Canceled__c,Cancelled_Date__c,Reason_for_Cancellation__c,Meeting_Room__c FROM Brand__c WHERE Meeting_Room__c IN :meetRoomIds])
    {
        if(!mrBrandMap.containskey(bran.Meeting_Room__c))
        {
            mrBrandMap.put(bran.Meeting_Room__c,new List<Brand__c>());
        }
        mrBrandMap.get(bran.Meeting_Room__c).add(bran);
    }         
    
    for(Meeting_Room__c ex : mrList)
    {
        if(mrBrandMap.get(ex.Id) != null)
        {
            for(Brand__c b : mrBrandMap.get(ex.Id))
            {
                if(ex.Canceled__c == true){
                        if(b.Canceled__c == false){	
                            b.Canceled__c =  ex.Canceled__c;
                            b.Cancelled_Date__c = ex.CanceledDate__c;
                            b.Reason_for_Cancellation__c = ex.Cancel_Reason__c;
                            tobeUpdatedBrands.add(b);
                        }
                    }
                    else{
                        b.Canceled__c =  ex.Canceled__c;
                        b.Cancelled_Date__c = ex.CanceledDate__c;
                        b.Reason_for_Cancellation__c = ex.Cancel_Reason__c;
                        tobeUpdatedBrands.add(b);
                    }            }
        }
    }
    
    if(tobeUpdatedBrands.size() > 0)
    {
        update tobeUpdatedBrands;
    }
    
    /*for(Meeting_Room__c records : trigger.new)
    {
       if(records.CurrencyIsoCode != Trigger.oldMap.get(records.Id).CurrencyIsoCode)
       {
           meetingRoomCurrencyIds.add(records.Id);
           meetingRoomCurrencyMap.put(records.Id,records);
       }
    }
    
    if(meetingRoomCurrencyIds.size() > 0) {
        MeetingRoomTriggerHandler.updateBrandCurrency(meetingRoomCurrencyIds, meetingRoomCurrencyMap);
    }*/

}