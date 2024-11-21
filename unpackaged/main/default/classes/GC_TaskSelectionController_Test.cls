@isTest
Public class GC_TaskSelectionController_Test {
    @testSetup
    static void testData() {
        GC_Order__c testOrder= GC_TestUtils.getTestOrder();
        GC_GES_Order_Task__c got = new GC_GES_Order_Task__c();
        got.Order__c = testOrder.Id;
        got.Sign_Length__c = 10;
        got.Sign_Width__c = 10;
        got.Onsite_Contact_Person__c = UserInfo.getUserId();
        got.Delivery_Date_Time__c = DateTime.now();
        got.Completion_Date_Time__c = DateTime.now() + 10;
        got.Removal_Date_Time__c = DateTime.now() + 15;
        got.QuantityNum__c = 5;
        got.Carpet_Length__c = 15;
        got.Carpet_Width__c = 15;
        got.Revision__c = 1;
        got.Status__c = 'New';
        got.Item_Number__c = '12345';
        got.Item_Template__c = 'Carpet';
        insert got;
        
    Map<String, User> userMap = GC_TestUtils.getUsers();
        User user1 = userMap.get('AM');
    
        GC_Vendor_Order_Task__c vot=  GC_TestUtils.getTestVendorTask(testOrder.Id, UserInfo.getUserId());
    vot.Vendor2__c= UserInfo.getUserId();
    vot.Vendor3__c= UserInfo.getUserId();
    vot.Vendor4__c= UserInfo.getUserId();
    vot.Vendor5__c= UserInfo.getUserId();
    update vot;
    GC_Show_Team_Member__c teamMember = new GC_Show_Team_Member__c(Connect2_Show__c = testOrder.Connect2_Show__c, Show_Role__c = 'Account Manager', User__c = user1.Id);
        insert teamMember;
        
        
    }
    
      Public Static Testmethod void testSubmitAll(){
        GC_Order__c testOrder1= [select id,Name,Connect2_Show__c from GC_Order__c where Booth_Area_ID__c = '1390259'];
        Test.setCurrentPageReference(new PageReference('Page.GC_TaskSelectionPage'));
        System.currentPageReference().getParameters().put('id',testOrder1.id); 
        GC_TaskSelectionPageController controller = new GC_TaskSelectionPageController();
        for(GC_TaskSelectionPageController.GesTaskWrapper gotWrapper: controller.gesOrderTasks){
            gotWrapper.isSelected =true;
        }
        for(GC_TaskSelectionPageController.VendorTaskWrapper votWrapper: controller.venOrderTasks){
            votWrapper.isSelected =true;
        }
        controller.selectTasks();
        PageReference pr= controller.submitTasks();
        
        GC_Vendor_Order_Task__c vot2=  GC_TestUtils.getTestVendorTask(testOrder1.Id, UserInfo.getUserId());
        vot2.Vendor2__c= UserInfo.getUserId();
        vot2.Vendor3__c= UserInfo.getUserId();
        vot2.Vendor4__c= UserInfo.getUserId();
        vot2.Vendor5__c= UserInfo.getUserId();
        update vot2;
        ContentVersion fileToUpload  = new ContentVersion(
              Title = 'Penguins',
              PathOnClient = 'Penguins.jpg',
              VersionData = Blob.valueOf('Test Content'),
              IsMajorVersion = true
            );
        insert  fileToUpload;
        ContentDocumentLink contentlink = new ContentDocumentLink();
        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :fileToUpload.Id LIMIT 1];  
        contentlink.LinkedEntityId = vot2.id;
        contentlink.contentdocumentid = contentVersion_2.contentdocumentid;
        contentlink.ShareType = 'V';
        insert contentlink; 
        GC_VOTSubmitForApproval.submitRecord(vot2.id);
        
      }          
}