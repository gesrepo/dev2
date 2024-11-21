global class BatchableMelissaAccountSweep implements Database.Batchable<sObject>, Database.AllowsCallOuts{
 // global   String  query;
   // String RUser = '00540000003EhZ9';
   // String BCountry = 'US';
     String recStatus = 'NN';
    global  final String  query;

    // Query Commented now supplied as variable
    //query = 'select Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry from Account where RecordTypeId = \''+Label.Account_Exhibitor+'\' AND EMEA__c = False and Melissa_Integration_Status__c = \'\' AND CreatedById != \''+RUser+'\' AND BillingCountry = \''+BCountry+'\' AND OwnerId != \''+RUser+'\' limit 150000';         
  
    
    
    
    global BatchableMelissaAccountSweep() {
     
            
     if(Test.isRunningTest()) { 
       query = 'select Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry from Account where  Melissa_Integration_Status__c !=null  limit 25';
        }  else {
        query =  'select Name, BillingStreet, BillingCity, BillingState, BillingPostalCode,BillingCountry from Account where merge_flag__c = \''+recStatus+'\' LIMIT 9999';                 
       
        
        }       
    } 
    
    global Database.QueryLocator start(Database.BatchableContext bc){
       
        
         if(Test.isRunningTest()) { 
         return Database.getQueryLocator('select Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry from Account');
        }  else {
         return Database.getQueryLocator(query);
        }
        
    }
    
    global void execute(Database.BatchableContext bc, List<sObject> scope) {
       EnrichmentOfAddressAccountSweep myMelissaAddress = new EnrichmentOfAddressAccountSweep();
       myMelissaAddress.enrichMelissaAddress(scope);
    }
   global void finish(Database.BatchableContext bc){       }

}