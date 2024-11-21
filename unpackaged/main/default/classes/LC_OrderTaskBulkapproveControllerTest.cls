@isTest
public class LC_OrderTaskBulkapproveControllerTest {
    
    @isTest static void testAllMethod() 
    {	List<GC_GES_Order_Task__c> gots = new List<GC_GES_Order_Task__c>();
        GC_Order__c order = GC_TestUtils.getTestOrder();
     	string recordId;
     
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
     	gots.add(got);
        
        GC_GES_Order_Task__c got2 = new GC_GES_Order_Task__c();
        got2.Order__c = order.Id;
        got2.Item_Category_ID__c = '1896';
        got2.Description__c = 'Test Item Description';
        got2.Item_Number__c = '300004';
        got2.Item_Template__c = 'Basic';
        got2.QuantityNum__c = 1;
        got2.Status__c = 'Submitted';
        got2.Show_Management_Field__c = 'Yes';
        got2.File_Reference_Link__c = 'link';
        got2.Order_Line_ID__c = '123';
        insert got2;
        gots.add(got2);
        
        Test.startTest(); 
     	
        //ApexPages.StandardController sc = new ApexPages.StandardController();
     	ApexPages.StandardSetController sc1 = new ApexPages.StandardSetController(gots);
        LC_OrderTaskBulkapproveController controller = new LC_OrderTaskBulkapproveController();
        LC_OrderTaskBulkapproveController controller1 = new LC_OrderTaskBulkapproveController(sc1);
        
        LC_OrderTaskBulkapproveController.getGotRecords(got.id);
        LC_OrderTaskBulkapproveController.getGotRecords(got2.id);
        Test.stopTest();
    }
    
}