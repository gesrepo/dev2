/**************************************
Class : TriggerFor_BatchImportLogisticsQuoteTest
Description : this class is used to cover code coverage of trigger "TriggerFor_BatchImportLogisticsQuote" and helper class 
               "QuoteStagingTriggerHelper".
**************************************/
@isTest
private class TriggerFor_BatchImportLogisticsQuoteTest{
 static testMethod void validateHelloWorld() { 
 
     Quote__c q = new Quote__c();
     q.TOPS_Quote_Number__c= '189922';
     q.Quote_Subject__c = 'new';            
     q.Source__c = 'test source';
     q.Stage__c = 'Traffic / Carrier Quote Returned';
     q.Type__c = 'test';
     insert q;

     Quote_Staging__c qs = new Quote_Staging__c();
     qs.TOPS_Quote_Number__c= '189922';
     qs.Quote_Subject__c = 'new';            
     qs.Source__c = 'test source';
     qs.Stage__c = 'Traffic / Carrier Quote Returned';
     qs.Type__c = 'test insert';
     qs.Quote_Id__c = q.id;  
     
 Test.startTest();
     insert qs;  
 Test.stopTest();
 
     qs.Type__c = 'test updated';     
     update qs;
     
 // Retrieve the updates quote
    Quote__c qb = [SELECT Type__c FROM Quote__c WHERE Id =:q.Id];
    System.debug('type after trigger fired: ' + qb.Type__c );
 
 // Test that the trigger correctly updated the price
 //System.assertEquals('test updated', qb.Type__c );
 }
}