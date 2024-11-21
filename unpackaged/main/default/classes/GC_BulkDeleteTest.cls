/**
* @author rahul sinha For SLK Software Services
* @description Test code for the GC_OrderBulkDeleteController and GC_OrderTaskBulkDeleteController
* 02-03-2018 : Original Version
* Modified: 
**/
@isTest
public class GC_BulkDeleteTest {
    
    @isTest
    public static void testOrderDeletion() {
        List<GC_Order__c> orders= new List<GC_Order__c>();
        GC_Order__c order1 = GC_TestUtils.getTestOrder();
        GC_Order__c order2 = GC_TestUtils.getTestOrder();
        //public static GC_Connect2_Show__c show;
        GC_GES_Order_Task__c got = new GC_GES_Order_Task__c();
        got.Order__c = order1.Id;
        got.Sign_Length__c = 10;
        got.Sign_Width__c = 10;
        //got.Onsite_Contact_Person__c = accountManagerId;
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
        orders.add(order1);
        orders.add(order2);
        ApexPages.StandardSetController sc=new ApexPages.StandardSetController(orders);
        sc.setSelected(orders);
        GC_OrderBulkDeleteController delController = new GC_OrderBulkDeleteController(sc);
        delController.bulkDelete();
        delController.backAction();
    }
	
	@isTest
	public static void testOrderTaskDeletion() {
        List<GC_GES_Order_Task__c> gots= new List<GC_GES_Order_Task__c>();
        GC_Order__c order3 = GC_TestUtils.getTestOrder();
        //public static GC_Connect2_Show__c show;
		
			GC_GES_Order_Task__c got1 = new GC_GES_Order_Task__c();
			got1.Order__c = order3.Id;
			got1.Sign_Length__c = 10;
			got1.Sign_Width__c = 10;
			//got.Onsite_Contact_Person__c = accountManagerId;
			got1.Delivery_Date_Time__c = DateTime.now();
			got1.Completion_Date_Time__c = DateTime.now() + 10;
			got1.Removal_Date_Time__c = DateTime.now() + 15;
			got1.QuantityNum__c = 5;
			got1.Carpet_Length__c = 15;
			got1.Carpet_Width__c = 15;
			got1.Revision__c = 1;
			got1.Status__c = 'New';
			got1.Item_Number__c = '12345';
			got1.Item_Template__c = 'Carpet';
			insert got1;
			gots.add(got1);
        ApexPages.StandardSetController sc1=new ApexPages.StandardSetController(gots);
        sc1.setSelected(gots);
        GC_OrderTaskBulkDeleteController delController1 = new GC_OrderTaskBulkDeleteController(sc1);
        delController1.bulkDelete();
        delController1.backAction();
    }
}