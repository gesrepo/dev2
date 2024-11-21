@isTest
private class GC_TaskHistoryComponentControllerTest {

	@isTest static void testObjectHistory() {

        Map<String, User> userMap = GC_TestUtils.getUsers();
        User user = userMap.get('AM');

        GC_GES_Order_Task__c orderTask = GC_TestUtils.setupOrderAndTask(user.Id);

        System.runAs(user) {
            GC_Order__c order = GC_OrderDao.getInstance().getOrderById(orderTask.Order__c);
            order.Booth_Area__c = 'Test Area 2';
            update order;

            order.Booth_Area__c = 'Test Area 3';
            update order;

            GC_TaskHistoryComponentController cont = new GC_TaskHistoryComponentController();
            cont.myObject = order;

            List<GC_TaskHistoryComponentController.objectHistoryLine> history = cont.getObjectHistory();

            System.assertNotEquals(null, history);
            System.assertNotEquals(0, history.size());


        }
	}

}