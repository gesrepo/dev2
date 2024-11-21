@isTest
public class SQRSer_wwwViadComV1_Mock  implements WebServiceMock {
    public void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType) {
            if(request instanceOf  SQRSer_wwwViadComV1.GetSqrTally_element){
                response.put('response_x',new SQRSer_wwwViadComV1.GetSqrTallyResponse_element());
            }
            else if(request instanceOf  SQRSer_wwwViadComV1.GetSqrSummary_element){
                response.put('response_x',new SQRSer_wwwViadComV1.GetSqrSummaryResponse_element());
            }
            else if(request instanceOf  SQRSer_wwwViadComV1.GetSqrDefaults_element){
                response.put('response_x',new SQRSer_wwwViadComV1.GetSqrDefaultsResponse_element());
            }
            else if(request instanceOf  SQRSer_wwwViadComV1.GetSqrDetails_element){
                response.put('response_x',new SQRSer_wwwViadComV1.GetSqrDetailsResponse_element());
            }
            else if(request instanceOf  SQRSer_wwwViadComV1.GetSimpleSqrs_element){
                response.put('response_x',new SQRSer_wwwViadComV1.GetSimpleSqrsResponse_element());
            }
            else if(request instanceOf  SQRSer_wwwViadComV1.SubmitSimpleSqr_element){
                response.put('response_x',new SQRSer_wwwViadComV1.SubmitSimpleSqrResponse_element());
            }
            else if(request instanceOf  SQRSer_wwwViadComV1.UpdateSqr_element){
                response.put('response_x',new SQRSer_wwwViadComV1.UpdateSqrResponse_element());
            }
            else if(request instanceOf  SQRSer_wwwViadComV1.SubmitSqr_element){
                response.put('response_x',new SQRSer_wwwViadComV1.SubmitSqrResponse_element());
            }
            else if(request instanceOf  SQRSer_wwwViadComV1.GetSqrBoothInfo_element){
                response.put('response_x',new SQRSer_wwwViadComV1.GetSqrBoothInfoResponse_element());
            }
            else if(request instanceOf  SQRSer_wwwViadComV1.GetSqrProblems_element){
                response.put('response_x',new SQRSer_wwwViadComV1.GetSqrProblemsResponse_element());
                
            }
        }
}