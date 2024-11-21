@isTest(SeeAllData=true)
private class SOP_DataAccessController_TEST {
	public class SalesforceUpsertOrganisationMokup implements WebServiceMock {
        String sfID;
        public SalesforceUpsertOrganisationMokup(String SalesforceID) {
            sfID = SalesforceID;
        }

        public void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {

        SOP_VIAD_V2.SalesforceUpsertOrganisationResult suor = new SOP_VIAD_V2.SalesforceUpsertOrganisationResult();
        suor.EUSopID = 43621;
        suor.MESopID = 23231;
        suor.SalesforceID = this.sfID;
        suor.UKSopID = 23212;
        SOP_VIAD_V2.SalesforceUpsertOrganisationResponse_element respElement = new SOP_VIAD_V2.SalesforceUpsertOrganisationResponse_element();
        respElement.SalesforceUpsertOrganisationResult = suor;
        response.put('response_x', respElement); 
        }
    }
	static testMethod void testGetCatalogues() {
		Account Facility = TestDataUtil.CreateTestFacility();
		//Case Cse = TestDataUtil.CreateTestCase(Exhibitor.Id, Booth.Id, Con.Id, SalesRepOpp.Id);
		
        Test.startTest();
        PageReference pageRef = Page.ViewSOPData;
        
        //set the Visualforce page for the test  
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('acctId', Facility.Id);
        ApexPages.currentPage().getParameters().put('caseId', '');

       	SOP_DataAccessController dac = new SOP_DataAccessController();
       	SOP_APIIntegration.mockResponse = getMockCatalogueResponse();
       	dac.selectedService = 'Catalogues';
       	dac.caseId = '';
       	dac.acctId = Facility.Id
       	;
       	PageReference pr = dac.serviceRedirect();
       	System.assert(pr != null);
       	dac.getEventCatalogues();
       	dac.returnToSelect();
       	SOP_APIIntegration.mockResponse = getMockCatItemsResponse();
       	ApexPages.currentPage().getParameters().put('catId', '12345');
       	dac.showPopup = false;
       	dac.showHidePopup();
       	dac.showCatalogueParents();
       	ApexPages.currentPage().getParameters().put('parentId', '12345');
       	dac.showCatalogueChildren();
		
       	test.stopTest();
	}
	
	static testMethod void testGetOrderHistory() {
		Account Facility = TestDataUtil.CreateTestFacility();
		//Case Cse = TestDataUtil.CreateTestCase(Exhibitor.Id, Booth.Id, Con.Id, SalesRepOpp.Id);
		
        Test.startTest();
        PageReference pageRef = Page.ViewSOPData;
        
        ApexPages.currentPage().getParameters().put('acctId', Facility.Id);
        ApexPages.currentPage().getParameters().put('caseId', '');

       	SOP_DataAccessController dac = new SOP_DataAccessController();
       	SOP_APIIntegration.mockResponse = getMockCatalogueResponse();
       	dac.selectedService = 'Order History';
       	dac.caseId = '';
       	dac.acctId = Facility.Id
       	;
       	PageReference pr = dac.serviceRedirect();
       	System.assert(pr != null);
       	dac.getServiceOrderHistory();
       	SOP_APIIntegration.mockResponse = getMockOrderResponse();
       	       	
       	SOP_VIAD_V2 v = new SOP_VIAD_V2();
       	//dac.getServiceOrderHistory();
       	
       	//v.GetCustomerOrders_element = new SOP_VIAD_V2.GetCustomerOrders_element();
       	SOP_VIAD_V2.CustomerOrder co = new SOP_VIAD_V2.CustomerOrder();
   		co.Id = 1234;
    	co.ProjectName = 'test name';
    	co.InvoiceDate = date.today();
    	co.Instance = 'UK';
    	co.BasketType = '1';
    	dac.orderHistoryList = new List<SOP_APIIntegration.orderHistoryWrapper>();
    	Map<String, String> testMap = new Map<String, String>();
    	testMap.put('1', 'New');
    	dac.orderHistoryList.add(new SOP_APIIntegration.orderHistoryWrapper(co, testMap));
    	ApexPages.currentPage().getParameters().put('orderNum', '1234');
    	//SOP_APIIntegration.orderSummaryWrapper thisOrder = new SOP_APIIntegration.orderSummaryWrapper();
    	SOP_VIAD_V2.OrderSummary os = new SOP_VIAD_V2.OrderSummary();
    	dac.thisOrder = new SOP_APIIntegration.orderSummaryWrapper(os);
    	
    	try{
    		dac.getServiceOrderHistory();
    	}
    	catch(exception e){
    		
    	}
       	
       	SOP_VIAD_V2.ArrayOfCustomerOrder ArrayOfCustomerOrder = new SOP_VIAD_V2.ArrayOfCustomerOrder();
        SOP_VIAD_V2.GetOrderSummaryResponse_element GetOrderSummaryResponse_element = new SOP_VIAD_V2.GetOrderSummaryResponse_element();
       	SOP_VIAD_V2.Catalogue Catalogue = new SOP_VIAD_V2.Catalogue();
       	SOP_VIAD_V2.CustomerOrder CustomerOrder = new SOP_VIAD_V2.CustomerOrder();
       	SOP_VIAD_V2.OrderSummaryRequest OrderSummaryRequest = new SOP_VIAD_V2.OrderSummaryRequest();
       	SOP_VIAD_V2.CustomerOrdersRequest CustomerOrdersRequest = new SOP_VIAD_V2.CustomerOrdersRequest();
       	SOP_VIAD_V2.OrderSummary OrderSummary = new SOP_VIAD_V2.OrderSummary();
       	SOP_VIAD_V2.GetCustomerOrdersResponse_element GetCustomerOrdersResponse_element = new SOP_VIAD_V2.GetCustomerOrdersResponse_element();
       	SOP_VIAD_V2.GetOrderSummary_element GetOrderSummary_element = new SOP_VIAD_V2.GetOrderSummary_element();
       	SOP_VIAD_V2.BasicHttpBinding_ISOPService BasicHttpBinding_ISOPService = new SOP_VIAD_V2.BasicHttpBinding_ISOPService();
       	SOP_Data_Contract dc = new SOP_Data_Contract();
       	SOP_Data_Contract.ArrayOfOrderSummaryItem ar = new SOP_Data_Contract.ArrayOfOrderSummaryItem();
       	SOP_Data_Contract.OrderSummaryItem osi = new SOP_Data_Contract.OrderSummaryItem();
       	SOP_wwwViadComSecurityV2 sec = new SOP_wwwViadComSecurityV2();
       	SOP_wwwViadComSecurityV2.AppSessionInfo asi = new SOP_wwwViadComSecurityV2.AppSessionInfo();
       	SOP_wwwViadComSecurityV2.ArrayOfDomainInfo adi = new SOP_wwwViadComSecurityV2.ArrayOfDomainInfo();
       	SOP_wwwViadComSecurityV2.DomainInfo di = new SOP_wwwViadComSecurityV2.DomainInfo();
       	SOP_wwwViadComSecurityV2.StartAppSession_element sase = new SOP_wwwViadComSecurityV2.StartAppSession_element();
       	SOP_wwwViadComSecurityV2.StartAppSessionResponse_element sasr = new SOP_wwwViadComSecurityV2.StartAppSessionResponse_element();
       	SOP_wwwViadComSecurityV2.UserInfo ui = new SOP_wwwViadComSecurityV2.UserInfo();
       	SOP_wwwViadComSecurityV2.BasicHttpBinding_IAuthenticationService httpb = new SOP_wwwViadComSecurityV2.BasicHttpBinding_IAuthenticationService();
       	
       	dac.showPopup = false;
       	try{
       	dac.showHidePopup();       	
       	}
       	catch(exception ex){
       		
       	}
       	test.stopTest();
	}
	
    static testMethod void testStandardController(){
    	Account Facility = TestDataUtil.CreateTestFacility();
    	Case c = new Case(
    		AccountId = Facility.Id,
    		Priority = 'Low'
    	);
    	insert c;
    	test.startTest();
    	PageReference pageRef = Page.ViewSOPData;
    	Test.setCurrentPageReference(pageRef);

        ApexPages.StandardController sc = new ApexPages.standardController(c);
        SOP_DataAccessController dac = new SOP_DataAccessController(sc);
        test.stopTest();
    }

    static testMethod void LinkFromAcctTest() {
    	//Create Facility
        Account Facility = TestDataUtil.CreateTestFacility();

        Test.startTest();
        PageReference pageRef = Page.ViewSOPData;
        
        //set the Visualforce page for the test  
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('acctId', Facility.Id);
        ApexPages.currentPage().getParameters().put('caseId', '');

       	SOP_DataAccessController dac = new SOP_DataAccessController();
       	dac.selectedService = 'Order History';
       	dac.caseId = '';
       	PageReference pr = dac.serviceRedirect();
       	System.assert(pr != null);

       	Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('acctId', Facility.Id);
        ApexPages.currentPage().getParameters().put('caseId', '');

       	dac = new SOP_DataAccessController();
       	dac.selectedService = 'Catalogues';
       	pr = dac.serviceRedirect();
       	System.assert(pr != null);

       	Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('acctId', Facility.Id);
        ApexPages.currentPage().getParameters().put('caseId', '');

       	dac = new SOP_DataAccessController();
       	dac.selectedService = '--None--';
       	pr = dac.serviceRedirect();
       	System.assert(pr == null);
       	

       	Test.stopTest();

    }

    static testMethod void LinkFromCaseTest() {
    	//Create Facility
        Account Facility = TestDataUtil.CreateTestFacility();

        Test.setMock(WebServiceMock.class, new SalesforceUpsertOrganisationMokup(Facility.id));

        Account Firm = TestDataUtil.CreateTestFirm();
        Account Exhibitor = TestDataUtil.CreateTestExhibitor();
        Show__c Show = TestDataUtil.CreateTestShow(Firm.Id);
        Opportunity SalesRepOpp = TestDataUtil.CreateTestSalesRepOpp(Facility.Id, Firm.Id, Show.Id);
        Oracle_Show_Booth__c Booth = TestDataUtil.CreateTestBooth(Exhibitor.Id, SalesRepOpp.Id, SalesRepOpp.Job_Number__c, Show.Show_ID__c);
        Contact Con = TestDataUtil.CreateTestContact();
        Case Cse = TestDataUtil.CreateTestCase(Exhibitor.Id, Booth.Id, Con.Id, SalesRepOpp.Id);

        Test.startTest();
        PageReference pageRef = Page.ViewSOPData;
        
        //set the Visualforce page for the test  
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('acctId', Facility.Id);
        ApexPages.currentPage().getParameters().put('caseId', cse.Id);

       	SOP_DataAccessController dac = new SOP_DataAccessController();
       	dac.selectedService = 'Order History';
       	PageReference pr = dac.serviceRedirect();
       	System.assert(pr != null);

       	Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('acctId', Facility.Id);
        ApexPages.currentPage().getParameters().put('caseId', cse.Id);

       	dac = new SOP_DataAccessController();
       	dac.selectedService = 'Catalogues';
       	pr = dac.serviceRedirect();
       	System.assert(pr != null);

       	Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('acctId', Facility.Id);
        ApexPages.currentPage().getParameters().put('caseId', cse.Id);

       	dac = new SOP_DataAccessController();
       	dac.selectedService = '--None--';
       	pr = dac.serviceRedirect();
       	System.assert(pr == null);
       	
       	Test.stopTest();

    }
    
    private static String getMockOrderResponse(){
    	String str = '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">';
    	str += '<s:Header><ActivityId CorrelationId="3b4a64f0-e8a2-46f8-a2f3-fea67270a4ba" xmlns="http://schemas.microsoft.com/2004/09/ServiceModel/Diagnostics">f06c532f-8938-4421-88a4-d1fd6c2e19e1</ActivityId></s:Header>';
		str += '<s:Body><GetCustomerOrdersResponse xmlns="www.viad.com/v2"><GetCustomerOrdersResult xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><CustomerOrder><BasketType>2</BasketType><BasketUpdateDate>2015-06-18T16:18:00.537</BasketUpdateDate><BasketVersionNo>1</BasketVersionNo><ID>12345</ID><Instance>UK</Instance><InvoiceDate i:nil="true"/><InvoiceNo i:nil="true"/><ProjectID>10340</ProjectID><ProjectName>EUROPERIO (JUNE) 2015</ProjectName><Total>16.27</Total></CustomerOrder></GetCustomerOrdersResult></GetCustomerOrdersResponse></s:Body></s:Envelope>';
    	return str;
    }
    
    private static String getMockOrderSummaryResponse(){
    	String str = '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"><s:Header><ActivityId CorrelationId="3ed999f3-9067-408d-a680-23bb7f38dd9f" xmlns="http://schemas.microsoft.com/2004/09/ServiceModel/Diagnostics">557aad04-a7d5-4941-b1d1-60b6103c3496</ActivityId></s:Header><s:Body><GetOrderSummaryResponse xmlns="www.viad.com/v2"><GetOrderSummaryResult xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><AddressLine1>AVDA. CONSTITUCION</AddressLine1><AddressLine2/><AddressLine3/><AddressLine4/><BasketVersionNo>1</BasketVersionNo><CatalogueName>PURE 2010 - SF - 17.5%</CatalogueName><Contact>. .</Contact><Country>Spain</Country><County>03002 ALICANTE</County><Customer>HISPANITAS/PROMOCAVEX, SL</Customer><DatePlaced>2010-01-27T00:00:00</DatePlaced><Department/><EventID>3859</EventID><EventName>PURE 2010</EventName><InvoiceNo>204485</InvoiceNo><Items xmlns:a="http://schemas.datacontract.org/2004/07/Viad.Services.Public.GES.v2.DataContracts.SOP"><a:OrderSummaryItem><a:_x003C_Code_x003E_k__BackingField>.</a:_x003C_Code_x003E_k__BackingField><a:_x003C_CurrentPrice_x003E_k__BackingField>1646</a:_x003C_CurrentPrice_x003E_k__BackingField><a:_x003C_CurrentVatRate_x003E_k__BackingField>20</a:_x003C_CurrentVatRate_x003E_k__BackingField><a:_x003C_Description_x003E_k__BackingField i:nil="true"/><a:_x003C_HirePrice_x003E_k__BackingField>138</a:_x003C_HirePrice_x003E_k__BackingField><a:_x003C_HireVatRate_x003E_k__BackingField>20</a:_x003C_HireVatRate_x003E_k__BackingField><a:_x003C_Name_x003E_k__BackingField>32amp 3 phase direct main supply</a:_x003C_Name_x003E_k__BackingField><a:_x003C_Options_x003E_k__BackingField/><a:_x003C_Quantity_x003E_k__BackingField>100</a:_x003C_Quantity_x003E_k__BackingField><a:_x003C_SubTotal_x003E_k__BackingField>1784</a:_x003C_SubTotal_x003E_k__BackingField><a:_x003C_VAT_x003E_k__BackingField i:nil="true"/></a:OrderSummaryItem></items></GetOrderSummaryResult></GetOrderSummaryResponse></s:Body>';
    	return str;
    }
    
    private static String getMockCatalogueResponse(){
    	String str = '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"><s:Header><ActivityId CorrelationId="aacd522e-b31e-409c-b875-57d47040bb06" xmlns="http://schemas.microsoft.com/2004/09/ServiceModel/Diagnostics">89494327-9bc1-4d41-a20b-fe61bc261e60</ActivityId></s:Header><s:Body><GetEventCataloguesResponse xmlns="www.viad.com/v2"><GetEventCataloguesResult xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><Catalogue><CatalogueName>VIRGIN LONDON MARATHON (APRIL) 2014 - FURNITURE 20% (EP)</CatalogueName><CurrentPriveVATRate>20</CurrentPriveVATRate><DisplayEuroLines>false</DisplayEuroLines><DisplayEuroOnly>false</DisplayEuroOnly><DisplayEuroTotals>false</DisplayEuroTotals><EventID>10515</EventID><ExchangeRate>1</ExchangeRate><HirePriceVATRate>20</HirePriceVATRate><ID>23838</ID><IsDeleted>false</IsDeleted><IsMaster>false</IsMaster><StartDate>2014-04-09T00:00:00</StartDate><XmlData i:nil="true"/></Catalogue></GetEventCataloguesResult></GetEventCataloguesResponse></s:Body></s:Envelope>';
    	return str;
    }
    
    private static String getMockCatItemsResponse(){
    	String str = '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"><s:Header><ActivityId CorrelationId="1589766d-dba2-434a-88c2-d7f261ff29f7" xmlns="http://schemas.microsoft.com/2004/09/ServiceModel/Diagnostics">cabc00d4-67fc-4f5c-bd0e-362b5c677e6f</ActivityId></s:Header><s:Body><GetCatalogueItemsResponse xmlns="www.viad.com/v2"><GetCatalogueItemsResult xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><Item><Code>FURNITURE (NEC)</Code><CurrentPrice i:nil="true"/><CurrentVatRate i:nil="true"/><HirePrice i:nil="true"/><HireVatRate i:nil="true"/><ID>12345</ID><ItemType>1</ItemType><Name>Hire - Furniture (NEC)</Name><ParentID i:nil="true"/><Pricing i:nil="true"/><ShortDescription i:nil="true"/></Item><Item><Code>Desking/Storage</Code><CurrentPrice i:nil="true"/><CurrentVatRate i:nil="true"/><HirePrice i:nil="true"/><HireVatRate i:nil="true"/><ID>1613</ID><ItemType>1</ItemType><Name>Desking/Storage</Name><ParentID>12345</ParentID><Pricing i:nil="true"/><ShortDescription i:nil="true"/></Item></GetCatalogueItemsResult></GetCatalogueItemsResponse></s:Body></s:Envelope>';
    	return str;
    }
}