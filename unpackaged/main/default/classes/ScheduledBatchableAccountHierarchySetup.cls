/*
    
/*
Class :ScheduledBatchableAccountHierarchySetup
  
Desc:  Class to call BatchableAccountHierarchySetup and set the batch size 10.
Author :Nehal Jain
Date :18 may  2017
*/


global class ScheduledBatchableAccountHierarchySetup implements Schedulable {
  
   global string query;
   
   global void execute(SchedulableContext sc) {
      
      BatchableAccountHierarchySetup acchierarchy=new BatchableAccountHierarchySetup();
      acchierarchy.query=this.query;
      database.executebatch(acchierarchy,10);

   }
}