@isTest
private class GC_OrderCreateEditControllerTest {
    public GC_CoreQuery coreApi {get; set;}
    public GC_CoreQuery.GC_ItemHolder selectedItem { get; set; } 
    GC_OrderCreateEditControllerTest(){
        
    }
    @isTest static void testInvalidJobNumberNew() {
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        show.Job_Number__c = '';
        update show;

        GC_Order__c order = new GC_Order__c();
        order.Connect2_Show__c = show.Id;
        order.Booth_Area__c  = 'Area';
        order.Booth_Area_ID__c = '1390259';

        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(order);
        ApexPages.currentPage().getParameters().put('_lkid' , show.Id);
        GC_OrderCreateEditController createEditController = new GC_OrderCreateEditController(sc);

        Test.stopTest();
    }

    @isTest static void testInvalidJobNumberView() {
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        show.Job_Number__c = '';
        update show;

        GC_Order__c order = new GC_Order__c();
        order.Connect2_Show__c = show.Id;
        order.Booth_Area__c  = 'Area';
        order.Booth_Area_ID__c = '1390259';
        insert order;

        //GC_PageUtil.setParam('showId', show.Id);
        //GC_PageUtil.setParam('orderId', order.Id);
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(order);
        GC_OrderCreateEditController createEditController = new GC_OrderCreateEditController(sc);
      
        Test.stopTest();
    }

    @isTest static void testNewOrder() {
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        show.Job_Number__c = '1';
        update show;

        GC_Order__c order = new GC_Order__c();
        order.Connect2_Show__c = show.Id;
        order.Booth_Area__c  = 'Area';
        order.Booth_Area_ID__c = '1390259';

        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(order);
        ApexPages.currentPage().getParameters().put('_lkid' , show.Id);
        GC_OrderCreateEditController createEditController = new GC_OrderCreateEditController(sc);

        Test.stopTest();
    }

    @isTest static void testNewOrderNoShow() {
        DateTime startTestDate = DateTime.Now();

        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        show.Job_Number__c = '';
        update show;

        GC_Order__c order = new GC_Order__c();
        order.Connect2_Show__c = show.Id;
        order.Booth_Area__c  = 'Area';
        order.Booth_Area_ID__c = '1390259';

        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(order);
        GC_OrderCreateEditController createEditController = new GC_OrderCreateEditController(sc);

        // return null;
        createEditController.showChanged();
        createEditController.CurrentOrder.Connect2_Show__c = show.Id;
        createEditController.showChanged();
        System.assert(createEditController.coreApi.isProjectValid == false);
        show.Job_Number__c = '1';
        update show;
        createEditController.showChanged();
        System.assert(createEditController.coreApi.isProjectValid == true);
        System.assert(createEditController.referenceShow != null);

        // This should actuall throw an exception in getBoothareas which is good coverage, and create a log.
        List<GC_Core_Interface_Log__c> logs = [select Id from GC_Core_Interface_Log__c where CreatedDate >= :startTestDate];
        System.assertEquals(logs.size(), 0);

        GC_Core_Session__c session = new GC_Core_Session__c();
        session.Core_Application_Session_ID__c = '7abacb3c-36f1-4963-a5e4-7e891ad26e43';
        session.Core_Application_Login_Expiration__c = DateTime.now() + 1;
        insert session;
        session = GC_CoreUtils.getSessionID();
        GC_TestUtils.simulateException = true;
        createEditController.showChanged();
        GC_TestUtils.simulateException = false;

        Test.stopTest();
    }

    @isTest static void testEditSaveOrder() {
        DateTime startTestDate = DateTime.Now();

        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        show.Job_Number__c = '1';
        update show;

        GC_Order__c order = new GC_Order__c();
        order.Connect2_Show__c = show.Id;
        order.Booth_Area__c  = 'Area';
        order.Booth_Area_ID__c = '1390259';
        
        insert order;

        //GC_PageUtil.setParam('showId', show.Id);
        //GC_PageUtil.setParam('orderId', order.Id);
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(order);
        GC_OrderCreateEditController createEditController = new GC_OrderCreateEditController(sc);

        createEditController.coreApi.obtainBoothAreas();
        List<GC_Core_Interface_Log__c> logs = [select Id from GC_Core_Interface_Log__c where CreatedDate >= :startTestDate];
        System.assertEquals(logs.size(), 0);

        GC_Core_Session__c session = GC_CoreUtils.getSessionID();

        createEditController.coreApi.coreSessionId = session.Core_Application_Session_ID__c;
        createEditController.loadAction();
        createEditController.sessionLoad();

        PageReference cancelPR = createEditController.cancelAction();

        String cancelPRurl = cancelPR.getUrl();
        System.assertEquals(cancelPRurl.contains('GC_OrderView') && cancelPRurl.contains('id=' + order.Id) , true);

        createEditController.coreApi.obtainBoothAreas();
        createEditController.coreApi.selectBoothArea();
        
        PageReference savePR = createEditController.saveAction();
        String savePRurl = savePR.getUrl();
        System.assertEquals(savePRurl.contains('GC_OrderView') && savePRurl.contains('id=' + order.Id) , true);

        GC_TestUtils.simulateException = true;
        createEditController.coreApi.obtainBoothAreas();
        logs = [select Id from GC_Core_Interface_Log__c where CreatedDate >= :startTestDate];
        System.assertEquals(logs.size(), 1);
        GC_TestUtils.simulateException = false;

        createEditController.coreApi.obtainBoothAreas();
        System.assertEquals('54321', createEditController.coreApi.showOccrProjectId);

        createEditController.coreApi.selectedBooth = '1390259';
        createEditController.coreApi.selectBoothArea();

        System.assertEquals('1390259', createEditController.CurrentOrder.Booth_Area_ID__c);
        SelectOption so = new SelectOption('' , '--None--');
        LargeSelectList lst = new LargeSelectList();
        lst.add(so);
        createEditController.coreApi.selectedBooth = '';
        createEditController.coreApi.selectBoothArea();
        createEditController.coreApi.selectedParentCategory='testParentCategory';
        createEditController.coreApi.selectedChildCategory='testChildCategory1';
        
         createEditController.coreApi.selectItem();
         SelectOption noneOption = new SelectOption('' , '--None--');
        noneOption.setValue('test');
         PageReference savePR1 = createEditController.saveAction();
            
        createEditController.getSaveTitle();
        createEditController.getCancelTitle();

        Test.stopTest();
    }

    @isTest static void testEditCancel() {
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        show.Job_Number__c = '1';
        update show;

        GC_Order__c order = new GC_Order__c();
        order.Connect2_Show__c = show.Id;
        order.Booth_Area__c  = 'Area';
        order.Booth_Area_ID__c = '1390259';
        insert order;

        Test.startTest();

        ApexPages.StandardController sc = new ApexPages.StandardController(order);
        GC_OrderCreateEditController cont = new GC_OrderCreateEditController(sc);
        cont.cancelAction();

        Test.stopTest();
    }

    @isTest static void testCloneSave() {
        PageReference pr;

        GC_GES_Order_Task__c orderTask = GC_TestUtils.setupOrderAndTask();
        GC_Order__c order = GC_OrderDao.getInstance().getOrderById(orderTask.Order__c);

        Test.startTest();

        GC_PageUtil.setParam('isClone', '1');

        ApexPages.StandardController sc = new ApexPages.StandardController(order);
        GC_OrderCreateEditController cont = new GC_OrderCreateEditController(sc);
        cont.sessionLoad();
        cont.coreApi.obtainBoothAreas();
        cont.coreApi.selectBoothArea();

        pr = cont.saveAction();

        List<GC_Order__c> newOrder = [select Id, Name from GC_Order__c where Id != :order.Id];
        List<GC_GES_Order_Task__c> newOrderTask = [select Id, Name from GC_GES_Order_Task__c where Id != :orderTask.Id];

        // we should have two clones, not equal to the parent
        System.assertNotEquals(0, newOrder.size());
        System.assertNotEquals(0, newOrderTask.size());

        Test.stopTest();
    }

    @isTest static void testCloneCancel() {
        PageReference pr;

        GC_GES_Order_Task__c orderTask = GC_TestUtils.setupOrderAndTask();
        GC_Order__c order = GC_OrderDao.getInstance().getOrderById(orderTask.Order__c);

        Test.startTest();

        Datetime startTime = DateTime.now();

        GC_PageUtil.setParam('isClone', '1');

        ApexPages.StandardController sc = new ApexPages.StandardController(order);
        GC_OrderCreateEditController cont = new GC_OrderCreateEditController(sc);
        cont.sessionLoad();
        cont.coreApi.obtainBoothAreas();
        cont.coreApi.selectBoothArea();

        pr = cont.cancelAction();

        Test.stopTest();

    }
     
    @isTest static void testCommunityCloneSaveAndCancel() {
        GC_GES_Order_Task__c orderTask = GC_TestUtils.setupOrderAndTask();
        GC_Order__c order = GC_OrderDao.getInstance().getOrderById(orderTask.Order__c);

        System.assertNotEquals(null, order.Connect2_Show__c);

        GC_PageUtil.setParam('originalOrderId', order.Id);
        GC_PageUtil.setParam('showId', order.Connect2_Show__c);
        GC_PageUtil.setParam('isClone', '1');

        GC_OrderCreateEditController cont = new GC_OrderCreateEditController();

        Test.setMock(WebServiceMock.class, new CORE_SECURITY_IMPLMockImpl());
        Test.setMock(WebServiceMock.class, new CORE_V2MockImpl());
        CORE_V2.BasicHttpBinding_IShowService ShowService = new CORE_V2.BasicHttpBinding_IShowService();

        CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService s = new CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService();
        GC_Core_Session__c session = new GC_Core_Session__c();
        session.Core_Application_Session_ID__c = '7abacb3c-36f1-4963-a5e4-7e891ad26e43';
        session.Core_Application_Login_Expiration__c = DateTime.now() + 1;
        insert session;

        session = GC_CoreUtils.getSessionID();


        cont.coreApi.coreSessionId = session.Core_Application_Session_ID__c;

        cont.coreApi.obtainBoothAreas();

        PageReference pg = cont.saveAction();

        // TODO why oh why, we need asserts here, need to know if clone saved.
        pg = cont.cancelAction();

    }
     @isTest static void testAllMethodsClassic(){
       Test.setMock(WebServiceMock.class, new CORE_V1MockImpl());
        CORE_V1.BasicHttpBinding_IProductService productService = new CORE_V1.BasicHttpBinding_IProductService();
        GC_Order__c order= GC_TestUtils.getTestOrder(); 
        GC_GES_Order_Task__c got = new GC_GES_Order_Task__c();
        got.Order__c = order.Id;
        got.Sign_Length__c = 10;
        got.Sign_Width__c = 10;
        got.Delivery_Date_Time__c = DateTime.now();
        got.Completion_Date_Time__c = DateTime.now() + 10;
        got.Removal_Date_Time__c = DateTime.now() + 15;
        got.QuantityNum__c = 5;
        got.Carpet_Length__c = 15;
        got.Carpet_Width__c = 15;
        //got.Revision__c = 1;
        got.Status__c = 'New';
        got.Item_Number__c = '400004';
        got.Item_Template__c = 'Carpet';
        got.UOM__c = 'SF';
        got.Electrical_Ordered__c = false;
        got.Electrical_Under__c = false;
        got.Parent_Category__c='test';
        got.Child_Category__c='test';
        got.Booth_Area_Discount__c=10;
        got.Description__c='Test Desc';
        insert got;
       
        
        ApexPages.StandardController sc = new ApexPages.StandardController(order);
        GC_OrderCreateEditController controller= new GC_OrderCreateEditController(sc);
        PageReference pr = controller.sessionLoad();
        controller.coreApi.obtainProducts();
        controller.coreApi.selectItem();
        controller.coreApi.obtainBoothAreas();
        controller.coreApi.selectBoothArea();
        controller.coreapi.setItemNumber= new set<string>();
        controller.coreapi.setItemNumber.add(got.Item_Number__c);
        Product_List__c prd = new Product_List__c();
        prd.Name = 'test';
        prd.Project_Number__c ='123456';
        prd.Show_Org_Products__c='test';

        insert prd;
        
         List<Product_List__c> productList = new  List<Product_List__c>();
         productList.add(prd);
        
        SelectOption so = new SelectOption('uniqueValue', 'displayValue');
       
       
        LargeSelectList lst = new LargeSelectList();
        lst.add(so);
         SelectOption noneOption = new SelectOption('' , '--None--');
        noneOption.setValue('test');
        controller.coreApi.populateProductList();
        controller.coreApi.emptyProductList();
        controller.coreApi.selectedParentCategory='Carpet';
        controller.coreApi.selectedChildCategory ='Autro';
        controller.coreApi.searchItemClick='searchItemHidden';
        controller.coreApi.selectedItemNumberAndDescription='400004_Test Desc';  
         
         controller.coreApi.selectItem();
         
        PageReference pg = controller.saveAction();
        List<SelectOption> childCategories= new  List<SelectOption>();
            childCategories.add(noneOption);
       controller.coreApi.selectCategories(); 
       controller.coreApi.setCurrentTask(got);
    
    }
    
}