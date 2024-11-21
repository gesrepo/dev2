/*************************************************************************************************
Class     :  BoothUploadProcessingBatch.cls
Developer :  marian.iovi@vertiba.com
Created   :  -
Modified  :  January 27, 2017
Objective :  This class provides methods for MasterUploadController.cls

*************************************************************************************************/

global class BoothUploadProcessingBatch implements Database.Batchable<sObject>, Database.Stateful {

    global Booth_Upload__c BoothUpload { get; set; }
    global boolean isDuplicationCheck { get; set; }
    global List<String> countryCodes { get; set; }
    global String ERSubject { get; set; }
    global List<String> ERTos { get; set; }
    global String ERBody { get; set; }
    global String ERBodyAux { get; set; }
    global String pageHost { get; set; }
    global String sessionId {get;set;}
    List<Booth_Staging__c> fullStagingList = new List<Booth_Staging__c>();// used to store all related staging record - Najmal - March 07th,2023 - #305622
    
    global BoothUploadProcessingBatch(Booth_Upload__c bu, String ph) {
        //#426842 - flag to check the duplication check needed or not
        isDuplicationCheck = Boolean.valueOf(System.Label.Is_Duplication_Check);
        sessionId = UserInfo.getSessionId();
        pageHost = ph;
        BoothUpload = bu;
        
        ERSubject = 'Exception Report for ' + boothUpload.Opportunity__r.Show_Name__r.Name + ' on ' + boothUpload.Confirmation_Date_Time__c;
        
        ERBody = 'Hi, <br /><br />An exception report has been generated for the Exhibitor Upload that took place on ' + boothUpload.Confirmation_Date_Time__c + ' by ' + UserInfo.getUsername() + ' . ';
        ERBody += 'This was loaded as ' + boothUpload.Name + ' for the Opportunity ' + boothUpload.Opportunity__r.Name + ' and Organiser ' + boothUpload.Organiser_2__r.Name + '.<br /><br />';
        ERBody += 'The system matches on Account Name, Opportunity and Stand Number. If an existing stand record is found, it will update with the information from the Exhibitor list. Any amendments to the record will be detailed below. <br /><br />';
        ERBody += 'The following stand amendments were made during the upload, please investigate if these accounts have existing orders on SOP as soon as possible.<br /><br />';
        ERBody += '<table border="1">';
        ERBody += '<thead style="background-color:#BBBBBB;"><tr><th>Account</th><th>Stand Number Now</th><th>Hall Info</th><th>Contact Name</th><th>Contact Phone</th><th>SOP UK</th><th>SOP EUR</th><th>SOP ME</th><th></th></tr></thead><tbody>';

        ERBodyAux = '<table border="1">';
        ERBodyAux += '<thead style="background-color:#BBBBBB;"><tr><th>Booth Staging</th><th>Account</th><th>Stand Number</th><th>Information</th></tr></thead><tbody>';

        List<GroupMember> groupMembers = [SELECT Id, UserOrGroupId FROM GroupMember WHERE Group.DeveloperName = 'EMEA_Supervisor'];
        Set<Id> userIds = new Set<Id>();
        for (GroupMember groupMember : groupmembers) {
            userIds.add(groupmember.UserOrGroupId);
        }
        List<User> users = [SELECT Email FROM User WHERE Id IN :userIds];
        ERTos = new List<String>();
        for (User usr : users) {
            ERTos.add(usr.Email);
        }

        ERTos.add('ddunkley@ges.com');
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        //create record with name of booth upload Id, whenever the batch starts - #394587
        Booth_Upload_Settings__c bus = new Booth_Upload_Settings__c(Booth_Upload_Id__c=BoothUpload.Id,Name=BoothUpload.Id);
        insert bus;
        
        //Collecting all active country codes into a list - #394588 04-04-2024
        Schema.DescribeFieldResult fieldDescription = Account.VAT_Number_Country_Code__c.getDescribe();
        List<String> countryCds = new List<String>();
        for(Schema.PicklistEntry entry : fieldDescription.getPicklistValues()){
            countryCds.add(entry.getValue());
        }
        countryCodes = countryCds;
        
        return Database.getQueryLocator(
            [SELECT Id, Name, Show_Name__c, Status__c, Account_ID__r.Name, Country__c, Address_1__c, Address_2__c, Address_3__c, Agency_Contact__c, 
            Agency_Email__c, Agency_Phone__c, Booth_Height__c, Booth_ID__c, Booth_Length__c, Booth_Size__c, Booth_Width__c, Business_Type__c, City__c, Company__c, 
            Email__c, Exhibitor_Body__c, Exhibitor_GUID__c, Exhibitor_Username__c, Exhibitor_Password__c, 
            Exhibitor_Status__c, Fax__c, First_Name__c, Last_Name__c, Nameboard_Name__c, New_Exhibitor__c, Notes__c, Open_Sides__c, Operations_Zone__c, Package_Type__c, Phone_Number__c, 
            Pillar_Column_Size_c__c, Post_Zip_Code__c, Service_Zone__c, Stand_Number__c, Stand_Type__c, State_County__c, Vat_Number__c, Website__c, Mobile__c, Salutation__c,
            Contractor_Contact__c, Contractor_Email__c, Contact_ID__c, Contractor_Phone__c, Cust_Type__c, Design_Configuration__c, Discount__c, Available_For_Expresso_Manual__c
                FROM Booth_Staging__c WHERE Booth_Upload__c = :BoothUpload.Id AND Status__c != 'Confirmed']
        );
    }
    
    global void execute(Database.BatchableContext BC, List<Booth_Staging__c> scope) {
        
        Savepoint sp = Database.setSavepoint();
        try {
            System.debug('scope: ' + scope);
            String str1 = '';
            String str2 = '';
        
            Id accRT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Exhibitor').getRecordTypeId();
            
            List<BoothStagingWrapper> boothStagingList = new List<BoothStagingWrapper>();
            for (Booth_Staging__c staging : scope) {
                boothStagingList.add(new BoothStagingWrapper(staging));
            }
            
            List<Opportunity> auxOpps = MatchExisting(boothStagingList);
            
            List<Oracle_Show_Booth__c> booths = new List<Oracle_Show_Booth__c>();
            Map<Id, Oracle_Show_Booth__c> exbooths = new Map<Id, Oracle_Show_Booth__c>();
            List<Account> accounts = new List<Account>();
            Map<Id, Account> exaccounts = new Map<Id, Account>();
            List<Oracle_Show_Booth_Contact__c> bcontacts = new List<Oracle_Show_Booth_Contact__c>();
            Map<Id, Oracle_Show_Booth_Contact__c> exbcontacts = new Map<Id, Oracle_Show_Booth_Contact__c>();
            List<Contact> contacts = new List<Contact>();
            Map<Id, Contact> excontacts = new Map<Id, Contact>();
            List<Booth_Staging__c> stagings = new List<Booth_Staging__c>();
            
            for (BoothStagingWrapper bs : boothStagingList) {
                
                if (bs.AddToExceptionReport || bs.staging.Company__c == null || bs.staging.Company__c == '' || bs.staging.First_Name__c == null || bs.staging.First_Name__c == '' ||
                    bs.staging.Last_Name__c == null || bs.staging.Last_Name__c == '' || bs.staging.Stand_Number__c == null || bs.staging.Stand_Number__c == '' 
                    // || bs.staging.Post_Zip_Code__c == null || bs.staging.Post_Zip_Code__c == ''
                    // || bs.staging.Country__c == null || bs.staging.Country__c == ''
                    // || bs.staging.City__c == null || bs.staging.City__c == ''
                    // || bs.staging.Phone_Number__c == null || bs.staging.Phone_Number__c == ''
                   ) {
                        
                    str1 += '<tr>'; 
                    str1 += '<td><a href="http://' + pageHost + '/' + bs.staging.Id + '">' + bs.staging.Name + '</a></td>';
                    str1 += '<td>' + bs.staging.Company__c + '</td>';
                    str1 += '<td>' + bs.staging.Stand_Number__c + '</td>';

                    string exceptionInformation = bs.ExceptionInformation;
                    if (bs.staging.Company__c == null || bs.staging.Company__c == '' )
                    {
                        exceptionInformation = exceptionInformation + 'Missing company name' +'<br />';
                    }

                    if (bs.staging.First_Name__c == null || bs.staging.First_Name__c == '' )
                    {
                        exceptionInformation = exceptionInformation + 'Missing first name' +'<br />';
                    }

                    if (bs.staging.Last_Name__c == null || bs.staging.Last_Name__c == '' )
                    {
                        exceptionInformation = exceptionInformation + 'Missing last name' +'<br />';
                    }

                    if (bs.staging.Stand_Number__c == null || bs.staging.Stand_Number__c == '')
                    {
                        exceptionInformation = exceptionInformation + 'Missing stand number' +'<br />';
                    }


                    str1 += '<td>' + exceptionInformation + '</td>';                    
                    str1 += '</tr>';
                       
                       system.debug('email: ' + str1);
                } else {
                
                    if (bs.putInTheEmail) {
                        str2 += '<tr>';
                        str2 += '<td>' + (bs.staging.Company__c == null ? '' : bs.staging.Company__c) + '</td>';
                        str2 += '<td>' + (bs.staging.Stand_Number__c == null ? '' : bs.staging.Stand_Number__c) + (bs.booth.Id == null ? '' : (bs.staging.Stand_Number__c == bs.booth.BOOTH_NUMBER__c ? '' : ' (Old Stand Number:' + bs.booth.BOOTH_NUMBER__c + ' )' )) + '</td>';
                        str2 += '<td>' + (bs.staging.Service_Zone__c == null ? '' : bs.staging.Service_Zone__c) + '</td>';
                        str2 += '<td>' + (bs.staging.First_Name__c == null ? '' : bs.staging.First_Name__c) + ' ' + (bs.staging.Last_Name__c == null ? '' : bs.staging.Last_Name__c) + '</td>';
                        str2 += '<td>' + (bs.staging.Phone_Number__c == null ? '' : bs.staging.Phone_Number__c) + '</td>';
                        str2 += '<td>' + (bs.account.UK_SOP_ID__c == null ? '' : bs.account.UK_SOP_ID__c) + '</td>';
                        str2 += '<td>' + (bs.account.EURO_SOP_ID__c == null ? '' : bs.account.EURO_SOP_ID__c) + '</td>';
                        str2 += '<td>' + (bs.account.ME_SOP_ID__c == null ? '' : bs.account.ME_SOP_ID__c) + '</td>';
                        str2 += '<td>' + (bs.ExceptionInformation == null ? '' : bs.ExceptionInformation) + '</td>';
                        str2 += '</tr>';

                        system.debug('email: ' + str2);
                    }
                    
                    //#426842---------------assigning values to the Account object
                    bs.account.RecordTypeId = accRT;
                    if (bs.staging.Business_Type__c != null && bs.staging.Business_Type__c != '') {
                        bs.account.Business_Type__c = bs.staging.Business_Type__c;
                    } else {
                        if (bs.account.Business_Type__c == null || bs.account.Business_Type__c == '') {
                            bs.account.Business_Type__c = 'Exhibitor';
                        }
                    }
                    
                    if (bs.staging.Cust_Type__c != null && bs.staging.Cust_Type__c != '') {
                        bs.account.Cust_Type__c = bs.staging.Cust_Type__c;
                    } else {
                        if (bs.account.Cust_Type__c == null || bs.account.Cust_Type__c == '') {
                            bs.account.Cust_Type__c = '99 Exibitor';
                        }
                    }
                    bs.account.EMEA__c = true;
                    bs.account.Name = bs.staging.Company__c;
                    bs.account.BillingStreet = (bs.staging.Address_1__c == null ? '' : bs.staging.Address_1__c) + ',' + (bs.staging.Address_2__c == null ? '' : bs.staging.Address_2__c) + ',' + (bs.staging.Address_3__c == null ? '' : bs.staging.Address_3__c);
                    bs.account.BillingCity = bs.staging.City__c;
                    bs.account.BillingState = bs.staging.State_County__c;
                    bs.account.BillingPostalCode = bs.staging.Post_Zip_Code__c;
                    bs.account.BillingCountry = bs.staging.Country__c;
                    bs.account.Phone = bs.staging.Phone_Number__c;
                    bs.account.Website = bs.staging.Website__c;
                    bs.account.Vat_Number__c = bs.staging.Vat_Number__c;
                    //assign VAT Country Code if it is included in the VAT Number - #394588 04-04-2024
                    if(bs.staging.Vat_Number__c != null && bs.staging.Vat_Number__c.length()>2 && countryCodes.contains(bs.staging.Vat_Number__c.substring(0,2))){
                           bs.account.VAT_Number_Country_Code__c = bs.staging.Vat_Number__c.substring(0,2);
                    }
                       
                    if(String.isNotBlank(bs.staging.Exhibitor_GUID__c)){
                        //new Account from the Exhibitor routine
                        bs.account.Source_Exhibitor_Upload__c = true;
                        //bs.account.Exhibitor_onDataCom__c = true;
                    }
                    if (bs.account.Id == null) {
                        if(isDuplicationCheck){
                            boolean accFound = false;
                            for(Account acc: accounts){
                                if(acc.Name == bs.account.Name && acc.BillingCountry == bs.account.BillingCountry && acc.BillingPostalCode == bs.account.BillingPostalCode){
                                    bs.account = acc;
                                    accFound = true;
                                    break;
                                }
                            }
                            if(!accFound)
                                accounts.add(bs.account);
                        }else
                            accounts.add(bs.account);
                    } else {
                        exaccounts.put(bs.account.Id, bs.account);
                    }
                    
                    //#426842-----------------assigning values to the Booth object
                    bs.booth.Name = (bs.staging.Company__c == null ? '' : bs.staging.Company__c) + ' ' + (bs.staging.Stand_Number__c == null ? '' : bs.staging.Stand_Number__c);
                    bs.booth.BOOTH_ID__c = bs.staging.Booth_ID__c;
                    bs.booth.BOOTH_NUMBER__c = bs.staging.Stand_Number__c;
                    bs.booth.Booth_Height__c = bs.staging.Booth_Height__c;
                    try {
                        bs.booth.BOOTH_LENGTH__c = Decimal.valueOf(bs.staging.Booth_Length__c);
                    } catch (Exception ex) { } 
                    bs.booth.BOOTH_SIZE__c = bs.staging.Booth_Size__c;
                    bs.booth.BOOTH_TYPE__c = bs.staging.Stand_Type__c;
                    try {
                        bs.booth.BOOTH_WIDTH__c = Decimal.valueOf(bs.staging.Booth_Width__c);
                    } catch (Exception ex) { }
                    if (bs.staging.Business_Type__c != null && bs.staging.Business_Type__c != '') {
                        bs.booth.Business_Type__c = bs.staging.Business_Type__c;
                    } else {
                        if (bs.booth.Business_Type__c == null || bs.booth.Business_Type__c == '') {
                            bs.booth.Business_Type__c = 'Exhibitor';
                        }
                    }
                    if (bs.staging.Cust_Type__c != null && bs.staging.Cust_Type__c != '') {
                        bs.booth.Cust_Type__c = bs.staging.Cust_Type__c;
                    } else {
                        if (bs.booth.Cust_Type__c == null || bs.booth.Cust_Type__c == '') {
                            bs.booth.Cust_Type__c = '99 Exibitor';
                        }
                    }
                    bs.booth.Cust_Type__c = bs.staging.Cust_Type__c;
                    bs.booth.Design_Configuration__c = bs.staging.Design_Configuration__c;
                    bs.booth.Discount__c = bs.staging.Discount__c;
                    bs.booth.CONTACT_EMAIL__c = bs.staging.Email__c;
                    bs.booth.Exhibitor_Body__c = bs.staging.Exhibitor_Body__c;
                    bs.booth.Exhibitor_Status__c = bs.staging.Exhibitor_Status__c;
                    bs.booth.CONTACT_FAX__c = bs.staging.Fax__c;
                    bs.booth.CONTACT_FIRST_NAME__c = bs.staging.First_Name__c;
                    bs.booth.CONTACT_LAST_NAME__c = bs.staging.Last_Name__c;
                    bs.booth.Nameboard_Name__c = bs.staging.Nameboard_Name__c;
                    bs.booth.New_Exhibitor__c = bs.staging.New_Exhibitor__c;
                    bs.booth.Notes__c = bs.staging.Notes__c;
                    bs.booth.Open_Sides__c = bs.staging.Open_Sides__c;
                    bs.booth.Zone__c = bs.staging.Operations_Zone__c;
                    bs.booth.Package_Type__c = bs.staging.Package_Type__c;
                    bs.booth.CONTACT_PHONE__c = bs.staging.Phone_Number__c;
                    bs.booth.Pillar_Column_Size__c = bs.staging.Pillar_Column_Size_c__c;
                    bs.booth.Service_Zone__c = bs.staging.Service_Zone__c;
                    bs.booth.Show_Occurrence__c = boothUpload.Opportunity__c;
                    bs.booth.Exhibitor_GUID__c = bs.staging.Exhibitor_GUID__c;
                    bs.booth.Exhibitor_Username__c = bs.staging.Exhibitor_Username__c;
                    bs.booth.Exhibitor_Password__c = bs.staging.Exhibitor_Password__c;
                    bs.booth.Exhibitor_Status__c = bs.staging.Exhibitor_Status__c;
                    bs.booth.Available_For_Expresso_Manual__c = bs.staging.Available_For_Expresso_Manual__c;
                    bs.booth.Account__r = bs.account;

                    System.debug('****bs.booth: ' + bs.booth);
                    if (bs.booth.Id == null) {
                        boolean boothFound = false;
                        for(Oracle_Show_Booth__c booth: booths){
                            if(booth.Account__r.Name == bs.staging.Company__c && booth.Account__r.BillingPostalCode == bs.staging.Post_Zip_Code__c 
                               && booth.BOOTH_NUMBER__c == bs.staging.Stand_Number__c){
                                   bs.booth = booth;
                                   boothFound = true;
                                   break;
                               }
                        }
                        if(!boothFound)
                            booths.add(bs.booth);
                    } else {
                        exbooths.put(bs.booth.Id, bs.booth);
                    }
                    
                    //#426842------------------assigning values to the Booth Contact object
                    bs.boothContact.Agency_Contact__c = bs.staging.Agency_Contact__c;
                    bs.boothContact.Agency_Email__c = bs.staging.Agency_Email__c;
                    bs.boothContact.Agency_Phone__c = bs.staging.Agency_Phone__c;
                    bs.boothContact.Mailing_City__c = bs.staging.City__c;
                    bs.boothContact.Contractor_Contact__c = bs.staging.Contractor_Contact__c;
                    bs.boothContact.Contractor_Email__c = bs.staging.Contractor_Email__c;
                    bs.boothContact.Contractor_Phone__c = bs.staging.Contractor_Phone__c;
                    bs.boothContact.Mailing_Country__c = bs.staging.Country__c;
                    bs.boothContact.EMAIL__c = bs.staging.Email__c;
                    bs.boothContact.FAX__c = bs.staging.Fax__c;
                    bs.boothContact.FIRST_NAME__c = bs.staging.First_Name__c;
                    bs.boothContact.LAST_NAME__c = bs.staging.Last_Name__c;
                    bs.boothContact.PHONE__c = bs.staging.Phone_Number__c;
                    bs.boothContact.Mailing_Postal_Code__c = bs.staging.Post_Zip_Code__c;
                    bs.boothContact.Mailing_State__c = bs.staging.State_County__c;
                    bs.boothContact.Mobile__c = bs.staging.Mobile__c;
                    bs.boothContact.Salutation__c = bs.staging.Salutation__c;
                    bs.boothContact.Mailing_Street__c = (bs.staging.Address_1__c == null ? '' : bs.staging.Address_1__c) + ',' + (bs.staging.Address_2__c == null ? '' : bs.staging.Address_2__c) + ',' + (bs.staging.Address_3__c == null ? '' : bs.staging.Address_3__c);
                    if (bs.account.Id != null) {
                        for (Opportunity auxOpp : auxOpps) {
                            if (auxOpp.AccountId == bs.account.Id) {
                                bs.boothContact.Opt_Out__c = true;
                            }
                        }
                    }
                    bs.boothContact.Oracle_Show_Booth__r = bs.booth;
                    System.debug('****bs.boothContact: ' + bs.boothContact);
                    if (bs.boothContact.Id == null) {
                        boolean bcFound = false;
                        for(Oracle_Show_Booth_Contact__c boothContact: bcontacts){
                            if(boothContact.First_Name__c == bs.staging.First_Name__c && boothContact.Last_Name__c == bs.staging.Last_Name__c 
                               && boothContact.Mailing_Postal_Code__c == bs.staging.Post_Zip_Code__c && boothContact.EMAIL__c == bs.staging.Email__c
                               && boothContact.Oracle_Show_Booth__r.BOOTH_NUMBER__c == bs.staging.Stand_Number__c){
                                   bs.boothContact = boothContact;
                                   bcFound = true;
                                   break;
                               }
                        }
                        if(!bcFound)
                            bcontacts.add(bs.boothContact);
                    } else {
                        exbcontacts.put(bs.boothContact.Id, bs.boothContact);
                    }
                    
                    //#426842------------------assigning values to the Contact object
                    bs.contact.Email = bs.staging.Email__c;
                    bs.contact.Fax = bs.staging.Fax__c;
                    bs.contact.MailingStreet = (bs.staging.Address_1__c == null ? '' : bs.staging.Address_1__c) + ',' + (bs.staging.Address_2__c == null ? '' : bs.staging.Address_2__c) + ',' + (bs.staging.Address_3__c == null ? '' : bs.staging.Address_3__c);
                    bs.contact.MailingCity = bs.staging.City__c;
                    bs.contact.MailingState = bs.staging.State_County__c;
                    bs.contact.MailingPostalCode = bs.staging.Post_Zip_Code__c;
                    bs.contact.MailingCountry = bs.staging.Country__c;
                    bs.contact.FirstName = bs.staging.First_Name__c;
                    bs.contact.LastName = bs.staging.Last_Name__c;
                    bs.contact.Phone = bs.staging.Phone_Number__c;
                    bs.contact.MobilePhone = bs.staging.Mobile__c;
                    bs.contact.Salutation = bs.staging.Salutation__c;
                    bs.contact.Account = bs.account;
                    System.debug('****bs.contact: ' + bs.contact);
                    if (bs.contact.Id == null) {
                        boolean contactFound = false;

                        for(Integer i = 0; i < contacts.size(); i++) 
                        {
                            if(!isDuplicationCheck && contacts[i].FirstName == bs.contact.FirstName 
                               && contacts[i].LastName == bs.contact.LastName 
                               && contacts[i].MailingPostalCode == bs.contact.MailingPostalCode 
                               && contacts[i].Account.Name == bs.contact.Account.Name){ 
                                   contactFound = true;
                                   bs.contact = contacts[i];
                               }else if(contacts[i].Email == bs.contact.Email && contacts[i].Account.Name == bs.contact.Account.Name){ 
                                   contactFound = true;
                                   bs.contact = contacts[i];
                               }
                        }
                        if (contactFound == false)
                        {
                            contacts.add(bs.contact);
                        }
                    } else {
                        excontacts.put(bs.contact.Id, bs.contact);
                    }
                    
                    //bs.contact.Account = bs.account;
                    //bs.booth.Account__r = bs.account;
                    //bs.boothContact.Oracle_Show_Booth__r = bs.booth;
                    bs.boothContact.Contact__r = bs.contact;
                    
                    bs.staging.Status__c = 'Confirmed';
                    bs.staging.Confirmation_Error__c = '';
                    bs.staging.Booth_Id_2__r = bs.booth;
                    bs.staging.Booth_Contact_Id__r = bs.boothContact;
                    bs.staging.Account_Id__r = bs.account;
                    bs.staging.Contact_Id__r = bs.contact;
                    stagings.add(bs.staging);
                    
                }
            }
            //Replaced DML with Database Methods to avoid failures of success records - Najmal - March 07th,2023 - #305622
            //insert accounts;
            List<Database.SaveResult> accountsResults = Database.insert(accounts, false);
            // update exaccounts.values();
            
            System.debug('*** for-contacts: ' + contacts);
            for (Contact contact : contacts) {
                contact.AccountId = contact.Account.Id;
            }
            // find duplicates contacts
            List<Contact> cleanContacts = new List<Contact>(contacts);
            for(Integer i = 0; i < contacts.size(); i++) {
                for(Integer j = 0; j < contacts.size(); j++) {
                    if(i != j){
                        if(!isDuplicationCheck && contacts[i].FirstName == contacts[j].FirstName && contacts[i].LastName == contacts[j].LastName && contacts[i].MailingPostalCode == contacts[j].MailingPostalCode 
                           && contacts[i].Account.Name == contacts[j].Account.Name) {
                               System.debug('*** matchDuplicate: ' + contacts[i]);
                               contacts.remove(j);
                           }else if(contacts[i].Email == contacts[j].Email && contacts[i].Account.Name == contacts[j].Account.Name) {
                               System.debug('*** matchDuplicate: ' + contacts[i]);
                               contacts.remove(j);
                           }
                    }
                }
            }
 
            

            //System.debug('*** cleanContacts: ' + cleanContacts);
            //Replaced DML with Database Methods to avoid failures of success records - Najmal - March 07th,2023 - #305622
            List<Database.SaveResult> cleanContactsResult = new List<Database.SaveResult>();
            if(!cleanContacts.isEmpty())
                cleanContactsResult = Database.insert(cleanContacts, false);
            //insert cleanContacts;
            //
            // update excontacts.values();
            
            for (Oracle_Show_Booth__c booth : booths) {
                booth.Account__c = booth.Account__r.Id;
            }
            //Replaced DML with Database Methods to avoid failures of success records - Najmal - March 07th,2023 - #305622
            //insert booths;
            List<Database.SaveResult> boothResult = Database.insert(booths, false);
            //Replaced DML with Database Methods to avoid failures of success records - Najmal - March 07th,2023 - #305622
           // update exbooths.values();
            List<Database.SaveResult> exBoothResult = Database.update(exbooths.values(), false);
                
            for (Oracle_Show_Booth_Contact__c bcontact : bcontacts) {
                if (bcontact.Oracle_Show_Booth__c == null)
                    bcontact.Oracle_Show_Booth__c = bcontact.Oracle_Show_Booth__r.Id;
                
                /*
                system.debug(batchID + 'bcontact update contact: ' + bcontact.Contact__c);
                system.debug(batchID + 'bcontact update contact id: ' + bcontact.Contact__r.Id);
                system.debug(batchID + 'bcontact update id: ' + bcontact.id);
                system.debug(batchID + 'bcontact update Name: ' + bcontact.FIRST_NAME__c);
                system.debug(batchID + 'bcontact update Name: ' + bcontact.LAST_NAME__c);
                */
                bcontact.Contact__c = bcontact.Contact__r.Id;
            }
            //Replaced DML with Database Methods to avoid failures of success records - Najmal - March 07th,2023 - #305622
            //insert bcontacts;
            List<Database.SaveResult> bcontactsResult = Database.insert(bcontacts, false);
            //Replaced DML with Database Methods to avoid failures of success records - Najmal - March 07th,2023 - #305622
            //update exbcontacts.values();
            List<Database.SaveResult> exbcontactsResult = Database.update(exbcontacts.values(), false);
            
            for (Booth_Staging__c staging : stagings) {
                staging.Booth_Id_2__c = staging.Booth_Id_2__r.Id;
                staging.Booth_Contact_Id__c = staging.Booth_Contact_Id__r.Id;
                staging.Account_Id__c = staging.Account_Id__r.Id;
                staging.Contact_Id__c = staging.Contact_Id__r.Id;
            }
            
            //Replaced DML with Database Methods to avoid failures of success records - Najmal - March 07th,2023 - #305622
            //update stagings;
            List<Database.SaveResult> result7 = Database.update(stagings, false);
            
            
            //Handle the failed records from the Database methods - Najmal - March 07th,2023 - #305622
            updateFailedBoothStaging(boothStagingList,accountsResults,accounts,
                                    cleanContactsResult,cleanContacts,
                                    boothResult,booths,
                                    exBoothResult, exbooths.values(),
                                    bcontactsResult,bcontacts,
                                    exbcontactsResult,exbcontacts.values());
            
            ERBodyAux += str1;
            ERBody += str2;
            
        } catch (Exception ex) {
            System.debug('tryCatch err: ' + ex.getMessage() + ex.getStackTraceString());
            Database.rollback(sp);
            List<Booth_Staging__c> failedRows = [SELECT Id, Name, Company__c, Stand_Number__c FROM Booth_Staging__c WHERE Id IN :scope];
            for (Booth_Staging__c staging : failedRows) {
                staging.Status__c = 'Failed';
                string err = ex.getMessage();
                //staging.Confirmation_Error__c = err.abbreviate(250);
                staging.Confirmation_Error__c = err;
                
                system.debug('failed: ' + staging.Id);
                
                ERBodyAux += '<tr>'; 
                ERBodyAux += '<td><a href="http://' + pageHost + '/' + staging.Id + '">' + staging.Name + '</a></td>';
                ERBodyAux += '<td>' + staging.Company__c + '</td>';
                ERBodyAux += '<td>' + staging.Stand_Number__c + '</td>';
                ERBodyAux += '<td>' + staging.Confirmation_Error__c + '</td>';                    
                ERBodyAux += '</tr>';
                system.debug('email: ' + ERBodyAux);
            }

            // try {
                update failedRows;   
        //     } catch (Exception ex2) {
        //        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        // mail.setToAddresses(ERTos);
        // mail.setSubject('Error Report for ' + boothUpload.Opportunity__r.Show_Name__r.Name + ' on ' + boothUpload.Confirmation_Date_Time__c);
        // mail.setUseSignature(false);
        // mail.setHtmlBody(ex2.getMessage() + '<br />' + ex2.getStackTraceString());
        // Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        //     }

            
        }

    }
    
    global void finish(Database.BatchableContext BC) {
        //call batch for data.com
        //DataDotComUpdateAccBatch dataComBatch = new DataDotComUpdateAccBatch(sessionId);
        //String dataCombatchId = Database.executeBatch(dataComBatch);
        //delete the created record once the batch finish - #394587 04-04-2024
        delete [SELECT Id, Booth_Upload_Id__c FROM Booth_Upload_Settings__c WHERE Name =:BoothUpload.Id];
        
        ERBody += '</tbody></table>';
        ERBodyAux += '</tbody></table>';
        
        ERBody += '<br /><br />The records below are incomplete:<br /><br />';
        ERBody += ERBodyAux;
            
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(ERTos);
        mail.setSubject(ERSubject);
        mail.setUseSignature(false);
        mail.setHtmlBody(ERBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

        system.debug('Email' + ERBody);
    }
    
    //Implementation - Handling the failed records from the Database methods - Najmal - March 07th,2023 - #305622
     public void updateFailedBoothStaging(List<BoothStagingWrapper> boothStgList,List<Database.SaveResult> accountResults,List<Account> accounts,
                                         List<Database.SaveResult> cleanContactsResult,List<Contact> cleanContacts,
                                         List<Database.SaveResult> boothResult,List<Oracle_Show_Booth__c> booths,
                                         List<Database.SaveResult> exBoothResult,List<Oracle_Show_Booth__c> exBooths,
                                         List<Database.SaveResult> bcontactsResult,List<Oracle_Show_Booth_Contact__c> bcontacts,
                                         List<Database.SaveResult> exbcontactsResult,List<Oracle_Show_Booth_Contact__c> exbcontacts){
        List<Booth_Staging__c> failedStages = new List<Booth_Staging__c>();
        for(BoothStagingWrapper boothstg : boothStgList){
            boolean isNext = false;
            //for account insert
            for( integer i=0; i < accountResults.size(); i++ ){
                if(!accountResults.get(i).isSuccess() && boothstg.account === accounts.get(i)){
                    boothstg.staging.Confirmation_Error__c = accountResults.get(i).getErrors().get(0).getMessage();
                    failedStages.add(boothstg.staging);
                    isNext = true;
                    break;
                }
            }if(isNext)
                continue;
            //for contact insert
            for( integer i=0; i < cleanContactsResult.size(); i++ ){
                if(!cleanContactsResult.get(i).isSuccess() && boothstg.contact == cleanContacts.get(i)){
                    boothstg.staging.Confirmation_Error__c = cleanContactsResult.get(i).getErrors().get(0).getMessage();
                    failedStages.add(boothstg.staging);
                    isNext = true;
                    break;
                }
            }if(isNext)
                continue;
            //for booth insert
            for( integer i=0; i < boothResult.size(); i++ ){
                if(!boothResult.get(i).isSuccess() && boothstg.booth == booths.get(i)){
                    boothstg.staging.Confirmation_Error__c = boothResult.get(i).getErrors().get(0).getMessage();
                    failedStages.add(boothstg.staging);
                    isNext = true;
                    break;
                }
            }if(isNext)
                continue;
            //for booth update
            for( integer i=0; i < exBoothResult.size(); i++ ){
                if(!exBoothResult.get(i).isSuccess() && boothstg.booth == exBooths.get(i)){
                    boothstg.staging.Confirmation_Error__c = exBoothResult.get(i).getErrors().get(0).getMessage();
                    failedStages.add(boothstg.staging);
                    isNext = true;
                    break;
                }
            }if(isNext)
                continue;
            //for booth contact insert
            for( integer i=0; i < bcontactsResult.size(); i++ ){
                if(!bcontactsResult.get(i).isSuccess() && boothstg.boothContact == bcontacts.get(i)){
                    boothstg.staging.Confirmation_Error__c = bcontactsResult.get(i).getErrors().get(0).getMessage();
                    failedStages.add(boothstg.staging);
                    isNext = true;
                    break;
                }
            }if(isNext)
                continue;
            //for booth contact update
            for( integer i=0; i < exbcontactsResult.size(); i++ ){
                if(!exbcontactsResult.get(i).isSuccess() && boothstg.boothContact == exbcontacts.get(i)){
                    boothstg.staging.Confirmation_Error__c = exbcontactsResult.get(i).getErrors().get(0).getMessage();
                    failedStages.add(boothstg.staging);
                    break;
                }
            }
        }
        for(Booth_Staging__c staging : failedStages){
            staging.Status__c = 'Failed';
            staging.Account_ID__r = null;
            staging.Booth_Contact_ID__r = null;
            staging.Contact_ID__r = null;
            staging.Booth_ID_2__r = null;
            system.debug('failed: ' + staging.Id);
            ERBodyAux += '<tr>'; 
            ERBodyAux += '<td><a href="http://' + pageHost + '/' + staging.Id + '">' + staging.Name + '</a></td>';
            ERBodyAux += '<td>' + staging.Company__c + '</td>';
            ERBodyAux += '<td>' + staging.Stand_Number__c + '</td>';
            ERBodyAux += '<td>' + staging.Confirmation_Error__c + '</td>';                    
            ERBodyAux += '</tr>';
        }
        update failedStages;
    }
    
    public void getFailedBoothDetails(List<Database.SaveResult> results,List<BoothStagingWrapper> boothStgList,List<Account> accounts){
        for( integer i=0; i < results.size(); i++ ){
            if(!results.get(i).isSuccess()){
                system.debug('********* Failed *********'+results.get(i).getErrors()[0].getMessage());
                for(BoothStagingWrapper boothstg : boothStgList){
                    if(boothstg.account == accounts.get(i)){
                        system.debug('********* Success *********');
                    }
                }
            }
        }
    }
    
    //#426842 - will return the list of accounts with same details but different zipcode
    public List<Account> getAccountListWithDifferentZipCode(BoothStagingWrapper bsw, List<Account> accListTemp){
        String zipCode;
        if(bsw.staging.Post_Zip_Code__c.length() == 4){
            zipCode = bsw.staging.Post_Zip_Code__c.left(2)+' '+ bsw.staging.Post_Zip_Code__c.right(2);
            accListTemp.add(new Account(Name = bsw.staging.Company__c,BillingPostalCode = zipCode,BillingCountry = bsw.staging.Country__c,EMEA__c = true));
        }else if(bsw.staging.Post_Zip_Code__c.length() == 5){
            zipCode = bsw.staging.Post_Zip_Code__c.left(2)+' '+ bsw.staging.Post_Zip_Code__c.right(3);
            accListTemp.add(new Account(Name = bsw.staging.Company__c,BillingPostalCode = zipCode,BillingCountry = bsw.staging.Country__c,EMEA__c = true));
            zipCode = bsw.staging.Post_Zip_Code__c.left(3)+' '+ bsw.staging.Post_Zip_Code__c.right(2);
            accListTemp.add(new Account(Name = bsw.staging.Company__c,BillingPostalCode = zipCode,BillingCountry = bsw.staging.Country__c,EMEA__c = true));
        }else if(bsw.staging.Post_Zip_Code__c.length() == 6){
            zipCode = bsw.staging.Post_Zip_Code__c.left(2)+' '+ bsw.staging.Post_Zip_Code__c.right(4);
            accListTemp.add(new Account(Name = bsw.staging.Company__c,BillingPostalCode = zipCode,BillingCountry = bsw.staging.Country__c,EMEA__c = true));
            zipCode = bsw.staging.Post_Zip_Code__c.left(3)+' '+ bsw.staging.Post_Zip_Code__c.right(3);
            accListTemp.add(new Account(Name = bsw.staging.Company__c,BillingPostalCode = zipCode,BillingCountry = bsw.staging.Country__c,EMEA__c = true));
            zipCode = bsw.staging.Post_Zip_Code__c.left(4)+' '+ bsw.staging.Post_Zip_Code__c.right(2);
            accListTemp.add(new Account(Name = bsw.staging.Company__c,BillingPostalCode = zipCode,BillingCountry = bsw.staging.Country__c,EMEA__c = true));
        }else if(bsw.staging.Post_Zip_Code__c.length() == 7){
            zipCode = bsw.staging.Post_Zip_Code__c.left(2)+' '+ bsw.staging.Post_Zip_Code__c.right(5);
            accListTemp.add(new Account(Name = bsw.staging.Company__c,BillingPostalCode = zipCode,BillingCountry = bsw.staging.Country__c,EMEA__c = true));
            zipCode = bsw.staging.Post_Zip_Code__c.left(3)+' '+ bsw.staging.Post_Zip_Code__c.right(4);
            accListTemp.add(new Account(Name = bsw.staging.Company__c,BillingPostalCode = zipCode,BillingCountry = bsw.staging.Country__c,EMEA__c = true));
            zipCode = bsw.staging.Post_Zip_Code__c.left(4)+' '+ bsw.staging.Post_Zip_Code__c.right(3);
            accListTemp.add(new Account(Name = bsw.staging.Company__c,BillingPostalCode = zipCode,BillingCountry = bsw.staging.Country__c,EMEA__c = true));
            zipCode = bsw.staging.Post_Zip_Code__c.left(5)+' '+ bsw.staging.Post_Zip_Code__c.right(2);
            accListTemp.add(new Account(Name = bsw.staging.Company__c,BillingPostalCode = zipCode,BillingCountry = bsw.staging.Country__c,EMEA__c = true));
        }
        return accListTemp;
    }
    
    public List<Opportunity> MatchExisting(List<BoothStagingWrapper> boothStagingList) {
        // booth matches 
        Set<String> boothAccounts = new Set<String>();
        Set<String> boothFNames = new Set<String>();
        Set<String> boothLNames = new Set<String>();
        // account matches 
        Set<String> accountNames = new Set<String>();
        Set<String> accountZips = new Set<String>();
        // booth contact matches
        Set<String> bcontFNames = new Set<String>();
        Set<String> bcontLNames = new Set<String>();
        Set<String> bcontZips = new Set<String>();
        Set<String> bcontStands = new Set<String>();
        // contact matches
        Set<String> emails = new Set<String>();
        Set<String> contFNames = new Set<String>();
        Set<String> contLNames = new Set<String>();
        Set<String> contZips = new Set<String>();
        List<Account> accountMatches = new List<Account>();
        for (BoothStagingWrapper staging : boothStagingList) {
            if(isDuplicationCheck){
                List<Account> accList = new List<Account>();
                
                //#426842--Start--Finding the duplicate accounts based on the EMEA Account Duplication Rule
                accList.add(new Account(Name = staging.staging.Company__c,BillingPostalCode = staging.staging.Post_Zip_Code__c,BillingCountry = staging.staging.Country__c,EMEA__c = true));
                if(!String.isBlank(staging.staging.Post_Zip_Code__c) && staging.staging.Post_Zip_Code__c.containsWhitespace())
                    accList.add(new Account(Name = staging.staging.Company__c,BillingPostalCode = staging.staging.Post_Zip_Code__c.deleteWhitespace(),BillingCountry = staging.staging.Country__c,EMEA__c = true));
                else if(!String.isBlank(staging.staging.Post_Zip_Code__c) && staging.staging.Post_Zip_Code__c.length()>3)
                    accList = getAccountListWithDifferentZipCode(staging,accList);
                List<Datacloud.FindDuplicatesResult> results = Datacloud.FindDuplicates.findDuplicates(accList);
                for (Datacloud.FindDuplicatesResult findDupeResult : results) {
                    Boolean readyToJumbNext = false;
                    for (Datacloud.DuplicateResult dupeResult : findDupeResult.getDuplicateResults()) {
                        for (Datacloud.MatchResult matchResult : dupeResult.getMatchResults()) {
                            for (Datacloud.MatchRecord matchRecord : matchResult.getMatchRecords()) {
                                Account matchedAcc = (Account) matchRecord.getRecord();
                                accountMatches.add(matchedAcc);
                                staging.account.Id = matchedAcc.Id;
                                readyToJumbNext=true;
                                staging.staging.Account_ID__r=matchedAcc;
                                boothAccounts.add(matchedAcc.Name);
                                break;
                            }
                            if(readyToJumbNext)break;
                        }
                        if(readyToJumbNext)break;
                    }
                    if(readyToJumbNext)break;
                }
            }
            //#426842--End--Finding the duplicate accounts based on the EMEA Account Duplication Rule
            
            // booth matches 
            //#336693 To avoid blank values from the list for better query perfomance - 10-07-2023 - start
            if(!String.isBlank(staging.staging.Company__c))
                boothAccounts.add(staging.staging.Company__c);
            if(!String.isBlank(staging.staging.First_Name__c))
                boothFNames.add(staging.staging.First_Name__c);
            if(!String.isBlank(staging.staging.Last_Name__c))
                boothLNames.add(staging.staging.Last_Name__c);
            // account matches 
            if(!String.isBlank(staging.staging.Company__c))
                accountNames.add(staging.staging.Company__c);
            if(!String.isBlank(staging.staging.Post_Zip_Code__c))
                accountZips.add(staging.staging.Post_Zip_Code__c);
            System.debug('accountNames--> '+accountNames);
            System.debug('accountZips--> '+accountZips);
            // booth contact matches
            if(!String.isBlank(staging.staging.First_Name__c))
                bcontFNames.add(staging.staging.First_Name__c);
            if(!String.isBlank(staging.staging.Last_Name__c))
                bcontLNames.add(staging.staging.Last_Name__c);
            if(!String.isBlank(staging.staging.Post_Zip_Code__c))
                bcontZips.add(staging.staging.Post_Zip_Code__c);
            if(!String.isBlank(staging.staging.Stand_Number__c))
                bcontStands.add(staging.staging.Stand_Number__c);
            // contact matches
            if(!String.isBlank(staging.staging.Email__c))
                emails.add(staging.staging.Email__c);
            if(!String.isBlank(staging.staging.First_Name__c))
                contFNames.add(staging.staging.First_Name__c);
            if(!String.isBlank(staging.staging.Last_Name__c))
                contLNames.add(staging.staging.Last_Name__c);
            if(!String.isBlank(staging.staging.Post_Zip_Code__c))
                contZips.add(staging.staging.Post_Zip_Code__c);
            //#336693 To avoid blank values from the list for better query perfomance - 10-07-2023 - end
        }
        
        List<Oracle_Show_Booth__c> boothMatches = [SELECT Id, Account__c, Account__r.Name, Account__r.BillingPostalCode, Booth_Number__c, BOOTH_ID__c, Booth_Height__c, BOOTH_LENGTH__c, BOOTH_SIZE__c, BOOTH_TYPE__c, BOOTH_WIDTH__c, Business_Type__c, Cust_Type__c, Design_Configuration__c, Discount__c, CONTACT_EMAIL__c, Exhibitor_Body__c, Exhibitor_Status__c, CONTACT_FAX__c, CONTACT_FIRST_NAME__c, CONTACT_LAST_NAME__c, Nameboard_Name__c, New_Exhibitor__c, Notes__c, Open_Sides__c, Zone__c, Package_Type__c, CONTACT_PHONE__c, Pillar_Column_Size__c, Service_Zone__c, Show_Occurrence__c FROM Oracle_Show_Booth__c WHERE Show_Occurrence__c = :boothUpload.Opportunity__c AND Account__r.Name IN :boothAccounts];
        //#426842 Fetch accounts via soql only if isDuplicationCheck is false
        if(!isDuplicationCheck)
            accountMatches = [SELECT Id, EURO_SOP_ID__c, ME_SOP_ID__c, UK_SOP_ID__c, Name, BillingPostalCode, BillingStreet, BillingCity, BillingState, BillingCountry, Phone, Website, Vat_Number__c FROM Account WHERE Name IN :accountNames AND BillingPostalCode IN :accountZips];
        List<Oracle_Show_Booth_Contact__c> bcontMatches = [SELECT Id, Oracle_Show_Booth__r.Booth_Number__c, Oracle_Show_Booth__r.Show_Occurrence__c, 
                                                            Agency_Contact__c, Agency_Email__c, Agency_Phone__c, Mailing_City__c, Contractor_Contact__c, 
                                                            Contractor_Email__c, Contractor_Phone__c, Contact__c, Mailing_Country__c, EMAIL__c, FAX__c, 
                                                            FIRST_NAME__c, LAST_NAME__c, PHONE__c, Mailing_Postal_Code__c, Mailing_State__c, Mailing_Street__c 
                                                                FROM Oracle_Show_Booth_Contact__c 
                                                                WHERE First_Name__c IN :bcontFNames AND Last_Name__c IN :bcontLNames 
                                                                            AND Mailing_Postal_Code__c In :bcontZips 
                                                                            // AND Oracle_Show_Booth__r.Booth_Number__c IN :bcontStands 
                                                                            AND Oracle_Show_Booth__r.Show_Occurrence__c = :boothUpload.Opportunity__c];
        System.debug('***bcontMatches: ' + bcontMatches);
        //#426842 Get contacts based on emails if isDuplicationCheck is true
        List<Contact> contactMatches = !isDuplicationCheck ? [SELECT Id, Email, Account.Name, Fax, MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry, FirstName, LastName, Phone FROM Contact WHERE FirstName IN :contFNames AND LastName IN :contLNames AND MailingPostalCode IN :contZips] :
                                        [SELECT Id, Email, Account.Name, Fax, MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry, FirstName, LastName, Phone FROM Contact WHERE Email IN :emails];
        
        for (BoothStagingWrapper bs : boothStagingList) {
            //#426842 do the account duplication via soql only if isDuplicationCheck is false
            if(!isDuplicationCheck){
                for (Account match : accountMatches) {
                    if (bs.staging.Company__c == match.Name && bs.staging.Post_Zip_Code__c == match.BillingPostalCode) {
                        bs.account = match;
                    }
                }
            }
            
            for (Oracle_Show_Booth__c match : boothMatches) {
                // if (bs.staging.Company__c == match.Account__r.Name && bs.staging.First_Name__c == match.CONTACT_FIRST_NAME__c && bs.staging.Last_Name__c == match.CONTACT_LAST_NAME__c && bs.staging.Stand_Number__c == match.BOOTH_NUMBER__c) {
                if ( (bs.staging.Account_ID__r.Name == match.Account__r.Name  || bs.staging.Company__c == match.Account__r.Name) && bs.staging.Post_Zip_Code__c == match.Account__r.BillingPostalCode ) {
                    bs.accountBooths.add(match);
                    
                    if (bs.staging.Stand_Number__c == match.BOOTH_NUMBER__c) {
                        bs.booth = match; 
                        bs.account.Id = match.Account__r.Id;
                        bs.staging.Account_ID__r=match.Account__r;
                    }
                }
            }
            
            string currentStandNumber = '';
            
            if (bs.booth != null)
            {
                currentStandNumber = bs.booth.BOOTH_NUMBER__c;
            }
            
            //#426842 - no need of the below validations anymore and keeping isDuplicationCheck as flag if the validation needed back
            if (bs.account.Id != null && !isDuplicationCheck) {
                
                // need to read the staging records directly from the data because the List passed in can be partial and not a full list
                // only one execution of the query is required.so kept inside If - Najmal - March 07th,2023 - #305622
                if(fullStagingList.isEmpty()){
                    fullStagingList = [SELECT Id, Name, Show_Name__c, Status__c, Account_ID__r.Name, Country__c, Address_1__c, Address_2__c, Address_3__c, Agency_Contact__c, 
                                       Agency_Email__c, Agency_Phone__c, Booth_Height__c, Booth_ID__c, Booth_Length__c, Booth_Size__c, Booth_Width__c, Business_Type__c, City__c, Company__c, 
                                       Email__c, Exhibitor_Body__c, Exhibitor_GUID__c, Exhibitor_Username__c, Exhibitor_Password__c, 
                                       Exhibitor_Status__c, Fax__c, First_Name__c, Last_Name__c, Nameboard_Name__c, New_Exhibitor__c, Notes__c, Open_Sides__c, Operations_Zone__c, Package_Type__c, Phone_Number__c, 
                                       Pillar_Column_Size_c__c, Post_Zip_Code__c, Service_Zone__c, Stand_Number__c, Stand_Type__c, State_County__c, Vat_Number__c, Website__c, Mobile__c, Salutation__c,
                                       Contractor_Contact__c, Contractor_Email__c, Contact_ID__c, Contractor_Phone__c, Cust_Type__c, Design_Configuration__c, Discount__c
                                       FROM Booth_Staging__c WHERE Booth_Upload__c = :BoothUpload.Id] ;
                }
                for (Booth_Staging__c staging : fullStagingList) {
                    if (staging.Company__c == bs.staging.Company__c && staging.Post_Zip_Code__c == bs.staging.Post_Zip_Code__c ) {
                        bs.batchBooths.add(staging);
                    }
                }
                
                Integer accountBoothCount = bs.accountBooths.size();
                Integer batchBoothCount = bs.batchBooths.size();
                
                if (batchBoothCount == 1)
                {
                    switch on accountBoothCount {
                        when 0 {
                            // The account doesn't have any booths so we can create them
                        }
                        when 1
                        {
                            bs.booth = bs.accountBooths.get(0);
                            currentStandNumber = bs.booth.BOOTH_NUMBER__c;
                        }
                        when else {
                            if (bs.booth.Id == null)
                            {
                                bs.AddToExceptionReport = true;
                                bs.ExceptionInformation = 'Batch contains only one booth but accounts has two or more boothes.';
                            }
                        }
                    }
                    
                }
                else
                {
                    if (accountBoothCount >=1)
                    {
                        Integer numberOfBoothsFound = 0;
                        Integer numberOfBoothsMissing = 0;
                        
                        boolean accountBoothFound = false;
                        Oracle_Show_Booth__c missingAccountBooth = null;
                        
                        
                        
                        for (Oracle_Show_Booth__c ab : bs.accountBooths) {
                            
                            
                            accountBoothFound = false;
                            
                            for (Booth_Staging__c bb : bs.batchBooths) {
                                if (ab.Booth_Number__c == bb.Stand_Number__c)
                                {
                                    accountBoothFound = true;
                                    break;
                                }
                                
                                
                            }
                            
                            if (accountBoothFound)
                            {
                                numberOfBoothsFound = numberOfBoothsFound + 1;
                            }
                            else
                            {
                                numberOfBoothsMissing = numberOfBoothsMissing + 1;
                                if (numberOfBoothsMissing == 1)
                                {
                                    missingAccountBooth = ab;
                                }
                                else
                                {
                                    missingAccountBooth = null;
                                }
                            }
                            
                        }
                        
                        if (numberOfBoothsFound == bs.accountBooths.size() || numberOfBoothsMissing == 1  )
                        {
                            if (numberOfBoothsMissing == 1)
                            {
                                if (bs.booth.Id == null)
                                {
                                    if (numberOfBoothsFound != bs.accountBooths.size())
                                    {
                                        if (missingAccountBooth == null)
                                        {
                                            bs.AddToExceptionReport = true;
                                            bs.ExceptionInformation = 'Unable to find booth to update the stand number.';
                                        }
                                        else
                                        {
                                            bs.booth = missingAccountBooth;
                                            currentStandNumber = bs.booth.BOOTH_NUMBER__c;
                                        }
                                    }
                                }
                            }
                            else if (numberOfBoothsMissing >= 2 && numberOfBoothsFound != bs.accountBooths.size())
                            {
                                bs.AddToExceptionReport = true;
                                bs.ExceptionInformation = 'Batch is missing two or more booths.';
                            }
                            
                        }
                        else
                        {
                            if (numberOfBoothsFound == fullStagingList.size())
                            {
                                // The batch is missing some of the booths that exist on the account but all the booths in the batch already exist on the account so they can be updated.
                            }
                            else
                            {
                                bs.AddToExceptionReport = true;
                                bs.ExceptionInformation = 'Two or more existing booths are missing from the batch.';
                            }
                            
                        }
                    }
                }
                
            }
            
            
            for (Oracle_Show_Booth_Contact__c match : bcontMatches) {
                System.debug('***match: ' + match);
                System.debug('***bs.staging: ' + bs.staging);
                if (bs.staging.First_Name__c == match.First_Name__c && bs.staging.Last_Name__c == match.Last_Name__c
                                            && bs.staging.Post_Zip_Code__c == match.Mailing_Postal_Code__c 
                                            && bs.staging.Email__c == match.EMAIL__c 
                                            && bs.staging.Stand_Number__c == match.Oracle_Show_Booth__r.Booth_Number__c 
                                            && boothUpload.Opportunity__c == match.Oracle_Show_Booth__r.Show_Occurrence__c 
                                            //&& match.Contact__c == bs.staging.Contact_ID__c
                                            ) {
                    bs.boothContact = match;
                    System.debug('***bs.boothContact: ' + bs.boothContact);
                }
                System.debug('***next item');
            }
            List<Contact> bsMatchContacts = new List<Contact>();
            for (Contact match : contactMatches) {
                System.debug(loggingLevel.Error, '*** match: ' + match);
                System.debug(loggingLevel.Error, '*** bs.contact: ' + bs.contact);
                //#426842 - Do the contact duplication check based on email and parent account name if isDuplicationCheck is true
                if (!isDuplicationCheck && bs.staging.First_Name__c == match.FirstName && bs.staging.Last_Name__c == match.LastName && bs.staging.Post_Zip_Code__c == match.MailingPostalCode && (bs.staging.Account_ID__r.Name == match.Account.Name || bs.staging.Company__c == match.Account.Name)) {
                    bs.contact = match;
                }else if(bs.staging.Email__c == match.Email && (bs.staging.Account_ID__r.Name == match.Account.Name || bs.staging.Company__c == match.Account.Name)) {
                    bs.contact = match;
                }
            }
        }
        
        List<Opportunity> auxOpps = [SELECT Id, AccountId FROM Opportunity WHERE AccountId IN :accountMatches AND RecordType.DeveloperName = 'EMEA_Custom_Build' AND Show_Occurrence__c = :boothUpload.Opportunity__c];
        return auxOpps;
    }
    
    public class BoothStagingWrapper {
        
        public Booth_Staging__c staging { get; set; }
        
        public Oracle_Show_Booth__c booth { get; set; }
        public Account account { get; set; }
        public Oracle_Show_Booth_Contact__c boothContact { get; set; }
        public Contact contact { get; set; }


        public List<Oracle_Show_Booth__c> accountBooths { get; set; }
        public List<Booth_Staging__c> batchBooths { get; set; }

        public boolean AddToExceptionReport { get; set; }
        public string ExceptionInformation { get; set; }

        
        public boolean putInTheEmail {
            get {
                System.debug('putInTheEmail?');
                System.debug('booth record--> '+booth);
                
                if (booth.id != null || Test.isRunningTest()) {

                    boolean returnValue = false;
                    if (booth.BOOTH_ID__c != staging.Booth_ID__c)
                    { 
                        if (this.ExceptionInformation.Length() != 0) 
                        {
                            this.ExceptionInformation = this.ExceptionInformation + '<br />';
                        }
                        this.ExceptionInformation = this.ExceptionInformation + 'Booth ID changed from ' + booth.BOOTH_ID__c + ' to ' + staging.Booth_ID__c;
                        returnValue = true;
                    }

                    if (booth.BOOTH_NUMBER__c != staging.Stand_Number__c) { 
                        if (this.ExceptionInformation.Length() != 0) 
                        {
                            this.ExceptionInformation = this.ExceptionInformation + '<br />';
                        }
                        this.ExceptionInformation = this.ExceptionInformation + 'Booth Number changed from ' + booth.BOOTH_NUMBER__c + ' to ' + staging.Stand_Number__c;
                        returnValue = true;
                    }

                    if (booth.Booth_Height__c != staging.Booth_Height__c) { 
                        if (this.ExceptionInformation.Length() != 0) 
                        {
                            this.ExceptionInformation = this.ExceptionInformation + '<br />';
                        }
                        this.ExceptionInformation = this.ExceptionInformation + 'Booth height changed from ' + String.valueOf(booth.Booth_Height__c) + ' to ' + String.valueOf(staging.Booth_Height__c);
                        returnValue = true;
                    }

                    try {
                        if (booth.BOOTH_LENGTH__c != Decimal.valueOf(staging.Booth_Length__c)) 
                        {
                        if (this.ExceptionInformation.Length() != 0) 
                        {
                            this.ExceptionInformation = this.ExceptionInformation + '<br />';
                        }
                        this.ExceptionInformation = this.ExceptionInformation + 'Booth length changed from ' + String.valueOf(booth.BOOTH_LENGTH__c) + ' to ' + staging.Booth_Length__c;
                        returnValue = true;
                        }
                    } catch (Exception ex) { } 


                    if (booth.BOOTH_SIZE__c != staging.Booth_Size__c)
                    {
                        if (this.ExceptionInformation.Length() != 0) 
                        {
                            this.ExceptionInformation = this.ExceptionInformation + '<br />';
                        }
                        this.ExceptionInformation = this.ExceptionInformation + 'Booth size changed from ' + String.valueOf(booth.BOOTH_SIZE__c) + ' to ' + String.valueOf(staging.BOOTH_SIZE__c);
                        returnValue = true;
                    }


                    if (booth.BOOTH_TYPE__c != staging.Stand_Type__c) 
                    {
                        if (this.ExceptionInformation.Length() != 0) 
                        {
                            this.ExceptionInformation = this.ExceptionInformation + '<br />';
                        }
                        this.ExceptionInformation = this.ExceptionInformation + 'Booth type changed from ' + booth.BOOTH_TYPE__c + ' to ' + staging.Stand_Type__c;
                        returnValue = true;
                    }


                    try {
                        if (booth.BOOTH_WIDTH__c != Decimal.valueOf(staging.Booth_Width__c))
                                            {
                        if (this.ExceptionInformation.Length() != 0) 
                        {
                            this.ExceptionInformation = this.ExceptionInformation + '<br />';
                        }
                        this.ExceptionInformation = this.ExceptionInformation + 'Booth width changed from ' + String.valueOf(booth.BOOTH_WIDTH__c) + ' to ' + staging.Booth_Width__c;
                        returnValue = true;
                    }
                    } catch (Exception ex) { } 

                    if (booth.Business_Type__c != (staging.Business_Type__c == null || staging.Business_Type__c == '' ? 'Exhibitor' : staging.Business_Type__c) ) 
                    {
                        if (this.ExceptionInformation.Length() != 0) 
                        {
                            this.ExceptionInformation = this.ExceptionInformation + '<br />';
                        }
                        this.ExceptionInformation = this.ExceptionInformation + 'Business type changed from ' + booth.Business_Type__c + ' to ' + (staging.Business_Type__c == null || staging.Business_Type__c == '' ? 'Exhibitor' : staging.Business_Type__c);
                        returnValue = true;
                    }

                    if (booth.Cust_Type__c != staging.Cust_Type__c)
                                        {
                        if (this.ExceptionInformation.Length() != 0) 
                        {
                            this.ExceptionInformation = this.ExceptionInformation + '<br />';
                        }
                        this.ExceptionInformation = this.ExceptionInformation + 'Customer type changed from ' + booth.Cust_Type__c + ' to ' + staging.Cust_Type__c;
                        returnValue = true;
                    }

                    if (booth.Design_Configuration__c != staging.Design_Configuration__c) 
                                                            {
                        if (this.ExceptionInformation.Length() != 0) 
                        {
                            this.ExceptionInformation = this.ExceptionInformation + '<br />';
                        }
                        this.ExceptionInformation = this.ExceptionInformation + 'Design configuration changed from ' + booth.Design_Configuration__c + ' to ' + staging.Design_Configuration__c;
                        returnValue = true;
                    }

                    if (booth.Discount__c != staging.Discount__c)                                                             
                    {
                        if (this.ExceptionInformation.Length() != 0) 
                        {
                            this.ExceptionInformation = this.ExceptionInformation + '<br />';
                        }
                        this.ExceptionInformation = this.ExceptionInformation + 'Discount changed from ' + booth.Discount__c + ' to ' + staging.Discount__c;
                        returnValue = true;
                    }

                    if (booth.CONTACT_EMAIL__c != staging.Email__c) {
                        if (this.ExceptionInformation.Length() != 0) 
                        {
                            this.ExceptionInformation = this.ExceptionInformation + '<br />';
                        }
                        this.ExceptionInformation = this.ExceptionInformation + 'Email changed from ' + booth.CONTACT_EMAIL__c + ' to ' + staging.Email__c;
                        returnValue = true;
                    }

                    if (booth.Exhibitor_Body__c != staging.Exhibitor_Body__c) {
                        if (this.ExceptionInformation.Length() != 0) 
                        {
                            this.ExceptionInformation = this.ExceptionInformation + '<br />';
                        }
                        this.ExceptionInformation = this.ExceptionInformation + 'Exhibitor body from ' + booth.Exhibitor_Body__c + ' to ' + staging.Exhibitor_Body__c;
                        returnValue = true;
                    }

                    if (booth.Exhibitor_Status__c != staging.Exhibitor_Status__c) {
                        if (this.ExceptionInformation.Length() != 0) 
                        {
                            this.ExceptionInformation = this.ExceptionInformation + '<br />';
                        }
                        this.ExceptionInformation = this.ExceptionInformation + 'Exhibitor status from ' + booth.Exhibitor_Status__c + ' to ' + staging.Exhibitor_Status__c;
                        returnValue = true;
                    }

                    if (booth.CONTACT_FAX__c != staging.Fax__c) {
                        if (this.ExceptionInformation.Length() != 0) 
                        {
                            this.ExceptionInformation = this.ExceptionInformation + '<br />';
                        }
                        this.ExceptionInformation = this.ExceptionInformation + 'Fax from ' + booth.CONTACT_FAX__c + ' to ' + staging.Fax__c;
                        returnValue = true;
                    }

                    if (booth.CONTACT_FIRST_NAME__c != staging.First_Name__c){
                        if (this.ExceptionInformation.Length() != 0) 
                        {
                            this.ExceptionInformation = this.ExceptionInformation + '<br />';
                        }
                        this.ExceptionInformation = this.ExceptionInformation + 'First name changed from ' + booth.CONTACT_FIRST_NAME__c + ' to ' + staging.First_Name__c;
                        returnValue = true;
                    }

                    if (booth.CONTACT_LAST_NAME__c != staging.Last_Name__c) {
                        if (this.ExceptionInformation.Length() != 0) 
                        {
                            this.ExceptionInformation = this.ExceptionInformation + '<br />';
                        }
                        this.ExceptionInformation = this.ExceptionInformation + 'Last name changed from ' + booth.CONTACT_LAST_NAME__c + ' to ' + staging.Last_Name__c;
                        returnValue = true;
                    }

                    if (booth.Nameboard_Name__c != staging.Nameboard_Name__c) {
                        if (this.ExceptionInformation.Length() != 0) 
                        {
                            this.ExceptionInformation = this.ExceptionInformation + '<br />';
                        }
                        this.ExceptionInformation = this.ExceptionInformation + 'Nameboard name from ' + booth.Nameboard_Name__c + ' to ' + staging.Nameboard_Name__c;
                        returnValue = true;
                    }

                    if (booth.New_Exhibitor__c != staging.New_Exhibitor__c) {
                        if (this.ExceptionInformation.Length() != 0) 
                        {
                            this.ExceptionInformation = this.ExceptionInformation + '<br />';
                        }
                        this.ExceptionInformation = this.ExceptionInformation + 'New exhibitor changed from ' + (booth.New_Exhibitor__c ? 'Yes' : 'No') + ' to ' + (staging.New_Exhibitor__c ? 'Yes' : 'No');
                        returnValue = true;
                    }

                    if (booth.Notes__c != staging.Notes__c) {
                        if (this.ExceptionInformation.Length() != 0) 
                        {
                            this.ExceptionInformation = this.ExceptionInformation + '<br />';
                        }
                        this.ExceptionInformation = this.ExceptionInformation + 'Notes changed from ' + booth.Notes__c + ' to ' + staging.Notes__c;
                        returnValue = true;
                    }

                    if (booth.Open_Sides__c != staging.Open_Sides__c) {
                        if (this.ExceptionInformation.Length() != 0) 
                        {
                            this.ExceptionInformation = this.ExceptionInformation + '<br />';
                        }
                        this.ExceptionInformation = this.ExceptionInformation + 'Open sides changed from ' + booth.Open_Sides__c + ' to ' + staging.Open_Sides__c;
                        returnValue = true;
                    }

                    if (booth.Zone__c != staging.Operations_Zone__c) {
                        if (this.ExceptionInformation.Length() != 0) 
                        {
                            this.ExceptionInformation = this.ExceptionInformation + '<br />';
                        }
                        this.ExceptionInformation = this.ExceptionInformation + 'Operations zone changed from ' + booth.Zone__c + ' to ' + staging.Operations_Zone__c;
                        returnValue = true;
                    }

                    if (booth.Package_Type__c != staging.Package_Type__c) {
                        if (this.ExceptionInformation.Length() != 0) 
                        {
                            this.ExceptionInformation = this.ExceptionInformation + '<br />';
                        }
                        this.ExceptionInformation = this.ExceptionInformation + 'Package type changed from ' + booth.Package_Type__c + ' to ' + staging.Package_Type__c;
                        returnValue = true;
                    }

                    if (booth.CONTACT_PHONE__c != staging.Phone_Number__c) {
                        if (this.ExceptionInformation.Length() != 0) 
                        {
                            this.ExceptionInformation = this.ExceptionInformation + '<br />';
                        }
                        this.ExceptionInformation = this.ExceptionInformation + 'Phone changed from ' + booth.CONTACT_PHONE__c + ' to ' + staging.Phone_Number__c;
                        returnValue = true;
                    }

                    if (booth.Pillar_Column_Size__c != staging.Pillar_Column_Size_c__c) {
                        if (this.ExceptionInformation.Length() != 0) 
                        {
                            this.ExceptionInformation = this.ExceptionInformation + '<br />';
                        }
                        this.ExceptionInformation = this.ExceptionInformation + 'Pillar column size changed from ' + String.valueOf(booth.Pillar_Column_Size__c) + ' to ' + String.valueOf(staging.Pillar_Column_Size_c__c);
                        returnValue = true;
                    }

                    if (booth.Service_Zone__c != staging.Service_Zone__c) {
                        if (this.ExceptionInformation.Length() != 0) 
                        {
                            this.ExceptionInformation = this.ExceptionInformation + '<br />';
                        }
                        this.ExceptionInformation = this.ExceptionInformation + 'Service zone changed from ' + booth.Service_Zone__c + ' to ' + staging.Service_Zone__c;
                        returnValue = true;
                    }


                    return returnValue;
                }
                return false;
            }
        }
        
        public BoothStagingWrapper(Booth_Staging__c s) {
            staging = s;
            
            booth = new Oracle_Show_Booth__c();
            account = new Account();
            boothContact = new Oracle_Show_Booth_Contact__c();
            contact = new Contact();
            accountBooths = new List<Oracle_Show_Booth__c>();
            batchBooths = new List<Booth_Staging__c>();

            ExceptionInformation = '';

            AddToExceptionReport = false;
            
            CleanupNulls();
        }
        
        private void CleanupNulls() {
            if (staging.Show_Name__c != null && staging.Show_Name__c.toLowerCase() == 'null') staging.Show_Name__c = null;
            if (staging.Status__c != null && staging.Status__c.toLowerCase() == 'null') staging.Status__c = null;
            if (staging.Address_1__c != null && staging.Address_1__c.toLowerCase() == 'null') staging.Address_1__c = null;
            if (staging.Address_2__c != null && staging.Address_2__c.toLowerCase() == 'null') staging.Address_2__c = null;
            if (staging.Address_3__c != null && staging.Address_3__c.toLowerCase() == 'null') staging.Address_3__c = null;
            if (staging.Agency_Contact__c != null && staging.Agency_Contact__c.toLowerCase() == 'null') staging.Agency_Contact__c = null;
            if (staging.Agency_Email__c != null && staging.Agency_Email__c.toLowerCase() == 'null') staging.Agency_Email__c = null;
            if (staging.Agency_Phone__c != null && staging.Agency_Phone__c.toLowerCase() == 'null') staging.Agency_Phone__c = null;
            if (staging.Booth_ID__c != null && staging.Booth_ID__c.toLowerCase() == 'null') staging.Booth_ID__c = null;
            if (staging.Booth_Length__c != null && staging.Booth_Length__c.toLowerCase() == 'null') staging.Booth_Length__c = null;
            if (staging.Booth_Width__c != null && staging.Booth_Width__c.toLowerCase() == 'null') staging.Booth_Width__c = null;
            if (staging.Business_Type__c != null && staging.Business_Type__c.toLowerCase() == 'null') staging.Business_Type__c = null;
            if (staging.City__c != null && staging.City__c.toLowerCase() == 'null') staging.City__c = null;
            if (staging.Company__c != null && staging.Company__c.toLowerCase() == 'null') staging.Company__c = null;
            if (staging.Contractor_Contact__c != null && staging.Contractor_Contact__c.toLowerCase() == 'null') staging.Contractor_Contact__c = null;
            if (staging.Contractor_Email__c != null && staging.Contractor_Email__c.toLowerCase() == 'null') staging.Contractor_Email__c = null;
            if (staging.Contractor_Phone__c != null && staging.Contractor_Phone__c.toLowerCase() == 'null') staging.Contractor_Phone__c = null;
            if (staging.Country__c != null && staging.Country__c.toLowerCase() == 'null') staging.Country__c = null;
            if (staging.Cust_Type__c != null && staging.Cust_Type__c.toLowerCase() == 'null') staging.Cust_Type__c = null;
            if (staging.Design_Configuration__c != null && staging.Design_Configuration__c.toLowerCase() == 'null') staging.Design_Configuration__c = null;
            if (staging.Discount__c != null && staging.Discount__c.toLowerCase() == 'null') staging.Discount__c = null;
            if (staging.Email__c != null && staging.Email__c.toLowerCase() == 'null') staging.Email__c = null;
            if (staging.Exhibitor_Body__c != null && staging.Exhibitor_Body__c.toLowerCase() == 'null') staging.Exhibitor_Body__c = null;
            if (staging.Exhibitor_Status__c != null && staging.Exhibitor_Status__c.toLowerCase() == 'null') staging.Exhibitor_Status__c = null;
            if (staging.Fax__c != null && staging.Fax__c.toLowerCase() == 'null') staging.Fax__c = null;
            if (staging.First_Name__c != null && staging.First_Name__c.toLowerCase() == 'null') staging.First_Name__c = null;
            if (staging.Last_Name__c != null && staging.Last_Name__c.toLowerCase() == 'null') staging.Last_Name__c = null;
            if (staging.Nameboard_Name__c != null && staging.Nameboard_Name__c.toLowerCase() == 'null') staging.Nameboard_Name__c = null;
            if (staging.Notes__c != null && staging.Notes__c.toLowerCase() == 'null') staging.Notes__c = null;
            if (staging.Operations_Zone__c != null && staging.Operations_Zone__c.toLowerCase() == 'null') staging.Operations_Zone__c = null;
            if (staging.Package_Type__c != null && staging.Package_Type__c.toLowerCase() == 'null') staging.Package_Type__c = null;
            if (staging.Phone_Number__c != null && staging.Phone_Number__c.toLowerCase() == 'null') staging.Phone_Number__c = null;
            if (staging.Post_Zip_Code__c != null && staging.Post_Zip_Code__c.toLowerCase() == 'null') staging.Post_Zip_Code__c = null;
            if (staging.Service_Zone__c != null && staging.Service_Zone__c.toLowerCase() == 'null') staging.Service_Zone__c = null;
            if (staging.Stand_Number__c != null && staging.Stand_Number__c.toLowerCase() == 'null') staging.Stand_Number__c = null;
            if (staging.Stand_Type__c != null && staging.Stand_Type__c.toLowerCase() == 'null') staging.Stand_Type__c = null;
            if (staging.State_County__c != null && staging.State_County__c.toLowerCase() == 'null') staging.State_County__c = null;
            if (staging.Vat_Number__c != null && staging.Vat_Number__c.toLowerCase() == 'null') staging.Vat_Number__c = null;
            if (staging.Website__c != null && staging.Website__c.toLowerCase() == 'null') staging.Website__c = null;
        }
        
    }

}