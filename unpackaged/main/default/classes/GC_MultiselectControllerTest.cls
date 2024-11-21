@isTest
private class GC_MultiselectControllerTest {

    static testMethod void testMultiselectController() {
        GC_MultiselectController c = new GC_MultiselectController();

        c.leftOptions = new List<SelectOption>();
        c.rightOptions = new List<SelectOption>();

        c.leftOptionsHidden = 'A&a&b&b&C&c';
        c.rightOptionsHidden = '';

        System.assertEquals(c.leftOptions.size(), 3);
        System.assertEquals(c.rightOptions.size(), 0);
    }

}