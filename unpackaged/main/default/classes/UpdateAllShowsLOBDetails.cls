global class UpdateAllShowsLOBDetails implements Database.Batchable<sObject>{
    global final String query = 'select id from Show__c ';
    global List<Show__c> showUpdate = new List<Show__c>();
	
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Show__c> scope){
        Set<Id> scopeIds = new Set<Id>();
        for (Show__c s : scope) {
            scopeIds.add(s.Id);
        }
        LOBDetailsCalculations.LOBDetailsCalculations(scopeIds);
    }

    global void finish(Database.BatchableContext BC){
    
    }
    
}