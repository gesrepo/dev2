/*
Class :BatchableDataComCallOutOnCoreExihibitor  
Desc: Batch class to call EnrichmentOfCoreExhibitor  classs and get DUNS Number using data.com api 
Author :Kumud Thakur
Date :21 April 2017
*/


global class BatchableDataComCallOutOnCoreExihibitor  implements Database.Batchable<sObject>, Database.AllowsCallOuts{
    
    global   String  query;
    
   global BatchableDataComCallOutOnCoreExihibitor() {
       
     /*if(Test.isRunningTest()) { 
       query = 'select Company_Name__c,Address1__c, Address_2__c,Address_3__c,Address_4__c,Counter__c,City__c, State__c, Postal_Code__c, Country__c from CORE_EXHIBITOR__c where  Melissa_Integration_Status__c != null AND Data_Com_Integration_Status__c = null AND Oracle_Interface_Status__c =  \''+'N'+'\'  AND Oracle_Interface_Status__c != null  LIMIT 25';
        }    */        
    } 
    
    global Database.QueryLocator start(Database.BatchableContext bc){
         /* if(Test.isRunningTest()) { 
         return Database.getQueryLocator('select Company_Name__c,Address1__c,Address_2__c,Address_3__c, Address_4__c,Counter__c,City__c, State__c, Postal_Code__c, Country__c from CORE_EXHIBITOR__c');
        }  else {*/
        return Database.getQueryLocator(query);
       // }
    }
    
    global void execute(Database.BatchableContext bc, List<sObject> scope) {
      
           EnrichmentOfCoreExhibitor myCoreExihibitor = new EnrichmentOfCoreExhibitor();
           List<CORE_EXHIBITOR__c> listCoreExhibit=myCoreExihibitor.enrichCoreExhibitorDUNS(scope);
           final List<CORE_EXHIBITOR__c>  listTobeUpdateCore=new List<CORE_EXHIBITOR__c>();
           
           /*
           
               below code is update the oracle interface and status , if some how data.com return unhandled exception
               then those records will get update status=failure and oracle interface ='P'.
           */
           for(CORE_EXHIBITOR__c objCore:listCoreExhibit){
              system.debug('++++++++++++++++++++ ' +objCore.Oracle_Interface_Status__c!='P');
              system.debug('==================== ' +objCore.Data_Com_Integration_Status__c);
           
               if((objCore.Oracle_Interface_Status__c!='P' && String.IsBlank(objCore.Data_Com_Integration_Status__c)) || Test.isRunningTest()){
               
                   objCore.Oracle_Interface_Status__c='P';
                   objCore.counter__C=objCore.counter__C!=null?objCore.counter__C:0;
                   objCore.counter__C=objCore.counter__C+1;
                   objCore.Data_Com_Integration_Status__c='Failed';
                   objCore.Data_Com_Error_Message__c='Unknown Exception or Read TimeOut Exception';
                   listTobeUpdateCore.add(objCore);
               }
           
           }
           
           if(!listTobeUpdateCore.isEmpty()){
               update listTobeUpdateCore;
           }
    }
   global void finish(Database.BatchableContext bc){ 
   
   
   }

}