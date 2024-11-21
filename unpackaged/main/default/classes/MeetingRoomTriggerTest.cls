@isTest
public class MeetingRoomTriggerTest {
    public static testMethod void testMethod1() {
        GC_Connect2_Show__c cgs=new GC_Connect2_Show__c();   
        cgs.Show_Start_Date__c=Date.parse('3/4/2015');
        cgs.Show_End_Date__c=Date.parse('3/4/2015');
        insert cgs; 
        
        GES_Connect_Corporate_Accounts__c  gca=new GES_Connect_Corporate_Accounts__c();  
        gca.Name_of_Congress__c='Test';
        gca.Shipping_Street_c__c='Bangalore';
        gca.Show_Name__c=cgs.id;
        gca.Housing_Logistics_Vendor__c = 'BCD Travel';
        gca.Number_of_rooms_Secured__c = 6;
        gca.Association_Contact_Name__c='SLK Soft';
        gca.Association_Name__c='rksinha';
        insert gca;  
        
        List<Meeting_Room__c> listExhibit = new List<Meeting_Room__c>();
        Meeting_Room__c ex = new Meeting_Room__c();
       
      
        ex.Congress__c		 =  gca.Id;
        ex.Congress_Lead__c='Don Schmid';
        ex.GES_Congress_Manager__c='Debbie Hummel';
        Meeting_Room__c ex1 = new Meeting_Room__c();
         ex1.Canceled__c = true;
		ex1.Congress_Lead__c='Don Schmid';
        ex1.GES_Congress_Manager__c='Debbie Hummel';
        ex1.Congress__c	 =  gca.Id;
        listExhibit.add(ex);
        listExhibit.add(ex1);
        insert listExhibit;
        
        Brand__c b5 = new Brand__c();
        b5.Brand_Name__c = 'Test';
        b5.GES_Congress_Manager__c = 'McCartney, Eva';
        b5.Meeting_Room__c = ex.Id;
        b5.Brand_Category__c='Oncology';
        b5.Business_Unit__c='IM';
        b5.GES_Connect_Corporate_Accounts__c = gca.Id;
        insert b5;
        
        ex.Canceled__c = true;
        update ex;
    }

}