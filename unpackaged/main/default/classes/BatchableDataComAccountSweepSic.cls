global class BatchableDataComAccountSweepSic  implements Database.Batchable<sObject>, Database.AllowsCallOuts, Database.Stateful {
    global   String  query;
    final map<String,DatacloudDandBCompany> mapDandB=new Map<String,DatacloudDandBCompany>();            
   
   global BatchableDataComAccountSweepSic(String mrgTyp) {    
   
      query = 'select Id, Name, Dunsnumber, Sic, SicDesc from Account where Dunsnumber <> null and merge_type__c = \''+mrgTyp+'\'  LIMIT 9999';                 
   
    } 
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<sObject> scope) {
    
    List<Account> listAccount=new List<Account>();
    set<String> setDunsNumber=new Set<String>(); 
    
    List<Account> accUpdt = new List<Account>();
    
    for(SObject s: scope)
        {
            listAccount.add((Account)s);
        }
    
    for(Account instAcc : listAccount)
        {
             if(String.isNotBlank(instAcc.Dunsnumber)){
                  setDunsNumber.add(instAcc.Dunsnumber);// duns number of account in the set
               }
                       
        }
    
      getSicDandB(setDunsNumber);
      system.debug('Value of mapDandB.size() inside execute:'+mapDandB.size());
      system.debug('Value of listAccount.size() inside execute:'+listAccount.size());
      for(Account acc:listAccount){
           if (mapDandB.containskey(acc.dunsNumber)){
                   acc.Sic = mapDandB.get(acc.dunsNumber).PrimarySic;
                   acc.SicDesc = mapDandB.get(acc.dunsNumber).PrimarySicDesc;
            }
            accUpdt.add(acc);       
        }   
             
        system.debug('Value of accUpdt.size():'+accUpdt.size());          
        if(accUpdt.size() > 0) {  
                   system.debug('Value of accUpdt Update');               
                   Update accUpdt;                   
                 }  
    }   
    
     public void getSicDandB(Set<String> setDunsNumber ){
     system.debug('Value of setDunsNumber.size():'+setDunsNumber.size());
    for(DatacloudDandBCompany instDBcmpny:[SELECT Dunsnumber, PrimarySic, PrimarySicDesc FROM DatacloudDandBCompany where dunsnumber in : setDunsNumber]){
        mapDandB.put(instDBcmpny.Dunsnumber,instDBcmpny);
        system.debug('Value of mapDandB.size():'+mapDandB.size());
     }
    }    
       
   global void finish(Database.BatchableContext bc){       }
   }