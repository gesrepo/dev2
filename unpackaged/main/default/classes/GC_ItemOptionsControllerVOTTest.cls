@isTest
private class GC_ItemOptionsControllerVOTTest 
{
    @isTest static void testItemOptions() {
        GC_Order__c order = GC_TestUtils.getTestOrder();
        GC_Vendor_Order_Task__c task = new GC_Vendor_Order_Task__c();
        task.Order__c = order.Id;
        insert task;
        
        GC_ItemOptionsControllerVOT cont = new GC_ItemOptionsControllerVOT();
        cont.got = task;
        cont.coreApi = new GC_CoreQuery();
    
         cont.deliveryDateTime = Datetime.now();
         cont.removalDateTime = Datetime.now();
         cont.completionDateTime = Datetime.now();
         cont.venueAttributes = new List<SelectOption>();
     
         GC_PageUtil.setParam('DDT', DateTime.now().format('MM/dd/YYYY hh:mm a'));
        cont.setDateTime();
        
        ApexPages.currentPage().getParameters().remove('DDT');
        GC_PageUtil.setParam('RDT', DateTime.now().format('MM/dd/YYYY hh:mm a'));
        cont.setDateTime();
        
        
        ApexPages.currentPage().getParameters().remove('RDT');
        GC_PageUtil.setParam('CDT', DateTime.now().format('MM/dd/YYYY hh:mm a'));
        cont.setDateTime();
        
        
        ApexPages.currentPage().getParameters().remove('CDT');

        // test hitting the exceptions, values should still be the smae though
        GC_PageUtil.setParam('DDT', 'test abc123');
        cont.setDateTime();
        
        ApexPages.currentPage().getParameters().remove('DDT');
        GC_PageUtil.setParam('RDT', 'test abc123');
        cont.setDateTime();
        
        ApexPages.currentPage().getParameters().remove('RDT');
        GC_PageUtil.setParam('CDT', 'test abc123');
        cont.setDateTime();
        
        ApexPages.currentPage().getParameters().remove('CDT');

        // test blanking out the values
        GC_PageUtil.setParam('DDT', '');
        cont.setDateTime();
        
        ApexPages.currentPage().getParameters().remove('DDT');
        GC_PageUtil.setParam('RDT', '');
        cont.setDateTime();
        
        ApexPages.currentPage().getParameters().remove('RDT');
        GC_PageUtil.setParam('CDT', '');
        cont.setDateTime();
        
        ApexPages.currentPage().getParameters().remove('CDT');

        cont.setDateTime();
        
        cont.getDeliveryDateTimeFormatted();
        cont.getRemovalDateTimeFormatted();
        cont.getCompletionDateTimeFormatted();
      }
    
}