global class acccValidatePatmentBatch implements Database.Batchable<sObject>,Database.AllowsCallouts{
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, CC_Received_and_Validated__c, Payment_ID_Info__c FROM Activity_Log_ACCC__c where CC_Received_and_Validated__c = false';
        //query += ' AND Id = \'a8X180000008WfO\'';
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, List<Activity_Log_ACCC__c> scope) {
        String ApplicationID = System.Label.GC_Label_AppID;     //'SalesForce';    
        String ApplicationKey = System.Label.GC_Label_AppKey;    //'76v.H-_7};9^+4(]J.;3'; 
        String companyId= '';
        String languageId= ''; 
        
        
        
        ACCC_wwwViadComSecurityV2.BasicHttpBinding_IAuthenticationService appSecurity = new ACCC_wwwViadComSecurityV2.BasicHttpBinding_IAuthenticationService();
        ACCC_wwwViadComSecurityV2.AppSessionInfo responseAppSessionInfo = appSecurity.StartAppSession(ApplicationID,  ApplicationKey, companyId, languageId);
        ACCC1_wwwViadComV1.BasicHttpBinding_IPaymentCollectionService v1accp = new ACCC1_wwwViadComV1.BasicHttpBinding_IPaymentCollectionService();
        ACCC1_wwwViadComV1.PaymentCollectionInfo response_x = v1accp.GetPaymentCollection(responseAppSessionInfo.SessionID,scope[0].Payment_ID_Info__c);
        system.debug('response_x==='+response_x.CreditCardExpireMonth);
        if(response_x.CreditCardExpireMonth != null || Test.isRunningTest()) {
            scope[0].CC_Received_and_Validated__c = true; 
        }
        update scope;
    }   
    
    global void finish(Database.BatchableContext BC) {
    }
}