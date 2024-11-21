@isTest
public class GC_FileUploadPageControllerTest {
    
	@isTest static void constructorTest(){
        
        Test.setCurrentPageReference(new PageReference('Page.GC_FileUploadPage'));
        System.currentPageReference().getParameters().put('recordId','1234567890'); 
        System.currentPageReference().getParameters().put('recordName','testName'); 
        GC_FileUploadPageController  fup = new GC_FileUploadPageController();
        GC_Order__c testOrder= GC_TestUtils.getTestOrder();
         GC_Vendor_Order_Task__c testVOT= GC_TestUtils.getTestVendorTask(testOrder.Id, UserInfo.getUserId());
        Test.setCurrentPageReference(new PageReference('Page.GC_FileUploadPage'));
        System.currentPageReference().getParameters().put('recordId',testVOT.id); 
        fup = new GC_FileUploadPageController();
        
    }
}