@isTest
Public Class SymposiaBrandEditTest{
    
    
    Public Static Testmethod void SymposiaBrandEdit1()
    {   
        GES_Connect_Corporate_Accounts__c parentCongress = GC_TestUtils.getTestCongress();
		Symposia__c   Symposia= GC_TestUtils.getTestSymposia();
		Brand__c brand= GC_TestUtils.getTestBrand();
		brand.Symposia__c =Symposia.id;
        Test.setCurrentPageReference(new PageReference('Page.SymposiaBrandEdit'));
        System.currentPageReference().getParameters().put('congid',Symposia.Congress__c);    
        System.currentPageReference().getParameters().put('symid',Symposia.id);
        System.currentPageReference().getParameters().put('brandid',brand.Id);    
        System.currentPageReference().getParameters().put('symName',Symposia.Name);
		System.currentPageReference().getParameters().put('autoBrand','true');
        SymposiaBrandEdit eBrandCTRL= new SymposiaBrandEdit();
        

        eBrandCTRL.SymposiaBrandSave();
        eBrandCTRL.BrandCancel();
        eBrandCTRL.getbr();
        eBrandCTRL.cancelOperation();
        eBrandCTRL.changeBrandCatandBusUnit();
    }


}