@isTest
Public Class SponsorshipBrandDetailTest{
Public Static Testmethod void SponsorshipBrandDetail()
{          
   Brand__c b =new Brand__c();
    b.Sponsorship_Costs_Estimated__c=325;
    b.Funding_Owner__c='Test';
    b.Brand_Category__c = 'Anti Infectives';
    b.Brand_Name__c = '	Acrodat';
    b.Business_Unit__c = 'CH';
    insert b;
    Test.setCurrentPageReference(new PageReference('Page.SponsorshipBrandDetail'));
    System.currentPageReference().getParameters().put('sponbrandid',b.id);
    ApexPages.StandardController sc = new ApexPages.standardController(b);
    SponsorshipBrandDetail sp = new SponsorshipBrandDetail();    
    sp.BrandSave();
    sp.BrandCancel();
    sp.getbr();   
   
}
}