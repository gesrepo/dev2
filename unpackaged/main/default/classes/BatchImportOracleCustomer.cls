global class BatchImportOracleCustomer implements Database.Batchable<SObject>, Database.Stateful {

    public String query; 

    global database.querylocator start(Database.BatchableContext BC){return Database.getQueryLocator(query);}
        
    global void execute(Database.BatchableContext BC, Sobject[] scope){
    
        /* START: IMPORT CUSTOMER */
        
        // Retrieve the list of Customers in Staging Table and build a collection. Using this collection, 
        // determine which customers already exist vs which ones are new.
        List<Staging_Oracle_AR_Customer__c> LoCustomersInStagingTable = new List<Staging_Oracle_AR_Customer__c>();
        
        for(SObject s: scope)
        {
            LoCustomersInStagingTable.add((Staging_Oracle_AR_Customer__c)s);
        }
        
        // Since the list of Customers in Staging Table also have addresses, a Set needs to be defined to 
        // determine the unique list of customers.
        set<string> SoAllStageCustAccountId = new set<string>();
        set<string> SoProcessedStageCustAccountId = new set<string>();
        set<id> SoAllStageCustId = new set<id>();
        
        // Build another collection of unique Customers from the Staging customers list. Each 
        // Staging_Oracle_AR_Customer__c object in this collection has only customer information 
        // (no site/address) fields populated.
        List<Staging_Oracle_AR_Customer__c> LoImportCustomers = new List<Staging_Oracle_AR_Customer__c>();
        
        // Create a map of Staging_Oracle_AR_Customer__c object created in the prior step to AR_CUST_ACCOUNT_ID__c.
        // So, if this field value is known, the corresponding staging customer object could be retrieved.
        map<string, Staging_Oracle_AR_Customer__c> MoImportCustomers = new map<string, Staging_Oracle_AR_Customer__c>();

        for(Staging_Oracle_AR_Customer__c stageCustomer: LoCustomersInStagingTable)
        {
            if (!SoAllStageCustAccountId.contains(stageCustomer.AR_CUST_ACCOUNT_ID__c))
            {
                SoAllStageCustId.add(stageCustomer.Id);
                SoAllStageCustAccountId.add(stageCustomer.AR_CUST_ACCOUNT_ID__c);
                
                LoImportCustomers.add(stageCustomer);                
                MoImportCustomers.put(stageCustomer.AR_CUST_ACCOUNT_ID__c, stageCustomer);
            }
        }
        system.debug('**********SoAllStageCustId.size()=='+SoAllStageCustId.size());
        // Once the unique list of customers for import is created, split this list into two separate lists, 
        // one for insert and one for update.
        List<Account> LoAccountsForInsert = new List<Account>();
        List<Account> LoAccountsForUpdate = new List<Account>();
        
        // This feed creates only 'Exhibitor' record type accounts
        RecordType ExbRT = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Exhibitor'];
        id ExbRTId = ExbRT.Id;
        
        List<Staging_Oracle_AR_Customer__c> LoStageCustomersInsert = new List<Staging_Oracle_AR_Customer__c>();
        List<Staging_Oracle_AR_Customer__c> LoStageCustomersUpdate = new List<Staging_Oracle_AR_Customer__c>();     
        
        // Retrieve the list of Accounts that already exist based on Set SoAllStageCustAccountId. Also,
        // based on this list determine the set which does not exist (i.e. Customers which need to be inserted).
        List<Account> LoExistingAccounts = [Select Id, ORACLE_AR_CUST_ACCOUNT_ID__c, ORACLE_AR_CUST_NUMBER__c, GES_Master_Customer_Number__c, Name, DUNS_Number__c, ORACLE_AR_CUST_LAST_UPDATE_DATE__c, ORACLE_AR_CUST_STATUS__c, Phone, BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode From Account Where ORACLE_AR_CUST_ACCOUNT_ID__c In : SoAllStageCustAccountId];
        // system.debug('**********LoExistingAccounts.size()=='+LoExistingAccounts.size());
        /*// Add by kumud 
        List<AR_Customer_Info__c> listARCustomerInfo =new List<AR_Customer_Info__c>();
        listARCustomerInfo=[Select Oracle_AR_Customer_ID__c,Account__c from AR_Customer_Info__c where Oracle_AR_Customer_ID__c in : SoAllStageCustAccountId];
        system.debug('==========listARCustomerInfo.size()=='+listARCustomerInfo.size());
        Map<Id,Account> mapIDAccount=new Map<Id,Account>();
        Set<Id> setAccountId=new Set<ID>();
               
        for(AR_Customer_Info__c instARCS:listARCustomerInfo){
                        
                setAccountId.add(instARCS.Account__c);
                        
        }
        system.debug('==========setAccountId.size()=='+setAccountId.size());
        for(Account instAcc:[Select Id, ORACLE_AR_CUST_ACCOUNT_ID__c, ORACLE_AR_CUST_NUMBER__c, GES_Master_Customer_Number__c, Name, DUNS_Number__c, ORACLE_AR_CUST_LAST_UPDATE_DATE__c, ORACLE_AR_CUST_STATUS__c, Phone, BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode From Account where id in :setAccountId]){
                        
                        mapIDAccount.put(instAcc.id,instAcc);
        }
        system.debug('==========mapIDAccount.size()=='+mapIDAccount.size());
        //End here */
        set<string> SoStageCustAccountIdForUpdate = new set<string>();
        //Set<Id> setStagingARCSId=new Set<Id>();
        for(Account accnt: LoExistingAccounts)
        {
            //system.debug('**********Inside for LoExistingAccounts.size()=='+LoExistingAccounts.size());
            Staging_Oracle_AR_Customer__c UpdateCustomer = MoImportCustomers.get(accnt.ORACLE_AR_CUST_ACCOUNT_ID__c);
            //setStagingARCSId.add(UpdateCustomer.id);
            LoStageCustomersUpdate.add(UpdateCustomer);
            
            accnt.ORACLE_AR_CUST_ACCOUNT_ID__c = UpdateCustomer.AR_CUST_ACCOUNT_ID__c;
            // Master Customer Number may have changed in Oracle, update it
            accnt.ORACLE_AR_CUST_NUMBER__c = UpdateCustomer.AR_CUSTOMER_NUMBER__c;
            accnt.GES_Master_Customer_Number__c = UpdateCustomer.AR_CUSTOMER_NUMBER__c;
            
            // Name may have been modified in Oracle, update it
            accnt.Name = UpdateCustomer.AR_CUSTOMER_NAME__c;
            
            // DUNS Number may have changed in Oracle, update it (cleanup, de-duplication etc)
            accnt.DUNS_Number__c = (UpdateCustomer.AR_CUSTOMER_DUNS_NUMBER__c == null ? null : UpdateCustomer.AR_CUSTOMER_DUNS_NUMBER__c.format());
             //accnt.DUNSNumber=Accnt.DUNS_Number__c!=null?accnt.DUNS_Number__c.replaceAll(',','').trim():accnt.DUNS_Number__c;
            //system.debug('==========accnt.DUNSNumber=='+accnt.DUNSNumber);
            // Last time it was modified in Oracle may have changed so update it
            //accnt.ORACLE_AR_CUST_CREATION_DATE__c = UpdateCustomer.AR_CUST_CREATION_DATE__c;
            accnt.ORACLE_AR_CUST_LAST_UPDATE_DATE__c = UpdateCustomer.AR_CUST_LAST_UPDATE_DATE__c;
            
            // Status may have changed in Oracle, so update it
            accnt.ORACLE_AR_CUST_STATUS__c = UpdateCustomer.AR_CUST_STATUS__c;
            
            // Update Phone# field, only if it is null in existing record
            if (accnt.Phone == null || accnt.Phone == '')
                accnt.Phone = '000-000-0000';
            
            // Update Billing address only if any of the required fields is null, update
            // Billing address to whatever is in the staging table.
            if (accnt.BillingStreet == null || accnt.BillingStreet == '' || 
                accnt.BillingCity == null || accnt.BillingCity == '' ||
                accnt.BillingState == null || accnt.BillingState == '' ||
                accnt.BillingPostalCode == null || accnt.BillingPostalCode == '')
            {
                accnt.BillingStreet = UpdateCustomer.AR_CUSTOMER_ADDRESS1__c + (UpdateCustomer.AR_CUSTOMER_ADDRESS2__c == null ? '' : ' ' + UpdateCustomer.AR_CUSTOMER_ADDRESS2__c) + (UpdateCustomer.AR_CUSTOMER_ADDRESS3__c == null ? '' : ' ' + UpdateCustomer.AR_CUSTOMER_ADDRESS3__c)+ (UpdateCustomer.AR_CUSTOMER_ADDRESS4__c == null ? '' : ' ' + UpdateCustomer.AR_CUSTOMER_ADDRESS4__c );          
                        
                accnt.BillingCity = UpdateCustomer.AR_CUSTOMER_CITY__c ;
                accnt.BillingState = UpdateCustomer.AR_CUSTOMER_STATE__c ;
                
                accnt.BillingCountry = UpdateCustomer.AR_CUSTOMER_COUNTRY__c;
                string PostalCode = UpdateCustomer.AR_CUSTOMER_POSTAL_CODE__c;
                
                if (accnt.BillingCountry.toUpperCase() == 'USA' || accnt.BillingCountry.toUpperCase() == 'US')
                {
                    if (PostalCode != null)
                    {
                        if (PostalCode.length() == 5)
                            Postalcode += '-0000';
                    }
                    else
                    {
                        Postalcode = '00000-0000';
                    }
                }
                else
                {
                    if (PostalCode == null || PostalCode.length() == 0)
                        Postalcode = '00000';               
                }
                    
                accnt.BillingPostalCode = PostalCode;
            }
            
            // If Existing customer, no need to change the relationship type and record type
            // accnt.Relationship_Type__c = 'Customer';
            // accnt.RecordTypeId = ExbRTId;
            
            SoStageCustAccountIdForUpdate.add(accnt.ORACLE_AR_CUST_ACCOUNT_ID__c);
            SoProcessedStageCustAccountId.add(accnt.ORACLE_AR_CUST_ACCOUNT_ID__c);
            LoAccountsForUpdate.add(accnt);
        } // end of loop
         system.debug('***********SoProcessedStageCustAccountId.size(Acnt UPD)=='+SoProcessedStageCustAccountId.size()); 
         //system.debug('***********LoAccountsForUpdate.size()=='+LoAccountsForUpdate.size());      
         //system.debug('==========setStagingARCSId=='+setStagingARCSId);      
        // Add by Gaurav to update NUR status related to Accounts of AR Customer Info
        List<Staging_Oracle_AR_Customer__c> LoStageARCustomersUpdate = new List<Staging_Oracle_AR_Customer__c>(); 
        for(AR_Customer_Info__c instARCS:[Select Oracle_AR_Customer_ID__c,Account__c from AR_Customer_Info__c where Oracle_AR_Customer_ID__c in : SoAllStageCustAccountId]){
                  // system.debug('********************'+instARCS);                           
            Staging_Oracle_AR_Customer__c UpdateARCustomer = MoImportCustomers.get(instARCS.Oracle_AR_Customer_ID__c);
           // system.debug('**********UpdateARCustomer.id**********'+UpdateARCustomer.id); 
            UpdateARCustomer.Interface_Status__c = 'Acc: NUR';
            SoStageCustAccountIdForUpdate.add(instARCS.Oracle_AR_Customer_ID__c);
            SoProcessedStageCustAccountId.add(instARCS.Oracle_AR_Customer_ID__c);
            LoStageARCustomersUpdate.add(UpdateARCustomer);
            }
            system.debug('***********SoProcessedStageCustAccountId.size(AR UPD)=='+SoProcessedStageCustAccountId.size());
            //system.debug('**********LoStageARCustomersUpdate.size()**********'+LoStageARCustomersUpdate.size());
            //  add by kumud --> Commenting as Account info update from AR Customer Info is not required
            /*
            Account accnt=mapIDAccount.get(instARCS.Account__C);

            accnt.ORACLE_AR_CUST_ACCOUNT_ID__c = UpdateCustomer.AR_CUST_ACCOUNT_ID__c;
            // Master Customer Number may have changed in Oracle, update it
            accnt.ORACLE_AR_CUST_NUMBER__c = UpdateCustomer.AR_CUSTOMER_NUMBER__c;
            accnt.GES_Master_Customer_Number__c = UpdateCustomer.AR_CUSTOMER_NUMBER__c;
            
            // Name may have been modified in Oracle, update it
            accnt.Name = UpdateCustomer.AR_CUSTOMER_NAME__c;
            
            // DUNS Number may have changed in Oracle, update it (cleanup, de-duplication etc)
            accnt.DUNS_Number__c = (UpdateCustomer.AR_CUSTOMER_DUNS_NUMBER__c == null ? null : UpdateCustomer.AR_CUSTOMER_DUNS_NUMBER__c.format());
            //accnt.DUNSNumber=Accnt.DUNS_Number__c!=null?accnt.DUNS_Number__c.replaceAll(',','').trim():accnt.DUNS_Number__c;
            //system.debug('==========accnt.DUNSNumber=='+accnt.DUNSNumber);
            // Last time it was modified in Oracle may have changed so update it
            //accnt.ORACLE_AR_CUST_CREATION_DATE__c = UpdateCustomer.AR_CUST_CREATION_DATE__c;
            accnt.ORACLE_AR_CUST_LAST_UPDATE_DATE__c = UpdateCustomer.AR_CUST_LAST_UPDATE_DATE__c;
            
            // Status may have changed in Oracle, so update it
            accnt.ORACLE_AR_CUST_STATUS__c = UpdateCustomer.AR_CUST_STATUS__c;
            
            // Update Phone# field, only if it is null in existing record
            if (accnt.Phone == null || accnt.Phone == '')
                accnt.Phone = '000-000-0000';
            
            // Update Billing address only if any of the required fields is null, update
            // Billing address to whatever is in the staging table.
            if (accnt.BillingStreet == null || accnt.BillingStreet == '' || 
                accnt.BillingCity == null || accnt.BillingCity == '' ||
                accnt.BillingState == null || accnt.BillingState == '' ||
                accnt.BillingPostalCode == null || accnt.BillingPostalCode == '')
            {
                accnt.BillingStreet = UpdateCustomer.AR_CUSTOMER_ADDRESS1__c + (UpdateCustomer.AR_CUSTOMER_ADDRESS2__c == null ? '' : ' ' + UpdateCustomer.AR_CUSTOMER_ADDRESS2__c) + (UpdateCustomer.AR_CUSTOMER_ADDRESS3__c == null ? '' : ' ' + UpdateCustomer.AR_CUSTOMER_ADDRESS3__c)+ (UpdateCustomer.AR_CUSTOMER_ADDRESS4__c == null ? '' : ' ' + UpdateCustomer.AR_CUSTOMER_ADDRESS4__c );          
                        
                accnt.BillingCity = UpdateCustomer.AR_CUSTOMER_CITY__c ;
                accnt.BillingState = UpdateCustomer.AR_CUSTOMER_STATE__c ;
                
                accnt.BillingCountry = UpdateCustomer.AR_CUSTOMER_COUNTRY__c;
                string PostalCode = UpdateCustomer.AR_CUSTOMER_POSTAL_CODE__c;
                
                if (accnt.BillingCountry.toUpperCase() == 'USA' || accnt.BillingCountry.toUpperCase() == 'US')
                {
                    if (PostalCode != null)
                    {
                        if (PostalCode.length() == 5)
                            Postalcode += '-0000';
                    }
                    else
                    {
                        Postalcode = '00000-0000';
                    }
                }
                else
                {
                    if (PostalCode == null || PostalCode.length() == 0)
                        Postalcode = '00000';               
                }
                    
                accnt.BillingPostalCode = PostalCode;
            }
            
            // If Existing customer, no need to change the relationship type and record type
            // accnt.Relationship_Type__c = 'Customer';
            // accnt.RecordTypeId = ExbRTId;
            system.debug('**********'+SoStageCustAccountIdForUpdate);
            if(!SoStageCustAccountIdForUpdate.contains(instARCS.Oracle_AR_Customer_ID__c)){
                   system.debug('*******inside if'+SoStageCustAccountIdForUpdate);
                   SoStageCustAccountIdForUpdate.add(instARCS.Oracle_AR_Customer_ID__c); 
                   LoAccountsForUpdate.add(accnt);
            }
          
           
        } // end loop
                */
       

          set<string> SoStageCustAccountIdForInsert = new set<string>();
        
        for(string custAccountId : SoAllStageCustAccountId)
        {
            if (!SoStageCustAccountIdForUpdate.contains(custAccountId))
                SoStageCustAccountIdForInsert.add(custAccountId);
        }
        
        for(string custAccountId : SoStageCustAccountIdForInsert)
        {
            SoProcessedStageCustAccountId.add(custAccountId);
            Staging_Oracle_AR_Customer__c InsertCustomer = MoImportCustomers.get(custAccountId);
            LoStageCustomersInsert.add(InsertCustomer);
            
            Account Accnt = new Account();
            Accnt.ORACLE_AR_CUST_ACCOUNT_ID__c = InsertCustomer.AR_CUST_ACCOUNT_ID__c;
            Accnt.ORACLE_AR_CUST_NUMBER__c = InsertCustomer.AR_CUSTOMER_NUMBER__c;
            Accnt.GES_Master_Customer_Number__c = InsertCustomer.AR_CUSTOMER_NUMBER__c;
            Accnt.Name = InsertCustomer.AR_CUSTOMER_NAME__c;
            Accnt.DUNS_Number__c = (InsertCustomer.AR_CUSTOMER_DUNS_NUMBER__c == null ? null : InsertCustomer.AR_CUSTOMER_DUNS_NUMBER__c.format());
            //Accnt.DUNSNumber=Accnt.DUNS_Number__c!=null?Accnt.DUNS_Number__c.replaceAll(',','').trim():Accnt.DUNS_Number__c;
            //system.debug('*******Accnt.DUNSNumber****'+Accnt.DUNSNumber);
            Accnt.ORACLE_AR_CUST_CREATION_DATE__c = InsertCustomer.AR_CUST_CREATION_DATE__c;
            Accnt.ORACLE_AR_CUST_LAST_UPDATE_DATE__c = InsertCustomer.AR_CUST_LAST_UPDATE_DATE__c;
            Accnt.ORACLE_AR_CUST_STATUS__c = InsertCustomer.AR_CUST_STATUS__c;
            
            Accnt.Phone = '000-000-0000';
            Accnt.BillingStreet = InsertCustomer.AR_CUSTOMER_ADDRESS1__c + (InsertCustomer.AR_CUSTOMER_ADDRESS2__c == null ? '' : ' ' + InsertCustomer.AR_CUSTOMER_ADDRESS2__c) + (InsertCustomer.AR_CUSTOMER_ADDRESS3__c == null ? '' : ' ' + InsertCustomer.AR_CUSTOMER_ADDRESS3__c)+ (InsertCustomer.AR_CUSTOMER_ADDRESS4__c == null ? '' : ' ' + InsertCustomer.AR_CUSTOMER_ADDRESS4__c ); 
            Accnt.BillingCity = InsertCustomer.AR_CUSTOMER_CITY__c ;
            Accnt.BillingState = InsertCustomer.AR_CUSTOMER_STATE__c ;
            
            Accnt.BillingCountry = InsertCustomer.AR_CUSTOMER_COUNTRY__c;
            string PostalCode = InsertCustomer.AR_CUSTOMER_POSTAL_CODE__c;
            
            if (accnt.BillingCountry.toUpperCase() == 'USA' || accnt.BillingCountry.toUpperCase() == 'US')
            {
                if (PostalCode != null)
                {
                    if (PostalCode.length() == 5)
                        Postalcode += '-0000';
                }
                else
                {
                    Postalcode = '00000-0000';
                }
            }
            else
            {
                if (PostalCode == null || PostalCode.length() == 0)
                    Postalcode = '00000';               
            }
                
            Accnt.BillingPostalCode = PostalCode;            
            
            Accnt.Relationship_Type__c = 'Customer';
            Accnt.RecordTypeId = ExbRTId;       
            
            LoAccountsForInsert.add(Accnt);
        }
        system.debug('***********SoProcessedStageCustAccountId.size(Acnt Inst)=='+SoProcessedStageCustAccountId.size());
        List<Database.Saveresult> IR = Database.insert(LoAccountsForInsert, false);
        List<Database.Saveresult> UR = Database.update(LoAccountsForUpdate, false);    
        
        List<Staging_Oracle_AR_Customer__c> LoStageCustomersInsertStatus = new List<Staging_Oracle_AR_Customer__c>();
                
        integer InsertCount = 0;
        
        for(Database.Saveresult result : IR)
        {
            Staging_Oracle_AR_Customer__c InsertedCustomer = LoStageCustomersInsert[InsertCount];
            InsertedCustomer.Interface_Process_Attempts__c = (InsertedCustomer.Interface_Process_Attempts__c == null ? 0 : InsertedCustomer.Interface_Process_Attempts__c + 1);
            
            if (result.isSuccess())
            {
                InsertedCustomer.Interface_Status__c = 'Acc: I';
                InsertedCustomer.Interface_Error_Message__c = '';
            }
            else
            {
                InsertedCustomer.Interface_Status__c = 'Acc: IF';
                string ErrorMessage = '';
                for(Database.Error err : result.getErrors())
                {
                    ErrorMessage += err.getMessage();
                }
                
                InsertedCustomer.Interface_Error_Message__c = ErrorMessage;             
            }
            
            LoStageCustomersInsertStatus.add(InsertedCustomer);
            
            InsertCount++;
        }
        
        if (LoStageCustomersInsertStatus.size() > 0)
            Database.update(LoStageCustomersInsertStatus, false);
        
        List<Staging_Oracle_AR_Customer__c> LoStageCustomersUpdateStatus = new List<Staging_Oracle_AR_Customer__c>();
        
        integer UpdateCount = 0;
        
        
        for(Database.Saveresult result : UR)
        {
            Staging_Oracle_AR_Customer__c UpdatedCustomer = LoStageCustomersUpdate[UpdateCount];
            UpdatedCustomer.Interface_Process_Attempts__c = (UpdatedCustomer.Interface_Process_Attempts__c == null ? 0 : UpdatedCustomer.Interface_Process_Attempts__c + 1);
            
            if (result.isSuccess())
            {
                UpdatedCustomer.Interface_Status__c = 'Acc: U';
                UpdatedCustomer.Interface_Error_Message__c = '';
            }
            else
            {
                UpdatedCustomer.Interface_Status__c = 'Acc: UF';
                string ErrorMessage = '';
                for(Database.Error err : result.getErrors())
                {
                    ErrorMessage += err.getMessage();
                }
                
                UpdatedCustomer.Interface_Error_Message__c = ErrorMessage;              
            }
            
            LoStageCustomersUpdateStatus.add(UpdatedCustomer);
                        
            UpdateCount++;
        }
        
        if (LoStageCustomersUpdateStatus.size() > 0)
            Database.update(LoStageCustomersUpdateStatus, false); 
        
        if (LoStageARCustomersUpdate.size() > 0)
            Database.update(LoStageARCustomersUpdate, false); 
        
         set<string> SoUnProcessedStageCustAccountId = new set<string>();
        system.debug('***********SoAllStageCustAccountId.size(Last)=='+SoAllStageCustAccountId.size());
        system.debug('***********SoProcessedStageCustAccountId.size(Last)=='+SoProcessedStageCustAccountId.size());
        for(string custAccntId : SoAllStageCustAccountId)
        {
            if (!SoProcessedStageCustAccountId.contains(custAccntId))
                SoUnProcessedStageCustAccountId.add(custAccntId);
        }
        system.debug('***********SoUnProcessedStageCustAccountId.size()=='+SoUnProcessedStageCustAccountId.size());
         List<Staging_Oracle_AR_Customer__c> LoStageUnProcessedStageUpdate = new List<Staging_Oracle_AR_Customer__c>(); 
         for(string custStgAccountId : SoUnProcessedStageCustAccountId)
        {
            Staging_Oracle_AR_Customer__c UpdCustomer = MoImportCustomers.get(custStgAccountId);
            UpdCustomer.Interface_Status__c = 'Acc: NUR';
            LoStageUnProcessedStageUpdate.add(UpdCustomer);
            
        }   
        system.debug('***********LoStageUnProcessedStageUpdate.size(Last)=='+LoStageUnProcessedStageUpdate.size());
        if (LoStageUnProcessedStageUpdate.size() > 0)
            Database.update(LoStageUnProcessedStageUpdate, false);
        
        /* END: IMPORT CUSTOMER */
        
    }
   
    global void finish(Database.BatchableContext BC)
    {      
    }
}