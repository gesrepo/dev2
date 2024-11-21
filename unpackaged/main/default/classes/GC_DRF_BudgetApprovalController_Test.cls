/**
* @author Ethos Solutions - www.ethos.com
* @description Test code for Design Request Form budget approval controller
* 2016-04-13 : Original Version
**/
@isTest
public class GC_DRF_BudgetApprovalController_Test {
    @isTest
    public static void GC_BudgetApprovalTests() {
        GC_Connect2_Show__c show =  GC_TestUtils.getTestConnect2Show();
        User director = GC_TestUtils.createUser('GC Director of Account Management', 'director', 'danny');
        GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c(
            User__c = director.Id,
            Connect2_Show__c = show.Id,
            Show_Role__c = 'Director of Account Management');
        insert stm;
        GC_Show_Team_Member__c stmInfo = [select Id, User__c from GC_Show_Team_Member__c where Id = :stm.Id];
        GC_Design_Request_Form__c drf = new GC_Design_Request_Form__c();
        drf.Connect2_Show__c = show.Id;
        insert drf;
        GC_Design_Request_Form_Budget__c newDRFB = new GC_Design_Request_Form_Budget__c();
        newDRFB.Design_Request_Form__c = drf.Id;
        newDRFB.Next_ApproverSTM__c = stmInfo.Id;
        insert newDRFB;

        Test.startTest();

        ApexPages.StandardController sc = new ApexPages.StandardController(newDRFB);
        GC_DRF_BudgetApprovalController cont = new GC_DRF_BudgetApprovalController(sc);

        cont.loadAction();

        System.assertEquals(cont.canSubmit, true);
        System.assertEquals(cont.getCanSubmitForApproval(), true);
        cont.getUserName();

        PageReference pg = cont.setApprover();
        System.assertNotEquals(null, pg);

        System.assertEquals(GC_ApprovalUtils.isUnderApproval(newDRFB.Id), true);

        pg.setRedirect(true);
        cont.cancel();
        cont.cancelSubmitForApproval();

        cont.approverChanged();
        System.assertEquals(cont.approverName != null, true);



        Test.stopTest();
    }

    @isTest
    public static void GC_BudgetApprovalErrorConditions() {
        GC_Connect2_Show__c show =  GC_TestUtils.getTestConnect2Show();
        User director = GC_TestUtils.createUser('GC Director of Account Management', 'director', 'danny');
        GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c(
            User__c = director.Id,
            Connect2_Show__c = show.Id,
            Show_Role__c = 'Director of Account Management');
        insert stm;
        GC_Show_Team_Member__c stmInfo = [select Id, User__c from GC_Show_Team_Member__c where Id = :stm.Id];
        GC_Design_Request_Form__c drf = new GC_Design_Request_Form__c();
        drf.Connect2_Show__c = show.Id;
        insert drf;
        GC_Design_Request_Form_Budget__c newDRFB = new GC_Design_Request_Form_Budget__c();
        newDRFB.Design_Request_Form__c = drf.Id;
        newDRFB.Next_ApproverSTM__c = stmInfo.Id;
        insert newDRFB;

        Test.startTest();

        ApexPages.StandardController sc = new ApexPages.StandardController(newDRFB);
        GC_DRF_BudgetApprovalController cont = new GC_DRF_BudgetApprovalController(sc);

        newDRFB.Status__c = 'Not New';
        update newDRFB;
        cont.drfB = [select Id, Name, Next_ApproverSTM__c, Status__c, Design_Request_Form__r.Connect2_Show__c, Design_Request_Form__c, OwnerId from GC_Design_Request_Form_Budget__c where Id = :newDRFB.id];

        cont.loadAction();
        System.assertEquals(cont.canSubmit, false);

        newDRFB.Status__c = 'New';
        update newDRFB;
        cont.drfB = [select Id, Name, Next_ApproverSTM__c, Status__c, Design_Request_Form__r.Connect2_Show__c, Design_Request_Form__c, OwnerId from GC_Design_Request_Form_Budget__c where Id = :newDRFB.id];

        delete stm;
        cont.loadAction();
        System.assertEquals(cont.canSubmit, false);

        // TODO need to test budget owner
        Test.stopTest();
    }
}