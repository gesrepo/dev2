/**
* @author Ethos Solutions - www.ethos.com
* @description Test code for Design Request Form DAO
* 2016-04-13 : Original Version
**/
@isTest
public class GC_DesignRequestFormDao_Test {
    public static testMethod void GC_DesignRequestFormDao_Test() {
        GC_Connect2_Show__c cShow = new GC_Connect2_Show__c();
        insert cShow;
        GC_Design_Request_Form__c drf = new GC_Design_Request_Form__c(Connect2_Show__c = cShow.Id);
        insert drf;
        String stringId = drf.Id;
        GC_Design_Request_Form__c methodValue = GC_DesignRequestFormDao.getInstance().getDesignRequestFormById(stringId);
        System.assertEquals(stringId, methodValue.Id, 'Design Request Form Id should match methodValue.Id');
    }
}