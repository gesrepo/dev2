@isTest
public class GC_OrderClone_ControllerTest {

    public static testMethod void Testorder1() {

        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();

        //GC_Order__c order = new GC_Order__c();
        //order.Connect2_Show__c = show.Id;
        //insert order;
        
        User usr = [SELECT Id, Name FROM User WHERE Id = :userinfo.getUserId() LIMIT 1];
        Map<String, User> portalUsers = GC_TestUtils.getPortalUsers();
        system.debug('portalUsers>>>>>'+portalUsers);
        User vendor = portalUsers.get('GC Community Vendor');
        string showId = show.Id;
        
        GC_Order__c order = new GC_Order__c();
        order.Connect2_Show__c = show.Id;
        order.Order_Area_Description__c = 'testing';
        order.Booth_Area__c='Bangalore';
        insert order;
        
        GC_Show_Attribute__c GCshow=new GC_Show_Attribute__c();
        GCshow.Connect2_Show__c =show.Id;
        GCshow.name='test';
        insert GCshow;

        GC_GES_Order_Task__c got = new GC_GES_Order_Task__c();
        got.Order__c = order.Id;
        got.Delivery_Location__c = 'testing';
        got.Department__c=GCshow.id;
        insert got;

       GC_Vendor_Order_Task__c vot = new GC_Vendor_Order_Task__c();
        vot.Order__c = order.Id;
        vot.Vendor__c=usr.Id;
        insert vot ;
        
        GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c();
        stm.Connect2_Show__c = order.Connect2_Show__c;
        stm.User__c = vendor.Id;
        stm.Show_Role__c = 'Vendor';
        insert stm;

        ApexPages.StandardController sc = new ApexPages.StandardController(show);
        GC_OrderHolder orderHolder = new GC_OrderHolder(order);
        orderHolder.selected = true;
        
        List<GC_OrderHolder> holderList = new List<GC_OrderHolder>();
        holderList.add(orderHolder);
        
        GC_OrderClone_Controller.GC_OrderHolder_WODL orderHolder1 = new GC_OrderClone_Controller.GC_OrderHolder_WODL(order);
        orderHolder1.selected = true;
        orderHolder1.newDeliveryLocation= '123456_test';
        
        List<GC_OrderClone_Controller.GC_OrderHolder_WODL> holderList1 = new List<GC_OrderClone_Controller.GC_OrderHolder_WODL>();
        holderList1.add(orderHolder1);
        
        ApexPages.currentPage().getParameters().put('Id' , showId);
        GC_OrderClone_Controller cont = new GC_OrderClone_Controller(sc);
        
        cont.selectedshow = show.Id;
        cont.showContent = true;
        //cont.orderHolders = new List<GC_OrderHolder>();

        cont.showId =  show.Id;
        cont.show = show;
        cont.Username = 'Aishwarya';
        cont.modifiedDateFrom = (Date.today());
        cont.modifiedDateTo = (Date.today());
        cont.createdDateFrom = (Date.today());
        cont.createdDateTo = (Date.today());
        cont.showDateDelivery = (Date.today());
        cont.showDateRemoval = (Date.today());
        cont.showDateCompletion = (Date.today());
        
        cont.vendor='Ethos';
        cont.TypeofUser='Internal';
        cont.votQuery ='Testing';
        cont.deliveryLocation = 'null';
        cont.department = 'null';
        cont.delivery = 'null';
        cont.venue = 'null';
        cont.vendor = 'null';
        cont.department = 'test 123';
        cont.Username='null';
        cont.searchString = 'test';
        cont.orderHolders = holderList;
        cont.orderHoldersWODL = holderList1;
        cont.getopenShowOptions();
        cont.selectedshow = show.Id;
        cont.itemsSelected();
        cont.cloneOrders();
        cont.cancelclone();
        cont.showContent = true;
        cont.toggleContent();
        cont.showContent = false;
        cont.deliveryLocationsFromShow = new Set<String>();
        cont.deliveryLocationsFromShow.Add('test');
        cont.selectedshow = show.Id;
        Test.startTest();
        cont.showOrderGrids();
        cont.mapDeliveryLocations();
        cont.showSelected();
        cont.searchResults();
                String dt = cont.getDateString(Date.newInstance(2017, 10, 02));
        System.assertEquals(dt, '2017-10-02');
        
        cont.resetSearch();
        Test.stopTest();
    }

}