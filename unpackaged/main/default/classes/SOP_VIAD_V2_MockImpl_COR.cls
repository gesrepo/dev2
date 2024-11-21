@isTest
global class SOP_VIAD_V2_MockImpl_COR implements WebServiceMock {
    global void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType) {
                
        SOP_VIAD_V2.GetCustomerOrdersResponse_element response_x = new SOP_VIAD_V2.GetCustomerOrdersResponse_element();
        response_x.GetCustomerOrdersResult = new SOP_VIAD_V2.ArrayOfCustomerOrder();
        response.put('response_x', response_x); 
    }
}