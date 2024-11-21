@isTest
private class LiveAgentController_TEST {

    static testMethod void myUnitTest() {
    	apexPages.currentPage().getParameters().put('endpoint', 'language=Fr#deployment_id');
        LiveAgentController controller = new LiveAgentController();
    }
}