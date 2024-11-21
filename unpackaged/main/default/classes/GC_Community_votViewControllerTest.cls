/**
* @author Ethos Solutions - www.ethos.com
* @description Test code for the Vendor Order Task view controller
* 2016-04-12 : Original Version
**/
@isTest
public with sharing class GC_Community_votViewControllerTest {
    public static testMethod void showViewPage() {
        
        User accountManager = GC_TestUtils.createUser('GC Account Manager', 'TheManager', 'ofAccounts');
        Map<String, User> userDetails = GC_TestUtils.getPortalUsers();
        User vendor = userDetails.get('GC Community Vendor');

        User clientSO = userDetails.get('GC Community Client');

        GC_Connect2_Show__c show;
        GC_Order__c order;
        GC_Vendor_Order_Task__c vot; 
        GC_Show_Team_Member__c stm;
        
        System.runAs(accountManager){
            show = GC_TestUtils.getTestConnect2Show();
            
            stm = new GC_Show_Team_Member__c();
            stm.Connect2_Show__c = show.Id;
            stm.User__c = clientSO.Id;
            stm.Show_Role__c = 'Show Organizer';
            insert stm;

            order = new GC_Order__c();
            order.Connect2_Show__c = show.Id;
            insert order;

            vot = new GC_Vendor_Order_Task__c();
            vot.Order__c = order.Id;
            vot.Vendor__c = vendor.Id;
            vot.Vendor_Instructions__c = 'Please do this';
            insert vot;
        }

        System.runAs(vendor){
            GC_Connect2_Show__c vendorShow = GC_Connect2ShowDao.getInstance().getConnect2ShowById(show.Id);
            System.assertNotEquals(vendorShow, null);

            GC_Order__c vendorOrder = GC_OrderDao.getInstance().getOrderById(order.Id);
            System.assertNotEquals(vendorOrder, null);

            GC_Vendor_Order_Task__c vendorTask = GC_VendorOrderTaskDao.getInstance().getVendorOrderTaskById(vot.Id);
            System.assertNotEquals(vendorTask , null);

            GC_PageUtil.setParam('votId', vendorTask.Id);
            GC_PageUtil.setParam('showId', vendorShow.Id);
            GC_PageUtil.setParam('orderId', vendorOrder.Id);
            Test.startTest();
            GC_Community_votViewController cont = new GC_Community_votViewController();
            cont.showId = vendorShow.Id;
            PageReference pr;
            pr = cont.editRecord();
            System.assertEquals(pr.getUrl() , '/GC_Community_votCreateEdit?orderId=' + order.Id + '&showId=' + show.Id + '&votId=' + vot.Id);
            //Vendors cannot submit?
            //cont.submitRecord();
            
            //Database update allows users with read access to use functionality
            //pr = cont.cancel();
            //System.assert(pr.getUrl().contains('showId') && pr.getUrl().contains('orderId') && pr.getUrl().contains('GC_Community_OrderView'));
            
        }

        System.runAs(clientSO){
            GC_PageUtil.setParam('votId', vot.Id);
            GC_PageUtil.setParam('showId', show.Id);
            GC_PageUtil.setParam('orderId', order.Id);
            GC_Community_votViewController cont = new GC_Community_votViewController();
            cont.showId = show.Id;
            cont.submitRecord();
            PageReference pr;
            pr = cont.cancel();
            System.assert(pr.getUrl().contains('showId') && pr.getUrl().contains('orderId') && pr.getUrl().contains('GC_Community_OrderView'));

        }
        Test.StopTest();
    }

    public static testMethod void cloneVotTest(){
        
        User accountManager = GC_TestUtils.createUser('GC Account Manager', 'ManageThe', 'AccountOf');

        Map<String, User> userDetails = GC_TestUtils.getPortalUsers();
        User vendor = userDetails.get('GC Community Vendor');
        User clientSO = userDetails.get('GC Community Client');

        GC_Connect2_Show__c show;
        GC_Order__c order;
        GC_Vendor_Order_Task__c vot;
        GC_Show_Team_Member__c stm;

        System.runAs(accountManager){
        
            test.starttest();

            show = GC_TestUtils.getTestConnect2Show();

            stm = new GC_Show_Team_Member__c();
            stm.Connect2_Show__c = show.Id;
            stm.User__c = clientSO.Id;
            stm.Show_Role__c = 'Show Organizer';
            insert stm;

            order = new GC_Order__c();
            order.Connect2_Show__c = show.Id;
            insert order;

            vot = new GC_Vendor_Order_Task__c();
            vot.Order__c = order.Id;
            vot.Vendor__c = vendor.Id;
            vot.Vendor_Instructions__c = 'Please do this';
            vot.SelectAllOrderTasks__c = true;
            insert vot;
            
            test.stoptest();
        }
        System.runAs(clientSO){
            GC_Vendor_Order_Task__c clientTask = GC_VendorOrderTaskDao.getInstance().getVendorOrderTaskById(vot.Id);
            GC_PageUtil.setParam('votId', clientTask.Id);
            GC_PageUtil.setParam('showId', show.Id);
            GC_PageUtil.setParam('orderId', order.Id);

            GC_Community_votViewController cont = new GC_Community_votViewController();
            cont.showId = show.Id;
            cont.cloneTask();

            List<GC_Vendor_Order_Task__c> votQuery = [Select Id, Name From GC_Vendor_Order_Task__c];
            System.assertEquals(votQuery.size() , 2);
           
            GC_PageUtil.setParam('isClone', '1');
            GC_PageUtil.setParam('originalVotId', vot.Id);
            GC_Community_votCreateEditController votCreateCont = new GC_Community_votCreateEditController();
            votCreateCont.cancel();

        }
    }
}