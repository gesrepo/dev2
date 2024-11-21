@isTest
global class SOP_VIAD_V2_MockImpl_UCR implements WebServiceMock {
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
                
        SOP_VIAD_V2.SalesforceUpsertContactResponse_element response_x = new SOP_VIAD_V2.SalesforceUpsertContactResponse_element();
        response.put('response_x', response_x); 
    }
}