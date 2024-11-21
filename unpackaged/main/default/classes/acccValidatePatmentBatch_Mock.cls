@isTest
public class acccValidatePatmentBatch_Mock implements WebServiceMock{
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
       
        System.debug('CORE_SECURITY_IMPLMockImpl.doInvoke() - ' +
            '\n request: ' + request +
            '\n response: ' + response +
            '\n endpoint: ' + endpoint +
            '\n soapAction: ' + soapAction +
            '\n requestName: ' + requestName +
            '\n responseNS: ' + responseNS +
            '\n responseName: ' + responseName +
            '\n responseType: ' + responseType);
                
                 if (requestName == 'StartAppSession'){
                   ACCC_wwwViadComSecurityV2.StartAppSessionResponse_element ss = new ACCC_wwwViadComSecurityV2.StartAppSessionResponse_element();
                   ACCC_wwwViadComSecurityV2.AppSessionInfo sessioninfo = new ACCC_wwwViadComSecurityV2.AppSessionInfo();
                   sessioninfo.SessionID = 'jhdhkfhkdf';
                   ss.StartAppSessionResult = sessioninfo;
                     response.put('response_x', ss);
                }
                if (requestName == 'GetPaymentCollection'){
                    ACCC1_wwwViadComV1.GetPaymentCollectionResponse_element ee = new ACCC1_wwwViadComV1.GetPaymentCollectionResponse_element();
                    ACCC1_wwwViadComV1.PaymentCollectionInfo ss = new ACCC1_wwwViadComV1.PaymentCollectionInfo();
                    ss.CreditCardExpireMonth = 12;
                    ee.GetPaymentCollectionResult = ss;
                    response.put('response_x', ee);

              }
       }         
}