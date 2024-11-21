@isTest
public class GC_CongressCalendarControllerTest {
    
    public static testMethod void getShowsTest() {
        Exhibit__c parentExhibit = GC_TestUtils.getTestExhibit();
        Brand__c singleBrand ;
        
        Brand__c brand = new Brand__c();
        brand.Brand_Name__c = 'Acrodat';
        brand.Brand_Category__c= 'Rare Diseases';
        brand.Business_Unit__c= 'PIH';
        brand.GES_Congress_Manager__c = 'McCartney, Eva';       
        brand.Brand_Team_Contact__c = 'Adamczyk, Alice';
        brand.Company_Code__c  = '12345';  
        brand.Cost_Center__c  =67894;  
        brand.Funding_Provider_Department__c  = 'Medical';  
        brand.Funding_Provider_Region__c  = 'Global';  
        brand.Funding_Provider_Brand__c  = 'Acrodat';
        
        GES_Connect_Corporate_Accounts__c ca = new GES_Connect_Corporate_Accounts__c();
        ca.Id = parentExhibit.Activity_Type_Exhibit_Instance_c__c;
        ca.Congress_Start_Date__c = Date.today() + 2;
        update ca;
        brand.GES_Connect_Corporate_Accounts__c= ca.Id;// parentExhibit.Activity_Type_Exhibit_Instance_c__c ;
        brand.Exhibit_Instance__c = parentExhibit.id;
        brand.canceled__c=false;
        insert brand;
        
        GC_CongressCalendarController serCong=new GC_CongressCalendarController();
        serCong.searchCongressWithFilter();
        serCong.getDateString(Date.today());
        serCong.save();
        serCong.setDate();
        serCong.resetSearch();
        serCong.searchCongress('queryString');
        serCong.sortColumn();
        serCong.sortOrder='asc';
        serCong.inputBrand ='Test';
        serCong.inputStartDate = Date.today();
        serCong.congressDate = Date.today();
        serCong.congressToDate = Date.today();
        serCong.nullsOrder='nulls last';
        serCong.initialOrderByClause ='orderByClause';
    }
}