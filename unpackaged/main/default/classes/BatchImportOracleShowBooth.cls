global class BatchImportOracleShowBooth implements Database.Batchable<SObject>, Database.Stateful {

    public String query; 

    global database.querylocator start(Database.BatchableContext BC){return Database.getQueryLocator(query);}
        
    global void execute(Database.BatchableContext BC, Sobject[] scope){
        
        /* START: IMPORT Show Booth */
 
        // Retrieve the list of Booths in Staging Table and build a collection. Using this collection, 
        // determine which Booths already exist vs which ones are new.
        List<Staging_Oracle_Show_Booth__c> LoShowBoothsInStagingTable = new List<Staging_Oracle_Show_Booth__c>();
        
        for(SObject s: scope)
        {
            LoShowBoothsInStagingTable.add((Staging_Oracle_Show_Booth__c)s);
        }
        
        /*
            1. Create a Set of All Booth Ids in the Staging Table.
            
            2. Create a Set of Customer Ids for Booths in the Staging Table. Use this set to create a map of 
               Customer Account ID and Account Id (SFDC Id field). This map/lookup is required to populate the 
               "Account__c" field during insert
               
            3. Create a Set of all Project Numbers in the Staging Table. Use this set to create a map of Show Occurrence
               Project Number to (Opportunity) Id (SFDC Id field). This map/lookup is required to populate the
               "Show_Occurrence__c" field during insert (but not update since Master-Detail field cannot be updated.)
        */
        
        set<string> SoAllStageBoothId = new set<string>();
        set<string> SoCustAccountId = new set<string>();
        set<string> SoProjectNumber = new set<string>();
            
        // Create a map of Staging_Oracle_Show_Booth__c object created in the prior step to BOOTH_ID__c.
        // So, if this field value is known, the corresponding staging show occurrence booth object could be retrieved.
        
        map<string, Staging_Oracle_Show_Booth__c> MoImportBooths = new map<string, Staging_Oracle_Show_Booth__c>();
        
        // Add by Gaurav, to store Customer Name against Cust ID from Staging Core Booth
        map<string, string> MoCustIdtoCustNm = new map<string, string>();
                
        for(Staging_Oracle_Show_Booth__c stageBooth : LoShowBoothsInStagingTable)
        {
            if (!SoAllStageBoothId.contains(stageBooth.Booth_ID__c))
            {
                SoAllStageBoothId.add(stageBooth.Booth_ID__c);
                MoImportBooths.put(stageBooth.Booth_ID__c, stageBooth);
                SoCustAccountId.add(stageBooth.CUST_ACCOUNT_ID__c);
                
                SoProjectNumber.add(stageBooth.PROJECT_NUMBER__c);
                MoCustIdtoCustNm.put(stageBooth.CUST_ACCOUNT_ID__c,stageBooth.CUSTOMER_NAME__c);
            }
        }
        
        // Create a map of Customer Account ID and Account Id (SFDC Id field)
        map<string, id> MoCustAcctIdToAccountId = new map<string, id>();
        map<string, string> MoCustAcctIdToAccountName = new map<string, string>();
        List<Account> Accnts = [Select Id, ORACLE_AR_CUST_ACCOUNT_ID__c, Name From Account Where ORACLE_AR_CUST_ACCOUNT_ID__c In :SoCustAccountId];
        
        for (Account acnt : Accnts)
        {
            MoCustAcctIdToAccountId.put(acnt.ORACLE_AR_CUST_ACCOUNT_ID__c, acnt.Id);
            MoCustAcctIdToAccountName.put(acnt.ORACLE_AR_CUST_ACCOUNT_ID__c, acnt.Name);
        }
        
        //  Added by Gaurav  [Desc: List To store AR Custom Info]
        Map<String,AR_Customer_Info__c> mapIDARCustomInfo = new Map<String,AR_Customer_Info__c>();
        for(AR_Customer_Info__c instArcustom:[select AR_Customer_Number__c,Oracle_AR_Customer_ID__c,Master_Account_Name__c,Account__c,GBMS_ID__c from AR_Customer_Info__c where Oracle_AR_Customer_ID__c in:SoCustAccountId])
        {
            mapIDARCustomInfo.put(instArcustom.Oracle_AR_Customer_ID__c,instArcustom);
        }
           
        //  End by Gaurav 
        
        // Create a map of Project Number to Show Occurrence Id (SFDC Id field for Opportunity).
        map<string, id> MoProjectNumberToOppId = new map<string, id>();
        map<string, string> MoProjectNumberToOppShowName = new map<string, string>();
        
        List<Opportunity> Opps = [Select Id, Job_Number__c, Show_Name__c, Show_Name__r.Name From Opportunity Where Job_Number__c In :SoProjectNumber];
        
        for (Opportunity opp : Opps)
        {
            MoProjectNumberToOppId.put(opp.Job_Number__c, opp.Id);
            
            if (Opp.Show_Name__c != null)
            {
                MoProjectNumberToOppShowName.put(opp.Job_Number__c, Opp.Show_Name__r.Name);
            }
        }
        
        // Split collection of Booths into two separate lists, one for update and another for insert
        List<Oracle_Show_Booth__c> LoBoothsForInsert = new List<Oracle_Show_Booth__c>();
        List<Oracle_Show_Booth__c> LoBoothsForUpdate = new List<Oracle_Show_Booth__c>();
            
        List<Staging_Oracle_Show_Booth__c> LoStageBoothsInsert = new List<Staging_Oracle_Show_Booth__c>();
        List<Staging_Oracle_Show_Booth__c> LoStageBoothsUpdate = new List<Staging_Oracle_Show_Booth__c>();      
        
        // Retrieve the list of Booths that already exist based on Set SoAllStageBoothId. Also, based on 
        // this list determine the set which does not exist (i.e. Booths which need to be inserted).
        List<Oracle_Show_Booth__c> LoExistingBooths = [Select Id, BOOTH_ID__c From Oracle_Show_Booth__c Where BOOTH_ID__c In : SoAllStageBoothId];
        
        set<string> SoStageBoothIdForUpdate = new set<string>();
        
        for(Oracle_Show_Booth__c booth: LoExistingBooths)
        {
            Staging_Oracle_Show_Booth__c UpdateStageBooth = MoImportBooths.get(booth.BOOTH_ID__c);
            LoStageBoothsUpdate.add(UpdateStageBooth);
                        
            booth.Account__c = MoCustAcctIdToAccountId.get(UpdateStageBooth.CUST_ACCOUNT_ID__c);

            booth.BOOTH_CREATION_DATE__c = UpdateStageBooth.BOOTH_CREATION_DATE__c;
            booth.BOOTH_LAST_UPDATE_DATE__c = UpdateStageBooth.BOOTH_LAST_UPDATE_DATE__c;
            booth.BOOTH_LENGTH__c = UpdateStageBooth.BOOTH_LENGTH__c;
            booth.BOOTH_NUMBER__c = UpdateStageBooth.BOOTH_NUMBER__c;
            booth.BOOTH_SHARED_FLAG__c = UpdateStageBooth.BOOTH_SHARED_FLAG__c;
            booth.BOOTH_SIZE__c = UpdateStageBooth.BOOTH_SIZE__c;
            booth.BOOTH_TYPE__c = UpdateStageBooth.BOOTH_TYPE__c;
            booth.BOOTH_WIDTH__c = UpdateStageBooth.BOOTH_WIDTH__c;
            booth.CUST_ACCOUNT_ID__c = UpdateStageBooth.CUST_ACCOUNT_ID__c;
            booth.Zone__c = UpdateStageBooth.ZONE__c;
            booth.Service_Zone__c = UpdateStageBooth.SERVICE_ZONE__c;
            booth.EXHIBITOR_STATUS1__c = UpdateStageBooth.EXHIBITOR_STATUS1__c;
            booth.EXHIBITOR_STATUS2__c = UpdateStageBooth.EXHIBITOR_STATUS2__c;
            booth.EXHIBITOR_STATUS3__c = UpdateStageBooth.EXHIBITOR_STATUS3__c;
            booth.EXHIBITOR_STATUS4__c = UpdateStageBooth.EXHIBITOR_STATUS4__c;
            booth.EXHIBITOR_STATUS5__c = UpdateStageBooth.EXHIBITOR_STATUS5__c;
            booth.Show_Package__c = UpdateStageBooth.Show_Package__c;  //Amarab 09212022 for ShowPackage Info
            booth.SHOW_OCCR_CUST_ID__c = UpdateStageBooth.SHOW_OCCR_CUST_ID__c;  //Amarab04102023 for Showsite contact send to CORE
            
            //  Add by Gaurav, for Booth Name field
            
            if  (UpdateStageBooth.PROJECT_NUMBER__c != null && UpdateStageBooth.PROJECT_NUMBER__c != '') 
                {
                    if  (UpdateStageBooth.CUSTOMER_NAME__c != null && UpdateStageBooth.CUSTOMER_NAME__c != '') 
                    {
                        booth.Name = UpdateStageBooth.PROJECT_NUMBER__c + ' ' + UpdateStageBooth.CUSTOMER_NAME__c;
                        booth.Booth_Name_Searchable__c = booth.Name;
                    }
                }
            
            if (UpdateStageBooth.ED_FLAG__c != null)
                booth.ED_FLAG__c = (UpdateStageBooth.ED_FLAG__c.toUpperCase() == 'Y' ? true: false);
            else
                booth.ED_FLAG__c = false;
            
            if (UpdateStageBooth.INACTIVE_FLAG__c != null)
                booth.INACTIVE_FLAG__c = (UpdateStageBooth.INACTIVE_FLAG__c.toUpperCase() == 'Y' ? true : false);
            else
                booth.INACTIVE_FLAG__c = false;
                      
            booth.PROJECT_NUMBER__c = UpdateStageBooth.PROJECT_NUMBER__c;
            booth.SHOW_ID__c = UpdateStageBooth.SHOW_ID__c;
            
            if (UpdateStageBooth.THIRD_PARTY_FLAG__c != null)
                booth.THIRD_PARTY_FLAG__c = (UpdateStageBooth.THIRD_PARTY_FLAG__c.toUpperCase() == 'Y' ? true: false);
            else
                booth.THIRD_PARTY_FLAG__c = false;
            
            if (UpdateStageBooth.SHOW_ORG_FLAG__c != null)
                booth.SHOW_ORG_FLAG__c = (UpdateStageBooth.SHOW_ORG_FLAG__c.toUpperCase() == 'Y' ? true: false);
            else
                booth.SHOW_ORG_FLAG__c = false;
            
            String ExhibitorName = MoCustAcctIdToAccountName.get(UpdateStageBooth.CUST_ACCOUNT_ID__c);
            
            if (ExhibitorName != null && ExhibitorName != '')
                booth.Exhibitor_Name_Denormalized__c = ExhibitorName;
            else
                booth.Exhibitor_Name_Denormalized__c = null;
            
            String ShowName = MoProjectNumberToOppShowName.get(UpdateStageBooth.PROJECT_NUMBER__c);
            
            if (ShowName != null && ShowName != '')
                booth.Show_Name_Denormalized__c = ShowName;
            else
                booth.Show_Name_Denormalized__c = null;
                
            //  Added by Gaurav, new field Exhibitor Name 
            
            if (UpdateStageBooth.CUSTOMER_NAME__c != null && UpdateStageBooth.CUSTOMER_NAME__c != '') {
            booth.Exhibitor_Name__c = UpdateStageBooth.CUSTOMER_NAME__c;
            }
            
            SoStageBoothIdForUpdate.add(booth.BOOTH_ID__c);
            LoBoothsForUpdate.add(booth);
        }
        
        set<string> SoStageBoothIdForInsert = new set<string>();
        
        for(string boothId : SoAllStageBoothId)
        {
            if (!SoStageBoothIdForUpdate.contains(boothId))
                SoStageBoothIdForInsert.add(boothId);
        }
        
        for(string boothId : SoStageBoothIdForInsert)
        {
            Staging_Oracle_Show_Booth__c InsertStageBooth = MoImportBooths.get(boothId);
            LoStageBoothsInsert.add(InsertStageBooth);
            
            Oracle_Show_Booth__c Booth = new Oracle_Show_Booth__c();

            Booth.Account__c = MoCustAcctIdToAccountId.get(InsertStageBooth.CUST_ACCOUNT_ID__c);
            Booth.Show_Occurrence__c = MoProjectNumberToOppId.get(InsertStageBooth.PROJECT_NUMBER__c);
            
            //  Modified by Gaurav, for Booth Name field
            
            //Booth.Name = InsertStageBooth.PROJECT_NUMBER__c + ' ' + MoCustAcctIdToAccountName.get(InsertStageBooth.CUST_ACCOUNT_ID__c);
            
            if  (InsertStageBooth.PROJECT_NUMBER__c != null && InsertStageBooth.PROJECT_NUMBER__c != '') 
                {
                    if  (InsertStageBooth.CUSTOMER_NAME__c != null && InsertStageBooth.CUSTOMER_NAME__c != '') 
                    {
                        Booth.Name = InsertStageBooth.PROJECT_NUMBER__c + ' ' + InsertStageBooth.CUSTOMER_NAME__c;
                        Booth.Booth_Name_Searchable__c = Booth.Name;
                    }
                }
            
            if  (Booth.Name != null && Booth.Name != '') 
                {
            if (Booth.Name.length() > 80)
                Booth.Name = Booth.Name.substring(0,80);
            }
            Booth.BOOTH_ID__c = InsertStageBooth.BOOTH_ID__c;
            Booth.BOOTH_CREATION_DATE__c = InsertStageBooth.BOOTH_CREATION_DATE__c;
            Booth.BOOTH_LAST_UPDATE_DATE__c = InsertStageBooth.BOOTH_LAST_UPDATE_DATE__c;
            Booth.BOOTH_LENGTH__c = InsertStageBooth.BOOTH_LENGTH__c;
            Booth.BOOTH_NUMBER__c = InsertStageBooth.BOOTH_NUMBER__c;
            Booth.BOOTH_SHARED_FLAG__c = InsertStageBooth.BOOTH_SHARED_FLAG__c;
            Booth.BOOTH_SIZE__c = InsertStageBooth.BOOTH_SIZE__c;
            Booth.BOOTH_TYPE__c = InsertStageBooth.BOOTH_TYPE__c;
            Booth.BOOTH_WIDTH__c = InsertStageBooth.BOOTH_WIDTH__c;
            Booth.CUST_ACCOUNT_ID__c = InsertStageBooth.CUST_ACCOUNT_ID__c;
            booth.Zone__c = InsertStageBooth.ZONE__c;
            booth.Service_Zone__c = InsertStageBooth.SERVICE_ZONE__c;
            booth.EXHIBITOR_STATUS1__c = InsertStageBooth.EXHIBITOR_STATUS1__c;
            booth.EXHIBITOR_STATUS2__c = InsertStageBooth.EXHIBITOR_STATUS2__c;
            booth.EXHIBITOR_STATUS3__c = InsertStageBooth.EXHIBITOR_STATUS3__c;
            booth.EXHIBITOR_STATUS4__c = InsertStageBooth.EXHIBITOR_STATUS4__c;
            booth.EXHIBITOR_STATUS5__c = InsertStageBooth.EXHIBITOR_STATUS5__c;
            booth.Show_Package__c = InsertStageBooth.Show_Package__c;  //Amarab 09212022 for ShowPackage Info
            booth.SHOW_OCCR_CUST_ID__c = InsertStageBooth.SHOW_OCCR_CUST_ID__c;  //Amarab04102023 for Showsite contact send to CORE
            
            if (InsertStageBooth.ED_FLAG__c != null)
                Booth.ED_FLAG__c = (InsertStageBooth.ED_FLAG__c.toUpperCase() == 'Y' ? true: false);
            
            if (InsertStageBooth.INACTIVE_FLAG__c != null)
                Booth.INACTIVE_FLAG__c = (InsertStageBooth.INACTIVE_FLAG__c.toUpperCase() == 'Y' ? true : false);
            else
                Booth.ED_FLAG__c = false;
            
            Booth.PROJECT_NUMBER__c = InsertStageBooth.PROJECT_NUMBER__c;
            Booth.SHOW_ID__c = InsertStageBooth.SHOW_ID__c;
            
            if (InsertStageBooth.THIRD_PARTY_FLAG__c != null)
                Booth.THIRD_PARTY_FLAG__c = (InsertStageBooth.THIRD_PARTY_FLAG__c.toUpperCase() == 'Y' ? true : false);
            else
                Booth.THIRD_PARTY_FLAG__c = false;
            
            if (InsertStageBooth.SHOW_ORG_FLAG__c !=  null)
                Booth.SHOW_ORG_FLAG__c = (InsertStageBooth.SHOW_ORG_FLAG__c.toUpperCase() == 'Y' ? true : false);
            else
                Booth.SHOW_ORG_FLAG__c = false;
            
            String ExhibitorName = MoCustAcctIdToAccountName.get(InsertStageBooth.CUST_ACCOUNT_ID__c);
            
            if (ExhibitorName != null && ExhibitorName != '')
                Booth.Exhibitor_Name_Denormalized__c = ExhibitorName;
            else
                Booth.Exhibitor_Name_Denormalized__c = null;
            
            String ShowName = MoProjectNumberToOppShowName.get(InsertStageBooth.PROJECT_NUMBER__c);
            
            if (ShowName != null && ShowName != '')
                Booth.Show_Name_Denormalized__c = ShowName;
            else
                Booth.Show_Name_Denormalized__c = null;
            
            //  Added by Gaurav, new field Exhibitor Name 
            
            if (InsertStageBooth.CUSTOMER_NAME__c != null && InsertStageBooth.CUSTOMER_NAME__c != '') {
            Booth.Exhibitor_Name__c = InsertStageBooth.CUSTOMER_NAME__c;
            }
                            
            LoBoothsForInsert.add(Booth);
        }
        
        //  Added by Gaurav  [Desc: List To store AR Custom Info]
        
         for(Oracle_Show_Booth__c bth: LoBoothsForUpdate)
        {
           if  (mapIDARCustomInfo != null && !mapIDARCustomInfo.isEmpty()) 
           {
            if(mapIDARCustomInfo.ContainsKey(bth.CUST_ACCOUNT_ID__c)) 
            {
                if  (mapIDARCustomInfo.get(bth.CUST_ACCOUNT_ID__c).Account__c != null) 
                {
                    bth.Account__c = mapIDARCustomInfo.get(bth.CUST_ACCOUNT_ID__c).Account__c;
                }
                if  (bth.PROJECT_NUMBER__c != null && bth.PROJECT_NUMBER__c != '') 
                {
                    bth.Name = bth.PROJECT_NUMBER__c + ' ' + MoCustIdtoCustNm.get(bth.CUST_ACCOUNT_ID__c);
                    bth.Booth_Name_Searchable__c = bth.Name;
                }
                if  (mapIDARCustomInfo.get(bth.CUST_ACCOUNT_ID__c).GBMS_ID__c != null && mapIDARCustomInfo.get(bth.CUST_ACCOUNT_ID__c).GBMS_ID__c != '') 
                {
                    bth.GBMS_ID__c=mapIDARCustomInfo.get(bth.CUST_ACCOUNT_ID__c).GBMS_ID__c;
                }   
                if  (mapIDARCustomInfo.get(bth.CUST_ACCOUNT_ID__c).Oracle_AR_Customer_ID__c != null && mapIDARCustomInfo.get(bth.CUST_ACCOUNT_ID__c).Oracle_AR_Customer_ID__c != '') 
                {   
                    bth.Oracle_AR_Customer_ID__c=mapIDARCustomInfo.get(bth.CUST_ACCOUNT_ID__c).Oracle_AR_Customer_ID__c;
                }
                if  (mapIDARCustomInfo.get(bth.CUST_ACCOUNT_ID__c).AR_Customer_Number__c != null && mapIDARCustomInfo.get(bth.CUST_ACCOUNT_ID__c).AR_Customer_Number__c != '') 
                {   
                    bth.Oracle_AR_Customer_Number__c=mapIDARCustomInfo.get(bth.CUST_ACCOUNT_ID__c).AR_Customer_Number__c;
                }
                if  (mapIDARCustomInfo.get(bth.CUST_ACCOUNT_ID__c).Master_Account_Name__c != null && mapIDARCustomInfo.get(bth.CUST_ACCOUNT_ID__c).Master_Account_Name__c != '') 
                {
                bth.Exhibitor_Name_Denormalized__c=mapIDARCustomInfo.get(bth.CUST_ACCOUNT_ID__c).Master_Account_Name__c;
                }
            }
           }
         }
        
        for(Oracle_Show_Booth__c bth: LoBoothsForInsert)
        {
           if  (mapIDARCustomInfo != null && !mapIDARCustomInfo.isEmpty()) 
           {
            if(mapIDARCustomInfo.ContainsKey(bth.CUST_ACCOUNT_ID__c)) 
            {
                if  (mapIDARCustomInfo.get(bth.CUST_ACCOUNT_ID__c).Account__c != null ) 
                {
                    bth.Account__c = mapIDARCustomInfo.get(bth.CUST_ACCOUNT_ID__c).Account__c;
                }
                if  (bth.PROJECT_NUMBER__c != null && bth.PROJECT_NUMBER__c != '') 
                {
                    bth.Name = bth.PROJECT_NUMBER__c + ' ' + MoCustIdtoCustNm.get(bth.CUST_ACCOUNT_ID__c);
                    bth.Booth_Name_Searchable__c = bth.Name;
                }
                if  (mapIDARCustomInfo.get(bth.CUST_ACCOUNT_ID__c).GBMS_ID__c != null && mapIDARCustomInfo.get(bth.CUST_ACCOUNT_ID__c).GBMS_ID__c != '') 
                {
                    bth.GBMS_ID__c=mapIDARCustomInfo.get(bth.CUST_ACCOUNT_ID__c).GBMS_ID__c;
                }   
                if  (mapIDARCustomInfo.get(bth.CUST_ACCOUNT_ID__c).Oracle_AR_Customer_ID__c != null && mapIDARCustomInfo.get(bth.CUST_ACCOUNT_ID__c).Oracle_AR_Customer_ID__c != '') 
                {   
                    bth.Oracle_AR_Customer_ID__c=mapIDARCustomInfo.get(bth.CUST_ACCOUNT_ID__c).Oracle_AR_Customer_ID__c;
                }
                if  (mapIDARCustomInfo.get(bth.CUST_ACCOUNT_ID__c).AR_Customer_Number__c != null && mapIDARCustomInfo.get(bth.CUST_ACCOUNT_ID__c).AR_Customer_Number__c != '') 
                {   
                    bth.Oracle_AR_Customer_Number__c=mapIDARCustomInfo.get(bth.CUST_ACCOUNT_ID__c).AR_Customer_Number__c;
                }
                if  (mapIDARCustomInfo.get(bth.CUST_ACCOUNT_ID__c).Master_Account_Name__c != null && mapIDARCustomInfo.get(bth.CUST_ACCOUNT_ID__c).Master_Account_Name__c != '') 
                {
                bth.Exhibitor_Name_Denormalized__c=mapIDARCustomInfo.get(bth.CUST_ACCOUNT_ID__c).Master_Account_Name__c;
                }
            }
           }
         }
        
        //  End by Gaurav
        
        List<Database.Saveresult> BoothIR = Database.insert(LoBoothsForInsert, false);
        List<Database.Saveresult> BoothUR = Database.update(LoBoothsForUpdate, false);     
        
        List<Staging_Oracle_Show_Booth__c> LoStageBoothInsertStatus = new List<Staging_Oracle_Show_Booth__c>();
                
        integer InsertBoothCount = 0;
        
        for(Database.Saveresult result : BoothIR)
        {
            Staging_Oracle_Show_Booth__c InsertedBooth = LoStageBoothsInsert[InsertBoothCount];
            InsertedBooth.Interface_Process_Attempts__c = (InsertedBooth.Interface_Process_Attempts__c == null ? 0 : InsertedBooth.Interface_Process_Attempts__c + 1);
            
            if (result.isSuccess())
            {
                InsertedBooth.Interface_Status__c = 'Inserted';
                InsertedBooth.Interface_Error_Message__c = '';
            }
            else
            {
                InsertedBooth.Interface_Status__c = 'Insert Failed';
                
                string ErrorMessage = '';
                for(Database.Error err : result.getErrors())
                {
                    ErrorMessage += err.getMessage();
                }
                
                InsertedBooth.Interface_Error_Message__c = ErrorMessage;               
            }
            
            LoStageBoothInsertStatus.add(InsertedBooth);
            
            InsertBoothCount++;
        }
        
        if (LoStageBoothInsertStatus.size() > 0)
            Database.update(LoStageBoothInsertStatus, false);
        
        List<Staging_Oracle_Show_Booth__c> LoStageBoothUpdateStatus = new List<Staging_Oracle_Show_Booth__c>();
        
        integer UpdateBoothCount = 0;
        
        for(Database.Saveresult result : BoothUR)
        {
            Staging_Oracle_Show_Booth__c UpdatedBooth = LoStageBoothsUpdate[UpdateBoothCount];
            UpdatedBooth.Interface_Process_Attempts__c = (UpdatedBooth.Interface_Process_Attempts__c == null ? 0 : UpdatedBooth.Interface_Process_Attempts__c + 1);
            
            if (result.isSuccess())
            {
                UpdatedBooth.Interface_Status__c = 'Updated';
                UpdatedBooth.Interface_Error_Message__c = '';
            }
            else
            {
                UpdatedBooth.Interface_Status__c = 'Update Failed';
                
                string ErrorMessage = '';
                
                for(Database.Error err : result.getErrors())
                {
                    ErrorMessage += err.getMessage();
                }
                
                UpdatedBooth.Interface_Error_Message__c = ErrorMessage;                
            }
            
            LoStageBoothUpdateStatus.add(UpdatedBooth);
                        
            UpdateBoothCount++;
        }
        
        if (LoStageBoothUpdateStatus.size() > 0)
            Database.update(LoStageBoothUpdateStatus, false);          
        
        /* END: IMPORT SHOW BOOTH */        
    }
    
    global void finish(Database.BatchableContext BC)
    {      
    }    

}