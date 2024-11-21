@isTest
Public Class SymposiaBrandDetailTest{
Public Static Testmethod void SymposiaBrandDetail()
{          
   Brand__c b =new Brand__c();
    b.Sponsorship_Costs_Estimated__c=325;
    b.Funding_Owner__c='Test';
    b.brand_Category__c='Test Category';
    b.Brand_Name__c='Test name';
    b.Business_Unit__c='EM';
    insert b;
    Test.setCurrentPageReference(new PageReference('Page.SymposiaBrandDetail'));
    System.currentPageReference().getParameters().put('symbrandid',b.id);
    ApexPages.StandardController sc = new ApexPages.standardController(b);
    SymposiaBrandDetail sy = new SymposiaBrandDetail();    
    sy.BrandSave();
    sy.BrandCancel();
    sy.getbr();   
   
}
}