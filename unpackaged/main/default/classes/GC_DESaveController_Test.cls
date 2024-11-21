/**
* @author Ethos Solutions - www.ethos.com
* @description Test code for Design Element save controller
* 2016-04-13 : Original Version
**/
@isTest
public class GC_DESaveController_Test {
    @isTest
    public static void GC_DESaveController_Test() {
        GC_Connect2_Show__c show =  GC_TestUtils.getTestConnect2Show();
        GC_Design_Request_Form__c newDRF = GC_TestUtils.getTestDRF(show.Id);
        Account acc = new Account(
            Name = 'Specifier Summit',
            Phone = '415-900-5322',
            Fax = '115-900-5233',
            BillingStreet = '4108 W. 52nd Place',
            BillingCity = 'Chicago',
            BillingState = 'IL' ,
            BillingPostalCode = '60632',
            NumberOfEmployees = 200,
            AnnualRevenue = 20000000);
        insert acc;
        GC_Design_Element__c newDE = new GC_Design_Element__c();
        //newDE.Design_Request_Form__c = newDRF.Id;
        newDE.Client__c = acc.Id;
        newDE.Requester__c = UserInfo.getUserId();
        newDE.Task_Type__c = 'Design';
        newDE.Design_Element__c = 'Entrance';
        newDE.Task_Description__c = 'Test Design Element';
        newDE.Deliverable__c = 'Graphics';
        newDE.Status__c = 'New';
        newDE.Revision__c = 1;
        newDE.Connect2_Show__c = show.Id;
        insert newDE;
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(newDE);
        GC_DESaveController controller = new GC_DESaveController(sc);
    }
}