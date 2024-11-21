@isTest
Public Class ProductTheaterbrandEditTest{
    
    Public Static Testmethod void ProductBrandEdit1()
    {   
        GES_Connect_Corporate_Accounts__c parentCongress = GC_TestUtils.getTestCongress();
        Product_Theater__c   productTheatre = GC_TestUtils.getTestProductTheater();
        Brand__c brand= GC_TestUtils.getTestBrand();
        brand.Product_Theater__c =productTheatre.id;
        Test.setCurrentPageReference(new PageReference('Page.ProductTheaterbrandEdit'));
        System.currentPageReference().getParameters().put('congid',productTheatre.Congress__c);    
        System.currentPageReference().getParameters().put('ProductTheaterid',productTheatre.id);
        System.currentPageReference().getParameters().put('brandid',brand.id);    
        System.currentPageReference().getParameters().put('producttherName',productTheatre.Name);
        //Brand__c brand=[select Brand_Name__c,Brand_Category__c,Funding_Owner__c from Brand__c where Exhibit_Instance__c =: exhibit.id];
       // ApexPages.StandardController stdController=new ApexPages.StandardController(brand);
        ProductTheaterbrandEdit eBrandCTRL= new ProductTheaterbrandEdit();
        

        eBrandCTRL.ProductTheaterbrandSave();
        eBrandCTRL.BrandCancel();
        eBrandCTRL.cancelOperation();
        eBrandCTRL.changeBrandCatandBusUnit();
        eBrandCTRL.getbr();

    }


}