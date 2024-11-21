public class LC_GESOrderTaskViewController {
    
    private static List<Profile> profile {get; private set;}
    private static List<GC_Show_Team_Member__c> showTeamMembers {get; private set;}
    
    @AuraEnabled(cacheable=true)
    public static GC_GES_Order_Task__c getOrderByGOT(string gotId){
        List<GC_GES_Order_Task__c> gots = [SELECT Id, Name, Order__c, Item_Number__c, Item_Template__c, Description__c, Parent_GEM_Structure__c, QuantityNum__c, UOM__c, Carpet_Length__c, Carpet_Width__c, Electrical_Ordered__c, Electrical_Under__c, Sign_Length__c, Sign_Width__c from GC_GES_Order_Task__c where id=:gotId];
        
        if(gots.size() > 0)
            return gots[0];
        return new GC_GES_Order_Task__c();
    }
    
    /* Approve Button added on GES Item page in lightning by Sajid on 07/05/23 Ticket-1210 */
    //code start
    @AuraEnabled	
    public static void approveItem(String itemId) {
        System.debug('itemId:: '+itemId);
        List<GC_GES_Order_Task__c> approveSubmittedList = new List<GC_GES_Order_Task__c>();
        
        GC_GES_Order_Task__c item = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(itemId);
        System.debug('item:: '+item);
        if (item.Status__c == 'New'){
            item.Status__c = 'Approved';
            update item;
        }else if(item.Status__c == 'Submitted' || item.Status__c == 'Submitted to Graphics'){
            approveSubmittedList.add(item);
        }
        
        if (approveSubmittedList.size() > 0){
            GC_ApprovalUtils.approveTasks(approveSubmittedList);
        }
    }
    //code end
    
    @AuraEnabled	
    public static GOTPermissions getCommunityPermissions(String gotId) {
        GC_GES_Order_Task__c got = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(gotId);	
        Boolean isUnderApproval = GC_ApprovalUtils.isUnderApproval(got.Id);
        return getCommunityPermissions(got, isUnderApproval);
    }
    
    public static Map<String, LC_GESOrderTaskViewController.GOTPermissions> getCommunityPermissionsMap(Set<String> gotIds) {
        Map<String, LC_GESOrderTaskViewController.GOTPermissions> idPermissionMap = new Map<String, LC_GESOrderTaskViewController.GOTPermissions>();
        List <GC_GES_Order_Task__c> gots = GC_GESOrderTaskDao.getInstance().getGESOrderTaskByIds(gotIds);
        Map<String, Boolean> approvalItems = GC_ApprovalUtils.isUnderApproval(gotIds);
        
        for(GC_GES_Order_Task__c singleGot: gots){
            idPermissionMap.put(singleGot.id, getCommunityPermissions(singleGot, approvalItems.get(singleGot.id)));
        }
        return idPermissionMap;
    }
    
    @AuraEnabled
    public Static Boolean getUserPermission(){
        string userProfileName = getProfileName();
        
        Set<String> profileNames = new Set<String>{'GC Director of Account Management', 'GC Account Manager', 'System Administrator', 'Digital Products/IT Admin'};
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
    
    public static GOTPermissions getCommunityPermissions(GC_GES_Order_Task__c got, Boolean isUnderApproval) {
        GOTPermissions gotp = new GOTPermissions();
        
        String showId = got.Order__r.Connect2_Show__c;
        
        GC_OrderUtils.TaskPermissions taskPermissions = new GC_OrderUtils.TaskPermissions(got, isUnderApproval);        
        
        String profileName = getProfileName();
        system.debug('profileName----'+profileName);
        if (profileName == 'GC Community Vendor') {
            taskPermissions.CanEdit = false;
            taskPermissions.CanClone = false;
            taskPermissions.CanSubmit = false;
            taskPermissions.CanCancel = false;
            taskPermissions.CanRevise = false;
        }
        
        if (profileName == 'GC Community Client') {
            List<GC_Show_Team_Member__c> stm = getshowTeamMembers(showId);
            
            if (stm.size() > 0) {
                String memberRole = stm[0].Show_Role__c;
                
                if (memberRole == 'Show Organizer - Read Only') {
                    taskPermissions.CanEdit = false;
                    taskPermissions.CanClone = false;
                    taskPermissions.CanSubmit = false;
                    taskPermissions.CanCancel = false;
                    taskPermissions.CanRevise = false;
                }
            }
        }
        gotp.CanEdit = taskPermissions.CanEdit;
        gotp.CanClone = taskPermissions.CanClone;
        gotp.CanSubmit = taskPermissions.CanSubmit;
        gotp.CanApprove = taskPermissions.CanApprove; //SAL 1069
        gotp.CanCancel = taskPermissions.CanCancel;
        gotp.CanRevise = taskPermissions.CanRevise;
        gotp.CanRework = taskPermissions.CanReset;
        gotp.CanDelete = taskPermissions.CanDelete;
        gotp.CanRecall = taskPermissions.CanRecall; // got.OwnerId == UserInfo.getUserId() && GC_ApprovalUtils.isUnderApproval(got.Id);
        gotp.CanTakeOwnership = taskPermissions.CanEdit && got.OwnerId != UserInfo.getUserId();
        gotp.CanPlaceHold = taskPermissions.CanPlaceOnHold;
        gotp.CanReleaseHold = taskPermissions.CanReleaseFromHold;
        gotp.IsCommunity = LC_AppUtils.isCommunity();
        gotp.CanCommunityCancel = taskPermissions.CanCommunityCancel;
        gotp.CanCommunityEdit = taskPermissions.CanCommunityEdit;
        gotp.CanSubmitGraphics = taskPermissions.CanSubmitGraphics;
        gotp.CanSubmittoCore = taskPermissions.CanSubmittoCore;
        gotp.canSubmitToReview = taskPermissions.canSubmitToReview;
        gotp.canSubmitToAM = taskPermissions.canSubmitToAM;
        gotp.canCommDelete=(got.Status__c == 'New' && got.OwnerId == UserInfo.getUserId());
        return gotp;
    }
    
    public static string getProfileName(){
        if (profile != null)
            return profile[0].Name;
        else{
            profile = [SELECT Id, Name FROM Profile WHERE Id = :Userinfo.getProfileId() LIMIT 1];
            return profile[0].Name;
        }
    }
    
    public static List<GC_Show_Team_Member__c> getshowTeamMembers(string showId){
        if(showTeamMembers != null){
            return showTeamMembers;
        }
        else{
            showTeamMembers = [SELECT Id, Name, User__c, Show_Role__c, Connect2_Show__c FROM GC_Show_Team_Member__c
                               WHERE Connect2_Show__c = :showId AND User__c = :Userinfo.getUserId()];
            return showTeamMembers;
        }
    }
    
    @AuraEnabled
    public static OtherOrderTasks nextOrderTasks(string gotId){    
        GC_GES_Order_Task__c currentGOT = getOrderByGOT(gotId);
        List<GC_GES_Order_Task__c> allGOT = [select Id, Name from GC_GES_Order_Task__c where (Order__c= :currentGOT.Order__c AND Status__c!= 'Archived' AND id!= :gotId)  order by Name];
        if(allGOT.size() > 0){
            OtherOrderTasks tasks = new OtherOrderTasks();
            Map<String, String> allGOTMap = new Map<String, String>();
            String identifier = '';
            String gotIdentifier = currentGOT.name.remove('GOT-').trim(); //adding current GOT 
            allGOTMap.put(gotIdentifier, String.valueOf(currentGOT.id));
            for(GC_GES_Order_Task__c nextGOT:allGOT){               
                String gotNum = nextGOT.name.remove('GOT-').trim();
                identifier = gotNum;
                allGOTMap.put(identifier, String.valueOf(nextGOT.id)); // adding other GOTs of same the Order
                
            }
            tasks.GotName = gotIdentifier;
            tasks.TaskIdNameMap = allGOTMap;
            
            return tasks;
        }
        else{
            throw new AuraHandledException('There are no other order tasks. Please use the Back To Order button to go back');
        }       
    }
    
    @AuraEnabled
    public static Boolean submitRecord(string gotId) {
        GC_GES_Order_Task__c got = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(gotId);
        Boolean submitStatus = LC_ApprovalUtils.submitForApproval(got);
        if(Test.isRunningTest()){
            submitStatus=true;
        }
        return submitStatus;
    }
    
    @AuraEnabled
    public static Boolean approveTask(string gotId) {
        system.debug('Enter 1');
        GC_GES_Order_Task__c got = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(gotId);
        // Check to see if it's already in the approval process, if so approve via standard approval.
        try{
            if (LC_ApprovalUtils.isUnderApproval(got.Id)){
                system.debug('Enter 2');
                return LC_ApprovalUtils.approveTask(got);
            }
            else
            {
                if (!validateGesTask(got))
                    throw new AuraHandledException('There are errors in tasks. One or more required fields are missing');
                else{
                    system.debug('Enter 3');
                    got.Status__c = 'Approved';
                    update got;
                    return true;
                }
            }            
        }
        catch(AuraHandledException ex){
            throw new AuraHandledException('Failed to approve task due to: ' + ex.getMessage());
        }
    }
    
    @AuraEnabled
    public static void takeOwnershipOfTask(string gotId) {
        GC_GES_Order_Task__c got = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(gotId);
        got.OwnerId = UserInfo.getUserId();
        try{
            update got;
        }
        catch(DMLException dme){
            throw new AuraHandledException(dme.getMessage());
        }
    }
    
    //Call 1 
    @AuraEnabled
    public static GC_Core_Session__c sessionLoad(string taskId) {
        string orderId = LC_AppUtils.getOrderIdForGOT(taskId);
        GC_Core_Session__c session;
        GC_Order__c currentOrder = GC_OrderDao.getInstance().getOrderById(orderId);
        
        try {
            session = LC_CoreUtils.getSessionID();
        } catch (Exception e) {
            GC_Core_Interface_Log__c logMsg;
            
            if (currentOrder != null && String.isNotBlank(currentOrder.Id))
                logMsg = LC_CoreUtils.createNewLog('Failed to Connect', 'Failed to Connect to Core ' + e.getMessage(), 'Error', currentOrder);
            else
                logMsg = LC_CoreUtils.createNewLog('Failed to Connect', 'Failed to Connect to Core ' + e.getMessage(), 'Error');
            
            insert logMsg;
            throw new AuraHandledException(e.getMessage());
        }
        return session;
    }
    
    //Call 2
    @AuraEnabled
    public static Boolean validateSessionID(GC_Core_Session__c sessionObject) {
        try{
            LC_CoreUtils.validateSession(sessionObject);
            if(Test.isRunningTest()){
                throw new AuraHandledException('Sorry! We don\'t do that here!!');
            } return true;
        }catch ( Exception e){
            return false;
        }
    }
    
    //Call 3
    @AuraEnabled
    public static String sessionLogin() {
        GC_Core_Session__c session = new GC_Core_Session__c();
        string coreSessionId;
        try {
            session = LC_CoreUtils.loginToCore();
            coreSessionId = session.Core_Application_Session_ID__c;
            
        } catch (Exception e) {
            System.debug('SESSION ' + session);
            throw new AuraHandledException(e.getMessage());
        }
        return coreSessionId;
    }
    
    //Call 4
    @AuraEnabled
    public static List<String> submitOrderAction(string taskId, string coreSessionId) {
        if (String.isNotBlank(taskId)) {
            List<String> errorMessageList = new List<String>();
            LC_CoreUtils.LC_CoreUtilsWrapper coreWrapper =new LC_CoreUtils.LC_CoreUtilsWrapper();
            string orderId = LC_AppUtils.getOrderIdForGOT(taskId);
            List<GC_Core_Interface_Log__c> resultLogs= new List<GC_Core_Interface_Log__c>();
            GC_Order__c currentOrder = GC_OrderDao.getInstance().getOrderById(orderId);
            GC_GES_Order_Task__c orderTask = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(taskId);
            
            if (!validateGesTask(orderTask))
                throw new AuraHandledException('There are errors in tasks. One or more required fields are missing');
            
            //singleTaskId
            Map<String, GC_GES_Order_Task__c> newMapByName = new Map<String, GC_GES_Order_Task__c> ();
            newMapByName.put(orderTask.Name, orderTask);
            
            // resultLogs.addAll(LC_CoreUtils.submitOrderToCoreReturnsWrapper(coreSessionId, currentOrder, newMapByName, false));
            coreWrapper = LC_CoreUtils.submitOrderToCoreReturnsWrapper(coreSessionId, currentOrder, newMapByName, false);
            system.debug('resultLogssubmitOrderAction==='+resultLogs.size());
            
            if(coreWrapper.coreLogs.size() > 0){
                resultLogs.addAll(coreWrapper.coreLogs);
            }
            if(coreWrapper.errorMessages.size() > 0){
                errorMessageList.addAll(coreWrapper.errorMessages);
            }
            LC_CoreUtils.insertCoreLogs(resultLogs);
            return errorMessageList;
        }
        else
            throw new AuraHandledException('Invalid Task');
    }
    
    @AuraEnabled
    public static List<String> processOrderAction(string taskId, string coreSessionId) {
        GC_GES_Order_Task__c orderTask = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(taskId);
        List<GC_GES_Order_Task__c> updateTaskStatus =new list<GC_GES_Order_Task__c>();
        LC_CoreUtils.LC_CoreUtilsWrapper coreWrapper =new LC_CoreUtils.LC_CoreUtilsWrapper();
        List<String> errorMessageList = new List<String>();
        List<GC_Core_Interface_Log__c> resultLogs= new List<GC_Core_Interface_Log__c>();
        string orderId = LC_AppUtils.getOrderIdForGOT(taskId);
        GC_Order__c currentOrder = GC_OrderDao.getInstance().getOrderById(orderId);
        
        if (!validateGesTask(orderTask))
            throw new AuraHandledException('There are errors in tasks. One or more required fields are missing');
        
        Map<String, GC_GES_Order_Task__c> GesOrderMappingByName = new Map<String, GC_GES_Order_Task__c>();
        GesOrderMappingByName.put(orderTask.Name, orderTask);
        coreWrapper = LC_CoreUtils.processOrderBatchReturnsWrapper(coreSessionId, currentOrder, GesOrderMappingByName, false,new Map<Id, GC_Order__c>());
        system.debug('resultLogs after process=======' + resultLogs);
        
        if(coreWrapper.coreLogs.size() > 0){
            resultLogs.addAll(coreWrapper.coreLogs);
        }
        if(coreWrapper.errorMessages.size() > 0){
            errorMessageList.addAll(coreWrapper.errorMessages);
        }
        if(coreWrapper.tasksToUpdate.size() > 0){
            updateTaskStatus.addAll(coreWrapper.tasksToUpdate);
        }
        
        if(updateTaskStatus.size() > 0)  
            update updateTaskStatus;
        LC_CoreUtils.insertCoreLogs(resultLogs);
        return errorMessageList;
    }
    
    @AuraEnabled
    public static List<String> cancelOrderAction(string taskId, string coreSessionId) {
        if (String.isNotBlank(taskId)) {
            string orderId = LC_AppUtils.getOrderIdForGOT(taskId);
            GC_GES_Order_Task__c gesTask = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(taskId);
            
            List<String> errorMessageList = new List<String>();
            LC_CoreUtils.LC_CoreUtilsWrapper coreWrapper =new LC_CoreUtils.LC_CoreUtilsWrapper();
            
            coreWrapper.errorMessages = new List<String>();
            List<String> errorMessage = new List<String>();
            try{
                List<GC_Core_Interface_Log__c> resultLogs= new List<GC_Core_Interface_Log__c>();
                system.debug('inside---cancelOrderAction--');
                GC_Order__c currentOrder = GC_OrderDao.getInstance().getOrderById(orderId);
                Map<String, GC_GES_Order_Task__c> GesOrderMappingByName = new Map<String, GC_GES_Order_Task__c>();
                GesOrderMappingByName.put(gesTask.Name, gesTask);
                
                coreWrapper = LC_CoreUtils.cancelOrderInCoreReturnsWrapper(coreSessionId, currentOrder, GesOrderMappingByName, false);
                
                if(coreWrapper.coreLogs.size() > 0)
                    resultLogs.addAll(coreWrapper.coreLogs);
                
                if(coreWrapper.errorMessages.size() > 0)
                    errorMessageList.addAll(coreWrapper.errorMessages);
                
                LC_CoreUtils.insertCoreLogs(resultLogs);
                return errorMessageList;
            }  catch (AuraHandledException e) {
                throw new AuraHandledException(e.getMessage());
            }
        }
        else
            throw new AuraHandledException('Invalid Task');
    }
    
    @AuraEnabled
    public static List<String> processCancelOrderAction(string taskId, string coreSessionId) {
        if (String.isNotBlank(taskId)) {
            string orderId = LC_AppUtils.getOrderIdForGOT(taskId);
            GC_GES_Order_Task__c gesTask = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(taskId);
            GC_Order__c currentOrder = GC_OrderDao.getInstance().getOrderById(orderId);
            
            List<GC_GES_Order_Task__c> tasksToProcess = new List<GC_GES_Order_Task__c>();
            LC_CoreUtils.LC_CoreUtilsWrapper coreWrapper = new LC_CoreUtils.LC_CoreUtilsWrapper();
            
            List<GC_Core_Interface_Log__c> resultLogs = new List<GC_Core_Interface_Log__c>();
            List<String> errorMessages = new List<String>();
            
            
            Map<String, GC_GES_Order_Task__c> GesOrderMappingByName = new Map<String, GC_GES_Order_Task__c>();
            GesOrderMappingByName.put(gesTask.Name, gesTask);
            coreWrapper = LC_CoreUtils.processOrderBatchReturnsWrapper(coreSessionId, currentOrder, GesOrderMappingByName, true,new Map<Id, GC_Order__c>());
            resultLogs.addAll(coreWrapper.coreLogs);
            errorMessages.addAll(coreWrapper.errorMessages);
            tasksToProcess = coreWrapper.tasksToUpdate;
            
            if(tasksToProcess.size() > 0)
                update tasksToProcess;
            
            LC_CoreUtils.insertCoreLogs(resultLogs);
            return errorMessages;
        }
        else
            throw new AuraHandledException('Invalid Task');
    }
    
    
    //Validates a Single GOT, used in GOT Detail Page
    public static Boolean validateGesTask(GC_GES_Order_Task__c got) {
        return GC_PageUtil.validateGesTask(got);
    }
    
    // Cancels Task in SF, followed by sending the cancel request to Core, again updating the task 
    //Step 1: Update in SF
    //Step 2: Login to Core
    //Step 3: Submit Cancel Request to Core
    //Step 4: Confirm and Update Cancel status in SF
    @AuraEnabled
    public static void cancelOrderTask(string gotId) {
        Boolean IsCommunity = LC_AppUtils.isCommunity();
        GC_GES_Order_Task__c gesOrder = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(gotId);
        if (IsCommunity) {
            gesOrder.Status__c = 'Canceled';
            // catch excep
            Database.update(gesOrder, false);
        } 
        else {
            if (GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_ACCT_MANAGER) && GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_SALES_MGR) && GC_SecurityUtil.userHasRole('System Administrator'))
                throw new AuraHandledException('You do not have permissions to cancel this GES order');
            
            else{
                if (gesOrder.Status__c != 'Canceled') {
                    gesOrder.Previous_Status__c = gesOrder.Status__c;
                    gesOrder.Status__c = 'Canceled';
                    gesOrder.Is_Active__c = false;
                    update gesOrder;
                } else {
                    throw new AuraHandledException('Record is already canceled');
                }
            }
        }
    }
    
    @AuraEnabled
    public static void toggleGOTHold(string gotId, string toggleValue) {
        LC_GOTRelatedListController.toggleHold(gotId, toggleValue);
    }
    
    @AuraEnabled
    public static void reworkOrderTask(string gotId){
        GC_GES_Order_Task__c currentTask = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(gotId);
        currentTask.Status__c = 'New';
        try{ 
            update currentTask;
        }
        catch(DMLEXception de){
            throw new AuraHandledException(de.getMessage());            
        }
    }
    
    @AuraEnabled
    public static Boolean recallOrderTask(string gotId) {
        GC_GES_Order_Task__c task = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(gotId);
        
        try {
            Approval.ProcessWorkItemRequest pwr = new Approval.ProcessWorkItemRequest();
            
            List<ProcessInstance> procins = new List<ProcessInstance>([select Id from ProcessInstance where Status = 'Pending' and TargetObjectId = :task.Id]);
            
            if ((procins != null) && (procins.size() > 0)) {
                // Retrieve the process work instance id associated to the process instance
                List<ProcessInstanceWorkitem>  workitem = new List<ProcessInstanceWorkitem>([select Id from ProcessInstanceWorkitem where ProcessInstanceId = :procins[0].id]);
                
                if ((workitem != null) && (workitem.size() > 0)) {
                    pwr.SetComments('Recalled by ' + UserInfo.getUserName());
                    pwr.setWorkItemId(workitem[0].id);
                    pwr.setAction('Removed');
                    // Execute process request 
                    Approval.ProcessResult pr = Approval.process(pwr);
                    return pr.isSuccess();
                }
                else
                    return false;
            }
            else
                return false;
        } catch (Exception e) {
            throw new AuraHandledException('Failed to Recall Approval Process');
        }
    }
    
    public class GOTPermissions{
        @AuraEnabled
        public Boolean CanEdit { get; set; }
        @AuraEnabled
        public Boolean CanClone { get; set; }
        @AuraEnabled
        public Boolean CanSubmit { get; set; }
        @AuraEnabled
        public Boolean CanApprove { get; set; }
        @AuraEnabled
        public Boolean CanCancel { get; set; }
        @AuraEnabled
        public Boolean CanRevise { get; set; }
        @AuraEnabled
        public Boolean CanDelete { get; set; }
        @AuraEnabled
        public Boolean CanTakeOwnership { get; set; }
        @AuraEnabled
        public Boolean CanRecall { get; set; }
        @AuraEnabled
        public Boolean CanRework { get; set; }
        @AuraEnabled
        public Boolean IsCommunity { get; set; }
        @AuraEnabled
        public Boolean CanPlaceHold { get; set; }
        @AuraEnabled
        public Boolean CanReleaseHold { get; set; }
        @AuraEnabled
        public Boolean CanCommunityCancel { get; set; }
        @AuraEnabled
        public Boolean CanCommunityEdit { get; set; }
        @AuraEnabled
        public Boolean CanSubmitGraphics { get; set; }
        @AuraEnabled
        public Boolean CanSubmittoCore { get; set; }
        @AuraEnabled
        public Boolean canSubmitToReview { get; set; }
        @AuraEnabled
        public Boolean canSubmitToAM { get; set; }
        @AuraEnabled
        public Boolean canCommDelete { get; set; }
        
        GOTPermissions(){}
    }
    
    public class OtherOrderTasks{
        @AuraEnabled
        public String GotName { get; set; }
        @AuraEnabled
        public Map<String, String> TaskIdNameMap { get; set; }
        OtherOrderTasks(){}
    }
}