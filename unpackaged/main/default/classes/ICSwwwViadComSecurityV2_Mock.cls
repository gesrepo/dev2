@isTest
public class ICSwwwViadComSecurityV2_Mock implements WebServiceMock {
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

        if(request instanceOf ICSwwwViadComSecurityV2.CreateAccount_element) {
            response.put( 'response_x', new ICSwwwViadComSecurityV2.CreateAccountResponse_element());
        }
        else if(request instanceOf ICSwwwViadComSecurityV2.EndAppSession_element) {
            response.put( 'response_x', new ICSwwwViadComSecurityV2.EndAppSessionResponse_element());
        }
        else if(request instanceOf ICSwwwViadComSecurityV2.QueryOtherSession_element) {
            response.put( 'response_x', new ICSwwwViadComSecurityV2.QueryOtherSessionResponse_element());
        }
        else if(request instanceOf ICSwwwViadComSecurityV2.QuerySession_element) {
            response.put( 'response_x', new ICSwwwViadComSecurityV2.QuerySessionResponse_element());
        }
        else if(request instanceOf ICSwwwViadComSecurityV2.RequestSessionTransfer_element) {
            response.put( 'response_x', new ICSwwwViadComSecurityV2.RequestSessionTransferResponse_element());
        }
        else if(request instanceOf ICSwwwViadComSecurityV2.ResetPassword_element) {
            response.put( 'response_x', new ICSwwwViadComSecurityV2.ResetPasswordResponse_element());
        }
        else if(request instanceOf ICSwwwViadComSecurityV2.ResetPasswordRequest_element) {
            response.put( 'response_x', new ICSwwwViadComSecurityV2.ResetPasswordRequestResponse_element());
        }
        else if(request instanceOf ICSwwwViadComSecurityV2.RetrieveContactInformation_element) {
            response.put( 'response_x', new ICSwwwViadComSecurityV2.RetrieveContactInformationResponse_element());
        }
        else if(request instanceOf ICSwwwViadComSecurityV2.SearchDirectory_element) {
            response.put( 'response_x', new ICSwwwViadComSecurityV2.SearchDirectoryResponse_element());
        }
        else if(request instanceOf ICSwwwViadComSecurityV2.StartAppSession_element) {
            response.put( 'response_x', new ICSwwwViadComSecurityV2.StartAppSessionResponse_element());
        }
        else if(request instanceOf ICSwwwViadComSecurityV2.TransferSession_element) {
            response.put( 'response_x', new ICSwwwViadComSecurityV2.TransferSessionResponse_element());
        }
        else if(request instanceOf ICSwwwViadComSecurityV2.UpdateContactInformation_element) {
            response.put( 'response_x', new ICSwwwViadComSecurityV2.UpdateContactInformationResponse_element());
        }
        else if(request instanceOf ICSwwwViadComSecurityV2.UpdateDisplayName_element) {
            response.put( 'response_x', new ICSwwwViadComSecurityV2.UpdateDisplayNameResponse_element());
        }
        else if(request instanceOf ICSwwwViadComSecurityV2.UpdateEmailAddress_element) {
            response.put( 'response_x', new ICSwwwViadComSecurityV2.UpdateEmailAddressResponse_element());
        }
        else if(request instanceOf ICSwwwViadComSecurityV2.UserLogin_element) {
            response.put( 'response_x', new ICSwwwViadComSecurityV2.UserLoginResponse_element());
        }
        else if(request instanceOf ICSwwwViadComSecurityV2.UserLoginByDomain_element) {
            response.put( 'response_x', new ICSwwwViadComSecurityV2.UserLoginByDomainResponse_element());
        }
        else if(request instanceOf ICSwwwViadComSecurityV2.UserLoginWithoutPassword_element) {
            response.put( 'response_x', new ICSwwwViadComSecurityV2.UserLoginWithoutPasswordResponse_element());
        }
        else if(request instanceOf ICSwwwViadComSecurityV2.UserLoginWithStoredPassword_element) {
            response.put( 'response_x', new ICSwwwViadComSecurityV2.UserLoginWithStoredPasswordResponse_element());
        }
        else if(request instanceOf ICSwwwViadComSecurityV2.UserLogout_element) {
            response.put( 'response_x', new ICSwwwViadComSecurityV2.UserLogoutResponse_element());
        }
    }
}