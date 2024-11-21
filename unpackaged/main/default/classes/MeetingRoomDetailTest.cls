@isTest
Public Class MeetingRoomDetailTest{
    Public Static Testmethod void MeetingRoomDetail()
    {          
        GC_Connect2_Show__c cgs=new GC_Connect2_Show__c();   
        cgs.Show_Start_Date__c=Date.parse('3/4/2015');
        cgs.Show_End_Date__c=Date.parse('3/4/2015');
        insert cgs; 
        
        GES_Connect_Corporate_Accounts__c  gca=new GES_Connect_Corporate_Accounts__c();  
        gca.Name_of_Congress__c='Test';
        gca.Shipping_Street_c__c='Bangalore';
        gca.Shipping_Country__c = 'US';
        gca.Show_Name__c=cgs.id;
        gca.Association_Contact_Name__c='SLK Soft';
        gca.Association_Name__c='rksinha';
        gca.Housing_Logistics_Vendor__c = 'BCD Travel';
        gca.Number_of_rooms_Secured__c = 5;
        gca.Number_of_rooms_to_Secure__c = 6;
        insert gca;  
        
        Meeting_Room__c mr=new Meeting_Room__c();  
        mr.Congress__c = gca.id;
        mr.Meeting_Room_Name__c ='Test Meeting room 001';
        mr.Activity_Level__c='4';
        mr.GES_Congress_Manager__c='n/a';
        mr.Congress_Lead__c='n/a';
        insert mr;
        
        //mr.Id='12233455';
        MeetingRoomDetail mtdr=new MeetingRoomDetail();
        mtdr.mrid =mr.id;
        /*
GES_Connect_Corporate_Accounts__c  gca=new GES_Connect_Corporate_Accounts__c();  
gca.Name_of_Congress__c='Test';
gca.Acronym_of_Congress__c = 'TEST';
gca.Exhibit_Open_Date__c = Date.Today();
gca.Exhibit_Close_Date__c = Date.Today();
gca.Facility_Name__c = 'Test';
gca.Shipping_City__c = 'Atlanta';
gca.Shipping_Street_c__c='Bangalore';
gca.Shipping_Zip_Postal_Code__c = '23';
insert gca; 
*/
        mtdr.MeetingRoomNewBrand();
        mtdr.MeetingRoomSave();
        mtdr.MeetingRoomcancel();     
        mtdr.getmr();
        mtdr.BrandList();
        mtdr.MeetingRoomData();
        mtdr.CongressDetail();
        mtdr.MeetingRoomClone();
        
        
        
    }
}