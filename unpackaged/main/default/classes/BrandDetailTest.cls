@isTest
Public Class BrandDetailTest{
Public Static Testmethod void BrandDetail()
{          
    Brand__c b =new Brand__c();
    b.Exhibit_Costs_Estimated__c=325;
    b.Exhibit_Costs_Actual__c=423;
    b.Brand_Category__c = '	Acrodat';
    b.Brand_Name__c = 'Anti Infectives';
    b.Business_Unit__c = 'CH';
    insert b;
    Test.setCurrentPageReference(new PageReference('Page.BrandDetail'));
    System.currentPageReference().getParameters().put('brandid',b.id);
    ApexPages.StandardController stdController= new ApexPages.StandardController(b);
    BrandDetail objBrandDetail = new BrandDetail(stdController);    
    objBrandDetail.BrandSave();
    objBrandDetail.BrandCancel();
    objBrandDetail.getb();   
}
}