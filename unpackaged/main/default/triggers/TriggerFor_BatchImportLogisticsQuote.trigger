/***************************************
Trigger : TriggerFor_BatchImportLogisticsQuote 
Descritption : this is added to execute logic witten in batch class BatchImportLogisticsQuote, which updates custom Quote
                based on the quote staging records.
created : 14th march 2019 by Gaurav Kumar            
***************************************/
trigger TriggerFor_BatchImportLogisticsQuote on Quote_Staging__c (After update,After insert) {

    If(Trigger.isAfter)
    {
        If(trigger.isInsert)
        {
            QuoteStagingTriggerHelper obj= new QuoteStagingTriggerHelper();
            obj.executeBatchLogic(trigger.new);
        }
        If(trigger.isUpdate)
        {
            QuoteStagingTriggerHelper obj= new QuoteStagingTriggerHelper();
            obj.executeBatchLogic(trigger.new);        
        }    
    }

}