trigger ExhibitTrigger on Exhibit__c (after update)
{
    Set<Id> exhibitIds = new set<Id>();
    Set<Id> exhibitCurrencyIds = new set<Id>();
    Set<Id> setCongressIds = new set<Id>();
    Map<Id,Exhibit__c> exhibitCurrencyMap = new Map<Id,Exhibit__c>();
    Map<Id,List<Brand__c>> exhibitBrandMap = new Map<Id,List<Brand__c>>();
    List<Brand__c> tobeUpdatedBrands = new List<Brand__c>();
    List<Exhibit__c> exList = new List<Exhibit__c>();
    
    for(Exhibit__c records : trigger.new)
    {
       if( records.Canceled__c != Trigger.oldMap.get(records.Id).Canceled__c || records.CanceledDate__c != Trigger.oldMap.get(records.Id).CanceledDate__c || records.CancelReason__c != Trigger.oldMap.get(records.Id).CancelReason__c)
       {
           exhibitIds.add(records.Id);
           exList.add(records);
           setCongressIds.add(records.Activity_Type_Exhibit_Instance_c__c);
       }
    }
    if(exhibitIds.size() > 0) {
        for(Brand__c bran : [SELECT Id,Canceled__c,Cancelled_Date__c,Reason_for_Cancellation__c,Exhibit_Instance__c FROM Brand__c WHERE Exhibit_Instance__c IN :exhibitIds])
        {
            if(!exhibitBrandMap.containskey(bran.Exhibit_Instance__c))
            {
                exhibitBrandMap.put(bran.Exhibit_Instance__c,new List<Brand__c>());
            }
            exhibitBrandMap.get(bran.Exhibit_Instance__c).add(bran);
        }         
        
        for(Exhibit__c ex : exList)
        {
            if(exhibitBrandMap.get(ex.Id) != null)
            {
                for(Brand__c b : exhibitBrandMap.get(ex.Id))
                {
                    if(ex.Canceled__c == true){
                        if(b.Canceled__c == false){
                            system.debug('Cancelled selected');
                            b.Canceled__c =  ex.Canceled__c;
                            b.Cancelled_Date__c = ex.CanceledDate__c;
                            b.Reason_for_Cancellation__c = ex.CancelReason__c;
                            tobeUpdatedBrands.add(b);
                        }
                    }
                    else{
                        system.debug('Cancelled not selected');
                        b.Canceled__c =  ex.Canceled__c;
                        b.Cancelled_Date__c = ex.CanceledDate__c;
                        b.Reason_for_Cancellation__c = ex.CancelReason__c;
                        tobeUpdatedBrands.add(b);
                    }
                }
            }
        }
        
        if(tobeUpdatedBrands.size() > 0)
        {
            update tobeUpdatedBrands;
        }
        //ExhibitTriggerHandler.updateExhibitCancelledOnCongress(exList, exhibitIds, setCongressIds);
    }
    /*for(Exhibit__c records : trigger.new)
    {
       if(records.CurrencyIsoCode != Trigger.oldMap.get(records.Id).CurrencyIsoCode)
       {
           exhibitCurrencyIds.add(records.Id);
           exhibitCurrencyMap.put(records.Id,records);
       }
    }
    
    if(exhibitCurrencyIds.size() > 0) {
        ExhibitTriggerHandler.updateBrandCurrency(exhibitCurrencyIds, exhibitCurrencyMap);
    }*/
    
}