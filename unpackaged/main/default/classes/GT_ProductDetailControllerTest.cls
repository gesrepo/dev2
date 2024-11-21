@isTest
public class GT_ProductDetailControllerTest {
    
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
        GT_Meeting_Planning__c meetingPlanning = new GT_Meeting_Planning__c();
       // GT_Sporting_Event__c sportingEvent = new GT_Sporting_Event__c();
       // GT_Membership__c membership = new GT_Membership__c();
        
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
        
        meetingPlanning.GES_Connect_Event__c = connectEvent.Id;
        meetingPlanning.Name = 'test meeting Planning';
        insert meetingPlanning;
        
        //sportingEvent.GES_Connect_Event__c = connectEvent.Id;
        //sportingEvent.Sporting_Event_Type__c = 'Suite';
        //insert sportingEvent;
        
        //membership.GES_Connect_Event__c = connectEvent.Id;
//        insert membership;
        
        
        brand1.Exhibit__c = exhibit.Id;
        brand1.GES_Costs_Estimated__c = 43423;
        brand1.Funding_Provider_Region__c = 'US';
        brand1.Funding_Provider_Brand__c = 'Test';
        brand1.GES_Costs_Actual__c = 447;
        brand1.Cost_Center__c = 'fgzdzdf';
        brand1.Canceled__c = true ;
        brand1.Reason_for_Cancellation__c = 'Budget Cut';
        brand1.Cancelled_Date__c = date.today();
        insert brand1;
        
        brand2.Sponsorship__c = sponsorship.Id;
        brand2.GES_Costs_Estimated__c = 43423;
        brand2.Funding_Provider_Region__c = 'US';
        brand2.Funding_Provider_Brand__c = 'Test';
        brand2.GES_Costs_Actual__c = 447;
        brand2.Cost_Center__c = 'fgzdzdf';
        brand2.Canceled__c = true ;
        brand2.Reason_for_Cancellation__c = 'Budget Cut';
        brand2.Cancelled_Date__c = date.today();
        insert brand2;
        
        brand3.Meeting_Room__c = meetingRoom.Id;
        brand3.GES_Costs_Estimated__c = 43423;
        brand3.Funding_Provider_Region__c = 'US';
        brand3.Funding_Provider_Brand__c = 'Test';
        brand3.GES_Costs_Actual__c = 447;
        brand3.Cost_Center__c = 'fgzdzdf';
        brand3.Canceled__c = true ;
        brand3.Reason_for_Cancellation__c = 'Budget Cut';
        brand3.Cancelled_Date__c = date.today();
        insert brand3;
        
        brand4.Speaking_Engagement__c = speakingEngagement.Id;
        brand4.GES_Costs_Estimated__c = 43423;
        brand4.Funding_Provider_Region__c = 'US';
        brand4.Funding_Provider_Brand__c = 'Test';
        brand4.GES_Costs_Actual__c = 447;
        brand4.Cost_Center__c = 'fgzdzdf';
        brand4.Canceled__c = true ;
        brand4.Reason_for_Cancellation__c = 'Budget Cut';
        brand4.Cancelled_Date__c = date.today();
        insert brand4;
        
        brand5.Event__c = event.Id;
        brand5.GES_Costs_Estimated__c = 43423;
        brand5.Funding_Provider_Region__c = 'US';
        brand5.Funding_Provider_Brand__c = 'Test';
        brand5.GES_Costs_Actual__c = 447;
        brand5.Cost_Center__c = 'fgzdzdf';
        brand5.Canceled__c = true ;
        brand5.Reason_for_Cancellation__c = 'Budget Cut';
        brand5.Cancelled_Date__c = date.today();
        insert brand5;
        
        brand6.Registration_Attend_Only__c = regAttend.Id;
        brand6.GES_Costs_Estimated__c = 43423;
        brand6.Funding_Provider_Region__c = 'US';
        brand6.Funding_Provider_Brand__c = 'Test';
        brand6.GES_Costs_Actual__c = 447;
        brand6.Cost_Center__c = 'fgzdzdf';
        brand6.Canceled__c = true ;
        brand6.Reason_for_Cancellation__c = 'Budget Cut';
        brand6.Cancelled_Date__c = date.today();
        insert brand6;
        
        brand7.General_Event_Costs__c = geneventCost.Id;
        brand7.GES_Costs_Estimated__c = 43423;
        brand7.Funding_Provider_Region__c = 'US';
        brand7.Funding_Provider_Brand__c = 'Test';
        brand7.GES_Costs_Actual__c = 447;
        brand7.Cost_Center__c = 'fgzdzdf';
        brand7.Canceled__c = true ;
        brand7.Reason_for_Cancellation__c = 'Budget Cut';
        brand7.Cancelled_Date__c = date.today();
        insert brand7;
        
        brand8.Meeting_Planning__c = meetingPlanning.Id;
        brand8.GES_Costs_Estimated__c = 43423;
        brand8.Funding_Provider_Region__c = 'US';
        brand8.Funding_Provider_Brand__c = 'Test';
        brand8.GES_Costs_Actual__c = 447;
        brand8.Cost_Center__c = 'fgzdzdf';
        brand8.Canceled__c = true ;
        brand8.Reason_for_Cancellation__c = 'Budget Cut';
        brand8.Cancelled_Date__c = date.today();
        insert brand8;
        
       /* brand9.sporting_Event__c = sportingEvent.Id;
        brand9.GES_Costs_Estimated__c = 43423;
        brand9.Funding_Provider_Region__c = 'US';
        brand9.Funding_Provider_Brand__c = 'Test';
        brand9.GES_Costs_Actual__c = 447;
        brand9.Cost_Center__c = 'fgzdzdf';
        brand9.Canceled__c = true ;
        brand9.Reason_for_Cancellation__c = 'Budget Cut';
        brand9.Cancelled_Date__c = date.today();
        insert brand9;
        
        brand10.Membership__c = membership.Id;
        brand10.GES_Costs_Estimated__c = 43423;
        brand10.Funding_Provider_Region__c = 'US';
        brand10.Funding_Provider_Brand__c = 'Test';
        brand10.GES_Costs_Actual__c = 447;
        brand10.Cost_Center__c = 'fgzdzdf';
        brand10.Canceled__c = true ;
        brand10.Reason_for_Cancellation__c = 'Budget Cut';
        brand10.Cancelled_Date__c = date.today();
        insert brand10;*/
        
        GT_ProductDetailController.getProfileName();
        GT_ProductDetailController.getFields(brand1.id);
        GT_ProductDetailController.getParentObj(brand1.id);
        
        GT_ProductDetailController.getFields(brand2.id);
        GT_ProductDetailController.getParentObj(brand2.id);
        
        GT_ProductDetailController.getFields(brand3.id);
        GT_ProductDetailController.getParentObj(brand3.id);
        
        GT_ProductDetailController.getFields(brand4.id);
        GT_ProductDetailController.getParentObj(brand4.id);
        
        GT_ProductDetailController.getFields(brand5.id);
        GT_ProductDetailController.getParentObj(brand5.id);
        
        GT_ProductDetailController.getFields(brand6.id);
        GT_ProductDetailController.getParentObj(brand6.id);
        
        GT_ProductDetailController.getFields(brand7.id);
        GT_ProductDetailController.getParentObj(brand7.id);
        
        GT_ProductDetailController.getFields(brand8.id);
        GT_ProductDetailController.getParentObj(brand8.id);
        
        /*GT_ProductDetailController.getFields(sportingEvent.id);
        GT_ProductDetailController.getParentObj(sportingEvent.id);
        
        GT_ProductDetailController.getFields(membership.id);
        GT_ProductDetailController.getParentObj(membership.id);*/
    }

}