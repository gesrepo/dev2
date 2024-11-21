trigger TrgAfterInsertUpdateFreightItem on Freight_Item__c (after delete, after insert, after undelete, 
after update) {
    
    // SFDC-244 : TMS Integration - trigger bypass for TMSIntegrationUser - by Sajid - 09/27/23
    if(UserInfo.getName() == Label.TMSIntegrationUser){
        
        return;
    }
    //end
        
        Set<Id> SoQuoteId = new Set<Id>();       
        
        if (!Trigger.isDelete)
        {
            for(Freight_Item__c ql : Trigger.New)
            {
                SoQuoteId.add(ql.Quote__c);
            }
        }
        else
        {
            for(Freight_Item__c ql : Trigger.Old)
            {
                SoQuoteId.add(ql.Quote__c);
            }
        }
        
        List<Freight_Item__c> FreightItems = [Select Id, Crated_Weight__c, Length__c, Width__c, Height__c, Quantity__c, Quote__c From Freight_Item__c Where Void__c = false And Quote__c In :SoQuoteId Order By Quote__c];
        
        map<Id, list<Freight_Item__c>> MoQuoteToLoFrieghtItem = new map<Id, list<Freight_Item__c>>();
        
        for(Id quoteId : SoQuoteId)
        {
            list<Freight_Item__c> LoQuoteFreightItems = new list<Freight_Item__c>();
            
            for(Freight_Item__c fi : FreightItems)
            {
                if (fi.Quote__c == quoteId)
                {
                    LoQuoteFreightItems.add(fi);
                }
            }
            
            MoQuoteToLoFrieghtItem.put(quoteId, LoQuoteFreightItems);
        }
        
        List<Quote__c> LoQuotes = [Select Id, Crated_Weight__c, Dim_Weight__c From Quote__c Where Id In :SoQuoteId];
        
        for(Quote__c quote : LoQuotes)
        {
            Id quoteId = quote.Id;
            
            try
            {
                //If Lines are not entered, then Crated and Dim weight will be 0
                decimal TotalCratedWeight = 0;
                decimal TotalDimWeight = 0;
                Integer DimFactor = Integer.valueOf(System.Label.Dim_Factor);
                                    
                if (MoQuoteToLoFrieghtItem.get(quoteId).size() > 0)
                {
            
                    for(Freight_Item__c fi : MoQuoteToLoFrieghtItem.get(quoteId))
                    {
                        if (fi.Quantity__c == null || fi.Quantity__c == 0)
                            fi.Quantity__c = 1;
                            
                        if (fi.Crated_Weight__c != null)
                            TotalCratedWeight += fi.Quantity__c * fi.Crated_Weight__c;
                            
                        if (fi.Length__c != null && fi.Length__c > 0 &&
                            fi.Width__c != null && fi.Width__c > 0 &&
                            fi.Height__c != null && fi.Height__c > 0)
                            {
                                //TotalDimWeight +=  fi.Quantity__c * (fi.Length__c * fi.Width__c * fi.Height__c)/194;  Amarab 3/18/2022 to change dim factor from 194 to 166
                                TotalDimWeight +=  fi.Quantity__c * (fi.Length__c * fi.Width__c * fi.Height__c)/DimFactor ;
                            }
                    }
                }
                
                quote.Crated_Weight__c = TotalCratedWeight;
                quote.Dim_Weight__c = TotalDimWeight;

            }
            finally
            {
                FreightItems = null;
            }
        }
        
        Database.update(LoQuotes, false);
    
    // SFDC-244 - start : TMS Integration - Populating Quote and Freight Item into a Staging Table - by Sajid - 08/04/23
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
        if(SoQuoteId != null){
            FreightItemHandler fiHandler = new FreightItemHandler();
            fiHandler.updateTMSShippingOrderStg(Trigger.New, SoQuoteId);
        }
    }
    // SFDC-244 - end
        
}