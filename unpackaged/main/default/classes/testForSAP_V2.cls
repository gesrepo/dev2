@isTest
private class testForSAP_V2 {

	static testmethod void test1() {
		SOPService__c serv = new SOPService__c();
        serv.Name = 'Default';
        serv.URL__c = 'test';
        insert serv;
        
		SOP_VIAD_V2.SalesforceUpsertContactRequest a = new SOP_VIAD_V2.SalesforceUpsertContactRequest();
		SOP_VIAD_V2.SalesforceUpsertContactResponse_element b = new SOP_VIAD_V2.SalesforceUpsertContactResponse_element();
		SOP_VIAD_V2.SalesforceUpsertContact_element c = new SOP_VIAD_V2.SalesforceUpsertContact_element();
		SOP_VIAD_V2.SalesforceUpsertOrganisation_element d = new SOP_VIAD_V2.SalesforceUpsertOrganisation_element();
		SOP_VIAD_V2.SalesforceUpsertOrganisationResponse_element e = new SOP_VIAD_V2.SalesforceUpsertOrganisationResponse_element();
		SOP_VIAD_V2.SalesforceUpsertOrganisationRequest f = new SOP_VIAD_V2.SalesforceUpsertOrganisationRequest();
		SOP_VIAD_V2.SalesforceUpsertOrganisationResult g = new SOP_VIAD_V2.SalesforceUpsertOrganisationResult();
		SOP_VIAD_V2.GetCustomerOrders_element h = new SOP_VIAD_V2.GetCustomerOrders_element();
		SOP_VIAD_V2.ArrayOfCustomerOrder i = new SOP_VIAD_V2.ArrayOfCustomerOrder();
		SOP_VIAD_V2.GetOrderSummaryResponse_element j = new SOP_VIAD_V2.GetOrderSummaryResponse_element();
		SOP_VIAD_V2.Catalogue k = new SOP_VIAD_V2.Catalogue();
		SOP_VIAD_V2.CustomerOrder l = new SOP_VIAD_V2.CustomerOrder();
		SOP_VIAD_V2.OrderSummaryRequest m = new SOP_VIAD_V2.OrderSummaryRequest();
		SOP_VIAD_V2.CustomerOrdersRequest n = new SOP_VIAD_V2.CustomerOrdersRequest();
		SOP_VIAD_V2.OrderSummary o = new SOP_VIAD_V2.OrderSummary();
		SOP_VIAD_V2.GetCustomerOrdersResponse_element p = new SOP_VIAD_V2.GetCustomerOrdersResponse_element();
		SOP_VIAD_V2.GetOrderSummary_element q = new SOP_VIAD_V2.GetOrderSummary_element();
		SOP_VIAD_V2.SalesforceUpsertOrganisationResponse_elementFuture r = new SOP_VIAD_V2.SalesforceUpsertOrganisationResponse_elementFuture();
		SOP_VIAD_V2.SalesforceUpsertContactResponse_elementFuture s = new SOP_VIAD_V2.SalesforceUpsertContactResponse_elementFuture();
		SOP_VIAD_V2.BasicHttpBinding_ISOPService t = new SOP_VIAD_V2.BasicHttpBinding_ISOPService();
		try{
			t.beginSalesforceUpsertOrganisation(new system.continuation(10),'gythgjkj',f);
		} catch(Exception ex){
			system.debug(ex);
		}
		try{
			t.beginSalesforceUpsertContact(new system.continuation(10),'gythgjkj',a);
		} catch(Exception ex){
			system.debug(ex);
		}
		try{
			t.SalesforceUpsertOrganisation('gythgjkj',f);
		} catch(Exception ex){
			system.debug(ex);
		}
		try{
			t.SalesforceUpsertContact('gysdthgjkj',a);
		} catch(Exception ex){
			system.debug(ex);
		}
		try{
			t.GetCustomerOrders('gysdthgjkj',n);
		} catch(Exception ex){
			system.debug(ex);
		}
		try{
			t.GetOrderSummary('gysdthgjkj',m);
		} catch(Exception ex){
			system.debug(ex);
		}
	}
	
}