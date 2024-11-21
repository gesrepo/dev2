public class LC_SelectRates {

    @AuraEnabled
    public static Quote__c fetchQuote(String recordId){
        Quote__c quote = [Select Class_of_Service__c, Crated_Weight__c, Custom_Quote__c, Delivery_Date__c, Destination_State__c, Dim_Weight__c, Flat_Rate_Unit_Price_Type__c, Id, 
                          Message__c, OB_Class_of_Service__c, OB_Custom_Quote__c, OB_Delivery_Date__c, OB_Destination_State__c, OB_Flat_Rate_Unit_Price_Type__c, OB_Origination_State__c, 
                          OB_Pickup_Date__c, OB_Pickup_Window_Start__c, OB_Selection__c, OB_Service_Type__c, OB_Shipment_Type__c, Order_Date__c, Origination_State__c, Pickup_Date__c, 
                          Pickup_Window_Start__c, Quote_Subject__c, Selection__c, Service_Type__c, Shipment_Type__c, Weight_Override__c From Quote__c Where Id =: recordId limit 1];
	System.debug('quote********* '+quote);
        return quote;
    }
    
    @AuraEnabled
    public static String getQuoteRates(String quoteId, String direction){
        return LogisticsQuoteRates.GetRatesLightning(quoteId, direction);
    }
    
    @AuraEnabled
    public static String updateInboundOutboundQuote(id quoteId, string selection, string rates, string unitPrice){
        return LogisticsQuoteRates.UpdateQuote(quoteId, selection, rates, unitPrice);
    }
    
    @AuraEnabled
    public static String priceCustomQuote(String quoteId, String direction){
        return LogisticsQuoteRates.PriceCustomQuote(quoteId, direction);
    }
    
}