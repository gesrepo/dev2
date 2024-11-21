@isTest
public with sharing class GC_DesignRequestFormControllerTest {

    public static testMethod void drfTest() {
        GC_Connect2_Show__c show =  GC_TestUtils.getTestConnect2Show();
        show.Show_End_Date__c = Date.today() - 1;
        update show;
        Map<String, User> user = GC_TestUtils.getUsers();
        User userDetails = user.get('AM');
        GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c();
        stm.Connect2_Show__c = show.Id;
        stm.User__c = userDetails.Id;
        stm.Show_Role__c = 'Account Manager';
        insert stm;
        GC_Design_Request_Form__c newDRF = new GC_Design_Request_Form__c();
        newDRF.Connect2_Show__c = show.Id;
        newDRF.Status__c = 'New';
        newDRF.Requester_User__c = userDetails.Id;
        newDRF.Requester__c = stm.Id;
        insert newDRF;

        ApexPages.StandardController sc = new ApexPages.StandardController(newDrf);
        GC_DesignRequestFormController cont = new GC_DesignRequestFormController(sc);
        cont.closeDRF();
        GC_Design_Request_Form__c drf = GC_DesignRequestFormDao.getInstance().getDesignRequestFormById(newDRF.Id);
        System.assertEquals(drf.Status__c , 'Closed');
    }
    public static testMethod void closeDrfAsAMTest() {
        Map<String, User> user = GC_TestUtils.getUsers();
        User userDetails = user.get('AM');
        System.runAs(userDetails) {
            GC_Connect2_Show__c show =  GC_TestUtils.getTestConnect2Show();
            show.Show_End_Date__c = Date.today() + 1;
            update show;

            GC_Design_Request_Form__c newDRF = new GC_Design_Request_Form__c();
            newDRF.Connect2_Show__c = show.Id;
            newDRF.Status__c = 'New';
            newDRF.Requester_User__c = userDetails.Id;
            newDRF.Requester__c = [select Id from GC_Show_Team_Member__c where User__c = :userDetails.Id].Id;
            insert newDRF;

            ApexPages.StandardController sc = new ApexPages.StandardController(newDrf);
            GC_DesignRequestFormController cont = new GC_DesignRequestFormController(sc);
            cont.closeDRF();
            cont.getDRF();
            GC_Design_Request_Form__c drf = GC_DesignRequestFormDao.getInstance().getDesignRequestFormById(newDRF.Id);
            System.assertNotEquals(drf.Status__c , 'Closed');
        }
    }
}