/*  Class: BatchableDataComAccountSweep
    Desc: Test Class
    Author: Hemendra
    Created Date: 23 June 2017
*/

    @isTest(SeeAllData=false)
    
    Private class TestBatchableDataComAccountSweep{
    Private static testmethod void TestBatchableAccount(){
    
    List<Account> acList = new List<Account>();
    Account acc = new Account();
    acc.Name = 'Test';
    acc.BillingStreet = 'Test123';
    acc.BillingCity = 'Delhi';
    acc.BillingState = 'New Delhi';
    acc.BillingPostalCode = '201014';
    acc.BillingCountry = 'India';
    acc.Melissa_Integration_Status__c = 'Success';
    acc.merge_flag__c = 'MP';
    //acc.Data_Com_Status_UPS__c  ='N';
    //acc.Data_Com_Status_UPS__c  ='DI';
    acList.add(acc);
    insert acList;
    
    oAuth__c objAuth = new oAuth__c(name='DataComMatch');
    objAuth.Client_ID__c ='3MVG9PbQtiUzNgN5HOnTahCd6Ge_WVuM2gEpa.5yizaCHELxi_V7Rm8za0HRx8c1zauNoKVX_Dk2D5AQOhsbe';
    objAuth.UsernameAccount__c ='accountmerge@ges.com.dev2';
    objAuth.DataComURL__c ='https://ges--dev2.sandbox.my.salesforce.com/services/data/v32.0/match/DunsRightMatchEngine/DatacloudCompany/DunsRightMatchRule';
    objAuth.Auth_Endpoint__c ='https://ges--dev2.sandbox.my.salesforce.com';
    objAuth.Client_Secret__c ='6888180621037269559';
    objAuth.SecurityAccount__c ='gessvoc8MNIJ2OQvJdadV6WH04JnGw9C';
    insert objAuth;
    
    set<id> AccIDs= new set<id>();
    AccIDs.add(acc.id);
    Test.setMock(HttpCalloutMock.class, new BatchableDataComWSMockAccountSweep());
    
    /*oAuth__c myoAuth = new oAuth__c();
    myoAuth.Auth_Endpoint__c = 'httpsL:/test123.com';
    myoAuth.Client_ID__c = 'test';
    myoAuth.Client_Secret__c = 'test';
    myoAuth.name = 'DataComMatch';
    insert myoAuth;*/
    
    Test.StartTest();
    BatchableDataComAccountSweep obj= new BatchableDataComAccountSweep();
    Database.executeBatch(obj);
    Test.StopTest();
    
    }
        
 }