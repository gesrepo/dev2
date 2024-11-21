@isTest
Public Class GC_GESOrderTaskDaoTest{
    @testSetup static void dataSetup() {
        //Opportunity opp = GC_TestUtils.getTestOpportunity();
        //GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show1();
        GC_Order__c testOrder=GC_TestUtils.getTestOrder();
        GC_GES_Order_Task__c testGOT = new GC_GES_Order_Task__c();
        testGOT.Order__c = testOrder.Id;
        testGOT.Sign_Length__c = 10;
        testGOT.Sign_Width__c = 10;
        //testGOT.Onsite_Contact_Person__c = accountManagerId;
        testGOT.Delivery_Date_Time__c = DateTime.now();
        testGOT.Completion_Date_Time__c = DateTime.now() + 10;
        testGOT.Removal_Date_Time__c = DateTime.now() + 15;
        testGOT.QuantityNum__c = 5;
        testGOT.Carpet_Length__c = 15;
        testGOT.Carpet_Width__c = 15;
        testGOT.Revision__c = 1;
        testGOT.Status__c = 'New';
        testGOT.Item_Number__c = '12345';
        testGOT.Item_Template__c = 'Carpet';
        insert testGOT;
    }
    
    //Start testing all methods one by one
    @isTest static void testMethod0() {
        GC_Order__c testOrder1= [SELECT id, name, Connect2_Show__c, Connect2_Show__r.Id from  GC_Order__c where Booth_Area_ID__c='1390259'];
        GC_GESOrderTaskDao gotDAO= GC_GESOrderTaskDao.getInstance();
        List<GC_GES_Order_Task__c> gots = gotDAO.getByConnect2ShowId(testOrder1.Connect2_Show__c);
        Set<String> gotIds= new Set<String>();
        gotIds.add(testOrder1.Id);
        String gotId;
        for(GC_GES_Order_Task__c got: gots){
            gotIds.add(string.valueOf(got.Id));
            gotId=string.valueOf(got.Id);
        }
        gots = gotDAO.getByConnect2ShowId(testOrder1.Connect2_Show__c,'Name');
        gots = gotDAO.getByGesOrderId(testOrder1.Id);
        gots = gotDAO.getByGesOrderIdAndExcludeStatus(testOrder1.Id,'Submitted');
        gots = gotDAO.getByGesOrderIdDesc(testOrder1.Id);
        String whereClause = 'Order__c = \'' + testOrder1.Id + '\' AND OwnerId = \'' + UserInfo.getUserId() + '\'';
        gots = gotDAO.getByWhere(whereClause);
        Set<String> orderIds= new Set<String>();
        orderIds.add(string.valueOf(testOrder1.Id));
        gots = gotDAO.getGesOrderTaskByOrderSet(orderIds);
        gots = gotDAO.getGesOrderTaskOrderByOrderSet(orderIds);
        gots = gotDAO.getGESOrderTaskByIds(gotIds);
        GC_GES_Order_Task__c got = gotDAO.getGESOrderTaskById(gotId);
        
    }
}