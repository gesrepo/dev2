@isTest
global class DiscountWebServiceMock implements WebServiceMock {
    
    public String methodToTest;
    
    global DiscountWebServiceMock(final String methodToTest){
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
            if(methodToTest == 'DiscountSubmission')
            {
                if(requestName == 'StartAppSession')
                {
                wwwViadComSecurityV2.StartAppSessionResponse_element resp = new wwwViadComSecurityV2.StartAppSessionResponse_element();
                resp.StartAppSessionResult = new wwwViadComSecurityV2.AppSessionInfo();
                resp.StartAppSessionResult.SessionID  = 'TestSessionId';            
                response.put('response_x', resp);
                } else if(requestName == 'UserLoginWithoutPassword')
                {
                wwwViadComSecurityV2.UserLoginWithoutPasswordResponse_element resp = new wwwViadComSecurityV2.UserLoginWithoutPasswordResponse_element();
                resp.UserLoginWithoutPasswordResult = new wwwViadComSecurityV2.AppSessionInfo();
                resp.UserLoginWithoutPasswordResult.SessionID  = 'TestSessionId';            
                response.put('response_x', resp);
                }
                
                /*f(requestName == 'SubmitDiscount')
                {
                wwwViadComSecurityV2.StartAppSessionResponse_element resp = new wwwViadComSecurityV2.StartAppSessionResponse_element();
                resp.StartAppSessionResult = new wwwViadComSecurityV2.AppSessionInfo();
                resp.StartAppSessionResult.SessionID  = 'TestSessionId';            
                response.put('response_x', resp);
                }*/
                 
            }
             else if(methodToTest == 'SubmitDiscount'){
                wwwViadComV2.SubmitBoothAreaDiscountResponse_element  resp= new wwwViadComV2.SubmitBoothAreaDiscountResponse_element();
                resp.SubmitBoothAreaDiscountResult = new wwwViadComV2.BoothAreaDiscount();
                response.put('response_x', resp);
            }
            else if(methodToTest == 'UpdateDiscount'){
                wwwViadComV2.UpdateBoothAreaDiscountResponse_element  resp= new wwwViadComV2.UpdateBoothAreaDiscountResponse_element();
                resp.UpdateBoothAreaDiscountResult = new wwwViadComV2.BoothAreaDiscount();
                response.put('response_x', resp);
            }
            else if(methodToTest == 'DeleteDiscount'){
                wwwViadComV2.DeleteBoothAreaDiscountResponse_element  resp= new wwwViadComV2.DeleteBoothAreaDiscountResponse_element();
                resp.DeleteBoothAreaDiscountResult = new wwwViadComV2.BoothAreaDiscount();
                response.put('response_x', resp);
            }
            
        }
}