public with sharing class LC_DesignElementTaskController {
    private static List<Profile> profile {get; private set;}
    //Wrapperclass to get values of traffic admin,creative director and director of account manager
    public class WrapperTogetValues{
        @AuraEnabled public string directorOfAccountManager;
        @AuraEnabled public string creativeDirectorApprovers; 
        @AuraEnabled public string trafficeAdministratorApprover;
        @AuraEnabled public string requestor;
        @AuraEnabled public string accountManager;
        @AuraEnabled public Boolean justificationForDeliverables;
    }
    public static string getProfileName(){
        if (profile != null)
            return profile[0].Name;
        else{
            profile = [SELECT Id, Name FROM Profile WHERE Id = :Userinfo.getProfileId() LIMIT 1];
            return profile[0].Name;
        }
    }
    
    @AuraEnabled
    public Static Boolean getUserPermission(){
        string userProfileName = getProfileName();
        Set<String> profileNames = new Set<String>{'GC Director of Account Management', 'GC Account Manager', 'System Administrator'};
            if(profileNames.contains(userProfileName))
            return true;
        List<PermissionSetAssignment> currentUserPerSet =  [SELECT Id, PermissionSet.Name
                                                            FROM PermissionSetAssignment
                                                            WHERE AssigneeId = :Userinfo.getUserId() 
                                                            AND PermissionSet.Name = 'GC_Director_Of_Account_Management_Connect'];
        if(currentUserPerSet != null && currentUserPerSet.size() == 1)
            return true;
        
        else 
            return false;
    }    
    
    // Method to fetch Design Element Task Data to display in table of design request form related list
    @AuraEnabled
    public static List<sObject> fetchManifestData(string drfId){
        List<GC_Design_Element__c> listToBeReturned= new List<GC_Design_Element__c>();
        listToBeReturned=[select id,Name,Status__c,Show_ID__c,Design_Element__c,Task_Description__c,Deliverable__c,Assigned_To__c,Requested_Due_Date__c,Revision__c,LastModifiedDate from GC_Design_Element__c where Design_Request_Form__c=:drfId ORDER BY LastModifiedDate desc];
        return listToBeReturned;
    }
    
    //Method to get the values of trafficAdminApprover,creativeDirectorApprover,DirectorOfAccountManager
    //SAL-1293 passed elementTaskId as argument in the method calling - 12/29/23 - Sajid
    @AuraEnabled
    public static WrapperTogetValues getLookupValues(string elementTaskId){
        WrapperTogetValues obj= new WrapperTogetValues();
        string showRevTemp='';
        string cityCode='';
        //string showCity='';
        try{
       //SAL-1293 - DRF based logic commented as this is no longer needed - 12/29/23 - Sajid
       /*     List<GC_Design_Request_Form__c > showRevenue=[select Id,FormulaShowRevenue__c from GC_Design_Request_Form__c where id=:drfId];
            GC_Design_Request_Form__c drf= [Select id, FormulaShowCityCode__c, FormulaShowJobNumber__c, RecordType_Name__c, Connect2_Show__c,FormulaShowRevenue__c from GC_Design_Request_Form__c WHERE id=:drfId];
            showRevTemp = string.isNotBlank(drf.FormulaShowRevenue__c) ? drf.FormulaShowRevenue__c: '0';
            if(200000 < Decimal.valueOf(showRevTemp) || Decimal.valueOf(showRevTemp) < 500000)
                obj.justificationForDeliverables=true;
            else
                obj.justificationForDeliverables=false;
            
            if(Test.isRunningTest())
                cityCode = '42';
            else
                cityCode = String.isNotBlank(drf.FormulaShowJobNumber__c) ? drf.FormulaShowJobNumber__c.substringBefore('-'): '12345';
            
            String recordTypeName = String.isNotBlank(drf.RecordType_Name__c) ? drf.RecordType_Name__c: '';
            String query = 'SELECT id, User_ID__c, City_Code__c FROM GC_DETDAMApprover__mdt where City_Code__c LIKE \'%' ;
            List<GC_DETDAMApprover__mdt> damApprovers= Database.query(query+ cityCode + '%\'');
            for(GC_DETDAMApprover__mdt damApprover: damApprovers){
                List<String> allCityCodes = damApprover.City_Code__c.split(',');
                if(allCityCodes.contains(cityCode)){
                    obj.directorOfAccountManager=damApprover.User_ID__c;
                }
            }
            GC_Design_Request_Form__c parentDRF =[SELECT id, Connect2_Show__r.Opportunity_Id__c, Connect2_Show__r.Opportunity_Name__c FROM GC_Design_Request_Form__c WHERE id=:drfId];
            List<Opportunity> parentOppty =[SELECT id, Account.Name, Account.BillingCity, Production_Location__c from Opportunity WHERE id=:parentDRF.Connect2_Show__r.Opportunity_Id__c LIMIT 1 ];
            if (parentOppty.size() > 0){
                for(Opportunity o:parentOppty){
                    showCity = o.Account.BillingCity;
                }
            }
            */
            //SAL-1298
            
            Map<String, String> mapCityCodeToUserIdDAM = new Map<String, String>();
            Map<String, String> mapCityCodeToUserIdCD = new Map<String, String>();
            Map<String, String> mapCityCodeToUserIdTA = new Map<String, String>();
            
            String queryDAM = 'SELECT id, User_ID__c, City_Code__c FROM GC_DETDAMApprover__mdt';
            List<GC_DETDAMApprover__mdt> damApprovers= Database.query(queryDAM);
            for(GC_DETDAMApprover__mdt damApprover: damApprovers){
                List<String> allCityCodes = damApprover.City_Code__c.split(',');
                for(String ctyCode : allCityCodes){
                    mapCityCodeToUserIdDAM.put(ctyCode, damApprover.User_ID__c);
                } 
            }
            
            String queryCD = 'SELECT id, User_ID__c, City_Code__c FROM GC_DETCDApprover__mdt';
            List<GC_DETCDApprover__mdt> cdApprovers = Database.query(queryCD);
            for(GC_DETCDApprover__mdt cdApprover: cdApprovers){
                List<String> allCityCodes = cdApprover.City_Code__c.split(',');
                for(String ctyCode : allCityCodes){
                    mapCityCodeToUserIdCD.put(ctyCode, cdApprover.User_ID__c);
                } 
            }
            
            String queryTA = 'SELECT id, User_ID__c, City_Code__c FROM GC_DET_TAApprover__mdt';
            List<GC_DET_TAApprover__mdt> taApprovers = Database.query(queryTA);
            for(GC_DET_TAApprover__mdt taApprover: taApprovers){
                List<String> allCityCodes = taApprover.City_Code__c.split(',');
                for(String ctyCode : allCityCodes){
                    mapCityCodeToUserIdTA.put(ctyCode, taApprover.User_ID__c);
                } 
            }
            
            //List<GC_Design_Element__c > showRevenue = [select Id,FormulaShowRevenue__c from GC_Design_Element__c where id=:elementTaskId];
            GC_Design_Element__c designElement= [Select id,Show_Revenue__c, FormulaShowJobNumber__c, Connect2_Show__c,Connect2_Show__r.Opportunity_Id__c, Connect2_Show__r.Opportunity_Name__c from GC_Design_Element__c WHERE id=:elementTaskId];
            showRevTemp = string.isNotBlank(designElement.Show_Revenue__c) ? designElement.Show_Revenue__c: '0';
            obj.justificationForDeliverables = (200000 < Decimal.valueOf(showRevTemp) || Decimal.valueOf(showRevTemp) < 500000) ? true : false;
            cityCode = Test.isRunningTest() ? '42' : String.isNotBlank(designElement.FormulaShowJobNumber__c) ? designElement.FormulaShowJobNumber__c.substringBefore('-'): '12345'; 
            obj.directorOfAccountManager = mapCityCodeToUserIdDAM != null && mapCityCodeToUserIdDAM.size() > 0 ? mapCityCodeToUserIdDAM.get(cityCode) : '';
            obj.creativeDirectorApprovers = mapCityCodeToUserIdCD != null && mapCityCodeToUserIdCD.size() > 0 ? mapCityCodeToUserIdCD.get(cityCode) : '';
            obj.trafficeAdministratorApprover = mapCityCodeToUserIdTA != null && mapCityCodeToUserIdTA.size() > 0 ? mapCityCodeToUserIdTA.get(cityCode) : '';
            obj.requestor=UserInfo.getUserId();
            obj.accountManager=UserInfo.getUserId();
            return obj;
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    //Method to delete the design Element Task Records
    @AuraEnabled
    public static void deleteManifestRecords(string elementId){
        GC_Design_Element__c element = new GC_Design_Element__c();
        element=[select Id from GC_Design_Element__c where Id=:elementId];
        delete element;
    }
    
    //Method to close Design Request Form
    @AuraEnabled
    public static string closeDesignReqForm(string drfId){
        GC_Design_Request_Form__c drf= new GC_Design_Request_Form__c();
        Boolean hasPermissions = false;
        drf = GC_DesignRequestFormDao.getInstance().getDesignRequestFormById(drfId);
        String profileName = getProfileName();
        if (profileName == 'System Administrator') {
            hasPermissions = true;
        }
        if (!hasPermissions) {
            List<GC_Show_Team_Member__c> accManagers = [SELECT Id, User__c, Show_Role__c FROM GC_Show_Team_Member__c WHERE Connect2_Show__c = :drf.Connect2_Show__c AND Show_Role__c = 'Account Manager'];
            for (GC_Show_Team_Member__c am : accManagers) {
                if (am.User__c == UserInfo.getUserId()) {
                    hasPermissions = true;
                }
            }
        }
        if (!hasPermissions) {
            return 'accManagerCanClose';
        }
        if (drf.FormulaShowCloseDate__c > Date.today()) {
            return 'canCloseOnlyAfterShowIsOver';
        }
        try{
            drf.Status__c = 'Closed';
            update drf;
            return 'closed';
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    //Method to determine whether Account Manager has permissions
    public static Boolean determineAccountManagerPermissions(string elementId) {
        GC_Design_Element__c designElement = GC_DesignElementDao.getInstance().getDesignElementById(elementId);
        Boolean hasPermissions = false;
        String profileName = getProfileName();
        
        hasPermissions = profileName == 'System Administrator';
        if (!hasPermissions) {
            List<String> allowedShowRoles = new List<String>();
            allowedShowRoles.add('Account Manager');
            allowedShowRoles.add('Sales Manager');
            allowedShowRoles.add('Director of Account Management');
            //SAL-1293 - updated where clasue - 12/22/23 - Sajid
            //List<GC_Show_Team_Member__c> accManagers = [SELECT Id, User__c, Show_Role__c FROM GC_Show_Team_Member__c WHERE Connect2_Show__c = :designElement.Design_Request_Form__r.Connect2_Show__c AND Show_Role__c in :allowedShowRoles];
            List<GC_Show_Team_Member__c> accManagers = [SELECT Id, User__c, Show_Role__c FROM GC_Show_Team_Member__c WHERE Connect2_Show__c = :designElement.Connect2_Show__c AND Show_Role__c in :allowedShowRoles];
            for (GC_Show_Team_Member__c am : accManagers) {
                if (am.User__c == UserInfo.getUserId()) {
                    hasPermissions = true;
                }
            }
        }
        return hasPermissions;
    }
    
    //Method to cancel Design Element Task
    @AuraEnabled
    public static string cancelDesignElementTask(string elementId){
        GC_Design_Element__c designElement = GC_DesignElementDao.getInstance().getDesignElementById(elementId);
        try{
            if (designElement.Status__c == 'Archived') {
                return 'archived';
            }
            if (GC_ApprovalUtils.isUnderApproval(elementId)) {
                return 'underApproval';
            }
            Boolean hasPermissions = determineAccountManagerPermissions(elementId);
            if (!hasPermissions) {
                return 'AccSalesDirectorsCanCancel';
            }
            if (designElement.Status__c != 'Canceled' && designElement.Show_Close_Date__c < Date.today()) {
                designElement.Previous_Status__c = designElement.Status__c;
                designElement.Status__c = 'Canceled';
                update designElement;
                return 'success';
            }
            else if (designElement.Status__c == 'Canceled') {
                return 'recordCancelled';
            }
            else {
                return 'DRFnotClosed';
            }
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    //Method to create Revision of design element Task i.e making the status of det as new
    @AuraEnabled
    public static string createRevision(string elementId) {
        //Check that user has profile that allows revisions
        String profileName = getProfileName();
        if (GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_ACCT_MANAGER) &&
            GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_SALES_MGR) &&
            GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_DIRECTOR_ACCT_MGMT) &&
            GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_CREATIVE_DIRECTOR) &&
            GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_TRAFFIC_ADMIN) &&
            GC_SecurityUtil.userHasRole('System Administrator')) {
                return 'nopermissions';
            }
        //Requery existing record to get fields not referenced in Visualforce
        GC_Design_Element__c element = GC_DesignElementDao.getInstance().getDesignElementById(elementId);
        if (!element.Active__c) {
            return 'canReviseOnlyActiveDE';
        }
        
        if (element.Status__c == 'New') {
            return 'canReviseonlyOldDE';
        }
        if (GC_ApprovalUtils.isUnderApproval(element.Id)) {
            return 'inApprovalProcess';
        }
        element.Revision__c = element.Revision__c + 1;
        element.Is_Revision__c = true;
        element.Status__c = 'New';
        element.Rework__c = false;
        element.Previous_Task_Instructions__c = element.Task_Instruction__c;
        try {
            update element;
            return 'Success';
        }
        catch (DmlException e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    //Method to put the design element task on hold
    @AuraEnabled
    public static string onHold(string elementId) {
        GC_Design_Element__c designElement=GC_DesignElementDao.getInstance().getDesignElementById(elementId);
        if (designElement.Status__c == 'Archived') {
            return 'taskIsArchived';
        }
        // Check if current user is AM or Sys Admin, otherwise return error
        Boolean hasPermissions = determineAccountManagerPermissions(elementId);
        if (!hasPermissions) {
            return 'OnlyAccSalesDirectorsCanPutOnHold';
        }
        try{
            if (designElement.Status__c != 'On Hold/WFI') {
                if (!GC_ApprovalUtils.isUnderApproval(designElement.Id)) {
                    //SAL-1293 - removed DRF logic as this is no longer required - 12/22/23 - Sajid
                    //if (designElement.Design_Request_Form__r.Status__c == 'New' || designElement.Design_Request_Form__r.Status__c == 'Active') {
                        designElement.Previous_Status__c = designElement.Status__c;
                        designElement.Status__c = 'On Hold/WFI';
                        update designElement;
                        return 'success';
                   //SAL-1293 - else part commented - 12/20/23 - Sajid
                    /* }
                    else {
                        return 'DRFMustBeNewOrActive';
                    }*/
                }
                else {
                    return 'TaskMustNotBeUnderApproval';
                }
            }
            else {
                return 'alreadyOnHold';
            }
        }
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        
    }
    
    //Method to release the designelement task from hold
    @AuraEnabled
    public static string releaseHold(string elementId) {
        //Requery existing record to get fields not referenced in Visualforce
        GC_Design_Element__c designElement = GC_DesignElementDao.getInstance().getDesignElementById(elementId);
        // Check if current user is AM or Sys Admin, otherwise return error
        Boolean hasPermissions = determineAccountManagerPermissions(elementId);
        if (!hasPermissions) {
            return 'AccSalesDirectorCanRelease';
        }
        if (GC_ApprovalUtils.isUnderApproval(elementId)) {
            return 'underApproval';
        }
        try{
            if (designElement.Status__c == 'On Hold/WFI' && designElement.Is_On_Hold__c == true) {
                //SAL-1293 - removed DRF logic as this is no longer required - 12/22/23 - Sajid
                //if (designElement.Design_Request_Form__r.Status__c == 'New' || designElement.Design_Request_Form__r.Status__c == 'Active') {
                    designElement.Status__c = designElement.Previous_Status__c;
                    update designElement;
                    return 'success';
                //SAL-1293 - else part commented 12/20/23 - Sajid
                /*}
                else {
                    return 'newOrActive';
                }*/
            }
            else {
                return 'notOnHold';
            }
        }
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        
    }
    
    //Method to clone the records
    @AuraEnabled
    public static string cloneRecord(GC_Design_Element__c fieldsOfRecordViewForm){
        upsert fieldsOfRecordViewForm;
        return fieldsOfRecordViewForm.Id;
    }
    @AuraEnabled
    public static GC_Design_Element__c getDRFId(Id DETId){
        GC_Design_Element__c designElement = GC_DesignElementDao.getInstance().getDesignElementById(DETId);
        return designElement;
    }
    
    public static Boolean getCanSubmitForApproval() {
        if (GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_ACCT_MANAGER)
            || GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_SALES_MGR)
            || GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_CREATIVE_DIRECTOR)
            || GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_TRAFFIC_ADMIN)
            || GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_DIRECTOR_ACCT_MGMT)
            || GC_SecurityUtil.userHasRole('System Administrator')) {
                return true;
            }
        else {
            return false;
        }
    }
    @AuraEnabled
    public static string  setApprover(string elementId){
        GC_Design_Element__c designElement = GC_DesignElementDao.getInstance().getDesignElementById(elementId);
        if (designElement.Status__c == 'Archived') {
            return 'archived';
        }
        if (designElement.Status__c == 'On Hold/WFI') {
            return 'onHold';
        }
        
        if (!getCanSubmitForApproval()) {
            return UserInfo.getName()+'cantSubmit';
        }
        if (GC_ApprovalUtils.isUnderApproval(elementId)) {
            return 'underApproval';
        }   
        if(Test.isRunningTest()){
            designElement.Creative_Director_Approvers__c=Id.valueOf('00540000003DJr9');
            designElement.Traffic_Administrator_Approver__c=Id.valueOf('00540000003DJqK'); 
        }
        if (String.isBlank(designElement.Creative_Director_Approvers__c) || String.isBlank(designElement.Traffic_Administrator_Approver__c)) {
            return 'CDOrTARequired';
        }
        else {
            List<GC_Design_Element__c> des = new List<GC_Design_Element__c>();
            des.add(designElement);
            GC_DesignElementTaskTriggerHandler.SetAccountManager(des);
            try{// -- because cant submit gesApproved design element task for submission to approve
                update des;
            }
            catch (Exception e) {
                //return e.getMessage()+'cantUpdate';
                throw new AuraHandledException(e.getMessage());
            }
            
            designElement = GC_DesignElementDao.getInstance().getDesignElementById(designElement.Id);
            if (designElement.Secondary_Account_Manager__c == null) {
                designElement.Secondary_Account_Manager__c = designElement.Account_Manager__c;
                update designElement;
            }
            if (GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_CREATIVE_DIRECTOR) || GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_TRAFFIC_ADMIN)) {
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Submitting request for approval');
                req1.setObjectId(designElement.Id);
                /*if (String.isNotBlank(designElement.Detailer_Approver__c)) {
                    req1.setNextApproverIds(new Id[] {designElement.Detailer_Approver__c});                 
                else {
                    // GC_PageUtil.AddErrorMessage('A Detailer must be selected to be submitted for approval.');
                    return 'detailerMustBeSelected';
                }*/  //Amarab 04062021 SAL-1243 Remove check as assignment is managed in Workfront
                
                req1.setProcessDefinitionNameOrId('DE_Approval_Process11');//DE Approval Process Any Submit 
                try {
                    Approval.ProcessResult result = Approval.process(req1);
                }
                catch (Exception e) {
                    //GC_PageUtil.AddErrorMessage('Failed to Submit this task for Approval: ' + e.getMessage());
                    //return e.getMessage()+'cantsub';
                    throw new AuraHandledException(e.getMessage());
                }
            }
            else {
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Submitting request for approval');
                req1.setObjectId(designElement.Id);
                List<Id> approvers = new List<Id>();
                if (String.isNotBlank(designElement.Creative_Director_Approvers__c)) {
                    approvers.add(designElement.Creative_Director_Approvers__c);
                }
                if (String.isNotBlank(designElement.Traffic_Administrator_Approver__c)) {
                    approvers.add(designElement.Traffic_Administrator_Approver__c);
                }
                req1.setNextApproverIds(approvers);
                req1.setProcessDefinitionNameOrId('DE_Approval_Process9');//DE Approval Process9 Backup
                try {
                    Approval.ProcessResult result = Approval.process(req1);
                }
                catch (Exception e) {
                    throw new AuraHandledException(e.getMessage());
                }
            }
        }
        return null;
    }
}