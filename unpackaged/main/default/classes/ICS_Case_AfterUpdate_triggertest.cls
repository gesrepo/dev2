@istest
public class ICS_Case_AfterUpdate_triggertest {
    public static testmethod void ICS_Case_AfterUpdate_trigger(){
        Customer_Service_Inquiries_ICS__c cm = new Customer_Service_Inquiries_ICS__c();
            cm.Case_Approval_Status__c = 'LOB Submitted';
       		cm.Case_Approval_Status__c = 'F&R Submitted';
        	cm.Case_Approval_Status__c = 'AR1 Submitted';
            cm.Case_Approval_Status__c = 'AR2 Submitted';
        	cm.Case_Approval_Status__c = 'CSO Submitted';
        	cm.Case_Approval_Status__c = 'Additional Submitted';
            insert cm;

			cm.Case_Approval_Status__c = 'AR1 Submitted';
        	update cm;
    }

}