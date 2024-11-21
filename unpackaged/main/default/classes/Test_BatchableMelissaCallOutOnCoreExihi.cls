/* Class Name: BatchableMelissaCallOutOnCoreExihibitor 

    Author: Nehal Jain
    Created Date: 5/15/2017*/

@isTest
                                
public class Test_BatchableMelissaCallOutOnCoreExihi  {

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
 
Test.StartTest();

 createCustomSetting();

List<CORE_EXHIBITOR__c> CoreList = new List<CORE_EXHIBITOR__c>();
    CORE_EXHIBITOR__c Core = new CORE_EXHIBITOR__c();
    Core.Company_Name__c = 'Test';
    Core.Address1__c = 'Test1';
    Core.City__c = 'Delhi';
    Core.State__c = 'New Delhi';
    Core.Postal_Code__c = '201014';
    Core.Country__c  = 'India';
    Core.Melissa_Integration_Status__c  = 'Success';
    Core.Data_Com_Integration_Status__c = 'null';
    Core.Oracle_Interface_Status__c = 'N';
    Core.Oracle_Interface_Status__c = 'Success1';
    Core.Oracle_Key_Index__c = '123456';
    CoreList.add(Core);
    insert CoreList;
    
    set<id> CoreIDs= new set<id>();
    CoreIDs.add(Core.id);
   Test.setMock(HttpCalloutMock.class, new BatchableCoreExhibitorCallOutMock());
    
    
    
    
    BatchableMelissaCallOutOnCoreExihibitor obj= new BatchableMelissaCallOutOnCoreExihibitor();
    Database.executeBatch(obj);
    Test.StopTest();

}

}