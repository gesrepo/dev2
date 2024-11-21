/**
* @author Ethos Solutions - www.ethos.com
* @description Controller for GES Order Task edit page
* 2016-04-13 : Original Version
**/
public with sharing class GC_GESOrderTaskEditController extends GC_BaseViewController {
    private final String DATE_TIME_FORMAT = 'MM/dd/YYYY hh:mm a';
    
    public GC_GES_Order_Task__c got {get; set;}
    
    public GC_CoreQuery coreApi {get; set;}
    
    public List<SelectOption> venueLocations { get; private set; }
    public List<SelectOption> materialAttributes { get; private set; }
    public List<SelectOption> departmentAttributes { get; private set; }
    
    // New for GPM to link a Sign Order to an existing sign order.
    public List<SelectOption> designElementTasks { get; private set; }
    
    public GC_Order__c referenceOrder {get; set;}
    
    public Boolean isActive {get; set;} // determines if this item is active.
    public Boolean isRevision {get; set;} // determines if this items is a revision of a previous item.
    
    //---------- Properties from community controller
    public String orderId {get; set;}
    public String showId {get; set;}
    public Boolean cloneFlag {get; set;}
    public Boolean hasCloned {get; set;}
    public Boolean canCancel {get; set;}
    public String isRevised {get; set;}
    public GC_Connect2_Show__c show {get; set;}
    
    // Links to a design element task indicating a parent gem structure.
    public List<SelectOption> activeGemStructureTasks { get; private set; }
    //SAL-636
    public GC_Task_Field_Manager__c taskFieldManager {get; set;}
    
    public GC_GESOrderTaskEditController() {
        hasCloned = false;
        try {
            
            IsSalesforce = GC_PageUtil.IsLightningUI();
            IsLightning = GC_PageUtil.IsLightningUI();
            IsCommunity = !GC_PageUtil.IsLightningUI();
            
            Id gotId;
            
            if (ApexPages.currentPage().getParameters().get('isClone') == '1') {
                gotId = ApexPages.currentPage().getParameters().get('originalGotId');
                cloneFlag = true;
            }
            else {
                gotId = ApexPages.currentPage().getParameters().get('gotId');
                cloneFlag = false;
            }
            
            orderId = ApexPages.currentPage().getParameters().get('orderId');
            showId = ApexPages.currentPage().getParameters().get('showId');
            isRevised = ApexPages.currentPage().getParameters().get('isRevised');
            referenceOrder = GC_OrderDao.getInstance().getOrderById(orderId);
            got = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(gotId);
            
            if (got != null) {
                showId = got.Order__r.Connect2_Show__c;
                show = GC_Connect2ShowDao.getInstance().getConnect2ShowById(showId);
            }
            else {
                got = new GC_GES_Order_Task__c();
                got.Order__c = referenceOrder.Id;
            }
            
            coreApi = new GC_CoreQuery();
            
            coreApi.showProjectNumber = (referenceOrder != null && String.isNotBlank(referenceOrder.Connect2_Show__r.Job_Number__c)) ?
                referenceOrder.Connect2_Show__r.Job_Number__c :
            got.Order__r.Connect2_Show__r.Job_Number__c;
            
            coreApi.selectedBooth = (referenceOrder != null) ? String.valueof(referenceOrder.Booth_Area_ID__c) : got.Formula_Booth_Area_ID__c;
            coreApi.selectedBoothName =  (referenceOrder != null) ? String.valueof(referenceOrder.Booth_Area__c) : got.Formula_Booth_Area__c;
            coreApi.isProjectValid = String.isNotBlank(coreApi.showProjectNumber);
            coreApi.setCurrentTask(got);
            
            canCancel = isRevised != '1';
            
            LookupShowAttributes();
        }
        catch (Exception e) {
            GC_PageUtil.AddErrorMessage(e.getLineNumber() + ' ' + e.getMessage());
            GC_PageUtil.AddErrorMessage(e.getStackTraceString());
        }
        try{
            taskFieldManager = [SELECT id, name, Background__c,Booth_Area_Discount__c,Budget_Code__c,Client_Layout_Notes__c,Completion_Date_Time__c,Connect2_Show__c,Copy_Placement__c,Default_Completion_Date_Time__c,Default_Installation_Delivery_Date_Time__c,Default_Removal_Date_Time__c,Delivery_Area__c,File_Reference_Link_Folder__c,Installation_Delivery_Date_Time__c,Installation_Method__c,Onsite_Contact_Person__c,Onsite_Contact_Person_Number__c,Outdoors__c,Price__c,Removal_Date_Time__c,Save_Signs__c,Sign_Copy__c,Sign_Title__c,Sign_Type__c,Sign_Type_Other__c,Single_Double_Sided__c,Special_Instructions_Client_Remarks__c,User__c,User_Item_Description__c FROM GC_Task_Field_Manager__c WHERE Connect2_Show__c=:got.Order__r.Connect2_Show__c LIMIT 1];
        }
        catch(exception e){
            taskFieldManager= new GC_Task_Field_Manager__c();
            taskFieldManager.Connect2_Show__c= got.Order__r.Connect2_Show__c;
        }
    }
    
    public GC_GESOrderTaskEditController(ApexPages.StandardController stdController) {
        hasCloned = false;
        
        IsSalesforce = true;
        
        String taskId = stdController.getId();
        if (ApexPages.currentPage().getParameters().get('isClone') == '1') {
            cloneFlag = true;
        }
        else {
            cloneFlag = false;
        }
        
        if (String.isNotBlank(taskId)) {
            if (cloneFlag) {
                hasCloned = true;
                got = GC_PageUtil.cloneTask(GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(taskId));
                referenceOrder = GC_OrderDao.getInstance().getOrderById(got.Order__c);
            }
            else {
                got = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(taskId);
            }
        }
        else {
            got = new GC_GES_Order_Task__c();
            for (String param : ApexPages.CurrentPage().getParameters().keySet()) {
                if (param.contains('_lkid')) {
                    String orderId = ApexPages.CurrentPage().getParameters().get(param);
                    referenceOrder = GC_OrderDao.getInstance().getOrderById(orderId);
                    got.Order__c = referenceOrder.Id;
                    break;
                }
            }
        }
        
        coreApi = new GC_CoreQuery();
        coreApi.showProjectNumber = (referenceOrder != null && String.isNotBlank(referenceOrder.Connect2_Show__r.Job_Number__c)) ?
            referenceOrder.Connect2_Show__r.Job_Number__c :
        got.Order__r.Connect2_Show__r.Job_Number__c;
        
        coreApi.selectedBooth = (referenceOrder != null) ? String.valueof(referenceOrder.Booth_Area_ID__c) : got.Formula_Booth_Area_ID__c;
        coreApi.selectedBoothName =  (referenceOrder != null) ? String.valueof(referenceOrder.Booth_Area__c) : got.Formula_Booth_Area__c;
        coreApi.isProjectValid = String.isNotBlank(coreApi.showProjectNumber);
        coreApi.setCurrentTask(got);
        
        LookupShowAttributes();
        isActive = String.isNotBlank(got.Status__c) && got.Status__c == 'Active';
        if (isActive) {
            GC_PageUtil.AddErrorMessage('The task can not be edited while it is active.  Please revise and resubmit.');
        }
        isRevision = String.isNotBlank(got.Previous_Revision__c);
        
        
        try{
            taskFieldManager = [SELECT id, name, Background__c,Booth_Area_Discount__c,Budget_Code__c,Client_Layout_Notes__c,Completion_Date_Time__c,Connect2_Show__c,Copy_Placement__c,Default_Completion_Date_Time__c,Default_Installation_Delivery_Date_Time__c,Default_Removal_Date_Time__c,Delivery_Area__c,File_Reference_Link_Folder__c,Installation_Delivery_Date_Time__c,Installation_Method__c,Onsite_Contact_Person__c,Onsite_Contact_Person_Number__c,Outdoors__c,Price__c,Removal_Date_Time__c,Save_Signs__c,Sign_Copy__c,Sign_Title__c,Sign_Type__c,Sign_Type_Other__c,Single_Double_Sided__c,Special_Instructions_Client_Remarks__c,User__c,User_Item_Description__c FROM GC_Task_Field_Manager__c WHERE Connect2_Show__c=:showId LIMIT 1];
        }catch(exception e){
            taskFieldManager= new GC_Task_Field_Manager__c();
        }
        
        
    }
    
    ///**
    // * @description Load Action to determine if we display the lightning view page vs. the classic salesforce view page.
    // **/
    public PageReference loadAction() {
        return null;
    }
    
    public PageReference orderChanged() {
        if (String.isNotBlank(got.Order__c)) {
            referenceOrder = GC_OrderDao.getInstance().getOrderById(got.Order__c);
            coreApi.showProjectNumber = referenceOrder.Connect2_Show__r.Job_Number__c;
            coreApi.isProjectValid = String.isNotBlank(coreApi.showProjectNumber);
            coreApi.selectedBooth = String.valueof(referenceOrder.Booth_Area_ID__c);
            coreApi.selectedBoothName = String.valueof(referenceOrder.Booth_Area__c);
            return coreApi.obtainProducts();
        }
        else {
            return null;
        }
    }
    
    public void LookupShowAttributes() {
        venueLocations = new List<SelectOption>();
        materialAttributes = new List<SelectOption>();
        departmentAttributes = new List<SelectOption>();
        String showId = got.Order__r.Connect2_Show__c;
        String orderId;
        // we may be on a new page, need to find the Show to obtain attributes.
        if (String.isBlank(showId) && referenceOrder != null) {
            showId = referenceOrder.Connect2_Show__c;
            orderId = referenceOrder.Id;
        }
        if (String.isBlank(orderId)) {
            orderId = got.Order__r.Id;
        }
        GC_OrderUtils.lookupShowAttributes(showId, materialAttributes, venueLocations, departmentAttributes);
        
        if (designElementTasks == null) {
            designElementTasks = new List<SelectOption>();
        }
        else {
            designElementTasks.clear();
        }
        
        SelectOption noneSelectOption = new SelectOption('', '---None---');
        designElementTasks.add(noneSelectOption);
        //SAL-1293 - updated where clause - 12/20/23 - Sajid
        //List<GC_Design_Element__c> tasks = [select Id, Name, Design_Element__c, Deliverable__c, Task_Description__c from GC_Design_Element__c where Design_Request_Form__r.Connect2_Show__c = :showId order by Name];
        List<GC_Design_Element__c> tasks = [select Id, Name, Design_Element__c, Deliverable__c, Task_Description__c from GC_Design_Element__c where Connect2_Show__c = :showId order by Name];
        
        for(GC_Design_Element__c task: tasks) {
            String taskDesc = task.Name + ' - ' + task.Design_Element__c + ' - ' + task.Deliverable__c + ' - ' + task.Task_Description__c;
            designElementTasks.add(new SelectOption(task.Id, taskDesc));
        }
        
        List<GC_GES_Order_Task__c> gesTasks = GC_GESOrderTaskDao.getInstance().getByGesOrderIdAndExcludeStatus(orderId, 'Archived');
        
        // Build up a list of GEM Structures to Link to.
        activeGemStructureTasks = new List<SelectOption>();
        activeGemStructureTasks.add(new SelectOption('','----None----'));
        for (GC_GES_Order_Task__c gesOrderTask : gesTasks) {
            if (gesOrderTask.Status__c == 'Active' && String.isNotBlank(gesOrderTask.Description__c) && gesOrderTask.Description__c.startsWith('GEM Structure with')) {
                String taskKey = gesOrderTask.Name + '-' + gesOrderTask.Item_Number__c + '-' + gesOrderTask.Description__c;
                activeGemStructureTasks.add(new SelectOption(String.valueOf(gesOrderTask.Id), taskKey));
            }
        }
    }
    
    public PageReference sessionLoad() {
        GC_Core_Session__c session;
        try {
            session = GC_CoreUtils.getSessionID();
            coreApi.coreSessionId = session.Core_Application_Session_ID__c;
        }
        catch (Exception e) {
            System.debug('SESSION ' + session);
            GC_PageUtil.AddErrorMessage(e.getMessage());
        }
        return null;
    }
    
    public PageReference cancelAction() {           
        if (IsCommunity) {
            String gotId = ApexPages.currentPage().getParameters().get('gotId');
            String showId = ApexPages.currentPage().getParameters().get('showId');
            String orderId = ApexPages.currentPage().getParameters().get('orderId');
            String isClone = ApexPages.currentPage().getParameters().get('isClone');
            String originalGotId = ApexPages.currentPage().getParameters().get('originalGotId');
            
            
            if (String.isNotBlank(isClone) && String.isNotBlank(orderId) && String.isNotBlank(originalGotId)) {
                got = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(got.Id);
                PageReference pr = new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_gotView');
                pr.getParameters().put('showId', showId);
                pr.getParameters().put('orderId', orderId);
                pr.getParameters().put('gotId', originalGotId);
                return pr;
            }
            if (String.isNotBlank(gotId) && String.isNotBlank(showId) && String.isNotBlank(orderId)) {
                return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_gotView?gotId=' + gotId + '&showId=' + showId + '&orderId=' + orderId);
            }
            if (String.isNotBlank(gotId)) {
                return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_gotView?gotId=' + gotId + '&orderId=' + orderId);
            }
            
            if (String.isNotBlank(showId) && String.isNotBlank(orderId)) {
                return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_OrderView?showId=' + showId + '&orderId=' + orderId);
            }
            else {
                return null;
            }
        }
        else {
            String gotId = ApexPages.currentPage().getParameters().get('id');
            // This Handles the New Action
            if (ApexPages.CurrentPage().getParameters().containsKey('retURL')) {
                return new PageReference(ApexPages.CurrentPage().getParameters().get('retURL'));
            }
            
            // This handles all Other Actions
            PageReference viewPage = Page.GC_OrderTaskView;
            viewPage.getParameters().put('id', gotId);
            system.debug('viewPage==='+viewPage);
            return viewPage;
        }
        
    }
    
    public Boolean saveTask() {
        if (String.isBlank(got.Item_Number__c) && got.Previous_Revision__c == null) {
            GC_PageUtil.AddErrorMessage('Must select an item from the drop down.');
            return false;
        }
        
        if (got.Item_Template__c != null && got.Item_Template__c.contains('Carpet') && got.Carpet_Length__c != null && got.Carpet_Width__c != null && got.UOM__c == 'SF' && got.UOM__c != 'EA') {
            got.QuantityNum__c = Integer.valueof(got.Carpet_Length__c * got.Carpet_Width__c);
        }
                
        if (got.Item_Number__c == '900301')  {
            got.Item_Number__c = '900367';
        }
        if (got.Item_Number__c == '600533')  {
            got.Item_Number__c = '600510';
        }
        if (got.Item_Number__c == '600534')  {
            got.Item_Number__c = '600520';
        }
        if (got.Item_Number__c == '900710')  {
            got.Item_Number__c = '900079';
        }
        if (got.Item_Number__c == '900606')  {
            got.Item_Number__c = '900241';
        }
        
        if (got.Item_Number__c == '900241'){
            got.UOM__c = 'SF';
        }
       
        
        
        if (!GC_PageUtil.validateGesTask(got)) {
            return false;
        }
        
        GC_GES_Order_Task__c updatedTask;
        
        if (cloneFlag && !hasCloned) {
            updatedTask = GC_PageUtil.cloneTask(got);
        }
        else {
            updatedTask = got;
        }
        
        try {
            upsert updatedTask;
        }
        catch (Exception e) {
            GC_PageUtil.AddErrorMessage('Error Saving the Record. ' + e.getMessage());
            return false;
        }
        
        got = updatedTask;
        
        return true;
    }
    
    public PageReference saveAction() {
        Boolean saveSuccess = saveTask();
        
        if (!saveSuccess) {
            return null;
        }
        
        if (IsCommunity) {
            if (got != null && String.isNotBlank(orderId) && String.isNotBlank(showId)) {
                return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_gotView?gotId=' + got.Id + '&showId=' + showId + '&orderId=' + orderId);
            }
            if (String.isNotBlank(orderId) && String.isNotBlank(showId)) {
                return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_OrderView?orderId=' + orderId + '&showId=' + showId);
            }
            return null;
        }
        else {
            PageReference viewPage = new PageReference('/' + got.Id);
            return viewPage;
        }
        
    }
    
    /**
* @description Submits the task for the proper approvals. (community only)
* @return redirect to the respective community view pages.
**/
    public PageReference submitForApproval() {
        
        Boolean saveSuccess = saveTask();
        
        if (!saveSuccess) {
            return null;
        }
        
        got = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(got.Id);
        Boolean submitStatus = GC_ApprovalUtils.submitForApproval(got);
        
        if (submitStatus) {
            if (String.isNotBlank(got.Id) && String.isNotBlank(orderId) && String.isNotBlank(showId)) {
                return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_gotView?gotId=' + got.Id + '&showId=' + showId + '&orderId=' + orderId);
            }
            if (String.isNotBlank(showId) && String.isNotBlank(orderId)) {
                return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_OrderView?showId=' + showId + '&orderId=' + orderId);
            }
            else {
                return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_OrderView');
            }
        }
        else {
            return null;
        }
    }
    
    public PageReference saveAndApproveAction() {
        if (got.Item_Template__c != null && got.Item_Template__c.contains('Carpet') && got.Carpet_Length__c != null && got.Carpet_Width__c != null && got.UOM__c == 'SF') {
            got.QuantityNum__c = Integer.valueof(got.Carpet_Length__c * got.Carpet_Width__c);
        }
        if (GC_ApprovalUtils.isUnderApproval(got.Id)) {
            if (GC_ApprovalUtils.approveTask(got)) {
                PageReference approveSuccessPR = new PageReference('/' + got.Id);
                approveSuccessPR.getParameters().put('printMessage', 'msg');
                return approveSuccessPR;
            }
            else {
                return null;
            }
        }
        if (!GC_PageUtil.validateGesTask(got)) {
            return null;
        }
        
        try {
            got.Status__c = 'Approved';
            upsert got;
        }
        catch (Exception e) {
            GC_PageUtil.AddErrorMessage('Error Saving the Record. ' + e.getMessage());
            return null;
        }
        PageReference viewPage = new PageReference('/' + got.Id);
        viewPage.getParameters().put('printMessage', 'msg');
        return viewPage;
    }
    
    public PageReference saveAndApproveAndNewAction() {
        PageReference result;
        
        result = saveAndApproveAction();
        
        if (result == null) {
            return null;
        }
        else {
            String orderId = got.Order__c;
            String retURL = 'apex/GC_OrderView?id=' + orderId;
            PageReference pr = new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_OrderTaskEdit?orderId_lkid=' + orderId + '&retURL=' + retURL);
            pr.setRedirect(true);
            
            return pr;
        }
    }
    
    // FIXME: Switch these to labels
    
    public String getSaveTitle() {
        return 'Saves the current task. Returns to the task view page.';
    }
    public String getSaveAndSubmitTitle() {
        return 'Saves the current task, performs required validation checks and submits to the account manager on the show for approval.';
    }
    
    public String getSaveAndApproveTitle() {
        return 'Saves the current task, performs required validation checks and sets the status to Approved.';
    }
    
    public String getCancelTitle() {
        return 'Cancels the current page edit and returns back to the Task view page.';
    }
    
    public String getRemovalDateTimeFormatted() {
        return null;
    }
    
    public pageReference clearDiscountValues(){
        got.Discount_Reason_Code__c = null;
        got.Discount_Reason_Text__c = null;
        return null;
    }
    
}