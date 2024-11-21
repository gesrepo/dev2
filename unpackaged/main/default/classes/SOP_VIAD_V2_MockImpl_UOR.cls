@isTest
global class SOP_VIAD_V2_MockImpl_UOR implements WebServiceMock {
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
                
        SOP_VIAD_V2.SalesforceUpsertOrganisationResponse_element response_x = new SOP_VIAD_V2.SalesforceUpsertOrganisationResponse_element();
        response_x.SalesforceUpsertOrganisationResult = new SOP_VIAD_V2.SalesforceUpsertOrganisationResult();
        response.put('response_x', response_x); 
    }
}