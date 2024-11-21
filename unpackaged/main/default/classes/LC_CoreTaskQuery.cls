public with sharing class LC_CoreTaskQuery {
    @AuraEnabled
    public static ProductListWrapper obtainProducts(String showProjectNumber, string boothAreaId, string coreSessionId) {
        String showOccrProjectId;
        
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
        }catch (CalloutException ce) {
            throw new AuraHandledException(ce.getMessage());
        }
        catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
        CORE_V4.BasicHttpBinding_IProductService productService = new CORE_V4.BasicHttpBinding_IProductService();
        try {
            CORE_V4.ArrayOfShowOrgParentCategory showOrgProducts;
            if (Test.isRunningTest()) {
                showOrgProducts = GC_TestUtils.getTestShowParentProducts2();
            }else {
                showOrgProducts = productService.GetShowOrgProducts(coreSessionId, Integer.valueOf(showOccrProjectId), Integer.valueOf(boothAreaId));
            }
            ProductListWrapper products = getProductMap(showOrgProducts);
            return products;
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    public static ProductListWrapper getProductMap(CORE_V4.ArrayOfShowOrgParentCategory products){
        ProductListWrapper resultObj= new ProductListWrapper();
        if (products.ShowOrgParentCategory != null) {
            for (CORE_V4.ShowOrgParentCategory parentCategory : products.ShowOrgParentCategory ) {
                if(!resultObj.mainToSubCatMap.containsKey(parentCategory.Name)){
                    resultObj.mainToSubCatMap.put(parentCategory.Name, new List<string>());
                }
                resultObj.prodCatList.add(parentCategory.Name);
                for(CORE_V4.ShowOrgChildCategory childCategory: parentCategory.ChildCategories.ShowOrgChildCategory){
                    resultObj.mainToSubCatMap.get(parentCategory.Name).add(childCategory.Name);          
                    if(childCategory.Products!=null){
                        if(!resultObj.subCatToProductMap.containsKey(childCategory.Name)){
                            resultObj.subCatToProductMap.put(childCategory.Name, new List<String>());
                        }
                        for(CORE_V4.ShowOrgProduct product:childCategory.Products.ShowOrgProduct){              
                            LC_ItemHolder productHolder = new LC_ItemHolder(product);
                            system.debug('productHolder ContractPrice v4:: '+product.ContractPrice);
                            productHolder.ContractPrice = String.valueOf(product.ContractPrice);
                            productHolder.ParentCategory = parentCategory.Name;
                            productHolder.ChildCategory = childCategory.Name;
                            resultObj.itemDescToProductMap.put(String.valueOf(productHolder.ItemNumber + '_' + productHolder.ItemDescription), productHolder);
                            resultObj.subCatToProductMap.get(childCategory.Name).add(String.valueOf(productHolder.ItemNumber + '_' + productHolder.ItemDescription));
                        }            
                    }                       
                }
            }
        }
        return resultObj;
    }
    
    public class ProductListWrapper {
        /*@AuraEnabled List<string> prodCatList {get;set;}
        @AuraEnabled Map<string,List<string>> mainToSubCatMap {get;set;}
        @AuraEnabled Map<string,List<string>> subCatToProductMap {get;set;}
        @AuraEnabled Map<string,LC_ItemHolder> itemDescToProductMap {get;set;}*/  //Amarab 04/30/2021 Apex property can’t have a private or protected access modifier.
        
        @AuraEnabled public List<string> prodCatList {get;set;}
        @AuraEnabled public Map<string,List<string>> mainToSubCatMap {get;set;}
        @AuraEnabled public Map<string,List<string>> subCatToProductMap {get;set;}
        @AuraEnabled public Map<string,LC_ItemHolder> itemDescToProductMap {get;set;}
        
        public ProductListWrapper(){
            this.mainToSubCatMap= new Map<string,List<string>>();
            this.subCatToProductMap= new Map<string,List<string>>();
            this.itemDescToProductMap= new Map<string,LC_ItemHolder>();
            this.prodCatList = new List<String>();
        }
    }
    
    public class LC_SubCatProdWrapper {
        @AuraEnabled
        public String ChildCategory { get; set; }
        @AuraEnabled
        public List<String> products {get; set; }
        public LC_SubCatProdWrapper(string childCat, List<String> prods){
            ChildCategory = childCat;
            products = new List<String>();
            if(prods.size() > 0)
                products = prods;
        }
        public LC_SubCatProdWrapper(){}
    }
    
    public class LC_ItemHolder {
        @AuraEnabled
        public String Category { get; set; }
        @AuraEnabled
        public String CategoryId { get; set; }
        @AuraEnabled
        public String ChildCategory { get; set; }
        @AuraEnabled
        public String InventoryItemId { get; set; }
        @AuraEnabled
        public String ItemNumber { get; set; }
        @AuraEnabled
        public String ItemDescription { get; set; }
        @AuraEnabled
        public String ItemOptionTemplate { get; set; }
        @AuraEnabled
        public String ImageUrl { get; set; }
        @AuraEnabled
        public String ItemType { get; set; }
        @AuraEnabled
        public String LineOfBusiness { get; set; }
        @AuraEnabled
        public String ParentCategory { get; set; }
        @AuraEnabled
        public String Price { get; set; }
        @AuraEnabled
        public String Units { get; set; }
        @AuraEnabled
        public String TaxRate { get; set; }
        @AuraEnabled
        public String BoothAreaDiscount { get; set; }
        @AuraEnabled
        public String ContractPrice { get; set; }
        
        public LC_ItemHolder(CORE_V4.ShowOrgProduct orgProduct) {
            InventoryItemId = String.valueOf(orgProduct.InventoryItemId);
            ItemNumber = orgProduct.ItemNumber;
            ItemDescription = orgProduct.ItemDescription;
            ImageUrl = orgProduct.ImageUrl;
            ItemOptionTemplate = orgProduct.ItemOptionTemplate;
            Price = String.valueOf(orgProduct.Price);
            Units = orgProduct.UOM;
            TaxRate = String.valueOf(orgProduct.TaxRate);
            BoothAreaDiscount = String.valueOf(orgproduct.DiscountPercentage);
            ContractPrice = String.valueOf(orgProduct.ContractPrice);
        }
    }
}