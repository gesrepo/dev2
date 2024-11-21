@isTest
public class Epa3ReportControllerTest {
    @testSetup static void setup() {
        GES_Connect_Corporate_Accounts__c shw=new GES_Connect_Corporate_Accounts__c(Name_of_Congress__c='test',Congress_Start_Date__c=Date.today(),
                                                                                    Congress_End_Date__c=Date.today()+5,Acronym_of_Congress__c='TST',Congress_Level__c='5',Association_Contact_Name__c='test', Association_Name__c='tets', Housing_Logistics_Vendor__c='BCD Travel', Number_of_rooms_Secured__c=2);
        insert shw; 
        Exhibit__c ex=new Exhibit__c(GES_Congress_Manager__c='Gail Griffith',GES_Account_Manager__c='Megan Siconolfi',GES_Account_Executive__c='Lori Filloon',Activity_Type_Exhibit_Instance_c__c=shw.Id,Congress_Lead__c='Laine Mann');
        insert ex;
        Sponsorship__c sponsor=new Sponsorship__c(GES_Congress_Manager__c='Gail Griffith',GES_Account_Manager__c='Megan Siconolfi',GES_Account_Executive__c='Lori Filloon',Sponsorship__c=shw.Id,Congress_Lead__c='Laine Mann');
        insert sponsor;
        Product_Theater__c pt=new Product_Theater__c(GES_Congress_Manager__c='Gail Griffith',GES_Account_Manager__c='Megan Siconolfi',GES_Account_Executive__c='Lori Filloon',Congress__c=shw.Id,Congress_Lead__c='Laine Mann');
        insert pt;
        Symposia__c symp=new Symposia__c(GES_Congress_Manager__c='Gail Griffith',GES_Account_Manager__c='Megan Siconolfi',GES_Account_Executive__c='Lori Filloon',Congress__c=shw.Id,Congress_Lead__c='Laine Mann');
        insert symp;
        Meeting_Room__c meeting=new Meeting_Room__c(GES_Congress_Manager__c='Gail Griffith',GES_Account_Manager__c='Megan Siconolfi',GES_Account_Executive__c='Lori Filloon',Congress__c=shw.Id,Congress_Lead__c='Laine Mann');
        insert meeting;
        
    }
    Public Static Testmethod void testEpa(){
        Epa3ReportController epa=new Epa3ReportController();
        epa.next();
        epa.gotoReports();
        epa.back();
        epa.excelReport();
        epa.getDisableNext();
        epa.getDisablePrevious();
        epa.resetSearch();
    }
    
}