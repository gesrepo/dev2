@isTest
public class GT_EventRLCancellationTriggerTest {
    public static testMethod void testMethod1() {
        GC_Connect2_Show__c cgs=new GC_Connect2_Show__c();   
        cgs.Show_Start_Date__c=Date.parse('3/4/2015');
        cgs.Show_End_Date__c=Date.parse('3/4/2015');
        insert cgs; 
        
        GT_Event__c  evt=new GT_Event__c();  
        evt.Name_of_Event__c='Test';
        evt.Show_Name__c=cgs.id;
        
        insert evt;  
        
        List<GT_Event_RL__c> evList = new List<GT_Event_RL__c>();
        GT_Event_RL__c ev = new GT_Event_RL__c();
        
        ev.GES_Connect_Event__c =  evt.Id;
        ev.Event_Room_Name__c='Test';
        GT_Event_RL__c ev1 = new GT_Event_RL__c();
        
        ev1.Canceled__c = true;
        ev1.Event_Room_Name__c='Test';
        
        ev1.Cancellation_Date__c=Date.today();
        ev1.GES_Connect_Event__c =  evt.Id;
        evList.add(ev);
        evList.add(ev1);
        insert evList;
        
        GT_Brand__c bd = new GT_Brand__c();
        bd.Event__c = ev.Id;
        bd.GES_Connect_Event__c = evt.Id;
        insert bd;
        
        ev.Canceled__c = true;
        ev.Cancellation_Date__c=Date.today();
        update ev;
        
        delete ev;
    }
    
}