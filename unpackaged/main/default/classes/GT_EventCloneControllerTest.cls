@isTest
private class GT_EventCloneControllerTest {

    @testSetup static void setup() {
        // Create test record with children
        GT_Event__c testEvent = new GT_Event__c();
        testEvent.Event_Start_Date__c= date.today();
        testEvent.Event_End_Date__c=date.today()+10;
        testEvent.RecordTypeId='0121W000000YepBQAS';
        testEvent.Name_of_Event__c='TSTRHL01_TEST';
        insert testEvent;
        
        GT_Exhibit__c testExhibit = new GT_Exhibit__c();
        testExhibit.GES_Connect_Event__c= testEvent.id;
        testExhibit.Booth_Length__c=10;
        testExhibit.Booth_Number__c='15';
        testExhibit.Activity_Level__c='Tier 1';
        insert testExhibit;
        
        GT_Sponsorship__c sponsorship = new GT_Sponsorship__c();
        sponsorship.GES_Connect_Event__c = testEvent.Id;
        insert sponsorship;
        
        GT_Speaking_Engagement__c speakingEngagement = new GT_Speaking_Engagement__c();
        speakingEngagement.GES_Connect_Event__c=testEvent.id;
        insert speakingEngagement;
        
        GT_Meeting_Room__c meetingRoom = new GT_Meeting_Room__c();
        meetingRoom.GES_Connect_Event__c=testEvent.id;
        insert meetingRoom;
        
        GT_Event_RL__c event = new GT_Event_RL__c();
        event.GES_Connect_Event__c=testEvent.id;
        event.Event_Room_Name__c='test event room';
        insert event;
        
        GT_Reg_Attend_Only__c regAttend = new  GT_Reg_Attend_Only__c();
        regAttend.GES_Connect_Event__c=testEvent.id;
        insert regAttend;
        
        GT_Sporting_Event__c sporEve = new GT_Sporting_Event__c();
        sporEve.GES_Connect_Event__c=testEvent.id;
        sporEve.Sporting_Event_Type__c='Season Tickets';
        insert sporEve;
        
        GT_Membership__c mem = new GT_Membership__c();
        mem.GES_Connect_Event__c=testEvent.id;
        insert mem;
        
        List<GT_Brand__c> brandList= new List<GT_Brand__c>();
        GT_Brand__c testBrand1= new GT_Brand__c();
        testBrand1.GES_Connect_Event__c= testEvent.id;
        testBrand1.Exhibit__c= testExhibit.id;
        brandList.add(testBrand1);
        GT_Brand__c testBrand2= new GT_Brand__c();
        testBrand2.GES_Connect_Event__c= testEvent.id;
        testBrand2.Sponsorship__c= sponsorship.id;
        brandList.add(testBrand2);
        GT_Brand__c testBrand3= new GT_Brand__c();
        testBrand3.GES_Connect_Event__c= testEvent.id;
        testBrand3.Speaking_Engagement__c= speakingEngagement.id;
        brandList.add(testBrand3);
        GT_Brand__c testBrand4= new GT_Brand__c();
        testBrand4.GES_Connect_Event__c= testEvent.id;
        testBrand4.Meeting_Room__c= meetingRoom.id;
        brandList.add(testBrand4);
        GT_Brand__c testBrand5= new GT_Brand__c();
        testBrand5.GES_Connect_Event__c= testEvent.id;
        testBrand5.Event__c= event.id;
        brandList.add(testBrand5);
        GT_Brand__c testBrand6= new GT_Brand__c();
        testBrand6.GES_Connect_Event__c= testEvent.id;
        testBrand6.Registration_Attend_Only__c= regAttend.id;
        brandList.add(testBrand6);
        GT_Brand__c testBrand7= new GT_Brand__c();
        testBrand7.GES_Connect_Event__c= testEvent.id;
        testBrand7.Sporting_Event__c= sporEve.id;
        brandList.add(testBrand7);
        GT_Brand__c testBrand8= new GT_Brand__c();
        testBrand8.GES_Connect_Event__c= testEvent.id;
        testBrand8.Membership__c= mem.id;
        brandList.add(testBrand8);
        insert brandList;
    }
    
    @isTest static void testCloning() {
        // Get the first test account by using a SOQL query
        List<GT_Event__c> existingEvents=[SELECT id, name,Name_of_Event__c FROM GT_Event__c WHERE Name_of_Event__c='TSTRHL01_TEST' LIMIT 1];
        GT_EventCloneController.cloneEventWithChildren(existingEvents[0].id);
    }
}