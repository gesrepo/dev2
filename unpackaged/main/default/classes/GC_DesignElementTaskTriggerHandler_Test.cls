/**
* @author Ethos Solutions - www.ethos.com
* @description Test code for Design Element Task trigger handler
* 2016-04-13 : Original Version
**/
@isTest
private class GC_DesignElementTaskTriggerHandler_Test {
    
    @isTest
    public static void testClearRevisionInfo() {
        GC_Connect2_Show__c show =  GC_TestUtils.getTestConnect2Show();
        //GC_Design_Request_Form__c drf = GC_TestUtils.getTestDRF(show.Id);
        GC_Design_Element__c newDE = GC_TestUtils.getTestDesignElement(show.Id);
        
        GC_Design_Element__c clone = newDE.clone(false, true, false, true);
        clone.Revision__c = newDE.Revision__c++;
        clone.Previous_Revision__c = newDE.Id;
        clone.OwnerId = UserInfo.getUserId();
        
        insert clone;
        
        // Check that revision number and previous revision lookup were cleared on insert since it wasn't a revision
        GC_Design_Element__c det = GC_DesignElementDao.getInstance().getDesignElementById(clone.Id);
        System.assertEquals(1, det.Revision__c);
        System.assertEquals(null, det.Previous_Revision__c);
    }
    
    @isTest
    public static void testUpdateCreativeDirectorTeamAssignment() {
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        
        System.runAs ( thisUser ) {
            GC_Connect2_Show__c show =  GC_TestUtils.getTestConnect2Show();
            //GC_Design_Request_Form__c drf = GC_TestUtils.getTestDRF(show.Id);
            GC_Design_Element__c newDE = GC_TestUtils.getTestDesignElement(show.Id);
            Account account = GC_TestUtils.getAccount();
            Contact contact = GC_TestUtils.getContact('firstname', 'lastname', account);
            Map<String, User> userMap = GC_TestUtils.getUsers();
            User creative = GC_TestUtils.createUser('GC Creative Director', 'creative', 'director');
            User u1 = GC_TestUtils.createUser('GC Account Manager', 'TheManager', 'ofAccounts');
            u1.UserRoleId = [select Id from UserRole where Name = 'System Administrator'].Id;
            update u1;
            
            newDE.Creative_Director_Approvers__c = creative.Id;
            newDE.Traffic_Administrator_Approver__c = userMap.get('TA').Id;
            //newDE.Detailer_Approver__c = userMap.get('DET').Id;  //Amarab 04062021 SAL-1243 Replacing old Designer/Detailer Approver1 field with new field
            newDE.Contact_Designer_Detailer_Approver1__c = contact.Id;
            newDE.Detailer_Approver2__c = userMap.get('DET2').Id;
            newDE.Detailer_Approver3__c = userMap.get('DET3').Id;
            newDE.Detailer_Approver4__c = userMap.get('DET4').Id;
            newDE.Detailer_Approver5__c = userMap.get('DET5').Id;
            
            Set<Id> detailerIds = new Set<Id> {
                    contact.Id,
                    userMap.get('DET2').Id,
                    userMap.get('DET3').Id,
                    userMap.get('DET4').Id,
                    userMap.get('DET5').Id
                    };
                        update newDE;
            
            List<GC_Show_Team_Member__c> list_stm = new List<GC_Show_Team_Member__c>();
            List<GC_Show_Team_Assignment__c> list_stAssignment = new List<GC_Show_Team_Assignment__c>(); 
            GC_Show_Team_Member__c stm1 = new GC_Show_Team_Member__c(
                User__c = creative.Id,
                Connect2_Show__c = show.Id,
                Show_Role__c = 'Detailer');
            GC_Show_Team_Member__c stm2 = new GC_Show_Team_Member__c(
                User__c = u1.Id,
                Connect2_Show__c = show.Id,
                Show_Role__c = 'Account Manager');
            GC_Show_Team_Member__c stm3 = new GC_Show_Team_Member__c(
                User__c = creative.Id,
                Connect2_Show__c = show.Id,
                Show_Role__c = 'Sales Manager');
            list_stm.add(stm1);
            list_stm.add(stm2);
            //list_stm.add(stm3);
            insert list_stm;            
            GC_Show_Team_Assignment__c stAssignment1 = new GC_Show_Team_Assignment__c(
                Design_Element__c = newDE.Id,
                Show_Team_Member__c = stm1.Id);
            GC_Show_Team_Assignment__c stAssignment2 = new GC_Show_Team_Assignment__c(
                Design_Element__c = newDE.Id,
                Show_Team_Member__c = stm2.Id);
            GC_Show_Team_Assignment__c stAssignment3 = new GC_Show_Team_Assignment__c(
                Design_Element__c = newDE.Id,
                Show_Team_Member__c = stm3.Id);
            list_stAssignment.add(stAssignment1);
            list_stAssignment.add(stAssignment2);
            //list_stAssignment.add(stAssignment3);
            insert list_stAssignment;
            test.startTest();
            GC_DesignElementTaskTriggerHandler.UpdateShowTeamAssignmentsAccess(new List<GC_Design_Element__c>{newDE});
            GC_DesignElementTaskTriggerHandler.SetAccountManager(new List<GC_Design_Element__c>{newDE});
            
            //GC_DesignElementTaskTriggerHandler.getDetailerIds(newDE);
            newDE.Creative_Director_Approvers__c = null;
            newDE.Traffic_Administrator_Approver__c = null;
            //newDE.Detailer_Approver__c = null;   //Amarab 04062021 SAL-1243 Replacing old Designer/Detailer Approver1 field with new field
            newDE.Contact_Designer_Detailer_Approver1__c  = null;
            newDE.Detailer_Approver2__c = null;
            newDE.Detailer_Approver3__c = null;
            newDE.Detailer_Approver4__c = null;
            newDE.Detailer_Approver5__c = null;
            update newDE;
            test.stopTest();

        }
    }
    
     @isTest
    public static void testupdateApproverFields() {
        Test.startTest();
        GC_Connect2_Show__c show =  GC_TestUtils.getTestConnect2Show();
        GC_Design_Element__c newDE = GC_TestUtils.getTestDesignElement(show.Id);
        GC_DesignElementTaskTriggerHandler.updateApproverFields(new List<GC_Design_Element__c>{newDE});
        Test.stopTest();
    }
}