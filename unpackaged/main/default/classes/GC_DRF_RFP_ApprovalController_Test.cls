/**
* @author Ethos Solutions - www.ethos.com
* @description Test code for Design Request Form RFP approval controller
* 2016-04-13 : Original Version
**/
@isTest
public class GC_DRF_RFP_ApprovalController_Test {
    @isTest
    public static void approvalTaTest() {
        User trafficAdmin = GC_TestUtils.createUser('GC Traffic Administrator', 'trafAd', 'ministrator');
        User creativeDirector = GC_TestUtils.createUser('GC Creative Director', 'DandyD', 'Singleton');
        User detailer = GC_TestUtils.createUser('GC Detailer', 'detailing', 'tom');
        Account account = GC_TestUtils.getAccount();
        Contact contact = GC_TestUtils.getContact('firstname', 'lastname', account);
        System.runAs(trafficAdmin) {
            GC_Connect2_Show__c show =  GC_TestUtils.getTestConnect2Show();
            GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c(
                User__c = trafficAdmin.Id,
                Connect2_Show__c = show.Id,
                Show_Role__c = 'Traffic Administrator');
            insert stm;
            GC_Show_Team_Member__c stm2 = new GC_Show_Team_Member__c(
                User__c = creativeDirector.Id,
                Connect2_Show__c = show.Id,
                Show_Role__c = 'Creative Director');
            insert stm2;
            GC_Design_Request_Form__c drf = new GC_Design_Request_Form__c();
            drf.Connect2_Show__c = show.Id;
            insert drf;
            GC_Design_Element__c newDE = new GC_Design_Element__c();
            newDE.Design_Request_Form__c = drf.Id;
            newDE.Creative_Director_Approvers__c = creativeDirector.Id;
            newDE.Traffic_Administrator_Approver__c = trafficAdmin.Id;
            test.startTest();
            insert newDE;
            test.stopTest();
            //newDE.Detailer_Approver__c = detailer.Id;  //Amarab 04062021 SAL-1243 Replacing old Designer/Detailer Approver1 field with new field
            newDE.Contact_Designer_Detailer_Approver1__c = contact.Id;
            update newDE;
            ApexPages.StandardController sc = new ApexPages.StandardController(newDE);
            GC_DRF_RFP_ApprovalController cont = new GC_DRF_RFP_ApprovalController(sc);
            PageReference pg = cont.setApprover();
            //FIXME Update this Test
            //System.assertNotEquals(pg , null);
        }
    }
    
    @isTest
    public static void approvalAmTest() {
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        
        System.runAs ( thisUser ) {
            User trafficAdmin = GC_TestUtils.createUser('GC Traffic Administrator', 'trafAd', 'ministrator');
            User creativeDirector = GC_TestUtils.createUser('GC Creative Director', 'DandyD', 'Singleton');
            User detailer = GC_TestUtils.createUser('GC Detailer', 'detailing', 'tom');
            User accountManager = GC_TestUtils.createUser('GC Account Manager', 'accounting1', 'manager2');
            Account account1 = GC_TestUtils.getAccount();
            Contact contact = GC_TestUtils.getContact('firstname', 'lastname', account1);
            System.runAs(accountManager) {
                GC_Connect2_Show__c show =  GC_TestUtils.getTestConnect2Show();
                GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c(
                    User__c = trafficAdmin.Id,
                    Connect2_Show__c = show.Id,
                    Show_Role__c = 'Traffic Administrator');
                insert stm;
                GC_Show_Team_Member__c stm2 = new GC_Show_Team_Member__c(
                    User__c = creativeDirector.Id,
                    Connect2_Show__c = show.Id,
                    Show_Role__c = 'Creative Director');
                insert stm2;
                GC_Design_Request_Form__c drf = new GC_Design_Request_Form__c();
                drf.Connect2_Show__c = show.Id;
                insert drf;
                GC_Design_Element__c newDE = new GC_Design_Element__c();
                newDE.Design_Request_Form__c = drf.Id;
                newDE.Creative_Director_Approvers__c = creativeDirector.Id;
                newDE.Traffic_Administrator_Approver__c = trafficAdmin.Id;
                insert newDE;
                //newDE.Detailer_Approver__c = detailer.Id;  //Amarab 04062021 SAL-1243 Replacing old Designer/Detailer Approver1 field with new field
                newDE.Contact_Designer_Detailer_Approver1__c = contact.Id;
                update newDE;
                
                Test.startTest();
                
                ApexPages.StandardController sc = new ApexPages.StandardController(newDE);
                GC_DRF_RFP_ApprovalController cont = new GC_DRF_RFP_ApprovalController(sc);
                PageReference pg = cont.setApprover();
                
                Test.stopTest();
                
                //FIXME Update this Test
                //System.assertNotEquals(pg , null);
            }
        }
    }
    @isTest
    public static void deOnHoldTest() {
        GC_Connect2_Show__c show =  GC_TestUtils.getTestConnect2Show();
        GC_Design_Request_Form__c drf = new GC_Design_Request_Form__c();
        drf.Connect2_Show__c = show.Id;
        insert drf;
        GC_Design_Element__c newDE = new GC_Design_Element__c();
        newDE.Design_Request_Form__c = drf.Id;
        newDE.Status__c = 'On Hold/WFI';
        insert newDE;
        ApexPages.StandardController sc = new ApexPages.StandardController(newDE);
        GC_DRF_RFP_ApprovalController cont = new GC_DRF_RFP_ApprovalController(sc);
        PageReference pg = cont.setApprover();
        System.assertEquals(pg , null);
    }
    
    @isTest
    public static void noDETTest() {
        User trafficAdmin = GC_TestUtils.createUser('GC Traffic Administrator', 'trafAd1', 'ministrator1');
        User creativeDirector = GC_TestUtils.createUser('GC Creative Director', 'DandyD2', 'Singleton2');
        GC_Connect2_Show__c show =  GC_TestUtils.getTestConnect2Show();
        GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c(
            User__c = trafficAdmin.Id,
            Connect2_Show__c = show.Id,
            Show_Role__c = 'Traffic Administrator');
        insert stm;
        GC_Show_Team_Member__c stm2 = new GC_Show_Team_Member__c(
            User__c = creativeDirector.Id,
            Connect2_Show__c = show.Id,
            Show_Role__c = 'Creative Director');
        insert stm2;
        GC_Design_Request_Form__c drf = new GC_Design_Request_Form__c();
        drf.Connect2_Show__c = show.Id;
        insert drf;
        GC_Design_Element__c newDE = new GC_Design_Element__c();
        newDE.Design_Request_Form__c = drf.Id;
        newDE.Creative_Director_Approvers__c = creativeDirector.Id;
        newDE.Traffic_Administrator_Approver__c = trafficAdmin.Id;
        insert newDE;
        System.runAs(trafficAdmin) {
            ApexPages.StandardController sc = new ApexPages.StandardController(newDE);
            GC_DRF_RFP_ApprovalController cont = new GC_DRF_RFP_ApprovalController(sc);
            PageReference pg = cont.setApprover();
            //System.assertEquals(pg , null);
        }
    }
    
    @isTest
    public static void failedApprovalTest() {
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        
        System.runAs ( thisUser ) {
            User trafficAdmin = GC_TestUtils.createUser('GC Traffic Administrator', 'trafA3', 'ministrato3');
            User creativeDirector = GC_TestUtils.createUser('GC Creative Director', 'Dandy5', 'Singleto5');
            User detailer = GC_TestUtils.createUser('GC Detailer', 'detailin1', 'tommy1');
            Account account2 = GC_TestUtils.getAccount();
            Contact contact = GC_TestUtils.getContact('firstname', 'lastname', account2);
            GC_Connect2_Show__c show =  GC_TestUtils.getTestConnect2Show();
            GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c(
                User__c = trafficAdmin.Id,
                Connect2_Show__c = show.Id,
                Show_Role__c = 'Traffic Administrator');
            insert stm;
            GC_Show_Team_Member__c stm2 = new GC_Show_Team_Member__c(
                User__c = creativeDirector.Id,
                Connect2_Show__c = show.Id,
                Show_Role__c = 'Creative Director');
            insert stm2;
            GC_Design_Request_Form__c drf = new GC_Design_Request_Form__c();
            drf.Connect2_Show__c = show.Id;
            insert drf;
            GC_Design_Element__c newDE = new GC_Design_Element__c();
            newDE.Design_Request_Form__c = drf.Id;
            newDE.Creative_Director_Approvers__c = creativeDirector.Id;
            newDE.Traffic_Administrator_Approver__c = trafficAdmin.Id;
            //newDE.Detailer_Approver__c = detailer.Id;  //Amarab 04062021 SAL-1243 Replacing old Designer/Detailer Approver1 field with new field
            //newDE.Contact_Designer_Detailer_Approver1__c = contact.Id;
            insert newDE;
            System.runAs(trafficAdmin) {
                ApexPages.StandardController sc = new ApexPages.StandardController(newDE);
                GC_DRF_RFP_ApprovalController cont = new GC_DRF_RFP_ApprovalController(sc);
                PageReference pg = cont.setApprover();
                //System.assertEquals(pg , null);
                cont.cancel();
            }
        }
    }
    
    @isTest
    public static void noCDTest() {
        User trafficAdmin = GC_TestUtils.createUser('GC Traffic Administrator', 'trafA3', 'ministrato3');
        GC_Connect2_Show__c show =  GC_TestUtils.getTestConnect2Show();
        GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c(
            User__c = trafficAdmin.Id,
            Connect2_Show__c = show.Id,
            Show_Role__c = 'Traffic Administrator');
        insert stm;
        GC_Design_Request_Form__c drf = new GC_Design_Request_Form__c();
        drf.Connect2_Show__c = show.Id;
        insert drf;
        GC_Design_Element__c newDE = new GC_Design_Element__c();
        newDE.Design_Request_Form__c = drf.Id;
        newDE.Traffic_Administrator_Approver__c = trafficAdmin.Id;
        insert newDE;
        ApexPages.StandardController sc = new ApexPages.StandardController(newDE);
        GC_DRF_RFP_ApprovalController cont = new GC_DRF_RFP_ApprovalController(sc);
        PageReference pg = cont.setApprover();
        System.assertEquals(pg , null);
    }
}