/*  

Class :BatchableMelissaCallOutOnCoreExihibitor 
version :V1.0 
Desc: Batch class to call EnrichmentOfCoreExhibitor  class to call meslissa Address api
Modified by :Kumud Thakur
Date :29 April 2017
*/
    


global class BatchableMelissaCallOutOnCoreExihibitor  implements Database.Batchable<sObject>, Database.AllowsCallOuts{
   
    global  String  query;
    
      global BatchableMelissaCallOutOnCoreExihibitor() {       
     if(Test.isRunningTest()) { 
       query = 'select  Address1__c, Address_2__c,Address_3__c,Address_4__c,IsManualIntervention__c,City__c, State__c, Postal_Code__c,Country__c from CORE_EXHIBITOR__c where Melissa_Integration_Status__c = null  limit 25';
        }            
    } 
    
   
    global Database.QueryLocator start(Database.BatchableContext bc){
      if(Test.isRunningTest()) { 
         return Database.getQueryLocator('select  Address1__c, Address_2__c,Address_3__c,Address_4__c,IsManualIntervention__c,City__c, State__c, Postal_Code__c,Country__c from CORE_EXHIBITOR__c');
        }  else {
        return Database.getQueryLocator(query);
        }
    }
    
    global void execute(Database.BatchableContext bc, List<sObject> scope) {
       EnrichmentOfCoreExhibitor myCoreExihibitor = new EnrichmentOfCoreExhibitor();
       myCoreExihibitor.enrichCoreExhibitorAddress(scope);
    }
   global void finish(Database.BatchableContext bc){       }

}