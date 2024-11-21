@isTest
public class ACCC_wwwViadComSecurityV2Vaccc_Mock implements WebServiceMock{
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
       
        System.debug(LoggingLevel.INFO, 'CORE_SECURITY_IMPLMockImpl.doInvoke() - ' +
            '\n request: ' + request +
            '\n response: ' + response +
            '\n endpoint: ' + endpoint +
            '\n soapAction: ' + soapAction +
            '\n requestName: ' + requestName +
            '\n responseNS: ' + responseNS +
            '\n responseName: ' + responseName +
            '\n responseType: ' + responseType);

        if(request instanceOf ACCC_wwwViadComSecurityV2.CreateAccount_element) {
            response.put( 'response_x', new ACCC_wwwViadComSecurityV2.CreateAccountResponse_element());
        }
        if(request instanceOf wwwViadComSecurityV2Vaccc.StartAppSession_element ) {
            wwwViadComSecurityV2Vaccc.StartAppSessionResponse_element response_x = new wwwViadComSecurityV2Vaccc.StartAppSessionResponse_element();
            response_x.StartAppSessionResult= new wwwViadComSecurityV2Vaccc.AppSessionInfo();
            response_x.StartAppSessionResult.ApplicationID='1234567890';
            response_x.StartAppSessionResult.CompanyId='Adarsh.Co';
            response_x.StartAppSessionResult.Expiration=Date.Today()+1;
            response_x.StartAppSessionResult.SessionID='adarshbhatG';
            response_x.StartAppSessionResult.LanguageId='';
            //Map<String, wwwViadComSecurityV2Vaccc.StartAppSessionResponse_element> response = new Map<String, wwwViadComSecurityV2Vaccc.StartAppSessionResponse_element>();
            response.put('response_x', response_x);
           
        }
        else if(request instanceOf ACCC_wwwViadComSecurityV2.EndAppSession_element) {
            response.put( 'response_x', new ACCC_wwwViadComSecurityV2.EndAppSessionResponse_element());
        }
        else if(request instanceOf ACCC_wwwViadComSecurityV2.QueryOtherSession_element) {
            response.put( 'response_x', new ACCC_wwwViadComSecurityV2.QueryOtherSessionResponse_element());
        }
        else if(request instanceOf ACCC_wwwViadComSecurityV2.QuerySession_element) {
            response.put( 'response_x', new ACCC_wwwViadComSecurityV2.QuerySessionResponse_element());
        }
        else if(request instanceOf ACCC_wwwViadComSecurityV2.RequestSessionTransfer_element) {
            response.put( 'response_x', new ACCC_wwwViadComSecurityV2.RequestSessionTransferResponse_element());
        }
        else if(request instanceOf ACCC_wwwViadComSecurityV2.ResetPassword_element) {
            response.put( 'response_x', new ACCC_wwwViadComSecurityV2.ResetPasswordResponse_element());
        }
        else if(request instanceOf ACCC_wwwViadComSecurityV2.ResetPasswordRequest_element) {
            response.put( 'response_x', new ACCC_wwwViadComSecurityV2.ResetPasswordRequestResponse_element());
        }
        else if(request instanceOf ACCC_wwwViadComSecurityV2.RetrieveContactInformation_element) {
            response.put( 'response_x', new ACCC_wwwViadComSecurityV2.RetrieveContactInformationResponse_element());
        }
        else if(request instanceOf ACCC_wwwViadComSecurityV2.SearchDirectory_element) {
            response.put( 'response_x', new ACCC_wwwViadComSecurityV2.SearchDirectoryResponse_element());
        }
        else if(request instanceOf ACCC_wwwViadComSecurityV2.StartAppSession_element) {
            response.put( 'response_x', new ACCC_wwwViadComSecurityV2.StartAppSessionResponse_element());
        }
        else if(request instanceOf ACCC_wwwViadComSecurityV2.TransferSession_element) {
            response.put( 'response_x', new ACCC_wwwViadComSecurityV2.TransferSessionResponse_element());
        }
        else if(request instanceOf ACCC_wwwViadComSecurityV2.UpdateContactInformation_element) {
            response.put( 'response_x', new ACCC_wwwViadComSecurityV2.UpdateContactInformationResponse_element());
        }
        else if(request instanceOf ACCC_wwwViadComSecurityV2.UpdateDisplayName_element) {
            response.put( 'response_x', new ACCC_wwwViadComSecurityV2.UpdateDisplayNameResponse_element());
        }
        else if(request instanceOf ACCC_wwwViadComSecurityV2.UpdateEmailAddress_element) {
            response.put( 'response_x', new ACCC_wwwViadComSecurityV2.UpdateEmailAddressResponse_element());
        }
        else if(request instanceOf ACCC_wwwViadComSecurityV2.UserLogin_element) {
            response.put( 'response_x', new ACCC_wwwViadComSecurityV2.UserLoginResponse_element());
        }
        else if(request instanceOf ACCC_wwwViadComSecurityV2.UserLoginByDomain_element) {
            response.put( 'response_x', new ACCC_wwwViadComSecurityV2.UserLoginByDomainResponse_element());
        }
        else if(request instanceOf ACCC_wwwViadComSecurityV2.UserLoginWithoutPassword_element) {
            response.put( 'response_x', new ACCC_wwwViadComSecurityV2.UserLoginWithoutPasswordResponse_element());
        }
        else if(request instanceOf ACCC_wwwViadComSecurityV2.UserLoginWithStoredPassword_element) {
            response.put( 'response_x', new ACCC_wwwViadComSecurityV2.UserLoginWithStoredPasswordResponse_element());
        }
        else if(request instanceOf ACCC_wwwViadComSecurityV2.UserLogout_element) {
            response.put( 'response_x', new ACCC_wwwViadComSecurityV2.UserLogoutResponse_element());
        }
        else if(request instanceOf ACCC_wwwViadComSecurityV2.QuerySessionThisNode_element) {
            response.put( 'response_x', new ACCC_wwwViadComSecurityV2.QuerySessionThisNodeResponse_element());
        }
    }
}