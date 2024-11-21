@isTest
private class wwwViadComV2WebSvcTest {

    @isTest static void coverGeneratedCodeTypes() {
        Test.setMock(WebServiceMock.class, new wwwViadComV2MockImpl());
        wwwViadComV2 parentObject = new wwwViadComV2();
        new CORE_DATA_CONTRACT_SYSTEM.DateTimeOffset();
        new CORE_SERIALIZATION_ARRAYS.ArrayOfint();
        new CORE_SERIALIZATION_ARRAYS.ArrayOfKeyValueOfstringstring();
        new CORE_SERIALIZATION_ARRAYS.ArrayOfKeyValueOfstringstring_KeyValueOfstringstring_element();
        new CORE_SERIALIZATION_ARRAYS.ArrayOfstring();
        new wwwViadComV2.ArrayOfBoothArea();
        new wwwViadComV2.ViadImage();
        new wwwViadComV2.Facility();
        new wwwViadComV2.ShowOrganizer();
        new wwwViadComV2.BoothArea();
        new wwwViadComV2.ShowProject();
        new wwwViadComV2.BoothAreaDiscount();
        new wwwViadComV2.ArrayOfBoothAreaDiscount();
        new wwwViadComV2.ArrayOfShowOrganizer();
        new wwwViadComV2.DeleteBoothAreaDiscount_element();
        new wwwViadComV2.SubmitBoothAreaResponse_element();
        new wwwViadComV2.UpdateBoothAreaDiscount_element();
        new wwwViadComV2.SubmitBoothArea_element();
        new wwwViadComV2.DeleteBoothArea_element();
        new wwwViadComV2.GetOperationsZonesResponse_element();
        new wwwViadComV2.SubmitBoothAreaDiscountResponse_element();
        new wwwViadComV2.GetBoothAreasResponse_element();
        new wwwViadComV2.GetProjectByProjectNumber_element();
        new wwwViadComV2.GetProjectByProjectNumberResponse_element();
        new wwwViadComV2.GetBoothAreas_element();
        new wwwViadComV2.DeleteBoothAreaResponse_element();
        new wwwViadComV2.GetOperationsZones_element();
        new wwwViadComV2.SubmitBoothAreasResponse_element();
        new wwwViadComV2.SubmitBoothAreaDiscount_element();
        new wwwViadComV2.UpdateBoothAreaResponse_element();
        new wwwViadComV2.UpdateBoothArea_element();
        new wwwViadComV2.DeleteBoothAreaDiscountResponse_element();
        new wwwViadComV2.UpdateBoothAreaDiscountResponse_element();
        new wwwViadComV2.SubmitBoothAreas_element();
        
    }
    @isTest static void coverCodeForGetOperationsZones(){
        Test.setMock(WebServiceMock.class, new wwwViadComV2MockImpl());
        wwwViadComV2.BasicHttpBinding_IShowOrganizerService testObject = new wwwViadComV2.BasicHttpBinding_IShowOrganizerService();
        System.assertEquals(null, testObject.GetOperationsZones(null, null));
    }
    @isTest static void coverCodeForGetProjectByProjectNumber(){
        Test.setMock(WebServiceMock.class, new wwwViadComV2MockImpl());
        wwwViadComV2.BasicHttpBinding_IShowOrganizerService testObject = new wwwViadComV2.BasicHttpBinding_IShowOrganizerService();
        testObject.GetProjectByProjectNumber(null, null);
        // Assert is no longer valid due to change in CORE_V2MockImpl class
        //System.assertEquals(null, testObject.GetShowProjectByProjectNumber(null, null););
    }
    @isTest static void coverCodeForDeleteBoothArea(){
        Test.setMock(WebServiceMock.class, new wwwViadComV2MockImpl());
        wwwViadComV2.BasicHttpBinding_IShowOrganizerService testObject = new wwwViadComV2.BasicHttpBinding_IShowOrganizerService();
        testObject.DeleteBoothArea(null, null);
    }
    @isTest static void coverCodeForDeleteBoothAreaDiscount(){
        Test.setMock(WebServiceMock.class, new wwwViadComV2MockImpl());
        wwwViadComV2.BasicHttpBinding_IShowOrganizerService testObject = new wwwViadComV2.BasicHttpBinding_IShowOrganizerService();
        testObject.DeleteBoothAreaDiscount(null, null);
    }
    @isTest static void coverCodeForSubmitBoothArea(){
        Test.setMock(WebServiceMock.class, new wwwViadComV2MockImpl());
        wwwViadComV2.BasicHttpBinding_IShowOrganizerService testObject = new wwwViadComV2.BasicHttpBinding_IShowOrganizerService();
        testObject.SubmitBoothArea(null, null);
    }
    @isTest static void coverCodeForUpdateBoothArea(){
        Test.setMock(WebServiceMock.class, new wwwViadComV2MockImpl());
        wwwViadComV2.BasicHttpBinding_IShowOrganizerService testObject = new wwwViadComV2.BasicHttpBinding_IShowOrganizerService();
        testObject.UpdateBoothArea(null, null);
    }
    @isTest static void coverCodeForUpdateBoothAreaDiscount(){
        Test.setMock(WebServiceMock.class, new wwwViadComV2MockImpl());
        wwwViadComV2.BasicHttpBinding_IShowOrganizerService testObject = new wwwViadComV2.BasicHttpBinding_IShowOrganizerService();
        testObject.UpdateBoothAreaDiscount(null, null);
    }
    @isTest static void coverCodeForSubmitBoothAreaDiscount(){
        Test.setMock(WebServiceMock.class, new wwwViadComV2MockImpl());
        wwwViadComV2.BasicHttpBinding_IShowOrganizerService testObject = new wwwViadComV2.BasicHttpBinding_IShowOrganizerService();
        testObject.SubmitBoothAreaDiscount(null, null);
    }
}