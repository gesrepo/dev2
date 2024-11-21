public class PhoneTypeVerificationAPI {
    
    @Future(callout=true)
    public static void PhoneTypeAPICall(String contId, String phoneNum){
        Contact cont = new Contact(Id=contId);
        Boolean TextOptOut = true;
        String username = System.Label.Twilio_Account_SID;
        String password = System.Label.Twilio_Auth_Token;
        
        HttpRequest req= new HttpRequest();
        req.setMethod('GET');
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'Basic  ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        req.setTimeout(60000);     
        String url = 'https://lookups.twilio.com/v2/PhoneNumbers/'+phoneNum+'?Fields=line_type_intelligence';
        req.setEndpoint(url);
        System.debug(' url::: '+url);
        
        Http http = new Http();
        HttpResponse res = new HttpResponse();
        
        if(Test.isRunningTest()){
            res.setBody('{"phone_number": "+19650181999","calling_country_code": "1","country_code": "US","disposable_phone_number_risk": null,"line_type_intelligence": {"mobile_network_code": "10","error_code": null,"type": "mobile"},"valid": true,"identity_match": null}');
        }
        else{
            res = http.send(req);
        }
        System.debug('res::: '+res);
        
        Map<String, Object> resMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        System.debug('resMap:: '+resMap);
        String lineType = (String)JSON.serialize(resMap.get('line_type_intelligence'));
        Map<String, Object> lineMap = (Map<String, Object>) JSON.deserializeUntyped(lineType);
        System.debug('lineType:: '+lineType);
        if(resMap.get('valid') == true && lineMap!=null && lineMap.size()>0){
            String phoneType = (String)JSON.serialize(lineMap.get('type'));
            String formPhoneType = phoneType.replace('"','');
            TextOptOut = formPhoneType == 'mobile'? false : true;
        }
        
        cont.Text_Opt_Out__c = TextOptOut;
        if(cont != null){
            update cont;
        }         
    }
}