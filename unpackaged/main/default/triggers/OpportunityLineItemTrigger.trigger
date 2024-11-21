trigger OpportunityLineItemTrigger on OpportunityLineItem (after insert, after update, after delete, after undelete) 
{
    Set<Id> opportunityIds = new Set<Id>();
    Set<Id> priceBookEntryIds = new Set<Id>();
    Set<Id> oppLineItemIds = new Set<Id>();

    Map<Id, Id> opportunityIdToShowOccurrenceIdMap = new Map<Id, Id>();
    Map<Id, PriceBookEntry> priceBookEntries = new Map<Id, PriceBookEntry>();
    
    List<Opportunity_Products_Public__c> oppProductsPublicToInsert = new List<Opportunity_Products_Public__c>();
    List<Opportunity_Products_Public__c> oppProductsPublicToUpdate = new List<Opportunity_Products_Public__c>();
    List<Opportunity_Products_Public__c> oppProductsPublicToDelete = new List<Opportunity_Products_Public__c>();
    
    List<OpportunityLineItem> oppLineItemsToWorkWith = new List<OpportunityLineItem>();
    
    if(Trigger.isDelete)
        oppLineItemsToWorkWith = Trigger.old;
    else
        oppLineItemsToWorkWith = Trigger.new;
            
    for(OpportunityLineItem lineItem : oppLineItemsToWorkWith)
    {
        if(lineItem.Id != null)
            oppLineItemIds.add(lineItem.Id);
        if(lineItem.OpportunityId != null)
            opportunityIds.add(lineItem.OpportunityId);
        if(lineItem.PriceBookEntryId != null)
            priceBookEntryIds.add(lineItem.PriceBookEntryId);
    }

    if(Trigger.isAfter && (Trigger.isUpdate || Trigger.isInsert || Trigger.isUndelete))
    {
        if(!priceBookEntryIds.isEmpty())
            priceBookEntries = new Map<Id, PriceBookEntry>([SELECT Id, Product2Id, Product2.Name FROM PriceBookEntry WHERE ID IN: priceBookEntryIds LIMIT :EGUtils.getNoOfRowsThatCanBeRetrieved()]);    
    }
    
    /************************************* AFTER INSERT & UNDELETE *****************************************************/
    
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUndelete) && !opportunityIds.isEmpty())
    {        
        for (Show_Occurrence_Public__c showOccurrence : [SELECT Id, Show_Occurrence_Ref__c FROM Show_Occurrence_Public__c WHERE Show_Occurrence_Ref__c IN : opportunityIds AND Show_Occurrence_Ref__c != NULL LIMIT :EGUtils.getNoOfRowsThatCanBeRetrieved()])
            opportunityIdToShowOccurrenceIdMap.put(showOccurrence.Show_Occurrence_Ref__c, showOccurrence.Id); 
        
        if(!opportunityIdToShowOccurrenceIdMap.isEmpty())
        {
            for(OpportunityLineItem lineItem : Trigger.new)
            {
                if(lineItem.OpportunityId != null)
                {
                    Id showOccurrenceId = opportunityIdToShowOccurrenceIdMap.get(lineItem.OpportunityId);
                    
                    if(showOccurrenceId != null)
                    {
                        Opportunity_Products_Public__c productPublic = EGUtils.getOppProductPublic(new Opportunity_Products_Public__c(), lineItem, priceBookEntries.get(lineItem.PriceBookEntryId));
                        productPublic.Show_Occurrence_Public__c = showOccurrenceId;
                        productPublic.Opportunity_Line_Item_Id__c = lineItem.Id;
                        
                        if(lineItem.PriceBookEntryId != null && priceBookEntries.get(lineItem.PriceBookEntryId) != null)
                            productPublic.Name = priceBookEntries.get(lineItem.PriceBookEntryId).Product2.Name;
                            
                        oppProductsPublicToInsert.add(productPublic);
                    }
                }    
            } 
        }
        insert oppProductsPublicToInsert;   
    }

    /************************************* AFTER UPDATE *****************************************************/
    
    if(Trigger.isAfter && Trigger.isUpdate)  
    {
        for(Opportunity_Products_Public__c productPublic : [SELECT Id, Opportunity_Line_Item_Id__c FROM Opportunity_Products_Public__c WHERE Opportunity_Line_Item_Id__c IN: oppLineItemIds AND Opportunity_Line_Item_Id__c != NULL LIMIT :EGUtils.getNoOfRowsThatCanBeRetrieved()])
        {
            OpportunityLineItem lineItem = Trigger.newMap.get(productPublic.Opportunity_Line_Item_Id__c);
            productPublic = EGUtils.getOppProductPublic(productPublic, lineItem, priceBookEntries.get(lineItem.PriceBookEntryId));

            if(lineItem.PriceBookEntryId != null && priceBookEntries.get(lineItem.PriceBookEntryId) != null)
                productPublic.Name = priceBookEntries.get(lineItem.PriceBookEntryId).Product2.Name;

            oppProductsPublicToUpdate.add(productPublic);
        }
        update oppProductsPublicToUpdate;
    } 

    /************************************* AFTER DELETE *****************************************************/
    
    if(Trigger.isAfter && Trigger.isDelete) 
    {
        for(Opportunity_Products_Public__c productPublic : [SELECT Id, Opportunity_Line_Item_Id__c FROM Opportunity_Products_Public__c WHERE Opportunity_Line_Item_Id__c IN: oppLineItemIds AND Opportunity_Line_Item_Id__c != NULL LIMIT :EGUtils.getNoOfRowsThatCanBeRetrieved()])
            oppProductsPublicToDelete.add(productPublic);
          
        delete oppProductsPublicToDelete;      
    } 
    
    /**************************** AFTER INSERT AND UPDATE FOR HAS DESIGN DOLLARS ************************/
    
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate) && !opportunityIds.isEmpty())
    {
        Set<String> productCodesToFilter = new Set<String>();
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        
        productCodesToFilter.add(Properties.kiosk);
        productCodesToFilter.add(Properties.construction);
        productCodesToFilter.add(Properties.intl);
        productCodesToFilter.add(Properties.graphics);
        productCodesToFilter.add(Properties.refurb);
        productCodesToFilter.add(Properties.exhibit);
        
        for(Opportunity opp : [SELECT Id, HasDesignDollars__c, (SELECT TotalPrice FROM OpportunityLineItems WHERE PriceBookEntry.Product2.ProductCode IN: productCodesToFilter) FROM Opportunity WHERE Id IN: opportunityIds])
        {
            Double total = 0;
            Boolean hasDesignDollars = false;
            
            for(OpportunityLineItem lineItem : opp.OpportunityLineItems)
                total += lineItem.TotalPrice;
            
            if(total > 0)
                hasDesignDollars = true;
            
            if(hasDesignDollars != opp.HasDesignDollars__c)
            {
                Opportunity oppToUpdate = new Opportunity(Id = opp.Id, HasDesignDollars__c = hasDesignDollars);
                oppsToUpdate.add(oppToUpdate);                                                        
            }             
        }
        
        if(!oppsToUpdate.isEmpty())
            update oppsToUpdate;
    }    
}