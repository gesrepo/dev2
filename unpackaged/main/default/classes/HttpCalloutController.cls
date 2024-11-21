/*********************************************************************
    Date    : 18 April 2017 
    Note    : This class contains one method getCalloutResponseContents() that returns callout response.
              We can use this class to perform HTTP callout when request is in JSON.
    Change History
    =============
    Developer       Modified On     Change description
                  
**********************************************************************/
public class HttpCalloutController {

  Map<String,MelissaSetting__c> melissaSetting = MelissaSetting__c.getAll();

  decimal counterFromSetting=decimal.valueOf(melissaSetting.get('Melissa Counter').value__c);

  // Pass in the endpoint/Method(GET/POST/PUT etc.)/request body to be used using the string url
  public HttpResponse getCalloutResponseContents(String url, string HTTPMethod, map<string,string> mapOfHeader, string jsonBody, boolean isCompressed) {
    
    HttpResponse response ;
 
    // Instantiate a new http object
    Http h = new Http();
    system.debug('my request ++ ' + jsonBody );
    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
    HttpRequest req = new HttpRequest();
    req.setEndpoint(url);
    req.setMethod(HTTPMethod);
    req.setBody(jsonBody);
    // to support multiple headers
    for(string headerkey : mapOfHeader.keyset()){
        req.setHeader(headerkey, mapOfHeader.get(headerkey));
    }
    req.setCompressed(isCompressed);
    req.setTImeout(120000);

    // Send the request, and return a response
    system.debug('**************req'+req);
    try{
       
        response = h.send(req);
        System.debug('responseBody: '+response.getBody()); 
        
    }catch(System.CalloutException ex){
        
        // Log the exception
        APEXLog__c log = new APEXLog__c(); 
        log.ClassName__c = 'HttpCalloutCOntroller';
        log.Message__c = ex.getMessage();
        log.StackTrace__c =  ex.getStackTraceString();
        log.Method__c = 'getCalloutResponseContents';      
        log.RecordId_Data__c = jsonBody;                       
        insert log;
    }
    return response;
  }
  
   // Pass in the endpoint/Method(GET/POST/PUT etc.)/request body to be used using the string url
  public HttpResponse getCalloutResponseContentsMelissa(Map<Id,CORE_EXHIBITOR__c> mapCoreExhibitor,String url, string HTTPMethod, map<string,string> mapOfHeader, string jsonBody, boolean isCompressed) {
    
    HttpResponse response ;
   
    // Instantiate a new http object
    Http h = new Http();
    system.debug('my request ++ ' + jsonBody );
    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
    HttpRequest req = new HttpRequest();
    req.setEndpoint(url);
    req.setMethod(HTTPMethod);
    req.setBody(jsonBody);
    // to support multiple headers
    for(string headerkey : mapOfHeader.keyset()){
        req.setHeader(headerkey, mapOfHeader.get(headerkey));
    }
    req.setCompressed(isCompressed);
    req.setTImeout(120000);

    // Send the request, and return a response
    system.debug('**************req'+req);
    try{
       
        response = h.send(req);
        System.debug('responseBody: '+response.getBody()); 
        
    }catch(System.CalloutException ex){
        
        Set<ID> setCoreExhbID=new Set<ID>();
        List<CORE_EXHIBITOR__c> listCoreExhbt=new List<CORE_EXHIBITOR__c>();
        for(Id coreexhbtID: mapCoreExhibitor.keyset()){
            system.debug('============>jsonBody'+jsonBody+'------'+jsonBody.contains(coreexhbtID));
            //if(jsonBody!=null && jsonBody.contains(coreexhbtID)){
                setCoreExhbID.add(coreexhbtID);
            //}
        }
        for(CORE_EXHIBITOR__c objCoreExhbt:[select Counter__c,Melissa_Integration_Status__c,Melissa_Results__c from CORE_EXHIBITOR__c where id in :setCoreExhbID]){
            
            objCoreExhbt.Counter__c=objCoreExhbt.Counter__c!=null?objCoreExhbt.counter__c:0;
            objCoreExhbt.counter__C=objCoreExhbt.counter__C+1;
            if(objCoreExhbt.Counter__c>=counterFromSetting){
                    objCoreExhbt.Melissa_Integration_Status__c = 'Success';
                    objCoreExhbt.Counter__c=0;
            }else{
                    objCoreExhbt.Melissa_Integration_Status__c ='Failed';
                    objCoreExhbt.Melissa_Results__c=ex.getMessage();
            }
            listCoreExhbt.add(objCoreExhbt);
        }
        
        update listCoreExhbt;
        // Log the exception
        APEXLog__c log = new APEXLog__c(); 
        log.ClassName__c = 'HttpCalloutCOntroller';
        log.Message__c = ex.getMessage();
        log.StackTrace__c =  ex.getStackTraceString();
        log.Method__c = 'getCalloutResponseContents';      
        log.RecordId_Data__c = jsonBody;                       
        insert log;
    }
    return response;
  }
}