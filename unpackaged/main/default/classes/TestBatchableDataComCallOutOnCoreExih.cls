/* Class Name: BatchableDataComCallOutOnCoreExihibitor 

    Author: Nehal Jain
    Created Date: 5/11/2017*/

@isTest(SeeAllData=false)
                                
public class TestBatchableDataComCallOutOnCoreExih  {

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
Auth_Token__c auth= new Auth_Token__c();
    auth.Name='DataCom';
    auth.Auth_Token__c='606256c8-6122-464f-a9dc-cb90f32a0b20';
    auth.Auth_Token_Expires__c=Datetime.now().addminutes(60);
    insert auth;


List<CORE_EXHIBITOR__c> CoreList = new List<CORE_EXHIBITOR__c>();
    CORE_EXHIBITOR__c Core = new CORE_EXHIBITOR__c();
    Core.Company_Name__c = 'Test';
    Core.Address1__c = 'Test1';
    Core.City__c = 'AVALON';
    Core.State__c = 'CA';
    Core.Postal_Code__c = '201014';
    Core.Country__c  = 'US';
    Core.Melissa_Integration_Status__c  = '';
    Core.Melissa_Results__c ='AE20';
    Core.Oracle_Interface_Status__c = 'N';
    Core.Data_Com_Integration_Status__c='Success';
   // Core.counter__C=0;
    Core.Oracle_Key_Index__c = '123456';
    Core.Data_Com_Error_Message__c='Unknown Exception or Read TimeOut Exception';
    CoreList.add(Core);
    insert CoreList;
    
    
    

    set<id> CoreIDs= new set<id>();
    CoreIDs.add(Core.id);
    Test.setMock(HttpCalloutMock.class, new BatchableDataComWebServiceCallOutMock());
    
      
    
    Test.StartTest();
    BatchableDataComCallOutOnCoreExihibitor obj= new BatchableDataComCallOutOnCoreExihibitor();
    obj.query='select Company_Name__c,Address1__c, Address_2__c,Address_3__c,Address_4__c,Counter__c,City__c, State__c, Postal_Code__c, Country__c from CORE_EXHIBITOR__c';
    Database.executeBatch(obj);
    Test.StopTest();

}


static  testMethod void testMethod2() {
    
    oAuthException  instexc=new oAuthException('No OAuth Settings Found');

     try{
         if(true){
         throw instexc;
         }
    }Catch(Exception e){}
    
    }
    



}