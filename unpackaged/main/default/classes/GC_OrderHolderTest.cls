@isTest
public class GC_OrderHolderTest {
 @isTest   
    public static void Test1(){
         GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        
        User usr = [SELECT Id, Name FROM User WHERE Id = :userinfo.getUserId() LIMIT 1];
        
        GC_Order__c order = new GC_Order__c();
        order.Connect2_Show__c = show.Id;
        order.Order_Area_Description__c = 'testing';
        order.Booth_Area__c='Bangalore';
        insert order;
        
        GC_GES_Order_Task__c got = new GC_GES_Order_Task__c();
        got.Order__c = order.Id;
        got.Delivery_Location__c = 'testing';
        insert got;
        
        GC_Vendor_Order_Task__c vot = new GC_Vendor_Order_Task__c();
        vot.Order__c = order.Id;
        insert vot ;
        
        
        Attachment ah =new Attachment();
        ah.Description ='plane';
        ah.LastModifiedDate = (Date.today());
        ah.ContentType='Attachment';
        List<Attachment> listOrderAttachment = new List<Attachment>();
        listOrderAttachment.add(ah);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(show);
        GC_OrderHolder orderHolder = new GC_OrderHolder(order);
        orderHolder.selected = true;
        List<GC_OrderHolder> holderList = new List<GC_OrderHolder>();
        holderList.add(orderHolder);
    }  
     
}