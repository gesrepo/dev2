@isTest
public class GT_pharmaTest {
    @testSetup
    public static void testsetupMethod(){
        GT_Event__c insertConnectEvent= new GT_Event__c();
        insertConnectEvent.Shipping_City_c__c='testShippingCity';
        insertConnectEvent.Shipping_Zip_Postal_Code_c__c='12345';
        insert insertConnectEvent;
        
        GT_Exhibit__c insertExhibit=new GT_Exhibit__c();
        insertExhibit.GES_Connect_Event__c=insertConnectEvent.Id;
        insertExhibit.Agency_Contact_Name__c='test Agency Contact Name';
        insert insertExhibit;
        GT_Brand__c insertBrand=new GT_Brand__c();
        insertBrand.Exhibit__c=insertExhibit.id;
        insertBrand.Additional_Cost_Description_6__c='test brand of Exhibit';
        insert insertBrand;
        
        GT_Sponsorship__c insertSponsership=new GT_Sponsorship__c();
        insertSponsership.GES_Connect_Event__c=insertConnectEvent.Id;
        insertSponsership.Sponsorship_Name__c='test Sponseship name';
        insert insertSponsership;
        GT_Brand__c insertsponBrand=new GT_Brand__c();
        insertsponBrand.Sponsorship__c=insertSponsership.Id;
        insertsponBrand.Additional_Cost_Description_6__c='test brand for sponsership';
        insert insertsponBrand;
        
        GT_Meeting_Room__c insertMeeting=new GT_Meeting_Room__c();
        insertMeeting.GES_Connect_Event__c=insertConnectEvent.Id;
        insertMeeting.Agency_Name__c='test meetingRoom name';
        insert insertMeeting;
        GT_Brand__c insertMeetingBrand=new GT_Brand__c();
        insertMeetingBrand.Meeting_Room__c=insertMeeting.Id;
        insertMeetingBrand.Additional_Cost_Description_6__c='test brand for Meeting';
        insert insertMeetingBrand;
        
        GT_Speaking_Engagement__c insertSpeaking=new GT_Speaking_Engagement__c();
        insertSpeaking.GES_Connect_Event__c=insertConnectEvent.Id;
        insertSpeaking.Event_Manager__c='test speakingEng name';
        insert insertSpeaking;
        GT_Brand__c insertSpeakingBrand=new GT_Brand__c();
        insertSpeakingBrand.Speaking_Engagement__c=insertSpeaking.Id;
        insertSpeakingBrand.Additional_Cost_Description_6__c='test brand for SpeakingEng';
        insert insertSpeakingBrand;
        
        GT_Event_RL__c insertEventRL= new GT_Event_RL__c();
        insertEventRL.GES_Connect_Event__c=insertConnectEvent.Id;
        insertEventRL.Agency_Contact_Email__c='testagencyContactEmail@abc.com';
        insertEventRL.Event_Room_Name__c='testEventRoomName';
        insert insertEventRL;
        GT_Brand__c insertEventRLBrand=new GT_Brand__c();
        insertEventRLBrand.Event__c=insertEventRL.Id;
        insertEventRLBrand.Additional_Cost_Description_6__c='test brand for EventRL';
        insert insertEventRLBrand;
        
        GT_Meeting_Planning__c insertMeetingPlanning = new GT_Meeting_Planning__c();
        insertMeetingPlanning.GES_Connect_Event__c=insertConnectEvent.Id;
        insertMeetingPlanning.Canceled__c=true;
        insertMeetingPlanning.Cancellation_Date__c=system.today();
        insertMeetingPlanning.I_D_Name_Other__c='testIDNameOther';
        insertMeetingPlanning.Meeting_Planning_Name__c='testMeetingPlanning';
        insert insertMeetingPlanning;
        GT_Brand__c insertMeetingPlanningBrand=new GT_Brand__c();
        insertMeetingPlanningBrand.Meeting_Planning__c=insertMeetingPlanning.Id;
        insertMeetingPlanningBrand.Additional_Cost_Description_6__c='test brand for MeetingPlanning';
        insert insertMeetingPlanningBrand;
    }
    @isTest
    public static void testMethod1(){
        GT_ExhibitApexController.getProfileName();
        GT_Exhibit__c exhibit=[select Id from GT_Exhibit__c where Agency_Contact_Name__c='test Agency Contact Name' limit 1];
        GT_ExhibitApexController.getObjectName(exhibit.Id);
        GT_Sponsorship__c sponsorship=[select Id from GT_Sponsorship__c where Sponsorship_Name__c='test Sponseship name' limit 1];
        GT_Meeting_Room__c meetingRoom=[select Id from GT_Meeting_Room__c where Agency_Name__c='test meetingRoom name' limit 1];
        GT_Speaking_Engagement__c speakingEngagement=[select Id from GT_Speaking_Engagement__c where Event_Manager__c='test speakingEng name' limit 1];
         GT_Event__c event=[select Id from GT_Event__c where Shipping_City_c__c='testShippingCity' AND Shipping_Zip_Postal_Code_c__c='12345' limit 1];
        GT_Event_RL__c eventRL=[select Id from GT_Event_RL__c where Agency_Contact_Email__c='testagencyContactEmail@abc.com' limit 1];
        GT_Meeting_Planning__c meetingPlanning=[select Id from GT_Meeting_Planning__c where I_D_Name_Other__c='testIDNameOther' limit 1];
        Test.startTest();
        GT_Brand__c GTBRandId=[select id from GT_Brand__c where Additional_Cost_Description_6__c='test brand of Exhibit' limit 1];
        GT_ProductCreatePharmaApexController.getParentObjName(GTBRandId.Id);
        GT_Brand__c GTBRandSpon=[select id from GT_Brand__c where Additional_Cost_Description_6__c='test brand for sponsership' limit 1];
        GT_ProductCreatePharmaApexController.getParentObjName(GTBRandSpon.Id);
        GT_Brand__c GTBRandmeeting=[select id from GT_Brand__c where Additional_Cost_Description_6__c='test brand for Meeting' limit 1];
        GT_ProductCreatePharmaApexController.getParentObjName(GTBRandmeeting.Id);
        GT_Brand__c GTBRandspeaking=[select id from GT_Brand__c where Additional_Cost_Description_6__c='test brand for SpeakingEng' limit 1];
        GT_ProductCreatePharmaApexController.getParentObjName(GTBRandspeaking.Id);
        GT_ExhibitApexController.cloneRecord(exhibit,exhibit.Id);
        GT_ExhibitApexController.cloneRecordspeakingEngagement(speakingEngagement,speakingEngagement.Id);
        GT_ExhibitApexController.cloneRecordMeetingRoom(meetingRoom,meetingRoom.Id);
        GT_ExhibitApexController.cloneRecordSponsorship(sponsorship,sponsorship.Id);
        GT_ExhibitApexController.CalendarValues(speakingEngagement.Id);
        GT_ExhibitApexController.CalendarValuesMeetingRoom(meetingRoom.Id);
        GT_ProductCreatePharmaApexController.cloneRecord(GTBRandId);
        GT_ProductCreatePharmaApexController.connectEventId(exhibit.Id,'GT_Exhibit__c');
        GT_ProductCreatePharmaApexController.connectEventId(sponsorship.Id,'GT_Sponsorship__c');
        GT_ProductCreatePharmaApexController.connectEventId(meetingRoom.Id,'GT_Meeting_Room__c');
        GT_ProductCreatePharmaApexController.connectEventId(speakingEngagement.Id,'GT_Speaking_Engagement__c');
        GT_ProductCreatePharmaApexController.connectEventId(eventRL.Id,'GT_Event_RL__c');
        GT_ProductCreatePharmaApexController.connectEventId(meetingPlanning.Id,'GT_Meeting_Planning__c');
        GT_ProductCreatePharmaApexController.ParentObjNameusingId(exhibit.Id);
        GT_ProductCreatePharmaApexController.exhibitOpenDateOfCOngress(event.Id);
         GT_ProductCreatePharmaApexController.CalendarValues(GTBRandId.Id);
        GT_ProductCreatePharmaApexController.getTherapeuticAndBusinessUnitValues('Pipeline');
        GT_ProductCreatePharmaApexController.exhibitOpenDateValue(GTBRandId.Id);
        Test.stopTest();
        
    }
    
}