global class PopulateCategories implements Database.Batchable<sObject> 
{
     global Database.QueryLocator start(Database.BatchableContext bc) 
     {
         String cancelStatus = 'Canceled';
         String soql = 'Select Id,Item_Category__c,Item_Category_ID__c from GC_GES_Order_Task__c where Status__c <>\''+cancelStatus+'\'';
         return Database.getQueryLocator(soql);
     }
     
     global void execute(Database.BatchableContext bc, List<GC_GES_Order_Task__c> recs) 
     {
         List<GC_GES_Order_Task__c> tobeUpdated = new List<GC_GES_Order_Task__c>();
         Map<String,String> idCategoryMap = new Map<String,String>();
         idCategoryMap.put('1896','Standard Furniture');
         idCategoryMap.put('20001','Drape');
         idCategoryMap.put('1893','Specialty Furniture');
         idCategoryMap.put('1884','Production');
         idCategoryMap.put('1895','Standard Carpet');
         idCategoryMap.put('1883','Plush Carpet');
         idCategoryMap.put('1863','Graphics');
         idCategoryMap.put('1873','Material');
         idCategoryMap.put('1868','HANGING SIGN.HANGING SIGN MATERIAL');
         idCategoryMap.put('1859','Electrical Outlets');
         idCategoryMap.put('1858','Electrical Material');
         idCategoryMap.put('1882','Plumbing');
         idCategoryMap.put('1870','LABOR.LABOR');
         idCategoryMap.put('1861','EQUIPMENT.EQUIPMENT');
         idCategoryMap.put('1872','MATERIAL HANDLING.MATERIAL HANDLING');
         idCategoryMap.put('1890','PURCHASE.OTHER SERVICES');
         idCategoryMap.put('20000','GEM Structures');
         idCategoryMap.put('1860','ELECTRICAL.ELECTRICAL LABOR');
         idCategoryMap.put('1865','HANGING SIGN.HANGING SIGN');
         idCategoryMap.put('9999','Other');
         
         for(GC_GES_Order_Task__c got: recs)
         {
             if(!String.isBlank(got.Item_Category_ID__c))
             {
                 if(idCategoryMap.containsKey(got.Item_Category_ID__c))
                 {
                     got.Item_Category__c = idCategoryMap.get(got.Item_Category_ID__c);
                     tobeUpdated.add(got);
                 }
             }
         }
         
         if(tobeUpdated.size() > 0)
         {
             update tobeUpdated;
         }
     }
     
     global void finish(Database.BatchableContext bc) 
     {
         
     }
}