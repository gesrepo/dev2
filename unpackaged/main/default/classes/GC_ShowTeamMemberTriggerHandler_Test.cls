/**
* @author Ethos Solutions - www.ethos.com
* @description Test code for Show Team Member trigger handler
* 2016-04-13 : Original Version
**/
@isTest
private class GC_ShowTeamMemberTriggerHandler_Test {

   @isTest
    public static void testAsAccountManager() {
        Map<String, User> users = GC_TestUtils.getUsers();
        User user = users.get('AM');
        System.runAs(user) {
            GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
            GC_Design_Request_Form__c drf = GC_TestUtils.getTestDRF(show.Id);
            GC_Design_Request_Form_Budget__c budget = new GC_Design_Request_Form_Budget__c();
            budget.Design_Request_Form__c = drf.Id;
            insert budget;
            GC_Show_Attribute__c sa = new GC_Show_Attribute__c();
            sa.Name_Unique__c = 'Test Attribute';
            sa.Connect2_Show__c = show.Id;
            insert sa;
            // Trigger automatically inserts this user.
            //GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c();
            //stm.Connect2_Show__c = show.Id;
            //stm.User__c = user.Id;
            //stm.Show_Role__c = 'Account Manager';
            //insert stm;
            GC_Design_Element__c de = GC_TestUtils.getTestDesignElement(show.Id);
            List<GC_Connect2_Show__c> showQuery = [Select Id from GC_Connect2_Show__c where Id = :show.Id];
            System.assert(showQuery.size() == 1, ' User ' + user.Id + ' is expected to have access to the show');
            List<GC_Design_Request_Form__c> drfQuery = [Select Id from GC_Design_Request_Form__c where Id = :drf.Id];
            System.assert(drfQuery.size() == 1, ' User ' + user.Id + ' is expected to have access to the design request form');
            List<GC_Design_Request_Form_Budget__c> budgetQuery = [Select Id from GC_Design_Request_Form_Budget__c where Id = :budget.Id];
            System.assert(budgetQuery.size() == 1, ' User ' + user.Id + ' is expected to have access to the design request form budget');
            List<GC_Show_Attribute__c> attributeQuery = [Select Id from GC_Show_Attribute__c where Id = :sa.Id];
            System.assert(attributeQuery.size() == 1, ' User ' + user.Id + ' is expected to have access to the show attribute');
            List<GC_Design_Element__c> deQuery = [Select Id from GC_Design_Element__c where Id = :de.Id];
            System.assert(deQuery.size() == 1, ' User ' + user.Id + ' is expected to have access to the design element task');
            List<GC_Show_Team_Member__c> stmQuery = [Select Id from GC_Show_Team_Member__c where Connect2_Show__c = :show.Id];
            System.assert(stmQuery.size() == 1, ' User ' + user.Id + ' is expected to have access to 1 Show Team Members' + ' actual return ' + stmQuery.size());
        }
    }

    @isTest
    public static void testAsAccountManager2() {
        Map<String, User> users = GC_TestUtils.getUsers();
        User user = users.get('AM');
        System.runAs(user) {
            GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
            GC_Design_Request_Form__c drf = GC_TestUtils.getTestDRF(show.Id);
            GC_Design_Request_Form_Budget__c budget = new GC_Design_Request_Form_Budget__c();
            budget.Design_Request_Form__c = drf.Id;
            insert budget;
            //GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c();
            //stm.Connect2_Show__c = show.Id;
            //stm.User__c = user.Id;
            //stm.Show_Role__c = 'Account Manager';
            //insert stm;
            GC_Show_Attribute__c sa = new GC_Show_Attribute__c();
            sa.Name_Unique__c = 'Test Attribute';
            sa.Connect2_Show__c = show.Id;
            insert sa;
            GC_Design_Element__c de = GC_TestUtils.getTestDesignElement(show.Id);
            List<GC_Connect2_Show__c> showQuery = [Select Id from GC_Connect2_Show__c where Id = :show.Id];
            System.assert(showQuery.size() == 1, ' User ' + user.Id + ' is expected to have access to the show');
            List<GC_Design_Request_Form__c> drfQuery = [Select Id from GC_Design_Request_Form__c where Id = :drf.Id];
            System.assert(drfQuery.size() == 1, ' User ' + user.Id + ' is expected to have access to the design request form');
            List<GC_Design_Request_Form_Budget__c> budgetQuery = [Select Id from GC_Design_Request_Form_Budget__c where Id = :budget.Id];
            System.assert(budgetQuery.size() == 1, ' User ' + user.Id + ' is expected to have access to the design request form budget');
            List<GC_Show_Attribute__c> attributeQuery = [Select Id from GC_Show_Attribute__c where Id = :sa.Id];
            System.assert(attributeQuery.size() == 1, ' User ' + user.Id + ' is expected to have access to the show attribute');
            List<GC_Design_Element__c> deQuery = [Select Id from GC_Design_Element__c where Id = :de.Id];
            System.assert(deQuery.size() == 1, ' User ' + user.Id + ' is expected to have access to the design element task');
            List<GC_Show_Team_Member__c> stmQuery = [Select Id from GC_Show_Team_Member__c where Connect2_Show__c = :show.Id];
            System.assert(stmQuery.size() == 1, ' User ' + user.Id + ' is expected to have access to 1 Show Team Members' + ' actual return ' + stmQuery.size());
        }
    }

    @isTest
    public static void testAsSecondaryAccountManager() {
        Map<String, User> users = GC_TestUtils.getUsers();
        User user1 = users.get('AM');
        User user2 = users.get('SM');
        GC_Connect2_Show__c show;
        GC_Design_Request_Form__c drf;
        GC_Design_Request_Form_Budget__c budget;
        GC_Show_Attribute__c sa;
        GC_Show_Team_Member__c stm;
        GC_Show_Team_Member__c stm2;
        GC_Design_Element__c de;
        //GC_Work_Order_Task__c wot;
        //GC_Sign_Order_Task__c sot;
        System.runAs(user1) {
            show = GC_TestUtils.getTestConnect2Show();
            drf = GC_TestUtils.getTestDRF(show.Id);
            budget = new GC_Design_Request_Form_Budget__c();
            budget.Design_Request_Form__c = drf.Id;
            insert budget;
            sa = new GC_Show_Attribute__c();
            sa.Name_Unique__c = 'Test Attribute';
            sa.Connect2_Show__c = show.Id;
            insert sa;
            stm2 = new GC_Show_Team_Member__c();
            stm2.Connect2_Show__c = show.Id;
            //stm2.User__c = user2.Id;
            stm2.Show_Role__c = 'Secondary Account Manager';
            //insert stm2;
            de = GC_TestUtils.getTestDesignElement(show.Id);
        }
        
        /*
        // commenting the code as the Profile GC Sales Manager is no longer available for use
        System.runAs(user2) {
            List<GC_Connect2_Show__c> showQuery = [Select Id from GC_Connect2_Show__c where Id = :show.Id];
            System.assert(showQuery.size() == 1, ' User ' + user.Id + ' is expected to have access to the show');
            List<GC_Design_Request_Form__c> drfQuery = [Select Id from GC_Design_Request_Form__c where Id = :drf.Id];
            System.assert(drfQuery.size() == 1, ' User ' + user.Id + ' is expected to have access to the design request form');
            List<GC_Design_Request_Form_Budget__c> budgetQuery = [Select Id from GC_Design_Request_Form_Budget__c where Id = :budget.Id];
            System.assert(budgetQuery.size() == 1, ' User ' + user.Id + ' is expected to have access to the design request form budget');
            List<GC_Show_Attribute__c> attributeQuery = [Select Id from GC_Show_Attribute__c where Id = :sa.Id];
            System.assert(attributeQuery.size() == 1, ' User ' + user.Id + ' is expected to have access to the show attribute');
            List<GC_Design_Element__c> deQuery = [Select Id from GC_Design_Element__c where Id = :de.Id];
            System.assert(deQuery.size() == 1, ' User ' + user.Id + ' is expected to have access to the design element task');
            List<GC_Show_Team_Member__c> stmQuery = [Select Id from GC_Show_Team_Member__c where Connect2_Show__c = :show.Id];
            System.assert(stmQuery.size() == 2, ' User ' + user.Id + ' is expected to have access to 2 Show Team Members' + ' actual return ' + stmQuery.size());
            // TODO as a follow on to update these tests, we should also probably test edit access or read only access
        }*/
    }

    @isTest
    public static void testAsCreativeDirectorTrafficAdmin1() {
        Map<String, User> users = GC_TestUtils.getUsers();
        User user1 = users.get('AM');
        User user3 = users.get('CD');
        GC_Connect2_Show__c show;
        GC_Design_Request_Form__c drf;
        GC_Design_Request_Form_Budget__c budget;
        GC_Show_Attribute__c sa;
        GC_Show_Team_Member__c stm;
        GC_Show_Team_Member__c stm3;
        GC_Design_Element__c de;
        System.runAs(user1) {
            show = GC_TestUtils.getTestConnect2Show();
            drf = GC_TestUtils.getTestDRF(show.Id);
            budget = new GC_Design_Request_Form_Budget__c();
            budget.Design_Request_Form__c = drf.Id;
            insert budget;
            sa = new GC_Show_Attribute__c();
            sa.Name_Unique__c = 'Test Attribute';
            sa.Connect2_Show__c = show.Id;
            insert sa;
            //stm = new GC_Show_Team_Member__c();
            //stm.Connect2_Show__c = show.Id;
            //stm.User__c = user1.Id;
            //stm.Show_Role__c = 'Account Manager';
            //insert stm;
            stm3 = new GC_Show_Team_Member__c();
            stm3.Connect2_Show__c = show.Id;
            stm3.User__c = user3.Id;
            stm3.Show_Role__c = 'Creative Director';
            insert stm3;
            de = GC_TestUtils.getTestDesignElement(show.Id);
        }
        System.runAs(user3) {
            List<GC_Connect2_Show__c> showQuery = [Select Id from GC_Connect2_Show__c where Id = :show.Id];
            System.assert(showQuery.size() == 1, ' User ' + user.Id + ' is expected to have access to the show');
            List<GC_Design_Request_Form__c> drfQuery = [Select Id from GC_Design_Request_Form__c where Id = :drf.Id];
            System.assert(drfQuery.size() == 1, ' User ' + user.Id + ' is expected to have access to the design request form');
            List<GC_Design_Request_Form_Budget__c> budgetQuery = [Select Id from GC_Design_Request_Form_Budget__c where Id = :budget.Id];
            //System.assert(budgetQuery.size() == 1, ' User ' + user.Id + ' is expected to have access to the design request form budget');
            List<GC_Show_Attribute__c> attributeQuery = [Select Id from GC_Show_Attribute__c where Id = :sa.Id];
            //System.assert(attributeQuery.size() == 1, ' User ' + user.Id + ' is expected to have access to the show attribute');
            List<GC_Design_Element__c> deQuery = [Select Id from GC_Design_Element__c where Id = :de.Id];
            //System.assert(deQuery.size() == 1, ' User ' + user.Id + ' is expected to have access to the design element task');
            List<GC_Show_Team_Member__c> stmQuery = [Select Id from GC_Show_Team_Member__c where Connect2_Show__c = :show.Id];
            //System.assert(stmQuery.size() == 2, ' User ' + user.Id + ' is expected to have access to all Show Team Members' + ' actual return ' + stmQuery.size());
            // TODO as a follow on to update these tests, we should also probably test edit access or read only access
        }
    }

    public static testMethod void deleteShowMemberTest(){
    
        
        User accountManager = GC_TestUtils.createUser('GC Account Manager', 'Bobby', 'AccountManager');
        User am2 = GC_TestUtils.createUser('GC Account Manager', 'Kent', 'TheAM');

        GC_Connect2_Show__c show;
        GC_Show_Team_Member__c stm;
        GC_Order__c order;
        GC_GES_Order_Task__c got;
        GC_Design_Request_Form__c drf;
        GC_Design_Element__c de;
        GC_Vendor_Order_Task__c vot;
        
        Test.starttest();
        System.runAs(accountManager){

            show = GC_TestUtils.getTestConnect2Show();
            stm = new GC_Show_Team_Member__c();
            stm.Connect2_Show__c = show.Id;
            stm.User__c = am2.Id;
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
            insert got;

            drf = GC_TestUtils.getTestDRF(show.Id);
            de = GC_TestUtils.getTestDesignElement(show.Id);

            vot = new GC_Vendor_Order_Task__c();
            vot.Order__c = order.Id;
            insert vot;
        }
        
        test.stoptest();

        System.runAs(am2){
            List<GC_Connect2_Show__c> showQuery = [Select Id from GC_Connect2_Show__c Where Id =:show.Id];
            System.assertEquals(showQuery.size() , 1);

            List<GC_Order__c> orderQuery = [select Id from GC_Order__c Where Id =:order.Id];
            System.assertEquals(orderQuery.size() , 1);

            List<GC_GES_Order_Task__c> gotQuery = [select Id from GC_GES_Order_Task__c Where Id =:got.Id];
            System.assertEquals(gotQuery.size() , 1);

            List<GC_Design_Request_Form__c> drfQuery = [select Id from GC_Design_Request_Form__c where Id =:drf.Id];
            System.assertEquals(drfQuery.size() , 1);

            List<GC_Design_Element__c> deQuery = [select Id from GC_Design_Element__c where Id =:de.Id];
            //System.assertEquals(deQuery.size() , 1);

            List<GC_Vendor_Order_Task__c> votQuery = [select Id from GC_Vendor_Order_Task__c Where Id =:vot.Id];
            System.assertEquals(votQuery.size() , 1);
        }

        System.runAs(accountManager){
            delete stm;
        }

        System.runAs(am2){
            //modifying the assertions as the GC Account Manager has view all permissions for GC_Order__c and GC_GES_Order_Task__c, GC_Design_Element__c and GC_Design_Request_Form__c
            List<GC_Order__c> orderQuery2 = [select Id from GC_Order__c Where Id =:order.Id];
            //System.assertEquals(orderQuery2.size() , 1);

            List<GC_GES_Order_Task__c> gotQuery2 = [select Id from GC_GES_Order_Task__c Where Id =:got.Id];
            //System.assertEquals(gotQuery2.size() , 1);

            List<GC_Connect2_Show__c> showQuery2 = [Select Id from GC_Connect2_Show__c Where Id =:show.Id];
            //System.assertEquals(showQuery2.size() , 1);

            List<GC_Design_Request_Form__c> drfQuery2 = [select Id from GC_Design_Request_Form__c where Id =:drf.Id];
            //System.assertEquals(drfQuery2.size() , 1);

            List<GC_Design_Element__c> deQuery2 = [select Id from GC_Design_Element__c where Id =:de.Id];
            //System.assertEquals(deQuery2.size() , 1);

            List<GC_Vendor_Order_Task__c> votQuery2 = [select Id from GC_Vendor_Order_Task__c Where Id =:vot.Id];
            //System.assertEquals(votQuery2.size() , 1);
        }

    }
    
    @isTest
    public static void sendEmailNewShowTeamMemberAddTest() {

        Map<String, User> users = GC_TestUtils.getUsers();
        User user1 = users.get('AM');
        User user3 = users.get('CD');
        user1.UserRoleId = [select Id from UserRole where Name = 'System Administrator'].Id;
        update user1;

        GC_Connect2_Show__c show;
        GC_Show_Attribute__c sa;
        GC_Show_Team_Member__c stm;
        System.runAs(user1) {
            Map<String, User> portalUsers = GC_TestUtils.getPortalUsers();
            User vendor = portalUsers.get('GC Community Vendor');
            show = GC_TestUtils.getTestConnect2Show();
            sa = new GC_Show_Attribute__c();
            sa.Name_Unique__c = 'Test Attribute';
            sa.Connect2_Show__c = show.Id;
            insert sa;
            stm = new GC_Show_Team_Member__c();
            stm.Connect2_Show__c = show.Id;
            stm.User__c = vendor.Id;
            stm.Show_Role__c = 'Vendor';
            stm.Service_Type__c = sa.Id;
            insert stm;
            GC_ShowTeamMemberTriggerHandler.sendEmailNewShowTeamMemberAdd(new List<GC_Show_Team_Member__c> {stm});
        }
    }
}