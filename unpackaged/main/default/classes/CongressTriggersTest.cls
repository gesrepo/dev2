@isTest(SeeAllData=true)
public class CongressTriggersTest 
{
    public static testMethod void exhbitTrigger() 
    {
        GES_Connect_Corporate_Accounts__c  gca=new GES_Connect_Corporate_Accounts__c();  
        gca.Name_of_Congress__c='Test';
        gca.Acronym_of_Congress__c = 'TEST';
        gca.Exhibit_Open_Date__c = Date.Today();
        gca.Exhibit_Close_Date__c = Date.Today();
        gca.Facility_Name__c = 'Test';
        gca.Shipping_City__c = 'Atlanta';
        gca.Shipping_Street_c__c='Bangalore';
        gca.Shipping_Zip_Postal_Code__c = '23';
        gca.CurrencyIsoCode='USD';
        gca.Housing_Logistics_Vendor__c = 'BCD Travel';
        gca.Number_of_rooms_Secured__c = 6;
        gca.Association_Contact_Name__c='SLK Soft';
        gca.Association_Name__c='rksinha';
        
        insert gca;
        
        Exhibit__c ex = new Exhibit__c();
        ex.Booth_Length__c = 10;
        ex.Booth_Width__c = 10;
        ex.Exhibit_Name__c = 'Test';
        ex.Activity_Level__c = '1';
        ex.Congress_Lead__c = 'Lee Kim';
        ex.GES_Congress_Manager__c = 'Debbie Hummel';
        ex.Activity_Type_Exhibit_Instance_c__c =  gca.Id;
        insert ex;
        
        Brand__c b = new Brand__c();
        b.Brand_Name__c = 'Test';
        b.GES_Congress_Manager__c = 'Debbie Hummel';
        b.Exhibit_Instance__c = ex.Id;
        b.GES_Connect_Corporate_Accounts__c = gca.Id;
        b.CurrencyIsoCode='USD';
        b.Brand_Category__c = 'Anti Infectives' ;
        b.Business_Unit__c = 'CH';
        insert b;
        Brand__c b1 = new Brand__c();
        b1.Brand_Name__c = 'Test';
        b1.GES_Congress_Manager__c = 'Debbie Hummel';
        b1.Exhibit_Instance__c = ex.Id;
        b1.GES_Connect_Corporate_Accounts__c = gca.Id;
        b1.CurrencyIsoCode='USD';
        b1.Brand_Category__c = 'Anti Infectives' ;
        b1.Business_Unit__c = 'CH';
        
        insert b1;
        
		GES_Connect_Corporate_Accounts__c  updateGCA=new GES_Connect_Corporate_Accounts__c();  
		updateGCA = [SELECT ID,Congress_Cancelled__c FROM GES_Connect_Corporate_Accounts__c WHERE Id = :gca.Id];
        updateGCA.Congress_Cancelled__c = true;
        update updateGCA; 
        gca.CurrencyIsoCode='GBP';
        update gca;
        
        Exhibit__c  updateEX=new Exhibit__c();  
		updateEX = [SELECT ID,Canceled__c FROM Exhibit__c WHERE Id = :ex.Id];
        updateEX.Canceled__c = true;
        update updateEX;
        
        GES_Connect_Corporate_Accounts__c  updateGCA1=new GES_Connect_Corporate_Accounts__c();  
		updateGCA1 = [SELECT ID,Congress_Cancelled__c FROM GES_Connect_Corporate_Accounts__c WHERE Id = :gca.Id];
        updateGCA1.Congress_Cancelled__c = false;
        update updateGCA1;
        
    }
    
    public static testMethod void sponsorshipTrigger() 
    {
        GES_Connect_Corporate_Accounts__c  gca=new GES_Connect_Corporate_Accounts__c();  
        gca.Name_of_Congress__c='Test';
        gca.Acronym_of_Congress__c = 'TEST';
        gca.Exhibit_Open_Date__c = Date.Today();
        gca.Exhibit_Close_Date__c = Date.Today();
        gca.Facility_Name__c = 'Test';
        gca.Shipping_City__c = 'Atlanta';
        gca.Shipping_Street_c__c='Bangalore';
        gca.Shipping_Zip_Postal_Code__c = '23';
        gca.Housing_Logistics_Vendor__c = 'BCD Travel';
        gca.Number_of_rooms_Secured__c = 6;
        gca.Association_Contact_Name__c='SLK Soft';
        gca.Association_Name__c='rksinha';
        insert gca;
        
        Sponsorship__c sp = new Sponsorship__c();
        sp.Sponsorship_Name__c = 'Test';
        sp.Activity_Level__c = '1';
        sp.Sponsorship__c = gca.Id;
        sp.Congress_Lead__c = 'Lee Kim';
        sp.GES_Congress_Manager__c = 'Debbie Hummel';
        insert sp;
        
        Brand__c b = new Brand__c();
        b.Brand_Name__c = 'Test';
        b.GES_Congress_Manager__c = 'McCartney, Eva';
        b.Sponsorship__c = sp.Id;
        b.GES_Connect_Corporate_Accounts__c = gca.Id;
        b.Brand_Category__c = 'Anti Infectives' ;
        b.Business_Unit__c = 'CH';
        insert b;
        
        GES_Connect_Corporate_Accounts__c  updateGCA=new GES_Connect_Corporate_Accounts__c();  
		updateGCA = [SELECT ID,Congress_Cancelled__c FROM GES_Connect_Corporate_Accounts__c WHERE Id = :gca.Id];
        updateGCA.Congress_Cancelled__c = true;
        update updateGCA;
        
        Sponsorship__c  updateSP=new Sponsorship__c();  
		updateSP = [SELECT ID,Canceled__c FROM Sponsorship__c WHERE Id = :sp.Id];
        updateSP.Canceled__c = true;
        update updateSP;
        
        GES_Connect_Corporate_Accounts__c  updateGCA1=new GES_Connect_Corporate_Accounts__c();  
		updateGCA1 = [SELECT ID,Congress_Cancelled__c FROM GES_Connect_Corporate_Accounts__c WHERE Id = :gca.Id];
        updateGCA1.Congress_Cancelled__c = false;
        update updateGCA1;
        
        //sp.Canceled__c = true;
        //update sp;
    }
    
    public static testMethod void symposiaTrigger() 
    {
        GES_Connect_Corporate_Accounts__c  gca=new GES_Connect_Corporate_Accounts__c();  
        gca.Name_of_Congress__c='Test';
        gca.Acronym_of_Congress__c = 'TEST';
        gca.Exhibit_Open_Date__c = Date.Today();
        gca.Exhibit_Close_Date__c = Date.Today();
        gca.Facility_Name__c = 'Test';
        gca.Shipping_City__c = 'Atlanta';
        gca.Shipping_Street_c__c='Bangalore';
        gca.Shipping_Zip_Postal_Code__c = '23';
        gca.Housing_Logistics_Vendor__c = 'BCD Travel';
        gca.Number_of_rooms_Secured__c = 6;
        gca.Association_Contact_Name__c='SLK Soft';
        gca.Association_Name__c='rksinha';
        insert gca;
        
        Symposia__c sy = new Symposia__c();
        sy.Activity_Level__c = '2';
        sy.Symposia_Name__c = 'Test';
        sy.Congress__c = gca.Id;
        sy.Congress_Lead__c = 'Lee Kim';
        sy.GES_Congress_Manager__c = 'Debbie Hummel';
        insert sy;
        
        Brand__c b = new Brand__c();
        b.Brand_Name__c = 'Test';
        b.GES_Congress_Manager__c = 'McCartney, Eva';
        b.Symposia__c = sy.Id;
        b.GES_Connect_Corporate_Accounts__c = gca.Id;
        b.Brand_Category__c = 'Anti Infectives' ;
        b.Business_Unit__c = 'CH';
        insert b;
        
        GES_Connect_Corporate_Accounts__c  updateGCA=new GES_Connect_Corporate_Accounts__c();  
		updateGCA = [SELECT ID,Congress_Cancelled__c FROM GES_Connect_Corporate_Accounts__c WHERE Id = :gca.Id];
        updateGCA.Congress_Cancelled__c = true;
        update updateGCA;
        
        Symposia__c  updateSYM=new Symposia__c();  
		updateSYM = [SELECT ID,Canceled__c FROM Symposia__c WHERE Id = :sy.Id];
        updateSYM.Canceled__c = true;
        update updateSYM;
        
        GES_Connect_Corporate_Accounts__c  updateGCA1=new GES_Connect_Corporate_Accounts__c();  
		updateGCA1 = [SELECT ID,Congress_Cancelled__c FROM GES_Connect_Corporate_Accounts__c WHERE Id = :gca.Id];
        updateGCA1.Congress_Cancelled__c = false;
        update updateGCA1;
        
       // sy.Canceled__c = true;
        //update sy;
    }
    
    public static testMethod void meetingRoomTrigger() 
    {
        GES_Connect_Corporate_Accounts__c  gca=new GES_Connect_Corporate_Accounts__c();  
        gca.Name_of_Congress__c='Test';
        gca.Acronym_of_Congress__c = 'TEST';
        gca.Exhibit_Open_Date__c = Date.Today();
        gca.Exhibit_Close_Date__c = Date.Today();
        gca.Facility_Name__c = 'Test';
        gca.Shipping_City__c = 'Atlanta';
        gca.Shipping_Street_c__c='Bangalore';
        gca.Shipping_Zip_Postal_Code__c = '23';
        gca.Housing_Logistics_Vendor__c = 'BCD Travel';
        gca.Number_of_rooms_Secured__c = 6;
        gca.Association_Contact_Name__c='SLK Soft';
        gca.Association_Name__c='rksinha';
        insert gca;
        
        Meeting_Room__c mr = new Meeting_Room__c();
        mr.Activity_Level__c = '1';
        mr.Meeting_Room_Name__c = 'Test';
        mr.Congress__c = gca.Id;
        mr.Congress_Lead__c = 'Lee Kim';
        mr.GES_Congress_Manager__c = 'Debbie Hummel';
        insert mr;
        
        Brand__c b = new Brand__c();
        b.Brand_Name__c = 'Test';
        b.Brand_Category__c = 'Anti Infectives' ;
        b.Business_Unit__c = 'CH';
        b.GES_Congress_Manager__c = 'McCartney, Eva';
        b.Meeting_Room__c = mr.Id;
        b.GES_Connect_Corporate_Accounts__c = gca.Id;
        insert b;
        
        GES_Connect_Corporate_Accounts__c  updateGCA=new GES_Connect_Corporate_Accounts__c();  
		updateGCA = [SELECT ID,Congress_Cancelled__c FROM GES_Connect_Corporate_Accounts__c WHERE Id = :gca.Id];
        updateGCA.Congress_Cancelled__c = true;
        update updateGCA;
        
        Meeting_Room__c  updateMR=new Meeting_Room__c();  
		updateMR = [SELECT ID,Canceled__c FROM Meeting_Room__c WHERE Id = :mr.Id];
        updateMR.Canceled__c = true;
        update updateMR;
        
        GES_Connect_Corporate_Accounts__c  updateGCA1=new GES_Connect_Corporate_Accounts__c();  
		updateGCA1 = [SELECT ID,Congress_Cancelled__c FROM GES_Connect_Corporate_Accounts__c WHERE Id = :gca.Id];
        updateGCA1.Congress_Cancelled__c = false;
        update updateGCA1;
        
        //mr.Canceled__c = true;
        //update mr;
    }
    
    public static testMethod void productTheatreTrigger() 
    {
        GES_Connect_Corporate_Accounts__c  gca=new GES_Connect_Corporate_Accounts__c();  
        gca.Name_of_Congress__c='Test';
        gca.Acronym_of_Congress__c = 'TEST';
        gca.Exhibit_Open_Date__c = Date.Today();
        gca.Exhibit_Close_Date__c = Date.Today();
        gca.Facility_Name__c = 'Test';
        gca.Shipping_City__c = 'Atlanta';
        gca.Shipping_Street_c__c='Bangalore';
        gca.Shipping_Zip_Postal_Code__c = '23';
        gca.Housing_Logistics_Vendor__c = 'BCD Travel';
        gca.Number_of_rooms_Secured__c = 6;
        gca.Association_Contact_Name__c='SLK Soft';
        gca.Association_Name__c='rksinha';
        insert gca;
        
        Product_Theater__c pt = new Product_Theater__c();
        pt.Activity_Level__c = '1';
        pt.Product_Theater_Name__c = 'Test';
        pt.Congress__c = gca.Id;
        pt.Congress_Lead__c = 'Lee Kim';
        pt.GES_Congress_Manager__c = 'Debbie Hummel';
        insert pt;
        
        Brand__c b = new Brand__c();
        b.Brand_Name__c = 'Test';
        b.GES_Congress_Manager__c = 'McCartney, Eva';
        b.Product_Theater__c = pt.Id;
        b.GES_Connect_Corporate_Accounts__c = gca.Id;
        b.Brand_Category__c = 'Anti Infectives' ;
        b.Business_Unit__c = 'CH';
        insert b;
        
        GES_Connect_Corporate_Accounts__c  updateGCA=new GES_Connect_Corporate_Accounts__c();  
		updateGCA = [SELECT ID,Congress_Cancelled__c FROM GES_Connect_Corporate_Accounts__c WHERE Id = :gca.Id];
        updateGCA.Congress_Cancelled__c = true;
        update updateGCA;
        
        Product_Theater__c  updatePT=new Product_Theater__c();  
		updatePT = [SELECT ID,Canceled__c FROM Product_Theater__c WHERE Id = :pt.Id];
        updatePT.Canceled__c = true;
        update updatePT;
        
        GES_Connect_Corporate_Accounts__c  updateGCA1=new GES_Connect_Corporate_Accounts__c();  
		updateGCA1 = [SELECT ID,Congress_Cancelled__c FROM GES_Connect_Corporate_Accounts__c WHERE Id = :gca.Id];
        updateGCA1.Congress_Cancelled__c = false;
        update updateGCA1; 
    }
}