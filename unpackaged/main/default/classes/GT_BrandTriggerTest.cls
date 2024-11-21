@isTest(SeeAllData=true)
public class GT_BrandTriggerTest {
    public static testMethod void testMethod1() {
        User u=[select id from user where id='0051W000004H9WM'];
        System.runAs(u){
            GT_Event__c evt=new GT_Event__c(currencyisocode='USD');
            insert evt;
            GT_Brand__c brand=new GT_Brand__c(GES_Connect_Event__c=evt.id);
            insert brand;
        }
    }

}