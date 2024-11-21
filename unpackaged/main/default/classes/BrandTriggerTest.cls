@isTest
public class BrandTriggerTest {
    
    
    
        static List<Brand__c> listofBrands = new List<Brand__c>();
        static List<Brand__c> listofBrands1 = new List<Brand__c>();
        static List<Exhibit__c> listExhibit = new List<Exhibit__c>();
        static Exhibit__c ex = new Exhibit__c();
        static List<Sponsorship__c> listSponsorship = new List<Sponsorship__c>();
        static Sponsorship__c sp = new Sponsorship__c();
        static List<Product_Theater__c> listProduct_Theater= new List<Product_Theater__c>();
        static Product_Theater__c pt = new Product_Theater__c();
        static List<Symposia__c> listSymposia= new List<Symposia__c>();
        static Symposia__c sy = new Symposia__c();
        static List<Meeting_Room__c> listMeeting_Room= new List<Meeting_Room__c>();
        static Meeting_Room__c mr = new Meeting_Room__c();
    

    public static testMethod void testMethod1() {
        
        
        GC_Connect2_Show__c cgs=new GC_Connect2_Show__c();   
        cgs.Show_Start_Date__c=Date.parse('3/4/2015');
        cgs.Show_End_Date__c=Date.parse('3/4/2015');
        insert cgs; 
        
        GES_Connect_Corporate_Accounts__c  gca=new GES_Connect_Corporate_Accounts__c();  
        gca.Name_of_Congress__c='Test';
        gca.Shipping_Street_c__c='Bangalore';
        gca.Show_Name__c=cgs.id;
        gca.Association_Contact_Name__c='Test';
        gca.Association_Name__c='Test';
        insert gca;  
        

        ex.Booth_Length__c = 10;
        ex.Booth_Width__c = 10;
        ex.Exhibit_Name__c = 'Test';
        ex.Activity_Level__c = '1';
        ex.Congress_Lead__c='n/a';
        ex.GES_Congress_Manager__c='n/a';
        ex.Activity_Type_Exhibit_Instance_c__c =  gca.Id;
        listExhibit.add(ex);
        insert listExhibit;
        
        
        sp.Sponsorship_Name__c = 'Test';
        sp.Activity_Level__c = '1';
        sp.Exhibit_Bundled_with_Sponsorsip__c = true;
        sp.Sponsorship__c= gca.Id;
        sp.Congress_Lead__c='n/a';
        sp.GES_Congress_Manager__c='n/a';
        listSponsorship.add(sp);
        insert listSponsorship;
        
        
        pt.Product_Theater_Name__c = 'Test';
        pt.Activity_Level__c = '1';
        pt.Congress__c = gca.Id;
        pt.Congress_Lead__c='n/a';
        pt.GES_Congress_Manager__c='n/a';
        listProduct_Theater.add(pt);
        insert listProduct_Theater;
        
        
        sy.Symposia_Name__c = 'Test';
        sy.Activity_Level__c = '1';
        sy.Congress__c = gca.Id;
        sy.Congress_Lead__c='n/a';
        sy.GES_Congress_Manager__c='n/a';
        sy.GES_Account_Manager__c='Amy Gerrard';
        listSymposia.add(sy);
        insert listSymposia;
        
        mr.Meeting_Room_Name__c = 'Test';
        mr.Activity_Level__c = '1';
        mr.Congress__c = gca.Id;
        mr.Congress_Lead__c='n/a';
        mr.GES_Congress_Manager__c='n/a';
        listMeeting_Room.add(mr);
        insert listMeeting_Room;
        

        Brand__c br1 = new Brand__c();
        br1.Brand_Name__c = 'Test';
        br1.GES_Congress_Manager__c = 'McCartney, Eva';
        br1.Meeting_Room__c =mr.Id;
        br1.GES_Connect_Corporate_Accounts__c = gca.Id;
        listofBrands.add(br1);
        Brand__c br2 = new Brand__c();
        br2.Brand_Name__c = 'Test';
        br2.GES_Congress_Manager__c = 'McCartney, Eva';
        br2.Meeting_Room__c =mr.Id;
        br2.GES_Connect_Corporate_Accounts__c = gca.Id;
        listofBrands1.add(br2);
        
        Brand__c br3 = new Brand__c();
        br3.Brand_Name__c = 'Test';
        br3.GES_Congress_Manager__c = 'McCartney, Eva';
        br3.Symposia__c = sy.Id;
        br3.GES_Connect_Corporate_Accounts__c = gca.Id;
        listofBrands.add(br3);
        Brand__c br4 = new Brand__c();
        br4.Brand_Name__c = 'Test';
        br4.GES_Congress_Manager__c = 'McCartney, Eva';
        br4.Symposia__c = sy.Id;
        br4.GES_Connect_Corporate_Accounts__c = gca.Id;
        listofBrands1.add(br4);
        
        Brand__c br5 = new Brand__c();
        br5.Brand_Name__c = 'Test';
        br5.GES_Congress_Manager__c = 'McCartney, Eva';
        br5.Product_Theater__c = pt.Id;
        br5.GES_Connect_Corporate_Accounts__c = gca.Id;
        listofBrands.add(br5);
        Brand__c br6 = new Brand__c();
        br6.Brand_Name__c = 'Test';
        br6.GES_Congress_Manager__c = 'McCartney, Eva';
        br6.Product_Theater__c = pt.Id;
        br6.GES_Connect_Corporate_Accounts__c = gca.Id;
        listofBrands1.add(br6);
        
        Brand__c br7 = new Brand__c();
        br7.Brand_Name__c = 'Test';
        br7.GES_Congress_Manager__c = 'McCartney, Eva';
        br7.Sponsorship__c = sp.Id;
        br7.GES_Connect_Corporate_Accounts__c = gca.Id;
        listofBrands.add(br7);
        Brand__c br8 = new Brand__c();
        br8.Brand_Name__c = 'Test';
        br8.GES_Congress_Manager__c = 'McCartney, Eva';
        br8.Sponsorship__c = sp.Id;
        br8.GES_Connect_Corporate_Accounts__c = gca.Id;
        listofBrands1.add(br8);
        
        Brand__c br9 = new Brand__c();
        br9.Brand_Name__c = 'Test';
        br9.GES_Congress_Manager__c = 'McCartney, Eva';
        br9.Exhibit_Instance__c = ex.Id;
        br9.GES_Connect_Corporate_Accounts__c = gca.Id;
        listofBrands.add(br9);
        Brand__c br10 = new Brand__c();
        br10.Brand_Name__c = 'Test';
        br10.GES_Congress_Manager__c = 'McCartney, Eva';
        br10.Exhibit_Instance__c = ex.Id;
        br10.GES_Connect_Corporate_Accounts__c = gca.Id;
        listofBrands1.add(br10);
        insert listofBrands;
        insert listofBrands1;
        for(Brand__c varB:listofBrands){
        varB.Canceled__c =true; 
        }
        update listofBrands;
        System.assertEquals(false, ex.Canceled__c);
        System.assertEquals(false, sp.Canceled__c);
        System.assertEquals(false, sy.Canceled__c);
        System.assertEquals(false, mr.Canceled__c);
        System.assertEquals(false, pt.Canceled__c);
        for(Brand__c varA:listofBrands1){
        varA.Canceled__c =true; 
        }
        update listofBrands1;
    }
}