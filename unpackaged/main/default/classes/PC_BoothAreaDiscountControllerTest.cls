@isTest
public class PC_BoothAreaDiscountControllerTest {
    @testSetup static void setup(){
        Booth_Area__c parentBooth=new Booth_Area__c(BoothID_Area__c='1001');
        insert parentBooth;
         Booth_Area__c parentBooth1=new Booth_Area__c(BoothID_Area__c='1001');
        insert parentBooth1;
         Booth_Area__c parentBooth2=new Booth_Area__c(BoothID_Area__c='1001');
        insert parentBooth2;
         Booth_Area__c parentBooth3=new Booth_Area__c(BoothID_Area__c='1001');
        insert parentBooth3;
        
        Discount__c localDisc= new Discount__c(DiscountId__c=10,Booth_Area__c=parentBooth.id);
        insert localDisc;
        
        GC_Core_Session__c session = new GC_Core_Session__c();
        session.Is_Logged_In__c = true;
        session.Core_Application_Login_Expiration__c = DateTime.now().addMinutes(10);
        INSERT session;
       
    }  
    public static testMethod void ConstructorMethod(){
        List<Discount__c> localDiscount=[select id,DiscountId__c from Discount__c where DiscountId__c=10];
        ApexPages.StandardController stdSetController = new ApexPages.StandardController(localDiscount[0]);
          PageReference pageRef = Page.PC_DeleteDiscountVf;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id', String.valueOf(localDiscount[0].Id));
        PC_BoothAreaDiscountController ext = new PC_BoothAreaDiscountController(stdSetController);
    }
    
    public static testMethod void testLoginMethods(){
        PC_BoothAreaDiscountController.getCoreSessionID();
    }
    public static testMethod void testLoginMethods2(){
        PC_BoothAreaDiscountController.performLoginToCore();
    }
    public static testMethod void discountSubmissionTest(){
        Discount__c localDiscount=[select id,DiscountId__c from Discount__c where DiscountId__c=10];
        List<Booth_Area__c> parentBooth=[SELECT id,BoothID_Area__c,  Connect2_Show__c, Connect2_Show__r.Job_Number__c FROM Booth_Area__c WHERE BoothID_Area__c= '1001'];
        Test.setMock(WebServiceMock.class, new wwwViadComV2MockImpl());
        test.startTest();
       string discountfrmbooth=PC_BoothAreaDiscountController.discountSubmission(parentBooth[0].id,string.valueof(localDiscount.id),true,'10','L001','12345678901234567890');
        test.stopTest();
    }
    public static testMethod void deleteRecordsFromCoreTest(){
     Discount__c localDiscount=[select id,DiscountId__c from Discount__c where DiscountId__c=10];
        test.startTest();
        Test.setMock(WebServiceMock.class, new wwwViadComV2MockImpl());
        try{
        PC_BoothAreaDiscountController.deleteRecordsFromCore(string.valueof(localDiscount.id));
        }catch(Exception e){}
        test.stopTest();
    }
     public static testMethod void getBoothIdForDiscountTest(){
     Discount__c localDiscount=[select id,DiscountId__c,Booth_Area__c from Discount__c where DiscountId__c=10];
         system.debug('localDiscount'+localDiscount);
        test.startTest();
      string result= PC_BoothAreaDiscountController.getBoothIdForDiscount(localDiscount.id,localDiscount.Booth_Area__c);
        test.stopTest();
    }
}