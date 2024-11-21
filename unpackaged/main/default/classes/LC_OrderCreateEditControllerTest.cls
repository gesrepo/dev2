@isTest
public class LC_OrderCreateEditControllerTest {
    @isTest
    public static void allTestMethod(){
        
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        show.Job_Number__c = '00100';
        update show;
        
        GC_Order__c order = GC_TestUtils.getTestOrder();
        order.Connect2_Show__c = show.Id;
        upsert order;
        
        list<GC_GES_Order_Task__c> gotList = new list<GC_GES_Order_Task__c>();
       
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
            
        GC_Core_Session__c session1= GC_CoreUtils.getSessionID();
        GC_CoreUtils.validateSession(session1);
        String coreSessionId =session1.Core_Application_Session_ID__c;
        Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');
        ContentVersion cv = new ContentVersion();
        cv.title = 'test content trigger';      
        cv.PathOnClient ='test';           
        cv.VersionData =beforeblob;          
        insert cv;         

        ContentVersion testContent = [SELECT  ContentDocumentId FROM ContentVersion where Id = :cv.Id];
        List<contentdocumentlink> contentDocumentLinkList = new List<contentdocumentlink>();
        for(GC_GES_Order_Task__c testTask : gotList){
            contentdocumentlink contentLink = new contentdocumentlink();
            contentLink.LinkedEntityId=testTask.Id;
            contentLink.ShareType= 'V';   
            contentLink.Visibility = 'AllUsers';
            contentlink.ContentDocumentId=testcontent.ContentDocumentId;
            contentDocumentLinkList.add(contentLink);
        }
        insert contentDocumentLinkList;
        
        LC_OrderCreateEditController.LC_OrderWrapper TestWrapper = new LC_OrderCreateEditController.LC_OrderWrapper();
        
        String SessionId = LC_OrderCreateEditController.initSession(order.Id,false).sessionId;
        
        Test.startTest() ;
        LC_OrderCreateEditController.initSession(order.Id,true);
        LC_OrderCreateEditController.initSession(order.Id,false); 
        LC_OrderCreateEditController.initClassSessionLoad(order);
        LC_OrderCreateEditController.cancelClone(order.Id);
        LC_OrderCreateEditController.cloneCurrentOrder(order);
        LC_OrderCreateEditController.cloneOrder(order,order);
        LC_OrderCreateEditController.getCurrentOrder(order.Id);
        LC_OrderCreateEditController.getOrderFields('1390259',order.Connect2_Show__c,coreSessionId,order);
        LC_OrderCreateEditController.showChanged(show.Id,coreSessionId);
       
        LC_OrderCreateEditController.orderCreate(order,false,order.id);
        LC_OrderCreateEditController.orderCreate(order,true,order.id);
        LC_OrderCreateEditController.isCommunity();
        
        show.Job_Number__c = '';
        update show;
        LC_OrderCreateEditController.showChanged(show.Id,coreSessionId);
        Test.stopTest() ;
    }
}