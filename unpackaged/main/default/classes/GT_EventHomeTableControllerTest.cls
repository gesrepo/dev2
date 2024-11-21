@isTest
public class GT_EventHomeTableControllerTest {
    
    static TestMethod void testAllMethods() {
        
        GT_Event__c testEvent = new GT_Event__c();
        testEvent.Name_of_Event__c = 'Test Event from methods';
        testEvent.Event_Acronym__c = 'TEST';
        testEvent.Event_Start_Date__c = Date.today();
        testEvent.Event_End_Date__c = Date.today() + 2;
        insert testEvent;
        
        GT_EventHomeTableController.getConnectSettings();
        GT_EventHomeTableController.getEvents();
        GT_EventHomeTableController.getSearchResults('Test', 'TEST', '2018',null,null,null,null,null,null);
        GT_EventHomeTableController.getSearchResults('Test', '', '','Juanita Timney',null,null,null,null,null);
        GT_EventHomeTableController.getSearchResults('Test', '', '2018',null,'Corporate',null,null,null,null);
        GT_EventHomeTableController.getSearchResults('', '', '2018',null,null,'ASD',null,null,null);
        GT_EventHomeTableController.getSearchResults('', 'TEST', '2018',null,null,null,'Katie Lillie',null,null);
        GT_EventHomeTableController.getSearchResults('Test', 'TEST', '',null,null,null,null,'Jill Johnson',null);
        GT_EventHomeTableController.getSearchResults('', 'TEST', '',null,null,null,null,null,'Biopharmaceuticals');
    }
}