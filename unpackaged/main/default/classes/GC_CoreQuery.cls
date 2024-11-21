public with sharing class GC_CoreQuery {
    public GC_Order__c order {get; set;}
    public GC_GES_Order_Task__c got {get; set;}
    
    // These are consistent via multiline and booth area changes
    public String coreSessionId { get; set; }
    public String showProjectNumber { get; set; } // CORE uses two numbers for ordering items, showProjectNumber is the salesforce Job number.
    public String showOccrProjectId { get; set; } // This is determined by the salesforce job number above and needs to be queried for.
    public String selectedBooth { get; set; } // Selected Booth ID from Parent Order
    public String selectedBoothName { get; set; } // Selected Booth ID from Parent Order
    public List<SelectOption> boothOptions { get; private set; }
    public Map<String, CORE_V2.BoothArea> boothAreas { get; private set; }
    public List<SelectOption> productCategories { get; private set; }
    public List<SelectOption> childCategories { get; private set; }
    public LargeSelectList productList { get; set; }
    public Map<String, Map<String, List<string>>> products { get; private set; }
    public Map<String, GC_ItemHolder> itemsMap ;
    public Boolean isProjectValid { get; set; }
    public String searchItemClick { get; set; }
    
    // These vary per item, potentially can change based on which task is selected.
    public GC_ItemHolder selectedItem { get; set; } // Wrapper Item to hold the selected Item
    //public List<GC_ItemHolder> currentItems { get; set; } // Wrapper Item to hold the selected Item
    public List<String> currentItems { get; set; } 
    public String selectedCategory { get; set; } // Selected Category for Filters
    public String selectedParentCategory { get; set; } // Selected Category for Filters
    
    public String selectedChildCategory { get; set; } // Selected Category for Filters
    public String selectedItemNumber { get; set; } // Selected Item Number when Selected
    public String selectedItemNumberAndDescription { get; set; } // Selected Item Number when Selected
    public String itemOptionsTemplate { get; set; } // itemOptionsTemplate is used to rerender the options for the particular item, Basic / Graphics / Carpet are the simple options.
    public String selectedImagePath { get; set; } // itemOptionsTemplate is used to rerender the options for the particular item, Basic / Graphics / Carpet are the simple options.
    public Map<string,string> categoryMap { get; set; } 
    public set<string> setItemNumber;
    
    public GC_CoreQuery() {
        SelectOption noneSelectOption = new SelectOption('', '---None---');
        productCategories = new List<SelectOption>();
        productCategories.Add(noneSelectOption);
        
        childCategories = new List<SelectOption>();
        childCategories.Add(noneSelectOption);
        
        productList = new LargeSelectList();
        productList.Add(noneSelectOption);
        
        //selectedParentCategory = '';
        selectedChildCategory = '';
        
        //products = new Map<String, Map<String, List<GC_ItemHolder>>>();
        products = new Map<String, Map<String, List<string>>>();
        boothOptions = new List<SelectOption>();
        boothAreas = new Map<String, CORE_V2.BoothArea>();
        categoryMap  = new Map<String, String>();
    }
    
    public void setCurrentTask(GC_GES_Order_Task__c gesOrderTask) {
        
        system.debug('setCurrentTask=======' + gesOrderTask);
        system.debug('itemsMap=======' + itemsMap);
        
        got = gesOrderTask;
        selectedCategory = String.valueOf(got.Item_Category_ID__c);
        selectedParentCategory= got.Parent_Category__c;
        selectedChildCategory= got.Child_Category__c;
        selectedItemNumber = String.valueOf(got.Item_Number__c);
        selectedItemNumberAndDescription = selectedItemNumber + '_' + String.valueOf(got.Description__c);
        selectCategories();
        itemOptionsTemplate = String.valueOf(got.Item_Template__c);
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
            InventoryItemId = String.valueOf(orgProduct.InventoryItemId);
            ItemNumber = orgProduct.ItemNumber;
            ItemDescription = orgProduct.ItemDescription;
            ImageUrl = orgProduct.ImageUrl;
            ItemOptionTemplate = orgProduct.ItemOptionTemplate;
            Price = String.valueOf(orgProduct.Price);
            Units = orgProduct.UOM;
            TaxRate = String.valueOf(orgProduct.TaxRate);
            BoothAreaDiscount = String.valueOf(orgproduct.DiscountPercentage);
            
        }
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
    
    public PageReference obtainBoothAreas() {
        if (isProjectValid) {
            //if (String.isBlank(coreSessionId)) {
            //    sessionLoad();
            //}
            if (String.isBlank(coreSessionId)) {
                GC_PageUtil.AddErrorMessage('Failed to Obtain the Session Id');
                return null;
            }
            CORE_V2.BasicHttpBinding_IShowService projectQuery = new CORE_V2.BasicHttpBinding_IShowService();
            try {
                CORE_V2.ShowProject showProject;
                if (Test.isRunningTest()) {
                   showProject = GC_TestUtils.getTestShowProject();
                }
                else {
                    showProject = projectQuery.GetShowProjectByProjectNumber(coreSessionId, showProjectNumber);
                }
                boothAreas = getBoothAreaByShowProject(showProject);
                showOccrProjectId = String.valueOf(showProject.showOccrProjectId);
            }
            catch (Exception e) {
                GC_Core_Interface_Log__c logMsg;
                if (order != null && String.isNotBlank(order.Id)) {
                    logMsg = GC_CoreUtils.createNewLog('Obtain Booth Areas', 'Failed to Obtain Booth Areas ' + e.getMessage(), 'Error', order);
                }
                else {
                    logMsg = GC_CoreUtils.createNewLog('Obtain Booth Areas', 'Failed to Obtain Booth Areas ' + e.getMessage(), 'Error');
                }
                insert logMsg;
                GC_PageUtil.AddErrorMessage('Failed to Obtain Booth Areas');
                GC_PageUtil.AddErrorMessage('Response from Web Service: ' + e.getMessage());
            }
            selectedBooth = String.valueof(order.Booth_Area_ID__c);
        }else {
            GC_PageUtil.AddErrorMessage('Job Number is blank, Cannot proceed with obtaining the Booth Areas.');
        }if (order.Status__c == 'Active') {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'The current order can not be changed because it has active tasks'));
        }
        return null;
    }
    
    public PageReference selectBoothArea() {
        if (String.isNotBlank(selectedBooth) && boothAreas != null) {
            CORE_V2.BoothArea boothArea = boothAreas.get(selectedBooth);
            order.Booth_Area__c = String.valueOf(boothArea.Area);
            order.Booth_Area_ID__c = String.valueOf(boothArea.BoothAreaId);
            order.Delivery_Date_Time__c = GC_CoreUtils.ConvertExternalDateTime(boothArea.DeliveryDateTime);
            order.Removal_Date_Time__c = GC_CoreUtils.ConvertExternalDateTime(boothArea.RemovalDateTime);
            order.Completion_Date_Time__c = GC_CoreUtils.ConvertExternalDateTime(boothArea.CompletionDateTime);
            return null;
        }
        return null;
    }
    
    public Map<String, CORE_V2.BoothArea> getBoothAreaByShowProject(CORE_V2.ShowProject showProject) {
        boothOptions.clear();
        Map<String, CORE_V2.BoothArea> boothAreaLookup = new Map<String, CORE_V2.BoothArea>(); // we'll use Area as the Key, this should be filled out
        SelectOption noneSelectOption = new SelectOption('', '---None---');
        boothOptions.Add(noneSelectOption);
        
        for (CORE_V2.BoothArea boothArea : showProject.BoothAreas.BoothArea) {
            boothAreaLookup.put(String.valueOf(boothArea.BoothAreaId), boothArea);
            SelectOption so = new SelectOption(String.valueof(boothArea.BoothAreaId), boothArea.Area);
            boothOptions.Add(so);
        }
        return boothAreaLookup;
    }
    
    public PageReference obtainProducts() {
        if (isProjectValid) {
            GC_Core_Session__c session;
            try {
                session = GC_CoreUtils.getSessionID();
                coreSessionId = session.Core_Application_Session_ID__c;
            }
            catch (Exception e) {
                GC_PageUtil.AddErrorMessage(e.getMessage());
                return null;
            }
            
            if (String.isBlank(selectedBooth)) {
                selectedBooth = String.valueof(order.Booth_Area_ID__c);
                if (String.isBlank(selectedBooth)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Booth area is required to create the GES order task.'));
                    return null;
                }
            }
            CORE_V2.BasicHttpBinding_IShowService projectQuery = new CORE_V2.BasicHttpBinding_IShowService();
            try {
                CORE_V2.ShowProject showProject;
                if (Test.isRunningTest()) {
                    showProject = GC_TestUtils.getTestShowProject();
                }
                else {
                    showProject = projectQuery.GetShowProjectByProjectNumber(coreSessionId, showProjectNumber);
                }
                showOccrProjectId = String.valueOf(showProject.showOccrProjectId);
            }catch (Exception e) {
                //system.debug(LoggingLevel.ERROR, e.getMessage() + ' ' + e.getStackTraceString());
                GC_PageUtil.AddErrorMessage(e.getMessage());
                return null;
            }
            CORE_V1.BasicHttpBinding_IProductService productService = new CORE_V1.BasicHttpBinding_IProductService();
            try {
                //rk CORE_V1.ArrayOfShowOrgProduct showOrgProducts;
                CORE_V1.ArrayOfShowOrgParentCategory showOrgProducts;
                if (Test.isRunningTest()) {
                    showOrgProducts = GC_TestUtils.getTestShowParentProducts();
                }else {
                    showOrgProducts = productService.GetShowOrgProducts(coreSessionId, Integer.valueOf(showOccrProjectId), Integer.valueOf(selectedBooth));
                }
                    products = getProductMap(showOrgProducts);
                    GC_ProductMap newProductMap= new GC_ProductMap();
                    newProductMap.itemsMap= itemsMap;
            } catch (Exception e) {
                GC_PageUtil.AddErrorMessage(e.getMessage());
                system.debug('error at=='+e.getStackTraceString());
                system.debug('error at=='+e.getMessage());
                return null;
            }
        }
        else {
            GC_PageUtil.AddErrorMessage('Job Number is invalid, Cannot proceed with selecting order items.');
        } 
       
        if (got != null) {
            
            System.debug('inside got 1-----------------'+ got.Parent_Category__c);
            selectedCategory = String.isNotBlank(got.Item_Category_ID__c) ? String.valueOf(got.Item_Category_ID__c): null;
            selectedItemNumber = String.isNotBlank(got.Item_Number__c) ? String.valueOf(got.Item_Number__c) : null;
            selectedItemNumberAndDescription = String.isNotBlank(got.Item_Number__c) ? String.valueOf(got.Item_Number__c) + '_' + String.valueOf(got.Description__c) : null;
            selectedParentCategory=String.isNotBlank(got.Parent_Category__c) ? String.valueOf(got.Parent_Category__c): null;
            selectedChildCategory= String.isNotBlank(got.Child_Category__c) ? String.valueOf(got.Child_Category__c): null;
        }
        try {
            PageReference pr = selectCategories();
            return pr;
        } catch(Exception e) {
            GC_PageUtil.AddErrorMessage('Failed to select category: ' + e.getMessage());
            return null;
        }
    }
    
    public Map<String, Map<String, List<String>>> getProductMap(CORE_V1.ArrayOfShowOrgParentCategory products){
        productCategories.clear();
        categoryMap.clear();
        Map<String, Map<String, List<String>>> productsMap= new Map<String, Map<String, List<String>>>();
        itemsMap = new Map<String, GC_ItemHolder>();
        setItemNumber = new set<string>();
        SelectOption noneSelectOption = new SelectOption('', '---None---');
        productCategories.Add(noneSelectOption);    
        
        if (products.ShowOrgParentCategory != null) {
            for (CORE_V1.ShowOrgParentCategory parentCategory : products.ShowOrgParentCategory ) {
                if(!productsMap.containsKey(parentCategory.Name)){
                    //productsMap.put(parentCategory.Name, new Map<String, List<GC_ItemHolder>>());
                    productsMap.put(parentCategory.Name, new Map<String, List<string>>());
                    SelectOption so = new SelectOption(parentCategory.Name, parentCategory.Name);
                    productCategories.Add(so);
                    categoryMap.put(String.valueof(parentCategory.Name), parentCategory.Name);
                    if(parentCategory.ChildCategories !=null){
                        for(CORE_V1.ShowOrgChildCategory childCategory: parentCategory.ChildCategories.ShowOrgChildCategory){
                            if(!productsMap.get(parentCategory.Name).containsKey(childCategory.Name)){
                                //productsMap.get(parentCategory.Name).put(childCategory.Name, new List<GC_ItemHolder>());
                                productsMap.get(parentCategory.Name).put(childCategory.Name, new List<string>());
                            }
                            if(childCategory.Products!=null){
                                for(CORE_V1.ShowOrgProduct product:childCategory.Products.ShowOrgProduct){
                                    GC_ItemHolder productHolder = new GC_ItemHolder(product);
                                    productHolder.ParentCategory = parentCategory.Name;
                                    productHolder.ChildCategory = childCategory.Name;
                                    //productsMap.get(parentCategory.Name).get(childCategory.Name).add(productHolder);
                                    productsMap.get(parentCategory.Name).get(childCategory.Name).add(String.valueOf(productHolder.ItemNumber + '_' + productHolder.ItemDescription));
                                    itemsMap.put(String.valueOf(productHolder.ItemNumber + '_' + productHolder.ItemDescription), productHolder);
                                    setItemNumber.add(productHolder.ItemNumber); 
                                }
                                        
                            }
                            
                        }
                    }
                }
            }
            if (itemsMap.containsKey(selectedItemNumberAndDescription)) {
                selectedItem = itemsMap.get(selectedItemNumberAndDescription);
                                
                //ADDED BY KN 
                if(got != null){
                    got.Parent_Category__c = String.isBlank(got.Parent_Category__c) ? selectedItem.ParentCategory: String.valueOf(got.Parent_Category__c);
                    got.Child_Category__c = String.isBlank(got.Child_Category__c) ? selectedItem.ChildCategory: String.valueOf(got.Child_Category__c);
                }
            }
        }
        
        else{
            GC_PageUtil.AddErrorMessage('Failed to return any products for the booth area.  Can not proceed with Ordering items.');
        }
        return productsMap;
    }
    
      public List<String> getProductList() {
        if (String.isNotBlank(selectedParentCategory)) {
            return products.get(selectedParentCategory).get(selectedChildCategory);
        }
        return null;
    }
    
    public List<GC_ItemHolder> getProductSelected() {
        if (selectedItem != null) {
            List<GC_ItemHolder> retList = new List<GC_ItemHolder>();
            retList.add(selectedItem);
            return retList;
        }
        return null;
    }
    
    public PageReference selectCategories() {
        searchItemClick = '';
         productList.clear();
        if (String.isNotBlank(selectedParentCategory)) {
            childCategories.clear();
            SelectOption noneOption = new SelectOption('' , '--None--');
            childCategories.add(noneOption);
            
            if (products != null && products.containsKey(selectedParentCategory)) {
                //system.debug('key set-----------'+products.get(selectedParentCategory).keySet());
                for (String childCat : products.get(selectedParentCategory).keySet()) {
                    String displayValue = childCat;
                    String uniqueValue = childCat;
                    //system.debug('childCat=='+childCat);
                    SelectOption so = new SelectOption(childCat, childCat);
                    childCategories.add(so);
                }
            }
            itemOptionsTemplate = '';
        }
       selectChildCategories();
        return null;
    }
    
    public PageReference selectChildCategories() {
        searchItemClick = '';
        if (String.isNotBlank(selectedParentCategory) && String.isNotBlank(selectedChildCategory)) {
            productList.clear();
            SelectOption noneOption = new SelectOption('' , '--None--');
            productList.add(noneOption);
            
            if (products != null && products.containsKey(selectedParentCategory)) {
                if(products.get(selectedParentCategory).containsKey(selectedChildCategory)){
                selectedCategory = products.get(selectedParentCategory).get(selectedChildCategory)[0].substringBefore('_');
                    for (String item : products.get(selectedParentCategory).get(selectedChildCategory)) {
                        SelectOption so = new SelectOption(item, item);
                        productList.add(so);
                    }
                }
            }
            
            itemOptionsTemplate = '';
        }
        system.debug('selectedItem==='+selectedItem);
        return null;
    }
    
    public PageReference selectItem() {
        try {
            if(searchItemClick == 'searchItemHidden'){
                if (itemsMap.containsKey(selectedItemNumberAndDescription)) {
                    selectedItem = itemsMap.get(selectedItemNumberAndDescription);
                    got.Booth_Area_Discount__c =  Decimal.valueOf(selectedItem.BoothAreaDiscount);
                    if (got.Item_Template__c != selectedItem.ItemOptionTemplate) {
                        got.QuantityNum__c = null;
                    }
                    got.Item_Template__c = selectedItem.ItemOptionTemplate;
                    got.Item_Number__c = selectedItem.ItemNumber;
                    got.Price__c = selectedItem.Price;
                    got.UOM__c = selectedItem.Units;
                    //-----SY chang to SF
                    if((selectedParentCategory =='Carpet'||got.Item_Template__c == 'Carpet') && (got.UOM__c == 'SY')){
                            got.UOM__c ='SF';
                        }
                    got.Description__c = selectedItem.ItemDescription;
                    got.Item_Category_ID__c = selectedItem.CategoryId;
                    itemOptionsTemplate = got.Item_Template__c;
                    selectedImagePath = selectedItem.ImageUrl;
                    selectedCategory = selectedItem.CategoryId;
                    selectedParentCategory =  selectedItem.ParentCategory;
                    selectedChildCategory = selectedItem.ChildCategory;
                    got.Parent_Category__c= selectedItem.ParentCategory;
                    got.Child_Category__c= selectedItem.ChildCategory;
                } else {
                    selectedItem = null;
                    selectedImagePath = null;
                }
            }
            else
            {
            system.debug('inside second else searchItemClick==='+searchItemClick);

                if (products != null && products.containsKey(selectedParentCategory)) {
                    //Map<String, List<GC_ItemHolder>> productMap = products.get(selectedParentCategory);
                    Map<String, List<String>> productMap = products.get(selectedParentCategory);
                    if (productMap.containsKey(selectedChildCategory)) {
                        currentItems = productMap.get(selectedChildCategory);
                        for(String holder:products.get(selectedParentCategory).get(selectedChildCategory) ){
                            if(selectedItemNumberAndDescription == holder){
                                selectedItem= itemsMap.get(holder);
                            }
                            
                        }
                        got.Booth_Area_Discount__c =  Decimal.valueOf(selectedItem.BoothAreaDiscount);
                        if (got.Item_Template__c != selectedItem.ItemOptionTemplate) {
                            got.QuantityNum__c = null;
                        }
                        got.Item_Template__c = selectedItem.ItemOptionTemplate;
                        //system.debug('selectedItem==='+selectedItem);
                        got.Item_Number__c = selectedItem.ItemNumber;
                        got.Price__c = selectedItem.Price;
                        got.UOM__c = selectedItem.Units;
                        if((selectedParentCategory =='Carpet'||got.Item_Template__c == 'Carpet') && (got.UOM__c == 'SY')){
                            got.UOM__c ='SF';
                        }
                        got.Description__c = selectedItem.ItemDescription;
                        got.Item_Category_ID__c = selectedItem.CategoryId;
                        itemOptionsTemplate = got.Item_Template__c;
                        selectedImagePath = selectedItem.ImageUrl;
                        got.Parent_Category__c= selectedItem.ParentCategory;
                        got.Child_Category__c= selectedItem.ChildCategory;
                    } else {
                        selectedItem = null;
                        selectedImagePath = null;
                    }
                }
                else 
                {
                    selectedItem = null;
                    selectedImagePath = null;
                }
            }
        //system.debug('selectedChildCategory==='+selectedChildCategory );
        }
        catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '' + got));
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getMessage()));
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getStackTraceString()));
        }
        selectCategories();
        return null;
    }
    public void populateProductList() {
        selectedCategory = '';
        productList.clear();
        
        SelectOption so1 = new SelectOption(' ', '--None--');
        productList.add(so1);
        for (GC_ItemHolder item : itemsMap.values()) {
            String displayValue = item.ItemNumber + ' ' + item.ItemDescription;
            String uniqueValue = item.ItemNumber + '_' + item.ItemDescription;
            
            SelectOption so = new SelectOption(uniqueValue, displayValue);
            productList.add(so);
            
        }
    }
   
    public void emptyProductList() {
        productList.clear();
        SelectOption so1 = new SelectOption(' ', '--None--');
        productList.add(so1);
    }
}