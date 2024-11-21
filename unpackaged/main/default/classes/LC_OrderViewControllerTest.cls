@isTest
public class LC_OrderViewControllerTest {
    @TestSetup
    public static void testSetup(){
        Opportunity opp=LC_TestUtils.insertOpportunity();
        GC_Connect2_Show__c show=LC_TestUtils.insertShow(opp.Id,opp.Name);
        GC_Order__c order=LC_TestUtils.insertOrder(show.Id);
         GC_Show_Attribute__c venueAttribute=LC_TestUtils.insertVenueAttributes(show.Id);
        GC_Show_Attribute__c deptAttribute=LC_TestUtils.insertDeptAttributes(show.Id);
        GC_Show_Attribute__c serviceAttribute=LC_TestUtils.insertServiceAttributes(show.Id);
        GC_Vendor_Order_Task__c vot=LC_TestUtils.insertVOT(order.Id,serviceAttribute.Id);
        GC_GES_Order_Task__c got=LC_TestUtils.insertGOT(order.Id,venueAttribute.Id,deptAttribute.Id);
    }
    @isTest
    public static void testMethod1() {
        GC_Connect2_Show__c show=[select id from GC_Connect2_Show__c where Show_Name__c = 'test show'];
        GC_Order__c order = [select Id from GC_Order__c where Booth_Area__c='new Booth Area'];
        list<String> orderIds = new list<String>();
        List<string> selectedStatusToPrint=new List<String>();
        orderIds.add(order.Id);
        LC_OrderViewController.getShowNumber(order.Id);
        LC_OrderViewController.getDataToDownlaodAsCSV(orderIds,selectedStatusToPrint,show.Id);
        LC_OrderViewController.showOrHideDeleteButton(order.Id);
        LC_OrderViewController.isCommunity();
        order.Status__c='';
        update order;
        LC_OrderViewController.showOrHideDeleteButton(order.Id); 
        LC_OrderViewController.getVOTStatusOfOrder(order.Id);
        GC_Vendor_Order_Task__c vendorOrderTask=[select Id from GC_Vendor_Order_Task__c where Delivery_Location_Ven__c='votForExistingMethod Location'];
        vendorOrderTask.Status__c='sent';
        update vendorOrderTask;
        LC_OrderViewController.getVOTStatusOfOrder(order.Id);
        order.Status__c='New';
        update order;
        LC_OrderViewController.deleteOrderAction(order.Id);
        order.Status__c='Active';
        update order;
        delete vendorOrderTask;
        LC_OrderViewController.deleteOrderAction(order.Id);
        LC_OrderViewController.getVOTStatusOfOrder(order.Id);
        LC_OrderViewController.initializeDeliveryLocationDetails(order.Id);
        LC_OrderViewController.GetShowID(order.Id);
        
        User accountMgr = GC_TestUtils.createUser('GC Account Manager', 'Test','AC01');
        accountMgr.GC_Show_Role__c='GC Account Manager; GC Creative Director; GC Traffic Administrator; GC Detailer; GC Director of Account Management; GC Sales Manager; GC Graphics Project Manager; GC Community Client; GC Community Vendor';
        update accountMgr;
        
        system.runAs(accountMgr){
            LC_OrderViewController.getProfileName();
        }
    }
    public static void testMethod2() {
        GC_Order__c order = [select Id from GC_Order__c where Booth_Area__c='new Booth Area'];
        LC_OrderViewController.GetShowID(order.Id);
 		LC_OrderViewController.isCommunity();       
    }
}