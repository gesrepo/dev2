global class BatchImportOracleShowBoothContact implements Database.Batchable<SObject>, Database.Stateful {
    
    public String query; 
    
    global database.querylocator start(Database.BatchableContext BC){return Database.getQueryLocator(query);}
    
    global void execute(Database.BatchableContext BC, Sobject[] scope){
        
        /* START: IMPORT Show Booth Contact */
        
        // Retrieve the list of Booth Contacts in Staging Table and build a collection. Using this collection, 
        // determine which Booth Contacts already exist vs which ones are new.
        List<Staging_Oracle_Show_Booth_Contact__c> LoStgBCs = new List<Staging_Oracle_Show_Booth_Contact__c>();
        
        for(SObject s: scope)
        {
            LoStgBCs.add((Staging_Oracle_Show_Booth_Contact__c)s);
        }
        
        /*
1. Create a Set of All Booth Contact Ids in the Staging Table.

2. Create a Set of Customer Booth Ids (CUST_BTH_ID__c) for Booth Contacts in the Staging Table. Use this set to 
create a map of Customer Booth ID and Booth Record Id (SFDC Id field). This map/lookup is required to populate 
the "Oracle_Show_Booth__c" field during insert.

3. Create a Set of all Booth Contact Email (EMAIL_ADDRESS__c) in the Staging Table. Use this set to create a map 
of Customer Contact Email to Contact Record Id (SFDC Id field). This map/lookup is required to populate the
"Contact__c" field during insert.
*/
        
        set<string> SoAllStageCustContactId = new set<string>();
        set<string> SoCustBoothId = new set<string>();
        set<string> SoCustContactEmail = new set<string>();
        //SFDC-272 - Fixed duplicate contact when the email is blank - 05/14/24
        set<string> setFirstName = new set<string>();
        set<string> setLastName = new set<string>();
        set<string> setAccountId = new set<string>();
        set<string> setBoothId = new set<string>();
        //End SFDC-272
        
        /*
Create a map of Staging_Oracle_Show_Booth_Contact__c object created in the prior step to CUST_CONT_ID__c.
So, if this field value is known, the corresponding staging show booth contact object could be retrieved
which could later be used to identify if this is an existing Booth Contact record.
*/
        
        map<string, Staging_Oracle_Show_Booth_Contact__c> MoBCCustContIdToStgBC = new map<string, Staging_Oracle_Show_Booth_Contact__c>();
        Map<String, String> StgBCFirstName = new Map<String,String>();
        Map<String, String> StgBCLastName = new Map<String,String>();
        List<Staging_Oracle_Show_Booth_Contact__c> LoSkipStageBC = new List<Staging_Oracle_Show_Booth_Contact__c>();
        
        for(Staging_Oracle_Show_Booth_Contact__c stageBC : LoStgBCs)
        {
            if(stageBC.EMAIL_ADDRESS__c == 'none@none.com'){
                LoSkipStageBC.add(stageBC);
                continue;
            }
            if (!SoAllStageCustContactId.contains(stageBC.CUST_CONT_ID__c))
            {
                SoAllStageCustContactId.add(stageBC.CUST_CONT_ID__c);
                MoBCCustContIdToStgBC.put(stageBC.CUST_CONT_ID__c, stageBC);
                
                
                SoCustBoothId.add(stageBC.CUST_BTH_ID__c);
                
                String Email;
                
                if (stageBC.EMAIL_ADDRESS__c != null && stageBC.EMAIL_ADDRESS__c != '')                
                    Email = GetSanitizedEmail(stageBC.EMAIL_ADDRESS__c);
                
                if (Email != null && Email != ''){
                    SoCustContactEmail.add(Email);
                    StgBCFirstName.put(Email.toUpperCase(), stageBC.First_Name__c.toUpperCase());
                    StgBCLastName.put(Email.toUpperCase(),stageBC.Last_Name__c.toUpperCase());
                }else{
                    //SFDC-272 - Fixed duplicate contact when the email is blank - 05/14/24
                    setFirstName.add(stageBC.First_Name__c.toUpperCase());
                    setLastName.add(stageBC.Last_Name__c.toUpperCase());
                    setBoothId.add(stageBC.CUST_BTH_ID__c);
                    //End SFDC-272
                }
            }
        }
        
        // Create a map of Customer Booth ID (CUST_BTH_ID__c) and Booth Record Id (SFDC Id field)
        // Create a map of Customer Booth ID (CUST_BTH_ID__c) and Booth Object        
        map<string, id> MoCustBoothIdToBoothId = new map<string, id>();
        map<string, Oracle_Show_Booth__c> MoCustBoothIdToBooth = new map<string, Oracle_Show_Booth__c>();
        
        List<Oracle_Show_Booth__c> Bths = [Select Id, BOOTH_ID__c, Account__c, Account__r.BillingStreet, Account__r.BillingCity, Account__r.BillingState, Account__r.BillingPostalCode, Account__r.BillingCountry From Oracle_Show_Booth__c Where BOOTH_ID__c In :SoCustBoothId];
        
        for (Oracle_Show_Booth__c bth : Bths)
        {
            MoCustBoothIdToBoothId.put(bth.BOOTH_ID__c, bth.Id);
            MoCustBoothIdToBooth.put(bth.BOOTH_ID__c, bth);
            //SFDC-272 - Fixed duplicate contact when the email is blank - 05/14/24
            if(setBoothId != null && setBoothId.contains(bth.BOOTH_ID__c)){
               	setAccountId.add(bth.Account__c);
            }
            //End SFDC-272
        }
        
        // Create a map of Customer Contact Email to Contact Record Id (SFDC Id field for Contact).
        // Update 1/14/2013: Booth Contact insert functionality is being revised to allow multiple
        // contacts to be associated to the same email address. So query below by email address will/may
        // return multiple records for each email address. The simple Maps of Map<string, id> and 
        // Map<string, Contact>, need to be changed to map each email id to multiple contact ids and
        // contacts
        
        /*
map<string, id> MoCustContactEmailToContactId = new map<string, id>();
map<string, Contact> MoCustContactEmailToContact = new map<string, Contact>();
*/
        
        map<string, Id> MoCustContactEmailToLoContactId = new map<string, Id>();
        map<string, Contact> MoCustContactEmailToLoContact = new map<string, Contact>();
        
        //SFDC-272 - Fixed duplicate contact when the email is blank - 05/14/24
        //List<Contact> Cons = [Select Id, FirstName, LastName, Email, AccountId, LastModifiedDate, Sync_with_Marketo__c From Contact Where Email In :SoCustContactEmail];
        List<Contact> Cons = [Select Id, FirstName, LastName, Email, AccountId, LastModifiedDate, Sync_with_Marketo__c From Contact Where (Email IN :SoCustContactEmail) OR (FirstName IN :setFirstName and LastName IN :setLastName and AccountId IN :setAccountId)];
        //Boolean ContactSynced = false;
        
        //SFDC-196 - fixed Apex CPU time limit exceeded exception - 04/12/24 - Sajid
        Map<String, List<Contact>> mapContactEmailToLoContact = new Map<String, List<Contact>>();
        Map<String, List<Contact>> mapAccountIdToLoContact = new Map<String, List<Contact>>();
        for(Contact c : Cons){
            String email = c.Email;
            if(email != null){
                if (mapContactEmailToLoContact.containsKey(email.toUpperCase())) {
                    mapContactEmailToLoContact.get(email.toUpperCase()).add(c);
                }
                else {
                    mapContactEmailToLoContact.put(email.toUpperCase(), new List<Contact>{ c });
                }
            }else{
                //SFDC-272 - Fixed duplicate contact when the email is blank - 05/14/24
                String uniqueAccKey = c.AccountId + '~' + c.FirstName + '~' + c.LastName; 
                if(mapAccountIdToLoContact.containsKey(uniqueAccKey)){
                    mapAccountIdToLoContact.get(uniqueAccKey).add(c);
                }else{
                    mapAccountIdToLoContact.put(uniqueAccKey, new List<Contact>{ c });
                }
                //End SFDC-272
            }  
        }
        
        //SFDC-196 - created two variables to store the latestModifiedTime of duplicate Contacts - 11/27/23 - Sajid
        map<string, DateTime> MoContactEmailToSyncLatestTime = new map<string, DateTime>();
        map<string, DateTime> MoContactEmailToUnSyncLatestTime = new map<string, DateTime>();
        
        //SFDC-196 - Moved below two variables inside for loop - 11/27/23 - Sajid
        /*DateTime SyncLatestTime = Date.newInstance(1901, 1, 1);
        DateTime UnSyncLatestTime = Date.newInstance(1901, 1, 1);
		*/
        
        for (string email : SoCustContactEmail)
        {
            List<Id> LoConId = new List<Id>();
            List<Contact> LoCon = new List<Contact>();
            Boolean ContactSynced = false;
            DateTime SyncLatestTime = Date.newInstance(1901, 1, 1); // SFDC-196
            DateTime UnSyncLatestTime = Date.newInstance(1901, 1, 1); // SFDC-196
            String custEmail = email.toUpperCase();
            system.debug('custEmail: '+custEmail);
            system.debug('mapContactEmailToLoContact size: '+mapContactEmailToLoContact.size());
            List<Contact> listContacts = mapContactEmailToLoContact.get(custEmail);
            if(listContacts != null && listContacts.size()>0){
                for (Contact con : listContacts)
                {
                    //Case in-sensitive matching
                    if(con != null && con.Email != null && con.FirstName != null && con.LastName != null && email != null && StgBCFirstName != null && STgBCLastName != null && StgBCFirstName.size() > 0 && STgBCLastName.size() > 0 && StgBCFirstName.containsKey(email.toUpperCase()) && STgBCLastName.containsKey(email.toUpperCase())){
                        if (email.toUpperCase() == con.Email.toUpperCase() && con.FirstName.toUpperCase() == StgBCFirstName.get(email.toUpperCase()) && con.LastName.toUpperCase() == STgBCLastName.get(email.toUpperCase()))
                        {
                            //LoConId.add(con.Id);
                            //LoCon.add(con);
                            System.debug('BC FirstName inside If : '+StgBCFirstName.get(email.toUpperCase()));
                            System.debug('BC LastName inside If: '+STgBCLastName.get(email.toUpperCase()));
                            System.debug('BC Email inside If: '+email.toUpperCase());
                            System.debug('Con FirstName inside If: '+con.FirstName);
                            System.debug('Con LastName inside If: '+con.LastName);
                            System.debug('Con Email inside If: '+con.Email);
                            System.debug('Con LastModifiedDate inside If: '+con.LastModifiedDate);
                            
                            //code start - SFDC-196 - Fixed duplicate contact - 11/27/23 - Sajid
                            if(MoCustContactEmailToLoContact.containsKey(con.email.toUpperCase())){
                                if(con.Sync_with_Marketo__c ){
                                    if(ContactSynced){
                                        SyncLatestTime = MoContactEmailToSyncLatestTime.get(con.Email.toUpperCase());
                                    }
                                    ContactSynced = true;
                                    if(con.LastModifiedDate > SyncLatestTime){
                                        MoCustContactEmailToLoContactId.put(email.toUpperCase(), con.id);
                                        MoCustContactEmailToLoContact.put(email.toUpperCase(), con);
                                        SyncLatestTime = con.LastModifiedDate;
                                        MoContactEmailToSyncLatestTime.put(con.Email.toUpperCase(),SyncLatestTime);
                                    }
                                }
                                else if(ContactSynced == false){
                                    UnSyncLatestTime = MoContactEmailToUnSyncLatestTime.get(con.Email.toUpperCase());
                                    if(con.LastModifiedDate > UnSyncLatestTime){        
                                        MoCustContactEmailToLoContactId.put(email.toUpperCase(), con.id);
                                        MoCustContactEmailToLoContact.put(email.toUpperCase(), con);
                                        UnSyncLatestTime = con.LastModifiedDate;
                                        MoContactEmailToUnSyncLatestTime.put(con.Email.toUpperCase(),UnSyncLatestTime);
                                    }
                                }
                            }else{
                                if(con.Sync_with_Marketo__c ){
                                    ContactSynced = true;
                                    if(con.LastModifiedDate > SyncLatestTime){
                                        MoCustContactEmailToLoContactId.put(email.toUpperCase(), con.id);
                                        MoCustContactEmailToLoContact.put(email.toUpperCase(), con);
                                        SyncLatestTime = con.LastModifiedDate;
                                        MoContactEmailToSyncLatestTime.put(con.Email.toUpperCase(),SyncLatestTime);
                                    }
                                }
                                else if(ContactSynced == false){
                                    if(con.LastModifiedDate > UnSyncLatestTime){        
                                        MoCustContactEmailToLoContactId.put(email.toUpperCase(), con.id);
                                        MoCustContactEmailToLoContact.put(email.toUpperCase(), con);
                                        UnSyncLatestTime = con.LastModifiedDate;
                                        MoContactEmailToUnSyncLatestTime.put(con.Email.toUpperCase(),UnSyncLatestTime);
                                    }
                                }
                            }
                        	//end -SFDC-196
                        
                        	//SFDC-196 - code commmented, fixed duplicate contact - 11/27/23 - Sajid
                        	/*if(con.Sync_with_Marketo__c ){
                            	ContactSynced = true;
                            	if(con.LastModifiedDate > SyncLatestTime){
                                	MoCustContactEmailToLoContactId.put(email.toUpperCase(), con.id);
                                	MoCustContactEmailToLoContact.put(email.toUpperCase(), con);
                                	SyncLatestTime = con.LastModifiedDate;
                            	}
                        	}
                        	else if(ContactSynced == false){
                            	if(con.LastModifiedDate > UnSyncLatestTime){        
                                	MoCustContactEmailToLoContactId.put(email.toUpperCase(), con.id);
                                	MoCustContactEmailToLoContact.put(email.toUpperCase(), con);
                                	UnSyncLatestTime = con.LastModifiedDate;
                            	}
                        	}*/
                        	//end-SFDC-196
                    	}
                	}
            	}
            }
            
            
            // Make the key field, email upper case so that comparisons later 
            // are not affected by case.
            //MoCustContactEmailToLoContactId.put(email.toUpperCase(), LoConId);
            //MoCustContactEmailToLoContact.put(email.toUpperCase(), LoCon);
        }
        
        // Split collection of Booth Contacts into two separate lists, one for update and another for insert            
        List<Staging_Oracle_Show_Booth_Contact__c> LoStageBCsInsertOp = new List<Staging_Oracle_Show_Booth_Contact__c>();
        List<Staging_Oracle_Show_Booth_Contact__c> LoStageBCsUpdateOp = new List<Staging_Oracle_Show_Booth_Contact__c>();
        List<Staging_Oracle_Show_Booth_Contact__c> LoStageBCsIgnored = new List<Staging_Oracle_Show_Booth_Contact__c>();            
        
        // Retrieve the list of Booth Contacts that already exist based on Set SoAllStageCustContactId.
        List<Oracle_Show_Booth_Contact__c> LoExistingBoothContacts = [Select Id, CUST_CONT_ID__c, FIRST_NAME__c, LAST_NAME__c, EMAIL__c, Contact__r.Id, Contact__r.FirstName, Contact__r.LastName, Contact__r.Email, Contact__r.AccountId, Oracle_Show_Booth__r.Id, Oracle_Show_Booth__r.Account__c, Updated_in_Salesforce__c From Oracle_Show_Booth_Contact__c Where CUST_CONT_ID__c In : SoAllStageCustContactId];
        
        
        /*    
Set of all Cust Contact Ids for which all matching Booth Contact records are going to be updated.
This list can be used to figure out the set/list of staging table records which will result in an
update of existing Booth Contact. In addition, this same list is used to determine the set of 
staging table records will will result in new Booth Contacts i.e. inserts.
*/
        set<string> SoCustContIdsUpdateOp = new set<string>();  
        
        // This variable is used towards the end of the process to set primary contact information on the Booth,
        // for updated booth contacts.
        set<id> SoBoothContactIds_Updated = new set<id>();
        
        /*
// This map is the map of existing Contacts to existing Booth Contacts based on
// criteria of matching First Name, Last Name and Email. Note, this match may be
// different from the currently selected Contact on the existing Booth Contact.
// When there is a difference, I believe the existing Booth Contact record should
// be updated to the matching Contact. This verification will actuall occur in the
// UpdateBoothContact method. So, in that method, first check if there is a new
// Contact created for the given Booth Contact. If not, check if there is an existing
// matching contact. Then check if the matching contact is different from the
// current contact on BC record, update it.
*/ 
        
        map<id, Contact> MoExistingBCSfIdToExistingContact = new map<id, Contact>();
        
        System.debug(MoCustContactEmailToLoContact);
        
        map<id, Contact> MoExistingBCSfIdToNewContact = CreateContactsForExistingBoothContacts(LoExistingBoothContacts,
                                                                                               MoBCCustContIdToStgBC,
                                                                                               MoCustBoothIdToBoothId,
                                                                                               MoCustBoothIdToBooth,
                                                                                               MoCustContactEmailToLoContact,
                                                                                               MoExistingBCSfIdToExistingContact,
                                                                                               mapAccountIdToLoContact);
        
        /*
***********************************************************        
Start: Process Booths Contacts for Update
***********************************************************
*/
        
        List<Oracle_Show_Booth_Contact__c> LoBoothContactsToUpdate = UpdateBoothContacts(LoExistingBoothContacts,
                                                                                         MoBCCustContIdToStgBC,
                                                                                         MoCustBoothIdToBoothId,
                                                                                         MoExistingBCSfIdToNewContact,
                                                                                         MoExistingBCSfIdToExistingContact,
                                                                                         SoCustContIdsUpdateOp,
                                                                                         LoStageBCsUpdateOp,
                                                                                         LoStageBCsIgnored);
        System.debug(MoExistingBCSfIdToExistingContact);
        System.debug(LoBoothContactsToUpdate);
        System.debug(LoExistingBoothContacts);
        
        List<Database.Saveresult> BoothContactUR = Database.update(LoBoothContactsToUpdate, false);                 
        ProcessUpdateResults(BoothContactUR, LoStageBCsUpdateOp , LoStageBCsIgnored, soBoothContactIds_Updated,LoSkipStageBC);
        
        
        /*
***********************************************************        
Start: Create Set of All Booth Contacts for Insert
***********************************************************
*/
        
        // This is the list of All Stage Booth Contact records minus the
        // set that is already identified for update.
        
        set<string> SoStgBCCustContIdsInsertOp = new set<string>();
        
        for(string bcCustContId : SoAllStageCustContactId)
        {
            if (!SoCustContIdsUpdateOp.contains(bcCustContId))
                SoStgBCCustContIdsInsertOp.add(bcCustContId);
        }    
        
        // These two variables are used at the very end of this process
        // to update primary contact of Booth
        set<id> SoBoothContactIds_Inserted = new set<id>();
        
        /*
***********************************************************        
Start: Process Booths Contacts for Insert
***********************************************************
*/
        
        if (SoStgBCCustContIdsInsertOp.size() > 0)
        {
            /*
In insert operation, a new contact needs to be created when these two conditions co-exist:

1. Booth exists for the Booth Contact record in staging table
2. A Contact does not exist with the given email address
3. A Contact does not exist with given First Name and Last Name combination 

In this case, a Contact needs to be created with the same address as the Account on the Booth.

Therefore, for the Booth Contact Staging records identified for Insert, create a list of Booths
which exists for such Booth Contacts.

Before list of Booths can be created, create a list of staging Booth Contact records using the
set of Staging Booth Contact record Ids of those Booth Contact staging records that are marked
for insert.
*/
            
            /*
***********************************************************        
Start: Create Contacts for new Booth Contacts
***********************************************************
*/
            
            /*
Create a list of all Staging Booth Contacts for Insert. In this list include
the CUST_BTH_ID__c column, so that it could be used to retrive the SFDC Id
of the Booth record using lookup in this map: MoCustBoothIdToBoothId
*/
            
            list<Staging_Oracle_Show_Booth_Contact__c> LoStageBoothContactsInsertOp = [Select Id, CUST_BTH_ID__c From Staging_Oracle_Show_Booth_Contact__c Where Interface_Status__c = 'New' And CUST_CONT_ID__c In :SoStgBCCustContIdsInsertOp];
            
            // Using the list created in the prior set, create a set of Booth Ids for such
            // Booth Contacts
            
            set<id> SoBoothIdsForNewBoothContacts = new set<id>();
            
            for (Staging_Oracle_Show_Booth_Contact__c stgBC: LoStageBoothContactsInsertOp)
                SoBoothIdsForNewBoothContacts.add(MoCustBoothIdToBoothId.get(stgBC.CUST_BTH_ID__c));
            
            // Now generate a list of Booths for each Booth Id retrieve in the prior step
            list<Oracle_Show_Booth__c> LoBoothsForNewBoothContacts = [Select Id, Account__c From Oracle_Show_Booth__c Where Id In :SoBoothIdsForNewBoothContacts];
            
            map<string, Contact> MoCustContIdToNewContact = CreateContactsForNewBoothContacts(SoStgBCCustContIdsInsertOp, 
                                                                                              MoBCCustContIdToStgBC,
                                                                                              MoCustContactEmailToLoContact,
                                                                                              MoCustBoothIdToBoothId,
                                                                                              MoCustBoothIdToBooth,
                                                                                              mapAccountIdToLoContact);
            
            /*
***********************************************************
START: Create New Booth Contacts and Process Insert Results
***********************************************************
*/
            List<Database.Saveresult> LoBCInsertResults = InsertBoothContacts(SoStgBCCustContIdsInsertOp,
                                                                              MoBCCustContIdToStgBC,
                                                                              MoCustContIdToNewContact,
                                                                              MoCustContactEmailToLoContact,
                                                                              MoCustBoothIdToBoothId,
                                                                              LoStageBCsInsertOp);
            System.debug(LoBCInsertResults);
            System.debug(SoStgBCCustContIdsInsertOp);
            
            ProcessBoothContactInsertResults(LoBCInsertResults, LoStageBCsInsertOp, SoBoothContactIds_Inserted);
            
        }   // End if SoStgBCIdsProcessAsInsert.size() > 0 
        
        UpdateBoothPrimaryContactInfo(SoBoothContactIds_Inserted, SoBoothContactIds_Updated);
    }
    
    private string GetSanitizedEmail(string email)
    {
        return email.replace(',','').replace('\'','').replace('"','').replace('mailto:','').replace('mailto','').replace('&','');       
    }
    
    private string GetTruncatedEmail(string email)
    {
        string ReturnValue = '';
        
        if (email.length() <= 80)
        {
            ReturnValue = email;
        }
        else
        {
            integer PosOfAt = email.indexOf('@');
            
            if (PosOfAt > 0)
            {
                string DomPart = email.substring(PosOfAt);
                integer DomPartLen = DomPart.length();
                
                if (DomPartLen < 80)
                {
                    string EmailPart = email.substring(0, 80 - DomPartLen);
                    ReturnValue = EmailPart + DomPart;
                }
                else
                    ReturnValue = '';
            }
            else
                ReturnValue = email.substring(0, 80);
        }
        
        return ReturnValue;
    }
    
    private List<Oracle_Show_Booth_Contact__c> UpdateBoothContacts(List<Oracle_Show_Booth_Contact__c> loExistingBoothContacts, 
                                                                   Map<string, Staging_Oracle_Show_Booth_Contact__c> moBCCustContIdToStgBC,
                                                                   Map<string, string> moCustBoothIdToBoothId,
                                                                   Map<id, Contact> moExistingBCSfIdToNewContact,
                                                                   Map<id, Contact> moExistingBCSfIdToExistingContact,
                                                                   Set<string> soCustContIdsUpdateOp,
                                                                   List<Staging_Oracle_Show_Booth_Contact__c> loStageBCsUpdateOp,
                                                                   List<Staging_Oracle_Show_Booth_Contact__c> loStageBCsIgnored)
    {
        System.debug('Inside Update Method');
        
        List<Oracle_Show_Booth_Contact__c> LoBoothContactsToUpdate = new List<Oracle_Show_Booth_Contact__c>();
        
        for(Oracle_Show_Booth_Contact__c bc: LoExistingBoothContacts)
        {
            Staging_Oracle_Show_Booth_Contact__c StgBC = MoBCCustContIdToStgBC.get(bc.CUST_CONT_ID__c);         
            
            /*
The variable loStageBCsUpdateOp needs to include stage booth
contact record only if the corresponding bc is actually
being included in the update list loBoothContactsToUpdate.
*/
            // loStageBCsUpdateOp.add(StgBC);
            
            /*
If CUST_BTH_ID__c is different from existing record, the line below will set
BoothId to null. This will occur in the case when the Contact gets assigned
to another Booth. In such a case, update is not valid.

In reality this should never happen.
*/
            string BoothId = moCustBoothIdToBoothId.get(StgBC.CUST_BTH_ID__c);
            
            // Do not update booth contact, if it is updated manually in Salesforce
            if (bc.Updated_in_Salesforce__c == false)
            {
                //updBoothContact.Oracle_Show_Booth__c = BoothId; This Master-Detail Relationship field is not updateable
                
                if (BoothId == null || BoothId.equals(''))
                {
                    /*
Since Booth does not exist (perhaps Contact was moved to another Booth in Oracle). 
Hence, this record cannot be processed normally. Inactivate Booth Contact record.
*/
                    
                    bc.Inactive__c = true;
                    
                    soCustContIdsUpdateOp.add(bc.CUST_CONT_ID__c);
                    LoBoothContactsToUpdate.add(bc);                
                    
                    // This will never be used, as the staging record in this case is
                    // updated based on the results of the update.
                    // StgBC.Interface_Status__c = 'Inactivated';
                    // StgBC.Interface_Error_Message__c = 'This booth contact may have been moved to another Booth in Oracle. This operation is not permitted in Salesforce.com. This booth contact is being inactivated.';
                    
                    /*
The variable loStageBCsUpdateOp needs to include stage booth
contact only if the corresponding bc is actually
being included in the update list LoBoothContactsToUpdate.
*/
                    loStageBCsUpdateOp.add(StgBC);
                }     
                else
                {               
                    String StgBCEmail;
                    
                    if (StgBC.EMAIL_ADDRESS__c != null && StgBC.EMAIL_ADDRESS__c != '')
                        StgBCEmail = GetSanitizedEmail(StgBC.EMAIL_ADDRESS__c);
                    
                    /*         
NOTE: If this Booth Contact needs to be tied to a new Contact, the Contact is already
created in the prior section. So, just get the Id of the new Contact.

If Booth Contact Email and/or Phone are blank, Contact creation in prior steps
will fail. As a result, TheBooth variable may be blank because no contact exits.
In this case, the Update Booth Contact for this record should fail because it
will try to update the Contact__c field with null.
*/
                    
                    Contact TheContact = MoExistingBCSfIdToNewContact.get(bc.Id);
                    
                    Id ContactId = null;
                    
                    //If TheContact is null, then booth contact does not require a new Contact
                    if (TheContact != null){
                        //NOTE: If ContactId ends up being null, then perhaps the new Contact was not created due to data error     
                        ContactId = TheContact.Id;
                    }
                    else
                    {
                        /*
Execution of this portion of code means a new contact has not been created
for this Booth Contact. In this case, check if a matching Contact was found
which should be in this collection: MoExistingBCSfIdToExistingContact.
If a matching contact was found, and if these conditions are satisfied then
Overwrite the Contact on the Booth Contact.
1. Id of matching contact different from Id of contact currently on the BC
AND
(
2. First Name of matching contact different from contact currently on BC
OR
3. Last Name of matching contact different from contact currently on BC
OR
4. Email of matching contact different from contact currently on BC
)
*/
                        
                        Contact ExistingContact = MoExistingBCSfIdToExistingContact.get(bc.Id);
                        System.debug(ExistingContact);
                        System.debug('Contact Name '+bc.Contact__c);
                        
                        //code start -SFDC-196 - remodified below logic to populate the ContactId - 11/27/23 - Sajid
                        /*if (ExistingContact != null && bc.Contact__r != null)
                        {
                            if (ExistingContact.Id != bc.Contact__c && 
                                ((bc.Contact__c != null && (ExistingContact.FirstName == null && bc.Contact__r.FirstName == null) || (ExistingContact.FirstName != null && bc.Contact__r.FirstName != null && ExistingContact.FirstName.toUpperCase() != bc.Contact__r.FirstName.toUpperCase())) ||
                                 ExistingContact.LastName.toUpperCase() != bc.Contact__r.LastName.toUpperCase() ||
                                 (bc.Contact__r.Email != null && ExistingContact.Email.toUpperCase() != bc.Contact__r.Email.toUpperCase() || bc.Contact__r.Email == null)
                                ))
                                ContactId = ExistingContact.Id;
                            else
                                ContactId = bc.Contact__c;
                            System.debug('Contact ID '+ContactId);
                        }
                        else
                            ContactId = bc.Contact__c;
                        System.debug('Contact ID else '+ContactId);
                        */
                        
                        if (ExistingContact != null && bc.Contact__r == null){
                            ContactId = ExistingContact.Id;
                        }
                        else if (ExistingContact == null && bc.Contact__r != null){
                            ContactId = bc.Contact__c;
                        }
                        else if(ExistingContact.Id != bc.Contact__c){
                            if((bc.Contact__c != null && (ExistingContact.FirstName == null && bc.Contact__r.FirstName == null) || (ExistingContact.FirstName != null && bc.Contact__r.FirstName != null && ExistingContact.FirstName.toUpperCase() != bc.Contact__r.FirstName.toUpperCase())) ||
                               ExistingContact.LastName.toUpperCase() != bc.Contact__r.LastName.toUpperCase() ||
                               (bc.Contact__r.Email != null && ExistingContact.Email.toUpperCase() != bc.Contact__r.Email.toUpperCase() || bc.Contact__r.Email == null)
                              ){
                                  ContactId = ExistingContact.Id;
                              }else{
                                  ContactId = bc.Contact__c;
                              }
                        }else{
                            ContactId = bc.Contact__c;
                        }
                        //end -SFDC-196
                    }
                    
                    bc.Contact__c = ContactId;
                    
                    bc.AREA_CODE__c = StgBC.AREA_CODE__c;
                    bc.CONTACT_ROLE__c = StgBC.CONTACT_ROLE__c;
                    bc.CONTACT_TYPE__c = StgBC.CONTACT_TYPE__c;
                    bc.COUNTRY_CODE__c = StgBC.COUNTRY_CODE__c;
                    bc.CUST_BOOTH_ID__c = StgBC.CUST_BTH_ID__c;
                    bc.CUST_CONT_ID__c = StgBC.CUST_CONT_ID__c;
                    
                    if (StgBCEmail != null)
                        bc.EMAIL__c = StgBCEmail;
                    
                    bc.EXTENSION__c = StgBC.EXTENSION__c;
                    bc.FAX__c = StgBC.FAX__c;
                    bc.FIRST_NAME__c = StgBC.FIRST_NAME__c;
                    bc.LAST_NAME__c = StgBC.LAST_NAME__c;
                    bc.PHONE__c = StgBC.PHONE__c;
                    bc.PRIMARY_FLAG__c = StgBC.PRIMARY_FLAG__c;
                    bc.SHOW_OCCR_CUST_ID__c = StgBC.SHOW_OCCR_CUST_ID__c;
                    bc.Inactive__c = false;
                    
                    soCustContIdsUpdateOp.add(bc.CUST_CONT_ID__c);
                    LoBoothContactsToUpdate.add(bc);
                    
                    /*
The variable LoStageBCsUpdateOp needs to include stage booth
contact only if the corresponding bc is actually
being included in the update list LoBoothContactsToUpdate.
*/
                    loStageBCsUpdateOp.add(StgBC);
                    
                    //Also, update fields on the Contact as applicable
                } // end if BoothId == null
            } // end if (bc.Updated_in_Salesforce__c == false
            else // If show workbench booth contact is updated in salesforce, do not update it anymore.
            {
                soCustContIdsUpdateOp.add(bc.CUST_CONT_ID__c);
                StgBC.Interface_Status__c = 'Ignored';
                StgBC.Interface_Error_Message__c = 'Booth contact updated in Salesforce. Update ignored.'; 
                
                /*
Add this stage booth contact to the ignored list. This is required
since the booth contact record corresponding to this stage record
will not be included in the booth contact update list. Hence, while
iterating the booth contact update results, this stage record will
not be found. Ignored stage records will have to be processed 
separately.
*/
                loStageBCsIgnored.add(StgBC);
            }
        } // end for
        
        return LoBoothContactsToUpdate;
    }
    
    private void ProcessUpdateResults(List<Database.Saveresult> loBCUpdateResults, List<Staging_Oracle_Show_Booth_Contact__c> loStgBCProcessedAsUpdate, List<Staging_Oracle_Show_Booth_Contact__c> loStgBCIgnored, Set<Id> soBCIdsUpdated, List<Staging_Oracle_Show_Booth_Contact__c> LoSkipStageBC)
    {
        List<Staging_Oracle_Show_Booth_Contact__c> LoStgBCUpdateStatus = new List<Staging_Oracle_Show_Booth_Contact__c>();
        
        integer ResultCount = 0;
        
        for(Database.Saveresult result : loBCUpdateResults)
        {
            Staging_Oracle_Show_Booth_Contact__c StgBCProcessedAsUpdate = loStgBCProcessedAsUpdate[ResultCount];
            StgBCProcessedAsUpdate.Interface_Process_Attempts__c = (StgBCProcessedAsUpdate.Interface_Process_Attempts__c == null ? 0 : StgBCProcessedAsUpdate.Interface_Process_Attempts__c + 1);
            
            if (result.isSuccess())
            {
                if (StgBCProcessedAsUpdate.Interface_Status__c == null || StgBCProcessedAsUpdate.Interface_Status__c != 'Inactivated')
                {
                    StgBCProcessedAsUpdate.Interface_Status__c = 'Updated';
                    StgBCProcessedAsUpdate.Interface_Error_Message__c = '';
                }
                
                // If Booth Contact was successfully updated, add the Booth Id to the set of Booth Ids
                // which will be used later to update booth with Contact information.
                
                soBCIdsUpdated.add(result.getId());
            }
            else
            {
                System.debug('The Id' + result.getId());
                StgBCProcessedAsUpdate.Interface_Status__c = 'Failed Update';
                
                string ErrorMessage = '';
                
                for(Database.Error err : result.getErrors())
                {
                    ErrorMessage += err.getMessage();
                }
                
                StgBCProcessedAsUpdate.Interface_Error_Message__c = ErrorMessage;                
            }
            
            LoStgBCUpdateStatus.add(StgBCProcessedAsUpdate);
            
            ResultCount++;
        }
        
        if (LoStgBCUpdateStatus.size() > 0)
            Database.update(LoStgBCUpdateStatus, false);
        
        if(LoSkipStageBC != null && LoSkipStageBC.size()>0){
            for(Staging_Oracle_Show_Booth_Contact__c stageBCSkipRecord: LoSkipStageBC){
                stageBCSkipRecord.Interface_Status__c = 'Updated';
                //stageBCSkipRecord.Interface_Error_Message__c = 'Skiped the reocord since email is none@none.com';
                loStgBCIgnored.add(stageBCSkipRecord);
            }
        }
        // Update the ignored stage booth contact records
        if (loStgBCIgnored.size() > 0)
            Database.update(loStgBCIgnored, false);   
    }
    
    private List<Database.SaveResult> InsertBoothContacts(Set<string> soStgBCCustContIdInsertOp,
                                                          Map<string, Staging_Oracle_Show_Booth_Contact__c> moBCCustContIdToStgBC, 
                                                          Map<string, Contact> moCustContIdToNewContact,
                                                          Map<string, Contact> moCustConEmailToLoContact,
                                                          Map<string, string> moCustBthIdToBoothId,
                                                          List<Staging_Oracle_Show_Booth_Contact__c> loStgBCInsertOp)
    {
        List<Oracle_Show_Booth_Contact__c> LoNewBC = new List<Oracle_Show_Booth_Contact__c>();
        
        for(string bcCustContId : soStgBCCustContIdInsertOp)
        {
            Staging_Oracle_Show_Booth_Contact__c stgBCRec = moBCCustContIdToStgBC.get(bcCustContId);
            loStgBCInsertOp.add(stgBCRec);
            
            Oracle_Show_Booth_Contact__c NewBC = new Oracle_Show_Booth_Contact__c();
            
            String StgBoothContactEmail;
            
            if (stgBCRec.EMAIL_ADDRESS__c != null && stgBCRec.EMAIL_ADDRESS__c != '')
                StgBoothContactEmail = GetSanitizedEmail(stgBCRec.EMAIL_ADDRESS__c);
            
            /*         
NOTE: If this Booth Contact needs to be tied to a new Contact, the Contact is already
created in the prior section. So, just get the Id of the new Contact.

If Booth Contact Email and/or Phone are blank, Contact creation in prior steps
will fail. As a result, TheBooth variable may be blank because no contact exits.
In this case, the Update Booth Contact for this record should fail because it
will try to update the Contact__c field with null.
*/
            
            Contact ContactForNewBC = moCustContIdToNewContact.get(bcCustContId);
            
            /*
The variable ContactForNewBC may be null because booth contact does not require a new Contact
in the object definition in Salesforce.com.

NOTE: If ContactForNewBC ends up being null, then perhaps the new Contact was not created due 
to some error. A secondary check could be done to see if a contact already exists for the 
email address on the stage booth contact record. In this case, the MoCustConEmailToLoContact
collection needs to be checked. The reason the collection is checked because it is quite
possible that multiple contacts exist in Salesforce.com for the same email address. In case,
duplicate contacts with same email exists, select the first one.
*/
            
            if (ContactForNewBC != null) {
                NewBC.Contact__c = ContactForNewBC.Id;
            }
            else {
                
                //TheContact = MoCustContactEmailToContact.get(stgBCRec.EMAIL_ADDRESS__c);
                Contact LoCon;// = new List<Contact>();
                
                if (stgBCRec.EMAIL_ADDRESS__c != null && stgBCRec.EMAIL_ADDRESS__c != '')           
                    LoCon = moCustConEmailToLoContact.get(stgBCRec.EMAIL_ADDRESS__c.toUpperCase());
                
                if (LoCon != null)// && LoCon.size() > 0)
                {
                    
                    if (LoCon.FirstName != null && LoCon.FirstName.toUpperCase() == stgBCRec.FIRST_NAME__c.toUpperCase() && LoCon.LastName.toUpperCase() == stgBCRec.LAST_NAME__c.toUpperCase())
                    {
                        ContactForNewBC = LoCon;
                    }
                    
                }
                
                if (ContactForNewBC != null)
                    NewBC.Contact__c = ContactForNewBC.Id;
            }
            
            /*
If BoothId is null, Booth Contact cannot be inserted as the parent Booth is not known.
In this case, attempt to insert will cause error. Database.Update call on this record
in the payload will mark this row as errored. So, this issue is automatically handled
i.e. identified and recorded in the normal flow.
*/               
            string BoothId = moCustBthIdToBoothId.get(stgBCRec.CUST_BTH_ID__c);
            
            NewBC.Oracle_Show_Booth__c = BoothId;
            
            NewBC.AREA_CODE__c = stgBCRec.AREA_CODE__c;
            NewBC.CONTACT_ROLE__c = stgBCRec.CONTACT_ROLE__c;
            NewBC.CONTACT_TYPE__c = stgBCRec.CONTACT_TYPE__c;
            NewBC.COUNTRY_CODE__c = stgBCRec.COUNTRY_CODE__c;
            NewBC.CUST_BOOTH_ID__c = stgBCRec.CUST_BTH_ID__c;
            NewBC.CUST_CONT_ID__c = stgBCRec.CUST_CONT_ID__c;
            
            if (StgBoothContactEmail != null)
                NewBC.EMAIL__c = GetSanitizedEmail(StgBoothContactEmail);
            
            NewBC.EXTENSION__c = stgBCRec.EXTENSION__c;
            NewBC.FAX__c = stgBCRec.FAX__c;
            NewBC.FIRST_NAME__c = stgBCRec.FIRST_NAME__c;
            NewBC.LAST_NAME__c = stgBCRec.LAST_NAME__c;
            NewBC.PHONE__c = stgBCRec.PHONE__c;
            NewBC.PRIMARY_FLAG__c = stgBCRec.PRIMARY_FLAG__c;
            NewBC.SHOW_OCCR_CUST_ID__c = stgBCRec.SHOW_OCCR_CUST_ID__c;
            
            LoNewBC.add(NewBC);
            
        } // end for
        
        //Perform Actual Insert
        
        return Database.insert(LoNewBC, false);
        
    }
    
    private void ProcessBoothContactInsertResults(List<Database.Saveresult> loBCInsertResults, List<Staging_Oracle_Show_Booth_Contact__c> loStgBCProcessedAsInsert, Set<Id> soBCIdsInserted)
    { 
        /*
While iterating over the results of insert and update of Booth Contacts, create a list
of Booths which may be updated with information of the primary contact, if available.
If primary contact is not available, then select the first contact from the list.
*/
        
        List<Staging_Oracle_Show_Booth_Contact__c> LoStgBCInsertStatus = new List<Staging_Oracle_Show_Booth_Contact__c>();
        
        integer ResultCount = 0;
        
        for(Database.Saveresult result : loBCInsertResults)
        {
            Staging_Oracle_Show_Booth_Contact__c StgBCProcessedAsInsert = loStgBCProcessedAsInsert[ResultCount];
            StgBCProcessedAsInsert.Interface_Process_Attempts__c = (StgBCProcessedAsInsert.Interface_Process_Attempts__c == null ? 0 : StgBCProcessedAsInsert.Interface_Process_Attempts__c + 1);
            
            if (result.isSuccess())
            {
                StgBCProcessedAsInsert.Interface_Status__c = 'Inserted';
                StgBCProcessedAsInsert.Interface_Error_Message__c = '';
                
                // If Booth Contact was successfully inserted, add the Booth Id to the set of Booth Ids
                // which will be used later to update booth with Contact information.
                
                soBCIdsInserted.add(result.getId());
            }
            else
            {
                StgBCProcessedAsInsert.Interface_Status__c = 'Failed Insert';
                
                string ErrorMessage = '';
                for(Database.Error err : result.getErrors())
                {
                    ErrorMessage += err.getMessage();
                }
                
                StgBCProcessedAsInsert.Interface_Error_Message__c = ErrorMessage;               
            }
            
            LoStgBCInsertStatus.add(StgBCProcessedAsInsert);
            
            ResultCount++;
        }
        
        if (LoStgBCInsertStatus.size() > 0)
            Database.update(LoStgBCInsertStatus, false);
        
    }
    
    private map<string, Contact> CreateContactsForNewBoothContacts(set<string> soStgBCCustContIds, map<string, Staging_Oracle_Show_Booth_Contact__c> moBCCustContIdToStgBC, map<string, Contact> moCustContactEmailToLoContact, map<string, Id> moCustBoothIdToBoothId, map<string, Oracle_Show_Booth__c> moCustBoothIdToBooth,Map<String, List<Contact>> mapAccountIdToLoContact)
    {
        list<Contact> LoNewContacts =  new list<Contact>();
        map<string, Contact> MoBCCustContIdToNewContact =  new map<string, Contact>();
        map<string, Contact> MoBCEmailToNewContact =  new map<string, Contact>();
        map<string, Contact> MoExistingBCEmailToNewContact =  new map<string, Contact>();
        map<string, Contact> MoExistingAccEmailToNewContact =  new map<string, Contact>();
        map<string, Contact> MoExistingBoothAccToNewContact =  new map<string, Contact>();
        
        // These collections will be used to update existing Contacts which are not 
        // related to the same Account as Account on Booth
        Set<Id> SoConIds4ContactFieldUpdate = new Set<Id>();        
        map<id, id> MoConIdToAccountId4ContactFieldUpdate = new map<id, id>();        
        
        for(string stgBCCustContId : soStgBCCustContIds)
        {
            Staging_Oracle_Show_Booth_Contact__c stgBCRec = moBCCustContIdToStgBC.get(stgBCCustContId);
            
            String StgBCEmail;
            
            if (stgBCRec.EMAIL_ADDRESS__c != null && stgBCRec.EMAIL_ADDRESS__c != '')
                StgBCEmail = GetSanitizedEmail(stgBCRec.EMAIL_ADDRESS__c);
            System.debug('Email in create : '+StgBCEmail);
            
            Contact ExistingContact = null;
            
            if (StgBCEmail != null)
            {
                /*
Retrieve the list of contacts that matches this email address. Note that
since multiple contacts could be tied to the same email address, you have
to check if these fields for the current contact in this loop (i.e. the 
staging table contact): Email, First name and Last name match the contact. 
Since execution is already inside this loop, it means email field is already
matched.

If there is no matching contact based on email, first name and last name,
ExistingContact should be null.
*/
                
                //List is created with upper case value for key field (email)
                Contact LoCon = moCustContactEmailToLoContact.get(StgBCEmail.toUpperCase());              
                
                if (LoCon != null)// && LoCon.size() > 0)
                {
                    System.debug('Contact ID for existign in Create : '+LoCon.Id);
                    System.debug((LoCon.FirstName != null)+ ' ' + (LoCon.FirstName.toUpperCase() == stgBCRec.FIRST_NAME__c.toUpperCase()) + ' ' + (LoCon.LastName.toUpperCase() == stgBCRec.LAST_NAME__c.toUpperCase()));
                    System.debug((LoCon.FirstName != null)+ ' ' + (LoCon.FirstName.toUpperCase()) +( stgBCRec.FIRST_NAME__c.toUpperCase()) + ' ' + (LoCon.LastName.toUpperCase())+(stgBCRec.LAST_NAME__c.toUpperCase()));
                    
                    if (LoCon.FirstName != null && LoCon.FirstName.toUpperCase() == stgBCRec.FIRST_NAME__c.toUpperCase() && LoCon.LastName.toUpperCase() == stgBCRec.LAST_NAME__c.toUpperCase())
                    {
                        ExistingContact = LoCon;
                    }
                    
                }
            }else{
                //SFDC-272 - Fixed duplicate contact when the email is blank - 05/14/24
                Oracle_Show_Booth__c Booth = moCustBoothIdToBooth.get(stgBCRec.CUST_BTH_ID__c);
                String bAccUniqueKey = Booth.Account__c + '~' + stgBCRec.FIRST_NAME__c + '~' + stgBCRec.LAST_NAME__c;
                List<Contact> lst_Cons = mapAccountIdToLoContact.get(bAccUniqueKey);
                if(lst_Cons != null && lst_Cons.size() >0){
                    ExistingContact = lst_Cons.get(0);
                }
                //End-272
            }
            System.debug('Existing Contact final : ' +ExistingContact);
            
            // If ExistingContact is null, must create new contact
            if (ExistingContact == null)
            {
                string BoothId = null;                
                BoothId = moCustBoothIdToBoothId.get(stgBCRec.CUST_BTH_ID__c);
                
                // Create Contact here
                if (BoothId == null || BoothId.equals(''))
                {
                    /*
Contact cannot be created as address (required) to create contact cannot be
retrieved. Note address is retrieved from the Account tied to the Booth.
This case again does not require special handling as Contact__c is a required
field (via validation) and so not specifying it will return an insert error.
Handle the insert error normally.
*/
                }
                else
                {
                    // Get Account Address From Booth Account
                    Oracle_Show_Booth__c bth = moCustBoothIdToBooth.get(stgBCRec.CUST_BTH_ID__c);
                    
                    if (bth != null && bth.Account__c != null)
                    {
                        Contact Cont = GetNewContactObject(stgBCRec, StgBCEmail, bth, 'CORE');
                        
                        /*
If duplicate new Contacts exist within the same batch, then de-duplicate.
However, create a reference (map) of this stage booth contact to existing contact
De-duplication is possible only if Email is not null or blank. If blank, then
always create a new contact
*/
                        
                        if (Cont.Email != null && Cont.Email != '')
                        {
                            //SFDC-196 - created new UniqueKey field for allowing to create new contact if email,firstname,lastname is not equal Fixed duplicate contact - 11/27/23 - Sajid
                            String uniqueKey = Cont.Email + '~' + Cont.FirstName + '~' + Cont.LastName;
                            String accUniqueKey = bth.Account__c +'~'+Cont.Email;
                            if (!MoBCEmailToNewContact.containsKey(uniqueKey))
                            {
                                if(!MoExistingAccEmailToNewContact.containsKey(accUniqueKey)){
                                    LoNewContacts.add(Cont);
                                    MoBCCustContIdToNewContact.put(stgBCCustContId, Cont);
                                    MoExistingAccEmailToNewContact.put(accUniqueKey, Cont);
                                }else{
                                    MoBCCustContIdToNewContact.put(stgBCCustContId, MoExistingAccEmailToNewContact.get(accUniqueKey)); 
                                }
                                
                                MoBCEmailToNewContact.put(uniqueKey, Cont);
                                moCustContactEmailToLoContact.put(Cont.Email.toUpperCase(), Cont); //SFDC-196 - adding new created contact into this map to keep this field upto date - 11/27/23 - Sajid
                            }
                            else //If Contact is duplicate, then retrieve the Contact from the MoBCEmailToNewContact map
                            {
                                MoBCCustContIdToNewContact.put(stgBCCustContId, MoBCEmailToNewContact.get(uniqueKey));                                
                            }
                        }
                        else //If Email is null, always create a new contact
                        {
                            //SFDC-272 - Fixed duplicate contact when the email is blank - 05/14/24
                            String boothAccUniqueKey = bth.Account__c + '~' + Cont.FirstName + '~' + Cont.LastName; 
                            system.debug('New boothAccUniqueKey:: '+boothAccUniqueKey);
                            if(!MoExistingBoothAccToNewContact.containsKey(boothAccUniqueKey)){
                                system.debug('IF New boothAccUniqueKey:: '+boothAccUniqueKey);
                                LoNewContacts.add(Cont);
                                MoBCCustContIdToNewContact.put(stgBCCustContId, Cont);
                                MoExistingBoothAccToNewContact.put(boothAccUniqueKey,Cont);
                                mapAccountIdToLoContact.put(boothAccUniqueKey,new List<Contact>{Cont});
                            }else{
                                system.debug('ELSE New boothAccUniqueKey:: '+boothAccUniqueKey);
                                MoBCCustContIdToNewContact.put(stgBCCustContId, MoExistingBoothAccToNewContact.get(boothAccUniqueKey));
                            }
                            //LoNewContacts.add(Cont);
                            //MoBCCustContIdToNewContact.put(stgBCCustContId, Cont);
                            
                            //End SFDC-272
                        }
                    } 
                    /*
else Contact cannot be created as address cannot be specifed since Booth 
does not have Account Information.
*/            
                }
            } // If Contact is found and AccountId on Contact is NULL, then update it to Account on Booth
            else
            {
                if (ExistingContact != null && ExistingContact.AccountId == null)
                {
                    SoConIds4ContactFieldUpdate.add(ExistingContact.Id);
                    
                    Oracle_Show_Booth__c Bth = moCustBoothIdToBooth.get(stgBCRec.CUST_BTH_ID__c);
                    
                    if (Bth != null)
                    {
                        if (Bth.Account__c != null)
                            MoConIdToAccountId4ContactFieldUpdate.put(ExistingContact.Id, Bth.Account__c);
                    }
                }
                //Do Nothing as of now
            }
        } // end for
        
        if (LoNewContacts.size() > 0)
            Database.insert(LoNewContacts, false);
        
        /*
***********************************************************        
Start: Update AccountId field (if null) of existing Contacts
***********************************************************
*/
        
        list<Contact> LoContacts4FieldUpdate = [Select Id, AccountId From Contact Where Id In :SoConIds4ContactFieldUpdate];
        
        for(Contact Con: LoContacts4FieldUpdate)
        {
            if (Con.AccountId == null)
            {
                Con.AccountId = MoConIdToAccountId4ContactFieldUpdate.get(Con.Id);
            }
        }
        
        if (LoContacts4FieldUpdate.size() > 0)
            Database.update(LoContacts4FieldUpdate, false);
        
        return MoBCCustContIdToNewContact;
        
    }
    
    private map<id, Contact> CreateContactsForExistingBoothContacts(List<Oracle_Show_Booth_Contact__c> loExistingBoothContacts, map<string, Staging_Oracle_Show_Booth_Contact__c> moBCCustContIdToStgBC, map<string, Id> moCustBoothIdToBoothId, map<string, Oracle_Show_Booth__c> moCustBoothIdToBooth, map<string, Contact> moCustContactEmailToLoContact, map<id, Contact> moExistingBCSfIdToExistingContact,Map<String, List<Contact>> mapAccountIdToLoContact)
    {        
        list<Contact> LoNewContacts =  new list<Contact>();
        map<id, Contact> MoExistingBCSfIdToNewContact =  new map<id, Contact>();
        map<string, Contact> MoExistingBCEmailToNewContact =  new map<string, Contact>();
        map<string, Contact> MoExistingAccEmailToNewContact =  new map<string, Contact>();
        map<string, Contact> MoExistingBoothAccToNewContact =  new map<string, Contact>();
        
        // These collections will be used to update existing Contacts which are not 
        // related to the same Account as Account on Booth. UPDATE: Existing Contacts should not be updated in any manner.
        set<id> SoConIdsForContactFieldUpdate = new set<id>();
        map<id, id> MoConIdToAccountIdForContactFieldUpdate = new map<id, id>();
        
        for(Oracle_Show_Booth_Contact__c bc: loExistingBoothContacts)
        {
            Staging_Oracle_Show_Booth_Contact__c stgBCRec = moBCCustContIdToStgBC.get(bc.CUST_CONT_ID__c);         
            system.debug('bc.CUST_CONT_ID__c:: '+bc.CUST_CONT_ID__c);
            system.debug('stgBCRec:: '+stgBCRec);
            string BoothId = moCustBoothIdToBoothId.get(stgBCRec.CUST_BTH_ID__c);
            
            // Updating the condition to ignore new contact creation logic (i.e. everything in the else
            // portion of this if block) if existing booth contact is updated in Salesforce.
            if (BoothId == null || BoothId.equals('') || bc.Updated_in_Salesforce__c == true)
            {
                // Do nothing
            }     
            else
            {
                //If The Booth Contact is existing, it should already be tied with a Contact. If so, do not
                //Update fields on Contact, except AccountId - if it is not already linked to an Account.
                //Additionally, check if Booth Contact First Name, Last Name Or Email address in staging table is 
                //different from those in Booth Contact record. If it is different, only then create a new contact
                
                String StgBCEmail;
                
                if (stgBCRec.EMAIL_ADDRESS__c != null && stgBCRec.EMAIL_ADDRESS__c != '')
                    StgBCEmail = GetSanitizedEmail(stgBCRec.EMAIL_ADDRESS__c);
                
                Contact ExistingContact;
                Oracle_Show_Booth__c Booth = MoCustBoothIdToBooth.get(stgBCRec.CUST_BTH_ID__c);
                
                if (StgBCEmail != null)
                {
                    //Retrieve the list of contacts that matches this email address. Note that
                    //since multiple contacts could be tied to the same email address, you have
                    //to check if these fields for the current contact in this loop (i.e. the 
                    //staging table contact): Email, First name and Last name match the contact. 
                    //Since execution is already inside this loop, it means email field is already
                    //matched.
                    //
                    //If there is no matching contact based on email, first name and last name,
                    //ExistingContact should be null.
                    
                    //List is created with upper case value for key field (email)
                    Contact LoCon = moCustContactEmailToLoContact.get(StgBCEmail.toUpperCase());
                    
                    if (LoCon != null)// && LoCon.size() > 0)
                    {
                        
                        if (LoCon.FirstName != null && LoCon.FirstName.toUpperCase() == stgBCRec.FIRST_NAME__c.toUpperCase() && LoCon.LastName.toUpperCase() == stgBCRec.LAST_NAME__c.toUpperCase())
                        {
                            
                            ExistingContact = LoCon;
                        }
                        
                        
                    }
                }else{
                    //SFDC-272 - Fixed duplicate contact when the email is blank - 05/14/24
                    String bAccUniqueKey = Booth.Account__c + '~' + stgBCRec.FIRST_NAME__c + '~' + stgBCRec.LAST_NAME__c;
                    List<Contact> lst_Cons = mapAccountIdToLoContact.get(bAccUniqueKey);
                    if(lst_Cons != null && lst_Cons.size() >0){
                        ExistingContact = lst_Cons.get(0);
                    }
                    //End-272
                }
                
                //The revised logic to determine an existing contact already addresses the
                //requirement to check/match based on Email, First Name and Last Name. So,
                //if ExistingContact is not null, it means a positive and definitive match.
                
                //If ExistingContact is null or empty, it means there is no contact in the database
                //that has same Email, First Name and Last Name as the staging table booth contact 
                //record.
                
                if (ExistingContact == null)
                {
                    //New Contact's address should be the same as the address of customer tied to the Booth. 
                    //Therefore, retrieve Account Address From Booth Account
                    
                    if (Booth != null && Booth.Account__c != null)
                    {                       
                        Contact Cont = new Contact();
                        
                        Cont.FirstName =  stgBCRec.FIRST_NAME__c;
                        Cont.LastName = stgBCRec.LAST_NAME__c;
                        
                        string CountryCode = stgBCRec.COUNTRY_CODE__c;
                        string AreaCode = string.valueOf(Integer.valueOf(stgBCRec.AREA_CODE__c));
                        string Phone = '';
                        
                        if (CountryCode != null)
                            Phone = '+' + CountryCode;
                        else
                            Phone = '+1';
                        
                        if (AreaCode != null)
                            Phone = Phone + AreaCode;
                        
                        Phone = Phone + stgBCRec.PHONE__c;
                        
                        Cont.Phone = Phone;
                        Cont.Fax = stgBCRec.FAX__c;
                        
                        /*
JV 09/16/2013: Database column length for email is going to increase
to 256 characters in Oracle eBusiness Suite. However, Salesforce
contact email length cannot be increased - it is 80 chars long. So, 
in order to create a new contact, check if email length is more than
80. If it is, truncate email.
*/
                        
                        if (StgBCEmail != null)                                 
                            Cont.Email = GetTruncatedEmail(StgBCEmail);
                        
                        Cont.MailingStreet = Booth.Account__r.BillingStreet;
                        Cont.MailingCity = Booth.Account__r.BillingCity;
                        Cont.MailingState = Booth.Account__r.BillingState;
                        Cont.MailingPostalCode = Booth.Account__r.BillingPostalCode;
                        Cont.MailingCountry = Booth.Account__r.BillingCountry;
                        Cont.AccountId = Booth.Account__c;
                        Cont.Source__c = 'CORE';
                        
                        // If duplicate new Contacts exist within the same batch, then de-duplicate.
                        // However, create a reference (map) of this stage booth contact to existing contact
                        // De-duplication is possible only if Email is not null and not blank. If blank, then
                        // always create a new contact
                        
                        if (Cont.Email != null && Cont.Email != '')
                        {
                            //SFDC-196 - created new UniqueKey field for allowing to create new contact if email,firstname,lastname is not equal Fixed duplicate contact - 11/27/23 - Sajid
                            String uniqueKey = Cont.Email + '~' + Cont.FirstName + '~' + Cont.LastName;
                            String accUniqueKey = Booth.Account__c +'~'+Cont.Email;
                            if (!MoExistingBCEmailToNewContact.containsKey(uniqueKey))
                            {
                                if(!MoExistingAccEmailToNewContact.containsKey(accUniqueKey)){
                                    LoNewContacts.add(Cont);
                                    MoExistingBCSfIdToNewContact.put(bc.Id, Cont);
                                    MoExistingAccEmailToNewContact.put(accUniqueKey, Cont);
                                }else{
                                    MoExistingBCSfIdToNewContact.put(bc.Id, MoExistingAccEmailToNewContact.get(accUniqueKey)); 
                                }
                                MoExistingBCEmailToNewContact.put(uniqueKey, Cont);
                                moCustContactEmailToLoContact.put(Cont.Email.toUpperCase(), Cont); //SFDC-196 - adding new created contact into this field to keep this upto date - 11/27/23 - Sajid
                            }
                            else //If Contact is duplicate, then retrieve the Contact from the MoExistingBCEmailToNewContact map
                            {
                                MoExistingBCSfIdToNewContact.put(bc.Id, MoExistingBCEmailToNewContact.get(uniqueKey));                             
                            }
                        }
                        else //If Email is null, always create a new contact
                        {
                            //SFDC-272 - Fixed duplicate contact when the email is blank - 05/14/24
                            String boothAccUniqueKey = Booth.Account__c + '~' + Cont.FirstName + '~' + Cont.LastName;
                            System.debug('boothAccUniqueKey:: '+boothAccUniqueKey);
                            if(!MoExistingBoothAccToNewContact.containsKey(boothAccUniqueKey)){
                                System.debug('IF boothAccUniqueKey:: ');
                                LoNewContacts.add(Cont);
                                MoExistingBCSfIdToNewContact.put(bc.Id, Cont);
                                MoExistingBoothAccToNewContact.put(boothAccUniqueKey,Cont);
                                mapAccountIdToLoContact.put(boothAccUniqueKey,new List<Contact>{Cont});
                            }else{
                                System.debug('ELSE boothAccUniqueKey:: ');
                                MoExistingBCSfIdToNewContact.put(bc.Id, MoExistingBoothAccToNewContact.get(boothAccUniqueKey));
                            }
                            //LoNewContacts.add(Cont);
                            //MoExistingBCSfIdToNewContact.put(bc.Id, Cont);
                            
                            //End SFDC-272
                        }
                        
                    } 
                    /*
else Contact cannot be created as address cannot be specifed since Booth 
does not have Account Information.
*/
                } // If ExistingContact is not null and AccountId on it is null, then update it to Account on Booth
                else
                {
                    if (ExistingContact != null && ExistingContact.AccountId == null)
                    {
                        SoConIdsForContactFieldUpdate.add(ExistingContact.Id);
                        MoConIdToAccountIdForContactFieldUpdate.put(ExistingContact.Id, MoCustBoothIdToBooth.get(stgBCRec.CUST_BTH_ID__c).Account__c);
                    }
                    
                    /*
Execution of this piece of code indicates a matching contact was found based on the 
match between First Name, Last Name and Email. Therefore, it may make sense to check
if this Contact is the same as the Contact currently specified on this Booth Contact.
This verification would need to occur in the "UpdateBoothContacts" method and in order
to support it, another list of Booth Contact Id to Contact needs to be built in this
place. 
*/
                    
                    moExistingBCSfIdToExistingContact.put(bc.Id, ExistingContact);
                }
                
            } // end if BoothId == null
        } // end for 
        
        if (LoNewContacts.size() > 0){
            Database.insert(LoNewContacts, false);
        }
        
        /*
***********************************************************        
Start: Update AccountId field (if null) of existing Contacts
***********************************************************
*/
        
        list<Contact> LoContactsToUpdate = [Select Id, AccountId From Contact Where Id In :SoConIdsForContactFieldUpdate];
        
        for(Contact Con: LoContactsToUpdate)
        {
            if (Con.AccountId == null)
            {
                Con.AccountId = MoConIdToAccountIdForContactFieldUpdate.get(Con.Id);
            }
        }
        
        if (LoContactsToUpdate.size() > 0)        
            Database.update(LoContactsToUpdate, false);
        
        return MoExistingBCSfIdToNewContact;    
    }    
    
    private Contact GetNewContactObject(Staging_Oracle_Show_Booth_Contact__c stgBCRec, string stgBCEmail, Oracle_Show_Booth__c bth, string source)
    {
        Contact Cont = new Contact();
        Cont.FirstName =  stgBCRec.FIRST_NAME__c;
        Cont.LastName = stgBCRec.LAST_NAME__c;
        
        string CountryCode = stgBCRec.COUNTRY_CODE__c;
        string AreaCode = string.valueOf(Integer.valueOf(stgBCRec.AREA_CODE__c));
        string Phone = '';
        
        if (CountryCode != null)
            Phone = '+' + CountryCode;
        else
            Phone = '+1';
        
        if (AreaCode != null)
            Phone = Phone + AreaCode;
        
        Phone = Phone + stgBCRec.PHONE__c;
        
        Cont.Phone = Phone;
        Cont.Fax = stgBCRec.FAX__c;
        
        if (stgBCEmail != null)
            Cont.Email = stgBCEmail;
        
        Cont.MailingStreet = bth.Account__r.BillingStreet;
        Cont.MailingCity = bth.Account__r.BillingCity;
        Cont.MailingState = bth.Account__r.BillingState;
        Cont.MailingPostalCode = bth.Account__r.BillingPostalCode;
        Cont.MailingCountry = bth.Account__r.BillingCountry;
        
        Cont.AccountId = bth.Account__c;
        Cont.Source__c = source;
        
        return Cont;
    }
    
    private void UpdateBoothPrimaryContactInfo(Set<Id> soBCIdsInserted, Set<Id> soBCIdsUpdated)
    {
        set<id> SoBoothIds = new set<id>();
        
        if (soBCIdsInserted.size() > 0)
        {
            list<Oracle_Show_Booth_Contact__c> LoBCi = [Select Id, Oracle_Show_Booth__c From Oracle_Show_booth_Contact__c Where Id In :soBCIdsInserted];
            
            for(Oracle_Show_Booth_Contact__c bci: LoBCi)
            {
                if (!SoBoothIds.contains(bci.Oracle_Show_Booth__c))
                {
                    SoBoothIds.add(bci.Oracle_Show_Booth__c);
                }
            }           
        }
        
        if (soBCIdsUpdated.size() > 0)
        {
            list<Oracle_Show_Booth_Contact__c> LoBCu = [Select Id, Oracle_Show_Booth__c From Oracle_Show_booth_Contact__c Where Id In :soBCIdsUpdated];
            
            for(Oracle_Show_Booth_Contact__c bcu: LoBCu)
            {            
                if (!SoBoothIds.contains(bcu.Oracle_Show_Booth__c))
                {
                    SoBoothIds.add(bcu.Oracle_Show_Booth__c);
                }
            }           
        }
        
        map<id, Oracle_Show_Booth_Contact__c> MoPrimaryBoothContacts = new map<id, Oracle_Show_Booth_Contact__c>();
        
        // Generate a list of Booth Contacts for all Booths. Need to query this way to prevent DML Governor 
        // Limit exception. Would have preferred to get this list one-at-a-time for each booth.
        
        List<Oracle_Show_Booth_Contact__c> LoBoothContacts = [Select Id, Oracle_Show_Booth__c, CUST_CONT_ID__c, FIRST_NAME__c, LAST_NAME__c, EMAIL__c, COUNTRY_CODE__c, AREA_CODE__c, PHONE__c, EXTENSION__c, FAX__c, PRIMARY_FLAG__c From Oracle_Show_Booth_Contact__c Where Oracle_Show_Booth__c In :SoBoothIds];
        
        for (id boothId : SoBoothIds)
        {           
            // For this Booth, extract the BoothContacts from the list LoBoothContacts
            list<Oracle_Show_Booth_Contact__c> LoBoothContactsForThisBooth = new list<Oracle_Show_Booth_Contact__c>();
            
            for (Oracle_Show_Booth_Contact__c bthContact : LoBoothContacts)
            {
                if (bthContact.Oracle_Show_Booth__c == boothId)
                    LoBoothContactsForThisBooth.add(bthContact);
            }
            
            for (Oracle_Show_Booth_Contact__c boothContact : LoBoothContactsForThisBooth)
            {           
                if (boothContact.PRIMARY_FLAG__c == 'Y')
                {
                    MoPrimaryBoothContacts.put(boothId, boothContact);
                    break;
                }
            }
            
            // If no, Booth Contact is marked primary, set the first Booth Contact as primary
            // in SFDC
            if (!MoPrimaryBoothContacts.containsKey(boothId) && !LoBoothContactsForThisBooth.isEmpty())
            {
                MoPrimaryBoothContacts.put(boothId, LoBoothContactsForThisBooth[0]);
            }
        }
        
        List<Oracle_Show_Booth__c> LoBooths = [Select Id, CUST_CONT_ID__c, CONTACT_FIRST_NAME__c, CONTACT_LAST_NAME__c, CONTACT_EMAIL__c, CONTACT_PHONE_COUNTRY_CODE__c, CONTACT_PHONE_AREA_CODE__c, CONTACT_PHONE__c, CONTACT_PHONE_EXTENSION__c, CONTACT_FAX__c From Oracle_Show_Booth__c Where Id In :SoBoothIds];
        List<Oracle_Show_Booth__c> LoBoothsForUpdate = new List<Oracle_Show_Booth__c>();
        
        for(Oracle_Show_Booth__c booth: LoBooths)
        {           
            Oracle_Show_Booth_Contact__c BoothContact = MoPrimaryBoothContacts.get(booth.Id);
            
            if (BoothContact != null)
            {
                booth.CUST_CONT_ID__c = BoothContact.CUST_CONT_ID__c;
                booth.CONTACT_FIRST_NAME__c = BoothContact.FIRST_NAME__c;
                booth.CONTACT_LAST_NAME__c = BoothContact.LAST_NAME__c;
                
                if (BoothContact.EMAIL__c != null)
                    booth.CONTACT_EMAIL__c = GetSanitizedEmail(BoothContact.EMAIL__c);
                
                booth.CONTACT_PHONE_COUNTRY_CODE__c = BoothContact.COUNTRY_CODE__c;
                booth.CONTACT_PHONE_AREA_CODE__c = BoothContact.AREA_CODE__c;
                booth.CONTACT_PHONE__c = BoothContact.PHONE__c;
                booth.CONTACT_PHONE_EXTENSION__c = BoothContact.EXTENSION__c;
                booth.CONTACT_FAX__c = BoothContact.FAX__c;
                
                LoBoothsForUpdate.add(booth);
            }
        }
        
        if (LoBoothsForUpdate.size() > 0)
            Database.update(LoBoothsForUpdate, false);
    }    
    
    global void finish(Database.BatchableContext BC)
    {      
    }           
    
}