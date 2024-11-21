/**
* @author Ethos Solutions - www.ethos.com
* @description Controller for Order view page
* 2016-04-13 : Original Version
**/
public with sharing class GC_OrderViewController extends GC_BaseViewController {
    // Order Status Values
    // New - Applies as long as task has not been submitted
    // Active - As long as there is at least one task submitted (ges task)
    // WFI -
    // Closed (all tasks have status Client Approved)
    // Canceled (entire order is canceled by the requester)
    //
    // Task Status Values
    // Submitted
    // Request Rejected
    // Task Accepted
    // Task Rejected

    private final String DATE_TIME_FORMAT = 'MM/dd/YYYY hh:mm a';
    // Current order in view.
    public GC_Order__c currentOrder {get; set;}
    public GC_Connect2_Show__c currentShow {get; set;}
    //public GC_Connect2_Show__c Show {get; set;}

    // Task mapping in a specific order.
    public Map<String, GC_GES_Order_Task__c> GesOrderMapping {get; set;}
    public Map<String, GC_GES_Order_Task__c> GesOrderMappingByName {get; set;}
    // GC-6 Multiline Order Edit
    public List<GesTaskWrapper> gesOrderTasks {get; set;}
    public List<VendorTaskWrapper> vendorOrderTasks {get; set;}
    // Holds the selected tasks used for editing
    public GesTaskWrapper selectedGesTask {get; set;}
    // Holds the selected vendor task used for editing
    public VendorTaskWrapper selectedVendorTask {get; set;}

    // Mapping by Task ID that determines task permissions allowed based on status.
    public Map<String, GC_OrderUtils.TaskPermissions> taskPermissions { get; set; }

    public String coreSessionId { get; set; }

    // keeps track of ajax processing messages for rerendering at the end.
    public List<String> transactionPageErrors {get; set;}

    //----- Properties from Community Controller

    public Boolean CanCreate {get; set;}
    public Boolean CanSubmit {get; set;}
    public Boolean CanEdit {get; set;}
    public Boolean CanClone {get; set;}


    public GC_CoreQuery coreApi { get; set; }

    // Select options for the show. for Task edits.
    public List<SelectOption> materialOptions { get; set; }
    public List<SelectOption> venueLocations { get; set; }
    public List<SelectOption> departmentAttributes { get; set; }
    public List<SelectOption> serviceTypes { get; set; }
    public List<SelectOption> userslist { get; set; }
    public List<SelectOption> userslist1 { get; set; }
    public List<SelectOption> userslist2 { get; set; }
    public List<SelectOption> userslist3 { get; set; }
    public List<SelectOption> userslist4 { get; set; }

    // Boolean flags indicating if the order has items to submit, based off status.
    public Boolean hasItemstoSubmit {get; set;}
    public Boolean hasValidationErrors {get; set;}
    public Boolean hasItemstoCancel {get; set;}

    // New for GPM to link a Sign Order to an existing sign order.
    public List<SelectOption> designElementTasks { get; private set; }

    public GC_GES_Order_Task__c currentRevision {get; set;}


    public List<SelectOption> activeGemStructureTasks { get; private set; }


    public Boolean canDelete {get; set;}
    public Boolean checkVendorStatus {get; set;}

    public List<SelectOption> gesOrderTasksForVendors { get; private set; } 


    public Boolean isReadOnlyView {get; set;}

    //Avi - 19/04/2017 - Start
    public List<GC_Show_Team_Member__c> showTeamMembersList {get; set;}
    public Boolean isModalViewDisplay {get; set;}
    public String currenttTaskId { get; set; }
    public String emailDefaultList {get; set;}
    public List<showTeamMemberWrapper> shwTeamMemWrapList {get; set;}
    public List<showTeamMemberWrapperExternal> shwTeamMemWrapExList {get; set;}
    public List<showTeamMemberWrapperExternalVendor> shwTeamMemWrapExListVen {get; set;}
    public DateTime deliveryDateTime {get; set;}
    public DateTime completionDateTime {get; set;}
    public DateTime removalDateTime {get; set;}
    public String vendorSelect {get; set;}
    public Boolean selectAllGesOT {get; set;}
    public Boolean disableGESOT {get; set;} 
    public String gesOrderTaskSelected {get; set;} 
    public string  showId;
    public GC_Task_Field_Manager__c taskFieldManager {get; set;}  //SAL-636
    //Avi - 19/04/2017 - End
    
    
    //New Line
      public integer  newcount;
      public  integer submittedcount;
      public integer approvedcount;
      public integer activecount;
      public integer cancelledcount;
      public Boolean showAttrFlag{get;set;}
      
    //SAL-421 -- rksinha
    public static User currentUserInfo;
    public string orderTaskId {get; set;}
    public List<GC_Core_Interface_Log__c> resultLogs= new List<GC_Core_Interface_Log__c>();
    GC_Core_Session__c sessionObject = new GC_Core_Session__c();
      
    // Standard Consctuctor for non std controller.
    public GC_OrderViewController() {
        // This constructor is called for the community and lightning page
        
        showId = ApexPages.currentPage().getParameters().get('showId');
        IsSalesforce = GC_PageUtil.IsLightningUI();
        IsLightning = GC_PageUtil.IsLightningUI();
        IsCommunity = !GC_PageUtil.IsLightningUI();

        String orderId = ApexPages.currentPage().getParameters().get('orderId');

        if (String.isBlank(orderId)) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Failed to find the order, redirecting to home page'));
            return;
        }
        currentUserInfo = new User();   //SAL-421
        currentUserInfo = GC_OrderUtils.currentUserInfo(Userinfo.getUserId());  //SAL-421
        currentOrder = GC_OrderDao.getInstance().getOrderById(orderId);

        initializeController();
        checkCommunityPermissions();
        setShowAttributeFlag();
        
        
    }

    // Standard controller constructor, will mostly always have an ID here representing the Order.
    public GC_OrderViewController(ApexPages.StandardController stdController) {
        // This constructor is called on Salesforce
        
        IsSalesforce = true;
        IsLightning = false;
        IsCommunity = false;
        currentUserInfo = new User();   //SAL-421
        currentUserInfo = GC_OrderUtils.currentUserInfo(Userinfo.getUserId());  //SAL-421 
        //system.debug(currentUserInfo);
        currentOrder = GC_OrderDao.getInstance().getOrderById(stdController.getId());

        initializeController();
        setShowAttributeFlag();
      //  currentUserInfo = new User();   //SAL-421
        //currentUserInfo = GC_OrderUtils.currentUserInfo(Userinfo.getUserId());  //SAL-421  
    }

    public void initializeController() {
        orderTaskId ='';
        canDelete = currentOrder.OwnerId == UserInfo.getUserId() && currentOrder.Status__c != null;
        coreApi = new GC_CoreQuery();
        venueLocations = new List<SelectOption>();
        materialOptions = new List<SelectOption>();
        departmentAttributes = new List<SelectOption>();
        serviceTypes = new List<SelectOption>();

        transactionPageErrors = new List<String>();
        gesOrderTasks = new List<GesTaskWrapper>();
        vendorOrderTasks = new List<VendorTaskWrapper>();

        currentShow = GC_Connect2ShowDao.getInstance().getConnect2ShowById(currentOrder.Connect2_Show__c);
        GesOrderMapping = new Map<String, GC_GES_Order_Task__c>();
        GesOrderMappingByName = new Map<String, GC_GES_Order_Task__c>();
        taskPermissions = new Map<String, GC_OrderUtils.TaskPermissions>();
        checkVendorStatus = false;

        if (String.isBlank(currentShow.Job_Number__c)) {
            GC_PageUtil.AddWarningMessage('Job Number is blank, Can not proceed with Edit. ');
            coreApi.isProjectValid = false;

        } else {
            coreApi.showProjectNumber = currentShow.Job_Number__c;
            coreApi.isProjectValid = true;
        }

        coreApi.order = currentOrder;
        GC_OrderUtils.lookupShowAttributes(currentOrder.Connect2_Show__c, materialOptions, venueLocations, departmentAttributes);
        GC_OrderUtils.lookupServiceTypeAttributes(currentOrder.Connect2_Show__c, serviceTypes);

        if (designElementTasks == null) {
            designElementTasks = new List<SelectOption>();

        } else {
            designElementTasks.clear();
        }

        SelectOption noneSelectOption = new SelectOption('', '---None---');
        designElementTasks.add(noneSelectOption);
        //SAL-1293 - removed DRF reference in where clause - 12/20/23 - Sajid
        //List<GC_Design_Element__c> tasks = [select Id, Name, Design_Element__c, Deliverable__c, Task_Description__c from GC_Design_Element__c where Design_Request_Form__r.Connect2_Show__c = :currentOrder.Connect2_Show__c order by Name];
        List<GC_Design_Element__c> tasks = [select Id, Name, Design_Element__c, Deliverable__c, Task_Description__c from GC_Design_Element__c where Connect2_Show__c = :currentOrder.Connect2_Show__c order by Name];

        for (GC_Design_Element__c task : tasks) {
            String taskDesc = task.Name + ' - ' + task.Design_Element__c + ' - ' + task.Deliverable__c + ' - ' + task.Task_Description__c;
            designElementTasks.add(new SelectOption(task.Id, taskDesc));
        }

        refreshTasks();

        isReadOnlyView = false;
        List<Profile> profiles = [SELECT Id, Name FROM Profile WHERE Id = :userinfo.getProfileId() LIMIT 1];
        if (profiles.size() > 0 && profiles[0].Name == 'GC Community Vendor') {
            isReadOnlyView = false;
        }

        isModalViewDisplay = false;
        disableGESOT = false;

        String showId = ApexPages.currentPage().getParameters().get('showId'); 
        showTeamMembersList = new List<GC_Show_Team_Member__c>();
        showTeamMembersList = [SELECT Id,Show_Role__c,User__r.Name,User__r.Email,Connect2_Show__r.TeamMemberDefaultList__c FROM GC_Show_Team_Member__c WHERE Connect2_Show__c = :showId ORDER BY Show_Role__c,User__r.Name ASC];

        List<String> emailAddress = new List<String>();
        Set<String> userEmails = new Set<String>();
        shwTeamMemWrapList = new List<showTeamMemberWrapper>();
        shwTeamMemWrapExList = new List<showTeamMemberWrapperExternal>();
        shwTeamMemWrapExListVen = new List<showTeamMemberWrapperExternalVendor>();

        if(showTeamMembersList.size() > 0)
        {
            if(!String.isBlank(showTeamMembersList[0].Connect2_Show__r.TeamMemberDefaultList__c))
            {
                emailAddress = showTeamMembersList[0].Connect2_Show__r.TeamMemberDefaultList__c.split(',');
            }
        }

        if(emailAddress.size() > 0)
        {
            for(String em: emailAddress)
            {
                userEmails.add(em);
            }
        }

        for(GC_Show_Team_Member__c st:showTeamMembersList)
        {
            Boolean checked = false;

            if(userEmails.size() > 0)
            {
                if(userEmails.contains(st.User__r.Email))
                {
                    checked = true;
                }
            }
            if(st.Show_Role__c == 'Show Organizer' || st.Show_Role__c == 'Vendor') 
            {
                if(st.Show_Role__c == 'Show Organizer')
                {
                    shwTeamMemWrapExList.add(new showTeamMemberWrapperExternal(st.User__r.Name,st.Show_Role__c,st.User__r.Email,st.Id,checked));
                }
                else
                {
                    shwTeamMemWrapExListVen.add(new showTeamMemberWrapperExternalVendor(st.User__r.Name,st.Show_Role__c,st.User__r.Email,st.Id,checked));
                }
                
            }
            else
            {
                shwTeamMemWrapList.add(new showTeamMemberWrapper(st.User__r.Name,st.Show_Role__c,st.User__r.Email,st.Id,checked));
            }
            
        }

        shwTeamMemWrapExList.sort();
        shwTeamMemWrapExListVen.sort();

     //   system.debug('shwTeamMemWrapList++++'+shwTeamMemWrapList);
     
     //SAL-636
        
        try{
            taskFieldManager = [SELECT id, name, Background__c,Booth_Area_Discount__c,Budget_Code__c,Client_Layout_Notes__c,Completion_Date_Time__c,Connect2_Show__c,Copy_Placement__c,Default_Completion_Date_Time__c,Default_Installation_Delivery_Date_Time__c,Default_Removal_Date_Time__c,Delivery_Area__c,File_Reference_Link_Folder__c,Installation_Delivery_Date_Time__c,Installation_Method__c,Onsite_Contact_Person__c,Onsite_Contact_Person_Number__c,Outdoors__c,Price__c,Removal_Date_Time__c,Save_Signs__c,Sign_Copy__c,Sign_Title__c,Sign_Type__c,Sign_Type_Other__c,Single_Double_Sided__c,Special_Instructions_Client_Remarks__c,User__c,User_Item_Description__c,Hide_Order_Level_File_Upload__c  FROM GC_Task_Field_Manager__c WHERE Connect2_Show__c=:showId LIMIT 1];
        }
        catch(exception e){
            taskFieldManager= new GC_Task_Field_Manager__c();
            taskFieldManager.Connect2_Show__c= showId;
        }
        //setShowAttributeFlag();
        
    }

    public PageReference loadAction() {

        // LoadAction is only called on community and lightning UI
        // FIXME: Determine right redirects for lightning

        String showId = ApexPages.currentPage().getParameters().get('showId');
        String orderId = ApexPages.currentPage().getParameters().get('orderId');

        if (String.isBlank(showId)) {
            return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_ShowSearch');
        }

        if (String.isBlank(orderId)) {
            PageReference pr = new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_HomePage');
            pr.getParameters().put('showId', showId);
            return pr;
        }

        return null;

    }

    public PageReference sessionLoad() {
        transactionPageErrors.clear();
        GC_Core_Session__c session;

        try {
            session = GC_CoreUtils.getSessionID();
            coreApi.coreSessionId = session.Core_Application_Session_ID__c;

        } catch (Exception e) {
            GC_Core_Interface_Log__c logMsg;

            if (currentOrder != null && String.isNotBlank(currentOrder.Id)) {
                logMsg = GC_CoreUtils.createNewLog('Failed to Connect', 'Failed to Connect to Core ' + e.getMessage(), 'Error', currentOrder);

            } else {
                logMsg = GC_CoreUtils.createNewLog('Failed to Connect', 'Failed to Connect to Core ' + e.getMessage(), 'Error');
            }

            insert logMsg;
            transactionPageErrors.add(e.getMessage());
        }
        sessionObject = session;
        return null;
    }

    public PageReference sessionLogin() {
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

    public PageReference editAction() {
        if (IsSalesforce) {
            if (IsLightning) {
                
                PageReference pr = new PageReference('/NotImplemented');
                pr.setRedirect(true);
                return pr;

            } else {
                return new PageReference('/apex/GC_OrderEdit?Id=' + currentOrder.Id);
            }

        } else {
            // Community
            String showId = ApexPages.currentPage().getParameters().get('showId');
            String orderId = ApexPages.currentPage().getParameters().get('orderId');
            return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_OrderCreateEdit?orderId=' + orderId + '&showId=' + showId);
        }
    }


    public PageReference cloneAction() {

        String showId = ApexPages.currentPage().getParameters().get('showId');

        if (IsLightning) {
           
            PageReference pr = new PageReference('/NotImplemented');
            pr.setRedirect(true);
            return pr;

        } else if (IsCommunity) {
            PageReference pr = new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_OrderCreateEdit');
            pr.getParameters().put('showId', showId);
            pr.getParameters().put('isClone', '1');
            pr.getParameters().put('originalOrderId', currentOrder.Id);
            return pr;

        } else if (IsSalesforce) {
            try {
                PageReference pr = new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_OrderEdit');
                pr.getParameters().put('id', currentOrder.Id);
                pr.getParameters().put('isClone', '1');
                pr.setRedirect(true);
                return pr;

            } catch (Exception e) {
                GC_PageUtil.AddErrorMessage(' Failed to Clone the Order: ' + e.getMessage());
                return null;
            }
        }

        return null;
    }

    public PageReference deleteOrderAction() {
        checkVendorStatus = false;
        //String orderId = ApexPages.currentPage().getParameters().get('orderId');
        List<GC_GES_Order_Task__c> orderTaskToDelete = GC_GESOrderTaskDao.getInstance().getByGesOrderId(currentOrder.Id);
        List<GC_Vendor_Order_Task__c> vendorTaskToDelete = GC_VendorOrderTaskDao.getInstance().getByGesOrderId(currentOrder.Id);

        Id currentShowId = currentOrder.Connect2_Show__c;

        if (IsLightning) {
            PageReference pr = new PageReference('/NotImplemented');
            pr.setRedirect(true);
            return pr;

        } else {
            try {
                if (currentOrder.Status__c != 'Active') {
                    if (vendorTaskToDelete.size() > 0) {
                        delete vendorTaskToDelete;
                    }

                    if (orderTaskToDelete.size() > 0) {
                        delete orderTaskToDelete;
                    }

                    delete currentOrder;

                    if (IsCommunity) {
                        return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_HomePage?showId=' + currentShowId);
                    } else if (IsSalesforce) {
                        return new PageReference('/' + GC_Order__c.sobjecttype.getDescribe().getKeyPrefix() + '/o');
                    }
                } else if (currentOrder.Status__c == 'Active') {
                    //GC_PageUtil.AddErrorMessage('You have Active task orders, order cannot be deleted.'); /*commented by Sajid on 04/05/23 Ticket-1209*/
                    GC_PageUtil.AddErrorMessage('You have Active items, order cannot be deleted.'); // added by Sajid on 04/05/23 Ticket-1209
                }
            } catch (Exception e) {
                GC_PageUtil.AddErrorMessage(' Failed to Delete the Order: ' + e.getMessage());
                return null;
            }
        }

        return null;
    }

    public PageReference createOrderTask() {
        // Used on community and lightning only, classic SF has standard related list
        if (GC_PageUtil.IsLightningUI()) {
            String orderId = ApexPages.currentPage().getParameters().get('Id');
            String showId = ApexPages.currentPage().getParameters().get('showId');
            return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_LDS_gotCreateEdit?orderId=' + orderId );

        } else {
            String orderId = ApexPages.currentPage().getParameters().get('orderId');
            String showId = ApexPages.currentPage().getParameters().get('showId');
            return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_gotCreateEdit?orderId=' + orderId + '&showId=' + showId);
        }
    }

    public PageReference createVendorTask() {
        String orderId = ApexPages.currentPage().getParameters().get('orderId');
        String showId = ApexPages.currentPage().getParameters().get('showId');
        return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_votCreateEdit?orderId=' + orderId + '&showId=' + showId);
    }

    public PageReference approvalAction() {
        // TODO Submit for Approval test, used on Community Portal Only.
        validateGesTasks();
        return null;
    }

    /**
     * @description Validates tasks needing submitted.
     * @return Returns a null page refernce for proper rerendering.
     **/
    public PageReference submitOrderValidate() {
        hasItemstoSubmit = false;
        hasValidationErrors = false;
        singleTaskId = ApexPages.currentPage().getParameters().get('singleTaskId');
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
                        hasItemstoSubmit = true;
                        break;
                    }
                }
            }
        }
        else {
            for (GC_GES_Order_Task__c orderTask : GesOrderMapping.values()) {
                if (orderTask.Status__c == 'Approved') {
                    hasItemstoSubmit = true;
                    break;
                }
            }
        }

        if (!hasItemstoSubmit) {
            //GC_PageUtil.AddWarningMessage('There are no tasks approved to submit to core.'); /*commented by Sajid on 04/05/23 Ticket-1209*/
            GC_PageUtil.AddWarningMessage('There are no items approved to submit to core.'); //added by Sajid on 04/05/23 Ticket-1209
            return null;
        }

        if (!validateGesTasks()) {
            GC_PageUtil.AddWarningMessage('Validation Errors.');
            hasValidationErrors = true;
            return null;
        }

        updateGraphicsTasks(singleTaskId);
        refreshTasks();
        //OrderStatusChange();
        
       
        return null;
    }

    /**
     * @description Validates tasks for cancel order that need canceling.
     * The order uses the status as canceled and has an order line id.
     * @return Returns a null page refernce for proper rerendering.
     **/
    public PageReference cancelOrderValidate() {
        hasItemstoCancel = false;

        for (GC_GES_Order_Task__c orderTask : GesOrderMapping.values()) {
            // TODO need canceled in core, need to check for line id
            if (orderTask.Status__c == 'Canceled' && String.isNotBlank(orderTask.Order_Line_ID__c) && !orderTask.Core_Cancelled__c) {
                hasItemstoCancel = true;
                break;
            }
        }

        if (!hasItemstoCancel) {
            //GC_PageUtil.AddWarningMessage('There are no tasks to cancel.'); /*commented by Sajid on 04/05/23 Ticket-1209*/
            GC_PageUtil.AddWarningMessage('There are no items to cancel.'); //added by Sajid on 04/05/23 Ticket-1209
            return null;
        }

        refreshTasks();
        // OrderStatusChange();
        return null;
    }

    public String singleTaskId {get; set;}

    /**
     * @description Calls out to web service to submit staging items for ordering
     * @return Returns a null page refernce for proper rerendering.
     **/
    public PageReference submitOrderAction() {
        for (String pageError : transactionPageErrors) {
            GC_PageUtil.AddErrorMessage(pageError);
        }

        if (transactionPageErrors.size() > 0) {
            return null;
        }

        if (!validateGesTasks()) {
            return null;
        }

        if ( String.isNotBlank(singleTaskId)) {
            Map<String, GC_GES_Order_Task__c> newMapByName = new Map<String, GC_GES_Order_Task__c> ();

            for (GC_GES_Order_Task__c orderTask : GesOrderMappingByName.values()) {
                if (orderTask.Id == singleTaskId) {
                     newMapByName.put(orderTask.Name, orderTask);
                }
            }

            if (newMapByName.size() > 0) {
                resultLogs.addAll(GC_CoreUtils.submitOrderToCore(coreSessionId, currentOrder, newMapByName, false));
            }
        }
        else {
            resultLogs.addAll(GC_CoreUtils.submitOrderToCore(coreSessionId, currentOrder, GesOrderMappingByName, false));
        }
        //system.debug('resultLogssubmitOrderAction==='+resultLogs);
        system.debug('resultLogssubmitOrderAction==='+resultLogs.size());
        return null;
    }

    public void updateGraphicsTasks(String singleTaskId) {
        List<GC_Show_Team_Member__c> graphicsTeamMembers =
            [Select Id, Name, User__c, Connect2_Show__c, Show_Role__c , User__r.Email
             From GC_Show_Team_Member__c
             Where Connect2_Show__c = :currentShow.Id
                                      and (Show_Role__c = 'Graphics Project Manager')
                                      Order By LastModifiedDate desc];

        List<GC_GES_Order_Task__c> tasksToUpdate = new List<GC_GES_Order_Task__c>();

        if ( String.isNotBlank(singleTaskId)) {
            Map<String, GC_GES_Order_Task__c> newMap = new Map<String, GC_GES_Order_Task__c> ();

            for (GC_GES_Order_Task__c orderTask : GesOrderMappingByName.values()) {
                if (orderTask.Id == singleTaskId) {
                     newMap.put(orderTask.Name, orderTask);
                }
            }

            if (newMap.size() > 0) {
                GesOrderMappingByName.clear();
                for (GC_GES_Order_Task__c orderTask : newMap.values()) {
                    GesOrderMappingByName.put(orderTask.Name, orderTask);
                }
            }

        }

        for (GC_GES_Order_Task__c task : GesOrderMappingByName.values()) {
            if (task.Item_Template__c == null || !task.Item_Template__c.contains('Graphics')) {
                continue;
            }

            if (task.Status__c != 'Approved') {
                continue;
            }

            task.GPM_Approver_1__c = null;
            task.GPM_Approver_2__c = null;
            task.GPM_Approver_3__c = null;

            for (GC_Show_Team_Member__c teamMember : graphicsTeamMembers) {
                if (task.GPM_Approver_1__c == null) {
                    task.GPM_Approver_1__c = teamMember.User__c;
                } else if (task.GPM_Approver_2__c == null) {
                    task.GPM_Approver_2__c = teamMember.User__c;
                } else if (task.GPM_Approver_3__c == null) {
                    task.GPM_Approver_3__c = teamMember.User__c;
                    break;
                }
            }

            if (task.GPM_Approver_1__c != null) {
                if (task.GPM_Approver_2__c == null) {
                    task.GPM_Approver_2__c = task.GPM_Approver_1__c;
                }

                if (task.GPM_Approver_3__c == null) {
                    task.GPM_Approver_3__c = task.GPM_Approver_1__c;
                }
            }

            tasksToUpdate.add(task);
        }

        Database.update(tasksToUpdate, false);
    }

    /**
     * @description Calls out to web service to process staging items.
     * @return Returns a null page refernce for proper rerendering.
     **/
    public PageReference processOrderAction() {
        hasItemstoSubmit = false;
        hasValidationErrors = false;
        singleTaskId = null;
        for (String pageError : transactionPageErrors) {
            GC_PageUtil.AddErrorMessage(pageError);
        }

        if (transactionPageErrors.size() > 0) {
            return null;
        }

        if (!validateGesTasks()) {
            return null;
        }

        //sessionLogin(); commented by nk
        resultLogs.addAll( GC_CoreUtils.processOrderBatch(coreSessionId, currentOrder, GesOrderMappingByName, false));
        currentOrder = GC_OrderDao.getInstance().getOrderById(currentOrder.Id);
        refreshTasks();
        //system.debug('resultLogsprocessOrderAction==='+resultLogs);
        //system.debug('resultLogsprocessOrderAction==='+resultLogs.size());
        return null;
    }

    /**
     * @description Calls out to web service to submit items to cancel and push in staging area.
     * @return Returns a null page refernce for proper rerendering.
     **/
    public PageReference cancelOrderAction() {
        for (String pageError : transactionPageErrors) {
            GC_PageUtil.AddErrorMessage(pageError);
        }

        if (transactionPageErrors.size() > 0) {
            return null;
        }

        sessionLogin();
        GC_CoreUtils.cancelOrderInCore(coreSessionId, currentOrder, GesOrderMappingByName, false);
        return null;
    }


    /**
     * @description Calls out to web service to process staging items.
     * @return Returns a null page refernce for proper rerendering.
     **/
    public PageReference processCancelOrderAction() {
        for (String pageError : transactionPageErrors) {
            GC_PageUtil.AddErrorMessage(pageError);
        }

        sessionLogin();
        GC_CoreUtils.processOrderBatch(coreSessionId, currentOrder, GesOrderMappingByName, true);
        currentOrder = GC_OrderDao.getInstance().getOrderById(currentOrder.Id);
        refreshTasks();
        return null;
    }


    // ---------------- Community Actions


    /**
     * @description Community action only, not done by account managers, or internal users.
     **/
    public PageReference submitOrder() {

        String showId = GC_PageUtil.getParam('showId');

        if (String.isBlank(showId)) {
            showId = currentOrder.Connect2_Show__c;
        }

        String whereClause = 'Order__c = \'' + currentOrder.Id + '\' AND OwnerId = \'' + UserInfo.getUserId() + '\'';
        List<GC_GES_Order_Task__c> gots;

        try {
            gots = GC_GESOrderTaskDao.getInstance().getByWhere(whereClause);

        } catch (Exception e) {
            System.debug(e.getMessage());
            GC_PageUtil.AddDeveloperMessage(e.getMessage());
            GC_PageUtil.AddDeveloperMessage(e.getStackTraceString());
            return null;
        }

        List<GC_Show_Team_Member__c> teams = [Select Id, Name, User__c, Connect2_Show__c, Show_Role__c , User__r.Email
                                              From GC_Show_Team_Member__c
                                              Where Connect2_Show__c = :showId and Show_Role__c = 'Account Manager'];

        if (teams.size() == 0) {
            GC_PageUtil.AddErrorMessage('An account manager is not found for this show.');
            return null;
        }

        Set<Id> approverUserIds = new Set<Id>();

        for (GC_Show_Team_Member__c team : teams) {
            approverUserIds.add(team.User__c);
        }

        Integer errors = 0;
        Integer newCount = 0;

        List<GC_GES_Order_Task__c> tasksToSubmit = new List<GC_GES_Order_Task__c>();

        for (GC_GES_Order_Task__c got : gots) {
            if (got.Status__c == 'New') {
                newCount++;
            }

            if (got.Status__c != 'New' && got.Status__c != 'Rejected') {
                continue;
            }

            tasksToSubmit.add(got);

           
        }

        if (!GC_ApprovalUtils.submitForApproval(showId, tasksToSubmit)) {
            errors++;
        }

        List<GC_Vendor_Order_Task__c> vots = GC_VendorOrderTaskDao.getInstance().getByGesOrderId(currentOrder.Id);
        List<GC_Vendor_Order_Task__c> votList = new List<GC_Vendor_Order_Task__c>();

        List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();

        for (GC_Vendor_Order_Task__c vot : vots) {
            if (vot.Status__c != 'New') {
                continue;
            }

            newCount ++;

            if (vot.Vendor__c == null) {
                GC_PageUtil.AddErrorMessage('Please add vendor for ' + vot.Name + '.');
                return null;
            }

            if (vot.Vendor__c != null) {
                emailMessages.add(GC_OrderUtils.generateVendorEmail(vot, vot.Vendor__c,currentShow.Name+ ' '+currentShow.Show_Name__c,vot.Service_Type__r.Name));
            }

            if (vot.Vendor2__c != null) {
                emailMessages.add(GC_OrderUtils.generateVendorEmail(vot, vot.Vendor2__c,currentShow.Name+ ' '+currentShow.Show_Name__c,vot.Service_Type2__r.Name));
            }

            if (vot.Vendor3__c != null) {
                emailMessages.add(GC_OrderUtils.generateVendorEmail(vot, vot.Vendor3__c,currentShow.Name+ ' '+currentShow.Show_Name__c,vot.Service_Type3__r.Name));
            }

            if (vot.Vendor4__c != null) {
                emailMessages.add(GC_OrderUtils.generateVendorEmail(vot, vot.Vendor4__c,currentShow.Name+ ' '+currentShow.Show_Name__c,vot.Service_Type4__r.Name));
            }

            if (vot.Vendor5__c != null) {
                emailMessages.add(GC_OrderUtils.generateVendorEmail(vot, vot.Vendor5__c,currentShow.Name+ ' '+currentShow.Show_Name__c,vot.Service_Type5__r.Name));
            }

            vot.Status__c = 'Sent';
            vot.Submitted_Date__c = Date.today();
            votList.add(vot);
        }

        if (newCount == 0) {
            GC_PageUtil.AddInfoMessage('No New Order Tasks to submit.');
            errors++;
        }

        if (errors > 0) {
            return null;
        }

        update votList;
        votList = GC_VendorOrderTaskDao.getInstance().getByGesOrderId(currentOrder.Id);

        if (emailMessages.size() > 0) {
            Messaging.SendEmail(emailMessages, false);
        }

        String orderId = GC_PageUtil.getParam('orderId');

        if (String.isNotBlank(showId) && String.isNotBlank(orderId)) {
            gots = GC_GESOrderTaskDao.getInstance().getByGesOrderId(orderId);

            for (GC_GES_Order_Task__c task : gots) {
                GC_PageUtil.AddDeveloperMessage(task.Name + ' ' + task.Status__c);
            }

            PageReference pr = new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_OrderView');

            for (String key : ApexPages.currentPage().getParameters().keySet()) {
                if (key.containsIgnoreCase('orderId') || key.containsIgnoreCase('showId')) {
                    pr.getParameters().put(key, ApexPages.currentPage().getParameters().get(key));
                }
            }

            pr.setRedirect(true);
            return pr;

        } else {
            GC_PageUtil.AddWarningMessage('Failed to redirect to the view page.');
            return null;
        }
    }


    public void checkCommunityPermissions() {
        CanCreate = true;
        CanSubmit = true;
        CanEdit = true;
        CanClone = true;

        CanEdit = currentOrder.Status__c != 'Active';

        List<Profile> profile = [SELECT Id, Name FROM Profile WHERE Id = :userinfo.getProfileId() LIMIT 1];
        String profileName = profile[0].Name;

        if (profileName == 'GC Community Vendor') {
            CanCreate = false;
            CanSubmit = false;
            CanEdit = false;
            CanClone = false;
        }

        if (profileName == 'GC Community Client' && currentShow != null) {
            List<GC_Show_Team_Member__c> stm = [SELECT Id, Name, User__c, Show_Role__c, Connect2_Show__c FROM GC_Show_Team_Member__c WHERE Connect2_Show__c = :currentShow.Id AND User__c = :userinfo.getUserId()];

            if (stm.size() > 0 && stm[0].Show_Role__c == 'Show Organizer - Read Only') {
                CanCreate = false;
                CanSubmit = false;
                CanEdit = false;
                CanClone = false;
            }
        }
    }

    // ----------------- END Community Specific actions

    /**
     * @description ***** TESTING ONLY ****** Gets all orders for a particular booth area, this could be useful for backfill / timeout errors
     **/
    

    /**
     * @description Validates the approved GES Tasks for Required Fields.
     * @return True if valid, false otherwise.
     **/
    public Boolean validateGesTasks() {
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
                            //errors.add('Order Task ' + orderTask.Name + ' has failed validation'); //commented by Sajid on 04/05/23 Ticket-1209
                            errors.add('Item ' + orderTask.Name + ' has failed validation'); //added by Sajid on 04/05/23 Ticket-1209
                        }

                        index++;
                    }
                }
            }

        }
        else {
            for (GC_GES_Order_Task__c orderTask : GesOrderMapping.values()) {
                if (orderTask.Status__c == 'Approved') {
                    if (!validateGesTask(index, orderTask)) {
                        //errors.add('Order Task ' + orderTask.Name + ' has failed validation'); //commented by Sajid on 04/05/23 Ticket-1209
                        errors.add('Item ' + orderTask.Name + ' has failed validation'); //added by Sajid on 04/05/23 Ticket-1209
                    }

                    index++;
                }
            }
        }

        return errors.size() == 0;
    }

    /**
     * @description Validates the approved GES Task for Required Fields.
     * @return True if valid, false otherwise.
     **/
    public Boolean validateGesTask(Integer index, GC_GES_Order_Task__c got) {
        return GC_PageUtil.validateGesTask(got);
    }

    /**
     * @description Redirects to the order print page for printing the order.
     * @return Redirect to the Show on the go page.
     **/
    public PageReference printOrder() {
        String orderId = GC_PageUtil.getParam('orderId');
        return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_ShowOnTheGoPDF?orderIds=' + orderId );
    }

    // FIXME - hardcoded verbiage from community controller. These should really be labels

    public String getCommunitySubmitTitle() {
        //return 'Submit all of my New tasks to the Account Manager for Approval.'; /*commented by Sajid on 04/05/23 Ticket-1209*/
        return 'Submit all of my New items to the Account Manager for Approval.'; //added by Sajid on 04/05/23 Ticket-1209
    }

    public String getSubmitTitle() {
        //return 'Submit all New tasks to the Account Manager for Approval.'; /*commented by Sajid on 04/05/23 Ticket-1209*/
        return 'Submit all New items to the Account Manager for Approval.'; //added by Sajid on 04/05/23 Ticket-1209
    }
    public String getPrintOrderTitle() {
        //return 'Prints the order and associated order tasks as PDF.'; /*commented by Sajid on 04/05/23 Ticket-1209*/
        return 'Prints the order and associated items as PDF.'; //added by Sajid on 04/05/23 Ticket-1209
    }
    public String getEditTitle() {
        return 'Edit the Order.';
    }
    public String getCloneTitle() {
        //return 'Clones order and associated order tasks to a new Show.'; /*commented by Sajid on 04/05/23 Ticket-1209*/
        return 'Clones order and associated items to a new Show.'; //added by Sajid on 04/05/23 Ticket-1209
    }
    public String getCreateNewGesTask() {
        //return 'Creates a new GES Task.'; /*commented by Sajid on 04/05/23 Ticket-1209*/
        return 'Creates a new GES Item.'; //added by Sajid on 04/05/23 Ticket-1209
    }
    public String getCreateNewVendorTask() {
        return 'Creates a new Vendor Task.';
    }
    public String getDeleteTitle() {
        //return 'Deletes order and associated order tasks.'; /*commented by Sajid on 04/05/23 Ticket-1209*/
        return 'Deletes order and associated items.'; //added by Sajid on 04/05/23 Ticket-1209
    }

    /**
     * @description Updates the internal controller related items, when updates are made.
     **/
    public void refreshTasks() {
        if (taskPermissions == null) {
            taskPermissions = new Map<String, GC_OrderUtils.TaskPermissions>();
        }

        gesOrderTasks.clear();
        vendorOrderTasks.clear();
        taskPermissions.clear();
        Set<String> taskIds = new Set<String>();

        if (currentOrder != null && String.isNotBlank(currentOrder.Id)) {
            currentOrder = GC_OrderDao.getInstance().getOrderById(currentOrder.Id);
            List<GC_GES_Order_Task__c> gesTasks = GC_GESOrderTaskDao.getInstance().getByGesOrderIdAndExcludeStatus(currentOrder.Id, 'Archived');
            List<GC_Vendor_Order_Task__c> vendorTasks = GC_VendorOrderTaskDao.getInstance().getByGesOrderId(currentOrder.Id);

            for (GC_GES_Order_Task__c task : gesTasks) {
                if (task.Status__c == 'Archived') {
                    continue;
                }

                taskIds.add(task.Id);
            }


            for (GC_GES_Order_Task__c task : gesTasks) {
                if (task.Status__c == 'Archived') {
                    continue;
                }

                GesTaskWrapper wrapper = new GesTaskWrapper();
                wrapper.task = task;
                
                wrapper.fileCount = task.ContentDocumentLinks.size();
                gesOrderTasks.add(wrapper);

            }

            for (GC_Vendor_Order_Task__c task : vendorTasks) {
                VendorTaskWrapper wrapper = new VendorTaskWrapper();
                wrapper.task = task;
                
                wrapper.fileCount = task.ContentDocumentLinks.size();
                vendorOrderTasks.add(wrapper);

                if ( task.Status__c == 'Sent') {
                    checkVendorStatus = true;
                }
            }
        }

        GesOrderMapping.clear();
        GesOrderMappingByName.clear();

        taskPermissions.clear();
        taskIds.clear();

        for (GesTaskWrapper gesOrder : gesOrderTasks) {
            taskIds.add(gesOrder.task.Id);
        }

        Map<String, Boolean> approvalItems = GC_ApprovalUtils.isUnderApproval(taskIds);

        for (GesTaskWrapper gesOrder : gesOrderTasks) {
            GesOrderMapping.put(gesOrder.task.Id, gesOrder.task);
            GesOrderMappingByName.put(gesOrder.task.Name, gesOrder.task);
            taskPermissions.put(gesOrder.task.Id, new GC_OrderUtils.TaskPermissions(gesOrder.task, approvalItems.get(gesOrder.task.Id)));
        }

        // Build up a list of GEM Structures to Link to.
        activeGemStructureTasks = new List<SelectOption>();
        activeGemStructureTasks.add(new SelectOption('', '----None----'));

        for (GesTaskWrapper gesOrderTask : gesOrderTasks) {
            if (gesOrderTask.task.Status__c == 'Active' && String.isNotBlank(gesOrderTask.task.Description__c) && gesOrderTask.task.Description__c.startsWith('GEM Structure with')) {
                String taskKey = gesOrderTask.task.Name + '-' + gesOrderTask.task.Item_Number__c + '-' + gesOrderTask.task.Description__c;
                activeGemStructureTasks.add(new SelectOption(String.valueOf(gesOrderTask.task.Id), taskKey));
            }
        }

        if (gesOrderTasksForVendors == null) {
            gesOrderTasksForVendors = new List<SelectOption>();
        }

        gesOrderTasksForVendors.clear();
        gesOrderTasksForVendors.add(new SelectOption('', '----None----'));

        for (GesTaskWrapper gesOrder : gesOrderTasks) {
            String displayValue = gesOrder.task.Name + ' - ' + gesOrder.task.Description__c + ' (' + gesOrder.task.Status__c + ')';
            gesOrderTasksForVendors.add(new SelectOption(gesOrder.task.Id, displayValue));
        }

        isModalViewDisplay = true;
    }

    /**
     * @description Creates a new task in a new page. //SAL-612 rksinha
     * @return to a new page as per classic or community domains. last return will be null.
     **/
    public PageReference newTask() {
        String orderId = ApexPages.currentPage().getParameters().get('id');     
       
        if(isCommunity){
            orderId = ApexPages.currentPage().getParameters().get('orderId');
            return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_GOTCreatePage?OrderId=' + orderId +'&showId='+ showId);
        }else{
            return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_GOTCreatePage?OrderId=' + orderId +'&showId='+ showId);
        }
    }
    
    //Added for Clone fucntionality in GES Order Task
    public PageReference cloneOrderTask(){
        String orderId = ApexPages.currentPage().getParameters().get('orderId');
        String showId = ApexPages.currentPage().getParameters().get('showId');
        return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_OrdTask_Clone_SelectView?OrderId=' + orderId +'&showId='+ showId + '&isCommunity=true');
    }
    
    //Added for Clone fucntionality in GES Order Task Non Community
    public PageReference cloneOrderTaskNonCommunity(){
        String orderId = ApexPages.currentPage().getParameters().get('id');
        //String showId = ApexPages.currentPage().getParameters().get('showId');
        return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_OrdTask_Clone_SelectView?OrderId=' + orderId + '&isCommunity=false');
    }
    //Added for Clone fucntionality in GES Order Task
    
    //Added for Move fucntionality in GES Order Task Non Community
    public PageReference moveOrderTaskNonCommunity()
    {
        String orderId = ApexPages.currentPage().getParameters().get('id');
        String showId = currentOrder.Connect2_Show__c;
        return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_OrdTask_Move_SelectView?OrderId=' + orderId +'&showId='+ showId+ '&isCommunity=false');
    }
    
    /**
     * @description Edits a selected task in a new page for editing. SAL-612 rksinha
     * @return null
     **/
    public PageReference editTask() {
        String taskId = GC_PageUtil.getParam('taskId');
        String orderId = ApexPages.currentPage().getParameters().get('id');     
        if(isCommunity){
            orderId = ApexPages.currentPage().getParameters().get('orderId');
            return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_GOTCreatePage?OrderId=' + orderId +'&showId='+ showId+'&taskId='+taskId+'&isEdit=true');
        }else{
            return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_GOTCreatePage?OrderId=' + orderId +'&showId='+ showId+'&showId='+ showId+'&taskId='+taskId+'&isEdit=true');
        }
    }

    /**
     * @description Saves the current selected task
     * @return null
     **/
    public PageReference saveTask() {
        try {
            if (String.isBlank(selectedGesTask.task.Item_Number__c)) {
                GC_PageUtil.AddErrorMessage('Must select an item from the drop down.');
                return null;
            }

            GC_GES_Order_Task__c got = selectedGesTask.task;

            if (got.Item_Template__c != null && got.Item_Template__c.contains('Carpet') && got.Carpet_Length__c != null && got.Carpet_Width__c != null && got.UOM__c == 'SF') {
               got.QuantityNum__c = Integer.valueof(got.Carpet_Length__c * got.Carpet_Width__c);
            }
            
            
            if (got.Item_Template__c != null && got.Item_Template__c.contains('Carpet') && got.Carpet_Length__c != null && got.Carpet_Width__c != null && coreApi.selectedItem.ItemNumber == '900018') {
            got.QuantityNum__c = Integer.valueof(got.Carpet_Length__c * got.Carpet_Width__c);
            } 
          
           
          if (!GC_PageUtil.validateGesTask(got)) {
                return null;
            }

            if (String.isBlank(currentOrder.Id)) {
                insert currentOrder;
            }

            // GC-722 Trigger handlers status scenario when !active to active transition.
            // We need to insert the revision, and then link the two records together.
            // Save the Revision here so that we can link it.
            if (currentRevision != null && String.isBlank(currentRevision.Id)) {
                insert currentRevision;



            }

            // Perform the Actual Update and refresh the list.
            if (selectedGesTask != null && String.isNotBlank(selectedGesTask.task.Id)) 
            {
                if(selectedGesTask.task.Status__c == 'On Hold')
                {
                    selectedGesTask.task.Status__c = 'New';
                }
                update selectedGesTask.task;
                //OrderStatusChange();
                refreshTasks();
                selectedGesTask = null;

            } else if (selectedGesTask != null && String.isBlank(selectedGesTask.task.Id)) {
                selectedGesTask.task.Order__c = currentOrder.Id;
                if(!String.isBlank(coreApi.selectedCategory))
                {
                    if(coreApi.categoryMap.containsKey(coreApi.selectedCategory))
                    {
                        selectedGesTask.task.Item_Category__c = coreApi.categoryMap.get(coreApi.selectedCategory);
                    }
                }
                 
                insert selectedGesTask.task;
                //OrderStatusChange();

                if (currentRevision != null && String.isBlank(currentRevision.Original_Task_Revision2__c)) {
                    currentRevision.Original_Task_Revision2__c = selectedGesTask.task.Id;
                    selectedGesTask.task.Original_Task_Revision2__c = selectedGesTask.task.Id;

                } else {
                    selectedGesTask.task.Original_Task_Revision2__c = selectedGesTask.task.Id;
                }

                refreshTasks();
                selectedGesTask = null;
            }

        } catch (Exception e) {
            GC_PageUtil.AddErrorMessage('Exception caught saving task: ' + e.getMessage());
            GC_PageUtil.AddErrorMessage(e.getStackTraceString());
        }
//calling order status change
//system.debug('@@@order status change @@@@');
 //OrderStatusChange();


    return null;
    }
    
    
    
    
    
    public  GC_Order__c  OrderStatusChange(){
        
        return null;
        }
        
        
        /**
         * @description Cancels the selected task inline for editing.
         * @return null
         **/
        public PageReference cancelEditTask() {
            selectedGesTask = null;
            refreshTasks();
            /**
            *cancel edit logic here
            *After cancelling status shows intitial status only
            **/
            
            //OrderStatusChange();  
            return null;
    }

    /**
     * @description Removes the task from salesforce.
     * @return null
     **/
    public PageReference deleteTask() {
        String taskId = GC_PageUtil.getParam('taskId');
        GesTaskWrapper taskToDelete = null;

        for (GesTaskWrapper wrapper : gesOrderTasks) {
            if (wrapper.task != null && String.isNotBlank(wrapper.task.Id) && taskId == wrapper.task.Id) {
                taskToDelete = wrapper;
                break;
            }
        }

        if (taskToDelete != null) {
            if (String.isNotBlank(taskToDelete.task.Id)) {
                delete taskToDelete.task;
            }
            
            refreshTasks();
        }
     //OrderStatusChange();
        return null;
    }

    /**
     * @description Submits the Graphics task to the Graphics Project Manager for Approval and Review.
     **/
    public PageReference submitGraphicsTask() {
        String taskId = GC_PageUtil.getParam('taskId');
        GC_GES_Order_Task__c task = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(taskId);

        ApexPages.StandardController sc = new ApexPages.StandardController(task);
        GC_GESOrderTaskViewController vc = new GC_GESOrderTaskViewController(sc);
        PageReference pr = vc.submitGraphicsAction();
        refreshTasks();
        return null;
    }

    /**
     * @description Clones the task in a new page for editing. SAL-612 rksinha.  Only adds if it saves.
     * @return null
     **/
    public PageReference cloneTask() {
        String taskId = GC_PageUtil.getParam('taskId');
        String orderId = ApexPages.currentPage().getParameters().get('id');
        if(isCommunity){
            orderId = ApexPages.currentPage().getParameters().get('orderId');
            return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_GOTCreatePage?OrderId=' + orderId +'&showId='+ showId+'&taskId='+taskId+'&isClone=true');
        }else{
            return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_GOTCreatePage?OrderId=' + orderId +'&showId='+ showId+'&showId='+ showId+'&taskId='+taskId+'&isClone=true');
        }
    }

    /**
     * @description Cancels the task from the order, still requires to cancel the task in core.
     * @return null
     **/
    public PageReference cancelTask() {
        String taskId = GC_PageUtil.getParam('taskId');
        GC_GES_Order_Task__c task = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(taskId);
        GC_OrderUtils.cancelTask(task);
        refreshTasks();
        //OrderStatusChange(); //For updating Order Status
        return null;
    }

    /**
     * @description Archives the current active tasks and clones it for revising.
     * @return null
     **/
    public PageReference reviseTask() {
        String taskId = GC_PageUtil.getParam('taskId');
        GC_GES_Order_Task__c task = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(taskId);

        if (task.Status__c != 'Active' && task.Status__c != 'Released') {
            GC_PageUtil.AddFatalMessage('You may only revise an active/ released GES Order.');
            return null;
        }

        if (task.Original_Task_Revision2__c != null) {
            GC_GES_Order_Task__c currentRevision = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(task.Original_Task_Revision2__c);

            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, JSON.serialize(currentRevision)));

            if (currentRevision.Status__c == 'Active') {
                //GC_PageUtil.AddFatalMessage('A revision has already been started for this Task.  Proceed to edit this task: ' + task.Name); //commented by Sajid on 04/05/23 Ticket-1209
                GC_PageUtil.AddFatalMessage('A revision has already been started for this Item.  Proceed to edit this item: ' + task.Name); //added by Sajid on 04/05/23 Ticket-1209
                return null;
            }
        }

        Savepoint sp = Database.setSavepoint();

        try {
            // Create a clone of the record, this will get a new autonumber but keep the revision in tact.
            currentRevision = task.clone(false, true, false, true);
            currentRevision.Revision__c = task.Revision__c + 1;
            currentRevision.Last_Revision__c = DateTime.Now();
            currentRevision.Previous_Revision__c = task.Id;
            currentRevision.Submitted_Date__c = null;
            currentRevision.Status__c = 'New';
            currentRevision.Line_Item_Number__c = null;
            currentRevision.Line_Item_Status__c = null;
            currentRevision.Order_Header_ID__c = null;
            currentRevision.Order_Number__c = null;
            currentRevision.OwnerId = UserInfo.getUserId();
            currentRevision.Is_On_Hold__c = false;

            selectedGesTask = new GesTaskWrapper();
            selectedGesTask.isRevision = true;
            selectedGesTask.task = currentRevision;
            coreApi.setCurrentTask(selectedGesTask.task);

        } catch (Exception ex) {
            //GC_PageUtil.AddFatalMessage('Failed to Revise the task ' + ex.getMessage()); /*commented by Sajid on 04/05/23 Ticket-1209*/
            GC_PageUtil.AddFatalMessage('Failed to Revise the item ' + ex.getMessage()); //added by Sajid on 04/05/23 Ticket-1209
            //GC_PageUtil.AddDeveloperMessage('Failed to Revise the task ' + ex.getStackTraceString()); /*commented by Sajid on 04/05/23 Ticket-1209*/
            GC_PageUtil.AddDeveloperMessage('Failed to Revise the item ' + ex.getStackTraceString()); //added by Sajid on 04/05/23 Ticket-1209
            Database.rollback(sp);
            return null;
        }
      //OrderStatusChange();
        return null;
    }

    /**
     * @description Places the currently selected task on hold.
     * @return null
     **/
    public PageReference placeOnHoldTask() {
        String taskId = GC_PageUtil.getParam('taskId');
        GC_GES_Order_Task__c task = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(taskId);
        GC_OrderUtils.placeOnHoldTask(task);
        refreshTasks();
        //OrderStatusChange();
        return null;
    }

    /**
     * @description Releases the current task from hold
     * @return null
     **/
    public PageReference releaseFromHoldTask() {
        String taskId = GC_PageUtil.getParam('taskId');
        GC_GES_Order_Task__c task = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(taskId);
        GC_OrderUtils.releaseFromHoldTask(task);
        refreshTasks();
        //OrderStatusChange();
        return null;
    }

    /**
     * @description Approves the task for submitting to core.
     * @return null
     **/
    public PageReference approveTask() {
        String taskId = GC_PageUtil.getParam('taskId');
        GC_GES_Order_Task__c task = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(taskId);
        GC_OrderUtils.approveTask(task);
        //Testing approval
        refreshTasks();
        //OrderStatusChange();        
        return null;
    }
    
    /**
     * @description Flags an approved task for editing.
     * @return null
     **/
    public PageReference reworkTask() {
        String taskId = GC_PageUtil.getParam('taskId');
        GC_GES_Order_Task__c task = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(taskId);
        PageReference pr = GC_OrderUtils.reworkTask(task);
        refreshTasks();
        //OrderStatusChange();
        return null;
    }

    /**
     * @description Community submit to AM for approval.
     * @return null
     **/
    public PageReference submitTask() {
       
         try {
            String taskId = GC_PageUtil.getParam('taskId');
            
            isModalViewDisplay = true;
            currenttTaskId = taskId;
        } catch (Exception e) {
            /*GC_PageUtil.AddErrorMessage('Failed to submit the task: ' + e.getMessage()); commented by Sajid on 04/05/23 Ticket-1209*/
            GC_PageUtil.AddErrorMessage('Failed to submit the item: ' + e.getMessage()); //added by Sajid on 04/05/23 Ticket-1209
            GC_PageUtil.AddDeveloperMessage(e.getStackTraceString());
        }
        
        return null;
    }

    
    public PageReference filterVendors() {
        String showAttr = '';
       // system.debug('selectedVendorTask.task.Service_Type__c'+selectedVendorTask.task.Service_Type__c);
       // system.debug('vendorSelect++++'+vendorSelect);
        List<User> filterUsersSA = new List<User>();
        Map<Id,String> mapUsers = new Map<Id,String>();
        if(vendorSelect == 'Vendor1')
        {
            if(selectedVendorTask.task.Service_Type__c != null)
            {
                List<GC_Show_Attribute__c> showAttributes = [select Id, Name from GC_Show_Attribute__c where Id = :selectedVendorTask.task.Service_Type__c];
                if(showAttributes.size() > 0)
                {
                    showAttr = showAttributes[0].Name;
                }
             
                List<GC_Show_Team_Member__c> stmVen = [select Id,User__c,User__r.Name,User__r.CompanyName from GC_Show_Team_Member__c where Service_Type__c =: showAttributes[0].Id];
                
                //List<User> filterUsers = [select Id,Name,CompanyName from User where Profile.Name = 'GC Community Vendor' and IsActive = TRUE and ServiceType__c =:showAttr];
                
                List<User> filterUsers = [select Id,Name,CompanyName from User where Id in : mapUsers.keySet()];
                
                if (userslist == null) {
                    userslist = new List<SelectOption>();
                }

                userslist.clear();
               
                
                for(GC_Show_Team_Member__c stm1: stmVen)
                {
                    if(stm1.User__r.CompanyName != null || String.isNotBlank(stm1.User__r.CompanyName))
                    {
                        SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name+' - '+stm1.User__r.CompanyName);
                        userslist.Add(option);
                    }
                    else
                    {
                        SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name);
                        userslist.Add(option);
                    }
                }
            }
            else
            {
                userslist.clear();
            }
        }

        if(vendorSelect == 'Vendor2')
        {
            if(selectedVendorTask.task.Service_Type2__c != null)
            {
                List<GC_Show_Attribute__c> showAttributes = [select Id, Name from GC_Show_Attribute__c where Id = :selectedVendorTask.task.Service_Type2__c];
                if(showAttributes.size() > 0)
                {
                    showAttr = showAttributes[0].Name;
                }
                
                List<GC_Show_Team_Member__c> stmVen = [select Id,User__c,User__r.Name,User__r.CompanyName from GC_Show_Team_Member__c where Service_Type__c =: showAttributes[0].Id];
                //List<User> filterUsers = [select Id,Name,CompanyName from User where Profile.Name = 'GC Community Vendor' and IsActive = TRUE and ServiceType__c =:showAttr];

                if (userslist1 == null) {
                    userslist1 = new List<SelectOption>();
                }

                userslist1.clear();
                //SelectOption noneSelectOption = new SelectOption('', '---None---');
                //serviceTypeOptions.add(noneSelectOption);

                //for (User usr : filterUsers) 
                //{
                //    if(usr.CompanyName != null || String.isNotBlank(usr.CompanyName))
                //    {
                //        SelectOption option = new SelectOption(usr.Id, usr.Name+' - '+usr.CompanyName);
                //        userslist1.Add(option);
                //    }
                //    else
                //    {
                //        SelectOption option = new SelectOption(usr.Id, usr.Name);
                //        userslist1.Add(option);
                //    }  
                //}
                
                for(GC_Show_Team_Member__c stm1: stmVen)
                {
                    if(stm1.User__r.CompanyName != null || String.isNotBlank(stm1.User__r.CompanyName))
                    {
                        SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name+' - '+stm1.User__r.CompanyName);
                        userslist1.Add(option);
                    }
                    else
                    {
                        SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name);
                        userslist1.Add(option);
                    }
                }
            }
            else
            {
                userslist1.clear();
            }
        }

        if(vendorSelect == 'Vendor3')
        {
            if(selectedVendorTask.task.Service_Type3__c != null)
            {
                List<GC_Show_Attribute__c> showAttributes = [select Id, Name from GC_Show_Attribute__c where Id = :selectedVendorTask.task.Service_Type3__c];
                if(showAttributes.size() > 0)
                {
                    showAttr = showAttributes[0].Name;
                }
                //List<User> filterUsers = [select Id,Name,CompanyName from User where Profile.Name = 'GC Community Vendor' and IsActive = TRUE and ServiceType__c =:showAttr];
                List<GC_Show_Team_Member__c> stmVen = [select Id,User__c,User__r.Name,User__r.CompanyName from GC_Show_Team_Member__c where Service_Type__c =: showAttributes[0].Id];
                if (userslist2 == null) {
                    userslist2 = new List<SelectOption>();
                }

                userslist2.clear();
                //SelectOption noneSelectOption = new SelectOption('', '---None---');
                //serviceTypeOptions.add(noneSelectOption);

                for(GC_Show_Team_Member__c stm1: stmVen)
                {
                    if(stm1.User__r.CompanyName != null || String.isNotBlank(stm1.User__r.CompanyName))
                    {
                        SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name+' - '+stm1.User__r.CompanyName);
                        userslist2.Add(option);
                    }
                    else
                    {
                        SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name);
                        userslist2.Add(option);
                    }
                }
            }
            else
            {
                userslist2.clear();
            }
        }

        if(vendorSelect == 'Vendor4')
        {
            if(selectedVendorTask.task.Service_Type4__c != null)
            {
                List<GC_Show_Attribute__c> showAttributes = [select Id, Name from GC_Show_Attribute__c where Id = :selectedVendorTask.task.Service_Type4__c];
                if(showAttributes.size() > 0)
                {
                    showAttr = showAttributes[0].Name;
                }
                //List<User> filterUsers = [select Id,Name,CompanyName from User where Profile.Name = 'GC Community Vendor' and IsActive = TRUE and ServiceType__c =:showAttr];
                
                List<GC_Show_Team_Member__c> stmVen = [select Id,User__c,User__r.Name,User__r.CompanyName from GC_Show_Team_Member__c where Service_Type__c =: showAttributes[0].Id];
                
                if (userslist3 == null) {
                    userslist3 = new List<SelectOption>();
                }

                userslist3.clear();
                //SelectOption noneSelectOption = new SelectOption('', '---None---');
                //serviceTypeOptions.add(noneSelectOption);

                for(GC_Show_Team_Member__c stm1: stmVen)
                {
                    if(stm1.User__r.CompanyName != null || String.isNotBlank(stm1.User__r.CompanyName))
                    {
                        SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name+' - '+stm1.User__r.CompanyName);
                        userslist3.Add(option);
                    }
                    else
                    {
                        SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name);
                        userslist3.Add(option);
                    }
                }
            }
            else
            {
                userslist3.clear();
            }
        }

        if(vendorSelect == 'Vendor5')
        {
            if(selectedVendorTask.task.Service_Type5__c != null)
            {
                List<GC_Show_Attribute__c> showAttributes = [select Id, Name from GC_Show_Attribute__c where Id = :selectedVendorTask.task.Service_Type5__c];
                if(showAttributes.size() > 0)
                {
                    showAttr = showAttributes[0].Name;
                }
                List<User> filterUsers = [select Id,Name,CompanyName from User where Profile.Name = 'GC Community Vendor' and IsActive = TRUE and ServiceType__c =:showAttr];
                
                List<GC_Show_Team_Member__c> stmVen = [select Id,User__c,User__r.Name,User__r.CompanyName from GC_Show_Team_Member__c where Service_Type__c =: showAttributes[0].Id];
                
                if (userslist4 == null) {
                    userslist4 = new List<SelectOption>();
                }

                userslist4.clear();
                //SelectOption noneSelectOption = new SelectOption('', '---None---');
                //serviceTypeOptions.add(noneSelectOption);

                for(GC_Show_Team_Member__c stm1: stmVen)
                {
                    if(stm1.User__r.CompanyName != null || String.isNotBlank(stm1.User__r.CompanyName))
                    {
                        SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name+' - '+stm1.User__r.CompanyName);
                        userslist4.Add(option);
                    }
                    else
                    {
                        SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name);
                        userslist4.Add(option);
                    }
                }
            }
            else
            {
                userslist4.clear();
            }
        }
        
        
        return null;
    }


//--------------For sending email to user -------------
    public PageReference sendEmail() { 

       //----------- new changes------------------------
        List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
        List<GC_GES_Order_Task__c> GESorderInfo = GC_GESOrderTaskDao.getInstance().getByGesOrderId(currentOrder.Id);
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        
         //String taskId = GC_PageUtil.getParam('taskId');
        GC_GES_Order_Task__c task = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(currenttTaskId);
        PageReference pr = GC_OrderUtils.submitTask(task);
        refreshTasks();

        isModalViewDisplay = false;
        list<String> emailAddress = new List<String>();
        String Id = '';
        String order = '';
        String orderTask = '';
        String SignTitle='';
        String ItemNumber='';
        String Description ='';
        String UserItem_Description ='';
        String Price ='';
        String Total = '';
        String UOM ='';
        String QuantityNum ='';
        String Status ='';
        String CustomMsgBody='';
        String CustomMsgBody1='';
        Messaging.SingleEmailMessage[] messages = 
                    new List<Messaging.SingleEmailMessage> ();
        try {
            
           
            if(!String.isBlank(emailDefaultList))
            {
                emailAddress = emailDefaultList.split(',');
            }

            //List<GC_GES_Order_Task__c> ot = [SELECT Id,Order__r.Name,Name,Sign_Title__c,Item_Number__c,Description__c,Price__c,Total__c,UOM__c,QuantityNum__c,Status__c FROM GC_GES_Order_Task__c WHERE Id = :currenttTaskId]; /*commented by Sajid on 04/05/23 Ticket-1209*/
            List<GC_GES_Order_Task__c> ot = [SELECT Id,Order__r.Name,Name,Sign_Title__c,Item_Number__c,Description__c,User_Item_Description__c,Price__c,Total__c,UOM__c,QuantityNum__c,Status__c FROM GC_GES_Order_Task__c WHERE Id = :currenttTaskId]; // Added field User_Item_Description__c in query by Sajid on 04/05/23 Ticket-1209
           
            if(ot.size() > 0)
            {
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
             
             
             for (Attachment a : [select Name, Body, BodyLength from Attachment  where ParentId =:currenttTaskId]){
          
             Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                                     efa.setFileName(a.Name);
                                     efa.setBody(a.Body);
                                     fileAttachments.add(efa);
            
         }
             
           
           for(String mail:emailAddress)
            {
                if(!String.isBlank(mail))
                {
                    
                    //message.toAddresses = new String[] { mail };
                    //message.subject='Below Order Task are submitted for Approval' ; /*commented by Sajid on 04/05/23 Ticket-1209*/
                    message.subject='Below Item are submitted for Approval' ;  /*added Sajid on 04/05/23 Ticket-1209*/
                    /*CustomMsgBody1 = '<style>table, th, td { border: 1px solid black;}</style><b> Below Order Task are submitted for Approval </b></ br></ br><table><tr><th> Order Name</th><th> GES Order Task Number </th><th>Sign Title</th><th>Item Number</th><th>Description</th><th>Price</th><th>Total Price</th><th>Units</th><th>Quantity</th><th>Status</th></tr>'; commented by Sajid on 04/05/23 Ticket-1209 */
                    CustomMsgBody1 = '<style>table, th, td { border: 1px solid black;}</style><b> Below Item are submitted for Approval </b></ br></ br><table><tr><th> Order Name</th><th> GES Item Number </th><th>Sign Title</th><th>Item Number</th><th>Description</th><th>Price</th><th>Total Price</th><th>Units</th><th>Quantity</th><th>Status</th></tr>'; // added by Sajid on 04/05/23 Ticket-1209
                    CustomMsgBody1+='<tr><td>'+order +'</td><td><a href="https://ges--c.vf.force.com/apex/GC_OrderTaskView?id='+id+'&sfdc.override=1" target="_blank">'+ orderTask+'</a></td><td>'+SignTitle +'</td><td>'+ItemNumber +'</td><td>'+Description +'</td><td>'+Price +'</td><td>'+Total +'</td><td>'+UOM +'</td><td>'+QuantityNum +'</td><td>'+Status +'</td></tr>';
                    CustomMsgBody=CustomMsgBody1; 
                    message.setHtmlBody(CustomMsgBody1);
                    
                  
                  //---------- Checking the attachement size ---------------  
                    
                    if(fileAttachments.size()>0){
                  message.setFileAttachments(fileAttachments);
            }
           message.setToAddresses(new list<string>{mail});
      
                      // message.setReplyTo(mail);
           
                    //message.plainTextBody = order + orderTask;
                   // messages.add(message);
                }
                 
            }
            //---- Sending mail to user--------------
             Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message });
                    //messages.add(message);
                    //Messaging.sendEmail(messages);

        } catch (Exception e) {
           
        }
        
        // OrderStatusChange();
         
        return null;    
    }
    
    //Sent email if the ordertask is cancelled after it's approved
    public PageReference sendEmail1() 
    { 
       //Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
       List<Messaging.SingleEmailMessage> msgstoBeSent = new List<Messaging.SingleEmailMessage>();
       set <string> emailset=new set<string>();
        set<String> Afteremailsplit = new set<String>();
        set<id> userids=new set<id>();
        List<user> userlistToBeUpdated = new List<user>();
        
        list<string> emailvalues=new List<string>();
            String Id = '';
            String order = '';
            String orderTask = '';
            String ShowName='';
            String Connect2Show='';
            String ShowDates='';
            String OrderNumber= '';
            String Status ='';
            String TaskNumber='';
            String DeliveryArea='';
            String OrderAreaDescription='';
            String Item='';
            String SpecialInstructions='';
            String CustomMsgBody='';
            String CustomMsgBody1='';
            string status1;
        
        String taskId = GC_PageUtil.getParam('taskId');
        currenttTaskId=taskId;
        GC_GES_Order_Task__c task = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(taskId);
        
        
         List<GC_GES_Order_Task__c> ot = [SELECT Id,Order__r.Name,Order__r.Order_Area_Description__c,Connect2_Show_Number__c,Order__r.Show_Name__c,Name,Order_Number__c,Delivery_Location__c,Item_Number__c,Status__c,Show_Management_Field__c FROM GC_GES_Order_Task__c WHERE Id =:currenttTaskId];
           
            if(ot.size() > 0)
            {
                Id = ot[0].Id;
                order = ot[0].Order__r.Name;
                orderTask = ot[0].Name;
                Status = ot[0].Status__c;
                status1=Status;
                ShowName = ot[0].Order__r.Show_Name__c;
                Connect2Show = ot[0].Connect2_Show_Number__c; //connect 2 show
                ShowDates = '';
                OrderNumber = ot[0].Order_Number__c;
                TaskNumber = '';
                DeliveryArea = ot[0].Delivery_Location__c;
                OrderAreaDescription= ot[0].Order__r.Order_Area_Description__c;
                Item= ot[0].Item_Number__c;
                SpecialInstructions= ot[0].Show_Management_Field__c; 
               
            }
       
        //system.debug('status1++++++'+status1);
        if( status1=='Approved')
        {
          List<GC_Show_Team_Member__c> accountManagersTeam = [Select Id, Name, User__c, Connect2_Show__c, Show_Role__c , User__r.Email, UserEmail__c From GC_Show_Team_Member__c Where Connect2_Show__c =:showId and Show_Role__c = 'Account Manager']; 
            
            for(GC_Show_Team_Member__c gc:accountManagersTeam ){
               // userids.add(gc.User__c);
               emailset.add(gc.UserEmail__c ); //new change 
               
             }
         
             if(emailset.size() > 0)
             {
                  for(string s:emailset)
                  {
                      if(String.isNotBlank(s))
                      {
                          s.split(',');
                          Afteremailsplit.add(s);
                      }
                  }
               // system.debug('Afteremailsplit++++++'+Afteremailsplit);
                 for(String mail:Afteremailsplit)
                 {
                     if(!String.isBlank(mail))
                     {
                        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                        message.toAddresses = new String[] {mail};
                        message.subject='Notification of Order Cancellation' ;
                        CustomMsgBody1 = '<style>table, tr,td, {border: 1px solid black;} </style><table><tr><td>Show Name<td><td>' + ShowName+ '<td></tr><tr><td>Connect2 Show<td><td>' + Connect2Show+ '<td></tr><tr><td>Show Dates<td><td>' + ShowDates+ '<td></tr><tr><td>Order Number<td><td>' + OrderNumber + '<td></tr><tr><td>Status<td><td>' + Status+ '<td></tr><tr><td>Item Number<td><td><a href="https://ges--c.vf.force.com/apex/GC_OrderTaskView?id='+id+'&sfdc.override=1" target="_blank">' + orderTask+ '<td></tr><tr><td>Delivery Area<td><td>' + DeliveryArea+ '<td></tr><tr><td>Order Area Description<td><td>' + OrderAreaDescription+ '<td></tr><tr><td>Item<td><td>' + Item+ '<td></tr><tr><td>Special Instructions<td><td>' + SpecialInstructions+ '<td></tr></table>'; // updated the body by Sajid on 04/05/23 Ticket-1209
                        CustomMsgBody=CustomMsgBody1; 
                        message.setHtmlBody(CustomMsgBody1);
                        msgstoBeSent.add(message);
                        
                        /*
                        if (results[0].success) 
                        {
                            System.debug('The email was sent successfully.');
                        } 
                        else 
                        {
                            System.debug('The email failed to send: ' + results[0].errors[0].message);
                        }*/
                    }
                }
                GC_OrderUtils.cancelTask(task);
                Messaging.SendEmailResult[] results = Messaging.sendEmail(msgstoBeSent);
                refreshTasks();
               // OrderStatusChange();
                return null; 
            }
            
       }
        //GC_GES_Order_Task__c task = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(taskId);
        GC_OrderUtils.cancelTask(task);
        refreshTasks();
        //New Line of code dont remove
       // OrderStatusChange();
        return null;    
   }

//--- Send mail to default user ----------------
     public PageReference saveDefaultandSendEmail() {
        isModalViewDisplay = false;
        list<String> emailAddress = new List<String>();
        String Id = '';
        String order = '';
        String CustomMsgBody='';
        String CustomMsgBody1='';
        String orderTask = '';
        String SignTitle='';
        String ItemNumber='';
        String Description ='';
        String UserItem_Description ='';
        String Price ='';
        String Total = '';
        String UOM ='';
        String QuantityNum ='';
        String Status ='';
        
        
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> ();
        GC_Connect2_Show__c cs;
        String showId = ApexPages.currentPage().getParameters().get('showId'); 

        try 
        {
            cs = [SELECT Id,TeamMemberDefaultList__c FROM GC_Connect2_Show__c WHERE Id = :showId];
            cs.TeamMemberDefaultList__c = emailDefaultList;
            update cs;
        } catch (Exception e) {
           
        }
        
        
        //new Line of code
 List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
 Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();

        try {
            
            
            if(!String.isBlank(emailDefaultList))
            {
                emailAddress = emailDefaultList.split(',');
            }

            List<GC_GES_Order_Task__c> ot = [SELECT Id,Order__r.Name,Name,Sign_Title__c,Item_Number__c,Description__c,Price__c,Total__c,UOM__c,QuantityNum__c,Status__c FROM GC_GES_Order_Task__c WHERE Id = :currenttTaskId];
           
            if(ot.size() > 0)
            {
                Id = ot[0].Id;
                order = ot[0].Order__r.Name;
                orderTask = ot[0].Name;
                SignTitle = ot[0].Sign_Title__c;
                ItemNumber = ot[0].Item_Number__c;
                Description = ot[0].Description__c;
                Price = ot[0].Price__c;
                Total = String.valueof(ot[0].Total__c);
                UOM = ot[0].UOM__c;
                QuantityNum = String.valueof(ot[0].QuantityNum__c);
                Status = ot[0].Status__c;
               
            }
           
            
            //--------Getting the attachement ---------------------
             
             for (Attachment a : [select Name, Body, BodyLength from Attachment  where ParentId =:currenttTaskId]){
          
             Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                                     efa.setFileName(a.Name);
                                     efa.setBody(a.Body);
                                     fileAttachments.add(efa);
            
         }
          
           
           for(String mail:emailAddress)
            {
                if(!String.isBlank(mail))
                {
                    
                    message.toAddresses = new String[] { mail };
                    message.subject='Below Item is been cancelled after Approved' ;
                    CustomMsgBody1 = '<style>table, th, td { border: 1px solid black;}</style><b> Below Item are submitted for Approval </b></ br></ br><table><tr><th> Order Name</th><th> GES Item Number </th><th>Sign Title</th><th>Item Number</th><th>Description</th><th>Price</th><th>Total Price</th><th>Units</th><th>Quantity</th><th>Status</th></tr>'; // updated the body by Sajid on 04/05/23 Ticket-1209
                    CustomMsgBody1+='<tr><td>'+order +'</td><td><a href="https://ges--c.vf.force.com/apex/GC_OrderTaskView?id='+id+'&sfdc.override=1" target="_blank">'+ orderTask+'</a></td><td>'+SignTitle +'</td><td>'+ItemNumber +'</td><td>'+Description +'</td><td>'+Price +'</td><td>'+Total +'</td><td>'+UOM +'</td><td>'+QuantityNum +'</td><td>'+Status +'</td></tr>';
                    CustomMsgBody=CustomMsgBody1; 
                    message.setHtmlBody(CustomMsgBody1);
                    
                    //newline code 
                    
                    
                    if(fileAttachments.size()>0){
            message.setFileAttachments(fileAttachments);
            }
           message.setToAddresses(new list<string>{mail}); //Setting the address
      
                   // message.setReplyTo(mail);
           
                    //message.plainTextBody = order + orderTask;
                   // messages.add(message);
                }
                 
            }
             Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message }); //Sending mail
                    //messages.add(message);
            //Messaging.sendEmail(messages);

        } catch (Exception e) {
           
        }
       
         //OrderStatusChange();
         
        return null;    
    }

    public PageReference cancelButtonCLick() {
        try {

            isModalViewDisplay = false;
            
        } catch (Exception e) {
            
        }
        return null;
    }

     public class showTeamMemberWrapper 
    {
        public String memberName {get; set;}
        public String memberRole {get; set;}
        public String memberEmail {get; set;}
        public String memberId {get; set;}
        public boolean isDefault {get; set;}
        
        public showTeamMemberWrapper(String memName,String memRole,String memEmail,String memId,Boolean isDef) 
        {
            this.memberName = memName;
            this.memberRole = memRole;
            this.memberEmail = memEmail;
            this.memberId = memId;
            this.isDefault = isDef;
        }
    }

    public class showTeamMemberWrapperExternal implements Comparable
    {
        public String memberName {get; set;}
        public String memberRole {get; set;}
        public String memberEmail {get; set;}
        public String memberId {get; set;}
        public boolean isDefault {get; set;}
        
        public showTeamMemberWrapperExternal(String memName,String memRole,String memEmail,String memId,Boolean isDef) 
        {
            this.memberName = memName;
            this.memberRole = memRole;
            this.memberEmail = memEmail;
            this.memberId = memId;
            this.isDefault = isDef;
        }

        public Integer compareTo(Object ObjToCompare) {
            return memberName.CompareTo(((showTeamMemberWrapperExternal)ObjToCompare).memberName);
        }
    }

    public class showTeamMemberWrapperExternalVendor implements Comparable
    {
        public String memberName {get; set;}
        public String memberRole {get; set;}
        public String memberEmail {get; set;}
        public String memberId {get; set;}
        public boolean isDefault {get; set;}
        
        public showTeamMemberWrapperExternalVendor(String memName,String memRole,String memEmail,String memId,Boolean isDef) 
        {
            this.memberName = memName;
            this.memberRole = memRole;
            this.memberEmail = memEmail;
            this.memberId = memId;
            this.isDefault = isDef;
        }

        public Integer compareTo(Object ObjToCompare) {
            return memberName.CompareTo(((showTeamMemberWrapperExternalVendor)ObjToCompare).memberName);
        }
    }

    public PageReference recallTask() {
        String taskId = GC_PageUtil.getParam('taskId');
        GC_GES_Order_Task__c task = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(taskId);

        try {
            Approval.ProcessWorkItemRequest pwr = new Approval.ProcessWorkItemRequest();

            List<ProcessInstance> procins = new List<ProcessInstance>([select Id from ProcessInstance where Status = 'Pending' and TargetObjectId = :task.Id]);
            // Retrieve the process work instance id associated to the process instance
            List<ProcessInstanceWorkitem>  workitem = new List<ProcessInstanceWorkitem>([select Id from ProcessInstanceWorkitem where ProcessInstanceId = :procins[0].id]);

            if ((workitem != null) && (workitem.size() > 0)) {
                pwr.SetComments('Recalled by ' + UserInfo.getUserName());
                pwr.setWorkItemId(workitem[0].id);
                pwr.setAction('Removed');
                // Execute process request 
                Approval.ProcessResult pr = Approval.process(pwr);
            }

        } catch (Exception e) {
            GC_PageUtil.AddErrorMessage('Failed to Recall Approval Process for ' + task.Name);
        }
      
        refreshTasks();
        // OrderStatusChange();
        return null;
    }

    public void toggleAdditionalOptions() {
        if (selectedGesTask != null) {
            selectedGesTask.additionalOptions = !selectedGesTask.additionalOptions;
        }
    }

    /**
     * @description Wrapper used to store the task.
     * @return null
     **/
    public class GesTaskWrapper {
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

    /**
     * @description Wrapper used to store the task.
     * @return null
     **/
    public class VendorTaskWrapper {
        public Boolean isRevision {get; set;}
        public Boolean isSent {get; set;}
        public Boolean additionalOptions {get; set;}
        public GC_Vendor_Order_Task__c task {get; set;}
        public Integer fileCount {get; set;}
        public VendorTaskWrapper () {
            isRevision = false;
            additionalOptions = false;
            fileCount = 0;
            isSent=false;
        }
    }


    public PageReference newVendorTask() {
        selectedVendorTask = new VendorTaskWrapper();
        selectedVendorTask.task = new GC_Vendor_Order_Task__c();

        if (currentOrder != null && String.isNotBlank(currentOrder.Id)) {
            selectedVendorTask.task.Order__c = currentOrder.Id;
        }

        return null;
    }

    public PageReference cloneVendorTask() {
        String taskId = GC_PageUtil.getParam('taskId');
         GC_Vendor_Order_Task__c task = GC_VendorOrderTaskDao.getInstance().getVendorOrderTaskById(taskId);
         selectedVendorTask = new VendorTaskWrapper();
         selectedVendorTask.task = GC_PageUtil.cloneTask(task);
         
        //KN 
        //GC_PageUtil.setParam('taskId', selectedVendorTask.task.Id);
        
         if(selectedVendorTask.task.SelectAllOrderTasks__c == true)
         {   
            disableGESOT = true;
            selectAllGesOT = true;
         }
         else{
            disableGESOT = false;
            selectAllGesOT = false; 
         }
         
          String showAttr = '';
        if(selectedVendorTask.task.Service_Type__c != null)
        {
            List<GC_Show_Attribute__c> showAttributes = [select Id, Name from GC_Show_Attribute__c where Id = :selectedVendorTask.task.Service_Type__c];
            if(showAttributes.size() > 0)
            {
                showAttr = showAttributes[0].Name;
            }

            List<GC_Show_Team_Member__c> stmVen = [select Id,User__c,User__r.Name,User__r.CompanyName from GC_Show_Team_Member__c where Service_Type__c =: showAttributes[0].Id];
            //List<User> filterUsers = [select Id,Name,CompanyName from User where Profile.Name = 'GC Community Vendor' and IsActive = TRUE and ServiceType__c =:showAttr];

            if (userslist == null) {
                userslist = new List<SelectOption>();
            }

            userslist.clear();
            //SelectOption noneSelectOption = new SelectOption('', '---None---');
            //serviceTypeOptions.add(noneSelectOption);

            for(GC_Show_Team_Member__c stm1: stmVen)
            {
                if(stm1.User__r.CompanyName != null || String.isNotBlank(stm1.User__r.CompanyName))
                {
                    SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name+' - '+stm1.User__r.CompanyName);
                    userslist.Add(option);
                }
                else
                {
                    SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name);
                    userslist.Add(option);
                }
            }
        }

         
        return null;
    }

    public PageReference editVendorTask() {
        String taskId = GC_PageUtil.getParam('taskId');

        for (VendorTaskWrapper wrapper : vendorOrderTasks) {
            if (wrapper.task != null && wrapper.task.Id == taskId) {
                selectedVendorTask = wrapper;

                if(selectedVendorTask.task.SelectAllOrderTasks__c == true)
                {   
                    disableGESOT = true;
                    selectAllGesOT = true;
                }
                else{
                    disableGESOT = false;
                    selectAllGesOT = false; 
                }

                //Populate Vendors
                String showAttr = '';
                if(selectedVendorTask.task.Service_Type__c != null)
                {
                    List<GC_Show_Attribute__c> showAttributes = [select Id, Name from GC_Show_Attribute__c where Id = :selectedVendorTask.task.Service_Type__c];
                    if(showAttributes.size() > 0)
                    {
                        showAttr = showAttributes[0].Name;
                    }

                    List<GC_Show_Team_Member__c> stmVen = [select Id,User__c,User__r.Name,User__r.CompanyName from GC_Show_Team_Member__c where Service_Type__c =: showAttributes[0].Id];
                    //List<User> filterUsers = [select Id,Name,CompanyName from User where Profile.Name = 'GC Community Vendor' and IsActive = TRUE and ServiceType__c =:showAttr];

                    if (userslist == null) {
                        userslist = new List<SelectOption>();
                    }

                    userslist.clear();
                    //SelectOption noneSelectOption = new SelectOption('', '---None---');
                    //serviceTypeOptions.add(noneSelectOption);

                    for(GC_Show_Team_Member__c stm1: stmVen)
                    {
                        if(stm1.User__r.CompanyName != null || String.isNotBlank(stm1.User__r.CompanyName))
                        {
                            SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name+' - '+stm1.User__r.CompanyName);
                            userslist.Add(option);
                        }
                        else
                        {
                            SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name);
                            userslist.Add(option);
                        }
                    }
                }

                if(selectedVendorTask.task.Service_Type2__c != null)
                {
                    List<GC_Show_Attribute__c> showAttributes = [select Id, Name from GC_Show_Attribute__c where Id = :selectedVendorTask.task.Service_Type2__c];
                    if(showAttributes.size() > 0)
                    {
                        showAttr = showAttributes[0].Name;
                    }
                    //List<User> filterUsers = [select Id,Name,CompanyName from User where Profile.Name = 'GC Community Vendor' and IsActive = TRUE and ServiceType__c =:showAttr];
                    List<GC_Show_Team_Member__c> stmVen = [select Id,User__c,User__r.Name,User__r.CompanyName from GC_Show_Team_Member__c where Service_Type__c =: showAttributes[0].Id];
                    if (userslist1 == null) {
                        userslist1 = new List<SelectOption>();
                    }

                    userslist1.clear();
                    //SelectOption noneSelectOption = new SelectOption('', '---None---');
                    //serviceTypeOptions.add(noneSelectOption);

                    for(GC_Show_Team_Member__c stm1: stmVen)
                    {
                        if(stm1.User__r.CompanyName != null || String.isNotBlank(stm1.User__r.CompanyName))
                        {
                            SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name+' - '+stm1.User__r.CompanyName);
                            userslist1.Add(option);
                        }
                        else
                        {
                            SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name);
                            userslist1.Add(option);
                        }
                    }
                }

                if(selectedVendorTask.task.Service_Type3__c != null)
                {
                    List<GC_Show_Attribute__c> showAttributes = [select Id, Name from GC_Show_Attribute__c where Id = :selectedVendorTask.task.Service_Type3__c];
                    if(showAttributes.size() > 0)
                    {
                        showAttr = showAttributes[0].Name;
                    }
                    //List<User> filterUsers = [select Id,Name,CompanyName from User where Profile.Name = 'GC Community Vendor' and IsActive = TRUE and ServiceType__c =:showAttr];
                    List<GC_Show_Team_Member__c> stmVen = [select Id,User__c,User__r.Name,User__r.CompanyName from GC_Show_Team_Member__c where Service_Type__c =: showAttributes[0].Id];

                    if (userslist2 == null) {
                        userslist2 = new List<SelectOption>();
                    }

                    userslist2.clear();
                    //SelectOption noneSelectOption = new SelectOption('', '---None---');
                    //serviceTypeOptions.add(noneSelectOption);

                    for(GC_Show_Team_Member__c stm1: stmVen)
                    {
                        if(stm1.User__r.CompanyName != null || String.isNotBlank(stm1.User__r.CompanyName))
                        {
                            SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name+' - '+stm1.User__r.CompanyName);
                            userslist2.Add(option);
                        }
                        else
                        {
                            SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name);
                            userslist2.Add(option);
                        }
                    }
                }

                if(selectedVendorTask.task.Service_Type4__c != null)
                {
                    List<GC_Show_Attribute__c> showAttributes = [select Id, Name from GC_Show_Attribute__c where Id = :selectedVendorTask.task.Service_Type4__c];
                    if(showAttributes.size() > 0)
                    {
                        showAttr = showAttributes[0].Name;
                    }
                    //List<User> filterUsers = [select Id,Name,CompanyName from User where Profile.Name = 'GC Community Vendor' and IsActive = TRUE and ServiceType__c =:showAttr];
                    List<GC_Show_Team_Member__c> stmVen = [select Id,User__c,User__r.Name,User__r.CompanyName from GC_Show_Team_Member__c where Service_Type__c =: showAttributes[0].Id];

                    if (userslist3 == null) {
                        userslist3 = new List<SelectOption>();
                    }

                    userslist3.clear();
                    //SelectOption noneSelectOption = new SelectOption('', '---None---');
                    //serviceTypeOptions.add(noneSelectOption);

                    for(GC_Show_Team_Member__c stm1: stmVen)
                    {
                        if(stm1.User__r.CompanyName != null || String.isNotBlank(stm1.User__r.CompanyName))
                        {
                            SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name+' - '+stm1.User__r.CompanyName);
                            userslist3.Add(option);
                        }
                        else
                        {
                            SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name);
                            userslist3.Add(option);
                        }
                    }
                }

                if(selectedVendorTask.task.Service_Type5__c != null)
                {
                    List<GC_Show_Attribute__c> showAttributes = [select Id, Name from GC_Show_Attribute__c where Id = :selectedVendorTask.task.Service_Type5__c];
                    if(showAttributes.size() > 0)
                    {
                        showAttr = showAttributes[0].Name;
                    }
                    
                    //List<User> filterUsers = [select Id,Name,CompanyName from User where Profile.Name = 'GC Community Vendor' and IsActive = TRUE and ServiceType__c =:showAttr];

                    List<GC_Show_Team_Member__c> stmVen = [select Id,User__c,User__r.Name,User__r.CompanyName from GC_Show_Team_Member__c where Service_Type__c =: showAttributes[0].Id];

                    if (userslist4 == null) {
                        userslist4 = new List<SelectOption>();
                    }

                    userslist4.clear();
                    //SelectOption noneSelectOption = new SelectOption('', '---None---');
                    //serviceTypeOptions.add(noneSelectOption);

                    for(GC_Show_Team_Member__c stm1: stmVen)
                    {
                        if(stm1.User__r.CompanyName != null || String.isNotBlank(stm1.User__r.CompanyName))
                        {
                            SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name+' - '+stm1.User__r.CompanyName);
                            userslist4.Add(option);
                        }
                        else
                        {
                            SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name);
                            userslist4.Add(option);
                        }
                    }
                }
                break;
            }
        }

        return null;
    }

    public void deleteVendorTask() {
        String taskId = GC_PageUtil.getParam('taskId');
        VendorTaskWrapper taskToDelete = null;

        for (VendorTaskWrapper wrapper : vendorOrderTasks) {
            if (wrapper.task != null && String.isNotBlank(wrapper.task.Id) && wrapper.task.Id == taskId) {
                taskToDelete = wrapper;
                break;
            }
        }

        if (taskToDelete != null) {
            if (String.isNotBlank(taskToDelete.task.Id)) {
               try{
                    delete taskToDelete.task;
                }catch(exception e){
                    GC_PageUtil.AddErrorMessage('The task can not be deleted! '+e.getMessage());
                }
            }

            refreshTasks();
        }

       // return null;
    }

    public PageReference sendVendorTask() {
        String taskId = GC_PageUtil.getParam('taskId');
        VendorTaskWrapper taskToSend = null;
        system.debug('taskId=='+taskId);
        system.debug('taskToSend=='+taskToSend);
        for (VendorTaskWrapper wrapper : vendorOrderTasks) {
            if (wrapper.task != null && String.isNotBlank(wrapper.task.Id) && wrapper.task.Id == taskId) {
                taskToSend = wrapper;
                break;
            }
        }
        system.debug('taskToSend.task.Name=='+taskToSend.task.Name);

        if (taskToSend != null) {
            if (String.isNotBlank(taskToSend.task.Id)) {
                List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();

                if (taskToSend.task.Vendor__c == null) {
                    GC_PageUtil.AddErrorMessage('Please add vendor for ' + taskToSend.task.Name + '.');
                    return null;
                }

                if (taskToSend.task.Vendor__c != null) {
                    emailMessages.add(GC_OrderUtils.generateVendorEmail(taskToSend.task, taskToSend.task.Vendor__c,currentShow.Name+ ' '+currentShow.Show_Name__c,taskToSend.task.Service_Type__r.Name));
                }

                if (taskToSend.task.Vendor2__c != null) {
                    emailMessages.add(GC_OrderUtils.generateVendorEmail(taskToSend.task, taskToSend.task.Vendor2__c,currentShow.Name+ ' '+currentShow.Show_Name__c,taskToSend.task.Service_Type2__r.Name));
                }

                if (taskToSend.task.Vendor3__c != null) {
                    emailMessages.add(GC_OrderUtils.generateVendorEmail(taskToSend.task, taskToSend.task.Vendor3__c,currentShow.Name+ ' '+currentShow.Show_Name__c,taskToSend.task.Service_Type3__r.Name));
                }

                if (taskToSend.task.Vendor4__c != null) {
                    emailMessages.add(GC_OrderUtils.generateVendorEmail(taskToSend.task, taskToSend.task.Vendor4__c,currentShow.Name+ ' '+currentShow.Show_Name__c,taskToSend.task.Service_Type4__r.Name));
                }

                if (taskToSend.task.Vendor5__c != null) {
                    emailMessages.add(GC_OrderUtils.generateVendorEmail(taskToSend.task, taskToSend.task.Vendor5__c,currentShow.Name+ ' '+currentShow.Show_Name__c,taskToSend.task.Service_Type5__r.Name));
                }

                //set allOrNone to false to allow non-error messages to be sent even if some fail
                Messaging.sendEmail(emailMessages, false);
                taskToSend.task.Status__c = 'Sent';
                taskToSend.task.Submitted_Date__c = Date.today();
                update taskToSend.task;
                taskToSend.isSent=true;
                taskId ='';
                //refreshTasks();
                
                PageReference pr ;
                if(IsCommunity){
                    pr = new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_OrderView');

                    for (String key : ApexPages.currentPage().getParameters().keySet()) {
                        if (key.containsIgnoreCase('orderId') || key.containsIgnoreCase('showId')) {
                            pr.getParameters().put(key, ApexPages.currentPage().getParameters().get(key));
                        }
                    }
                }else{
                    pr = new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_OrderView');
                    for (String key : ApexPages.currentPage().getParameters().keySet()) {
                        if (key.containsIgnoreCase('Id') || key.containsIgnoreCase('id')) {
                            pr.getParameters().put(key, ApexPages.currentPage().getParameters().get(key));
                        }
                    }
                }
                pr.setRedirect(true);
                return pr;
                
            }
            
            
            
        }
        return null;   
    }

    public PageReference saveVendorTask() {
        // Perform the Actual Update and refresh the list.
        if (selectedVendorTask != null && String.isNotBlank(selectedVendorTask.task.Id)) {
            if (GC_OrderUtils.validateVendorTask(selectedVendorTask.task)) {
            if(selectAllGesOT!=null){
                selectedVendorTask.task.SelectAllOrderTasks__c = selectAllGesOT;
                }
                update selectedVendorTask.task; 
                refreshTasks();
                selectedVendorTask = null;
                isModalViewDisplay = false;
            }
        } else if (selectedVendorTask != null && String.isBlank(selectedVendorTask.task.Id)) {
            if (GC_OrderUtils.validateVendorTask(selectedVendorTask.task)) {
                selectedVendorTask.task.Order__c = currentOrder.Id;
                if(selectAllGesOT!=null){   //It contains null value,It gets the value only when user edit the vendor
                selectedVendorTask.task.SelectAllOrderTasks__c = selectAllGesOT;
                }
                insert selectedVendorTask.task;
                selectedVendorTask = null;
                refreshTasks();
               isModalViewDisplay = false;
            }
        }

        return null;
    }

    public PageReference cancelEditVendorTask() {
        selectedVendorTask = null;
        refreshTasks();
        return null;
    }


    public PageReference exportToCSV() {
        String orderId = GC_PageUtil.getParam('orderId');
        //String isCommunity = GC_PageUtil.getParam('isCommunity');
        Boolean isCommunity = ApexPages.currentPage().getURL().contains('Community');
        return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_ExportToCSV?orderIds=' + orderId + '&isCommunity' + isCommunity);
    }

     public PageReference otDropDownReadOnly() {
       // system.debug('selectAllGesOT++++++'+selectAllGesOT);
        if(selectAllGesOT == true)
        {   
            disableGESOT = true;
            selectedVendorTask.task.GESOrderTask1__c = null;
            selectedVendorTask.task.GESOrderTask2__c = null;
            selectedVendorTask.task.GESOrderTask3__c = null;
            selectedVendorTask.task.GESOrderTask4__c = null;
            selectedVendorTask.task.GESOrderTask5__c = null;
        }
        else{
            disableGESOT = false; 
        }
       // system.debug('disableGESOT++++++'+disableGESOT); 
        return null;
    }
    
//SAL-586 -- start @@author soniya gopu
    
    public List<ContentVersion> listFiles {get; set;}
    public ContentVersion fileToUpload { get; set; }
    public GC_Vendor_Order_Task__c uploadToThisVOT{get;set;}
    public void retrieveFiles() {
        orderTaskId = GC_PageUtil.getParam('taskId');
        fileToUpload = new ContentVersion();
        //uploadToThisVOT= GC_VendorOrderTaskDao.getInstance().getVendorOrderTaskById(orderTaskId);
        //upsert uploadToThisVOT;
        //uploadToThisVOT = new GC_Vendor_Order_Task__c();
        //uploadToThisVOT.Id = orderTaskId;
         for (VendorTaskWrapper wrapper : vendorOrderTasks) {
            if (wrapper.task != null && wrapper.task.Id == orderTaskId) {
                //selectedVendorTask = wrapper;
                wrapper.isSent=true;
            }else{
                wrapper.isSent=false;
            }
            
        }
    }
    public PageReference doUpload(){
        ContentDocumentLink contentlink = new ContentDocumentLink();
        try{
            insert fileToUpload;
            ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :fileToUpload.Id LIMIT 1];
            
            
            contentlink.LinkedEntityId = orderTaskId;
            contentlink.contentdocumentid = contentVersion_2.contentdocumentid;
            contentlink.ShareType = 'V';
            insert contentlink; 
            GC_PageUtil.AddConfirmMessage('File is uploaded successfully!');
            String orderId = ApexPages.currentPage().getParameters().get('orderId');
            //orderId = ApexPages.currentPage().getParameters().get('orderId');
            //return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_OrderView?OrderId=' + orderId +'&showId='+ showId);
            PageReference pr = new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_OrderView');

            for (String key : ApexPages.currentPage().getParameters().keySet()) {
                if (key.containsIgnoreCase('orderId') || key.containsIgnoreCase('showId')) {
                    pr.getParameters().put(key, ApexPages.currentPage().getParameters().get(key));
                }
            }
            pr.setRedirect(true);
            return pr;
            
        }catch (exception e){
            GC_PageUtil.AddErrorMessage(e.getMessage());
            
        }
        fileToUpload=null;
        contentlink=null;
        return null;

    }
    
    //File Upload for Classic
    public PageReference doUploadFile() {
        ContentDocumentLink contentlink = new ContentDocumentLink();
        try{
            insert fileToUpload;
            ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :fileToUpload.Id LIMIT 1];
            
            
            contentlink.LinkedEntityId = orderTaskId;
            contentlink.contentdocumentid = contentVersion_2.contentdocumentid;
            contentlink.ShareType = 'V';
            insert contentlink; 
            GC_PageUtil.AddConfirmMessage('File is uploaded successfully!');
            //String orderId = ApexPages.currentPage().getParameters().get('orderId');
            PageReference pr = new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_OrderView');

            for (String key : ApexPages.currentPage().getParameters().keySet()) {
                if (key.containsIgnoreCase('Id') || key.containsIgnoreCase('id')) {
                    pr.getParameters().put(key, ApexPages.currentPage().getParameters().get(key));
                }
            }
            pr.setRedirect(true);
            return pr;
            
        }catch (exception e){
            GC_PageUtil.AddErrorMessage(e.getMessage());
            
        }
        fileToUpload=null;
        contentlink=null;
        return null;

    }
  
    public PageReference SelectTaskToSubmit() {
        String showId = ApexPages.currentPage().getParameters().get('showId');
        String orderId = ApexPages.currentPage().getParameters().get('orderId');
        return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_TaskSelectionPage?Id=' + orderId + '&isCommunity=true');
    } 

// SAL-586 - finish    

    public void setShowAttributeFlag(){
        GC_Connect2_Show__c parentShow = [select id,(SELECT Id, Name from Show_Attributes__r) FROM  GC_Connect2_Show__c where id = :currentOrder.Connect2_Show__c];
        //List<GC_Show_Attribute__c> showAttributes 
        /*if(showAttributes !=null && showAttributes.size()>0){
            showAttrFlag=true;
        }else{
            showAttrFlag=false;
        }*/
        if(parentShow.Show_Attributes__r !=null && parentShow.Show_Attributes__r.size()>0){
            showAttrFlag=true;
        }else{
            showAttrFlag=false;
        }
        
    }
    
    //SAL-421 rksinha
    public void submitToGPM() {
        PageReference tempPage = ApexPages.currentPage();
        singleTaskId = ApexPages.currentPage().getParameters().get('singleTaskId');
        List<GC_GES_Order_Task__c> taskToSubmitToCore = new List<GC_GES_Order_Task__c>();
        for (GC_GES_Order_Task__c orderTask : GesOrderMapping.values()) {
            if (orderTask.Id == singleTaskId) {
                 if(orderTask.GPM_Approver_1__c != null || orderTask.GPM_Approver_2__c != null || orderTask.GPM_Approver_3__c != null) {
                     taskToSubmitToCore.add(orderTask);
                 }
            }
                    
         }
        if(taskToSubmitToCore.size() > 0) {
            GC_ApprovalUtils.submitForGPMApproval(taskToSubmitToCore[0], 'GES_GO_AM_to_GPM_Approval_Process');
        }
        refreshTasks();
        OrderStatusChange();
    }
    
    public void insertCoreLogs(){
        //system.debug('resultLogsfinal==='+resultLogs);
        system.debug('resultLogsfinal==='+resultLogs.size());
        try{
            upsert resultLogs;
        }catch(exception e){
            GC_PageUtil.AddErrorMessage(e.getMessage());
        }
        
    }
    
    public void submitToAMReview() {
        String tempTaskId = ApexPages.currentPage().getParameters().get('singleTaskId');
        GC_GES_Order_Task__c task = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(tempTaskId);
        PageReference pr = GC_OrderUtils.submitTask(task);
        refreshTasks();
        OrderStatusChange();
    }
    
    public PageReference validateSessionID() {
        GC_CoreUtils.validateSession(sessionObject);
        return null;
    }
     public pageReference clearDiscountValues(){
        selectedGesTask.task.Discount_Reason_Code__c = null;
        selectedGesTask.task.Discount_Reason_Text__c = null;
        return null;
    }
    
}