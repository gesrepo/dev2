@isTest
public class RedirectToDiscountEditPage_Test {
    public static testMethod void testMethod1() {
        GC_Connect2_Show__c connect2 = GC_TestUtils.getTestConnect2Show();
         Discount__c disc = GC_TestUtils.getTestDiscount();
        insert disc;
        Booth_Area__c ba = [select Connect2_Show__c from Booth_Area__c where id=: disc.Booth_Area__c limit 1];
        ba.Connect2_Show__c = connect2.Id;
        update ba;
        ApexPages.StandardController dc = new ApexPages.StandardController(disc);
        Test.startTest(); 
        ApexPages.currentPage().getParameters().put('Id',disc.Booth_Area__c);
        RedirectToDiscountEditPage discount = new RedirectToDiscountEditPage(dc);
        Test.stopTest(); 
    }
}