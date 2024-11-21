trigger ProductTheaterTrigger on Product_Theater__c (after update) 
{
    Set<Id> prodThIds = new set<Id>();
    Set<Id> productTheaterCurrencyIds = new set<Id>();
    Map<Id,List<Brand__c>> ptBrandMap = new Map<Id,List<Brand__c>>();
    Map<Id,Product_Theater__c> productTheaterCurrencyMap = new Map<Id,Product_Theater__c>();
    List<Brand__c> tobeUpdatedBrands = new List<Brand__c>();
    List<Product_Theater__c> ptList = new List<Product_Theater__c>();
    
    for(Product_Theater__c records : trigger.new)
    {
        if(records.Canceled__c != Trigger.oldMap.get(records.Id).Canceled__c || records.Canceled_Date__c != Trigger.oldMap.get(records.Id).Canceled_Date__c || records.Cancel_Reason__c != Trigger.oldMap.get(records.Id).Cancel_Reason__c)
        {
            prodThIds.add(records.Id);
            ptList.add(records);
        }
    }
    
	for(Brand__c bran : [SELECT Id,Canceled__c,Cancelled_Date__c,Reason_for_Cancellation__c,Product_Theater__c FROM Brand__c WHERE Product_Theater__c IN :prodThIds])
    {
        if(!ptBrandMap.containskey(bran.Product_Theater__c))
        {
            ptBrandMap.put(bran.Product_Theater__c,new List<Brand__c>());
        }
        ptBrandMap.get(bran.Product_Theater__c).add(bran);
    }         
    
    for(Product_Theater__c ex : ptList)
    {
        if(ptBrandMap.get(ex.Id) != null)
        {
            for(Brand__c b : ptBrandMap.get(ex.Id))
            {
                if(ex.Canceled__c == true){
                        if(b.Canceled__c == false){	
                            b.Canceled__c =  ex.Canceled__c;
                            b.Cancelled_Date__c = ex.Canceled_Date__c;
                            b.Reason_for_Cancellation__c = ex.Cancel_Reason__c;
                            tobeUpdatedBrands.add(b);
                        }
                    }
                    else{
                        b.Canceled__c =  ex.Canceled__c;
                        b.Cancelled_Date__c = ex.Canceled_Date__c;
                        b.Reason_for_Cancellation__c = ex.Cancel_Reason__c;
                        tobeUpdatedBrands.add(b);
                    }
            }
        }
    }
    
    if(tobeUpdatedBrands.size() > 0)
    {
        update tobeUpdatedBrands;
    }
    
    /*for(Product_Theater__c records : trigger.new)
    {
       if(records.CurrencyIsoCode != Trigger.oldMap.get(records.Id).CurrencyIsoCode)
       {
           productTheaterCurrencyIds.add(records.Id);
           productTheaterCurrencyMap.put(records.Id,records);
       }
    }
    
    if(productTheaterCurrencyIds.size() > 0) {
        ProductTheaterTriggerHandler.updateBrandCurrency(productTheaterCurrencyIds, productTheaterCurrencyMap);
    }*/

}