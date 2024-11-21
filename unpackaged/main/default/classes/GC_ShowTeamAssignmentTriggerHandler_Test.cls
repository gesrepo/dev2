/**
* @author Ethos Solutions - www.ethos.com
* @description Test code for Show Team Assignment trigger handler
* 2016-04-13 : Original Version
**/
@isTest
private class GC_ShowTeamAssignmentTriggerHandler_Test {

    @isTest
    public static void testTrafficAdminAssignment() {
        Map<String, User> users = GC_TestUtils.getUsers();
        User user = users.get('TA');
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        GC_Design_Request_Form__c drf = GC_TestUtils.getTestDRF(show.Id);
        GC_Design_Element__c de = GC_TestUtils.getTestDesignElement(drf.Id);
        GC_Design_Request_Form_Budget__c budget = new GC_Design_Request_Form_Budget__c();
        budget.Design_Request_Form__c = drf.Id;
        insert budget;
        GC_Show_Attribute__c sa = new GC_Show_Attribute__c();
        sa.Name_Unique__c = 'Test Attribute';
        sa.Connect2_Show__c = show.Id;
        insert sa;
        GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c();
        stm.Connect2_Show__c = show.Id;
        stm.User__c = user.Id;
        stm.Show_Role__c = 'Traffic Administrator';
        insert stm;
        Map<String, RecordType> staRecordTypes = GC_TestUtils.getRecordType('GC_Show_Team_Assignment__c');
        List<GC_Show_Team_Assignment__c> stas = new List<GC_Show_Team_Assignment__c>();
        GC_Show_Team_Assignment__c sta1 = new GC_Show_Team_Assignment__c();
        sta1.RecordTypeId = staRecordTypes.get('Design Element Assignment').Id;
        sta1.Connect2_Show__c = show.Id;
        sta1.Show_Team_Member__c = stm.Id;
        sta1.Design_Element__c = de.Id;
        stas.add(sta1);
        insert stas;
        System.runAs(user) {
            List<GC_Connect2_Show__c> showQuery = [Select Id from GC_Connect2_Show__c where Id = :show.Id];
            System.assert(showQuery.size() == 1, 'User is Expected to have access to the Show');
            List<GC_Design_Request_Form__c> drfQuery = [Select Id from GC_Design_Request_Form__c where Id = :drf.Id];
            System.assert(drfQuery.size() == 1, 'User is Expected to have access to the DRF');
            List<GC_Design_Request_Form_Budget__c> budgetQuery = [Select Id from GC_Design_Request_Form_Budget__c where Id = :budget.Id];
            System.assert(budgetQuery.size() == 1, 'User is Expected to have access to the DRF Budget');
            List<GC_Show_Attribute__c> attributeQuery = [Select Id from GC_Show_Attribute__c where Id = :sa.Id];
            System.assert(attributeQuery.size() == 1, 'User is Expected to have access to the Show Attribute');
            List<GC_Design_Element__c> deQuery = [Select Id from GC_Design_Element__c where Id = :de.Id];
            System.assert(deQuery.size() == 1, 'User is Expected to have access to the Design Element');
        }
    }

    @isTest
    public static void testGraphicsProjectManagerAssignment() {
        Map<String, User> users = GC_TestUtils.getUsers();
        User user = users.get('GPM');
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        GC_Design_Request_Form__c drf = GC_TestUtils.getTestDRF(show.Id);
        GC_Design_Element__c de = GC_TestUtils.getTestDesignElement(drf.Id);
        GC_Design_Request_Form_Budget__c budget = new GC_Design_Request_Form_Budget__c();
        budget.Design_Request_Form__c = drf.Id;
        insert budget;
        GC_Show_Attribute__c sa = new GC_Show_Attribute__c();
        sa.Name_Unique__c = 'Test Attribute';
        sa.Connect2_Show__c = show.Id;
        insert sa;
        GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c();
        stm.Connect2_Show__c = show.Id;
        stm.User__c = user.Id;
        stm.Show_Role__c = 'Graphics Project Manager';
        insert stm;
        Map<String, RecordType> staRecordTypes = GC_TestUtils.getRecordType('GC_Show_Team_Assignment__c');
        List<GC_Show_Team_Assignment__c> stas = new List<GC_Show_Team_Assignment__c>();
        GC_Show_Team_Assignment__c sta1 = new GC_Show_Team_Assignment__c();
        sta1.RecordTypeId = staRecordTypes.get('Design Element Assignment').Id;
        sta1.Connect2_Show__c = show.Id;
        sta1.Show_Team_Member__c = stm.Id;
        sta1.Design_Element__c = de.Id;
        stas.add(sta1);
        insert stas;
        System.runAs(user) {
            List<GC_Connect2_Show__c> showQuery = [Select Id from GC_Connect2_Show__c where Id = :show.Id];
            System.assert(showQuery.size() == 1, 'User is Expected to have access to the Show');
            List<GC_Design_Request_Form__c> drfQuery = [Select Id from GC_Design_Request_Form__c where Id = :drf.Id];
            System.assert(drfQuery.size() == 0, 'User is Expected to NOT have access to the DRF');
            List<GC_Design_Request_Form_Budget__c> budgetQuery = [Select Id from GC_Design_Request_Form_Budget__c where Id = :budget.Id];
            System.assert(budgetQuery.size() == 0, 'User is Expected to NOT have access to the DRF Budget');
            List<GC_Show_Attribute__c> attributeQuery = [Select Id from GC_Show_Attribute__c where Id = :sa.Id];
            System.assert(attributeQuery.size() == 1, 'User is Expected to have access to the Show Attribute');
            List<GC_Design_Element__c> deQuery = [Select Id from GC_Design_Element__c where Id = :de.Id];
            System.assert(deQuery.size() == 1, 'User is Expected to have access to the Design Element');
        }
    }
}