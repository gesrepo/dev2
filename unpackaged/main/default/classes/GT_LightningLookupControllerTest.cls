@isTest
public class GT_LightningLookupControllerTest {
    
    static TestMethod void testAllMethods() {
        
        GC_Connect2_Show__c testShow = new GC_Connect2_Show__c();
        testShow.Show_Name__c = 'test show';
        testShow.Job_Number__c = '12345';
        testShow.Show_Start_Date__c = Date.today();
        testShow.Show_End_Date__c = Date.today();
        insert testShow;
        
        string serializedResult = GT_LightningLookupController.searchDB('GC_Connect2_Show__c', 'Name', 'Id', 4, 'Name', 'cs');
    }
}