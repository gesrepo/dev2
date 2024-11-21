@isTest
Public Class ProductTheaterEditTest{
	@testSetup static void dataSetup() {
		
		GES_Connect_Corporate_Accounts__c gs=new GES_Connect_Corporate_Accounts__c();
        gs.Exhibit_Close_Date__c=Date.parse('12/05/2017');
        gs.Exhibit_Open_Date__c=Date.parse('02/12/2017');
        gs.Acronym_of_Congress__c='as';
        gs.Name_of_Congress__c='test';
        gs.CurrencyIsoCode='GBP';
        gs.Shipping_Street_c__c='Bangalore';
		gs.Association_Contact_Name__c='SLK Soft';
		gs.Association_Name__c='rksinha';
        gs.Housing_Logistics_Vendor__c = 'BCD Travel';
        gs.Number_of_rooms_Secured__c = 5;
        gs.Number_of_rooms_to_Secure__c = 6;
        gs.Shipping_Country__c='India';
        insert gs;   
		
		Product_Theater__c testProdTh =new Product_Theater__c();
		testProdTh.Product_Theater_Name__c ='Test';
		testProdTh.Product_Theater_Location__c= 'Bangalore';
		testProdTh.GES_Congress_Manager__c='n/a';
		testProdTh.Congress_Lead__c='n/a';
		testProdTh.GES_Account_Manager__c='n/a';
		testProdTh.Activity_Level__c='3';
		testProdTh.Congress__c=gs.Id;
		insert testProdTh;
		
		Brand__c br=new Brand__c(); 
        br.Brand_Name__c='Eucrisa';
        br.GES_Congress_Manager__c='Purcell';
        br.Product_Theater__c=testProdTh.id;
        br.GES_Connect_Corporate_Accounts__c=gs.id;
        br.Brand_Category__c='Vaccines';
        br.Business_Unit__c='CH';
		insert br;
	}
	
	//for new
	@isTest static void testMethod0() {
		Product_Theater__c testProdTh1 = new Product_Theater__c();
		
		GES_Connect_Corporate_Accounts__c gs1= [Select id, Name from GES_Connect_Corporate_Accounts__c WHERE Acronym_of_Congress__c='as'];
		PageReference pageRef = Page.ProductTheaterEdit;
		pageRef.getParameters().put('congid', gs1.Id);
		pageRef.getParameters().put('congName', gs1.Name);
		Test.setCurrentPage(pageRef);
		ApexPages.StandardController sc=new ApexPages.StandardController(gs1);
		ProductTheaterEdit pted=new ProductTheaterEdit(sc);
		testProdTh1.Product_Theater_Name__c='Test 2';
		testProdTh1.Product_Theater_Name__c ='Test';
		testProdTh1.Product_Theater_Location__c= 'Bangalore';
		testProdTh1.GES_Congress_Manager__c='n/a';
		testProdTh1.Congress_Lead__c='n/a';
		testProdTh1.GES_Account_Manager__c='n/a';
		testProdTh1.Activity_Level__c='3';
		pted.pt =testProdTh1;
		pted.ProductTheaterSave();
		pted.producttherCancel();
		pted.cancelOperation();
		pted.getpt();    
		pted.geta();
	}
	//for edit
	@isTest static void testMethod1() {
		Product_Theater__c testProdTh1 = [SELECT id, Name, Product_Theater_Name__c, Product_Theater_Location__c, GES_Congress_Manager__c,Congress_Lead__c, GES_Account_Manager__c, Activity_Level__c FROM Product_Theater__c WHERE Product_Theater_Name__c='Test'];
		
		GES_Connect_Corporate_Accounts__c gs1= [Select id, Name from GES_Connect_Corporate_Accounts__c WHERE Acronym_of_Congress__c='as'];
		PageReference pageRef = Page.ProductTheaterEdit;
		pageRef.getParameters().put('ProductTheaterid', testProdTh1.Id);
		pageRef.getParameters().put('congid', gs1.Id);
		pageRef.getParameters().put('congName', gs1.Name);
		Test.setCurrentPage(pageRef);
		ApexPages.StandardController sc=new ApexPages.StandardController(gs1);
		ProductTheaterEdit pted=new ProductTheaterEdit(sc);
		testProdTh1.Product_Theater_Name__c='Test 2';
		pted.ProductTheaterSave();
		pted.producttherCancel();
		pted.cancelOperation();
		pted.getpt();    
		pted.geta();
	}
	
	//for cloning
	@isTest static void testMethod2() {
		Product_Theater__c testProdTh1 = [SELECT id, Name, Product_Theater_Name__c, Product_Theater_Location__c, GES_Congress_Manager__c,Congress_Lead__c, GES_Account_Manager__c, Activity_Level__c FROM Product_Theater__c WHERE Product_Theater_Name__c='Test'];
		
		GES_Connect_Corporate_Accounts__c gs1= [Select id, Name from GES_Connect_Corporate_Accounts__c WHERE Acronym_of_Congress__c='as'];
		PageReference pageRef = Page.ProductTheaterEdit;
		pageRef.getParameters().put('ProductTheaterid', testProdTh1.Id);
		pageRef.getParameters().put('congid', gs1.Id);
		pageRef.getParameters().put('congName', gs1.Name);
		pageRef.getParameters().put('toClone', 'true');
		Test.setCurrentPage(pageRef);
		ApexPages.StandardController sc=new ApexPages.StandardController(gs1);
		ProductTheaterEdit pted=new ProductTheaterEdit(sc);
		testProdTh1.Product_Theater_Name__c='Test 2';
		pted.ProductTheaterSave();
		pted.producttherCancel();
		pted.pt.Canceled__c=true;
		pted.cancelOperation();
		
	}


}