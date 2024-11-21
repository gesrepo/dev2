@isTest
public class ICS_UpdatetransactionOnCase_Test {
    static Account facility=TestDataUtil.CreateTestFacility();
    static Account firm=TestDataUtil.CreateTestFirm();
    static Show__c show=TestDataUtil.CreateTestShow(firm.id);
    public static Set<Id>updatedCaseIDs;
    
    @istest
    public static void handleApproversTest()
    {
        List<Customer_Service_Inquiries_ICS__c> icsList = new List<Customer_Service_Inquiries_ICS__c>();
        ICS_UpdatetransactionOnCase.handleApprovers(null);
        
        Customer_Service_Inquiries_ICS__c ICS1 = TestDataUtil.createTestCustomerServiceInquries();
        ICS1.Opportunity_Name__c = TestDataUtil.CreateTestSalesRepOpp(facility.id, firm.id, show.id).id;
        ICS1.Case_Approval_Status__c = 'Case Open';        
        ICS1.Case_Requestor_Email_ID__c='sample1@sample.com';
        icsList.add(ICS1);
        insert icsList;
        
        Id CSIId = icsList.get(0).Id;
        Test.startTest();
        
        AR_Adjustments__c arAdApr = TestDataUtil.createTestARAdjustment(CSIId);
        insert arAdApr;
        ICS_UpdatetransactionOnCase.handleApprovers(icsList);
        
        Credit_Memo_ICS__c crdmIcs = TestDataUtil.createTestCreditMemo(CSIId);
        insert crdmIcs;
        ICS_UpdatetransactionOnCase.handleApprovers(icsList);
        
        Refunds_ICS__c rfIcs = TestDataUtil.createTestRefund(CSIId);
        insert rfIcs;
        ICS_UpdatetransactionOnCase.handleApprovers(icsList);
        
        Test.stopTest();
    }
}