@isTest
global class SOP_VIAD_V2_MockImpl_OSR implements WebServiceMock {
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
                
        SOP_VIAD_V2.GetOrderSummaryResponse_element response_x = new SOP_VIAD_V2.GetOrderSummaryResponse_element();
        response_x.GetOrderSummaryResult = new SOP_VIAD_V2.OrderSummary();
        response.put('response_x', response_x); 
    }
}