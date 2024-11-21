@isTest
public class GT_BackControllerTest {
	
    static TestMethod void testAllMethods() {
        GT_Brand__c brand1 = new GT_Brand__c();
        GT_Brand__c brand2 = new GT_Brand__c();
        GT_Brand__c brand3 = new GT_Brand__c();
        GT_Brand__c brand4 = new GT_Brand__c();
        GT_Brand__c brand5 = new GT_Brand__c();
        GT_Brand__c brand6 = new GT_Brand__c();
        GT_Brand__c brand7 = new GT_Brand__c();
        GT_Brand__c brand8 = new GT_Brand__c();
        //GT_Brand__c brand9 = new GT_Brand__c();
        //GT_Brand__c brand10 = new GT_Brand__c();
        GT_Exhibit__c exhibit = new GT_Exhibit__c();
        GT_Sponsorship__c sponsorship = new GT_Sponsorship__c();
        GT_Meeting_Room__c meetingRoom = new GT_Meeting_Room__c();
        GT_Speaking_Engagement__c speakingEngagement = new GT_Speaking_Engagement__c();
        GT_Event_RL__c event = new GT_Event_RL__c();
        GT_Event__c connectEvent = new GT_Event__c();
        GT_Reg_Attend_Only__c regAttend = new  GT_Reg_Attend_Only__c();
        GT_General_Event_Costs__c geneventCost = new GT_General_Event_Costs__c();
        //GT_Sporting_Event__c sportingEvent = new GT_Sporting_Event__c();
        GT_Meeting_Planning__c meetingPlanning = new GT_Meeting_Planning__c();
        //GT_Membership__c membership = new GT_Membership__c ();
        
        connectEvent.Association_Contact_Name__c = 'test name';
        insert connectEvent;
        
        exhibit.GES_Connect_Event__c = connectEvent.Id;
        insert exhibit;
        
        sponsorship.GES_Connect_Event__c = connectEvent.Id;
        insert sponsorship;
        
        meetingRoom.GES_Connect_Event__c = connectEvent.Id;
        insert meetingRoom;
        
        speakingEngagement.GES_Connect_Event__c = connectEvent.Id;
        insert speakingEngagement;
        
        regAttend.GES_Connect_Event__c = connectEvent.Id;
        insert regAttend;
        
        event.GES_Connect_Event__c = connectEvent.Id;
        event.Event_Room_Name__c = 'test name';
        insert event;
        
		geneventCost.GES_Connect_Event__c =  connectEvent.Id;
        insert geneventCost;
        
        //sportingEvent.GES_Connect_Event__c =  connectEvent.Id;
        //sportingEvent.Sporting_Event_Type__c = 'Suite';
        //insert sportingEvent;
        
        meetingPlanning.GES_Connect_Event__c =  connectEvent.Id;
        insert meetingPlanning;
        
        //membership.GES_Connect_Event__c =  connectEvent.Id;
        //insert membership;
        
        brand1.Exhibit__c = exhibit.Id;
        insert brand1;
        
        brand2.Sponsorship__c = sponsorship.Id;
        insert brand2;
        
        brand3.Meeting_Room__c = meetingRoom.Id;
        insert brand3;
        
        brand4.Speaking_Engagement__c = speakingEngagement.Id;
        insert brand4;
        
        brand5.Event__c = event.Id;
        insert brand5;
        
        brand6.Registration_Attend_Only__c = regAttend.Id;
        insert brand6;
        
        brand7.General_Event_Costs__c = geneventCost.Id;
        insert brand7;
        
        //brand8.Membership__c = membership.Id;
        //insert brand8;
        
        brand8.Meeting_Planning__c = meetingPlanning.Id;
        insert brand8;
        
        //brand9.Sporting_Event__c = sportingEvent.Id;
        //insert brand10;
       
        
        GT_BackController.getRelatedRecordId(brand1.Id);
        GT_BackController.getRelatedRecordId(brand2.Id);
        GT_BackController.getRelatedRecordId(brand3.Id);
        GT_BackController.getRelatedRecordId(brand4.Id);
        GT_BackController.getRelatedRecordId(brand5.Id);
        GT_BackController.getRelatedRecordId(brand6.Id);
        GT_BackController.getRelatedRecordId(brand7.Id);
        GT_BackController.getRelatedRecordId(brand8.Id);
        //GT_BackController.getRelatedRecordId(brand9.Id);
        //GT_BackController.getRelatedRecordId(brand10.Id);
        GT_BackController.getRelatedRecordId(exhibit.Id);
        GT_BackController.getRelatedRecordId(sponsorship.Id);
        GT_BackController.getRelatedRecordId(exhibit.Id);
        GT_BackController.getRelatedRecordId(meetingRoom.Id);
        GT_BackController.getRelatedRecordId(speakingEngagement.Id);
        GT_BackController.getRelatedRecordId(event.Id);
        GT_BackController.getRelatedRecordId(regAttend.Id);
        GT_BackController.getRelatedRecordId(geneventCost.Id);
        //GT_BackController.getRelatedRecordId(membership.Id);
        GT_BackController.getRelatedRecordId(meetingPlanning.Id);
        //GT_BackController.getRelatedRecordId(sportingEvent.Id);
        
    }
}