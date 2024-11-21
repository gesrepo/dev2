/****************************************************************
* Author: Karthik N, Created: 9/25/2017 
* This Class Reimplements WebServiceMock to fake responses for 
* test class that tests TestBoothAreaSubmission
*****************************************************************/
@isTest
global class BoothAreaWebServiceMock implements WebServiceMock {
    
    public String methodToTest;
    
    global BoothAreaWebServiceMock(final String methodToTest){
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
                else if(requestName == 'UserLoginWithoutPassword')
                {
                wwwViadComSecurityV2.UserLoginWithoutPasswordResponse_element resp = new wwwViadComSecurityV2.UserLoginWithoutPasswordResponse_element();
                resp.UserLoginWithoutPasswordResult = new wwwViadComSecurityV2.AppSessionInfo();
                resp.UserLoginWithoutPasswordResult.SessionID  = 'TestSessionId';            
                response.put('response_x', resp);
                }
            }
            else if(methodToTest == 'GetDispalySequence'){
                wwwViadComV2.GetProjectByProjectNumberResponse_element resp= new wwwViadComV2.GetProjectByProjectNumberResponse_element();
                wwwViadComV2.ArrayOfBoothArea aba = new wwwViadComV2.ArrayOfBoothArea();
                wwwViadComV2.BoothArea testBooth =  new wwwViadComV2.BoothArea();
                testBooth.DisplaySequence = 123;//test sequence
                aba.BoothArea = new wwwViadComV2.BoothArea[] {testBooth};
                    
                    resp.GetProjectByProjectNumberResult = new wwwViadComV2.ShowProject();
                resp.GetProjectByProjectNumberResult.BoothAreas = aba;
                response.put('response_x', resp);
            }
            else if(methodToTest == 'ShowOccurCustomerDisplay'){
                wwwViadComV2.GetProjectByProjectNumberResponse_element resp= new wwwViadComV2.GetProjectByProjectNumberResponse_element();
                wwwViadComV2.ArrayOfBoothArea aba = new wwwViadComV2.ArrayOfBoothArea();
                wwwViadComV2.BoothArea testBooth =  new wwwViadComV2.BoothArea();
                testBooth.ShowOccrCustomerId = 456;//test occr cust id
                aba.BoothArea = new wwwViadComV2.BoothArea[] {testBooth};
                    
                    resp.GetProjectByProjectNumberResult = new wwwViadComV2.ShowProject();
                resp.GetProjectByProjectNumberResult.BoothAreas = aba;
                response.put('response_x', resp);
            }
            else if(methodToTest == 'SubmitBoothArea'){
                wwwViadComV2.SubmitBoothAreaResponse_element resp= new wwwViadComV2.SubmitBoothAreaResponse_element();
                resp.SubmitBoothAreaResult = new wwwViadComV2.BoothArea();
                response.put('response_x', resp);
            }else if(methodToTest == 'SubmitBoothAreas'){
                wwwViadComV2.SubmitBoothAreasResponse_element resp= new wwwViadComV2.SubmitBoothAreasResponse_element();
                //resp.SubmitBoothAreaResult = new wwwViadComV2.BoothArea();
                response.put('response_x', resp);
            }
            else if(methodToTest == 'UpdateBoothArea'){
                wwwViadComV2.UpdateBoothAreaResponse_element resp= new wwwViadComV2.UpdateBoothAreaResponse_element();
                resp.UpdateBoothAreaResult = new wwwViadComV2.BoothArea();
                response.put('response_x', resp);
            }
            else if(methodToTest == 'DeleteBoothArea'){
                wwwViadComV2.DeleteBoothAreaResponse_element resp= new wwwViadComV2.DeleteBoothAreaResponse_element();
                resp.DeleteBoothAreaResult = new wwwViadComV2.BoothArea();
                response.put('response_x', resp);
            }else if(methodToTest == 'GetProjectByProjectNumber'){
                wwwViadComV2.GetProjectByProjectNumberResponse_element resp= new wwwViadComV2.GetProjectByProjectNumberResponse_element();
                resp.GetProjectByProjectNumberResult = new wwwViadComV2.ShowProject();
                wwwViadComV2.ArrayOfBoothArea arrayBoothArea = new wwwViadComV2.ArrayOfBoothArea();
                arrayBoothArea.BoothArea = new List<wwwViadComV2.BoothArea>();
                wwwViadComV2.BoothArea boothArea = new wwwViadComV2.BoothArea();
                boothArea.DisplaySequence = 1000;
                boothArea.Editable = true;
                boothArea.Deleteable = true;
                boothArea.GroupOrdersByCategory = true;
                arrayBoothArea.BoothArea.add(boothArea);
                resp.GetProjectByProjectNumberResult.BoothAreas = arrayBoothArea;
                wwwViadComV2.Facility Facility = new wwwViadComV2.Facility();
                Facility.FacilityId = 1999;
                resp.GetProjectByProjectNumberResult.Facility = Facility;
                schemasMicrosoftCom200310Serializat.ArrayOfstring OperationsZones = new schemasMicrosoftCom200310Serializat.ArrayOfstring();
                OperationsZones.string_x = new List<String>();
                OperationsZones.string_x.add('1232');
                resp.GetProjectByProjectNumberResult.OperationsZones = OperationsZones;
                wwwViadComV2.ArrayOfShowOrganizer ShowOrganizers = new wwwViadComV2.ArrayOfShowOrganizer();
                ShowOrganizers.ShowOrganizer = new List<wwwViadComV2.ShowOrganizer>();
                wwwViadComV2.ShowOrganizer organizer = new wwwViadComV2.ShowOrganizer();
                organizer.CustomerName = 'Test Name';
                organizer.ShowOccrCustomerId= 1122;
                ShowOrganizers.ShowOrganizer.add(organizer);
                resp.GetProjectByProjectNumberResult.ShowOrganizers = ShowOrganizers;
                response.put('response_x', resp);
            }
        }
}