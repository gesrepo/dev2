trigger GT_RegistrationAttendOnlyCancellationTrigger on GT_Reg_Attend_Only__c (after update, before delete) {
    Set<Id> reg_Attend_OnlyIds = new Set<Id>();
    List<GT_Reg_Attend_Only__c> reg_Attend_OnlyList = new List<GT_Reg_Attend_Only__c>();
    Map<Id,List<GT_Brand__c>> reg_Attend_OnlyBrandMap = new Map<Id,List<GT_Brand__c>>();
    List<GT_Brand__c> tobeUpdatedBrands = new List<GT_Brand__c>();
    List<GT_Brand__c> brandsTobeDeleted = new List<GT_Brand__c>();
    
    if (Trigger.isUpdate) {
        for(GT_Reg_Attend_Only__c reg_Attend_Only: trigger.new){
            if( Trigger.isUpdate && reg_Attend_Only.Canceled__c != Trigger.oldMap.get(reg_Attend_Only.Id).Canceled__c || Trigger.isUpdate && reg_Attend_Only.Cancellation_Date__c != Trigger.oldMap.get(reg_Attend_Only.Id).Cancellation_Date__c || Trigger.isUpdate && reg_Attend_Only.Reason_for_Cancellation__c != Trigger.oldMap.get(reg_Attend_Only.Id).Reason_for_Cancellation__c){
                reg_Attend_OnlyIds.add(reg_Attend_Only.Id);
                reg_Attend_OnlyList.add(reg_Attend_Only);
            }
        }
        if(reg_Attend_OnlyIds.size() > 0) {

            for(GT_Brand__c brand : [SELECT Id,Canceled__c,Cancelled_Date__c,Reason_for_Cancellation__c,Registration_Attend_Only__c FROM GT_Brand__c WHERE Registration_Attend_Only__c IN :reg_Attend_OnlyIds])
            {
                if(!reg_Attend_OnlyBrandMap.containskey(brand.Registration_Attend_Only__c))
                {
                    reg_Attend_OnlyBrandMap.put(brand.Registration_Attend_Only__c,new List<GT_Brand__c>());
                }
                reg_Attend_OnlyBrandMap.get(brand.Registration_Attend_Only__c).add(brand);
            }         
            
            for(GT_Reg_Attend_Only__c reg_Attend_Only : reg_Attend_OnlyList)
            {
                if(reg_Attend_OnlyBrandMap.get(reg_Attend_Only.Id) != null)
                {
                    for(GT_Brand__c brand : reg_Attend_OnlyBrandMap.get(reg_Attend_Only.Id))
                    {
                        if(reg_Attend_Only.Canceled__c == true){
                            if(brand.Canceled__c == false){
                                brand.Canceled__c =  reg_Attend_Only.Canceled__c;
                                brand.Cancelled_Date__c = reg_Attend_Only.Cancellation_Date__c;
                                brand.Reason_for_Cancellation__c = reg_Attend_Only.Reason_for_Cancellation__c;
                                tobeUpdatedBrands.add(brand);
                            }
                        }
                        else{
                            brand.Canceled__c =  reg_Attend_Only.Canceled__c;
                            brand.Cancelled_Date__c = reg_Attend_Only.Cancellation_Date__c;
                            brand.Reason_for_Cancellation__c = reg_Attend_Only.Reason_for_Cancellation__c;
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
        for(GT_Reg_Attend_Only__c reg_Attend_Only: trigger.old){
            reg_Attend_OnlyIds.add(reg_Attend_Only.Id);
        }
        
        if(reg_Attend_OnlyIds.size() > 0) {
            for(GT_Brand__c brand : [SELECT Id,Registration_Attend_Only__c FROM GT_Brand__c WHERE Registration_Attend_Only__c IN :reg_Attend_OnlyIds])
            {
                if(reg_Attend_OnlyIds.contains(brand.Registration_Attend_Only__c)){
                    brandsTobeDeleted.add(brand);
                }
            }
        }
        if(brandsTobeDeleted.size() > 0){
            delete brandsTobeDeleted;
        }
    }
}