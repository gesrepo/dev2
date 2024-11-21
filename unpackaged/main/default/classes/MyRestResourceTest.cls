@IsTest
public class MyRestResourceTest {
    @testSetup static void setup(){
        GC_Core_Session__c coreSession= new  GC_Core_Session__c(Core_Application_Session_ID__c='ID002', Is_Logged_In__c=true, Core_Application_Session_Error_Message__c='msg'
       , Core_Application_Login_Error_Message__c='Msg',  Core_Application_Login_Expiration__c=Date.today(), Core_Application_Session_Expiration__c =Date.today()+4);
        insert coreSession;
    }
    @isTest static void testgetRecord(){
        String projectNum='P00000001';
        RestRequest request = new RestRequest();
        request.requestUri ='https://yourInstance.salesforce.com/services/apexrest/' + projectNum;
        request.httpMethod = 'GET';
        RestContext.request = request;
        Test.startTest();
        String result=MyRestResource.getRecord();
        Test.stopTest();
        UpSQR_DatacontractOrg200407System testClassVar= new UpSQR_DatacontractOrg200407System ();
        UpSQR_DatacontractOrg200407System.DateTimeOffset testDateTimeOffset= new UpSQR_DatacontractOrg200407System.DateTimeOffset(); 
        UpSQR_MicrosoftCom200310Serializat  testObj=new UpSQR_MicrosoftCom200310Serializat();
        UpSQR_MicrosoftCom200310Serializat.KeyValueOfstringstring_element  testKeyValueOfstringstring_element =new UpSQR_MicrosoftCom200310Serializat.KeyValueOfstringstring_element();
        UpSQR_MicrosoftCom200310Serializat.ArrayOfKeyValueOfstringstring   testArrayOfKeyValueOfstringstring  =new UpSQR_MicrosoftCom200310Serializat.ArrayOfKeyValueOfstringstring ();
        UpSQR_MicrosoftCom200310Serializat.ArrayOfint   testArrayOfint  =new UpSQR_MicrosoftCom200310Serializat.ArrayOfint();
    }
}