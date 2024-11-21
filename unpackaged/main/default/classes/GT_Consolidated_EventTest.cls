@isTest
public class GT_Consolidated_EventTest {
   @testSetup static void setup() {
        GT_Event__c shw=new GT_Event__c(Shipping_City__c='Test',Shipping_State_Province__c='Test',Name_of_Event__c='Test Event',
                                        Event_Start_Date__c=Date.today(),Event_End_Date__c=Date.today()+3);
        insert shw; 
        GT_Event__c shw2=new GT_Event__c(Shipping_City__c='Test',Shipping_State_Province__c='Test',Name_of_Event__c='Test Event',
                                        Event_Start_Date__c=Date.today(),Event_End_Date__c=Date.today()+3);
        insert shw2; 
        GT_Exhibit__c ex=new GT_Exhibit__c(Project_Manager_CrownCastle__c='Juanita Timney', GES_Connect_Event__c = shw.Id, Contacts_Made__c=10);
        insert ex;
       	GT_Exhibit__c ex2=new GT_Exhibit__c(Project_Manager_CrownCastle__c='Juanita Timney', GES_Connect_Event__c = shw.Id, Contacts_Made__c=100);
        insert ex2;
        GT_Sponsorship__c sp=new GT_Sponsorship__c(Project_Manager_CrownCastle__c='Juanita Timney', GES_Connect_Event__c = shw.Id);
        insert sp;
        GT_Speaking_Engagement__c spk=new GT_Speaking_Engagement__c(Project_Manager_CrownCastle__c='Juanita Timney', GES_Connect_Event__c = shw.Id);
        insert spk;
        GT_Meeting_Room__c mtng=new GT_Meeting_Room__c(Project_Manager__c='Juanita Timney', GES_Connect_Event__c = shw.Id);
        insert mtng;
        GT_Event_RL__c evt=new GT_Event_RL__c(Project_Manager_CrownCastle__c='Juanita Timney', GES_Connect_Event__c = shw.Id,Event_Room_Name__c='Test');
        insert evt;
        GT_Reg_Attend_Only__c rg=new GT_Reg_Attend_Only__c(Project_Manager_CrownCastle__c='Juanita Timney', GES_Connect_Event__c = shw.Id,Names_of_Attendees__c='Test');
        insert rg;
        GT_Sporting_Event__c sprt=new GT_Sporting_Event__c(CC_Project_Manager__c='Juanita Timney', GES_Connect_Event__c = shw.Id,Sporting_Event_Type__c='Suite');
        insert sprt;
        GT_Membership__c member=new GT_Membership__c(CC_Project_Manager__c='Juanita Timney', GES_Connect_Event__c = shw.Id);
       insert member;
       GT_Brand__c brand=new GT_Brand__c(GES_Connect_Event__c=shw.Id,Exhibit__c=ex.Id,Booth_Space_Cost_Actual__c=20,
                                         Booth_Space_Cost_Estimated__c=40,GES_Costs_Estimated__c=30,GES_Costs_Actual__c=40,
                                        Sponsorship__c=sp.Id,Speaking_Engagement__c=spk.Id,Meeting_Room__c=mtng.Id,Event__c=evt.Id,
                                        Registration_Attend_Only__c=rg.id,Sporting_Event__c=sprt.Id,Membership__c=member.Id,Sales_Leaders__c='Fagan');
        insert brand;
    }
    Public Static Testmethod void test(){
        //GT_Consolidated_Event evt=new GT_Consolidated_Event();
         GT_Consolidated_Event.fetchReports(null,null,null,null,null);
         GT_Consolidated_Event.fetchReports(string.valueOfGmt(Date.today()),string.valueOfGmt(Date.today()+3),'Fagan', 'No', 'No');
    }
    
    @isTest
     static void testInit(){
         GT_Consolidated_Event.init();
    }
    
}