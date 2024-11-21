global class BatchableDataComAccountSweep  implements Database.Batchable<sObject>, Database.AllowsCallOuts, Database.Stateful {
    global   String  query;
    String Success = 'Success';
    String recStatus= 'MP';
        
   global BatchableDataComAccountSweep() {    
   
      query = 'select Name, BillingStreet, BillingCity, BillingState, BillingPostalCode,BillingCountry from Account where merge_flag__c = \''+recStatus+'\' LIMIT 9999';                 
   
    } 
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<sObject> scope) {
      
        Set<Id> CustIds = new Set<Id>();
        List<Account> CustList = new List<Account>();
        final String datacomUrl=oAuth__C.getValues('DataComMatch').datacomUrl__C;
        for (SObject s: scope) {    
            Account cust    = (Account) s;           
            CustList.add(cust);    
            CustIds.add(cust.Id);                     
        }          
        
         DunsRightMatchRequest reqbody = new DunsRightMatchRequest();               
         for(Account aoj: CustList)
         {                       
            DunsRightMatchRequest.entities DataComReq = new DunsRightMatchRequest.entities();
            DunsRightMatchRequest.matchOptions DataComFlds = new DunsRightMatchRequest.matchOptions();
                                   
            DataComReq.Name = aoj.Name; 
            
            // DataComReq.Zip = aoj.Melissa_Postal_Code__c;
            // DataComReq.State= aoj.Melissa_State__c;
            // DataComReq.City = aoj.Melissa_City__c;        
            // DataComReq.Street = aoj.Melissa_Address__c; 
            // DataComReq.Country = aoj.Melissa_Country__c; 
            
              DataComReq.Zip = aoj.BillingPostalCode;
              DataComReq.State= aoj.BillingState;
              DataComReq.City = aoj.BillingCity;        
              DataComReq.Street = aoj.BillingStreet; 
              DataComReq.Country = aoj.BillingCountry; 
          
            DataComReq.attributes.type = 'DatacloudCompany';                                           
            reqbody.entities.add(DataComReq);  
         }
        
        String DataComJSON = System.JSON.Serialize(reqbody);         
        system.debug('DataComJSON-->'+DataComJSON);
        
        //Auth_Token__c  oAuthToken = Token_Manager.getToken();   
        Auth_Token__c  oAuthToken = Token_Manager_Account.getToken(); 
        system.debug('oAuthTokenAuth_Token-->'+oAuthToken.Auth_Token__c);
        
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();

        req.setEndpoint(datacomUrl);
        req.setHeader('Authorization', 'Bearer ' +oAuthToken.Auth_Token__c);
        req.setMethod('POST');        
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        req.setBody(DataComJSON);
        req.setCompressed(true);
                      
        try {   
                String JsonDataComResp;
                integer statuscode ;  
                List<DunsRightMatchResponse> DataComResponse = new List<DunsRightMatchResponse>();     
                if(!test.isRunningtest())
                {
                    res = http.send(req);
                    statusCode =res.getStatusCode();
                    System.debug('responseBody: '+res.getBody()); 
                    JsonDataComResp = res.getBody(); 
                    DataComResponse = DunsRightMatchResponse.parseJsonArray(JsonDataComResp); 
                }
                else
                {
                    list<DunsRightMatchResponse.MatchRecords> lstmatchrecord = new list<DunsRightMatchResponse.MatchRecords>();
                    list<DunsRightMatchResponse.errors> lstErrors = new list<DunsRightMatchResponse.errors>();
                    
                    DunsRightMatchResponse.Record obj1 = new DunsRightMatchResponse.Record();
                    obj1.DunsNumber='11';
                    obj1.Name='test';
                    DunsRightMatchResponse.MatchRecords obj2 = new DunsRightMatchResponse.MatchRecords();
                    obj2.matchConfidence =345;
                    obj2.record =obj1;
                    lstmatchrecord.add(obj2);
                    
                    DunsRightMatchResponse.Errors obj5 = new DunsRightMatchResponse.Errors();
                    obj5.statusCode ='404';
                    obj5.message ='URl Not found';
                    lstErrors.add(obj5);
                    DunsRightMatchResponse  obj3 = new DunsRightMatchResponse();
                    obj3.success = true;
                    obj3.matchRecords=lstmatchrecord;
                    DunsRightMatchResponse  obj4 = new DunsRightMatchResponse();
                    obj4.success = false;
                    obj4.Errors=lstErrors;
                    DataComResponse.add(obj3);
                    DataComResponse.add(obj4);
                    statusCode =200;    
                }
                
                List<Account> UpdateIntakes = new List<Account>();
                List<Webservice_Log__c> wsList = new List<Webservice_Log__c>();
                system.debug('DataComResponse-->'+DataComResponse);
                  
                if(DataComResponse != null) {    
                  integer i = 0; 
                  //List<Account> DatacomCustList = new List<Account>([SELECT Id FROM Account WHERE Id IN : CustIds]);     
                  List<Account> DatacomCustList=CustList;
                  for(Account intakes : DatacomCustList) {                                                   
                        if(DataComResponse[i].success == True && statusCode ==200) {                              
                                  Intakes.DUNS_Number__c = DataComResponse[i].MatchRecords[0].Record.DunsNumber;  
                                 // Intakes.Melissa_Address_DUNS__c = DataComResponse[i].MatchRecords[0].Record.DunsNumber;   
                                  Intakes.Alternate_Name__c =  DataComResponse[i].MatchRecords[0].Record.Name;   
                                  Intakes.Match_Confidence__c = DataComResponse[i].MatchRecords[0].matchConfidence; 
                                  Intakes.Merge_Flag__c = 'DP';
                                  Intakes.Data_Com_Integration_Status__c = 'Success';                                                            
                        }  
                        else if(DataComResponse[i].success == False && DataComResponse[i].Errors[0] != null) {                                
                                  Intakes.Data_Com_Error_Message__c = DataComResponse[i].Errors[0].message; 
                                  Intakes.Data_Com_Integration_Status__c = 'Failed';                                                                
                        }                                       
                        UpdateIntakes.add(intakes);  
                        i++;
                 }
             }             
            for(Account acc:UpdateIntakes){
                system.debug('=======>id'+acc.id+'duns number'+acc.DUNS_Number__c);
            }                 
             if(DataComResponse!=null) { 
             Webservice_Log__c wsl = new Webservice_Log__c();                              
                             wsl.Account__c = CustList[0].Id;                            
                             wsl.HTTP_Request__c = DataComJSON;
                             wsl.HTTP_Response__c = res.getBody();
                             wsl.Integration_Name__c = 'Data.Com';            
                             wsList.add(wsl);
              }
                                                     
                 if(wsList.size() > 0) {
                   Database.Insert(wsList,false);   
                 }                                                     
                 if(UpdateIntakes.size() > 0) {
                   Database.Update(UpdateIntakes,false);   
                 }          
        } catch(System.CalloutException e) {
            System.debug('Callout error: '+ e);
            System.debug(res.toString());
        }
    }
   global void finish(Database.BatchableContext bc){       }

}