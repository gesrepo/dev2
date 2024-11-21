@isTest
private class SOP_APIIntegrationTest {
    

    @isTest static void test_method_one() {
        insert new SOPService__c(Name = 'Default', URL__c = 'https://uatapi.viad.com/GES/v2/SOPService.svc');
        
        SOP_APIIntegration sapII = new SOP_APIIntegration();
        Map<string,string> ecwMap = new Map<String,String>();
        ecwMap.put('CatalogueName', 'bbbbb');
        ecwMap.put('CurrentPriveVATRate', '54');
        ecwMap.put('ExchangeRate', '67');
        ecwMap.put('HirePriceVATRate', '67853');
        ecwMap.put('ID', 'bbbbb');
        ecwMap.put('StartDate', String.valueOf(date.Today()));
        ecwMap.put('EventID', 'bbbbb');

        SOP_APIIntegration.EventCatalogueWrapper a = new SOP_APIIntegration.EventCatalogueWrapper(ecwMap);

        Map<string,string> eciwMap = new Map<String,String>();
        eciwMap.put('Code', 'bbbbb');
        eciwMap.put('CurrentVatRate', '67');
        eciwMap.put('CurrentPrice', '23421');
        eciwMap.put('HirePrice', '3454324');
        eciwMap.put('HireVatRate', '2323');
        eciwMap.put('ID', 'bbbbb');
        eciwMap.put('ItemType', 'bbbbb');
        eciwMap.put('Name', 'bbbbb');
        eciwMap.put('ParentID', 'bbbbb');
        eciwMap.put('Pricing', '342342');
        eciwMap.put('ShortDescription', 'bbbbb');

        SOP_APIIntegration.EventCatalogueItemWrapper b = new SOP_APIIntegration.EventCatalogueItemWrapper(eciwMap);
        SOP_APIIntegration.orderHistoryWrapper c = new SOP_APIIntegration.orderHistoryWrapper(new SOP_VIAD_V2.CustomerOrder(),new Map<String,String>());
        SOP_APIIntegration.orderSummaryWrapper d = new SOP_APIIntegration.orderSummaryWrapper(new SOP_VIAD_V2.OrderSummary());
        SOP_APIIntegration.orderSummaryItemWrapper f = new SOP_APIIntegration.orderSummaryItemWrapper(new SOP_Data_Contract.OrderSummaryItem());

        try {
            SOP_APIIntegration.UpsertOrganisation('esteString','binenteles');
        } catch(Exception e) {
            system.debug(e);
        }
        try {
            SOP_APIIntegration.UpsertContact('char de string','char esti tu');
        } catch(Exception e) {

        }
        try {
            SOP_APIIntegration.authenticate('da un nume','da o parola');
        } catch(Exception e) {

        }
        try {
            SOP_APIIntegration.getServiceOrderHistory('asta-i session','asta-i account');
        } catch(Exception e) {

        }
        try {
            SOP_APIIntegration.getServiceOrderSummary('asta-i sesiunea', 3,'asta-i instanta');
        } catch(Exception e) {

        }
        try {
            SOP_APIIntegration.getServiceOrderItems('asta-i sesiunea','asta-i instanta',d);
        } catch(Exception e) {

        }
        try {
            SOP_APIIntegration.getEventCatalogRequest('asta-i sesiunea','asta-i eventul','si asta-i instanta');
        } catch(Exception e) {

        }
        try {
            SOP_APIIntegration.getEventCatalogItemsRequest('asta-i sesiunea','asta-i catalogul','asta-i instanta');
        } catch(Exception e) {

        }
    }
}