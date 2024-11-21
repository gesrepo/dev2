trigger CongressTrigger on GES_Connect_Corporate_Accounts__c (after update, after insert) {
    CongressTriggerHandler dummyHandlerObject = new CongressTriggerHandler();
    List<String>updatedCurrencyIsoCodeIds= new List<String>();
    List<String>updatedCancelledFieldrecordIds= new List<String>();
    
    for(GES_Connect_Corporate_Accounts__c varGCCA: trigger.new){
        if( Trigger.isUpdate && varGCCA.CurrencyIsoCode!= Trigger.oldMap.get(varGCCA.Id).CurrencyIsoCode){
     
           updatedCurrencyIsoCodeIds.add(String.valueOf(varGCCA.Id));
              
        }
    }
    dummyHandlerObject.updateActivitiesAndBrands(updatedCurrencyIsoCodeIds);
    
    if (Trigger.isUpdate) {
        for(GES_Connect_Corporate_Accounts__c corAcc: trigger.new){
            if( Trigger.isUpdate && corAcc.Congress_Cancelled__c != Trigger.oldMap.get(corAcc.Id).Congress_Cancelled__c || Trigger.isUpdate && corAcc.Congress_Cancellation_Date__c != Trigger.oldMap.get(corAcc.Id).Congress_Cancellation_Date__c || Trigger.isUpdate && corAcc.Reason_for_Cancellation__c != Trigger.oldMap.get(corAcc.Id).Reason_for_Cancellation__c){
                updatedCancelledFieldrecordIds.add(String.valueOf(corAcc.Id));
            }	
        }
        dummyHandlerObject.updateCancelledFieldsActivitiesAndProducts(updatedCancelledFieldrecordIds);
    }
}