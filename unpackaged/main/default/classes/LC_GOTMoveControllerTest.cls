@isTest
public class LC_GOTMoveControllerTest {

    @isTest
    public static void testMethod1(){
        Map<String, User> users = GC_TestUtils.getUsers();
        User user1 = users.get('DAM');
        
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        
        GC_Order__c order = new GC_Order__c();
        order.Connect2_Show__c = show.Id;
        order.Order_Area_Description__c = 'testing';
        order.Booth_Area__c='Bangalore';
        insert order;
        
        GC_Order__c order1 = new GC_Order__c();
        order1.Connect2_Show__c = show.Id;
        order1.Order_Area_Description__c = 'testing';
        order1.Booth_Area__c='Bangalore';
        insert order1;
        
        GC_GES_Order_Task__c got = new GC_GES_Order_Task__c();
        got.Order__c = order.Id;
        got.Delivery_Location__c = 'testing';
        insert got;
        
        GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c();
        stm.Connect2_Show__c = order.Connect2_Show__c;
        stm.User__c = user1.Id;
        stm.Show_Role__c = 'Director of Account Management';
        insert stm;
        
        List<String> taskIds= new List<String>();
        taskIds.add(got.Id);
        System.runAs(user1) {
            Test.startTest(); 
            LC_GOTMoveController.getOpenShows();
            LC_GOTMoveController.getExistingOrdersForShowByOrderId(order.Id);
            LC_GOTMoveController.getExistingOrdersForShow(show.Id,order.Id);
            LC_GOTMoveController.cloneGESOrderTasks(show.Id, order.Id, taskIds);
            
            LC_GOTMoveController.getAvailableOrderTasksForOrder(order.Id, 'Move');  // clone
            LC_GOTMoveController.getAvailableOrderTasksForOrder(order.Id, 'Clone');
            LC_GOTMoveController.moveGESOrderTasks(String.valueOf(order.Id), taskIds);            
            Test.stopTest();
        }
    }
}