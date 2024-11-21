/**
* @author Ethos Solutions - www.ethos.com
* @description Test code for Design Element DAO
* 2016-04-13 : Original Version
**/
@isTest
public class GC_DesignElementDaoTest {
    public static testMethod void DesignElementDaoTest() {
        GC_Connect2_Show__c cShow = new GC_Connect2_Show__c();
        insert cShow;
        GC_Design_Request_Form__c drf = new GC_Design_Request_Form__c(Connect2_Show__c = cShow.Id);
        insert drf;
        GC_Design_Element__c numRev = new GC_Design_Element__c(Connect2_Show__c = cShow.Id);
        numRev.Revision__c = 1;
        insert numRev;
        GC_Design_Element__c de = new GC_Design_Element__c(Connect2_Show__c = cShow.Id);
        insert de;
        String stringId = de.Id;
        GC_Design_Element__c methodValue = GC_DesignElementDao.getInstance().getDesignElementById(stringId);
        System.assertEquals(stringId, methodValue.Id, 'Sign order task Id should match methodValue.Id');
    }
}