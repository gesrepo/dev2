/**
* @author Ethos Solutions - www.ethos.com
* @description Test for GES Order Task edit controller
* 2016-08-19 : Original Version
**/
@isTest
public class GC_GESOrderTaskEditControllerTest {

    @isTest
    public static void testNewTask() {
        User testUser = GC_TestUtils.createUser('GC Account Manager', 'Donald', 'Clinton');
        System.runAs(testUser) {
            PageReference pr;
            // Create an order
            GC_Order__c order = GC_TestUtils.getTestOrder();
            // We need to map the order with our test data booth area.
            order.Booth_Area_ID__c = '1390259';

            // Get a test session ID for working with unit tests.
            GC_Core_Session__c session = GC_CoreUtils.getSessionID();
            GC_PageUtil.setParam('_lkid', order.Id);

            ApexPages.StandardController sc = new ApexPages.StandardController(new GC_GES_Order_Task__c());
            GC_GESOrderTaskEditController cont = new GC_GESOrderTaskEditController(sc);
            System.assertNotEquals(null, cont.got);

            // Save the task we should get some errors because an item isn't selected
            cont.sessionLoad();
            cont.coreApi.obtainProducts();
           // System.assertNotEquals(0, cont.coreApi.productList.size());
            // ID should be null, we'haven't saved it
            System.assertEquals(null, cont.got.Id);

            // now select an item.
            cont.got.Item_Category_ID__c = '1896';
            cont.got.Item_Number__c = '300004';
            cont.got.Description__c = 'Test Item Description';

            // set the current task to populate the selected item.
            cont.coreApi.setCurrentTask(cont.got);

            cont.coreApi.selectItem();

            //System.assertNotEquals(null, cont.coreApi.selectedItem);
            System.assertEquals('Test Item Description', cont.got.Description__c);

            // Try to save the task, it should fail because quantity is required.
            cont.saveAction();
            System.assertEquals(false, cont.saveTask());

            cont.got.QuantityNum__c = 1;

            //System.assertEquals(true, cont.saveTask());

            pr = cont.saveAction();
            //system.debug(pr.getUrl());
            //System.assertEquals('/' + cont.got.Id, pr.getUrl());
        }
    }

    @isTest
    public static void testNewTaskCancel() {
        // TEST as Account Manager

        User testUser = GC_TestUtils.createUser('GC Account Manager', 'Donald', 'Clinton');
        System.runAs(testUser) {
            GC_PageUtil.setParam('retUrl', '/unittesting');
            PageReference pr;
            // Create an order
            GC_Order__c order = GC_TestUtils.getTestOrder();
            // We need to map the order with our test data booth area.
            order.Booth_Area_ID__c = '1390259';

            // Get a test session ID for working with unit tests.
            GC_Core_Session__c session = GC_CoreUtils.getSessionID();
            GC_PageUtil.setParam('_lkid', order.Id);

            ApexPages.StandardController sc = new ApexPages.StandardController(new GC_GES_Order_Task__c());
            GC_GESOrderTaskEditController cont = new GC_GESOrderTaskEditController(sc);
            System.assertNotEquals(null, cont.got);

            // Save the task we should get some errors because an item isn't selected
            cont.sessionLoad();
            cont.coreApi.obtainProducts();
           // System.assertNotEquals(0, cont.coreApi.productList.size());
            // ID should be null, we'haven't saved it
            System.assertEquals(null, cont.got.Id);

            // now select an item.
            cont.got.Item_Category_ID__c = '1896';
            cont.got.Item_Number__c = '300004';
            cont.got.Description__c = 'Test Item Description';

            // set the current task to populate the selected item.
            cont.coreApi.setCurrentTask(cont.got);

            cont.coreApi.selectItem();

            //System.assertNotEquals(null, cont.coreApi.selectedItem);
            System.assertEquals('Test Item Description', cont.got.Description__c);

            // Try to save the task, it should fail because quantity is required.
            cont.saveAction();
            System.assertEquals(false, cont.saveTask());

            cont.got.QuantityNum__c = 1;

            //System.assertEquals(true, cont.saveTask());

            pr = cont.cancelAction();
            system.debug(pr.getUrl());
            System.assertEquals('/unittesting', pr.getUrl());
        }
    }

    @isTest
    public static void testEditTaskAndCancel() {
        TaskEditControllerTestData testData = new TaskEditControllerTestData();

        System.runAs(testData.runasuser) {
            PageReference pr;
            // Create an order
            // We need to map the order with our test data booth area.

            // Get a test session ID for working with unit tests.
            GC_Core_Session__c session = GC_CoreUtils.getSessionID();
            GC_PageUtil.setParam('_lkid', testData.order.Id);

            ApexPages.StandardController sc = new ApexPages.StandardController(testData.got);
            GC_GESOrderTaskEditController cont = new GC_GESOrderTaskEditController(sc);
            pr = cont.cancelAction();
            system.debug(pr.getUrl());
            System.assertEquals('/apex/gc_ordertaskview', pr.getUrl());
        }
    }

    @isTest
    public static void testCloneTask() {
        TaskEditControllerTestData testData = new TaskEditControllerTestData();

        System.runAs(testData.runasuser) {
            PageReference pr;
            // Create an order
            // We need to map the order with our test data booth area.

            // Get a test session ID for working with unit tests.
            GC_Core_Session__c session = GC_CoreUtils.getSessionID();
            GC_PageUtil.setParam('isClone', '1');
            GC_PageUtil.setParam('_lkid', testData.order.Id);

            ApexPages.StandardController sc = new ApexPages.StandardController(testData.got);
            GC_GESOrderTaskEditController cont = new GC_GESOrderTaskEditController(sc);

            cont.sessionLoad();
            cont.coreApi.obtainProducts();
            //System.assertNotEquals(0, cont.coreApi.productList.size());

            // now select an item.
            cont.got.Item_Category_ID__c = '1896';
            cont.got.Item_Number__c = '300004';
            cont.got.Description__c = 'Test Item Description';

            // set the current task to populate the selected item.
            cont.coreApi.setCurrentTask(cont.got);
            cont.coreApi.selectItem();
            cont.got.QuantityNum__c = 1;

            DateTime startTestTime = DateTime.now();
            // saving should save a clone with a start time > now.
            pr = cont.saveAction();
            List<GC_GES_Order_Task__c> task = [select Id, Name from GC_GES_Order_Task__c where CreatedDate >= :startTestTime];
            System.assertNotEquals(0, task.size());
            Integer lastIndex = task.size() - 1;
            // Ids should be different
            System.assertNotEquals(testData.got.Id, task[lastIndex].Id);

        }
    }

    @isTest
    public static void testEditTaskAndChangeOrder() {
        TaskEditControllerTestData testData = new TaskEditControllerTestData();

        System.runAs(testData.runasuser) {
            GC_Order__c newOrder = new GC_Order__c();
            newOrder.Connect2_Show__c = testData.show.Id;
            newOrder.Booth_Area__c  = 'Area';
            newOrder.Booth_Area_ID__c = '1390259';
            insert newOrder;
            PageReference pr;
            // Create an order
            // We need to map the order with our test data booth area.

            // Get a test session ID for working with unit tests.
            GC_Core_Session__c session = GC_CoreUtils.getSessionID();
            GC_PageUtil.setParam('_lkid', testData.order.Id);

            ApexPages.StandardController sc = new ApexPages.StandardController(testData.got);
            GC_GESOrderTaskEditController cont = new GC_GESOrderTaskEditController(sc);
            cont.got.Order__c = newOrder.Id;
            pr = cont.orderChanged();

            // test for null order
            cont.got.Order__c = null;
            pr = cont.orderChanged();
        }
    }

    @isTest
    public static void testEditTaskAndApprove() {
        TaskEditControllerTestData testData = new TaskEditControllerTestData();

        System.runAs(testData.runasuser) {
            PageReference pr;
            // Create an order
            // We need to map the order with our test data booth area.

            // Get a test session ID for working with unit tests.
            GC_Core_Session__c session = GC_CoreUtils.getSessionID();

            ApexPages.StandardController sc = new ApexPages.StandardController(testData.got);
            GC_GESOrderTaskEditController cont = new GC_GESOrderTaskEditController(sc);

            // Save the task we should get some errors because an item isn't selected
            cont.sessionLoad();
            cont.coreApi.obtainProducts();
            // now select an item.
            cont.got.Item_Category_ID__c = '1896';
            cont.got.Item_Number__c = '300004';
            cont.got.Description__c = 'Test Item Description';

            // set the current task to populate the selected item.
            cont.coreApi.setCurrentTask(cont.got);

            cont.coreApi.selectItem();
            cont.got.QuantityNum__c = 1;

            System.assertEquals(true, cont.saveTask());

            pr = cont.saveAndApproveAction();
            GC_GES_Order_Task__c updatedTask = [select Id, Status__c from GC_GES_Order_Task__c where Id = :testData.got.Id];
            System.assertEquals(true, updatedTask.Status__c == 'Approved');
            System.assertEquals(true, pr.getUrl().contains('/' + cont.got.Id));
        }
    }

    @isTest
    public static void testEditTaskAndApproveAndNew() {
        TaskEditControllerTestData testData = new TaskEditControllerTestData();

        System.runAs(testData.runasuser) {
            PageReference pr;
            // Create an order
            // We need to map the order with our test data booth area.

            // Get a test session ID for working with unit tests.
            GC_Core_Session__c session = GC_CoreUtils.getSessionID();

            ApexPages.StandardController sc = new ApexPages.StandardController(testData.got);
            GC_GESOrderTaskEditController cont = new GC_GESOrderTaskEditController(sc);

            // Save the task we should get some errors because an item isn't selected
            cont.sessionLoad();
            cont.coreApi.obtainProducts();
            // now select an item.
            cont.got.Item_Category_ID__c = '1896';
            cont.got.Item_Number__c = '300004';
            cont.got.Description__c = 'Test Item Description';

            // set the current task to populate the selected item.
            cont.coreApi.setCurrentTask(cont.got);

            cont.coreApi.selectItem();
            cont.got.QuantityNum__c = 1;

            System.assertEquals(true, cont.saveTask());

            pr = cont.saveAndApproveAndNewAction();
            GC_GES_Order_Task__c updatedTask = [select Id, Status__c from GC_GES_Order_Task__c where Id = :testData.got.Id];
            System.assertEquals(true, updatedTask.Status__c == 'Approved');
            System.assertEquals(true, pr.getUrl().contains('GC_OrderTaskEdit'));
            System.assertEquals(true, pr.getUrl().contains('orderId_lkid'));
        }
    }



    @isTest
    public static void testCommunityLoad() {
        TaskEditControllerTestData testData = new TaskEditControllerTestData();
        PageReference pr;
        GC_PageUtil.setParam('gotId' , testData.got.Id);
        GC_PageUtil.setParam('showId', testData.show.Id);
        GC_PageUtil.setParam('orderId', testData.order.Id);
        
        System.runAs(testData.runasuser) {
            GC_CoreUtils.getSessionID();
            GC_GESOrderTaskEditController gotCont = new GC_GESOrderTaskEditController();
            
            gotCont.getCancelTitle();
            gotCont.getSaveTitle();
            gotCont.getSaveAndSubmitTitle();
            gotCont.getSaveAndApproveTitle();
            gotCont.getRemovalDateTimeFormatted();
            gotCont.referenceOrder = testData.order;
            gotCont.got = testData.got;
            gotCont.loadAction();
            gotCont.saveAction();
            gotCont.submitForApproval();
            gotCont.loadAction();
            gotCont.saveAction();
            gotCont.submitForApproval();
            
            List<GC_GES_Order_Task__c> gotList = GC_GESOrderTaskDao.getInstance().getByGesOrderId(testData.order.Id);
            System.assertEquals(gotList.size() , 1);
            System.assertEquals(gotList[0].Formula_Booth_Area__c , 'Area');
            System.assertEquals(gotList[0].Formula_Booth_Area_ID__c , '1390259');
            
            pr = gotCont.cancelAction();
            //System.assertEquals(true, pr.getUrl().contains('GC_Community_gotView'));
        }
    }

    @isTest
    public static void testCommunitySaveNew() {
        TaskEditControllerTestData testData = new TaskEditControllerTestData();

        PageReference pr;
        //GC_PageUtil.setParam('gotId' , testData.got.Id);
        GC_PageUtil.setParam('showId', testData.show.Id);
        GC_PageUtil.setParam('orderId', testData.order.Id);

        System.runAs(testData.runasuser) {
            GC_CoreUtils.getSessionID();
            GC_GESOrderTaskEditController cont = new GC_GESOrderTaskEditController();
            
            System.assertNotEquals(null, cont.got);
            
            // Save the task we should get some errors because an item isn't selected
            cont.sessionLoad();
            cont.coreApi.obtainProducts();
            //System.assertNotEquals(0, cont.coreApi.productList.size());
            
            // now select an item.
            cont.got.Item_Category_ID__c = '1896';
            cont.got.Item_Number__c = '300004';
            cont.got.Description__c = 'Test Item Description';
            
            // set the current task to populate the selected item.
            cont.coreApi.setCurrentTask(cont.got);
            
            cont.coreApi.selectItem();
            
            //System.assertNotEquals(null, cont.coreApi.selectedItem);
            System.assertEquals('Test Item Description', cont.got.Description__c);
            
            // Try to save the task, it should fail because quantity is required.
            cont.got.QuantityNum__c = null;
            cont.saveAction();
            System.assertEquals(false, cont.saveTask());
            
            cont.got.QuantityNum__c = 1;
            
            //System.assertEquals(true, cont.saveTask());
            
            pr = cont.saveAction();
            //system.debug(pr.getUrl());
            //System.assertEquals(true, pr.getUrl().contains('GC_Community_gotView'));
        }
    }

    @isTest
    public static void testCommunitySave() {
        TaskEditControllerTestData testData = new TaskEditControllerTestData();

        PageReference pr;
        GC_PageUtil.setParam('gotId' , testData.got.Id);
        GC_PageUtil.setParam('showId', testData.show.Id);
        GC_PageUtil.setParam('orderId', testData.order.Id);
        
        System.runAs(testData.runasuser) {
            GC_CoreUtils.getSessionID();
            GC_GESOrderTaskEditController cont = new GC_GESOrderTaskEditController();
            
            System.assertNotEquals(null, cont.got);
            
            // Save the task we should get some errors because an item isn't selected
            cont.sessionLoad();
            cont.coreApi.obtainProducts();
            // System.assertNotEquals(0, cont.coreApi.productList.size());
            
            // now select an item.
            cont.got.Item_Category_ID__c = '1896';
            cont.got.Item_Number__c = '300004';
            cont.got.Description__c = 'Test Item Description';
            
            // set the current task to populate the selected item.
            cont.coreApi.setCurrentTask(cont.got);
            
            cont.coreApi.selectItem();
            
            //System.assertNotEquals(null, cont.coreApi.selectedItem);
            System.assertEquals('Test Item Description', cont.got.Description__c);
            
            // Try to save the task, it should fail because quantity is required.
            cont.got.QuantityNum__c = null;
            cont.saveAction();
            System.assertEquals(false, cont.saveTask());
            
            cont.got.QuantityNum__c = 1;
            
            System.assertEquals(true, cont.saveTask());
            
            pr = cont.saveAction();
            system.debug(pr.getUrl());
            //System.assertEquals(true, pr.getUrl().contains('GC_Community_gotView'));
        }
    }

    @isTest
    public static void testCommunitySaveSubmit() {
        TaskEditControllerTestData testData = new TaskEditControllerTestData();

        PageReference pr;
        GC_PageUtil.setParam('gotId' , testData.got.Id);
        GC_PageUtil.setParam('showId', testData.show.Id);
        GC_PageUtil.setParam('orderId', testData.order.Id);
        
        System.runAs(testData.runasuser) {
            GC_CoreUtils.getSessionID();
            GC_GESOrderTaskEditController cont = new GC_GESOrderTaskEditController();
            
            System.assertNotEquals(null, cont.got);
            
            // Save the task we should get some errors because an item isn't selected
            cont.sessionLoad();
            cont.coreApi.obtainProducts();
            //System.assertNotEquals(0, cont.coreApi.productList.size());
            
            // now select an item.
            cont.got.Item_Category_ID__c = '1896';
            cont.got.Item_Number__c = '300004';
            cont.got.Description__c = 'Test Item Description';
            
            // set the current task to populate the selected item.
            cont.coreApi.setCurrentTask(cont.got);
            
            cont.coreApi.selectItem();
            
            //System.assertNotEquals(null, cont.coreApi.selectedItem);
            System.assertEquals('Test Item Description', cont.got.Description__c);
            
            // Try to save the task, it should fail because quantity is required.
            cont.got.QuantityNum__c = null;
            cont.saveAction();
            System.assertEquals(false, cont.saveTask());
            
            cont.got.QuantityNum__c = 1;
            
            System.assertEquals(true, cont.saveTask());
            
            pr = cont.submitForApproval();
            
            //System.assertEquals(true, GC_ApprovalUtils.isUnderApproval(cont.got.Id));
            
            //System.assertEquals(true, pr.getUrl().contains('GC_Community_gotView'));
        }
    }

    @isTest
    public static void testCommunityCloneCancel() {
        TaskEditControllerTestData testData = new TaskEditControllerTestData();
        PageReference pr;
        //GC_PageUtil.setParam('gotId' , testData.got.Id);
        GC_PageUtil.setParam('showId', testData.show.Id);
        GC_PageUtil.setParam('orderId', testData.order.Id);
        GC_PageUtil.setParam('isClone', '1');
        GC_PageUtil.setParam('originalGotId', testData.got.Id);

        GC_GESOrderTaskEditController cont = new GC_GESOrderTaskEditController();

        pr = cont.cancelAction();
        System.assertEquals(true, pr.getUrl().contains('GC_Community_gotView'));
    }

    @isTest
    public static void testCommunityCloneSave() {

        TaskEditControllerTestData testData = new TaskEditControllerTestData();
        PageReference pr;
        //GC_PageUtil.setParam('gotId' , testData.got.Id);
        GC_PageUtil.setParam('showId', testData.show.Id);
        GC_PageUtil.setParam('orderId', testData.order.Id);
        GC_PageUtil.setParam('isClone', '1');
        GC_PageUtil.setParam('originalGotId', testData.got.Id);

        GC_GESOrderTaskEditController cont = new GC_GESOrderTaskEditController();

        cont.sessionLoad();
        cont.coreApi.obtainProducts();
       // System.assertNotEquals(0, cont.coreApi.productList.size());
        // now select an item.
        cont.got.Item_Category_ID__c = '1896';
        cont.got.Item_Number__c = '300004';
        cont.got.Description__c = 'Test Item Description';

        // set the current task to populate the selected item.
        cont.coreApi.setCurrentTask(cont.got);
        cont.coreApi.selectItem();
        cont.got.QuantityNum__c = 1;

        DateTime startTestTime = DateTime.now();
        // saving should save a clone with a start time > now.
        pr = cont.saveAction();
        List<GC_GES_Order_Task__c> task = [select Id, Name from GC_GES_Order_Task__c where CreatedDate >= :startTestTime];
        //System.assertNotEquals(0, task.size());
        Integer lastIndex = task.size() - 1;
        // Ids should be different
        //System.assertNotEquals(testData.got.Id, task[lastIndex].Id);


        //System.assertEquals(true, pr.getUrl().contains('GC_Community_gotView'));
        
    }


    // TODO test carpet item, and validation upon save

    public class TaskEditControllerTestData {

        public GC_Connect2_Show__c show { get; set; }
        public GC_Show_Team_Member__c stm { get; set; }
        public GC_Order__c order { get; set;}
        public GC_GES_Order_Task__c got { get; set; }
        public User runasuser { get; set; }

        public TaskEditControllerTestData() {
            
            runasuser = GC_TestUtils.createUser('GC Account Manager', 'testAccount', 'manager');
            User runasuser1 = GC_TestUtils.createUser('GC Account Manager', 'testUser', 'manager');
            system.runAs(runasuser1){
                show = GC_TestUtils.getTestConnect2Show();
                show.Job_Number__c = '1';
                update show;
                
                stm = new GC_Show_Team_Member__c();
                stm.Connect2_Show__c = show.Id;
                stm.User__c = runasuser.Id;
                stm.Show_Role__c = 'Account Manager';
                insert stm;
                
                order = new GC_Order__c();
                order.Connect2_Show__c = show.Id;
                order.Booth_Area__c  = 'Area';
                order.Booth_Area_ID__c = '1390259';
                insert order;
                
                got = new GC_GES_Order_Task__c();
                got.Order__c = order.Id;
                got.Item_Category_ID__c = '1896';
                got.Item_Number__c = '300004';
                got.Item_Template__c = 'Basic';
                got.QuantityNum__c = 1;
                insert got;
            }
        }
    }
}