public class SQRServiceClient {
    public static Boolean SQRInvoked = false;
    @future(callout=true)
    public static void submitCaseSQRs(Id caseId){
        
        String Comments; 
        DateTime dt = System.now();
        String currentCaseId='';
        
        try{
            CaseToSQRSetting__c CaseToSQRSetting = CaseToSQRSetting__c.getValues('CaseToSQR Webservice Authentication');  //  get values from custom setting 
            
            String loginName= CaseToSQRSetting != null ? CaseToSQRSetting.Username__c : '';  
            String password= CaseToSQRSetting != null ? CaseToSQRSetting.Password__c : '';
            String ApplicationID= CaseToSQRSetting != null ? CaseToSQRSetting.ApplicationID__c : '';
            string ApplicationKey= CaseToSQRSetting != null ? CaseToSQRSetting.ApplicationKey__c : '';
            
            String appSessionId;
            if(!Test.isRunningTest()){
                wwwViadComSecurityV2.BasicHttpBinding_IAuthenticationService authClient=new wwwViadComSecurityV2.BasicHttpBinding_IAuthenticationService();
                authClient.endpoint_x= CaseToSQRSetting != null ? CaseToSQRSetting.Authentication_EndPoint__c : '';
                
                wwwViadComSecurityV2.AppSessionInfo authResponse=authClient.StartAppSession(applicationID,applicationKey,null,null);
                appSessionId=authResponse.SessionID;
                
                system.debug('sessionid=='+authResponse.SessionID);
                system.debug('Expiration==='+authResponse.Expiration);
                
                wwwViadComSecurityV2.AppSessionInfo loginResponse =authClient.UserLogin(appSessionId,loginName,password,null);
                
                system.debug('sessionid=='+loginResponse.SessionID);
                system.debug('Expiration==='+authResponse.Expiration);
            }
            
            //The Type found in the SFDC Case Detail section will be used to determine the additional field values for Oracle SQR – Category, Order Type, LOB & Cause.
            
            Map<String,CaseToSQRMapping__mdt> mCaseToSQRMapping=new Map<String,CaseToSQRMapping__mdt>();
            for (CaseToSQRMapping__mdt mapping:[SELECT SF_Show_Type__c ,CORE_SQR_Cause__c ,CORE_SQR_Cause_Code__c ,
                                                CORE_SQR_LOB__c,CORE_SQR_LOB_Code__c,CORE_SQR_Order_Type__c ,CORE_SQR_Order_Type_Code__c ,
                                                CORE_SQR_Service_Category__c,CORE_SQR_Service_Category_Code__c  FROM CaseToSQRMapping__mdt]){
                                                    mCaseToSQRMapping.put(mapping.SF_Show_Type__c, mapping);
                                                }
            
            wwwViadComV2_SQR.BasicHttpBinding_ISqrService client=new wwwViadComV2_SQR.BasicHttpBinding_ISqrService();
            client.endpoint_x= CaseToSQRSetting != null ? CaseToSQRSetting.Client_EndPoint__c : '';
            
            Case existingsqr = [Select CORE_SQR_Last_Sent_Date__c from Case Where Id = :caseId];
            List <Case> CaseRecords = new List<Case>();
            
            if (existingsqr.CORE_SQR_Last_Sent_Date__c != null) {
                CaseRecords =  [select Id, CaseNumber, Booth__r.BOOTH_ID__c, ContactEmail, ContactPhone, Contact.Name, Show_Name__r.Name, Account.Name, GES_Type__c, CORE_SQR_ID__c, CreatedBy.Name, ContactId,
                                Reason__c, Origin, Refund_Adj_Amount__c, Refund_Adj_Reason_Code__c, Resolution__c, Credit_Memo_Code__c, Status, Send_CORE_SQR_Status__c, CORE_SQR_Last_Sent_Date__c, (select CommentBody, CreatedBy.Name from CaseComments where lastmodifieddate > :existingsqr.CORE_SQR_Last_Sent_Date__c order by CreatedDate), (select id, Name,GES_Type__c,CORE_SQR_Last_Sent_Date__c from Core_SQRs__r) 
                                from Case Where Id = :caseId];
            }
            else {
                CaseRecords =  [select Id, CaseNumber, Booth__r.BOOTH_ID__c, ContactEmail, ContactPhone, Contact.Name, Show_Name__r.Name, Account.Name, GES_Type__c, CORE_SQR_ID__c, CreatedBy.Name, ContactId,
                                Reason__c, Origin, Refund_Adj_Amount__c, Refund_Adj_Reason_Code__c, Resolution__c, Credit_Memo_Code__c, Status, Send_CORE_SQR_Status__c, CORE_SQR_Last_Sent_Date__c, (select CommentBody, CreatedBy.Name from CaseComments order by CreatedDate), (select id, Name,GES_Type__c,CORE_SQR_Last_Sent_Date__c from Core_SQRs__r)  
                                from Case Where Id = :caseId];    
            }
            
            if(!CaseRecords.isEmpty()){
                
                for(Case oCase: CaseRecords){
                    
                    CaseToSQRMapping__mdt mapping = mCaseToSQRMapping.containsKey(oCase.GES_Type__c)?mCaseToSQRMapping.get(oCase.GES_Type__c):null;
                    Integer boothId = oCase.Booth__r.BOOTH_ID__c!=null?Integer.valueOf(oCase.Booth__r.BOOTH_ID__c):null;
                    
                    system.debug('CaseId==='+oCase.Id);
                    system.debug('boothId==='+boothId);
                    system.debug('ContactEmail==='+oCase.ContactEmail);
                    
                    // Twilio Case
                    if(oCase.CreatedBy.Name == 'Twilio Integration' && oCase.ContactId != null){
                        Map<String, Core_SQR__c> mapTypeToCoreSQR = new Map<String, Core_SQR__c>();
                        for(Core_SQR__c cSQR : oCase.Core_SQRs__r){
                            mapTypeToCoreSQR.put(cSQR.GES_Type__c, cSQR);
                        }
                        
                        if(oCase.GES_Type__c != '' && oCase.GES_Type__c != 'Twilio Automatic Case Closure'){
                            if(!mapTypeToCoreSQR.isEmpty() && mapTypeToCoreSQR.containsKey(oCase.GES_Type__c)){
                                Core_SQR__c existingCoreSQR = mapTypeToCoreSQR.get(oCase.GES_Type__c);
                                if(existingCoreSQR != null && existingCoreSQR.Name != null){
                                    wwwViadComDataV2_SQR.SqrUpdateRequest sqrInfo = updateSQR(oCase, mapping, boothId, comments);
                                    sqrInfo.SqrHeaderId= Integer.valueOf(existingCoreSQR.Name);
                                    Integer responseCode;
                                    if(!Test.isRunningTest())
                                        responseCode = client.UpdateSqr(appSessionId,sqrInfo);   
                                    else
                                        responseCode = 1;
                                    
                                    system.debug('Response Code ==='+responseCode);
                                    existingCoreSQR.CORE_SQR_Last_Sent_Date__c = dt;
                                    Update existingCoreSQR;
                                }else{
                                    wwwViadComDataV2_SQR.SqrCreateRequest sqrInfo = createSQR(oCase, mapping, boothId, comments);
                                    Integer responseCode;
                                    if(!Test.isRunningTest())
                                        responseCode=client.SubmitSqr(appSessionId,sqrInfo);
                                    else
                                        responseCode = 1;
                                    
                                    Core_SQR__c coreSQR = new Core_SQR__c();
                                    coreSQR.Name = String.valueOf(+responseCode);
                                    coreSQR.CORE_SQR_Last_Sent_Date__c = dt;
                                    coreSQR.Case__c = oCase.Id;
                                    coreSQR.GES_Type__c = oCase.GES_Type__c;
                                    
                                    insert coreSQR;
                                }
                            }else{
                                wwwViadComDataV2_SQR.SqrCreateRequest sqrInfo = createSQR(oCase, mapping, boothId, comments);
                                Integer responseCode;
                                if(!Test.isRunningTest())
                                    responseCode=client.SubmitSqr(appSessionId,sqrInfo);
                                else
                                    responseCode = 1;
                                
                                Core_SQR__c coreSQR = new Core_SQR__c();
                                coreSQR.Name = String.valueOf(+responseCode);
                                coreSQR.CORE_SQR_Last_Sent_Date__c = dt;
                                coreSQR.Case__c = oCase.Id;
                                coreSQR.GES_Type__c = oCase.GES_Type__c;
                                
                                insert coreSQR;
                            }
                        }
                    }else{
                        if (oCase.CORE_SQR_ID__c == null){
                            wwwViadComDataV2_SQR.SqrCreateRequest sqrInfo = createSQR(oCase, mapping, boothId, comments);
                            Integer responseCode;
                            if(!Test.isRunningTest())
                                responseCode=client.SubmitSqr(appSessionId,sqrInfo);
                            else
                                responseCode = 1;
                            
                            oCase.CORE_SQR_ID__c = String.valueOf(+responseCode);
                            oCase.CORE_SQR_Last_Sent_Date__c = dt;
                            
                            Update oCase;                       
                        }
                        else{
                            wwwViadComDataV2_SQR.SqrUpdateRequest sqrInfo = updateSQR(oCase, mapping, boothId, comments);
                            sqrInfo.SqrHeaderId= Integer.valueOf(oCase.CORE_SQR_ID__c);
                            Integer responseCode;
                            if(!Test.isRunningTest())
                                responseCode = client.UpdateSqr(appSessionId,sqrInfo);   
                            else
                                responseCode = 1;
                            
                            system.debug('Response Code ==='+responseCode);
                            oCase.CORE_SQR_Last_Sent_Date__c = dt;
                            currentCaseId=oCase.id;
                            Update oCase;
                        }
                    }
                }
            }
            
        }
        catch(Exception e){
            
            /*Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
String[] toAddresses = new String[] {'snair@ges.com','rsinha@ges.com'};
mail.setToAddresses(toAddresses);
mail.setReplyTo('snair@ges.com');
mail.setSenderDisplayName('Apex error message');
mail.setSubject('Error from Org&nbsp;: ' + UserInfo.getOrganizationName());
mail.setPlainTextBody(e.getMessage()+'case Id='+currentCaseId+'user='+UserInfo.getUserId());
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });*/
            System.debug(e);
        }   
    }
    
    public static wwwViadComDataV2_SQR.SqrCreateRequest createSQR(Case oCase, CaseToSQRMapping__mdt mapping, Integer boothId, String comments){
        for(CaseComment comm : oCase.CaseComments){
            comments=comm.CreatedBy.Name + ': ' + comm.CommentBody + ' \r\n' + (comments != NULL ? comments : '');  
        }
        
        wwwViadComDataV2_SQR.SqrCreateRequest sqrInfo=new wwwViadComDataV2_SQR.SqrCreateRequest();
        
        sqrInfo.ContactEmail=oCase.ContactEmail;
        sqrInfo.ContactName=oCase.Contact.Name;
        sqrInfo.ContactPhone=oCase.ContactPhone;
        sqrInfo.CustomerBoothId=boothId;
        sqrInfo.Description=oCase.CaseNumber +' - '+ oCase.GES_Type__c +' - '+ oCase.Reason__c;
        sqrInfo.LineOfBusiness = mapping != null ? mapping.CORE_SQR_LOB_Code__c : null; 
        sqrInfo.OrderType= mapping != null ? mapping.CORE_SQR_Order_Type_Code__c : null;
        sqrInfo.Priority='L'; //Low
        sqrInfo.ServiceCategory=mapping !=null ? mapping.CORE_SQR_Service_Category_Code__c : null;
        sqrInfo.Cause= mapping != null ? mapping.CORE_SQR_Cause_Code__c : null;
        sqrInfo.Source='N'; //National Servicenter
        if (oCase.Status == 'Closed') {
            sqrInfo.Status='C'; 
            oCase.Send_CORE_SQR_Status__c = 'Closed'; 
        }
        else if (oCase.Send_CORE_SQR_Status__c == 'In Process' && oCase.Status != 'Closed') {
            sqrInfo.Status='I'; 
        }
        else if (oCase.Send_CORE_SQR_Status__c == 'Closed') {
            sqrInfo.Status='C'; 
        }
        sqrInfo.Comments=(comments != NULL ? 'Case Comments: '+ comments : '') + ' \r\n' + (oCase.Origin != NULL ? 'Source: '+ oCase.Origin : '') + ' \r\n' + (oCase.Resolution__c != NULL ? 'Resolution: ' + oCase.Resolution__c : '') + ' \r\n' + (oCase.Refund_Adj_Amount__c != NULL ?  'Refund/Adj Amount: ' + oCase.Refund_Adj_Amount__c : 'Refund/Adj Amount: '+ 0) + ' \r\n' + (oCase.Refund_Adj_Reason_Code__c != NULL ? 'Adj Code: ' + oCase.Refund_Adj_Reason_Code__c : '') + ' \r\n' + (oCase.Credit_Memo_Code__c != NULL ? 'CM Code: ' + oCase.Credit_Memo_Code__c : '');   
        // adding the following code to remove the issue of string greater than the allowed limit
        if(sqrInfo.Comments.length()>2499){
            sqrInfo.Comments= sqrInfo.Comments.left(2499);
        }
        
        return sqrInfo;
    }
    
    public static wwwViadComDataV2_SQR.SqrUpdateRequest updateSQR(Case oCase, CaseToSQRMapping__mdt mapping, Integer boothId, String comments){
        for(CaseComment comm : oCase.CaseComments){
            comments=comm.CreatedBy.Name + ': ' + comm.CommentBody + ' \r\n' + (comments != NULL ? comments : '');  
        }  
        
        wwwViadComDataV2_SQR.SqrUpdateRequest sqrInfo=new wwwViadComDataV2_SQR.SqrUpdateRequest();
        
        sqrInfo.ContactEmail=oCase.ContactEmail;
        sqrInfo.ContactName=oCase.Contact.Name;
        sqrInfo.ContactPhone=oCase.ContactPhone;
        sqrInfo.Description=oCase.CaseNumber +' - '+ oCase.GES_Type__c +' - '+ oCase.Reason__c;
        sqrInfo.LineOfBusiness = mapping != null ? mapping.CORE_SQR_LOB_Code__c : null; 
        sqrInfo.OrderType= mapping != null ? mapping.CORE_SQR_Order_Type_Code__c : null;
        sqrInfo.Priority='L'; //Low
        sqrInfo.ServiceCategory=mapping !=null ? mapping.CORE_SQR_Service_Category_Code__c : null;
        sqrInfo.Cause= mapping != null ? mapping.CORE_SQR_Cause_Code__c : null;
        sqrInfo.Source='N'; //National Servicenter
        if (oCase.Status == 'Closed'){
            sqrInfo.Status='C'; 
            oCase.Send_CORE_SQR_Status__c = 'Closed'; 
        }
        else if (oCase.Send_CORE_SQR_Status__c == 'In Process' && oCase.Status != 'Closed') {
            sqrInfo.Status='I'; 
        }
        else if (oCase.Send_CORE_SQR_Status__c == 'Closed') {
            sqrInfo.Status='C'; 
        }
        sqrInfo.Comments=(comments != NULL ? 'Case Comments: '+ comments : '') + ' \r\n' + (oCase.Origin != NULL ? 'Source: '+ oCase.Origin : '') + ' \r\n' + (oCase.Resolution__c != NULL ? 'Resolution: ' + oCase.Resolution__c : '') + ' \r\n' + (oCase.Refund_Adj_Amount__c != NULL ?  'Refund/Adj Amount: ' + oCase.Refund_Adj_Amount__c : 'Refund/Adj Amount: '+ 0) + ' \r\n' + (oCase.Refund_Adj_Reason_Code__c != NULL ? 'Adj Code: ' + oCase.Refund_Adj_Reason_Code__c : '') + ' \r\n' + (oCase.Credit_Memo_Code__c != NULL ? 'CM Code: ' + oCase.Credit_Memo_Code__c : '');   
        //sqrInfo.SqrHeaderId= Integer.valueOf(oCase.CORE_SQR_ID__c);
        
        return sqrInfo;
    }
    
}