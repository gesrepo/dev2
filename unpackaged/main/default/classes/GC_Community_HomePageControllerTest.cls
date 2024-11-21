/**
* @author Ethos Solutions - www.ethos.com
* @description Test code for the home page controller
* 2016-04-12 : Original Version
**/
@isTest
public class GC_Community_HomePageControllerTest {

    public static testMethod void homePageTest() {
 
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        
        GC_Community_HomePageController cont = new GC_Community_HomePageController();
        cont.vendor='Ethos';
        cont.TypeofUser='Internal';
        cont.votQuery ='Testing';
        cont.boothName = 'null';
        cont.department = 'null';
        cont.delivery = 'null';
        cont.venue = 'null';
        cont.vendor = 'null';
        cont.Username=new List<String>();
        cont.TypeOfUser='null';
        cont.CanCreate =true;
        cont.sortOrder ='Tester';
        cont.department = 'test 123';
        cont.oponsiteContactPerson = new List<String>();
        cont.oponsiteContactPersonOther = new List<String>();
        cont.searchString = 'test';
        PageReference pr = cont.loadPage();
        System.assertEquals(pr.getUrl() , cont.homePage);
        pr = cont.createOrder();
        System.assertEquals(pr, null);
   
        
        GC_Show_Attribute__c GCshow=new GC_Show_Attribute__c();
        GCshow.Connect2_Show__c =show.Id;
        GCshow.name='test';
        insert GCshow;
        
        list<Profile> Newprf= [Select id from Profile where Name = 'GC Community Vendor || GC Community Client' ];
       
        User usr = [SELECT Id, Name FROM User WHERE Id = :userinfo.getUserId() LIMIT 1];
  
         
        GC_Order__c order = new GC_Order__c();
        order.Connect2_Show__c = show.Id;
        order.Order_Area_Description__c = 'testing';
        order.Booth_Area__c='Bangalore';
        insert order;

        GC_GES_Order_Task__c got = new GC_GES_Order_Task__c();
        got.Order__c = order.Id;
        got.Delivery_Location__c = 'testing';
        got.Department__c=GCshow.id;
        insert got;

       GC_Vendor_Order_Task__c vot = new GC_Vendor_Order_Task__c();
        vot.Order__c = order.Id;
        vot.Vendor__c=usr.Id;
        insert vot ;
        

        ApexPages.currentPage().getParameters().put('showId' , show.Id);
        cont = new GC_Community_HomePageController();

        cont.showId = show.Id;
        cont.show = show;
       
        cont.showDateDelivery = Date.today();
        cont.showDateCompletion = Date.today();
        cont.showDateRemoval = Date.today();      
        cont.createdDateFrom = Date.today();
        cont.createdDateTo = Date.today();       
        cont.modifiedDateFrom = Date.today();
        cont.modifiedDateTo = Date.today();
        cont.oponsiteContactPerson = new List<String>();
        cont.oponsiteContactPersonOther = new List<String>();
        cont.searchString = 'test';
        
        cont.SaveOrderFilter();
             
        String dt = cont.getDateString(Date.newInstance(2017, 10, 02));
        System.assertEquals(dt, '2017-10-02');
        pr = cont.loadPage();
        System.assertEquals(cont.gesOrders.size() , 1);

        pr = cont.searchResults();
        System.assertEquals(cont.gesOrders.size() , 0);
        pr = cont.resetSearch();
        System.assertEquals(cont.gesOrders.size() , 1);

        // TODO should actually unit test the filters one by one.
        //
        pr = cont.createOrder();
        System.assertEquals(pr.getUrl() , cont.orderCreatePage);

        pr = cont.printShow();
        System.assert(pr.getUrl().contains('GC_ShowOnTheGo'));
        pr=cont.sortColumn();
        System.assertEquals(cont.gesOrders.size() , 1);
        pr = cont.cloneOrder();
        
         pr = cont.resetSearch();
        
        System.assertEquals(cont.showDateDelivery, null);
        System.assertEquals(cont.showDateCompletion, null);
        System.assertEquals(cont.showDateRemoval, null);
        System.assertEquals(cont.createdDateFrom, null);
        System.assertEquals(cont.createdDateTo, null);
        System.assertEquals(cont.modifiedDateFrom, null);
        System.assertEquals(cont.modifiedDateTo, null);
        //System.assertEquals(cont.searchString, null);
        System.assertEquals(cont.department, null);
        System.assertEquals(cont.delivery, null);
        System.assertEquals(cont.venue, null);
        System.assertEquals(cont.vendor, null);
        //System.assertEquals(cont.Username, null);
        //System.assertEquals(cont.oponsiteContactPerson,null);
        //System.assertEquals(cont.oponsiteContactPersonOther,null);
        
        pr = cont.searchResults();
        cont.Username.add('Aishwarya');
        
        cont.show.job_number__c = '000012345';
        Pagereference prX=cont.loadPage();
    }
    
}