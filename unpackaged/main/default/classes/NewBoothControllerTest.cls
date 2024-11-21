@isTest
public class NewBoothControllerTest {
    
    private static GC_Connect2_Show__c show;
    private static Booth_Area__c bc;
    
    /*public NewBoothControllerTest()
    {
        show = GC_TestUtils.getTestConnect2Show();
        bc = GetTestBoothArea(show);
    }*/
    
    @isTest
    static void NewBoothController_Test(){
        
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        GetTestBoothArea(show);
        Booth_Area__c bc = GetTestBoothArea(show);
        PageReference pageRef = Page.Newboothcreation;
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(show);
        ApexPages.currentPage().getParameters().put('Id',show.Id);
        ApexPages.currentPage().getParameters().put('BoothId',bc.Id);
        Test.startTest();
        Test.setMock(WebServiceMock.class, new BoothAreaWebServiceMock('SessionLogin'));
        
        NewBoothController booth=new NewBoothController(sc);
        Test.stopTest();
    }
    
    private static Booth_Area__c GetTestBoothArea(GC_Connect2_Show__c show)
    {
        Booth_Area__c bc=new Booth_Area__c();
        bc.Name='MATERIAL HANDLING';
        bc.BoothID_Area__c='431202';
        bc.Completion_Date_time__c=system.today();
        bc.Connect2_Show__c=show.Id;
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
        return bc;
    }
    
    /*@isTest
    public static void oracleSubmission(){
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        NewBoothController booth=new NewBoothController(new ApexPages.StandardController(show));
        //ApexPages.currentPage().getParameters().put('newId',show.Id);
        //ApexPages.currentPage().getParameters().put('boothId',bc.Id);
        Test.setMock(WebServiceMock.class, new BoothAreaWebServiceMock('SessionLogin'));
        Test.setMock(WebServiceMock.class, new BoothAreaWebServiceMock('SubmitBoothArea'));
        PageReference pageRef = Page.Newboothcreation;
        Test.setCurrentPage(pageRef);
        booth.oracleSubmission();
        
    }*/
    
    @isTest
    public static void NewBoothControllerMethod1(){
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        GetTestBoothArea(show);
        Booth_Area__c bc = GetTestBoothArea(show);
        insert bc;
        PageReference pageRef = Page.Newboothcreation;
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(show);
        ApexPages.currentPage().getParameters().put('Id',show.Id);
        ApexPages.currentPage().getParameters().put('BoothId',bc.Id);
        Test.startTest();
        Test.setMock(WebServiceMock.class, new BoothAreaWebServiceMock('SessionLogin'));
        
        NewBoothController booth=new NewBoothController(sc);
        Test.setMock(WebServiceMock.class, new BoothAreaWebServiceMock('DeleteBoothAreaDiscount'));
        booth.oracleDelete();
        Test.stopTest();
    }
    
    @isTest
    public static void NewBoothControllerMethod2(){
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        GetTestBoothArea(show);
        Booth_Area__c bc = GetTestBoothArea(show);
        insert bc;
        PageReference pageRef = Page.Newboothcreation;
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(show);
        ApexPages.currentPage().getParameters().put('Id',show.Id);
        ApexPages.currentPage().getParameters().put('BoothId',bc.Id);
        Test.startTest();
        Test.setMock(WebServiceMock.class, new BoothAreaWebServiceMock('SessionLogin'));
        
        NewBoothController booth=new NewBoothController(sc);
        Test.setMock(WebServiceMock.class, new BoothAreaWebServiceMock('UpdateBoothArea'));
        booth.oracleUpdate();
        Test.stopTest();
    }
    
    @isTest
    public static void NewBoothControllerMethod3(){
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        GetTestBoothArea(show);
        Booth_Area__c bc = GetTestBoothArea(show);
        insert bc;
        PageReference pageRef = Page.Newboothcreation;
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(show);
        ApexPages.currentPage().getParameters().put('Id',show.Id);
        ApexPages.currentPage().getParameters().put('BoothId',bc.Id);
        Test.startTest();
        Test.setMock(WebServiceMock.class, new BoothAreaWebServiceMock('SessionLogin'));
        
        NewBoothController booth=new NewBoothController(sc);
        booth.oracleDelete();
        Test.stopTest();
    }
    
}