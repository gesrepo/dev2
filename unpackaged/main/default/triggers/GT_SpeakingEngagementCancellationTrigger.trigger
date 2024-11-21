trigger GT_SpeakingEngagementCancellationTrigger on GT_Speaking_Engagement__c (after update, before delete) {
    Set<Id> speakingEngagementIds = new Set<Id>();
    List<GT_Speaking_Engagement__c> speakingEngagementList = new List<GT_Speaking_Engagement__c>();
    Map<Id,List<GT_Brand__c>> speakingEngagementBrandMap = new Map<Id,List<GT_Brand__c>>();
    List<GT_Brand__c> tobeUpdatedBrands = new List<GT_Brand__c>();
    List<GT_Brand__c> brandsTobeDeleted = new List<GT_Brand__c>();
    
    if (Trigger.isUpdate) {
        for(GT_Speaking_Engagement__c speakingEngagement: trigger.new){
            if( Trigger.isUpdate && speakingEngagement.Canceled__c != Trigger.oldMap.get(speakingEngagement.Id).Canceled__c || Trigger.isUpdate && speakingEngagement.Cancellation_Date__c != Trigger.oldMap.get(speakingEngagement.Id).Cancellation_Date__c || Trigger.isUpdate && speakingEngagement.Reason_for_Cancellation__c != Trigger.oldMap.get(speakingEngagement.Id).Reason_for_Cancellation__c){
                speakingEngagementIds.add(speakingEngagement.Id);
                speakingEngagementList.add(speakingEngagement);
            }
        }
        if(speakingEngagementIds.size() > 0) {

            for(GT_Brand__c brand : [SELECT Id,Canceled__c,Cancelled_Date__c,Reason_for_Cancellation__c,Speaking_Engagement__c FROM GT_Brand__c WHERE Speaking_Engagement__c IN :speakingEngagementIds])
            {
                if(!speakingEngagementBrandMap.containskey(brand.Speaking_Engagement__c))
                {
                    speakingEngagementBrandMap.put(brand.Speaking_Engagement__c,new List<GT_Brand__c>());
                }
                speakingEngagementBrandMap.get(brand.Speaking_Engagement__c).add(brand);
            }         
            
            for(GT_Speaking_Engagement__c speakingEngagement : speakingEngagementList)
            {
                if(speakingEngagementBrandMap.get(speakingEngagement.Id) != null)
                {
                    for(GT_Brand__c brand : speakingEngagementBrandMap.get(speakingEngagement.Id))
                    {
                        if(speakingEngagement.Canceled__c == true){
                            if(brand.Canceled__c == false){
                                brand.Canceled__c =  speakingEngagement.Canceled__c;
                                brand.Cancelled_Date__c = speakingEngagement.Cancellation_Date__c;
                                brand.Reason_for_Cancellation__c = speakingEngagement.Reason_for_Cancellation__c;
                                tobeUpdatedBrands.add(brand);
                            }
                        }
                        else{
                            brand.Canceled__c =  speakingEngagement.Canceled__c;
                            brand.Cancelled_Date__c = speakingEngagement.Cancellation_Date__c;
                            brand.Reason_for_Cancellation__c = speakingEngagement.Reason_for_Cancellation__c;
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
        for(GT_Speaking_Engagement__c speakingEngagement: trigger.old){
            speakingEngagementIds.add(speakingEngagement.Id);
        }
        
        if(speakingEngagementIds.size() > 0) {
            for(GT_Brand__c brand : [SELECT Id,Speaking_Engagement__c FROM GT_Brand__c WHERE Speaking_Engagement__c IN :speakingEngagementIds])
            {
                if(speakingEngagementIds.contains(brand.Speaking_Engagement__c)){
                    brandsTobeDeleted.add(brand);
                }
            }
        }
        if(brandsTobeDeleted.size() > 0){
            delete brandsTobeDeleted;
        }
    }
}