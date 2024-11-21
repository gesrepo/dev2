@isTest
public class GT_RegAttOnlyTriggerTest {
      public static testMethod void testMethod1() {
        GC_Connect2_Show__c cgs=new GC_Connect2_Show__c();   
        cgs.Show_Start_Date__c=Date.parse('3/4/2015');
        cgs.Show_End_Date__c=Date.parse('3/4/2015');
        insert cgs; 
        
        GT_Event__c  evt=new GT_Event__c();  
        evt.Name_of_Event__c='Test';
        evt.Show_Name__c=cgs.id;
        insert evt;  
        
        List<GT_Reg_Attend_Only__c> rgList = new List<GT_Reg_Attend_Only__c>();
        GT_Reg_Attend_Only__c rg = new GT_Reg_Attend_Only__c();
        
        rg.GES_Connect_Event__c =  evt.Id;
        rg.Names_of_Attendees__c='Test';
        GT_Reg_Attend_Only__c rg1 = new GT_Reg_Attend_Only__c();
        rg1.Names_of_Attendees__c='Test';
        rg1.Canceled__c = true;//
        rg1.Cancellation_Date__c=Date.today();//
        rg1.GES_Connect_Event__c =  evt.Id;
        rgList.add(rg);
        rgList.add(rg1);
        insert rgList;
        
        GT_Brand__c bd = new GT_Brand__c();
        bd.Registration_Attend_Only__c = rg.Id;//
        bd.GES_Connect_Event__c = evt.Id;
        insert bd;
        
        rg.Canceled__c = true;
        rg.Cancellation_Date__c=Date.today();
        update rg;
         delete rg;
    }   


}