/**
* @author Ethos Solutions - www.ethos.com
* @description Test code for revise Design Element controller
* 2016-04-13 : Original Version
**/
@isTest
private class GC_ReviseDesignElement_Controller_Test {
    
    @isTest
    public static void testCreateRevision() {
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        
        System.runAs ( thisUser ) {
            User accountManager = GC_TestUtils.createUser('GC Account Manager', 'testAcc2', 'testLastAcc2');
            User ta = GC_TestUtils.createUser('GC Traffic Administrator', 'ta', 'testta');
            User cd = GC_TestUtils.createUser('GC Creative Director', 'cd', 'testcd');
            User designer = GC_TestUtils.createUser('GC detailer', 'testDet1', 'testLastDet1');
            Account account = GC_TestUtils.getAccount();
            Contact contact = GC_TestUtils.getContact('firstname', 'lastname', account);
            
            ApexPages.StandardController sc;
            
            System.runAs(accountManager) {
                GC_Connect2_Show__c show =  GC_TestUtils.getTestConnect2Show();
                GC_Design_Request_Form__c drf = GC_TestUtils.getTestDRF(show.Id);
                GC_Design_Element__c newDE = GC_TestUtils.getTestDesignElement(drf.Id);
                newDE.Traffic_Administrator_Approver__c = ta.Id;
                newDE.Creative_Director_Approvers__c = cd.Id;
                //newDE.Detailer_Approver__c = designer.Id;  //Amarab 04062021 SAL-1243 Replacing old Designer/Detailer Approver1 field with new field
                newDE.Contact_Designer_Detailer_Approver1__c = contact.Id;
                update newDE;
                sc = new ApexPages.StandardController(newDE);
                
            }
            System.runAs(accountManager) {
                
            }
            //    PageReference pg;
            //    Test.startTest();
            //    ApexPages.StandardController sc = new ApexPages.StandardController(newDE);
            //    GC_ReviseDesignElement_Controller cont = new GC_ReviseDesignElement_Controller(sc);
            //    //System.runAs(designer) {
            //    //    pg = cont.createRevision();
            //    //    System.assertEquals(null, pg);
            //    //}
            //    GC_Design_Element__c de = cont.getDesignElement();
            //    System.assertNotEquals(null, de);
            //    System.assertEquals(newDE.Id, de.Id);
            //    pg = cont.createRevision();
            //    System.assertNotEquals(null, pg);
            //    GC_Design_Element__c rev = cont.revision;
            //    System.assertEquals(1, rev.Revision__c);
            //    System.assertEquals(de.Id, rev.Previous_Revision__c);
            //    // Check that trying to revise the same DE again doesn't work since its now inactive
            //    pg = cont.createRevision();
            //    System.assertEquals(null, pg);
            //    Test.stopTest();
            //}
        }
    }
}