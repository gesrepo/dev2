trigger GT_MembershipCancellationTrigger on GT_Membership__c (after update, before delete) {
    Set<Id> membershipIds = new Set<Id>();
    List<GT_Membership__c> membershipList = new List<GT_Membership__c>();
    Map<Id,List<GT_Brand__c>> membershipBrandMap = new Map<Id,List<GT_Brand__c>>();
    List<GT_Brand__c> tobeUpdatedBrands = new List<GT_Brand__c>();
    List<GT_Brand__c> brandsTobeDeleted = new List<GT_Brand__c>();
    
    if (Trigger.isUpdate) {
        for(GT_Membership__c membership: trigger.new){
            if( Trigger.isUpdate && membership.Canceled__c != Trigger.oldMap.get(membership.Id).Canceled__c || Trigger.isUpdate && membership.Cancellation_Date__c != Trigger.oldMap.get(membership.Id).Cancellation_Date__c || Trigger.isUpdate && membership.Reason_for_Cancellation__c != Trigger.oldMap.get(membership.Id).Reason_for_Cancellation__c){
                membershipIds.add(membership.Id);
                membershipList.add(membership);
            }
        }
        if(membershipIds.size() > 0) {

            for(GT_Brand__c brand : [SELECT Id,Canceled__c,Cancelled_Date__c,Reason_for_Cancellation__c,Membership__c FROM GT_Brand__c WHERE Membership__c IN :membershipIds])
            {
                if(!membershipBrandMap.containskey(brand.Membership__c))
                {
                    membershipBrandMap.put(brand.Membership__c,new List<GT_Brand__c>());
                }
                membershipBrandMap.get(brand.Membership__c).add(brand);
            }         
            
            for(GT_Membership__c membership : membershipList)
            {
                if(membershipBrandMap.get(membership.Id) != null)
                {
                    for(GT_Brand__c brand : membershipBrandMap.get(membership.Id))
                    {
                        if(membership.Canceled__c == true){
                            if(brand.Canceled__c == false){
                                brand.Canceled__c =  membership.Canceled__c;
                                brand.Cancelled_Date__c = membership.Cancellation_Date__c;
                                brand.Reason_for_Cancellation__c = membership.Reason_for_Cancellation__c;
                                tobeUpdatedBrands.add(brand);
                            }
                        }
                        else{
                            brand.Canceled__c =  membership.Canceled__c;
                            brand.Cancelled_Date__c = membership.Cancellation_Date__c;
                            brand.Reason_for_Cancellation__c = membership.Reason_for_Cancellation__c;
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
        for(GT_Membership__c membership: trigger.old){
            membershipIds.add(membership.Id);
        }
        
        if(membershipIds.size() > 0) {
            for(GT_Brand__c brand : [SELECT Id,Membership__c FROM GT_Brand__c WHERE Membership__c IN :membershipIds])
            {
                if(membershipIds.contains(brand.Membership__c)){
                    brandsTobeDeleted.add(brand);
                }
            }
        }
        if(brandsTobeDeleted.size() > 0){
            delete brandsTobeDeleted;
        }
    }
}