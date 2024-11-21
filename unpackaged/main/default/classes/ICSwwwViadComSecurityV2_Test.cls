@istest
public class ICSwwwViadComSecurityV2_Test {
	@istest
    public static void Unit1(){
    	ICSwwwViadComSecurityV2.RequestSessionTransferResponse_element ICSwV2 = new ICSwwwViadComSecurityV2.RequestSessionTransferResponse_element();
        ICSwV2.RequestSessionTransferResult = 'test';
        
        ICSwwwViadComSecurityV2.UpdateContactInformationResponse_element ICSwUpdateInfo = new ICSwwwViadComSecurityV2.UpdateContactInformationResponse_element();
        
        ICSwwwViadComSecurityV2.UserLoginByDomain_element ICSwByDomain = new ICSwwwViadComSecurityV2.UserLoginByDomain_element();
        ICSwByDomain.DomainName = 'test';
        
        ICSwwwViadComSecurityV2.RequestSessionTransfer_element ICSwReq = new ICSwwwViadComSecurityV2.RequestSessionTransfer_element();
		ICSwReq.AppSessionID = '';
        
        ICSwwwViadComSecurityV2.TransferSession_element ICSwTransfer = new ICSwwwViadComSecurityV2.TransferSession_element();
		ICSwTransfer.AppSessionID = '';
        
        ICSwwwViadComSecurityV2.SyncSessionFromOtherNode_element ICSwSession = new ICSwwwViadComSecurityV2.SyncSessionFromOtherNode_element();
		ICSwSession.AppSessionID = '';
        
        ICSwwwViadComSecurityV2.QuerySession_element ICSwQuerySession = new ICSwwwViadComSecurityV2.QuerySession_element();
		ICSwQuerySession.AppSessionID = '';
        
        ICSwwwViadComSecurityV2.UpdateContactInformation_element ICSwElement = new ICSwwwViadComSecurityV2.UpdateContactInformation_element();
		ICSwElement.AppSessionID = '';
        
        ICSwwwViadComSecurityV2.StartAppSessionResponse_element ICSwStart= new ICSwwwViadComSecurityV2.StartAppSessionResponse_element();
        ICSwwwViadComSecurityV2.UserLoginResponse_element unit1= new ICSwwwViadComSecurityV2.UserLoginResponse_element();
        ICSwwwViadComSecurityV2.ResetPasswordRequestInfo unit2= new ICSwwwViadComSecurityV2.ResetPasswordRequestInfo();
        ICSwwwViadComSecurityV2.ResetPassword_element unit3= new ICSwwwViadComSecurityV2.ResetPassword_element();
        ICSwwwViadComSecurityV2.DomainInfo unit4= new ICSwwwViadComSecurityV2.DomainInfo();
        ICSwwwViadComSecurityV2.ContactInfo unit5= new ICSwwwViadComSecurityV2.ContactInfo();
        ICSwwwViadComSecurityV2.QuerySessionThisNode_element unit6= new ICSwwwViadComSecurityV2.QuerySessionThisNode_element();
        ICSwwwViadComSecurityV2.UserLoginWithoutPassword_element unit7= new ICSwwwViadComSecurityV2.UserLoginWithoutPassword_element();
        
        ICSwwwViadComSecurityV2.UpdateEmailAddress_element unit8= new ICSwwwViadComSecurityV2.UpdateEmailAddress_element();
        ICSwwwViadComSecurityV2.UserLoginByDomainResponse_element unit9= new ICSwwwViadComSecurityV2.UserLoginByDomainResponse_element();
        ICSwwwViadComSecurityV2.UpdateDisplayName_element unit10= new ICSwwwViadComSecurityV2.UpdateDisplayName_element();
        ICSwwwViadComSecurityV2.EndAppSessionResponse_element unit11= new ICSwwwViadComSecurityV2.EndAppSessionResponse_element();
        ICSwwwViadComSecurityV2.RetrieveContactInformation_element unit12= new ICSwwwViadComSecurityV2.RetrieveContactInformation_element();
        ICSwwwViadComSecurityV2.StartAppSession_element unit13= new ICSwwwViadComSecurityV2.StartAppSession_element();
        ICSwwwViadComSecurityV2.ResetPasswordRequestResponse_element unit14= new ICSwwwViadComSecurityV2.ResetPasswordRequestResponse_element();
        ICSwwwViadComSecurityV2.QuerySessionThisNodeResponse_element unit15= new ICSwwwViadComSecurityV2.QuerySessionThisNodeResponse_element();
        ICSwwwViadComSecurityV2.DirectoryInfo unit16= new ICSwwwViadComSecurityV2.DirectoryInfo();
        ICSwwwViadComSecurityV2.GetDomainStatusesResponse_element unit17= new ICSwwwViadComSecurityV2.GetDomainStatusesResponse_element();
        ICSwwwViadComSecurityV2.QueryOtherSessionResponse_element unit18= new ICSwwwViadComSecurityV2.QueryOtherSessionResponse_element();
        ICSwwwViadComSecurityV2.SyncSessionFromOtherNodeResponse_element unit19= new ICSwwwViadComSecurityV2.SyncSessionFromOtherNodeResponse_element();
        ICSwwwViadComSecurityV2.EndAppSession_element unit20= new ICSwwwViadComSecurityV2.EndAppSession_element();
        ICSwwwViadComSecurityV2.GetDomainStatuses_element unit21= new ICSwwwViadComSecurityV2.GetDomainStatuses_element();
        
        ICSwwwViadComSecurityV2.UserLogoutResponse_element unit22= new ICSwwwViadComSecurityV2.UserLogoutResponse_element();
        ICSwwwViadComSecurityV2.SearchDirectory_element unit23= new ICSwwwViadComSecurityV2.SearchDirectory_element();
        ICSwwwViadComSecurityV2.UserLogout_element unit24= new ICSwwwViadComSecurityV2.UserLogout_element();
        ICSwwwViadComSecurityV2.UpdateEmailAddressResponse_element unit25= new ICSwwwViadComSecurityV2.UpdateEmailAddressResponse_element();
        ICSwwwViadComSecurityV2.AuthenticateUserResponse_element unit26= new ICSwwwViadComSecurityV2.AuthenticateUserResponse_element();
        ICSwwwViadComSecurityV2.AppSessionInfo unit27= new ICSwwwViadComSecurityV2.AppSessionInfo();
        ICSwwwViadComSecurityV2.UserInfo unit28= new ICSwwwViadComSecurityV2.UserInfo();
        ICSwwwViadComSecurityV2.RetrieveContactInformationResponse_element unit29= new ICSwwwViadComSecurityV2.RetrieveContactInformationResponse_element();
        ICSwwwViadComSecurityV2.UpdateDisplayNameResponse_element unit30= new ICSwwwViadComSecurityV2.UpdateDisplayNameResponse_element();
        ICSwwwViadComSecurityV2.TransferSessionResponse_element unit31= new ICSwwwViadComSecurityV2.TransferSessionResponse_element();
        ICSwwwViadComSecurityV2.UserLogin_element unit32= new ICSwwwViadComSecurityV2.UserLogin_element();
        ICSwwwViadComSecurityV2.UserLoginWithoutPasswordResponse_element unit33= new ICSwwwViadComSecurityV2.UserLoginWithoutPasswordResponse_element();
        ICSwwwViadComSecurityV2.ArrayOfDirectoryInfo unit34= new ICSwwwViadComSecurityV2.ArrayOfDirectoryInfo();
        ICSwwwViadComSecurityV2.SearchDirectoryResponse_element unit35= new ICSwwwViadComSecurityV2.SearchDirectoryResponse_element();
        ICSwwwViadComSecurityV2.UserLoginWithStoredPasswordResponse_element unit36= new ICSwwwViadComSecurityV2.UserLoginWithStoredPasswordResponse_element();
        ICSwwwViadComSecurityV2.UserLoginWithStoredPassword_element unit37= new ICSwwwViadComSecurityV2.UserLoginWithStoredPassword_element();
        ICSwwwViadComSecurityV2.ArrayOfDomainStatus unit38= new ICSwwwViadComSecurityV2.ArrayOfDomainStatus();
        ICSwwwViadComSecurityV2.AuthenticateUser_element unit39= new ICSwwwViadComSecurityV2.AuthenticateUser_element();
        ICSwwwViadComSecurityV2.QuerySessionResponse_element unit40= new ICSwwwViadComSecurityV2.QuerySessionResponse_element();
        ICSwwwViadComSecurityV2.ArrayOfResetPasswordRequestInfo unit41= new ICSwwwViadComSecurityV2.ArrayOfResetPasswordRequestInfo();
        
        ICSwwwViadComSecurityV2.QueryOtherSession_element QueryOtherSession_element= new ICSwwwViadComSecurityV2.QueryOtherSession_element();
        ICSwwwViadComSecurityV2.CreateAccount_element CreateAccount_element= new ICSwwwViadComSecurityV2.CreateAccount_element();
        ICSwwwViadComSecurityV2.CreateAccountResponse_element CreateAccountResponse_element= new ICSwwwViadComSecurityV2.CreateAccountResponse_element();
        ICSwwwViadComSecurityV2.ResetPasswordRequest_element ResetPasswordRequest_element= new ICSwwwViadComSecurityV2.ResetPasswordRequest_element();
        ICSwwwViadComSecurityV2.ArrayOfDomainInfo ArrayOfDomainInfo= new ICSwwwViadComSecurityV2.ArrayOfDomainInfo();
        ICSwwwViadComSecurityV2.DomainStatus DomainStatus= new ICSwwwViadComSecurityV2.DomainStatus();
        ICSwwwViadComSecurityV2.ResetPasswordResponse_element ResetPasswordResponse_element= new ICSwwwViadComSecurityV2.ResetPasswordResponse_element();
        
         
      
        ICSwwwViadComSecurityV2.BasicHttpBinding_IAuthenticationService basicHttpBinding= new ICSwwwViadComSecurityV2.BasicHttpBinding_IAuthenticationService();
        Test.setMock(WebServiceMock.class, new ICSwwwViadComSecurityV2_Mock());
        basicHttpBinding.ResetPasswordRequest('testlogin', 'testlogin', 'test@test.com');
        basicHttpBinding.UserLogin ('testlogin','testlogin','testlogin', true);
        basicHttpBinding.UserLoginWithStoredPassword ('testlogin','testlogin','testlogin','password', true);
        basicHttpBinding.TransferSession ('testlogin','testlogin');
        basicHttpBinding.ResetPassword ('testlogin','testlogin','testlogin');
        basicHttpBinding.UpdateEmailAddress ('testlogin','testlogin@test.com');
        basicHttpBinding.UpdateDisplayName ('testlogin','Test');
        basicHttpBinding.QuerySession ('testlogin');
        basicHttpBinding.UserLoginByDomain ('testlogin','Sachin','loginName','password',true);
        basicHttpBinding.QueryOtherSession ('testlogin','Test');
        basicHttpBinding.UserLoginWithoutPassword('testlogin','Test@gmail.com',true);
        basicHttpBinding.StartAppSession('testlogin','Sachin','loginName','password');
        basicHttpBinding.RetrieveContactInformation('testlogin');
        basicHttpBinding.SearchDirectory('testlogin','Sachin','loginName');
        basicHttpBinding.CreateAccount('testlogin','Sachin','loginName','password','test','test@gmail.com','112514564564');
        basicHttpBinding.RequestSessionTransfer('24135425sad');   
        
        
       
    }
}