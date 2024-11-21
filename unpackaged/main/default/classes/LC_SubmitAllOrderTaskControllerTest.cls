@isTest
public class LC_SubmitAllOrderTaskControllerTest {
    
    @isTest
    public static void allTestMethod(){
        
        list<GC_GES_Order_Task__c> gotList = new list<GC_GES_Order_Task__c>();
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        show.Job_Number__c = '00100';
        update show;
        
        GC_Order__c order = GC_TestUtils.getTestOrder();
        order.Connect2_Show__c = show.Id;
        upsert order;
        
        Map<String, User> userMap = GC_TestUtils.getUsers();
        User user1 = userMap.get('AM');
        
        list<GC_Show_Team_Member__c> showTeamsList = new list<GC_Show_Team_Member__c>();
        
        
        GC_Show_Team_Member__c teamMember = new GC_Show_Team_Member__c(Connect2_Show__c = order.Connect2_Show__c, 
                                                                       Show_Role__c = 'Account Manager',
                                                                       User__c = user1.Id);
        showTeamsList.add(teamMember);
        insert teamMember;
        
        GC_GES_Order_Task__c got = new GC_GES_Order_Task__c();
        got.Order__c = order.Id;
        got.Item_Category_ID__c = '1896';
        got.Item_Number__c = '300004';
        got.Description__c = 'Test Item Description';
        got.Item_Template__c = 'Basic';
        got.QuantityNum__c = 1;
        got.UOM__c = 'EA';
        got.Status__c = 'Approved';
        got.Show_Management_Field__c = 'Yes';
        got.File_Reference_Link__c = 'link';
        got.Completion_Date_Time__c = DateTime.Now();
        got.Removal_Date_Time__c = DateTime.Now();
        got.Delivery_Date_Time__c = DateTime.Now();
        got.Price__c = '11.59';
        got.New_Price__c = 12;
        got.Description__c = 'test Desciption';
        got.Invoice_Remarks__c = 'test remarks';
        got.Production_Remarks__c = 'test remarks';
        got.Item_Type_Remarks__c = 'test remarks';
        got.Show_Site_Remarks__c = 'test show site remarks';
        got.Discount_Reason_Text__c ='test';
        got.Booth_Area_Discount_Override__c=12;
        got.Budget_Code__c ='test'; 
        insert got;
        gotList.add(got);
        
        Id votId;
        GC_Vendor_Order_Task__c vot = GC_TestUtils.getTestVendorTask(order.id,votId);
        vot.Vendor__c= UserInfo.getUserId();
        vot.Vendor2__c= UserInfo.getUserId();
        vot.Vendor3__c= UserInfo.getUserId();
        vot.Vendor4__c= UserInfo.getUserId();
        vot.Vendor5__c= UserInfo.getUserId();
        update vot;
        
        LC_SubmitAllOrderTaskController.getAllGot(order.id);
        LC_SubmitAllOrderTaskController.getAllVot(order.id);
        LC_SubmitAllOrderTaskController.getAllApprovers(order.id);
        LC_SubmitAllOrderTaskController.submitAllTasks(order.id, showTeamsList, LC_SubmitAllOrderTaskController.getAllGot(order.id), LC_SubmitAllOrderTaskController.getAllVot(order.id));
        LC_SubmitAllOrderTaskController.getShow(show.id);
        LC_SubmitAllOrderTaskController.submitForApproval(show.id,gotList);
       
        vot.Status__c='Sent';
        update vot;
        LC_SubmitAllOrderTaskController.submitAllTasks(order.id, showTeamsList, LC_SubmitAllOrderTaskController.getAllGot(order.id), LC_SubmitAllOrderTaskController.getAllVot(order.id));
        
    }
    
}