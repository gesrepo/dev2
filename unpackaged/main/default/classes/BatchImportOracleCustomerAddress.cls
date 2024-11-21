global class BatchImportOracleCustomerAddress implements Database.Batchable<SObject>, Database.Stateful {

    public String query; 

    global database.querylocator start(Database.BatchableContext BC){return Database.getQueryLocator(query);}
        
    global void execute(Database.BatchableContext BC, Sobject[] scope){
        
        /* START: IMPORT CUSTOMER ADDRESS */
 
        // Retrieve the list of Customers in Staging Table and build a collection. Using this collection, 
        // determine which customers already exist vs which ones are new.
        List<Staging_Oracle_AR_Customer__c> LoCustomersInStagingTable = new List<Staging_Oracle_AR_Customer__c>();
        
        for(SObject s: scope)
        {
            LoCustomersInStagingTable.add((Staging_Oracle_AR_Customer__c)s);
        }
        
        // Create a Set of All Customer Site Ids in the Staging Table
        set<string> SoAllStageCustSiteId = new set<string>();
            
        // Create a map of Staging_Oracle_AR_Customer__c object created in the prior step to AR_ADDR_CUST_ACCT_SITE_ID__c.
        // So, if this field value is known, the corresponding staging customer address object could be retrieved.
        
        // While building this set, if duplicate rows (rows with same values in AR_ADDR_CUST_ACCT_SITE_ID__c column)
        // exists, they are excluded. The reason duplicates will exist because the query in CORE that retrieves
        // these rows joins with address detail tables (e.g. Site Use) which will cause multiple rows for the same
        // address location. 
        
        // The duplicate rows need to be marked as duplicate. Therefore, capture this list in the else portion of
        // the if-else statement below.
        map<string, Staging_Oracle_AR_Customer__c> MoImportAddresses = new map<string, Staging_Oracle_AR_Customer__c>();
        list<Staging_Oracle_AR_Customer__c> LoDuplicateStageAddresses = new list<Staging_Oracle_AR_Customer__c>();
                
        for(Staging_Oracle_AR_Customer__c stageAddress: LoCustomersInStagingTable)
        {
            if (!SoAllStageCustSiteId.contains(stageAddress.AR_ADDR_CUST_ACCT_SITE_ID__c))
            {
                SoAllStageCustSiteId.add(stageAddress.AR_ADDR_CUST_ACCT_SITE_ID__c);
                MoImportAddresses.put(stageAddress.AR_ADDR_CUST_ACCT_SITE_ID__c, stageAddress);
            }
            else
            {
                LoDuplicateStageAddresses.add(stageAddress);
            }
        }
        
        // Create a Set of Customer Ids. Use this set to create a map of Customer Account ID and Account Id (SFDC Id)
        // This reverse lookup is required to populate the "Account__c" field while inserting new addresses
        set<string> SoUniqueCustAccountId = new set<string>();
        for(SObject s: scope)
        {
            SoUniqueCustAccountId.add(((Staging_Oracle_AR_Customer__c)s).AR_CUST_ACCOUNT_ID__c);
        }
        
        // create a map of Customer Account ID and Account Id (SFDC Id)
        map<string, id> MoCustAcctIdToAccountId = new map<string, id>();
        //Change Id to String to fix invalid Id issue
       // map<Id,AR_Customer_Info__c> mapIDARCustomInfo=new map<Id,AR_Customer_Info__c>();
        map<string,AR_Customer_Info__c> mapIDARCustomInfo=new map<string,AR_Customer_Info__c>();
        List<Account> Accnts = [Select Id, ORACLE_AR_CUST_ACCOUNT_ID__c From Account Where ORACLE_AR_CUST_ACCOUNT_ID__c In :SoUniqueCustAccountId];
        
        for (Account acnt : Accnts)
        {
            MoCustAcctIdToAccountId.put(acnt.ORACLE_AR_CUST_ACCOUNT_ID__c, acnt.Id);
        }
         // Add by kumud : [Desc: Fetch AR Custom Info records]
        for(AR_Customer_Info__c instArcustom:[select AR_Customer_Number__c,Oracle_AR_Customer_ID__c,Master_Account_Name__c,Account__c,GBMS_ID__c from AR_Customer_Info__c where Oracle_AR_Customer_ID__c in:SoUniqueCustAccountId]){
        
            mapIDARCustomInfo.put(instArcustom.Oracle_AR_Customer_ID__c,instArcustom);
        
        }
        // End
        // Split collection of Addresses into two separate lists, one for update and another for insert
        List<Oracle_AR_Customer_Address__c> LoAddressesForInsert = new List<Oracle_AR_Customer_Address__c>();
        List<Oracle_AR_Customer_Address__c> LoAddressesForUpdate = new List<Oracle_AR_Customer_Address__c>();
            
        List<Staging_Oracle_AR_Customer__c> LoStageAddressesInsert = new List<Staging_Oracle_AR_Customer__c>();
        List<Staging_Oracle_AR_Customer__c> LoStageAddressesUpdate = new List<Staging_Oracle_AR_Customer__c>();     
        
        // Retrieve the list of Addresses that already exist based on Set SoAllStageCustSiteId. Also, based on 
        // this list determine the set which does not exist (i.e. Addresses which need to be inserted).
        List<Oracle_AR_Customer_Address__c> LoExistingAddresses = [Select Id, Account__c, AR_CUST_ACCT_SITE_ID__c From Oracle_AR_Customer_Address__c Where AR_CUST_ACCT_SITE_ID__c In : SoAllStageCustSiteId];
        
        set<string> SoStageCustSiteIdForUpdate = new set<string>();
        
        for(Oracle_AR_Customer_Address__c address: LoExistingAddresses)
        {
            Staging_Oracle_AR_Customer__c UpdateStageAddress = MoImportAddresses.get(address.AR_CUST_ACCT_SITE_ID__c);
            LoStageAddressesUpdate.add(UpdateStageAddress);
            
            //Account Acnt = [Select Id From Account Where ORACLE_AR_CUST_ACCOUNT_ID__c = : UpdateStageAddress.AR_CUST_ACCOUNT_ID__c];
            
            //address.Account__c = Acnt.Id;
            //address.Acocunt__c = MoCustAcctIdToAccountId.get(UpdateStageAddress.AR_CUST_ACCOUNT_ID__c);
            system.debug('-------------->address'+address);
            address.AR_CUST_ACCT_SITE_ID__c = UpdateStageAddress.AR_ADDR_CUST_ACCT_SITE_ID__c;
            address.AR_CUST_SITE_ADDRESS1__c = UpdateStageAddress.AR_CUSTOMER_ADDRESS1__c;
            address.AR_CUST_SITE_ADDRESS2__c = UpdateStageAddress.AR_CUSTOMER_ADDRESS2__c;
            address.AR_CUST_SITE_ADDRESS3__c = UpdateStageAddress.AR_CUSTOMER_ADDRESS3__c;
            address.AR_CUST_SITE_ADDRESS4__c = UpdateStageAddress.AR_CUSTOMER_ADDRESS4__c;
            address.AR_CUST_SITE_CITY__c = UpdateStageAddress.AR_CUSTOMER_CITY__c;
            address.AR_CUST_SITE_STATE__c = UpdateStageAddress.AR_CUSTOMER_STATE__c;
            address.AR_CUST_SITE_PROVINCE__c = UpdateStageAddress.AR_CUSTOMER_PROVINCE__c;
            address.AR_CUST_SITE_COUNTRY__c = UpdateStageAddress.AR_CUSTOMER_COUNTRY__c;
            address.AR_CUST_SITE_POSTAL_CODE__c = UpdateStageAddress.AR_CUSTOMER_POSTAL_CODE__c;
            address.AR_CUST_SITE_STATUS__c = UpdateStageAddress.AR_ADDR_CUST_SITE_STATUS__c;
            address.AR_CUST_SITE_CREATION_DATE__c = UpdateStageAddress.AR_ADDR_CUST_SITE_CREATION_DATE__c;
            address.AR_CUST_SITE_LAST_UPDATE_DATE__c = UpdateStageAddress.AR_ADDR_CUST_SITE_LAST_UPDATE_DATE__c;
            
            address.AR_PARTY_SITE_LOC_ID__c = UpdateStageAddress.AR_ADDR_PARTY_SITE_LOC_ID__c;
            address.AR_PARTY_SITE_LOC_CREATION_DATE__c = UpdateStageAddress.AR_ADDR_PARTY_SITE_LOC_CREATION_DATE__c;
            address.AR_PARTY_SITE_LOC_LAST_UPDATE_DATE__c = UpdateStageAddress.AR_ADDR_PARTY_SITE_LOC_LAST_UPDATE_DATE__c;
            
            address.AR_PARTY_SITE_USE_PRIMARY_FLAG__c = UpdateStageAddress.AR_ADDR_CUST_SITE_USE_PRIMARY_FLAG__c;
            address.AR_PARTY_SITE_USE_STATUS__c = UpdateStageAddress.AR_ADDR_CUST_SITE_USE_STATUS__c;

            SoStageCustSiteIdForUpdate.add(address.AR_CUST_ACCT_SITE_ID__c);
            LoAddressesForUpdate.add(address);
        }
        
        set<string> SoStageCustSiteIdForInsert = new set<string>();
        
        for(string custSiteId : SoAllStageCustSiteId)
        {
            if (!SoStageCustSiteIdForUpdate.contains(custSiteId))
                SoStageCustSiteIdForInsert.add(custSiteId);
        }
        
        for(string custSiteId : SoStageCustSiteIdForInsert)
        {
            Staging_Oracle_AR_Customer__c InsertStageAddress = MoImportAddresses.get(custSiteId);
            LoStageAddressesInsert.add(InsertStageAddress);
            
            Oracle_AR_Customer_Address__c Address = new Oracle_AR_Customer_Address__c();
            system.debug('==============>mapIDARCustomInfo'+mapIDARCustomInfo+'==========MoCustAcctIdToAccountId'+MoCustAcctIdToAccountId+'=======InsertStageAddress.AR_CUST_ACCOUNT_ID__c'+InsertStageAddress.AR_CUST_ACCOUNT_ID__c);
            // Add by kumud  [desc : populate Account either by Account object directly  or with the help of AR custom info object]
            if(MoCustAcctIdToAccountId.containskey(InsertStageAddress.AR_CUST_ACCOUNT_ID__c)){
                Address.Account__c = MoCustAcctIdToAccountId.get(InsertStageAddress.AR_CUST_ACCOUNT_ID__c);
            }else if(mapIDARCustomInfo.containskey(InsertStageAddress.AR_CUST_ACCOUNT_ID__c)){
                Address.Account__c = mapIDARCustomInfo.get(InsertStageAddress.AR_CUST_ACCOUNT_ID__c).Account__C;
            }// End here.
           
            Address.AR_CUST_ACCT_SITE_ID__c = InsertStageAddress.AR_ADDR_CUST_ACCT_SITE_ID__c;
            Address.AR_CUST_SITE_ADDRESS1__c = InsertStageAddress.AR_CUSTOMER_ADDRESS1__c;
            Address.AR_CUST_SITE_ADDRESS2__c = InsertStageAddress.AR_CUSTOMER_ADDRESS2__c;
            Address.AR_CUST_SITE_ADDRESS3__c = InsertStageAddress.AR_CUSTOMER_ADDRESS3__c;
            Address.AR_CUST_SITE_ADDRESS4__c = InsertStageAddress.AR_CUSTOMER_ADDRESS4__c;
            Address.AR_CUST_SITE_CITY__c = InsertStageAddress.AR_CUSTOMER_CITY__c;
            Address.AR_CUST_SITE_STATE__c = InsertStageAddress.AR_CUSTOMER_STATE__c;
            Address.AR_CUST_SITE_PROVINCE__c = InsertStageAddress.AR_CUSTOMER_PROVINCE__c;
            Address.AR_CUST_SITE_COUNTRY__c = InsertStageAddress.AR_CUSTOMER_COUNTRY__c;
            Address.AR_CUST_SITE_POSTAL_CODE__c = InsertStageAddress.AR_CUSTOMER_POSTAL_CODE__c;
            Address.AR_CUST_SITE_STATUS__c = InsertStageAddress.AR_ADDR_CUST_SITE_STATUS__c;
            Address.AR_CUST_SITE_CREATION_DATE__c = InsertStageAddress.AR_ADDR_CUST_SITE_CREATION_DATE__c;
            Address.AR_CUST_SITE_LAST_UPDATE_DATE__c = InsertStageAddress.AR_ADDR_CUST_SITE_LAST_UPDATE_DATE__c;
            
            Address.AR_PARTY_SITE_LOC_ID__c = InsertStageAddress.AR_ADDR_PARTY_SITE_LOC_ID__c;
            Address.AR_PARTY_SITE_LOC_CREATION_DATE__c = InsertStageAddress.AR_ADDR_PARTY_SITE_LOC_CREATION_DATE__c;
            Address.AR_PARTY_SITE_LOC_LAST_UPDATE_DATE__c = InsertStageAddress.AR_ADDR_PARTY_SITE_LOC_LAST_UPDATE_DATE__c;
            
            Address.AR_PARTY_SITE_USE_PRIMARY_FLAG__c = InsertStageAddress.AR_ADDR_CUST_SITE_USE_PRIMARY_FLAG__c;
            Address.AR_PARTY_SITE_USE_STATUS__c = InsertStageAddress.AR_ADDR_CUST_SITE_USE_STATUS__c;               
            
            LoAddressesForInsert.add(Address);
        }
        
        List<Database.Saveresult> AddrIR = Database.insert(LoAddressesForInsert, false);
        List<Database.Saveresult> AddrUR = Database.update(LoAddressesForUpdate, false);       
        
        List<Staging_Oracle_AR_Customer__c> LoStageAddressInsertStatus = new List<Staging_Oracle_AR_Customer__c>();
                
        integer InsertAddrCount = 0;
        
        for(Database.Saveresult result : AddrIR)
        {
            Staging_Oracle_AR_Customer__c InsertedAddress = LoStageAddressesInsert[InsertAddrCount];
            InsertedAddress.Interface_Process_Attempts__c = (InsertedAddress.Interface_Process_Attempts__c == null ? 0 : InsertedAddress.Interface_Process_Attempts__c + 1);
            
            if (result.isSuccess())
            {
                if (InsertedAddress.Interface_Status__c == 'New')
                    InsertedAddress.Interface_Status__c = 'Addr: I';
                else
                    InsertedAddress.Interface_Status__c = InsertedAddress.Interface_Status__c + ' Addr: I';
                
                InsertedAddress.Interface_Error_Message__c = '';
            }
            else
            {
                if (InsertedAddress.Interface_Status__c == 'New')
                    InsertedAddress.Interface_Status__c = 'Addr: IF';
                else                
                    InsertedAddress.Interface_Status__c = InsertedAddress.Interface_Status__c + ' Addr: IF';
                
                string ErrorMessage = '';
                for(Database.Error err : result.getErrors())
                {
                    ErrorMessage += err.getMessage();
                }
                
                InsertedAddress.Interface_Error_Message__c = ErrorMessage;               
            }
            
            LoStageAddressInsertStatus.add(InsertedAddress);
            
            InsertAddrCount++;
        }
        
        if (LoStageAddressInsertStatus.size() > 0)
            Database.update(LoStageAddressInsertStatus, false);
        
        List<Staging_Oracle_AR_Customer__c> LoStageAddressUpdateStatus = new List<Staging_Oracle_AR_Customer__c>();
        
        integer UpdateAddrCount = 0;
        
        for(Database.Saveresult result : AddrUR)
        {
            Staging_Oracle_AR_Customer__c UpdatedAddress = LoStageAddressesUpdate[UpdateAddrCount];
            UpdatedAddress.Interface_Process_Attempts__c = (UpdatedAddress.Interface_Process_Attempts__c == null ? 0 : UpdatedAddress.Interface_Process_Attempts__c + 1);
            
            if (result.isSuccess())
            {
                if (UpdatedAddress.Interface_Status__c == 'New')
                    UpdatedAddress.Interface_Status__c = 'Addr: U';
                else
                    UpdatedAddress.Interface_Status__c = UpdatedAddress.Interface_Status__c  + ' Addr: U';
                
                UpdatedAddress.Interface_Error_Message__c = '';
            }
            else
            {
                if (UpdatedAddress.Interface_Status__c == 'New')
                    UpdatedAddress.Interface_Status__c = 'Addr: UF';
                else                
                    UpdatedAddress.Interface_Status__c = UpdatedAddress.Interface_Status__c  + ' Addr: UF';
                
                string ErrorMessage = '';
                
                for(Database.Error err : result.getErrors())
                {
                    ErrorMessage += err.getMessage();
                }
                
                UpdatedAddress.Interface_Error_Message__c = ErrorMessage;                
            }
            
            LoStageAddressUpdateStatus.add(UpdatedAddress);
                        
            UpdateAddrCount++;
        }
        
        if (LoStageAddressUpdateStatus.size() > 0)
            Database.update(LoStageAddressUpdateStatus, false);            
        
        /* END: IMPORT CUSTOMER ADDRESS */ 
        
        /* START: UPDATE DUPLICATE ADDRESS RECORDS IN STAGING TABLE */
        
        if (LoDuplicateStageAddresses.size() > 0)
        {
            for (Staging_Oracle_AR_Customer__c dupStageAddress : LoDuplicateStageAddresses)
            {
                if (dupStageAddress.Interface_Status__c == 'New')
                    dupStageAddress.Interface_Status__c = 'Addr: Dup';
                else
                    dupStageAddress.Interface_Status__c = dupStageAddress.Interface_Status__c  + ' Addr: Dup';
                
                dupStageAddress.Interface_Error_Message__c = 'Duplicate';
            }
            
            Database.update(LoDuplicateStageAddresses, false);
        }
        
        /* END: UPDATE DUPLICATE ADDRESS RECORDS IN STAGING TABLE */
    }

    global void finish(Database.BatchableContext BC)
    {      
    }
}