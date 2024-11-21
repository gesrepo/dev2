@isTest
public class discountSubmissionGatewayTest {
    @isTest
    static void SessionLoginCalloutTest(){
        Test.startTest();
        Test.setMock(WebServiceMock.class, new DiscountWebServiceMock('DiscountSubmission'));
        string sId = discountSubmissionGateway.DiscountSubmission();
        System.assertEquals('TestSessionId', sId);
        Test.stopTest();
    }
     private static Discount__c GetTestDiscount()
    {
        Discount__c disc=new Discount__c();
        Booth_Area__c bc = new Booth_Area__c();
        disc.Booth_Area__c= bc.Id;
        disc.BoothAreaID__c='431202';
        disc.Apply_To_All__c=false;
        disc.LineOfBusiness__c='';
        disc.Discount__c='10';
        disc.DiscountId__c=100;
       
        return disc;
    }
    @isTest
    static void submitDiscountCalloutTest(){
        Test.startTest();
         Discount__c disc = GetTestDiscount();
        Test.setMock(WebServiceMock.class, new DiscountWebServiceMock('submitDiscount'));
        discountSubmissionGateway.submitDiscount('TestSessionId', disc);
        Test.stopTest();
    }
    
    @isTest
    static void updateDiscountCalloutTest(){
        Test.startTest();
         Discount__c disc = GetTestDiscount();
        Test.setMock(WebServiceMock.class, new DiscountWebServiceMock('updateDiscount'));
        discountSubmissionGateway.updateDiscount('TestUpdatedSessionId', disc);
        Test.stopTest();
    }
    
    @isTest
    static void deleteDiscountCalloutTest(){
        Test.startTest();
        Test.setMock(WebServiceMock.class, new DiscountWebServiceMock('deleteDiscount'));
          Discount__c disc= GetTestDiscount();
        discountSubmissionGateway.deleteDiscount('TestPreDeleteSessionId', disc);
        Test.stopTest();
    }
}