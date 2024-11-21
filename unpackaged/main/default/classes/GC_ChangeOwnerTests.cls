@isTest
private class GC_ChangeOwnerTests {

    @isTest
    public static void testShowChangeOwner() {
        User am1 = GC_TestUtils.createUser('GC Account Manager', 'unit_test', 'account_manager1');
        User am2 = GC_TestUtils.createUser('GC Account Manager', 'unit_test', 'account_manager2');
        User detailer = GC_TestUtils.createUser('GC Detailer', 'unit_test', 'detailer');
        Map<String, User> portalUsers = GC_TestUtils.getPortalUsers();
        User showOrganizerUser = portalUsers.get('GC Community Client');

        GC_Connect2_Show__c show;

        System.runAs(am1) {
            show = GC_TestUtils.getTestConnect2Show();
            GC_Show_Team_Member__c stmAm2 = new GC_Show_Team_Member__c();
            stmAm2.Connect2_Show__c = show.Id;
            stmAm2.User__c = am2.Id;
            stmAm2.Show_Role__c = 'Account Manager';
            insert stmAm2;
            GC_Show_Team_Member__c stmDetailer = new GC_Show_Team_Member__c();
            stmDetailer.Connect2_Show__c = show.Id;
            stmDetailer.User__c = detailer.Id;
            stmDetailer.Show_Role__c = 'Detailer';
            insert stmDetailer;
            GC_Show_Team_Member__c stmShowOrganizer = new GC_Show_Team_Member__c();
            stmShowOrganizer.Connect2_Show__c = show.Id;
            stmShowOrganizer.User__c = showOrganizerUser.Id;
            stmShowOrganizer.Show_Role__c = 'Show Organizer';
            insert stmShowOrganizer;
        }
        System.runAs(am2) {
            List<GC_Connect2_Show__c> showQuery = [Select Id from GC_Connect2_Show__c where Id = :show.Id];
            System.assert(showQuery.size() == 1, ' User ' + user.Id + ' is expected to have access to the show');
        }
        System.runAs(detailer) {
            List<GC_Connect2_Show__c> showQuery = [Select Id from GC_Connect2_Show__c where Id = :show.Id];
            System.assert(showQuery.size() == 1, ' User ' + user.Id + ' is expected to have access to the show');
        }
        System.runAs(showOrganizerUser) {
            List<GC_Connect2_Show__c> showQuery = [Select Id from GC_Connect2_Show__c where Id = :show.Id];
            System.assert(showQuery.size() == 1, ' User ' + user.Id + ' is expected to have access to the show');
        }
        // Change owner removes access for everyone
        System.runAs(am1) {
            show.OwnerId = am2.Id;
            update show;
        }
        System.runAs(am2) {
            List<GC_Connect2_Show__c> showQuery = [Select Id from GC_Connect2_Show__c where Id = :show.Id];
            System.assert(showQuery.size() == 1, ' User ' + user.Id + ' is expected to have access to the show');
        }
        System.runAs(detailer) {
            List<GC_Connect2_Show__c> showQuery = [Select Id from GC_Connect2_Show__c where Id = :show.Id];
            System.assert(showQuery.size() == 1, ' User ' + user.Id + ' is expected to have access to the show');
        }
        System.runAs(showOrganizerUser) {
            List<GC_Connect2_Show__c> showQuery = [Select Id from GC_Connect2_Show__c where Id = :show.Id];
            System.assert(showQuery.size() == 1, ' User ' + user.Id + ' is expected to have access to the show');
        }
    }

    @isTest
    public static void testDRFChangeOwner() {
        User am1 = GC_TestUtils.createUser('GC Account Manager', 'unit_test', 'account_manager1');
        User am2 = GC_TestUtils.createUser('GC Account Manager', 'unit_test', 'account_manager2');
        User detailer = GC_TestUtils.createUser('GC Detailer', 'unit_test', 'detailer');

        GC_Connect2_Show__c show;
        GC_Design_Request_Form__c drf;

        System.runAs(am1) {
            show = GC_TestUtils.getTestConnect2Show();
            drf = GC_TestUtils.getTestDRF(show.Id);

            GC_Show_Team_Member__c stmAm2 = new GC_Show_Team_Member__c();
            stmAm2.Connect2_Show__c = show.Id;
            stmAm2.User__c = am2.Id;
            stmAm2.Show_Role__c = 'Account Manager';
            insert stmAm2;
            GC_Show_Team_Member__c stmDetailer = new GC_Show_Team_Member__c();
            stmDetailer.Connect2_Show__c = show.Id;
            stmDetailer.User__c = detailer.Id;
            stmDetailer.Show_Role__c = 'Detailer';
            insert stmDetailer;
        }
        System.runAs(am2) {
            List<GC_Design_Request_Form__c> recordQuery = [Select Id from GC_Design_Request_Form__c where Id = :drf.Id];
            System.assert(recordQuery.size() == 1, ' User ' + user.Id + ' is expected to have access to the record');
        }
        System.runAs(detailer) {
            List<GC_Design_Request_Form__c> recordQuery = [Select Id from GC_Design_Request_Form__c where Id = :drf.Id];
            System.assert(recordQuery.size() == 1, ' User ' + user.Id + ' is expected to have access to the record');
        }
        // Change owner removes access for everyone
        System.runAs(am1) {
            drf.OwnerId = am2.Id;
            update drf;
        }
        System.runAs(detailer) {
            List<GC_Design_Request_Form__c> recordQuery = [Select Id from GC_Design_Request_Form__c where Id = :drf.Id];
            System.assert(recordQuery.size() == 1, ' User ' + user.Id + ' is expected to have access to the record');
        }
    }

    @isTest
    public static void testDEChangeOwner() {
        User am1 = GC_TestUtils.createUser('GC Account Manager', 'unit_test', 'account_manager1');
        User am2 = GC_TestUtils.createUser('GC Account Manager', 'unit_test', 'account_manager2');
        User ta = GC_TestUtils.createUser('GC Traffic Administrator', 'unit_test', 'ta1');
        User cd = GC_TestUtils.createUser('GC Creative Director', 'unit_test', 'cd1');
        User detailer = GC_TestUtils.createUser('GC Detailer', 'unit_test', 'detailer');

        GC_Connect2_Show__c show;
        GC_Design_Request_Form__c drf;
        GC_Design_Element__c de;

        System.runAs(am1) {
            show = GC_TestUtils.getTestConnect2Show();
            drf = GC_TestUtils.getTestDRF(show.Id);
            de = GC_TestUtils.getTestDesignElement(drf.Id);
            de.Creative_Director_Approvers__c = cd.Id;
            de.Traffic_Administrator_Approver__c = ta.Id;
            update de;

            GC_Show_Team_Member__c stmAm2 = new GC_Show_Team_Member__c();
            stmAm2.Connect2_Show__c = show.Id;
            stmAm2.User__c = am2.Id;
            stmAm2.Show_Role__c = 'Account Manager';
            insert stmAm2;

            Test.startTest();

            List<GC_Show_Team_Member__c> showTeamMembers = [select Id from GC_Show_Team_Member__c where Connect2_Show__c = :show.Id];
            System.assertEquals(showTeamMembers.size(), 4, 'Expected 4 Members');
            List<GC_Show_Team_Assignment__c> showTeamAssignments = [select Id from GC_Show_Team_Assignment__c where Design_Element__c = :de.Id];
            System.assertEquals(showTeamAssignments.size(), 2, 'Expected 2 Assignments');
        }
        System.runAs(am2) {
            List<GC_Design_Element__c> recordQuery = [Select Id from GC_Design_Element__c where Id = :de.Id];
            System.assert(recordQuery.size() == 1, ' User ' + am2.Id + ' is expected to have access to the record');
        }
        System.runAs(ta) {
            //de.Detailer_Approver__c = detailer.Id;  //Amarab 04062021 SAL-1243 Replacing old Designer/Detailer Approver1 field with new field
            de.Contact_Designer_Detailer_Approver1__c = detailer.Id;
            update de;
            List<GC_Show_Team_Member__c> showTeamMembers = [select Id from GC_Show_Team_Member__c where Connect2_Show__c = :show.Id];
            System.assertEquals(showTeamMembers.size(), 5, 'Expected 5 Members');
            List<GC_Show_Team_Assignment__c> showTeamAssignments = [select Id from GC_Show_Team_Assignment__c where Design_Element__c = :de.Id];
            System.assertEquals(showTeamAssignments.size(), 3, 'Expected 3 Assignments');
            List<GC_Design_Element__c> recordQuery = [Select Id from GC_Design_Element__c where Id = :de.Id];
            System.assert(recordQuery.size() == 1, ' User ' + ta.Id + ' is expected to have access to the record');
        }
        System.runAs(detailer) {
            List<GC_Design_Element__c> recordQuery = [Select Id from GC_Design_Element__c where Id = :de.Id];
            System.assert(recordQuery.size() == 1, ' User ' + detailer.Id + ' is expected to have access to the record');
        }
        // Change owner removes access for everyone
        System.runAs(am1) {
            de.OwnerId = am2.Id;
            update de;
        }
        System.runAs(detailer) {
            List<GC_Design_Element__c> recordQuery = [Select Id from GC_Design_Element__c where Id = :de.Id];
            System.assert(recordQuery.size() == 1, ' User ' + detailer.Id + ' is expected to have access to the record');
        }
        Test.stopTest();
    }

    @isTest
    public static void testOrderChangeOwner() {
        User am1 = GC_TestUtils.createUser('GC Account Manager', 'unit_test', 'account_manager1');
        User am2 = GC_TestUtils.createUser('GC Account Manager', 'unit_test', 'account_manager2');
        Account acc = GC_TestUtils.getAccount();
        User client1 = GC_TestUtils.createPortalUser('GC Community Client', 'unit_test', 'client1', acc);
        User client2 = GC_TestUtils.createPortalUser('GC Community Client', 'unit_test', 'client2', acc);
        User vendor1 = GC_TestUtils.createPortalUser('GC Community Vendor', 'unit_test', 'vendor1', acc);

        GC_Order__c order;
        GC_Connect2_Show__c show;

        System.runAs(am1) {
            order = GC_TestUtils.getTestOrder();
            show = GC_Connect2ShowDao.getInstance().getConnect2ShowById(order.Connect2_Show__c);
            GC_Vendor_Order_Task__c vendorTask = GC_TestUtils.getTestVendorTask(order.Id, vendor1.Id);

            GC_Show_Team_Member__c stmAm2 = new GC_Show_Team_Member__c();
            stmAm2.Connect2_Show__c = show.Id;
            stmAm2.User__c = am2.Id;
            stmAm2.Show_Role__c = 'Account Manager';
            insert stmAm2;
            GC_Show_Team_Member__c stmClient1 = new GC_Show_Team_Member__c();
            stmClient1.Connect2_Show__c = show.Id;
            stmClient1.User__c = client1.Id;
            stmClient1.Show_Role__c = 'Show Organizer';
            insert stmClient1;
            GC_Show_Team_Member__c stmClient2 = new GC_Show_Team_Member__c();
            stmClient2.Connect2_Show__c = show.Id;
            stmClient2.User__c = client2.Id;
            stmClient2.Show_Role__c = 'Show Organizer';
            insert stmClient2;
        }
        Test.startTest();
        System.runAs(client1) {
            List<GC_Order__c> recordQuery = [Select Id from GC_Order__c where Id = :order.Id];
            System.assert(recordQuery.size() == 1, ' User ' + client1.Id + ' is expected to have access to the record');
        }
        System.runAs(client2) {
            List<GC_Order__c> recordQuery = [Select Id from GC_Order__c where Id = :order.Id];
            System.assert(recordQuery.size() == 1, ' User ' + client2.Id + ' is expected to have access to the record');
        }
        System.runAs(vendor1) {
            List<GC_Order__c> recordQuery = [Select Id from GC_Order__c where Id = :order.Id];
            System.assert(recordQuery.size() == 1, ' User ' + vendor1.Id + ' is expected to have access to the record');
        }
        System.runAs(am1) {
            order.OwnerId = am2.Id;
            update order;
        }
        System.runAs(client1) {
            List<GC_Order__c> recordQuery = [Select Id from GC_Order__c where Id = :order.Id];
            System.assert(recordQuery.size() == 1, ' User ' + client1.Id + ' is expected to have access to the record');
        }
        System.runAs(client2) {
            List<GC_Order__c> recordQuery = [Select Id from GC_Order__c where Id = :order.Id];
            System.assert(recordQuery.size() == 1, ' User ' + client2.Id + ' is expected to have access to the record');
        }
        System.runAs(vendor1) {
            List<GC_Order__c> recordQuery = [Select Id from GC_Order__c where Id = :order.Id];
            System.assert(recordQuery.size() == 1, ' User ' + vendor1.Id + ' is expected to have access to the record');
        }
        Test.stopTest();
    }

    @isTest
    public static void testGesOrderTaskChangeOwner() {
        User am1 = GC_TestUtils.createUser('GC Account Manager', 'unit_test', 'account_manager1');
        User am2 = GC_TestUtils.createUser('GC Account Manager', 'unit_test', 'account_manager2');
        Account acc = GC_TestUtils.getAccount();
        User client1 = GC_TestUtils.createPortalUser('GC Community Client', 'unit_test', 'client1', acc);
        User client2 = GC_TestUtils.createPortalUser('GC Community Client', 'unit_test', 'client2', acc);

        GC_Connect2_Show__c show;
        GC_Order__c order;
        GC_GES_Order_Task__c orderTask;

        System.runAs(am1) {
            order = GC_TestUtils.getTestOrder();
            orderTask = GC_TestUtils.getTestOrderTask(order.Id, null);

            show = GC_Connect2ShowDao.getInstance().getConnect2ShowById(order.Connect2_Show__c);

            GC_Show_Team_Member__c stmAm2 = new GC_Show_Team_Member__c();
            stmAm2.Connect2_Show__c = show.Id;
            stmAm2.User__c = am2.Id;
            stmAm2.Show_Role__c = 'Account Manager';
            insert stmAm2;
            GC_Show_Team_Member__c stmClient1 = new GC_Show_Team_Member__c();
            stmClient1.Connect2_Show__c = show.Id;
            stmClient1.User__c = client1.Id;
            stmClient1.Show_Role__c = 'Show Organizer';
            insert stmClient1;
            GC_Show_Team_Member__c stmClient2 = new GC_Show_Team_Member__c();
            stmClient2.Connect2_Show__c = show.Id;
            stmClient2.User__c = client2.Id;
            stmClient2.Show_Role__c = 'Show Organizer';
            insert stmClient2;
        }
        Test.startTest();
        System.runAs(client1) {
            List<GC_GES_Order_Task__c> recordQuery = [Select Id from GC_GES_Order_Task__c where Id = :orderTask.Id];
            System.assert(recordQuery.size() == 1, ' User ' + client1.Id + ' is expected to have access to the record');
        }
        System.runAs(client2) {
            List<GC_GES_Order_Task__c> recordQuery = [Select Id from GC_GES_Order_Task__c where Id = :orderTask.Id];
            System.assert(recordQuery.size() == 1, ' User ' + client2.Id + ' is expected to have access to the record');
        }
        System.runAs(am1) {
            orderTask.OwnerId = am2.Id;
            update orderTask;
        }
        System.runAs(client1) {
            List<GC_GES_Order_Task__c> recordQuery = [Select Id from GC_GES_Order_Task__c where Id = :orderTask.Id];
            System.assert(recordQuery.size() == 1, ' User ' + client1.Id + ' is expected to have access to the record');
        }
        System.runAs(client2) {
            List<GC_GES_Order_Task__c> recordQuery = [Select Id from GC_GES_Order_Task__c where Id = :orderTask.Id];
            System.assert(recordQuery.size() == 1, ' User ' + client2.Id + ' is expected to have access to the record');
        }
        Test.stopTest();
    }

    @isTest
    public static void testGesOrderTaskChangeOwner2() {
        User am1 = GC_TestUtils.createUser('GC Account Manager', 'unit_test', 'account_manager1');
        User am2 = GC_TestUtils.createUser('GC Account Manager', 'unit_test', 'account_manager2');
        Account acc = GC_TestUtils.getAccount();
        User client1 = GC_TestUtils.createPortalUser('GC Community Client', 'unit_test', 'client1', acc);
        User client2 = GC_TestUtils.createPortalUser('GC Community Client', 'unit_test', 'client2', acc);

        GC_Connect2_Show__c show;
        GC_Order__c order;
        GC_GES_Order_Task__c orderTask;

        System.runAs(am1) {
            order = GC_TestUtils.getTestOrder();
            show = GC_Connect2ShowDao.getInstance().getConnect2ShowById(order.Connect2_Show__c);

            GC_Show_Team_Member__c stmAm2 = new GC_Show_Team_Member__c();
            stmAm2.Connect2_Show__c = show.Id;
            stmAm2.User__c = am2.Id;
            stmAm2.Show_Role__c = 'Account Manager';
            insert stmAm2;
            GC_Show_Team_Member__c stmClient1 = new GC_Show_Team_Member__c();
            stmClient1.Connect2_Show__c = show.Id;
            stmClient1.User__c = client1.Id;
            stmClient1.Show_Role__c = 'Show Organizer';
            insert stmClient1;
            GC_Show_Team_Member__c stmClient2 = new GC_Show_Team_Member__c();
            stmClient2.Connect2_Show__c = show.Id;
            stmClient2.User__c = client2.Id;
            stmClient2.Show_Role__c = 'Show Organizer';
            insert stmClient2;

            orderTask = GC_TestUtils.getTestOrderTask(order.Id, null);
        }
        Test.startTest();
        System.runAs(client1) {
            List<GC_GES_Order_Task__c> recordQuery = [Select Id from GC_GES_Order_Task__c where Id = :orderTask.Id];
            System.assert(recordQuery.size() == 1, ' User ' + client1.Id + ' is expected to have access to the record');
        }
        System.runAs(client2) {
            List<GC_GES_Order_Task__c> recordQuery = [Select Id from GC_GES_Order_Task__c where Id = :orderTask.Id];
            System.assert(recordQuery.size() == 1, ' User ' + client2.Id + ' is expected to have access to the record');
        }
        System.runAs(am1) {
            orderTask.OwnerId = am2.Id;
            update orderTask;
        }
        System.runAs(client1) {
            List<GC_GES_Order_Task__c> recordQuery = [Select Id from GC_GES_Order_Task__c where Id = :orderTask.Id];
            System.assert(recordQuery.size() == 1, ' User ' + client1.Id + ' is expected to have access to the record');
        }
        System.runAs(client2) {
            List<GC_GES_Order_Task__c> recordQuery = [Select Id from GC_GES_Order_Task__c where Id = :orderTask.Id];
            System.assert(recordQuery.size() == 1, ' User ' + client2.Id + ' is expected to have access to the record');
        }
        Test.stopTest();
    }

    @isTest
    public static void testVendorOrderTaskChangeOwner() {
        User am1 = GC_TestUtils.createUser('GC Account Manager', 'unit_test', 'account_manager1');
        User am2 = GC_TestUtils.createUser('GC Account Manager', 'unit_test', 'account_manager2');
        Account acc = GC_TestUtils.getAccount();
        User client1 = GC_TestUtils.createPortalUser('GC Community Client', 'unit_test', 'client1', acc);
        User client2 = GC_TestUtils.createPortalUser('GC Community Client', 'unit_test', 'client2', acc);
        User vendor1 = GC_TestUtils.createPortalUser('GC Community Vendor', 'unit_test', 'vendor1', acc);

        GC_Connect2_Show__c show;
        GC_Order__c order;
        GC_Vendor_Order_Task__c orderTask;

        System.runAs(am1) {
            order = GC_TestUtils.getTestOrder();
            orderTask = GC_TestUtils.getTestVendorTask(order.Id, vendor1.Id);
            show = GC_Connect2ShowDao.getInstance().getConnect2ShowById(order.Connect2_Show__c);

            GC_Show_Team_Member__c stmAm2 = new GC_Show_Team_Member__c();
            stmAm2.Connect2_Show__c = show.Id;
            stmAm2.User__c = am2.Id;
            stmAm2.Show_Role__c = 'Account Manager';
            insert stmAm2;
            GC_Show_Team_Member__c stmClient1 = new GC_Show_Team_Member__c();
            stmClient1.Connect2_Show__c = show.Id;
            stmClient1.User__c = client1.Id;
            stmClient1.Show_Role__c = 'Show Organizer';
            insert stmClient1;
            GC_Show_Team_Member__c stmClient2 = new GC_Show_Team_Member__c();
            stmClient2.Connect2_Show__c = show.Id;
            stmClient2.User__c = client2.Id;
            stmClient2.Show_Role__c = 'Show Organizer';
            insert stmClient2;
        }
        Test.startTest();
        System.runAs(client1) {
            List<GC_Vendor_Order_Task__c> recordQuery = [Select Id from GC_Vendor_Order_Task__c where Id = :orderTask.Id];
            System.assert(recordQuery.size() == 1, ' User ' + client1.Id + ' is expected to have access to the record');
        }
        System.runAs(client2) {
            List<GC_Vendor_Order_Task__c> recordQuery = [Select Id from GC_Vendor_Order_Task__c where Id = :orderTask.Id];
            System.assert(recordQuery.size() == 1, ' User ' + client2.Id + ' is expected to have access to the record');
        }
        System.runAs(vendor1) {
            List<GC_Vendor_Order_Task__c> recordQuery = [Select Id from GC_Vendor_Order_Task__c where Id = :orderTask.Id];
            System.assert(recordQuery.size() == 1, ' User ' + vendor1.Id + ' is expected to have access to the record');
        }
        System.runAs(am1) {
            orderTask.OwnerId = am2.Id;
            update orderTask;
        }
        System.runAs(client1) {
            List<GC_Vendor_Order_Task__c> recordQuery = [Select Id from GC_Vendor_Order_Task__c where Id = :orderTask.Id];
            System.assert(recordQuery.size() == 1, ' User ' + client1.Id + ' is expected to have access to the record');
        }
        System.runAs(client2) {
            List<GC_Vendor_Order_Task__c> recordQuery = [Select Id from GC_Vendor_Order_Task__c where Id = :orderTask.Id];
            System.assert(recordQuery.size() == 1, ' User ' + client2.Id + ' is expected to have access to the record');
        }
        System.runAs(vendor1) {
            List<GC_Vendor_Order_Task__c> recordQuery = [Select Id from GC_Vendor_Order_Task__c where Id = :orderTask.Id];
            System.assert(recordQuery.size() == 1, ' User ' + vendor1.Id + ' is expected to have access to the record');
        }
        Test.stopTest();
    }

    @isTest
    public static void testVendorOrderTaskChangeOwner2() {
        User am1 = GC_TestUtils.createUser('GC Account Manager', 'unit_test', 'account_manager1');
        User am2 = GC_TestUtils.createUser('GC Account Manager', 'unit_test', 'account_manager2');
        Account acc = GC_TestUtils.getAccount();
        User client1 = GC_TestUtils.createPortalUser('GC Community Client', 'unit_test', 'client1', acc);
        User client2 = GC_TestUtils.createPortalUser('GC Community Client', 'unit_test', 'client2', acc);
        User vendor1 = GC_TestUtils.createPortalUser('GC Community Vendor', 'unit_test', 'vendor1', acc);

        GC_Connect2_Show__c show;
        GC_Order__c order;
        GC_Vendor_Order_Task__c orderTask;

        System.runAs(am1) {
            order = GC_TestUtils.getTestOrder();
            show = GC_Connect2ShowDao.getInstance().getConnect2ShowById(order.Connect2_Show__c);

            GC_Show_Team_Member__c stmAm2 = new GC_Show_Team_Member__c();
            stmAm2.Connect2_Show__c = show.Id;
            stmAm2.User__c = am2.Id;
            stmAm2.Show_Role__c = 'Account Manager';
            insert stmAm2;
            GC_Show_Team_Member__c stmClient1 = new GC_Show_Team_Member__c();
            stmClient1.Connect2_Show__c = show.Id;
            stmClient1.User__c = client1.Id;
            stmClient1.Show_Role__c = 'Show Organizer';
            insert stmClient1;
            GC_Show_Team_Member__c stmClient2 = new GC_Show_Team_Member__c();
            stmClient2.Connect2_Show__c = show.Id;
            stmClient2.User__c = client2.Id;
            stmClient2.Show_Role__c = 'Show Organizer';
            insert stmClient2;

            orderTask = GC_TestUtils.getTestVendorTask(order.Id, vendor1.Id);
        }
        Test.startTest();
        System.runAs(client1) {
            List<GC_Vendor_Order_Task__c> recordQuery = [Select Id from GC_Vendor_Order_Task__c where Id = :orderTask.Id];
            System.assert(recordQuery.size() == 1, ' User ' + client1.Id + ' is expected to have access to the record');
        }
        System.runAs(client2) {
            List<GC_Vendor_Order_Task__c> recordQuery = [Select Id from GC_Vendor_Order_Task__c where Id = :orderTask.Id];
            System.assert(recordQuery.size() == 1, ' User ' + client2.Id + ' is expected to have access to the record');
        }
        System.runAs(vendor1) {
            List<GC_Vendor_Order_Task__c> recordQuery = [Select Id from GC_Vendor_Order_Task__c where Id = :orderTask.Id];
            System.assert(recordQuery.size() == 1, ' User ' + vendor1.Id + ' is expected to have access to the record');
        }
        System.runAs(am1) {
            orderTask.OwnerId = am2.Id;
            update orderTask;
        }
        System.runAs(client1) {
            List<GC_Vendor_Order_Task__c> recordQuery = [Select Id from GC_Vendor_Order_Task__c where Id = :orderTask.Id];
            System.assert(recordQuery.size() == 1, ' User ' + client1.Id + ' is expected to have access to the record');
        }
        System.runAs(client2) {
            List<GC_Vendor_Order_Task__c> recordQuery = [Select Id from GC_Vendor_Order_Task__c where Id = :orderTask.Id];
            System.assert(recordQuery.size() == 1, ' User ' + client2.Id + ' is expected to have access to the record');
        }
        System.runAs(vendor1) {
            List<GC_Vendor_Order_Task__c> recordQuery = [Select Id from GC_Vendor_Order_Task__c where Id = :orderTask.Id];
            System.assert(recordQuery.size() == 1, ' User ' + vendor1.Id + ' is expected to have access to the record');
        }
        Test.stopTest();
    }

}