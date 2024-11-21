@istest
public class UpdateCaseICS_TEST{
    static Account facility=TestDataUtil.CreateTestFacility();
     static Account firm=TestDataUtil.CreateTestFirm();
     static Show__c show=TestDataUtil.CreateTestShow(firm.id);
    @istest
    public static void test1(){
        
        
        
        Customer_Service_Inquiries_ICS__c test1=new Customer_Service_Inquiries_ICS__c();
        //test1.Customer_Name__c='test1';
        test1.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
        test1.Requestor_Apporval_Required__c=true;
        test1.Case_Requestor_Approval_Status__c='Approved';
        
        insert test1;
        AR_Adjustments__c sample=new AR_Adjustments__c();
        sample.AR_Adj_CSI_ID__c=test1.id;
        sample.Amount__c=1000000;
        sample.Sales_Order__c = '1001';
        insert sample;
        //sample.Requestor_Approval_Required__c=true;
        //sample.Requestor_Email_ID__c='prakash.gb2@slkgroup.com';
        //sample.Requestor_Approval_Status__c='Approved';
        sample.DAM_Approver_Email_ID__c='prakash.gb2@slkgroup.com';
        sample.DAM_Approver_Status__c='Approved';
        sample.F_A_Approver_Email__c='prakash.gb2@slkgroup.com';
        sample.F_R_Approvers_Status__c='Approved';
        sample.AR1_Approver_Email__c='prakash.gb2@slkgroup.com';
        sample.AR1_Approver_Status__c='Approved';
        sample.CSO_Approver_Email__c= 'soniya.gopu@slkgroup.com';
        sample.CSO_Approver_Status__c='Approved';
        sample.AR2_Approver_Email__c='prakash.gb2@slkgroup.com';
        sample.AR2_Approver_Status__c='Approved';
        update sample;
        UpdateCaseICS.caseUpdate(test1, 'APPROVE');
        
        
        
    }
    @istest
    public static void test2(){
        Customer_Service_Inquiries_ICS__c test1=new Customer_Service_Inquiries_ICS__c();
        //test1.Customer_Name__c='test1';
        test1.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
        insert test1;
        Credit_Memo_ICS__c sample=new Credit_Memo_ICS__c();
        sample.CSI_ICS__c=test1.id;
        sample.Amount_w_psp__c=10000000;
        sample.Tax_Amount__c=100;
        sample.Credit_Memo_Reason__c='Legal Settlement: CM';
        sample.Credit_LOB__c='AUDIO VISUAL';
        insert sample;
        //sample.Requestor_Approval_Required__c=true;
        //sample.Requestor_Email_ID__c='prakash.gb2@slkgroup.com';
        //sample.Requestor_Approval_Status__c='Approved';
        sample.LOB_Approver_Email_ID__c='prakash.gb2@slkgroup.com';
        sample.LOB__c='Approved';
        sample.F_R_Approver_Email_ID__c='prakash.gb2@slkgroup.com';
        sample.F_R_Approver_Status__c='Approved';
        sample.AR1_Approver_Email_ID__c='prakash.gb2@slkgroup.com';
        sample.AR1_Approver_Status__c='Approved';
         sample.CSO_Approver_Email__c= 'soniya.gopu@slkgroup.com';
        sample.CSO_Approver_Status__c='Approved';       
        sample.AR2_Approver_Email_ID__c='prakash.gb2@slkgroup.com';
        sample.AR2_Approver_Status__c='Approved';
        sample.Additional_Approver_Email_ID__c='prakash.gb2@slkgroup.com';
        sample.Additional_Approver_Status__c='Approved';
        update sample;
        UpdateCaseICS.caseUpdate(test1, 'APPROVE');
    }
    
    @istest
    public static void test3(){
        Customer_Service_Inquiries_ICS__c test1=new Customer_Service_Inquiries_ICS__c();
        //test1.Customer_Name__c='test1';
        test1.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
        insert test1;
        Charges__c sample=new Charges__c();
        sample.Last_4_of_CC__c = '1001';
        sample.Last_4_of_Token__c = '2001';
        sample.CSI_ICS__c=test1.id;
        sample.Total_Amount__c=100000;
        insert sample;
        //sample.Requestor_Approval_Required__c=true;
        //sample.Requestor_Email_ID__c='prakash.gb2@slkgroup.com';
        //sample.Requestor_Approval_Status__c='Approved';
        update sample; 
        UpdateCaseICS.caseUpdate(test1, 'APPROVE');
        
        
    }
    @istest
    public static void test4(){
        Customer_Service_Inquiries_ICS__c test1=new Customer_Service_Inquiries_ICS__c();
        //test1.Customer_Name__c='test1';
        test1.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
        insert test1;
        Receipt_Reversals__c sample=new Receipt_Reversals__c();
        sample.CSI_ICS__c=test1.id;
        sample.Receipt_Reversal_Amount__c=100000;
        insert sample;
        //sample.Requestor_Approval_Required__c=true;
        //sample.Requestor_Email_ID__c='prakash.gb2@slkgroup.com';
        //sample.Requestor_Approval_Status__c='Approved';
        //sample.Approver_Email__c='prakash.gb2@slkgroup.com';
        sample.Approver_Status__c='Approved';
        update sample;
        UpdateCaseICS.caseUpdate(test1, 'APPROVE');
        
        
    }
    @istest
    public static void test5(){
        Customer_Service_Inquiries_ICS__c test1=new Customer_Service_Inquiries_ICS__c();
        //test1.Customer_Name__c='test1';
        test1.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
        insert test1;
        Refunds_ICS__c sample=new Refunds_ICS__c();
        sample.CSI_ICS__c=test1.id;
        sample.Amount__c=1000000;
        sample.Last_4_of_CC__c = '1001';
        sample.Last_4_of_Token__c = '2001';
        insert sample;        
        sample.AR1_Approver_Email_ID__c='prakash.gb2@slkgroup.com';
        sample.AR1_Approver_Status__c='Approved';
        //sample.CSO_Approver_Email__c= 'soniya.gopu@slkgroup.com';
        sample.CSO_Approver_Status__c='Approved';
        sample.AR2_Approver_Email_ID__c='prakash.gb2@slkgroup.com';
        sample.AR2_Approver_Status__c='Approved';
        update sample;
        UpdateCaseICS.caseUpdate(test1, 'APPROVE');
        
       
    }
    @istest
    public static void test6(){
        Customer_Service_Inquiries_ICS__c test1=new Customer_Service_Inquiries_ICS__c();
        //test1.Customer_Name__c='test1';
        test1.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
        insert test1;
        Payment_Transfer_ICS__c sample=new Payment_Transfer_ICS__c();
        sample.CSI_ICS_No__c=test1.id;
        sample.Transfer_Amount__c=100000;
        insert sample;
        //sample.Requestor_Email_ID__c='prakash.gb2@slkgroup.com';
        //sample.Requestor_Approval_Status__c='Approved';
        //sample.Requestor_Approval_Required__c=true;
        update sample;
        UpdateCaseICS.caseUpdate(test1, 'APPROVE');
        
        
    }
    
   /* @istest
    public static void test7(){
        Customer_Service_Inquiries_ICS__c test1=new Customer_Service_Inquiries_ICS__c();
        //test1.Customer_Name__c='test1';
        test1.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
        test1.Case_Approval_Status__c='Requestor Submitted';
        insert test1;
        Payment_Transfer_ICS__c sample=new Payment_Transfer_ICS__c();
        sample.CSI_ICS_No__c=test1.id;
        sample.Transfer_Amount__c=100000;
        insert sample;
        //sample.Requestor_Email_ID__c='prakash.gb2@slkgroup.com';
        sample.Requestor_Approval_Status__c='Rejected';
        sample.Requestor_Approval_Required__c=true;
        update sample;
        UpdateCaseICS.caseUpdate(test1, 'REJECT');

    }
   @istest
    public static void test8(){
        Customer_Service_Inquiries_ICS__c test2=new Customer_Service_Inquiries_ICS__c();
        //test2.Customer_Name__c='test';
        test2.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
        test2.Case_Approval_Status__c='LOB Submitted';
        insert test2;
        AR_Adjustments__c sample=new AR_Adjustments__c();
        sample.AR_Adj_CSI_ID__c=test2.id;
        sample.Amount__c=1000000;
        sample.Sales_Order__c = '1001';
        insert sample;
        sample.DAM_Approver_Email_ID__c='prakash.gb2@slkgroup.com';
        sample.DAM_Approver_Status__c='Rejected';
        sample.DAM_Approver_Comments__c = 'AR Adjustments Rejected';
        update sample;
        UpdateCaseICS.caseUpdate(test2, 'REJECT');

    }
   @istest
    public static void test9(){
        Customer_Service_Inquiries_ICS__c test1=new Customer_Service_Inquiries_ICS__c();
        //test1.Customer_Name__c='test1';
        test1.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
        test1.Case_Approval_Status__c='F&R Submitted';
        insert test1;
         AR_Adjustments__c sample=new AR_Adjustments__c();
        sample.AR_Adj_CSI_ID__c=test1.id;
        sample.Amount__c=1000000;
        sample.Sales_Order__c = '1001';
        insert sample;
        sample.Requestor_Approval_Required__c=true;
        //sample.Requestor_Email_ID__c='prakash.gb2@slkgroup.com';
        sample.Requestor_Approval_Status__c='Approved';
        sample.DAM_Approver_Email_ID__c='prakash.gb2@slkgroup.com';
        sample.DAM_Approver_Status__c='Rejected';
        sample.F_A_Approver_Email__c='prakash.gb2@slkgroup.com';
        sample.F_R_Approvers_Status__c='Rejected';
        sample.AR1_Approver_Email__c='prakash.gb2@slkgroup.com';
        sample.AR1_Approver_Status__c='Rejected';
         sample.CSO_Approver_Email__c= 'soniya.gopu@slkgroup.com';
        sample.CSO_Approver_Status__c='Approved';
        sample.AR2_Approver_Email__c='prakash.gb2@slkgroup.com';
        sample.AR2_Approver_Status__c='Rejected';
        update sample;
        UpdateCaseICS.caseUpdate(test1, 'REJECT');

    }
    @istest
    public static void test12(){
        Customer_Service_Inquiries_ICS__c test1=new Customer_Service_Inquiries_ICS__c();
        //test1.Customer_Name__c='test1';
        test1.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
        test1.Case_Approval_Status__c='AR1 Submitted';
        insert test1;
         AR_Adjustments__c sample=new AR_Adjustments__c();
        sample.AR_Adj_CSI_ID__c=test1.id;
        sample.Amount__c=1000000;
        sample.Sales_Order__c = '1001';
        insert sample;
        sample.Requestor_Approval_Required__c=true;
        //sample.Requestor_Email_ID__c='prakash.gb2@slkgroup.com';
        sample.Requestor_Approval_Status__c='Approved';
        sample.DAM_Approver_Email_ID__c='prakash.gb2@slkgroup.com';
        sample.DAM_Approver_Status__c='Rejected';
        sample.F_A_Approver_Email__c='prakash.gb2@slkgroup.com';
        sample.F_R_Approvers_Status__c='Rejected';
        sample.AR1_Approver_Email__c='prakash.gb2@slkgroup.com';
        sample.AR1_Approver_Status__c='Rejected';
         sample.CSO_Approver_Email__c= 'soniya.gopu@slkgroup.com';
        sample.CSO_Approver_Status__c='Approved';
        sample.AR2_Approver_Email__c='prakash.gb2@slkgroup.com';
        sample.AR2_Approver_Status__c='Rejected';
        update sample;
        UpdateCaseICS.caseUpdate(test1, 'REJECT');

    }
    @istest
    public static void test10(){
        Customer_Service_Inquiries_ICS__c test1=new Customer_Service_Inquiries_ICS__c();
        //test1.Customer_Name__c='test1';
        test1.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
        test1.Case_Approval_Status__c='AR2 Submitted';
        
        insert test1;
        AR_Adjustments__c sample=new AR_Adjustments__c();
        sample.AR_Adj_CSI_ID__c=test1.id;
        sample.Amount__c=1000000;
        sample.Sales_Order__c = '1001';
        insert sample;
        sample.Requestor_Approval_Required__c=true;
        //sample.Requestor_Email_ID__c='prakash.gb2@slkgroup.com';
        sample.Requestor_Approval_Status__c='Approved';
        sample.DAM_Approver_Email_ID__c='prakash.gb2@slkgroup.com';
        sample.DAM_Approver_Status__c='Rejected';
        sample.F_A_Approver_Email__c='prakash.gb2@slkgroup.com';
        sample.F_R_Approvers_Status__c='Rejected';
        sample.AR1_Approver_Email__c='prakash.gb2@slkgroup.com';
        sample.AR1_Approver_Status__c='Rejected';
         sample.CSO_Approver_Email__c= 'soniya.gopu@slkgroup.com';
        sample.CSO_Approver_Status__c='Approved';
        sample.AR2_Approver_Email__c='prakash.gb2@slkgroup.com';
        sample.AR2_Approver_Status__c='Rejected';
        update sample;
        UpdateCaseICS.caseUpdate(test1, 'REJECT');

    }
    @istest
    public static void test11(){
        Customer_Service_Inquiries_ICS__c test1=new Customer_Service_Inquiries_ICS__c();
        //test1.Customer_Name__c='test1';
        test1.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
        test1.Case_Approval_Status__c='AR2 Submitted';
        insert test1;
         AR_Adjustments__c sample=new AR_Adjustments__c();
        sample.AR_Adj_CSI_ID__c=test1.id;
        sample.Amount__c=1000000;
        sample.Sales_Order__c = '1001';
        insert sample;
        sample.Requestor_Approval_Required__c=true;
        //sample.Requestor_Email_ID__c='prakash.gb2@slkgroup.com';
        sample.Requestor_Approval_Status__c='Approved';
        sample.DAM_Approver_Email_ID__c='prakash.gb2@slkgroup.com';
        sample.DAM_Approver_Status__c='Rejected';
        sample.F_A_Approver_Email__c='prakash.gb2@slkgroup.com';
        sample.F_R_Approvers_Status__c='Rejected';
        sample.AR1_Approver_Email__c='prakash.gb2@slkgroup.com';
        sample.AR1_Approver_Status__c='Rejected';
         sample.CSO_Approver_Email__c= 'soniya.gopu@slkgroup.com';
        sample.CSO_Approver_Status__c='Approved';
        sample.AR2_Approver_Email__c='prakash.gb2@slkgroup.com';
        sample.AR2_Approver_Status__c='Rejected';
        update sample;
        UpdateCaseICS.caseUpdate(test1, 'REJECT');

    }
    
    @istest
    public static void test13(){
        Customer_Service_Inquiries_ICS__c test1=new Customer_Service_Inquiries_ICS__c();
        //test1.Customer_Name__c='test1';
        test1.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
        test1.Case_Approval_Status__c='Additional Submitted';
        insert test1;
         AR_Adjustments__c sample=new AR_Adjustments__c();
        sample.AR_Adj_CSI_ID__c=test1.id;
        sample.Amount__c=1000000;
        sample.Sales_Order__c = '1001';
        insert sample;
        sample.Requestor_Approval_Required__c=true;
        //sample.Requestor_Email_ID__c='prakash.gb2@slkgroup.com';
        sample.Requestor_Approval_Status__c='Rejected';
        sample.DAM_Approver_Email_ID__c='prakash.gb2@slkgroup.com';
        sample.DAM_Approver_Status__c='Rejected';
        sample.F_A_Approver_Email__c='prakash.gb2@slkgroup.com';
        sample.F_R_Approvers_Status__c='Rejected';
        sample.AR1_Approver_Email__c='prakash.gb2@slkgroup.com';
        sample.AR1_Approver_Status__c='Rejected';
         sample.CSO_Approver_Email__c= 'soniya.gopu@slkgroup.com';
        sample.CSO_Approver_Status__c='Approved';
        sample.AR2_Approver_Email__c='prakash.gb2@slkgroup.com';
        sample.AR2_Approver_Status__c='Rejected';
        update sample;
        UpdateCaseICS.caseUpdate(test1, 'REJECT');

    }*/
    @istest
    public static void test14(){
        Customer_Service_Inquiries_ICS__c test2=new Customer_Service_Inquiries_ICS__c();
        //test2.Customer_Name__c='test1';
        test2.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
        test2.Case_Approval_Status__c='Requestor Submitted';
        insert test2;
        UpdateCaseICS.caseUpdate(test2, 'APPROVE');
    }
    @istest
    public static void test15(){
        Customer_Service_Inquiries_ICS__c test2=new Customer_Service_Inquiries_ICS__c();
        //test2.Customer_Name__c='test1';
        test2.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
        test2.Case_Approval_Status__c='LOB Submitted';
        insert test2;
        UpdateCaseICS.caseUpdate(test2, 'APPROVE');
    }
    @istest
    public static void test16(){
        Customer_Service_Inquiries_ICS__c test2=new Customer_Service_Inquiries_ICS__c();
        //test2.Customer_Name__c='test1';
        test2.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
        test2.Case_Approval_Status__c='F&R Submitted';
        insert test2;
        UpdateCaseICS.caseUpdate(test2, 'APPROVE');
    }
    @istest
    public static void test17(){
        Customer_Service_Inquiries_ICS__c test2=new Customer_Service_Inquiries_ICS__c();
        //test2.Customer_Name__c='test1';
        test2.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
        test2.Case_Approval_Status__c='AR1 Submitted';
        insert test2;
        UpdateCaseICS.caseUpdate(test2, 'APPROVE');
    }
    @istest
    public static void test18(){
        Customer_Service_Inquiries_ICS__c test2=new Customer_Service_Inquiries_ICS__c();
        //test2.Customer_Name__c='test1';
        test2.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
        test2.Case_Approval_Status__c='AR2 Submitted';
        insert test2;
        UpdateCaseICS.caseUpdate(test2, 'APPROVE');
    }
    @istest
     public static void test19(){
        Customer_Service_Inquiries_ICS__c test2=new Customer_Service_Inquiries_ICS__c();
        //test2.Customer_Name__c='test1';
        test2.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
        test2.Case_Approval_Status__c='CSO Submitted';
        insert test2;
        UpdateCaseICS.caseUpdate(test2, 'APPROVE');
    }
  @istest
    public static void test20(){
        Customer_Service_Inquiries_ICS__c test2=new Customer_Service_Inquiries_ICS__c();
        //test2.Customer_Name__c='test1';
        test2.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
        test2.Case_Approval_Status__c='Additional Submitted';
        insert test2;
        UpdateCaseICS.caseUpdate(test2, 'APPROVE');
    }
      @istest
    public static void test21(){
        Customer_Service_Inquiries_ICS__c test21=new Customer_Service_Inquiries_ICS__c();
        //test21.Customer_Name__c='test1';
        test21.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
        test21.Case_Approval_Status__c='Requestor Submitted';
        insert test21;
        UpdateCaseICS.caseUpdate(test21, 'Reject');
    }
    
     public static void test22(){
        Customer_Service_Inquiries_ICS__c test22=new Customer_Service_Inquiries_ICS__c();
        //test22.Customer_Name__c='test1';
        test22.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
        test22.Case_Approval_Status__c='LOB Submitted';
        insert test22;
        UpdateCaseICS.caseUpdate(test22, 'Reject');
    }
    @istest
    public static void test23(){
        Customer_Service_Inquiries_ICS__c test23=new Customer_Service_Inquiries_ICS__c();
        //test23.Customer_Name__c='test1';
        test23.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
        test23.Case_Approval_Status__c='F&R Submitted';
        insert test23;
        UpdateCaseICS.caseUpdate(test23, 'Reject');
    }
    @istest
    public static void test24(){
        Customer_Service_Inquiries_ICS__c test24=new Customer_Service_Inquiries_ICS__c();
        //test24.Customer_Name__c='test1';
        test24.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
        test24.Case_Approval_Status__c='AR1 Submitted';
        insert test24;
        UpdateCaseICS.caseUpdate(test24, 'Reject');
    }
    @istest
    public static void test25(){
        Customer_Service_Inquiries_ICS__c test25=new Customer_Service_Inquiries_ICS__c();
        //test25.Customer_Name__c='test1';
        test25.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
        test25.Case_Approval_Status__c='AR2 Submitted';
        insert test25;
        UpdateCaseICS.caseUpdate(test25, 'Reject');
    }
    @istest
     public static void test26(){
        Customer_Service_Inquiries_ICS__c test26=new Customer_Service_Inquiries_ICS__c();
        //test26.Customer_Name__c='test1';
        test26.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
        test26.Case_Approval_Status__c='CSO Submitted';
        insert test26;
        UpdateCaseICS.caseUpdate(test26, 'Reject');
    }
  @istest
    public static void test27(){
        Customer_Service_Inquiries_ICS__c test27=new Customer_Service_Inquiries_ICS__c();
        //test27.Customer_Name__c='test1';
        test27.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
        test27.Case_Approval_Status__c='Additional Submitted';
        insert test27;
        UpdateCaseICS.caseUpdate(test27, 'Reject');
    }
    
    
}