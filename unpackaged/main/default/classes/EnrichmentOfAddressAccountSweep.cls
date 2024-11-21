Public class EnrichmentOfAddressAccountSweep{
    //global   String  query;
    //String RUser = '00540000003EhZ9';
   // String BCountry = 'US';
    final String country;
    final String baseURLForGlobal;
    final String baseURLForPersonator;
    final string errorCodesFromSetting;
    final string customerId;
    final string melissaOptions;

    final Integer melissaAddCharLen;
    
      public EnrichmentOfAddressAccountSweep(){
        
            Map<String,MelissaSetting__c> melissaSetting = MelissaSetting__c.getAll();   //  get value from custom setting 
            country=melissaSetting.get('MelisaPersonatorCountry').value__c;
            baseURLForGlobal=melissaSetting.get('Melissa GlobalAddress URL').value__c;
            baseURLForPersonator=melissaSetting.get('Melissa Personator URL').value__c;
            errorCodesFromSetting=melissaSetting.get('Melissa Error Codes').value__c;
            customerId=melissaSetting.get('Melissa ClientId').value__c;
            melissaOptions=melissaSetting.get('Melissa Options').value__c;
            melissaAddCharLen=Integer.valueOf(melissaSetting.get('Melissa Min Address Length').value__c);

            
    }
    
    public void enrichMelissaAddress(List<sObject> objRec){ 
     
     //final  Map<String,MelissaSetting__c> melissaSetting = MelissaSetting__c.getAll();
    // final Integer melissaAddCharLen=Integer.valueOf(melissaSetting.get('Melissa Min Address Length').value__c);
     List<Account> ExhiList = new List<Account>();
     Boolean isPersoantorURL = true;
     string endPointURL;
      final string personatorCountry;
    // final string country=Label.PersonatorCountry;
    // final String errorCodesFromLabel=label.Melissa_ErrorCode;
     final List<String> listErrorCodes=new List<String>();
     boolean isUpdate=true;
     boolean isMelissaError=false;
         
        for (SObject s: objRec) {    
            Account Exhi    = (Account) s;           
            ExhiList.add(Exhi);                         
        }          
        
       //   MelissaJasonRequest reqbody = new MelissaJasonRequest();  
       MelissaPersonatorRequest reqbody = new MelissaPersonatorRequest();             
         for(Account aoj: ExhiList)
         {                       
            MelissaPersonatorRequest.Records Melreq = new MelissaPersonatorRequest.Records();
           // system.debug('**********Label.PersonatorCountry'+Label.PersonatorCountry+'--------'+aoj.BillingCountry);
                if(aoj.BillingCountry!=null && !country.contains(aoj.BillingCountry)){
                       endPointURL=baseURLForGlobal;
                        Melreq.Country = aoj.BillingCountry; 
                         
                       // isPersoantorURL = false;
                        Melreq.Locality = aoj.BillingCity;      
                        Melreq.AdministrativeArea = aoj.BillingState;
                }else{
                       // personatorCountry = aoj.BillingCountry; 
                       endPointURL=baseURLForPersonator;
                        reqbody.Columns='GrpAddressDetails';
                        reqbody.Actions=null;
                        Melreq.City = aoj.BillingCity;
                        Melreq.State = aoj.BillingState;
                }
                reqbody.TransmissionReference='ges test string';
            Melreq.PostalCode = aoj.BillingPostalCode;
            
            Melreq.AddressLine1 = aoj.BillingStreet; 
            Melreq.RecordID = aoj.Id; 
            
            reqbody.CustomerID = customerId;
            reqbody.Options = melissaOptions;                                 
            reqbody.Records.add(Melreq);            
            
         }

        String MELJSON = System.JSON.Serialize(reqbody);      
        system.debug('MELJSON-->'+MELJSON);
      //  endPointURL= isPersoantorURL ? Label.MelissaDataUS : Label.Melissa_Data;
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        
      //  req.setEndpoint(Label.Melissa_Data_Personator);
       system.debug('end point URL : ' + endPointURL );
       req.setEndpoint(endPointURL);
       system.debug('end point URL : ' + endPointURL );
     // endPointURL = isPersoantorURL ? Label.MelissaDataUS : Label.Melissa_Data;
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(MELJSON);
               
              
                res = http.send(req);
                System.debug('responseBody: '+res.getBody()); 
                String JsonMELResp = res.getBody();    
                System.debug('JsonMELResp : '+res.getBody()); 
                   
           // MelissaPersonatorResponse MELResponse = MelissaPersonatorResponse.parse(JsonMELResp); 
           //Map<Id,MelissaPersonatorResponse.Records> MELMap = new Map<Id,MelissaPersonatorResponse.Records>();
            List<Account> UpdateIntakes = new List<Account>();
            List<Webservice_Log__c> wsList = new List<Webservice_Log__c>();
            
             if(JsonMELResp!=null && JsonMELResp.length()>0){
           
            // deserialize JSON response to MelissaJasonResponse object
          //  MelissaJasonResponse MELResponse = MelissaJasonResponse.parse(JsonMELResp);
          MelissaPersonatorResponse MELResponse = MelissaPersonatorResponse.parse(JsonMELResp); 
            
          
            // map of Account id to Addresses(retruned from mellisa)
          //  Map<Id,MelissaJasonResponse.Records> MELMap = new Map<Id,MelissaJasonResponse.Records>();
          Map<Id,MelissaPersonatorResponse.Records> MELMap = new Map<Id,MelissaPersonatorResponse.Records>();
           

                 
            if(MELResponse.Records !=null) {
            
               
            
              
                // iterate through all records in response and put in MAP
                for (integer i = 0 ; i < MELResponse.Records.size(); i++) {                  
                        
                        MELMap.put(MELResponse.Records[i].RecordID.trim(),MELResponse.Records[i]);
                        Webservice_Log__c wsl = new Webservice_Log__c(); 
                        wsl.HTTP_Request__c = MELJSON;
                        wsl.HTTP_Response__c = res.getBody();
                        wsl.Account__c = MELResponse.Records[i].RecordID;      
                        wsl.Integration_Name__c = 'MelissaData';                        
                        wsList.add(wsl);    
                }
                
                   Map<Id,Account> IntakesMap = new Map<Id,Account>([SELECT BillingCountry,BillingStreet,BillingCity,BillingState,BillingPostalCode,Melissa_Integration_Status__c,Melissa_Results__c,Delivery_Indicator__c FROM Account WHERE Id IN : MELMap.KeySet()]);
                
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
                for(id accountID : MELMap.keySet()) {
                  
                    // check if recordId(found in callout response) present in Account
                    if(IntakesMap.containsKey(accountID)){ 
                    
                    system.debug('========intakesmap===============' +  IntakesMap.containsKey(accountID));
                        
                            Account intakes = IntakesMap.get(accountID);
                            
                       
                       
                            
                            // check whether mellisa API result have to be ignored, if yes set status=='succes'
                            // check callout response 
                            if(res.getStatusCode() == 200  ) {
                                system.debug( ' CallResponse ++ ' + res.getStatusCode());

                                system.debug( ' result code ++ ' + MELMap.get(intakes.Id).Results );
                                // if result exists, check first errorCodein label exist or not
                                system.debug('=============listErrorCodes>'+listErrorCodes);
                                if( (MELMap.get(intakes.Id).Results!= null ) && !listErrorCodes.isEmpty()){
                                                 system.debug('inside if');                                                   // if error code exists then match mellisa result with label
                                        for( integer i=0; i< listErrorCodes.size(); i++){
                                                system.debug('MELMap.get(intakes.Id).Results.contains(listErrorCodes[i]==='+MELMap.get(intakes.Id).Results.contains(listErrorCodes[i])+'MELMap.get(intakes.Id).Results.contains(listErrorCodes[i]----'+MELMap.get(intakes.Id).Results);
                                            if(MELMap.get(intakes.Id).Results.contains(listErrorCodes[i])){
                                                isUpdate = false;
                                                isMelissaError= true;
                                            }

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
                                     intakes.BillingStreet   = MELMap.get(intakes.Id).AddressLine1+' '+addressLine2+' '+addressLine3+' '+addressLine4;  
                                   // intakes.BillingStreet   = MELMap.get(intakes.Id).AddressLine1; 
                                   // intakes.BillingCountry=intakes.CountryCode;
                                        if(intakes.BillingStreet.length()>=melissaAddCharLen){
                                            
                                            
                                            if(intakes.BillingCountry!=null && !country.contains(intakes.BillingCountry)){
                                                intakes.BillingCountry= MELMap.get(intakes.Id).CountryISO3166_1_Alpha2;
                                                intakes.BillingCity = MELMap.get(intakes.Id).Locality;
                                                intakes.BillingState = MELMap.get(intakes.Id).AdministrativeArea;
                                                   System.debug('BillingCountry: '+MELMap.get(intakes.Id).CountryISO3166_1_Alpha2); 
                                            }else{
                                                intakes.BillingCity = MELMap.get(intakes.Id).City;
                                                intakes.BillingState = MELMap.get(intakes.Id).State;
                                                intakes.BillingCountry =  MELMap.get(intakes.Id).countryCode;
                                                intakes.Delivery_Indicator__c =  MELMap.get(intakes.Id).DeliveryIndicator;
                                                System.debug('BillingCountry Personator: '+MELMap.get(intakes.Id).countryCode ); 
                                                
                                            }  
                                             //  intakes.BillingCountry= MELMap.get(intakes.Id).CountryCode;
                                                intakes.BillingPostalCode   = MELMap.get(intakes.Id).PostalCode;
                                        }
                                            
                                        intakes.Melissa_Integration_Status__c = 'Success';
                                        
                                      //  System.debug('BillingCountry: '+MELMap.get(intakes.Id).CountryCode); 
                                   
                                } else if(isMelissaError){
                                
                                    intakes.Melissa_Integration_Status__c = 'Melissa Error';
                                }
                                                        
                                 
                                intakes.Merge_Flag__c = 'MP'; 
                                intakes.Melissa_Results__c = MELMap.get(intakes.Id).Results;
                            } 

                           
                        UpdateIntakes.add(intakes); 
                        
                    } // end of mapcoreexhibitor contains If 
                    
                } // end of for loop
                
            } // end of meillsaa record null if
          
            
            // Update web service log 
            if(!wsList.isEmpty()|| Test.isRunningTest()) {
                Database.Insert(wsList,false);   
            } 
         
            // Update Account                                         
            if(!UpdateIntakes.isEmpty() || Test.isRunningTest()) {                 
                Database.Update(UpdateIntakes,false);                   
            }
        }//  end of outer if  
        
    }
   

}