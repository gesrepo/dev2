@isTest
public class DiscountControllerTest {
   Private Static Discount__c ds;
     @isTest
    static  void discountTest(){
    
        GC_Connect2_Show__c connect2 = GC_TestUtils.getTestConnect2Show();
        Discount__c disc = GC_TestUtils.getTestDiscount();
        insert disc;
        Booth_Area__c ba = [select Connect2_Show__c from Booth_Area__c where id=: disc.Booth_Area__c limit 1];
        ba.Connect2_Show__c = connect2.Id;
        update ba;
        ApexPages.StandardController dc = new ApexPages.StandardController(disc);
       Test.startTest(); 
        ApexPages.currentPage().getParameters().put('Id',disc.Booth_Area__c);
        DiscountController discount = new DiscountController(dc);
        PageReference pr = Page.NewDiscountFromBoothArea;
              
         ApexPages.currentPage().getParameters().put('discountId',disc.Id);
         Test.setMock(WebServiceMock.class, new DiscountWebServiceMock('DiscountSubmission'));
         DiscountController discount1 = new DiscountController(dc);
         Test.setMock(WebServiceMock.class, new DiscountWebServiceMock('SubmitDiscount'));
         for(Discount__c d : discount1.finalDiscount) {
             d.Discount__c = '10.0';
             d.BoothAreaID__c = '12345';
         }
         discount1.discountSubmission();
         Test.stopTest();
    }
    
    @isTest
    static  void discountTest2(){
    
        GC_Connect2_Show__c connect2 = GC_TestUtils.getTestConnect2Show();
        Discount__c disc = GC_TestUtils.getTestDiscount();
        insert disc;
        Booth_Area__c ba = [select Connect2_Show__c from Booth_Area__c where id=: disc.Booth_Area__c limit 1];
        ba.Connect2_Show__c = connect2.Id;
        update ba;
        ApexPages.StandardController dc = new ApexPages.StandardController(disc);
       Test.startTest(); 
        ApexPages.currentPage().getParameters().put('Id',disc.Booth_Area__c);
        DiscountController discount = new DiscountController(dc);
        PageReference pr = Page.NewDiscountFromBoothArea;
         ApexPages.currentPage().getParameters().put('discountId',disc.Id);
         Test.setMock(WebServiceMock.class, new DiscountWebServiceMock('DiscountSubmission'));
         DiscountController discount1 = new DiscountController(dc);
         
         for(Discount__c d : discount1.finalDiscount) {
             d.Discount__c = '10.0';
             d.BoothAreaID__c = '12345';
         }
         discount1.discountUpdate();
         Test.stopTest();
    }
    @isTest
    static  void discountTest3(){
    
        GC_Connect2_Show__c connect2 = GC_TestUtils.getTestConnect2Show();
        Discount__c disc = GC_TestUtils.getTestDiscount();
        insert disc;
        Booth_Area__c ba = [select Connect2_Show__c from Booth_Area__c where id=: disc.Booth_Area__c limit 1];
        ba.Connect2_Show__c = connect2.Id;
        update ba;
        ApexPages.StandardController dc = new ApexPages.StandardController(disc);
       Test.startTest(); 
        ApexPages.currentPage().getParameters().put('Id',disc.Booth_Area__c);
        DiscountController discount = new DiscountController(dc);
        PageReference pr = Page.NewDiscountFromBoothArea;
              
         ApexPages.currentPage().getParameters().put('discountId',disc.Id);
         Test.setMock(WebServiceMock.class, new DiscountWebServiceMock('DiscountSubmission'));
         DiscountController discount1 = new DiscountController(dc);
         Test.setMock(WebServiceMock.class, new DiscountWebServiceMock('DeleteDiscount'));
         discount1.discountDelete();
         Test.stopTest();
    }
     
}