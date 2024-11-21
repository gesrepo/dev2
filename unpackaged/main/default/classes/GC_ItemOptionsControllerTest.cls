@isTest
private class GC_ItemOptionsControllerTest {
    
    @isTest static void testItemOptions() {
        
        GC_Order__c order = GC_TestUtils.getTestOrder();
        GC_GES_Order_Task__c task = new GC_GES_Order_Task__c();
        task.Order__c = order.Id;
        
        insert task;
        
        GC_ItemOptionsController cont = new GC_ItemOptionsController();
        
        cont.got = task;
        cont.coreApi = new GC_CoreQuery();
        cont.coreApi.setCurrentTask(task);
        
        cont.deliveryDateTime = Datetime.now();
        cont.removalDateTime = Datetime.now();
        cont.completionDateTime = Datetime.now();
        cont.venueAttributes = new List<SelectOption>();
        cont.materialAttributes = new List<SelectOption>();
        
        System.assertEquals(null, cont.getDeliveryDateTimeFormatted());
        System.assertEquals(null, cont.getRemovalDateTimeFormatted());
        System.assertEquals(null, cont.getCompletionDateTimeFormatted());
        
        GC_PageUtil.setParam('DDT', DateTime.now().format('MM/dd/YYYY hh:mm a'));
        cont.setDateTime();
        System.assertNotEquals(null, cont.got.Delivery_Date_Time__c);
        ApexPages.currentPage().getParameters().remove('DDT');
        GC_PageUtil.setParam('RDT', DateTime.now().format('MM/dd/YYYY hh:mm a'));
        cont.setDateTime();
        System.assertNotEquals(null, cont.got.Removal_Date_Time__c);
        ApexPages.currentPage().getParameters().remove('RDT');
        GC_PageUtil.setParam('CDT', DateTime.now().format('MM/dd/YYYY hh:mm a'));
        cont.setDateTime();
        System.assertNotEquals(null, cont.got.Completion_Date_Time__c);
        ApexPages.currentPage().getParameters().remove('CDT');
        
        System.assertNotEquals(null, cont.getDeliveryDateTimeFormatted());
        System.assertNotEquals(null, cont.getRemovalDateTimeFormatted());
        System.assertNotEquals(null, cont.getCompletionDateTimeFormatted());
        
        // test hitting the exceptions, values should still be the smae though
        GC_PageUtil.setParam('DDT', 'test abc123');
        cont.setDateTime();
        System.assertNotEquals(null, cont.got.Delivery_Date_Time__c);
        ApexPages.currentPage().getParameters().remove('DDT');
        GC_PageUtil.setParam('RDT', 'test abc123');
        cont.setDateTime();
        System.assertNotEquals(null, cont.got.Removal_Date_Time__c);
        ApexPages.currentPage().getParameters().remove('RDT');
        GC_PageUtil.setParam('CDT', 'test abc123');
        cont.setDateTime();
        System.assertNotEquals(null, cont.got.Completion_Date_Time__c);
        ApexPages.currentPage().getParameters().remove('CDT');
        
        // test blanking out the values
        GC_PageUtil.setParam('DDT', '');
        cont.setDateTime();
        System.assertEquals(null, cont.got.Delivery_Date_Time__c);
        ApexPages.currentPage().getParameters().remove('DDT');
        GC_PageUtil.setParam('RDT', '');
        cont.setDateTime();
        System.assertEquals(null, cont.got.Removal_Date_Time__c);
        ApexPages.currentPage().getParameters().remove('RDT');
        GC_PageUtil.setParam('CDT', '');
        cont.setDateTime();
        System.assertEquals(null, cont.got.Completion_Date_Time__c);
        ApexPages.currentPage().getParameters().remove('CDT');
        
        cont.setDateTime();
        cont.got.Copy_Default_Order_Dates__c  = true;
        cont.copyDates();
        
        cont.getstrDeliveryDateTime();
        cont.getstrCompletionDateTime();
        cont.getstrRemovalDateTime();
    }
    
}