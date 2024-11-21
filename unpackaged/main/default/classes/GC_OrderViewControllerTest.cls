@isTest
private class GC_OrderViewControllerTest {
    
    @isTest static void testOrderViewController() {
        
        User accountManager = GC_TestUtils.createUser('GC Account Manager', 'TheManager', 'ofAccounts');
        accountManager.UserRoleId = [select Id from UserRole where Name = 'System Administrator'].Id;
        update accountManager;
        
        User accountMgr = GC_TestUtils.createUser('GC Account Manager', 'Test','AC01');
        accountMgr.GC_Show_Role__c='GC Account Manager; GC Creative Director; GC Traffic Administrator; GC Detailer; GC Director of Account Management; GC Sales Manager; GC Graphics Project Manager; GC Community Client; GC Community Vendor';
        update accountMgr;
        
        System.runAs(accountManager){
            
            GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
            show.Job_Number__c = '1';
            update show;

            GC_Show_Team_Member__c showTM1 = new GC_Show_Team_Member__c();
            showTM1.Connect2_Show__c= show.Id;
            showTM1.User__c= accountMgr.Id;
            showTM1.Show_Role__c= 'Account Manager';
            upsert showTM1;
            
            GC_Order__c order = new GC_Order__c();
            order.Connect2_Show__c = show.Id;
            order.Booth_Area__c  = 'Area';
            order.Booth_Area_ID__c = '1390259';
            insert order;
            
            GC_GES_Order_Task__c got = new GC_GES_Order_Task__c();
            got.Order__c = order.Id;
            got.Item_Category_ID__c = '1896';
            got.Description__c = 'Test Item Description';
            got.Item_Number__c = '300004';
            got.Item_Template__c = 'Basic';
            got.QuantityNum__c = 1;
            got.Status__c = 'New';
            got.Show_Management_Field__c = 'Yes';
            got.File_Reference_Link__c = 'link';
            got.Order_Line_ID__c = '123';
            insert got;
            
            GC_Vendor_Order_Task__c task = new GC_Vendor_Order_Task__c();
            task.Order__c = order.id;
            task.Vendor_Instructions__c = 'test instructions';
            insert task;
            
            got.Status__c = 'Approved';
            update got;
            Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(order);
            GC_OrderViewController orderViewController = new GC_OrderViewController(sc);
            
            Test.setMock(WebServiceMock.class, new CORE_SECURITY_IMPLMockImpl());
            Test.setMock(WebServiceMock.class, new CORE_V2MockImpl());
            
            CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService s = new CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService();
            GC_Core_Session__c session = new GC_Core_Session__c();
            session.Core_Application_Session_ID__c = '7abacb3c-36f1-4963-a5e4-7e891ad26e43';
            session.Core_Application_Login_Expiration__c = DateTime.now() + 1;
            insert session;
            
            session = GC_CoreUtils.getSessionID();
            
            orderViewController.coreSessionId = session.Core_Application_Session_ID__c;
            
            orderViewController.loadAction();
            orderViewController.sessionLoad();
            orderViewController.sessionLogin();
            
            orderViewController.editAction();
            
            PageReference clonePR = orderViewController.cloneAction();
            String clonePRurl = clonePR.getUrl();
            System.assertEquals(clonePRurl.contains('GC_OrderView') && clonePRurl.contains('id=' + order.Id) , false);
            
            orderViewController.approvalAction();
            
            //orderViewController.queryOrderStatus();
            //orderViewController.editBoothAreaAction();
            //System.assertEquals('54321', orderViewController.showOccrProjectId);
            
            //orderViewController.selectedBooth = '1390259';
            //orderViewController.selectBoothArea();
            
            //System.assertEquals('1390259', orderViewController.CurrentOrder.Booth_Area_ID__c);
            
            //orderViewController.selectedBooth = '';
            //orderViewController.selectBoothArea();
            
            //System.assertEquals(true, orderViewController.nullBoothArea);
            PageReference submitPR = orderViewController.submitOrderAction();
            PageReference cancelPR = orderViewController.cancelOrderAction();
            PageReference deletepr = orderViewController.deleteOrderAction();
            PageReference createorpr = orderViewController.createOrderTask();
            PageReference createvepr = orderViewController.createVendorTask();
            PageReference sumtPR = orderViewController.submitOrder();
            GC_PageUtil.setParam('taskId', task.Id);
            orderViewController.retrieveFiles();
            orderViewController.fileToUpload  = new ContentVersion(
                Title = 'Penguins',
                PathOnClient = 'Penguins.jpg',
                VersionData = Blob.valueOf('Test Content'),
                IsMajorVersion = true
            );
            orderViewController.doUploadFile();
            Test.stopTest();
        }
        
    }
    
    @isTest static void testOrderViewControllerDoFile() {
        
        User accountManager = GC_TestUtils.createUser('GC Account Manager', 'TheManager', 'ofAccounts');
        accountManager.UserRoleId = [select Id from UserRole where Name = 'System Administrator'].Id;
        update accountManager;
        
        User accountMgr = GC_TestUtils.createUser('GC Account Manager', 'Test','AC01');
        accountMgr.GC_Show_Role__c='GC Account Manager; GC Creative Director; GC Traffic Administrator; GC Detailer; GC Director of Account Management; GC Sales Manager; GC Graphics Project Manager; GC Community Client; GC Community Vendor';
        update accountMgr;
        
        System.runAs(accountManager){
            
            GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
            show.Job_Number__c = '1';
            update show;

            GC_Show_Team_Member__c showTM1 = new GC_Show_Team_Member__c();
            showTM1.Connect2_Show__c= show.Id;
            showTM1.User__c= accountMgr.Id;
            showTM1.Show_Role__c= 'Account Manager';
            upsert showTM1;
            
            GC_Order__c order = new GC_Order__c();
            order.Connect2_Show__c = show.Id;
            order.Booth_Area__c  = 'Area';
            order.Booth_Area_ID__c = '1390259';
            insert order;
            
            GC_GES_Order_Task__c got = new GC_GES_Order_Task__c();
            got.Order__c = order.Id;
            got.Item_Category_ID__c = '1896';
            got.Description__c = 'Test Item Description';
            got.Item_Number__c = '300004';
            got.Item_Template__c = 'Basic';
            got.QuantityNum__c = 1;
            got.Status__c = 'New';
            got.Show_Management_Field__c = 'Yes';
            got.File_Reference_Link__c = 'link';
            got.Order_Line_ID__c = '123';
            insert got;
            
            GC_Vendor_Order_Task__c task = new GC_Vendor_Order_Task__c();
            task.Order__c = order.id;
            task.Vendor_Instructions__c = 'test instructions';
            insert task;
            
            got.Status__c = 'Approved';
            update got;
            Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(order);
            GC_OrderViewController orderViewController = new GC_OrderViewController(sc);
            
            Test.setMock(WebServiceMock.class, new CORE_SECURITY_IMPLMockImpl());
            Test.setMock(WebServiceMock.class, new CORE_V2MockImpl());
            
            CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService s = new CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService();
            GC_Core_Session__c session = new GC_Core_Session__c();
            session.Core_Application_Session_ID__c = '7abacb3c-36f1-4963-a5e4-7e891ad26e43';
            session.Core_Application_Login_Expiration__c = DateTime.now() + 1;
            insert session;
            
            session = GC_CoreUtils.getSessionID();
            
            orderViewController.coreSessionId = session.Core_Application_Session_ID__c;
            
            orderViewController.loadAction();
            orderViewController.sessionLoad();
            orderViewController.sessionLogin();
            
            orderViewController.editAction();
            
            PageReference clonePR = orderViewController.cloneAction();
            String clonePRurl = clonePR.getUrl();
            System.assertEquals(clonePRurl.contains('GC_OrderView') && clonePRurl.contains('id=' + order.Id) , false);
            
            orderViewController.approvalAction();
            
            //orderViewController.queryOrderStatus();
            //orderViewController.editBoothAreaAction();
            //System.assertEquals('54321', orderViewController.showOccrProjectId);
            
            //orderViewController.selectedBooth = '1390259';
            //orderViewController.selectBoothArea();
            
            //System.assertEquals('1390259', orderViewController.CurrentOrder.Booth_Area_ID__c);
            
            //orderViewController.selectedBooth = '';
            //orderViewController.selectBoothArea();
            
            //System.assertEquals(true, orderViewController.nullBoothArea);
            PageReference submitPR = orderViewController.submitOrderAction();
            PageReference cancelPR = orderViewController.cancelOrderAction();
            PageReference deletepr = orderViewController.deleteOrderAction();
            PageReference createorpr = orderViewController.createOrderTask();
            PageReference createvepr = orderViewController.createVendorTask();
            PageReference sumtPR = orderViewController.submitOrder();
            orderViewController.retrieveFiles();
            orderViewController.fileToUpload  = new ContentVersion(
                Title = 'Penguins',
                PathOnClient = 'Penguins.jpg',
                VersionData = Blob.valueOf('Test Content'),
                IsMajorVersion = true
            );
            orderViewController.doUpload();
            Test.stopTest();
        }
        
    }
    
    @isTest static void submitOrderTest() {
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        show.Job_Number__c = '1';
        update show;
        
        GC_Show_Attribute__c sa = new GC_Show_Attribute__c();
        sa.Name_Unique__c = 'Test Attribute';
        sa.Connect2_Show__c = show.Id;
        sa.RecordTypeId = GC_TestUtils.getRecordType('GC_Show_Attribute__c').get('Venue Location').Id;
        sa.Name = 'Test Venue';
        insert sa;
        
        GC_Show_Attribute__c sa2 = new GC_Show_Attribute__c();
        sa2.Connect2_Show__c = show.Id;
        sa2.RecordTypeId = GC_TestUtils.getRecordType('GC_Show_Attribute__c').get('Material').Id;
        sa2.Name = 'Test Material';
        insert sa2;
        
        GC_Order__c order = new GC_Order__c();
        order.Connect2_Show__c = show.Id;
        order.Booth_Area__c  = 'Area';
        order.Booth_Area_ID__c = '1390259';
        insert order;
        
        GC_GES_Order_Task__c got = new GC_GES_Order_Task__c();
        got.Order__c = order.Id;
        got.Item_Category_ID__c = '1896';
        got.Item_Number__c = '300004';
        got.Description__c = 'Test Item Description';
        got.Item_Template__c = 'Basic';
        got.QuantityNum__c = 1;
        got.UOM__c = 'EA';
        got.Status__c = 'Approved';
        got.Show_Management_Field__c = 'Yes';
        got.File_Reference_Link__c = 'link';
        got.Completion_Date_Time__c = DateTime.Now();
        got.Removal_Date_Time__c = DateTime.Now();
        got.Delivery_Date_Time__c = DateTime.Now();
        got.Price__c = '11.59';
        got.New_Price__c = 12;
        got.SA_Venue_Location__c = sa.Id;
        got.Description__c = 'test Desciption';
        got.Invoice_Remarks__c = 'test remarks';
        got.Production_Remarks__c = 'test remarks';
        got.Item_Type_Remarks__c = 'test remarks';
        got.Show_Site_Remarks__c = 'test show site remarks';
        
        
        GC_GES_Order_Task__c got1 = new GC_GES_Order_Task__c();
        got1.Order__c = order.Id;
        got1.Item_Category_ID__c = '1896';
        got1.Item_Number__c = '300004';
        got1.Description__c = 'Test Item Description';
        got1.Item_Template__c = 'Graphics';
        got1.GOT_Single_Double_Sided__c = 'Double';
        got1.QuantityNum__c = 1;
        got1.Status__c = 'Approved';
        got1.Sign_Title__c = 'test sign';
        got1.Show_Management_Field__c = 'Yes';
        got1.File_Reference_Link__c = 'link';
        got1.Layout__c = 'test layout';
        got1.Sign_Copy__c = 'test copy';
        got1.Installation_Method__c = 'test installation method';
        got1.GOT_Sign_Type__c = 'sign type test';
        got1.GOT_Copy_Placement__c = 'copy placement';
        got1.Material__c = sa2.Id;
        got1.Save_Signs__c = 'yes';
        got1.GOT_Background__c = 'test background';
        
        
        GC_GES_Order_Task__c got2 = new GC_GES_Order_Task__c();
        got2.Order__c = order.Id;
        got2.Item_Category_ID__c = '1896';
        got2.Item_Number__c = '300004';
        got2.Description__c = 'Test Item Description';
        got2.Item_Template__c = 'Custom Graphics';
        got2.GOT_Single_Double_Sided__c = 'Single';
        got2.Sign_Length__c = 20;
        got2.Sign_Width__c = 15;
        got2.QuantityNum__c = 1;
        got2.Status__c = 'Approved';
        got2.Show_Management_Field__c = 'Yes';
        got2.File_Reference_Link__c = 'link';
        got2.Sign_Title__c = 'test sign';
        got2.Show_Management_Field__c = 'Yes';
        got2.File_Reference_Link__c = 'link';
        got2.Layout__c = 'test layout';
        got2.Sign_Copy__c = 'test copy';
        got2.Installation_Method__c = 'test installation method';
        got2.GOT_Sign_Type__c = 'sign type test';
        got2.GOT_Copy_Placement__c = 'copy placement';
        got2.Material__c = sa2.Id;
        got2.Save_Signs__c = 'yes';
        got2.GOT_Background__c = 'test background';
        
        GC_GES_Order_Task__c got3 = new GC_GES_Order_Task__c();
        got3.Order__c = order.Id;
        got3.Item_Category_ID__c = '1896';
        got3.Item_Number__c = '300004';
        got3.Description__c = 'Test Item Description';
        got3.Item_Template__c = 'Carpet';
        got3.Electrical_Ordered__c = false;
        got3.Electrical_Under__c = false;
        got3.UOM__c = 'EA';
        got3.QuantityNum__c = 1;
        got3.Status__c = 'Approved';
        got3.Show_Management_Field__c = 'Yes';
        got3.File_Reference_Link__c = 'link';
        
        GC_GES_Order_Task__c got4 = new GC_GES_Order_Task__c();
        got4.Order__c = order.Id;
        got4.Item_Category_ID__c = '1896';
        got4.Item_Number__c = '300004';
        got4.Description__c = 'Test Item Description';
        got4.Item_Template__c = 'Custom Carpet';
        got4.Electrical_Ordered__c = true;
        got4.Electrical_Under__c = true;
        got4.UOM__c = 'SF';
        got4.Carpet_Length__c = 10;
        got4.QuantityNum__c = 200;
        got4.Status__c = 'Approved';
        got4.Show_Management_Field__c = 'Yes';
        got4.File_Reference_Link__c = 'link';
        
        GC_GES_Order_Task__c got5 = new GC_GES_Order_Task__c();
        got5.Order__c = order.Id;
        got5.Status__c = 'New';
        
        insert got;
        insert got1;
        insert got2;
        insert got3;
        insert got4;
        insert got5;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(order);
        GC_OrderViewController cont = new GC_OrderViewController(sc);
        
        
        
        cont.submitOrderValidate();
        System.assertEquals(true, cont.hasItemstoSubmit);
        System.assertEquals(true, cont.hasValidationErrors);
        got4.Carpet_Width__c = 20;
        update got4;
        cont = new GC_OrderViewController(sc);
        
        GC_PageUtil.setParam('singleTaskId', got.Id);
        cont.submitOrderValidate();
        
        System.assertEquals(true, cont.hasItemstoSubmit);
        System.assertEquals(false, cont.hasValidationErrors);
        
        cont.submitOrderAction();
        cont.processOrderAction();
        
        // TODO create Show
        // TODO create Order
        // TODO create GES Order Task with Status Approved.
        // TODO create Vendor Order Task
        // TODO Load the page
        // TODO Approve a Task
    }
    
    @isTest static void submittoCoreTest() {
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        show.Job_Number__c = '1';
        update show;
        
        GC_Show_Attribute__c sa = new GC_Show_Attribute__c();
        sa.Name_Unique__c = 'Test Attribute';
        sa.Connect2_Show__c = show.Id;
        sa.RecordTypeId = GC_TestUtils.getRecordType('GC_Show_Attribute__c').get('Venue Location').Id;
        sa.Name = 'Test Venue';
        insert sa;
        
        GC_Show_Attribute__c sa2 = new GC_Show_Attribute__c();
        sa2.Connect2_Show__c = show.Id;
        sa2.RecordTypeId = GC_TestUtils.getRecordType('GC_Show_Attribute__c').get('Material').Id;
        sa2.Name = 'Test Material';
        insert sa2;
        
        GC_Order__c order = new GC_Order__c();
        order.Connect2_Show__c = show.Id;
        order.Booth_Area__c  = 'Area';
        order.Booth_Area_ID__c = '1390259';
        insert order;
        
        GC_GES_Order_Task__c got = new GC_GES_Order_Task__c();
        got.Order__c = order.Id;
        got.Item_Category_ID__c = '1896';
        got.Item_Number__c = '300004';
        got.Description__c = 'Test Item Description';
        got.Item_Template__c = 'Basic';
        got.QuantityNum__c = 1;
        got.UOM__c = 'EA';
        got.Status__c = 'Approved';
        got.Show_Management_Field__c = 'Yes';
        got.File_Reference_Link__c = 'link';
        got.Completion_Date_Time__c = DateTime.Now();
        got.Removal_Date_Time__c = DateTime.Now();
        got.Delivery_Date_Time__c = DateTime.Now();
        got.Price__c = '11.59';
        got.New_Price__c = 12;
        got.SA_Venue_Location__c = sa.Id;
        got.Description__c = 'test Desciption';
        got.Invoice_Remarks__c = 'test remarks';
        got.Production_Remarks__c = 'test remarks';
        got.Item_Type_Remarks__c = 'test remarks';
        got.Show_Site_Remarks__c = 'test show site remarks';
        
        
        GC_GES_Order_Task__c got1 = new GC_GES_Order_Task__c();
        got1.Order__c = order.Id;
        got1.Item_Category_ID__c = '1896';
        got1.Item_Number__c = '300004';
        got1.Description__c = 'Test Item Description';
        got1.Item_Template__c = 'Graphics';
        got1.GOT_Single_Double_Sided__c = 'Double';
        got1.QuantityNum__c = 1;
        got1.Status__c = 'Approved';
        got1.Sign_Title__c = 'test sign';
        got1.Show_Management_Field__c = 'Yes';
        got1.File_Reference_Link__c = 'link';
        got1.Layout__c = 'test layout';
        got1.Sign_Copy__c = 'test copy';
        got1.Installation_Method__c = 'test installation method';
        got1.GOT_Sign_Type__c = 'sign type test';
        got1.GOT_Copy_Placement__c = 'copy placement';
        got1.Material__c = sa2.Id;
        got1.Save_Signs__c = 'yes';
        got1.GOT_Background__c = 'test background';
        
        
        GC_GES_Order_Task__c got2 = new GC_GES_Order_Task__c();
        got2.Order__c = order.Id;
        got2.Item_Category_ID__c = '1896';
        got2.Item_Number__c = '300004';
        got2.Description__c = 'Test Item Description';
        got2.Item_Template__c = 'Custom Graphics';
        got2.GOT_Single_Double_Sided__c = 'Single';
        got2.Sign_Length__c = 20;
        got2.Sign_Width__c = 15;
        got2.QuantityNum__c = 1;
        got2.Status__c = 'Approved';
        got2.Show_Management_Field__c = 'Yes';
        got2.File_Reference_Link__c = 'link';
        got2.Sign_Title__c = 'test sign';
        got2.Show_Management_Field__c = 'Yes';
        got2.File_Reference_Link__c = 'link';
        got2.Layout__c = 'test layout';
        got2.Sign_Copy__c = 'test copy';
        got2.Installation_Method__c = 'test installation method';
        got2.GOT_Sign_Type__c = 'sign type test';
        got2.GOT_Copy_Placement__c = 'copy placement';
        got2.Material__c = sa2.Id;
        got2.Save_Signs__c = 'yes';
        got2.GOT_Background__c = 'test background';
        
        GC_GES_Order_Task__c got3 = new GC_GES_Order_Task__c();
        got3.Order__c = order.Id;
        got3.Item_Category_ID__c = '1896';
        got3.Item_Number__c = '300004';
        got3.Description__c = 'Test Item Description';
        got3.Item_Template__c = 'Carpet';
        got3.Electrical_Ordered__c = false;
        got3.Electrical_Under__c = false;
        got3.UOM__c = 'EA';
        got3.QuantityNum__c = 1;
        got3.Status__c = 'Approved';
        got3.Show_Management_Field__c = 'Yes';
        got3.File_Reference_Link__c = 'link';
        
        GC_GES_Order_Task__c got4 = new GC_GES_Order_Task__c();
        got4.Order__c = order.Id;
        got4.Item_Category_ID__c = '1896';
        got4.Item_Number__c = '300004';
        got4.Description__c = 'Test Item Description';
        got4.Item_Template__c = 'Custom Carpet';
        got4.Electrical_Ordered__c = true;
        got4.Electrical_Under__c = true;
        got4.UOM__c = 'SF';
        got4.Carpet_Length__c = 10;
        got4.QuantityNum__c = 200;
        got4.Status__c = 'Approved';
        got4.Show_Management_Field__c = 'Yes';
        got4.File_Reference_Link__c = 'link';
        
        GC_GES_Order_Task__c got5 = new GC_GES_Order_Task__c();
        got5.Order__c = order.Id;
        got5.Status__c = 'New';
        
        insert got;
        insert got1;
        insert got2;
        insert got3;
        insert got4;
        insert got5;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(order);
        GC_OrderViewController cont = new GC_OrderViewController(sc);
        cont.singleTaskId = got4.Id;
        
        cont.submitOrderValidate();
        System.assertEquals(true, cont.hasItemstoSubmit);
        System.assertEquals(true, cont.hasValidationErrors);
        
        cont.submitOrderAction();
        cont.processOrderAction();
        
    }
    
    
    
    @isTest static void cancelOrderTest() {
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        show.Job_Number__c = '1';
        update show;
        
        GC_Order__c order = new GC_Order__c();
        order.Connect2_Show__c = show.Id;
        order.Booth_Area__c  = 'Area';
        order.Booth_Area_ID__c = '1390259';
        insert order;
        
        GC_GES_Order_Task__c got = new GC_GES_Order_Task__c();
        got.Order__c = order.Id;
        got.Item_Category_ID__c = '1896';
        got.Order_Line_ID__c = '1896';
        got.Core_Cancelled__c = false;
        got.Item_Number__c = '300004';
        got.Item_Template__c = 'Basic';
        got.QuantityNum__c = 1;
        got.Status__c = 'Canceled';
        got.Show_Management_Field__c = 'Yes';
        got.File_Reference_Link__c = 'link';
        insert got;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(order);
        GC_OrderViewController cont = new GC_OrderViewController(sc);
        
        cont.cancelOrderValidate();
        System.assertEquals(true, cont.hasItemstoCancel);
        
        cont.cancelOrderAction();
        cont.processCancelOrderAction();
    }
    
    @isTest static void validationTest() {
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        show.Job_Number__c = '1';
        update show;
        
        GC_Order__c order = new GC_Order__c();
        order.Connect2_Show__c = show.Id;
        order.Booth_Area__c  = 'Area';
        order.Booth_Area_ID__c = '1390259';
        insert order;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(order);
        GC_OrderViewController cont = new GC_OrderViewController(sc);
        cont.submitOrderValidate();
        cont.cancelOrderValidate();
        GC_OrderViewController.GesTaskWrapper taskWrapper = cont.selectedGesTask;
        //cont.clearDiscountValues();
    }
    
    
/* @isTest static void testCommunityConstructor() {
        Map<String, User> portalUsers = GC_TestUtils.getPortalUsers();
        
        User clientUser = portalUsers.get('GC Community Client');
        User vendor = portalUsers.get('GC Community Vendor');
        
        GC_GES_Order_Task__c orderTask = GC_TestUtils.setupOrderAndTask();
        GC_Order__c order = GC_OrderDao.getInstance().getOrderById(orderTask.Order__c);
     
       GC_Connect2_Show__c show;
     GC_Show_Attribute__c sa;
         sa = new GC_Show_Attribute__c();
            sa.Name_Unique__c = 'Test Attribute';
            sa.Connect2_Show__c = order.Connect2_Show__c;
            sa.RecordTypeId = GC_TestUtils.getRecordType('GC_Show_Attribute__c').get('Show Service').Id;
            sa.Name = 'Test Venue';
            insert sa;
        
        GC_Show_Team_Member__c clientMember = new GC_Show_Team_Member__c(Connect2_Show__c = order.Connect2_Show__c,
                                                                         User__c = clientUser.Id,
                                                                         Show_Role__c = 'Show Organizer',
                                                                        Service_Type__c = sa.Id);
        insert clientMember;
        
        GC_Show_Team_Member__c vendorMember = new GC_Show_Team_Member__c(Connect2_Show__c = order.Connect2_Show__c,
                                                                         User__c = vendor.Id,
                                                                         Show_Role__c = 'Vendor',
                                                                        Service_Type__c = sa.Id);
        insert vendorMember;
        Test.startTest();
        GC_Vendor_Order_Task__c vendorTask = GC_TestUtils.getTestVendorTask(order.Id, vendor.Id);
        
        
        
        //System.runAs(clientUser) {
            GC_GES_Order_Task__c orderTask2 = GC_TestUtils.getTestOrderTask(order.Id, null);
            
            GC_PageUtil.setParam('showId', order.Connect2_Show__c);
            GC_PageUtil.setParam('orderId', order.Id);
            GC_PageUtil.setParam('taskId', orderTask2.Id);
            GC_OrderViewController cont = new GC_OrderViewController();
            
            System.assert(cont.CanCreate);
            System.assert(cont.CanSubmit);
            System.assert(cont.CanEdit);
            System.assert(cont.CanClone);
            
            PageReference pg = cont.loadAction();
            System.assertEquals(null, pg);
            pg = cont.editTask();
            pg = cont.cancelEditTask();
            pg = cont.cloneTask();
            pg = cont.reviseTask();
            pg = cont.cancelTask();
            pg = cont.approveTask();
            pg = cont.reworkTask();
            pg = cont.printOrder();
            pg = cont.placeOnHoldTask();
            pg = cont.releaseFromHoldTask();
            cont.retrieveFiles();
            cont.fileToUpload  = new ContentVersion(
              Title = 'Penguins',
              PathOnClient = 'Penguins.jpg',
              VersionData = Blob.valueOf('Test Content'),
              IsMajorVersion = true
            );
            cont.doUpload();
            //pg= cont.doUpload();
            
             PageReference pg1 = cont.editAction();        
             System.assertNotEquals(null, pg1);
            
              PageReference pg2 = cont.cloneAction();
            System.assertNotEquals(null, pg2);
            
             PageReference pg3 = cont.createOrderTask();
             System.assertNotEquals(null, pg3);
            
             PageReference pg4 = cont.createVendorTask();
             System.assertNotEquals(null, pg4);
           
             PageReference pg5 = cont.submitOrder();
             System.assertNotEquals(null, pg5);
            
            String title = cont.getCommunitySubmitTitle();
            title = cont.getSubmitTitle();
            title = cont.getPrintOrderTitle();
            title = cont.getEditTitle();
            title = cont.getCloneTitle();
            title = cont.getDeleteTitle();
            title = cont.getCreateNewGesTask();
            title = cont.getCreateNewVendorTask();
            
        //}
        
        Test.stopTest();
        
    } */
    
    @isTest static void orderViewOperations() {
        
        GC_OrderViewController cont = new GC_OrderViewController();
        
        PageReference pg = cont.newTask();
        //System.assertNotEquals(null, pg);
        
        pg = cont.cloneOrderTask();
        System.assertNotEquals(null, pg);
               
       // pg = cont.submitToGPM();
        //System.assertNotEquals(null, pg);
        
        //pg = cont.deleteTask();
        //System.assertNotEquals(null, pg);
        
        //pg = cont.submitGraphicsTask();
        //System.assertNotEquals(null, pg);
        
        
    }
    
    
    @isTest static void testCommunityActions() {
        
        User accountManager = GC_TestUtils.createUser('GC Account Manager', 'TheManager', 'ofAccounts');
        accountManager.UserRoleId = [select Id from UserRole where Name = 'System Administrator'].Id;
        update accountManager;

        Map<String, User> portalUsers;        
        User clientUser;
        GC_GES_Order_Task__c orderTask;
        GC_Order__c order;
        GC_Show_Team_Member__c clientMember;
        GC_Core_Session__c session;

        System.runAs(accountManager){
            
            portalUsers = GC_TestUtils.getPortalUsers();
            clientUser = portalUsers.get('GC Community Client');
            orderTask = GC_TestUtils.setupOrderAndTask();
            order = GC_OrderDao.getInstance().getOrderById(orderTask.Order__c);
            
             clientMember = new GC_Show_Team_Member__c(
                Connect2_Show__c = order.Connect2_Show__c,
                User__c = clientUser.Id,
                Show_Role__c = 'Show Organizer');
            insert clientMember;
            
            Test.setMock(WebServiceMock.class, new CORE_SECURITY_IMPLMockImpl());
            Test.setMock(WebServiceMock.class, new CORE_V2MockImpl());
            CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService s = new CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService();
            session = GC_TestUtils.createTestSession();
            
  
        
        
        GC_Connect2_Show__c show = [Select Id, Job_Number__c From GC_Connect2_Show__c where Id = : order.Connect2_Show__c];
        
        
        
        
            GC_GES_Order_Task__c orderTask2 = GC_TestUtils.getTestOrderTask(order.Id, null);
            
            GC_PageUtil.setParam('showId', order.Connect2_Show__c);
            GC_PageUtil.setParam('orderId', order.Id);
            GC_PageUtil.setParam('taskId', orderTask2.Id);
            Test.startTest();
            GC_OrderViewController cont = new GC_OrderViewController();
            
            PageReference pg = cont.loadAction();
            
            pg = cont.editTask();
            pg = cont.cancelEditTask();
            pg = cont.cloneTask();
            pg = cont.reviseTask();
            pg = cont.cancelTask();
            pg = cont.approveTask();
            pg = cont.reworkTask();
            pg = cont.printOrder();
            pg = cont.placeOnHoldTask();
            pg = cont.releaseFromHoldTask();
            //pg=cont.doUpload();
            pg = cont.SelectTaskToSubmit();
            pg = cont.validateSessionID();
            pg = cont.cloneOrderTaskNonCommunity();
            pg = cont.moveOrderTaskNonCommunity();
            //pg = cont.sendEmail();
            pg = cont.sendEmail1();
            pg = cont.saveDefaultandSendEmail();
            pg = cont.cancelButtonCLick();
            //pg = cont.recallTask();
            
            //pg = cont.clearDiscountValues();
           //cont.submitToGPM();
            cont.updateGraphicsTasks(order.Id);
            //cont.submitGraphicsTask();
            cont.insertCoreLogs();
            //cont.submitToAMReview();
            cont.setShowAttributeFlag();
            cont.submitToGPM();
            cont.toggleAdditionalOptions();
            
            //cont.deleteVendorTask();
            
            
        }
        
        Test.stopTest();
    }
    
    @isTest static void testCommunityOrderActions() {
        
        
        
        Map<String, User> portalUsers;
        
        User clientUser;
        User vendor;
        User accountManger;
        //new code
        //
        User accountManager = GC_TestUtils.createUser('GC Account Manager', 'TheManager', 'ofAccounts');
        accountManager.UserRoleId = [select Id from UserRole where Name = 'System Administrator'].Id;
        update accountManager;
        
         GC_Connect2_Show__c show;
        GC_Vendor_Order_Task__c vot;
        GC_Show_Attribute__c sa;
       
        GC_GES_Order_Task__c orderTask;
        GC_Order__c order;
        GC_Show_Team_Member__c clientMember;
        GC_Show_Team_Member__c clientMember1;
        GC_Core_Session__c session;
            
        System.runAs(accountManager){
            
            portalUsers = GC_TestUtils.getPortalUsers();
            clientUser = portalUsers.get('GC Community Client');
            vendor = portalUsers.get('GC Community Vendor');
            accountManger = portalUsers.get('GC Account Manager');
            
            orderTask = GC_TestUtils.setupOrderAndTask();
            order = GC_OrderDao.getInstance().getOrderById(orderTask.Order__c);
            
            
            sa = new GC_Show_Attribute__c();
            sa.Name_Unique__c = 'Test Attribute';
            sa.Connect2_Show__c = order.Connect2_Show__c;
            sa.RecordTypeId = GC_TestUtils.getRecordType('GC_Show_Attribute__c').get('Show Service').Id;
            sa.Name = 'Test Venue';
            insert sa;
            
            clientMember = new GC_Show_Team_Member__c(
                Connect2_Show__c = order.Connect2_Show__c,
                User__c = clientUser.Id,
                Show_Role__c = 'Show Organizer',
                Service_Type__c =sa.Id );
            insert clientMember;
            
            //   GC_Show_Team_Member__c clientMember2 = new GC_Show_Team_Member__c(
            //       Connect2_Show__c = order.Connect2_Show__c,
            //       User__c = accountManger.Id,
            //       Show_Role__c = 'Account Manager');
            //   insert clientMember2;
            
            
            clientMember1 = new GC_Show_Team_Member__c(
                Connect2_Show__c = order.Connect2_Show__c,
                User__c = vendor.Id,
                Show_Role__c = 'Vendor',
                Service_Type__c =sa.Id);
            insert clientMember1;
            
            Test.setMock(WebServiceMock.class, new CORE_SECURITY_IMPLMockImpl());
            Test.setMock(WebServiceMock.class, new CORE_V2MockImpl());
            CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService s = new CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService();
            session = GC_TestUtils.createTestSession();
        }
        
        
        //GC_Connect2_Show__c show = [Select Id, Job_Number__c From GC_Connect2_Show__c where Id = : order.Connect2_Show__c ];
        
        Test.startTest();
        
        System.runAs(clientUser) {
            
            //newtask
            GC_PageUtil.setParam('showId', order.Connect2_Show__c);
            GC_PageUtil.setParam('orderId', order.Id);
            
            order.Booth_Area_ID__c = '1390259';
            GC_OrderViewController cont = new GC_OrderViewController();
            
            PageReference pg = cont.loadAction();
            //cont.coreApi.showProjectNumber = show.Job_Number__c;
            cont.coreApi.isProjectValid = String.isNotBlank(cont.coreApi.showProjectNumber);
            cont.coreApi.selectedBooth = String.valueof(order.Booth_Area_ID__c);
            cont.coreApi.selectedBoothName = String.valueof(order.Booth_Area__c);
            cont.coreApi.obtainProducts();
           cont.deliveryDateTime = Datetime.now();
           cont.removalDateTime = Datetime.now();
           cont.completionDateTime = Datetime.now();
            //New Task
            cont.newTask();
            cont.selectedGesTask= new GC_OrderViewController.GesTaskWrapper();
            cont.selectedGesTask.task = new GC_GES_Order_Task__c();  
            if (cont.currentOrder != null && String.isNotBlank(cont.currentOrder.Id)) {
                cont.selectedGesTask.task.Order__c = cont.currentOrder.Id;
            }              
            cont.selectedGesTask.task.Item_Category_ID__c = '1896';
            cont.coreApi.setCurrentTask(cont.selectedGesTask.task);
            
           
            
            cont.coreApi.selectCategories();
            //System.assertNotEquals(0, productList.size());
            
            cont.coreApi.getProductSelected();
            cont.coreApi.obtainBoothAreas();
            //cont.coreApi.selectBoothArea();
            
            
            cont.selectedGesTask.task.Item_Number__c = '300004';
            cont.selectedGesTask.task.Description__c = 'Test Item Description';
            cont.coreApi.setCurrentTask(cont.selectedGesTask.task);
            
            cont.coreApi.selectItem();
            
            System.assertNotEquals(null, cont.selectedGesTask.task.Item_Number__c);
            
            System.assertNotEquals(null, cont.selectedGesTask.task);
            
            //System.assertNotEquals(null, cont.coreApi.selectedItem);
            cont.selectedGesTask.task.Item_Template__c = 'Basic';
            
            cont.selectedGesTask.task.QuantityNum__c = 1;
            
            cont.saveTask();
            
            List<GC_GES_Order_Task__c> gots = [Select Id, Order__c,Status__c From GC_GES_Order_Task__c Where Order__c = :order.Id];
            System.assertEquals(2, gots.size());
            
            //revise task
            GC_PageUtil.setParam('taskId', gots[1].Id);
            cont.reviseTask();
            cont.saveTask();
            
            //submmit  task
            GC_PageUtil.setParam('taskId', gots[0].Id);
            cont.submitTask();
            
            cont.emailDefaultList = 'test1@test.com,test2@test.com,';
            pg=cont.sendEmail();
            cont.emailDefaultList = 'test1@test.com,test2@test.com,';
            pg=cont.saveDefaultandSendEmail();
            
            
            cont.isModalViewDisplay = false;
            cont.cancelButtonCLick();
            
            //Recall task
            GC_PageUtil.setParam('taskId', gots[0].Id);
            cont.recallTask();
            
            //Remove task
            //GC_PageUtil.setParam('taskId', gots[0].Id);
            //cont.deleteTask();
            //
            gots[0].Status__c = 'Canceled';
            update gots[0];
            pg=cont.sendEmail1();
            GC_PageUtil.setParam('showId', order.Connect2_Show__c);
            GC_PageUtil.setParam('orderId', order.Id);
            GC_PageUtil.setParam('id', order.Id);
            cont.cloneOrderTask();
            cont.cloneOrderTaskNonCommunity();
            cont.moveOrderTaskNonCommunity();
        }
        
        Test.stopTest();
    }
    
    @isTest static void testCommunityVendorActions() {
        
        Map<String, User> portalUsers;
        User clientUser;
        User vendor;
        GC_GES_Order_Task__c orderTask;
        GC_Order__c order;
        GC_Show_Team_Member__c clientMember;
        GC_Show_Attribute__c sa;
        GC_Show_Team_Member__c  stm;
        GC_Core_Session__c session;
        GC_Connect2_Show__c show;
        GC_Vendor_Order_Task__c vottask1;
        GC_Vendor_Order_Task__c vottask;
        
        User accountManager = GC_TestUtils.createUser('GC Account Manager', 'TheManager', 'ofAccounts');
        accountManager.UserRoleId = [select Id from UserRole where Name = 'System Administrator'].Id;
        update accountManager;
        
        System.runAs(accountManager){
        portalUsers = GC_TestUtils.getPortalUsers();
        
        clientUser = portalUsers.get('GC Community Client');
        vendor = portalUsers.get('GC Community Vendor');
        
        
        orderTask = GC_TestUtils.setupOrderAndTask();
        order = GC_OrderDao.getInstance().getOrderById(orderTask.Order__c);
        
        clientMember = new GC_Show_Team_Member__c(
            Connect2_Show__c = order.Connect2_Show__c,
            User__c = clientUser.Id,
            Show_Role__c = 'Show Organizer');
        insert clientMember;
        
        sa = new GC_Show_Attribute__c();
        sa.Name_Unique__c = 'Test Attribute';
        sa.Connect2_Show__c = order.Connect2_Show__c;
        sa.RecordTypeId = GC_TestUtils.getRecordType('GC_Show_Attribute__c').get('Show Service').Id;
        sa.Name = 'Test Venue';
        insert sa;
        
        system.debug('SA Test+++'+sa.Id);
        
         stm = new GC_Show_Team_Member__c(
            Connect2_Show__c = order.Connect2_Show__c,
            User__c = vendor.Id,
            Show_Role__c = 'Vendor',
            Service_Type__c = sa.Id);
        insert stm;
        
        system.debug('STM Test+++'+stm);
        
        
        
        //GC_Vendor_Order_Task__c vendorTask = GC_TestUtils.getTestVendorTask(order.Id, vendor.Id);
        
        Test.setMock(WebServiceMock.class, new CORE_SECURITY_IMPLMockImpl());
        Test.setMock(WebServiceMock.class, new CORE_V2MockImpl());
        CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService s = new CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService();
        session = GC_TestUtils.createTestSession();
        Test.startTest();
        show = [Select Id, Job_Number__c From GC_Connect2_Show__c where Id = : order.Connect2_Show__c];
        vottask1 = new GC_Vendor_Order_Task__c();
            vottask1.Order__c = order.id;
            //vottask1.Vendor__c = vendor.Id;
            //vottask1.Vendor2__c = vendor.Id;
            //vottask1.Vendor3__c = vendor.Id;
            //vottask1.Vendor4__c = vendor.Id;
            //vottask1.Vendor5__c = vendor.Id;
            vottask1.Service_Type__c = sa.Id;
            vottask1.Service_Type2__c = sa.Id;
            vottask1.Service_Type3__c = sa.Id;
            vottask1.Service_Type4__c = sa.Id;
            vottask1.Service_Type5__c = sa.Id;
            vottask1.Vendor_Instructions__c = 'test instructions111'; 
            vottask1.SelectAllOrderTasks__c = true;
            insert vottask1;
            
            vottask = new GC_Vendor_Order_Task__c();
            vottask.Order__c = order.id;
            vottask.Vendor__c = vendor.Id;
            vottask.Vendor2__c = vendor.Id;
            vottask.Vendor3__c = vendor.Id;
            vottask.Vendor4__c = vendor.Id;
            vottask.Vendor5__c = vendor.Id;
            vottask.Vendor_Instructions__c = 'test instructions111';
            insert vottask;
        
        }
        
        System.runAs(clientUser) {
            
            GC_PageUtil.setParam('showId', order.Connect2_Show__c);
            GC_PageUtil.setParam('orderId', order.Id);
            
            order.Booth_Area_ID__c = '1390259';
            GC_OrderViewController cont = new GC_OrderViewController();
            
            PageReference pg = cont.loadAction();
            
            //Nvew Vendor Task
            
            cont.newVendorTask();
            cont.selectAllGesOT = true;
            cont.saveVendorTask();
            
            List<GC_Vendor_Order_Task__c> vots = [Select Id From GC_Vendor_Order_Task__c];
            //System.assertEquals(1, vots.size());
            
            //Edit vendor task
            GC_PageUtil.setParam('taskId', vots[0].Id);
            cont.editVendorTask();
            
            //Send vendor task
            //GC_PageUtil.setParam('taskId', vots[0].Id);
            //cont.sendVendorTask();
            
            //Cancel edit vendor task
            cont.cancelEditVendorTask();
            
            //clone vendor task
            cont.cloneVendorTask();
            cont.saveVendorTask();
            
            List<GC_Vendor_Order_Task__c> vots1 = [Select Id From GC_Vendor_Order_Task__c];
            //System.assertEquals(2, vots1.size());
            
            //Edit vendor task
            
            GC_PageUtil.setParam('taskId', vots1[0].Id);
            cont.editVendorTask();
            
            cont.selectedVendorTask.task.Vendor_Instructions__c = 'Test Test';
            
            cont.saveVendorTask();
            
            cont.newVendorTask();
            cont.vendorSelect = 'Vendor1';
            cont.userslist = new List<SelectOption>();
            cont.selectedVendorTask.task.Service_Type__c = sa.Id;
            cont.filterVendors();
            
            cont.vendorSelect = 'Vendor2';
            cont.userslist1 = new List<SelectOption>();
            cont.selectedVendorTask.task.Service_Type2__c = sa.Id;
            cont.filterVendors();
            
            cont.vendorSelect = 'Vendor3';
            cont.userslist2 = new List<SelectOption>();
            cont.selectedVendorTask.task.Service_Type3__c = sa.Id;
            cont.filterVendors();
            
            cont.vendorSelect = 'Vendor4';
            cont.userslist3 = new List<SelectOption>();
            cont.selectedVendorTask.task.Service_Type4__c = sa.Id;
            cont.filterVendors();
            
            cont.vendorSelect = 'Vendor5';
            cont.userslist4 = new List<SelectOption>();
            cont.selectedVendorTask.task.Service_Type5__c = sa.Id;
            cont.filterVendors();
            GC_PageUtil.setParam('taskId', vottask.Id);
            GC_OrderViewController.VendorTaskWrapper vot = new GC_OrderViewController.VendorTaskWrapper();
            vot.task = vottask;
            cont.vendorOrderTasks.add(vot);
            //cont.sendVendorTask();
            
            Test.stopTest();
            
            //cont.deleteVendorTask();
            
            GC_OrderViewController.showTeamMemberWrapperExternalVendor stm11 = new GC_OrderViewController.showTeamMemberWrapperExternalVendor('test','test','test','test',true);
            
            cont.selectAllGesOT = false;
            cont.otDropDownReadOnly();
            
            
            
            
            GC_PageUtil.setParam('taskId', vottask1.Id);
            GC_OrderViewController.VendorTaskWrapper vot1 = new GC_OrderViewController.VendorTaskWrapper();
            vot1.task = vottask1;
            cont.vendorOrderTasks.add(vot1);
            //cont.editVendorTask();
        }
        
        
    }
    
    @isTest static void testOrderViewTasksController() {
        
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        show.Job_Number__c = '1';
        update show;
        
        GC_Order__c order = new GC_Order__c();
        order.Connect2_Show__c = show.Id;
        order.Booth_Area__c  = 'Area';
        order.Booth_Area_ID__c = '1390259';
        insert order;
        
        List<GC_GES_Order_Task__c> gots = new List<GC_GES_Order_Task__c>();
        
        for (Integer i = 0; i < 100; i++) {
            GC_GES_Order_Task__c got = new GC_GES_Order_Task__c();
            got.Order__c = order.Id;
            got.Item_Category_ID__c = '1896';
            got.Item_Number__c = '300004';
            got.Item_Template__c = 'Basic';
            got.QuantityNum__c = 1 + i;
            got.Status__c = 'New';
            got.Show_Management_Field__c = 'Yes';
            got.File_Reference_Link__c = 'link';
            got.Order_Line_ID__c = '123';
            gots.add(got);
            
        }
        
        insert gots;
        
        GC_Vendor_Order_Task__c task = new GC_Vendor_Order_Task__c();
        task.Order__c = order.id;
        task.Vendor_Instructions__c = 'test instructions';
        insert task;
        
        for (GC_GES_Order_Task__c got : gots) {
            got.Status__c = 'Approved';
        }
        
        update gots;
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(order);
        GC_OrderViewController orderViewController = new GC_OrderViewController(sc);
        
        Test.setMock(WebServiceMock.class, new CORE_SECURITY_IMPLMockImpl());
        Test.setMock(WebServiceMock.class, new CORE_V2MockImpl());
        
        CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService s = new CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService();
        GC_Core_Session__c session = new GC_Core_Session__c();
        session.Core_Application_Session_ID__c = '7abacb3c-36f1-4963-a5e4-7e891ad26e43';
        session.Core_Application_Login_Expiration__c = DateTime.now() + 1;
        insert session;
        
        session = GC_CoreUtils.getSessionID();
        
        orderViewController.coreSessionId = session.Core_Application_Session_ID__c;
        
        orderViewController.loadAction();
        orderViewController.sessionLoad();
        orderViewController.sessionLogin();
        
        orderViewController.editAction();
        
        PageReference clonePR = orderViewController.cloneAction();
        String clonePRurl = clonePR.getUrl();
        System.assertEquals(clonePRurl.contains('GC_OrderView') && clonePRurl.contains('id=' + order.Id) , false);
        
        orderViewController.approvalAction();
        
        PageReference submitPR = orderViewController.submitOrderAction();
        PageReference cancelPR = orderViewController.cancelOrderAction();
        
        PageReference deleteOrderPR = orderViewController.deleteOrderAction();
        
        Test.stopTest();
        
    }
    
    @isTest static void testBulkApproveTasks() { 
        
        User accountManager = GC_TestUtils.createUser('GC Account Manager', 'TheManager', 'ofAccounts');
        accountManager.UserRoleId = [select Id from UserRole where Name = 'System Administrator'].Id;
        update accountManager;
        
        User am = GC_TestUtils.createUser('GC Account Manager', 'unit_test', 'account_manager1');
        
        Map<String, User> portalUsers = new Map<String, User>();
        GC_Connect2_Show__c show = new GC_Connect2_Show__c();
        User clientUser = new User();
        GC_Show_Team_Member__c clientMember = new GC_Show_Team_Member__c();
        
        System.runAs(accountManager){
            portalUsers = GC_TestUtils.getPortalUsers(); 
            
            show = GC_TestUtils.getTestConnect2Show();
            show.Job_Number__c = '1';
            update show;
            
            clientUser = portalUsers.get('GC Community Client');
            
            GC_Show_Team_Member__c stmAm = new GC_Show_Team_Member__c();
            stmAm.Connect2_Show__c = show.Id;
            stmAm.User__c = am.Id;
            stmAm.Show_Role__c = 'Account Manager';
            insert stmAm;
            
            clientMember.Connect2_Show__c = show.Id;
            clientMember.User__c = clientUser.Id;
            clientMember.Show_Role__c = 'Show Organizer';
            insert clientMember;
        }
        
        GC_Order__c order = new GC_Order__c();
        GC_GES_Order_Task__c got1 = new GC_GES_Order_Task__c();
        GC_GES_Order_Task__c got2 = new GC_GES_Order_Task__c();
        GC_GES_Order_Task__c contGot2 = new GC_GES_Order_Task__c();
        
        Test.startTest();
        System.runAs(clientUser) {
            order.Connect2_Show__c = show.Id;
            order.Booth_Area__c  = 'Area';
            order.Booth_Area_ID__c = '1390259';
            
            insert order;
            
            got1.Order__c = order.Id;
            got1.Item_Category_ID__c = '1896';
            got1.Item_Number__c = '300004';
            got1.Item_Template__c = 'Graphics';
            got1.GOT_Single_Double_Sided__c = 'Double';
            got1.QuantityNum__c = 1;
            got1.Status__c = 'New';
            got1.Sign_Title__c = 'test sign';
            got1.Show_Management_Field__c = 'Yes';
            got1.File_Reference_Link__c = 'link';
            got1.Layout__c = 'test layout';
            got1.Sign_Copy__c = 'test copy';
            got1.Installation_Method__c = 'test installation method';
            got1.GOT_Sign_Type__c = 'sign type test';
            got1.GOT_Copy_Placement__c = 'copy placement';
            got1.Save_Signs__c = 'yes';
            got1.GOT_Background__c = 'test background';
            
            got2.Order__c = order.Id;
            got2.Item_Category_ID__c = '1896';
            got2.Item_Number__c = '300004';
            got2.Item_Template__c = 'Custom Graphics';
            got2.GOT_Single_Double_Sided__c = 'Single';
            got2.Sign_Length__c = 20;
            got2.Sign_Width__c = 15;
            got2.QuantityNum__c = 1;
            got2.Status__c = 'New';
            got2.Show_Management_Field__c = 'Yes';
            got2.File_Reference_Link__c = 'link';
            got2.Sign_Title__c = 'test sign';
            got2.Show_Management_Field__c = 'Yes';
            got2.File_Reference_Link__c = 'link';
            got2.Layout__c = 'test layout';
            got2.Sign_Copy__c = 'test copy';
            got2.Installation_Method__c = 'test installation method';
            got2.GOT_Sign_Type__c = 'sign type test';
            got2.GOT_Copy_Placement__c = 'copy placement';
            got2.Save_Signs__c = 'yes';
            got2.GOT_Background__c = 'test background';
            
            List<GC_GES_Order_Task__c> gots1 = new List<GC_GES_Order_Task__c>();
            gots1.add(got1);
            insert gots1;
            
            List<GC_GES_Order_Task__c> gots2 = new List<GC_GES_Order_Task__c>();
            gots2.add(got2);
            insert gots2;
            
            // test with status = new
            ApexPages.StandardSetController sc = new ApexPages.StandardSetController(gots1);
            sc.setSelected(gots1);
            GC_OrderTaskBulkapproveController cont = new GC_OrderTaskBulkapproveController(sc);
            
            cont.loadAction();
            
            GC_GES_Order_Task__c task1 = [Select Id, Status__c From GC_GES_Order_Task__c Where Id = :gots1[0].Id];
            System.assertEquals('Approved', task1.Status__c);
            
            
            //task submit
            GC_ApprovalUtils.submitForApproval(show.Id, gots2);
            
            
            contGot2 = [Select Id, Status__c From GC_GES_Order_Task__c Where Id = :gots2[0].Id];
            
            System.assertEquals('Submitted', contGot2.Status__c);
        }
        
        System.runAs(am) {
            
            List<GC_GES_Order_Task__c> cont21gots2 = new List<GC_GES_Order_Task__c>();
            cont21gots2.add(contGot2);
            
            ApexPages.StandardSetController sc21 = new ApexPages.StandardSetController(cont21gots2);
            sc21.setSelected(cont21gots2);
            GC_OrderTaskBulkapproveController cont21 = new GC_OrderTaskBulkapproveController(sc21);
            
            cont21.loadAction();
            
            GC_GES_Order_Task__c task21 = [Select Id, Status__c From GC_GES_Order_Task__c Where Id = :cont21gots2[0].Id];
            //System.assertEquals('Approved', task21.Status__c);
        }
        
        Test.stopTest();
        
    }
    
    @isTest static void testCommunityOrderActions1() 
    {
        User accountManager = GC_TestUtils.createUser('GC Account Manager', 'TheManager', 'ofAccounts');
        accountManager.UserRoleId = [select Id from UserRole where Name = 'System Administrator'].Id;
        update accountManager;
        System.runAs(accountManager){
        GC_GES_Order_Task__c orderTask = GC_TestUtils.setupOrderAndTask();
        GC_Order__c order = GC_OrderDao.getInstance().getOrderById(orderTask.Order__c);
        
        GC_PageUtil.setParam('orderId', order.Id);
        GC_OrderViewController cont = new GC_OrderViewController();
        PageReference pg = Page.GC_Community_OrderView;
        Test.setCurrentPage(pg);
        cont.exportToCSV();
        }
        
    }
    
    
    @isTest static void testCommunityVendorActions1() 
    {
        
        User accountManager = GC_TestUtils.createUser('GC Account Manager', 'TheManager', 'ofAccounts');
        accountManager.UserRoleId = [select Id from UserRole where Name = 'System Administrator'].Id;
        update accountManager;
        
        Map<String, User> portalUsers;
        User clientUser;
        User vendor;
        GC_GES_Order_Task__c orderTask;
        GC_Order__c order;
        GC_Show_Team_Member__c clientMember;
        GC_Show_Attribute__c sa;
        GC_Show_Team_Member__c  stm;
        GC_Core_Session__c session;
        
        System.runAs(accountManager){
            portalUsers = GC_TestUtils.getPortalUsers();
            
            clientUser = portalUsers.get('GC Community Client');
            vendor = portalUsers.get('GC Community Vendor');
            
            
            orderTask = GC_TestUtils.setupOrderAndTask();
            order = GC_OrderDao.getInstance().getOrderById(orderTask.Order__c);
            
            clientMember = new GC_Show_Team_Member__c(
                Connect2_Show__c = order.Connect2_Show__c,
                User__c = clientUser.Id,
                Show_Role__c = 'Show Organizer');
            insert clientMember;
            
            sa = new GC_Show_Attribute__c();
            sa.Name_Unique__c = 'Test Attribute';
            sa.Connect2_Show__c = order.Connect2_Show__c;
            sa.RecordTypeId = GC_TestUtils.getRecordType('GC_Show_Attribute__c').get('Show Service').Id;
            sa.Name = 'Test Venue';
            insert sa;
            
            system.debug('SA Test+++'+sa.Id);
            
            stm = new GC_Show_Team_Member__c(
                Connect2_Show__c = order.Connect2_Show__c,
                User__c = vendor.Id,
                Show_Role__c = 'Vendor',
                Service_Type__c = sa.Id);
            insert stm;
            
            system.debug('STM Test+++'+stm);
            
            Test.setMock(WebServiceMock.class, new CORE_SECURITY_IMPLMockImpl());
            Test.setMock(WebServiceMock.class, new CORE_V2MockImpl());
            CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService s = new CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService();
            session = GC_TestUtils.createTestSession();
        }
        
        Test.startTest();
        GC_Connect2_Show__c show = [Select Id, Job_Number__c From GC_Connect2_Show__c where Id = : order.Connect2_Show__c];
        
        System.runAs(clientUser){
            
        GC_PageUtil.setParam('showId', order.Connect2_Show__c);
        GC_PageUtil.setParam('orderId', order.Id);
        
        order.Booth_Area_ID__c = '1390259';
        GC_OrderViewController cont = new GC_OrderViewController();
        
        PageReference pg = cont.loadAction();
        PageReference pg1 = cont.deleteTask();
        
        //Nvew Vendor Task
        
        cont.newVendorTask();
        cont.selectAllGesOT = true;
        cont.saveVendorTask();
        
        List<GC_Vendor_Order_Task__c> vots = [Select Id From GC_Vendor_Order_Task__c];
        //System.assertEquals(1, vots.size());
        
        //Edit vendor task
        GC_PageUtil.setParam('taskId', orderTask.Id);
        cont.editVendorTask();
        PageReference pg2 = cont.submitGraphicsTask();
        
        //Send vendor task
        //GC_PageUtil.setParam('taskId', vots[0].Id);
        //cont.sendVendorTask();
        //Cancel edit vendor task
        cont.cancelEditVendorTask();
        GC_PageUtil.setParam('taskId', vots[0].Id);
        //clone vendor task
        cont.cloneVendorTask();
        cont.saveVendorTask();
        
        List<GC_Vendor_Order_Task__c> vots1 = [Select Id From GC_Vendor_Order_Task__c];
        //System.assertEquals(2, vots1.size());
        
        //Edit vendor task
        
        GC_PageUtil.setParam('taskId', vots1[0].Id);
        cont.editVendorTask();
        
        cont.selectedVendorTask.task.Vendor_Instructions__c = 'Test Test';
        
        cont.saveVendorTask();
        
        cont.newVendorTask();
        cont.vendorSelect = 'Vendor1';
        cont.userslist = new List<SelectOption>();
        cont.selectedVendorTask.task.Service_Type__c = sa.Id;
        cont.filterVendors();
        
        cont.vendorSelect = 'Vendor2';
        cont.userslist1 = new List<SelectOption>();
        cont.selectedVendorTask.task.Service_Type2__c = sa.Id;
        cont.filterVendors();
        
        cont.vendorSelect = 'Vendor3';
        cont.userslist2 = new List<SelectOption>();
        cont.selectedVendorTask.task.Service_Type3__c = sa.Id;
        cont.filterVendors();
        
        cont.vendorSelect = 'Vendor4';
        cont.userslist3 = new List<SelectOption>();
        cont.selectedVendorTask.task.Service_Type4__c = sa.Id;
        cont.filterVendors();
        
        cont.vendorSelect = 'Vendor5';
        cont.userslist4 = new List<SelectOption>();
        cont.selectedVendorTask.task.Service_Type5__c = sa.Id;
        cont.filterVendors();
        
        GC_Vendor_Order_Task__c vottask = new GC_Vendor_Order_Task__c();
        vottask.Order__c = order.id;
        vottask.Vendor__c = vendor.Id;
        vottask.Vendor2__c = vendor.Id;
        vottask.Vendor3__c = vendor.Id;
        vottask.Vendor4__c = vendor.Id;
        vottask.Vendor5__c = vendor.Id;
        vottask.Vendor_Instructions__c = 'test instructions111';
        insert vottask;
        
        GC_PageUtil.setParam('taskId', vottask.Id);
        GC_OrderViewController.VendorTaskWrapper vot = new GC_OrderViewController.VendorTaskWrapper();
        vot.task = vottask;
        cont.vendorOrderTasks.add(vot);
        cont.sendVendorTask();
        
        //cont.deleteVendorTask();
        
        GC_OrderViewController.showTeamMemberWrapperExternalVendor stm11 = new GC_OrderViewController.showTeamMemberWrapperExternalVendor('test','test','test','test',true);
        
        cont.selectAllGesOT = false;
        cont.otDropDownReadOnly();
        
        cont.selectAllGesOT = true;
        cont.otDropDownReadOnly();
        }
        Test.stoptest();
        
        
        
    }
    
    @isTest static void testCommunityVendorActions2() 
    {
        User accountManager = GC_TestUtils.createUser('GC Account Manager', 'TheManager', 'ofAccounts');
        accountManager.UserRoleId = [select Id from UserRole where Name = 'System Administrator'].Id;
        update accountManager;
        
        system.runAs(accountManager){
            Map<String, User> portalUsers = GC_TestUtils.getPortalUsers();
            
            User clientUser = portalUsers.get('GC Community Client');
            User vendor = portalUsers.get('GC Community Vendor');
            
            
            GC_GES_Order_Task__c orderTask = GC_TestUtils.setupOrderAndTask();
            GC_Order__c order = GC_OrderDao.getInstance().getOrderById(orderTask.Order__c);
            
            GC_Show_Team_Member__c clientMember = new GC_Show_Team_Member__c(
                Connect2_Show__c = order.Connect2_Show__c,
                User__c = clientUser.Id,
                Show_Role__c = 'Show Organizer');
            insert clientMember;
            
            GC_Show_Attribute__c sa = new GC_Show_Attribute__c();
            sa.Name_Unique__c = 'Test Attribute';
            sa.Connect2_Show__c = order.Connect2_Show__c;
            sa.RecordTypeId = GC_TestUtils.getRecordType('GC_Show_Attribute__c').get('Show Service').Id;
            sa.Name = 'Test Venue';
            insert sa;
            
            GC_OrderViewController cont = new GC_OrderViewController();
            
            PageReference pg = cont.loadAction();
            
            GC_Vendor_Order_Task__c vottask1 = new GC_Vendor_Order_Task__c();
            vottask1.Order__c = order.id;
            //vottask1.Vendor__c = vendor.Id;
            //vottask1.Vendor2__c = vendor.Id;
            //vottask1.Vendor3__c = vendor.Id;
            //vottask1.Vendor4__c = vendor.Id;
            //vottask1.Vendor5__c = vendor.Id;
            vottask1.Service_Type__c = sa.Id;
            vottask1.Service_Type2__c = sa.Id;
            vottask1.Service_Type3__c = sa.Id;
            vottask1.Service_Type4__c = sa.Id;
            vottask1.Service_Type5__c = sa.Id;
            vottask1.Vendor_Instructions__c = 'test instructions111'; 
            vottask1.SelectAllOrderTasks__c = true;
            insert vottask1;
            
            GC_PageUtil.setParam('taskId', vottask1.Id);
            GC_OrderViewController.VendorTaskWrapper vot1 = new GC_OrderViewController.VendorTaskWrapper();
            vot1.task = vottask1;
            cont.vendorOrderTasks = new List<GC_OrderViewController.VendorTaskWrapper>();
            cont.vendorOrderTasks.add(vot1);
            //cont.editVendorTask();
            Test.startTest();
            cont.cloneVendorTask();
            orderTask.Status__c = 'Active';
            update orderTask;
            GC_PageUtil.setParam('taskId', orderTask.Id);
            cont.reviseTask();
            orderTask.Original_Task_Revision2__c = orderTask.Id;
            update orderTask;
            cont.reviseTask();
            Test.stopTest();
        }
    } 
      @isTest static void testCommunity2()
      {
           GC_OrderViewController cont = new GC_OrderViewController();
          cont.getCommunitySubmitTitle();
          cont.getSubmitTitle();
         cont.getPrintOrderTitle();
         cont.getCloneTitle();
         cont.getEditTitle();
         cont.getCreateNewVendorTask();
         cont.getCreateNewGesTask();
         cont.getDeleteTitle();
          
         Map<String, User> userDetails = GC_TestUtils.getPortalUsers();
         User vendor = userDetails.get('GC Community Vendor'); 
         GC_Connect2_Show__c show;
         GC_Order__c order;
         GC_Show_Team_Member__c stm;
         show = GC_TestUtils.getTestConnect2Show();

             order = new GC_Order__c();
             order.Connect2_Show__c = show.Id;
            insert order;
            
         GC_GES_Order_Task__c vot = new GC_GES_Order_Task__c();
        vot.Order__c = order.Id;
        vot.Item_Category_ID__c = '1896';
        vot.Item_Number__c = '300004';
        vot.Item_Template__c = 'Basic';
        vot.QuantityNum__c = 1;
        vot.Status__c = 'New';
        vot.Show_Management_Field__c = 'Yes';
        vot.File_Reference_Link__c = 'link';
        vot.Order_Line_ID__c = '123';
        insert vot;

        //User clientUser = GC_TestUtils.getPortalUsers().get('GC Community Client');
        User clientUser = userDetails.get('GC Community Client');
        GC_PageUtil.setParam('votId', vot.Id);
        GC_PageUtil.setParam('orderId', order.Id);
        GC_PageUtil.setParam('showId', show.Id);

        //System.runAs(clientUser) {
            GC_OrderViewController cont1 = new GC_OrderViewController();
            cont1.loadAction();
            
            vot.Status__c = 'Active';
            update vot;
            
            List<GC_GES_Order_Task__c> votList = [SELECT Id, Name, Revision__c, Status__c FROM GC_GES_Order_Task__c WHERE Id = :vot.Id];
            System.assertEquals(1, votList[0].Revision__c);
            System.assertEquals('Active', votList[0].Status__c);
                   
            vot.Order__c = order.Id;
              
            update vot;
                         
      //}
         
}

}