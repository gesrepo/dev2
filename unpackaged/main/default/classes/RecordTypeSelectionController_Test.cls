@isTest
public without sharing class RecordTypeSelectionController_Test
{ 
    @testSetup static void  dataSetup()
    {
        
        TestDataUtilityClass.recordTypeCreation('Opportunity');
        //creation of opportunity recordtype record
        
    }
    
    static testMethod void testRecordTypeCreation()
    {
        String obj='Opportunity';
        Test.startTest();
        RecordTypeSelectionController.getRecordtype(obj);
        Test.stopTest();
        
    }
}