public with sharing class SOP_APIIntegration {
    
    public static String mockResponse;
    public static Map<String, String> basketTypeMap {get;set;}
    
    //final static string SOP_ENDPOINT = 'https://uatapi.viad.com/GES/v2/SOPService.svc';
    final static string SOP_ENDPOINT = SOPService__c.getInstance('Default').URL__c;

    //final static string SOP_CATALOG_ITEMS_ENDPOINT = 'https://api.viad.com/GES/v2/SOPService.svc';
    private static List<Map<String, String>> MapList = new List<Map<String, String>>();
    
    private static SOP_VIAD_V2.BasicHttpBinding_ISOPService c;
    private enum XmlDocParsing {NONE , GetResult}
    
    // MW 25th November 2015
    public static SOP_VIAD_V2.SalesforceUpsertOrganisationResult UpsertOrganisation(string sessionId, string upsertSerialisedRequest)
    {   
        SOP_VIAD_V2.SalesforceUpsertOrganisationRequest upsertRequest = (SOP_VIAD_V2.SalesforceUpsertOrganisationRequest)JSON.deserialize(upsertSerialisedRequest, SOP_VIAD_V2.SalesforceUpsertOrganisationRequest.class);

        
        SOP_VIAD_V2.BasicHttpBinding_ISOPService sopService = new SOP_VIAD_V2.BasicHttpBinding_ISOPService();
        SOP_VIAD_V2.SalesforceUpsertOrganisationResult sfuor;
        try {
            sfuor = sopService.SalesforceUpsertOrganisation(sessionId, upsertRequest);
            System.debug(sfuor);
        } catch(Exception e){
            system.debug(e);
        }
        return sfuor;
    }
    
        // MW 1st December 2015
    public static string UpsertContact(string sessionId, string upsertSerialisedRequest)
    {   
        SOP_VIAD_V2.SalesforceUpsertContactRequest upsertRequest;
        try {
         upsertRequest = (SOP_VIAD_V2.SalesforceUpsertContactRequest)JSON.deserialize(upsertSerialisedRequest, SOP_VIAD_V2.SalesforceUpsertContactRequest.class);
        } catch(Exception e) {
            system.debug(e);
        }
        
        SOP_VIAD_V2.BasicHttpBinding_ISOPService sopService = new SOP_VIAD_V2.BasicHttpBinding_ISOPService();
        String sfucr;
        try {
            sfucr = sopService.SalesforceUpsertContact(sessionId, upsertRequest);
            System.debug(sfucr);
        } catch(Exception e) {
            system.debug(e);
        }
        return sfucr;
        
    }
    
    public static SOP_wwwViadComSecurityV2.AppSessionInfo authenticate(string userName , string pwd){
        SOP_wwwViadComSecurityV2.AppSessionInfo sessionInfo;
        try{
            SOP_wwwViadComSecurityV2.BasicHttpBinding_IAuthenticationService s = new SOP_wwwViadComSecurityV2.BasicHttpBinding_IAuthenticationService();
            SOP_wwwViadComSecurityV2.AppSessionInfo a = s.StartAppSession(userName, pwd, '', '');
            sessionInfo = a;
        }
        catch(exception e){
            system.debug('*******************AUTHENTICATION ERROR: '+e.getMessage());
        }
        if(sessionInfo == null)
            system.debug('sessionInfo is null');
        else
        {
        if(sessionInfo.SessionId == null){
            system.debug('*******************AUTHENTICATION ERROR: No valid session Id was returned.');
            return null;
        }
        else{
            return sessionInfo;
        }
        }
        return null;
    }
    
    public static List<orderHistoryWrapper> getServiceOrderHistory(String sessionId, String accountId){
        List<orderHistoryWrapper> orderHistoryList;
        if(basketTypeMap == null){
            basketTypeMap = new Map<String, String>();
            List<BasketTypeMap__c> btmList = BasketTypeMap__c.getall().values();
            for(BasketTypeMap__c btm : btmList){
                if(!basketTypeMap.containsKey(btm.Key__c)){
                    basketTypeMap.put(btm.Key__c, btm.Value__c);
                }
            }
        }
        try{
            c = new SOP_VIAD_V2.BasicHttpBinding_ISOPService();
            SOP_VIAD_V2.CustomerOrdersRequest o = new SOP_VIAD_V2.CustomerOrdersRequest();
            o.SalesforceID = accountId;
            SOP_VIAD_V2.ArrayOfCustomerOrder ac = c.GetCustomerOrders(sessionId, o);
            orderHistoryList = new List<orderHistoryWrapper>();
            for(SOP_VIAD_V2.CustomerOrder cos : ac.CustomerOrder){
                if(orderHistoryList.size() < 1000){
                    orderHistoryList.add(new orderHistoryWrapper(cos, basketTypeMap));
                }
                else{
                    break;
                }
            }
        }
        catch(exception e){
            system.debug('******************ERROR: '+String.valueOf(e));
        }
        return orderHistoryList;
    }
    
    public static orderSummaryWrapper getServiceOrderSummary(String sessionId, Integer orderNo, String instance){
        c = new SOP_VIAD_V2.BasicHttpBinding_ISOPService();
        SOP_VIAD_V2.OrderSummaryRequest os = new SOP_VIAD_V2.OrderSummaryRequest();
        os.OrderNo = orderNo;
        os.SopInstance = instance;
        SOP_VIAD_V2.OrderSummary ss = c.GetOrderSummary(sessionId, os);
        orderSummaryWrapper thisOrder = new orderSummaryWrapper(ss);
        return thisOrder;
    }
    //Dependent on getServiceOrderSummary service
    public static List<orderSummaryItemWrapper> getServiceOrderItems(String sessionId, String instance, orderSummaryWrapper thisOrder){
        //c = new SOP_VIAD_V2.BasicHttpBinding_ISOPService();
        List<orderSummaryItemWrapper> osiList = new List<orderSummaryItemWrapper>();
        if(!thisOrder.Items.OrderSummaryItem.isEmpty()){
            List<SOP_Data_Contract.OrderSummaryItem> itemList = new List<SOP_Data_Contract.OrderSummaryItem>();
            itemList = thisOrder.Items.OrderSummaryItem;
            for(SOP_Data_Contract.OrderSummaryItem i : itemList){
                osiList.add(new orderSummaryItemWrapper(i));
            }
        }
        return osiList;
    }
    
    public static List<EventCatalogueWrapper> getEventCatalogRequest(String sessionId, String eventId, String instance){
        List<EventCatalogueWrapper> tempWrapper = new List<EventCatalogueWrapper>();
        string xmlString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v2="www.viad.com/v2">';
        xmlString += '<soapenv:Header/>';
        xmlString += '<soapenv:Body>';
        xmlString += '<v2:GetEventCatalogues>';
        xmlString += '<v2:applicationSessionId>'+sessionId+'</v2:applicationSessionId>';
        xmlString += '<v2:cataloguesRequest>';
        xmlString += '<v2:EventID>'+eventId+'</v2:EventID>';
        xmlString += '<v2:SopInstance>'+instance+'</v2:SopInstance>';
        xmlString += '</v2:cataloguesRequest>';
        xmlString += '</v2:GetEventCatalogues>';
        xmlString += '</soapenv:Body>';
        xmlString += '</soapenv:Envelope>';
        try{
            String body;
            if(!test.isRunningTest()){
                body = SendHttpRequest(SOP_ENDPOINT, xmlString , XmlDocParsing.NONE, 'www.viad.com/v2/ISOPService/GetEventCatalogues');
            }
            else{
                body = mockResponse;
            }
            Dom.Document doc = new Dom.Document();
            doc.load(body);
            String soapNS = 'http://schemas.xmlsoap.org/soap/envelope/';
            dom.XmlNode envelope = doc.getRootElement();
            dom.XmlNode header = envelope.getChildElement('Body', soapNS);
            walkThrough(header.getChildElements());
            for(Map<String, String> m : mapList){
                tempWrapper.add(new EventCatalogueWrapper(m));
            }
        }
        catch(exception e){
            return null;
        }
        //system.debug('********************tempWrapper: '+tempWrapper);
        return tempWrapper;
    }
    
    public static List<EventCatalogueItemWrapper> getEventCatalogItemsRequest(String sessionId, String catalogueId, String instance){
        List<EventCatalogueItemWrapper> tempWrapper = new List<EventCatalogueItemWrapper>();
        string xmlString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v2="www.viad.com/v2">';
        xmlString += '<soapenv:Header/>';
        xmlString += '<soapenv:Body>';
        xmlString += '<v2:GetCatalogueItems>';
        xmlString += '<v2:applicationSessionId>'+sessionId+'</v2:applicationSessionId>';
        xmlString += '<v2:itemsRequest>';
        xmlString += '<v2:CatalogueID>'+catalogueId+'</v2:CatalogueID>';
        xmlString += '<v2:SopInstance>'+instance+'</v2:SopInstance>';
        xmlString += '</v2:itemsRequest>';
        xmlString += '</v2:GetCatalogueItems>';
        xmlString += '</soapenv:Body>';
        xmlString += '</soapenv:Envelope>';
        try{
            String body;
            if(!test.isRunningTest()){
                body = SendHttpRequest(SOP_ENDPOINT, xmlString , XmlDocParsing.NONE, 'www.viad.com/v2/ISOPService/GetCatalogueItems');
            }
            else{
                body = mockResponse;
            }
            Dom.Document doc = new Dom.Document();
            doc.load(body);
            String soapNS = 'http://schemas.xmlsoap.org/soap/envelope/';
            dom.XmlNode envelope = doc.getRootElement();
            dom.XmlNode header = envelope.getChildElement('Body', soapNS);
            walkThrough(header.getChildElements());
            for(Map<String, String> m : mapList){
                tempWrapper.add(new EventCatalogueItemWrapper(m));
            }
                
        }
        catch(exception e){
            return null;
        }
        //system.debug('********************tempWrapper: '+tempWrapper);

        return tempWrapper;
    }
    
    private static String SendHttpRequest(string useEndPoint, string SoapBody, XmlDocParsing docParsing, string SOAPAction) {
    
        string ENDPOINT = useEndPoint ;
        Http h = new http();
        HttpRequest req = new HttpRequest();
        req.setHeader('Content-Type', 'text/xml; charset=utf-8');
        req.setHeader('SOAPAction', SOAPAction);
        req.setEndpoint(ENDPOINT);
        req.setMethod('POST');
        string body;
        try{
            //System.Debug ('***: ' + SoapBody);
            req.setBody(SoapBody);
            //system.debug('Requst Body was:  ' + req.getBody ());
            HttpResponse res = h.send(req);
            //system.debug('Body was:  ' + res);
            //system.debug('String was:' + res.getBody());          
            body = res.getBody();
        } 
        catch (Exception ex) {
            System.Debug ('***: ' + ex.getMessage() );          
            return null;
        }
        //system.debug('******************BODY: '+body);
        return body;
    }
    
    public static void walkThrough(List<DOM.XMLNode> nodes){
        Map<String, String> tempMap;
        for(DOM.XMLNode node : nodes){
            List<DOM.XMLNode> temp = node.getChildElements();
            if(temp.isEmpty()){
                tempMap = tempMap == null ? new Map<String, String>() : tempMap;
                if(node.getNodeType() == DOM.XMLNodeType.ELEMENT){
                    tempMap.put(node.getName().trim(), node.getText());
                }
            }
            else{
                walkThrough(node.getChildElements());
            }
        }
        if(tempMap != null){
            mapList.add(tempMap);
        }
    }
    
    
    public class EventCatalogueWrapper{
        
        public String CatalogueName {get;set;}
        public integer CurrentPriveVATRate {get;set;}
        public String EventID {get;set;}
        public integer ExchangeRate {get;set;}
        public integer HirePriceVATRate {get;set;}
        public String ID {get;set;}
        public Date StartDate {get;set;}
        
        public EventCatalogueWrapper(Map<String, String> thisMap){
            for(String s : thisMap.keySet()){
                if(s == 'CatalogueName'){
                    CatalogueName = thisMap.get(s);
                }
                else if(s == 'CurrentPriveVATRate'){
                    CurrentPriveVATRate = integer.valueOf(thisMap.get(s));
                }
                else if(s == 'EventID'){
                    EventID = thisMap.get(s);
                }
                else if(s == 'ExchangeRate'){
                    ExchangeRate = integer.valueOf(thisMap.get(s));
                }
                else if(s == 'HirePriceVATRate'){
                    HirePriceVATRate = integer.valueOf(thisMap.get(s));
                }
                else if(s == 'ID'){
                    ID = thisMap.get(s);
                }
                else if(s == 'StartDate'){
                    StartDate = Date.valueOf(thisMap.get(s));
                }
            }
        }
    }
    
    public class EventCatalogueItemWrapper{
        
        public String Code {get;set;}
        public String CurrentPrice {get;set;}
        public String CurrentVatRate {get;set;}
        public String HirePrice {get;set;}
        public String HireVatRate {get;set;}
        public String ID {get;set;}
        public String ItemType {get;set;}
        public String Name {get;set;}
        public String ParentID {get;set;}
        public String Pricing {get;set;}
        public String ShortDescription {get;set;}   
        
        public EventCatalogueItemWrapper(Map<String, String> thisMap){
            for(String s : thisMap.keySet()){
                if(s == 'Code'){
                    Code = thisMap.get(s);
                }
                else if(s == 'CurrentVatRate'){
                    CurrentVatRate = thisMap.get(s);
                }
                else if(s == 'CurrentPrice'){
                    CurrentPrice = thisMap.get(s);
                }
                else if(s == 'HirePrice'){
                    HirePrice = thisMap.get(s);
                }
                else if(s == 'HireVatRate'){
                    HireVatRate = thisMap.get(s);
                }
                else if(s == 'ID'){
                    ID = thisMap.get(s);
                }
                else if(s == 'ItemType'){
                    ItemType = thisMap.get(s);
                }
                else if(s == 'Name'){
                    Name = thisMap.get(s);
                }
                else if(s == 'ParentID'){
                    ParentID = thisMap.get(s);
                }
                else if(s == 'Pricing'){
                    Pricing = thisMap.get(s);
                }
                else if(s == 'ShortDescription'){
                    ShortDescription = thisMap.get(s);
                }
            }
        }
    }
    
    public class orderHistoryWrapper{
        
        public Integer orderNo {get; private set;}
        public String projectName {get; private set;}
        public DateTime invoiceDate {get; private set;}
        public String instance {get; private set;}
        public String BasketType {get; private set;}
        public orderHistoryWrapper(SOP_VIAD_V2.CustomerOrder co, Map<String, String> btMap){
            if(co != null){
                orderNo = co.Id;
                projectName = co.ProjectName;
                invoiceDate = co.InvoiceDate;
                instance = co.Instance;
                try{
                    BasketType = btMap.get(co.BasketType.trim());
                }
                catch(exception e){
                    system.debug('*****************EXCEPTION: '+e.getMessage());
                    BasketType = 'N/A';
                }
            }
        }
    }
    
    public class orderSummaryWrapper{
        
        public String AddressLine1 {get; private set;}
        public String AddressLine2 {get; private set;}
        public String AddressLine3 {get; private set;}
        public String AddressLine4 {get; private set;}
        public Integer BasketVersionNo {get; private set;}
        public String CatalogueName {get; private set;}
        public String Contact {get; private set;}
        public String Country {get; private set;}
        public String County {get; private set;}
        public String Customer {get; private set;}
        public DateTime DatePlaced {get; private set;}
        public String orderPlaced {get; private set;}
        public String Department {get; private set;}
        public Integer EventID {get; private set;}
        public String EventName {get; private set;}
        public Integer InvoiceNo {get; private set;}
        public SOP_Data_Contract.ArrayOfOrderSummaryItem Items {get; private set;}
        public Double NettTotal {get; private set;}
        public Integer OrderNo {get; private set;}
        public String Postcode {get; private set;}
        public String StandNo {get; private set;}
        public String State {get; private set;}
        public Double SurchargesAndDiscounts {get; private set;}
        public Double TotalExcludingtVAT {get; private set;}
        public Double TotalLineItems {get; private set;}
        public String Town {get; private set;}
        public Double VAT {get; private set;}
        
        public orderSummaryWrapper(SOP_VIAD_V2.OrderSummary os){
             AddressLine1 = os.AddressLine1;
             AddressLine2 = os.AddressLine2;
             AddressLine3 = os.AddressLine3;
             AddressLine4 = os.AddressLine4;
             BasketVersionNo = os.BasketVersionNo;
             CatalogueName = os.CatalogueName;
             Contact = os.Contact;
             Country = os.Country;
             County = os.County;
             Customer = os.Customer;
             orderPlaced = os.DatePlaced == null ? null : os.DatePlaced.format();
             DatePlaced = os.DatePlaced;
             Department = os.Department;
             EventID = os.EventID;
             EventName = os.EventName;
             InvoiceNo = os.InvoiceNo;
             Items = os.Items;
             NettTotal = os.NettTotal;
             OrderNo = os.OrderNo;
             Postcode = os.Postcode;
             StandNo = os.StandNo;
             State = os.State;
             SurchargesAndDiscounts = os.SurchargesAndDiscounts;
             TotalExcludingtVAT = os.TotalExcludingtVAT;
             TotalLineItems = os.TotalLineItems;
             Town = os.Town;
             VAT = os.VAT;
        }
    }
    
    public class orderSummaryItemWrapper{
        
        public String Code{get; private set;}
        public Double CurrentPrice{get; private set;}
        public Double CurrentVatRate{get; private set;}
        public String Description{get; private set;}
        public Double HirePrice{get; private set;}
        public Double HireVatRate{get; private set;}
        public String Name{get; private set;}
        public String Options{get; private set;}
        public Integer Quantity{get; private set;}
        public Double SubTotal{get; set;}
        public Double VAT{get; private set;}
        
        public orderSummaryItemWrapper(SOP_Data_Contract.OrderSummaryItem item){
            Code = item.x_x003C_Code_x003E_k_xBackingField;
            CurrentPrice = item.x_x003C_CurrentPrice_x003E_k_xBackingField;
            CurrentVatRate = item.x_x003C_CurrentVatRate_x003E_k_xBackingField;
            Description = item.x_x003C_Description_x003E_k_xBackingField;
            HirePrice = item.x_x003C_HirePrice_x003E_k_xBackingField;
            HireVatRate = item.x_x003C_HireVatRate_x003E_k_xBackingField;
            Name = item.x_x003C_Name_x003E_k_xBackingField;
            Options = item.x_x003C_Options_x003E_k_xBackingField;
            Quantity = item.x_x003C_Quantity_x003E_k_xBackingField;
            SubTotal = item.x_x003C_SubTotal_x003E_k_xBackingField;
            VAT = item.x_x003C_VAT_x003E_k_xBackingField;
        }
    }
}