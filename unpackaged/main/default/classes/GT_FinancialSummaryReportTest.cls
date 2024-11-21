@isTest
public class GT_FinancialSummaryReportTest {
    
    static testMethod void GT_FinancialSummaryReport()
    {
        Test.StartTest();
        
        GT_Event__c event = new GT_Event__c();
        GT_Brand__c br = new GT_Brand__c();
        GT_Exhibit__c ex = new GT_Exhibit__c();
        
        event.Exhibit_Close_Date__c=Date.parse('12/05/2017');
        event.Exhibit_Open_Date__c=Date.parse('02/12/2017');
        event.Name_of_Event__c='testEvent';
        event.Event_Website__c='www.google.com';
        event.Shipping_City__c = 'NewYork';
        event.Shipping_State_Province__c = 'Buffalo';
        event.Shipping_Country__c = 'United States';
        insert event;
        
        ex.Exhibit_Name__c = 'testExhibit';
        ex.Booth_Length__c=245;
        ex.Booth_Number__c='234';
        ex.GES_Connect_Event__c=event.id;
        insert ex;
        
        GT_Sponsorship__c sp=new GT_Sponsorship__c();
        sp.Sponsorship_Name__c='testSponsorship';
        sp.GES_Connect_Event__c=event.id;
        insert sp;
        
        GT_Speaking_Engagement__c se = new GT_Speaking_Engagement__c();
        se.Speaking_Engagement_Type__c ='Sales session';
        se.GES_Connect_Event__c=event.id;
        insert se;
        
        GT_Meeting_Room__c mr = new GT_Meeting_Room__c();
        mr.Meeting_Room_Name__c = 'testMeetingRoom';
        mr.Meeting_Room_Use__c = 'Work Room';
        mr.GES_Connect_Event__c=event.id;
        insert mr;
        
        GT_Event_RL__c ev = new GT_Event_RL__c();
        ev.Event_Room_Name__c = 'testRoom';
        ev.Event_Type__c = 'Internal';
        ev.GES_Connect_Event__c = event.id;
        insert ev;
        
        GT_Reg_Attend_Only__c ra = new GT_Reg_Attend_Only__c();
        ra.Reg_Attend_Name__c = 'testra';
        ra.GES_Connect_Event__c=event.id;
        insert ra;
        
        GT_Sporting_Event__c spe = new GT_Sporting_Event__c();
        spe.Sporting_event_Name__c = 'Test Sporting Event';
		spe.Sporting_Event_Type__c = 'Suite';
        spe.GES_Connect_Event__c = event.id;
        insert spe;
        
        GT_Membership__c mem = new GT_Membership__c();
        mem.Membership_Name__c = 'Test Membership';
        mem.GES_Connect_Event__c = event.id;
        insert mem;
        
        GT_Meeting_Planning__c mpl = new GT_Meeting_Planning__c();
        mpl.GES_Connect_Event__c = event.id;
        mpl.Meeting_Planning_Name__c = 'Test';
        insert mpl;        
        
        br.GES_Connect_Event__c = event.id;
        br.Booth_Space_Cost_Actual__c = 500;
        br.Booth_Space_Cost_Estimated__c = 1000;
        br.GES_Costs_Actual__c = 1000;
        br.GES_Costs_Estimated__c = 1500;
        br.Sponsorship_Cost_Actual_CrownCastle__c = 50;
        br.Sponsorship_Cost_Estimated_CrownCastle__c = 100;
        br.Speaker_Cost_Actual_CrownCastle__c = 400;
        br.Speaker_Cost_Estimated_CrownCastle__c = 100;
        br.Meeting_Room_Cost_Actual_CrownCastle__c = 800;
        br.Meeting_Room_Cost_Estimated_CrownCastle__c = 600;
        br.Meeting_Room_Services_Cost_Actual_CC__c = 100;
        br.Meeting_Room_Services_Cost_Estimated_CC__c = 50;
        br.Exhibit__c = ex.Id;
        br.Sponsorship__c = sp.Id;
        br.Speaking_Engagement__c = se.Id;
        br.Meeting_Room__c = mr.Id;
        br.Event__c = ev.Id;
        br.Meeting_Planning__c = mpl.Id;
        br.Sporting_Event__c = spe.Id;
        br.Membership__c = mem.Id;
        br.Registration_Attend_Only__c = ra.Id;
        insert br;
        
        GT_FinancialSummaryReport.getConnectSettings();
        GT_FinancialSummaryReport.getExhibitDetails(event.Id);
        
        Test.setCurrentPageReference(new PageReference('Page.GT_FinancialSummaryReport'));
        System.currentPageReference().getParameters().put('recordId', event.id);
        ApexPages.StandardController sc=new ApexPages.StandardController(event);
        GT_FinancialSummaryReport gtFscr=new GT_FinancialSummaryReport(sc); 
        
        List<GT_Exhibit__c> exhibitlst = [Select Name,Exhibit_Name__c,(select Name,Brand_Name__c,Booth_Space_Cost_Actual__c,Booth_Space_Cost_Estimated__c
                                                                       from Brands__r) from GT_Exhibit__c where GES_Connect_Event__c=:event.Id];
        
        system.assertEquals(gtFscr.dispWrapper.size(), 1);       
        Test.stopTest();
    }
}