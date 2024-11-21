@isTest
public with sharing class GC_DesignElement_EditControllerTest {
    
    public static testMethod void testDesignElementEdit() {
        
        GC_Connect2_Show__c show =  GC_TestUtils.getTestConnect2Show();
        show.Job_Number__c='011600503';
        show.Production_Location__c='110- Las Vegas';
        show.YRMO__c='201702';
        update show;        
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
        newDE.Connect2_Show__c = show.Id;
        newDE.Client__c = acc.Id;
        newDE.Requester__c = UserInfo.getUserId();
        newDE.Task_Type__c = 'Design';
        newDE.Design_Element__c = 'Entrance';
        newDE.Task_Description__c = 'Test Design Element 2';
        newDE.Deliverable__c = 'Graphics';
        newDE.Status__c = 'Accepted';
        newDE.Revision__c = 1;
        newDE.LOC1__c = '5678';
        newDE.LOC2__c = '9101';
        newDE.LOC3__c = '1234';
        insert newDE;
        

        GC_PageUtil.setParam('drfId', newDRF.Id);
        GC_DesignElement_EditController controller1 = new GC_DesignElement_EditController();
        Test.startTest();       
        ApexPages.StandardController sc1 = new ApexPages.StandardController(newDE);
        GC_DesignElement_EditController controller2 = new GC_DesignElement_EditController(sc1);
        GC_PageUtil.setParam('id', newDE.Id);
        GC_PageUtil.setParam('drfId', newDRF.Id);
        ApexPages.StandardController stdCtrlNewMode = new ApexPages.StandardController(newDE);
        GC_DesignElement_EditController controller3 = new GC_DesignElement_EditController(stdCtrlNewMode);
        GC_PageUtil.setParam('drfId', newDRF.Id);        
        //check the status
        controller3.changeMode();
        controller3.saveRecord();
        controller3.cancelAndBack();
        controller3.checkandValidate();
        Test.stopTest();
    }
    
}