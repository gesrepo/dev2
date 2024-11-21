@isTest
public class CaseApproveRejectPageControllerTest {
    
    @testSetup
    static void testData() {
        List<Employees__c> listEmp = new List<Employees__c>();
        Employees__c emp = TestDataUtil.createTestEmployee();
        Employees__c emp1 = TestDataUtil.createTestEmployee();
        emp1.Email_Address__c=
            'test1@test1.com';

        listEmp.add(emp);
        listEmp.add(emp1);
        insert listEmp;
        ICS_Approver_Matrix__c approverMatrix = TestDataUtil.createTestApproverMatrix(listEmp[0].id);
        insert approverMatrix;
        Customer_Service_Inquiries_ICS__c ICS = TestDataUtil.createTestCustomerServiceInquries();
        ICS.Case_Requestor__c = listEmp[0].Id;
        ICS.Email_Copy_To__c = listEmp[0].Id;
        ICS.Case_Approval_Status__c = 'Requestor Submitted';
        insert ICS;
        Customer_Service_Inquiries_ICS__c ICS1 = TestDataUtil.createTestCustomerServiceInquries();
        ICS1.Case_Requestor__c = listEmp[0].Id;
        ICS1.Email_Copy_To__c = listEmp[0].Id;
        ICS1.Case_Approval_Status__c = 'Requestor Rejected';
        insert ICS1;
        AR_Adjustments__c arAdj = TestDataUtil.createTestARAdjustment(ICS.Id);
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
        insert arAdj;
    
    AR_Adjustments__c DelarAdj = TestDataUtil.createTestARAdjustment(ICS.Id);
        DelarAdj.Del_DAM_LOB_Approver__c = listEmp[0].Id;
        DelarAdj.Del_F_R_Approver__c = listEmp[0].Id;
        DelarAdj.Del_AR1_Approver__c = listEmp[0].Id;
        DelarAdj.Del_CSO_Approver__c = listEmp[0].Id;
        DelarAdj.Del_AR2_Approver__c = listEmp[0].Id;
        insert DelarAdj;
/*****      
    test.starttest();
        Credit_Memo_ICS__c creditMemo = TestDataUtil.createTestCreditMemo(ICS.Id);
        creditMemo.LOB_Approver_Name__c = listEmp[1].Id;
        creditMemo.LOB_Approver_Email_ID__c = listEmp[1].Email_Address__c;
        creditMemo.F_R_Approver_Name__c = listEmp[1].Id;
        creditMemo.F_R_Approver_Email_ID__c = listEmp[1].Email_Address__c;
        creditMemo.AR1_Approver_Name__c = listEmp[1].Id;
        creditMemo.AR1_Approver_Email_ID__c = listEmp[1].Email_Address__c;
        creditMemo.CSO_Approver_Name__c = listEmp[1].Id;
        creditMemo.CSO_Approver_Email__c = listEmp[1].Email_Address__c;
        creditMemo.AR2_Approver_Name__c = listEmp[1].Id;
        creditMemo.AR2_Approver_Email_ID__c = listEmp[1].Email_Address__c;
        creditMemo.Additional_Approver_Name__c = listEmp[1].Id;
        creditMemo.Additional_Approver_Email_ID__c = listEmp[1].Email_Address__c;
        insert creditMemo; 
    test.stoptest();
*****/  
    Credit_Memo_ICS__c DelcreditMemo = TestDataUtil.createTestCreditMemo(ICS.Id);
        DelcreditMemo.Del_LOB_Approver__c = listEmp[0].Id;
        DelcreditMemo.Del_F_R_Approver__c = listEmp[0].Id;
        DelcreditMemo.Del_AR1_Approver__c = listEmp[0].Id;
        DelcreditMemo.Del_CSO_Approver__c = listEmp[0].Id;
        DelcreditMemo.Del_AR2_Approver__c = listEmp[0].Id;
        DelcreditMemo.Del_Additional_Approver__c = listEmp[0].Id;
        insert DelcreditMemo;
    
        Refunds_ICS__c refund = TestDataUtil.createTestRefund(ICS.Id);
        refund.AR1_Approver_Name__c = listEmp[0].Id;
        refund.AR1_Approver_Email_ID__c = listEmp[0].Email_Address__c;
        refund.CSO_Approver_Name__c = listEmp[0].Id;
       // refund.CSO_Approver_Email__c = listEmp[0].Email_Address__c;
        refund.AR2_Approver_Name__c = listEmp[0].Id;
        refund.AR2_Approver_Email_ID__c = listEmp[0].Email_Address__c;
        insert refund;
        refund.Del_AR1_Approver__c = listEmp[0].Id;
        upsert refund;
    

    
        Receipt_Reversals__c receiptReversal = TestDataUtil.createTestReceiptReversal(ICS.Id);
        receiptReversal.Additional_Approver_Name__c = listEmp[0].Id;
        //receiptReversal.Approver_Email__c = listEmp[0].Email_Address__c;
        insert receiptReversal;

    }
    
  @istest// adj Fr1 sub
    public static void test1(){            
        Customer_Service_Inquiries_ICS__c csiIcs = [select Id, Case_Approval_Status__c, Email_Copy_To__c, Review_Comments__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.CaseApproveRejectPage;
        pageRef.getParameters().put('id', String.valueOf(csiIcs.Id));
        pageRef.getParameters().put('email', 'test@test.com');
        pageRef.getParameters().put('status', 'APPROVE');
        pageRef.getParameters().put('transactionType', 'All');
        Test.setCurrentPage(pageRef);        
        ApexPages.StandardController sc=new ApexPages.StandardController(csiIcs);        
        CaseApproveRejectPageController cont =new CaseApproveRejectPageController(sc);
        Test.StartTest();
        PageReference pr = cont.customerAction();
        pageRef.getParameters().put('status', 'REJECT');
        ApexPages.StandardController sc1=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont1 =new CaseApproveRejectPageController(sc1);
        cont1.caseRecord.Review_Comments__c = 'Test';
        cont1.customerAction();
        Test.StopTest();
        
    } 
    
    
    
    @istest // LOB Approved
    public static void LOBApprove(){            
        Customer_Service_Inquiries_ICS__c csiIcs = [select Id, Case_Approval_Status__c, Email_Copy_To__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.CaseApproveRejectPage;
        pageRef.getParameters().put('id', String.valueOf(csiIcs.Id));
        pageRef.getParameters().put('email', 'test@test.com');
        pageRef.getParameters().put('status', 'APPROVE');
        pageRef.getParameters().put('transactionType', 'All');
        Test.setCurrentPage(pageRef);
        csiIcs.Case_Approval_Status__c = 'LOB Submitted';
        update csiIcs;
        ApexPages.StandardController sc=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont =new CaseApproveRejectPageController(sc);
        
        List<Employees__c> listEmp = [Select Id, Email_Address__c From Employees__c LIMIT 2];
        
         Credit_Memo_ICS__c creditMemo = [Select Del_LOB_Approver__c,Del_F_R_Approver__c,Del_AR1_Approver__c, LOB_Approver_Email_ID__c,
                                          Del_CSO_Approver__c,Del_AR2_Approver__c,Del_Additional_Approver__c,Del_AR1_Approver_Email__c
                                         from Credit_Memo_ICS__c];
        creditMemo.Del_LOB_Approver__c = listEmp[0].Id;
        creditMemo.Del_F_R_Approver__c = listEmp[0].Id;
        creditMemo.Del_AR1_Approver__c = listEmp[0].Id;
        creditMemo.Del_CSO_Approver__c = listEmp[0].Id;
        creditMemo.Del_AR2_Approver__c = listEmp[0].Id;
        creditMemo.Del_Additional_Approver__c = listEmp[0].Id;
        creditMemo.LOB_Approver_Email_ID__c ='test@gm.com';
        Update creditMemo;
    
        Test.StartTest();
        PageReference pr = cont.customerAction();
        pageRef.getParameters().put('status', 'APPROVE');
        ApexPages.StandardController sc1=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont1 =new CaseApproveRejectPageController(sc1);
        cont1.caseRecord.Review_Comments__c = 'Test';
        cont1.customerAction();
               
        Test.StopTest();
    } 
    
     @istest //LOB Reject
    public static void LOBReject(){            
        Customer_Service_Inquiries_ICS__c csiIcs = [select Id, Case_Approval_Status__c, Email_Copy_To__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.CaseApproveRejectPage;
        pageRef.getParameters().put('id', String.valueOf(csiIcs.Id));
        pageRef.getParameters().put('email', 'test@test.com');
        pageRef.getParameters().put('status', 'REJECT');
        pageRef.getParameters().put('transactionType', 'All');
        Test.setCurrentPage(pageRef);
        csiIcs.Case_Approval_Status__c = 'LOB Rejected';
        update csiIcs;
        ApexPages.StandardController sc=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont =new CaseApproveRejectPageController(sc);
        
        List<Employees__c> listEmp = [Select Id, Email_Address__c From Employees__c LIMIT 2];
        
         Credit_Memo_ICS__c creditMemo = [Select Del_LOB_Approver__c,Del_F_R_Approver__c,Del_AR1_Approver__c,
                                          Del_CSO_Approver__c, LOB_Approver_Email_ID__c, Del_AR2_Approver__c,Del_Additional_Approver__c
                                         from Credit_Memo_ICS__c];
        creditMemo.Del_LOB_Approver__c = listEmp[0].Id;
        creditMemo.Del_F_R_Approver__c = listEmp[0].Id;
        creditMemo.Del_AR1_Approver__c = listEmp[0].Id;
        creditMemo.Del_CSO_Approver__c = listEmp[0].Id;
        creditMemo.Del_AR2_Approver__c = listEmp[0].Id;
        creditMemo.Del_Additional_Approver__c = listEmp[0].Id;
        Update creditMemo;
        
        Test.StartTest();
        PageReference pr = cont.customerAction();
        pageRef.getParameters().put('status', 'REJECT');
        ApexPages.StandardController sc1=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont1 =new CaseApproveRejectPageController(sc1);
        cont1.caseRecord.Review_Comments__c = 'Test';
        cont1.customerAction();
        
        Test.StopTest();
    } 
     @istest
    public static void FandRApprove(){            
        Customer_Service_Inquiries_ICS__c csiIcs = [select Id, Case_Approval_Status__c, Email_Copy_To__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.CaseApproveRejectPage;
        pageRef.getParameters().put('id', String.valueOf(csiIcs.Id));
        pageRef.getParameters().put('email', 'test@test.com');
        pageRef.getParameters().put('status', 'APPROVE');
        pageRef.getParameters().put('transactionType', 'All');
        Test.setCurrentPage(pageRef);
        csiIcs.Case_Approval_Status__c = 'F&R Submitted';
        update csiIcs;
        ApexPages.StandardController sc=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont =new CaseApproveRejectPageController(sc);
        List<Employees__c> listEmp = [Select Id, Email_Address__c From Employees__c LIMIT 2];
        
         Credit_Memo_ICS__c creditMemo = [Select Del_LOB_Approver__c,Del_F_R_Approver__c,Del_AR1_Approver__c,
                                          Del_CSO_Approver__c, LOB_Approver_Email_ID__c, Del_AR2_Approver__c,Del_Additional_Approver__c
                                         from Credit_Memo_ICS__c limit 1];
        creditMemo.Del_LOB_Approver__c = listEmp[0].Id;
        creditMemo.Del_F_R_Approver__c = listEmp[0].Id;
        creditMemo.Del_AR1_Approver__c = listEmp[0].Id;
        creditMemo.Del_CSO_Approver__c = listEmp[0].Id;
        creditMemo.Del_AR2_Approver__c = listEmp[0].Id;
        creditMemo.Del_Additional_Approver__c = listEmp[0].Id;
        Update creditMemo;
        
        Test.StartTest();
        PageReference pr = cont.customerAction();
        pageRef.getParameters().put('status', 'APPROVE');
        ApexPages.StandardController sc1=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont1 =new CaseApproveRejectPageController(sc1);
        cont1.caseRecord.Review_Comments__c = 'Test';
        cont1.customerAction();
        Test.StopTest();
    } 
    
         @istest
       public static void FandRReject(){            
        Customer_Service_Inquiries_ICS__c csiIcs = [select Id, Case_Approval_Status__c, Email_Copy_To__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.CaseApproveRejectPage;
        pageRef.getParameters().put('id', String.valueOf(csiIcs.Id));
        pageRef.getParameters().put('email', 'test@test.com');
        pageRef.getParameters().put('status', 'REJECT');
        pageRef.getParameters().put('transactionType', 'All');
        Test.setCurrentPage(pageRef);
        csiIcs.Case_Approval_Status__c = 'F&R Submitted';
        update csiIcs;
        ApexPages.StandardController sc=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont =new CaseApproveRejectPageController(sc);
        
        List<Employees__c> listEmp = [Select Id, Email_Address__c From Employees__c LIMIT 2];
        
         Credit_Memo_ICS__c creditMemo = [Select Del_LOB_Approver__c, LOB_Approver_Email_ID__c, Del_F_R_Approver__c,Del_AR1_Approver__c,
                                          Del_CSO_Approver__c,Del_AR2_Approver__c,Del_Additional_Approver__c
                                         from Credit_Memo_ICS__c limit 1];
        creditMemo.Del_LOB_Approver__c = listEmp[0].Id;
        creditMemo.Del_F_R_Approver__c = listEmp[0].Id;
        creditMemo.Del_AR1_Approver__c = listEmp[0].Id;
        creditMemo.Del_CSO_Approver__c = listEmp[0].Id;
        creditMemo.Del_AR2_Approver__c = listEmp[0].Id;
        creditMemo.Del_Additional_Approver__c = listEmp[0].Id;
        Update creditMemo;
        
        Test.StartTest();
        PageReference pr = cont.customerAction();
        pageRef.getParameters().put('status', 'REJECT');
        ApexPages.StandardController sc1=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont1 =new CaseApproveRejectPageController(sc1);
        cont1.caseRecord.Review_Comments__c = 'Test';
        cont1.customerAction();
        Test.StopTest();
    }
    
     @istest
    public static void AR1Approve(){            
        Customer_Service_Inquiries_ICS__c csiIcs = [select Id, Case_Approval_Status__c, Email_Copy_To__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.CaseApproveRejectPage;
        pageRef.getParameters().put('id', String.valueOf(csiIcs.Id));
        pageRef.getParameters().put('email', 'test@test.com');
        pageRef.getParameters().put('status', 'APPROVE');
        pageRef.getParameters().put('transactionType', 'All');
        Test.setCurrentPage(pageRef);
        csiIcs.Case_Approval_Status__c = 'AR1 Submitted';
        update csiIcs;
        ApexPages.StandardController sc=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont =new CaseApproveRejectPageController(sc);
         Test.StartTest();
        PageReference pr = cont.customerAction();
        pageRef.getParameters().put('status', 'APPROVE');
        ApexPages.StandardController sc1=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont1 =new CaseApproveRejectPageController(sc1);
        cont1.caseRecord.Review_Comments__c = 'Test';
        cont1.customerAction();
        Test.StopTest();
    } 
     
        
        
     @istest
    public static void AR1Reject(){            
        Customer_Service_Inquiries_ICS__c csiIcs = [select Id, Case_Approval_Status__c, Email_Copy_To__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.CaseApproveRejectPage;
        pageRef.getParameters().put('id', String.valueOf(csiIcs.Id));
        pageRef.getParameters().put('email', 'test@test.com');
        pageRef.getParameters().put('status', 'REJECT');
        pageRef.getParameters().put('transactionType', 'All');
        Test.setCurrentPage(pageRef);
        csiIcs.Case_Approval_Status__c = 'AR1 Submitted';
        update csiIcs;
        ApexPages.StandardController sc=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont =new CaseApproveRejectPageController(sc);
                        
        Test.StartTest();
        PageReference pr = cont.customerAction();
        pageRef.getParameters().put('status', 'REJECT');
        ApexPages.StandardController sc1=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont1 =new CaseApproveRejectPageController(sc1);
        cont1.caseRecord.Review_Comments__c = 'Test';
        cont1.customerAction();
        Test.StopTest();
    } 
    
    @istest
    public static void CSOApprove(){            
        Customer_Service_Inquiries_ICS__c csiIcs = [select Id, Case_Approval_Status__c, Email_Copy_To__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.CaseApproveRejectPage;
        pageRef.getParameters().put('id', String.valueOf(csiIcs.Id));
        pageRef.getParameters().put('email', 'test@test.com');
        pageRef.getParameters().put('status', 'APPROVE');
        pageRef.getParameters().put('transactionType', 'All');
        Test.setCurrentPage(pageRef);
        csiIcs.Case_Approval_Status__c = 'CSO Submitted';
        update csiIcs;
        ApexPages.StandardController sc=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont =new CaseApproveRejectPageController(sc);
        Test.StartTest();
         List<Employees__c> listEmp = [Select Id, Email_Address__c From Employees__c LIMIT 2];
        
          Refunds_ICS__c refund= [Select Del_AR1_Approver__c,Del_CSO_Approver_Email__c,
                                         Del_CSO_Approver__c,Del_AR2_Approver__c
                                         from Refunds_ICS__c];
        
           
        refund.Del_AR1_Approver__c = listEmp[0].Id;
        refund.Del_CSO_Approver__c = listEmp[0].Id;
        refund.Del_AR2_Approver__c = listEmp[0].Id;
        System.debug('@@@Test--Email_Address__c-->'+listEmp[0].Email_Address__c);
        //refund.Del_CSO_Approver_Email__c = listEmp[0].Email_Address__c;
        Update refund;
           
       
        PageReference pr = cont.customerAction();
        pageRef.getParameters().put('status', 'APPROVE');
        ApexPages.StandardController sc1=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont1 =new CaseApproveRejectPageController(sc1);
        cont1.caseRecord.Review_Comments__c = 'Test';
        cont1.customerAction();
        Test.StopTest();
    } 
       
        @istest
    public static void CSOReject(){            
        Customer_Service_Inquiries_ICS__c csiIcs = [select Id, Case_Approval_Status__c, Email_Copy_To__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.CaseApproveRejectPage;
        pageRef.getParameters().put('id', String.valueOf(csiIcs.Id));
        pageRef.getParameters().put('email', 'test@test.com');
        pageRef.getParameters().put('status', 'REJECT');
        pageRef.getParameters().put('transactionType', 'All');
        Test.setCurrentPage(pageRef);
        csiIcs.Case_Approval_Status__c = 'CSO Submitted';
        update csiIcs;
        ApexPages.StandardController sc=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont =new CaseApproveRejectPageController(sc);
        Test.StartTest();
         List<Employees__c> listEmp = [Select Id, Email_Address__c From Employees__c LIMIT 2];
        
          Refunds_ICS__c refund= [Select Del_AR1_Approver__c,Del_CSO_Approver_Email__c,
                                         Del_CSO_Approver__c,Del_AR2_Approver__c
                                         from Refunds_ICS__c];
        
           
        refund.Del_AR1_Approver__c = listEmp[0].Id;
        refund.Del_CSO_Approver__c = listEmp[0].Id;
        refund.Del_AR2_Approver__c = listEmp[0].Id;
        System.debug('@@@Test--Email_Address__c-->'+listEmp[0].Email_Address__c);
        //refund.Del_CSO_Approver_Email__c = listEmp[0].Email_Address__c;
        Update refund;
        PageReference pr = cont.customerAction();
        pageRef.getParameters().put('status', 'REJECT');
        ApexPages.StandardController sc1=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont1 =new CaseApproveRejectPageController(sc1);
        cont1.caseRecord.Review_Comments__c = 'Test';
        cont1.customerAction();
        Test.StopTest();
    }
     @istest
    public static void CSOReject1(){            
        Customer_Service_Inquiries_ICS__c csiIcs = [select Id, Case_Approval_Status__c, Email_Copy_To__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.CaseApproveRejectPage;
        pageRef.getParameters().put('id', String.valueOf(csiIcs.Id));
        pageRef.getParameters().put('email', 'test@test.com');
        pageRef.getParameters().put('status', 'REJECT');
        pageRef.getParameters().put('transactionType', 'All');
        Test.setCurrentPage(pageRef);
        csiIcs.Case_Approval_Status__c = 'CSO Submitted';
        update csiIcs;
        ApexPages.StandardController sc=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont =new CaseApproveRejectPageController(sc);
        
        Test.StartTest();
        PageReference pr = cont.customerAction();
        pageRef.getParameters().put('status', 'REJECT');
        ApexPages.StandardController sc1=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont1 =new CaseApproveRejectPageController(sc1);
        cont1.caseRecord.Review_Comments__c = 'Test';
        cont1.customerAction();
        Test.StopTest();
    }

     @istest
    public static void AR2Approve(){     
   Customer_Service_Inquiries_ICS__c csiIcs = [select Id, Case_Approval_Status__c, Email_Copy_To__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.CaseApproveRejectPage;
        pageRef.getParameters().put('id', String.valueOf(csiIcs.Id));
        pageRef.getParameters().put('email', 'test@test.com');
        pageRef.getParameters().put('status', 'APPROVE');
        pageRef.getParameters().put('transactionType', 'All');
        Test.setCurrentPage(pageRef);
        csiIcs.Case_Approval_Status__c = 'AR2 Submitted';
        update csiIcs;
        ApexPages.StandardController sc=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont =new CaseApproveRejectPageController(sc);       
        
        Test.StartTest();
        PageReference pr = cont.customerAction();
        pageRef.getParameters().put('status', 'APPROVE');
        ApexPages.StandardController sc1=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont1 =new CaseApproveRejectPageController(sc1);
        cont1.caseRecord.Review_Comments__c = 'Test';
        cont1.customerAction();
        Test.StopTest(); 
    } 

     @istest
    public static void AR2Reject(){
        Customer_Service_Inquiries_ICS__c csiIcs = [select Id, Case_Approval_Status__c, Email_Copy_To__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.CaseApproveRejectPage;
        pageRef.getParameters().put('id', String.valueOf(csiIcs.Id));
        pageRef.getParameters().put('email', 'test@test.com');
        pageRef.getParameters().put('status', 'REJECT');
        pageRef.getParameters().put('transactionType', 'All');
        Test.setCurrentPage(pageRef);
        csiIcs.Case_Approval_Status__c = 'AR2 Submitted';
        update csiIcs;
        ApexPages.StandardController sc=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont =new CaseApproveRejectPageController(sc);
        
        Test.StartTest();
               
        PageReference pr = cont.customerAction();
        pageRef.getParameters().put('status', 'REJECT');
        ApexPages.StandardController sc1=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont1 =new CaseApproveRejectPageController(sc1);
        cont1.caseRecord.Review_Comments__c = 'Test';
        cont1.customerAction();
        Test.StopTest();
    }  
    @istest
    public static void AR2Reject1(){
        Customer_Service_Inquiries_ICS__c csiIcs = [select Id, Case_Approval_Status__c, Email_Copy_To__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.CaseApproveRejectPage;
        pageRef.getParameters().put('id', String.valueOf(csiIcs.Id));
        pageRef.getParameters().put('email', 'test@test.com');
        pageRef.getParameters().put('status', 'REJECT');
        pageRef.getParameters().put('transactionType', 'All');
        Test.setCurrentPage(pageRef);
        csiIcs.Case_Approval_Status__c = 'AR2 Submitted';
        update csiIcs;
        ApexPages.StandardController sc=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont =new CaseApproveRejectPageController(sc);
        
        Test.StartTest();
         List<Employees__c> listEmp = [Select Id, Email_Address__c From Employees__c LIMIT 2];
        
          Refunds_ICS__c refund= [Select Del_AR1_Approver__c,Del_CSO_Approver_Email__c,
                                         Del_CSO_Approver__c,Del_AR2_Approver__c
                                         from Refunds_ICS__c];
        
           
        refund.Del_AR1_Approver__c = listEmp[0].Id;
        refund.Del_CSO_Approver__c = listEmp[0].Id;
        refund.Del_AR2_Approver__c = listEmp[0].Id;
        System.debug('@@@Test--Email_Address__c-->'+listEmp[0].Email_Address__c);
        //refund.Del_CSO_Approver_Email__c = listEmp[0].Email_Address__c;
        Update refund;
        
        PageReference pr = cont.customerAction();
        pageRef.getParameters().put('status', 'REJECT');
        ApexPages.StandardController sc1=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont1 =new CaseApproveRejectPageController(sc1);
        cont1.caseRecord.Review_Comments__c = 'Test';
        cont1.customerAction();
        Test.StopTest();
    } 

    @istest
    public static void AddApprove(){            
        Customer_Service_Inquiries_ICS__c csiIcs = [select Id, Case_Approval_Status__c, Email_Copy_To__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.CaseApproveRejectPage;
        pageRef.getParameters().put('id', String.valueOf(csiIcs.Id));
        pageRef.getParameters().put('email', 'test@test.com');
        pageRef.getParameters().put('status', 'APPROVE');
        pageRef.getParameters().put('transactionType', 'All');
        Test.setCurrentPage(pageRef);
        csiIcs.Case_Approval_Status__c = 'Additional Submitted';
        update csiIcs;
        ApexPages.StandardController sc=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont =new CaseApproveRejectPageController(sc);
        
        List<Employees__c> listEmp = [Select Id, Email_Address__c From Employees__c LIMIT 2];
        
         Credit_Memo_ICS__c creditMemo = [Select Del_LOB_Approver__c, LOB_Approver_Email_ID__c, Del_F_R_Approver__c,Del_AR1_Approver__c,
                                          Del_CSO_Approver__c,Del_AR2_Approver__c,Del_Additional_Approver__c
                                         from Credit_Memo_ICS__c limit 1];
        creditMemo.Del_LOB_Approver__c = listEmp[0].Id;
        creditMemo.Del_F_R_Approver__c = listEmp[0].Id;
        creditMemo.Del_AR1_Approver__c = listEmp[0].Id;
        creditMemo.Del_CSO_Approver__c = listEmp[0].Id;
        creditMemo.Del_AR2_Approver__c = listEmp[0].Id;
        creditMemo.Del_Additional_Approver__c = listEmp[0].Id;
        Update creditMemo;
        
              
         Receipt_Reversals__c receiptReversal = [Select Del_Additional_Approver__c
                                         from Receipt_Reversals__c];
         receiptReversal.Del_Additional_Approver__c = listEmp[0].Id;
         Update receiptReversal; 
             
        Test.StartTest();
        PageReference pr = cont.customerAction();
        pageRef.getParameters().put('status', 'APPROVE');
        ApexPages.StandardController sc1=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont1 =new CaseApproveRejectPageController(sc1);
        cont1.caseRecord.Review_Comments__c = 'Test';
        cont1.customerAction();
        Test.StopTest();
    } 
    
    
    
    @istest
    public static void AddReject(){            
        Customer_Service_Inquiries_ICS__c csiIcs = [select Id, Case_Approval_Status__c, Email_Copy_To__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.CaseApproveRejectPage;
        pageRef.getParameters().put('id', String.valueOf(csiIcs.Id));
        pageRef.getParameters().put('email', 'test@test.com');
        pageRef.getParameters().put('status', 'REJECT');
        pageRef.getParameters().put('transactionType', 'All');
        Test.setCurrentPage(pageRef);
        csiIcs.Case_Approval_Status__c = 'Additional Submitted';
        update csiIcs;
        ApexPages.StandardController sc=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont =new CaseApproveRejectPageController(sc);
        
        List<Employees__c> listEmp = [Select Id, Email_Address__c From Employees__c LIMIT 2];
        
         Credit_Memo_ICS__c creditMemo = [Select Del_LOB_Approver__c, LOB_Approver_Email_ID__c, Del_F_R_Approver__c,Del_AR1_Approver__c,
                                          Del_CSO_Approver__c,Del_AR2_Approver__c,Del_Additional_Approver__c
                                         from Credit_Memo_ICS__c limit 1];
        creditMemo.Del_LOB_Approver__c = listEmp[0].Id;
        creditMemo.Del_F_R_Approver__c = listEmp[0].Id;
        creditMemo.Del_AR1_Approver__c = listEmp[0].Id;
        creditMemo.Del_CSO_Approver__c = listEmp[0].Id;
        creditMemo.Del_AR2_Approver__c = listEmp[0].Id;
        creditMemo.Del_Additional_Approver__c = listEmp[0].Id;
        Update creditMemo;
              
                
        Test.StartTest();
        PageReference pr = cont.customerAction();
        pageRef.getParameters().put('status', 'REJECT');
        ApexPages.StandardController sc1=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont1 =new CaseApproveRejectPageController(sc1);
        cont1.caseRecord.Review_Comments__c = 'Test';
        cont1.customerAction();
        Test.StopTest();
    }
    @istest
    public static void AddReject1(){            
        Customer_Service_Inquiries_ICS__c csiIcs = [select Id, Case_Approval_Status__c, Email_Copy_To__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.CaseApproveRejectPage;
        pageRef.getParameters().put('id', String.valueOf(csiIcs.Id));
        pageRef.getParameters().put('email', 'test@test.com');
        pageRef.getParameters().put('status', 'REJECT');
        pageRef.getParameters().put('transactionType', 'All');
        Test.setCurrentPage(pageRef);
        csiIcs.Case_Approval_Status__c = 'Additional Submitted';
        update csiIcs;
        ApexPages.StandardController sc=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont =new CaseApproveRejectPageController(sc);
        
        List<Employees__c> listEmp = [Select Id, Email_Address__c From Employees__c LIMIT 2];
                 Receipt_Reversals__c receiptReversal = [Select Del_Additional_Approver__c
                                         from Receipt_Reversals__c];
         receiptReversal.Del_Additional_Approver__c = listEmp[0].Id;
         Update receiptReversal; 
        
              
                
        Test.StartTest();
        PageReference pr = cont.customerAction();
        pageRef.getParameters().put('status', 'REJECT');
        ApexPages.StandardController sc1=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont1 =new CaseApproveRejectPageController(sc1);
        cont1.caseRecord.Review_Comments__c = 'Test';
        cont1.customerAction();
        Test.StopTest();
    }
    
        @istest
    public static void ARAdjustment(){            
        Customer_Service_Inquiries_ICS__c csiIcs = [select Id, Case_Approval_Status__c, Email_Copy_To__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.CaseApproveRejectPage;
        pageRef.getParameters().put('id', String.valueOf(csiIcs.Id));
        pageRef.getParameters().put('email', 'test@test.com');
        pageRef.getParameters().put('status', 'APPROVE');
        pageRef.getParameters().put('transactionType', 'ARAdjustment');
        Test.setCurrentPage(pageRef);
        csiIcs.Case_Approval_Status__c = 'LOB Submitted';
        update csiIcs;
        ApexPages.StandardController sc=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont =new CaseApproveRejectPageController(sc);
        
        Test.StartTest();
        PageReference pr = cont.customerAction();
        pageRef.getParameters().put('status', 'APPROVE');
        ApexPages.StandardController sc1=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont1 =new CaseApproveRejectPageController(sc1);
        cont1.caseRecord.Review_Comments__c = 'Test';
        cont1.customerAction();
        Test.StopTest();
    }

    @istest
    public static void test8(){            
        Customer_Service_Inquiries_ICS__c csiIcs = [select Id, Case_Approval_Status__c, Email_Copy_To__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.CaseApproveRejectPage;
        pageRef.getParameters().put('id', String.valueOf(csiIcs.Id));
        pageRef.getParameters().put('email', 'test@test.com');
        pageRef.getParameters().put('status', 'REJECT');
        pageRef.getParameters().put('transactionType', 'All');
        Test.setCurrentPage(pageRef);
        csiIcs.Case_Approval_Status__c = 'LOB Submitted';
        update csiIcs;
        ApexPages.StandardController sc=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont =new CaseApproveRejectPageController(sc);
        
        Test.StartTest();
        PageReference pr = cont.customerAction();
        pageRef.getParameters().put('status', 'APPROVE');
        ApexPages.StandardController sc1=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont1 =new CaseApproveRejectPageController(sc1);
        cont1.caseRecord.Review_Comments__c = 'Test';
        cont1.customerAction();
        Test.StopTest();
    } 
  
    
     @istest
    public static void test13(){            
        Customer_Service_Inquiries_ICS__c csiIcs = [select Id, Case_Approval_Status__c,Review_Comments__c, Email_Copy_To__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        CaseApproveRejectPageController.currencyFormat(1234);
        CaseApproveRejectPageController.currencyFormatTotal(45678);
      
        
    }
    
    
        @istest
    public static void RefundAR1_Approve(){            
        Customer_Service_Inquiries_ICS__c csiIcs = [select Id, Case_Approval_Status__c, Email_Copy_To__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.CaseApproveRejectPage;
        pageRef.getParameters().put('id', String.valueOf(csiIcs.Id));
        pageRef.getParameters().put('email', 'test@test.com');
        pageRef.getParameters().put('status', 'APPROVE');
        pageRef.getParameters().put('transactionType', 'All');
        Test.setCurrentPage(pageRef);
        csiIcs.Case_Approval_Status__c = 'AR1 Submitted';
        update csiIcs;
        ApexPages.StandardController sc=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont =new CaseApproveRejectPageController(sc);
        Test.StartTest();
         List<Employees__c> listEmp = [Select Id, Email_Address__c From Employees__c LIMIT 2];
        
          Refunds_ICS__c refund= [Select AR1_Approver_Name__c, AR2_Approver_Name__c, CSO_Approver_Name__c
                                         from Refunds_ICS__c];
        
           
        refund.AR1_Approver_Name__c = listEmp[0].Id;
        refund.AR2_Approver_Name__c = listEmp[0].Id;
        refund.CSO_Approver_Name__c = listEmp[0].Id;
        System.debug('@@@Test--Email_Address__c-->'+listEmp[0].Email_Address__c);
        //refund.Del_CSO_Approver_Email__c = listEmp[0].Email_Address__c;
        Update refund;
           
       
        PageReference pr = cont.customerAction();
        pageRef.getParameters().put('status', 'APPROVE');
        ApexPages.StandardController sc1=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont1 =new CaseApproveRejectPageController(sc1);
        cont1.caseRecord.Review_Comments__c = 'Test';
        cont1.customerAction();
        Test.StopTest();
    } 
       
        @istest
    public static void RefundAR1_Reject(){            
        Customer_Service_Inquiries_ICS__c csiIcs = [select Id, Case_Approval_Status__c, Email_Copy_To__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.CaseApproveRejectPage;
        pageRef.getParameters().put('id', String.valueOf(csiIcs.Id));
        pageRef.getParameters().put('email', 'test@test.com');
        pageRef.getParameters().put('status', 'REJECT');
        pageRef.getParameters().put('transactionType', 'All');
        Test.setCurrentPage(pageRef);
        csiIcs.Case_Approval_Status__c = 'AR2 Submitted';
        update csiIcs;
        ApexPages.StandardController sc=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont =new CaseApproveRejectPageController(sc);
        Test.StartTest();
         List<Employees__c> listEmp = [Select Id, Email_Address__c From Employees__c LIMIT 2];
        
          Refunds_ICS__c refund= [Select AR1_Approver_Name__c, AR2_Approver_Name__c, CSO_Approver_Name__c
                                         from Refunds_ICS__c];
        
           
        refund.AR1_Approver_Name__c = listEmp[0].Id;
        refund.AR2_Approver_Name__c = listEmp[0].Id;
        refund.CSO_Approver_Name__c = listEmp[0].Id;
        System.debug('@@@Test--Email_Address__c-->'+listEmp[0].Email_Address__c);
        //refund.Del_CSO_Approver_Email__c = listEmp[0].Email_Address__c;
        Update refund;
        PageReference pr = cont.customerAction();
        pageRef.getParameters().put('status', 'REJECT');
        ApexPages.StandardController sc1=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont1 =new CaseApproveRejectPageController(sc1);
        cont1.caseRecord.Review_Comments__c = 'Test';
        cont1.customerAction();
        Test.StopTest();
    }
    
    public static void creditmemo_Reject(){            
        Customer_Service_Inquiries_ICS__c csiIcs = [select Id, Case_Approval_Status__c, Email_Copy_To__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.CaseApproveRejectPage;
        pageRef.getParameters().put('id', String.valueOf(csiIcs.Id));
        pageRef.getParameters().put('email', 'test@test.com');
        pageRef.getParameters().put('status', 'Reject');
        pageRef.getParameters().put('transactionType', 'All');
        Test.setCurrentPage(pageRef);
        csiIcs.Case_Approval_Status__c = 'Additional Submitted';
        update csiIcs;
        ApexPages.StandardController sc=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont =new CaseApproveRejectPageController(sc);
        
        List<Employees__c> listEmp = [Select Id, Email_Address__c From Employees__c LIMIT 2];
        
         Credit_Memo_ICS__c creditMemo = [Select Del_LOB_Approver__c, LOB_Approver_Email_ID__c, Del_F_R_Approver__c,Del_AR1_Approver__c,
                                          Del_CSO_Approver__c,Del_AR2_Approver__c,Del_Additional_Approver__c
                                         from Credit_Memo_ICS__c limit 1];
        creditMemo.Del_LOB_Approver__c = listEmp[0].Id;
        creditMemo.Del_F_R_Approver__c = listEmp[0].Id;
        creditMemo.Del_AR1_Approver__c = listEmp[0].Id;
        creditMemo.Del_CSO_Approver__c = listEmp[0].Id;
        creditMemo.Del_AR2_Approver__c = listEmp[0].Id;
        creditMemo.Del_Additional_Approver__c = listEmp[0].Id;
        Update creditMemo;
        
              
         Receipt_Reversals__c receiptReversal = [Select Del_Additional_Approver__c
                                         from Receipt_Reversals__c];
         receiptReversal.Del_Additional_Approver__c = listEmp[0].Id;
         Update receiptReversal; 
             
        Test.StartTest();
        PageReference pr = cont.customerAction();
        pageRef.getParameters().put('status', 'Reject');
        ApexPages.StandardController sc1=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont1 =new CaseApproveRejectPageController(sc1);
        cont1.caseRecord.Review_Comments__c = 'Test';
        cont1.customerAction();
        Test.StopTest();
    }
    public static void paymentTransferTest(){
        Customer_Service_Inquiries_ICS__c csiIcs = [select Id, Case_Approval_Status__c, Email_Copy_To__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        Payment_Transfer_ICS__c payment = TestDataUtil.createTestPaymentTransfer(csiIcs.id);
        insert payment;
        
        PageReference pageRef = Page.CaseApproveRejectPage;
        pageRef.getParameters().put('id', String.valueOf(csiIcs.Id));
        pageRef.getParameters().put('email', 'test@test.com');
        pageRef.getParameters().put('status', 'Reject');
        pageRef.getParameters().put('transactionType', 'All');
        Test.setCurrentPage(pageRef);
        //ApexPages.StandardController sc=new ApexPages.StandardController(csiIcs);
        //CaseApproveRejectPageController cont =new CaseApproveRejectPageController(sc);
        Test.StartTest();
        //PageReference pr = cont.customerAction();
        ApexPages.StandardController sc1=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont1 =new CaseApproveRejectPageController(sc1);
        cont1.caseRecord.Review_Comments__c = 'Test';
        cont1.customerAction();
        Test.StopTest();
        
    }
       @istest // LOB Approved
    public static void LOBApprove1(){            
        Customer_Service_Inquiries_ICS__c csiIcs = [select Id, Case_Approval_Status__c, Email_Copy_To__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.CaseApproveRejectPage;
        pageRef.getParameters().put('id', String.valueOf(csiIcs.Id));
        pageRef.getParameters().put('email', 'test@test.com');
        pageRef.getParameters().put('status', 'APPROVE');
        pageRef.getParameters().put('transactionType', 'All');
        Test.setCurrentPage(pageRef);
        csiIcs.Case_Approval_Status__c = 'LOB Submitted';
        update csiIcs;
        ApexPages.StandardController sc=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont =new CaseApproveRejectPageController(sc);
        
        List<Employees__c> listEmp = [Select Id, Email_Address__c From Employees__c LIMIT 2];
        
         Credit_Memo_ICS__c creditMemo = [Select Del_LOB_Approver__c,Del_F_R_Approver__c,Del_AR1_Approver__c, LOB_Approver_Email_ID__c,
                                          Del_CSO_Approver__c,Del_AR2_Approver__c,Del_Additional_Approver__c,Del_AR1_Approver_Email__c
                                         from Credit_Memo_ICS__c];
        creditMemo.Del_LOB_Approver__c = listEmp[0].Id;
        creditMemo.Del_F_R_Approver__c = listEmp[1].Id;
        creditMemo.Del_AR1_Approver__c = listEmp[0].Id;
        creditMemo.Del_CSO_Approver__c = listEmp[0].Id;
        creditMemo.Del_AR2_Approver__c = listEmp[0].Id;
        creditMemo.Del_Additional_Approver__c = listEmp[0].Id;
        creditMemo.F_R_Approver_Email_ID__c = 'test@test.com';
        Update creditMemo;
    
        Test.StartTest();
        PageReference pr = cont.customerAction();
        pageRef.getParameters().put('status', 'APPROVE');
        ApexPages.StandardController sc1=new ApexPages.StandardController(csiIcs);
        CaseApproveRejectPageController cont1 =new CaseApproveRejectPageController(sc1);
        
        cont1.caseRecord.Review_Comments__c = 'Test';
        cont1.customerAction();
               
        Test.StopTest();
    } 
   
    
}