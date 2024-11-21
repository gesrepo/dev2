/*  

Class :AccountHierarchySetup
version :V1.0 
Desc: Batch class to call AccountHierarchySetup class 
Modified by :Nehal Jain
Date :18th May 2017
*/
    


global class BatchableAccountHierarchySetup implements Database.Batchable<sObject>, Database.AllowsCallOuts{
   
    global  String  query;
    
      global BatchableAccountHierarchySetup() {       
     if(Test.isRunningTest()) { 
       query = 'select  name, DunsNumber,parent_duns_number__C,Custom_Parent_Account__c,Processed_Flag__c,ParentId from Account  limit 25';
        }            
    } 
    
   
    global Database.QueryLocator start(Database.BatchableContext bc){
      if(Test.isRunningTest()) { 
         return Database.getQueryLocator('select  name, DunsNumber,parent_duns_number__C,Custom_Parent_Account__c,Processed_Flag__c,ParentId from Account');
        }  else {
        return Database.getQueryLocator(query);
        }
    }
    
    global void execute(Database.BatchableContext bc, List<sObject> scope) {
       AccountHierarchySetup hierarchy = new AccountHierarchySetup();
       hierarchy.setupAccountHierarchy(scope);
    }
   global void finish(Database.BatchableContext bc){       }

}