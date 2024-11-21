//queries Ascential TRG_Event data from Ascential using Exhibitor API (Ascential_Exhibitor_API/services/apexrest/ExhibitorData)
// client_id and client_secret are stored as Custom Setting as GES__c object
public class Exhibitor_Integration {
    public Static String logincallout(){
        System.debug('Inside Exhibitor_Integration.logincallout');
        GES__c CS = GES__c.GetOrgDefaults();//geting credentials from custom setting
        
        //getting session id
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Ascential_Exhibitor_API/services/oauth2/token');
        req.setMethod('POST'); 
        req.setBody('grant_type=password' +'&client_id=' + CS.clientId__c +
                    '&client_secret=' + CS.clientSecret__c+'&username=' + '{!HTMLENCODE($Credential.Username)}' +
                    '&password=' + '{!HTMLENCODE($Credential.Password)}'); 
        System.debug('req Body'+req.getBody());
        
        Http http = new Http(); 
        HttpResponse res= new HttpResponse();
        if(Test.isRunningTest()){
            res.setBody('{"access_token":"12345678","instance_url":"cs89.salesforce.com","id":"test.salesforce.com/id/00D0E0000008mI0UAI/0050E000000lKgqQAE","token_type":"Bearer","issued_at":"1520575954174","signature":"314gGMiGnMuoMB96qXxZQ7xjACMb3qp2r7GctzgswO8="}');
        }
        else{
            res = http.send(req);
        }
        
        system.debug('Returned Body'+res.getBody());
        
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        String sessionidStr =(string) results.get('access_token');
        if(sessionidStr == null){
            
            system.debug('res body'+res.getBody());
        }
        /*system.debug('sessionidStr from login '+sessionidStr );
        system.debug('Return URL===>'+(String)results.get('instance_url'));
        System.debug('Exiting Exhibitor_Integration.logincallout');*/
        return sessionidStr;
    }
    
    public Static map<string,object> getAsset(String EventName,String sessionidStr){
        System.debug('Inside Exhibitor_Integration.getAsset');
        //String sessionidStr=logincallout();//get session id
        
        //get assest data from exhibitor api
        HttpRequest req=new HttpRequest();
        req.setEndpoint('callout:Ascential_Exhibitor_API/services/apexrest/ExhibitorData?Event_name='+EventName);
        //req.setEndpoint('callout:Ascential_Exhibitor_API/services/apexrest/ExhibitorData');
        req.setMethod('GET'); 
        req.setHeader('Authorization', 'OAuth '+sessionidStr);
        req.setHeader('Content-Type', 'application/json; charset=UTF-8');
        req.setTimeout(120000);
        
        Http http = new Http();
        HttpResponse res = new HttpResponse();
        
        if(Test.isRunningTest()){
            res.setStatusCode(200);
            res.setBody('{"orders":[{"order":{"webuser_password":"999137267120171009","web_level":"Full","standinfo":{"width":2.00,"trg_event_name":"CWIEME Berlin 2018","total_area":4.00,"standholder_id":"9991372671","stand_nbr":"E1","space_type":"Shell Basic","section":"Components, Devices, Subsystems","open_sides":"1","nameboard":"New Co","length":2.00,"hall":null,"category":null,"adj_width":null,"adj_space_types":null,"adj_length":null},"postal_code":"AA12BA","original_order_id":"OPP-589713","order_type":"New Business","order_status":"CR","opportunity_id":"OPP-589713","line_2":null,"line_1":"Street1","inactive":false,"exhibitor_name":"New Co","exhibitor_id":"9991372671","exhibitor_booking_id":"0060E000006qoBGQAY","create_new_profile":"Y","country":"United Kingdom","communications":[{"source":"main contact","requester_contact_name":null,"main_contact_name":"Test Bloke","forms_contact_name":null,"communication":[{"type":"email","text":"test.bloke@test.com"}]},{"source":"forms contact","requester_contact_name":null,"main_contact_name":null,"forms_contact_name":"Test Bloke","communication":[{"type":"phone","text":null},{"type":"email","text":"test.bloke@test.com"},{"type":"fax","text":null}]},{"source":"requester contact","requester_contact_name":"Test Bloke","main_contact_name":null,"forms_contact_name":null,"communication":[{"type":"phone","text":null},{"type":"email","text":"test.bloke@test.com"},{"type":"fax","text":null},{"type":"webaddress","text":null}]},{"source":"organisation","requester_contact_name":null,"main_contact_name":null,"forms_contact_name":null,"communication":[{"type":"phone","text":null},{"type":"email","text":"test.bloke@test.com"},{"type":"fax","text":null},{"type":"webaddress","text":null}]}],"city":"London","brand":[],"address":[{"source":"forms contact","postal_code":"AA12BA","line_1":"Street1","county":null,"country":"Street1","city":"London"},{"source":"requester contact","postal_code":"AA12BA","line_1":"Street1","county":null,"country":"United Kingdom","city":"London"},{"source":"organisation","postal_code":"AA12BA","line_1":"Street1","county":null,"country":"United Kingdom","city":"London"}]}}]}');
        }
        else{
            //system.debug('get request===>'+req);
            res = http.send(req);
        }
        
        try
        {
            // If the request is successful, parse the JSON response.
            if (res.getStatusCode() == 200) {
                // Deserialize the JSON string into collections of primitive data types.
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                System.debug('Returned Asset data===>'+res.getBody());
                System.debug('Exiting Exhibitor_Integration.getAsset');
                return results;
            }
            else{
                System.debug('Exiting Exhibitor_Integration.getAsset');
                System.debug('Returned Status Code====>'+res.getStatusCode());
                System.debug('Returned Status====>'+res.getStatus());
                System.debug('Returned Body====>'+res.getBody());
                CalloutException e = new CalloutException();
                e.setMessage('Invalid Get query. Please check!');
                throw e;
                
            }
            
        }
        catch (Exception e)
        { // gotta catch em all!
            system.debug('Error in API Call===>'+e);
            return null;
        }
    }
}