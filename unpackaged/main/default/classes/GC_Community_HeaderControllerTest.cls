/**
* @author Ethos Solutions - www.ethos.com
* @description Test code for the Header Controller class
* 2016-04-13 : Original Version
**/
@isTest
private class GC_Community_HeaderControllerTest {

    @isTest static void TestHeader() {
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        GC_Order__c order = new GC_Order__c();
        order.Connect2_Show__c = show.Id;
        insert order;

        GC_Community_HeaderController cont = new GC_Community_HeaderController();
        ApexPages.currentPage().getParameters().put('showId' , show.Id);
        ApexPages.currentPage().getParameters().put('orderId' , order.Id);

        cont = new GC_Community_HeaderController();
        cont.getShowDates();

        Boolean hasTaskRay = cont.hasTaskRayAccess;
        
        Boolean hasCongressAccess = cont.hasCongressAccess;
        
        Boolean hasTradeshowAccess = cont.hasTradeshowAccess;
        PageReference pr= cont.navigateAnalytics();
    }

}