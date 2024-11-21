@isTest
Public class VFC_ICSDelegateApprover_Test {
    @testSetup
    static void testData() {
        List<Employees__c> listEmp = new List<Employees__c>();
        Employees__c emp = TestDataUtil.createTestEmployee();
        Employees__c emp1 = TestDataUtil.createTestEmployee();
        emp1.Email_Address__c='test1@test1.com'; 
        listEmp.add(emp);
        listEmp.add(emp1);
        insert listEmp;
        //ICS_Approver_Matrix__c approverMatrix = TestDataUtil.createTestApproverMatrix(listEmp[0].id);
        //insert approverMatrix;
        Customer_Service_Inquiries_ICS__c ICS = TestDataUtil.createTestCustomerServiceInquries();
        ICS.Case_Requestor__c = listEmp[0].Id;
        ICS.Case_Approval_Status__c = 'Requestor Submitted';
        ics.Priority__c ='Urgent';
    //ics.Requestor_Apporval_Required__c=true;
        insert ICS;
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
        Credit_Memo_ICS__c creditMemo = TestDataUtil.createTestCreditMemo(ICS.Id);
        creditMemo.LOB_Approver_Name__c = listEmp[0].Id;
        creditMemo.LOB_Approver_Email_ID__c = listEmp[0].Email_Address__c;
        creditMemo.F_R_Approver_Name__c = listEmp[0].Id;
        creditMemo.F_R_Approver_Email_ID__c = listEmp[0].Email_Address__c;
        creditMemo.AR1_Approver_Name__c = listEmp[0].Id;
        creditMemo.AR1_Approver_Email_ID__c = listEmp[0].Email_Address__c;
        creditMemo.CSO_Approver_Name__c = listEmp[0].Id;
        creditMemo.CSO_Approver_Email__c = listEmp[0].Email_Address__c;    
        creditMemo.AR2_Approver_Name__c = listEmp[0].Id;
        creditMemo.AR2_Approver_Email_ID__c = listEmp[0].Email_Address__c;        
        creditMemo.Additional_Approver_Name__c = listEmp[0].Id;
        creditMemo.Additional_Approver_Email_ID__c = listEmp[0].Email_Address__c;
        insert creditMemo;
        Refunds_ICS__c refund = TestDataUtil.createTestRefund(ICS.Id);
        refund.AR1_Approver_Name__c = listEmp[0].Id;
        refund.AR1_Approver_Email_ID__c = listEmp[0].Email_Address__c;
        refund.CSO_Approver_Name__c = listEmp[0].Id;
        //refund.CSO_Approver_Email__c = listEmp[0].Email_Address__c;
        refund.AR2_Approver_Name__c = listEmp[0].Id;
        refund.AR2_Approver_Email_ID__c = listEmp[0].Email_Address__c;
        insert refund;
        Receipt_Reversals__c receiptReversal = TestDataUtil.createTestReceiptReversal(ICS.Id);
        receiptReversal.Additional_Approver_Name__c = listEmp[0].Id;
        //receiptReversal.Approver_Email__c= listEmp[0].Email_Address__c;
        insert receiptReversal;
    }
     
    static testMethod void testMethod1() {
        Customer_Service_Inquiries_ICS__c ics = [select Id, Case_Approval_Status__c from Customer_Service_Inquiries_ICS__c limit 1];
        PageReference pageRef = Page.VFP_ICSDelegateApprover;
        pageRef.getParameters().put('id', String.valueOf(ics.Id));
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(ics);
        VFC_ICSDelegateApprover testAccPlan = new VFC_ICSDelegateApprover(sc);
    }
   
    static testMethod void testMethodLOB() { 
        Customer_Service_Inquiries_ICS__c ics = [select Id, Case_Approval_Status__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.VFP_ICSDelegateApprover;
        pageRef.getParameters().put('id', String.valueOf(ics.Id));
        Test.setCurrentPage(pageRef);
        
        ics.Case_Approval_Status__c = 'LOB Submitted';
        update ics;
        Credit_Memo_ICS__c creditMemo = [select LOB_Approver_Name__c,LOB_Approver_Email_ID__c,F_R_Approver_Name__c,F_R_Approver_Email_ID__c,AR1_Approver_Name__c,
                                        AR1_Approver_Email_ID__c,CSO_Approver_Name__c,CSO_Approver_Email__c,AR2_Approver_Name__c,AR2_Approver_Email_ID__c,
                                        Additional_Approver_Name__c,Additional_Approver_Email_ID__c from Credit_Memo_ICS__c Limit 1];
        creditMemo.LOB_Approver_Name__c = emp[0].Id;
        creditMemo.LOB_Approver_Email_ID__c = emp[0].Email_Address__c;
        creditMemo.F_R_Approver_Name__c = emp[0].Id;
        creditMemo.F_R_Approver_Email_ID__c = emp[0].Email_Address__c;
        creditMemo.AR1_Approver_Name__c = emp[0].Id;
        creditMemo.AR1_Approver_Email_ID__c = emp[0].Email_Address__c;
        creditMemo.CSO_Approver_Name__c = emp[0].Id;
        creditMemo.CSO_Approver_Email__c = emp[0].Email_Address__c;    
        creditMemo.AR2_Approver_Name__c = emp[0].Id;
        creditMemo.AR2_Approver_Email_ID__c = emp[0].Email_Address__c;        
        creditMemo.Additional_Approver_Name__c = emp[0].Id;
        creditMemo.Additional_Approver_Email_ID__c = emp[0].Email_Address__c;
        update creditMemo;
        ApexPages.StandardController sc = new ApexPages.StandardController(ics);
        VFC_ICSDelegateApprover testAccPlan = new VFC_ICSDelegateApprover(sc);
        ApexPages.currentPage().getParameters().put('delegateEmail', 'test@test.com');
        ApexPages.currentPage().getParameters().put('approverstage', 'LOB');
        ApexPages.currentPage().getParameters().put('transactionType', 'AR Adjustment');
        ApexPages.currentPage().getParameters().put('index', '1');
        testAccPlan.listLOBApprovers[0].arAdjustment.AR2_Approver_Name__c = emp[0].Id;
        testAccPlan.delegateApproval();
    } 
    
    static testMethod void testMethodFR() { 
        Customer_Service_Inquiries_ICS__c ics = [select Id, Case_Approval_Status__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.VFP_ICSDelegateApprover;
        pageRef.getParameters().put('id', String.valueOf(ics.Id));
        Test.setCurrentPage(pageRef);
        
        ics.Case_Approval_Status__c = 'F&R Submitted';
        update ics;
        Credit_Memo_ICS__c creditMemo = [select LOB_Approver_Name__c,LOB_Approver_Email_ID__c,F_R_Approver_Name__c,F_R_Approver_Email_ID__c,AR1_Approver_Name__c,
                                        AR1_Approver_Email_ID__c,CSO_Approver_Name__c,CSO_Approver_Email__c,AR2_Approver_Name__c,AR2_Approver_Email_ID__c,
                                        Additional_Approver_Name__c,Additional_Approver_Email_ID__c from Credit_Memo_ICS__c Limit 1];
        creditMemo.LOB_Approver_Name__c = emp[0].Id;
        creditMemo.LOB_Approver_Email_ID__c = emp[0].Email_Address__c;
        creditMemo.F_R_Approver_Name__c = emp[0].Id;
        creditMemo.F_R_Approver_Email_ID__c = emp[0].Email_Address__c;
        creditMemo.AR1_Approver_Name__c = emp[0].Id;
        creditMemo.AR1_Approver_Email_ID__c = emp[0].Email_Address__c;
        creditMemo.CSO_Approver_Name__c = emp[0].Id;
        creditMemo.CSO_Approver_Email__c = emp[0].Email_Address__c;    
        creditMemo.AR2_Approver_Name__c = emp[0].Id;
        creditMemo.AR2_Approver_Email_ID__c = emp[0].Email_Address__c;        
        creditMemo.Additional_Approver_Name__c = emp[0].Id;
        creditMemo.Additional_Approver_Email_ID__c = emp[0].Email_Address__c;
        update creditMemo;
        ApexPages.StandardController sc = new ApexPages.StandardController(ics);
        VFC_ICSDelegateApprover testAccPlan = new VFC_ICSDelegateApprover(sc);
        ApexPages.currentPage().getParameters().put('delegateEmail', 'test@test.com');
        ApexPages.currentPage().getParameters().put('approverstage', 'FR');
        ApexPages.currentPage().getParameters().put('transactionType', 'AR Adjustment');
        ApexPages.currentPage().getParameters().put('index', '1');
        testAccPlan.listFRApprovers[0].arAdjustment.AR2_Approver_Name__c = emp[0].Id;
        testAccPlan.delegateApproval();
    } 
    static testMethod void testMethodAR1() { 
        Customer_Service_Inquiries_ICS__c ics = [select Id, Case_Approval_Status__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.VFP_ICSDelegateApprover;
        pageRef.getParameters().put('id', String.valueOf(ics.Id));
        Test.setCurrentPage(pageRef);
        
        ics.Case_Approval_Status__c = 'AR1 Submitted';
        update ics;
        Credit_Memo_ICS__c creditMemo = [select LOB_Approver_Name__c,LOB_Approver_Email_ID__c,F_R_Approver_Name__c,F_R_Approver_Email_ID__c,AR1_Approver_Name__c,
                                        AR1_Approver_Email_ID__c,CSO_Approver_Name__c,CSO_Approver_Email__c,AR2_Approver_Name__c,AR2_Approver_Email_ID__c,
                                        Additional_Approver_Name__c,Additional_Approver_Email_ID__c from Credit_Memo_ICS__c Limit 1];
        creditMemo.LOB_Approver_Name__c = emp[0].Id;
        creditMemo.LOB_Approver_Email_ID__c = emp[0].Email_Address__c;
        creditMemo.F_R_Approver_Name__c = emp[0].Id;
        creditMemo.F_R_Approver_Email_ID__c = emp[0].Email_Address__c;
        creditMemo.AR1_Approver_Name__c = emp[0].Id;
        creditMemo.AR1_Approver_Email_ID__c = emp[0].Email_Address__c;
        creditMemo.CSO_Approver_Name__c = emp[0].Id;
        creditMemo.CSO_Approver_Email__c = emp[0].Email_Address__c;    
        creditMemo.AR2_Approver_Name__c = emp[0].Id;
        creditMemo.AR2_Approver_Email_ID__c = emp[0].Email_Address__c;        
        creditMemo.Additional_Approver_Name__c = emp[0].Id;
        creditMemo.Additional_Approver_Email_ID__c = emp[0].Email_Address__c;
        update creditMemo;
        ApexPages.StandardController sc = new ApexPages.StandardController(ics);
        VFC_ICSDelegateApprover testAccPlan = new VFC_ICSDelegateApprover(sc);
        ApexPages.currentPage().getParameters().put('delegateEmail', 'test@test.com');
        ApexPages.currentPage().getParameters().put('approverstage', 'AR1');
        ApexPages.currentPage().getParameters().put('transactionType', 'AR Adjustment');
        ApexPages.currentPage().getParameters().put('index', '1');
        testAccPlan.listAR1Approvers[0].arAdjustment.AR2_Approver_Name__c = emp[0].Id;
        testAccPlan.delegateApproval();
    } 
    
    static testMethod void testMethodCSO() { 
        Customer_Service_Inquiries_ICS__c ics = [select Id, Case_Approval_Status__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.VFP_ICSDelegateApprover;
        pageRef.getParameters().put('id', String.valueOf(ics.Id));
        Test.setCurrentPage(pageRef);
        
        ics.Case_Approval_Status__c = 'CSO Submitted';
        update ics;
        Credit_Memo_ICS__c creditMemo = [select LOB_Approver_Name__c,LOB_Approver_Email_ID__c,F_R_Approver_Name__c,F_R_Approver_Email_ID__c,AR1_Approver_Name__c,
                                        AR1_Approver_Email_ID__c,CSO_Approver_Name__c,CSO_Approver_Email__c,AR2_Approver_Name__c,AR2_Approver_Email_ID__c,
                                        Additional_Approver_Name__c,Additional_Approver_Email_ID__c from Credit_Memo_ICS__c Limit 1];
        creditMemo.LOB_Approver_Name__c = emp[0].Id;
        creditMemo.LOB_Approver_Email_ID__c = emp[0].Email_Address__c;
        creditMemo.F_R_Approver_Name__c = emp[0].Id;
        creditMemo.F_R_Approver_Email_ID__c = emp[0].Email_Address__c;
        creditMemo.AR1_Approver_Name__c = emp[0].Id;
        creditMemo.AR1_Approver_Email_ID__c = emp[0].Email_Address__c;
        creditMemo.CSO_Approver_Name__c = emp[0].Id;
        creditMemo.CSO_Approver_Email__c = emp[0].Email_Address__c;    
        creditMemo.AR2_Approver_Name__c = emp[0].Id;
        creditMemo.AR2_Approver_Email_ID__c = emp[0].Email_Address__c;        
        creditMemo.Additional_Approver_Name__c = emp[0].Id;
        creditMemo.Additional_Approver_Email_ID__c = emp[0].Email_Address__c;
        update creditMemo;
        ApexPages.StandardController sc = new ApexPages.StandardController(ics);
        VFC_ICSDelegateApprover testAccPlan = new VFC_ICSDelegateApprover(sc);
        ApexPages.currentPage().getParameters().put('delegateEmail', 'test@test.com');
        ApexPages.currentPage().getParameters().put('approverstage', 'CSO');
        ApexPages.currentPage().getParameters().put('transactionType', 'AR Adjustment');
        ApexPages.currentPage().getParameters().put('index', '1');
        testAccPlan.listCSOApprovers[0].arAdjustment.AR2_Approver_Name__c = emp[0].Id;
        testAccPlan.delegateApproval();
    } 
      
    static testMethod void testMethodAR2() { 
        test.startTest();
        Customer_Service_Inquiries_ICS__c ics = [select Id, Case_Approval_Status__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.VFP_ICSDelegateApprover;
        pageRef.getParameters().put('id', String.valueOf(ics.Id));
        Test.setCurrentPage(pageRef);
        
        ics.Case_Approval_Status__c = 'AR2 Submitted';
        update ics;
        Credit_Memo_ICS__c creditMemo = [select LOB_Approver_Name__c,LOB_Approver_Email_ID__c,F_R_Approver_Name__c,F_R_Approver_Email_ID__c,AR1_Approver_Name__c,
                                        AR1_Approver_Email_ID__c,CSO_Approver_Name__c,CSO_Approver_Email__c,AR2_Approver_Name__c,AR2_Approver_Email_ID__c,
                                        Additional_Approver_Name__c,Additional_Approver_Email_ID__c from Credit_Memo_ICS__c Limit 1];
        creditMemo.LOB_Approver_Name__c = emp[0].Id;
        creditMemo.LOB_Approver_Email_ID__c = emp[0].Email_Address__c;
        creditMemo.F_R_Approver_Name__c = emp[0].Id;
        creditMemo.F_R_Approver_Email_ID__c = emp[0].Email_Address__c;
        creditMemo.AR1_Approver_Name__c = emp[0].Id;
        creditMemo.AR1_Approver_Email_ID__c = emp[0].Email_Address__c;
        creditMemo.CSO_Approver_Name__c = emp[0].Id;
        creditMemo.CSO_Approver_Email__c = emp[0].Email_Address__c;    
        creditMemo.AR2_Approver_Name__c = emp[0].Id;
        creditMemo.AR2_Approver_Email_ID__c = emp[0].Email_Address__c;        
        creditMemo.Additional_Approver_Name__c = emp[0].Id;
        creditMemo.Additional_Approver_Email_ID__c = emp[0].Email_Address__c;
        update creditMemo;
        ApexPages.StandardController sc = new ApexPages.StandardController(ics);
        VFC_ICSDelegateApprover testAccPlan = new VFC_ICSDelegateApprover(sc);
        ApexPages.currentPage().getParameters().put('delegateEmail', 'test@test.com');
        ApexPages.currentPage().getParameters().put('approverstage', 'AR2');
        ApexPages.currentPage().getParameters().put('transactionType', 'AR Adjustment');
        ApexPages.currentPage().getParameters().put('index', '1');
        testAccPlan.listAR2Approvers[0].arAdjustment.AR2_Approver_Name__c = emp[0].Id;
        testAccPlan.delegateApproval();
    test.stopTest();
    } 
    
    static testMethod void testMethodAdditional() { 
        Customer_Service_Inquiries_ICS__c ics = [select Id, Case_Approval_Status__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.VFP_ICSDelegateApprover;
        pageRef.getParameters().put('id', String.valueOf(ics.Id));
        Test.setCurrentPage(pageRef);
        
        ics.Case_Approval_Status__c = 'Additional Submitted';
        update ics;
        Credit_Memo_ICS__c creditMemo = [select LOB_Approver_Name__c,LOB_Approver_Email_ID__c,F_R_Approver_Name__c,F_R_Approver_Email_ID__c,AR1_Approver_Name__c,
                                        AR1_Approver_Email_ID__c,CSO_Approver_Name__c,CSO_Approver_Email__c,AR2_Approver_Name__c,AR2_Approver_Email_ID__c,
                                        Additional_Approver_Name__c,Additional_Approver_Email_ID__c from Credit_Memo_ICS__c Limit 1];
        creditMemo.LOB_Approver_Name__c = emp[0].Id;
        creditMemo.LOB_Approver_Email_ID__c = emp[0].Email_Address__c;
        creditMemo.F_R_Approver_Name__c = emp[0].Id;
        creditMemo.F_R_Approver_Email_ID__c = emp[0].Email_Address__c;
        creditMemo.AR1_Approver_Name__c = emp[0].Id;
        creditMemo.AR1_Approver_Email_ID__c = emp[0].Email_Address__c;
        creditMemo.CSO_Approver_Name__c = emp[0].Id;
        creditMemo.CSO_Approver_Email__c = emp[0].Email_Address__c;    
        creditMemo.AR2_Approver_Name__c = emp[0].Id;
        creditMemo.AR2_Approver_Email_ID__c = emp[0].Email_Address__c;        
        creditMemo.Additional_Approver_Name__c = emp[0].Id;
        creditMemo.Additional_Approver_Email_ID__c = emp[0].Email_Address__c;
        update creditMemo;
        ApexPages.StandardController sc = new ApexPages.StandardController(ics);
        VFC_ICSDelegateApprover testAccPlan = new VFC_ICSDelegateApprover(sc);
        ApexPages.currentPage().getParameters().put('delegateEmail', 'test@test.com');
        ApexPages.currentPage().getParameters().put('approverstage', 'ADA');
        ApexPages.currentPage().getParameters().put('transactionType', 'AR Adjustment');
        ApexPages.currentPage().getParameters().put('index', '1');
        testAccPlan.listAdditionalApprovers[0].arAdjustment.AR2_Approver_Name__c = emp[0].Id;
        testAccPlan.delegateApproval();
    }
    
    static testMethod void testMethodRefundAR2() {
         test.startTest();
        Customer_Service_Inquiries_ICS__c ics = [select Id, Case_Approval_Status__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.VFP_ICSDelegateApprover;
        pageRef.getParameters().put('id', String.valueOf(ics.Id));
        Test.setCurrentPage(pageRef);       
        ics.Case_Approval_Status__c = 'AR2 Submitted';
        update ics;
        ApexPages.StandardController sc = new ApexPages.StandardController(ics);
        VFC_ICSDelegateApprover testAccPlan = new VFC_ICSDelegateApprover(sc);
        ApexPages.currentPage().getParameters().put('delegateEmail', 'test1@test1.com');
        ApexPages.currentPage().getParameters().put('approverstage', 'AR2');
        ApexPages.currentPage().getParameters().put('transactionType', 'Refund');
        ApexPages.currentPage().getParameters().put('index', '1');
        testAccPlan.listAR2Approvers[0].arAdjustment.AR2_Approver_Name__c = emp[0].Id;  
        testAccPlan.delegateApproval();
        test.stopTest();
    }
    static testMethod void testMethodRefundCSO() {
         test.startTest();
        Customer_Service_Inquiries_ICS__c ics = [select Id, Case_Approval_Status__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.VFP_ICSDelegateApprover;
        pageRef.getParameters().put('id', String.valueOf(ics.Id));
        Test.setCurrentPage(pageRef);       
        ics.Case_Approval_Status__c = 'CSO Submitted';
        update ics;
        ApexPages.StandardController sc = new ApexPages.StandardController(ics);
        VFC_ICSDelegateApprover testAccPlan = new VFC_ICSDelegateApprover(sc);
        ApexPages.currentPage().getParameters().put('delegateEmail', 'test1@test1.com');
        ApexPages.currentPage().getParameters().put('approverstage', 'CSO');
        ApexPages.currentPage().getParameters().put('transactionType', 'Refund');
        ApexPages.currentPage().getParameters().put('index', '1');
        testAccPlan.listCSOApprovers[0].arAdjustment.AR2_Approver_Name__c = emp[0].Id;  
        testAccPlan.delegateApproval();
        test.stopTest();
    }
    
    static testMethod void testMethodRefundAdditional() {
         test.startTest();
        Customer_Service_Inquiries_ICS__c ics = [select Id, Case_Approval_Status__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.VFP_ICSDelegateApprover;
        pageRef.getParameters().put('id', String.valueOf(ics.Id));
        Test.setCurrentPage(pageRef);       
        ics.Case_Approval_Status__c = 'Additional Submitted';
        update ics;
        ApexPages.StandardController sc = new ApexPages.StandardController(ics);
        VFC_ICSDelegateApprover testAccPlan = new VFC_ICSDelegateApprover(sc);
        ApexPages.currentPage().getParameters().put('delegateEmail', 'test1@test1.com');
        ApexPages.currentPage().getParameters().put('approverstage', 'ADA');
        ApexPages.currentPage().getParameters().put('transactionType', 'Refund');
        ApexPages.currentPage().getParameters().put('index', '1');
        testAccPlan.listAR2Approvers[0].arAdjustment.AR2_Approver_Name__c = emp[0].Id;  
        testAccPlan.delegateApproval();
        test.stopTest();
    }
    
    static testMethod void testMethodCreditMemoLOB() { 
        Customer_Service_Inquiries_ICS__c ics = [select Id, Case_Approval_Status__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.VFP_ICSDelegateApprover;
        pageRef.getParameters().put('id', String.valueOf(ics.Id));
        Test.setCurrentPage(pageRef);
        
        ics.Case_Approval_Status__c = 'LOB Submitted';
        update ics;
        ApexPages.StandardController sc = new ApexPages.StandardController(ics);
        VFC_ICSDelegateApprover testAccPlan = new VFC_ICSDelegateApprover(sc);
        ApexPages.currentPage().getParameters().put('delegateEmail', 'test@test.com');
        ApexPages.currentPage().getParameters().put('approverstage', 'LOB');
        ApexPages.currentPage().getParameters().put('transactionType', 'Credit Memo');
        ApexPages.currentPage().getParameters().put('index', '1');
        testAccPlan.listLOBApprovers[0].arAdjustment.AR2_Approver_Name__c = emp[0].Id;
        testAccPlan.delegateApproval();
    } 
    
     static testMethod void testMethodCreditMemoFandR() { 
        Customer_Service_Inquiries_ICS__c ics = [select Id, Case_Approval_Status__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.VFP_ICSDelegateApprover;
        pageRef.getParameters().put('id', String.valueOf(ics.Id));
        Test.setCurrentPage(pageRef);
        
        ics.Case_Approval_Status__c = 'F&R Submitted';
        update ics;
        ApexPages.StandardController sc = new ApexPages.StandardController(ics);
        VFC_ICSDelegateApprover testAccPlan = new VFC_ICSDelegateApprover(sc);
        ApexPages.currentPage().getParameters().put('delegateEmail', 'test@test.com');
        ApexPages.currentPage().getParameters().put('approverstage', 'FR');
        ApexPages.currentPage().getParameters().put('transactionType', 'Credit Memo');
        ApexPages.currentPage().getParameters().put('index', '1');
        testAccPlan.listFRApprovers[0].arAdjustment.AR2_Approver_Name__c = emp[0].Id;
        testAccPlan.delegateApproval();
    } 
    
     static testMethod void testMethodCreditMemoAR1() { 
        Customer_Service_Inquiries_ICS__c ics = [select Id, Case_Approval_Status__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.VFP_ICSDelegateApprover;
        pageRef.getParameters().put('id', String.valueOf(ics.Id));
        Test.setCurrentPage(pageRef);
        
        ics.Case_Approval_Status__c = 'AR1 Submitted';
        update ics;
        ApexPages.StandardController sc = new ApexPages.StandardController(ics);
        VFC_ICSDelegateApprover testAccPlan = new VFC_ICSDelegateApprover(sc);
        ApexPages.currentPage().getParameters().put('delegateEmail', 'test@test.com');
        ApexPages.currentPage().getParameters().put('approverstage', 'AR1');
        ApexPages.currentPage().getParameters().put('transactionType', 'Credit Memo');
        ApexPages.currentPage().getParameters().put('index', '1');
        testAccPlan.listAR1Approvers[0].arAdjustment.AR2_Approver_Name__c = emp[0].Id;
        testAccPlan.delegateApproval();
    } 
    
    static testMethod void testMethodCreditMemoCSO() { 
        Customer_Service_Inquiries_ICS__c ics = [select Id, Case_Approval_Status__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.VFP_ICSDelegateApprover;
        pageRef.getParameters().put('id', String.valueOf(ics.Id));
        Test.setCurrentPage(pageRef);
        
        ics.Case_Approval_Status__c = 'CSO submitted';
        update ics;
        ApexPages.StandardController sc = new ApexPages.StandardController(ics);
        VFC_ICSDelegateApprover testAccPlan = new VFC_ICSDelegateApprover(sc);
        ApexPages.currentPage().getParameters().put('delegateEmail', 'test@test.com');
        ApexPages.currentPage().getParameters().put('approverstage', 'AR1');
        ApexPages.currentPage().getParameters().put('transactionType', 'Credit Memo');
        ApexPages.currentPage().getParameters().put('index', '1');
        testAccPlan.listCSOApprovers[0].arAdjustment.AR2_Approver_Name__c = emp[0].Id;
        testAccPlan.delegateApproval();
    } 
    
    static testMethod void testMethodCreditMemoAR2() { 
        Customer_Service_Inquiries_ICS__c ics = [select Id, Case_Approval_Status__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.VFP_ICSDelegateApprover;
        pageRef.getParameters().put('id', String.valueOf(ics.Id));
        Test.setCurrentPage(pageRef);
        
        ics.Case_Approval_Status__c = 'AR2 Submitted';
        update ics;
        ApexPages.StandardController sc = new ApexPages.StandardController(ics);
        VFC_ICSDelegateApprover testAccPlan = new VFC_ICSDelegateApprover(sc);
        ApexPages.currentPage().getParameters().put('delegateEmail', 'test@test.com');
        ApexPages.currentPage().getParameters().put('approverstage', 'AR2');
        ApexPages.currentPage().getParameters().put('transactionType', 'Credit Memo');
        ApexPages.currentPage().getParameters().put('index', '1');
        testAccPlan.listAR2Approvers[0].arAdjustment.AR2_Approver_Name__c = emp[0].Id;
        testAccPlan.delegateApproval();
    } 
    
      static testMethod void testMethodCreditMemoAdditional() { 
        Customer_Service_Inquiries_ICS__c ics = [select Id, Case_Approval_Status__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.VFP_ICSDelegateApprover;
        pageRef.getParameters().put('id', String.valueOf(ics.Id));
        Test.setCurrentPage(pageRef);
        
        ics.Case_Approval_Status__c = 'Additional Submitted';
        update ics;
        ApexPages.StandardController sc = new ApexPages.StandardController(ics);
        VFC_ICSDelegateApprover testAccPlan = new VFC_ICSDelegateApprover(sc);
        ApexPages.currentPage().getParameters().put('delegateEmail', 'test@test.com');
        ApexPages.currentPage().getParameters().put('approverstage', 'ADA');
        ApexPages.currentPage().getParameters().put('transactionType', 'Credit Memo');
        ApexPages.currentPage().getParameters().put('index', '1');
        testAccPlan.listAdditionalApprovers[0].arAdjustment.AR2_Approver_Name__c = emp[0].Id;
        testAccPlan.delegateApproval();
    } 
    
    static testMethod void testMethodReceiptReversalAdditional() { 
        Customer_Service_Inquiries_ICS__c ics = [select Id, Case_Approval_Status__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.VFP_ICSDelegateApprover;
        pageRef.getParameters().put('id', String.valueOf(ics.Id));
        Test.setCurrentPage(pageRef);
        
        ics.Case_Approval_Status__c = 'Additional Submitted';
        update ics;
        ApexPages.StandardController sc = new ApexPages.StandardController(ics);
        VFC_ICSDelegateApprover testAccPlan = new VFC_ICSDelegateApprover(sc);
        ApexPages.currentPage().getParameters().put('delegateEmail', 'test@test.com');
        ApexPages.currentPage().getParameters().put('approverstage', 'ADA');
        ApexPages.currentPage().getParameters().put('transactionType', 'Receipt Reversal');
        ApexPages.currentPage().getParameters().put('index', '1');
        testAccPlan.listAdditionalApprovers[0].arAdjustment.AR2_Approver_Name__c = emp[0].Id;
        testAccPlan.delegateApproval();
    }  
    
    
    
    
    
    static testMethod void testMethod3() {
        Customer_Service_Inquiries_ICS__c ics = [select Id, Case_Approval_Status__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.VFP_ICSDelegateApprover;
        pageRef.getParameters().put('id', String.valueOf(ics.Id));
        Test.setCurrentPage(pageRef);      
        ics.Case_Approval_Status__c = 'F&R Submitted';
        update ics;
        ApexPages.StandardController sc = new ApexPages.StandardController(ics);
        VFC_ICSDelegateApprover testAccPlan = new VFC_ICSDelegateApprover(sc);
        ApexPages.currentPage().getParameters().put('delegateEmail', 'test@test.com');
        ApexPages.currentPage().getParameters().put('approverstage', 'FR');
        ApexPages.currentPage().getParameters().put('transactionType', 'AR Adjustment');
        ApexPages.currentPage().getParameters().put('index', '1');
        testAccPlan.listFRApprovers[0].arAdjustment.AR2_Approver_Name__c = emp[0].Id;
        testAccPlan.delegateApproval();
    } 
    
    static testMethod void testMethod4() {
        Customer_Service_Inquiries_ICS__c ics = [select Id, Case_Approval_Status__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.VFP_ICSDelegateApprover;
        pageRef.getParameters().put('id', String.valueOf(ics.Id));
        Test.setCurrentPage(pageRef);       
        ics.Case_Approval_Status__c = 'AR1 Submitted';
        update ics;
        ApexPages.StandardController sc = new ApexPages.StandardController(ics);
        VFC_ICSDelegateApprover testAccPlan = new VFC_ICSDelegateApprover(sc);
        ApexPages.currentPage().getParameters().put('delegateEmail', 'test@test.com');
        ApexPages.currentPage().getParameters().put('approverstage', 'AR1');
        ApexPages.currentPage().getParameters().put('transactionType', 'AR Adjustment');
        ApexPages.currentPage().getParameters().put('index', '1');
        testAccPlan.listAR1Approvers[0].arAdjustment.AR1_Approver_Name__c = emp[0].Id;
        testAccPlan.delegateApproval(); 
    }
    
    static testMethod void testMethod5() {
        Customer_Service_Inquiries_ICS__c ics = [select Id, Case_Approval_Status__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.VFP_ICSDelegateApprover;
        pageRef.getParameters().put('id', String.valueOf(ics.Id));
        Test.setCurrentPage(pageRef);       
        ics.Case_Approval_Status__c = 'AR1 Submitted';
        update ics;
        ApexPages.StandardController sc = new ApexPages.StandardController(ics);
        VFC_ICSDelegateApprover testAccPlan = new VFC_ICSDelegateApprover(sc);
        ApexPages.currentPage().getParameters().put('delegateEmail', 'test@test.com');
        ApexPages.currentPage().getParameters().put('approverstage', 'AR1');
        ApexPages.currentPage().getParameters().put('transactionType', 'Credit Memo');
        ApexPages.currentPage().getParameters().put('index', '1');
        testAccPlan.listAR1Approvers[0].arAdjustment.AR1_Approver_Name__c = emp[0].Id;
        testAccPlan.delegateApproval(); 
    }
    
        static testMethod void testMethod6() {
        Customer_Service_Inquiries_ICS__c ics = [select Id, Case_Approval_Status__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.VFP_ICSDelegateApprover;
        pageRef.getParameters().put('id', String.valueOf(ics.Id));
        Test.setCurrentPage(pageRef);       
        ics.Case_Approval_Status__c = 'AR1 Submitted';
        update ics;  
        ApexPages.StandardController sc = new ApexPages.StandardController(ics);
        VFC_ICSDelegateApprover testAccPlan = new VFC_ICSDelegateApprover(sc);   
        ApexPages.currentPage().getParameters().put('delegateEmail', 'test@test.com');
        ApexPages.currentPage().getParameters().put('approverstage', 'AR1');
        ApexPages.currentPage().getParameters().put('transactionType', 'Refund');
        ApexPages.currentPage().getParameters().put('index', '1');
        testAccPlan.listAR1Approvers[0].arAdjustment.AR1_Approver_Name__c = emp[0].Id;
       testAccPlan.delegateApproval(); 
    }

     static testMethod void testMethod7() {
        Customer_Service_Inquiries_ICS__c ics = [select Id, Case_Approval_Status__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.VFP_ICSDelegateApprover;
        pageRef.getParameters().put('id', String.valueOf(ics.Id));
        Test.setCurrentPage(pageRef);       
        ics.Case_Approval_Status__c = 'CSO Submitted';
        update ics;
        ApexPages.StandardController sc = new ApexPages.StandardController(ics);
        VFC_ICSDelegateApprover testAccPlan = new VFC_ICSDelegateApprover(sc);       
        ApexPages.currentPage().getParameters().put('delegateEmail', 'test@test.com');
        ApexPages.currentPage().getParameters().put('approverstage', 'CSO');
        ApexPages.currentPage().getParameters().put('transactionType', 'Credit Memo');
        ApexPages.currentPage().getParameters().put('index', '1');
        testAccPlan.listCSOApprovers[0].arAdjustment.CSO_Approver_Name__c = emp[0].Id;
        testAccPlan.delegateApproval();
    }
     static testMethod void testMethod8() {
        Customer_Service_Inquiries_ICS__c ics = [select Id, Case_Approval_Status__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.VFP_ICSDelegateApprover;
        pageRef.getParameters().put('id', String.valueOf(ics.Id));
        Test.setCurrentPage(pageRef);       
        ics.Case_Approval_Status__c = 'CSO Submitted';
        update ics;
        ApexPages.StandardController sc = new ApexPages.StandardController(ics);
        VFC_ICSDelegateApprover testAccPlan = new VFC_ICSDelegateApprover(sc);       
        ApexPages.currentPage().getParameters().put('delegateEmail', 'test@test.com');
        ApexPages.currentPage().getParameters().put('approverstage', 'CSO');
        ApexPages.currentPage().getParameters().put('transactionType', 'Refund');
        ApexPages.currentPage().getParameters().put('index', '1');
        testAccPlan.listCSOApprovers[0].arAdjustment.CSO_Approver_Name__c = emp[0].Id;
        testAccPlan.delegateApproval();
    }
 
    static testMethod void testMethod9() {
         test.startTest();
        Customer_Service_Inquiries_ICS__c ics = [select Id, Case_Approval_Status__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.VFP_ICSDelegateApprover;
        pageRef.getParameters().put('id', String.valueOf(ics.Id));
        Test.setCurrentPage(pageRef);        
        ics.Case_Approval_Status__c = 'AR2 Submitted';
        update ics;
        ApexPages.StandardController sc = new ApexPages.StandardController(ics);
        VFC_ICSDelegateApprover testAccPlan = new VFC_ICSDelegateApprover(sc);
        ApexPages.currentPage().getParameters().put('delegateEmail', 'test@test.com');
        ApexPages.currentPage().getParameters().put('approverstage', 'AR2');
        ApexPages.currentPage().getParameters().put('transactionType', 'AR Adjustment');
        ApexPages.currentPage().getParameters().put('index', '1');
        testAccPlan.listAR2Approvers[0].arAdjustment.AR2_Approver_Name__c = emp[0].Id;
        testAccPlan.delegateApproval();
        test.stopTest();

    } 
        static testMethod void testMethod10() {
            test.startTest();
        Customer_Service_Inquiries_ICS__c ics = [select Id, Case_Approval_Status__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.VFP_ICSDelegateApprover;
        pageRef.getParameters().put('id', String.valueOf(ics.Id));
        Test.setCurrentPage(pageRef);
        
        ics.Case_Approval_Status__c = 'AR2 Submitted';
        update ics;
        ApexPages.StandardController sc = new ApexPages.StandardController(ics);
        VFC_ICSDelegateApprover testAccPlan = new VFC_ICSDelegateApprover(sc);
        ApexPages.currentPage().getParameters().put('delegateEmail', 'test@test.com');
        ApexPages.currentPage().getParameters().put('approverstage', 'AR2');
        ApexPages.currentPage().getParameters().put('transactionType', 'Credit Memo');
        ApexPages.currentPage().getParameters().put('index', '1');
        testAccPlan.listAR2Approvers[0].arAdjustment.AR2_Approver_Name__c = emp[0].Id;  
        testAccPlan.delegateApproval();
        test.stopTest();
    }
    
       static testMethod void testMethod11() {
         test.startTest();
        Customer_Service_Inquiries_ICS__c ics = [select Id, Case_Approval_Status__c from Customer_Service_Inquiries_ICS__c limit 1];
        List<Employees__c> emp = [select Email_Address__c from Employees__c where Email_Address__c = 'test1@test1.com'];
        PageReference pageRef = Page.VFP_ICSDelegateApprover;
        pageRef.getParameters().put('id', String.valueOf(ics.Id));
        Test.setCurrentPage(pageRef);       
        ics.Case_Approval_Status__c = 'AR2 Submitted';
        update ics;
        ApexPages.StandardController sc = new ApexPages.StandardController(ics);
        VFC_ICSDelegateApprover testAccPlan = new VFC_ICSDelegateApprover(sc);
        ApexPages.currentPage().getParameters().put('delegateEmail', 'test1@test1.com');
        ApexPages.currentPage().getParameters().put('approverstage', 'AR2');
        ApexPages.currentPage().getParameters().put('transactionType', 'Refund');
        ApexPages.currentPage().getParameters().put('index', '1');
        testAccPlan.listAR2Approvers[0].arAdjustment.AR2_Approver_Name__c = emp[0].Id;  
        testAccPlan.delegateApproval();
        test.stopTest();
    }

}