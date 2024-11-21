global class ACCC_SendEmail{
    webservice static string sendMinimalPaymentMail(Id caseId) {
        Case caseRec = [select Booth__r.BOOTH_ID__c, ContactEmail,Contact.Name,Show_Name__r.Name, Account.Name from Case where Id =: caseId];
        //Contact C = [select Contact.Name from Contact where ID =: caseId];
        String ApplicationID = System.Label.GC_Label_AppID;//'SalesForce';    //change to custom label
        String ApplicationKey = System.Label.GC_Label_AppKey;//'76v.H-_7};9^+4(]J.;3';    //change to custom label
        String companyId= '';
        String languageId= '';
        String boothId = caseRec.Booth__r.BOOTH_ID__c;
        string resultFlag;
        try{
            //Added isRunningTest to skip session code for test class by Sajid 06/02/2023 SFDC-229 SFDC+Twilio ACCC Button on Lightning Page for text reps (ME# 331277)
            ACCC_wwwViadComSecurityV2.AppSessionInfo responseAppSessionInfo = new ACCC_wwwViadComSecurityV2.AppSessionInfo();
            String response_x;
            if(!Test.isRunningTest()){
                ACCC_wwwViadComSecurityV2.BasicHttpBinding_IAuthenticationService appSecurity = new ACCC_wwwViadComSecurityV2.BasicHttpBinding_IAuthenticationService();
                responseAppSessionInfo = appSecurity.StartAppSession(ApplicationID,  ApplicationKey, companyId, languageId);
                system.debug('SessionID==='+responseAppSessionInfo.SessionID);
                system.debug('boothId==='+boothId);
                system.debug('caseRec.Contact.Name==='+caseRec.Contact.Name);
                system.debug('caseRec.Account.Name==='+caseRec.Account.Name);
                system.debug('caseRec.ContactEmail==='+caseRec.ContactEmail);
                system.debug('caseRec.Show_Name__r.name==='+caseRec.Show_Name__r.name);
                ACCC1_wwwViadComV1.BasicHttpBinding_IPaymentCollectionService v1accp = new ACCC1_wwwViadComV1.BasicHttpBinding_IPaymentCollectionService();
                response_x = v1accp.RequestPaymentCollection(responseAppSessionInfo.SessionID,boothId, caseRec.Contact.Name,caseRec.Account.Name,String.valueOf(caseRec.ContactEmail),0.00,caseRec.Show_Name__r.name,'','','');
            }
            system.debug('response_x==='+response_x);
            Activity_Log_ACCC__c varACCC= new Activity_Log_ACCC__c();
            varACCC.Customer_Service_Inquiry_Case__c = caseRec.Id;
            varACCC.Payment_ID_Info__c = +response_x;
            varACCC.Session_ID_info__c= +responseAppSessionInfo.SessionID;
            insert varACCC;
            varACCC.Mail_has_been_Sent_on_Requesting_CC__c = true;
            varACCC.Subject__c = 'Your GES Payment Information - '+caseRec.ContactEmail;
            varACCC.Booth_ID__c= '01000';               
            Update varACCC; 
            resultFlag= 'true';
        }catch(exception e){
            system.debug('error at==='+e.getStackTraceString());
            system.debug('error msg==='+e.getMessage());
            resultFlag= 'false';
        } 
        return resultFlag;
    }  
    //Sajid 06/02/2023 SFDC-229 SFDC+Twilio ACCC Button on Lightning Page for text reps (ME# 331277)
    @AuraEnabled
    public static String sendAnEmail(id recordId)
    {
        System.debug('recordId:: '+recordId);
        
        Case c = [select id, Booth__c from Case where id =: recordId];
        if(c.Booth__c != null)
        {
            Oracle_Show_Booth__c showBooth = [select id, BOOTH_ID__c from Oracle_Show_Booth__c where id =: c.Booth__c];
            
            if(showBooth != null && showBooth.BOOTH_ID__c != null)
            {
                String result = sendMinimalPaymentMail(c.Id);
                return result;
            }
            else
            {
                return 'Please enter the Valid Booth ID';
            }
        }
        return 'Please enter the Valid Booth ID';
    }      
}