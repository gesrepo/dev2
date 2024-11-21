@isTest
public class ProductThearerTriggerTest {

    public static testMethod void testMethod1() {
        GC_Connect2_Show__c cgs=new GC_Connect2_Show__c();   
        cgs.Show_Start_Date__c=Date.parse('3/4/2015');
        cgs.Show_End_Date__c=Date.parse('3/4/2015');
        insert cgs; 
        
        GES_Connect_Corporate_Accounts__c  gca=new GES_Connect_Corporate_Accounts__c();  
        gca.Name_of_Congress__c='Test';
        gca.Shipping_Street_c__c='Bangalore';
        gca.Show_Name__c=cgs.id;
        gca.Housing_Logistics_Vendor__c = 'BCD Travel';
        gca.Number_of_rooms_Secured__c = 6;
        gca.Association_Contact_Name__c='SLK Soft';
        gca.Association_Name__c='rksinha';
        insert gca;  
        
        List<Product_Theater__c> listProductTheater = new List<Product_Theater__c>();
        Product_Theater__c pt = new Product_Theater__c();
        pt.Product_Theater_Name__c = 'Test';
        pt.Activity_Level__c = '1';
        pt.Congress__c =  gca.Id;
        pt.Congress_Lead__c = 'Don Schmid';
        pt.GES_Congress_Manager__c = 'Debbie Hummel';
        
        Product_Theater__c pt1 = new Product_Theater__c();
        pt.Product_Theater_Name__c = 'Test';
        pt1.Activity_Level__c = '1';
        pt1.Canceled__c = true;
        pt1.Congress__c =  gca.Id;
        pt1.Congress_Lead__c = 'Don Schmid';
        pt1.GES_Congress_Manager__c = 'Debbie Hummel';
        listProductTheater.add(pt);
        listProductTheater.add(pt1);
        insert listProductTheater;
        
        Brand__c b5 = new Brand__c();
        b5.Brand_Name__c = 'Test';
        b5.GES_Congress_Manager__c = 'McCartney, Eva';
        b5.Product_Theater__c = pt.Id;
        b5.GES_Connect_Corporate_Accounts__c = gca.Id;
        b5.Brand_Category__c = 'Oncology' ;
        b5.Business_Unit__c = 'CH' ;
        insert b5;
        
        pt.Canceled__c = true;
        update pt;
    }
}