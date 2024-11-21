@isTest
public class AsyncSoapStockQuoteServiceMockImpl implements WebServiceMock {
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

        if(request instanceOf ICSwwwViadComSecurityV2.ResetPasswordRequest_element) {
            response.put( 'response_x', new AsyncICSwwwViadComSecurityV2.ResetPasswordRequestResponse_elementFuture());
        }else if(request instanceOf ICSwwwViadComSecurityV2.UserLoginWithoutPassword_element ) {
            response.put( 'response_x', new AsyncICSwwwViadComSecurityV2.UserLoginWithoutPasswordResponse_elementFuture());
        }else if(request instanceOf ICSwwwViadComSecurityV2.StartAppSession_element ) {
            response.put( 'response_x', new AsyncICSwwwViadComSecurityV2.StartAppSessionResponse_elementFuture());
        }else if(request instanceOf ICSwwwViadComSecurityV2.RetrieveContactInformation_element ) {
            response.put( 'response_x', new AsyncICSwwwViadComSecurityV2.RetrieveContactInformationResponse_elementFuture());
        }
        else if(request instanceOf ICSwwwViadComSecurityV2.SearchDirectory_element ) {
            response.put( 'response_x', new AsyncICSwwwViadComSecurityV2.SearchDirectoryResponse_elementFuture());
        }
        else if(request instanceOf ICSwwwViadComSecurityV2.AuthenticateUser_element ) {
            response.put( 'response_x', new AsyncICSwwwViadComSecurityV2.AuthenticateUserResponse_elementFuture());
        }
        else if(request instanceOf ICSwwwViadComSecurityV2.UserLogin_element ) {
            response.put( 'response_x', new AsyncICSwwwViadComSecurityV2.UserLoginResponse_elementFuture());
        }
        
        
        else if(request instanceOf ICSwwwViadComSecurityV2.UserLoginWithStoredPassword_element ) {
            response.put( 'response_x', new AsyncICSwwwViadComSecurityV2.UserLoginWithStoredPasswordResponse_elementFuture());
        }
        else if(request instanceOf ICSwwwViadComSecurityV2.SyncSessionFromOtherNode_element ) {
            response.put( 'response_x', new AsyncICSwwwViadComSecurityV2.SyncSessionFromOtherNodeResponse_elementFuture());
        }
        else if(request instanceOf ICSwwwViadComSecurityV2.TransferSession_element ) {
            response.put( 'response_x', new AsyncICSwwwViadComSecurityV2.TransferSessionResponse_elementFuture());
        }
        else if(request instanceOf ICSwwwViadComSecurityV2.ResetPassword_element ) {
            response.put( 'response_x', new AsyncICSwwwViadComSecurityV2.ResetPasswordResponse_elementFuture());
        }
        else if(request instanceOf ICSwwwViadComSecurityV2.UpdateEmailAddress_element ) {
            response.put( 'response_x', new AsyncICSwwwViadComSecurityV2.UpdateEmailAddressResponse_elementFuture());
        }
        
        
         else if(request instanceOf ICSwwwViadComSecurityV2.UpdateDisplayName_element ) {
            response.put( 'response_x', new AsyncICSwwwViadComSecurityV2.UpdateDisplayNameResponse_elementFuture());
        }
         else if(request instanceOf ICSwwwViadComSecurityV2.QuerySession_element ) {
            response.put( 'response_x', new AsyncICSwwwViadComSecurityV2.QuerySessionResponse_elementFuture());
        } 
        else if(request instanceOf ICSwwwViadComSecurityV2.UserLoginByDomain_element ) {
            response.put( 'response_x', new AsyncICSwwwViadComSecurityV2.UserLoginByDomainResponse_elementFuture());
        } 
        else if(request instanceOf ICSwwwViadComSecurityV2.QuerySessionThisNode_element ) {
            response.put( 'response_x', new AsyncICSwwwViadComSecurityV2.QuerySessionThisNodeResponse_elementFuture());
        } 
        else if(request instanceOf ICSwwwViadComSecurityV2.QueryOtherSession_element ) {
            response.put( 'response_x', new AsyncICSwwwViadComSecurityV2.QueryOtherSessionResponse_elementFuture());
        }
         else if(request instanceOf ICSwwwViadComSecurityV2.CreateAccount_element ) {
            response.put( 'response_x', new AsyncICSwwwViadComSecurityV2.CreateAccountResponse_elementFuture());
        }
        
        
         else if(request instanceOf ICSwwwViadComSecurityV2.UserLogout_element ) {
            response.put( 'response_x', new AsyncICSwwwViadComSecurityV2.UserLogoutResponse_elementFuture());
        }
         else if(request instanceOf ICSwwwViadComSecurityV2.GetDomainStatuses_element ) {
            response.put( 'response_x', new AsyncICSwwwViadComSecurityV2.GetDomainStatusesResponse_elementFuture());
        }
         else if(request instanceOf ICSwwwViadComSecurityV2.EndAppSession_element ) {
            response.put( 'response_x', new AsyncICSwwwViadComSecurityV2.EndAppSessionResponse_elementFuture());
        }
         else if(request instanceOf ICSwwwViadComSecurityV2.RequestSessionTransfer_element  ) {
            response.put( 'response_x', new AsyncICSwwwViadComSecurityV2.RequestSessionTransferResponse_elementFuture());
        } 
        else if(request instanceOf ICSwwwViadComSecurityV2.UpdateContactInformation_element ) {
            response.put( 'response_x', new AsyncICSwwwViadComSecurityV2.UpdateContactInformationResponse_elementFuture());
        } 
       
    }
}