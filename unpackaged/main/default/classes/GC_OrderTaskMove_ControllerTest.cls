@isTest
public class GC_OrderTaskMove_ControllerTest
{
     public static testMethod void Test1() 
     {
         GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        
        User usr = [SELECT Id, Name FROM User WHERE Id = :userinfo.getUserId() LIMIT 1];
        Map<String, User> portalUsers = GC_TestUtils.getPortalUsers();
        User vendor = portalUsers.get('GC Community Vendor');
        
        GC_Order__c order = new GC_Order__c();
        order.Connect2_Show__c = show.Id;
        order.Order_Area_Description__c = 'testing';
        order.Booth_Area__c='Bangalore';
        insert order;
        
        GC_Order__c order1 = new GC_Order__c();
        order1.Connect2_Show__c = show.Id;
        order1.Order_Area_Description__c = 'testing';
        order1.Booth_Area__c='Bangalore';
        insert order1;
        
        GC_Show_Attribute__c GCshow=new GC_Show_Attribute__c();
        GCshow.Connect2_Show__c =show.Id;
        GCshow.name='test';
        insert GCshow;

        GC_GES_Order_Task__c got = new GC_GES_Order_Task__c();
        got.Order__c = order.Id;
        got.Delivery_Location__c = 'testing';
        got.Department__c=GCshow.id;
        insert got;
        
        GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c();
        stm.Connect2_Show__c = order.Connect2_Show__c;
        stm.User__c = vendor.Id;
        stm.Show_Role__c = 'Vendor';
        insert stm;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(got);
        

        GC_OrderTaskMove_Controller cont = new GC_OrderTaskMove_Controller(sc);
        GC_OrderTaskMove_Controller.wrapOrdTask orderHolder = new GC_OrderTaskMove_Controller.wrapOrdTask(got);
        orderHolder.selected = true;
        List<GC_OrderTaskMove_Controller.wrapOrdTask> holderList = new List<GC_OrderTaskMove_Controller.wrapOrdTask>();
        holderList.add(orderHolder);
        cont.ordTaskList = holderList;
        PageReference pr;
        
        cont.selectedshow = show.Id;
        
        cont.selectedOrder = order1.Id;
        cont.moveOrdTasks();
        cont.cancelclone();
     }
}