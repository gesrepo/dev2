public with sharing class CCXBoothContactDetailsController {
    
    private ApexPages.StandardController controller;
    private final Oracle_Show_Booth_Contact__c boothContact;
    private final Oracle_Show_Booth__c booth;
    public Oracle_Show_Booth_Contact__c bc { get; set; }
    
    public CCXBoothContactDetailsController(ApexPages.StandardController stdController)
    {
        controller = stdController;
        this.boothContact = (Oracle_Show_Booth_Contact__c)stdController.getRecord();
        this.booth = [Select Id, Account__c, Exhibitor_Name_Denormalized__c, Account__r.Name, SHOW_OCCR_CUST_ID__c,BOOTH_ID__c From Oracle_Show_Booth__c Where Id = :this.boothContact.Oracle_Show_Booth__c];
        //this.bc = [Select Id, CUST_BOOTH_ID__c, SHOW_OCCR_CUST_ID__c From Oracle_Show_Booth_Contact__c Where Id = :this.boothContact.Id]; // Added by Sajid on 04/10/23 sfdc-202
        //ApexPages.currentPage().getParameters().get('retUrl') = '/apex/PageBoothDetails?id=' + boothContact.Oracle_Show_Booth__c;
    }
    
    public PageReference createNew()
    {
        // Address fields removed from this check as National Servicenter is also going to
        // use this form and they do not fill this information
        // boothContact.Mailing_Street__c == null || boothContact.Mailing_City__c == null || 
        // boothContact.Mailing_State__c == null || boothContact.Mailing_Country__c == null || 
        // boothContact.Mailing_Postal_Code__c == null
        // Update 5/5/2013: Change so Email not required.
        //if ((boothContact.FIRST_NAME__c == null || boothContact.LAST_NAME__c == null || boothContact.EMAIL__c == null || boothContact.PHONE__c == null) && boothContact.Contact__c == null) // Necessary inputs must be provided. If not, throw back error.
        
        if ((boothContact.FIRST_NAME__c == null || boothContact.LAST_NAME__c == null || boothContact.PHONE__c == null) && boothContact.Contact__c == null) // Necessary inputs must be provided. If not, throw back error.        
        {
            ApexPages.Message Msg = new ApexPages.Message(ApexPages.Severity.FATAL,'Required fields missing. Please select an existing Contact OR enter First Name, Last Name and Phone.');
            ApexPages.addMessage(Msg);
        }
        else
        {
            Contact ExistingContact;
            
            if (boothContact.Contact__c != null)
                ExistingContact = [Select Id, FirstName, LastName, Email, Phone, Fax, MobilePhone, MailingStreet, MailingCity, MailingState, MailingCountry, MailingPostalCode From Contact Where Id = :boothContact.Contact__c];

            /*
                Since Booth Contact does not exist, the following scenarios are possible:
                1. Contact is selected and detail field(s) not specified.
                2. Contact is selected and one or more detail field(s) are specified
                3. Contact is not selected and all detail fields are specified
                
                Case 1 and 2: Use information of selected Contact. Ignore information specified by user
                Case 3: Create new Contact and Booth Contact with details specified by the user.
            */
            
            if (boothContact.Contact__c != null)
            {
                createBoothContact(boothContact, ExistingContact);
            }
            else
            {
                try
                {
                    string ContactId = createContact(boothContact);
                    
                    if (ContactId == '')
                    {
                        ApexPages.Message Msg = new ApexPages.Message(ApexPages.Severity.FATAL,boothContact.FIRST_NAME__c.toUpperCase() + ' ' + boothContact.LAST_NAME__c.toUpperCase() + (boothContact.EMAIL__c == null ? '' : ' (' + boothContact.EMAIL__c.toUpperCase() + ')') + ' already exists Or ' + boothContact.FIRST_NAME__c.toUpperCase() + ' ' + boothContact.LAST_NAME__c.toUpperCase() + (boothContact.EMAIL__c == null ? '' : ' (' + boothContact.EMAIL__c.toUpperCase() + ')') + ' is already associated to ' + this.booth.Exhibitor_Name_Denormalized__c.toUpperCase() + '. Please enter different contact information or use Option 1 i.e. select an existing contact.');
                        ApexPages.addMessage(Msg);
                    }
                    else
                    {
                        boothContact.Contact__c = ContactId;
                        Database.insert(boothContact);
                    }               
                }
                catch(exception e)
                {
                    ApexPages.Message Msg = new ApexPages.Message(ApexPages.Severity.FATAL, 'An error occurred while creating contact. Error message: ' + e.getMessage());
                    ApexPages.addMessage(Msg);      
                }
            }
        }
        
        //return Page.PageBoothDetails + "?id=" + boothContact.Oracle_Show_Booth__c;
        
        PageReference Pr = null;
        
        if (!ApexPages.hasMessages(ApexPages.Severity.FATAL))
            Pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/' + boothContact.id); // Added by Sajid on 04/12/23 - sfdc-202
       		//Pr = new PageReference('/apex/PageBoothContactDetails?id=' + boothContact.id + '&sfdc.override=1'); /** Commented by Sajid **/

        return Pr;
        
    }
    
    public PageReference updateExisting()
    {
        // Address fields removed from this check as National Servicenter is also going to
        // use this form and they do not fill this information
        // boothContact.Mailing_Street__c == null || boothContact.Mailing_City__c == null || 
        // boothContact.Mailing_State__c == null || boothContact.Mailing_Country__c == null || 
        // boothContact.Mailing_Postal_Code__c == null
        // Update 5/5/2013: Email not required.
        if (boothContact.FIRST_NAME__c == null || // Necessary inputs must be provided. If not, throw back error.
            boothContact.LAST_NAME__c == null || 
            //boothContact.EMAIL__c == null ||
            boothContact.PHONE__c == null)
        {
            ApexPages.Message Msg = new ApexPages.Message(ApexPages.Severity.FATAL,'Required fields missing. Please enter First Name, Last Name and Phone.');
            ApexPages.addMessage(Msg);
        }
        else
        {
            Contact ExistingContact;
            
            if (boothContact.Contact__c != null)
                ExistingContact = [Select Id, FirstName, LastName, Email, Phone, Fax, MobilePhone, MailingStreet, MailingCity, MailingState, MailingCountry, MailingPostalCode From Contact Where Id = :boothContact.Contact__c];

            /*
                Since Booth Contact exists, these scenarios are possible:
                
                1. A different Contact is selected and/or
                2. Details changed, which may require update of Contact in addition to Booth Contact.
                
                For the purpose of this form, we'll assume that user wants to update Booth Contact 
                information and that should also update contact information on the Contact record.
                
                Therefore, a separate form is created for "Edit". Also, the option to select another 
                "Contact" is removed from the Edit form - this field is read-only.
                
                Upon update, the Contact will be updated accordingly.
            */
            
            string NewContactId = null;
            
            if(ExistingContact != null)
                updateContact(boothContact, ExistingContact);
            else
            {
                //Means someone has deleted the contact. In this case, check
                //if there is a contact with the same first name, last name
                //associated to the same company, if so associate it to the
                //booth contact.
                List<Contact> LoExCon = [Select Id From Contact Where FirstName = :boothContact.FIRST_NAME__c
                                                                        and LastName = :boothContact.LAST_NAME__c
                                                                        and AccountId = :boothContact.Account_Id__c];
                                                                        
                if (LoExCon != null)
                {
                    Contact c = LoExCon[0];
                    boothContact.Contact__c = c.Id;
                }
                else
                {
                    //If a contact could not be found, create new contact and
                    //associate it to booth contact.
                    boothContact.Contact__c = createContact(boothContact);
                }
            }
            
            boothContact.Updated_In_Salesforce__c = true;
            
            Database.update(boothContact);
        }

        PageReference Pr = null;
        
        if (!ApexPages.hasMessages(ApexPages.Severity.FATAL))
            Pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/' + boothContact.id); // Added by Sajid on 04/12/23 - sfdc-202
            //Pr = new PageReference('/apex/PageBoothContactDetails?id=' + boothContact.id + '&sfdc.override=1'); // Commented by Sajid
        
        return Pr;
    }
    
    private string createContact(Oracle_Show_Booth_Contact__c boothContact)
    {
        string ReturnId = '';
        boolean CreateContact = true;
        List<Contact> LoDuplicateContacts = null;
        
        // Check if Contact with given Email Address, First Name and Last Name already exists. 
        // If it does, throw back an error asking user to select existing contact.
        if (boothContact.EMAIL__c != null && boothContact.EMAIL__c != '')
            LoDuplicateContacts = [Select Id, FirstName, LastName, Email, Phone, Fax, MobilePhone, MailingStreet, MailingCity, MailingState, MailingCountry, MailingPostalCode From Contact Where Email = :boothContact.EMAIL__c And FirstName = :boothContact.FIRST_NAME__c And LastName = :boothContact.LAST_NAME__c];
        
        if (LoDuplicateContacts != null && LoDuplicateContacts.size() > 0)
        {
            // Return empty string. This should be used to display error on the page.           
            CreateContact = false;
        }
        else
        {        
            // If combination of First Name, Last Name and Email does not exist, check if there is a contact
            // with same First Name and Last Name tied to the Account on the Booth, if it exists return
            // empty string as well.
            LoDuplicateContacts = [Select Id, FirstName, LastName, Email, Phone, Fax, MobilePhone, MailingStreet, MailingCity, MailingState, MailingCountry, MailingPostalCode From Contact Where AccountId = :this.booth.Account__c And FirstName = :boothContact.FIRST_NAME__c And LastName = :boothContact.LAST_NAME__c];
            
            if (LoDuplicateContacts != null && LoDuplicateContacts.size() > 0)
            {
                // Return empty string. This should be used to display error on the page.           
                CreateContact = false;
            }
        }      
        
        if (CreateContact)
        {   
            //Retrieve Booth and the Account on it
            Oracle_Show_Booth__c Booth = [Select Id, Account__c From Oracle_Show_Booth__c Where Id = :boothContact.Oracle_Show_Booth__c];       
            Contact NewContact = new Contact();
            NewContact.FirstName = boothContact.FIRST_NAME__c;
            NewContact.LastName = boothContact.LAST_NAME__c;
            NewContact.Email = boothContact.EMAIL__c;
            NewContact.Phone = boothContact.PHONE__c;
            NewContact.MobilePhone = boothContact.Mobile__c;  //Amarab 04112023 Added Mobile for Booth Contact
            NewContact.MailingStreet = boothContact.Mailing_Street__c;
            NewContact.MailingCity = boothContact.Mailing_City__c;
            NewContact.MailingState = boothContact.Mailing_State__c;
            NewContact.MailingCountry = boothContact.Mailing_Country__c;
            NewContact.MailingPostalCode = boothContact.Mailing_Postal_Code__c;
            
            if (Booth != null)
                NewContact.AccountId = Booth.Account__c;
            
            Database.insert(NewContact);
            
            ReturnId = NewContact.id;
        }
        
        return ReturnId;
    }
    
    private boolean UpdateContact(Oracle_Show_Booth_Contact__c boothContact, Contact existingContact)
    {
        
        existingContact.FirstName = boothContact.FIRST_NAME__c;
        existingContact.LastName = boothContact.LAST_NAME__c;
        existingContact.Email = boothContact.EMAIL__c;
        existingContact.Phone = boothContact.PHONE__c;
        existingContact.MobilePhone = boothContact.Mobile__c;  //Amarab 04112023 Added Mobile for Booth Contact
        existingContact.MailingStreet = boothContact.Mailing_Street__c;
        existingContact.MailingCity = boothContact.Mailing_City__c;
        existingContact.MailingState = boothContact.Mailing_State__c;
        existingContact.MailingCountry = boothContact.Mailing_Country__c;
        existingContact.MailingPostalCode = boothContact.Mailing_Postal_Code__c;
        
        Database.update(existingContact);
                    
        return true;
    }
    
    private id createBoothContact(Oracle_Show_Booth_Contact__c boothContact, Contact existingContact)
    {       
        boothContact.FIRST_NAME__c = existingContact.FirstName;
        boothContact.LAST_NAME__c = existingContact.LastName;
        boothContact.EMAIL__c = existingContact.Email;
        boothContact.PHONE__c = existingContact.Phone;
        boothContact.Mobile__c = existingContact.MobilePhone;  //Amarab 04112023 Added Mobile for Booth Contact
        boothContact.CONTACT_TYPE__c = 'BOOTH';
        boothContact.CONTACT_ROLE__c = 'SECONDARY';
        boothContact.Mailing_Street__c = existingContact.MailingStreet;
        boothContact.Mailing_City__c = existingContact.MailingCity;
        boothContact.Mailing_State__c = existingContact.MailingState;
        boothContact.Mailing_Country__c = existingContact.MailingCountry;
        boothContact.Mailing_Postal_Code__c = existingContact.MailingPostalCode;
        
        Database.insert(boothContact);
        
        return boothContact.id; 
    }   
    
    public PageReference backToCustomPage()
    {
        PageReference Pr = new PageReference('/apex/PageBoothDetails?id=' + boothContact.Oracle_Show_Booth__c + '&retURL=/apex/PageBooth');
        return Pr;
    }
    
    public PageReference backToStandardDetailPage()
    {
        PageReference Pr = new PageReference('/' + boothContact.Oracle_Show_Booth__c);
        return Pr;
    } 
    
    public String newCase()
    {
        List<Oracle_Show_Booth_Contact__c> LoBCs = [Select Id, Oracle_Show_Booth__c, Contact__c, Contact__r.Name, Oracle_Show_Booth__r.Name, Oracle_Show_Booth__r.Account__r.Id, Oracle_Show_Booth__r.Account__r.Name, Oracle_Show_Booth__r.Show_Occurrence__r.Id, Oracle_Show_Booth__r.Show_Occurrence__r.Name From Oracle_Show_Booth_Contact__c Where Id = :boothContact.Id];
        Oracle_Show_Booth_Contact__c BC = LoBCs[0];

        String AccountId = BC.Oracle_Show_Booth__r.Account__c;
        String AccountName = EncodingUtil.urlEncode(BC.Oracle_Show_Booth__r.Account__r.Name, 'UTF-8');

        String BoothId = BC.Oracle_Show_Booth__c;
        String BoothName = EncodingUtil.urlEncode(BC.Oracle_Show_Booth__r.Name, 'UTF-8');

        String OptyId = BC.Oracle_Show_Booth__r.Show_Occurrence__c;
        String OptyName = EncodingUtil.urlEncode(BC.Oracle_Show_Booth__r.Show_Occurrence__r.Name, 'UTF-8');

        String Url = '/500/e?cas4='+AccountName+'&cas4_lkid='+AccountId+'&CF00NM0000000f6Cf='+BoothName +'&CF00NM0000000f6Cf_lkid='+BoothId+'&CF00NM0000000f6pI='+OptyName+'&CF00NM0000000f6pI_lkid='+OptyId+'&00NM0000000fBkD=Exhibitor'; 
        
        return Url;
        
        //PageReference Pr = new PageReference(Url+'&isdtp=vw&retURL=%2F500%2Fo');
        //return Pr;
    }  
    
    // Added by Sajid on 04/10/23 sfdc-202 **Start code*** 
    public PageReference sendToCore(){
        if(String.isBlank(booth.BOOTH_ID__c) && String.isBlank(booth.SHOW_OCCR_CUST_ID__c))
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Contact cannot be sent to CORE as SHOW_OCCR_CUST_ID__c and CUST_BOOTH_ID__c are Blank')); 
            return null;         
        }
        if(String.isBlank(booth.BOOTH_ID__c))
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Contact cannot be sent to CORE as CUST_BOOTH_ID__c is blank')); 
            return null;         
        }
        if(String.isBlank(booth.SHOW_OCCR_CUST_ID__c))
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Contact cannot be sent to CORE as SHOW_OCCR_CUST_ID__c is blank')); 
            return null;         
        }
        
        try{
            PageReference pr = ExhibitorServiceClient.submitContactToCore(boothContact.Id); 
            return pr;
        }catch(exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You do not have sufficient privileges to perform this operation. Please check with your System Administrator. To go back, press Cancel. For more details, please refer to the detailed error message here- '+e.getMessage()));
            return null;
        }

    }
    // *** End Code   

}