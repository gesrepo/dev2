/****************************************************************
* Author: Karthik N, Created: 9/25/2017 
* This Class Reimplements WebServiceMock to fake responses for 
* test class that tests RefreshBoothArea
*****************************************************************/
@isTest
global class RefreshBoothWebServiceMock implements WebServiceMock {
    
    public String methodToTest;
    
    global RefreshBoothWebServiceMock(final String methodToTest){
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
            
            if(methodToTest == 'RefreshMethod'){
                if(requestName == 'StartAppSession')
                {
                    wwwViadComSecurityV2.StartAppSessionResponse_element resp = new wwwViadComSecurityV2.StartAppSessionResponse_element();
                    resp.StartAppSessionResult = new wwwViadComSecurityV2.AppSessionInfo();
                    resp.StartAppSessionResult.SessionID  = 'TestSessionId';            
                    response.put('response_x', resp);
                }
                else if(requestName == 'UserLoginWithoutPassword')
                {
                    wwwViadComSecurityV2.UserLoginWithoutPasswordResponse_element resp = new wwwViadComSecurityV2.UserLoginWithoutPasswordResponse_element();
                    resp.UserLoginWithoutPasswordResult = new wwwViadComSecurityV2.AppSessionInfo();
                    resp.UserLoginWithoutPasswordResult.SessionID  = 'TestSessionId';     
                    response.put('response_x', resp);
                }
                else if(requestName == 'GetProjectByProjectNumber')
                {
                    wwwViadComV2.GetProjectByProjectNumberResponse_element resp = new wwwViadComV2.GetProjectByProjectNumberResponse_element();
                    resp.GetProjectByProjectNumberResult =  new wwwViadComV2.ShowProject();
                    wwwViadComV2.ArrayOfBoothArea aba = new wwwViadComV2.ArrayOfBoothArea();
                    wwwViadComV2.BoothArea testBooth =  new wwwViadComV2.BoothArea();
                    testBooth.DisplaySequence = 123;//test sequence
                    testBooth.Area = 'Test Booth';
                    testBooth.BoothAreaId = 2345;
                    testBooth.CompletionDateTime = System.Today();
                    testBooth.DeliveryDateTime = System.Today();
                    testBooth.DeliveryLocation = 'Bangalore';
                    testBooth.FacilityId = 123;
                    testBooth.RemovalDateTime = system.today();
                    testBooth.ShowOccrCustomerId = 349334;
                    testBooth.ZoneId = 'B1';
                    testBooth.DisplaySequence = 3456;
                    testBooth.Operations = null;
                    //testBooth.ShowId;
                    testBooth.Editable = true;
                    testBooth.Deleteable = false;
                    testBooth.GroupOrdersByCategory = true;
                    aba.BoothArea = new wwwViadComV2.BoothArea[] {testBooth};
                    resp.GetProjectByProjectNumberResult.BoothAreas = aba;
                    response.put('response_x', resp);
                }
            }
            
        }
}