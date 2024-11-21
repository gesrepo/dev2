@isTest
public class ICS_UpdateApproverFromMatrixHandler_Test{
    static Account facility=TestDataUtil.CreateTestFacility();
    static Account firm=TestDataUtil.CreateTestFirm();
    static Show__c show=TestDataUtil.CreateTestShow(firm.id);
    static List<AR_Adjustments__c> testdata=new List<AR_Adjustments__c>();
    static AR_Adjustments__c sample=new AR_Adjustments__c();
    public static Set<Id>updatedMatrixIDs;
    
    @istest
    public static void handleApproversTest()
    {
        //List<ICS_Approver_Matrix__c> matrixlist = new List<ICS_Approver_Matrix__c>();
        ICS_Approver_Matrix__c cr=new ICS_Approver_Matrix__c();
        ICS_UpdateApproverFromMatrixHandler.handleApprovers(null);
        
        Employees__c e=new Employees__c();
        e.name='sample';
        e.Email_Address__c='sample@sample.com';
        insert e;
        Employees__c e1=new Employees__c();
        e1.name='sample1';
        e1.Email_Address__c='sample1@sample.com';
        insert e1;
        
        Customer_Service_Inquiries_ICS__c test1=new Customer_Service_Inquiries_ICS__c();
        test1.Sales_Channel__c ='Revenue Show Org';
        //test1.Customer_Name__c='test';
        test1.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
        insert test1;
        
        cr.Min_Amount__c=5000;
        cr.Max_Amount__c=null;
        cr.LOB_Approver__c=e1.id;
        cr.F_R_Approver__c=e.Id;
        cr.AR1_Approver__c=e1.id;
		cr.CSO_Approver__c=e1.id;
        cr.AR2_Approver__c=e.id;
        cr.Additional_Approver__c=e.id;
        cr.Transaction_Types__c='AR Adjustments';
        cr.Location__c='110- Las Vegas';
        cr.sales_channel__c='Revenue Show Org';
        insert cr;
        cr.sales_channel__c = 'E&E (Trade Show)';
        update cr;
        
        sample.AR_Adj_CSI_ID__c=test1.id;        
        sample.Amount__c=1000;
        testdata.add(sample);
        insert testdata;
    }    
        
    /*{
        List<Customer_Service_Inquiries_ICS__c> icsList = new List<Customer_Service_Inquiries_ICS__c>();
        ICS_UpdateApproverFromMatrixHandler.handleApprovers(null);
        
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
      //  ICS_UpdateApproverFromMatrixHandler.handleApprovers(icsList);
        
        Credit_Memo_ICS__c crdmIcs = TestDataUtil.createTestCreditMemo(CSIId);
        insert crdmIcs;
       // ICS_UpdateApproverFromMatrixHandler.handleApprovers(icsList);
        
        Refunds_ICS__c rfIcs = TestDataUtil.createTestRefund(CSIId);
        insert rfIcs;
       // ICS_UpdateApproverFromMatrixHandler.handleApprovers(icsList);       

        Test.stopTest();
    }*/
}