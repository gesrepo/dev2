@isTest
public class wwwViadComSecurityV2VacccVaccc_Mock implements WebServiceMock{
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

        if(request instanceOf wwwViadComSecurityV2Vaccc.CreateAccount_element) {
            response.put( 'response_x', new wwwViadComSecurityV2Vaccc.CreateAccountResponse_element());
        }
        else if(request instanceOf wwwViadComSecurityV2Vaccc.EndAppSession_element) {
            response.put( 'response_x', new wwwViadComSecurityV2Vaccc.EndAppSessionResponse_element());
        }
        else if(request instanceOf wwwViadComSecurityV2Vaccc.QueryOtherSession_element) {
            response.put( 'response_x', new wwwViadComSecurityV2Vaccc.QueryOtherSessionResponse_element());
        }
        else if(request instanceOf wwwViadComSecurityV2Vaccc.QuerySession_element) {
            response.put( 'response_x', new wwwViadComSecurityV2Vaccc.QuerySessionResponse_element());
        }
        else if(request instanceOf wwwViadComSecurityV2Vaccc.RequestSessionTransfer_element) {
            response.put( 'response_x', new wwwViadComSecurityV2Vaccc.RequestSessionTransferResponse_element());
        }
        else if(request instanceOf wwwViadComSecurityV2Vaccc.ResetPassword_element) {
            response.put( 'response_x', new wwwViadComSecurityV2Vaccc.ResetPasswordResponse_element());
        }
        else if(request instanceOf wwwViadComSecurityV2Vaccc.ResetPasswordRequest_element) {
            response.put( 'response_x', new wwwViadComSecurityV2Vaccc.ResetPasswordRequestResponse_element());
        }
        else if(request instanceOf wwwViadComSecurityV2Vaccc.RetrieveContactInformation_element) {
            response.put( 'response_x', new wwwViadComSecurityV2Vaccc.RetrieveContactInformationResponse_element());
        }
        else if(request instanceOf wwwViadComSecurityV2Vaccc.SearchDirectory_element) {
            response.put( 'response_x', new wwwViadComSecurityV2Vaccc.SearchDirectoryResponse_element());
        }
        else if(request instanceOf wwwViadComSecurityV2Vaccc.StartAppSession_element) {
            response.put( 'response_x', new wwwViadComSecurityV2Vaccc.StartAppSessionResponse_element());
        }
        else if(request instanceOf wwwViadComSecurityV2Vaccc.TransferSession_element) {
            response.put( 'response_x', new wwwViadComSecurityV2Vaccc.TransferSessionResponse_element());
        }
        else if(request instanceOf wwwViadComSecurityV2Vaccc.UpdateContactInformation_element) {
            response.put( 'response_x', new wwwViadComSecurityV2Vaccc.UpdateContactInformationResponse_element());
        }
        else if(request instanceOf wwwViadComSecurityV2Vaccc.UpdateDisplayName_element) {
            response.put( 'response_x', new wwwViadComSecurityV2Vaccc.UpdateDisplayNameResponse_element());
        }
        else if(request instanceOf wwwViadComSecurityV2Vaccc.UpdateEmailAddress_element) {
            response.put( 'response_x', new wwwViadComSecurityV2Vaccc.UpdateEmailAddressResponse_element());
        }
        else if(request instanceOf wwwViadComSecurityV2Vaccc.UserLogin_element) {
            response.put( 'response_x', new wwwViadComSecurityV2Vaccc.UserLoginResponse_element());
        }
        else if(request instanceOf wwwViadComSecurityV2Vaccc.UserLoginByDomain_element) {
            response.put( 'response_x', new wwwViadComSecurityV2Vaccc.UserLoginByDomainResponse_element());
        }
        else if(request instanceOf wwwViadComSecurityV2Vaccc.UserLoginWithoutPassword_element) {
            response.put( 'response_x', new wwwViadComSecurityV2Vaccc.UserLoginWithoutPasswordResponse_element());
        }
        else if(request instanceOf wwwViadComSecurityV2Vaccc.UserLoginWithStoredPassword_element) {
            response.put( 'response_x', new wwwViadComSecurityV2Vaccc.UserLoginWithStoredPasswordResponse_element());
        }
        else if(request instanceOf wwwViadComSecurityV2Vaccc.UserLogout_element) {
            response.put( 'response_x', new wwwViadComSecurityV2Vaccc.UserLogoutResponse_element());
        }
    }
}