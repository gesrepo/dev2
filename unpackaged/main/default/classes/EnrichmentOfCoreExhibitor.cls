/*********************************************************************
    Date    : 18 April 2017    
    Note    : This class will be used inside batch class to standardization/enrichment address field and DUNS on CORE_EXHIBITOR__c records.  
    Change History
    =============
    Modified On    modified by  Change description
    04/19/2017                  added this method enrichCoreExihibitorDUNS to populated DUNS on core exihibitor
    04/20/2017                  Modfied this method "EnrichmentOfCoreExihbior" to add condition on endpoint and accordingly request/response modification
    04/21/2017                  modified the log of integration of failed/success as given below
    04/28/2017    Kumud Thakur  Implement custom setting to control Melissa Switch off/On, Error Codes 
                                if Switch off, then all records from mellissa api regardless having error code in the custom setting error codes.
                                If switch on , then the melisa Error records having status melissa errors and available on the manual intervention screen.
                    
**********************************************************************/
Public class EnrichmentOfCoreExhibitor{
    
    
    
    
    public string endPointURL;
    
    final String country;
    final String baseURLForGlobal;
    final String baseURLForPersonator;
    final string errorCodesFromSetting;
    final string customerId;
    final string melissaOptions;
    final decimal counterFromSetting;
    final decimal dataComCounterFromSetting;
    final String switchStatus;
    final String datacomUrl;
    final Integer melissaAddCharLen;
    
    /* 

        Constructor  for intialization of variables

    */
    
    public EnrichmentOfCoreExhibitor(){
        
            Map<String,MelissaSetting__c> melissaSetting = MelissaSetting__c.getAll();   //  get value from custom setting 
            system.debug('+++'+melissaSetting);
        
            country=melissaSetting.get('MelisaPersonatorCountry').value__c;
            baseURLForGlobal=melissaSetting.get('Melissa GlobalAddress URL').value__c;
            baseURLForPersonator=melissaSetting.get('Melissa Personator URL').value__c;
            errorCodesFromSetting=melissaSetting.get('Melissa Error Codes').value__c;
            customerId=melissaSetting.get('Melissa ClientId').value__c;
            melissaOptions=melissaSetting.get('Melissa Options').value__c;
            counterFromSetting=decimal.valueOf(melissaSetting.get('Melissa Counter').value__c);
            dataComCounterFromSetting=decimal.valueOf(melissaSetting.get('datacom Counter').value__c);
            switchStatus=melissaSetting.get('Melissa Switch').value__c;
            melissaAddCharLen=Integer.valueOf(melissaSetting.get('Melissa Min Address Length').value__c);
            datacomUrl=oAuth__C.getValues('DataComMatch').datacomUrl__C;
           
    }
    /* 
    
        Method to get Melissa switch Status
        if switch -On : return true
        switch -Off : return false
        swirch blank or null - treate as on : return true;
        
        @Author :Kumud 
    */
   @TestVisible  private boolean getSwitchStatus(){
        
        
        if(switchStatus!=null && switchStatus.equalsIgnoreCase('On')){
            
            return true;
            
        }else if(switchStatus!=null && switchStatus.equalsIgnoreCase('Off')){
            
            return false;
        }else{
            
            return true;
        }
        
    }
    
    /*   
       Method Desc: pass List of Coreexhibitior records ann return JSON requesti body to send melissa api
       and create request as per the coutry , IF country US,Canada End point will be Personator else global.
       @Author :Kumud 
    */
    
   @TestVisible  private String   melissaRequestBodyInJson(List<CORE_EXHIBITOR__c> listCoreExhb){
        
        
        // creata an instance for mellisa request class         
        MelissaJasonRequestForPersonator melPersontorReq = new MelissaJasonRequestForPersonator();
        MelissaJasonRequestForGlobal melGlobalReq=new MelissaJasonRequestForGlobal();
        // set customer id and options        
       
        String MELJSON;
        boolean isPersontaor=false;
        
        for (CORE_EXHIBITOR__c instCoreExhbitior: listCoreExhb) { 

        
           // CORE_EXHIBITOR__c instCoreExhbitior    = (CORE_EXHIBITOR__c) instRec;  // Type cast sobject to Core Exhibitior object         
            MelissaJasonRequestForPersonator.Records melPersontorReqRecord = new MelissaJasonRequestForPersonator.Records(); 
            MelissaJasonRequestForGlobal.Records melGlobalReqRecord=new MelissaJasonRequestForGlobal.Records();
            
            system.debug('********country'+country+'---------instCoreExhbitior.Country__c'+instCoreExhbitior.Country__c+'---------'+!instCoreExhbitior.Country__c.Contains(country));           
            // perosnator does not need country in request
            if(instCoreExhbitior.Country__c!=null && !country.contains(instCoreExhbitior.Country__c)){      //  need to call global address melissa api as country is not US /Canada
                endPointURL=baseURLForGlobal;
                melGlobalReq.CustomerID=customerId;
                melGlobalReq.Options = melissaOptions;
                melGlobalReq.TransmissionReference='ges test string';
                melGlobalReqRecord.RecordID = instCoreExhbitior.Id; 
                melGlobalReqRecord.AddressLine1 = instCoreExhbitior.Address1__c; 
                melGlobalReqRecord.AddressLine2 = instCoreExhbitior.Address_2__c;
                melGlobalReqRecord.AddressLine3 = instCoreExhbitior.Address_3__c; 
                melGlobalReqRecord.AddressLine4 = instCoreExhbitior.Address_4__c;
                melGlobalReqRecord.Locality = instCoreExhbitior.City__c;  
                melGlobalReqRecord.AdministrativeArea = instCoreExhbitior.State__c;
                melGlobalReqRecord.PostalCode = instCoreExhbitior.Postal_Code__c;
                melGlobalReqRecord.Country = instCoreExhbitior.Country__c; 
                melGlobalReq.Records.add(melGlobalReqRecord);
                isPersontaor=false;
                
            }else{
                
                endPointURL=baseURLForPersonator;
                melPersontorReq.CustomerID = customerId; 
                melPersontorReq.Options = melissaOptions;
                melPersontorReq.TransmissionReference='ges test string';
                melPersontorReq.Columns='GrpAddressDetails';
                melPersontorReq.Actions=null;
                melPersontorReqRecord.RecordID = instCoreExhbitior.Id; 
                melPersontorReqRecord.AddressLine1 = instCoreExhbitior.Address1__c; 
                melPersontorReqRecord.AddressLine2 = instCoreExhbitior.Address_2__c;
                melPersontorReqRecord.AddressLine3 = instCoreExhbitior.Address_3__c; 
                melPersontorReqRecord.AddressLine4 = instCoreExhbitior.Address_4__c;
                melPersontorReqRecord.City =  instCoreExhbitior.City__c;
                melPersontorReqRecord.State = instCoreExhbitior.State__c;
                melPersontorReqRecord.PostalCode = instCoreExhbitior.Postal_Code__c;
                melPersontorReq.Records.add(melPersontorReqRecord); 
                isPersontaor=true;              
            }
            
          
            

        }
        
        //endPointURL = isPersoantorURL ? Label.MelissaDataUS : Label.Melissa_Data;
        system.debug('end point URL : ' + endPointURL );
        // serializing MelissaJasonRequest to JSON to support content type "application/json"        
       // String MELJSON; = System.JSON.Serialize(reqbody);      
     
        if(isPersontaor){
          
            MELJSON= System.JSON.Serialize(melPersontorReq);
        }else{
            MELJSON= System.JSON.Serialize(melGlobalReq);
        }
        system.debug('MELJSON--> before method '+MELJSON+'=========reqbody.Records'+melGlobalReq.Records.size());
        return MELJSON;
    }
    
    
 @TestVisible   private HttpResponse getMelissaResponseInJson( final Map<Id,CORE_EXHIBITOR__c> mapCoreExhibitor,string MELReqJSON, String endPointURL){
        
        // callout class intialization        
        HttpCalloutCOntroller httpCallout = new HttpCalloutCOntroller();
        map<string,string> headers = new map<string,string>();
        headers.put('Content-Type', 'application/json');
        headers.put('Accept', 'application/json');
        // get Response from HTTP callout
        HttpResponse callResponse  = httpCallout.getCalloutResponseContentsMelissa(mapCoreExhibitor,endPointURL, 'POST', headers, MELReqJSON, false); // send request
        
        return callResponse;
    }
    
    

     
    // Enrich exihibitor records using mellisa API    
    public void enrichCoreExhibitorAddress(List<sObject> objRec){
        
        
        //List<CORE_EXHIBITOR__c> listCoreExhibitior=new List<CORE_EXHIBITOR__c>();
        final List<String> listErrorCodes=new List<String>();
        final Map<Id,CORE_EXHIBITOR__c> mapCoreExhibitor=new Map<Id,CORE_EXHIBITOR__c>();
        boolean isUpdate = true;
        decimal counter = 0;
        boolean isMelissaError=false;
         String JsonMELResp;
        for (SObject instRec: objRec) { 
        
            CORE_EXHIBITOR__c instCoreExhbitior    = (CORE_EXHIBITOR__c) instRec;
            system.debug('*********getSwitchStatus+'+getSwitchStatus());
            if(getSwitchStatus() && !instCoreExhbitior.isManualIntervention__c){  // switch on condition
                
                    
                    mapCoreExhibitor.put(instCoreExhbitior.id,instCoreExhbitior);
            }else if(!getSwitchStatus() ||Test.isRunningTest()){ // switch off
                
                    
                    mapCoreExhibitor.put(instCoreExhbitior.id,instCoreExhbitior);
            }
        
        }
         system.debug('*********+++mapCoreExhibitor'+mapCoreExhibitor.size());       
        String MELJSON = melissaRequestBodyInJson(mapCoreExhibitor.values());  // call method to make json request for melissa     
        system.debug('MELJSON--> after call method '+MELJSON);
        system.debug('**********endPointURL'+endPointURL);
        HttpResponse callResponse;
        if(String.isNotBlank(MELJSON) && String.isNotBlank(endPointURL)){
            
            callResponse= getMelissaResponseInJson(mapCoreExhibitor,MELJSON,endPointURL);  // call method send req and get Response from melissa API
            if(callResponse!=null){
                JsonMELResp = callResponse.getBody();  
            }
             
        }
        //HttpResponse 
        
       
        
        
        if(JsonMELResp!=null && JsonMELResp.length()>0 ){
           
            // deserialize JSON response to MelissaJasonResponse object
            system.debug('**********JsonMELResp*'+JsonMELResp);
            MelissaJasonResponse MELResponse = MelissaJasonResponse.parse(JsonMELResp);
            
          
            // map of coreExihibitor id to Addresses(retruned from mellisa)
            Map<Id,MelissaJasonResponse.Records> MELMap = new Map<Id,MelissaJasonResponse.Records>();
            List<CORE_EXHIBITOR__c> UpdateIntakes = new List<CORE_EXHIBITOR__c>();
            List<Webservice_Log__c> wsList = new List<Webservice_Log__c>();
                 
            if(MELResponse.Records !=null) { 
              
                // iterate through all records in response and put in MAP
                for (integer i = 0 ; i < MELResponse.Records.size(); i++) {                  
                        
                        MELMap.put(MELResponse.Records[i].RecordID.trim(),MELResponse.Records[i]);
                        Webservice_Log__c wsl = new Webservice_Log__c(); 
                        wsl.HTTP_Request__c = MELJSON;
                        wsl.HTTP_Response__c = callResponse.getBody();
                        wsl.CORE_EXHIBITOR__c = MELResponse.Records[i].RecordID;      
                        wsl.Integration_Name__c = 'MelissaData';                        
                        wsList.add(wsl);    
                }
                
                
                
                // check whether any error code exists
                //in below lines make a set of error code. get from custom setting
                
                if(errorCodesFromSetting!=null && errorCodesFromSetting.contains(',')){
                    
                    for(String errCode:errorCodesFromSetting.split(',')){
                        
                        listErrorCodes.add(errCode.trim());
                    }
                }else if(errorCodesFromSetting!=null){
                    
                        listErrorCodes.add(errorCodesFromSetting.trim());
                }
                



                //  iterate over core exihibitor records and update with matching address           
                for(id coreExihibitorId : MELMap.keySet()) {
                  
                    // check if recordId(found in callout response) present in CORE_EXHIBITOR__c
                    if(mapCoreExhibitor.containsKey(coreExihibitorId)){   
                        
                            CORE_EXHIBITOR__c intakes = mapCoreExhibitor.get(coreExihibitorId);
                            
                            // assign error counter to 0 if intakes.Counter__c is null
                            counter = ( intakes.Counter__c==null) ? 0 : intakes.Counter__c;
                            
                            // check whether mellisa API result have to be ignored, if yes set status=='succes'
                            // check callout response 
                            if(callResponse.getStatusCode() == 200 ) {
                                system.debug( ' CallResponse ++ ' + callResponse.getStatusCode());

                                system.debug( ' result code ++ ' + MELMap.get(intakes.Id).Results );
                                // if result exists, check first errorCodein label exist or not
                                if( (MELMap.get(intakes.Id).Results!= null ) && !listErrorCodes.isEmpty()){
                                                                                                    // if error code exists then match mellisa result with label
                                        for( integer i=0; i< listErrorCodes.size(); i++){
                                            
                                            if(MELMap.get(intakes.Id).Results.contains(listErrorCodes[i])){
                                                isUpdate = false;
                                                isMelissaError= true;
                                            }/*else {
                                                
                                                isUpdate = true;
                                                isMelissaError= false;
                                            }*/

                                        }
                                    
                                }else if(String.isBlank(MELMap.get(intakes.Id).Results)){ // if mellisa result does not exist
                                    isUpdate = false;
                                }
                                system.debug('**********isUpdate'+isUpdate);
                                if(isUpdate){  
                                
                                    final String addressLine1=MELMap.get(intakes.Id).AddressLine1!=null?MELMap.get(intakes.Id).AddressLine1:'';
                                    final String addressLine2=MELMap.get(intakes.Id).AddressLine2!=null?MELMap.get(intakes.Id).AddressLine2:'';
                                    final String addressLine3=MELMap.get(intakes.Id).AddressLine3!=null?MELMap.get(intakes.Id).AddressLine3:'';
                                    final String addressLine4=MELMap.get(intakes.Id).AddressLine4!=null?MELMap.get(intakes.Id).AddressLine4:'';
                                
                                    //intakes.Address1__c=intakes.Address1__c!=null?intakes.Address1__c.trim():intakes.Address1__c;
                                  
                                    
                                   // intakes.Address1__c = MELMap.get(intakes.Id).AddressLine1+' '+addressLine2+' '+addressLine3; 
                                    intakes.Address1__c=addressLine1;
                                    intakes.Address_2__c =addressLine2;
                                    intakes.Address_3__c =addressLine3;
                                    intakes.Address_4__c =addressLine4;
                                    final String conCatAddress=(addressLine1+addressLine2+addressLine3+addressLine4).trim();
                                    system.debug(conCatAddress.length());
                                    if( conCatAddress.length()>=melissaAddCharLen){
                                          if( !country.contains(intakes.Country__c)){
                                    
                                                intakes.City__c = MELMap.get(intakes.Id).Locality;
                                                intakes.State__c = MELMap.get(intakes.Id).AdministrativeArea;
                                                 intakes.Country__c  = MELMap.get(intakes.Id).CountryISO3166_1_Alpha2!=null?MELMap.get(intakes.Id).CountryISO3166_1_Alpha2:intakes.Country__c;
                                        }else{
                                            intakes.City__c = MELMap.get(intakes.Id).City;
                                            intakes.State__c = MELMap.get(intakes.Id).State;
                                            system.debug('************MELMap.get(intakes.Id).CountryCode****'+MELMap.get(intakes.Id).CountryCode);
                                            intakes.Country__c  = MELMap.get(intakes.Id).CountryCode!=null?MELMap.get(intakes.Id).CountryCode:intakes.Country__c;
                                        }  
                                        //system.debug('********'+MELMap.get(intakes.Id).CountryISO3166_1_Alpha2+'***********'+MELMap.get(intakes.Id).CountryISO3166_1_Alpha3);
                                        //system.debug('***********'+MELMap.get(intakes.Id).CountryName);
                                       
                                        intakes.Postal_Code__c = MELMap.get(intakes.Id).PostalCode;
                                        
                                        intakes.Counter__c = 0;
                                    }
                                    intakes.Melissa_Integration_Status__c = 'Success';
                                }else{
                                   
                                   system.debug('error found');
                                   intakes=setStatusForRecord(intakes,isMelissaError,counter);  // set core exhibitor status as per different conditions


                                }       
                                                        
                                 
                                    intakes.Melissa_Results__c = MELMap.get(intakes.Id).Results;
                            } 
                            else{
                                    system.debug('error found');
                                    intakes=setStatusForRecord(intakes,isMelissaError,counter);
                            } 
                           
                        UpdateIntakes.add(intakes); 
                        
                    } // end of mapcoreexhibitor contains If 
                    
                } // end of for loop
                
            } // end of meillsaa record null if
          
            
            // Update web service log 
            if(!wsList.isEmpty() || Test.isRunningTest()) {
                Database.Insert(wsList,false);   
            } 
         
            // Update CORE_EXHIBITOR__c                                         
            if(!UpdateIntakes.isEmpty()|| Test.isRunningTest()) {                 
                Database.Update(UpdateIntakes,false);                   
            }
        }//  end of outer if  
    }
    
    
   @TestVisible private CORE_EXHIBITOR__c setStatusForRecord(CORE_EXHIBITOR__c intakes,boolean isMelissaError, decimal counter){
            system.debug('switch status ++ ' + getSwitchStatus());
            if(!getSwitchStatus()) {   //  switch off
                
                intakes.Melissa_Integration_Status__c = 'Success';
                intakes.Counter__c=0;
            }
            else{
                intakes.Counter__c=intakes.Counter__c+1;                            
                            
                if(intakes.Counter__c>=counterFromSetting){
                 system.debug('counter ++ ' + intakes.Counter__c);
                    intakes.Melissa_Integration_Status__c = 'Success';
                    intakes.Counter__c=0;
                }else{
                        system.debug('mellisa error + ' + isMelissaError);
                        if(isMelissaError){
                            intakes.Melissa_Integration_Status__c = 'Melissa Error';  
                            intakes.isManualIntervention__c=true;
                            intakes.Counter__c=0;
                        }else{
                            intakes.Melissa_Integration_Status__c = 'Failed';  
                            //intakes.Counter__c = counter + 1;  
                        }
                }                                

            }
        return intakes;
        

    }
    
    /* Enrich Exhibitor records using DataDotCom API 
       Parameter : List of CoreExhibitor, which got success from melissa 
       Desc:  To get the DUNS Number by passing, Name and Address to the Data.com API.
    
    */
    
    
    public List<CORE_EXHIBITOR__c> enrichCoreExhibitorDUNS(List<sObject> objRec){
    
        system.debug('*******objRec'+objRec);
        List<CORE_EXHIBITOR__c> custList = new List<CORE_EXHIBITOR__c>();
        DunsRightMatchRequest reqbody = new DunsRightMatchRequest();    
        DunsRightMatchRequest.matchOptions DataComFlds = new DunsRightMatchRequest.matchOptions();
        
        for (SObject s: objRec) {    
            CORE_EXHIBITOR__c cust    = (CORE_EXHIBITOR__c) s;           
            custList.add(cust);  
            
                 
            DunsRightMatchRequest.entities DataComReq = new DunsRightMatchRequest.entities();
                                   
            DataComReq.Name = cust.Company_Name__c; 
            DataComReq.Zip = cust.Postal_Code__c;
            DataComReq.State= cust.State__c;
            DataComReq.City = cust.City__c;        
            DataComReq.Street = cust.Address1__c +' '+cust.Address_2__c+' '+cust.Address_3__c+' '+cust.Address_4__c; 
            DataComReq.Country = cust.Country__c; 
            DataComReq.attributes.type = 'DatacloudCompany';                                           
            reqbody.entities.add(DataComReq);   
        } 
        String DataComJSON = System.JSON.Serialize(reqbody);         
        system.debug('DataComJSON-->'+DataComJSON);
        Auth_Token__c  oAuthToken = Token_Manager.getToken(); 
        system.debug('oAuthTokenAuth_Token-->'+oAuthToken.Auth_Token__c);
        
        // get Response from HTTP callout
        map<string,string> headers = new map<string,string>();
        headers.put('Authorization', 'Bearer ' +oAuthToken.Auth_Token__c);
        headers.put('Content-Type', 'application/json;charset=UTF-8');
        HttpCalloutController httpCallout = new HttpCalloutController();
        HttpResponse res  = httpCallout.getCalloutResponseContents(datacomUrl, 'POST', headers, DataComJSON, true);
        //System.debug('responseBody: '+res.getBody()); 
        String JsonDataComResp ;
            if(res!=null){
                 JsonDataComResp = res.getBody();
            }
           
       
          
         List<DunsRightMatchResponse> dataComResponse ;     
        //Now that we are done with callouts, we can update the oauth tokens if they changed.
        
        Upsert oAuthToken Name;
        List<CORE_EXHIBITOR__c> UpdateIntakes = new List<CORE_EXHIBITOR__c>();
        try{
            if(res!=null && res.getStatusCode() == 200 ) {
       
                 dataComResponse = DunsRightMatchResponse.parseJsonArray(JsonDataComResp); 
             
                 system.debug('dataComResponse-->'+dataComResponse);
                 system.debug('Ttoal results '+ dataComResponse.size());
                      
                if(dataComResponse != null) {             
                    integer i = 0; 
                    integer success= 0;
                    integer fail=0;    
                    for(CORE_EXHIBITOR__c intakes : custList) {                                                   
                        if(dataComResponse[i].success == True) {     
                            success++;                         
                            intakes.Data_com_DUNS_Number__c = dataComResponse[i].MatchRecords[0].Record.DunsNumber;   
                            intakes.Match_Confidence__c = dataComResponse[i].MatchRecords[0].matchConfidence;    
                            intakes.Data_Com_Integration_Status__c = 'Success';
                            intakes.Oracle_Interface_Status__c='P';
                            intakes.Counter__c=0;                                                          
                        }  
                        else {
                            fail++;
                            intakes.Data_Com_Error_Message__c = dataComResponse[i].Errors[0].message; 
                            intakes.Data_Com_Integration_Status__c = 'Failed'; 
                            intakes.Oracle_Interface_Status__c='P';
                            system.debug('*****intakes.Counter__c*****'+intakes.Counter__c);
                            intakes.Counter__c=intakes.Counter__c==null?0:intakes.Counter__c;                       
                            intakes.Counter__c=intakes.Counter__c+1;                            
                            if(intakes.Counter__c>=dataComCounterFromSetting){
                                intakes.Data_Com_Integration_Status__c = 'Success'; 
                                intakes.Oracle_Interface_Status__c='P';
                                intakes.Counter__c=0;
                            }/*else{
                                intakes.Counter__c=intakes.Counter__c+1;
                            } */                          
                        }  
                        system.debug('*************'+intakes);                      
                        UpdateIntakes.add(intakes);  
                        i++;                                                  
                    }    
                    system.debug('Totla custList'+ custList);
                    system.debug('Totla i'+ i);
                    system.debug('Total success '+ success);
                    system.debug('Totla Failed'+ fail);
                    system.debug('**********UpdateIntakes****'+UpdateIntakes);                                                                                             
                    if(UpdateIntakes.size() > 0 || Test.isRunningTest()) {
                        Database.Update(UpdateIntakes,false);   
                    } 
                         
                } 
            
            }else if(res.getStatusCode() != 200){
                    /* 
                        Below code will run once the status not equal 200 some how, then 
                        counter will get incre
                    
                    */
                    integer i=0;
                    if(JsonDataComResp!=null){
                        dataComResponse = DunsRightMatchResponse.parseJsonArray(JsonDataComResp);
                    }
                    for(CORE_EXHIBITOR__c intakes : custList) { 
                        
                        i++;
                        intakes.Counter__c=intakes.Counter__c==null?0:intakes.Counter__c;
                        intakes.Counter__c= intakes.Counter__c+1;
                        intakes.Data_Com_Integration_Status__c = 'Failed'; 
                        intakes.Oracle_Interface_Status__c='P';
                        intakes.Data_Com_Error_Message__c=dataComResponse[i].Errors[0].message;
                        if(intakes.Counter__c>=dataComCounterFromSetting){
                                intakes.Data_Com_Integration_Status__c = 'Success'; 
                                //intakes.Oracle_Interface_Status__c='P';
                                intakes.Counter__c=0;
                        }
                        UpdateIntakes.add(intakes);
                    }   
            }
        }Catch(exception ex){
        
            for(CORE_EXHIBITOR__c intakes : custList) { 
              
                intakes.Counter__c=intakes.Counter__c==null?0:intakes.Counter__c;
                intakes.Counter__c= intakes.Counter__c+1;
                intakes.Data_Com_Integration_Status__c = 'Failed'; 
                intakes.Oracle_Interface_Status__c='P';
                intakes.Data_Com_Error_Message__c=ex.getMessage();
                if(intakes.Counter__c>=dataComCounterFromSetting){
                        intakes.Data_Com_Integration_Status__c = 'Success'; 
                       // intakes.Oracle_Interface_Status__c='P';
                        intakes.Counter__c=0;
                }
                UpdateIntakes.add(intakes);
             
            }
            
            if(!UpdateIntakes.isEmpty() || Test.isRunningTest()){
                update UpdateIntakes;
            }
             // Log the exception
            APEXLog__c log = new APEXLog__c(); 
            log.ClassName__c = 'MellisaCallOnCoreExihbior';
            log.Message__c = ex.getMessage();
            log.StackTrace__c = ex.getStackTraceString();
            log.Method__c = 'enrichCoreExihibitorDUNS';      
            log.RecordId_Data__c = DataComJSON;                       
            insert log;
        }

        return UpdateIntakes;
    }
}