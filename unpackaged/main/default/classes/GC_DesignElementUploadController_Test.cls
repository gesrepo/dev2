/**
* @author Ethos Solutions - www.ethos.com
* @description Test code for Design Element upload controller
* 2016-04-13 : Original Version
**/
@isTest
public with sharing class GC_DesignElementUploadController_Test {

    public static testMethod void testDesignElementCreation() {
        GC_Connect2_Show__c show =  GC_TestUtils.getTestConnect2Show();
        GC_Design_Element__c newDE = new GC_Design_Element__c();
        //newDE.Design_Request_Form__c = newDRF.Id;
        newDE.Requester__c = UserInfo.getUserId();
        newDE.Task_Type__c = 'Design';
        newDE.Design_Element__c = 'Entrance';
        newDE.Task_Description__c = 'Test Design Element';
        newDE.Deliverable__c = 'Graphics';
        newDE.Status__c = 'Accepted';
        newDE.Revision__c = 1;
        newDE.Connect2_Show__c=show.Id;
        insert newDE;
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(newDE);
        GC_DesignElementUploadController controller = new GC_DesignElementUploadController(sc);
        //check the status
        controller.loadDesignElement();
    }
     public static testMethod void testDesignElementCreation2() {
        GC_Connect2_Show__c show =  GC_TestUtils.getTestConnect2Show();
        GC_Design_Element__c newDE = new GC_Design_Element__c();
        newDE.Requester__c = UserInfo.getUserId();
        newDE.Task_Type__c = 'Design';
        newDE.Design_Element__c = 'Entrance';
        newDE.Task_Description__c = 'Test Design Element';
        newDE.Deliverable__c = 'Graphics';
        newDE.Status__c = 'Approved';
        newDE.Revision__c = 1;
        newDE.Connect2_Show__c=show.Id;
        insert newDE;
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(newDE);
        GC_DesignElementUploadController controller = new GC_DesignElementUploadController(sc);
        controller.loadDesignElement();
    }
    
    public static testMethod void testStatusOnHold() {
        GC_Connect2_Show__c show =  GC_TestUtils.getTestConnect2Show();
        GC_Design_Element__c newDE = new GC_Design_Element__c();
        newDE.Requester__c = UserInfo.getUserId();
        newDE.Task_Type__c = 'Design';
        newDE.Design_Element__c = 'Entrance';
        newDE.Task_Description__c = 'Test Design Element';
        newDE.Deliverable__c = 'Graphics';
        newDE.Status__c = 'Archived';
        newDE.Revision__c = 1;
        newDE.Connect2_Show__c=show.Id;
        insert newDE;
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(newDE);
        GC_DesignElementUploadController controller = new GC_DesignElementUploadController(sc);
        controller.onHold();
    }

    public static testMethod void testDesignElementStatus() {
        
        User accountManager = GC_TestUtils.createUser('GC Account Manager', 'account', 'manager');
        System.runAs(accountManager) {
            GC_Connect2_Show__c show =  GC_TestUtils.getTestConnect2Show();
            show.Show_End_Date__c = Date.today() - 10;
            update show;
            GC_Design_Element__c newDE = GC_TestUtils.getTestDesignElement(show.Id);
            GC_Design_Element__c deQuery = GC_DesignElementDao.getInstance().getDesignElementById(newDe.Id);
            ApexPages.StandardController sc = new ApexPages.StandardController(deQuery);
            GC_DesignElementUploadController cont = new GC_DesignElementUploadController(sc);
            
            cont.onHold();
            deQuery = GC_DesignElementDao.getInstance().getDesignElementById(newDe.Id);
            System.assertEquals(deQuery.Status__c , 'On Hold/WFI');
            cont.onHold();
            
            cont.releaseHold();
            deQuery = GC_DesignElementDao.getInstance().getDesignElementById(newDe.Id);
            System.assertEquals(deQuery.Status__c , 'New');
            cont.releaseHold();
            
            cont.cancel();
            deQuery = GC_DesignElementDao.getInstance().getDesignElementById(newDe.Id);
            System.assertEquals(deQuery.Status__c , 'Canceled');
            cont.cancel();
        }
    }

}