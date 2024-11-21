/* Class Name: EnrichmentOfAddressAccountSweep

    Author: Nehal Jain
    Created Date: 5/11/2017*/


@isTest(SeeAllData=false)
                                
public class TestEnrichmentOfAddressAccountSweep  {

private static void createCustomSetting(){
    List<MelissaSetting__c> listSetting = new List<MelissaSetting__c>();
    MelissaSetting__c instMsetting=new MelissaSetting__c(Name= 'MelisaPersonatorCountry',Value__c = 'US');
    listSetting.add(instMsetting);
    instMsetting=new MelissaSetting__c(Name= 'Melissa GlobalAddress URL',Value__c = 'https://address.melissadata.net/V3/WEB/GlobalAddress/doGlobalAddress');
    listSetting.add(instMsetting);
    instMsetting=new MelissaSetting__c(Name= 'Melissa Personator URL',Value__c = 'https://personator.melissadata.net/v3/WEB/ContactVerify/doContactVerify');
    listSetting.add(instMsetting);
    instMsetting=new MelissaSetting__c(Name= 'Melissa Error Codes',Value__c = 'AE01');
    listSetting.add(instMsetting);
    instMsetting=new MelissaSetting__c(Name= 'Melissa ClientId',Value__c = 'FWhH1f9hr-7NpBDjRxOu-R**');
    listSetting.add(instMsetting);
    instMsetting=new MelissaSetting__c(Name= 'Melissa Options',Value__c = 'DELIVERYLINES:ON');
    listSetting.add(instMsetting);
    instMsetting=new MelissaSetting__c(Name= 'Melissa Min Address Length',Value__c = '1');
    listSetting.add(instMsetting);
    
    
    insert listSetting;
    
    
    oAuth__c myoAuth = new oAuth__c();
    myoAuth.Auth_Endpoint__c = 'https://test123.salesforce.com';
    myoAuth.Client_ID__c = '3MVG9Pb';
    myoAuth.Client_Secret__c = '6888';
    myoAuth.Username__c='test@ges.com';
    myoAuth.Password__c='123456'; 
    myoAuth.name = 'DataComMatch';
    myoAuth.datacomUrl__C='https://test.com/services/data/v32.0/match/DunsRightMatchEngine/DatacloudCompany/DunsRightMatchRule';
    insert myoAuth;
    
}

static  testMethod void testMethod1() {

createCustomSetting();

//RecordType rt = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' and name= 'Exhibitor' LIMIT 1];

    List<Account> AccLst= new List<Account>();
    Account Acc= new Account();
    Acc.Name= 'Test';
    Acc.BillingStreet= 'Test1';
    Acc.BillingCity= 'AVALON';
    Acc.BillingState= 'CA';
    Acc.BillingPostalCode= '201013';
    Acc.BillingCountry= 'US';
    //Acc.EMEA__c = False; 
    Acc.Melissa_Integration_Status__c = 'Melissa Error';
   // Acc.RecordTypeId = rt.id;
  //  Acc.Test__c = True;
    Acc.Melissa_Address__c   ='Test1';
    Acc.Melissa_Country__c='US';
    Acc.Melissa_City__c='AVALON';
    Acc.Melissa_State__c='CA';
    Acc.Melissa_Postal_Code__c ='201013';
    Acc.Melissa_Country__c='US';
    Acc.Melissa_Results__c ='AE01';
    AccLst.add(Acc);
    insert AccLst;
    
    
    
  BatchableDataComMockAccountSweep instBatch= new BatchableDataComMockAccountSweep();
    instBatch.accountId=AccLst[0].id;
    Test.setMock(HttpCalloutMock.class, instBatch);
     
                   
    
    
    Test.StartTest();
    EnrichmentOfAddressAccountSweep macc= new EnrichmentOfAddressAccountSweep();
    macc.enrichMelissaAddress(AccLst);
    
    Test.StopTest();
}

static  testMethod void testMethod2() {

createCustomSetting();



//RecordType rt = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' and name= 'Exhibitor' LIMIT 1];

    List<Account> AccLst= new List<Account>();
    Account Acc= new Account();
    Acc.Name= 'Test';
    Acc.BillingStreet= 'Test1';
    Acc.BillingCity= 'AVALON';
    Acc.BillingState= 'CA';
    Acc.BillingPostalCode= '201013';
    Acc.BillingCountry= 'Canada';
    //Acc.EMEA__c = False; 
    Acc.Melissa_Integration_Status__c = 'Success';
    Acc.Melissa_Address__c   ='Test1';
    Acc.Melissa_Country__c='CA';
    Acc.Melissa_City__c='AVALON';
    Acc.Melissa_State__c='CA';
    Acc.Melissa_Postal_Code__c ='201013';
    Acc.Melissa_Results__c ='AS01';
    AccLst.add(Acc);
    insert AccLst;
    
   
    BatchableDataComMockAccountSweep instBatch= new BatchableDataComMockAccountSweep();
    instBatch.accountId=AccLst[0].id;
    Test.setMock(HttpCalloutMock.class, instBatch);
     
                   
   
    
    Test.StartTest();
    EnrichmentOfAddressAccountSweep macc= new EnrichmentOfAddressAccountSweep();
    macc.enrichMelissaAddress(AccLst);
    
    Test.StopTest();
}






}