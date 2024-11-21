@isTest
public class GT_ExhibitCancellationTriggerTest {
    public static testMethod void testMethod1() {
        GC_Connect2_Show__c cgs=new GC_Connect2_Show__c();   
        cgs.Show_Start_Date__c=Date.parse('3/4/2015');
        cgs.Show_End_Date__c=Date.parse('3/4/2015');
        insert cgs; 
        
        GT_Event__c  evt=new GT_Event__c();  
        evt.Name_of_Event__c='Test';
        evt.Show_Name__c=cgs.id;
        insert evt;  
        
        List<GT_Exhibit__c> listExhibit = new List<GT_Exhibit__c>();
        GT_Exhibit__c ex = new GT_Exhibit__c();
        ex.Booth_Length__c = 10;
        ex.Booth_Width__c = 10;
        ex.Exhibit_Name__c = 'Test';
        ex.GES_Connect_Event__c =  evt.Id;
        
        GT_Exhibit__c ex1 = new GT_Exhibit__c();
        ex1.Booth_Length__c = 10;
        ex1.Booth_Width__c = 10;
        ex1.Exhibit_Name__c = 'Test';//
        ex1.Canceled__c = true;//
        ex1.Cancellation_Date__c=Date.today();//
        ex1.GES_Connect_Event__c =  evt.Id;
        listExhibit.add(ex);
        listExhibit.add(ex1);
        insert listExhibit;
        
        GT_Brand__c bd = new GT_Brand__c();
        bd.Exhibit__c = ex.Id;//
        bd.GES_Connect_Event__c = evt.Id;
        insert bd;
        
        ex.Canceled__c = true;
         ex.Cancellation_Date__c=Date.today();
        update ex;
        delete ex;
        
    }

}