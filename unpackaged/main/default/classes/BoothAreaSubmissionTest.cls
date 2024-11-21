@isTest
public class BoothAreaSubmissionTest {
    @isTest
    static void SessionLoginCalloutTest(){
        Test.startTest();
        Test.setMock(WebServiceMock.class, new BoothAreaWebServiceMock('SessionLogin'));
        string sId = TestBoothAreaSubmission.SessionLogin();
        System.assertEquals('TestSessionId', sId);
        Test.stopTest();
    }
    
    @isTest
    static void GetDispalySequenceCalloutTest(){
        Test.startTest();
        Test.setMock(WebServiceMock.class, new BoothAreaWebServiceMock('GetDispalySequence'));
        decimal maxValue = TestBoothAreaSubmission.GetDispalySequence('TestSessionId', 'PROJ123');
        System.assertEquals(1000, maxValue);
        Test.stopTest();
    }
    
    @isTest
    static void showOccurCustomerDisplayCalloutTest(){
        Test.startTest();
        Test.setMock(WebServiceMock.class, new BoothAreaWebServiceMock('ShowOccurCustomerDisplay'));
        set<Integer> occurances = TestBoothAreaSubmission.showOccurCustomerDispaly('TestSessionId', 'PROJ123');
        Test.stopTest();
    }
    
    private static Booth_Area__c GetTestBoothArea(){
        Booth_Area__c bc=new Booth_Area__c();
        bc.Name='MATERIAL HANDLING';
        bc.BoothID_Area__c='431202';
        bc.Completion_Date_time__c=system.today();
        bc.Deleteable__c=false;
        bc.Delivery_Date_time__c=system.today();
        bc.Delivery_Location__c='Bangalore';
        bc.Display_Sequence__c=string.valueOf(1010);
        bc.Editable__c=true;
        bc.FacilityId__c=string.valueOf(1291);
        bc.Job_Number__c=string.valueOf(071079249);
        bc.Removal_Date_time__c=system.today();
        bc.ShowOccrCustomerId__c=349334;
        bc.ShowToCustomer__c=true;
        bc.Zone_Id__c='B1';
        //Booth area Insertion
        return bc;
    }
    
    @isTest
    static void SubmitBoothAreaCalloutTest(){
        Test.startTest();
        Booth_Area__c bc = GetTestBoothArea();
        Test.setMock(WebServiceMock.class, new BoothAreaWebServiceMock('SubmitBoothArea'));
        TestBoothAreaSubmission.submitBoothArea('TestSessionId', bc);
        Test.stopTest();
    }
    
    @isTest
    static void UpdateBoothAreaCalloutTest(){
        Test.startTest();
        Booth_Area__c bc = GetTestBoothArea();
        Test.setMock(WebServiceMock.class, new BoothAreaWebServiceMock('UpdateBoothArea'));
        TestBoothAreaSubmission.updataBooth('TestUpdatedSessionId', bc);
        Test.stopTest();
    }
    
    @isTest
    static void DeleteBoothAreaCalloutTest(){
        Test.startTest();
        Test.setMock(WebServiceMock.class, new BoothAreaWebServiceMock('DeleteBoothArea'));
        Booth_Area__c bc = GetTestBoothArea();
        TestBoothAreaSubmission.DeleteBoothArea('TestPreDeleteSessionId', bc);
        Test.stopTest();
    }
    
    @isTest
    static void DeleteBoothAreaCalloutTest1(){
        Test.startTest();
        wwwViadComV2.BasicHttpBinding_IShowOrganizerService BasicHttpBinding_IShowOrganizerService = new wwwViadComV2.BasicHttpBinding_IShowOrganizerService();
        Test.setMock(WebServiceMock.class, new BoothAreaWebServiceMock('SubmitBoothAreas'));
        wwwViadComV2.ArrayOfBoothArea boothAreas = new wwwViadComV2.ArrayOfBoothArea();
        BasicHttpBinding_IShowOrganizerService.SubmitBoothAreas('TestPreDeleteSessionId', boothAreas);
        Test.stopTest();
    }
}