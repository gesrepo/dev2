@isTest
private class GC_CoreUtilsTest{
    @isTest static void testMethod1() {
        
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        show.Job_Number__c = '1';
        update show;
        
        User accountMgr = GC_TestUtils.createUser('GC Account Manager', 'Test','AC01');
        accountMgr.GC_Show_Role__c='GC Account Manager; GC Creative Director; GC Traffic Administrator; GC Detailer; GC Director of Account Management; GC Sales Manager; GC Graphics Project Manager; GC Community Client; GC Community Vendor';
        update accountMgr;
        
        GC_Order__c order = new GC_Order__c();
        order.Connect2_Show__c = show.Id;
        order.Booth_Area__c  = 'Area';
        order.Booth_Area_ID__c = '1390259';
        insert order;
        
        GC_Show_Team_Member__c showTM1 = new GC_Show_Team_Member__c();
        showTM1.Connect2_Show__c= show.Id;
        showTM1.User__c= accountMgr.Id;
        showTM1.Show_Role__c= 'Account Manager';
        upsert showTM1;
        List<GC_GES_Order_Task__c> gots =new List<GC_GES_Order_Task__c>();
        
     
        
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
        got.Discount_Reason_Text__c ='test';
        got.Booth_Area_Discount_Override__c=12;
        got.Budget_Code__c ='test';
       
       
        GC_GES_Order_Task__c got1 = new GC_GES_Order_Task__c();
        got1.Order__c = order.Id;
        got1.Item_Category_ID__c = '1896';
        got1.Item_Number__c = '300004';
        got1.Description__c = 'Test Item Description';
        got1.Item_Template__c = 'Graphics';
        got1.GOT_Single_Double_Sided__c = 'Double';
        got1.GOT_Sign_Type_Other__c='test';
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
        got1.Material__c = sa2.Id;
        got1.Save_Signs__c = 'yes';
        got1.GOT_Background__c = 'test background';
        
        
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
         
        
        GC_GES_Order_Task__c got3 = new GC_GES_Order_Task__c();
        got3.Order__c = order.Id;
        got3.Item_Category_ID__c = '1896';
        got3.Item_Number__c = '300004';
        got3.Description__c = 'Test Item Description';
        got3.Item_Template__c = 'Carpet';
        got3.Electrical_Ordered__c = false;
        got3.Electrical_Under__c = false;
        got3.UOM__c = 'EA';
        got3.QuantityNum__c = 1;
        got3.Status__c = 'Approved';
        got3.Show_Management_Field__c = 'Yes';
        got3.File_Reference_Link__c = 'link';
        
        
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
        got4.Carpet_Width__c=5;
        got4.QuantityNum__c = 200;
        got4.Status__c = 'Approved';
        got4.Show_Management_Field__c = 'Yes';
        got4.File_Reference_Link__c = 'link';
        
        GC_GES_Order_Task__c got5 = new GC_GES_Order_Task__c();
        got5.Order__c = order.Id;
        got5.Item_Category_ID__c = '1896';
        got5.Item_Number__c = '300004';
        got5.Description__c = 'Test Item Description';
        got5.Item_Template__c = 'Labor';
        got5.Electrical_Ordered__c = true;
        got5.Electrical_Under__c = true;
        got5.QuantityNum__c = 2;
        got5.Status__c = 'Approved';
        got5.Show_Management_Field__c = 'Yes';
        got5.File_Reference_Link__c = 'link';
        got5.Labor_In_Out__c ='IN';
        
        gots.add(got);
        gots.add(got1);
        gots.add(got2);
        gots.add(got3);
        gots.add(got4);
        gots.add(got5);
        insert gots;
        
        GC_Vendor_Order_Task__c task = new GC_Vendor_Order_Task__c();
        task.Order__c = order.id;
        task.Vendor_Instructions__c = 'test instructions';
        insert task;
        for(GC_GES_Order_Task__c got6:gots){
            got6.Status__c = 'Approved';
        }
        
        update gots;
        List<GC_GES_Order_Task__c> gots1= GC_GESOrderTaskDao.getInstance().getByGesOrderId(order.id);
        Map<String, GC_GES_Order_Task__c> newMapByName = new Map<String, GC_GES_Order_Task__c> ();
        
        for(GC_GES_Order_Task__c got6:gots1){
            newMapByName.put(got6.Name, got6);
        }
        
        Test.setMock(WebServiceMock.class, new CORE_SECURITY_IMPLMockImpl());
        Test.setMock(WebServiceMock.class, new CORE_V2MockImpl());
        
        CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService s = new CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService();
        GC_Core_Session__c session = new GC_Core_Session__c();
        session.Core_Application_Session_ID__c = '7abacb3c-36f1-4963-a5e4-7e891ad26e43';
        session.Core_Application_Login_Expiration__c = DateTime.now() + 1;
        insert session;
        
        GC_CoreUtils cont = new GC_CoreUtils();
        GC_Core_Session__c session1= GC_CoreUtils.getSessionID();
        GC_CoreUtils.validateSession(session1);
        String coreSessionId =session1.Core_Application_Session_ID__c;
        GC_Core_Session__c coreLogin = GC_CoreUtils.loginToCore();
        String APIEndpoint = GC_CoreUtils.getAPIEndpoint();
        DateTime dt= GC_CoreUtils.convertExternalDateTime(Date.Today());
        GC_CoreUtils.submitOrderToCore(coreSessionId, order, newMapByName, false);
        GC_CoreUtils.processOrderBatch(coreSessionId, order, newMapByName, false);
        wwwViadComDataV3_v1.ShowOrgOrderEntryStatus submitResponse= new wwwViadComDataV3_v1.ShowOrgOrderEntryStatus();
        submitResponse.LineNumber = 'active';
        submitResponse.Success=true;
        submitResponse.EnteredDateTime= Date.Today();
        submitResponse.ErrorMessage='none';
        submitResponse.OrderHeaderId=1234;
        submitResponse.OrderLineId=234;
        submitResponse.OrderNumber=456;
        submitResponse.SourceOrderCode=String.valueof(got.Name);
        GC_CoreUtils.submitOrderToCore(coreSessionId, order, newMapByName);
        
        
        Map<String, GC_GES_Order_Task__c> newMapByName2 = new Map<String, GC_GES_Order_Task__c> ();
        newMapByName2.put(got.Name, got);
        GC_GES_Order_Task__c  gotResponse= GC_CoreUtils.updateGesOrderTask(got.Name, submitResponse, newMapByName2) ;
        String  r= GC_CoreUtils.getLogOrderEntryContents('12', submitResponse) ;
        submitResponse.ErrorMessage=null;
        r= GC_CoreUtils.getLogOrderEntryContents('12', submitResponse) ;
        //GC_CoreUtils.cancelOrderInCore(coreSessionId, order, newMapByName, false);
        Map<String, GC_GES_Order_Task__c> newMapByName3 = new Map<String, GC_GES_Order_Task__c> ();
        for(GC_GES_Order_Task__c got6:gots1){
            got6.Status__c = 'Canceled';
            got6.Order_Line_ID__c = '12345';
            got6.Core_Cancelled__c = false;
            
            newMapByName3.put(got6.Name, got6);
        }
        
        GC_CoreUtils.cancelOrderInCore(coreSessionId, order, newMapByName3, false);
        
        GC_Core_Interface_Log__c log= GC_CoreUtils.createNewLog(' method', ' message', 'status',  order);
    }
}