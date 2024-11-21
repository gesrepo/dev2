@isTest
public class LC_GESItemsSubmitToCoreCtrlTest {
	@isTest
    public static void testSubmitToCore(){
        
        list<GC_GES_Order_Task__c> gotList = new list<GC_GES_Order_Task__c>();
        list<GC_GES_Order_Task__c> gotList1 = new list<GC_GES_Order_Task__c>();
		List<GC_GES_Order_Task__c> gots = new List<GC_GES_Order_Task__c>();
        
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
            gots.add(got);
            
            GC_GES_Order_Task__c got1 = new GC_GES_Order_Task__c();
            got1.Order__c = order.Id;
            got1.Item_Category_ID__c = '1896';
            got1.Item_Number__c = '300004';
            got1.Description__c = 'Test Item Description';
            got1.Item_Template__c = 'Graphics';
            got1.GOT_Single_Double_Sided__c = 'Double';
            got1.QuantityNum__c = 1;
            got1.Status__c = 'New';
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
            gots.add(got1);
            insert gots;

            
            GC_Core_Session__c session1= GC_CoreUtils.getSessionID();
            Test.setMock(WebServiceMock.class, new CORE_SECURITY_IMPLMockImpl());
            Test.setMock(WebServiceMock.class, new CORE_V2MockImpl());
            
            CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService s = new CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService();
            GC_Core_Session__c session = new GC_Core_Session__c();
            session.Core_Application_Session_ID__c = '7abacb3c-36f1-4963-a5e4-7e891ad26e43';
            session.Core_Application_Login_Expiration__c = DateTime.now() + 1;
            insert session;
            
            Test.startTest();
            
            ApexPages.StandardSetController sc1 = new ApexPages.StandardSetController(gots);
            LC_GESItemsSubmitToCoreCtrl controller = new LC_GESItemsSubmitToCoreCtrl();
            LC_GESItemsSubmitToCoreCtrl controller1 = new LC_GESItemsSubmitToCoreCtrl(sc1);
            
            String recordId = got.Id + ','+got1.Id;
            LC_GESItemsSubmitToCoreCtrl.sessionLoad();
            LC_GESItemsSubmitToCoreCtrl.validateSessionID(session);
            LC_GESItemsSubmitToCoreCtrl.sessionLogin();
            LC_GESItemsSubmitToCoreCtrl.submitGESItemsAction(recordId, session.Core_Application_Session_ID__c);
            Test.stopTest();
            
        }
    }
    
    @isTest
    public static void testCancelItemsInCore(){
        
        list<GC_GES_Order_Task__c> gotList = new list<GC_GES_Order_Task__c>();
        list<GC_GES_Order_Task__c> gotList1 = new list<GC_GES_Order_Task__c>();
		List<GC_GES_Order_Task__c> gots = new List<GC_GES_Order_Task__c>();
        
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
            got.Status__c = 'Active';
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
            got.Core_Cancelled__c = false;
            gots.add(got);
            
            GC_GES_Order_Task__c got1 = new GC_GES_Order_Task__c();
            got1.Order__c = order.Id;
            got1.Item_Category_ID__c = '1896';
            got1.Item_Number__c = '300004';
            got1.Description__c = 'Test Item Description';
            got1.Item_Template__c = 'Graphics';
            got1.GOT_Single_Double_Sided__c = 'Double';
            got1.QuantityNum__c = 1;
            got1.Status__c = 'New';
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
            gots.add(got1);
            insert gots;

            
            GC_Core_Session__c session1= GC_CoreUtils.getSessionID();
            Test.setMock(WebServiceMock.class, new CORE_SECURITY_IMPLMockImpl());
            Test.setMock(WebServiceMock.class, new CORE_V2MockImpl());
            
            CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService s = new CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService();
            GC_Core_Session__c session = new GC_Core_Session__c();
            session.Core_Application_Session_ID__c = '7abacb3c-36f1-4963-a5e4-7e891ad26e43';
            session.Core_Application_Login_Expiration__c = DateTime.now() + 1;
            insert session;
            
            Test.startTest();
            
            ApexPages.StandardSetController sc1 = new ApexPages.StandardSetController(gots);
            LC_GESItemsSubmitToCoreCtrl controller = new LC_GESItemsSubmitToCoreCtrl();
            LC_GESItemsSubmitToCoreCtrl controller1 = new LC_GESItemsSubmitToCoreCtrl(sc1);
            
            String recordId = got.Id + ','+got1.Id;
            LC_GESItemsSubmitToCoreCtrl.sessionLoad();
            LC_GESItemsSubmitToCoreCtrl.validateSessionID(session);
            LC_GESItemsSubmitToCoreCtrl.sessionLogin();
            LC_GESItemsSubmitToCoreCtrl.cancelGESItemsAction(recordId, session.Core_Application_Session_ID__c);
            Test.stopTest();
            
        }
    }

}