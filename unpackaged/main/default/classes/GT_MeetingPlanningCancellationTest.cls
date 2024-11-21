@isTest
public class GT_MeetingPlanningCancellationTest {
    public static testMethod void testMethod1() {
        GC_Connect2_Show__c cgs=new GC_Connect2_Show__c();   
        cgs.Show_Start_Date__c=Date.parse('3/4/2015');
        cgs.Show_End_Date__c=Date.parse('3/4/2015');
        insert cgs; 
        
        GT_Event__c  evt=new GT_Event__c();  
        evt.Name_of_Event__c='Test';
        evt.Show_Name__c=cgs.id;
        insert evt;  
        
        List<GT_Meeting_Planning__c> meetingRoomList = new List<GT_Meeting_Planning__c>();
        GT_Meeting_Planning__c mtng = new GT_Meeting_Planning__c();
       
        mtng.GES_Connect_Event__c =  evt.Id;
        
        GT_Meeting_Planning__c mtng1 = new GT_Meeting_Planning__c();
       
        mtng1.Canceled__c = true;//
        mtng1.Cancellation_Date__c=Date.today();
        mtng1.GES_Connect_Event__c =  evt.Id;
        meetingRoomList.add(mtng);
        meetingRoomList.add(mtng1);
        insert meetingRoomList;
        
        GT_Brand__c bd = new GT_Brand__c();
        bd.Meeting_Planning__c = mtng.Id;
        bd.GES_Connect_Event__c = evt.Id;
        insert bd;
        
        mtng.Canceled__c = true;
         mtng.Cancellation_Date__c=Date.today();
        update mtng;
        delete mtng;
    }

}