/**************************************
Author          : Mohd Sajid
Release         : April 18, 2023
Created         : April 10, 2023
Functionality   : Booth contacts are integrated to core
Itrack#   		: sfdc-202

Modification History:
Itrack#        Date                Author                         Change  
****************************************************************************

***********************************************************************************/

public class ExhibitorServiceClient {
    
    //@future(callout=true)
    public static PageReference submitContactToCore(Id boothContactId){
        Oracle_Show_Booth_Contact__c boothContact = new Oracle_Show_Booth_Contact__c();
        try{
            ShowsiteContactSetting__c ShowsiteContactSetting = ShowsiteContactSetting__c.getValues('ContactToCore Webservice Auth');

            String loginName= ShowsiteContactSetting != null ? ShowsiteContactSetting.Username__c : '';  
            String password= ShowsiteContactSetting != null ? ShowsiteContactSetting.Password__c : '';
            String applicationID= ShowsiteContactSetting != null ? ShowsiteContactSetting.ApplicationID__c : '';
            string applicationKey= ShowsiteContactSetting != null ? ShowsiteContactSetting.ApplicationKey__c : '';
            
            String appSessionId;
            if(!Test.isRunningTest()){
                wwwViadComSecurityV2.BasicHttpBinding_IAuthenticationService authClient=new wwwViadComSecurityV2.BasicHttpBinding_IAuthenticationService();
                authClient.endpoint_x= ShowsiteContactSetting != null ? ShowsiteContactSetting.Authentication_EndPoint__c : '';
                
                wwwViadComSecurityV2.AppSessionInfo authResponse=authClient.StartAppSession(applicationID,applicationKey,null,null);
                appSessionId=authResponse.SessionID;
                
                system.debug('sessionid=='+authResponse.SessionID);
                system.debug('Expiration==='+authResponse.Expiration);
                
                wwwViadComSecurityV2.AppSessionInfo loginResponse =authClient.UserLogin(appSessionId,loginName,password,null);
                
                system.debug('sessionid=='+loginResponse.SessionID);
                system.debug('Expiration==='+authResponse.Expiration);
            }
            
            wwwViadComV1_ExhibitorService.BasicHttpBinding_IExhibitorService client=new wwwViadComV1_ExhibitorService.BasicHttpBinding_IExhibitorService();
            client.endpoint_x= ShowsiteContactSetting != null ? ShowsiteContactSetting.Client_EndPoint__c : '';
            
            boothContact = [Select Id, FIRST_NAME__c,LAST_NAME__c,CUST_CONT_ID__c,SHOW_OCCR_CUST_ID__c,CUST_BOOTH_ID__c,PRIMARY_FLAG__c,COUNTRY_CODE__c,PHONE__c,EXTENSION__c,FAX__c,EMAIL__c,Oracle_Show_Booth__c from Oracle_Show_Booth_Contact__c Where Id = :boothContactId];
            Oracle_Show_Booth__c booth = [Select Id, SHOW_OCCR_CUST_ID__c,BOOTH_ID__c From Oracle_Show_Booth__c Where Id = :boothContact.Oracle_Show_Booth__c];
            List <Oracle_Show_Booth_Contact__c> boothContactRecords = new List<Oracle_Show_Booth_Contact__c>();
            
            wwwViadComV1_ExhibitorService.CustomerContact contactInfo = new wwwViadComV1_ExhibitorService.CustomerContact();            
            
            contactInfo.ContactRole = 'SHOWSITE';
            contactInfo.ContactType = 'SECONDARY';
            
            contactInfo.FirstName = boothContact.FIRST_NAME__c;
            contactInfo.LastName = boothContact.LAST_NAME__c;
            contactInfo.ShowOccrCustId = Integer.valueOf(booth.SHOW_OCCR_CUST_ID__c);
            contactInfo.CustomerBoothId = Integer.valueOf(booth.BOOTH_ID__c);
            contactInfo.Primary = boothContact.PRIMARY_FLAG__c == 'Y' ? true :false;
            contactInfo.CountryCode = boothContact.COUNTRY_CODE__c;
            contactInfo.PhoneNumber = boothContact.PHONE__c;
            contactInfo.Extension = String.valueOf(boothContact.EXTENSION__c);
            contactInfo.Fax = boothContact.FAX__c;
            contactInfo.EmailAddress = boothContact.EMAIL__c;
            
            if(boothContact.CUST_CONT_ID__c == null){
                Integer responseCode = !Test.isRunningTest() ? client.AddShowSiteContact(appSessionId,contactInfo) : 1;
                System.debug('responseCode Add:: '+responseCode);
                boothContact.CUST_CONT_ID__c = String.valueOf(responseCode);
                boothContact.Updated_in_CORE__c = true;
                boothContact.Updated_in_CORE_Date__c = System.now();
                update boothContact;
                
                String boothContacturl = URL.getSalesforceBaseUrl().toExternalForm() + '/' + boothContact.id;
                PageReference Pr = new PageReference(boothContacturl);
                return pr;
                
            }else{
                contactInfo.CustomerContactId = Integer.valueOf(boothContact.CUST_CONT_ID__c);
                Boolean responseCode = !Test.isRunningTest() ? client.UpdateShowSiteContact(appSessionId,contactInfo) : false;
                System.debug('responseCode Update:: '+responseCode);
                boothContact.Updated_in_CORE__c = true;
                boothContact.Updated_in_CORE_Date__c = System.now();
                update boothContact;
                
                String boothContacturl = URL.getSalesforceBaseUrl().toExternalForm() + '/' + boothContact.id;
                PageReference Pr = new PageReference(boothContacturl);
                return pr;
            }
        }
        catch(Exception e){
            System.debug(e);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage())); 
            return null;
        }
    }  
}