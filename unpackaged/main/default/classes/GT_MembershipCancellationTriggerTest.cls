@isTest
public class GT_MembershipCancellationTriggerTest {
       public static testMethod void testMethod1() {
        GC_Connect2_Show__c cgs=new GC_Connect2_Show__c();   
        cgs.Show_Start_Date__c=Date.parse('3/4/2015');
        cgs.Show_End_Date__c=Date.parse('3/4/2015');
        insert cgs; 
        
        GT_Event__c  evt=new GT_Event__c();  
        evt.Name_of_Event__c='Test';
        evt.Show_Name__c=cgs.id;
        insert evt;  
        
        List<GT_Membership__c> memberList = new List<GT_Membership__c>();
        GT_Membership__c member = new GT_Membership__c();
        
        member.GES_Connect_Event__c =  evt.Id;
        
        GT_Membership__c member1 = new GT_Membership__c();
        
        member1.Canceled__c = true;//
        member1.Cancellation_Date__c=Date.today();//
        member1.GES_Connect_Event__c =  evt.Id;
        memberList.add(member);
        memberList.add(member1);
        insert memberList;
        
        GT_Brand__c bd = new GT_Brand__c();
        bd.Membership__c = member.Id;//
        bd.GES_Connect_Event__c = evt.Id;
        insert bd;
        
        member.Canceled__c = true;
        member.Cancellation_Date__c=Date.today();
        update member;
           delete member;
    }   
}