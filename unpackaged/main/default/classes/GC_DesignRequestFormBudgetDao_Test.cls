/**
* @author Ethos Solutions - www.ethos.com
* @description Test code for Design Request Form budget DAO
* 2016-04-13 : Original Version
**/
@isTest
public class GC_DesignRequestFormBudgetDao_Test {
    public static testMethod void GC_DesignRequestFormBudgetDao_Test() {
        GC_Connect2_Show__c cShow = new GC_Connect2_Show__c();
        insert cShow;
        GC_Design_Request_Form__c drf = new GC_Design_Request_Form__c(Connect2_Show__c = cShow.Id);
        insert drf;
        GC_Design_Request_Form_Budget__c numRev = new GC_Design_Request_Form_Budget__c(Design_Request_Form__c = drf.Id);
        numRev.Revision__c = 0;
        insert numRev;
        //GC_Design_Request_Form_Budget__c drfBudget = new GC_Design_Request_Form_Budget__c(Design_Request_Form__c = drf.Id);
        //insert drfBudget;
        String stringId = numRev.Id;
        List<GC_Design_Request_Form_Budget__c> methodValues = GC_DesignRequestFormBudgetDao.getInstance().getByDrfId(stringId);
        for (GC_Design_Request_Form_Budget__c methodValue : methodValues) {
            System.assertEquals(stringId, methodValue.Id, 'Design Request Form Id should match methodValue.Id');
        }
    }
}