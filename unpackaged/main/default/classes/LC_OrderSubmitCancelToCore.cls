public with sharing class LC_OrderSubmitCancelToCore extends GC_BaseViewController{
    
    public class applicationException extends Exception {}
    
    // Task mapping in a specific order.
  /*  public Map<String, GC_GES_Order_Task__c> GesOrderMapping {get; set;}
    public Map<String, GC_GES_Order_Task__c> GesOrderMappingByName {get; set;}
    
    public static User currentUserInfo;
    public string orderTaskId {get; set;}
    public List<GC_Core_Interface_Log__c> resultLogs= new List<GC_Core_Interface_Log__c>();
    GC_Core_Session__c sessionObject = new GC_Core_Session__c(); */
    
    @AuraEnabled
    public static list<GC_GES_Order_Task__c> getAllGot(id recordId){
        list<GC_GES_Order_Task__c> gotList = new list<GC_GES_Order_Task__c>(); 
        //system.debug('inside gotList----');
        String activeStatus = 'Active';
        String canceledStatus = 'Canceled';
        /*
        String whereClause1 = 'Order__c = \'' + recordId + '\' AND Status__c = \'' + activeStatus + '\'';
        String whereClause = 'Order__c = \'' + recordId + '\' AND Status__c = \'' + canceledStatus+'\'' ;
        list<GC_GES_Order_Task__c> activeGotList = new list<GC_GES_Order_Task__c>(); 
        list<GC_GES_Order_Task__c> canceledGotList = new list<GC_GES_Order_Task__c>(); 
        activeGotList = GC_GESOrderTaskDao.getInstance().getByWhere(whereClause1);
        canceledGotList = GC_GESOrderTaskDao.getInstance().getByWhere(whereClause);
        gotList.addAll(activeGotList);
        gotList.addAll(canceledGotList);
		*/        
        
        Boolean cancelStatusBoolean = false;
        String whereClause2 = 'Order__c = \''+recordId+'\' AND ( Status__c = \''+activeStatus+'\' OR Status__c = \''+canceledStatus+'\''+') AND Core_Cancelled__c ='+cancelStatusBoolean;
       // system.debug('whereClause2==='+whereClause2);
        gotList = GC_GESOrderTaskDao.getInstance().getByWhere(whereClause2);
        //system.debug('gotList----'+gotList);
        return gotList;  
    }
    
    
    @AuraEnabled
    public static GC_Core_Session__c sessionLoad(id currentOrderId){
        GC_Order__c currentOrder = GC_OrderDao.getInstance().getOrderById(currentOrderId);
        GC_Core_Session__c session;
        try {
            session = LC_CoreUtils.getSessionID();
            if(Test.isRunningTest())
            {
                session = GC_TestUtils.createTestSession(); 
                //throw new applicationException('Sorry! We don\'t do that here!!');
            }  
            return session;
        } catch (Exception e) {
            GC_Core_Interface_Log__c logMsg;
            if (currentOrder != null && String.isNotBlank(currentOrder.Id)) {
                logMsg = LC_CoreUtils.createNewLog('Failed to Connect', 'Failed to Connect to Core ' + e.getMessage(), 'Error', currentOrder);
            } else {
                logMsg = LC_CoreUtils.createNewLog('Failed to Connect', 'Failed to Connect to Core ' + e.getMessage(), 'Error');
            }
            insert logMsg;
            String errorMessage = 'Failed to Connect'+', Failed to Connect to Core ' + e.getMessage()+' Error';
            throw new AuraHandledException(errorMessage);
        }
    }
    
    @AuraEnabled
    public static Boolean validateSessionID(GC_Core_Session__c sessionObject) {
        try{
            LC_CoreUtils.validateSession(sessionObject);
            if(Test.isRunningTest())
            {
                throw new applicationException('Sorry! We don\'t do that here!!');
            } return true;
        }catch ( Exception e){
            return false;
        }
    }
    
    @AuraEnabled
    public static String sessionLogin() {
        GC_Core_Session__c session = new GC_Core_Session__c();
        string coreSessionId;
        try {
            session = LC_CoreUtils.loginToCore();
            coreSessionId = session.Core_Application_Session_ID__c;
        } catch (Exception e) {
           // System.debug('SESSION ' + session);
            throw new AuraHandledException(e.getMessage());
        } 
        return coreSessionId;
    }
    
    @AuraEnabled
    public static LC_CoreUtils.LC_CoreUtilsWrapper submitOrderAction(string currentOrderId, string coreSessionId) {
        LC_CoreUtils.LC_CoreUtilsWrapper LC_CoreWrapper =new LC_CoreUtils.LC_CoreUtilsWrapper();
        List<String> errorMessageList =new list<String>();
        List<GC_GES_Order_Task__c> updateTaskStatus =new list<GC_GES_Order_Task__c>();
        try{
            List<GC_Core_Interface_Log__c> resultLogs= new List<GC_Core_Interface_Log__c>();
            //system.debug('inside---submitOrderAction--');
            GC_Order__c currentOrder = GC_OrderDao.getInstance().getOrderById(currentOrderId);
            List<GC_GES_Order_Task__c> gesTasks = GC_GESOrderTaskDao.getInstance().getByGesOrderIdAndExcludeStatus(currentOrder.Id, 'Archived');
            set<String> taskIds = getTaskIds(currentOrderId);
            Map<String, GC_GES_Order_Task__c> GesOrderMappingByName = getGesOrderMappingByName(currentOrderId);
            for(String singleTaskId : taskIds){
                if (!validateGesTasks(currentOrderId,singleTaskId,GesOrderMappingByName)) {
                   // system.debug('validation failed---submitOrderAction--');
                }
                if ( String.isNotBlank(singleTaskId)) {
                    Map<String, GC_GES_Order_Task__c> newMapByName = new Map<String, GC_GES_Order_Task__c> ();
                    for (GC_GES_Order_Task__c orderTask : GesOrderMappingByName.values()) {
                        if (orderTask.Id == singleTaskId) {
                            newMapByName.put(orderTask.Name, orderTask);
                        }
                    }
                    if (newMapByName.size() > 0) {
                       // System.debug('submitOrderAction dml executed--->'+Limits.getDmlStatements());
                        LC_CoreWrapper = LC_CoreUtils.submitOrderToCoreReturnsWrapper(coreSessionId, currentOrder, newMapByName, false);
                        if(LC_CoreWrapper.coreLogs.size() != 0){
                            resultLogs.addAll(LC_CoreWrapper.coreLogs);
                        }
                        if(LC_CoreWrapper.errorMessages.size() >0 ){
                            errorMessageList.addAll(LC_CoreWrapper.errorMessages);
                        }
                        if(LC_CoreWrapper.tasksToUpdate.size() > 0){
                            updateTaskStatus.addAll(LC_CoreWrapper.tasksToUpdate);
                        }
                    }
                }
                else {
                    LC_CoreWrapper = LC_CoreUtils.submitOrderToCoreReturnsWrapper(coreSessionId, currentOrder, GesOrderMappingByName, false);
                    if(LC_CoreWrapper.coreLogs.size() != 0){
                        resultLogs.addAll(LC_CoreWrapper.coreLogs);
                    }
                    if(LC_CoreWrapper.errorMessages.size() >0 ){
                        errorMessageList.addAll(LC_CoreWrapper.errorMessages);
                    }
                    if(LC_CoreWrapper.tasksToUpdate.size() > 0){
                        updateTaskStatus.addAll(LC_CoreWrapper.tasksToUpdate);
                    }
                }
            }
            if(updateTaskStatus.size() != 0){
                update updateTaskStatus;
            }
            //system.debug('LC_CoreWrapper--errorMessages========='+LC_CoreWrapper.errorMessages);
            //system.debug('resultLogssubmitOrderAction==='+resultLogs);
            //system.debug('resultLogssubmitOrderAction==='+resultLogs.size());
            LC_CoreUtils.insertCoreLogs(resultLogs);
            if(errorMessageList.size() > 0){
                LC_CoreWrapper.errorMessages = errorMessageList;
            }
            //system.debug('LC_CoreWrapper.errorMessages----final errors--'+LC_CoreWrapper.errorMessages);
            return LC_CoreWrapper;
        }catch(AuraHandledException e){
            //system.debug('e---'+e);
            throw e;
        }catch(LC_CoreUtils.LC_CoreUtilsException e){
           // system.debug('Submit order to core Method---'+e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    public static set<String> getTaskIds( id currentOrderId){
        GC_Order__c currentOrder = GC_OrderDao.getInstance().getOrderById(currentOrderId);
        List<GC_GES_Order_Task__c> gesTasks = GC_GESOrderTaskDao.getInstance().getByGesOrderIdAndExcludeStatus(currentOrder.Id, 'Archived');
        set<String> taskIds = new set<String>();
        for(GC_GES_Order_Task__c singleTask : gesTasks){
            taskIds.add(singleTask.Id);
        }
        return taskIds;
    }
    
    public static Map<String, GC_GES_Order_Task__c> getGesOrderMappingByName( id currentOrderId){
        GC_Order__c currentOrder = GC_OrderDao.getInstance().getOrderById(currentOrderId);
        List<GC_GES_Order_Task__c> gesTasks = GC_GESOrderTaskDao.getInstance().getByGesOrderIdAndExcludeStatus(currentOrder.Id, 'Archived');
        Map<String, GC_GES_Order_Task__c> GesOrderMappingByName = new Map<String, GC_GES_Order_Task__c>();
        for(GC_GES_Order_Task__c singleTask : gesTasks){
            GesOrderMappingByName.put(singleTask.Name, singleTask);
        }
        return GesOrderMappingByName;
    }
    
    public static Map<String, GC_GES_Order_Task__c> getGesOrderMappingByName( id currentOrderId,List<GC_GES_Order_Task__c> gesTasks){
        GC_Order__c currentOrder = GC_OrderDao.getInstance().getOrderById(currentOrderId);
        Map<String, GC_GES_Order_Task__c> GesOrderMappingByName = new Map<String, GC_GES_Order_Task__c>();
        for(GC_GES_Order_Task__c singleTask : gesTasks){
            GesOrderMappingByName.put(singleTask.Name, singleTask);
        }
        return GesOrderMappingByName;
    }
    
    @AuraEnabled
    public static LC_CoreUtils.LC_CoreUtilsWrapper processOrderAction(id currentOrderId,String coreSessionId) {
        LC_CoreUtils.LC_CoreUtilsWrapper LC_CoreWrapper = new LC_CoreUtils.LC_CoreUtilsWrapper();
        List<GC_Core_Interface_Log__c> resultLogs= new List<GC_Core_Interface_Log__c>();
        set<String> taskIds = getTaskIds(currentOrderId);
        Map<String, GC_GES_Order_Task__c> GesOrderMappingByName = getGesOrderMappingByName(currentOrderId);
        for(String singleTaskId : taskIds){
            if (!validateGesTasks(currentOrderId,singleTaskId,GesOrderMappingByName)) {
               // system.debug('validation failed---submitOrderAction--');
            }
        }
        GC_Order__C currentOrder = GC_OrderDao.getInstance().getOrderById(currentOrderId);
        LC_CoreWrapper = LC_CoreUtils.processOrderBatchReturnsWrapper(coreSessionId, currentOrder, GesOrderMappingByName, false, new Map<Id, GC_Order__c>());
        update LC_CoreWrapper.tasksToUpdate;
        insert LC_CoreWrapper.coreLogs;
        return LC_CoreWrapper;
    }
    
    
    
    /**-----------------np---LC------------
* @description Validates the approved GES Tasks for Required Fields.
* @return True if valid, false otherwise.
**/
    public Static Boolean validateGesTasks(String currentOrderId,String singleTaskId,  Map<String, GC_GES_Order_Task__c> GesOrderMappingByName) {
        List<GesTaskWrapper> gesOrderTasks = new List<GesTaskWrapper>();
        Map<String, GC_GES_Order_Task__c> GesOrderMapping = new Map<String, GC_GES_Order_Task__c>();
        List<GC_GES_Order_Task__c> gesTasks = GC_GESOrderTaskDao.getInstance().getByGesOrderIdAndExcludeStatus(currentOrderId, 'Archived');
        for (GC_GES_Order_Task__c task : gesTasks) {
            if (task.Status__c == 'Archived') {
                continue;
            }
            GesTaskWrapper wrapper = new GesTaskWrapper();
            wrapper.task = task;
            wrapper.fileCount = task.ContentDocumentLinks.size();
            gesOrderTasks.add(wrapper);
        }
        for (GesTaskWrapper gesOrder : gesOrderTasks) {
            GesOrderMapping.put(gesOrder.task.Id, gesOrder.task);
        }
        Boolean statusval = false;
        Set<String> errors = new Set<String>();
        Integer index = 1;
        if ( String.isNotBlank(singleTaskId)) {
            Map<String, GC_GES_Order_Task__c> newMapping = new Map<String, GC_GES_Order_Task__c> ();
            for (GC_GES_Order_Task__c orderTask : GesOrderMapping.values()) {
                if (orderTask.Id == singleTaskId) {
                    newMapping.put(orderTask.Id, orderTask);
                }
            }
            if (newMapping.size() > 0) {
                for (GC_GES_Order_Task__c orderTask : newMapping.values()) {
                    if (orderTask.Status__c == 'Approved') {
                        if (!validateGesTask(index, orderTask)) {
                            errors.add('Order Task ' + orderTask.Name + ' has failed validation');
                        }
                        index++;
                    }
                }
            }
        }
        else {
            for (GC_GES_Order_Task__c orderTask : GesOrderMapping.values()){
                if (orderTask.Status__c == 'Approved') {
                    if (!validateGesTask(index, orderTask)) {
                        errors.add('Order Task ' + orderTask.Name + ' has failed validation');
                    }
                    index++;
                }
            }
        }
        return errors.size() == 0;
    }
    /**
* @description Calls out to web service to submit items to cancel and push in staging area.
* @return Returns a Wrapper.
**/
    @AuraEnabled
    public static LC_CoreUtils.LC_CoreUtilsWrapper cancelOrderAction(string currentOrderId, string coreSessionId,list<GC_GES_Order_Task__c> gesTasks) {
        LC_CoreUtils.LC_CoreUtilsWrapper LC_CoreWrapper = new LC_CoreUtils.LC_CoreUtilsWrapper();
        LC_CoreWrapper.errorMessages = new List<String>();
        List<GC_Core_Interface_Log__c> coreLogs = new List<GC_Core_Interface_Log__c>();
        List<String> errorMessage = new List<String>();
        LC_CoreWrapper.tasksToUpdate = new List<GC_GES_Order_Task__c>();
        try{
            List<GC_Core_Interface_Log__c> resultLogs= new List<GC_Core_Interface_Log__c>();
            //system.debug('inside---cancelOrderAction--');
            GC_Order__c currentOrder = GC_OrderDao.getInstance().getOrderById(currentOrderId);
            Map<String, GC_GES_Order_Task__c> GesOrderMappingByName = getGesOrderMappingByName(currentOrderId, gesTasks);
            
            LC_CoreUtils.LC_CoreUtilsWrapper LC_CoreCancelWrapper = new LC_CoreUtils.LC_CoreUtilsWrapper();
            
            LC_CoreCancelWrapper = LC_CoreUtils.cancelOrderInCoreReturnsWrapper(coreSessionId, currentOrder, GesOrderMappingByName, false);
            resultLogs.addAll(LC_CoreCancelWrapper.coreLogs);
            LC_CoreWrapper.errorMessages.addAll(LC_CoreCancelWrapper.errorMessages);
            LC_CoreWrapper.tasksToUpdate.addAll(LC_CoreCancelWrapper.tasksToUpdate);
          
            update LC_CoreWrapper.tasksToUpdate;
            LC_CoreUtils.insertCoreLogs(resultLogs);
            //system.debug('LC_CoreWrapper.errorMessages==='+LC_CoreWrapper.errorMessages);
           // system.debug('LC_CoreWrapper.tasksToUpdate==='+LC_CoreWrapper.tasksToUpdate);
            
            return LC_CoreWrapper; 
        }  catch (AuraHandledException e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    /**
* @description Calls out to web service to process staging items.
* @return Returns a null page refernce for proper rerendering.
**/
    @AuraEnabled
    public static LC_CoreUtils.LC_CoreUtilsWrapper processCancelOrderAction(string currentOrderId, string coreSessionId,list<GC_GES_Order_Task__c> gesTasks) {
        try{
            LC_CoreUtils.LC_CoreUtilsWrapper LC_CoreWrapper = new LC_CoreUtils.LC_CoreUtilsWrapper();
            LC_CoreWrapper.errorMessages = new List<String>();
            List<GC_Core_Interface_Log__c> coreLogs = new List<GC_Core_Interface_Log__c>();
            List<String> errorMessage = new List<String>();
            LC_CoreWrapper.tasksToUpdate = new List<GC_GES_Order_Task__c>();
            List<GC_Core_Interface_Log__c> resultLogs= new List<GC_Core_Interface_Log__c>();
            GC_Order__c currentOrder = GC_OrderDao.getInstance().getOrderById(currentOrderId);
            Map<String, GC_GES_Order_Task__c> GesOrderMappingByName = getGesOrderMappingByName(currentOrderId,gesTasks);
            //-------------------------
            LC_CoreUtils.LC_CoreUtilsWrapper LC_CoreProcessCancelWrapper = new LC_CoreUtils.LC_CoreUtilsWrapper();
            LC_CoreProcessCancelWrapper = LC_CoreUtils.processOrderBatchReturnsWrapper(coreSessionId, currentOrder, GesOrderMappingByName, true, new Map<Id, GC_Order__c>());
            resultLogs.addAll(LC_CoreProcessCancelWrapper.coreLogs);
            LC_CoreWrapper.errorMessages.addAll(LC_CoreProcessCancelWrapper.errorMessages);
            LC_CoreWrapper.tasksToUpdate.addAll(LC_CoreProcessCancelWrapper.tasksToUpdate);
            //-------------------------------------
            LC_CoreUtils.insertCoreLogs(resultLogs);
            update LC_CoreWrapper.tasksToUpdate;
            return LC_CoreWrapper; 
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    public Static Boolean validateGesTask(Integer index, GC_GES_Order_Task__c got){
        return GC_PageUtil.validateGesTask(got);
    }
    
    public class GesTaskWrapper{
        public Boolean isRevision {get; set;}
        public Boolean additionalOptions {get; set;}
        public GC_GES_Order_Task__c task {get; set;}
        public Integer fileCount {get; set;}
        public GesTaskWrapper () {
            isRevision = false;
            additionalOptions = false;
            fileCount = 0;
        }
    }
}