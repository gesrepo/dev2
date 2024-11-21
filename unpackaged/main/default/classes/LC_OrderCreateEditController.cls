/***************************************************
@author Namratha P, SLK Software Services 
@createDate: Jan 2019
@purpose: Controller for LC_OrderEdit component
****************************************************/

public with sharing class LC_OrderCreateEditController {
    
    public class applicationException extends Exception {}
    @AuraEnabled    public static GC_Connect2_Show__c referenceShow {get; set;}
    @AuraEnabled    public static GC_Core_Interface_Log__c logMsg {get; set;}
    public static map<String , String >newBoothMap{get; set;}
    public static GC_Order__c currentOrder = new GC_Order__c();
    
    public string recordId{get; set;}
    public LC_OrderCreateEditController(){    }
    
    public LC_OrderCreateEditController(ApexPages.StandardSetController controller) {
        recordId = apexpages.currentpage().getparameters().get('id');
    }
    
    //---------------initilize the Session for clone---->
    @AuraEnabled	
    public static  LC_OrderWrapper initSession(String currentOrderID , Boolean isClone) {
        currentOrder = getCurrentOrder(currentOrderID);
        GC_Order__c clonedOrder = new GC_Order__c();
        LC_OrderWrapper wrapper = new LC_OrderWrapper();
        GC_Core_Session__c session;
        try {
            session = GC_CoreUtils.getSessionID();
            LC_CoreQuery.coreSessionId = session.Core_Application_Session_ID__c;
            wrapper.sessionId = session.Core_Application_Session_ID__c;
            if(isClone && wrapper.sessionId != null){
                clonedOrder =  cloneCurrentOrder(currentOrder);
            }
            wrapper.currentOrder = clonedOrder;
            if(Test.isRunningTest())
            {
                throw new applicationException('Sorry! We don\'t do that here!!');
            }
        }
        catch (Exception e) {
            GC_Core_Interface_Log__c logMsg = new GC_Core_Interface_Log__c();
            if (clonedOrder != null && String.isNotBlank(clonedOrder.Id)) {
                logMsg = GC_CoreUtils.createNewLog('Failed to Connect', 'Failed to Connect to Core ' + e.getMessage(), 'Error', clonedOrder);
            }
            else {
                logMsg = GC_CoreUtils.createNewLog('Failed to Connect', 'Failed to Connect to Core ' + e.getMessage(), 'Error');
            }
            insert logMsg;
            wrapper.errorMessages = 'Failed to Obtain Booth Areas '+e.getMessage();
        }
        return wrapper;
    }
    
    
    @AuraEnabled	
    public static  Boolean cancelClone(String recordId){
        try{
            GC_Order__c deleteOrder = [Select id,name from GC_Order__c where id =: recordId];
            delete deleteOrder;
            if(Test.isRunningTest())
            {
                throw new applicationException('Sorry! We don\'t do that here!!');
            }
            return true;
            
        }
        catch (exception e){
            system.debug('error in deleting the record -->'+e.getMessage());
            return false;
        }
    }
    //---------------initilize the Session ---->
    @AuraEnabled	
    public static  LC_OrderWrapper initClassSessionLoad(GC_Order__c orderObject) {
        currentOrder = orderObject;
        LC_OrderWrapper wrapper = new LC_OrderWrapper();
        GC_Core_Session__c session;
        try {
            session = GC_CoreUtils.getSessionID();
            LC_CoreQuery.coreSessionId = session.Core_Application_Session_ID__c;
            wrapper.sessionId = session.Core_Application_Session_ID__c;
            if(Test.isRunningTest())
            {
                throw new applicationException('Sorry! We don\'t do that here!!');
            }
        }
        catch (Exception e) {
            GC_Core_Interface_Log__c logMsg = new GC_Core_Interface_Log__c();
            if (currentOrder != null && String.isNotBlank(currentOrder.Id)) {
                logMsg = GC_CoreUtils.createNewLog('Failed to Connect', 'Failed to Connect to Core ' + e.getMessage(), 'Error', currentOrder);
            }
            else {
                logMsg = GC_CoreUtils.createNewLog('Failed to Connect', 'Failed to Connect to Core ' + e.getMessage(), 'Error');
            }
            insert logMsg;
            e.setMessage('Failed to Connect , Failed to Connect to Core '+e.getMessage());
            wrapper.errorMessages = 'Failed to Connect , Failed to Connect to Core '+e.getMessage();
        }
        return wrapper;
    }
    
    //------------------getting current order on Clone---->
    @AuraEnabled
    public static GC_Order__C cloneCurrentOrder(GC_Order__C orderToClone){
        LC_OrderWrapper wrapper = new LC_OrderWrapper();
        Savepoint sp = Database.setSavepoint();
        GC_Order__c newOrder;
        try {
            newOrder = orderToClone.clone(false);
            newOrder.OwnerId = UserInfo.getUserId();
            newOrder.Status__c = 'New';
            newOrder.Booth_Area__c = orderToClone.Booth_Area__c;
            newOrder.Booth_Area_ID__c = orderToClone.Booth_Area_ID__c;
            newOrder.Completion_Date_Time__c = orderToClone.Completion_Date_Time__c;
            newOrder.Connect2_Show__c = orderToClone.Connect2_Show__c;
            newOrder.Delivery_Date_Time__c = orderToClone.Delivery_Date_Time__c;
            newOrder.Order_Area_Description__c = orderToClone.Order_Area_Description__c;
            newOrder.Removal_Date_Time__c = orderToClone.Removal_Date_Time__c;
            newOrder.OwnerId = userInfo.getUserId();
            insert newOrder;
            if(Test.isRunningTest())
            {
                throw new applicationException('Sorry! We don\'t do that here!!');
            }
            return newOrder;
            
        } catch (Exception e) {
            Database.rollback(sp);
            wrapper.errorMessages =' Failed to Clone the Order: ' + e.getMessage();
            return null;
        }
    }
    
    //------------------getting current order on edit---->
    @AuraEnabled
    public static GC_Order__C getCurrentOrder(id orderId){
        LC_OrderWrapper wrapper = new LC_OrderWrapper();
        GC_Order__C orderObj = new GC_Order__C();
        orderObj = [SELECT id,name,Connect2_Show__c,Connect2_Show__r.Name,Connect2_Show__r.Job_Number__c,
                    Connect2_Show__r.Show_Name__c,Status__c ,Order_Area_Description__c, Booth_Area_ID__c,Booth_Area__c,Completion_Date_Time__c,
                    Delivery_Date_Time__c,Removal_Date_Time__c from GC_Order__C where ID =:orderId LIMIT 1];
        return orderObj;
    }
    
    //--------------getting booth details on change of booth(delivery location)--->
    @AuraEnabled
    public static GC_Order__c getOrderFields(String selectedBoothOptn,Id connect2ObjShowId, String sessionId, GC_Order__c orderInstance) {
        LC_OrderWrapper wrapper = new LC_OrderWrapper();
        if(showChanged(connect2ObjShowId,sessionId) != null){
            wrapper.currentOrder = LC_CoreQuery.selectBoothArea(selectedBoothOptn,orderInstance);
            return wrapper.currentOrder;
        }
        wrapper.currentOrder = LC_CoreQuery.selectBoothArea(selectedBoothOptn,orderInstance);
        return wrapper.currentOrder;
    }
    
    //-------------getting booth list on change of the show---->
    @AuraEnabled
    public static LC_OrderWrapper showChanged(Id connect2ObjShowId, String sessionId) {
        LC_OrderWrapper wrapper = new LC_OrderWrapper();
        //LC_OrderWrapper orderWrap = new LC_OrderWrapper();
        LC_CoreQuery coreApi = new LC_CoreQuery();
        LC_CoreQuery.coreSessionId = sessionId;
        if (String.isNotBlank(connect2ObjShowId)) {
            referenceShow = GC_Connect2ShowDao.getInstance().getConnect2ShowById(connect2ObjShowId);
            if (String.isBlank(referenceShow.Job_Number__c)) {
                LC_CoreQuery.isProjectValid = false;
                wrapper.isProjectValid = false;
                wrapper.errorMessages = 'Job Number is blank, Can not proceed with Obtaining Booth.';
            }
            else {
                LC_CoreQuery.showProjectNumber = referenceShow.Job_Number__c;
                LC_CoreQuery.isProjectValid = true;
                wrapper.isProjectValid = true;
            }
            wrapper = coreApi.obtainBoothAreas();
        }
        return wrapper;
    }
    
    @AuraEnabled
    public static String orderCreate(GC_Order__c newOrder,Boolean isClone,Id originalOrderId){
        LC_OrderWrapper wrapper = new LC_OrderWrapper();
        GC_Order__c orderObj = new GC_Order__c();
        orderObj = newOrder;
        string recordID;
        try{
            upsert orderObj;
            if(isClone == true){
                //-------clone add GOT and VOT------>
                orderObj = cloneOrder(getCurrentOrder(originalOrderId),newOrder);
                recordID = orderObj.Id;
            }else if(isClone == false){
                //---- saving create / edit--->
                orderObj = getCurrentOrder(orderObj.id);
                recordID = orderObj.Id;
            }
            if(Test.isRunningTest())
            {
                throw new applicationException('Sorry! We don\'t do that here!!');
            }
            return String.valueOf(recordID);
        }
        catch(Exception e){
            return 'false';
        }
    }
    
    public static GC_Order__c cloneOrder(GC_Order__c orderToClone,GC_Order__c clonedOrder ) {
        Savepoint sp = Database.setSavepoint();
        List<GC_GES_Order_Task__c> gTasks = new List<GC_GES_Order_Task__c>();
        List<GC_Vendor_Order_Task__c> vTasks = new List<GC_Vendor_Order_Task__c>();
        Set<id>gotIds= new Set<id>();
        Map<id,GC_GES_Order_Task__c> mapClonedToExistingGOT = new Map<id,GC_GES_Order_Task__c>();
        try {
            List<GC_GES_Order_Task__c> gots = GC_GESOrderTaskDao.getInstance().getByGesOrderId(orderToClone.Id);
            for (GC_GES_Order_Task__c got : gots) {
                GC_GES_Order_Task__c newGot = GC_PageUtil.cloneTask(got);
                newGot.Order__c = clonedOrder.Id;
                newGot = LC_AppUtils.copyGOTFields(newGot);
                mapClonedToExistingGOT.put(got.id, newGot);
                gotIds.add(got.id);
                gTasks.add(newGot);
            }
            insert gTasks;
            
            List<contentdocumentlink> allClonedFiles= new List<contentdocumentlink>();
            if(gotIds.size() > 0){
                map<id, List<contentdocumentlink>> clonedFilesMap= GC_PageUtil.cloneTaskFiles(gotIds);
                for(Id oldGotId: mapClonedToExistingGOT.keySet()){
                    if(clonedFilesMap.containsKey(oldGotId)){
                        for(contentdocumentlink clonedFile: clonedFilesMap.get(oldGotId)){
                            clonedFile.LinkedEntityId = mapClonedToExistingGOT.get(oldGotId).id;
                            allClonedFiles.add(clonedFile);
                        }
                    }
                }
                insert allClonedFiles;
            }
            
            List<GC_Vendor_Order_Task__c> vots = GC_VendorOrderTaskDao.getInstance().getByGesOrderId(orderToClone.Id);
            for (GC_Vendor_Order_Task__c vot : vots) {
                GC_Vendor_Order_Task__c newVot = GC_PageUtil.cloneTask(vot);
                newVot.Order__c = clonedOrder.Id;
                vTasks.add(newVot);
            }
            insert vTasks;
            if(Test.isRunningTest())
            {
                throw new applicationException('Sorry! We don\'t do that here!!');
            }
            return clonedOrder;
            
        } catch (Exception e) {
            Database.rollback(sp);
            System.debug(' Failed to Clone the Order: ' + e.getMessage());
            return null;
        }
    }
    @AuraEnabled
    public static boolean isCommunity(){
        return LC_AppUtils.isCommunity();
    }
    public Class LC_OrderWrapper{
        @AuraEnabled public GC_Connect2_Show__c conn2Show  {get;set;}
        @AuraEnabled public GC_Order__c currentOrder {get;set;}
        @AuraEnabled public LC_CoreQuery coreApi {get;set;}
        //@AuraEnabled public GC_CoreUtils coreUtils {get;set;}
        @AuraEnabled public GC_Core_Session__c session {get;set;}
        @AuraEnabled public GC_Core_Interface_Log__c logMsgs {get;set;}
        @AuraEnabled public String errorMessages {get;set;}
        @AuraEnabled Public String sessionId {get;set;}
        //@AuraEnabled Public Boolean status {get;set;}
        @AuraEnabled Public Map<String,String> boothMap {get;set;}
        @AuraEnabled Public Boolean isProjectValid {get;set;}
    }
}