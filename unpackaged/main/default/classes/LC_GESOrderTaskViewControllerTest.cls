@isTest
public class LC_GESOrderTaskViewControllerTest {
    @isTest
    public static void testMethod1(){
        
        User u1 = GC_TestUtils.createUser('GC Account Manager', 'TheManager', 'ofAccounts');
        u1.UserRoleId = [select Id from UserRole where Name = 'System Administrator'].Id;
        update u1;
        
        User u2 = GC_TestUtils.createUser('GC Account Manager', 'Test','AC01');
        u2.GC_Show_Role__c='GC Account Manager; GC Creative Director; GC Traffic Administrator; GC Detailer; GC Director of Account Management; GC Sales Manager; GC Graphics Project Manager; GC Community Client; GC Community Vendor';
        update u2;
        
        System.runAs(u1){
        Test.startTest();
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();

        Map<String, User> users = GC_TestUtils.getUsers();
        User user = users.get('AM');
        User user1 = users.get('GPM');
        
        GC_Order__c order = new GC_Order__c();
        order.Connect2_Show__c = show.Id;
        order.Order_Area_Description__c = 'testing';
        order.Booth_Area__c='Bangalore';
        order.Booth_Area_ID__c = '12345';
        insert order;
        
        GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c();
        stm.Connect2_Show__c = show.Id;
        stm.User__c = user.Id;
        stm.Show_Role__c = 'Account Manager';
        insert stm;
        
        /*Profile profile1 = [SELECT Id FROM Profile WHERE Name= 'GC Account Manager' ];  
        User u1 = new User(Alias = 'standt', IsActive=true, Email='testuser02@testorg.com', 
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = profile1.Id, 
                           //managerId = u1.Id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='testacm@testorg.com.test');
        insert u1;*/
        GC_Show_Team_Member__c stm5 = new GC_Show_Team_Member__c();
        stm5.Connect2_Show__c = show.Id;
        stm5.User__c = u1.Id;
        stm5.Show_Role__c = 'Account Manager';
        //insert stm5;
        
        GC_Show_Team_Member__c stm3 = new GC_Show_Team_Member__c();
        stm3.Connect2_Show__c = show.Id;
        stm3.User__c = user.Id;
        stm3.Show_Role__c = 'Secondary Account Manager';
        insert stm3;
        
        GC_Show_Team_Member__c stm1 = new GC_Show_Team_Member__c();
        stm1.Connect2_Show__c = show.Id;
        stm1.User__c = user1.Id;
        stm1.Show_Role__c = 'Graphics Project Manager';
        insert stm1;
        
        /*Profile profile = [SELECT Id FROM Profile WHERE Name= 'GC Graphics Project Manager' ];    
        User u2 = new User(Alias = 'standt', IsActive=true, Email='testuser02@testorg.com', 
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = profile.Id, 
                           //managerId = u1.Id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='testuser02@testorg.com');
        insert u2;*/
        
        
        GC_Show_Team_Member__c stm2 = new GC_Show_Team_Member__c();
        stm2.Connect2_Show__c = show.Id;
        stm2.User__c = user1.Id;
        stm2.Show_Role__c = 'Graphics Project Manager Direct';
        insert stm2;
        
        GC_Show_Team_Member__c stm4 = new GC_Show_Team_Member__c();
        stm4.Connect2_Show__c = show.Id;
        stm4.User__c = u2.Id;
        stm4.Show_Role__c = 'Graphics Project Manager';
        insert stm4; 

        
        GC_GES_Order_Task__c got = new GC_GES_Order_Task__c();
        got.Order__c = order.Id;
        got.Item_Category_ID__c = '1896';
       // got.Item_Number__c = '300004';
        got.Description__c = 'Test Item Description';
        got.ItemType__c = 'Test Type';
        got.Item_Template__c = 'Basic';
        got.QuantityNum__c = 1;
        got.UOM__c = 'EA';
        got.Status__c = 'New';
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
        got.Budget_Code__c = '12345';
        got.Onsite_Contact_Person_Number_Other__c = '9876543210';
        got.Order_Line_ID__c = '11223344';
        got.AM_Approver_1__c = user.Id;
        got.AM_Approver_2__c = user.Id;
        got.AM_Approver_3__c = user.Id;
        insert got;
        
        GC_GES_Order_Task__c got1 = new GC_GES_Order_Task__c();
        got1.Order__c = order.Id;
        got1.Item_Category_ID__c = '1896';
        got1.Item_Number__c = '300004';
        got1.Description__c = 'Test Item Description';
        got1.Item_Template__c = 'Graphics';
        got1.GOT_Single_Double_Sided__c = 'Double';
        got1.QuantityNum__c = 1;
        got1.Status__c = 'Approved';
        got1.Sign_Title__c = 'test sign';
        got1.Show_Management_Field__c = 'Yes';
        got1.File_Reference_Link__c = 'link';
        got1.Layout__c = 'test layout';
        got1.Sign_Copy__c = 'test copy';
        got1.Installation_Method__c = 'test installation method';
        got1.GOT_Sign_Type__c = 'sign type test';
        got1.GOT_Copy_Placement__c = 'copy placement';
        got1.Save_Signs__c = 'yes';
        got1.GOT_Background__c = 'test background';
        got1.Booth_Area_Discount_Override__c = 10;
        got1.Discount_Reason_Code__c = 'Customer Good Will';
        got1.Discount_Reason_Text__c = 'Test Reason';
        got1.GOT_Sign_Type_Other__c = 'Test Sign Type';
        got1.Budget_Code__c = '12345';
        got1.Onsite_Contact_Person_Number_Other__c = '9876543210';
        got1.Order_Line_ID__c = '11223345';
        insert got1;
		
        Test.stopTest();
            
        LC_GESOrderTaskViewController.getOrderByGOT(got.Id);
        LC_GESOrderTaskViewController.nextOrderTasks(got.Id);
        LC_GESOrderTaskViewController.takeOwnershipOfTask(got.Id);
        LC_GESOrderTaskViewController.toggleGOTHold(got.Id,'1');
        LC_GESOrderTaskViewController.toggleGOTHold(got.Id,'2');

        //LC_GESOrderTaskViewController.submitRecord(got.Id);
        got.Item_Number__c = '300004';
        update got;
        //LC_GESOrderTaskViewController.submitRecord(got.Id);
        System.runAs(user){
            LC_GESOrderTaskViewController.approveTask(got.Id);
        }        
        got.status__c='Submitted';
        update got;

        LC_GESOrderTaskViewController.recallOrderTask(got.Id);
        GC_Core_Session__c testSession = LC_GESOrderTaskViewController.sessionLoad(got.Id);
        LC_GESOrderTaskViewController.validateSessionID(testSession);
        LC_GESOrderTaskViewController.sessionLogin();
        
        got.status__c='Approved';
        got.Is_On_Hold__c  = true;
        update got;
        //Submit
        LC_GESOrderTaskViewController.submitOrderAction(got.Id, testSession.Core_Application_Session_ID__c);
        LC_GESOrderTaskViewController.processOrderAction(got.Id, testSession.Core_Application_Session_ID__c);
        
        got.status__c='Active';
        update got;
        
        got1.status__c='Active';
        update got1;
        //Cancel
        LC_GESOrderTaskViewController.cancelOrderTask(got1.Id);
        LC_GESOrderTaskViewController.cancelOrderAction(got.Id,testSession.Core_Application_Session_ID__c);
        LC_GESOrderTaskViewController.processCancelOrderAction(got.Id,testSession.Core_Application_Session_ID__c);
        
        SET<String> gotIdsLst =  new SET<String>(); 
        gotIdsLst.add(got.Id);
        gotIdsLst.add(got1.Id);
        LC_GESOrderTaskViewController.getCommunityPermissionsMap(gotIdsLst);
        LC_GESOrderTaskViewController.getCommunityPermissions(got.Id);
        LC_GESOrderTaskViewController.getshowTeamMembers(show.Id);
        LC_GESOrderTaskViewController.reworkOrderTask(got.Id);
        LC_GESOrderTaskViewController.getUserPermission();    
        
    }
    }
    
   
    
    @isTest
    public static void testMethod2(){
        
        User u1 = GC_TestUtils.createUser('GC Account Manager', 'TheManager', 'ofAccounts');
        u1.UserRoleId = [select Id from UserRole where Name = 'System Administrator'].Id;
        update u1;
        
        System.runAs(u1){
            
            GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
            
            Map<String, User> users = GC_TestUtils.getUsers();
            User user = users.get('AM');
            
            GC_Order__c order = new GC_Order__c();
            order.Connect2_Show__c = show.Id;
            order.Order_Area_Description__c = 'testing';
            order.Booth_Area__c='Bangalore';
            order.Booth_Area_ID__c = '12345';
            insert order;
            
            GC_GES_Order_Task__c got = new GC_GES_Order_Task__c();
            got.Order__c = order.Id;
            got.Item_Category_ID__c = '1896';
            // got.Item_Number__c = '300004';
            got.Description__c = 'Test Item Description';
            got.ItemType__c = 'Test Type';
            got.Item_Template__c = 'Basic';
            got.QuantityNum__c = 1;
            got.UOM__c = 'EA';
            got.Status__c = 'New';
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
            got.Budget_Code__c = '12345';
            got.Onsite_Contact_Person_Number_Other__c = '9876543210';
            got.Order_Line_ID__c = '11223344';
            got.AM_Approver_1__c = user.Id;
            got.AM_Approver_2__c = user.Id;
            got.AM_Approver_3__c = user.Id;
            insert got;
            
            GC_GES_Order_Task__c got2 = new GC_GES_Order_Task__c();
            got2.Order__c = order.Id;
            got2.Item_Category_ID__c = '1896';
            // got2.Item_Number__c = '300004';
            got2.Description__c = 'Test Item Description';
            got2.ItemType__c = 'Test Type';
            got2.Item_Template__c = 'Basic';
            got2.QuantityNum__c = 1;
            got2.UOM__c = 'EA';
            got2.Status__c = 'Submitted';
            got2.Show_Management_Field__c = 'Yes';
            got2.File_Reference_Link__c = 'link';
            got2.Completion_Date_Time__c = DateTime.Now();
            got2.Removal_Date_Time__c = DateTime.Now();
            got2.Delivery_Date_Time__c = DateTime.Now();
            got2.Price__c = '11.59';
            got2.New_Price__c = 12;
            got2.Description__c = 'test Desciption';
            got2.Invoice_Remarks__c = 'test remarks';
            got2.Production_Remarks__c = 'test remarks';
            got2.Item_Type_Remarks__c = 'test remarks';
            got2.Show_Site_Remarks__c = 'test show site remarks';
            got2.Budget_Code__c = '12345';
            got2.Onsite_Contact_Person_Number_Other__c = '9876543210';
            got2.Order_Line_ID__c = '11223344';
            got2.AM_Approver_1__c = user.Id;
            got2.AM_Approver_2__c = user.Id;
            got2.AM_Approver_3__c = user.Id;
            insert got2;

            
            LC_GESOrderTaskViewController.approveItem(got.Id);
            LC_GESOrderTaskViewController.approveItem(got2.Id);
        }
    }
    
    @isTest
    public static void testMethod3(){
        
        Map<String, User> portalUsers = GC_TestUtils.getPortalUsers();
        User clientUser = portalUsers.get('GC Community Client');
        User vendor = portalUsers.get('GC Community Vendor');
        
        system.runAs(vendor){
            GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
            
            Map<String, User> users = GC_TestUtils.getUsers();
            User user = users.get('AM');
            
            GC_Order__c order = new GC_Order__c();
            order.Connect2_Show__c = show.Id;
            order.Order_Area_Description__c = 'testing';
            order.Booth_Area__c='Bangalore';
            order.Booth_Area_ID__c = '12345';
            insert order;
            
            GC_GES_Order_Task__c got = new GC_GES_Order_Task__c();
            got.Order__c = order.Id;
            got.Item_Category_ID__c = '1896';
            // got.Item_Number__c = '300004';
            got.Description__c = 'Test Item Description';
            got.ItemType__c = 'Test Type';
            got.Item_Template__c = 'Basic';
            got.QuantityNum__c = 1;
            got.UOM__c = 'EA';
            got.Status__c = 'New';
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
            got.Budget_Code__c = '12345';
            got.Onsite_Contact_Person_Number_Other__c = '9876543210';
            got.Order_Line_ID__c = '11223344';
            got.AM_Approver_1__c = user.Id;
            got.AM_Approver_2__c = user.Id;
            got.AM_Approver_3__c = user.Id;
            insert got;
            LC_GESOrderTaskViewController.getCommunityPermissions(got, true);
        }
    }
    
    @isTest
    public static void testMethod4(){
        
        Map<String, User> portalUsers = GC_TestUtils.getPortalUsers();
        User clientUser = portalUsers.get('GC Community Client');
        User vendor = portalUsers.get('GC Community Vendor');
        
        system.runAs(clientUser){
            GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
            
            Map<String, User> users = GC_TestUtils.getUsers();
            User user = users.get('AM');
            
            GC_Show_Team_Member__c stm3 = new GC_Show_Team_Member__c();
            stm3.Connect2_Show__c = show.Id;
            stm3.User__c = clientUser.Id;
            stm3.Show_Role__c = 'Show Organizer - Read Only';
            insert stm3;
            
            
            GC_Show_Team_Member__c stm2 = new GC_Show_Team_Member__c();
            stm2.Connect2_Show__c = show.Id;
            stm2.User__c = clientUser.Id;
            stm2.Show_Role__c = 'Test';
            insert stm2;
            
            GC_Order__c order = new GC_Order__c();
            order.Connect2_Show__c = show.Id;
            order.Order_Area_Description__c = 'testing';
            order.Booth_Area__c='Bangalore';
            order.Booth_Area_ID__c = '12345';
            insert order;
            
            GC_GES_Order_Task__c got = new GC_GES_Order_Task__c();
            got.Order__c = order.Id;
            got.Item_Category_ID__c = '1896';
            // got.Item_Number__c = '300004';
            got.Description__c = 'Test Item Description';
            got.ItemType__c = 'Test Type';
            got.Item_Template__c = 'Basic';
            got.QuantityNum__c = 1;
            got.UOM__c = 'EA';
            got.Status__c = 'New';
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
            got.Budget_Code__c = '12345';
            got.Onsite_Contact_Person_Number_Other__c = '9876543210';
            got.Order_Line_ID__c = '11223344';
            got.AM_Approver_1__c = user.Id;
            got.AM_Approver_2__c = user.Id;
            got.AM_Approver_3__c = user.Id;
            insert got;
            LC_GESOrderTaskViewController.getCommunityPermissions(got, true);
        }
    }
}