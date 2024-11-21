public class SOP_UpsertWrapper {
    
    public static void UpsertOrganisationNoFuture(String upsertRequest)
    {
        String userName;
        String pwd;
        String sessionId;
        //string upsertSerialisedRequest = JSON.serialize(upsertRequest);
        
        SOPAuthentication__c auth = SOPAuthentication__c.getValues('Login Credentials');
        userName = auth.Username__c;
        pwd = auth.Password__c;
        system.debug(userName + ',' + pwd);
        // we must authenticate against viad services first
        sessionId = authenticate(userName, pwd);
        system.debug('session id:' + sessionId); 
        callUpsertOrganisation(sessionId, upsertRequest);       
        
        //SOP_VIAD_V2.SalesforceUpsertOrganisationResult upsertResult = SOP_APIIntegration.UpsertOrganisation(sessionId,upsertRequest);  
    }
    
    @future (callout=true)
    // TO DO, we need to generalise this, add in a new parament for type, eg contact / org or stand
    public static void UpsertOrganisation(String upsertRequest)
    {
         UpsertOrganisationNoFuture(upsertRequest);
    }
    
    /*public static void UpsertContactNoFuture(String upsertRequest)
    {
        String userName;
        String pwd;
        String sessionId;
        
        SOPAuthentication__c auth = SOPAuthentication__c.getValues('Login Credentials');
        userName = auth.Username__c;
        pwd = auth.Password__c;
        system.debug('In SOP_UpserWrapper.UpsertContactuserName' + userName + ',' + pwd);
        
        // we must authenticate against viad services first
        sessionId = authenticate(userName, pwd);
        system.debug('session id:' + sessionId); 
        
        callUpsertContact(sessionId, upsertRequest) ;
    }*/   

    public static void UpsertContactNoFuture(List<String> upsertRequest){
        String userName;
        String pwd;
        String sessionId;
        
        SOPAuthentication__c auth = SOPAuthentication__c.getValues('Login Credentials');
        userName = auth.Username__c;
        pwd = auth.Password__c;
        system.debug('In SOP_UpserWrapper.UpsertContactuserName' + userName + ',' + pwd);
        
        // we must authenticate against viad services first
        sessionId = authenticate(userName, pwd);
        system.debug('session id:' + sessionId); 
        
        callUpsertContact(sessionId, upsertRequest) ;
    }

    /*@future (callout=true)
    public static void UpsertContact(String upsertRequest)
    {
        UpsertContactNoFuture(upsertRequest);
    }*/  

    @future (callout=true)
    public static void UpsertContact(List<String> upsertRequest){
        UpsertContactNoFuture(upsertRequest);
    }  
    
    private static void callUpsertOrganisation(string sessionId, string upsertRequest)
    {
        boolean updateAccount = false;
        SOP_VIAD_V2.SalesforceUpsertOrganisationResult upsertResult = SOP_APIIntegration.UpsertOrganisation(sessionId,upsertRequest);  

        //system.debug('eu-' + upsertResult.EUSopID + ', UK-' + upsertResult.UKSopID +', ME-' + upsertResult.MESopID + ',id - ' + upsertResult.SalesforceID);
        // Load the account here and set the three sop ids
        if(upsertResult!=null){
        
            Account acct = [SELECT id,name, UK_SOP_ID__c, EURO_SOP_ID__c, ME_SOP_ID__c FROM Account WHERE id = :upsertResult.SalesforceID];
        
        
        // set the new values
            if(string.isBlank(acct.UK_SOP_ID__c) && upsertResult.UKSopID != null)
            {
                updateAccount = true;
                acct.UK_SOP_ID__c =  string.valueof(upsertResult.UKSopID);
            }
         
            if(string.isBlank(acct.EURO_SOP_ID__c) && upsertResult.EUSopID !=null)
            {
                updateAccount = true;
                acct.EURO_SOP_ID__c =  string.valueof(upsertResult.EUSopID);
            }
            
            if(string.isBlank(acct.ME_SOP_ID__c) && upsertResult.MESopID != null)
            {
                updateAccount = true;
                acct.ME_SOP_ID__c = string.valueof(upsertResult.MESopID);
            }
            
            if(updateAccount = true)
            {
                system.debug('UpdateAccount was set to ' + updateAccount);
                update acct;
            }
        }
    }

    /*private static void callUpsertContact(string sessionId, string upsertRequest)
    {
        //system.debug('In SOP_UpsertWrapper.calUpsertContact');
        string result = SOP_APIIntegration.UpsertContact (sessionId,upsertRequest);  
        
        if(!string.isEmpty(result))
        {
            // if we have something is in the string, we've had an error, normally wouldn't have a response
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            List<string> sendTo = new List<string>();
            sendTo.add('MAWallace@ges.com');
            sendTo.add('AModhvadia@ges.com');
            mail.setToAddresses(sendTo);
            
            mail.setReplyto('NoReply@ges.com');
            mail.setSubject('Error in Upsert Contact');
            
            //construct the message
            String body = 'An error has occured during the Upsert Contact from Salesforce to SOP.';
            body += 'Can you please review the error below.';
            body += result;
            mail.setHtmlBody(body);
            mails.add(mail);
            
            Messaging.sendEmail(mails);
        }
    }*/

    private static void callUpsertContact(string sessionId, List<String> upsertRequest)
    {
        //system.debug('In SOP_UpsertWrapper.calUpsertContact');
        //string result = SOP_APIIntegration.UpsertContact (sessionId,upsertRequest); 
        String[] result = new List<String>();
        
        for(String req :upsertRequest) {
            result.add(SOP_APIIntegration.UpsertContact (sessionId,req));
        }
        
        if(!result.isEmpty() && result[0] == null){
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            List<string> sendTo = new List<string>();
            //sendTo.add('MAWallace@ges.com');
            //sendTo.add('AModhvadia@ges.com');
            sendTo.add('ddunkley@ges.com');
            mail.setToAddresses(sendTo);
            
            mail.setReplyto('NoReply@ges.com');
            mail.setSubject('Error in Upsert Contact');
            
            //construct the message
            String body = 'An error has occured during the Upsert Contact from Salesforce to SOP.';
            body += 'Can you please review the error below.\n';
            for(String res :result){
                body += res+'\n';
            }
            mail.setHtmlBody(body);
            mails.add(mail);
            
            if(!mails.isEmpty()){
                Messaging.sendEmail(mails);
            }
        }
    }

    private static string authenticate(string userName, string pwd){
  
        SOP_wwwViadComSecurityV2.AppSessionInfo sessionInfo;
        
            System.debug('Username: ' + userName + ', password: ' + pwd);
            try{
                sessionInfo = SOP_APIIntegration.authenticate(userName, pwd);
                }
            catch(exception e){
                system.debug('*********************ERROR: '+e.getMessage());
            }
        if (sessionInfo != null)
        {
            return sessionInfo.SessionId;
        }
        else
            return null;

    }

}