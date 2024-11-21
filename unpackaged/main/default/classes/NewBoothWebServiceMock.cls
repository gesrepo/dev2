@isTest
global class NewBoothWebServiceMock implements WebServiceMock {
    
    public String methodToTest;
    
    global NewBoothWebServiceMock(final String methodToTest){
        this.methodToTest = methodToTest;
    }
    
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
                        
            if(methodToTest == 'SessionLogin'){
            if(requestName == 'StartAppSession')
                {
                wwwViadComSecurityV2.StartAppSessionResponse_element resp = new wwwViadComSecurityV2.StartAppSessionResponse_element();
                resp.StartAppSessionResult = new wwwViadComSecurityV2.AppSessionInfo();
                resp.StartAppSessionResult.SessionID  = 'TestSessionId';            
                response.put('response_x', resp);
                }
            }
        }
}