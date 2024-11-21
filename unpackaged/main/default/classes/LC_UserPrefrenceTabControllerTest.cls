@isTest
public class LC_UserPrefrenceTabControllerTest {

     @isTest
    public static void allTestMethod(){
        
        list<GC_GES_Order_Task__c> gotList = new list<GC_GES_Order_Task__c>();
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        show.Job_Number__c = '00100';
        update show;
        
        GC_Task_Field_Manager__c taskFieldManager = new GC_Task_Field_Manager__c();
        taskFieldManager.Connect2_Show__c = show.Id;
        insert taskFieldManager;
     	
        LC_UserPrefrenceTabController.getFields();
        LC_UserPrefrenceTabController.saveTaskFieldObj(show.Id, taskFieldManager);
        LC_UserPrefrenceTabController.getTaskField(show.Id);
        System.assertEquals(String.Valueof(taskFieldManager.Id), LC_UserPrefrenceTabController.restoreDefaultValues(show.Id));
    }
}