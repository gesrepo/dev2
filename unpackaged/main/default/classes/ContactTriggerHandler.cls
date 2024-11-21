/***************************************************************************************************
Author: Shyam Nair (SLK Software)
Date: 10/30/2019
Description: Handler class for ContactTrigger
****************************************************************************************************/
public class ContactTriggerHandler {
     public static Boolean isFirstTime = true;

    public static void setPrimaryOnAccount(List<Contact> contacts){
        List<Account> accounts = new List<Account>();
        List<Contact> contactsToUpdate = new List<Contact>();
        try{
            for(Contact contact :[SELECT Id,AccountId,Account.Primary_Contact__c,Account.Primary_Contact_Identified__c,Primary_Contact__c 
                                    FROM Contact WHERE Id IN: contacts]){
                if(contact.Account.Primary_Contact__c == null){
                    accounts.add(new Account(Id=contact.AccountId,Primary_Contact_Identified__c=true,Primary_Contact__c=contact.Id));
                }
                else{
                    if(contact.Account.Primary_Contact__c != contact.Id){
                        contactsToUpdate.add(new Contact(Id=contact.Account.Primary_Contact__c,Primary_Contact__c=false));
                        accounts.add(new Account(Id=contact.AccountId,Primary_Contact_Identified__c=true,Primary_Contact__c=contact.Id));
                    }
                }
            }

            if(!contactsToUpdate.isEmpty()){
                update contactsToUpdate;
            }

            if(!accounts.isEmpty()){
                update accounts;
            }
        }
        catch(Exception e){
            System.debug('Exception caught--> '+e.getMessage()+'/'+e.getStackTraceString());
            contacts[0].addError('Exception was caught. Please report to Administrator.');
        }
    }

    public static void unsetPrimaryContactOnAccount(List<Contact> contacts){
        List<Account> accounts = new List<Account>();
        try{
            for(Contact contact :[SELECT Id,AccountId,Account.Primary_Contact__c,Account.Primary_Contact_Identified__c,Primary_Contact__c 
                                    FROM Contact WHERE Id IN: contacts]){
                if(Account.Primary_Contact__c != null && contact.Id == contact.Account.Primary_Contact__c){
                    accounts.add(new Account(Id=contact.AccountId,Primary_Contact__c=null,Primary_Contact_Identified__c=false));
                }                        
            }

            if(!accounts.isEmpty()){
                update Accounts;
            }
        }
        catch(Exception e){
            System.debug('Exception caught--> '+e.getMessage()+'/'+e.getStackTraceString());
            contacts[0].addError('Exception was caught. Please report to Administrator.');
        }
    }
/*    
    //code added by Sajid - 03/06/23 (JIRA-198)
    public static void updateTextOptOut(List<Contact> contacts){
        List<Contact> contactsToUpdate = new List<Contact>();
        try{
            for(Contact contact :[SELECT Id, Name, Phone, MobilePhone, Text_Opt_Out__c FROM Contact WHERE Id IN: contacts]){
                contact.Text_Opt_Out__c = true;
                if(contact.MobilePhone == null){
                    contact.MobilePhone = contact.Phone;
                }
                contactsToUpdate.add(contact); 
            }
            
            if(!contactsToUpdate.isEmpty()){
                update contactsToUpdate;
            }
        }
        catch(Exception e){
            System.debug('Exception caught--> '+e.getMessage()+'/'+e.getStackTraceString());
            contacts[0].addError('Exception was caught. Please report to Administrator.');
        }
    }
*/    
    public static void updateMobilePhone(List<Contact> contacts, Boolean isMobilePhoneNull, Set<Id> setAccIds,Map<Id,Id> mapContIdToAccId){
        List<Contact> contactsToUpdate = new List<Contact>();
        Map<Id, String> accBillingCountry = new Map<Id, String>();
        Map<Id, String> mapAccIdToBillingCountry = new Map<Id, String>();
        
        String PhoneExtension = System.Label.PhoneExtension;
        List<String> listPhoneExt = PhoneExtension.split(',');
        
        try{
            List<Account> listAccount = [Select id, BillingCountry from Account where Id IN: setAccIds];
            for(Account acc: listAccount){
                mapAccIdToBillingCountry.put(acc.Id, acc.BillingCountry);
            }
            for(Contact contact : contacts){
                accBillingCountry.put(contact.Id, mapAccIdToBillingCountry.get(mapContIdToAccId.get(contact.Id)));
            }
            
            Map<String, String> customSettingData = getCustomSettingData();
            
            String formattedPhone;
            for(Contact contact : contacts){
                String countryCode = accBillingCountry.get(contact.Id) != null ? customSettingData.get(accBillingCountry.get(contact.Id)) != null ? customSettingData.get(accBillingCountry.get(contact.Id)) : '+1' : '+1';
 				System.debug('countryCode:: '+countryCode);
                if(isMobilePhoneNull){
                    Boolean phoneExt = checkPhoneExtension(listPhoneExt, contact.Phone);
                    if(phoneExt)
                        formattedPhone = contact.Phone;
                    else
                        formattedPhone = FormattingMobilePhone(contact.Phone, countryCode);
                }else{
                    Boolean phoneExt = checkPhoneExtension(listPhoneExt, contact.MobilePhone);
                    if(phoneExt)
                        formattedPhone = contact.MobilePhone;
                    else
                        formattedPhone = FormattingMobilePhone(contact.MobilePhone, countryCode);
                }
                contact.MobilePhone = formattedPhone;
            }
        }
        catch(Exception e){
            System.debug('Exception caught--> '+e.getMessage()+'/'+e.getStackTraceString());
            contacts[0].addError('Exception was caught. Please report to Administrator.');
        }
    }
    
    public static String FormattingMobilePhone(String phoneNum, String countryCode){
        String formattedPhone = phoneNum.replaceAll('(?!^\\+)[^\\d]','');
        String finalPhone;
        if(formattedPhone.contains(countryCode)){
            finalPhone = formattedPhone;
        }
        else if(formattedPhone.startsWith('1')){
            finalPhone = countryCode + formattedPhone.right(10);
        }else{
            finalPhone = countryCode + formattedPhone;
        }
        
        return finalPhone;
        
    }
    
    public static Map<String, String> getCustomSettingData(){
        
        Map<String, String> mapCountryCode = new Map<String, String>();
        for(CountryCode__c cs : CountryCode__c.getAll().values()){
            mapCountryCode.put(cs.Name, cs.Code__c);      
        }
        return mapCountryCode;
    }
    //code Ended
    
    public static Boolean checkPhoneExtension(List<String> listExt, String phoneNumber){ 
        Boolean isPhoneExt = false;
        for(String extValue : listExt){
            if(phoneNumber.contains(extValue)){
                isPhoneExt = true;
                break;
            }
        }
        return isPhoneExt;
    }
}