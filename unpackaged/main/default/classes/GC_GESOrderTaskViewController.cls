/**
* @author Ethos Solutions - www.ethos.com
* @description Controller for GES Order Task view page
* 2016-04-13 : Original Version
**/
public with sharing class GC_GESOrderTaskViewController extends GC_BaseViewController {
    public GC_GES_Order_Task__c got {get; set;}
    public String showProjectNumber { get; set; } // CORE uses two numbers for ordering items, showProjectNumber is the salesforce Job number.
    public GC_GES_Order_Task__c revision;

    public List<GC_GES_Order_Task__c> revisions {get; set;}

    public GC_CoreQuery coreApi {get; set;}

    //------------- Properties from community page
    public String showId {get; set;}
    public String orderId {get; set;}
    public String isRevised {get; set;}

    public GC_Connect2_Show__c show {get; set;}
    public GC_Order__c order {get; set;}

    public Boolean canTakeOwnership {get; set;}

    public String recallComments {get; set;}
    public Boolean canRecall {get; set;}

    public List<String> transactionPageErrors {get; set;}
    public String coreSessionId { get; set; }


    public Boolean isReadOnlyView {get; set;}
    //public GC_Task_Field_Manager__c tfm {get; set;}
    //SAL-636
    public GC_Task_Field_Manager__c taskFieldManager {get; set;}
    GC_Core_Session__c sessionObject = new GC_Core_Session__c();
    public List<GC_Core_Interface_Log__c> resultLogs= new List<GC_Core_Interface_Log__c>();
    //-------------


    // FIXME Move these to labels
    public String getEditTitle() {
        return 'Edit the Task.';
    }
    public String getCloneTitle() {
      //return 'Clones the Current Task and all of its contents.  Reset\'s status to New and Clears out external fields.';  /*commented by Sajid on 04/05/23 Ticket-1209*/
        return 'Clones the Current Item and all of its contents.  Reset\'s status to New and Clears out external fields.'; // added by Sajid on 04/05/23 Ticket-1209
    }
    public String getReviseTitle() {
        //return 'Revises the Current Task for Modification.  Clones the Record and Cancels the existing records and marks it as archived.';  /*commented by Sajid on 04/05/23 Ticket-1209*/
        return 'Revises the Current Item for Modification. Clones the Record and Cancels the existing records and marks it as archived.'; //added by Sajid on 04/05/23 Ticket-1209
    }
    public String getCancelTitle() {
        //return 'Cancels the Current Task and Flags it to be canceled at the external interface.'; /*commented by Sajid on 04/05/23 Ticket-1209*/
        return 'Cancels the Current Item and Flags it to be canceled at the external interface.'; //added by Sajid on 04/05/23 Ticket-1209
    }
    public String getOnHoldTitle() {
        //return 'Places the Current Task Status to On Hold and Await for more information.  Disables buttons for editing.'; /*commented by Sajid on 04/05/23 Ticket-1209*/
        return 'Places the Current Item Status to On Hold and Await for more information. Disables buttons for editing.'; //added by Sajid on 04/05/23 Ticket-1209
    }
    public String getReleaseHoldTitle() {
        //return 'Release the current task from On Hold and sets back to the previous status.'; /*commented by Sajid on 04/05/23 Ticket-1209*/
        return 'Release the Current item from On Hold and sets back to the previous status.'; //added by Sajid on 04/05/23 Ticket-1209
    }
    public String getApproveTitle() {
        //return 'Does a validation check on task for required fields, Sets the Status to Approved.'; /*commented by Sajid on 04/05/23 Ticket-1209*/
        return 'Does a validation check on item for required fields, Sets the Status to Approved.'; //added by Sajid on 04/05/23 Ticket-1209
    }
    public String getSubmitTitle() {
        //return 'Does a validation check on task for required fields, Sends the task to the Account manager for Approval.'; /*commented by Sajid on 04/05/23 Ticket-1209*/
        return 'Does a validation check on item for required fields, Sends the item to the Account manager for Approval.'; //added by Sajid on 04/05/23 Ticket-1209
    }
    public String getTakeOwnershipTitle() {
        //return 'Sets you as the owner of the Current Task'; /*commented by Sajid on 04/05/23 Ticket-1209*/
        return 'Sets you as the owner of the Current Item'; //added by Sajid on 04/05/23 Ticket-1209
    }
    public String getBackToOrderTitle() {
        return 'To go back to the order';
    }

    public GC_OrderUtils.TaskPermissions taskPermissions {get; private set;}

    public GC_GESOrderTaskViewController() {
        coreApi = new GC_CoreQuery();

        IsSalesforce = GC_PageUtil.IsLightningUI();
        IsLightning = GC_PageUtil.IsLightningUI();
        IsCommunity = !GC_PageUtil.IsLightningUI();

        Id gotId = ApexPages.currentPage().getParameters().get('Id');

        if (String.isBlank(gotId)) {
            gotId = ApexPages.currentPage().getParameters().get('gotId');
        }

        orderId = ApexPages.currentPage().getParameters().get('orderId');
        showId = ApexPages.currentPage().getParameters().get('showId');
        isRevised = ApexPages.currentPage().getParameters().get('isRevised');
        order = GC_OrderDao.getInstance().getOrderById(orderId);

        got = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(gotId);

        if (got != null) {
            showId = got.Order__r.Connect2_Show__c;
            show = GC_Connect2ShowDao.getInstance().getConnect2ShowById(showId);
        }

        CheckCommunityPermissions();

        transactionPageErrors = new List<String>();

        coreApi.setCurrentTask(got);

        isReadOnlyView = false;
        List<Profile> profiles = [SELECT Id, Name FROM Profile WHERE Id = :userinfo.getProfileId() LIMIT 1];
        if (profiles.size() > 0 && profiles[0].Name == 'GC Community Vendor') {
            isReadOnlyView = true;
        }
        try{
            taskFieldManager = [SELECT id, name, Background__c,Booth_Area_Discount__c,Budget_Code__c,Client_Layout_Notes__c,Completion_Date_Time__c,Connect2_Show__c,Copy_Placement__c,Default_Completion_Date_Time__c,Default_Installation_Delivery_Date_Time__c,Default_Removal_Date_Time__c,Delivery_Area__c,File_Reference_Link_Folder__c,Installation_Delivery_Date_Time__c,Installation_Method__c,Onsite_Contact_Person__c,Onsite_Contact_Person_Number__c,Outdoors__c,Price__c,Removal_Date_Time__c,Save_Signs__c,Sign_Copy__c,Sign_Title__c,Sign_Type__c,Sign_Type_Other__c,Single_Double_Sided__c,Special_Instructions_Client_Remarks__c,User__c,User_Item_Description__c FROM GC_Task_Field_Manager__c WHERE Connect2_Show__c=:got.Order__r.Connect2_Show__c LIMIT 1];
        }
        catch(exception e){
            taskFieldManager= new GC_Task_Field_Manager__c();
            taskFieldManager.Connect2_Show__c= got.Order__r.Connect2_Show__c;
        }
    }

    public void CheckCommunityPermissions() {
        taskPermissions = new GC_OrderUtils.TaskPermissions(got);

        List<Profile> profile = [SELECT Id, Name FROM Profile WHERE Id = :Userinfo.getProfileId() LIMIT 1];

        String profileName = profile[0].Name;

        if (profileName == 'GC Community Vendor') {
            taskPermissions.CanEdit = false;
            taskPermissions.CanClone = false;
            taskPermissions.CanSubmit = false;
            taskPermissions.CanCancel = false;
            taskPermissions.CanRevise = false;
        }

        if (profileName == 'GC Community Client') {
            List<GC_Show_Team_Member__c> stm = [SELECT Id, Name, User__c, Show_Role__c, Connect2_Show__c FROM GC_Show_Team_Member__c WHERE Connect2_Show__c = :show.Id AND User__c = :Userinfo.getUserId()];

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

        canRecall = got.OwnerId == UserInfo.getUserId() && GC_ApprovalUtils.isUnderApproval(got.Id);
        canTakeOwnership = taskPermissions.CanEdit && got.OwnerId != UserInfo.getUserId();
    }

    public GC_GESOrderTaskViewController(ApexPages.StandardController stdController) {
        coreApi = new GC_CoreQuery();

        IsSalesforce = true;

        GC_GES_Order_Task__c tmpgot = (GC_GES_Order_Task__c)stdController.getRecord();
        got = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(tmpgot.Id);

        if (String.isNotBlank(got.Order__r.Connect2_Show__r.Job_Number__c)) {
            showProjectNumber = got.Order__r.Connect2_Show__r.Job_Number__c;
        }

        taskPermissions = new GC_OrderUtils.TaskPermissions(got);

        revisions = new List<GC_GES_Order_Task__c>();

        if (String.isNotBlank(got.Original_Task_Revision2__c)) {
            revisions = [select Id, Name, Revision__c, Original_Task_Revision2__c, Status__c, Previous_Revision__c, Previous_Revision__r.Name, Last_Revision__c from GC_GES_Order_Task__c where Original_Task_Revision2__c = :got.Original_Task_Revision2__c order by Revision__c];
        }

        if (ApexPages.currentPage().getParameters().containsKey('printMessage') && got.Status__c == 'Approved') {
            ApexPages.currentPage().getParameters().remove('printMessage');
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.CONFIRM, 'The task ' + got.Name + ' has been approved.' ));
        }

        transactionPageErrors = new List<String>();

        coreApi.setCurrentTask(got);
        
        try{
            taskFieldManager = [SELECT id, name, Background__c,Booth_Area_Discount__c,Budget_Code__c,Client_Layout_Notes__c,Completion_Date_Time__c,Connect2_Show__c,Copy_Placement__c,Default_Completion_Date_Time__c,Default_Installation_Delivery_Date_Time__c,Default_Removal_Date_Time__c,Delivery_Area__c,File_Reference_Link_Folder__c,Installation_Delivery_Date_Time__c,Installation_Method__c,Onsite_Contact_Person__c,Onsite_Contact_Person_Number__c,Outdoors__c,Price__c,Removal_Date_Time__c,Save_Signs__c,Sign_Copy__c,Sign_Title__c,Sign_Type__c,Sign_Type_Other__c,Single_Double_Sided__c,Special_Instructions_Client_Remarks__c,User__c,User_Item_Description__c FROM GC_Task_Field_Manager__c WHERE Connect2_Show__c=:got.Order__r.Connect2_Show__c LIMIT 1];
        }
        catch(exception e){
            taskFieldManager= new GC_Task_Field_Manager__c();
            taskFieldManager.Connect2_Show__c= got.Order__r.Connect2_Show__c;
        }
    }

    /**
     * @description Load Action to determine if we display the lightning view page vs. the classic salesforce view page.
     **/
    public PageReference loadAction() {
        return null;
        //String orderId = got.Order__c;
        //if (GC_PageUtil.IsLightningUI()) {
        //    return new PageReference('/apex/GC_LDS_gotView?Id=' + got.Id );
        //}
        //else {
        //    return null;
        //}
    }

    public PageReference cloneAction() {
        try {
            String showId = ApexPages.currentPage().getParameters().get('showId');
            String orderId = ApexPages.currentPage().getParameters().get('orderId');

            PageReference pr = null;

            if (IsCommunity) {
                pr = new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_gotCreateEdit');
            }

            if (IsSalesforce) {
                if (IsLightning) {
                    pr = new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_LDS_gotCreateEdit');

                } else {
                    pr = new PageReference('/apex/GC_OrderTaskEdit');
                }

            }

            pr.getParameters().put('showId', showId);
            pr.getParameters().put('orderId', orderId);
            pr.getParameters().put('id', got.Id);
            pr.getParameters().put('isClone', '1');
            pr.getParameters().put('originalGotId', got.Id);
            return pr;

        } catch (Exception e) {
            GC_PageUtil.AddErrorMessage(' Failed to Clone the Task: ' + e.getMessage());
            return null;
        }
    }

    public PageReference editAction() {
        if (IsCommunity) {
            //return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_gotCreateEdit?gotId=' + got.Id + '&showId=' + showId + '&OrderId=' + orderId);
            //return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_GOTCreatePage?taskId=' + got.Id + '&showId=' + showId + '&OrderId=' + orderId+'&isEdit=true&isTaskPage=true');
            
            PageReference pr = new PageReference('/apex/GC_Community_GOTCreatePage');
            pr.getParameters().put('taskId', got.Id);
            pr.getParameters().put('isTaskPage', 'true');
            pr.getParameters().put('showId', showId);
            pr.getParameters().put('OrderId', OrderId);
            pr.getParameters().put('isEdit', 'true');
            return pr;
        }

        if (got.Status__c == 'Active') {
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'The task can not be edited while it is active.  Please revise and resubmit.')); /*commented by Sajid on 04/05/23 Ticket-1209*/
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'The item can not be edited while it is active.  Please revise and resubmit.')); //added by Sajid on 04/05/23 Ticket-1209
            return null;

        } else {
            if (IsLightning) {
                return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_LDS_gotCreateEdit?gotId=' + got.Id + '&showId=' + showId + '&orderId=' + orderId);

            } else {
                PageReference pr = new PageReference('/apex/GC_GOTCreatePage');
                pr.getParameters().put('taskId', got.Id);
                pr.getParameters().put('orderId', got.Order__c);
                pr.getParameters().put('isTaskPage', 'true');
                pr.getParameters().put('isEdit', 'true');
                return pr;
            }

        }
    }

    public PageReference saveAction() {
        return null;
    }

    public PageReference reviseAction() {

        String showId = ApexPages.currentPage().getParameters().get('showId');
        String orderId = ApexPages.currentPage().getParameters().get('orderId');

        if (!IsCommunity) {
            if (GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_ACCT_MANAGER) && GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_SALES_MGR) && GC_SecurityUtil.userHasRole('System Administrator')) {
                GC_PageUtil.AddFatalMessage('You don\'t have permissions to revise this GES order.');
                return null;
            }
        }

        GC_GES_Order_Task__c gesOrderTask = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(got.Id);

        if (gesOrderTask.Status__c != 'Active' && gesOrderTask.Status__c != 'Released') { //SAL 421- added released tasks
            GC_PageUtil.AddFatalMessage('You may only revise an active or released GES Order.');
            return null;
        }

        if (got.Previous_Revision__c != null) {
            GC_GES_Order_Task__c currentRevision = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(got.Previous_Revision__c);

            if (currentRevision.Status__c == 'Active' || currentRevision.Status__c == 'Released') {
                //GC_PageUtil.AddFatalMessage('A revision has already been started for this Task.  Proceed to edit this task: ' + gesOrderTask.Name); /*commented by Sajid on 04/05/23 Ticket-1209*/
                GC_PageUtil.AddFatalMessage('A revision has already been started for this Item.  Proceed to edit this item: ' + gesOrderTask.Name); //message updated by Sajid on 04/05/23 Ticket-1209
                return null;
            }
        }

        Savepoint sp = Database.setSavepoint();

        try {
            // Create a clone of the record, this will get a new autonumber but keep the revision in tact.
            revision = gesOrderTask.clone(false, true, false, true);
            revision.Revision__c = gesOrderTask.Revision__c + 1;
            revision.Previous_Revision__c = gesOrderTask.Id;
            revision.Last_Revision__c = DateTime.Now();

            // Set the parent revision for the related list and revision history.
            if (String.isBlank(revision.Original_Task_Revision2__c)) {
                revision.Original_Task_Revision2__c = gesOrderTask.Id;
                gesOrderTask.Original_Task_Revision2__c = gesOrderTask.Id;

            } else {
                revision.Original_Task_Revision2__c = gesOrderTask.Original_Task_Revision2__c;
            }

            revision.Submitted_Date__c = null;
            revision.Status__c = 'New';
            revision.Line_Item_Number__c = null;
            revision.Line_Item_Status__c = null;
            revision.Order_Header_ID__c = null;
            revision.Order_Number__c = null;
            revision.OwnerId = UserInfo.getUserId();

            // GC-722 This logic will only need to be set when the new revision goes to active.
            //revision.Status__c = 'Archived';
            //revision.Is_Active__c = false;

            // Reset the On Hold Status
            if (revision.Is_On_Hold__c == true) {
                revision.Is_On_Hold__c = false;
            }

            insert revision;

        } catch (Exception ex) {
            /* commented by Sajid on 04/05/23 Ticket-1209
            GC_PageUtil.AddFatalMessage('Failed to Revise the task ' + ex.getMessage());
            GC_PageUtil.AddDeveloperMessage('Failed to Revise the task ' + ex.getStackTraceString());
            */
            GC_PageUtil.AddFatalMessage('Failed to Revise the item ' + ex.getMessage()); //added Sajid on 04/05/23 Ticket-1209
            GC_PageUtil.AddDeveloperMessage('Failed to Revise the item ' + ex.getStackTraceString()); //added by Sajid on 04/05/23 Ticket-1209
            Database.rollback(sp);
            return null;
        }

        if (IsCommunity) {
            PageReference pr = new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_gotCreateEdit');
            pr.getParameters().put('showId', showId);
            pr.getParameters().put('gotId', revision.Id);
            pr.getParameters().put('orderId', orderId);
            pr.getParameters().put('isRevised', '1');
            return pr;

        } else {
            PageReference revisionPage = new ApexPages.StandardController(revision).edit();
            return revisionPage;
        }

    }

    public PageReference placeOnHoldAction() {
        if (GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_ACCT_MANAGER) && GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_SALES_MGR) && GC_SecurityUtil.userHasRole('System Administrator')) {
            GC_PageUtil.AddFatalMessage('You don\'t have permissions to place this GES order on hold.');
            return null;
        }

        GC_GES_Order_Task__c gesOrder = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(got.Id);

        if (gesOrder.Status__c == 'Canceled' && gesOrder.Is_On_Hold__c == false) {
            GC_PageUtil.AddFatalMessage('Order is canceled. Please create a new order.');
            return null;
        }

        if (gesOrder.Status__c != 'On Hold') {
            gesOrder.Previous_Status__c = gesOrder.Status__c;
            gesOrder.Status__c = 'On Hold';
            gesOrder.Is_On_Hold__c=true;
            update gesOrder;

        } else {
            GC_PageUtil.AddFatalMessage('Order is already on hold.');
            return null;
        }

        PageReference viewPage = new ApexPages.StandardController(got).view();
        return viewPage;
    }

    public PageReference releaseFromHoldAction() {
      
          if (GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_ACCT_MANAGER) && GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_SALES_MGR) && GC_SecurityUtil.userHasRole('System Administrator')) {
            GC_PageUtil.AddFatalMessage('You don\'t have permissions to release this GES order.');
            return null;
        }

        GC_GES_Order_Task__c gesOrder = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(got.Id);
         
         /**
         *Testing Purpose
         **/
          
         system.debug('gesorder status--------->'+gesOrder.Status__c);
         system.debug('ges order in hold -------->'+gesOrder.Is_On_Hold__c);
         system.debug('previous state ---------->'+gesOrder.Previous_Status__c);
         
       if (gesOrder.Status__c == 'On Hold' && gesOrder.Is_On_Hold__c ==true) {
           if(gesOrder.Previous_Status__c != null) {    //SAL - 428
                gesOrder.Status__c = gesOrder.Previous_Status__c;
            } else
            {
                gesOrder.Status__c = 'New';    
            }
            update gesOrder;

        } else {
            GC_PageUtil.AddFatalMessage('This order is not on hold.');
            return null;
        }

        PageReference viewPage = new ApexPages.StandardController(got).view();
        return viewPage;
    }

    public PageReference connectToCore(){
        transactionPageErrors.clear();
        GC_Core_Session__c session;

        try {
            session = GC_CoreUtils.getSessionID();
            coreSessionId = session.Core_Application_Session_ID__c;

        } catch (Exception e) {
            System.debug('SESSION ' + session);
            GC_PageUtil.AddErrorMessage(e.getMessage());
            transactionPageErrors.add(e.getMessage());
        }
        sessionObject = session;
        return null;
    }

    public PageReference loginToCore() {
        GC_Core_Session__c session;

        try {
            session = GC_CoreUtils.loginToCore();
            coreSessionId = session.Core_Application_Session_ID__c;

        } catch (Exception e) {
            System.debug('SESSION ' + session);
            GC_PageUtil.AddErrorMessage(e.getMessage());
            transactionPageErrors.add(e.getMessage());
        }

        return null;
    }

    public PageReference submitCancelTask() {
        GC_Order__c parentOrder = GC_OrderDao.getInstance().getOrderById(got.Order__c);
        GC_GES_Order_Task__c currentTask = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(got.Id);

        Map<String, GC_GES_Order_Task__c> taskMap = new Map<String, GC_GES_Order_Task__c>();
        taskMap.put(got.Name, currentTask);

        if (currentTask.Status__c == 'Canceled' && String.isNotBlank(currentTask.Order_Line_ID__c) && !currentTask.Core_Cancelled__c) {
            GC_CoreUtils.cancelOrderInCore(coreSessionId, parentOrder, taskMap, false);
        }

        return null;
    }

    public PageReference processCancelTask() {
        GC_Order__c parentOrder = GC_OrderDao.getInstance().getOrderById(got.Order__c);
        GC_GES_Order_Task__c currentTask = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(got.Id);

        Map<String, GC_GES_Order_Task__c> taskMap = new Map<String, GC_GES_Order_Task__c>();
        taskMap.put(got.Name, currentTask);

        if (currentTask.Status__c == 'Canceled' && String.isNotBlank(currentTask.Order_Line_ID__c) && !currentTask.Core_Cancelled__c) {
            GC_CoreUtils.processOrderBatch(coreSessionId, parentOrder, taskMap, true);

            if (currentTask.Line_Item_Status__c == 'CANCELLED') {
                PageReference pr = new PageReference('/apex/GC_OrderView');
                pr.getParameters().put('Id', got.Order__c);
                return pr;
            }
        }

        return null;
    }

    public PageReference cancelAction() {
        if (IsCommunity) {
            String showId = ApexPages.currentPage().getParameters().get('showId');
            String orderId = ApexPages.currentPage().getParameters().get('orderId');
            got.Status__c = 'Canceled';
            Database.update(got, false);
            return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_OrderView?showId=' + showId + '&orderId=' + orderId);

        } else {
            if (GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_ACCT_MANAGER) && GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_SALES_MGR) && GC_SecurityUtil.userHasRole('System Administrator')) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'You don\'t have permissions to cancel this GES order.'));
                return null;
            }

            GC_GES_Order_Task__c gesOrder = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(got.Id);

            if (gesOrder.Status__c != 'Canceled') {
                gesOrder.Previous_Status__c = gesOrder.Status__c;
                gesOrder.Status__c = 'Canceled';
                gesOrder.Is_Active__c = false;
                update gesOrder;

            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Record is already canceled.'));
                return null;
            }

            PageReference pr = new PageReference('/apex/GC_OrderView');
            pr.getParameters().put('Id', got.Order__c);
            return pr;
        }
    }


    public PageReference cancelActionForCore() {
        GC_GES_Order_Task__c gesOrder = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(got.Id);

        if (gesOrder.Status__c != 'Canceled') {
            gesOrder.Previous_Status__c = gesOrder.Status__c;
            gesOrder.Status__c = 'Canceled';
            gesOrder.Is_Active__c = false;
            update gesOrder;
            return null;

        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Record is already canceled.'));
            return null;
        }
    }

    public PageReference approveForSubmitAction() {
        // Check to see if it's already in the approval process, if so approve via standard approval.
        if (GC_ApprovalUtils.isUnderApproval(got.Id)) {
            if (GC_ApprovalUtils.approveTask(got)) {
                //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.CONFIRM, 'The task ' + got.Name + ' has been Approved.')); /*commented by Sajid on 04/05/23 Ticket-1209*/
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.CONFIRM, 'The item ' + got.Name + ' has been Approved.')); // added by Sajid on 04/05/23 Ticket-1209
                PageReference approveSuccessPR = new PageReference('/apex/GC_OrderView');
                approveSuccessPR.getParameters().put('Id', got.Order__c);
                return approveSuccessPR;

            } else {
                return null;
            }
        }

        // check on the validity, if it's not valid, then return an error and null page ref.
        if (!GC_PageUtil.validateGesTask(got)) {
            return null;
        }

        // update the status to approved and return to the order view page.
        got.Status__c = 'Approved';
        update got;
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.CONFIRM, 'The task ' + got.Name + ' has been Approved.')); /*commented by Sajid on 04/05/23 Ticket-1209*/
        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.CONFIRM, 'The item ' + got.Name + ' has been Approved.')); //added by Sajid on 04/05/23 Ticket-1209
        PageReference pr = new PageReference('/apex/GC_OrderView');
        pr.getParameters().put('Id', got.Order__c);
        return pr;
    }

    public PageReference resetToNew() {
        got.Status__c = 'New';
        update got;
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.CONFIRM, 'The task ' + got.Name + ' has been reset to New.')); /*commented by Sajid on 04/05/23 Ticket-1209*/
        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.CONFIRM, 'The item ' + got.Name + ' has been reset to New.')); //added by Sajid on 04/05/23 Ticket-1209
        PageReference pr = new PageReference('/apex/GC_OrderTaskEdit');
        pr.getParameters().put('Id', got.Id);
        return pr;
    }

    /**
     * @description Submits the ges order task for approval to account team
     * @return PageReference
     **/
    public PageReference submitRecord() {
        got = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(got.Id);
        Boolean submitStatus = GC_ApprovalUtils.submitForApproval(got);
        return null;
    }

    public PageReference recallApprovalProcess() {
        try {
            Approval.ProcessWorkItemRequest pwr = new Approval.ProcessWorkItemRequest();

            List<ProcessInstance> procins = new List<ProcessInstance>([select Id from ProcessInstance where Status = 'Pending' and TargetObjectId = :got.Id]);
            // Retrieve the process work instance id associated to the process instance
            List<ProcessInstanceWorkitem>  workitem = new List<ProcessInstanceWorkitem>([select Id from ProcessInstanceWorkitem where ProcessInstanceId = :procins[0].id]);

            if ((workitem != null) && (workitem.size() > 0)) {
                pwr.SetComments(recallComments);

                pwr.setWorkItemId(workitem[0].id);
                pwr.setAction('Removed');
                // Execute process request
                Approval.ProcessResult pr = Approval.process(pwr);
            }

        } catch (Exception e) {
            GC_PageUtil.AddErrorMessage('Failed to Recall Approval Process for ' + got.Name);
        }

        got = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(got.Id);
        canRecall = got.OwnerId == UserInfo.getUserId() && GC_ApprovalUtils.isUnderApproval(got.Id);
        PageReference pr = new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_gotView');

        for (String key : ApexPages.currentPage().getParameters().keySet()) {
            pr.getParameters().put(key, ApexPages.currentPage().getParameters().get(key));
        }

        pr.setRedirect(true);
        return pr;
    }

    /**
     * @description Sets the owner field of the ges order task to the currently logged in user
     * @return null PageReference to refresh page
     **/
    public PageReference takeOwnership() {
        got.OwnerId = UserInfo.getUserId();
        update got;

        return null;
    }

    public PageReference submitGraphicsAction() {
        // Check for Graphics Project Manager's on Task.
        List<GC_Show_Team_Member__c> graphicsTeamMembers = [select Id, Name, User__c, Connect2_Show__c, Show_Role__c , User__r.Name, User__r.Email
                from GC_Show_Team_Member__c
                where Connect2_Show__c = :got.Order__r.Connect2_Show__c
                and ((Show_Role__c = 'Graphics Project Manager') or (Show_Role__c = 'Graphics Project Manager Direct'))
                order By LastModifiedDate desc];

        if (graphicsTeamMembers.size() == 0) {
            GC_PageUtil.AddErrorMessage('Graphics Project Manager is not assigned to show as a show team member. Cannot send Graphics Task.');
            return null;
        }

        Set<Id> usersToNotify = new Set<Id>();

        for(GC_Show_Team_Member__c gtm: graphicsTeamMembers) {
            GC_PageUtil.AddInfoMessage('Sending Email Notification to ' + gtm.User__r.Name + ' (' + gtm.User__r.Email + ')');
            usersToNotify.add(gtm.User__c);
        }

        return null;
    }
    
   public PageReference nextOrderTask(){       
        List<GC_GES_Order_Task__c> allGOT= [select Id, Name from GC_GES_Order_Task__c where (Order__c= :got.Order__c AND Status__c!= 'Archived' AND id!= :got.id)  order by Name];
        List<Integer> gotNumberList = new List<Integer>();
        if(allGOT.size()>0){
            Map<Integer,Id> allGOTMap = new Map<Integer,Id>();
            Integer identifier=1;
            Id nextId=null;
            /*commented by Sajid on 04/05/23 Ticket-1209
            Integer gotIdentifier=Integer.valueof(got.name.remove('GOT-').trim());
            for(GC_GES_Order_Task__c nextGOT:allGOT){               
                String gotNum= nextGOT.name.remove('GOT-').trim();
           	comment end*/
            
            //start SAL-1209, added by Sajid on 04/05/23
            Integer gotIdentifier;
            if(got.name.contains('GOT-')){
                gotIdentifier=Integer.valueof(got.name.remove('GOT-').trim());
            }else{
                gotIdentifier=Integer.valueof(got.name.remove('LI-').trim());
            }
            
            for(GC_GES_Order_Task__c nextGOT:allGOT){ 
                String gotNum;
                if(got.name.contains('GOT-')){
                    gotNum= nextGOT.name.remove('GOT-').trim();
                }else{
                    gotNum= nextGOT.name.remove('LI-').trim();
                }
                //end SAL-1209
                
                identifier= Integer.valueof(gotNum);
                allGOTMap.put(identifier, nextGOT.id);
                gotNumberList.add(identifier);
            }
            gotNumberList.sort();
            identifier=gotNumberList.get(0);
            for(Integer gotNumber: gotNumberList){
                if(gotNumber > gotIdentifier){
                    nextId=allGOTMap.get(gotNumber);
                    break;
                }else{
                    nextId=allGOTMap.get(identifier);
                }
            }
            PageReference pageRef;
            if(!IsCommunity){
                pageRef = Page.GC_OrderTaskView;
                pageRef.getParameters().put('Id',nextId);
            }else{
                pageRef = Page.GC_Community_gotView;
                pageRef.getParameters().put('gotId',nextId);
                pageRef.getParameters().put('showId',order.Connect2_Show__c);
                pageRef.getParameters().put('orderId',order.id);
            }
            pageRef.setRedirect(true);
            return pageRef;
        }else{
            //GC_PageUtil.AddErrorMessage('There are no other order tasks. Please use the Back To Order button to go back.'); /*commented by Sajid on 04/05/23 Ticket-1209*/
            GC_PageUtil.AddErrorMessage('There are no other items. Please use the Back To Order button to go back.'); // Code added by Sajid on 04/05/23 Ticket - 1209
            return null;
        }       
    }
    
//SAL-501
    public PageReference submitToCore(){
        GC_Core_Session__c session = new GC_Core_Session__c();
        Map<String, GC_GES_Order_Task__c> gesOrderTasksByName = new Map<String, GC_GES_Order_Task__c>();
        if(got.Status__c!='Approved'){
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'The task can not be submitted to Core unless it is approved.  Please revise and resubmit.')); /*commented by Sajid on 04/05/23 Ticket-1209*/
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'The item can not be submitted to Core unless it is approved.  Please revise and resubmit.')); // Code added by Sajid on 04/05/23 Ticket - 1209
        }else{
            try {
                session = GC_CoreUtils.getSessionID();
                coreSessionId = session.Core_Application_Session_ID__c;
                GC_Order__c currentOrder= GC_OrderDao.getInstance().getOrderById(got.Order__c);
                gesOrderTasksByName.put(got.Name, got);
                
                resultLogs.addAll(GC_CoreUtils.submitOrderToCore(coreSessionId,currentOrder,gesOrderTasksByName,true ));
                
                system.debug('success=='+got.status__c);
                //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.CONFIRM, 'The task ' + got.Name + ' has been submitted.' ));
            } catch (Exception e) {
                System.debug('session=== ' + session);
                GC_PageUtil.AddErrorMessage(e.getMessage());
                transactionPageErrors.add(e.getMessage());
            }
            
            
            
        }
        return null;
        
    }
    
    public PageReference validateSessionID() {
        GC_CoreUtils.validateSession(sessionObject);
        return null;
    }
    
    public PageReference insertLogs() {
        try{
            upsert resultLogs;
        }catch(exception e){
            GC_PageUtil.AddErrorMessage(e.getMessage());
        }
        return null;
    }
    
}