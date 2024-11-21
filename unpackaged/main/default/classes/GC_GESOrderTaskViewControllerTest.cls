@isTest
public with sharing class GC_GESOrderTaskViewControllerTest {
    public static testMethod void gotTest() {
        
        User accountManager = GC_TestUtils.createUser('GC Account Manager', 'TheManager', 'ofAccounts');
        accountManager.UserRoleId = [select Id from UserRole where Name = 'System Administrator'].Id;
        update accountManager;
        
        system.runAs(accountManager){
            GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
            show.Job_Number__c = '1';
            update show;
            
            GC_Order__c order = new GC_Order__c();
            order.Connect2_Show__c = show.Id;
            order.Booth_Area__c  = 'Area';
            order.Booth_Area_ID__c = '1390259';
            insert order;
            
            List<GC_GES_Order_Task__c> listGOT = new List<GC_GES_Order_Task__c>();
            GC_GES_Order_Task__c got = new GC_GES_Order_Task__c();
            got.Order__c = order.Id;
            got.Item_Category_ID__c = '1896';
            got.Item_Number__c = '300004';
            got.Item_Template__c = 'Basic';
            got.QuantityNum__c = 1;
            got.Status__c = 'New';
            got.Show_Management_Field__c = 'Yes';
            got.File_Reference_Link__c = 'link';
            got.Order_Line_ID__c = '123';
            listGOT.add(got);
            GC_GES_Order_Task__c got1 = new GC_GES_Order_Task__c();
            got1.Order__c = order.Id;
            got1.Item_Category_ID__c = '1896';
            got1.Item_Number__c = '300004';
            got1.Item_Template__c = 'Basic';
            got1.QuantityNum__c = 1;
            got1.Status__c = 'New';
            got1.Show_Management_Field__c = 'Yes';
            got1.File_Reference_Link__c = 'link';
            got1.Order_Line_ID__c = '123';
            listGOT.add(got1);
            insert listGOT;
            
            ApexPages.StandardController sc = new ApexPages.StandardController(got);
            GC_GESOrderTaskViewController cont = new GC_GESOrderTaskViewController(sc);
            cont.getEditTitle();
            cont.getCloneTitle();
            cont.getReviseTitle();
            cont.getCancelTitle();
            cont.getOnHoldTitle();
            cont.getReleaseHoldTitle();
            cont.getApproveTitle();
            cont.getTakeOwnershipTitle();
            cont.getBackToOrderTitle();
            cont.getSubmitTitle();
            cont.validateSessionID();
            cont.insertLogs();
            
            
            PageReference pr1= cont.nextOrderTask();
            PageReference pr2= cont.submitToCore();
            
            PageReference pr;
            
            cont.cloneAction();
            List<GC_GES_Order_Task__c> gotList = [SELECT Id, Name, Revision__c, Status__c FROM GC_GES_Order_Task__c];
            System.assertEquals(gotList.size() , 2);
            
            cont.reviseAction();
            
            got.Status__c = 'Active';
            update got;

            //PageReference pr1= cont.nextOrderTask();
            cont.editAction();
            
            got.Previous_Revision__c = got.Id;
            cont.reviseAction();
            gotList = [SELECT Id, Name, Revision__c, Status__c FROM GC_GES_Order_Task__c WHERE Id = :got.Id];
            System.assertEquals(1, gotList[0].Revision__c);
            System.assertEquals('Active', gotList[0].Status__c);
            
            cont.placeOnHoldAction();
            gotList = [SELECT Id, Name, Status__c FROM GC_GES_Order_Task__c WHERE Id = :got.Id];
            System.assertEquals('On Hold', gotList[0].Status__c);
            
            cont.placeOnHoldAction();
            
            
            cont.releaseFromHoldAction();
            gotList = [SELECT Id, Name, Status__c FROM GC_GES_Order_Task__c WHERE Id = :got.Id];
            System.assertEquals('Active', gotList[0].Status__c);
            
            cont.releaseFromHoldAction();
            
            cont.connectToCore();
            cont.loginToCore();
            cont.submitCancelTask();
            cont.processCancelTask();
            cont.cancelActionForCore();        
            cont.cancelAction();
            gotList = [SELECT Id, Name, Status__c FROM GC_GES_Order_Task__c WHERE Id = :got.Id];
            System.assertEquals(gotList[0].Status__c , 'Canceled');
            
            cont.cancelAction();
            
            
            pr = cont.editAction();
            //System.assert(pr.getUrl().contains('/apex/GC_OrderTaskEdit') && pr.getUrl().contains(got.Id));
            
            cont.approveForSubmitAction();
        }
    }

    @isTest
    private static void multiFunctionTest() {
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
        got.Item_Number__c = '300004';
        got.Item_Template__c = 'Basic';
        got.QuantityNum__c = 1;
        got.Status__c = 'New';
        got.Show_Management_Field__c = 'Yes';
        got.File_Reference_Link__c = 'link';
        got.Order_Line_ID__c = '123';
        insert got;

        ApexPages.StandardController sc = new ApexPages.StandardController(got);
        GC_GESOrderTaskViewController cont = new GC_GESOrderTaskViewController(sc);

        cont.resetToNew();

        cont.submitRecord();

        cont.recallApprovalProcess();

        cont.takeOwnership();
    }

    @isTest
    private static void loadCommunityViewTestShowOrganizer() {
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
        got.Item_Number__c = '300004';
        got.Item_Template__c = 'Basic';
        got.QuantityNum__c = 1;
        got.Status__c = 'New';
        got.Show_Management_Field__c = 'Yes';
        got.File_Reference_Link__c = 'link';
        got.Order_Line_ID__c = '123';
        insert got;

        User clientUser = GC_TestUtils.getPortalUsers().get('GC Community Client');

        GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c();
        stm.Connect2_Show__c = show.Id;
        stm.User__c = clientUser.Id;
        stm.Show_Role__c = 'Show Organizer';
        insert stm;

        GC_PageUtil.setParam('gotId', got.Id);
        GC_PageUtil.setParam('orderId', order.Id);
        GC_PageUtil.setParam('showId', show.Id);

        System.runAs(clientUser) {
            GC_GESOrderTaskViewController cont = new GC_GESOrderTaskViewController();

            cont.loadAction();
            cont.saveAction();

            got.Status__c = 'Active';
            update got;
            cont.reviseAction();
            List<GC_GES_Order_Task__c> gotList = [SELECT Id, Name, Revision__c, Status__c FROM GC_GES_Order_Task__c WHERE Id = :got.Id];
            System.assertEquals(1, gotList[0].Revision__c);
            System.assertEquals('Active', gotList[0].Status__c);

            cont.recallComments = 'test';
            cont.coreSessionId = 'test';
        }
    }

    @isTest
    private static void loadCommunityViewTestClient() {
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
        got.Item_Number__c = '300004';
        got.Item_Template__c = 'Basic';
        got.QuantityNum__c = 1;
        got.Status__c = 'New';
        got.Show_Management_Field__c = 'Yes';
        got.File_Reference_Link__c = 'link';
        got.Order_Line_ID__c = '123';
        insert got;

        User clientUser = GC_TestUtils.getPortalUsers().get('GC Community Client');

        GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c();
        stm.Connect2_Show__c = show.Id;
        stm.User__c = clientUser.Id;
        stm.Show_Role__c = 'Show Organizer - Read Only';
        insert stm;

        got.Status__c = 'Active';
        update got;

        System.runAs(clientUser) {
            GC_PageUtil.setParam('gotId', got.Id);
            GC_PageUtil.setParam('orderId', order.Id);
            GC_PageUtil.setParam('showId', show.Id);
            GC_GESOrderTaskViewController cont = new GC_GESOrderTaskViewController();

            cont.loadAction();
            cont.saveAction();

            // Revise only takes effect on save, so status should still be active.
            cont.reviseAction();
            List<GC_GES_Order_Task__c> gotList = [SELECT Id, Name, Revision__c, Status__c FROM GC_GES_Order_Task__c WHERE Id = :got.Id];
            System.assertEquals(1, gotList[0].Revision__c);
            System.assertEquals('Active', gotList[0].Status__c);

            cont.recallComments = 'test';
            cont.coreSessionId = 'test';
        }
    }


    public static testMethod void holdStatusTest() {
        Map<String, User> userMap = GC_TestUtils.getUsers();
        User user = userMap.get('AM');
        
        User accountManager = GC_TestUtils.createUser('GC Account Manager', 'TheManager', 'ofAccounts');
        accountManager.UserRoleId = [select Id from UserRole where Name = 'System Administrator'].Id;
        update accountManager;
        
        system.runAs(accountManager){
            
            GC_Connect2_Show__c show =  GC_TestUtils.getTestConnect2Show();
            GC_Order__c order = new GC_Order__c();
            order.Connect2_Show__c = show.Id;
            order.Booth_Area_ID__c = '1390259';
            order.Booth_Area__c = 'Area';
            insert order;
            GC_GES_Order_Task__c got = new GC_GES_Order_Task__c();
            got.Order__c = order.Id;
            got.Sign_Length__c = 10;
            got.Sign_Width__c = 10;
            got.Onsite_Contact_Person__c = user.Id;
            got.Delivery_Date_Time__c = DateTime.now();
            got.Completion_Date_Time__c = DateTime.now() + 10;
            got.Removal_Date_Time__c = DateTime.now() + 15;
            got.QuantityNum__c = 5;
            got.Carpet_Length__c = 15;
            got.Carpet_Width__c = 15;
            got.Status__c = 'New';
            insert got;
            ApexPages.StandardController sc = new ApexPages.StandardController(got);
            GC_GESOrderTaskViewController gotController = new GC_GESOrderTaskViewController(sc);
            gotController.placeOnHoldAction();
            GC_GES_Order_Task__c query = [select Id, Name, Status__c from GC_GES_Order_Task__c where Id = :got.Id];
            System.assertEquals(query.Status__c , 'On Hold');
            gotController.placeOnHoldAction();
            gotController.releaseFromHoldAction();
            query = [select Id, Name, Status__c from GC_GES_Order_Task__c where Id = :got.Id];
            System.assertEquals(query.Status__c , 'New');
            gotController.releaseFromHoldAction();
        }
    }

    public static testMethod void revisionTest() {
        Map<String, User> userMap = GC_TestUtils.getUsers();
        User user = userMap.get('AM');
        System.runAs(user) {
            GC_Connect2_Show__c show =  GC_TestUtils.getTestConnect2Show();
            GC_Order__c order = new GC_Order__c();
            order.Connect2_Show__c = show.Id;
            order.Booth_Area_ID__c = '1390259';
            order.Booth_Area__c = 'Area';
            insert order;
            GC_GES_Order_Task__c got = new GC_GES_Order_Task__c();
            got.Order__c = order.Id;
            got.Sign_Length__c = 10;
            got.Sign_Width__c = 10;
            got.Onsite_Contact_Person__c = user.Id;
            got.Delivery_Date_Time__c = DateTime.now();
            got.Completion_Date_Time__c = DateTime.now() + 10;
            got.Removal_Date_Time__c = DateTime.now() + 15;
            got.QuantityNum__c = 5;
            got.Carpet_Length__c = 15;
            got.Carpet_Width__c = 15;
            got.Revision__c = 1;
            got.Status__c = 'Active';
            insert got;
            ApexPages.StandardController sc = new ApexPages.StandardController(got);
            GC_GESOrderTaskViewController gotController = new GC_GESOrderTaskViewController(sc);
            gotController.reviseAction();
            GC_GES_Order_Task__c query = [select Id, Name, Status__c from GC_GES_Order_Task__c where Id = :got.Id];
            System.assertEquals('Active', query.Status__c);
            gotController.reviseAction();
        }
    }

    public static testMethod void cancelTest() {
        Map<String, User> userMap = GC_TestUtils.getUsers();
        User user = userMap.get('AM');
        
        User accountManager = GC_TestUtils.createUser('GC Account Manager', 'TheManager', 'ofAccounts');
        accountManager.UserRoleId = [select Id from UserRole where Name = 'System Administrator'].Id;
        update accountManager;
        
        system.runAs(accountManager){
            
            GC_Connect2_Show__c show =  GC_TestUtils.getTestConnect2Show();
            GC_Order__c order = new GC_Order__c();
            order.Connect2_Show__c = show.Id;
            order.Booth_Area_ID__c = '1390259';
            order.Booth_Area__c = 'Area';
            insert order;
            GC_GES_Order_Task__c got = new GC_GES_Order_Task__c();
            got.Order__c = order.Id;
            got.Sign_Length__c = 10;
            got.Sign_Width__c = 10;
            got.Onsite_Contact_Person__c = user.Id;
            got.Delivery_Date_Time__c = DateTime.now();
            got.Completion_Date_Time__c = DateTime.now() + 10;
            got.Removal_Date_Time__c = DateTime.now() + 15;
            got.QuantityNum__c = 5;
            got.Carpet_Length__c = 15;
            got.Carpet_Width__c = 15;
            got.Revision__c = 1;
            got.Status__c = 'New';
            insert got;
            ApexPages.StandardController sc = new ApexPages.StandardController(got);
            GC_GESOrderTaskViewController gotController = new GC_GESOrderTaskViewController(sc);
            gotController.cancelAction();
            GC_GES_Order_Task__c query = [select Id, Name, Status__c from GC_GES_Order_Task__c where Id = :got.Id];
            query.Status__c = 'Canceled';
            gotController.cancelAction();
        }
    }

    public static testMethod void testUtils() {
        
        User accountManager = GC_TestUtils.createUser('GC Account Manager', 'TheManager', 'ofAccounts');
        accountManager.UserRoleId = [select Id from UserRole where Name = 'System Administrator'].Id;
        update accountManager;
        
        system.runAs(accountManager){
            GC_GES_Order_Task__c orderTask = GC_TestUtils.setupOrderAndTask();
            
            // The util methods are wrappers for classes which have their own tests, don't need to do asserts here
            PageReference pg = GC_OrderUtils.editTask(orderTask);
            pg = GC_OrderUtils.cloneTask(orderTask);
            pg = GC_OrderUtils.cancelTask(orderTask);
            pg = GC_OrderUtils.reviseTask(orderTask);
            pg = GC_OrderUtils.placeOnHoldTask(orderTask);
            pg = GC_OrderUtils.releaseFromHoldTask(orderTask);
            pg = GC_OrderUtils.approveTask(orderTask);
            pg = GC_OrderUtils.reworkTask(orderTask);
        }
        
    }

    @isTest
    private static void submitGraphicsTest() {
        Map<String, User> userMap = GC_TestUtils.getUsers();
        User amUser = userMap.get('AM');
        amUser = [select Id, Name, GC_Show_Role__c from User where Id = :amUser.Id];
        System.debug('******* User.GC_Show_Role__c: ' + amUser.GC_Show_Role__c);
        amUser.GC_Show_Role__c = 'GC Account Manager';
        update amUser;
        User gpmUser = userMap.get('GPM');
        GC_Connect2_Show__c show;
        GC_Order__c order;
        GC_GES_Order_Task__c got;

        System.runAs(amUser) {
            show =  GC_TestUtils.getTestConnect2Show();
            order = new GC_Order__c();
            order.Connect2_Show__c = show.Id;
            order.Booth_Area_ID__c = '1390259';
            order.Booth_Area__c = 'Area';
            insert order;
            got = new GC_GES_Order_Task__c();
            got.Order__c = order.Id;
            got.Item_Template__c = 'Graphics';
            got.Sign_Length__c = 10;
            got.Sign_Width__c = 10;
            got.Onsite_Contact_Person__c = amUser.Id;
            got.Delivery_Date_Time__c = DateTime.now();
            got.Completion_Date_Time__c = DateTime.now() + 10;
            got.Removal_Date_Time__c = DateTime.now() + 15;
            got.QuantityNum__c = 5;
            got.Carpet_Length__c = 15;
            got.Carpet_Width__c = 15;
            got.Revision__c = 1;
            got.Status__c = 'New';
            insert got;
            ApexPages.StandardController sc = new ApexPages.StandardController(got);
            GC_GESOrderTaskViewController gotController = new GC_GESOrderTaskViewController(sc);

            PageReference pr;

            pr = gotController.submitGraphicsAction();
            // All will be null because GPM was not added to show team.
            System.assertEquals(null, gotController.got.GPM_Approver_1__c);
            System.assertEquals(null, gotController.got.GPM_Approver_2__c);
            System.assertEquals(null, gotController.got.GPM_Approver_3__c);

            GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c();
            stm.Show_Role__c = 'Graphics Project Manager';
            stm.Connect2_Show__c = show.Id;
            stm.User__c = gpmUser.Id;
            insert stm;
            System.assertNotEquals(null, stm.Id);

            pr = gotController.submitGraphicsAction();

            //GC-739 removed this approval process, so there is nothing to test.  We should
            //have the code send an email through apex, or toggle a workflow action.

            //System.assertNotEquals(null, gotController.got.GPM_Approver_1__c);
            //System.assertNotEquals(null, gotController.got.GPM_Approver_2__c);
            //System.assertNotEquals(null, gotController.got.GPM_Approver_3__c);

            //GC_GES_Order_Task__c updatedTask = [select Id, Name, Status__c from GC_GES_Order_Task__c where Id = :got.Id];
            //System.assertEquals(true, GC_ApprovalUtils.isUnderApproval(updatedTask.Id));
            //System.assertEquals('Submitted to Graphics', updatedTask.Status__c);
        }

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
}