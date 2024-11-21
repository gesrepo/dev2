public with sharing class LC_GOTRelatedListController {
    
    @AuraEnabled
    public static List<GESTaskWrapper> getGots(Id orderId){
        system.debug('order id-------'+ orderId);
        String [] gotFields = new String [] {'Id',
            'Name',
            'Status__c',
            'Sign_Title__c',
            'Item_Number__c',
            'Description__c',
            'User_Item_Description__c',
            'QuantityNum__c',
            'OwnerId',
            'Submitted_Date__c',
            'Order_Number__c',
            'Line_Item_Number__c',
            'Line_Item_Status__c'
            };
                
                //Accessibility Check
                // Obtain the field name/token map for the Expense object
                //  Map<String,Schema.SObjectField> m = Schema.SObjectType.objToCheck.fields.getMap();
                
                String selectedObject = 'GC_GES_Order_Task__c';
        Map<String, Schema.SObjectType> gdMap = Schema.getGlobalDescribe();
        Schema.Describesobjectresult dsr = gdMap.get(selectedObject).getDescribe();
        Map<String, Schema.SObjectField> fieldMap = dsr.fields.getMap();
        
        for (String fieldToCheck : gotFields) {
            // Check if the user has access to view field
            if (!fieldMap.get(fieldToCheck).getDescribe().isAccessible()) {
                // Pass error to client
                throw new System.NoAccessException();
            }
        }
        //Accessibility Check End
        
        List<GESTaskWrapper> gotWrapperList = new List<GESTaskWrapper>();
        
        // List <GC_GES_Order_Task__c> gesOrderTasks =  [SELECT Id, Name, Status__c, Sign_Title__c, Item_Number__c, 
        //                                               Description__c, User_Item_Description__c,
        //                                               QuantityNum__c, Owner.Name, Submitted_Date__c, 
        //                                               Order_Number__c, Line_Item_Number__c, Line_Item_Status__c
        //                                               FROM GC_GES_Order_Task__c where Order__c =:orderId 
        //                                               ORDER BY LastModifiedDate DESC];
        //Amarab 01042023 SAL-1259 GES Order Task List- Replace Sign Title to User Item description
        List <GC_GES_Order_Task__c> gesOrderTasks =  [SELECT Id, Name, Status__c, Sign_Title__c, Item_Number__c, 
                                                      Description__c, QuantityNum__c, Owner.Name, Submitted_Date__c,
                                                      CORE_Number_FML__c, User_Item_Description__c FROM GC_GES_Order_Task__c where Order__c =:orderId 
                                                      ORDER BY LastModifiedDate DESC];
        
        Set<String> taskIds = new Set<String>();
        for(GC_GES_Order_Task__c gesOrderTask: gesOrderTasks){
            taskIds.add(gesOrderTask.Id);
        }
        
        Map<String, LC_GESOrderTaskViewController.GOTPermissions> permissionMap = 
            LC_GESOrderTaskViewController.getCommunityPermissionsMap(taskIds);  
        
        for(GC_GES_Order_Task__c gesOrderTask: gesOrderTasks){
            GESTaskWrapper gotWrapper = new GESTaskWrapper(gesOrderTask, permissionMap.get(gesOrderTask.Id), 0);
            gotWrapperList.add(gotWrapper);
        }
        return gotWrapperList;
    }
    
    @AuraEnabled
    public static boolean isCommunity(){
        return LC_AppUtils.isCommunity();
    }
    
    @AuraEnabled
    public static ProfileWrapper getProfilePermissions(){
        ProfileWrapper pWrapper = new ProfileWrapper();
        pWrapper.isCommunity = LC_AppUtils.isCommunity();
        pWrapper.profileName = LC_GESOrderTaskViewController.getProfileName();
        pWrapper.isIntrnlUser = LC_GESOrderTaskViewController.getUserPermission();
        return pWrapper;
    }    
    
    //Removes/Deletes a GOT 
    @AuraEnabled
    public static void removeTask(string taskId){
        taskId = LC_AppUtils.validateId(taskId);
        
        GC_GES_Order_Task__c[] tasksToDelete = [SELECT Id, Name FROM GC_GES_Order_Task__c 
                                                WHERE Id =: taskId]; 
        try {
            delete tasksToDelete;
        } catch (DmlException de) {
            throw new AuraHandledException(de.getMessage());
        }
    }
    
    @AuraEnabled
    public static void sendEmail(string taskId, List<string> emailDefaultList){
        //----------- new changes------------------------
        List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        
        GC_GES_Order_Task__c task = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(taskId);
        
        Boolean submitStatus = GC_ApprovalUtils.submitForApproval(task);
        if(Test.isRunningTest()){
            submitStatus=true;
        }
        if(submitStatus){
            list<String> emailAddress = new List<String>();
            if(emailDefaultList.size() > 0)
                emailAddress = emailDefaultList;
            
            String Id, order, orderTask, SignTitle, ItemNumber,
                Description, UserItem_Description, Price, Total, 
                UOM, QuantityNum, Status, CustomMsgBody, CustomMsgBody1 = '';
            
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>();
            try {
                //     if(!String.isBlank(emailDefaultListString)){
                //          emailAddress = emailDefaultListString.split(',');
                //     }
                
                List<GC_GES_Order_Task__c> ot = [SELECT Id, Order__r.Name, Name, Sign_Title__c, Item_Number__c, Description__c, User_Item_Description__c, Price__c, Total__c, UOM__c, QuantityNum__c, Status__c FROM GC_GES_Order_Task__c WHERE Id = :taskId];
                
                if(ot.size() > 0){
                    Id = ot[0].Id;
                    order = ot[0].Order__r.Name;
                    orderTask = ot[0].Name;
                    SignTitle = ot[0].Sign_Title__c;
                    ItemNumber = ot[0].Item_Number__c;
                    Description = ot[0].Description__c;
                    UserItem_Description=ot[0].User_Item_Description__c;
                    Price = ot[0].Price__c;
                    Total = String.valueof(ot[0].Total__c);
                    UOM = ot[0].UOM__c;
                    QuantityNum = String.valueof(ot[0].QuantityNum__c);
                    Status = ot[0].Status__c;
                }
                
                for (Attachment a : [select Name, Body, BodyLength from Attachment  where ParentId =:taskId]){
                    Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                    efa.setFileName(a.Name);
                    efa.setBody(a.Body);
                    fileAttachments.add(efa);
                } 
                
                for(String mail:emailAddress){
                    if(!String.isBlank(mail)){
                        //message.toAddresses = new String[] { mail };
                        message.subject='Below Order Task are submitted for Approval' ;
                        CustomMsgBody1 = '<style>table, th, td { border: 1px solid black;}</style><b> Below Order Task are submitted for Approval </b></ br></ br><table><tr><th> Order Name</th><th> GES Order Task Number </th><th>Sign Title</th><th>Item Number</th><th>Description</th><th>Price</th><th>Total Price</th><th>Units</th><th>Quantity</th><th>Status</th></tr>';
                        CustomMsgBody1+='<tr><td>'+order +'</td><td><a href="https://ges--c.vf.force.com/apex/GC_OrderTaskView?id='+id+'&sfdc.override=1" target="_blank">'+ orderTask+'</a></td><td>'+SignTitle +'</td><td>'+ItemNumber +'</td><td>'+Description +'</td><td>'+Price +'</td><td>'+Total +'</td><td>'+UOM +'</td><td>'+QuantityNum +'</td><td>'+Status +'</td></tr>';
                        CustomMsgBody=CustomMsgBody1; 
                        message.setHtmlBody(CustomMsgBody1);
                        
                        //---------- Checking the attachement size ---------------  
                        if(fileAttachments.size()>0){
                            message.setFileAttachments(fileAttachments);
                        }
                        message.setToAddresses(new list<string>{mail});
                    }
                }
                //---- Sending mail to user--------------
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message});
            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
        }
    }
    
    @AuraEnabled
    public static void toggleHold(string taskId, string toggleValue) {
        // Expected Toggle Values are 1 hold, 2 unhold
        if (GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_ACCT_MANAGER) && GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_SALES_MGR) && GC_SecurityUtil.userHasRole('System Administrator'))
            throw new AuraHandledException('You do not have permissions to place or release this GES order task on hold or unhold.');
        
        GC_GES_Order_Task__c gesOrder = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(taskId);
        
        if(toggleValue == '1'){ //call this condition if request is to place on hold
            if (gesOrder.Status__c == 'Canceled' && gesOrder.Is_On_Hold__c == false)
                throw new AuraHandledException('This order task is canceled. Please create a new one');
            
            if (gesOrder.Status__c != 'On Hold') {
                gesOrder.Previous_Status__c = gesOrder.Status__c;
                gesOrder.Status__c = 'On Hold';
                gesOrder.Is_On_Hold__c=true;
                update gesOrder;
            }
            else
                throw new AuraHandledException('This Order task is already on hold');
        }
        else if (toggleValue == '2'){ //call this condition if request is to release from hold
            if (gesOrder.Status__c == 'On Hold' && gesOrder.Is_On_Hold__c ==true) {
                if(gesOrder.Previous_Status__c != null)
                    gesOrder.Status__c = gesOrder.Previous_Status__c;
                else
                    gesOrder.Status__c = 'New';
                
                update gesOrder;
            } else
                throw new AuraHandledException('This Order task is not on hold');
        }
    }
    
    @AuraEnabled
    public static Boolean submitForApproval(string taskId){
        return LC_GESOrderTaskViewController.submitRecord(taskId);
    }
    
    @AuraEnabled
    public static void reworkTask(string taskId){
        LC_GESOrderTaskViewController.reworkOrderTask(taskId);
    }
    
    @AuraEnabled
    public static Boolean recallTask(string taskId){
        return LC_GESOrderTaskViewController.recallOrderTask(taskId);
    }
    
    @AuraEnabled
    public static Boolean approveTask(string taskId){
        try{
            return LC_GESOrderTaskViewController.approveTask(taskId);
        }
        catch(AuraHandledException ex){
            throw new AuraHandledException('Failed to approve, you are not an assigned Approver for this task');
        }
        catch(Exception ex){
            throw new AuraHandledException('Failed to approve task due to: ' + ex.getMessage());
        }
    }
    
    @AuraEnabled
    public static string fetchUserDetails(){
        User u = [SELECT Id, Name, Profile.Name FROM User WHERE id=:Userinfo.getUserId()];
        return u.Profile.Name;
    }
    
    @AuraEnabled
    public static GC_Core_Session__c sessionLoad(string taskId){
        return LC_GESOrderTaskViewController.sessionLoad(taskId);
    }
    
    @AuraEnabled
    public static Boolean validateSessionID(GC_Core_Session__c sessionObject) {
        return LC_GESOrderTaskViewController.validateSessionID(sessionObject);
    }
    
    @AuraEnabled
    public static String sessionLogin() {
        return LC_GESOrderTaskViewController.sessionLogin();
    }
    
    @AuraEnabled
    public static List<String> submitOrderAction(string taskId, string coreSessionId) {
        return LC_GESOrderTaskViewController.submitOrderAction(taskId, coreSessionId);
    }
    
    @AuraEnabled
    public static List<String> processOrderAction(string taskId, string coreSessionId) {
        return LC_GESOrderTaskViewController.processOrderAction(taskId, coreSessionId);
    }
    
    @AuraEnabled
    public static List<String> cancelOrderAction(string taskId, string coreSessionId) {
        return LC_GESOrderTaskViewController.cancelOrderAction(taskId, coreSessionId);
    }
    
    @AuraEnabled
    public static List<String> processCancelOrderAction(string taskId, string coreSessionId) {
        return LC_GESOrderTaskViewController.processCancelOrderAction(taskId, coreSessionId);
    }
    
    public class ProfileWrapper{
        @AuraEnabled
        public string profileName {get; set;}
        @AuraEnabled
        public Boolean isIntrnlUser {get; set;}
        @AuraEnabled
        public Boolean isCommunity {get; set;}
    }
    
    public class GESTaskWrapper{
        @AuraEnabled
        public GC_GES_Order_Task__c got {get; set;}
        @AuraEnabled
        public LC_GESOrderTaskViewController.GOTPermissions permissions {get; set;}
        @AuraEnabled
        public Integer fileCount {get; set;}
        
        public GESTaskWrapper(GC_GES_Order_Task__c orderTask, LC_GESOrderTaskViewController.GOTPermissions taskPermissions, Integer fCount){
            got = orderTask;
            permissions = taskPermissions;
            fileCount = fCount;
        }
    }
    
    @AuraEnabled
    public static Boolean getrelatedOrders(string orderId){
        List<GC_Order__c> order= new List<GC_Order__c>();
        order=[SELECT Id,(SELECT Id,Name FROM Vendor_Order_Tasks__r),(select Id,Name from GES_Order_Tasks__r) FROM GC_Order__c where id=:orderId];
        List<string> votList= new List<string>();
        List<string> gotList= new List<string>();
        for(GC_Order__c o:order){
            for(GC_GES_Order_Task__c g:o.GES_Order_Tasks__r){
                system.debug('got values are'+g.Name); 
                gotList.add(g.Name);
            }
            for(GC_Vendor_Order_Task__c v:o.Vendor_Order_Tasks__r){
                system.debug('vot values are'+v.Name); 
                votList.add(v.Name);
            }
            system.debug('gotList has'+gotList.size());
            system.debug('votList has'+votList.size());
        }
        if(gotList.size()==0 && votList.size()==0){
            return true;
        }
        else{
            return false;
        }
    }
    
    //SAL-1339 Added Booth Area on GES Item - Sajid - 07/22/24
    @AuraEnabled
    public static GC_Order__c getOrder(string orderId){
        GC_Order__c order= new GC_Order__c();
        order=[SELECT Id, Name,Booth_Area__c FROM GC_Order__c where id=:orderId];
        return order;
    }
}