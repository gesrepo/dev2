//Generated by FuseIT WSDL2Apex (http://www.fuseit.com/Solutions/SFDC-Explorer/Help-WSDL-Parser.aspx)
//Methods Included: SubmitShowOrgOrder, ProcessShowOrgOrderBatch, ProcessShowOrgOrder
//Methods Excluded: SubmitOrder, ResubmitOrder, GetBoothOrders, GetBoothAreaOrders, GetShowCustomerOrders, GetShowOrders, GetProjectOrders, GetOrderByOrderHeaderId, GetHeldProjectOrders, GetHeldShowOrders, GetHeldBoothOrders, GetHeldShowCustomerOrders, GetHeldProjectOrdersByStatus, SubmitCreditCardInformation, CancelOrder, ReleaseHold, ApplyHold, GetOrderAndSqrCounts, GetPaymentRestrictions, GetOrderPaymentInformation, ListShowElectricalOrdersAsXML, GetAddToOrderChoices
// Primary Port Class Name: BasicHttpBinding_IOrderService
public class CORE_ORDER {
    public class BasicHttpBinding_IOrderService {
        public String endpoint_x = GC_CoreUtils.getAPIEndpoint() + '/GES/v3/OrderService.svc';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        //public Integer timeout_x = 60000;
        // Adding timeout to 5 minutes per GES's direction.
        // We're limited to 2 minutes per Salesforce limitation
        public Integer timeout_x = 120000;
        private String[] ns_map_type_info = new String[]{'www.viad.com/v3','wwwViadComV3_v1 ','http://schemas.microsoft.com/2003/10/Serialization/Arrays','schemasMicrosoftCom200310Serializat_v1','http://schemas.datacontract.org/2004/07/Viad.Services.Public.GES.v3.FaultContracts.Order','schemasDatacontractOrg200407ViadSe_v1','http://schemas.microsoft.com/2003/10/Serialization/','CORE_SERIALIZATION','www.viad.com/data/v3','wwwViadComDataV3_v1'};

        public wwwViadComDataV3_v1.ShowOrgOrderEntryStatus ProcessShowOrgOrder() {
            wwwViadComV3_v1.ProcessShowOrgOrder_element request_x = new wwwViadComV3_v1.ProcessShowOrgOrder_element();
            wwwViadComV3_v1.ProcessShowOrgOrderResponse_element response_x;
            Map<String, wwwViadComV3_v1.ProcessShowOrgOrderResponse_element> response_map_x = new Map<String, wwwViadComV3_v1.ProcessShowOrgOrderResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                this,
                request_x,
                response_map_x,
                new String[]{endpoint_x,
                'www.viad.com/v3/IOrderService/ProcessShowOrgOrder',
                'www.viad.com/v3',
                'ProcessShowOrgOrder',
                'www.viad.com/v3',
                'ProcessShowOrgOrderResponse',
                'wwwViadComV3_v1.ProcessShowOrgOrderResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.ProcessShowOrgOrderResult;
        }

        public wwwViadComDataV3_v1.ArrayOfShowOrgOrderEntryStatus ProcessShowOrgOrderBatch(wwwViadComV3_v1.ProcessShowOrgOrderBatch_element request) {
            wwwViadComV3_v1.ProcessShowOrgOrderBatch_element request_x = request;
            wwwViadComV3_v1.ProcessShowOrgOrderBatchResponse_element response_x;
            Map<String, wwwViadComV3_v1.ProcessShowOrgOrderBatchResponse_element> response_map_x = new Map<String, wwwViadComV3_v1.ProcessShowOrgOrderBatchResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                this,
                request_x,
                response_map_x,
                new String[]{endpoint_x,
                'www.viad.com/v3/IOrderService/ProcessShowOrgOrderBatch',
                'www.viad.com/v3',
                'ProcessShowOrgOrderBatch',
                'www.viad.com/v3',
                'ProcessShowOrgOrderBatchResponse',
                'wwwViadComV3_v1.ProcessShowOrgOrderBatchResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.ProcessShowOrgOrderBatchResult;
        }

        public wwwViadComDataV3_v1.ArrayOfShowOrgOrderEntryStatus ProcessShowOrgOrderBatch() {
            wwwViadComV3_v1.ProcessShowOrgOrderBatch_element request_x = new wwwViadComV3_v1.ProcessShowOrgOrderBatch_element();
            return ProcessShowOrgOrderBatch(request_x);
        }

        public wwwViadComDataV3_v1.ShowOrgOrderEntryStatus SubmitShowOrgOrder(wwwViadComV3_v1.SubmitShowOrgOrder_element request) {
            
            wwwViadComV3_v1.SubmitShowOrgOrder_element request_x = request;
            wwwViadComV3_v1.SubmitShowOrgOrderResponse_element response_x;
            system.debug('submitted request from new WSDL wwwViadComDataV3_v1.ShowOrgOrderEntryStatus SubmitShowOrgOrder is thisrequest_x==='+request_x);
            Map<String, wwwViadComV3_v1.SubmitShowOrgOrderResponse_element> response_map_x = new Map<String, wwwViadComV3_v1.SubmitShowOrgOrderResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                this,
                request_x,
                response_map_x,
                new String[]{endpoint_x,
                'www.viad.com/v3/IOrderService/SubmitShowOrgOrder',
                'www.viad.com/v3',
                'SubmitShowOrgOrder',
                'www.viad.com/v3',
                'SubmitShowOrgOrderResponse',
                'wwwViadComV3_v1.SubmitShowOrgOrderResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.SubmitShowOrgOrderResult;
        }

        public wwwViadComDataV3_v1.ShowOrgOrderEntryStatus SubmitShowOrgOrder() {
            wwwViadComV3_v1.SubmitShowOrgOrder_element request_x = new wwwViadComV3_v1.SubmitShowOrgOrder_element();
            return SubmitShowOrgOrder(request_x);
        }
    }
}