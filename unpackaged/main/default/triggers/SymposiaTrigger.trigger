trigger SymposiaTrigger on Symposia__c (after update) 
{
    Set<Id> sympoIds = new set<Id>();
    Set<Id> symposiaCurrencyIds = new set<Id>();
    Map<Id,List<Brand__c>> sympoBrandMap = new Map<Id,List<Brand__c>>();
    Map<Id,Symposia__c> symposiaCurrencyMap = new Map<Id,Symposia__c>();
    List<Brand__c> tobeUpdatedBrands = new List<Brand__c>();
    List<Symposia__c> symList = new List<Symposia__c>();
    
    for(Symposia__c records : trigger.new)
    {
       if(records.Canceled__c != Trigger.oldMap.get(records.Id).Canceled__c || records.CanceledDate__c != Trigger.oldMap.get(records.Id).CanceledDate__c || records.CancelReason__c != Trigger.oldMap.get(records.Id).CancelReason__c)
       {
           sympoIds.add(records.Id);
           symList.add(records);
       }
    }
    
    for(Brand__c bran : [SELECT Id,Canceled__c,Cancelled_Date__c,Reason_for_Cancellation__c,Symposia__c FROM Brand__c WHERE Symposia__c IN :sympoIds])
    {
        if(!sympoBrandMap.containskey(bran.Symposia__c))
        {
            sympoBrandMap.put(bran.Symposia__c,new List<Brand__c>());
        }
        sympoBrandMap.get(bran.Symposia__c).add(bran);
    }         
    
    for(Symposia__c ex : symList)
    {
        if(sympoBrandMap.get(ex.Id) != null)
        {
            for(Brand__c b : sympoBrandMap.get(ex.Id))
            {
                if(ex.Canceled__c == true){
                        if(b.Canceled__c == false){	
                            b.Canceled__c =  ex.Canceled__c;
                            b.Cancelled_Date__c = ex.CanceledDate__c;
                            b.Reason_for_Cancellation__c = ex.CancelReason__c;
                            tobeUpdatedBrands.add(b);
                        }
                    }
                    else{
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
    
    /*for(Symposia__c records : trigger.new)
    {
       if(records.CurrencyIsoCode != Trigger.oldMap.get(records.Id).CurrencyIsoCode)
       {
           symposiaCurrencyIds.add(records.Id);
           symposiaCurrencyMap.put(records.Id,records);
       }
    }
    
    if(symposiaCurrencyIds.size() > 0) {
        SymposiaTriggerHandler.updateBrandCurrency(symposiaCurrencyIds, symposiaCurrencyMap);
    }*/

}