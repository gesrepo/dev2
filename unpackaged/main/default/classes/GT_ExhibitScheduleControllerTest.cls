@isTest
public class GT_ExhibitScheduleControllerTest {
    
    static TestMethod void fetchReportTest(){
        
        //Test GES Connect Event
        GT_Event__c testGCEvent = new GT_Event__c();
        testGCEvent.Name_of_Event__c = 'Test Event';
        testGCEvent.Event_Acronym__c = 'TEST';
        testGCEvent.Event_Start_Date__c = Date.today();
        testGCEvent.Event_End_Date__c = Date.today() + 2;
        testGCEvent.Facility_Name__c = 'Test Facility';
        testGCEvent.Shipping_City__c = 'Chicago';
        testGCEvent.Shipping_State_Province__c = 'Illinois';
        testGCEvent.Shipping_Country__c = 'United States';
        insert testGCEvent;
        
        //Test Exhibit
        GT_Exhibit__c testExhibit = new GT_Exhibit__c();
        testExhibit.Booth_Length__c = 100;
        testExhibit.Booth_Width__c = 200;
        testExhibit.Booth_Number__c = '12345';
        testExhibit.GES_Connect_Event__c = testGCEvent.Id;
        testExhibit.Canceled__c = false;
        insert testExhibit;
        
        //Test Speaking Engagement
        GT_Speaking_Engagement__c testSpEngmnt = new GT_Speaking_Engagement__c();
        testSpEngmnt.Speaking_Engagement_Type__c = 'Panel speaker';
        testSpEngmnt.GES_Connect_Event__c = testGCEvent.Id;
        testSpEngmnt.Canceled__c = false;
        insert testSpEngmnt;
        
        //Test Sponsorship
        GT_Sponsorship__c testSponsorship = new GT_Sponsorship__c();
        testSponsorship.Sponsorship_Name__c = 'Test Sponsorship';
        testSponsorship.GES_Connect_Event__c = testGCEvent.Id;
        testSponsorship.Canceled__c = false;
        insert testSponsorship;
        
        //Test Meeting Room
        GT_Meeting_Room__c testMR = new GT_Meeting_Room__c();
        testMR.Meeting_Room_Name__c = 'Test Meeting Room';
        testMR.GES_Connect_Event__c = testGCEvent.Id;
        testMR.Canceled__c = false;
        insert testMR;
        
        //Test Event(RL)
        GT_Event_RL__c testevntRL = new GT_Event_RL__c();
        testevntRL.Event_Room_Name__c = 'Test Event Room';
        testevntRL.GES_Connect_Event__c = testGCEvent.Id;
        testevntRL.Canceled__c = false;
        insert testevntRL;
        
        //Test Reg_Attend_Only
        GT_Reg_Attend_Only__c testRegAttend = new GT_Reg_Attend_Only__c();
        testRegAttend.GES_Connect_Event__c = testGCEvent.Id;
        testRegAttend.Canceled__c =false;
        testRegAttend.Names_of_Attendees__c = 'Karthik';
        insert testRegAttend;
        
        //Test Sporting Event
        GT_Sporting_Event__c testSportingEvent = new GT_Sporting_Event__c();
        testSportingEvent.GES_Connect_Event__c = testGCEvent.Id;
        testSportingEvent.Canceled__c =false;
        testSportingEvent.Sporting_Event_Name__c = 'Test';
        testSportingEvent.Sporting_Event_Type__c = 'Suite';
        insert testSportingEvent;
        
        //Test Membership
        GT_Membership__c testMembership = new GT_Membership__c();
        testMembership.GES_Connect_Event__c = testGCEvent.Id;
        testMembership.Canceled__c =false;
        testMembership.Membership_Name__c = 'Test';
        insert testMembership;
        
        //Test Product
        GT_Brand__c testBrand = new GT_Brand__c();
        testBrand.Canceled__c = false;
        testBrand.Exhibit__c = testExhibit.Id;
        testBrand.Speaking_Engagement__c = testSpEngmnt.Id;
        testBrand.Sponsorship__c = testSponsorship.Id;
        testBrand.Meeting_Room__c = testMR.Id;
        testBrand.Event__c = testevntRL.Id;
        testBrand.Registration_Attend_Only__c = testRegAttend.Id;
        insert testBrand;
        
        GT_ExhibitScheduleController.getConnectSettings();
        GT_ExhibitScheduleController.fetchReports(null, null, null);
        GT_ExhibitScheduleController.fetchReports(string.valueof(Date.today()), null,'Sig Sauer');
        GT_ExhibitScheduleController.fetchReports(null, string.valueof(Date.today()),null);
        GT_ExhibitScheduleController.fetchReports(string.valueof(Date.today()), string.valueof(Date.today()), 'Crown Castle');
       
       // GT_ExhibitScheduleController.fetchBrandNames();
        GT_ExhibitScheduleController.fetchCountryNames();
        GT_ExhibitScheduleController.fetchBusinessUnitCategory();
        
    }
}