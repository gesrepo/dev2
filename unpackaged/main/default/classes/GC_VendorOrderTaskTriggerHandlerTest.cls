/**
* @author Ethos Solutions - www.ethos.com
* @description Test code for Vendor Order Task trigger handler
* 2016-04-13 : Original Version
**/
@isTest
private class GC_VendorOrderTaskTriggerHandlerTest {

    @isTest static void TestInsertAndUpdate() {
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        GC_Order__c order = new GC_Order__c();
        order.Connect2_Show__c = show.Id;
        order.Booth_Area_ID__c = '1390259';
        order.Booth_Area__c = 'Area';
        insert order;
        GC_Vendor_Order_Task__c task = new GC_Vendor_Order_Task__c();
        task.Order__c = order.id;
        insert task;
        task.Vendor_Instructions__c = 'test instructions';
        update task;
    }

    @isTest
    private static void TriggerTest() {
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        GC_Order__c order = new GC_Order__c();
        order.Connect2_Show__c = show.Id;
        order.Booth_Area_ID__c = '1390259';
        order.Booth_Area__c = 'Area';
        insert order;
        GC_GES_Order_Task__c got = new GC_GES_Order_Task__c();
        got.Order__c = order.Id;
        insert got;

        Account acc = GC_TestUtils.getAccount();
        User vendor1 = GC_TestUtils.createPortalUser('GC Community Vendor', 'unit_test', 'vendor1', acc);
        User vendor2 = GC_TestUtils.createPortalUser('GC Community Vendor', 'unit_test', 'vendor2', acc);
        User vendor3 = GC_TestUtils.createPortalUser('GC Community Vendor', 'unit_test', 'vendor3', acc);
        User vendor4 = GC_TestUtils.createPortalUser('GC Community Vendor', 'unit_test', 'vendor4', acc);
        User vendor5 = GC_TestUtils.createPortalUser('GC Community Vendor', 'unit_test', 'vendor5', acc);

        Test.startTest();

        GC_Vendor_Order_Task__c vendorTask = new GC_Vendor_Order_Task__c();
        vendorTask.Order__c = order.Id;
        vendorTask.Vendor__c = vendor1.Id;
        vendorTask.Vendor2__c = vendor2.Id;
        vendorTask.Vendor3__c = vendor3.Id;
        vendorTask.Vendor4__c = vendor4.Id;
        vendorTask.Vendor5__c = vendor5.Id;
        insert vendorTask;
        
        GC_GES_Order_Task__c got2 = new GC_GES_Order_Task__c();
        got2.Order__c = order.Id;
        insert got2;
        
        List<GC_Show_Team_Member__c> stms = [select Id, User__r.Name from GC_Show_Team_Member__c where Connect2_Show__c = :show.Id AND Show_Role__c = 'Vendor'];
        //System.assertEquals(5, stms.size());

        vendorTask.Vendor_Instructions__c = 'test instructions';
        vendorTask.GESOrderTask1__c = got.Id;

        update vendorTask;

        // run as vendor user and verify access
        System.runAs(vendor5) {
            List<GC_GES_Order_Task__c> gots = [select Id, Name from GC_GES_Order_Task__c where Id = :got.id];
            System.assertEquals(1, gots.size());
            List<GC_Order__c> orders = [select Id, Name from GC_Order__c where Id = :order.id];
            System.assertEquals(1, orders.size());
            List<GC_Connect2_Show__c> shows = [select Id, Name from GC_Connect2_Show__c where Id = :show.Id];
            System.assertEquals(1, shows.size());
        }

        Test.stopTest();
    }

}