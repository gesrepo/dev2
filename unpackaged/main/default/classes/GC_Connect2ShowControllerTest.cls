@isTest
public class GC_Connect2ShowControllerTest {

    public static testMethod void cloneShowMembersAndAttributes() {
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        show.Job_Number__c = '1';
        update show;

        GC_Connect2_Show__c show2 = new GC_Connect2_Show__c();
        insert show2;

        User accountManager = GC_TestUtils.createUser('GC Account Manager', 'testAcc2', 'testLastAcc2');

        GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c();
        stm.Connect2_Show__c = show.Id;
        stm.User__c = accountManager.Id;
        stm.Show_Role__c = 'Account Manager';
        insert stm;

        GC_Show_Attribute__c sa = new GC_Show_Attribute__c();
        sa.Name_Unique__c = 'Test Attribute';
        sa.Connect2_Show__c = show.Id;
        insert sa;

        ApexPages.StandardController sc = new ApexPages.StandardController(show);
        GC_Connect2ShowController cont = new GC_Connect2ShowController(sc);
        GC_Connect2ShowController.GC_ShowAttributeHolder attHold = new GC_Connect2ShowController.GC_ShowAttributeHolder(sa);
        attHold.selected = true;
        cont.showAttHolders.add(attHold);
        GC_Connect2ShowController.GC_ShowTeamMemberHolder stmHold = new  GC_Connect2ShowController.GC_ShowTeamMemberHolder(stm);
        stmHold.selected = true;
        cont.stmHolders.add(stmHold);
        cont.tempShowAtt.Connect2_Show__c = show2.Id;
        PageReference pr;
        pr = cont.itemsSelected();
        System.assertEquals(pr.getUrl() , '/' + show2.Id);
        cont.doQuery();
        cont.cancel();
    }
}