@isTest
public class ExhibitScheduleReportTest{
    static Testmethod void ExhibitScheduleReport()
    {
        GC_Connect2_Show__c cgs=new GC_Connect2_Show__c();   
        cgs.Show_Start_Date__c=Date.parse('3/4/2015');
        cgs.Show_End_Date__c=Date.parse('3/4/2015');
        insert cgs;
        
        Brand__c br=new Brand__c(); 
        Exhibit__c ex = new Exhibit__c();     
        ApexPages.StandardController sc=new ApexPages.StandardController(br);   
        GES_Connect_Corporate_Accounts__c gs=new GES_Connect_Corporate_Accounts__c();
        gs.Exhibit_Close_Date__c=Date.parse('12/05/2017');
        gs.Exhibit_Open_Date__c=Date.parse('02/12/2017');
        gs.Acronym_of_Congress__c='as';
        gs.Name_of_Congress__c='test';
        insert gs;
        ex.Activity_Level__c='2';
        ex.Booth_Length__c=245;
        ex.Booth_Number__c='234';
        ex.Activity_Type_Exhibit_Instance_c__c=gs.id;
        insert ex;
        
        br.Brand_Name__c='Eucrisa';
        br.GES_Congress_Manager__c='Purcell';
        br.Exhibit_Instance__c=ex.id;
       
        insert br;
        
        GES_Connect_Corporate_Accounts__c  gca=new GES_Connect_Corporate_Accounts__c();  
        gca.Name_of_Congress__c='Test';
        gca.Shipping_Street_c__c='Bangalore';
        gca.Show_Name__c=cgs.id;
        insert gca;   
        List<Exhibit__c> listExhibit = new List<Exhibit__c>();
       
        Exhibit__c ex2 = new Exhibit__c();
        ex2.Booth_Length__c = 10;
        ex2.Booth_Width__c = 10;
        ex2.Exhibit_Name__c = 'Test';
        ex2.Activity_Level__c = '1';
        ex2.Canceled__c = True;
        ex2.Activity_Type_Exhibit_Instance_c__c =  gca.Id;
        listExhibit.add(ex2);
        insert listExhibit;
        
        ExhibitScheduleReport exShRt=new ExhibitScheduleReport(sc);
        exShRt.beginning();
        exShRt.save();
        exShRt.back();
        exShRt.ExhibitschDatabrand();
        //ExhibitScheduleReport.exportExcelReport('2017-12-05', '2017-12-02');
        ExhibitScheduleReport.exportExcelReport('', '');
        
        
        }
    static Testmethod void ExhibitScheduleReport1()
    {
        GC_Connect2_Show__c cgs=new GC_Connect2_Show__c();   
        cgs.Show_Start_Date__c=Date.parse('3/4/2015');
        cgs.Show_End_Date__c=Date.parse('3/4/2015');
        insert cgs;
        
        Brand__c br=new Brand__c(); 
        Sponsorship__c sp = new Sponsorship__c();    
        ApexPages.StandardController sc=new ApexPages.StandardController(sp);   
        GES_Connect_Corporate_Accounts__c gs=new GES_Connect_Corporate_Accounts__c();
        gs.Exhibit_Close_Date__c=Date.parse('12/05/2017');
        gs.Exhibit_Open_Date__c=Date.parse('02/12/2017');
        gs.Acronym_of_Congress__c='as';
        gs.Name_of_Congress__c='test';
        insert gs;
        sp.Activity_Level__c='2';
      
        insert sp;
        
        br.Brand_Name__c='Eucrisa';
        br.GES_Congress_Manager__c='Purcell';
        br.Sponsorship__c=sp.id;
       
        insert br;
        
        GES_Connect_Corporate_Accounts__c  gca=new GES_Connect_Corporate_Accounts__c();  
        gca.Name_of_Congress__c='Test';
        gca.Shipping_Street_c__c='Bangalore';
        gca.Show_Name__c=cgs.id;
        insert gca;   
        List<Sponsorship__c> listSponsorship = new List<Sponsorship__c>();
       
        Sponsorship__c sp2 = new Sponsorship__c();
        sp2.Sponsorship_Name__c = 'Test';
        sp2.Activity_Level__c = '1';
        sp2.Canceled__c = True;
        sp2.Sponsorship__c= gca.Id; 
        listSponsorship.add(sp2);
        insert listSponsorship;
        
        ExhibitScheduleReport exShRt=new ExhibitScheduleReport(sc);
        exShRt.beginning();
        exShRt.save();
        exShRt.back();
        exShRt.ExhibitschDatabrand();
        //ExhibitScheduleReport.exportExcelReport('2017-12-05', '2017-12-02');
        ExhibitScheduleReport.exportExcelReport('', '');
           
        }
    
      static Testmethod void ExhibitScheduleReport2()
    {
        GC_Connect2_Show__c cgs=new GC_Connect2_Show__c();   
        cgs.Show_Start_Date__c=Date.parse('3/4/2015');
        cgs.Show_End_Date__c=Date.parse('3/4/2015');
        insert cgs;
        
        Brand__c br=new Brand__c(); 
        Product_Theater__c pt = new Product_Theater__c();    
        ApexPages.StandardController sc=new ApexPages.StandardController(pt);   
        GES_Connect_Corporate_Accounts__c gs=new GES_Connect_Corporate_Accounts__c();
        gs.Exhibit_Close_Date__c=Date.parse('12/05/2017');
        gs.Exhibit_Open_Date__c=Date.parse('02/12/2017');
        gs.Acronym_of_Congress__c='as';
        gs.Name_of_Congress__c='test';
        insert gs;
        pt.Activity_Level__c='2';
      
        insert pt;
        
        br.Brand_Name__c='Eucrisa';
        br.GES_Congress_Manager__c='Purcell';
        br.Product_Theater__c=pt.id;
       
        insert br;
        
        GES_Connect_Corporate_Accounts__c  gca=new GES_Connect_Corporate_Accounts__c();  
        gca.Name_of_Congress__c='Test';
        gca.Shipping_Street_c__c='Bangalore';
        gca.Show_Name__c=cgs.id;
        insert gca;   
        List<Product_Theater__c> listProduct_Theater = new List<Product_Theater__c>();
       
        Product_Theater__c pt2 = new Product_Theater__c();
        pt2.Product_Theater_Name__c = 'Test';
        pt2.Activity_Level__c = '1';
        pt2.Canceled__c = True;
        pt2.Congress__c= gca.Id; 
        listProduct_Theater.add(pt2);
        insert listProduct_Theater;
        
        ExhibitScheduleReport exShRt=new ExhibitScheduleReport(sc);
        exShRt.beginning();
        exShRt.save();
        exShRt.back();
        exShRt.ExhibitschDatabrand();
        //ExhibitScheduleReport.exportExcelReport('2017-12-05', '2017-12-02');
        ExhibitScheduleReport.exportExcelReport('', '');
           
        }
       static Testmethod void ExhibitScheduleReport3()
    {
        GC_Connect2_Show__c cgs=new GC_Connect2_Show__c();   
        cgs.Show_Start_Date__c=Date.parse('3/4/2015');
        cgs.Show_End_Date__c=Date.parse('3/4/2015');
        insert cgs;
        
        Brand__c br=new Brand__c(); 
        Symposia__c sy = new Symposia__c();    
        ApexPages.StandardController sc=new ApexPages.StandardController(sy);   
        GES_Connect_Corporate_Accounts__c gs=new GES_Connect_Corporate_Accounts__c();
        gs.Exhibit_Close_Date__c=Date.parse('12/05/2017');
        gs.Exhibit_Open_Date__c=Date.parse('02/12/2017');
        gs.Acronym_of_Congress__c='as';
        gs.Name_of_Congress__c='test';
        insert gs;
        sy.Activity_Level__c='2';
      
        insert sy;
        
        br.Brand_Name__c='Eucrisa';
        br.GES_Congress_Manager__c='Purcell';
        br.Symposia__c=sy.id;
       
        insert br;
        
        GES_Connect_Corporate_Accounts__c  gca=new GES_Connect_Corporate_Accounts__c();  
        gca.Name_of_Congress__c='Test';
        gca.Shipping_Street_c__c='Bangalore';
        gca.Show_Name__c=cgs.id;
        insert gca;   
        List<Symposia__c> listSymposia = new List<Symposia__c>();
       
        Symposia__c sy2 = new Symposia__c();
        sy2.Symposia_Name__c = 'Test';
        sy2.Activity_Level__c = '1';
        sy2.Canceled__c = True;
        sy2.Congress__c= gca.Id; 
        listSymposia.add(sy2);
        insert listSymposia;
        
        ExhibitScheduleReport exShRt=new ExhibitScheduleReport(sc);
        exShRt.beginning();
        exShRt.save();
        exShRt.back();
        exShRt.ExhibitschDatabrand();
        //ExhibitScheduleReport.exportExcelReport('2017-12-05', '2017-12-02');
        ExhibitScheduleReport.exportExcelReport('', '');
           
        }
     static Testmethod void ExhibitScheduleReport4()
    {
        GC_Connect2_Show__c cgs=new GC_Connect2_Show__c();   
        cgs.Show_Start_Date__c=Date.parse('3/4/2015');
        cgs.Show_End_Date__c=Date.parse('3/4/2015');
        insert cgs;
        
        Brand__c br=new Brand__c(); 
        Meeting_Room__c mr = new Meeting_Room__c();    
        ApexPages.StandardController sc=new ApexPages.StandardController(mr);   
        GES_Connect_Corporate_Accounts__c gs=new GES_Connect_Corporate_Accounts__c();
        gs.Exhibit_Close_Date__c=Date.parse('12/05/2017');
        gs.Exhibit_Open_Date__c=Date.parse('02/12/2017');
        gs.Acronym_of_Congress__c='as';
        gs.Name_of_Congress__c='test';
        insert gs;
        mr.Activity_Level__c='2';
      
        insert mr;
        
        br.Brand_Name__c='Eucrisa';
        br.GES_Congress_Manager__c='Purcell';
        br.Meeting_Room__c=mr.id;
       
        insert br;
        
        GES_Connect_Corporate_Accounts__c  gca=new GES_Connect_Corporate_Accounts__c();  
        gca.Name_of_Congress__c='Test';
        gca.Shipping_Street_c__c='Bangalore';
        gca.Show_Name__c=cgs.id;
        insert gca;   
        List<Meeting_Room__c> listMeeting_Room = new List<Meeting_Room__c>();
       
        Meeting_Room__c mr2 = new Meeting_Room__c();
        mr2.Meeting_Room_Name__c = 'Test';
        mr2.Activity_Level__c = '1';
        mr2.Canceled__c = True;
        mr2.Congress__c= gca.Id;
        listMeeting_Room.add(mr2);
        insert listMeeting_Room;
        
        ExhibitScheduleReport exShRt=new ExhibitScheduleReport(sc);
        exShRt.beginning();
        exShRt.save();
        exShRt.back();
        exShRt.ExhibitschDatabrand();
        //ExhibitScheduleReport.exportExcelReport('2017-12-05', '2017-12-02');
        ExhibitScheduleReport.exportExcelReport('', '');
           
        }
    

}