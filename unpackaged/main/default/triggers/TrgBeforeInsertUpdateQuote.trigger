// SFDC-244 : TMS Integration - added after insert, after update events - by Sajid - 08/04/23
// trigger TrgBeforeInsertUpdateQuote on Quote__c (before insert, before update) { 
trigger TrgBeforeInsertUpdateQuote on Quote__c (before insert, before update, after insert, after update) {   
    
    // SFDC-244 : TMS Integration - added TMSIntegrationUser check to bypass trigger for TMS Integration user - by Sajid - 09/27/23
    // if(Userinfo.getProfileID()==Label.MergeSystemAdminId)
    if(Userinfo.getProfileID()==Label.MergeSystemAdminId || UserInfo.getName() == Label.TMSIntegrationUser){
        
        return;
    }
    
    /* SFDC-244 : TMS Integration - added Trigger.isBefore condition to run existing code only for Before events - by Sajid - 08/04/23 */
    if(Trigger.isBefore){
        
        /* 
For quotes where Booth is selected, automatically select the Show and the Account 
based on Booth.     
*/
        //TMS-110 - Updated INBOUND OWNER from quote owner when Inbound stage is not null - 11/09/23 - Sajid
        if (Trigger.isInsert){
            QuoteTriggerHandler.updateInboundOutboundOwner(Trigger.new);
        }
        //END TMS-110
        
        set<Id> SoBoothId = new set<Id>();
        set<Id> SoShowOccurrenceId = new set<Id>();
        map<Id, Id> MoQuoteIdToBoothId = new map<Id, Id>();
        set<Id> SoInOriginationAddressId = new set<Id>();
        set<Id> SoInDestinationAddressId = new set<Id>();
        set<Id> SoInFacilityId = new set<Id>();
        set<Id> SoObOriginationAddressId = new set<Id>();
        set<Id> SoObDestinationAddressId = new set<Id>();
        set<Id> SoObFacilityId = new set<Id>();
        
        set<Id> SoBillingContactId = new set<Id>();
        
        //SFDC-288 - Update the Outbound Stage and Inbound Stage Fields - 03/07/24 - Sajid
        if (Trigger.isUpdate){
            QuoteTriggerHandler.updateInboundOutboundOwner(Trigger.new); //TMS-110 - Updated INBOUND OWNER from quote owner when Inbound stage is not null - 11/09/23 - Sajid
            for(Quote__c qte : Trigger.new){
                Quote__c OldQuote = Trigger.oldMap.get(qte.Id);
                if(qte.Quote_Subject__c != OldQuote.Quote_Subject__c){
                    if(qte.Quote_Subject__c == 'Inbound' || qte.Quote_Subject__c == 'Inbound Canadian'){
                        qte.Outbound_Stage__c = 'Closed Lost';
                        if(qte.Inbound_Stage__c == 'Closed Lost'){
                            qte.Inbound_Stage__c = null;
                        }
                    }
                    if(qte.Quote_Subject__c == 'Outbound' || qte.Quote_Subject__c == 'Outbound Canadian'){
                        qte.Inbound_Stage__c = 'Closed Lost';
                        if(qte.Outbound_Stage__c == 'Closed Lost'){
                            qte.Outbound_Stage__c = null;
                        }
                    }
                    if(qte.Quote_Subject__c != 'Inbound' && qte.Quote_Subject__c != 'Outbound' && qte.Quote_Subject__c != 'Inbound Canadian' && qte.Quote_Subject__c != 'Outbound Canadian'){
                        if(qte.Inbound_Stage__c == 'Closed Lost'){
                            qte.Inbound_Stage__c = null;
                        }
                        if(qte.Outbound_Stage__c == 'Closed Lost'){
                            qte.Outbound_Stage__c = null;
                        }
                    }
                }
            }            
        }
        //End - SFDC-288
        
        for(Quote__c qte : Trigger.new)
        {
            if (qte.Booth__c != null)
            {
                SoBoothId.add(qte.Booth__c);
                MoQuoteIdToBoothId.put(qte.Id, qte.Booth__c);
            }
            
            if (qte.Show_Occurrence__c != null)
            {
                SoShowOccurrenceId.add(qte.Show_Occurrence__c);
            }
            
            if (qte.Billing_Contact__c != null)
                SoBillingContactId.add(qte.Billing_Contact__c);
            
            if (qte.Origination_Shipping_Address__c != null)
                SoInOriginationAddressId.add(qte.Origination_Shipping_Address__c);
            
            if (qte.Destination_Shipping_Address__c != null)
                SoInDestinationAddressId.add(qte.Destination_Shipping_Address__c);
            
            if (qte.Facility__c != null)
                SoInFacilityId.add(qte.Facility__c);
            
            if (qte.OB_Origination_Shipping_Address__c != null)
                SoObOriginationAddressId.add(qte.OB_Origination_Shipping_Address__c);
            
            if (qte.OB_Destination_Shipping_Address__c != null)
                SoObDestinationAddressId.add(qte.OB_Destination_Shipping_Address__c);
            
            if (qte.OB_Facility__c != null)
                SoObFacilityId.add(qte.OB_Facility__c);
            
        }
        
        List<Oracle_Show_Booth__c> LoBooths = [Select Id, Show_Occurrence__c, Account__c, Show_Occurrence__r.Name, BOOTH_NUMBER__c From Oracle_Show_Booth__c Where Id In :SoBoothId];
        
        map<Id, Oracle_Show_Booth__c> MoBoothIdToBooth = new map<Id, Oracle_Show_Booth__c>();
        map<Id, Id> MoBoothIdToShowOccurrenceId = new map<Id, Id>();
        map<Id, Id> MoBoothIdToAccountId = new map<Id, Id>();
        map<Id, String> MoBoothIdToShowOccurrenceName = new map<Id, String>();
        
        if (LoBooths !=  null)
        {
            for(Oracle_Show_Booth__c booth : LoBooths)
            {
                MoBoothIdToShowOccurrenceId.put(booth.Id, booth.Show_Occurrence__c);
                MoBoothIdToAccountId.put(booth.Id, booth.Account__c);
                
                if (!MoBoothIdToBooth.containsKey(booth.Id))
                    MoBoothIdToBooth.put(booth.Id, booth);
                
                if (booth.Show_Occurrence__c != null)
                {
                    SoShowOccurrenceId.add(booth.Show_Occurrence__c);
                    MoBoothIdToShowOccurrenceName.put(booth.Id, booth.Show_Occurrence__r.Name);
                }
            }
        }
        
        List<Opportunity> LoOppportunities = [Select Id, Name, Facility__c From Opportunity Where Id In :SoShowOccurrenceId];
        
        map<Id, String> MoOpptyIdToName = new map<Id, String>();
        map<Id, Opportunity> MoOpptyIdToOppty = new map<Id, Opportunity>();
        set<Id> SoOptyFacilityIds = new set<Id>();
        
        if (LoOppportunities != null)
        {
            for (Opportunity opty : LoOppportunities)
            {
                MoOpptyIdToName.put(opty.Id, opty.Name);
                MoOpptyIdToOppty.put(opty.Id, opty);
                
                //Also build the set of Facility Ids, if it is not null on the Opportunity
                //Facility needs to be defaulted, if available
                if (opty.Facility__c != null)
                    SoOptyFacilityIds.add(opty.Facility__c);
            }
        }
        
        //Also, create a set of Accounts, based on which a map of Accounts to QuoteId could
        //be created. This map in turn can be used to populate/default inbound pickup address
        set<Id> SoAccountId = new set<Id>();
        
        for(Quote__c qte : Trigger.new)
        {
            id AccountId = qte.Account_Id__c;
            
            if (qte.Booth__c != null)
                AccountId =  MoBoothIdToAccountId.get(qte.Booth__c);     
            
            if (AccountId != null)
                SoAccountId.add(AccountId);
        }
        
        // Create a map of Accounts, so account address can be pulled and populated on quote
        // for inbound pickup shipment address
        map<Id, Account> MoAccountIdToAccount = new map<Id, Account>();     
        List<Account> LoAccounts = [Select Id, Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry From Account Where Id In :SoAccountId];    
        
        for(Account acnt : LoAccounts)
            MoAccountIdToAccount.put(acnt.Id, acnt);
        
        // Retrieve all billing contacts
        //List<Contact> LoBillingContacts = [Select Id, Name, Phone, Fax From Contact Where Id In :SoBillingContactId];  //AMARAB 2/2/2024 to add emails
        List<Contact> LoBillingContacts = [Select Id, Name, Phone, Fax, Email From Contact Where Id In :SoBillingContactId];
        map<Id, Contact> MoBillingContactIdToContact = new map<Id, Contact>();
        
        for (Contact c : LoBillingContacts)
            MoBillingContactIdToContact.put(c.Id, c);
        
        /* START - QUERY AND CREATE MAP OF INBOUND and OUTBOUND SHIPPING ADDRESSES */
        
        Set<Id> SoAllShippingAddressIds = new Set<Id>();
        
        for(Id shipAddrId : SoInOriginationAddressId)
            SoAllShippingAddressIds.add(shipAddrId);
        
        for(Id shipAddrId : SoInDestinationAddressId)
            SoAllShippingAddressIds.add(shipAddrId);
        
        for(Id shipAddrId : SoObOriginationAddressId)
            SoAllShippingAddressIds.add(shipAddrId);
        
        for(Id shipAddrId : SoObDestinationAddressId)
            SoAllShippingAddressIds.add(shipAddrId);
        
        List<Shipping_Address__c> LoShippingAddresses = [Select Id, Name, Address_1__c, City__c, State__c, Country__c, Postal_Code__c From Shipping_Address__c Where Id In :SoAllShippingAddressIds];
        Map<Id, Shipping_Address__c> MoShipAddressIdToShipAddress = new Map<Id, Shipping_Address__c>();
        
        for(Shipping_Address__c addr: LoShippingAddresses)
            MoShipAddressIdToShipAddress.put(addr.Id, addr);
        
        /* END - QUERY AND CREATE MAP OF INBOUND and OUTBOUND ADDRESSES */
        
        /* START - QUERY AND CREATE MAP OF INBOUND and OUTBOUND FACILITIES */    
        
        Set<Id> SoAllFacilityIds = new Set<Id>();
        
        for(Id facId : SoInFacilityId)
            SoAllFacilityIds.add(facId);
        
        for(Id facId : SoObFacilityId)
            SoAllFacilityIds.add(facId);
        
        for(Id facId : SoOptyFacilityIds)
            SoAllFacilityIds.add(facId);
        
        List<Account> LoFacilities = [Select Id, Name, BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode, ShippingStreet, ShippingCity, ShippingState, ShippingCountry, ShippingPostalCode From Account Where RecordType.Name = 'Facility' And Id In :SoAllFacilityIds];
        Map<Id, Account> MoFacilityIdToFacility = new Map<Id, Account>();
        
        for(Account fac : LoFacilities)
            MoFacilityIdToFacility.put(fac.Id, fac);
        
        /* END - QUERY AND CREATE MAP OF INBOUND and OUTBOUND FACILITIES */
        
        RecordType LogisticsDomesticRT = [Select Id, Name From RecordType Where Name = 'Logistics Domestic']; //'012V00000004KgUIAU'
        RecordType LogisticsCanadaRT = [Select Id, Name From RecordType Where Name = 'Logistics Canada']; //'012V00000004KgUIAU'
        
        for(Quote__c qte : Trigger.new)
        {   
            // If Inbound Shipment Type is changed, blank out Class of Service, Service Type and Ship To Location
            if (qte.Shipment_Type__c == null)
            {
                qte.Class_of_Service__c = null;
                qte.Service_Type__c = null;
            }
            
            // If Outbound Shipment Type is changed, blank out Class of Service, Service Type and Ship To Location
            if (qte.OB_Shipment_Type__c == null)
            {
                qte.OB_Class_of_Service__c = null;
                qte.OB_Service_Type__c = null;
            }   
            
            //*************************************        
            //* START: RECORD TYPE SPECIFIC RULES *
            //*************************************
            //Uncomment this if block if rules are different for Domestic and International
            //if (qte.RecordTypeId == LogisticsDomesticRT.Id || qte.RecordTypeId == LogisticsCanada.Id)
            //{
            
            if (qte.Pickup_Window_Start__c != null && qte.Pickup_Window_Start__c != 'None') 
            {
                Integer PickupWindowStartTime = Integer.valueOf(qte.Pickup_Window_Start__c.split(':')[0]);
                
                if (PickupWindowStartTime > 14 && (qte.Pickup_Window_Start_Late__c == null || qte.Pickup_Window_Start_Late__c == false))
                    qte.Pickup_Window_Start__c.addError('Pickup Start Time is after 14:00 hours. Please confirm.');
            }
            
            if (qte.OB_Pickup_Window_Start__c != null && qte.OB_Pickup_Window_Start__c != 'None') 
            {
                Integer OBPickupWindowStartTime = Integer.valueOf(qte.OB_Pickup_Window_Start__c.split(':')[0]);
                
                if (OBPickupWindowStartTime > 14 && (qte.OB_Pickup_Window_Start_Late__c == null || qte.OB_Pickup_Window_Start_Late__c == false))
                    qte.OB_Pickup_Window_Start__c.addError('Pickup Start Time is after 14:00 hours. Please confirm.');
            } 
            
            if (qte.EDV_Amount__c != null && qte.EDV_Amount__c > 20000) 
            {
                
                if (qte.EDV_Amount_Exceeds_Limit__c == null || qte.EDV_Amount_Exceeds_Limit__c == false)
                    qte.EDV_Amount_Exceeds_Limit__c.addError('Please confirm EDV Amount > 20,000.');
            } 
            
            if (qte.Booth__c != null)
            {
                qte.Show_Occurrence__c =  MoBoothIdToShowOccurrenceId.get(qte.Booth__c);
                qte.Account_Id__c =  MoBoothIdToAccountId.get(qte.Booth__c);
            } 
            
            if (qte.Sales_Rep__c == null)
                qte.Sales_Rep__c = qte.OwnerId;
            
            //Populate Job Code, if Show is selected
            if (qte.Show_Occurrence__c != null)
            {
                String OppName = MoBoothIdToShowOccurrenceName.get(qte.Booth__c);
                
                if (OppName != null && OppName != '')
                {
                    integer IdxOfDash = OppName.indexOf('-');
                    
                    if (IdxOfDash > 0)
                        qte.Job_Code__c = OppName.subString(0,IdxOfDash);
                    else
                        qte.Job_Code__c = null;
                }
                // Since, the Show_Occurrence__c on Quote is being set above (based on Booth__c),
                // Or if user selected Show_Occurrence__c in the UI, OppName will not be resolved
                // to a non-blank value, if Booth is not selected. Hence, the else portion is
                // required.
                else
                {
                    OppName = MoOpptyIdToName.get(qte.Show_Occurrence__c);
                    
                    if (OppName != null && OppName != '')
                    {
                        integer IdxOfDash = OppName.indexOf('-');
                        
                        if (IdxOfDash > 0)
                            qte.Job_Code__c = OppName.subString(0,IdxOfDash);
                        else
                            qte.Job_Code__c = null;
                    }
                    else
                        qte.Job_Code__c = null;
                }
                
            }
            else
                qte.Job_Code__c = null;
            
            /* START - SET CONTACT NAME AND PHONE ON INBOUND AND OUTBOUND */
            
            if (qte.Billing_Contact__c != null)
            {
                // If a Billing Contact is selected, then check if this contact is 
                // different from the contact selected before the update; if so, 
                // then overwrite the values in the Inbound and Outbound Contact
                // and phone number fields.
                // Also, if the OldQuote does not exist (i.e if it is an insert)
                // default the values.
                
                boolean SetContactInfoFlag = false;
                
                if (Trigger.isUpdate)
                {
                    Quote__c OldQuote = Trigger.oldMap.get(qte.Id);
                    
                    if (OldQuote != null)
                    {
                        if (OldQuote.Billing_Contact__c != qte.Billing_Contact__c)
                        {
                            SetContactInfoFlag = true;
                        }
                    }
                }
                else //Is Insert
                    SetContactInfoFlag = true;
                
                if (SetContactInfoFlag)
                {
                    Contact BillingContact = MoBillingContactIdToContact.get(qte.Billing_Contact__c);
                    
                    if (BillingContact != null)
                    {
                        qte.Pickup_Contact_Name__c = BillingContact.Name;
                        qte.Pickup_Contact_Phone__c = BillingContact.Phone;
                        qte.Pickup_Contact_Fax__c = BillingContact.Fax;
                        qte.Delivery_Contact_Name__c = BillingContact.Name;
                        qte.Delivery_Contact_Phone__c = BillingContact.Phone;
                        qte.Delivery_Contact_Fax__c = BillingContact.Fax;
                        qte.OB_Pickup_Contact_Name__c = BillingContact.Name;
                        qte.OB_Pickup_Contact_Phone__c = BillingContact.Phone;
                        qte.OB_Delivery_Contact_Name__c = BillingContact.Name;
                        qte.OB_Delivery_Contact_Phone__c = BillingContact.Phone;  
                        //AMARAB 2/2/2024 to add emails
                        qte.Pickup_Contact_Email__c = BillingContact.Email;
                        qte.Delivery_Contact_Email__c = BillingContact.Email;
                        qte.OB_Pickup_Contact_Email__c = BillingContact.Email;
                        qte.OB_Delivery_Contact_Email__c = BillingContact.Email;        
                    }
                }
            }
            
            /* END - SET CONTACT NAME AND PHONE ON INBOUND AND OUTBOUND */
            
            /* START - SET BOOTH # ON INBOUND AND OUTBOUND */
            
            if (qte.Booth__c != null)
            {
                // If a Billing Contact is selected, then check if this contact is 
                // different from the contact selected before the update; if so, 
                // then overwrite the values in the Inbound and Outbound Contact
                // and phone number fields.
                // Also, if the OldQuote does not exist (i.e if it is an insert)
                // default the values.
                
                boolean SetBoothNumberFlag = false;
                
                if (Trigger.isUpdate)
                {
                    Quote__c OldQuote = Trigger.oldMap.get(qte.Id);
                    
                    if (OldQuote != null)
                    {
                        if (qte.Booth__c != null) //User changed Booth to a not null value, i.e. selected a booth
                        {
                            if ((OldQuote.Booth__c != null && OldQuote.Booth__c != qte.Booth__c) || OldQuote.Booth__c == null)
                                SetBoothNumberFlag = true;
                        }
                        else // If qte.Booth__c Is null user changed Booth to a null value or did not change this field
                        {
                            if (OldQuote.Booth__c != null)
                                SetBoothNumberFlag = true;  //User blanked out Booth        
                        }
                    }
                }
                else //Is Insert
                {
                    if (qte.Booth__c != null)
                        SetBoothNumberFlag = true;
                }
                
                // "SetBoothNumberFlag" flag is true:
                // On Insert, if user has selected a Booth
                // On Update, if user changed Booth from either a null value or a not null value to a not null value
                // On Update, if user changed Booth from a not null value to a null value       
                
                if (SetBoothNumberFlag)
                {
                    Oracle_Show_Booth__c Booth;
                    
                    if (qte.Booth__c != null)
                        Booth = MoBoothIdToBooth.get(qte.Booth__c);
                    
                    if (Booth != null)
                    {
                        qte.Delivery_Booth_No__c = Booth.BOOTH_NUMBER__c;
                        qte.OB_Pickup_Booth_No__c = Booth.BOOTH_NUMBER__c;        
                    }
                }
            }
            
            /* END - SET BOOTH # ON INBOUND AND OUTBOUND */      
            
            /* START - SET INBOUND ADDRESSES */
            
            if (qte.Origination_Shipping_Address__c != null)
            {
                Shipping_Address__c InOrigShipAddr = MoShipAddressIdToShipAddress.get(qte.Origination_Shipping_Address__c);
                
                if (InOrigShipAddr != null)
                {
                    qte.Origination_Street__c = InOrigShipAddr.Address_1__c;
                    qte.Origination_City__c = InOrigShipAddr.City__c;
                    qte.Origination_State__c = InOrigShipAddr.State__c;
                    qte.Origination_Country__c = InOrigShipAddr.Country__c;
                    qte.Origination_Postal_Code__c = InOrigShipAddr.Postal_Code__c;
                }          
            }
            
            if (qte.Facility__c != null && qte.Destination_Shipping_Address__c != null)
            {
                qte.Facility__c.addError('Facility (Lookup) and Destination Address (Lookup) both cannot be selected at the same time. Please select only one.');
            }
            else if(qte.Facility__c != null)
            {
                Account InFacility = MoFacilityIdToFacility.get(qte.Facility__c);
                
                if (InFacility != null)
                {
                    qte.Destination_Street__c = InFacility.BillingStreet;
                    qte.Destination_City__c = InFacility.BillingCity;
                    qte.Destination_State__c = InFacility.BillingState;
                    qte.Destination_Country__c = InFacility.BillingCountry;
                    qte.Destination_Postal_Code__c = InFacility.BillingPostalCode;
                }
                else
                {
                    qte.Facility__c.addError('Please select a \'Facility\' type account.');
                }
            }
            else if (qte.Destination_Shipping_Address__c != null)
            {
                Shipping_Address__c InDestShipAddr = MoShipAddressIdToShipAddress.get(qte.Destination_Shipping_Address__c);
                
                if (InDestShipAddr != null)
                {
                    qte.Destination_Street__c = InDestShipAddr.Address_1__c;
                    qte.Destination_City__c = InDestShipAddr.City__c;
                    qte.Destination_State__c = InDestShipAddr.State__c;
                    qte.Destination_Country__c = InDestShipAddr.Country__c;
                    qte.Destination_Postal_Code__c = InDestShipAddr.Postal_Code__c;
                }          
            }
            
            /* END - SET INBOUND ADDRESSES */
            
            /* START - SET OUTBOUND ADDRESSES */
            
            if (qte.OB_Facility__c != null && qte.OB_Origination_Shipping_Address__c != null 
                && (qte.Copy_To_OB_Pickup_Address__c == null || qte.Copy_To_OB_Pickup_Address__c == false))
            {
                qte.OB_Facility__c.addError('Facility (Lookup) and Pickup Address (Lookup) both cannot be selected at the same time. Please select only one.');
            }
            else if(qte.OB_Facility__c != null)
            {
                Account ObFacility = MoFacilityIdToFacility.get(qte.OB_Facility__c);
                
                if (ObFacility != null)
                {
                    qte.OB_Origination_Street__c = ObFacility.BillingStreet;
                    qte.OB_Origination_City__c = ObFacility.BillingCity;
                    qte.OB_Origination_State__c = ObFacility.BillingState;
                    qte.OB_Origination_Country__c = ObFacility.BillingCountry;
                    qte.OB_Origination_Postal_Code__c = ObFacility.BillingPostalCode;
                }
                else
                {
                    qte.OB_Facility__c.addError('Please select a \'Facility\' type account.');
                }
            }
            else if (qte.OB_Origination_Shipping_Address__c != null)
            {
                Shipping_Address__c ObOrigShipAddr = MoShipAddressIdToShipAddress.get(qte.OB_Origination_Shipping_Address__c);
                
                if (ObOrigShipAddr != null)
                {
                    qte.OB_Origination_Street__c = ObOrigShipAddr.Address_1__c;
                    qte.OB_Origination_City__c = ObOrigShipAddr.City__c;
                    qte.OB_Origination_State__c = ObOrigShipAddr.State__c;
                    qte.OB_Origination_Country__c = ObOrigShipAddr.Country__c;
                    qte.OB_Origination_Postal_Code__c = ObOrigShipAddr.Postal_Code__c;
                }        
            }
            
            //This needs to be set first, before the code to override the OB Destination
            //address with IB Destination address, if the Copy flag is checked.
            if (qte.OB_Destination_Shipping_Address__c != null)
            {
                Shipping_Address__c ObDestShipAddr = MoShipAddressIdToShipAddress.get(qte.OB_Destination_Shipping_Address__c);
                
                if (ObDestShipAddr != null)
                {
                    qte.OB_Destination_Street__c = ObDestShipAddr.Address_1__c;
                    qte.OB_Destination_City__c = ObDestShipAddr.City__c;
                    qte.OB_Destination_State__c = ObDestShipAddr.State__c;
                    qte.OB_Destination_Country__c = ObDestShipAddr.Country__c;
                    qte.OB_Destination_Postal_Code__c = ObDestShipAddr.Postal_Code__c;
                }          
            }        
            
            /* END - SET OUTBOUND ADDRESSES */
            
            /* START - COPY ADDRESSES TO OUTBOUND */
            
            if (qte.Copy_To_OB_Destination_Address__c != null && qte.Copy_To_OB_Destination_Address__c)
            {
                qte.OB_Destination_Shipping_Address__c = qte.Origination_Shipping_Address__c;
                qte.OB_Destination_Street__c = qte.Origination_Street__c;
                qte.OB_Destination_City__c = qte.Origination_City__c;
                qte.OB_Destination_State__c = qte.Origination_State__c;
                qte.OB_Destination_Country__c = qte.Origination_Country__c;
                qte.OB_Destination_Postal_Code__c = qte.Origination_Postal_Code__c;
                //Reset copy flag
                qte.Copy_To_OB_Destination_Address__c = false;
            }
            
            if (qte.Copy_To_OB_Pickup_Address__c != null && qte.Copy_To_OB_Pickup_Address__c)
            {
                if (qte.Facility__c != null)
                {
                    qte.OB_Facility__c = qte.Facility__c;
                    qte.OB_Origination_Shipping_Address__c = null;
                }
                else if (qte.Destination_Shipping_Address__c != null)
                {
                    qte.OB_Origination_Shipping_Address__c = qte.Destination_Shipping_Address__c;
                    qte.OB_Facility__c = null;
                }
                
                qte.OB_Origination_Street__c = qte.Destination_Street__c;
                qte.OB_Origination_City__c = qte.Destination_City__c;
                qte.OB_Origination_State__c = qte.Destination_State__c;
                qte.OB_Origination_Country__c = qte.Destination_Country__c;
                qte.OB_Origination_Postal_Code__c = qte.Destination_Postal_Code__c;
                //Reset copy flag
                qte.Copy_To_OB_Pickup_Address__c = false;        
            }      
            
            /* END - COPY ADDRESSES TO OUTBOUND */
            
            if (Trigger.isUpdate)
            {
                Quote__c OldQuote = Trigger.oldMap.get(qte.Id);
                
                if ((OldQuote.Stage__c == 'Pending Carrier Quote' ||
                     OldQuote.Stage__c == 'Pending Traffic Quote' ||
                     OldQuote.Stage__c == 'Re-Book' ||
                     OldQuote.Stage__c == 'Sent Traffic Quote') &&
                    qte.Stage__c == 'Qualification')
                {
                    qte.OwnerId = qte.Sales_Rep__c;
                }
                
                //Also, check changes to those fields which should cause re-rate and update
                //the "Message" field on the Quote accordingly
                /* START ALERT MESSAGES */
                String Message = '';
                
                if (OldQuote.Quote_Subject__c != qte.Quote_Subject__c)
                    Message = 'Quote subject changed from \'' + OldQuote.Quote_Subject__c + '\' to \'' + qte.Quote_Subject__c + '\'\n';
                
                String OldWeightOverride = (OldQuote.Weight_Override__c == null ? '' : OldQuote.Weight_Override__c.setScale(2).toPlainString());
                String WeightOverride = (qte.Weight_Override__c == null ? '' : qte.Weight_Override__c.setScale(2).toPlainString());
                
                if (OldWeightOverride != WeightOverride)      
                    Message += 'Quick quote weight changed from \'' + OldWeightOverride + '\' to \'' + WeightOverride + '\'\n';
                
                String OldCratedWeight = (OldQuote.Crated_Weight__c == null ? '' : OldQuote.Crated_Weight__c.setScale(2).toPlainString());
                String CratedWeight = (qte.Crated_Weight__c == null ? '' : qte.Crated_Weight__c.setScale(2).toPlainString());
                
                if (OldCratedWeight != CratedWeight)
                    Message += 'Crated weight changed from \'' + OldCratedWeight + '\' to \'' + CratedWeight + '\'\n';
                
                String OldDimWeight = (OldQuote.Dim_Weight__c == null ? '' : OldQuote.Dim_Weight__c.setScale(2).toPlainString());
                String DimWeight = (qte.Dim_Weight__c == null ? '' : qte.Dim_Weight__c.setScale(2).toPlainString());
                
                if (OldDimWeight != DimWeight)
                    Message += 'Dim weight changed from \'' + OldDimWeight + '\' to \'' + DimWeight + '\'\n';
                
                if (OldQuote.EDV_Amount__c != qte.EDV_Amount__c)
                    Message += 'EDV amount changed from \'' + OldQuote.EDV_Amount__c + '\' to \'' + qte.EDV_Amount__c + '\'\n';           
                
                //INBOUND OR ROUNDTRIP
                if (qte.Quote_Subject__c.toUpperCase() == 'INBOUND' || qte.Quote_Subject__c.toUpperCase() == 'ROUNDTRIP')           
                {
                    if (OldQuote.Pickup_Date__c != qte.Pickup_Date__c)      
                        Message += 'Inbound Pickup Date changed from \'' + (OldQuote.Pickup_Date__c != null ? OldQuote.Pickup_Date__c.format() : '') + ' to \'' + (qte.Pickup_Date__c != null ? qte.Pickup_Date__c.format() : '') + '\'\n';
                    
                    if (OldQuote.Delivery_Date__c != qte.Delivery_Date__c)        
                        Message += 'Inbound Delivery Date changed from \'' + (OldQuote.Delivery_Date__c != null ? OldQuote.Delivery_Date__c.format() : '') + ' to \'' + (qte.Delivery_Date__c != null ? qte.Delivery_Date__c.format() : '') + '\'\n';
                    
                    if (OldQuote.Origination_State__c != qte.Origination_State__c)
                        Message += 'Inbound Origination State changed from \'' + OldQuote.Origination_State__c + ' to \'' + qte.Origination_State__c + '\'\n';            
                    
                    if (OldQuote.Destination_State__c != qte.Destination_State__c)        
                        Message += 'Inbound Origination State changed from \'' + OldQuote.Destination_State__c + ' to \'' + qte.Destination_State__c + '\'\n';
                    
                    if (OldQuote.Additional_Labor__c != qte.Additional_Labor__c)
                        Message +=   'Inbound Accessorial \'Additional Labor\' changed from \'' + OldQuote.Additional_Labor__c + ' to \'' + qte.Additional_Labor__c + '\'\n';
                    
                    if (OldQuote.Attempt__c != qte.Attempt__c)
                        Message +=   'Inbound Accessorial \'Attempt\' changed from \'' + OldQuote.Attempt__c + ' to \'' + qte.Attempt__c + '\'\n';
                    
                    if (OldQuote.AM_Specified__c != qte.AM_Specified__c)
                        Message +=   'Inbound Accessorial \'AM Specified\' changed from \'' + OldQuote.AM_Specified__c + ' to \'' + qte.AM_Specified__c + '\'\n';
                    
                    if (OldQuote.Call_Before_Pickup__c != qte.Call_Before_Pickup__c)
                        Message +=   'Inbound Accessorial \'Call Before Pickup\' changed from \'' + OldQuote.Call_Before_Pickup__c + ' to \'' + qte.Call_Before_Pickup__c + '\'\n';
                    
                    if (OldQuote.Call_Before_Delivery__c != qte.Call_Before_Delivery__c)
                        Message +=   'Inbound Accessorial \'Call Before Delivery\' changed from \'' + OldQuote.Call_Before_Delivery__c + ' to \'' + qte.Call_Before_Delivery__c + '\'\n';
                    
                    if (OldQuote.Lift_Gate__c != qte.Lift_Gate__c)
                        Message +=   'Inbound Accessorial \'Lift Gate\' changed from \'' + OldQuote.Lift_Gate__c + ' to \'' + qte.Lift_Gate__c + '\'\n';
                    
                    if (OldQuote.Hazardous_Materials__c != qte.Hazardous_Materials__c)
                        Message +=   'Inbound Accessorial \'Hazardous Materials\' changed from \'' + OldQuote.Hazardous_Materials__c + ' to \'' + qte.Hazardous_Materials__c + '\'\n';
                    
                    if (OldQuote.Pallet_Jack__c != qte.Pallet_Jack__c)
                        Message +=   'Inbound Accessorial \'Pallet Jack\' changed from \'' + OldQuote.Pallet_Jack__c + ' to \'' + qte.Pallet_Jack__c + '\'\n';
                    
                    if (OldQuote.Palletization__c != qte.Palletization__c)
                        Message +=   'Inbound Accessorial \'Palletization\' changed from \'' + OldQuote.Palletization__c + ' to \'' + qte.Palletization__c + '\'\n';
                    
                    if (OldQuote.Inside_Pickup__c != qte.Inside_Pickup__c)
                        Message +=   'Inbound Accessorial \'Inside Pickup\' changed from \'' + OldQuote.Inside_Pickup__c + ' to \'' + qte.Inside_Pickup__c + '\'\n';
                    
                    if (OldQuote.Residential_Pickup__c != qte.Residential_Pickup__c)
                        Message +=   'Inbound Accessorial \'Residential Pickup\' changed from \'' + OldQuote.Residential_Pickup__c + ' to \'' + qte.Residential_Pickup__c + '\'\n';
                    
                    if (OldQuote.Wait_Time__c != qte.Wait_Time__c)
                        Message +=   'Inbound Accessorial \'Wait Time\' changed from \'' + OldQuote.Wait_Time__c + ' to \'' + qte.Wait_Time__c + '\'\n';
                    
                    if (OldQuote.Weekend_Pickup__c != qte.Weekend_Pickup__c)
                        Message +=   'Inbound Accessorial \'Weekend Pickup\' changed from \'' + OldQuote.Weekend_Pickup__c + ' to \'' + qte.Weekend_Pickup__c + '\'\n';
                    
                    if (OldQuote.Weekend_Delivery__c != qte.Weekend_Delivery__c)
                        Message +=   'Inbound Accessorial \'Weekend Delivery\' changed from \'' + OldQuote.Weekend_Delivery__c + ' to \'' + qte.Weekend_Delivery__c + '\'\n';
                    
                    //SFDC-280
                    if (OldQuote.NY_City__c != qte.NY_City__c)
                        Message +=   'Inbound NY City changed from \'' + OldQuote.NY_City__c + ' to \'' + qte.NY_City__c + '\'\n';
                    
                    if (OldQuote.IN_New_York_City_Fee__c != qte.IN_New_York_City_Fee__c)
                        Message += 'IN New York City Fee changed from \'' + OldQuote.IN_New_York_City_Fee__c + ' to \'' + qte.IN_New_York_City_Fee__c + '\'\n';
                    
                    if (OldQuote.Beyond_Point__c != qte.Beyond_Point__c && (OldQuote.Beyond_Point__c == null || qte.Beyond_Point__c == null))
                        Message += 'Inbound Beyond Point changed from \'' + OldQuote.Beyond_Point__c + ' to \'' + qte.Beyond_Point__c + '\'\n';
                    
                    if (OldQuote.IN_Beyond_Point_Fee__c != qte.IN_Beyond_Point_Fee__c)
                        Message += 'IN Beyond Point Fee changed from \'' + OldQuote.IN_Beyond_Point_Fee__c + ' to \'' + qte.IN_Beyond_Point_Fee__c + '\'\n';
                    
                    //End - SFDC-280
                }
                
                //OUTBOUND OR ROUNDTRIP
                if (qte.Quote_Subject__c.toUpperCase() == 'OUTBOUND' || qte.Quote_Subject__c.toUpperCase() == 'ROUNDTRIP')           
                {
                    if (OldQuote.OB_Pickup_Date__c != qte.OB_Pickup_Date__c)      
                        Message += 'Outbound Pickup Date changed from \'' + (OldQuote.OB_Pickup_Date__c != null ? OldQuote.OB_Pickup_Date__c.format() : '') + ' to \'' + (qte.OB_Pickup_Date__c != null ? qte.OB_Pickup_Date__c.format() : '') + '\'\n';
                    
                    if (OldQuote.OB_Delivery_Date__c != qte.OB_Delivery_Date__c)        
                        Message += 'Outbound Delivery Date changed from \'' + (OldQuote.OB_Delivery_Date__c != null ? OldQuote.OB_Delivery_Date__c.format() : '') + ' to \'' + (qte.OB_Delivery_Date__c != null ? qte.OB_Delivery_Date__c.format() : '') + '\'\n';
                    
                    if (OldQuote.OB_Origination_State__c != qte.OB_Origination_State__c)
                        Message += 'Outbound Origination State changed from \'' + OldQuote.OB_Origination_State__c + ' to \'' + qte.OB_Origination_State__c + '\'\n';            
                    
                    if (OldQuote.OB_Destination_State__c != qte.OB_Destination_State__c)        
                        Message += 'Outbound Origination State changed from \'' + OldQuote.OB_Destination_State__c + ' to \'' + qte.OB_Destination_State__c + '\'\n';
                    
                    if (OldQuote.OB_Additional_Labor__c != qte.OB_Additional_Labor__c)
                        Message +=   'Outbound Accessorial \'Additional Labor\' changed from \'' + OldQuote.OB_Additional_Labor__c + ' to \'' + qte.OB_Additional_Labor__c + '\'\n';
                    
                    if (OldQuote.OB_Attempt__c != qte.OB_Attempt__c)
                        Message +=   'Outbound Accessorial \'Attempt\' changed from \'' + OldQuote.OB_Attempt__c + ' to \'' + qte.OB_Attempt__c + '\'\n';
                    
                    if (OldQuote.OB_AM_Specified__c != qte.OB_AM_Specified__c)
                        Message +=   'Outbound Accessorial \'AM Specified\' changed from \'' + OldQuote.OB_AM_Specified__c + ' to \'' + qte.OB_AM_Specified__c + '\'\n';
                    
                    if (OldQuote.OB_Call_Before_Pickup__c != qte.OB_Call_Before_Pickup__c)
                        Message +=   'Outbound Accessorial \'Call Before Pickup\' changed from \'' + OldQuote.OB_Call_Before_Pickup__c + ' to \'' + qte.OB_Call_Before_Pickup__c + '\'\n';
                    
                    if (OldQuote.OB_Call_Before_Delivery__c != qte.OB_Call_Before_Delivery__c)
                        Message +=   'Outbound Accessorial \'Call Before Delivery\' changed from \'' + OldQuote.OB_Call_Before_Delivery__c + ' to \'' + qte.OB_Call_Before_Delivery__c + '\'\n';
                    
                    if (OldQuote.OB_Lift_Gate__c != qte.OB_Lift_Gate__c)
                        Message +=   'Outbound Accessorial \'Lift Gate\' changed from \'' + OldQuote.OB_Lift_Gate__c + ' to \'' + qte.OB_Lift_Gate__c + '\'\n';
                    
                    if (OldQuote.OB_Hazardous_Materials__c != qte.OB_Hazardous_Materials__c)
                        Message +=   'Outbound Accessorial \'Hazardous Materials\' changed from \'' + OldQuote.OB_Hazardous_Materials__c + ' to \'' + qte.OB_Hazardous_Materials__c + '\'\n';
                    
                    if (OldQuote.OB_Pallet_Jack__c != qte.OB_Pallet_Jack__c)
                        Message +=   'Outbound Accessorial \'Pallet Jack\' changed from \'' + OldQuote.OB_Pallet_Jack__c + ' to \'' + qte.OB_Pallet_Jack__c + '\'\n';
                    
                    if (OldQuote.OB_Palletization__c != qte.OB_Palletization__c)
                        Message +=   'Outbound Accessorial \'Palletization\' changed from \'' + OldQuote.OB_Palletization__c + ' to \'' + qte.OB_Palletization__c + '\'\n';
                    
                    if (OldQuote.OB_Inside_Pickup__c != qte.OB_Inside_Pickup__c)
                        Message +=   'Outbound Accessorial \'Inside Pickup\' changed from \'' + OldQuote.OB_Inside_Pickup__c + ' to \'' + qte.OB_Inside_Pickup__c + '\'\n';
                    
                    if (OldQuote.OB_Residential_Pickup__c != qte.OB_Residential_Pickup__c)
                        Message +=   'Outbound Accessorial \'Residential Pickup\' changed from \'' + OldQuote.OB_Residential_Pickup__c + ' to \'' + qte.OB_Residential_Pickup__c + '\'\n';
                    
                    if (OldQuote.OB_Wait_Time__c != qte.OB_Wait_Time__c)
                        Message +=   'Outbound Accessorial \'Wait Time\' changed from \'' + OldQuote.OB_Wait_Time__c + ' to \'' + qte.OB_Wait_Time__c + '\'\n';
                    
                    if (OldQuote.OB_Weekend_Pickup__c != qte.OB_Weekend_Pickup__c)
                        Message +=   'Outbound Accessorial \'Weekend Pickup\' changed from \'' + OldQuote.OB_Weekend_Pickup__c + ' to \'' + qte.OB_Weekend_Pickup__c + '\'\n';
                    
                    if (OldQuote.OB_Weekend_Delivery__c != qte.OB_Weekend_Delivery__c)
                        Message +=   'Outbound Accessorial \'Weekend Delivery\' changed from \'' + OldQuote.OB_Weekend_Delivery__c + ' to \'' + qte.OB_Weekend_Delivery__c + '\'\n';
                    
                    //SFDC-280
                    if (OldQuote.OB_NY_City__c != qte.OB_NY_City__c)
                        Message +=   'Outbound NY City changed from \'' + OldQuote.OB_NY_City__c + ' to \'' + qte.OB_NY_City__c + '\'\n';
                    
                    if (OldQuote.OB_New_York_City_Fee__c != qte.OB_New_York_City_Fee__c)
                        Message += 'OB New York City Fee changed from \'' + OldQuote.OB_New_York_City_Fee__c + ' to \'' + qte.OB_New_York_City_Fee__c + '\'\n';
                    
                    if (OldQuote.OB_Beyond_Point__c != qte.OB_Beyond_Point__c && (OldQuote.OB_Beyond_Point__c == null || qte.OB_Beyond_Point__c == null))
                        Message += 'Outbound Beyond Point changed from \'' + OldQuote.OB_Beyond_Point__c + ' to \'' + qte.OB_Beyond_Point__c + '\'\n';
                    
                    if (OldQuote.OB_Beyond_Point_Fee__c != qte.OB_Beyond_Point_Fee__c)
                        Message += 'OB Beyond Point Fee changed from \'' + OldQuote.OB_Beyond_Point_Fee__c + ' to \'' + qte.OB_Beyond_Point_Fee__c + '\'\n';
                    
                    //End - SFDC-280
                }
                
                if (qte.Total__c != null || qte.OB_Total__c != null)
                {
                    if (Message != '')
                    {
                        String PrePendAlert = 'ALERT - KEY DATA HAS BEEN CHANGED PLEASE RE-SELECT RATES.';
                        
                        if (qte.Message__c !=  null)
                            Message = (qte.Message__c.indexOf(PrePendAlert) > -1 ? Message : PrePendAlert + '\n' + Message);
                        else
                            Message = PrePendAlert + '\n' + Message;
                        
                        qte.Message__c = (qte.Message__c !=  null ? qte.Message__c + '\n'+ Message : Message);
                    }
                }
                
                /* END ALERT MESSAGES */
                
            } //end if Trigger.isUpdate
            
            //} 
            //*************************************      
            //* END: RECORD TYPE SPECIFIC RULES   *
            //*************************************
        }
        
        //*************************************       
        //* START: Set Defaults on New Quote  *
        //************************************* 
        
        for(Quote__c qte: Trigger.new)
        { 
            //***************************************************************************   
            //* START: Default Addresses upon Insert                                    *
            //***************************************************************************  
            if (Trigger.isInsert)
            {
                
                if (qte.Account_Id__c != null)
                {
                    //If Account has Oracle Addresses, then populate its reference on the Quote
                    qte.Origination_Street__c = MoAccountIdToAccount.get(qte.Account_Id__c).BillingStreet;
                    qte.Origination_City__c = MoAccountIdToAccount.get(qte.Account_Id__c).BillingCity;
                    qte.Origination_State__c = MoAccountIdToAccount.get(qte.Account_Id__c).BillingState;
                    qte.Origination_Country__c = MoAccountIdToAccount.get(qte.Account_Id__c).BillingCountry;
                    qte.Origination_Postal_Code__c = MoAccountIdToAccount.get(qte.Account_Id__c).BillingPostalCode;
                    
                    qte.OB_Destination_Street__c = MoAccountIdToAccount.get(qte.Account_Id__c).BillingStreet;
                    qte.OB_Destination_City__c = MoAccountIdToAccount.get(qte.Account_Id__c).BillingCity;
                    qte.OB_Destination_State__c = MoAccountIdToAccount.get(qte.Account_Id__c).BillingState;
                    qte.OB_Destination_Country__c = MoAccountIdToAccount.get(qte.Account_Id__c).BillingCountry;
                    qte.OB_Destination_Postal_Code__c = MoAccountIdToAccount.get(qte.Account_Id__c).BillingPostalCode;                
                }
            }
            //*************************************************************************** 
            //* END: Default Addresses upon Insert                                      *
            //***************************************************************************
            
            //***************************************************************************   
            //* START: Default Facility on Quote                                        *
            //***************************************************************************  
            
            /*
If it is an insert and a Opportunity is selected on the Quote and if Opportunity has a Facility identified
then default Opportunity Facility on the Quote.

NOTE: This can/will be overridden in the next steps if user has manually selected another facility or destination 
shipping address.

Update 05/02/2012: This should occur only on insert, not on update. Otherwise, users selection will be
changed, even if user has not changed Facility. This is specially true for Quotes created before this change 
was deployed because for those Quotes Facility__c and Destination_Shipping_Address__c fields
(and corresponding fields for outbound) will be null.
*/
            
            if (Trigger.isInsert)
            {
                Account OptyFacility = null;
                
                if (qte.Show_Occurrence__c != null)
                {
                    Opportunity Opty = MoOpptyIdToOppty.get(qte.Show_Occurrence__c);
                    
                    if (Opty != null && Opty.Facility__c != null)
                        OptyFacility = MoFacilityIdToFacility.get(Opty.Facility__c);
                }
                
                if (OptyFacility != null && qte.Facility__c ==  null)
                {
                    qte.Facility__c = OptyFacility.Id;
                    qte.Destination_Street__c = OptyFacility.BillingStreet;
                    qte.Destination_City__c = OptyFacility.BillingCity;
                    qte.Destination_State__c = OptyFacility.BillingState;
                    qte.Destination_Country__c = OptyFacility.BillingCountry;
                    qte.Destination_Postal_Code__c = OptyFacility.BillingPostalCode;          
                }
                
                if (OptyFacility != null && qte.OB_Facility__c ==  null)
                {        
                    qte.OB_Facility__c = OptyFacility.Id;
                    qte.OB_Origination_Street__c = OptyFacility.BillingStreet;
                    qte.OB_Origination_City__c = OptyFacility.BillingCity;
                    qte.OB_Origination_State__c = OptyFacility.BillingState;
                    qte.OB_Origination_Country__c = OptyFacility.BillingCountry;
                    qte.OB_Origination_Postal_Code__c = OptyFacility.BillingPostalCode;              
                }
            }
            
            //***************************************************************************   
            //* END: Default Facility on Quote                                          *
            //***************************************************************************
            
        }
        
        //*************************************      
        //* END: Set Defaults on New Quote    *
        //*************************************
    }
   
    // SFDC-244 - start : TMS Integration - Populating Quote and Freight Item into a Staging Table - by Sajid - 08/04/23
    if(Trigger.isAfter){
        
        if(Trigger.isInsert){
            QuoteTriggerHandler quoteTriggerHandler = new QuoteTriggerHandler();
            quoteTriggerHandler.createTMSShippingOrderStg(Trigger.new);
        }
        
        if(Trigger.isUpdate){
            QuoteTriggerHandler quoteTriggerHandler = new QuoteTriggerHandler();
            quoteTriggerHandler.updateTMSShippingOrderStg(Trigger.new);
        }
        
    }
    // SFDC-244 - code end
    
}