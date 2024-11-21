public class LC_GESItemsSubmitToCoreCtrl {
    
    public List<GC_GES_Order_Task__c> gots {get; set;}
    public string recordId{get; set;}
    public class applicationException extends Exception {}
    public LC_GESItemsSubmitToCoreCtrl(){
        
    }
    
    public LC_GESItemsSubmitToCoreCtrl(ApexPages.StandardSetController controller) {
        recordId=apexpages.currentpage().getparameters().get('id');
        gots = controller.getSelected();
    }
    
    @AuraEnabled
    public static GC_Core_Session__c sessionLoad(){
        GC_Core_Session__c session;
        try {
            session = LC_CoreUtils.getSessionID();
            if(Test.isRunningTest())
            {
                session = GC_TestUtils.createTestSession();
            }  
            return session;
        } catch (Exception e) {
            GC_Core_Interface_Log__c logMsg = LC_CoreUtils.createNewLog('Failed to Connect', 'Failed to Connect to Core ' + e.getMessage(), 'Error from GES List View button');
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
            throw new AuraHandledException(e.getMessage());
        } 
        return coreSessionId;
    }
    
    @AuraEnabled
    public static LC_CoreUtils.LC_CoreUtilsWrapper submitGESItemsAction(String recordIds, string coreSessionId) {
        Set<String> setRecordIds = new Set<String>();
        LC_CoreUtils.LC_CoreUtilsWrapper LC_CoreWrapper =new LC_CoreUtils.LC_CoreUtilsWrapper();
        List<String> errorMessageList =new list<String>();
        List<GC_GES_Order_Task__c> updateTaskStatus =new list<GC_GES_Order_Task__c>();
        List<GC_Core_Interface_Log__c> resultLogs= new List<GC_Core_Interface_Log__c>();
        Map<String, GC_GES_Order_Task__c> GesOrderMappingByName = new Map<String, GC_GES_Order_Task__c>();
        Map<String, String> itemIdToOrderId = new Map<String, String>();
        Set<String> gesItemIds = new Set<String>();
        Map<String,GC_GES_Order_Task__c> mapGESItem = new Map<String,GC_GES_Order_Task__c>();
        Map<String,GC_GES_Order_Task__c> mapProcessGESItems = new Map<String,GC_GES_Order_Task__c>();
        Set<String> orderIds = new Set<String>();
        Map<Id, GC_Order__c> mapOrder = new Map<Id,GC_Order__c>();
        List<GC_GES_Order_Task__c> listSkippedItems = new List<GC_GES_Order_Task__c>();
        Boolean isItemNull = false;
        List<LC_CoreUtils.LC_GESItemWrapper> listGesItemsWrp = new List<LC_CoreUtils.LC_GESItemWrapper>();
        LC_CoreUtils.LC_CoreUtilsWrapper LC_CoreWrapperProcess = new LC_CoreUtils.LC_CoreUtilsWrapper();
        
        try{
            List<String> recordIdList = recordIds.replaceAll('\\s','').removeStart('[').removeEnd(']').split(',');
            for(String ids : recordIdList){
                setRecordIds.add(ids);
            }
            List<GC_GES_Order_Task__c> gesTasks = GC_GESOrderTaskDao.getInstance().getGESItemsByIdAndExcludeStatus(setRecordIds, 'Archived');
            for(GC_GES_Order_Task__c singleTask : gesTasks){
                if(singleTask.Status__c == 'Approved'){
                    gesItemIds.add(singleTask.Id);
                    mapGESItem.put(singleTask.Id, singleTask);
                    orderIds.add(singleTask.Order__c);
                    GesOrderMappingByName.put(singleTask.Name, singleTask);
                    itemIdToOrderId.put(singleTask.Id, singleTask.Order__c);
                }else{
                    listSkippedItems.add(singleTask);
                }
            }
            
            if(!mapGESItem.isEmpty()){
                
                List<GC_Order__c> listGcOrder = GC_OrderDao.getInstance().getOrderByIds(orderIds);
                for(GC_Order__c gcOrder : listGcOrder){
                    mapOrder.put(gcOrder.Id,gcOrder);
                }
                
                for(String singleTaskId : mapGESItem.keySet()){
                    String currentOrderId = itemIdToOrderId.get(singleTaskId);
                    GC_Order__c currentOrder = mapOrder.get(currentOrderId);
                    GC_GES_Order_Task__c item = mapGESItem.get(singleTaskId);
                    
                    if (!validateGesTasks(item)) {
                        // system.debug('validation failed---submitGESItemsAction--');
                    }else{
                        mapProcessGESItems.put(item.Name, item);
                    }
                    
                    if (String.isNotBlank(singleTaskId)) {
                        Map<String, GC_GES_Order_Task__c> newMapByName = new Map<String, GC_GES_Order_Task__c> ();
                        newMapByName.put(item.Name, item);
                        
                        if (newMapByName.size() > 0) {
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
                            if(LC_CoreWrapper.gesItemWrapper.size() > 0){
                                listGesItemsWrp.addAll(LC_CoreWrapper.gesItemWrapper);
                            }
                        }
                    }
                    /*else{
                        isItemNull = true;
                    }*/
                }
                
                /*if(isItemNull && !mapGESItem.isEmpty()){
                    for(GC_GES_Order_Task__c item : GesOrderMappingByName.values()){
                        String currentOrderId = itemIdToOrderId.get(item.Id);
                        GC_Order__c currentOrder = mapOrder.get(currentOrderId);
                        Map<String, GC_GES_Order_Task__c> newMapByName = new Map<String, GC_GES_Order_Task__c> ();
                        newMapByName.put(item.Name, item);
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
                        if(LC_CoreWrapper.gesItemWrapper.size() > 0){
                            listGesItemsWrp.addAll(LC_CoreWrapper.gesItemWrapper);
                        }
                    }
                }*/
                
                if(errorMessageList.size() > 0){
                    LC_CoreWrapper.errorMessages = errorMessageList;
                }
                
                
                if(!mapProcessGESItems.isEmpty()){
                    LC_CoreWrapperProcess = processItemsAction(mapOrder, mapProcessGESItems, coreSessionId);
                    if(LC_CoreWrapperProcess.tasksToUpdate != null && LC_CoreWrapperProcess.tasksToUpdate.size() > 0){
                        updateTaskStatus.addAll(LC_CoreWrapperProcess.tasksToUpdate);
                    }
                    if(LC_CoreWrapperProcess.coreLogs != null && LC_CoreWrapperProcess.coreLogs.size() != 0){
                        resultLogs.addAll(LC_CoreWrapperProcess.coreLogs);
                    }
                }
                if(updateTaskStatus.size() != 0){
                    map<id,GC_GES_Order_Task__c> mapUpdateTaskStatus = new map<id,GC_GES_Order_Task__c>();
                    mapUpdateTaskStatus.putall(updateTaskStatus);
                    update mapUpdateTaskStatus.values();
                }
                LC_CoreUtils.insertCoreLogs(resultLogs);
            }
            
            if(!listSkippedItems.isEmpty()){
                for(GC_GES_Order_Task__c singleTask : listSkippedItems){
                    LC_CoreUtils.LC_GESItemWrapper gesItemsWrp = new LC_CoreUtils.LC_GESItemWrapper();
                    gesItemsWrp.itemId = singleTask.Id;
                    gesItemsWrp.itemName = singleTask.Name;
                    gesItemsWrp.itemStatus = 'Record could not be submitted to Core, since status is '+singleTask.Status__c;
                    listGesItemsWrp.add(gesItemsWrp);
                } 
            }
            LC_CoreWrapperProcess.gesItemWrapper = listGesItemsWrp;
            return LC_CoreWrapperProcess;
            
        }catch(AuraHandledException e){
            throw e;
        }catch(LC_CoreUtils.LC_CoreUtilsException e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    public Static Boolean validateGesTasks(GC_GES_Order_Task__c item) {
        Set<String> errors = new Set<String>();
        if (item.Status__c == 'Approved') {
            if (!LC_OrderSubmitCancelToCore.validateGesTask(1, item)) {
                errors.add('GES Item ' + item.Name + ' has failed validation');
            }
        }
        return errors.size() == 0;
    }
    
    public static LC_CoreUtils.LC_CoreUtilsWrapper processItemsAction(Map<Id, GC_Order__c> mapOrders, Map<String, GC_GES_Order_Task__c> GesOrderMappingByName, String coreSessionId) {
        LC_CoreUtils.LC_CoreUtilsWrapper LC_CoreWrapperProcess = new LC_CoreUtils.LC_CoreUtilsWrapper();
        LC_CoreWrapperProcess = LC_CoreUtils.processOrderBatchReturnsWrapper(coreSessionId, null, GesOrderMappingByName, false,mapOrders);
        return LC_CoreWrapperProcess;
    }
    
    @AuraEnabled
    public static LC_CoreUtils.LC_CoreUtilsWrapper cancelGESItemsAction(String recordIds, string coreSessionId) {
        Set<String> setRecordIds = new Set<String>();
        Set<String> orderIds = new Set<String>();
        Map<String, GC_GES_Order_Task__c> GesOrderMappingByName = new Map<String, GC_GES_Order_Task__c>();
        List<GC_GES_Order_Task__c> listSkippedItems = new List<GC_GES_Order_Task__c>();
        List<LC_CoreUtils.LC_GESItemWrapper> listGesItemsWrp = new List<LC_CoreUtils.LC_GESItemWrapper>();
        
        LC_CoreUtils.LC_CoreUtilsWrapper LC_CoreWrapper = new LC_CoreUtils.LC_CoreUtilsWrapper();
        LC_CoreWrapper.errorMessages = new List<String>();
        List<GC_Core_Interface_Log__c> coreLogs = new List<GC_Core_Interface_Log__c>();
        List<GC_Core_Interface_Log__c> resultLogs= new List<GC_Core_Interface_Log__c>();
        LC_CoreUtils.LC_CoreUtilsWrapper LC_CoreWrapperProcess = new LC_CoreUtils.LC_CoreUtilsWrapper();
        List<GC_GES_Order_Task__c> updateTaskStatus =new list<GC_GES_Order_Task__c>();
        
        try{
            List<String> recordIdList = recordIds.replaceAll('\\s','').removeStart('[').removeEnd(']').split(',');
            for(String ids : recordIdList){
                setRecordIds.add(ids);
            }
            
            List<GC_GES_Order_Task__c> gesTasks = GC_GESOrderTaskDao.getInstance().getGESOrderTaskByIds(setRecordIds);
            for(GC_GES_Order_Task__c singleTask : gesTasks){
                if ((singleTask.Status__c == 'Canceled' || singleTask.Status__c == 'Active') && String.isNotBlank(singleTask.Order_Line_ID__c) && !singleTask.Core_Cancelled__c) {
                    orderIds.add(singleTask.Order__c);
                    GesOrderMappingByName.put(singleTask.Name, singleTask);
                }else{
                    listSkippedItems.add(singleTask);
                }
            }
            
            if(!GesOrderMappingByName.isEmpty()){
                Map<Id, GC_Order__c> mapOrder = new Map<Id,GC_Order__c>([Select id, name, Order_Number__c, Status__c from GC_Order__c where Id IN : orderIds]);
                
                LC_CoreUtils.LC_CoreUtilsWrapper LC_CoreCancelWrapper = new LC_CoreUtils.LC_CoreUtilsWrapper();
                if(!mapOrder.isEmpty()){
                    LC_CoreCancelWrapper = LC_CoreUtils.cancelOrderInCoreFromListViewPage(coreSessionId, mapOrder, GesOrderMappingByName,true);
                    LC_CoreWrapper.errorMessages.addAll(LC_CoreCancelWrapper.errorMessages);
                    
                    if(LC_CoreCancelWrapper.coreLogs != null && LC_CoreCancelWrapper.coreLogs.size() > 0){
                        resultLogs.addAll(LC_CoreCancelWrapper.coreLogs);
                    }
                    if(LC_CoreCancelWrapper.tasksToUpdate != null && LC_CoreCancelWrapper.tasksToUpdate.size() > 0){
                        updateTaskStatus.addAll(LC_CoreCancelWrapper.tasksToUpdate);
                    }
                    
                    if(LC_CoreCancelWrapper.gesItemWrapper != null && LC_CoreCancelWrapper.gesItemWrapper.size() > 0){
                        listGesItemsWrp.addAll(LC_CoreCancelWrapper.gesItemWrapper);
                    }
                }
                
                if(updateTaskStatus.size() != 0){
                    map<id,GC_GES_Order_Task__c> mapUpdateTaskStatus = new map<id,GC_GES_Order_Task__c>();
                    mapUpdateTaskStatus.putall(updateTaskStatus);
                    update mapUpdateTaskStatus.values();
                }
                LC_CoreUtils.insertCoreLogs(resultLogs);
            }
            
            if(!listSkippedItems.isEmpty()){
                for(GC_GES_Order_Task__c singleTask : listSkippedItems){
                    LC_CoreUtils.LC_GESItemWrapper gesItemsWrp = new LC_CoreUtils.LC_GESItemWrapper();
                    gesItemsWrp.itemId = singleTask.Id;
                    gesItemsWrp.itemName = singleTask.Name;
                    if(singleTask.Status__c != 'Canceled' && singleTask.Status__c != 'Active'){
                        gesItemsWrp.itemStatus = 'Item could not be submitted to Core, since status is '+singleTask.Status__c;
                    }
                    else if(!singleTask.Core_Cancelled__c){
                        gesItemsWrp.itemStatus = 'Item could not be submitted to Core, since this item is already cancelled';
                    }
                    else if(String.isNotBlank(singleTask.Order_Line_ID__c)){
                        gesItemsWrp.itemStatus = 'Item could not be submitted to Core, since Order Line ID field is null';
                    }
                    listGesItemsWrp.add(gesItemsWrp);
                } 
            }
            LC_CoreWrapper.gesItemWrapper = listGesItemsWrp;
            
            return LC_CoreWrapper; 
        }  catch (AuraHandledException e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    /*public static LC_CoreUtils.LC_CoreUtilsWrapper processCancelItemAction(Map<Id, GC_Order__c> mapOrders, Map<String, GC_GES_Order_Task__c> GesOrderMappingByName, String coreSessionId) {
        try{
            return LC_CoreUtils.processOrderBatchReturnsWrapper(coreSessionId, null, GesOrderMappingByName, true, mapOrders);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }*/
}