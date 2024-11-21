@isTest
public class GC_RegChkListTaskDtlsTest {
    
    static TestMethod void RegistrationCheckListTaskDetailsTest()
    {
        GC_Connect2_Show__c testShow= GC_TestUtils.getTestConnect2Show();
        ApexPages.currentPage().getParameters().put('projectNumber' , '12345');
        ApexPages.currentPage().getParameters().put('id' , '1');
        
        GC_Core_Interface_Log__c testLog = new GC_Core_Interface_Log__c ();
        testLog.Message_Content__c = '';
        insert testLog;
        
        ApexPages.currentPage().getParameters().put('storedObjectId' , testLog.id);
        Test.startTest();
        Test.setMock(WebServiceMock.class, new wwwViadComV1_allMockImpl());
        GC_RegChkListTaskDtlsController rltdCntrlr = new GC_RegChkListTaskDtlsController ();
        Test.stopTest();
    }
}