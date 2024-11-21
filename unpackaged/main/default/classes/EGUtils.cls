//AUTHOR : FARHAN KARIM - BLUEWOLF

public class EGUtils
{
    public static Opportunity_Products_Public__c getOppProductPublic (Opportunity_Products_Public__c oppProductPublic, OpportunityLineItem lineItem, PriceBookEntry priceBookEntry)
    {
        oppProductPublic.Line_Description__c = lineItem.Description;
        oppProductPublic.List_Price__c = lineItem.ListPrice;
        oppProductPublic.Quantity__c = lineItem.Quantity;
        oppProductPublic.Sales_Price__c = lineItem.UnitPrice;
        oppProductPublic.Total_Price__c = lineItem.TotalPrice;
        
        if(priceBookEntry != null && priceBookEntry.Product2Id != null)
            oppProductPublic.Product__c = priceBookEntry.Product2Id;
            
        return oppProductPublic;
    } 
    
    public static Integer getNoOfRowsThatCanBeRetrieved()
    {
        Integer rows = Limits.getLimitQueryRows() - Limits.getQueryRows();
        
        if(rows < 0)
            rows = 0;
        
        return rows;    
    }
}