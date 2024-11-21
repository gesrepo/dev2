/**
* @author Ethos Solutions - www.ethos.com
* @description Wrapper class that holds selected GES Order
* 2016-04-13 : Original Version
**/
public with sharing class GC_OrderHolder {
    public GC_Order__c order {get; set;}
    public Boolean selected {get; set;}
    public List<GC_GES_Order_Task__c> gesTasks {get; set;}
    public List<GC_Vendor_Order_Task__c> vendorTasks {get; set;}
    public List<Attachment> listOrderAttachment {get; set;}   //added for SAL 517-518 @rksinha

    public GC_OrderHolder(GC_Order__c order) {
        this.order = order;
        this.selected = false;
        gesTasks = new List<GC_GES_Order_Task__c>();
        vendorTasks = new List<GC_Vendor_Order_Task__c>();
        if(order.Attachments.size() > 0) {
            listOrderAttachment = new List<Attachment>();
            listOrderAttachment.addAll(order.Attachments);
        }
    }
}