@isTest
public class UpSQR_ViadComV2_Mock implements WebServiceMock {
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
            if(request instanceOf  UpSQR_ViadComV2.GetSqrHeaders_element) { 
                UpSQR_ViadComV2.GetSqrHeadersResponse_element response_x =new  UpSQR_ViadComV2.GetSqrHeadersResponse_element(); 
                response_x.GetSqrHeadersResult=new UpSQR_ViadComDataV2.ArrayOfSqrHeader();
                response_x.GetSqrHeadersResult.SqrHeader=new List<UpSQR_ViadComDataV2.SqrHeader>();
                UpSQR_ViadComDataV2.SqrHeader testSqrHeader=new UpSQR_ViadComDataV2.SqrHeader();
                testSqrHeader.Priority='L';
                testSqrHeader.CreationDate=new UpSQR_DatacontractOrg200407System.DateTimeOffset();
                testSqrHeader.CreationDate.DateTime_x= Date.today();
                testSqrHeader.LastUpdateDate=new UpSQR_DatacontractOrg200407System.DateTimeOffset();
                testSqrHeader.LastUpdateDate.DateTime_x= Date.today()+2;
                testSqrHeader.Status='open';
                testSqrHeader.ServiceCategory='test cat';
                testSqrHeader.CustomerBoothId=500;
                response_x.GetSqrHeadersResult.SqrHeader.add(testSqrHeader);
                response.put('response_x',response_x);
            }
            /*else if(request instanceOf  UpSQR_ViadComV2.GetSqrDetails_element) {
                response.put('response_x',new UpSQR_ViadComV2.GetSqrDetailsResponse_element());
            }
            else if(request instanceOf  UpSQR_ViadComV2.GetSqrTally_element) {
                response.put('response_x',new UpSQR_ViadComV2.GetSqrTallyResponse_element());
            }
            else if(request instanceOf  UpSQR_ViadComV2.GetSqrSummary_element) {
                response.put('response_x',new UpSQR_ViadComV2.GetSqrSummaryResponse_element());
            }
            else if(request instanceOf  UpSQR_ViadComV2.GetSqrDefaults_element) {
                response.put('response_x',new UpSQR_ViadComV2.GetSqrDefaultsResponse_element());
            }
            else if(request instanceOf  UpSQR_ViadComV2.GetSimpleSqrs_element) {
                response.put('response_x',new UpSQR_ViadComV2.GetSimpleSqrsResponse_element());
            }
            else if(request instanceOf  UpSQR_ViadComV2.UpdateSqr_element) {
                response.put('response_x',new UpSQR_ViadComV2.UpdateSqrResponse_element());
            }
            else if(request instanceOf  UpSQR_ViadComV2.SubmitSimpleSqr_element) {
                response.put('response_x',new UpSQR_ViadComV2.SubmitSimpleSqrResponse_element());
            }
            else if(request instanceOf  UpSQR_ViadComV2.SubmitSqr_element) {
                response.put('response_x',new UpSQR_ViadComV2.SubmitSqrResponse_element());
            }
            else if(request instanceOf  UpSQR_ViadComV2.SubmitMultiItemSqr_element) {
                response.put('response_x',new UpSQR_ViadComV2.SubmitMultiItemSqrResponse_element());
            }
            else if(request instanceOf  UpSQR_ViadComV2.GetSqrProblems_element) {
                response.put('response_x',new UpSQR_ViadComV2.GetSqrProblemsResponse_element());
            }   */
            
        }
    
}