@isTest
private class GC_Connect2ShowViewControllerTest {

    @isTest static void testAddToShow() {
        User am = GC_TestUtils.createUser('GC Account Manager', 'test', 'user');
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        ApexPages.StandardController sc = new ApexPages.StandardController(show);
        GC_Connect2ShowViewController viewController = new GC_Connect2ShowViewController(sc);
        // This should be system admin running unit tests.
        System.assertEquals(true, viewController.isSysAdmin);
    }

    @isTest static void testAddToShowAM() {
        User addedUser = GC_TestUtils.createUser('GC Account Manager', 'test', 'user');
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        System.runAs(addedUser) {
            ApexPages.StandardController sc = new ApexPages.StandardController(show);
            GC_Connect2ShowViewController viewController = new GC_Connect2ShowViewController(sc);
            viewController.selectedRole = 'Account Manager';
            PageReference pr = viewController.addCurrentUserToShow();
            System.assertEquals(true, viewController.isOnShow);
        }
    }

    @isTest static void testAddToShowTA() {
        User addedUser = GC_TestUtils.createUser('GC Traffic Administrator', 'test', 'user');
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        System.runAs(addedUser) {
            ApexPages.StandardController sc = new ApexPages.StandardController(show);
            GC_Connect2ShowViewController viewController = new GC_Connect2ShowViewController(sc);
            viewController.selectedRole = 'Traffic Administrator';
            PageReference pr = viewController.addCurrentUserToShow();
            System.assertEquals(true, viewController.isOnShow);
        }
    }

    @isTest static void testAddToShowCD() {
        User addedUser = GC_TestUtils.createUser('GC Creative Director', 'test', 'user');
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        System.runAs(addedUser) {
            ApexPages.StandardController sc = new ApexPages.StandardController(show);
            GC_Connect2ShowViewController viewController = new GC_Connect2ShowViewController(sc);
            viewController.selectedRole = 'Creative Director';
            PageReference pr = viewController.addCurrentUserToShow();
            System.assertEquals(true, viewController.isOnShow);
        }
    }

    //@isTest static void testAddToShowDET() {
    //    User addedUser = GC_TestUtils.createUser('GC Detailer', 'test', 'user');
    //    GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
    //    System.runAs(addedUser) {
    //        ApexPages.StandardController sc = new ApexPages.StandardController(show);
    //        GC_Connect2ShowViewController viewController = new GC_Connect2ShowViewController(sc);
    //        viewController.selectedRole = 'Detailer';
    //        PageReference pr = viewController.addCurrentUserToShow();
    //        System.assertEquals(true, viewController.isOnShow);
    //    }
    //}

    @isTest static void testAddToShowGPM() {
        User addedUser = GC_TestUtils.createUser('GC Graphics Project Manager', 'test', 'user');
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        System.runAs(addedUser) {
            ApexPages.StandardController sc = new ApexPages.StandardController(show);
            GC_Connect2ShowViewController viewController = new GC_Connect2ShowViewController(sc);
            viewController.selectedRole = 'Graphics Project Manager';
            PageReference pr = viewController.addCurrentUserToShow();
            System.assertEquals(true, viewController.isOnShow);
            viewController.getDisplayOptions();
            viewController.getHiddenOptions();
            viewController.saveDisplayOptions();
            viewController.resetDisplayOptions();

        }
    }
}