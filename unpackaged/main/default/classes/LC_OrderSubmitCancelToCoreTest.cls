@isTest
public class LC_OrderSubmitCancelToCoreTest {
    
    @isTest
    public static void testAllMethods(){
        
        list<GC_GES_Order_Task__c> gotList = new list<GC_GES_Order_Task__c>();
        list<GC_GES_Order_Task__c> gotList1 = new list<GC_GES_Order_Task__c>();
        
        
        User accountMgr = GC_TestUtils.createUser('GC Account Manager', 'Test','AC01');
        accountMgr.GC_Show_Role__c='GC Account Manager; GC Creative Director; GC Traffic Administrator; GC Detailer; GC Director of Account Management; GC Sales Manager; GC Graphics Project Manager; GC Community Client; GC Community Vendor';
        update accountMgr;
        
        System.runAs(accountMgr){
            GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
            show.Job_Number__c = '1';
            update show;
            GC_Show_Attribute__c sa = new GC_Show_Attribute__c();
            sa.Name_Unique__c = 'Test Attribute';
            sa.Connect2_Show__c = show.Id;
            sa.RecordTypeId = GC_TestUtils.getRecordType('GC_Show_Attribute__c').get('Venue Location').Id;
            sa.Name = 'Test Venue';
            insert sa;
            
            GC_Show_Attribute__c sa2 = new GC_Show_Attribute__c();
            sa2.Connect2_Show__c = show.Id;
            sa2.RecordTypeId = GC_TestUtils.getRecordType('GC_Show_Attribute__c').get('Material').Id;
            sa2.Name = 'Test Material';
            insert sa2;
            
            
            GC_Order__c order1 = new GC_Order__c();
            order1.Connect2_Show__c = show.Id;
            order1.Booth_Area__c  = 'Area';
            order1.Booth_Area_ID__c = '1390259';
            insert order1;
            
            GC_Order__c order = new GC_Order__c();
            order.Connect2_Show__c = show.Id;
            order.Booth_Area__c  = 'Area';
            order.Booth_Area_ID__c = '1390259';
            insert order;
            
            Account account = GC_TestUtils.getAccount();
            Contact contact = GC_TestUtils.getContact('firstname', 'lastname', account);
            
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
            got.SA_Venue_Location__c = sa.Id;
            got.Description__c = 'test Desciption';
            got.Invoice_Remarks__c = 'test remarks';
            got.Production_Remarks__c = 'test remarks';
            got.Item_Type_Remarks__c = 'test remarks';
            got.Show_Site_Remarks__c = 'test show site remarks';
            got.Budget_Code__c = '12345';
            got.Onsite_Contact_Person_Number_Other__c = '9876543210';
            got.Order_Line_ID__c = '11223344';
            
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
            got1.Special_Instructions_Client_Remarks__c = 'Test Instructions'; //Show_Management_Field__c
            got1.File_Reference_Link__c = 'link';
            got1.Client_Layout_Notes__c = 'test layout';  //Layout__c
            got1.Sign_Copy_Plain__c = 'test copy';  //Sign_Copy__c
            got1.Installation_Method__c = 'test installation method';
            got1.GOT_Sign_Type__c = 'sign type test';
            got1.GOT_Copy_Placement__c = 'copy placement';
            got1.Material__c = sa2.Id;
            got1.Save_Signs__c = 'yes';
            got1.GOT_Background__c = 'test background';
            got1.Booth_Area_Discount_Override__c = 10;
            got1.Discount_Reason_Code__c = 'Customer Good Will';
            got1.Discount_Reason_Text__c = 'Test Reason';
            //got1.GOT_Sign_Type_Other__c = 'Test Sign Type';
            got1.Budget_Code__c = '12345';
            got1.Onsite_Contact__c = contact.Id;
            got1.Onsite_Contact_Person_Other__c = 'Test Contact Person';
            got1.Onsite_Contact_Person_Number_Other__c = '9876543210';
            got1.Order_Line_ID__c = '11223345';
            
            
            GC_GES_Order_Task__c got2 = new GC_GES_Order_Task__c();
            got2.Order__c = order.Id;
            got2.Item_Category_ID__c = '1896';
            got2.Item_Number__c = '300004';
            got2.Description__c = 'Test Item Description';
            got2.Item_Template__c = 'Custom Graphics';
            got2.GOT_Single_Double_Sided__c = 'Single';
            got2.Sign_Length__c = 20;
            got2.Sign_Width__c = 15;
            got2.QuantityNum__c = 1;
            got2.Status__c = 'Approved';
            got2.Show_Management_Field__c = 'Yes';
            got2.File_Reference_Link__c = 'link';
            got2.Sign_Title__c = 'test sign';
            got2.Show_Management_Field__c = 'Yes';
            got2.File_Reference_Link__c = 'link';
            got2.Layout__c = 'test layout';
            got2.Sign_Copy__c = 'test copy';
            got2.Installation_Method__c = 'test installation method';
            got2.GOT_Sign_Type__c = 'sign type test';
            got2.GOT_Copy_Placement__c = 'copy placement';
            got2.Material__c = sa2.Id;
            got2.Save_Signs__c = 'yes';
            got2.GOT_Background__c = 'test background';
            //got2.GOT_Sign_Type_Other__c = 'Test Sign Type';
            got2.Budget_Code__c = '12345';
            got2.Onsite_Contact__c = contact.Id;
            got2.Onsite_Contact_Person_Other__c = 'Test Contact Person';
            got2.Onsite_Contact_Person_Number_Other__c = '9876543210';
            got2.Order_Line_ID__c = '11223346';
            
            GC_GES_Order_Task__c got3 = new GC_GES_Order_Task__c();
            got3.Order__c = order.Id;
            got3.Item_Category_ID__c = '1896';
            got3.Item_Number__c = '300004';
            got3.Description__c = 'Test Item Description';
            got3.Item_Template__c = 'GEM Structures';
            got3.Electrical_Ordered__c = false;
            got3.Electrical_Under__c = false;
            got3.UOM__c = 'EA';
            got3.QuantityNum__c = 1;
            got3.Status__c = 'Approved';
            got3.Show_Management_Field__c = 'Yes';
            got3.File_Reference_Link__c = 'link';
            got3.GOT_Sign_Type_Other__c = 'Test Sign Type';
            got3.Budget_Code__c = '12345';
            got3.Onsite_Contact_Person_Number_Other__c = '9876543210';
            got3.Order_Line_ID__c = '11223347';
            
            GC_GES_Order_Task__c got4 = new GC_GES_Order_Task__c();
            got4.Order__c = order.Id;
            got4.Item_Category_ID__c = '1896';
            got4.Item_Number__c = '300004';
            got4.Description__c = 'Test Item Description';
            got4.Item_Template__c = 'Custom Carpet';
            got4.Electrical_Ordered__c = true;
            got4.Electrical_Under__c = true;
            got4.UOM__c = 'SF';
            got4.Carpet_Length__c = 10;
            got4.Carpet_Width__c = 10;
            got4.QuantityNum__c = 200;
            got4.Status__c = 'Approved';
            got4.Show_Management_Field__c = 'Yes';
            got4.File_Reference_Link__c = 'link';
            got4.Booth_Area_Discount_Override__c = 10;
            got4.Discount_Reason_Code__c = 'Customer Good Will';
            got4.Discount_Reason_Text__c = 'Test Reason';
            got4.GOT_Sign_Type_Other__c = 'Test Sign Type';
            got4.Budget_Code__c = '12345';
            got4.Onsite_Contact_Person_Number_Other__c = '9876543210';
            got4.Order_Line_ID__c = '11223348';
            
            GC_GES_Order_Task__c got6 = new GC_GES_Order_Task__c();
            got6.Order__c = order.Id;
            got6.Item_Category_ID__c = '1896';
            got6.Item_Number__c = '300004';
            got6.Description__c = 'Test Item Description';
            got6.Item_Template__c = 'GEM Structures';
            got6.Electrical_Ordered__c = true;
            got6.Electrical_Under__c = true;
            got6.UOM__c = 'SF';
            got6.Carpet_Length__c = 10;
            got6.Carpet_Width__c = 10;
            got6.QuantityNum__c = 20;
            got6.Status__c = 'Canceled';
            got6.Show_Management_Field__c = 'Yes';
            got6.File_Reference_Link__c = 'link';
            got6.Order_Line_ID__c = '123456';
            got6.Core_Cancelled__c = false;
            got6.Booth_Area_Discount_Override__c = 10;
            got6.Discount_Reason_Code__c = 'Customer Good Will';
            got6.Discount_Reason_Text__c = 'Test Reason';
            got6.GOT_Sign_Type_Other__c = 'Test Sign Type';
            got6.Budget_Code__c = '12345';
            got6.Onsite_Contact_Person_Number_Other__c = '9876543210';
            got6.Order_Line_ID__c = '11223349';
            
            GC_GES_Order_Task__c got7 = new GC_GES_Order_Task__c();
            got7.Order__c = order.Id;
            got7.Item_Category_ID__c = '1896';
            got7.Item_Number__c = '300004';
            got7.Description__c = 'Test Item Description';
            got7.Item_Template__c = 'Labor';
            got7.QuantityNum__c = 200;
            got7.Status__c = 'Approved';
            got7.Labor_In_Out__c = 'OUT';
            got7.Show_Management_Field__c = 'Yes';
            got7.File_Reference_Link__c = 'link';
            got7.Booth_Area_Discount_Override__c = 10;
            got7.Discount_Reason_Code__c = 'Customer Good Will';
            got7.Discount_Reason_Text__c = 'Test Reason';
            got7.GOT_Sign_Type_Other__c = 'Test Sign Type';
            got7.Budget_Code__c = '12345';
            got7.Onsite_Contact_Person_Number_Other__c = '9876543210';
            got7.Order_Line_ID__c = '11223348';
            got7.Budget_Code__c = '12347';
            
            GC_GES_Order_Task__c got5 = new GC_GES_Order_Task__c();
            got5.Order__c = order.Id;
            got5.Status__c = 'New';
            got5.Budget_Code__c = '12345';
            got5.Item_Template__c = 'GEM Structures';
            got5.QuantityNum__c = 20;
            got5.Onsite_Contact_Person_Number_Other__c = '9876543210';
            got5.Order_Line_ID__c = '11223350';
            //insert got0;
            insert got;
            insert got1;
            insert got2;
            insert got3;
            insert got4;
            insert got5;
            insert got6;
            insert got7;
            
            gotList1.add(got);
            gotList1.add(got1);
            gotList1.add(got6);
            
            GC_Vendor_Order_Task__c task = new GC_Vendor_Order_Task__c();
            task.Order__c = order.id;
            task.Vendor_Instructions__c = 'test instructions';
            insert task;
            
            got.Status__c = 'Approved';
            update got;
            
            GC_Core_Session__c session1= GC_CoreUtils.getSessionID();
            Test.setMock(WebServiceMock.class, new CORE_SECURITY_IMPLMockImpl());
            Test.setMock(WebServiceMock.class, new CORE_V2MockImpl());
            
            CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService s = new CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService();
            GC_Core_Session__c session = new GC_Core_Session__c();
            session.Core_Application_Session_ID__c = '7abacb3c-36f1-4963-a5e4-7e891ad26e43';
            session.Core_Application_Login_Expiration__c = DateTime.now() + 1;
            insert session;
            
            Test.startTest();
           
            LC_OrderSubmitCancelToCore.sessionLoad(order.Id);
            LC_OrderSubmitCancelToCore.sessionLogin();
            set<string> gotList2 =  LC_OrderSubmitCancelToCore.getTaskIds(order.Id);
            LC_OrderSubmitCancelToCore.cancelOrderAction(order.Id, session.Core_Application_Session_ID__c, gotList1);
            Map<String, GC_GES_Order_Task__c> GesOrderMappingByName = LC_OrderSubmitCancelToCore.getGesOrderMappingByName(order.Id);
            LC_OrderSubmitCancelToCore.validateGesTasks(order.Id,got.id,GesOrderMappingByName);
            LC_OrderSubmitCancelToCore.validateGesTask(1, got);
            LC_OrderSubmitCancelToCore.submitOrderAction(order.Id, session.Core_Application_Session_ID__c);
            LC_OrderSubmitCancelToCore.validateSessionID(session);
            LC_OrderSubmitCancelToCore.processCancelOrderAction(order.Id, session.Core_Application_Session_ID__c, gotList1);
            LC_OrderSubmitCancelToCore.processOrderAction(order.Id, session.Core_Application_Session_ID__c); 
            LC_OrderSubmitCancelToCore.getAllGot(order.Id);
            
            
            LC_OrderSubmitCancelToCore.getTaskIds(order1.Id);
            LC_OrderSubmitCancelToCore.submitOrderAction(order1.Id, session.Core_Application_Session_ID__c);
            LC_OrderSubmitCancelToCore.processOrderAction(order1.Id, session.Core_Application_Session_ID__c); 
            // LC_OrderSubmitCancelToCore.validateGesTask(1, got0); 
            
            wwwViadComDataV3_v1.ShowOrgOrderEntryStatus submitResponse = new wwwViadComDataV3_v1.ShowOrgOrderEntryStatus();
            submitResponse.Success = false;
            submitResponse.ErrorMessage = 'Test error';
            submitResponse.LineNumber = 'Test line';
            submitResponse.EnteredDateTime = system.today();
            submitResponse.SourceOrderCode = 'ges item';
            submitResponse.OrderNumber = 1234;
            submitResponse.OrderHeaderId = 324324;
            submitResponse.OrderLineId = 345444;
            submitResponse.LineStatus = 'fail';
            LC_CoreUtils.getLogOrderEntryContents('1', submitResponse);
            LC_CoreUtils.createNewLog('test', 'test message', 'new', order);
            
        }
        Test.stopTest();
    }        
}