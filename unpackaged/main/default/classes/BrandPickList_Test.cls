@isTest
public class BrandPickList_Test {
    static TestMethod void testPopulatePicklistMap() {
        BrandPickList testObj= new BrandPickList();
        Map<String, Map<String,String>> testMapBrandPicklist= BrandPickList.populatePicklistMap();
    }
}