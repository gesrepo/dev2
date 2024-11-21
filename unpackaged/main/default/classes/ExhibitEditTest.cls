@isTest
Public Class ExhibitEditTest{
    
    @testSetup static void dataSetup() {
    
    GES_Connect_Corporate_Accounts__c gs=new GES_Connect_Corporate_Accounts__c();
        gs.Exhibit_Close_Date__c=Date.parse('12/05/2017');
        gs.Exhibit_Open_Date__c=Date.parse('02/12/2017');
        gs.Acronym_of_Congress__c='as';
        gs.Name_of_Congress__c='test';
        gs.CurrencyIsoCode='GBP';
        gs.Shipping_Street_c__c='Bangalore';
        gs.Association_Contact_Name__c='SLK Soft';
        gs.Association_Name__c='rksinha';
        gs.Housing_Logistics_Vendor__c = 'BCD Travel';
        gs.Number_of_rooms_Secured__c = 5;
        gs.Number_of_rooms_to_Secure__c = 6;
        gs.Shipping_Country__c='India';
        insert gs;   
        
    }
    
    
    Public Static Testmethod void ExhibitEdit()
    {          
        Exhibit__c exbt= GC_TestUtils.getTestExhibit();
        ApexPages.StandardController sc=new ApexPages.StandardController(exbt);   
        Test.setCurrentPageReference(new PageReference('Page.Exhibitedit'));
        System.currentPageReference().getParameters().put('exhibitid',exbt.id); 
        System.currentPageReference().getParameters().put('congid',exbt.Activity_Type_Exhibit_Instance_c__c); 

        exbt=[select id,Name,Exhibit_Name__c,GES_Project_Number__c,Activity_Level__c from Exhibit__c where id=:exbt.id];
        ExhibitEdit Tebt=new ExhibitEdit(sc);
        Tebt.ExhibitSave();
        Tebt.ExhibitCancel();
        Tebt.cancelOperation();
        
        Tebt.gete(); 
    }
    
    
    Public Static Testmethod void ExhibitClone()
    {          
        Exhibit__c exbt= GC_TestUtils.getTestExhibit();
        ApexPages.StandardController sc=new ApexPages.StandardController(exbt);   
        Test.setCurrentPageReference(new PageReference('Page.Exhibitedit'));
        System.currentPageReference().getParameters().put('exhibitid',exbt.id); 
        System.currentPageReference().getParameters().put('congid',exbt.Activity_Type_Exhibit_Instance_c__c); 
        System.currentPageReference().getParameters().put('toClone','true'); 
        //System.currentPageReference().getParameters().put('congName',Activity_Type_Exhibit_Instance_c__r.Name); 

        exbt=[select id,Name,Exhibit_Name__c,GES_Project_Number__c,Activity_Level__c from Exhibit__c where id=:exbt.id];
        ExhibitEdit Tebt=new ExhibitEdit(sc);
        Tebt.ExhibitSave();
        Tebt.ExhibitCancel();
        Tebt.cancelOperation();
        
        Tebt.gete(); 
    }
    
    Public Static Testmethod void ExhibitNew()
    {         
        Exhibit__c exhibit= new Exhibit__c();
        ApexPages.StandardController sc=new ApexPages.StandardController(exhibit);   
        Test.setCurrentPageReference(new PageReference('Page.Exhibitedit'));
        ExhibitEdit Tebt=new ExhibitEdit(sc);
        GES_Connect_Corporate_Accounts__c parentCongress = GC_TestUtils.getTestCongress();
        exhibit.Activity_Type_Exhibit_Instance_c__c = parentCongress.id;
        exhibit.Booth_Length__c = 10;
        exhibit.Booth_Width__c = 10;
        exhibit.Exhibit_Name__c = 'Test Exhibit for Devs';
        exhibit.Activity_Level__c = '1';
        exhibit.CurrencyIsoCode = 'USD';       
        exhibit.GES_Congress_Manager__c='n/a';
        exhibit.Congress_Lead__c='n/a';
        exhibit.GES_Account_Manager__c='n/a';
    
        Tebt.e=exhibit;
        Tebt.ExhibitSave();
        Tebt.ExhibitCancel();
        Tebt.e.Canceled__c =true;
        Tebt.cancelOperation();
        
        Tebt.gete(); 
    }
}