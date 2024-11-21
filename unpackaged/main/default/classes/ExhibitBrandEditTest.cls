@isTest
Public Class ExhibitBrandEditTest{
    
    Public Static Testmethod void ExhibitBrandEdit1()
    {   
        GES_Connect_Corporate_Accounts__c parentCongress = GC_TestUtils.getTestCongress();
        Exhibit__c  exhibit= GC_TestUtils.getTestExhibit();
        Brand__c brand= GC_TestUtils.getTestBrand();
        brand.Product_Theater__c =exhibit.id;
        Test.setCurrentPageReference(new PageReference('Page.ExhibitBrandEdit'));
        System.currentPageReference().getParameters().put('congid',exhibit.Activity_Type_Exhibit_Instance_c__c);    
        System.currentPageReference().getParameters().put('exhibitid',exhibit.id);
        System.currentPageReference().getParameters().put('brandId',brand.Id);    
        System.currentPageReference().getParameters().put('ExhibitName',exhibit.Name);
        ExhibitBrandEdit eBrandCTRL= new ExhibitBrandEdit();
        

        eBrandCTRL.BrandSave();
        eBrandCTRL.BrandCancel();
        eBrandCTRL.gete(); 
        eBrandCTRL.getb();
        eBrandCTRL.geta();
        eBrandCTRL.changeBrandCatandBusUnit();
        eBrandCTRL.cancelOperation();
    }


}