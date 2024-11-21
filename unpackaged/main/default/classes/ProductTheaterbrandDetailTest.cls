@isTest
Public Class ProductTheaterbrandDetailTest{
Public Static Testmethod void ProductTheaterbrandDetail()
{          
   Brand__c b =new Brand__c();
    b.Sponsorship_Costs_Estimated__c=325;
    b.Funding_Owner__c='Test';
    b.Brand_Category__c='Tests';
    b.Brand_Name__c='Test';
    b.Business_Unit__c='EM';
    insert b;
    Test.setCurrentPageReference(new PageReference('Page.ProductTheaterbrandDetail'));
    System.currentPageReference().getParameters().put('ptrbrandid',b.id);
    ApexPages.StandardController sc = new ApexPages.standardController(b);
   // ApexPages.StandardController stdController= new ApexPages.StandardController(b);
    ProductTheaterbrandDetail bd = new ProductTheaterbrandDetail();    
    bd.BrandSave();
    bd.BrandCancel();
    bd.getbr();   
   
}
}