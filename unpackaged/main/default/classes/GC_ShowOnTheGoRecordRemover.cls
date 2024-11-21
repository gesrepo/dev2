/*******************************************
@@@ Purpose: This scheduler removes the GC_Core_Interface_Log__c records which are created when a show on the pdf report is run.
@@@ author rksinha For SLK Software Services 
@@@ Created Date 

********************************************/


global class GC_ShowOnTheGoRecordRemover implements Database.Batchable<sObject>{

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String searchKeyword='PDF Print';
        String query = 'SELECT Id, Name, Method_Name__c FROM GC_Core_Interface_Log__c where Method_Name__c LIKE \'%' ;
        //List<GC_Core_Interface_Log__c> allLogs = Database.query(query+ searchKeyword + '%\'');
        //system.debug('allLogs=='+allLogs.size());
        return Database.getQueryLocator(query+ searchKeyword + '%\'');
    }
    
    global void execute(Database.BatchableContext BC, List<GC_Core_Interface_Log__c> allPDFLogs) {
        database.delete(allPDFLogs, false) ;
    }  
    
    global void finish(Database.BatchableContext BC) {
    }

}