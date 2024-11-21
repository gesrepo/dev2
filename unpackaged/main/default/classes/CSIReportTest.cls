@isTest
public class CSIReportTest{
    static Testmethod void CSIreport1()
    {
        GC_Connect2_Show__c cgs=new GC_Connect2_Show__c();   
        cgs.Show_Start_Date__c=Date.parse('3/4/2015');
        cgs.Show_End_Date__c=Date.parse('3/4/2015');
        insert cgs;
        
        
           
         
        GES_Connect_Corporate_Accounts__c gs=new GES_Connect_Corporate_Accounts__c();
        gs.Exhibit_Close_Date__c=Date.parse('12/05/2017');
        gs.Exhibit_Open_Date__c=Date.parse('02/12/2017');
        gs.Acronym_of_Congress__c='as';
        gs.Name_of_Congress__c='test';
        gs.CurrencyIsoCode='GBP';
        gs.Shipping_Street_c__c='Bangalore';
        gs.Show_Name__c=cgs.id;
        gs.Association_Contact_Name__c='Test';
        gs.Association_Name__c='Test';
        gs.Housing_Logistics_Vendor__c = 'BCD Travel';
        gs.Number_of_rooms_Secured__c = 5;
        gs.Number_of_rooms_to_Secure__c = 6;
        insert gs;   
        
        
       
        
        List<Exhibit__c> listExhibit = new List<Exhibit__c>();
        Exhibit__c ex = new Exhibit__c(); 
        ex.Activity_Level__c='2';
        ex.Booth_Length__c=245;
        ex.Booth_Number__c='234';
        ex.Activity_Type_Exhibit_Instance_c__c=gs.id;
        ex.Congress_Lead__c='n/a';
        ex.GES_Congress_Manager__c='n/a';
        listExhibit.add(ex);
        Exhibit__c ex2 = new Exhibit__c();
        ex2.Booth_Length__c = 10;
        ex2.Booth_Width__c = 10;
        ex2.Exhibit_Name__c = 'Test';
        ex2.Activity_Level__c = '1';
        ex2.Canceled__c = True;
        ex2.Activity_Type_Exhibit_Instance_c__c =  gs.Id;
        ex2.Congress_Lead__c='n/a';
        ex2.GES_Congress_Manager__c='n/a';
        listExhibit.add(ex2);
        
        insert listExhibit;
        
        Sponsorship__c sp=new Sponsorship__c();
        sp.Sponsorship_Name__c='test';
        sp.Sponsorship__c=gs.id;
        sp.Activity_Level__c = '1';
        sp.Congress_Lead__c='n/a';
        sp.GES_Congress_Manager__c='n/a';
        insert sp;
        
        Product_Theater__c pd=new Product_Theater__c();
        pd.Product_Theater_Name__c='test';
        pd.Congress__c=gs.id;
        pd.Activity_Level__c = '1';
        pd.Congress_Lead__c='n/a';
        pd.GES_Congress_Manager__c='n/a';
        insert pd;
        
        Symposia__c sy=new Symposia__c();
        sy.Symposia_Name__c='test';
        sy.Congress__c=gs.id;
        sy.Activity_Level__c = '1';
        sy.Congress_Lead__c='n/a';
        sy.GES_Congress_Manager__c='n/a';
        sy.GES_Account_Manager__c='n/a';
        insert sy;
        
        Meeting_Room__c mt=new Meeting_Room__c();
        mt.Meeting_Room_Name__c='test';
        mt.Congress__c=gs.id;
        mt.Activity_Level__c = '1';
        mt.Congress_Lead__c='n/a';
        mt.GES_Congress_Manager__c='n/a';
        mt.GES_Account_Manager__c='n/a';
        insert mt;
        
         Brand__c br=new Brand__c(); 
        br.Brand_Name__c='Eucrisa';
        br.GES_Congress_Manager__c='Purcell';
        
        br.Exhibit_Instance__c=ex.id;
        br.GES_Connect_Corporate_Accounts__c=gs.id;
        br.Sponsorship_Costs_Actual__c=4355;
        br.Sponsorship_Costs_Estimated__c=4000;
        br.Product_Theater_Costs_Actual__c=858;
        br.Product_Theater_Costs_Estimated__c=800;
        br.Symposia_Estimated_Cost__c=345;
        br.Symposia_Actual_Cost__c=300;
        br.Meeting_Room_Estimated_Cost__c=504;
        br.Meeting_Room_Actual_Cost__c=500;
        br.Symposia__c=sy.id;
        br.Sponsorship__c=sp.id;
        br.MR_Services_Estimated_Costs__c=1500;
        br.Product_Theater__c=pd.id;
        br.Meeting_Room__c=mt.id;
        br.Brand_Category__c = 'CenterOne';
        br.Business_Unit__c= 'CH';
        insert br;
        String userDate = String.valueOf(Date.Today());
        //insert br;
        Test.setCurrentPageReference(new PageReference('Page.CSI_Report'));
        System.currentPageReference().getParameters().put('id',gs.id);    
        System.currentPageReference().getParameters().put('userDate',userDate);
        ApexPages.StandardController sc=new ApexPages.StandardController(gs);   

        CSIreport csi=new CSIreport(sc);
        csi.congid= gs.Id;
        //List<CSIreport.summaryExhibit> list1=new List<CSIreport.summaryExhibit>();
        csi.save();
        //PageReference pr =csi.runReport();
      
        //list1= csi.getResults();
        //ExhibitScheduleReport.exportExcelReport('2017-12-05', '2017-12-02');
        //ExhibitScheduleReport.exportExcelReport('', '');
        
        
    }
   
    
}