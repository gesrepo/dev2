@isTest
Public Class CongressDetailsTest{
    Public Static Testmethod void CongressDetailsTest()
    {
        GC_Connect2_Show__c cgs=new GC_Connect2_Show__c();   
        cgs.Show_Start_Date__c=Date.parse('3/4/2015');
        cgs.Show_End_Date__c=Date.parse('3/4/2015');
    insert cgs;              
        
        GES_Connect_Corporate_Accounts__c  gca=new GES_Connect_Corporate_Accounts__c(); 
        gca.Name_of_Congress__c='Test';
        gca.Shipping_Street_c__c='Bangalore';
        gca.Show_Name__c=cgs.id;
        gca.Secretariat_Same_as_Association__c =true;
        gca.Secretariat_Contact_Email__c = 'reachrksinha@gmail.com';
        gca.Secretariat_Contact_Name__c= 'aAssociation_Contact_Name__c';
        gca.Secretariat_Contact_Phone__c='9789944733';
        gca.Secretariat_Name__c='aAssociation_Name__c';
        gca.Association_Contact_Name__c='2.0 Health';
		gca.Association_Name__c='Test';
        gca.Housing_Logistics_Vendor__c = 'BCD Travel';
        gca.Number_of_rooms_to_Secure__c = 3;
        gca.Number_of_rooms_Secured__c = 3;
        gca.Housing_Required_PL__c = 'Yes';
        gca.Shipping_Country__c='Afghanistan';
    
    insert gca;    
        Account testFacility = new Account ();
        //testFacility.RecordType.DeveloperName ='Facility';
        testFacility.name='testFacility';
        testFacility.type='Hotel';
        testFacility.LMS_Facility_ID__c='1111';
        //testFacility.CurrencyIsoCode='USD - U.S. Dollar';
    
    insert testFacility;
        gca.Facility_Name_Account__c=testFacility.id;
        gca.Secretariat_Same_as_Association__c =false;
    upsert gca;
        
        Exhibit__c ex = new Exhibit__c();
        ex.Booth_Length__c = 10;
        ex.Booth_Width__c = 10;
        ex.Exhibit_Name__c = 'Test';
        ex.Activity_Level__c = '1';
        ex.Activity_Type_Exhibit_Instance_c__c =  gca.Id;
        ex.Congress_Lead__c = 'n/a';
        ex.GES_Congress_Manager__c= 'n/a';
        insert ex;
        
        Brand__c b5 = new Brand__c();
        b5.Brand_Name__c = 'Test';
        b5.GES_Congress_Manager__c = 'McCartney, Eva';
        b5.Exhibit_Instance__c = ex.Id;
        b5.GES_Connect_Corporate_Accounts__c = gca.Id;
        b5.Brand_Category__c='brand';
        b5.Business_Unit__c='EM';
        b5.Brand_Name__c='	Acrodat';
        insert b5;
        
        Sponsorship__c sp = new Sponsorship__c();
        sp.Sponsorship_Name__c = 'Test';
        sp.Activity_Level__c = '1';
        sp.Sponsorship__c = gca.Id;
        sp.Congress_Lead__c = 'n/a';
        sp.GES_Congress_Manager__c= 'n/a';
        insert sp;
        
        Brand__c b = new Brand__c();
        b.Brand_Name__c = 'Test';
        b.GES_Congress_Manager__c = 'McCartney, Eva';
        b.Sponsorship__c = sp.Id;
        b.GES_Connect_Corporate_Accounts__c = gca.Id;
         b.Brand_Category__c='brand';
        b.Business_Unit__c='EM';
        b.Brand_Name__c='	Acrodat';
        insert b;
        
        Symposia__c sy = new Symposia__c();
        sy.Activity_Level__c = '2';
        sy.Symposia_Name__c = 'Test';
        sy.Congress__c = gca.Id;
        sy.Congress_Lead__c = 'n/a';
        sy.GES_Congress_Manager__c= 'n/a';
        sy.GES_Account_Manager__c='Amy Gerrard';
        insert sy;
        
        Brand__c b4 = new Brand__c();
        b4.Brand_Name__c = 'Test';
        b4.GES_Congress_Manager__c = 'McCartney, Eva';
        b4.Symposia__c = sy.Id;
        b4.GES_Connect_Corporate_Accounts__c = gca.Id;
         b4.Brand_Category__c='brand';
        b4.Business_Unit__c='EM';
        b4.Brand_Name__c='	Acrodat';
        insert b4;
        
        Meeting_Room__c mr = new Meeting_Room__c();
        mr.Activity_Level__c = '1';
        mr.Meeting_Room_Name__c = 'Test';
        mr.Congress__c = gca.Id;
        mr.Congress_Lead__c = 'n/a';
        mr.GES_Congress_Manager__c= 'n/a';
        insert mr;
        
        Brand__c b1 = new Brand__c();
        b1.Brand_Name__c = 'Test';
        b1.GES_Congress_Manager__c = 'McCartney, Eva';
        b1.Meeting_Room__c = mr.Id;
        b1.GES_Connect_Corporate_Accounts__c = gca.Id;
         b1.Brand_Category__c='brand';
        b1.Business_Unit__c='EM';
        b1.Brand_Name__c='	Acrodat';
        insert b1;
        
        Product_Theater__c pt = new Product_Theater__c();
        pt.Activity_Level__c = '1';
        pt.Product_Theater_Name__c = 'Test';
        pt.Congress__c = gca.Id;
        pt.Congress_Lead__c = 'n/a';
        pt.GES_Congress_Manager__c= 'n/a';
        insert pt;
        
        Brand__c b2 = new Brand__c();
        b2.Brand_Name__c = 'Test';
        b2.GES_Congress_Manager__c = 'McCartney, Eva';
        b2.Product_Theater__c = pt.Id;
        b2.GES_Connect_Corporate_Accounts__c = gca.Id;
         b2.Brand_Category__c='brand';
        b2.Business_Unit__c='EM';
        b2.Brand_Name__c='	Acrodat';
        insert b2;
        
        Test.setCurrentPageReference(new PageReference('Page.Congressdetails'));
        System.currentPageReference().getParameters().put('id',gca.id); 
        
        ApexPages.StandardController sc=new ApexPages.StandardController(gca);
        CongressDetails cngdt=new CongressDetails(sc);
        //cngdt.congid='a6Qc00000007mFc'; 
        
        cngdt.congid =gca.Id;
        cngdt.NewExhibit();
        cngdt.NewSponsorship();
        cngdt.NewProductTheater();
        cngdt.NewSymposia();
        cngdt.NewMeetingRoom();
        cngdt.editCongress();
        cngdt.cloneCongress();
		cngdt.Congressedit();
        cngdt.cancelclone();
        cngdt.copyAssociationValues();
        cngdt.onFacilitySelect();
        
        Test.setCurrentPageReference(new PageReference('Page.CongressdetailsClone'));
        System.currentPageReference().getParameters().put('id',gca.id); 
        
        
    }
     
}