@isTest
public class PC_BoothAreaControllerTest {

    @testSetup static void setup(){
        
        GC_Connect2_Show__c Show = GC_TestUtils.getTestConnect2Show();
        system.debug('Show is is@@@'+Show.Id);
        
        Booth_Area__c parentBooth=new Booth_Area__c();
        parentBooth.Name='B001';
        parentBooth.BoothID_Area__c='1001';
        parentBooth.Connect2_Show__c=Show.id;
        parentBooth.Completion_Date_time__c=datetime.newInstance(2014, 9, 15, 12, 30, 0);
        parentBooth.Delivery_Date_time__c=datetime.newInstance(2014, 10, 15, 12, 30, 0);
        parentBooth.Removal_Date_time__c=datetime.newInstance(2014, 11, 15, 12, 30, 0);
        parentBooth.ShowOccrCustomerId__c=10;
        parentBooth.Delivery_Location__c='Test Location';
        parentBooth.Display_Sequence__c='10';
        parentBooth.FacilityId__c='10';
        parentBooth.ShowToCustomer__c=true;
        parentBooth.Zone__c='Z001';
        parentBooth.GroupOrdersByParent__c=true;
        parentBooth.Operations__c='O001';
        parentBooth.GroupOrdersByCategory__c=true;
        insert parentBooth; 
        
        system.debug('insert parentBooth--------'+parentBooth.Id);
        
        Discount__c localDisc= new Discount__c();
        localDisc.DiscountId__c=10;
        localDisc.Booth_Area__c=parentBooth.Id;
        insert localDisc;
        
        GC_Core_Session__c session = new GC_Core_Session__c();
        session.Is_Logged_In__c = true;
        session.Core_Application_Login_Expiration__c = DateTime.now().addMinutes(10);
        INSERT session;
    }
    
    public static testMethod void ConstructorMethod(){
        List<GC_Connect2_Show__c> showList =[select Id from GC_Connect2_Show__c where Show_Name__c = 'test show'];
        Test.setCurrentPage(Page.PC_Refresh_BoothAreaVFButton);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(showList);
        stdSetController.setSelected(showList);
        PC_BoothAreaController ext = new PC_BoothAreaController(stdSetController);
    }
    public static testmethod void constructorMethod2(){        
        GC_Connect2_Show__c Show = [select Id from GC_Connect2_Show__c where Show_Name__c = 'test show'];
        system.debug('Show1 is is@@@'+Show.Id);
        List<Booth_Area__c> tempRecordList=[SELECT Id,Name,BoothID_Area__c,Job_Number__c,Completion_Date_time__c, Deleteable__c,Editable__c,Operations__c ,ShowOccrCustomerId__c,Removal_Date_time__c,ShowToCustomer__c,Zone_Id__c,FacilityId__c,Delivery_Date_time__c,Delivery_Location__c,Display_Sequence__c,Connect2_Show__c FROM Booth_Area__c WHERE Connect2_Show__c=:Show.id];
        ApexPages.StandardController stdSetController = new ApexPages.StandardController(tempRecordList[0]);
        PageReference pageRef = Page.PC_Delete_BoothAreaVFButton;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id', String.valueOf(tempRecordList[0].Id));
        PC_BoothAreaController ext = new PC_BoothAreaController(stdSetController);
        ext.returnToBAUrl = 'login.salesforce.com';
        
    }
    
    public static testMethod void testMethod1(){
        
        
        Booth_Area__c boothArea = [select id,BoothID_Area__c from Booth_Area__c where Name = 'B001'];
        GC_Connect2_Show__c Show = [select Id from GC_Connect2_Show__c where Show_Name__c = 'test show'];
        
        test.startTest();
        PC_BoothAreaController.getCoreSessionID();
        PC_BoothAreaController.performLoginToCore();
        PC_BoothAreaController.asyncGetCoreSessionID();
        PC_BoothAreaController.asyncLoginToCore();
        PC_BoothAreaController.convertTimeToOracle(System.today());
        //PC_BoothAreaController.finalDeleteBoothArea(boothArea.Id);  // //includes mockCallout
        
        test.StopTest();
    }   
    public static testMethod void saveBoothAreaTest(){
        GC_Connect2_Show__c showList=[select id,Name,Job_Number__c from GC_Connect2_Show__c limit 1];
        Booth_Area__c parentBooth=[SELECT id,Name,BoothID_Area__c,Connect2_Show__c,Completion_Date_time__c,Delivery_Date_time__c, Delivery_Location__c, Removal_Date_time__c,ShowOccrCustomerId__c,Display_Sequence__c,FacilityId__c,ShowToCustomer__c,Zone__c,GroupOrdersByParent__c,Operations__c,GroupOrdersByCategory__c FROM Booth_Area__c WHERE (BoothID_Area__c='1001' AND Display_Sequence__c='10' AND FacilityId__c='10' AND Connect2_Show__c=:showList.id )limit 1];
        system.debug('showList fetch-------'+showList.id);
        system.debug('parentBooth--------'+parentBooth.Id);
       
        test.startTest();       
        PC_BoothAreaController.convertTimeToOracle(null);       
        Test.setMock(WebServiceMock.class, new wwwViadComV2MockImpl());
        PC_BoothAreaController.saveBoothArea(parentBooth,'12345678901234567890');
        test.stopTest();        
    }   
    public static testMethod void initializeBoothAreTest(){
        Booth_Area__c boothArea = [select id,BoothID_Area__c from Booth_Area__c where Name = 'B001'];
        GC_Connect2_Show__c Show = [select Id from GC_Connect2_Show__c where Show_Name__c = 'test show'];
        system.debug('Show2 is is@@@'+Show.Id);
       
        test.startTest();
        Test.setMock(WebServiceMock.class, new wwwViadComV2MockImpl());
        PC_BoothAreaController.initializeBoothAre(boothArea.Id,Show.Id);  //includes mockCallout
        test.stopTest();
    }
    
    public static testMethod void getBoothAreasFromCoreTest(){
        Booth_Area__c boothArea = [select id,BoothID_Area__c,Name from Booth_Area__c where Name = 'B001'];
        GC_Connect2_Show__c Show = [select id,Name,Job_Number__c,Show_Name__c from GC_Connect2_Show__c where Show_Name__c = 'test show'];
        system.debug('Show2 is is@@@'+Show.Id);
       
        test.startTest();
        Test.setMock(WebServiceMock.class, new wwwViadComV2MockImpl());
        //PC_BoothAreaController.finalDeleteBoothArea(boothArea.Id);  // //includes mockCallout
        PC_BoothAreaController.getBoothAreasFromCore(Show.Id);
        PC_BoothAreaController.refreshBoothAreasFromCore(Show.Id);
        test.stopTest();
    }
    public static testMethod void deleteBoothAreaTest(){
        Booth_Area__c boothArea = [select id,BoothID_Area__c from Booth_Area__c where Name = 'B001'];
        GC_Connect2_Show__c Show = [select id,Name,Job_Number__c from GC_Connect2_Show__c where Show_Name__c = 'test show'];
        system.debug('Show2 is is@@@'+Show.Id);
       
        test.startTest();
        Test.setMock(WebServiceMock.class, new wwwViadComV2MockImpl());
        PC_BoothAreaController.finalDeleteBoothArea(boothArea.Id);  // //includes mockCallout        
        test.stopTest();
    }
    
    
}