global class BatchableContactUpdate implements Database.Batchable<sObject> {

global String query;
global Map<Id, Contact> cnctmap;
global set<Id> cnctIds;

global BatchableContactUpdate(Map<Id, Contact> Contactmap) {

    cnctmap = Contactmap;
    cnctIds = cnctmap.keySet();
    if(Test.isRunningTest()) { 
    query = 'SELECT Id, Account.Id, Oracle_AR_Customer_Number__c, GBMS_ID__c,Oracle_AR_Customer_ID__c FROM Contact limit 25';   
    } else {
    query = 'SELECT Id, Account.Id, Oracle_AR_Customer_Number__c, GBMS_ID__c,Oracle_AR_Customer_ID__c FROM Contact where Id IN :cnctIds';   
     }
}

//Query method.
 global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(query);
    }


//Execute Method.
global void execute(Database.BatchableContext BC, List<Contact> scope)
{
    
    List<Contact> cnctList = new List<Contact>();
    for(Contact cntct: cnctmap.Values()){    
    
            cnctList.add(new Contact(Id = cntct.Id, 
                                                Oracle_AR_Customer_Number__c = cntct.Oracle_AR_Customer_Number__c, 
                                                GBMS_ID__c = cntct.GBMS_ID__c, 
                                                Oracle_AR_Customer_ID__c = cntct.Oracle_AR_Customer_ID__c));
                                }
    
   if(!cnctList .isEmpty()){
   Database.update(cnctList, false);
  }    
}

//Finish method to execute at last.
global void finish(Database.BatchableContext BC) {

}
}