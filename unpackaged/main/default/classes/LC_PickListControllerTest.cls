@isTest
public class LC_PickListControllerTest {
	 static TestMethod void testAllMethods() {
        GT_Event__c testEvent = new GT_Event__c();
        testEvent.Name_of_Event__c = 'Test Event';
        insert testEvent;
        
        List<string> pickListValues = LC_PickListController.getPickListValuesIntoList('GT_Event__c', 'Shipping_Country__c');
    }
}