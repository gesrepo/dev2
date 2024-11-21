@isTest
Public Class ProductTheaterDetailTest{
    Public Static Testmethod void ProductTheaterDetail()
    {   
        GC_Connect2_Show__c cgs=new GC_Connect2_Show__c();   
        cgs.Show_Start_Date__c=Date.parse('3/4/2015');
        cgs.Show_End_Date__c=Date.parse('3/4/2015');
        upsert cgs; 
        
        GES_Connect_Corporate_Accounts__c  gca=new GES_Connect_Corporate_Accounts__c();  
        gca.Name_of_Congress__c='Test 001';
        gca.Shipping_Street_c__c='Bangalore';
        gca.Show_Name__c=cgs.id;
        gca.Association_Contact_Name__c='SLK Soft';
        gca.Association_Name__c='rksinha';
        gca.Housing_Logistics_Vendor__c = 'BCD Travel';
        gca.Number_of_rooms_Secured__c = 5;
        gca.Number_of_rooms_to_Secure__c = 6;
        gca.Shipping_Country__c='India';
        upsert gca;
        
        Product_Theater__c prodT=new Product_Theater__c();    
        prodT.Congress__c = gca.id;
        prodT.Product_Theater_Name__c='Test product theater 01';
        prodT.Activity_Level__c='3';
        prodT.GES_Congress_Manager__c='n/a';
		prodT.Congress_Lead__c='n/a';
		prodT.GES_Account_Manager__c='n/a';
        upsert prodT;
        
        PageReference myVfPage = Page.ProductTheaterDetail;
        myVfPage.getParameters().put('producttherid',prodT.Id);
        myVfPage.getParameters().put('congid','gca.Id');
        myVfPage.getParameters().put('congName',gca.Name);
        // myVfPage.getParameters().put('congid','gca.Id');
        Test.setCurrentPage(myVfPage); 
        
        ProductTheaterDetail ptdr = new ProductTheaterDetail();
        //ptdr.ProductTheaterid = prodT.Id;
        //ptdr.congid= gca.Id;
        ptdr.Requested_Product_Theater_Date_and_Time ='';
        ptdr.Product_Theater_Time='';
        ptdr.Product_Theater_End_Date_and_Time='';
        
        ptdr.getpt();
        ptdr.ProductTheaterNewBrand();
        ptdr.prodtthrSave();
        ptdr.prodtthrcancel();
        ptdr.prodtthrClone();
        ptdr.CongressDetail();
        
        ptdr.brandList();
        ptdr.BrandList();
        
        
        /*ProductTheaterDetail pttr=new ProductTheaterDetail();
pttr.ProductTheaterid = pt.id;

pttr.ProductTheaterNewBrand();
pttr.prodtthrSave();
pttr.prodtthrcancel();     
pttr.getpt();
pttr.BrandList();
pttr.CongressDetail();
*/    
    }
}