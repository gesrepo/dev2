@isTest
private class Test_SOP_VIAD_V2 {
    
    private static void createCustomSetting() {
        insert new SOPService__c(Name = 'Default', URL__c = 'https://uatapi.viad.com/GES/v2/SOPService.svc');
    }
    
    @isTest static void SalesforceUpsertOrganisationTest() {
        createCustomSetting();
        Test.startTest();
            Test.setMock(WebServiceMock.class, new SOP_VIAD_V2_MockImpl_UOR());
            
            SOP_VIAD_V2.BasicHttpBinding_ISOPService service = new SOP_VIAD_V2.BasicHttpBinding_ISOPService();
            String sid = '1234';
            SOP_VIAD_V2.SalesforceUpsertOrganisationRequest uoReq = new SOP_VIAD_V2.SalesforceUpsertOrganisationRequest();
            SOP_VIAD_V2.SalesforceUpsertOrganisationResult uoRes = service.SalesforceUpsertOrganisation(sid, uoReq);
        Test.stopTest();
    }
    
    @isTest static void SalesforceUpsertContactTest() {
        createCustomSetting();
        Test.startTest();
            Test.setMock(WebServiceMock.class, new SOP_VIAD_V2_MockImpl_UCR());
            
            SOP_VIAD_V2.BasicHttpBinding_ISOPService service = new SOP_VIAD_V2.BasicHttpBinding_ISOPService();
            String sid = '1234';
            SOP_VIAD_V2.SalesforceUpsertContactRequest ucReq = new SOP_VIAD_V2.SalesforceUpsertContactRequest();
            String ucRes = service.SalesforceUpsertContact(sid, ucReq);
        Test.stopTest();
    }
    
    @isTest static void GetCustomerOrdersTest() {
        createCustomSetting();
        Test.startTest();
            Test.setMock(WebServiceMock.class, new SOP_VIAD_V2_MockImpl_COR());
            
            SOP_VIAD_V2.BasicHttpBinding_ISOPService service = new SOP_VIAD_V2.BasicHttpBinding_ISOPService();
            String sid = '1234';
            SOP_VIAD_V2.CustomerOrdersRequest coReq = new SOP_VIAD_V2.CustomerOrdersRequest();
            SOP_VIAD_V2.ArrayOfCustomerOrder coRes = service.GetCustomerOrders(sid, coReq);
            SOP_VIAD_V2.CustomerOrder co = new SOP_VIAD_V2.CustomerOrder();
        Test.stopTest();
    }
    
    @isTest static void GetOrderSummaryTest() {
        createCustomSetting();
        Test.startTest();
            Test.setMock(WebServiceMock.class, new SOP_VIAD_V2_MockImpl_OSR());
            
            SOP_VIAD_V2.BasicHttpBinding_ISOPService service = new SOP_VIAD_V2.BasicHttpBinding_ISOPService();
            String sid = '1234';
            SOP_VIAD_V2.OrderSummaryRequest osReq = new SOP_VIAD_V2.OrderSummaryRequest();
            SOP_VIAD_V2.OrderSummary osRes = service.GetOrderSummary(sid, osReq);
        Test.stopTest();
    }
    
    @isTest static void beginInvokeTests() {
        createCustomSetting();
        Test.startTest();
            SOP_VIAD_V2.BasicHttpBinding_ISOPService service = new SOP_VIAD_V2.BasicHttpBinding_ISOPService();
            System.Continuation cont = new System.Continuation(120);
            String sid = '1234';
            
            SOP_VIAD_V2.SalesforceUpsertOrganisationRequest uoReq = new SOP_VIAD_V2.SalesforceUpsertOrganisationRequest();
            SOP_VIAD_V2.SalesforceUpsertOrganisationResponse_elementFuture uoRes = service.beginSalesforceUpsertOrganisation(cont, sid, uoReq);
            
            SOP_VIAD_V2.SalesforceUpsertContactRequest ucReq = new SOP_VIAD_V2.SalesforceUpsertContactRequest();
            SOP_VIAD_V2.SalesforceUpsertContactResponse_elementFuture ucRes = service.beginSalesforceUpsertContact(cont, sid, ucReq);
        Test.stopTest();
    }
    
}