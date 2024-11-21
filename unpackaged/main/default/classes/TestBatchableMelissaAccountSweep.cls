/* Class Name: BatchableMelissaAccountSweep

    Author: Nehal Jain
    Created Date: 5/15/2017*/

@isTest(SeeAllData=false)
                                
public class TestBatchableMelissaAccountSweep  {

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
    instMsetting=new MelissaSetting__c(Name= 'Melissa Counter',Value__c = '3');
    listSetting.add(instMsetting);
    instMsetting=new MelissaSetting__c(Name= 'datacom Counter',Value__c = '3');
    listSetting.add(instMsetting);
    instMsetting=new MelissaSetting__c(Name= 'Melissa Switch',Value__c = 'On');
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

RecordType rt = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' and name= 'Exhibitor' LIMIT 1];

    List<Account> AccLst= new List<Account>();
    Account Acc= new Account();
    Acc.Name= 'Test';
    Acc.BillingStreet= 'Test1';
    Acc.BillingCity= 'Delhi';
    Acc.BillingState= 'New Delhi';
    Acc.BillingPostalCode= '201013';
    Acc.BillingCountry= 'US';
    Acc.EMEA__c = False; 
    Acc.Melissa_Integration_Status__c = 'Success';
    Acc.merge_flag__c = 'NN';
    Acc.RecordTypeId = rt.id;
    AccLst.add(Acc);
    insert AccLst;
    
    //set<id> AccIDs= new set<id>();
    //AccIDs.add(Acc.id);
   Test.setMock(HttpCalloutMock.class, new BatchableMelissaMockAccountSweep());
    
   
    
    Test.StartTest();
    BatchableMelissaAccountSweep obj= new BatchableMelissaAccountSweep();
    Database.executeBatch(obj);
    Test.StopTest();

}

}