@isTest 
private class AsyncICSwwwViadComSecurityV2_Test{
    static testMethod void validateHelloWorld() {
       Continuation con =new Continuation (40);
       AsyncICSwwwViadComSecurityV2.AsyncBasicHttpBinding_IAuthenticationService ResetPa = new AsyncICSwwwViadComSecurityV2.AsyncBasicHttpBinding_IAuthenticationService ();
      Test.setMock(WebServiceMock.class, new AsyncSoapStockQuoteServiceMockImpl());
       ResetPa.beginResetPasswordRequest(con , 'test','test2' , 'test@gmail.com');
       
         ResetPa.beginResetPasswordRequest(con , 'test','test2' , 'test@gmail.com');
         ResetPa.beginUserLoginWithoutPassword(con , 'test','test@gmail.com' , true);
        
         ResetPa.beginStartAppSession(con , '110101','10101' , '10101001' , '10101001');
        
         ResetPa.beginRetrieveContactInformation(con , '1010101');
        
         ResetPa.beginSearchDirectory(con , '110101','10101' , '10101001');
        
         ResetPa.beginAuthenticateUser(con , 'test','test2' , 'test@gmail.com');
        
         ResetPa.beginResetPasswordRequest(con , '101010','test@gmail.com' , 'TEST');
        
         ResetPa.beginUserLogin(con ,'101010', 'test','test2' , true);
        
         //ResetPa.beginUserLoginWithStoredPassword(con ,'TEST' 'test','test2' , 'test@gmail.com' ,true);
        
         ResetPa.beginSyncSessionFromOtherNode(con , '10101001');
        
         ResetPa.beginTransferSession(con , '10988','2111111' );
        
         ResetPa.beginResetPassword(con , 'test','test2' , 'test@gmail.com');
        
         ResetPa.beginUpdateEmailAddress(con , 'test2' , 'test@gmail.com');
        
         ResetPa.beginUpdateDisplayName(con , 'test','101010' );
        
         ResetPa.beginQuerySession(con , '101010');
        
         ResetPa.beginUserLoginByDomain(con , 'test','test2' , 'test@gmail.com' ,'tetet' , true);
        
         ResetPa.beginQuerySessionThisNode(con , 'test');
         
         
         
        
          ResetPa.beginQueryOtherSession(con , '101010' ,'22334343');
        
         ResetPa.beginCreateAccount(con , '111111','test2' , 'test@gmail.com' ,'tetet' , 'test' ,'test@gmail.com', '7367367');
        
         ResetPa.beginUserLogout(con , 'test');
         
         
         
          ResetPa.beginGetDomainStatuses(con , '101010');
        
         ResetPa.beginEndAppSession(con , 'test');
        
         ResetPa.beginRequestSessionTransfer(con , 'test');
         
         
         
        
        
       
        
    } 
}