global class BatchPurgeOracleStagingObjects implements Database.Batchable<SObject>, Database.Stateful {
    
    public String query; 

    global database.querylocator start(Database.BatchableContext BC){return Database.getQueryLocator(query);}
    
    global void execute(Database.BatchableContext BC, Sobject[] scope){
        list<Database.Deleteresult> LoDeletes = Database.delete(scope, false);
    }
    
    global void finish(Database.BatchableContext BC)
    {      
    }
}