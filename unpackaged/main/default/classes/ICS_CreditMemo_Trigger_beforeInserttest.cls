@istest
public class ICS_CreditMemo_Trigger_beforeInserttest {
    static Account facility=TestDataUtil.CreateTestFacility();
     static Account firm=TestDataUtil.CreateTestFirm();
     static Show__c show=TestDataUtil.CreateTestShow(firm.id);
    
    @istest
    public static void ICS_CreditMemo_Trigger_beforeInsert1(){
        List<Employees__c> listEmp = new List<Employees__c>();
        Employees__c emp = TestDataUtil.createTestEmployee();
        Employees__c emp1 = TestDataUtil.createTestEmployee();
        emp1.Email_Address__c='test1@test1.com';
        listEmp.add(emp);
        listEmp.add(emp1);
        insert listEmp;
        ICS_Approver_Matrix__c approverMatrix = TestDataUtil.createTestApproverMatrix(listEmp[0].id);
        insert approverMatrix;
        Customer_Service_Inquiries_ICS__c csi=new Customer_Service_Inquiries_ICS__c();
        csi.Booth_Area__c='test';
       // csi.Customer__c='123';
        csi.Case_Requestor_Approval_Status__c='Open';
        csi.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
        csi.Sales_Channel__c = 'E&E (Trade Show)';
        insert csi;
        Credit_Memo_ICS__c cmi = new Credit_Memo_ICS__c();
        cmi.CSI_ICS__c=csi.id;
        cmi.Amount_w_psp__c = 1000000;
        cmi.Tax_Amount__c = 2000;
        cmi.Credit_Memo_Reason__c = 'Bad Debt: CM';
        cmi.Reason_Code_Category__c='Cat - B';
        cmi.Credit_LOB__c = 'AUDIO VISUAL';    
        insert cmi;       
          cmi.Location__c = '710- Chicago, Cleveland, Milwaukee, St. Louis';
            update cmi;
    }
    
     @istest
    public static void ICS_CreditMemo_Trigger_beforeInsert2() {
    List<Employees__c> listEmp = new List<Employees__c>();
        Employees__c emp = TestDataUtil.createTestEmployee();
        Employees__c emp1 = TestDataUtil.createTestEmployee();
        emp1.Email_Address__c='test1@test1.com';
        listEmp.add(emp);
        listEmp.add(emp1);
        insert listEmp;
        ICS_Approver_Matrix__c approverMatrix = TestDataUtil.createTestApproverMatrix(listEmp[0].id);
        insert approverMatrix;
    Customer_Service_Inquiries_ICS__c csi = new Customer_Service_Inquiries_ICS__c();
    //csi.Customer__c='test';
        csi.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
        csi.Sales_Channel__c = 'E&E (Trade Show)';
    insert csi;
        
    Credit_Memo_ICS__c cmi = new Credit_Memo_ICS__c();
        cmi.CSI_ICS__c=csi.id;
        cmi.Amount_w_psp__c = 1000000;
        cmi.Tax_Amount__c = 2000;
        cmi.Credit_Memo_Reason__c = 'Accounts Receivables Billing Error: CM ERROR';
        cmi.Reason_Code_Category__c='Cat - A';
        cmi.Credit_LOB__c = 'AUDIO VISUAL';
        insert cmi;
   
    cmi.Location__c = '710- Chicago, Cleveland, Milwaukee, St. Louis';
    update cmi;
  }
    
    @istest
    public static void ICS_CreditMemo_Trigger_beforeInsert3() {
    List<Employees__c> listEmp = new List<Employees__c>();
        Employees__c emp = TestDataUtil.createTestEmployee();
        Employees__c emp1 = TestDataUtil.createTestEmployee();
        emp1.Email_Address__c='test1@test1.com';
        listEmp.add(emp);
        listEmp.add(emp1);
        insert listEmp;
        ICS_Approver_Matrix__c approverMatrix = TestDataUtil.createTestApproverMatrix(listEmp[0].id);
        insert approverMatrix;
         Customer_Service_Inquiries_ICS__c csi = new Customer_Service_Inquiries_ICS__c();
        //csi.Customer__c='test';
        csi.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
        csi.Sales_Channel__c = 'E&E (Trade Show)';
        insert csi;
        
        Credit_Memo_ICS__c cmi = new Credit_Memo_ICS__c();
        cmi.CSI_ICS__c=csi.id;
        cmi.Amount_w_psp__c = 1000000;
        cmi.Tax_Amount__c = 2000;
        cmi.Credit_Memo_Reason__c = 'Order Entry Error: CM';
        cmi.Reason_Code_Category__c='Cat - C';
        cmi.Credit_LOB__c = 'AUDIO VISUAL';
        insert cmi;
   
        cmi.Location__c = '710- Chicago, Cleveland, Milwaukee, St. Louis';
        update cmi;
  } 
    
    
}