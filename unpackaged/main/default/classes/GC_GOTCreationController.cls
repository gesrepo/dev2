/**
    * @author rahul sinha For SLK Software Services
    * @description Controller for Order view page
    * 02-03-2018 : Original Version
    **/
    public with sharing class GC_GOTCreationController extends GC_BaseViewController {
        public GC_OrderViewController.GesTaskWrapper selectedGesTask{get; set;}
        public GC_Order__c currentOrder{get; set;}
        public GC_CoreQuery coreApi {get; set;}
        public CORE_V1MockImpl Core {get; set;}
        public GC_Connect2_Show__c currentShow;//{get; set;}
        public String orderId ;//{get; set;}
        public String showId ;//{get; set;}
        public GC_GES_Order_Task__c currentRevision {get; set;}
        public List<SelectOption> activeGemStructureTasks { get; private set; }
        public List<SelectOption> designElementTasks { get; private set; }
        public List<SelectOption> materialOptions { get; set; }
        public List<SelectOption> venueLocations { get; set; }
        public List<SelectOption> departmentAttributes { get; set; }
        public List<SelectOption> serviceTypes { get; set; }
        public Boolean isCommunity;//{get; set;}
        public Integer runOnce{get; set;}
        public String isClone;// {get; set;}
        public String isEdit ;//{get; set;}
        public GC_Task_Field_Manager__c taskFieldManager {get; set;} //SAL-636
        public String taskId ;
        public String isTaskPage ;
        public GC_GOTCreationController(ApexPages.StandardController stdController) {
            runOnce=0;
            orderId=  ApexPages.currentPage().getParameters().get('orderId');
            showId=  ApexPages.currentPage().getParameters().get('showId');
            isClone=  ApexPages.currentPage().getParameters().get('isClone');
            isEdit=  ApexPages.currentPage().getParameters().get('isEdit');
            taskId=  ApexPages.currentPage().getParameters().get('taskId');
            isTaskPage=  ApexPages.currentPage().getParameters().get('isTaskPage');
            currentOrder = GC_OrderDao.getInstance().getOrderById(orderId);
            
            try{
                currentShow= GC_Connect2ShowDao.getInstance().getConnect2ShowById(currentOrder.Connect2_Show__c);
            }catch(exception e){
                system.debug('error trace'+ e.getStackTraceString());
                system.debug('error message'+ e.getMessage());
                currentShow= new GC_Connect2_Show__c();
            }
            
            coreApi = new GC_CoreQuery();
            coreApi.order = currentOrder;
            isCommunity=false;
            initializeController();
            runOnce=1;
            coreApi.selectedBooth = null;
            selectedGesTask.isRevision  =false;
            
            try{
                taskFieldManager = [SELECT id, name, Background__c,Booth_Area_Discount__c,Budget_Code__c,Client_Layout_Notes__c,Completion_Date_Time__c,Connect2_Show__c,Copy_Placement__c,Default_Completion_Date_Time__c,Default_Installation_Delivery_Date_Time__c,Default_Removal_Date_Time__c,Delivery_Area__c,File_Reference_Link_Folder__c,Installation_Delivery_Date_Time__c,Installation_Method__c,Onsite_Contact_Person__c,Onsite_Contact_Person_Number__c,Outdoors__c,Price__c,Removal_Date_Time__c,Save_Signs__c,Sign_Copy__c,Sign_Title__c,Sign_Type__c,Sign_Type_Other__c,Single_Double_Sided__c,Special_Instructions_Client_Remarks__c,User__c,User_Item_Description__c FROM GC_Task_Field_Manager__c WHERE Connect2_Show__c=:currentOrder.Connect2_Show__c LIMIT 1]; 
            }catch(exception e){
                taskFieldManager= new GC_Task_Field_Manager__c(); 
            }
            
          
      }
        
        public GC_GOTCreationController() {
            orderId=  ApexPages.currentPage().getParameters().get('orderId');
            showId=  ApexPages.currentPage().getParameters().get('showId');
            isClone=  ApexPages.currentPage().getParameters().get('isClone');
            isEdit=  ApexPages.currentPage().getParameters().get('isEdit');
            taskId=  ApexPages.currentPage().getParameters().get('taskId');
            isTaskPage=  ApexPages.currentPage().getParameters().get('isTaskPage');
            currentOrder = GC_OrderDao.getInstance().getOrderById(orderId);
            currentShow= GC_Connect2ShowDao.getInstance().getConnect2ShowById(currentOrder.Connect2_Show__c);
            coreApi = new GC_CoreQuery();
            IsCommunity = !GC_PageUtil.IsLightningUI();
            coreApi.order = currentOrder;
            initializeController();
            
            try{
                taskFieldManager = [SELECT id, name, Background__c,Booth_Area_Discount__c,Budget_Code__c,Client_Layout_Notes__c,Completion_Date_Time__c,Connect2_Show__c,Copy_Placement__c,Default_Completion_Date_Time__c,Default_Installation_Delivery_Date_Time__c,Default_Removal_Date_Time__c,Delivery_Area__c,File_Reference_Link_Folder__c,Installation_Delivery_Date_Time__c,Installation_Method__c,Onsite_Contact_Person__c,Onsite_Contact_Person_Number__c,Outdoors__c,Price__c,Removal_Date_Time__c,Save_Signs__c,Sign_Copy__c,Sign_Title__c,Sign_Type__c,Sign_Type_Other__c,Single_Double_Sided__c,Special_Instructions_Client_Remarks__c,User__c,User_Item_Description__c FROM GC_Task_Field_Manager__c WHERE Connect2_Show__c=:showId LIMIT 1]; 
            }catch(exception e){
                taskFieldManager= new GC_Task_Field_Manager__c(); 
            }
            
        }
        
        public void initializeController() {  
            try {
                selectedGesTask = new GC_OrderViewController.GesTaskWrapper();
                selectedGesTask.task = new GC_GES_Order_Task__c();
                //if condition for cloning tasks
                if(isClone=='true' && String.isNotBlank(taskId)){
                    GC_GES_Order_Task__c task = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(taskId);
                    selectedGesTask.task = GC_PageUtil.cloneTask(task);
                }
                // if condition for editing tasks 
                if(isEdit=='true' && String.isNotBlank(taskId)){
                    
                    GC_GES_Order_Task__c task = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(taskId);
                    selectedGesTask.task = task;
                    system.debug('isEdit=======' + selectedGesTask.task);
                }
                if (currentOrder != null && String.isNotBlank(currentOrder.Id) && String.isBlank(taskId)) {
                    selectedGesTask.task.Order__c = currentOrder.Id;
                }
                
                coreApi.setCurrentTask(selectedGesTask.task);
                
            } catch (Exception e) {
                //GC_PageUtil.AddErrorMessage('Exception caught creating task: ' + e.getMessage());
                //GC_PageUtil.AddErrorMessage(e.getStackTraceString());
                system.debug('Exception caught creating task===' + e.getMessage());
                system.debug('ErrorStackTraceString===' + e.getStackTraceString()+ e.getMessage());
            }
            
            if (String.isBlank(currentShow.Job_Number__c)) {
                GC_PageUtil.AddWarningMessage('Job Number is blank, Can not proceed with Edit. ');
                coreApi.isProjectValid = false;
                
            } else {
                coreApi.showProjectNumber = currentShow.Job_Number__c;
                coreApi.isProjectValid = true;
            }
            
            //coreApi.order = currentOrder;
            
            activeGemStructureTasks = new List<SelectOption>();
            activeGemStructureTasks.add(new SelectOption('', '----None----'));
            designElementTasks = new List<SelectOption>();
            designElementTasks.add(new SelectOption('', '----None----'));
            SelectOption noneSelectOption = new SelectOption('', '---None---');
            materialOptions = new List<SelectOption>();
            materialOptions.add(noneSelectOption);
            venueLocations = new List<SelectOption>();
            venueLocations.add(noneSelectOption);
            departmentAttributes = new List<SelectOption>();
            departmentAttributes.add(noneSelectOption);
            GC_OrderUtils.lookupShowAttributes(currentOrder.Connect2_Show__c, materialOptions, venueLocations, departmentAttributes);
            GC_OrderUtils.lookupServiceTypeAttributes(currentOrder.Connect2_Show__c, serviceTypes);
            
            
            if (designElementTasks == null) {
                designElementTasks = new List<SelectOption>();
                
            } else {
                designElementTasks.clear();
            }
            
            
            designElementTasks.add(noneSelectOption);
            //SAL-1293 - updated where clouse - 12/20/23 - Sajid
            //List<GC_Design_Element__c> tasks = [select Id, Name, Design_Element__c, Deliverable__c, Task_Description__c from GC_Design_Element__c where Design_Request_Form__r.Connect2_Show__c = :currentOrder.Connect2_Show__c order by Name];
            List<GC_Design_Element__c> tasks = [select Id, Name, Design_Element__c, Deliverable__c, Task_Description__c from GC_Design_Element__c where Connect2_Show__c = :currentOrder.Connect2_Show__c order by Name];
            
            for (GC_Design_Element__c task : tasks) {
                String taskDesc = task.Name + ' - ' + task.Design_Element__c + ' - ' + task.Deliverable__c + ' - ' + task.Task_Description__c;
                designElementTasks.add(new SelectOption(task.Id, taskDesc));
            }
            
        }
        
        
        public PageReference sessionLoad() {
            //transactionPageErrors.clear();
            GC_Core_Session__c session;
            //system.debug('sessionLoad===');
            try {
                session = GC_CoreUtils.getSessionID();
                coreApi.coreSessionId = session.Core_Application_Session_ID__c;
            //system.debug('exit sessionLoad===');    
            } catch (Exception e) {
                GC_Core_Interface_Log__c logMsg;
                
                if (currentOrder != null && String.isNotBlank(currentOrder.Id)) {
                    logMsg = GC_CoreUtils.createNewLog('Failed to Connect', 'Failed to Connect to Core ' + e.getMessage(), 'Error', currentOrder);
                    
                } else {
                    logMsg = GC_CoreUtils.createNewLog('Failed to Connect', 'Failed to Connect to Core ' + e.getMessage(), 'Error');
                }
                //system.debug('logMsg===='+logMsg);
                insert logMsg;
                //transactionPageErrors.add(e.getMessage());
                system.debug('sessionLoad===' + e.getMessage());
                system.debug('sessionLoad===' + e.getStackTraceString());
            }
            return null;
        }
        /**
    * @description Saves the current selected task
    * @return null
    **/
        public PageReference saveTask() {
            
            //system.debug('coreApi.selectedItem==='+coreApi.selectedItem);
            try {
                if (String.isBlank(selectedGesTask.task.Item_Number__c)) {
                    GC_PageUtil.AddErrorMessage('Must select an item from the drop down.');
                    return null;
                }
                GC_GES_Order_Task__c got = selectedGesTask.task;
                
                if(!coreapi.setItemNumber.contains(got.Item_Number__c)) {
                    GC_PageUtil.AddErrorMessage('Item doesn\'t exist for this show. Please Remove Edit it.');
                    return null;
                }
                system.debug('got inside saveTask method==='+got);
                //till here
                if (got.Item_Template__c != null && got.Item_Template__c.contains('Carpet') && got.Carpet_Length__c != null && got.Carpet_Width__c != null && got.UOM__c == 'SF') {
                    got.QuantityNum__c = Integer.valueof(got.Carpet_Length__c * got.Carpet_Width__c);
                    
                }
                if (got.Item_Number__c == '900018' || got.Item_Number__c == '900241'){
                     got.UOM__c = 'SF';
                }
                 
                if(!Test.isRunningTest()){  
                    if (got.Item_Template__c != null && got.Item_Template__c.contains('Carpet') && got.Carpet_Length__c != null && got.Carpet_Width__c != null && got.UOM__c == 'SF' ) {
                        got.QuantityNum__c = Integer.valueof(got.Carpet_Length__c * got.Carpet_Width__c);
                    } 
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
                    if(selectedGesTask.task.Status__c == 'On Hold'){
                        selectedGesTask.task.Status__c = 'New';
                    }
                    update selectedGesTask.task;
                    
                    selectedGesTask = null;
                    
                } else if (selectedGesTask != null && String.isBlank(selectedGesTask.task.Id)) {
                    selectedGesTask.task.Order__c = currentOrder.Id;
                    if(!String.isBlank(coreApi.selectedCategory)){
                        if(coreApi.categoryMap.containsKey(coreApi.selectedCategory))
                        {
                            selectedGesTask.task.Item_Category__c = coreApi.categoryMap.get(coreApi.selectedCategory);
                        }
                    }
                    if(String.isNotBlank(coreApi.selectedItem.ParentCategory)){
                            selectedGesTask.task.Parent_Category__c = coreApi.selectedItem.ParentCategory;
                    }
                    if(String.isNotBlank(coreApi.selectedItem.ChildCategory)){
                            selectedGesTask.task.Child_Category__c = coreApi.selectedItem.ChildCategory;
                    }
                    insert selectedGesTask.task;
                    //system.debug('selectedGesTask.task.id==='+selectedGesTask.task.Id);
                    if (currentRevision != null && String.isBlank(currentRevision.Original_Task_Revision2__c)) {
                        currentRevision.Original_Task_Revision2__c = selectedGesTask.task.Id;
                        selectedGesTask.task.Original_Task_Revision2__c = selectedGesTask.task.Id;
                        
                    } else {
                        selectedGesTask.task.Original_Task_Revision2__c = selectedGesTask.task.Id;
                    }
                    selectedGesTask = null;
                }
                
            } catch (Exception e) {
                GC_PageUtil.AddErrorMessage('Exception caught saving task: ' + e.getMessage());
                GC_PageUtil.AddErrorMessage(e.getStackTraceString());
                system.debug('Exception caught saving task: ' + e.getStackTraceString() + e.getMessage());
                return null;
            }
            
            PageReference pr;
            
            if(isCommunity){
                if(String.isNotBlank(isTaskPage) && isTaskPage=='true'){
                    pr= new PageReference('/apex/GC_Community_gotView');
                    pr.getParameters().put('gotId',taskId);
                }else{
                    pr= new PageReference('/apex/GC_Community_OrderView');
                }
                pr.getParameters().put('orderId',String.valueOf(currentOrder.id));
                pr.getParameters().put('showId',String.valueOf(currentOrder.Connect2_Show__c));
            }else{
                if(String.isNotBlank(isTaskPage) && isTaskPage=='true'){
                    String id2=  ApexPages.currentPage().getParameters().get('taskId');
                    pr= new PageReference('/apex/GC_OrderTaskView');
                    pr.getParameters().put('id',id2);
                }else{
                    pr= new PageReference('/apex/GC_OrderView');
                    pr.getParameters().put('id',String.valueOf(currentOrder.id));
                } 
            }
            
            pr.setRedirect(true);
            return pr;    
        }
        
        /**
    * @description Cancels the selected task inline for editing.
    * @return null
    **/
        public PageReference cancelEditTask() {
            selectedGesTask = null;
            PageReference pr;
            if(isCommunity){
                if(String.isNotBlank(isTaskPage) && isTaskPage=='true'){
                    pr= new PageReference('/apex/GC_Community_gotView');
                    pr.getParameters().put('gotId',taskId);
                }else{
                    pr= new PageReference('/apex/GC_Community_OrderView');
                }
                
                pr.getParameters().put('orderId',String.valueOf(currentOrder.id));
                pr.getParameters().put('showId',String.valueOf(currentOrder.Connect2_Show__c));
            }else{
                if(String.isNotBlank(isTaskPage) && isTaskPage=='true'){
                    String id2=  ApexPages.currentPage().getParameters().get('taskId');
                    pr= new PageReference('/apex/GC_OrderTaskView');
                    pr.getParameters().put('id',id2);
                }else{
                    pr= new PageReference('/apex/GC_OrderView');
                    pr.getParameters().put('id',String.valueOf(currentOrder.id));
                }            
            }
            pr.setRedirect(true);
            return pr;       
        }
        
        Map<string, string>  tfmToGotMap = TaskFieldToGOTFieldMap.loadMap();
        //tfmToGotMap  = TaskFieldToGOTFieldMap.loadMap();        
        Map<string, string> requiredFieldsMap = new Map<string, string>();        
        
                    
        public PageReference validateFields(){
            Schema.DescribeSObjectResult a_desc = GC_Task_Field_Manager__c.sObjectType.getDescribe(); 
            Map<String, Schema.SObjectField> all_fields = GC_Task_Field_Manager__c.sObjectType.getDescribe().fields.getMap();        
            SObject sTaskField = (SObject)taskFieldManager;
            
            for(Schema.sObjectField fld:all_fields.values()){            
                if(fld.getDescribe().getName().contains('__c') && (fld.getDescribe().getName() !='User__c'
                                                                  && fld.getDescribe().getName()!='Connect2_Show__c'
                                                                   && fld.getDescribe().getName()!='Hide_Order_Level_File_Upload__c'
                                                                   && fld.getDescribe().getName()!='Sign_Type__c'
                                                                   && fld.getDescribe().getName()!='Sign_Title__c'
                                                                   && fld.getDescribe().getName()!='Single_Double_Sided__c')){
                                                                       if(sTaskField.get(fld) == 'Shown and Required')
                                                                       {
                                                                           requiredFieldsMap.put(fld.getDescribe().getName(), fld.getDescribe().getLabel());
                                                                       }
                                                                   }
            }                      
                                    if(requiredFieldsMap.keySet().size()>0){
                                                    String msg1= '';
                                                    for(String key: requiredFieldsMap.values()){
                                                                    msg1+= key + ', ';
                                                    }
                                                    
                                                    if(String.isNotBlank(msg1)){
                                                                    GC_PageUtil.AddInfoMessage('The following field(s) are required for this Order Task: ' + msg1.left(msg1.length() - 2));
                                                    }else{
                                                                    
                                                    }
                                                    
                                    }
            return null;
        }
        
        public PageReference validateSave(){         
            SObject sGOT = (SObject)selectedGesTask.task;
            String emptyfields = '';       
            for (String key : requiredFieldsMap.keySet()){            
                if(String.isNotblank(tfmToGotMap.get(key))){
                    String gotFieldRelatedToTFM = tfmToGotMap.get(key);
                    String gotLabelRelatedToTFM = requiredFieldsMap.get(key);               
                    if(sGOT.get(gotFieldRelatedToTFM) == null){
                        emptyfields += gotLabelRelatedToTFM + ', ';
                    }
                }
                
            }
            if(requiredFieldsMap.containsKey('Special_Instructions_Client_Remarks__c') && selectedGesTask.task.Show_Management_Field__c.length()==0 ){
                emptyfields += 'Special Instructions (Client Remarks), ';
            } 
            if(String.isNotBlank(emptyfields)){
                system.debug('emptyfields==='+emptyfields);
                GC_PageUtil.AddErrorMessage('The following field(s) are required: ' + emptyfields.left(emptyfields.length() - 2));
                return null;
            }
            else
                return saveTask();
        }
        
        public Static String getReasonCodes(String inputReasonCode){
            Map<String, String> ReasonCodeMap= new Map<String, String>();
            ReasonCodeMap.put('Miscellaneous','MISC');
            ReasonCodeMap.put('Customer Good Will','REFUND');
            ReasonCodeMap.put('Exchange','EXCHANGE');
            ReasonCodeMap.put('100% Cancellation','CANCEL');
            ReasonCodeMap.put('Service Issue','MANUAL');
            ReasonCodeMap.put('Updated from Deal Workbench','DEALS');
            ReasonCodeMap.put('Addition to Contractual Agreement','1');
            ReasonCodeMap.put('Contractual Agreement','2');
            ReasonCodeMap.put('Excessive Labor','3');
            ReasonCodeMap.put('Late Exhibitor','4');
            ReasonCodeMap.put('Ordered Before Deadline','5');
            ReasonCodeMap.put('Ordered at Show Site','6');
            ReasonCodeMap.put('Out of Package','7');
            ReasonCodeMap.put('Exhibitor Changes','8');
            ReasonCodeMap.put('Estimate Revision','9');
            ReasonCodeMap.put('Online Discount','10');
        
         if(ReasonCodeMap.containsKey(inputReasonCode)){
            return ReasonCodeMap.get(inputReasonCode);
          }
          return null;
         }
        
        public pageReference clearDiscountValues(){
        selectedGesTask.task.Discount_Reason_Code__c = null;
        selectedGesTask.task.Discount_Reason_Text__c = null;
        return null;
    }
        
    }