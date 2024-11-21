public with sharing class MasterUploadController {
    
    public Booth_Upload__c boothUpload { get; set; }
    public List<BoothStagingWrapper> boothStagingList { get; set; }
    private List<Opportunity> auxOpps;
    public boolean confirmalert { get; set; }
    public boolean errorsalert { get; set; }
    public boolean disableButtons { get; set; }
    public integer numberOfRecords { get; set; }
    
    public boolean GeneratePressed { get; set; }
    private Id batchId;
    public string BatchMessage { get; set; }
    public boolean BatchStarted { get; set; }
    
    ApexPages.StandardSetController ctrl { get; set; }
    public integer noPages {
        get {
            if (numberOfRecords == 0)
                return 0;
            return (numberOfRecords - 1) / 20 + 1;
        }
    }
    public integer currentPage { get; set; }
    public void firstPage() {
        currentPage = 1;
        ctrl.first();
        LoadPage();
    }
    public void lastPage() {
        currentPage = noPages;
        ctrl.last();
        LoadPage();
    }
    public void previousPage() {
        if (currentPage > 1) {
            currentPage --;
            ctrl.previous();
            LoadPage();
        }
    }
    public void nextPage() {
        if (currentPage < noPages) {
            currentPage ++;
            ctrl.next();
            LoadPage();
        }
    }
    public string Filter { get; set; }
    
    private void LoadPage() {
        List<Booth_Staging__c> boothStagings = ctrl.getRecords();
        boothStagingList = new List<BoothStagingWrapper>();
        for (Booth_Staging__c staging : boothStagings) {
            boothStagingList.add(new BoothStagingWrapper(staging));
        }
        if(boothStagingList.isEmpty()){
            disableButtons = true;
        }
    }
    
    public MasterUploadController(ApexPages.StandardController controller) {
        confirmalert = false;
        errorsalert = false;
        GeneratePressed = false;
        Filter = '';
        Reload();
    }
    
    public void Reload() {
        disableButtons = false;
        try {
            boothUpload = [SELECT Id, Name, Organiser__c, Status__c, Organiser_2__c, Organiser_2__r.Name, Opportunity__c, Opportunity__r.Name, Opportunity__r.Show_Name__c, Opportunity__r.Show_Name__r.Name, Confirmation_Date_Time__c FROM Booth_Upload__c WHERE Id = :Apexpages.currentPage().getParameters().get('id')];
        } catch (Exception ex) { }
        
        string useFilter = '%' + Filter + '%';
        ctrl = new ApexPages.StandardSetController(Database.getQueryLocator([
            SELECT Id, Name, Show_Name__c, Status__c, Address_1__c, Address_2__c, Address_3__c, Booth_Height__c, Booth_ID__c, 
            Booth_Length__c, Booth_Size__c, Booth_Width__c, Business_Type__c, City__c, Company__c, Country__c, 
            Cust_Type__c, Discount__c, First_Name__c, Last_Name__c, Nameboard_Name__c, New_Exhibitor__c, Notes__c, 
            Open_Sides__c, Operations_Zone__c, Package_Type__c, Phone_Number__c, Pillar_Column_Size_c__c, 
            Post_Zip_Code__c, Stand_Number__c, Stand_Type__c, State_County__c, Vat_Number__c 
            FROM Booth_Staging__c 
            WHERE Booth_Upload__c = :boothUpload.Id AND 
            (Name LIKE :useFilter OR Company__c LIKE :useFilter OR
             Address_1__c LIKE :useFilter OR Post_Zip_Code__c LIKE :useFilter OR Country__c LIKE :useFilter OR
             Stand_Number__c LIKE :useFilter OR Stand_Type__c LIKE :useFilter OR First_Name__c LIKE :useFilter OR
             Last_Name__c LIKE :useFilter OR Phone_Number__c LIKE :useFilter OR Status__c LIKE :useFilter)
        ]));
        ctrl.setPageSize(20);
        
        numberOfRecords = ctrl.getResultSize();
        currentPage = 1;
        
        LoadPage();
    }
    
    public PageReference RedirectIfNotFound() {
        if (boothUpload == null) {
            return new PageReference('/' + Booth_Upload__c.sObjectType.getDescribe().getKeyPrefix());
        }
        return null;
    }
    
    public void confirmRecords() { 
        
        boothUpload.Confirmation_Date_Time__c = DateTime.now();
        
        BoothUploadProcessingBatch batch = new BoothUploadProcessingBatch(boothUpload, ApexPages.currentPage().getHeaders().get('Host'));
        // Changes in the batch size from 1 to 100 for better perfomance - Najmal - March 07th,2023 - #305622
        
        //#336693 - Changed hard-coded batch size to custom label called BoothUploadBatchSize for the part of code quality - 10-07-2023
        //batchId = Database.executeBatch(batch, 100);
        String BatchSize = System.Label.BoothUploadBatchSize;
        batchId = Database.executeBatch(batch, Integer.valueOf(BatchSize));
        BatchStarted = true;
        BatchMessage = 'Please wait. Your batch is processing: 0% completed';
        
        GeneratePressed = true;
        
        confirmalert = false;
        errorsalert = false;
        
    }
    
    public void CheckBatch() {
        
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                          TotalJobItems, CreatedBy.Email 
                          FROM AsyncApexJob WHERE Id = :batchId];
        if (a.Status != 'Completed' && (!Test.isRunningTest())) {
            if (a.Status == 'Failed' || a.Status == 'Aborted') {
                batchMessage = 'Batch has failed or was aborted by user.';
                return;
            }
            if (a.TotalJobItems == 0)
                batchMessage = 'Please wait. Your batch is processing: 0% completed';
            else
                batchMessage = 'Please wait. Your batch is processing: ' + (a.JobItemsProcessed * 100 / a.TotalJobItems)
                + '% completed';
            return;
        }
        //integer noErrors = [SELECT COUNT() FROM Booth_Staging__c WHERE Booth_Upload__c = :boothUpload.Id AND Status__c = 'Failed']; - old code
        //#336693 - Changed the condition to confirm the batch is successfull with no Failed/New record - 10-07-2023
        integer noErrors = [SELECT COUNT() FROM Booth_Staging__c WHERE Booth_Upload__c = :boothUpload.Id AND Status__c != 'Confirmed'];
        if (noErrors == 0) {
            boothUpload.Status__c = 'Complete';
            boothUpload.Confirmation_Date_Time__c = DateTime.now();
            update boothUpload;
            
            BatchStarted = false;
            GeneratePressed = false;
            confirmalert = true;
        } else {
            BatchStarted = false;
            GeneratePressed = false;
            errorsalert = true;
        }
        
        
        Reload();
    }
    
    public void CancelBatch() {
        BatchStarted = false;
        GeneratePressed = false;
        System.abortJob(batchId);
    }
    
    
    public PageReference saveRecords() {
        update boothUpload; 
        return null;
    }
    
    public PageReference isdeleting() { 
        Id bId = ApexPages.currentPage().getParameters().get('bId');
        integer i = 0;
        for (BoothStagingWrapper bs : boothStagingList) {
            if (bs.staging.Id == bId) {
                boothStagingList.remove(i);
                delete bs.staging;
                return null;
            }
            i++;
        }
        return null;
    }
    
    public PageReference gotoImportBuddy() {
        
        Booth_Upload_Settings__c bus;
        List<Booth_Upload_Settings__c> buss = [SELECT Id FROM Booth_Upload_Settings__c WHERE User_Id__c = :UserInfo.getUserId()];
        if (buss.size() > 0) {
            bus = buss[0];
        } else {
            bus = new Booth_Upload_Settings__c();
            bus.Name = UserInfo.getUsername();
            bus.User_Id__c = UserInfo.getUserId();
        }
        bus.Booth_Upload_Id__c = boothUpload.Id;
        upsert bus;
        
        return Page.sftplib__ImportBuddy;
        
    }
    
    public class BoothStagingWrapper {
        
        public Booth_Staging__c staging { get; set; }
        
        public BoothStagingWrapper(Booth_Staging__c s) {
            staging = s;
        }
        
    }
    
    public void resetAlerts() {
        confirmalert = false;
        errorsalert = false;
    }
    
    //Inserting stage records from the file which is uploaded by user - #394587 04-04-2024
    @AuraEnabled(cacheable=false)
    public static void createStageRecords(List<Booth_Staging__c> stgList, List<String> CSVFile){
        List<Database.SaveResult> stgListResult = Database.insert(stgList, false);
        try{
            String errorFileString = CSVFile[0].replace(',\r','').replace('\r','')+',ERROR \n';
            Boolean isHavingError = false;
            for( integer i=0; i < stgListResult.size(); i++ ){
                if(!stgListResult.get(i).isSuccess()){
                    isHavingError = true;
                    errorFileString = errorFileString + CSVFile[i+1].replace(',\r','').replace('\r','') + ',' + stgListResult.get(i).getErrors().get(0).getMessage() + ' \n';
                    system.debug(stgListResult.get(i).getErrors().get(0).getMessage());
                    system.debug(stgListResult.get(i));
                }
            }
            sendEmailAfterFileUpload(errorFileString,isHavingError,stgList[0].Booth_Upload__c);
        }catch(Exception ex){
            system.debug(ex.getMessage() + ex.getStackTraceString());
        }
    }
    
    //Sending confirmation email to the uploaded user after the records creation with details of failures if there is - #394587 04-04-2024
    @future
    public static void sendEmailAfterFileUpload(String errorFileString, Boolean isHavingError, String boothUploadId){ 
        Booth_Upload__c bu = [SELECT Id, Opportunity__r.Name FROM Booth_Upload__c WHERE Id =: boothUploadId];
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String body = 'Hi, <br /><br />Your request for data load is completed. If there were errors, this email would contain attachment.<br /><br />';
        if(isHavingError){
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            String attName = 'ErrorFile.csv';
            efa.setFileName(attName);
            efa.setBody(Blob.valueOf(errorFileString));
            email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        }
        email.setSubject('ImportBuddy Notification '+bu.Opportunity__r.Name);
        email.setToAddresses( new String[] {UserInfo.getUserEmail()} );
        email.setHtmlBody( body );
        if(!Test.isRunningTest()){
        	Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }
    }
    
    // Returning booth stage fields to provide column selection to the user - #394587 04-04-2024
    @AuraEnabled(cacheable=true)
    public static Map<String, String> getAllColumnsDetail(String objectApiName){
        Map<String, String> fieldToLabelMap = new Map<String, String>();
        Schema.SObjectType loadSchema = Schema.getGlobalDescribe().get(objectApiName);
        Map<String, Schema.SObjectField> fieldMap = loadSchema.getDescribe().fields.getMap();
        for (Schema.SObjectField fld: fieldMap.values()) {
            if(fld.getDescribe().isAccessible() && (fld.getDescribe().isAutoNumber() || (fld.getDescribe().isCustom() && fld.getDescribe().getType() != Schema.DisplayType.Reference))){
                fieldToLabelMap.put(fld.getDescribe().getName(), String.valueOf(fld.getDescribe().getLabel()));
            }
        }
        return fieldToLabelMap;
    }
    
    // To get the updated data after every operation done by user - #394587 04-04-2024
    @AuraEnabled(cacheable=false)
    public static List<Sobject> showStageData(String selectedField, String objectName, Id boothUploadId){
        system.debug(selectedField);
        List<String> fieldList = (List<String>) JSON.deserialize(selectedField, List<String>.class);
        String query = 'Select Id';
        for(String str : fieldList){
            query+= ', ' + str ;
        }
        query+= ' from ' + objectName +' where Booth_Upload__c=\''+boothUploadId+'\' order by Status__c';
        System.debug('Test: '+ query);
        List<Sobject> sobjectData = Database.query(query);
        return sobjectData;
    }
    
    // To delete the records selected by user - #394587 04-04-2024
    @AuraEnabled(cacheable=false)
    public static void deleteBsRecords(List<Booth_Staging__c> bsListToDelete){
        delete bsListToDelete;
    }
    
    // Run the batch only if there is no other batch running for the same Booth Upload - #394587 04-04-2024
    @AuraEnabled(cacheable=false)
    public static String runTheBatch(Id boothUploadId){
        List<Booth_Upload_Settings__c> busList = [SELECT Id, Booth_Upload_Id__c FROM Booth_Upload_Settings__c WHERE Name = :boothUploadId];
        if(busList.isEmpty()){
            Booth_Upload__c bu = [SELECT Id, Name, Organiser__c, Status__c, Organiser_2__c, Organiser_2__r.Name, Opportunity__c, Opportunity__r.Name, Opportunity__r.Show_Name__c, Opportunity__r.Show_Name__r.Name, Confirmation_Date_Time__c FROM Booth_Upload__c WHERE Id = :boothUploadId];
            bu.Confirmation_Date_Time__c = DateTime.now();
            BoothUploadProcessingBatch batch = new BoothUploadProcessingBatch(bu, URL.getOrgDomainUrl().toString());
            String BatchSize = System.Label.BoothUploadBatchSize;
            Id batchId = Database.executeBatch(batch, Integer.valueOf(BatchSize));
            return batchId;
        }
        return 'Running';
    }
    
    // Check the running batch status every 5 seconds - #394587 04-04-2024
    @AuraEnabled(cacheable=false)
    public static String checkRunningBatchStatus(Id boothUploadId, Id bId){
        system.debug(bId);
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id = :bId];
        if (a.Status != 'Completed') {
            if (a.Status == 'Failed' || a.Status == 'Aborted') {
                return 'Failed';
            }
            if (a.TotalJobItems != 0)
                return String.valueOf(a.JobItemsProcessed * 100 / a.TotalJobItems);
            else
                return '0';
        }
        integer noErrors = [SELECT COUNT() FROM Booth_Staging__c WHERE Booth_Upload__c = :boothUploadId AND Status__c != 'Confirmed'];
        if (noErrors == 0) {
            Booth_Upload__c bu = [SELECT Id, Name, Organiser__c, Status__c, Organiser_2__c, Organiser_2__r.Name, Opportunity__c, Opportunity__r.Name, Opportunity__r.Show_Name__c, Opportunity__r.Show_Name__r.Name, Confirmation_Date_Time__c FROM Booth_Upload__c WHERE Id = :boothUploadId];
            bu.Status__c = 'Complete';
            bu.Confirmation_Date_Time__c = DateTime.now();
            update bu;
            return 'Completed';
        }
        return 'CompletedWithError';
    }
    
}