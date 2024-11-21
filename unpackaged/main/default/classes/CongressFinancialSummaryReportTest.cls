@isTest
public class CongressFinancialSummaryReportTest
{
    static testMethod void CongressFinancialSummaryReport()
    {
        GES_Connect_Corporate_Accounts__c gs=new GES_Connect_Corporate_Accounts__c();
        Brand__c br=new Brand__c(); 
        Exhibit__c ex=new Exhibit__c(); 
        gs.Exhibit_Close_Date__c=Date.parse('12/05/2017');
        gs.Exhibit_Open_Date__c=Date.parse('02/12/2017');
        gs.Acronym_of_Congress__c='as';
        gs.Name_of_Congress__c='test';
        gs.Congress_Website__c='www.google.com';
        gs.Association_Name__c ='Mary';
        gs.Association_Contact_Name__c ='Jhonny';
        gs.Housing_Logistics_Vendor__c = 'BCD Travel';
        gs.Number_of_rooms_Secured__c = 5;
        gs.Number_of_rooms_to_Secure__c = 6;
        insert gs;
        ex.Activity_Level__c='2';
        ex.Booth_Length__c=245;
        ex.Booth_Number__c='234';
        ex.Activity_Type_Exhibit_Instance_c__c=gs.id;
        ex.Congress_Lead__c ='Don Schmid';
        ex.GES_Congress_Manager__c='Debbie Hummel';
        insert ex;
        Sponsorship__c sp=new Sponsorship__c();
        sp.Sponsorship_Name__c='test';
        sp.Sponsorship__c=gs.id;
        sp.Congress_Lead__c ='Don Schmid';
        sp.GES_Congress_Manager__c='Debbie Hummel';        
        insert sp;
        Product_Theater__c pd=new Product_Theater__c();
        pd.Product_Theater_Name__c='test';
        pd.Congress__c=gs.id;
        pd.Congress_Lead__c ='Don Schmid';
        pd.GES_Congress_Manager__c='Debbie Hummel';
        insert pd;
        Symposia__c sy=new Symposia__c();
        sy.Symposia_Name__c='test';
        sy.Congress__c=gs.id;
        sy.Congress_Lead__c ='Don Schmid';
        sy.GES_Congress_Manager__c='Debbie Hummel';
        insert sy;
        Meeting_Room__c mt=new Meeting_Room__c();
        mt.Meeting_Room_Name__c='test';
        mt.Congress__c=gs.id;
        mt.Congress_Lead__c ='Don Schmid';
        mt.GES_Congress_Manager__c='Debbie Hummel';
        insert mt;
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
        br.Product_Theater__c=pd.id;
        br.Meeting_Room__c=mt.id;
        br.Brand_Category__c= 'CentreOne' ;
        br.Business_Unit__c = 'CH';
        insert br;
        
        Test.setCurrentPageReference(new PageReference('Page.CongressFinancialSummaryReport'));
        System.currentPageReference().getParameters().put('id',gs.id);    
        ApexPages.StandardController sc=new ApexPages.StandardController(gs);   
        CongressFinancialSummaryReport cnFnSr=new CongressFinancialSummaryReport(sc);     
        cnFnSr.back();
        cnFnSr.save(); 
      }
}