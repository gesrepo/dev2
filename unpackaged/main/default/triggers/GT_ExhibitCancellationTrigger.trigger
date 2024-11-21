trigger GT_ExhibitCancellationTrigger on GT_Exhibit__c (after update, before delete) {
    system.debug('inside trigger');
    Set<Id> exhibitIds = new Set<Id>();
    List<GT_Exhibit__c> exhibitList = new List<GT_Exhibit__c>();
    Map<Id,List<GT_Brand__c>> exhibitBrandMap = new Map<Id,List<GT_Brand__c>>();
    List<GT_Brand__c> tobeUpdatedBrands = new List<GT_Brand__c>();
    List<GT_Brand__c> brandsTobeDeleted = new List<GT_Brand__c>();
    
    
    if (Trigger.isUpdate) {
        system.debug('Inside Updatee-----------------------');
        for(GT_Exhibit__c exhibit: trigger.new){
            if( Trigger.isUpdate && exhibit.Canceled__c != Trigger.oldMap.get(exhibit.Id).Canceled__c || Trigger.isUpdate && exhibit.Cancellation_Date__c != Trigger.oldMap.get(exhibit.Id).Cancellation_Date__c || Trigger.isUpdate && exhibit.Reason_for_Cancellation__c != Trigger.oldMap.get(exhibit.Id).Reason_for_Cancellation__c){
                exhibitIds.add(exhibit.Id);
                exhibitList.add(exhibit);
            }
        }
        if(exhibitIds.size() > 0) {
            system.debug('inside if------------------------------------------');
            for(GT_Brand__c brand : [SELECT Id,Canceled__c,Cancelled_Date__c,Reason_for_Cancellation__c,Exhibit__c FROM GT_Brand__c WHERE Exhibit__c IN :exhibitIds])
            {
                if(!exhibitBrandMap.containskey(brand.Exhibit__c))
                {
                    exhibitBrandMap.put(brand.Exhibit__c,new List<GT_Brand__c>());
                }
                exhibitBrandMap.get(brand.Exhibit__c).add(brand);
            }         
            
            for(GT_Exhibit__c exhibit : exhibitList)
            {
                if(exhibitBrandMap.get(exhibit.Id) != null)
                {
                    for(GT_Brand__c brand : exhibitBrandMap.get(exhibit.Id))
                    {
                        system.debug('exhibit.Canceled__c------------>'+exhibit.Canceled__c);
                        if(exhibit.Canceled__c == true){
                            system.debug('brand.Canceled__c-------------->'+brand.Canceled__c);
                            if(brand.Canceled__c == false){
                                brand.Canceled__c =  exhibit.Canceled__c;
                                brand.Cancelled_Date__c = exhibit.Cancellation_Date__c;
                                brand.Reason_for_Cancellation__c = exhibit.Reason_for_Cancellation__c;
                                tobeUpdatedBrands.add(brand);
                            }
                        }
                        else{
                            brand.Canceled__c =  exhibit.Canceled__c;
                            brand.Cancelled_Date__c = exhibit.Cancellation_Date__c;
                            brand.Reason_for_Cancellation__c = exhibit.Reason_for_Cancellation__c;
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
        system.debug('Inside delete');
        for(GT_Exhibit__c exhibit: trigger.old){
            exhibitIds.add(exhibit.Id);
            system.debug('----------------'+exhibitIds);
        }
        
        if(exhibitIds.size() > 0) {
            system.debug('----------------Inside exhibitIds > 0 ');
            for(GT_Brand__c brand : [SELECT Id,Exhibit__c FROM GT_Brand__c WHERE Exhibit__c IN :exhibitIds])
            {
                system.debug('brand----------------' + brand);
                if(exhibitIds.contains(brand.Exhibit__c)){
                    brandsTobeDeleted.add(brand);
                }
            }
            system.debug(brandsTobeDeleted);
        }
        system.debug(brandsTobeDeleted);
        if(brandsTobeDeleted.size() > 0){
            delete brandsTobeDeleted;
        }
    }
}