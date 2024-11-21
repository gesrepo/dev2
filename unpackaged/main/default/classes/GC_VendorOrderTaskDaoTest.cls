/**
* @author Ethos Solutions - www.ethos.com
* @description Test code for Vendor Order Task DAO
* 2016-04-13 : Original Version
**/
@isTest
private class GC_VendorOrderTaskDaoTest {
    
    
    @testSetup static void dataSetup() {
        GC_Order__c testOrder=GC_TestUtils.getTestOrder();
        GC_Vendor_Order_Task__c task = new GC_Vendor_Order_Task__c();
        task.Order__c = testOrder.id;
        task.Vendor_Instructions__c = 'test instructions';
        insert task;
    }
    
    @isTest static void test_method_one() {
        GC_Order__c testOrder1= [SELECT id, name, Connect2_Show__c, Connect2_Show__r.Id from  GC_Order__c where Booth_Area_ID__c='1390259'];
        GC_VendorOrderTaskDao votDAO= GC_VendorOrderTaskDao.getInstance();
        
        List<GC_Vendor_Order_Task__c> vots = votDAO.getByConnect2ShowId(testOrder1.Connect2_Show__c);
        Set<String> votIds= new Set<String>();
        votIds.add(testOrder1.Id);
        String votId;
        for(GC_Vendor_Order_Task__c vot: vots){
            votIds.add(string.valueOf(vot.Id));
            votId = string.valueOf(vot.Id);
        }
    }
    
    @isTest static void test_method_two() {
        // Implement test code
    }
    
}