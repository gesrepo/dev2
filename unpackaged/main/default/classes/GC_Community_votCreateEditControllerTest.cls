/**
* @author Ethos Solutions - www.ethos.com
* @description Test code for the Vendor Order Task controller
* 2016-04-12 : Original Version
**/
@isTest
public class GC_Community_votCreateEditControllerTest {

    public static testMethod void filterVen() 
    {
        Map<String, User> vendorDetails = GC_TestUtils.getPortalUsers();
        User vendor = vendorDetails.get('GC Community Vendor');

        GC_Connect2_Show__c show;
        GC_Show_Team_Member__c stm;
        GC_Order__c order;
        GC_Vendor_Order_Task__c vot;
        GC_Show_Attribute__c sa;
        
        Test.startTest();
            show = GC_TestUtils.getTestConnect2Show();
            
            order = new GC_Order__c();
            order.Connect2_Show__c = show.Id;
            insert order;
            
            sa = new GC_Show_Attribute__c();
            sa.Name_Unique__c = 'Test Attribute';
            sa.Connect2_Show__c = order.Connect2_Show__c;
            sa.RecordTypeId = GC_TestUtils.getRecordType('GC_Show_Attribute__c').get('Show Service').Id;
            sa.Name = 'Test Venue';
            insert sa;
            
             stm = new GC_Show_Team_Member__c(
            Connect2_Show__c = order.Connect2_Show__c,
            User__c = vendor.Id,
            Show_Role__c = 'Vendor',
            Service_Type__c = sa.Id);
            insert stm;
            
            vot = new GC_Vendor_Order_Task__c();
            vot.Order__c = order.Id;
            vot.Vendor__c = vendor.Id;
            vot.Service_Type__c = sa.Id;
            vot.Service_Type2__c = sa.Id;
            vot.Service_Type3__c = sa.Id;
            vot.Service_Type4__c = sa.Id;
            vot.Service_Type5__c = sa.Id;
            insert vot;
            Test.stopTest();
            
            GC_Connect2_Show__c vendorShow = GC_Connect2ShowDao.getInstance().getConnect2ShowById(show.Id);
            //System.assertNotEquals(vendorShow.Id , null);

            GC_Order__c vendorOrder = GC_OrderDao.getInstance().getOrderById(order.Id);
            //System.assertNotEquals(vendorOrder, null);

            GC_Vendor_Order_Task__c vendorTask = GC_VendorOrderTaskDao.getInstance().getVendorOrderTaskById(vot.Id);
            //System.assertNotEquals(vendorTask , null);
            
            GC_PageUtil.setParam('votId', vendorTask.Id);
            GC_PageUtil.setParam('showId', vendorShow.Id);
            GC_PageUtil.setParam('orderId', vendorOrder.Id);
            
            GC_Community_votCreateEditController cont = new GC_Community_votCreateEditController();
            
            cont.vendorSelect = 'Vendor1';
            cont.userslist = new List<SelectOption>();
            cont.vot.Service_Type__c = sa.Id;
            cont.filterVendors();
            
            cont.vendorSelect = 'Vendor2';
            cont.userslist1 = new List<SelectOption>();
            cont.vot.Service_Type2__c = sa.Id;
            cont.filterVendors();
            
            cont.vendorSelect = 'Vendor3';
            cont.userslist2 = new List<SelectOption>();
            cont.vot.Service_Type3__c = sa.Id;
            cont.filterVendors();
            
            cont.vendorSelect = 'Vendor4';
            cont.userslist3 = new List<SelectOption>();
            cont.vot.Service_Type4__c = sa.Id;
            cont.filterVendors();
            
            cont.vendorSelect = 'Vendor5';
            cont.userslist4 = new List<SelectOption>();
            cont.vot.Service_Type5__c = sa.Id;
            cont.filterVendors();
    }

    public static testMethod void saveVotPage() {
        User accountManager = GC_TestUtils.createUser('GC Account Manager', 'AccMan', 'ManAcc');
        Map<String, User> vendorDetails = GC_TestUtils.getPortalUsers();
        User vendor = vendorDetails.get('GC Community Vendor');

        GC_Connect2_Show__c show;
        GC_Show_Team_Member__c stm;
        GC_Order__c order;
        GC_Vendor_Order_Task__c vot;
         GC_Show_Attribute__c sa;
        
        System.runAs(accountManager){
             
            Test.startTest();
            show = GC_TestUtils.getTestConnect2Show();


            order = new GC_Order__c();
            order.Connect2_Show__c = show.Id;
            insert order;

            
            
            sa = new GC_Show_Attribute__c();
            sa.Name_Unique__c = 'Test Attribute';
            sa.Connect2_Show__c = order.Connect2_Show__c;
            sa.RecordTypeId = GC_TestUtils.getRecordType('GC_Show_Attribute__c').get('Show Service').Id;
            sa.Name = 'Test Venue';
            insert sa;
            
             stm = new GC_Show_Team_Member__c(
            Connect2_Show__c = order.Connect2_Show__c,
            User__c = vendor.Id,
            Show_Role__c = 'Vendor',
            Service_Type__c = sa.Id);
            insert stm;
            
            vot = new GC_Vendor_Order_Task__c();
            vot.Order__c = order.Id;
            vot.Vendor__c = vendor.Id;
            vot.Service_Type__c = sa.Id;
            vot.Service_Type2__c = sa.Id;
            vot.Service_Type3__c = sa.Id;
            vot.Service_Type4__c = sa.Id;
            vot.Service_Type5__c = sa.Id;
            insert vot;
            Test.stopTest();
        }

        //Vendor Should have read access only and not able to save Vendor Order Tasks
        System.runAs(vendor){
            GC_Connect2_Show__c vendorShow = GC_Connect2ShowDao.getInstance().getConnect2ShowById(show.Id);
            System.assertNotEquals(vendorShow.Id , null);

            GC_Order__c vendorOrder = GC_OrderDao.getInstance().getOrderById(order.Id);
            System.assertNotEquals(vendorOrder, null);

            GC_Vendor_Order_Task__c vendorTask = GC_VendorOrderTaskDao.getInstance().getVendorOrderTaskById(vot.Id);
            System.assertNotEquals(vendorTask , null);

            GC_PageUtil.setParam('votId', vendorTask.Id);
            GC_PageUtil.setParam('showId', vendorShow.Id);
            GC_PageUtil.setParam('orderId', vendorOrder.Id);

            GC_Community_votCreateEditController cont = new GC_Community_votCreateEditController();
            cont.vot.Vendor_Instructions__c = 'Do This';
            PageReference pr;
            pr = cont.saveRecord();

            GC_Vendor_Order_Task__c vendorTask2 = GC_VendorOrderTaskDao.getInstance().getVendorOrderTaskById(vot.Id);
            System.assertNotEquals(vendorTask2.Vendor_Instructions__c , 'Do This');
            
            cont.vendorSelect = 'Vendor1';
            cont.userslist = new List<SelectOption>();
            cont.vot.Service_Type__c = sa.Id;
            cont.filterVendors();
            
            cont.vendorSelect = 'Vendor2';
            cont.userslist1 = new List<SelectOption>();
            cont.vot.Service_Type2__c = sa.Id;
            cont.filterVendors();
            
            cont.vendorSelect = 'Vendor3';
            cont.userslist2 = new List<SelectOption>();
            cont.vot.Service_Type3__c = sa.Id;
            cont.filterVendors();
            
            cont.vendorSelect = 'Vendor4';
            cont.userslist3 = new List<SelectOption>();
            cont.vot.Service_Type4__c = sa.Id;
            cont.filterVendors();
            
            cont.vendorSelect = 'Vendor5';
            cont.userslist4 = new List<SelectOption>();
            cont.vot.Service_Type5__c = sa.Id;
            cont.filterVendors();
            
            cont.vot.SelectAllOrderTasks__c = true;
            cont.otDropDownReadOnly();
            
            cont.vot.SelectAllOrderTasks__c = false;
            cont.otDropDownReadOnly();

        }

        System.runAs(accountManager){
            GC_Vendor_Order_Task__c amTask = GC_VendorOrderTaskDao.getInstance().getVendorOrderTaskById(vot.Id);
            GC_PageUtil.setParam('votId', amTask.Id);
            GC_PageUtil.setParam('showId', show.Id);
            GC_PageUtil.setParam('orderId', order.Id);

            GC_Community_votCreateEditController cont = new GC_Community_votCreateEditController();
            cont.vot.Vendor_Instructions__c = 'Do This';
            PageReference pr;
            pr = cont.saveRecord();
            GC_Vendor_Order_Task__c amTask2 = GC_VendorOrderTaskDao.getInstance().getVendorOrderTaskById(vot.Id);
            System.assertEquals(amTask2.Vendor_Instructions__c , 'Do This');

            System.assert(pr.getUrl().contains('/GC_Community_votView') && pr.getUrl().contains('orderId') && pr.getUrl().contains('votId') && pr.getUrl().contains('showId'));
        }
    }

    public static testMethod void cancelVotPage() {

        User accountManager = GC_TestUtils.createUser('GC Account Manager', 'AccMan', 'ManAcc');
        Map<String, User> vendorDetails = GC_TestUtils.getPortalUsers();
        User vendor = vendorDetails.get('GC Community Vendor');

        GC_Connect2_Show__c show;
        GC_Order__c order;
        GC_Vendor_Order_Task__c vot;

        System.runAs(accountManager){
            show = GC_TestUtils.getTestConnect2Show();

            order = new GC_Order__c();
            order.Connect2_Show__c = show.Id;
            insert order;

            vot = new GC_Vendor_Order_Task__c();
            vot.Order__c = order.Id;
            vot.Vendor__c = vendor.Id;
            insert vot;
        }

        System.runAs(vendor){
            GC_Connect2_Show__c vendorShow = GC_Connect2ShowDao.getInstance().getConnect2ShowById(show.Id);
            GC_Vendor_Order_Task__c vendorTask = GC_VendorOrderTaskDao.getInstance().getVendorOrderTaskById(vot.Id);

            GC_PageUtil.setParam('votId', vendorTask.Id);
            GC_PageUtil.setParam('showId', vendorShow.Id);

            GC_Community_votCreateEditController cont = new GC_Community_votCreateEditController();

            PageReference pr;
            pr = cont.cancel();
            System.assertEquals(pr.getUrl() , '/GC_Community_OrderView');

        }
    }

    // TODO need tests for Clone / New vendor Order.
}