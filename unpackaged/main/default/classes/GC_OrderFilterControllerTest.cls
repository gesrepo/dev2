/*********************************************************************************
* Author: Karthik N, Created: 9/11/2017 
* This Class implements test methods for the controller - GC_OrderFilterController
**********************************************************************************/
@isTest
public class GC_OrderFilterControllerTest {
    
    public static testMethod void searchResultsTest() {
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        User usr = [SELECT Id, Name,GC_Show_Role__c FROM User WHERE Id = :userinfo.getUserId() LIMIT 1];
        usr.GC_Show_Role__c = 'GC Account Manager';
        update usr;
        string showId = show.Id;
        
        Map<String, User> userMap = GC_TestUtils.getUsers();
        User user1 = userMap.get('AM');
        GC_Connect2_Show__c show1 =  GC_TestUtils.getTestConnect2Show();
        GC_Order__c order1 = new GC_Order__c();
        
        
        GC_Show_Attribute__c GCshow=new GC_Show_Attribute__c();
        GCshow.Connect2_Show__c =show.Id;
        GCshow.Name = 'Test';
        insert GCshow;
        
        GC_Show_Attribute__c GCshow1=new GC_Show_Attribute__c();
        GCshow1.Connect2_Show__c =show.Id;
        GCshow1.RecordTypeId = GC_TestUtils.getRecordType('GC_Show_Attribute__c').get('Venue Location').Id;
        GCshow1.Name = 'Test Venue';
        insert GCshow1;
        
        GC_Order__c order = new GC_Order__c();
        order.Connect2_Show__c = show.Id;
        order.Order_Area_Description__c = 'testing';
        order.Booth_Area__c='Test Exhibit Booth';
        insert order;
        
        GC_GES_Order_Task__c got = new GC_GES_Order_Task__c();
        got.Order__c = order.Id;
        got.Delivery_Location__c = 'testing';
        got.Department__c= GCshow.Id;
        got.SA_Venue_Location__c = GCshow1.Id;
        got.Onsite_Contact_Person_Other__c='Test';
        got.Onsite_Contact_Person__c = user1.Id;
        insert got;
        
        GC_Vendor_Order_Task__c vot = new GC_Vendor_Order_Task__c();
        vot.Order__c = order.Id;
        vot.Vendor__c=usr.Id;
        insert vot;
        
        
        system.debug('id in test >>>>>>'+showId);
        
        ApexPages.currentPage().getParameters().put('Id' , showId);  //pass this as if a parameter is made available in URL
        GC_OrderFilterController cont = new GC_OrderFilterController();
        cont.showId =  show.Id;
        cont.show = show;
        cont.Username=new List<String>();
        cont.modifiedDateFrom = (Date.today());
        cont.modifiedDateTo = (Date.today());
        cont.createdDateFrom = (Date.today());
        cont.createdDateTo = (Date.today());
        cont.showDateDelivery = (Date.today());
        cont.showDateRemoval = (Date.today());
        cont.showDateCompletion = (Date.today());
        cont.onsiteContactPerson = new List<String>();
        cont.onsiteContactPersonOther = new List<String>();
        cont.searchString = 'test';
        cont.deliveryLocation = 'US';
        cont.department ='Graphics';
        
        List<String> st = new  List<String>();
        st.add('element');
        cont.filterString(st);
        cont.multiSelectString('filterCriteria', st);
        
        cont.SaveFilter();
        //test to check search result returned 
        PageReference pr = cont.searchResults(); 
        System.assertEquals(cont.gesOrders.size() , 0);
        
               
        //test to check date format
        String dt = cont.getDateString(Date.newInstance(2017, 10, 02));
        System.assertEquals(dt, '2017-10-02');
        
        //tests if all objects are nullified
        pr = cont.resetSearch();
        System.assertEquals(cont.deliveryLocation, null);
        System.assertEquals(cont.selectedOADescription, null);
        System.assertEquals(cont.showDateDelivery, null);
        System.assertEquals(cont.showDateCompletion, null);
        System.assertEquals(cont.showDateRemoval, null);
        System.assertEquals(cont.createdDateFrom, null);
        System.assertEquals(cont.createdDateTo, null);
        System.assertEquals(cont.modifiedDateFrom, null);
        System.assertEquals(cont.modifiedDateTo, null);
        System.assertEquals(cont.selectedVendor, null);
        System.assertEquals(cont.searchString, null);
        System.assertEquals(cont.department, null);
        System.assertEquals(cont.delivery, null);
        System.assertEquals(cont.venue, null);
        System.assertEquals(cont.vendor, null);
        //System.assertEquals(cont.Username, null);
        //System.assertEquals(cont.onsiteContactPerson,null);
        //System.assertEquals(cont.onsiteContactPersonOther,null);
        
        pr = cont.searchResults();
        cont.Username.add('Aishwarya');
      
    }
     
    
}