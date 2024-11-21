@isTest
public class LC_AddMyselfToShowControllerTest {
	
    static TestMethod void testAllMethods() {
        User addedUser = GC_TestUtils.createUser('GC Account Manager', 'test', 'user');
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        System.runAs(addedUser) {
            LC_AddMyselfToShowController.checkIsAdmin();
            LC_AddMyselfToShowController.checkIsOnShow(show.Id);
            LC_AddMyselfToShowController.getRoles(show.Id);
            LC_AddMyselfToShowController.addMyselfToshow(show.Id, 'Account Manager');
        }
    }
}