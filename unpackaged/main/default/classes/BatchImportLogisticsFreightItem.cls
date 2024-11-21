global class BatchImportLogisticsFreightItem implements Database.Batchable<SObject>, Database.Stateful 
{

    public String query; 
    global database.querylocator start(Database.BatchableContext BC){return Database.getQueryLocator(query);}        
    global void execute(Database.BatchableContext BC, Sobject[] scope)
    {       
    
        List<Freight_Item_Staging__c> LoStageFreightItems = new List<Freight_Item_Staging__c>();

        for(SObject s: scope)
            LoStageFreightItems.add((Freight_Item_Staging__c)s);

        set<string> SoAllStageFreightItemId = new set<string>();
        set<Id> SoAllFreightItemId = new set<Id>();
        map<Id, Freight_Item_Staging__c> MoStageFreightItemsToStageFreightItemId = new map<Id, Freight_Item_Staging__c>();
        map<Id, Freight_Item_Staging__c> MoStageFreightItemsToFreightItemId = new map<Id, Freight_Item_Staging__c>();
                
        for(Freight_Item_Staging__c stgFI: LoStageFreightItems)
        {
            SoAllStageFreightItemId.add(stgFI.Id);
            MoStageFreightItemsToStageFreightItemId.put(stgFI.Id, stgFI);
               
            if (!SoAllFreightItemId.contains(stgFI.freight_item__c))
            {
                SoAllFreightItemId.add(stgFI.freight_item__c);
                MoStageFreightItemsToFreightItemId.put(stgFI.freight_item__c, stgFI);
            }
        }

        List<Freight_Item__c> LoFreightItems = [Select f.Width__c, f.SystemModstamp, f.Quote__c, f.Quantity__c, f.Name, f.Line_Number__c, f.Length__c
        , f.LastModifiedDate, f.LastModifiedById, f.IsDeleted, f.Id, f.Height__c, f.Hazardous_Material__c, f.Description__c
        , f.CurrencyIsoCode, f.CreatedDate, f.CreatedById, f.Crated_Weight__c From Freight_Item__c f Where f.Id In :SoAllFreightItemId];

        List<Freight_Item__c> LoFreightItemsForUpdate = new List<Freight_Item__c>();
        List<Freight_Item_Staging__c> LoStageFreightItemsForUpdate = new List<Freight_Item_Staging__c>();

        for(Freight_Item__c fi : LoFreightItems)
        {
            //Retrieve stage freight items for the current freight item in loop
            Freight_Item_Staging__c fis = MoStageFreightItemsToFreightItemId.get(fi.Id);
            LoStageFreightItemsForUpdate.add(fis);
               
            //Set fields here - map between staging and quote objects 
            fi.Width__c = fis.Width__c;          
            //fi.Quote__c = fis.Quote__c;
            fi.Quantity__c = fis.Quantity__c;
            fi.Length__c = fis.Length__c;
            fi.Height__c = fis.Height__c;
            fi.Hazardous_Material__c = fis.Hazardous_Material__c;
            fi.Description__c = fis.Description__c;
            fi.Crated_Weight__c = fis.Crated_Weight__c;
            

            //Add freight item to list for update
            LoFreightItemsForUpdate.add(fi);
 
        }

        List<Database.Saveresult> LoSr = Database.Update(LoFreightItemsForUpdate, false);

        List<Freight_Item_Staging__c> LoStageFreightItemsUpdateStatus = new List<Freight_Item_Staging__c>();
        
        integer UpdateCount = 0;

        for(Database.Saveresult result : LoSr)
        {
                        
            Freight_Item_Staging__c StgFreightItemToUpdate = LoStageFreightItemsForUpdate[UpdateCount];
            StgFreightItemToUpdate.Interface_Process_Attempts__c = (StgFreightItemToUpdate.Interface_Process_Attempts__c == null ? 0 : StgFreightItemToUpdate.Interface_Process_Attempts__c + 1);
            
            if (result.isSuccess())
            {
                StgFreightItemToUpdate.Interface_Status__c = 'Updated';
                StgFreightItemToUpdate.Interface_Error_Message__c = '';
            }
            else
            {
                StgFreightItemToUpdate.Interface_Status__c = 'Failed';
                string ErrorMessage = '';
                for(Database.Error err : result.getErrors())
                {
                    ErrorMessage += err.getMessage();
                }
                
                StgFreightItemToUpdate.Interface_Error_Message__c = ErrorMessage;              
            }
            
            LoStageFreightItemsUpdateStatus.add(StgFreightItemToUpdate);
                        
            UpdateCount++;
        }
        
          if (LoStageFreightItemsUpdateStatus.size() > 0)
            Database.update(LoStageFreightItemsUpdateStatus, false);  

  }

    global void finish(Database.BatchableContext BC)
    {      
    }
}