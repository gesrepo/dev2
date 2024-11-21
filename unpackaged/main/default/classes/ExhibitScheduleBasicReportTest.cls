@isTest
public class ExhibitScheduleBasicReportTest
{    
    static TestMethod void ExhibitScheduleBasicReport()
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
        gs.shipping_city__c='Cincinatti';
        gs.shipping_state_province__c='Test State';
        gs.shipping_country__c='test Country';
        gs.facility_name__c='test Faci';
        gs.Advanced_Warehouse_Location_Name__c='test';   
        gs.Name_of_Congress__c='test';
        gs.Association_Name__c='Test';
        gs.Association_Contact_Name__c='test1';
       
        insert gs;
        ex.Activity_Level__c='2';
        ex.Booth_Length__c=245;
        ex.Booth_Number__c='234';
        ex.Activity_Type_Exhibit_Instance_c__c=gs.id;
         ex.Congress_Lead__c='n/a';
        ex.GES_Congress_Manager__c='n/a';
        insert ex;
        
        br.Brand_Name__c='Eucrisa';
        br.GES_Congress_Manager__c='Purcell';
        br.Exhibit_Instance__c=ex.id;
        br.Congress_Lead__c='n/a';
        insert br;
        
        GES_Connect_Corporate_Accounts__c  gca=new GES_Connect_Corporate_Accounts__c();  
        gca.Name_of_Congress__c='Test';
        gca.Shipping_Street_c__c='Bangalore';
        gca.Show_Name__c=cgs.id;
        gca.Association_Name__c='Test';
        gca.Association_Contact_Name__c='test1';
       
        insert gca;   
        List<Exhibit__c> listExhibit = new List<Exhibit__c>();
              
        Exhibit__c ex2 = new Exhibit__c();
        ex2.Booth_Length__c = 10;
        ex2.Booth_Width__c = 10;
        ex2.Exhibit_Name__c = 'Test';
        ex2.Activity_Level__c = '1';
        ex2.Canceled__c = true;
        ex2.Congress_Lead__c='n/a';
        ex2.GES_Congress_Manager__c='n/a';
        ex2.Activity_Type_Exhibit_Instance_c__c =  gca.Id;
       
        listExhibit.add(ex2);
        insert listExhibit;
        
        ExhibitScheduleBasicReport exShBsRt=new ExhibitScheduleBasicReport();
        ExhibitScheduleBasicReport.getOnLoad();
        exShBsRt.back();
        exShBsRt.save();
        ExhibitScheduleBasicReport.next();
        ExhibitScheduleBasicReport.previous();
        ExhibitScheduleBasicReport.ExhibitSchData('2018-12-05', '2018-12-02');
        ExhibitScheduleBasicReport.exportExcelReport('2017-12-05', '2017-12-02');
        ExhibitScheduleBasicReport.todate=Date.today();
        ExhibitScheduleBasicReport.fromdate=Date.today();
    }
}