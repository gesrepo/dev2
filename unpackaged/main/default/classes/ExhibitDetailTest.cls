@isTest
Public Class ExhibitDetailTest{
Public Static Testmethod void ExhibitDetail()
{          
    Exhibit__c exbt=new Exhibit__c ();            
    ExhibitDetail Tebt=new ExhibitDetail();
    exbt.Exhibit_Name__c='Test';
    exbt.GES_Project_Number__c=23;
    exbt.Activity_Level__c='3';
    exbt.Congress_Lead__c ='n/a';
    exbt.GES_Congress_Manager__c = 'n/a';
    insert exbt;
    system.debug('Exhibit id'+exbt.id);
    Test.setCurrentPageReference(new PageReference('Page.ExhibitDetail'));
    System.currentPageReference().getParameters().put('exhibitid',exbt.id); 
    system.debug('test exhibit'+exbt.id);
    exbt=[select id,Name,Exhibit_Name__c,GES_Project_Number__c,Activity_Level__c from Exhibit__c where id=:exbt.id];
    Tebt.ExhibitSave();
    Tebt.ExhibitCancel();
    Tebt.CongressDetail();     
    Tebt.gete();
    Tebt.newBrand(); 
    Tebt.BrandList();
    Tebt.Exhibitinfo();
    Tebt.Brandinfo();
}
}