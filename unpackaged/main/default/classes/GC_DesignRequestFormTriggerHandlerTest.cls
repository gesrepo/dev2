/**
* @author Ethos Solutions - www.ethos.com
* @description Test code for Design Request Form trigger handler
* 2016-04-13 : Original Version
**/
@isTest
public class GC_DesignRequestFormTriggerHandlerTest {

    public static testmethod void handleRFPCustomPopulateTest() {
        GC_Connect2_Show__c show2 = GC_TestUtils.getTestConnect2Show();
        show2.Job_Number__c = '1234';
        show2.Show_ID__c = '56789';
        update show2;

        GC_Design_Request_Form__c custom = new GC_Design_Request_Form__c();
        custom.Connect2_Show__c = show2.Id;
        custom.Status__c = 'New';
        insert custom;

        custom = GC_DesignRequestFormDao.getInstance().getDesignRequestFormById(custom.id);
        //System.assertNotEquals(show2.Job_Number__c, custom.DRF_Job_Number__c);
    }

    public static testMethod void getSameUserTest() {
        User sysAdminUser = GC_TestUtils.createUser('System Administrator', 'test', 'sysadmin');
        GC_Connect2_Show__c show;
        System.runAs(sysAdminUser) {
            show = GC_TestUtils.getTestConnect2Show();
        }
        Map<String, User> userMap = GC_TestUtils.getUsers();
        User user = userMap.get('AM');
        GC_Design_Request_Form__c drf = new GC_Design_Request_Form__c();
        drf.Connect2_Show__c = show.Id;
        drf.Requester_User__c = user.Id;
        drf.Requester_Secondary_User__c = user.Id;
        insert drf;
        List<GC_Show_Team_Member__c> showMemberList = [SELECT Id, Name, Show_Role__c, Connect2_Show__c, Show_Name__c, User__c FROM GC_Show_Team_Member__c WHERE Connect2_Show__c = :show.Id];
        System.assertEquals(showMemberList.size() , 1);
        System.assertEquals(showMemberList.get(0).Show_Role__c , 'Account Manager');
        System.assertEquals(showMemberList.get(0).User__c , user.Id);
    }

    public static testMethod void getDifferentUserTest() {
        User sysAdminUser = GC_TestUtils.createUser('System Administrator', 'test', 'sysadmin');
        GC_Connect2_Show__c show;
        System.runAs(sysAdminUser) {
            show = GC_TestUtils.getTestConnect2Show();
        }
        Map<String, User> userMap = GC_TestUtils.getUsers();
        User user = userMap.get('CD');
        User user2 = userMap.get('DAM');
        GC_Design_Request_Form__c drf = new GC_Design_Request_Form__c();
        drf.Connect2_Show__c = show.Id;
        drf.Requester_User__c = user.Id;
        drf.Requester_Secondary_User__c = user2.Id;
        insert drf;
        List<GC_Show_Team_Member__c> showMemberList = [SELECT Id, Name, Show_Role__c, Connect2_Show__c, Show_Name__c, User__c FROM GC_Show_Team_Member__c WHERE Connect2_Show__c = :show.Id];
        System.assertEquals(showMemberList.size() , 2);
        showMemberList = [SELECT Id, Name, Show_Role__c, Connect2_Show__c, Show_Name__c, User__c FROM GC_Show_Team_Member__c WHERE Connect2_Show__c = :show.Id AND User__c = :user.Id];
        System.assertEquals(showMemberList.get(0).Show_Role__c , 'Creative Director');
        showMemberList = [SELECT Id, Name, Show_Role__c, Connect2_Show__c, Show_Name__c, User__c FROM GC_Show_Team_Member__c WHERE Connect2_Show__c = :show.Id AND User__c = :user2.Id];
        System.assertEquals(showMemberList.get(0).Show_Role__c , 'Director of Account Management');
    }

    public static testMethod void getOtherDifferentUserTest() {
        User sysAdminUser = GC_TestUtils.createUser('System Administrator', 'test', 'sysadmin');
        GC_Connect2_Show__c show;
        System.runAs(sysAdminUser) {
            show = GC_TestUtils.getTestConnect2Show();
        }
        Map<String, User> userMap = GC_TestUtils.getUsers();
        User user = userMap.get('SM');
        User user2 = userMap.get('CD');
        GC_Design_Request_Form__c drf = new GC_Design_Request_Form__c();
        drf.Connect2_Show__c = show.Id;
        drf.Requester_User__c = user.Id;
        drf.Requester_Secondary_User__c = user2.Id;
        insert drf;
        List<GC_Show_Team_Member__c> showMemberList = [SELECT Id, Name, Show_Role__c, Connect2_Show__c, Show_Name__c, User__c FROM GC_Show_Team_Member__c WHERE Connect2_Show__c = :show.Id];
        System.assertEquals(showMemberList.size() , 2);
        showMemberList = [SELECT Id, Name, Show_Role__c, Connect2_Show__c, Show_Name__c, User__c FROM GC_Show_Team_Member__c WHERE Connect2_Show__c = :show.Id AND User__c = :user.Id];
        System.assertEquals(showMemberList.get(0).Show_Role__c , 'Account Manager');
        showMemberList = [SELECT Id, Name, Show_Role__c, Connect2_Show__c, Show_Name__c, User__c FROM GC_Show_Team_Member__c WHERE Connect2_Show__c = :show.Id AND User__c = :user2.Id];
        System.assertEquals(showMemberList.get(0).Show_Role__c , 'Creative Director');
    }

    public static testMethod void getLastDifferentUserTest() {
        User sysAdminUser = GC_TestUtils.createUser('System Administrator', 'test', 'sysadmin');
        GC_Connect2_Show__c show;
        System.runAs(sysAdminUser) {
            show = GC_TestUtils.getTestConnect2Show();
        }
        Map<String, User> userMap = GC_TestUtils.getUsers();
        User user = userMap.get('DAM');
        User user2 = userMap.get('SM');
        GC_Design_Request_Form__c drf = new GC_Design_Request_Form__c();
        drf.Connect2_Show__c = show.Id;
        drf.Requester_User__c = user.Id;
        drf.Requester_Secondary_User__c = user2.Id;
        insert drf;
        List<GC_Show_Team_Member__c> showMemberList = [SELECT Id, Name, Show_Role__c, Connect2_Show__c, Show_Name__c, User__c FROM GC_Show_Team_Member__c WHERE Connect2_Show__c = :show.Id];
        System.assertEquals(showMemberList.size() , 2);
        showMemberList = [SELECT Id, Name, Show_Role__c, Connect2_Show__c, Show_Name__c, User__c FROM GC_Show_Team_Member__c WHERE Connect2_Show__c = :show.Id AND User__c = :user.Id];
        System.assertEquals(showMemberList.get(0).Show_Role__c , 'Director of Account Management');
        showMemberList = [SELECT Id, Name, Show_Role__c, Connect2_Show__c, Show_Name__c, User__c FROM GC_Show_Team_Member__c WHERE Connect2_Show__c = :show.Id AND User__c = :user2.Id];
        System.assertEquals(showMemberList.get(0).Show_Role__c , 'Account Manager');
    }
}