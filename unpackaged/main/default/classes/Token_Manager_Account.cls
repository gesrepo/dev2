public with sharing class Token_Manager_Account {       
        
        private static string oauthLogin(String loginUri, String clientId,
                String clientSecret, String username, String password) {
                HttpRequest req = new HttpRequest(); 
         
                req.setMethod('POST');
                req.setEndpoint(loginUri+'/services/oauth2/token');
                req.setBody('grant_type=password' +
                    '&client_id=' + clientId +
                    '&client_secret=' + clientSecret +
                    '&username=' + EncodingUtil.urlEncode(username, 'UTF-8') +
                    '&password=' + EncodingUtil.urlEncode(password, 'UTF-8'));
            
                Http http = new Http();
          
                HTTPResponse res = http.send(req);

                System.debug('BODY: '+res.getBody());
                System.debug('STATUS:'+res.getStatus());
                System.debug('STATUS_CODE:'+res.getStatusCode());
                
                return res.getBody();
                    //return new JSONObject(res.getBody());
        }
    public static oAuth__c oAuthSetting {
        get {
            if (oAuthSetting == null) {
                oAuthSetting = oAuth__c.getInstance('DataComMatch');
                if (oAuthSetting == null) {
                    throw new oAuthException('No OAuth Settings Found');
                }
            }
            return oAuthSetting;
        } 
        private set;
    }
        static String  endPoint_URL=oAuthSetting.Auth_Endpoint__c;
        static String  client_Id=oAuthSetting.Client_ID__c;
        static string  client_Secret=oAuthSetting.Client_Secret__c;
        static string  user_name=oAuthSetting.UsernameAccount__c;
        static string  pass_word=oAuthSetting.SecurityAccount__c;
        
        
    private static Auth_Token__c ADC_OAuth {
        get {
            if (ADC_OAuth == null) {
                ADC_OAuth = [SELECT Name,Auth_Token__c,Auth_Token_Expires__c FROM Auth_Token__c WHERE Name='DataCom' LIMIT 1];
            }
            return ADC_OAuth;
        }
        set;
    }

    private static String endPointURL {
        get {
            if(endPointURL==null) {
                    endPointURL = oAuthSetting.Auth_Endpoint__c;                
            }
            return endPointURL;
        }
    }
    
    public static String getEndPointURL() {
        return endPointURL; 
    }


    public static Auth_Token__c getToken() {
        
        String jsonString = null;
         //system.debug('-------'+endPoint_URL+'---------client_Id-'+client_Id+'********client_Secret*+'+client_Secret+'=====user_name='+user_name+'****'+pass_word);
        jsonString=oauthLogin(endPoint_URL,client_Id,client_Secret,user_name,pass_word);
        
       
        

                if (jsonString.length() > 0 || Test.isrunningTest()) {
            
            ADCAuthResponse ADCAuthResp = (ADCAuthResponse) System.JSON.deserialize(jsonString, ADCAuthResponse.class);
            // system.debug('Auth => ' +jsonString);
            ADC_OAuth = new Auth_Token__c(Name = 'DataCom');  
           // system.debug('========ADCAuthResp.access_token'+ADCAuthResp.access_token+'**********'+ADCAuthResp);          
            ADC_OAuth.Auth_Token__c = ADCAuthResp.access_token;  
            ADC_OAuth.Auth_Token_Expires__c = Datetime.now().addminutes(60);             
        }
        return ADC_OAuth;

    }
    
    public class oAuthException extends Exception {}
    
     private class ADCAuthResponse {
        private String access_token {get;set;}
        private Integer expires_in {get;set;}
        private String refresh_token {get;set;}        
        private String jti {get;set;}       
    }

}