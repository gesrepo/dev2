public with sharing class GC_OrderCreateEditController extends GC_BaseViewController {
    public GC_Order__c currentOrder {get; private set;}
    public GC_OrderViewController.GesTaskWrapper selectedGesTask{get; set;}
    public GC_Connect2_Show__c referenceShow {get; set;}
    public GC_CoreQuery coreApi { get; set; }
    public Map<String, GC_ItemHolder> itemsMap ;
    public set<string> setItemNumber;
    // keeps track of ajax processing messages for rerendering at the end.
    public List<String> transactionPageErrors {get; set;}
    public Boolean isNew {get; set;}

    // ------- Properties for community page
    public Boolean cloneFlag {get; set;}  // Determines if the Task is a clone
    public string newBoothAreaId {get; set;}
    public GC_OrderCreateEditController() {
        IsSalesforce = GC_PageUtil.IsLightningUI();
        IsLightning = GC_PageUtil.IsLightningUI();
        IsCommunity = !IsSalesforce;

        coreApi = new GC_CoreQuery();

        cloneFlag = false;

        String orderId = ApexPages.currentPage().getParameters().get('orderId');
        String showId = ApexPages.currentPage().getParameters().get('showId');
        String isClone = ApexPages.currentPage().getParameters().get('isClone');
        String originalOrderId = ApexPages.currentPage().getParameters().get('originalOrderId');

        if (String.isNotBlank(isClone) && String.isNotBlank(showId) && String.isNotBlank(originalOrderId)) {
            // clone case
            referenceShow = GC_Connect2ShowDao.getInstance().getConnect2ShowById(showId);
            currentOrder = GC_OrderDao.getInstance().getOrderById(originalOrderId);
            currentOrder.Status__c = 'New';
            cloneFlag = true;
        }
        else if (String.isBlank(isClone) && String.isNotBlank(showId) && String.isBlank(orderId)) {
            // new task
            referenceShow = GC_Connect2ShowDao.getInstance().getConnect2ShowById(showId);
            currentOrder = new GC_Order__c(Connect2_Show__c = showId);
        }
        else if (String.isBlank(isClone) && String.isNotBlank(showId) && String.isNotBlank(orderId)) {
            // edit
            referenceShow = GC_Connect2ShowDao.getInstance().getConnect2ShowById(showId);
            currentOrder = GC_OrderDao.getInstance().getOrderById(orderId);
        }

        if (referenceShow != null && String.isBlank(referenceShow.Job_Number__c)) {
            String testMsg = ' test ' + referenceShow.Job_Number__c;
            GC_PageUtil.AddWarningMessage('Job Number is blank, Can not proceed with Edit. ');
            GC_PageUtil.AddWarningMessage(testMsg);
            GC_PageUtil.AddWarningMessage(cloneFlag + '');
            coreApi.isProjectValid = false;
        }
        else {
            coreApi.showProjectNumber = referenceShow.Job_Number__c;
            coreApi.isProjectValid = true;
        }
        transactionPageErrors = new List<String>();
        coreApi.order = currentOrder;
        coreApi.selectedBooth = currentOrder.Booth_Area_ID__c;
    }

    public GC_OrderCreateEditController(ApexPages.StandardController sc) {
        IsSalesforce = true;
        IsLightning = false;
        IsCommunity = false;

        cloneFlag = false;

        String isClone = ApexPages.currentPage().getParameters().get('isClone');

        cloneFlag = String.isNotBlank(isClone);

        coreApi = new GC_CoreQuery();

        coreApi.isProjectValid = false;
        String orderId = sc.getId();
        if (String.isNotBlank(orderId)) {
            isNew = false;
            currentOrder = GC_OrderDao.getInstance().getOrderById(orderId);
            if (String.isBlank(currentOrder.Connect2_Show__r.Job_Number__c)) {
                coreApi.isProjectValid = false;
            }
            else {
                coreApi.showProjectNumber = currentOrder.Connect2_Show__r.Job_Number__c;
                coreApi.isProjectValid = true;
            }
            if (cloneFlag) {
                currentOrder.Status__c = 'New';
            }
        }
        else {
            isNew = true;
            currentOrder = new GC_Order__c();
            for (String param : ApexPages.CurrentPage().getParameters().keySet()) {
                if (param.contains('_lkid')) {
                    String showId = ApexPages.CurrentPage().getParameters().get(param);
                    referenceShow = GC_Connect2ShowDao.getInstance().getConnect2ShowById(showId);
                    currentOrder.Connect2_Show__c = referenceShow.Id;
                    if (String.isBlank(referenceShow.Job_Number__c)) {
                        coreApi.isProjectValid = false;
                    }
                    else {
                        coreApi.showProjectNumber = referenceShow.Job_Number__c;
                        coreApi.isProjectValid = true;
                    }
                    break;
                }
            }
        }

        transactionPageErrors = new List<String>();

        coreApi.order = currentOrder;
        coreApi.selectedBooth = currentOrder.Booth_Area_ID__c;
    }

    public class GC_ItemHolder {
        public String Category { get; set; }
        public String CategoryId { get; set; }
        public String ChildCategory { get; set; }
        public String InventoryItemId { get; set; }
        public String ItemNumber { get; set; }
        public String ItemDescription { get; set; }
        public String ItemOptionTemplate { get; set; }
        public String ImageUrl { get; set; }
        public String ItemType { get; set; }
        public String LineOfBusiness { get; set; }
        public String ParentCategory { get; set; }
        public String Price { get; set; }
        public String Units { get; set; }
        public String TaxRate { get; set; }
        public String BoothAreaDiscount { get; set; }

        public GC_ItemHolder(CORE_V1.ShowOrgProduct orgProduct) {
            //Category = orgProduct.CategoryDescription;
            //CategoryId = String.valueOf(orgProduct.CategoryID);
            //ChildCategory = orgProduct.ChildCategory;
            InventoryItemId = String.valueOf(orgProduct.InventoryItemId);
            ItemNumber = orgProduct.ItemNumber;
            ItemDescription = orgProduct.ItemDescription;
            ImageUrl = orgProduct.ImageUrl;
            ItemOptionTemplate = orgProduct.ItemOptionTemplate;
            //ItemType = orgProduct.ItemType;
            //LineOfBusiness = orgProduct.LineOfBusiness;
            //ParentCategory = orgProduct.ParentCategory;
            Price = String.valueOf(orgProduct.Price);
            Units = orgProduct.UOM;
            TaxRate = String.valueOf(orgProduct.TaxRate);
            BoothAreaDiscount = String.valueOf(orgproduct.DiscountPercentage);
        }
    }

    public PageReference loadAction() {
        // Only called for community/lightning
        return null;
    }

    public PageReference showChanged() {
        if (String.isNotBlank(currentOrder.Connect2_Show__c)) {
            referenceShow = GC_Connect2ShowDao.getInstance().getConnect2ShowById(currentOrder.Connect2_Show__c);
            if (String.isBlank(referenceShow.Job_Number__c)) {
                coreApi.isProjectValid = false;
            }
            else {
                coreApi.showProjectNumber = referenceShow.Job_Number__c;
                coreApi.isProjectValid = true;
            }
            return coreApi.obtainBoothAreas();
        }
        else {
            return null;
        }
    }

    public PageReference sessionLoad() {
        transactionPageErrors.clear();
        GC_Core_Session__c session;
        try {
            session = GC_CoreUtils.getSessionID();
            coreApi.coreSessionId = session.Core_Application_Session_ID__c;
        }
        catch (Exception e) {
            GC_Core_Interface_Log__c logMsg;
            if (currentOrder != null && String.isNotBlank(currentOrder.Id)) {
                logMsg = GC_CoreUtils.createNewLog('Failed to Connect', 'Failed to Connect to Core ' + e.getMessage(), 'Error', currentOrder);
            }
            else {
                logMsg = GC_CoreUtils.createNewLog('Failed to Connect', 'Failed to Connect to Core ' + e.getMessage(), 'Error');
            }
            insert logMsg;
            GC_PageUtil.AddErrorMessage('Failed to Obtain Booth Areas ' + e.getMessage());
            transactionPageErrors.add(e.getMessage());
        }
        return null;
    }
     public class GC_ProductMap{
        //public Map<String, Map<String, List<string>>> productMap {get; set;}
        public Map<String, GC_ItemHolder> itemsMap {get; set;}
        //public set<string> setItemNumber {get; set;}
        //public Map<string,string> categoryMap { get; set; }
        //public List<SelectOption> productCategories { get; set; }
        
        public GC_ProductMap(){
            
        }
    }

    public PageReference saveAction() {
        System.debug(loggingLevel.Error, '*** cloneFlag: ' + cloneFlag);
        if (IsSalesforce && !IsLightning) {
            GC_Order__c updatedOrder;
            // if we're cloning, we clone the order and the order tasks, leaving the original one intact.
            if (cloneFlag) 
            {
                
                updatedOrder = GC_PageUtil.cloneOrder(currentOrder);
            }
            else {
                updatedOrder = currentOrder;
            }

            if (coreApi.boothAreas.containsKey(coreApi.selectedBooth)) {
                CORE_V2.BoothArea boothArea = coreApi.boothAreas.get(coreApi.selectedBooth);
                updatedOrder.put('Booth_Area_ID__c', String.valueOf(boothArea.BoothAreaId));
                updatedOrder.put('Booth_Area__c', String.valueOf(boothArea.Area));
                updatedOrder.put('Delivery_Date_Time__c', GC_CoreUtils.ConvertExternalDateTime(boothArea.DeliveryDateTime));
                updatedOrder.put('Removal_Date_Time__c', GC_CoreUtils.ConvertExternalDateTime(boothArea.RemovalDateTime));
                updatedOrder.put('Completion_Date_Time__c', GC_CoreUtils.ConvertExternalDateTime(boothArea.CompletionDateTime));
            }

            upsert updatedOrder;

            // TODO determine if the booth area has changed and recalculate the booth area discount on all the items and update them.
            return new PageReference('/apex/GC_OrderView?id=' + updatedOrder.Id);
        }
        else {
            if (coreApi.boothAreas.size() == 0) {
                GC_PageUtil.AddErrorMessage('Failed to Obtain Booth Areas from Web Service');
                return null;
            }
            if (String.isBlank(coreApi.selectedBooth)) {
                GC_PageUtil.AddErrorMessage('Please select a booth area for this order.');
                return null;
            }
            try {
                GC_Order__c updatedOrder;
                
                GC_Core_Session__c session;
                String coreSessionId;
                String showOccrProjectId;
                Map<String, Map<String, List<GC_ItemHolder>>> products = new Map<String, Map<String, List<GC_ItemHolder>>>();
                List<SelectOption> productList = new List<SelectOption>();
                Set<String> prodItemDesc = new Set<String>();
                List<GC_GES_Order_Task__c> gesOtToUpdate = new List<GC_GES_Order_Task__c>();
                try {
                    session = GC_CoreUtils.getSessionID();
                    coreSessionId = session.Core_Application_Session_ID__c;
                }
                catch (Exception e) {
                    GC_PageUtil.AddErrorMessage(e.getMessage());
                    return null;
                }

                CORE_V2.BasicHttpBinding_IShowService projectQuery = new CORE_V2.BasicHttpBinding_IShowService();
                try {
                    CORE_V2.ShowProject showProject;
                    if (Test.isRunningTest()) {
                        showProject = GC_TestUtils.getTestShowProject();
                    }
                    else {
                        showProject = projectQuery.GetShowProjectByProjectNumber(coreSessionId, referenceShow.Job_Number__c);
                    }
                    showOccrProjectId = String.valueOf(showProject.showOccrProjectId);
                }
                catch (Exception e) {
                    System.debug(LoggingLevel.ERROR, e.getMessage() + ' ' + e.getStackTraceString());
                    GC_PageUtil.AddErrorMessage(e.getMessage());
                    return null;
                }

                system.debug('showOccrProjectId'+showOccrProjectId);

                CORE_V1.BasicHttpBinding_IProductService productService = new CORE_V1.BasicHttpBinding_IProductService();
                try {
                    CORE_V1.ArrayOfShowOrgParentCategory showOrgProducts;
                    if (Test.isRunningTest()) {
                        showOrgProducts = GC_TestUtils.getTestShowParentProducts();
                    }
                    else {
                        showOrgProducts = productService.GetShowOrgProducts(coreSessionId, Integer.valueOf(showOccrProjectId), Integer.valueOf(coreApi.selectedBooth));
                    }
                   products = getProductMap(showOrgProducts);
                    GC_ProductMap newProductMap= new GC_ProductMap();
                    newProductMap.itemsMap= itemsMap;
                    

                }
                catch (Exception e) {
                    GC_PageUtil.AddErrorMessage(e.getMessage());
                    GC_PageUtil.AddDeveloperMessage(e.getStackTraceString());
                    return null;
                }
                
                
                if (cloneFlag) 
                {
                    updatedOrder = GC_PageUtil.cloneOrder(currentOrder);
                }
                else {
                    updatedOrder = currentOrder;
                }

                if (coreApi.boothAreas.containsKey(coreApi.selectedBooth)) {
                    CORE_V2.BoothArea boothArea = coreApi.boothAreas.get(coreApi.selectedBooth);
                    updatedOrder.put('Booth_Area_ID__c', String.valueOf(boothArea.BoothAreaId));
                    newBoothAreaId = String.valueOf(boothArea.BoothAreaId);
                    system.debug('newBoothAreaId+++++'+newBoothAreaId);
                    system.debug('coreApi.selectedBooth+++++'+coreApi.selectedBooth);
                    updatedOrder.put('Booth_Area__c', String.valueOf(boothArea.Area));
                    updatedOrder.put('Delivery_Date_Time__c', GC_CoreUtils.ConvertExternalDateTime(boothArea.DeliveryDateTime));
                    updatedOrder.put('Removal_Date_Time__c', GC_CoreUtils.ConvertExternalDateTime(boothArea.RemovalDateTime));
                    updatedOrder.put('Completion_Date_Time__c', GC_CoreUtils.ConvertExternalDateTime(boothArea.CompletionDateTime));
                }

                upsert updatedOrder;
                
                String orderId = updatedOrder.Id;
                String showId = updatedOrder.Connect2_Show__c;
                
                //if(!cloneFlag)
                //{
                List<GC_GES_Order_Task__c> gots = [Select Id,Item_Number__c,Description__c,Status__c from GC_GES_Order_Task__c where Order__c =: orderId];

                for(GC_GES_Order_Task__c gotasks: gots)
                {
                    if(!prodItemDesc.contains(gotasks.Item_Number__c+'_'+gotasks.Description__c))
                    {
                        gotasks.Status__c = 'On Hold';
                        gotasks.Is_On_Hold__c = true;
                        gesOtToUpdate.add(gotasks);
                    }
                }

                if(gesOtToUpdate.size() > 0)
                {
                    update gesOtToUpdate;
                }
                //}
                

                return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_OrderView?orderId=' + orderId + '&showId=' + showId);

            }
            catch (Exception e) {
                GC_PageUtil.AddErrorMessage(e.getMessage());
                GC_PageUtil.AddErrorMessage(e.getStackTraceString());
                return null;
            }
        }
    }

    public Map<String, Map<String, List<GC_ItemHolder>>> getProductMap(CORE_V1.ArrayOfShowOrgParentCategory products){
        List<SelectOption> productCategories = new List<SelectOption>();
        productCategories.clear();
        
        Map<String, Map<String, List<GC_ItemHolder>>> productsMap= new Map<String, Map<String, List<GC_ItemHolder>>>();
        Map<String, GC_ItemHolder> itemsMap = new Map<String, GC_ItemHolder>();
        itemsMap = new Map<String, GC_ItemHolder>();
        
        SelectOption noneSelectOption = new SelectOption('', '---None---');
        productCategories.Add(noneSelectOption);
        if (products.ShowOrgParentCategory != null) {
            for (CORE_V1.ShowOrgParentCategory parentCategory : products.ShowOrgParentCategory ) {
                if(!productsMap.containsKey(parentCategory.Name)){
                    productsMap.put(parentCategory.Name, new Map<String, List<GC_ItemHolder>>());
                    SelectOption so = new SelectOption(parentCategory.Name, parentCategory.Name);
                    productCategories.Add(so);
                  
                    if(parentCategory.ChildCategories !=null){
                        for(CORE_V1.ShowOrgChildCategory childCategory: parentCategory.ChildCategories.ShowOrgChildCategory){
                            if(!productsMap.get(parentCategory.Name).containsKey(childCategory.Name)){
                                productsMap.get(parentCategory.Name).put(childCategory.Name, new List<GC_ItemHolder>());
                            }
                            if(childCategory.Products!=null){
                                for(CORE_V1.ShowOrgProduct product:childCategory.Products.ShowOrgProduct){
                                    productsMap.get(parentCategory.Name).get(childCategory.Name).add(new GC_ItemHolder(product));
                                    itemsMap.put(String.valueOf(product.ItemNumber + '_' + product.ItemDescription),new GC_ItemHolder(product));
                                }
                            }
                            
                        }
                    }
                }
            }
        }
        
        else{
            GC_PageUtil.AddErrorMessage('Failed to return any products for the booth area.  Can not proceed with Ordering items.');
        }
        return productsMap;
    }

    /**
     * @description cancel any edits and go back to the view page.
     **/
    public PageReference cancelAction() {
        if (ApexPages.CurrentPage().getParameters().containsKey('retURL')) {
            return new PageReference(ApexPages.CurrentPage().getParameters().get('retURL'));
        }

        if (IsSalesforce && !IsLightning) {

            if (String.isNotBlank(currentOrder.Id)) {
                return new PageReference('/apex/GC_OrderView?id=' + currentOrder.Id);
            }
        }
        else {
            String orderId = ApexPages.currentPage().getParameters().get('Id');
            String showId = ApexPages.currentPage().getParameters().get('showId');
            String isClone = ApexPages.currentPage().getParameters().get('isClone');
            String originalOrderId = ApexPages.currentPage().getParameters().get('originalOrderId');

            if (String.isNotBlank(isClone) && String.isNotBlank(showId) && String.isNotBlank(originalOrderId)) {
                // clone case
                return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_OrderView?orderId=' + originalOrderId + '&showId=' + showId);
            }
            else if (String.isBlank(isClone) && String.isNotBlank(orderId) && String.isNotBlank(showId)) {
                // edit case
                return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_OrderView?orderId=' + orderId + '&showId=' + showId);
            }
            else if (String.isBlank(isClone) && String.isNotBlank(showId) && String.isBlank(orderId)) {
                // new case
                return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_HomePage?showId=' + showId);
            }
            else {
                // hope to never get here, but URL parameters could get removed
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Failed to find a valid redirect'));
                return null;
            }
        }
        return null;
    }

    public String getSaveTitle() {
        return 'Saves the current order. Returns to the order view page.';
    }
    public String getCancelTitle() {
        return 'Cancels the current page edit and returns back to the Order view page.';
    }

}