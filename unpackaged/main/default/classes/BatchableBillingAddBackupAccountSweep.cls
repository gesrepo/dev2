global class BatchableBillingAddBackupAccountSweep implements Database.Batchable<sObject>{

    global   String  query;
    
           
    global BatchableBillingAddBackupAccountSweep(String mrgTyp) {
    
    query = 'SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, DunsNumber, Melissa_Address_DUNS__c, Melissa_Address__c, Melissa_City__c, Melissa_State__c, Melissa_Postal_Code__c, Melissa_Country__c   FROM Account where merge_type__c = \''+mrgTyp+'\'  LIMIT 9999';   
    }
    
    global BatchableBillingAddBackupAccountSweep() {       
     if(Test.isRunningTest()) { 
       query = 'SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, DunsNumber, Melissa_Address_DUNS__c, Melissa_Address__c, Melissa_City__c, Melissa_State__c, Melissa_Postal_Code__c, Melissa_Country__c   FROM Account where merge_type__c != null LIMIT 25';   
     }         
    } 
     
      global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(query);
    }

    

    global void execute(Database.BatchableContext BC, List<Account> scope)

    {             

        List<Account> acctToUpdateList =  new List<Account>();

         

        for(Account accObj: scope){

                accObj.Melissa_Address__c = accObj.BillingStreet;
                accObj.Melissa_City__c  = accObj.BillingCity;
                accObj.Melissa_State__c = accObj.BillingState;
                accObj.Melissa_Postal_Code__c  = accObj.BillingPostalCode;
                accObj.Melissa_Country__c  = accObj.BillingCountry;
                accObj.Melissa_Address_DUNS__c = accObj.DunsNumber;
                accObj.merge_flag__C = 'NN';
                
                acctToUpdateList .add(accObj);            

      }       
    
   if(!acctToUpdateList .isEmpty()){
   Database.update(acctToUpdateList , false);
  }             
    }

    global void finish(Database.BatchableContext BC){}   

   

}