@isTest(SeeAllData=false)
public class CaseSubmitForApprovalTest {
    
    //setting up test data
    @testSetup
    static void setup(){
        //Test.startTest();
        //Account facility=TestDataUtil.CreateTestFacility();
        //Account firm=TestDataUtil.CreateTestFirm();
        //Show__c show=TestDataUtil.CreateTestShow(firm.id);
        
        List<Employees__c> listEmp = new List<Employees__c>();
        Employees__c emp = TestDataUtil.createTestEmployee();
        Employees__c emp1 = TestDataUtil.createTestEmployee();
        emp.Email_Address__c='test1@test1.com';
        emp1.Email_Address__c='test1@test1.com';
        listEmp.add(emp);
        listEmp.add(emp1);
        insert listEmp;
        
        
        ICS_Approver_Matrix__c approverMatrix = TestDataUtil.createTestApproverMatrix(listEmp[0].id);
        insert approverMatrix;
        
        List<Customer_Service_Inquiries_ICS__c> listICS = new List<Customer_Service_Inquiries_ICS__c>();
        Customer_Service_Inquiries_ICS__c ICS = TestDataUtil.createTestCustomerServiceInquries();
        //ics.Opportunity_Name__c = 'ASDLVA-201708-LVCC';
        ICS.Case_Requestor__c = listEmp[0].Id;
        ICS.Case_Approval_Status__c = 'Case Open' ;
        ICS.Requestor_Apporval_Required__c = true; 
        listICS.add(ICS);
        //insert ICS;
        
        Customer_Service_Inquiries_ICS__c ICS1 = TestDataUtil.createTestCustomerServiceInquries();
        //ics.Opportunity_Name__c = 'ASDLVA-201708-LVCC';
        ICS1.Case_Requestor__c = listEmp[0].Id;
        ICS1.Case_Approval_Status__c = 'Case Open' ;
        ICS1.Requestor_Apporval_Required__c = true; 
        listICS.add(ICS1);
        
        Customer_Service_Inquiries_ICS__c ICS2 = TestDataUtil.createTestCustomerServiceInquries();
        //ics.Opportunity_Name__c = 'ASDLVA-201708-LVCC';
        ICS2.Case_Requestor__c = listEmp[0].Id;
        ICS2.Case_Approval_Status__c = 'F&R Open' ;
        //ICS1.Requestor_Apporval_Required__c = true; 
        listICS.add(ICS2);
        
        Customer_Service_Inquiries_ICS__c ICS3 = TestDataUtil.createTestCustomerServiceInquries();
        //ics.Opportunity_Name__c = 'ASDLVA-201708-LVCC';
        ICS3.Case_Requestor__c = listEmp[0].Id;
        ICS3.Case_Approval_Status__c = 'F&R Open' ;
        //ICS1.Requestor_Apporval_Required__c = true; 
        listICS.add(ICS3);
        
        Customer_Service_Inquiries_ICS__c ICS4 = TestDataUtil.createTestCustomerServiceInquries();
        //ics.Opportunity_Name__c = 'ASDLVA-201708-LVCC';
        ICS4.Case_Requestor__c = listEmp[0].Id;
        ICS4.Case_Approval_Status__c = 'AR1 Open' ;
        //ICS1.Requestor_Apporval_Required__c = true; 
        listICS.add(ICS4);
        
        Customer_Service_Inquiries_ICS__c ICS5 = TestDataUtil.createTestCustomerServiceInquries();
        //ics.Opportunity_Name__c = 'ASDLVA-201708-LVCC';
        ICS5.Case_Requestor__c = listEmp[0].Id;
        ICS5.Case_Approval_Status__c = 'AR1 Open' ;
        //ICS1.Requestor_Apporval_Required__c = true; 
        listICS.add(ICS5);
        
        Customer_Service_Inquiries_ICS__c ICS6 = TestDataUtil.createTestCustomerServiceInquries();
        //ics.Opportunity_Name__c = 'ASDLVA-201708-LVCC';
        ICS6.Case_Requestor__c = listEmp[0].Id;
        ICS6.Case_Approval_Status__c = 'CSO Open' ;
        //ICS1.Requestor_Apporval_Required__c = true; 
        listICS.add(ICS6);
        
        Customer_Service_Inquiries_ICS__c ICS7 = TestDataUtil.createTestCustomerServiceInquries();
        //ics.Opportunity_Name__c = 'ASDLVA-201708-LVCC';
        ICS7.Case_Requestor__c = listEmp[0].Id;
        ICS7.Case_Approval_Status__c = 'CSO Open' ;
        //ICS1.Requestor_Apporval_Required__c = true; 
        listICS.add(ICS7);
        
        Customer_Service_Inquiries_ICS__c ICS8 = TestDataUtil.createTestCustomerServiceInquries();
        //ics.Opportunity_Name__c = 'ASDLVA-201708-LVCC';
        ICS8.Case_Requestor__c = listEmp[0].Id;
        ICS8.Case_Approval_Status__c = 'AR2 Open' ;
        //ICS1.Requestor_Apporval_Required__c = true; 
        listICS.add(ICS8);
        
        Customer_Service_Inquiries_ICS__c ICS9 = TestDataUtil.createTestCustomerServiceInquries();
        //ics.Opportunity_Name__c = 'ASDLVA-201708-LVCC';
        ICS9.Case_Requestor__c = listEmp[0].Id;
        ICS9.Case_Approval_Status__c = 'AR2 Open' ;
        //ICS1.Requestor_Apporval_Required__c = true; 
        listICS.add(ICS9);
        
        Customer_Service_Inquiries_ICS__c ICS10 = TestDataUtil.createTestCustomerServiceInquries();
        //ics.Opportunity_Name__c = 'ASDLVA-201708-LVCC';
        ICS10.Case_Requestor__c = listEmp[0].Id;
        ICS10.Case_Approval_Status__c = 'Additional Open' ;
        //ICS1.Requestor_Apporval_Required__c = true; 
        listICS.add(ICS10);
        
        Customer_Service_Inquiries_ICS__c ICS11 = TestDataUtil.createTestCustomerServiceInquries();
        //ics.Opportunity_Name__c = 'ASDLVA-201708-LVCC';
        ICS11.Case_Requestor__c = listEmp[0].Id;
        ICS11.Case_Approval_Status__c = 'Additional Open' ;
        //ICS1.Requestor_Apporval_Required__c = true; 
        listICS.add(ICS11);
        
        insert listICS;
        
        //for commented code -- goto ==>Commented Line - Part 1       
    }
    
    
    @isTest
    public static void  testMethod1() { 
        List<Customer_Service_Inquiries_ICS__c> testRecordICS= [select Id, Case_Approval_Status__c, Name, Requestor_Apporval_Required__c from Customer_Service_Inquiries_ICS__c]; 
        List<Employees__c> listEmp = [select Email_Address__c from Employees__c];
        List<AR_Adjustments__c> arAdjList = new List<AR_Adjustments__c>();
        AR_Adjustments__c arAdj = TestDataUtil.createTestARAdjustment(testRecordICS[0].Id);
        arAdj.DAM_LOB_Approver__c = listEmp[0].Id;
        arAdj.DAM_Approver_Email_ID__c = listEmp[0].Email_Address__c;
        arAdj.F_R_Approver__c = listEmp[0].Id;
        arAdj.F_A_Approver_Email__c = listEmp[0].Email_Address__c;
        arAdj.AR1_Approver_Name__c = listEmp[0].Id;
        arAdj.AR1_Approver_Email__c = listEmp[0].Email_Address__c;
        arAdj.CSO_Approver_Name__c = listEmp[0].Id;
        arAdj.CSO_Approver_Email__c = listEmp[0].Email_Address__c;
        arAdj.AR2_Approver_Name__c = listEmp[0].Id;
        arAdj.AR2_Approver_Email__c = listEmp[0].Email_Address__c; 
        //arAdj.DAM_Approver_Status__c = 'Approved';
         
        
        AR_Adjustments__c arAdj1 = TestDataUtil.createTestARAdjustment(testRecordICS[1].Id);
        arAdj1.DAM_LOB_Approver__c = listEmp[0].Id;
        arAdj1.DAM_Approver_Email_ID__c = listEmp[0].Email_Address__c;
        arAdj1.F_R_Approver__c = listEmp[0].Id;
        arAdj1.F_A_Approver_Email__c = listEmp[0].Email_Address__c;
        arAdj1.AR1_Approver_Name__c = listEmp[0].Id;
        arAdj1.AR1_Approver_Email__c = listEmp[0].Email_Address__c;
        arAdj1.CSO_Approver_Name__c = listEmp[0].Id;
        arAdj1.CSO_Approver_Email__c = listEmp[0].Email_Address__c;
        arAdj1.AR2_Approver_Name__c = listEmp[0].Id;
        arAdj1.AR2_Approver_Email__c = listEmp[0].Email_Address__c; 
        arAdj1.Del_DAM_LOB_Approver__c = listEmp[0].Id;
        arAdjList.add(arAdj);
        arAdjList.add(arAdj1);
        insert arAdjList;
          
        ICS_Approver_Matrix__c approverMatrix = TestDataUtil.createTestApproverMatrix(listEmp[0].id);
        insert approverMatrix;
        List<Credit_Memo_ICS__c> creditMemoList = new List<Credit_Memo_ICS__c>();
        Credit_Memo_ICS__c creditMemo = TestDataUtil.createTestCreditMemo(testRecordICS[0].Id); 
        creditMemo.Sales_Channel__c='E&E (Trade Show)';
        creditMemo.Amount_w_psp__c = 0;
        creditMemo.Tax_Amount__c = 0;
        creditMemoList.add(creditMemo);
        
        Credit_Memo_ICS__c creditMemo1 = TestDataUtil.createTestCreditMemo(testRecordICS[1].Id); 
        creditMemo1.Del_LOB_Approver__c = listEmp[0].Id;
        creditMemo1.Sales_Channel__c='E&E (Trade Show)';
        creditMemoList.add(creditMemo1);
        INSERT creditMemoList;  
        
        //Charges__c  Charges = TestDataUtil.createTestCharges(testRecordICS[0].Id);
        //insert Charges; 
        system.debug('creditMemoList==='+creditMemoList[0].LOB_Approver_Email_ID__c);
        
        system.debug('Test Record Is --> '+testRecordICS);
        
        CaseSubmitForApproval.generateEmail(testRecordICS[0].Id);
        
        testRecordICS[0].Requestor_Apporval_Required__c = false;
        testRecordICS[1].Requestor_Apporval_Required__c = false;
        update testRecordICS;
        test.startTest();
        system.debug('Credit_Memo_ICS__c==='+[select LOB_Approver_Email_ID__c from Credit_Memo_ICS__c where id=: creditMemoList[0].Id]);
        CaseSubmitForApproval.generateEmail(testRecordICS[0].Id);
        
        CaseSubmitForApproval.generateEmail(testRecordICS[1].Id);
        test.stopTest();
        
        //for commented code -- goto ==>Commented Line - Part 2
    }
    
    @isTest
    public static void testMethod2() { 
        List<Customer_Service_Inquiries_ICS__c> testRecordICS= [select Id, Case_Approval_Status__c, Name, Requestor_Apporval_Required__c from Customer_Service_Inquiries_ICS__c where Case_Approval_Status__c=:'F&R Open']; 
        List<Employees__c> listEmp = [select Email_Address__c from Employees__c];
        List<AR_Adjustments__c> arAdjList = new List<AR_Adjustments__c>();
        AR_Adjustments__c arAdj = TestDataUtil.createTestARAdjustment(testRecordICS[0].Id);
        arAdj.DAM_LOB_Approver__c = listEmp[0].Id;
        arAdj.DAM_Approver_Email_ID__c = listEmp[0].Email_Address__c;
        arAdj.F_R_Approver__c = listEmp[0].Id;
        arAdj.F_A_Approver_Email__c = listEmp[0].Email_Address__c;
        arAdj.AR1_Approver_Name__c = listEmp[0].Id;
        arAdj.AR1_Approver_Email__c = listEmp[0].Email_Address__c;
        arAdj.CSO_Approver_Name__c = listEmp[0].Id;
        arAdj.CSO_Approver_Email__c = listEmp[0].Email_Address__c;
        arAdj.AR2_Approver_Name__c = listEmp[0].Id;
        arAdj.AR2_Approver_Email__c = listEmp[0].Email_Address__c; 
        //arAdj.DAM_Approver_Status__c = 'Approved';
         
        
        AR_Adjustments__c arAdj1 = TestDataUtil.createTestARAdjustment(testRecordICS[1].Id);
        arAdj1.DAM_LOB_Approver__c = listEmp[0].Id;
        arAdj1.DAM_Approver_Email_ID__c = listEmp[0].Email_Address__c;
        arAdj1.F_R_Approver__c = listEmp[0].Id;
        arAdj1.F_A_Approver_Email__c = listEmp[0].Email_Address__c;
        arAdj1.AR1_Approver_Name__c = listEmp[0].Id;
        arAdj1.AR1_Approver_Email__c = listEmp[0].Email_Address__c;
        arAdj1.CSO_Approver_Name__c = listEmp[0].Id;
        arAdj1.CSO_Approver_Email__c = listEmp[0].Email_Address__c;
        arAdj1.AR2_Approver_Name__c = listEmp[0].Id;
        arAdj1.AR2_Approver_Email__c = listEmp[0].Email_Address__c; 
        arAdj1.Del_F_R_Approver__c = listEmp[0].Id;
        arAdjList.add(arAdj);
        arAdjList.add(arAdj1);
        insert arAdjList;
        
        ICS_Approver_Matrix__c approverMatrix = TestDataUtil.createTestApproverMatrix(listEmp[0].id);
        insert approverMatrix;
        List<Credit_Memo_ICS__c> creditMemoList = new List<Credit_Memo_ICS__c>();
        Credit_Memo_ICS__c creditMemo = TestDataUtil.createTestCreditMemo(testRecordICS[0].Id); 
        creditMemo.Sales_Channel__c='E&E (Trade Show)';
        creditMemo.Amount_w_psp__c = 0;
        creditMemo.Tax_Amount__c = 0;
        creditMemoList.add(creditMemo);
        
        Credit_Memo_ICS__c creditMemo1 = TestDataUtil.createTestCreditMemo(testRecordICS[1].Id); 
        creditMemo1.Del_F_R_Approver__c = listEmp[0].Id;
        creditMemo1.Sales_Channel__c='E&E (Trade Show)';
        creditMemoList.add(creditMemo1);
        INSERT creditMemoList;  
        
        system.debug('Test Record Is --> '+testRecordICS);
        
        CaseSubmitForApproval.generateEmail(testRecordICS[0].Id);
        test.startTest();
        CaseSubmitForApproval.generateEmail(testRecordICS[1].Id);
        test.stopTest();
        
        //for commented code -- goto ==>Commented Line - Part 2
    }
    
    @isTest
    public static void testMethod3() { 
        List<Customer_Service_Inquiries_ICS__c> testRecordICS= [select Id, Case_Approval_Status__c, Name, Requestor_Apporval_Required__c from Customer_Service_Inquiries_ICS__c where Case_Approval_Status__c=:'AR1 Open']; 
        List<Employees__c> listEmp = [select Email_Address__c from Employees__c];
        List<AR_Adjustments__c> arAdjList = new List<AR_Adjustments__c>();
        AR_Adjustments__c arAdj = TestDataUtil.createTestARAdjustment(testRecordICS[0].Id);
        arAdj.DAM_LOB_Approver__c = listEmp[0].Id;
        arAdj.DAM_Approver_Email_ID__c = listEmp[0].Email_Address__c;
        arAdj.F_R_Approver__c = listEmp[0].Id;
        arAdj.F_A_Approver_Email__c = listEmp[0].Email_Address__c;
        arAdj.AR1_Approver_Name__c = listEmp[0].Id;
        arAdj.AR1_Approver_Email__c = listEmp[0].Email_Address__c;
        arAdj.CSO_Approver_Name__c = listEmp[0].Id;
        arAdj.CSO_Approver_Email__c = listEmp[0].Email_Address__c;
        arAdj.AR2_Approver_Name__c = listEmp[0].Id;
        arAdj.AR2_Approver_Email__c = listEmp[0].Email_Address__c; 
        //arAdj.DAM_Approver_Status__c = 'Approved';
         
        
        AR_Adjustments__c arAdj1 = TestDataUtil.createTestARAdjustment(testRecordICS[1].Id);
        arAdj1.DAM_LOB_Approver__c = listEmp[0].Id;
        arAdj1.DAM_Approver_Email_ID__c = listEmp[0].Email_Address__c;
        arAdj1.F_R_Approver__c = listEmp[0].Id;
        arAdj1.F_A_Approver_Email__c = listEmp[0].Email_Address__c;
        arAdj1.AR1_Approver_Name__c = listEmp[0].Id;
        arAdj1.AR1_Approver_Email__c = listEmp[0].Email_Address__c;
        arAdj1.CSO_Approver_Name__c = listEmp[0].Id;
        arAdj1.CSO_Approver_Email__c = listEmp[0].Email_Address__c;
        arAdj1.AR2_Approver_Name__c = listEmp[0].Id;
        arAdj1.AR2_Approver_Email__c = listEmp[0].Email_Address__c; 
        arAdj1.Del_AR1_Approver__c = listEmp[0].Id;
        arAdjList.add(arAdj);
        arAdjList.add(arAdj1);
        insert arAdjList;
        
        ICS_Approver_Matrix__c approverMatrix = TestDataUtil.createTestApproverMatrix(listEmp[0].id);
        insert approverMatrix;
        List<Credit_Memo_ICS__c> creditMemoList = new List<Credit_Memo_ICS__c>();
        Credit_Memo_ICS__c creditMemo = TestDataUtil.createTestCreditMemo(testRecordICS[0].Id); 
        creditMemo.Sales_Channel__c='E&E (Trade Show)';
        creditMemo.Amount_w_psp__c = 0;
        creditMemo.Tax_Amount__c = 0;
        creditMemoList.add(creditMemo);
        
        Credit_Memo_ICS__c creditMemo1 = TestDataUtil.createTestCreditMemo(testRecordICS[1].Id); 
        creditMemo1.Del_AR1_Approver__c = listEmp[0].Id;
        creditMemo1.Sales_Channel__c='E&E (Trade Show)';
        creditMemoList.add(creditMemo1);
        INSERT creditMemoList;
        
        system.debug('Test Record Is --> '+testRecordICS);
        
        List<Refunds_ICS__c> refundList = new  List<Refunds_ICS__c>();
        Refunds_ICS__c refund = TestDataUtil.createTestRefund(testRecordICS[0].Id);
        refund.AR1_Approver_Email_ID__c = listEmp[0].Email_Address__c;
        refundList.add(refund);
        
        Refunds_ICS__c refund1 = TestDataUtil.createTestRefund(testRecordICS[1].Id);
        refund1.Del_AR1_Approver__c = listEmp[0].Id;
        refund1.Del_CSO_Approver__c = listEmp[0].Id;
        refund1.Del_AR2_Approver__c = listEmp[0].Id;
        refundList.add(refund1);
        insert refundList;
        
        test.startTest();
        CaseSubmitForApproval.generateEmail(testRecordICS[0].Id);
        CaseSubmitForApproval.generateEmail(testRecordICS[1].Id);
        test.stopTest();
        
        //for commented code -- goto ==>Commented Line - Part 2
    }
    
    @isTest
    public static void testMethod4() { 
        List<Customer_Service_Inquiries_ICS__c> testRecordICS= [select Id, Case_Approval_Status__c, Name, Requestor_Apporval_Required__c from Customer_Service_Inquiries_ICS__c where Case_Approval_Status__c=:'CSO Open']; 
        List<Employees__c> listEmp = [select Email_Address__c from Employees__c];
        List<AR_Adjustments__c> arAdjList = new List<AR_Adjustments__c>();
        AR_Adjustments__c arAdj = TestDataUtil.createTestARAdjustment(testRecordICS[0].Id);
        arAdj.DAM_LOB_Approver__c = listEmp[0].Id;
        arAdj.DAM_Approver_Email_ID__c = listEmp[0].Email_Address__c;
        arAdj.F_R_Approver__c = listEmp[0].Id;
        arAdj.F_A_Approver_Email__c = listEmp[0].Email_Address__c;
        arAdj.AR1_Approver_Name__c = listEmp[0].Id;
        arAdj.AR1_Approver_Email__c = listEmp[0].Email_Address__c;
        arAdj.CSO_Approver_Name__c = listEmp[0].Id;
        arAdj.CSO_Approver_Email__c = listEmp[0].Email_Address__c;
        arAdj.AR2_Approver_Name__c = listEmp[0].Id;
        arAdj.AR2_Approver_Email__c = listEmp[0].Email_Address__c; 
        //arAdj.DAM_Approver_Status__c = 'Approved';
         
        
        AR_Adjustments__c arAdj1 = TestDataUtil.createTestARAdjustment(testRecordICS[1].Id);
        arAdj1.DAM_LOB_Approver__c = listEmp[0].Id;
        arAdj1.DAM_Approver_Email_ID__c = listEmp[0].Email_Address__c;
        arAdj1.F_R_Approver__c = listEmp[0].Id;
        arAdj1.F_A_Approver_Email__c = listEmp[0].Email_Address__c;
        arAdj1.AR1_Approver_Name__c = listEmp[0].Id;
        arAdj1.AR1_Approver_Email__c = listEmp[0].Email_Address__c;
        arAdj1.CSO_Approver_Name__c = listEmp[0].Id;
        arAdj1.CSO_Approver_Email__c = listEmp[0].Email_Address__c;
        arAdj1.AR2_Approver_Name__c = listEmp[0].Id;
        arAdj1.AR2_Approver_Email__c = listEmp[0].Email_Address__c; 
        arAdj1.Del_CSO_Approver__c = listEmp[0].Id;
        arAdjList.add(arAdj);
        arAdjList.add(arAdj1);
        insert arAdjList;
        
        ICS_Approver_Matrix__c approverMatrix = TestDataUtil.createTestApproverMatrix(listEmp[0].id);
        insert approverMatrix;
        List<Credit_Memo_ICS__c> creditMemoList = new List<Credit_Memo_ICS__c>();
        Credit_Memo_ICS__c creditMemo = TestDataUtil.createTestCreditMemo(testRecordICS[0].Id); 
        creditMemo.Sales_Channel__c='E&E (Trade Show)';
        creditMemo.Amount_w_psp__c = 0;
        creditMemo.Tax_Amount__c = 0;
        creditMemoList.add(creditMemo);
        
        Credit_Memo_ICS__c creditMemo1 = TestDataUtil.createTestCreditMemo(testRecordICS[1].Id); 
        creditMemo1.Del_CSO_Approver__c = listEmp[0].Id;
        creditMemo1.Sales_Channel__c='E&E (Trade Show)';
        creditMemoList.add(creditMemo1);
        INSERT creditMemoList;
        
        List<Refunds_ICS__c> refundList = new  List<Refunds_ICS__c>();
        Refunds_ICS__c refund = TestDataUtil.createTestRefund(testRecordICS[0].Id);
       // refund.CSO_Approver_Email__c = listEmp[0].Email_Address__c;
        refundList.add(refund);
        
        Refunds_ICS__c refund1 = TestDataUtil.createTestRefund(testRecordICS[1].Id);
        refund1.Del_AR1_Approver__c = listEmp[0].Id;
        refund1.Del_CSO_Approver__c = listEmp[0].Id;
        refund1.Del_AR2_Approver__c = listEmp[0].Id;
        refundList.add(refund1);
        insert refundList;
        
        system.debug('Test Record Is --> '+testRecordICS);
        
        
        test.startTest();
        CaseSubmitForApproval.generateEmail(testRecordICS[0].Id);
        CaseSubmitForApproval.generateEmail(testRecordICS[1].Id);
        test.stopTest();
        
        //for commented code -- goto ==>Commented Line - Part 2
    }
    
    @isTest
    public static void testMethod5() { 
        List<Customer_Service_Inquiries_ICS__c> testRecordICS= [select Id, Case_Approval_Status__c, Name, Requestor_Apporval_Required__c from Customer_Service_Inquiries_ICS__c where Case_Approval_Status__c=:'AR2 Open']; 
        List<Employees__c> listEmp = [select Email_Address__c from Employees__c];
        List<AR_Adjustments__c> arAdjList = new List<AR_Adjustments__c>();
        AR_Adjustments__c arAdj = TestDataUtil.createTestARAdjustment(testRecordICS[0].Id);
        arAdj.DAM_LOB_Approver__c = listEmp[0].Id;
        arAdj.DAM_Approver_Email_ID__c = listEmp[0].Email_Address__c;
        arAdj.F_R_Approver__c = listEmp[0].Id;
        arAdj.F_A_Approver_Email__c = listEmp[0].Email_Address__c;
        arAdj.AR1_Approver_Name__c = listEmp[0].Id;
        arAdj.AR1_Approver_Email__c = listEmp[0].Email_Address__c;
        arAdj.CSO_Approver_Name__c = listEmp[0].Id;
        arAdj.CSO_Approver_Email__c = listEmp[0].Email_Address__c;
        arAdj.AR2_Approver_Name__c = listEmp[0].Id;
        arAdj.AR2_Approver_Email__c = listEmp[0].Email_Address__c; 
        //arAdj.DAM_Approver_Status__c = 'Approved';
         
        
        AR_Adjustments__c arAdj1 = TestDataUtil.createTestARAdjustment(testRecordICS[1].Id);
        arAdj1.DAM_LOB_Approver__c = listEmp[0].Id;
        arAdj1.DAM_Approver_Email_ID__c = listEmp[0].Email_Address__c;
        arAdj1.F_R_Approver__c = listEmp[0].Id;
        arAdj1.F_A_Approver_Email__c = listEmp[0].Email_Address__c;
        arAdj1.AR1_Approver_Name__c = listEmp[0].Id;
        arAdj1.AR1_Approver_Email__c = listEmp[0].Email_Address__c;
        arAdj1.CSO_Approver_Name__c = listEmp[0].Id;
        arAdj1.CSO_Approver_Email__c = listEmp[0].Email_Address__c;
        arAdj1.AR2_Approver_Name__c = listEmp[0].Id;
        arAdj1.AR2_Approver_Email__c = listEmp[0].Email_Address__c; 
        arAdj1.Del_AR2_Approver__c = listEmp[0].Id;
        arAdjList.add(arAdj);
        arAdjList.add(arAdj1);
        insert arAdjList;
        
        ICS_Approver_Matrix__c approverMatrix = TestDataUtil.createTestApproverMatrix(listEmp[0].id);
        insert approverMatrix;
        List<Credit_Memo_ICS__c> creditMemoList = new List<Credit_Memo_ICS__c>();
        Credit_Memo_ICS__c creditMemo = TestDataUtil.createTestCreditMemo(testRecordICS[0].Id); 
        creditMemo.Sales_Channel__c='E&E (Trade Show)';
        creditMemo.Amount_w_psp__c = 0;
        creditMemo.Tax_Amount__c = 0;
        creditMemoList.add(creditMemo);
        
        Credit_Memo_ICS__c creditMemo1 = TestDataUtil.createTestCreditMemo(testRecordICS[1].Id); 
        creditMemo1.Del_AR2_Approver__c = listEmp[0].Id;
        creditMemo1.Sales_Channel__c='E&E (Trade Show)';
        creditMemoList.add(creditMemo1);
        INSERT creditMemoList;
        
        List<Refunds_ICS__c> refundList = new  List<Refunds_ICS__c>();
        Refunds_ICS__c refund = TestDataUtil.createTestRefund(testRecordICS[0].Id);
        refund.AR2_Approver_Email_ID__c = listEmp[0].Email_Address__c;
        refundList.add(refund);
        
        Refunds_ICS__c refund1 = TestDataUtil.createTestRefund(testRecordICS[1].Id);
        refund1.Del_AR2_Approver__c = listEmp[0].Id;
        refundList.add(refund1);
        insert refundList;
        
        system.debug('Test Record Is --> '+testRecordICS);
        
        test.startTest();
        CaseSubmitForApproval.generateEmail(testRecordICS[0].Id);
        CaseSubmitForApproval.generateEmail(testRecordICS[1].Id);
        test.stopTest();
        
        //for commented code -- goto ==>Commented Line - Part 2
    }
    
    @isTest
    public static void testMethod6() { 
        List<Customer_Service_Inquiries_ICS__c> testRecordICS= [select Id, Case_Approval_Status__c, Name, Requestor_Apporval_Required__c from Customer_Service_Inquiries_ICS__c where Case_Approval_Status__c = 'Case Open']; 
        List<Employees__c> listEmp = [select Email_Address__c from Employees__c];
        
        Charges__c  Charges = TestDataUtil.createTestCharges(testRecordICS[0].Id);
        insert Charges; 
        
        Payment_Transfer_ICS__c Payment = TestDataUtil.createTestPaymentTransfer(testRecordICS[0].Id);
         insert Payment; 
         
        
        List<Receipt_Reversals__c> receiptReversalList = new List<Receipt_Reversals__c>();
        Receipt_Reversals__c receiptReversal = TestDataUtil.createTestReceiptReversal(testRecordICS[0].Id);
        receiptReversal.Additional_Approver_Name__c = listEmp[0].Id;
        receiptReversal.Del_Additional_Approver__c = listEmp[0].Id;
       // receiptReversal.Del_Additional_Approver_Email__c = 'as@slkgroup.com';
        receiptReversalList.add(receiptReversal);       
        insert receiptReversalList; 
        
        List<Refunds_ICS__c> refundList = new  List<Refunds_ICS__c>();
        Refunds_ICS__c refund = TestDataUtil.createTestRefund(testRecordICS[0].Id);
         refund.Del_AR1_Approver__c = listEmp[0].Id;
        refund.Del_CSO_Approver__c = listEmp[0].Id;
        refund.Del_AR2_Approver__c = listEmp[0].Id;
        refundList.add(refund);
        insert refundList;
        
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=refundList[0].id;
        insert attach;
        
        test.startTest();

        CaseSubmitForApproval.generateEmail(testRecordICS[0].Id);
        test.stopTest();
        
        //for commented code -- goto ==>Commented Line - Part 2
    }
    
    @isTest
    public static void testMethod7() { 
        List<Customer_Service_Inquiries_ICS__c> testRecordICS= [select Id, Case_Approval_Status__c, Name, Requestor_Apporval_Required__c from Customer_Service_Inquiries_ICS__c where Case_Approval_Status__c = 'Additional Open']; 
        List<Employees__c> listEmp = [select Email_Address__c from Employees__c];
        List<Receipt_Reversals__c> receiptReversalList = new List<Receipt_Reversals__c>();
        
        ICS_Approver_Matrix__c approverMatrix = TestDataUtil.createTestApproverMatrix(listEmp[0].id);
        insert approverMatrix;
        List<Credit_Memo_ICS__c> creditMemoList = new List<Credit_Memo_ICS__c>();
        Credit_Memo_ICS__c creditMemo = TestDataUtil.createTestCreditMemo(testRecordICS[0].Id); 
        creditMemo.Sales_Channel__c='E&E (Trade Show)';
        creditMemo.Amount_w_psp__c = 0;
        creditMemo.Tax_Amount__c = 0;
        creditMemoList.add(creditMemo);
        
        Credit_Memo_ICS__c creditMemo1 = TestDataUtil.createTestCreditMemo(testRecordICS[1].Id); 
        creditMemo1.Del_Additional_Approver__c = listEmp[0].Id;
        creditMemo1.Sales_Channel__c='E&E (Trade Show)';
        creditMemoList.add(creditMemo1);
        INSERT creditMemoList;
        
        Receipt_Reversals__c receiptReversal1 = TestDataUtil.createTestReceiptReversal(testRecordICS[0].Id);
        //receiptReversal1.Additional_Approver_Name__c = listEmp[0].Id;
        receiptReversal1.Del_Additional_Approver__c = listEmp[0].Id;
       // receiptReversal.Del_Additional_Approver_Email__c = 'as@slkgroup.com';
        receiptReversalList.add(receiptReversal1);
        
        Receipt_Reversals__c receiptReversal2 = TestDataUtil.createTestReceiptReversal(testRecordICS[1].Id);
        receiptReversal2.Additional_Approver_Name__c = listEmp[0].Id;
        receiptReversalList.add(receiptReversal2);
        
        insert receiptReversalList; 
        test.startTest();
        
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=creditMemoList[0].id;
        insert attach;
        
        CaseSubmitForApproval.generateEmail(testRecordICS[0].Id);
        CaseSubmitForApproval.generateEmail(testRecordICS[1].Id);
        test.stopTest();
        
        //for commented code -- goto ==>Commented Line - Part 2
    }
}