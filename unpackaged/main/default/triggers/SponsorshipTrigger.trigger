trigger SponsorshipTrigger on Sponsorship__c (after update) 
{
    Set<Id> sponIds = new set<Id>();
    Set<Id> sponsorshipCurrencyIds = new set<Id>();
    Map<Id,List<Brand__c>> sponBrandMap = new Map<Id,List<Brand__c>>();
    Map<Id,Sponsorship__c> sponsorshipCurrencyMap = new Map<Id,Sponsorship__c>();
    List<Brand__c> tobeUpdatedBrands = new List<Brand__c>();
    List<Sponsorship__c> spList = new List<Sponsorship__c>();
    
    for(Sponsorship__c records : trigger.new)
    {
       if(records.Canceled__c != Trigger.oldMap.get(records.Id).Canceled__c || records.CanceledDate__c != Trigger.oldMap.get(records.Id).CanceledDate__c || records.CancelReason__c != Trigger.oldMap.get(records.Id).CancelReason__c)
       {
           sponIds.add(records.Id);
           spList.add(records);
       }
    }
    
    for(Brand__c bran : [SELECT Id,Canceled__c,Cancelled_Date__c,Reason_for_Cancellation__c,Sponsorship__c FROM Brand__c WHERE Sponsorship__c IN :sponIds])
    {
        if(!sponBrandMap.containskey(bran.Sponsorship__c))
        {
            sponBrandMap.put(bran.Sponsorship__c,new List<Brand__c>());
        }
        sponBrandMap.get(bran.Sponsorship__c).add(bran);
    }         
    
    for(Sponsorship__c ex : spList)
    {
        if(sponBrandMap.get(ex.Id) != null)
        {
            for(Brand__c b : sponBrandMap.get(ex.Id))
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
    
    /*for(Sponsorship__c records : trigger.new)
    {
       if(records.CurrencyIsoCode != Trigger.oldMap.get(records.Id).CurrencyIsoCode)
       {
           sponsorshipCurrencyIds.add(records.Id);
           sponsorshipCurrencyMap.put(records.Id,records);
       }
    }
    
    if(sponsorshipCurrencyIds.size() > 0) {
        SponsorshipTriggerHandler.updateBrandCurrency(sponsorshipCurrencyIds, sponsorshipCurrencyMap);
    }*/

}