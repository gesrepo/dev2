@isTest
Public Class SymposiaDetailTest{
    Public Static Testmethod void SponsorshipDetail()
    {   
        
        GC_Connect2_Show__c cgs=new GC_Connect2_Show__c();   
        cgs.Show_Start_Date__c=Date.parse('3/4/2015');
        cgs.Show_End_Date__c=Date.parse('3/4/2015');
        insert cgs; 
        
        GES_Connect_Corporate_Accounts__c  gca=new GES_Connect_Corporate_Accounts__c();  
        gca.Name_of_Congress__c='Test';
        gca.Shipping_Street_c__c='Bangalore';
        gca.Show_Name__c=cgs.id;
        gca.Association_Contact_Name__c='SLK Soft';
        gca.Association_Name__c='rksinha';
        gca.Housing_Logistics_Vendor__c = 'BCD Travel';
        gca.Number_of_rooms_Secured__c = 5;
        gca.Number_of_rooms_to_Secure__c = 6;
        gca.Shipping_Country__c='India';
        insert gca; 
        
        Symposia__c sy=new Symposia__c();
        sy.Congress__c= gca.id;
        sy.Activity_Level__c='4';
        sy.Symposia_Name__c='Test 1';
        sy.GES_Congress_Manager__c='n/a';
        sy.Congress_Lead__c='n/a';
        insert sy;
        
        SymposiaDetail sydt=new SymposiaDetail();
        sydt.symid = sy.id;
        
        sydt.SymposiaNewBrand();
        sydt.SymposiaSave();
        sydt.Symposiacancel();     
        sydt.getsy();
        sydt.BrandList();
        sydt.SymposiaData();
        sydt.CongressDetail();
        sydt.SymposiaClone();
    }
}