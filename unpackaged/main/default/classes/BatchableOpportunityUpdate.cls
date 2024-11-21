global class BatchableOpportunityUpdate implements Database.Batchable<sObject> {

global String query;
global Map<Id,Opportunity> oppmap;
global set<Id> opptIds;

global BatchableOpportunityUpdate(Map<Id, Opportunity> opptyMap) {
    
    oppmap = opptyMap;
    opptIds = oppmap.keySet();
    system.debug ('++++++opptIds.size+++++' + opptIds.size());       
     if(Test.isRunningTest()) { 
       query = 'SELECT id, Account.Id,GBMS_ID__c,Oracle_AR_Customer_ID__c,Oracle_AR_Customer_Number__c FROM Opportunity  limit 25';
        }   else { 
    query = 'SELECT id, Account.Id,GBMS_ID__c,Oracle_AR_Customer_ID__c,Oracle_AR_Customer_Number__c FROM Opportunity where Id IN :opptIds';  
    //query = 'SELECT id, Account.Id,GBMS_ID__c,Oracle_AR_Customer_ID__c,Oracle_AR_Customer_Number__c FROM Opportunity where Id IN :oppmap.KeySet()';   
     }
}

//Query method.
 global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(query);
    }


//Execute Method.
global void execute(Database.BatchableContext BC, List<Opportunity> scope)
{
    List<Opportunity> opptyList = new List<Opportunity>();
    for(Opportunity opp: oppmap.Values()){    
    
            opptyList.add(new Opportunity(Id = opp.Id, 
                                                Oracle_AR_Customer_Number__c = opp.Oracle_AR_Customer_Number__c, 
                                                GBMS_ID__c = opp.GBMS_ID__c, 
                                                Oracle_AR_Customer_ID__c = opp.Oracle_AR_Customer_ID__c));
                                }
    
    
   system.debug ('++++++opptyList.size+++++' + opptyList.size());        
  if(!opptyList .isEmpty()){
   Database.update(opptyList, false);
  }    
}

//Finish method to execute at last.
global void finish(Database.BatchableContext BC) {

}
}