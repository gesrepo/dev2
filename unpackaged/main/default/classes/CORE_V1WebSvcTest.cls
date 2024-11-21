//Generated by FuseIT WSDL2Apex (http://www.fuseit.com/Solutions/SFDC-Explorer/Help-WSDL-Parser.aspx)

@isTest
private class CORE_V1WebSvcTest {
    
    @isTest static void coverGeneratedCodeTypes() {
        Test.setMock(WebServiceMock.class, new CORE_V1MockImpl());
        CORE_V1 parentObject = new CORE_V1();
        new CORE_DATA_CONTRACT_SHOW.ArrayOfProductStock();
        new CORE_DATA_CONTRACT_SHOW.ProductStock();
        new CORE_SERIALIZATION_ARRAYS.ArrayOfint();
        new CORE_SERIALIZATION_ARRAYS.ArrayOfKeyValueOfstringstring();
        new CORE_SERIALIZATION_ARRAYS.ArrayOfKeyValueOfstringstring_KeyValueOfstringstring_element();
        new CORE_SERIALIZATION_ARRAYS.ArrayOfstring();
        new CORE_V1.ArrayOfDiscount();
        new CORE_V1.ArrayOfProductColor();
        new CORE_V1.ArrayOfProductGroup();
        new CORE_V1.ArrayOfProductItemOption();
        new CORE_V1.ArrayOfProductPriceRule();
        new CORE_V1.ArrayOfProductSummary();
        new CORE_V1.ArrayOfShowOrgProduct();
        new CORE_V1.ArrayOfViadImage();
        new CORE_V1.ArrayOfShowOrgSpecialProduct();
        new CORE_V1.ArrayOfShowOrgParentCategory();
        new CORE_V1.Discount();
        new CORE_V1.GetShowOrgProducts_element();
        new CORE_V1.GetShowOrgProductsResponse_element();
        new CORE_V1.GetShowProductResponse_element();
        new CORE_V1.GetShowProductGroups_element();
        new CORE_V1.GetShowOrgDiscounts_element(); 
        new CORE_V1.GetShowOrgSpecialProducts_element();
        new CORE_V1.GetShowOrgDiscountsResponse_element(); 
        new CORE_V1.GetShowProductGroupsResponse_element(); 
        new CORE_V1.GetShowOrgSpecialProductsResponse_element();
        new CORE_V1.GetShowProduct_element();       
        new CORE_V1.Product();
        new CORE_V1.ProductColor();
        new CORE_V1.ProductGroup();
        new CORE_V1.ProductItemOption();
        new CORE_V1.ProductPriceRule();
        new CORE_V1.ProductSummary();
        new CORE_V1.ShowOrgProduct();
        new CORE_V1.ShowOrgChildCategory();
        new CORE_V1.ShowOrgParentCategory();
        new CORE_V1.SearchProducts_element();
        new CORE_V1.SearchProductsByGroup_element();
        new CORE_V1.SearchProductsResponse_element();
        new CORE_V1.CheckStockByProjectItems_element();
        new CORE_V1.CheckStockByProjectItemsResponse_element();         
        new CORE_V1.ViadImage();
        new CORE_V1.DeactivateShowOrgSpecialProductResponse_element(); 
        new CORE_V1.SubmitShowOrgSpecialProduct_element(); 
        new CORE_V1.SubmitShowOrgSpecialProductResponse_element();
        new CORE_V1.UpdateProductStockLevel_element();
        new CORE_V1.UpdateProductStockLevelResponse_element();
        new CORE_V1.UpdateShowOrgSpecialProduct_element();
        new CORE_V1.Product();
        new CORE_V1.SearchProductGroupsResponse_element();
        new CORE_V1.ShowOrgSpecialProduct();
        new CORE_V1.UpdateShowOrgSpecialProductResponse_element();
        new CORE_V1.DeactivateShowOrgSpecialProduct_element();
        new CORE_V1.ArrayOfShowOrgChildCategory();
      
    }
    @isTest static void coverCodeForGetShowOrgProducts(){
        Test.setMock(WebServiceMock.class, new CORE_V1MockImpl());
        CORE_V1.BasicHttpBinding_IProductService testObject = new CORE_V1.BasicHttpBinding_IProductService();
        System.assertEquals(null, testObject.GetShowOrgProducts(null, null, null));
    }
    @isTest static void coverCodeForSearchProducts(){
        Test.setMock(WebServiceMock.class, new CORE_V1MockImpl());
        CORE_V1.BasicHttpBinding_IProductService testObject = new CORE_V1.BasicHttpBinding_IProductService();
        System.assertEquals(null, testObject.SearchProducts(null, null, null, null ,null, null, null));
    }
    @isTest static void coverCodeForGetShowOrgDiscounts(){
        Test.setMock(WebServiceMock.class, new CORE_V1MockImpl());
        CORE_V1.BasicHttpBinding_IProductService testObject = new CORE_V1.BasicHttpBinding_IProductService();
        System.assertEquals(null, testObject.GetShowOrgDiscounts(null, null));
    }
    @isTest static void coverCodeForSearchProductGroups(){
        Test.setMock(WebServiceMock.class, new CORE_V1MockImpl());
        CORE_V1.BasicHttpBinding_IProductService testObject = new CORE_V1.BasicHttpBinding_IProductService();
        System.assertEquals(null, testObject.SearchProductGroups(null, null));
    }
    @isTest static void coverCodeForUpdateProductStockLevel(){
        Test.setMock(WebServiceMock.class, new CORE_V1MockImpl());
        CORE_V1.BasicHttpBinding_IProductService testObject = new CORE_V1.BasicHttpBinding_IProductService();
        System.assertEquals(null, testObject.UpdateProductStockLevel(null, null, null, null, null));
    }
    @isTest static void coverCodeForGetShowProduct(){
        Test.setMock(WebServiceMock.class, new CORE_V1MockImpl());
        CORE_V1.BasicHttpBinding_IProductService testObject = new CORE_V1.BasicHttpBinding_IProductService();
        System.assertEquals(null, testObject.GetShowProduct(null, null, null, null));
    }
   @isTest static void coverCodeForGetShowProductGroups(){
        Test.setMock(WebServiceMock.class, new CORE_V1MockImpl());
        CORE_V1.BasicHttpBinding_IProductService testObject = new CORE_V1.BasicHttpBinding_IProductService();
        System.assertEquals(null, testObject.GetShowProductGroups(null, null, null));
    }
    @isTest static void coverCodeForGetShowOrgSpecialProducts(){
        Test.setMock(WebServiceMock.class, new CORE_V1MockImpl());
        CORE_V1.BasicHttpBinding_IProductService testObject = new CORE_V1.BasicHttpBinding_IProductService();
         System.assertEquals(null, testObject.GetShowOrgSpecialProducts(null));
    }
    @isTest static void coverCodeForDeactivateShowOrgSpecialProduct(){
        Test.setMock(WebServiceMock.class, new CORE_V1MockImpl());
        CORE_V1.BasicHttpBinding_IProductService testObject = new CORE_V1.BasicHttpBinding_IProductService();
         System.assertEquals(null, testObject.DeactivateShowOrgSpecialProduct(null, null));
    }
   
}