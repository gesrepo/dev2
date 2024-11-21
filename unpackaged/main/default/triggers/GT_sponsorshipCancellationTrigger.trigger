trigger GT_sponsorshipCancellationTrigger on GT_Sponsorship__c (after update, before delete) {
    Set<Id> sponsorshipIds = new Set<Id>();
    List<GT_Sponsorship__c> sponsorshipList = new List<GT_Sponsorship__c>();
    Map<Id,List<GT_Brand__c>> sponsorshipBrandMap = new Map<Id,List<GT_Brand__c>>();
    List<GT_Brand__c> tobeUpdatedBrands = new List<GT_Brand__c>();
    List<GT_Brand__c> brandsTobeDeleted = new List<GT_Brand__c>();
    
    if (Trigger.isUpdate) {
        for(GT_Sponsorship__c sponsorship: trigger.new){
            if( Trigger.isUpdate && sponsorship.Canceled__c != Trigger.oldMap.get(sponsorship.Id).Canceled__c || Trigger.isUpdate && sponsorship.Cancellation_Date__c != Trigger.oldMap.get(sponsorship.Id).Cancellation_Date__c || Trigger.isUpdate && sponsorship.Reason_for_Cancellation__c != Trigger.oldMap.get(sponsorship.Id).Reason_for_Cancellation__c){
                sponsorshipIds.add(sponsorship.Id);
                sponsorshipList.add(sponsorship);
            }
        }
        if(sponsorshipIds.size() > 0) {

            for(GT_Brand__c brand : [SELECT Id,Canceled__c,Cancelled_Date__c,Reason_for_Cancellation__c,sponsorship__c FROM GT_Brand__c WHERE sponsorship__c IN :sponsorshipIds])
            {
                if(!sponsorshipBrandMap.containskey(brand.sponsorship__c))
                {
                    sponsorshipBrandMap.put(brand.sponsorship__c,new List<GT_Brand__c>());
                }
                sponsorshipBrandMap.get(brand.sponsorship__c).add(brand);
            }         
            
            for(GT_Sponsorship__c sponsorship : sponsorshipList)
            {
                if(sponsorshipBrandMap.get(sponsorship.Id) != null)
                {
                    for(GT_Brand__c brand : sponsorshipBrandMap.get(sponsorship.Id))
                    {
                        if(sponsorship.Canceled__c == true){
                            if(brand.Canceled__c == false){
                                brand.Canceled__c =  sponsorship.Canceled__c;
                                brand.Cancelled_Date__c = sponsorship.Cancellation_Date__c;
                                brand.Reason_for_Cancellation__c = sponsorship.Reason_for_Cancellation__c;
                                tobeUpdatedBrands.add(brand);
                            }
                        }
                        else{
                            brand.Canceled__c =  sponsorship.Canceled__c;
                            brand.Cancelled_Date__c = sponsorship.Cancellation_Date__c;
                            brand.Reason_for_Cancellation__c = sponsorship.Reason_for_Cancellation__c;
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
        for(GT_Sponsorship__c Sponsorship: trigger.old){
            sponsorshipIds.add(Sponsorship.Id);
        }
        
        if(sponsorshipIds.size() > 0) {
            for(GT_Brand__c brand : [SELECT Id,Sponsorship__c FROM GT_Brand__c WHERE Sponsorship__c IN :sponsorshipIds])
            {
                if(sponsorshipIds.contains(brand.Sponsorship__c)){
                    brandsTobeDeleted.add(brand);
                }
            }
        }
        if(brandsTobeDeleted.size() > 0){
            delete brandsTobeDeleted;
        }
    }
}