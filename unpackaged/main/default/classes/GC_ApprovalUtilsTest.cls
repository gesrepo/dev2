@isTest
public class GC_ApprovalUtilsTest
{   
     @isTest static void testMethod1() 
    {
        Map<String, User> portalUsers = GC_TestUtils.getPortalUsers();
        //Map<String, User> classicUsers = GC_TestUtils.getUsers();
        List<GC_Show_Team_Member__c> lstSTM = new List<GC_Show_Team_Member__c>();
        User clientUser = portalUsers.get('GC Community Client');
        User vendor = portalUsers.get('GC Community Vendor');
        User accountManger = portalUsers.get('GC Account Manager');
        User gpManger = portalUsers.get('GC Graphics Project Manager');
        User gpManagerDirect = portalUsers.get('GC Graphics Project Manager');
        GC_Connect2_Show__c show;
        Test.starttest();
        GC_GES_Order_Task__c orderTask = GC_TestUtils.setupOrderAndTask();
        GC_Order__c order = GC_OrderDao.getInstance().getOrderById(orderTask.Order__c);

        GC_Show_Team_Member__c clientMember = new GC_Show_Team_Member__c(
            Connect2_Show__c = order.Connect2_Show__c,
            User__c = clientUser.Id,
            Show_Role__c = 'Show Organizer');
        lstSTM.add(clientMember);    
        //insert clientMember;
        
        /*GC_Show_Team_Member__c clientMember2 = new GC_Show_Team_Member__c(
            Connect2_Show__c = order.Connect2_Show__c,
            User__c = accountManger.Id,
            Show_Role__c = 'Account Manager');
        lstSTM.add(clientMember2);
        //insert clientMember2;*/
         
        
        //GC_Show_Team_Member__c clientMember1 = new GC_Show_Team_Member__c(
        //    Connect2_Show__c = order.Connect2_Show__c,
        //    User__c = vendor.Id,
        //    Show_Role__c = 'Vendor');
        //lstSTM.add(clientMember1);
        //insert clientMember1;
        gpManger= GC_TestUtils.createUser('GC Graphics Project Manager', 'unit_test', 'graphics_manager2');
        GC_Show_Team_Member__c clientMember3 = new GC_Show_Team_Member__c(
            Connect2_Show__c = order.Connect2_Show__c,
            User__c = gpManger.Id,
            Show_Role__c = 'Graphics Project Manager');
        lstSTM.add(clientMember3);
        //insert clientMember3;
        
        /*GC_Show_Team_Member__c clientMember4 = new GC_Show_Team_Member__c(
            Connect2_Show__c = order.Connect2_Show__c,
            User__c = gpManagerDirect.Id,
            Show_Role__c = 'Graphics Project Manager Direct');
        lstSTM.add(clientMember4);  */
        //insert clientMember4;
        
        insert lstSTM;
       User am2 = GC_TestUtils.createUser('GC Account Manager', 'unit_test', 'account_manager2');
        GC_Show_Team_Member__c stmAm2 = new GC_Show_Team_Member__c();
            stmAm2.Connect2_Show__c = order.Connect2_Show__c;
            stmAm2.User__c = am2.Id;
            stmAm2.Show_Role__c = 'Account Manager';
            insert stmAm2;  
        
        orderTask.Item_Category__c = 'Graphics';
        update orderTask;
        Test.stoptest();
        
        GC_OrderViewController cont = new GC_OrderViewController();
        cont.currentOrder = order;
        cont.currenttTaskId = orderTask.Id;
        cont.gesOrderTasks = new List<GC_OrderViewController.GesTaskWrapper>();
        cont.vendorOrderTasks = new List<GC_OrderViewController.VendorTaskWrapper>();
        cont.taskPermissions = new Map<String, GC_OrderUtils.TaskPermissions>();
        cont.GesOrderMapping  = new Map<String, GC_GES_Order_Task__c>();
        cont.GesOrderMappingByName = new Map<String, GC_GES_Order_Task__c>();
        cont.emailDefaultList = 'test1@test.com,test2@test.com,';
        cont.sendEmail();
        
        //GC_ApprovalUtils.submitForApproval(orderTask);
        GC_ApprovalUtils.updateTaskApprovers(orderTask,order.Connect2_Show__c,null,null,null);
        //GC_ApprovalUtils.submitTaskForApproval1(orderTask,true);
        GC_ApprovalUtils.approveTask(orderTask);
        List<GC_GES_Order_Task__c> lst = new List<GC_GES_Order_Task__c>();
        lst.add(orderTask);
        GC_ApprovalUtils.approveTasks(lst);
        GC_ApprovalUtils.submitForGPMApproval(orderTask, 'GES_Order_Approval_Process');
              
    }
     @isTest Private static void testMethod2() 
     {
        GC_GES_Order_Task__c orderTask = GC_TestUtils.setupOrderAndTask();
        GC_Order__c order = GC_OrderDao.getInstance().getOrderById(orderTask.Order__c);
        GC_GES_Order_Task__c got = new GC_GES_Order_Task__c();
        got.Order__c = order.Id;
        got.Item_Category_ID__c = '1896';
        got.Description__c = 'Test Item Description';
        got.Item_Number__c = '300004';
        got.Item_Template__c = 'Basic';
        got.QuantityNum__c = 1;
        got.Status__c = 'New';
        got.Show_Management_Field__c = 'Yes';
        got.File_Reference_Link__c = 'link';
        got.Order_Line_ID__c = '123';
        insert got;
       
       
     }
}