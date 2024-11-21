@isTest
public class GT_SpeakingEngagementTest {
    public static testMethod void testMethod1() {
     GC_Connect2_Show__c cgs=new GC_Connect2_Show__c();   
        cgs.Show_Start_Date__c=Date.parse('3/4/2015');
        cgs.Show_End_Date__c=Date.parse('3/4/2015');
        insert cgs; 
        
        GT_Event__c  evt=new GT_Event__c();  
        evt.Name_of_Event__c='Test';
        evt.Show_Name__c=cgs.id;
        insert evt;  
        
        List<GT_Speaking_Engagement__c> seakList = new List<GT_Speaking_Engagement__c>();
        GT_Speaking_Engagement__c sp = new GT_Speaking_Engagement__c();
       
        
        sp.GES_Connect_Event__c =  evt.Id;
        
        GT_Speaking_Engagement__c sp1 = new GT_Speaking_Engagement__c();
       
       
        sp1.Canceled__c = true;
        sp1.Cancellation_Date__c=Date.today();
        sp1.GES_Connect_Event__c =  evt.Id;
        seakList.add(sp);
        seakList.add(sp1);
        insert seakList;
        
        GT_Brand__c bd = new GT_Brand__c();
        bd.Speaking_Engagement__c = sp.Id;
        bd.GES_Connect_Event__c = evt.Id;
        insert bd;
        
        sp.Canceled__c = true;
         sp.Cancellation_Date__c=Date.today();
        update sp;
        delete sp;
      }

}