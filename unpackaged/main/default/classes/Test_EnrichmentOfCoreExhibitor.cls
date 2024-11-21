/* Class Name: EnrichmentOfCoreExhibitor

    Author: Nehal Jain
    Created Date: 5/11/2017*/

@isTest(SeeAllData=false)

Public class Test_EnrichmentOfCoreExhibitor{



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

private static void createCustomSettingSwtichOff(){
    
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
    instMsetting=new MelissaSetting__c(Name= 'Melissa Switch',Value__c = 'OFF');
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




static  testMethod void testmethod1() {



    createCustomSetting();
    Test.startTest();
Auth_Token__c auth= new Auth_Token__c();
    auth.Name='DataCom';
    auth.Auth_Token__c='606256c8-6122-464f-a9dc-cb90f32a0b20';
    auth.Auth_Token_Expires__c=Datetime.now().addminutes(60);
    insert auth;



 List<CORE_EXHIBITOR__c> CoreList = new List<CORE_EXHIBITOR__c>();
    CORE_EXHIBITOR__c Core = new CORE_EXHIBITOR__c();
    Core.Company_Name__c = 'Test';
    Core.Address1__c = 'Test1';
    Core.City__c = 'Delhi';
    Core.State__c = 'New Delhi';
    Core.Postal_Code__c = '201014';
    Core.Country__c  = 'India';
    Core.Melissa_Integration_Status__c  = 'Success';
    Core.Oracle_Interface_Status__c = '';
    Core.Oracle_Interface_Status__c='P';
    Core.Data_Com_Integration_Status__c='';
    Core.Data_Com_Integration_Status__c = 'Failed';
    Core.counter__C=3;
    Core.Data_Com_Error_Message__c='Unknown Exception or Read TimeOut Exception';
    Core.isManualIntervention__c=true;
    Core.Melissa_Results__c ='AE01,AE02';
    Core.Oracle_Key_Index__c = '123456';
    CoreList.add(Core);
    insert CoreList;
    
    BatchableMelissaCoreExhibitorCallOutMock instBatch= new BatchableMelissaCoreExhibitorCallOutMock();
    instBatch.coreExihibitorId=CoreList[0].id;
    Test.setMock(HttpCalloutMock.class, instBatch);
  //  Test.startTest();
 
   


EnrichmentOfCoreExhibitor ecc = new EnrichmentOfCoreExhibitor();

ecc.getSwitchStatus();
ecc.melissaRequestBodyInJson(CoreList);
ecc.enrichCoreExhibitorAddress(CoreList);
ecc.setStatusForRecord(Core,true ,3.0);
 Test.stopTest();
}

static  testMethod void testmethod2() {

 
    createCustomSetting();

Auth_Token__c auth= new Auth_Token__c();
    auth.Name='DataCom';
    auth.Auth_Token__c='606256c8-6122-464f-a9dc-cb90f32a0b20';
    auth.Auth_Token_Expires__c=Datetime.now().addminutes(60);
    insert auth;




 List<CORE_EXHIBITOR__c> CoreList = new List<CORE_EXHIBITOR__c>();
    CORE_EXHIBITOR__c Core = new CORE_EXHIBITOR__c();
    Core.Company_Name__c = 'Test09';
    Core.Address1__c = 'Test123';
    Core.City__c = 'New York';
    Core.State__c = 'NY';
    Core.Postal_Code__c = '10018-3249';
    Core.Country__c  = 'US';
    Core.Melissa_Integration_Status__c  = 'Success';
    Core.Oracle_Interface_Status__c = '';
    Core.Oracle_Interface_Status__c='P';
    Core.Data_Com_Integration_Status__c='';
    Core.Data_Com_Integration_Status__c = 'Failed';
    Core.counter__C=3;
    Core.Data_Com_Error_Message__c='Unknown Exception or Read TimeOut Exception';
    Core.Oracle_Key_Index__c = '023456';
    CoreList.add(Core);
    insert CoreList;
    Test.startTest(); 
 set<id> CoreIDs= new set<id>();
    CoreIDs.add(Core.id);
   Test.setMock(HttpCalloutMock.class, new BatchableDataComWebServiceCallOutMock());
 
EnrichmentOfCoreExhibitor ecc = new EnrichmentOfCoreExhibitor();

ecc.getSwitchStatus();
ecc.melissaRequestBodyInJson(CoreList);
//ecc.enrichCoreExhibitorAddress(CoreList);
ecc.enrichCoreExhibitorDUNS(CoreList);
 Test.stopTest();
}

static  testMethod void testmethod3() {


createCustomSetting();

Auth_Token__c auth= new Auth_Token__c();
    auth.Name='DataCom';
    auth.Auth_Token__c='606256c8-6122-464f-a9dc-cb90f32a0b20';
    auth.Auth_Token_Expires__c=Datetime.now().addminutes(60);
    insert auth;



 List<CORE_EXHIBITOR__c> CoreList = new List<CORE_EXHIBITOR__c>();
    CORE_EXHIBITOR__c Core = new CORE_EXHIBITOR__c();
    Core.Company_Name__c = 'Test';
    Core.Address1__c = 'Test1';
    Core.City__c = 'Delhi';
    Core.State__c = 'New Delhi';
    Core.Postal_Code__c = '201014';
    Core.Country__c  = 'India';
    Core.isManualIntervention__c=true;
    Core.counter__C=0;
    Core.Melissa_Integration_Status__c  = 'Melissa Error';
    Core.Data_Com_Error_Message__c='Unknown Exception or Read TimeOut Exception';
    Core.Melissa_Results__c ='AE01,AE02';
    Core.Oracle_Key_Index__c = '123456';
    CoreList.add(Core);
    insert CoreList;
    
 
    Test.startTest();
   BatchableMelissaCoreExhibitorCallOutMock instBatch= new BatchableMelissaCoreExhibitorCallOutMock();
    instBatch.coreExihibitorId=CoreList[0].id;
    Test.setMock(HttpCalloutMock.class, instBatch);
   


EnrichmentOfCoreExhibitor ecc = new EnrichmentOfCoreExhibitor();

ecc.getSwitchStatus();
ecc.melissaRequestBodyInJson(CoreList);
ecc.enrichCoreExhibitorAddress(CoreList);
ecc.setStatusForRecord(Core,true ,3.0);
 Test.stopTest();
}

static  testMethod void testmethod4() {


createCustomSetting();

Auth_Token__c auth= new Auth_Token__c();
    auth.Name='DataCom';
    auth.Auth_Token__c='606256c8-6122-464f-a9dc-cb90f32a0b20';
    auth.Auth_Token_Expires__c=Datetime.now().addminutes(60);
    insert auth;



 List<CORE_EXHIBITOR__c> CoreList = new List<CORE_EXHIBITOR__c>();
    CORE_EXHIBITOR__c Core = new CORE_EXHIBITOR__c();
    Core.Company_Name__c = 'Test';
    Core.Address1__c = 'Test1';
    Core.City__c = 'Delhi';
    Core.State__c = 'New Delhi';
    Core.Postal_Code__c = '201014';
    Core.Country__c  = 'US';
    Core.isManualIntervention__c=true;
    Core.counter__C=0;
    Core.Melissa_Integration_Status__c  = 'Failed';
    Core.Data_Com_Error_Message__c='Unknown Exception or Read TimeOut Exception';
    Core.Melissa_Results__c ='AE01,AE02';
    Core.Oracle_Key_Index__c = '123456';
    CoreList.add(Core);
    insert CoreList;
    
 
    Test.startTest();
    BatchableMelissaCoreExhibitorCallOutMock instBatch= new BatchableMelissaCoreExhibitorCallOutMock();
    instBatch.coreExihibitorId=CoreList[0].id;
    Test.setMock(HttpCalloutMock.class, instBatch);
   


EnrichmentOfCoreExhibitor ecc = new EnrichmentOfCoreExhibitor();

ecc.getSwitchStatus();
ecc.melissaRequestBodyInJson(CoreList);
ecc.enrichCoreExhibitorAddress(CoreList);
ecc.setStatusForRecord(Core,true ,3.0);
 Test.stopTest();
}

static  testMethod void testmethod5() {

createCustomSettingSwtichOff();


Auth_Token__c auth= new Auth_Token__c();
    auth.Name='DataCom';
    auth.Auth_Token__c='606256c8-6122-464f-a9dc-cb90f32a0b20';
    auth.Auth_Token_Expires__c=Datetime.now().addminutes(60);
    insert auth;



 List<CORE_EXHIBITOR__c> CoreList = new List<CORE_EXHIBITOR__c>();
    CORE_EXHIBITOR__c Core = new CORE_EXHIBITOR__c();
    Core.Company_Name__c = 'Test';
    Core.Address1__c = 'Test1';
    Core.City__c = 'Delhi';
    Core.State__c = 'New Delhi';
    Core.Postal_Code__c = '201014';
    Core.Country__c  = 'US';
    //Core.isManualIntervention__c=true;
    Core.counter__C=0;
    Core.Melissa_Integration_Status__c  = 'Success';
    //Core.counter__C=0;
    Core.Data_Com_Error_Message__c='Unknown Exception or Read TimeOut Exception';
    Core.Melissa_Results__c ='AE01,AE02';
    Core.Oracle_Key_Index__c = '123456';
    CoreList.add(Core);
    insert CoreList;
   // Core.counter__C=1;
   // update CoreList;
    
    map<Id, List<CORE_EXHIBITOR__c>> map1 = new map<Id, List<CORE_EXHIBITOR__c>>(); 
    for(CORE_EXHIBITOR__c t : CoreList)
    {
        map1.put(t.Id, new List<CORE_EXHIBITOR__c>{t});
    }
    
    
 
    Test.startTest();
       BatchableMelissaCoreExhibitorCallOutMock instBatch= new BatchableMelissaCoreExhibitorCallOutMock();
    instBatch.coreExihibitorId=CoreList[0].id;
    Test.setMock(HttpCalloutMock.class, instBatch);
       


    EnrichmentOfCoreExhibitor ecc = new EnrichmentOfCoreExhibitor();

ecc.getSwitchStatus();
ecc.melissaRequestBodyInJson(CoreList);
    ecc.enrichCoreExhibitorAddress(CoreList);
ecc.setStatusForRecord(Core,true ,3.0);
 Test.stopTest();
 
    
}


}