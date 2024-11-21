trigger TMSFullShippingOrderTrigger on TMS_Full_Shipping_Order_Stg__c (after update) {

    if(UserInfo.getName() != Label.TMSIntegrationUser){
        return;
    }
    
    Set<Id> qIds = new Set<Id>();
    Set<Id> fiIds = new Set<Id>();
    
    if(trigger.isAfter && trigger.isUpdate){
        
        TMSFullShippingOrderTriggerHandler.updateQuoteANDFreightItems(trigger.new);


    }
    
}