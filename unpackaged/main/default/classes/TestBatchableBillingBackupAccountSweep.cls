/*  Class: BatchableBillingAddBackupAccountSweep
    Desc: Test Class
    Author: Gaurav
    Created Date: 01 Aug 2017
*/

    @isTest(SeeAllData=false)
    
    Private class TestBatchableBillingBackupAccountSweep{
    Private static testmethod void TestBatchableAccount(){
    
    List<Account> acList = new List<Account>();
    Account acc = new Account();
    acc.Name = 'Test';
    acc.BillingStreet = 'Test123';
    acc.BillingCity = 'Delhi';
    acc.BillingState = 'New Delhi';
    acc.BillingPostalCode = '201014';
    acc.BillingCountry = 'India';
    acc.merge_flag__c = 'MP';
    acc.merge_type__c = 'TopAcc';
    
    acList.add(acc);
    insert acList;
    
    String mrgTyp = 'TopAcc';
    
          
    Test.StartTest();
    BatchableBillingAddBackupAccountSweep obj= new BatchableBillingAddBackupAccountSweep();
    Database.executeBatch(obj);
    Test.StopTest();
    
    }
        
 }