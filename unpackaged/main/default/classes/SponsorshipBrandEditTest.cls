@isTest
Public Class SponsorshipBrandEditTest{
    
    Public Static Testmethod void sponsorshipBrandEdit1()
    {   
        GES_Connect_Corporate_Accounts__c parentCongress = GC_TestUtils.getTestCongress();
		Sponsorship__c    Sponsorship= GC_TestUtils.getTestSponsorship();
		Brand__c brand= GC_TestUtils.getTestBrand();
		brand.Sponsorship__c  =Sponsorship.id;
        Test.setCurrentPageReference(new PageReference('Page.SponsorshipBrandEdit'));
        System.currentPageReference().getParameters().put('congid',Sponsorship.Sponsorship__c);    
        System.currentPageReference().getParameters().put('sponid',Sponsorship.id);
        System.currentPageReference().getParameters().put('brandid',brand.id);    
        System.currentPageReference().getParameters().put('sponName',Sponsorship.Name);
        SponsorshipBrandEdit eBrandCTRL= new SponsorshipBrandEdit();
        

        eBrandCTRL.sponsorshipBrandSave();
        eBrandCTRL.BrandCancel();
        eBrandCTRL.cancelOperation();
        eBrandCTRL.getbr();
		eBrandCTRL.changeBrandCatandBusUnit();
    }
}