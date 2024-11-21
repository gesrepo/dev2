/**
        @@author soniya gopu For SLK Software services
        @@original version: 1/1/2018 
        @@changes made: 3/7/2018 removed fields (which are not required anymore) from queries
    **/

    public class CaseApproveRejectPageController{
        
      private final Customer_Service_Inquiries_ICS__c caseRecord;
        public String emailId {get; set;}
        public String status {get; set;}
        public Boolean alreadyApproved {get; set;}
        public String filename {get;set;}
        //public ContentVersion ConVer{get; set;}
        public Attachment attachment {get; set;}
        public String body {get;set;}
        
        public string userName{get;set;} //added for ICS Issue in June 2019
        public string passWord{get;set;} //added for ICS Issue in June 2019
        public boolean isAuthenticated{get;set;} //added for ICS Issue in June 2019
        public boolean renderApprovalPageBlock{get;set;} //added for ICS Issue in June 2019
        
        //to display multiple upload items.
        public String body1 {get;set;}
        public String filename1 {get;set;}
        public String body2 {get;set;}
        public String filename2 {get;set;}
        public String body3 {get;set;}
        public String filename3 {get;set;}
        public String body4 {get;set;}
        public String filename4 {get;set;}
        
        
        public String transactionType;
        public String recordId;
        public String approverStage;
        Customer_Service_Inquiries_ICS__c caseDetails;
        public Customer_Service_Inquiries_ICS__c caseEmp {get; set;}
        public blob file { get; set; }
      
        public CaseApproveRejectPageController(ApexPages.StandardController stdController){
            //ConVer= new ContentVersion();
            attachment = new Attachment();
            caseRecord = (Customer_Service_Inquiries_ICS__c) stdController.getRecord();
            emailId = ApexPages.currentPage().getParameters().get('email');
            status = ApexPages.currentPage().getParameters().get('status');
            String stageTransactionType = ApexPages.currentPage().getParameters().get('transactionType');
            recordId = ApexPages.currentPage().getParameters().get('recordId');
            alreadyApproved = false;
//            alreadyApproved = true;// added for ICS
            isAuthenticated=false;// added for ICS

            caseEmp = new Customer_Service_Inquiries_ICS__c();
            if(stageTransactionType != null && stageTransactionType != 'All') {
                approverStage = stageTransactionType.substring(0,3);
                transactionType = stageTransactionType.substring(3);
            } else
            {
                transactionType = stageTransactionType;
            }
            caseDetails = new Customer_Service_Inquiries_ICS__c();
            caseDetails = [SELECT Id, Name, Case_Approval_Status__c,
                             Case_Requestor_Approval_Status__c, Case_Requestor_Comment__c,
                             Opportunity_Name__r.Name, Account_Name__r.Name, 
                             Case_Requestor__r.Name,
                             Department__c,Title__c,Oracle_AR_Customer_Number__c, 
                             Show_Occur__r.Name, Show_Occur__r.Show_Name__r.Name, 
                             Project__c, Sales_Channel__c, Booth_Area__c,
                             Case_Requestor__r.First_Name__c, Case_Requestor__r.Last_Name__c,
                             Email_Copy_To__r.First_Name__c, Email_Copy_To__r.Last_Name__c,
                             Owner.Email
                             FROM Customer_Service_Inquiries_ICS__c
                             WHERE Id =: caseRecord.Id
                            ];
            Id caseId = caseRecord.Id;             
            if(transactionType == 'All') {
                List<AR_Adjustments__c> arList = new List<AR_Adjustments__c>();
                List<Credit_Memo_ICS__c> cmList = new  List<Credit_Memo_ICS__c>();
                List<Receipt_Reversals__c> rrList = new List<Receipt_Reversals__c>();
                List<Refunds_ICS__c> refundsList = new List<Refunds_ICS__c>();
                List<Payment_Transfer_ICS__c> paymentsList = new List<Payment_Transfer_ICS__c>();
                List<Charges__c> chargesList = new List<Charges__c>();
                
                String arAdjustmentQuery = arAdjustmentQuery();
                String creditMemoQuery = creditMemoQuery();
                String receiptReversalQuery = receiptReversalQuery();
                String refundQuery = refundQuery();
                arAdjustmentQuery += ' where AR_Adj_CSI_ID__c =: caseId';
                creditMemoQuery += ' where CSI_ICS__c =: caseId';
                receiptReversalQuery += ' where CSI_ICS__c =: caseId';
                refundQuery += ' where CSI_ICS__c =: caseId';
                if(caseDetails.Case_Approval_Status__c == 'LOB Submitted' || caseDetails.Case_Approval_Status__c == 'LOB Rejected') {
                    arAdjustmentQuery += ' AND DAM_Approver_Email_ID__c =: emailId AND Del_DAM_LOB_Approver__c != null';
                    arList = Database.query(arAdjustmentQuery);
                    creditMemoQuery += ' AND LOB_Approver_Email_ID__c =: emailId AND Del_LOB_Approver__c != null';
                    cmList = Database.query(creditMemoQuery);
                    System.debug('@@@cmList-LOB Submitted-->'+cmList);
                } else
                if(caseDetails.Case_Approval_Status__c == 'F&R Submitted' || caseDetails.Case_Approval_Status__c == 'F&R Rejected') {
                    arAdjustmentQuery += ' AND F_A_Approver_Email__c =: emailId AND Del_F_R_Approver__c != null';
                    arList = Database.query(arAdjustmentQuery);
                    creditMemoQuery += ' AND F_R_Approver_Email_ID__c =: emailId AND Del_F_R_Approver__c != null';
                    cmList = Database.query(creditMemoQuery);
                    System.debug('@@@cmList-F&R Submitted-->'+cmList);
                } else
                if(caseDetails.Case_Approval_Status__c == 'AR1 Submitted' || caseDetails.Case_Approval_Status__c == 'AR1 Rejected') {
                    arAdjustmentQuery += ' AND AR1_Approver_Email__c =: emailId AND Del_AR1_Approver__c != null';
                    arList = Database.query(arAdjustmentQuery);
                    creditMemoQuery += ' AND AR1_Approver_Email_ID__c =: emailId AND Del_AR1_Approver__c != null';
                    cmList = Database.query(creditMemoQuery);
                    System.debug('@@@cmList-AR1 Submitted-->'+cmList);
                    refundQuery += ' AND AR1_Approver_Email_ID__c =: emailId AND Del_AR1_Approver__c != null';
                    refundsList = Database.query(refundQuery);
                } else
                
                if(caseDetails.Case_Approval_Status__c == 'CSO Submitted' || caseDetails.Case_Approval_Status__c == 'CSO Rejected') {
                    arAdjustmentQuery += ' AND CSO_Approver_Email__c =: emailId AND Del_CSO_Approver__c != null';
                    arList = Database.query(arAdjustmentQuery);
                    creditMemoQuery += ' AND CSO_Approver_Email__c =: emailId AND Del_CSO_Approver__c != null';
                    cmList = Database.query(creditMemoQuery);
                    refundQuery += ' AND CSO_Approver_EmailID__c =: emailId AND Del_CSO_Approver__c != null';
                    refundsList = Database.query(refundQuery);
                } else    
                    
                    
                    
                if(caseDetails.Case_Approval_Status__c == 'AR2 Submitted' || caseDetails.Case_Approval_Status__c == 'AR2 Rejected') {
                    arAdjustmentQuery += ' AND AR2_Approver_Email__c =: emailId AND Del_AR2_Approver__c != null';
                    arList = Database.query(arAdjustmentQuery);
                    creditMemoQuery += ' AND AR2_Approver_Email_ID__c =: emailId AND Del_AR2_Approver__c != null';
                    cmList = Database.query(creditMemoQuery);
                    refundQuery += ' AND AR2_Approver_Email_ID__c =: emailId AND Del_AR2_Approver__c != null';
                    refundsList = Database.query(refundQuery);
                } else 
                if(caseDetails.Case_Approval_Status__c == 'Additional Submitted' || caseDetails.Case_Approval_Status__c == 'Additional Rejected') {
                    creditMemoQuery += ' AND Additional_Approver_Email_ID__c =: emailId AND Del_Additional_Approver__c != null';
                    cmList = Database.query(creditMemoQuery);
                    receiptReversalQuery += ' AND Approver_Email__c =: emailId AND Del_Additional_Approver__c != null';
                    //system.debug('emailId==='+emailId);
                    //system.debug('caseId==='+caseId);
                    //system.debug('receiptReversalQuery==='+receiptReversalQuery);
                    rrList = Database.query(receiptReversalQuery);
                    //system.debug('rrList==='+rrList);
                }
                if(arList.size() > 0) {
                    alreadyApproved = true;
                }
                if(cmList.size() > 0) {
                    alreadyApproved = true;
                }
                if(refundsList.size() > 0) {
                    alreadyApproved = true;
                }
                if(rrList.size() > 0) {
                    alreadyApproved = true;
                }
            }
            if(!alreadyApproved) {
                List<List<SObject>> searchList = [FIND :emailId IN ALL FIELDS 
                                                RETURNING AR_Adjustments__c(AR1_Approver_Email__c, CSO_Approver_Email__c, AR2_Approver_Email__c, F_A_Approver_Email__c, DAM_Approver_Email_ID__c, AR1_Approver_Status__c, AR2_Approver_Status__c, CSO_Approver_Status__c, DAM_Approver_Status__c, F_R_Approvers_Status__c WHERE AR_Adj_CSI_ID__c=:caseId),
                                                Refunds_ICS__c(AR1_Approver_Email_ID__c, AR2_Approver_Email_ID__c, CSO_Approver_EmailID__c, AR1_Approver_Status__c, AR2_Approver_Status__c, CSO_Approver_Status__c WHERE CSI_ICS__c=:caseId),
                                                Credit_Memo_ICS__c(LOB_Approver_Email_ID__c, F_R_Approver_Email_ID__c, AR1_Approver_Email_ID__c, CSO_Approver_Email__c, AR2_Approver_Email_ID__c, Additional_Approver_Email_ID__c, Additional_Approver_Status__c, AR1_Approver_Status__c, AR2_Approver_Status__c, CSO_Approver_Status__c, F_R_Approver_Status__c, LOB__c where CSI_ICS__c=:caseId)];
                
                for(AR_Adjustments__c ar : (List<AR_Adjustments__c>)searchList[0]) {
                    system.debug('ar==='+ar);
                    system.debug('status==='+caseDetails.Case_Approval_Status__c);
                    system.debug('emailId==='+emailId);
                    if(caseDetails.Case_Approval_Status__c.contains('LOB') && ar.DAM_Approver_Status__c == 'Rejected' && ar.DAM_Approver_Email_ID__c == emailId) {
                        alreadyApproved = true; 
                    } else
                    if(caseDetails.Case_Approval_Status__c.contains('F&R') && ((ar.DAM_Approver_Status__c == 'Approved' || ar.DAM_Approver_Status__c == 'Open') && ar.DAM_Approver_Email_ID__c == emailId)
                        || (ar.F_R_Approvers_Status__c == 'Rejected' && ar.F_A_Approver_Email__c == emailId)) {
                        alreadyApproved = true; 
                    } else
                    if(caseDetails.Case_Approval_Status__c.contains('AR1') && ((ar.F_R_Approvers_Status__c == 'Approved' || ar.F_R_Approvers_Status__c == 'Open') && ar.F_A_Approver_Email__c == emailId)
                        || (ar.AR1_Approver_Status__c == 'Rejected' && ar.AR1_Approver_Email__c == emailId)) {
                        alreadyApproved = true; 
                    } else
                    if(caseDetails.Case_Approval_Status__c.contains('CSO') && ((ar.AR1_Approver_Status__c == 'Approved' || ar.AR1_Approver_Status__c == 'Open') && ar.AR1_Approver_Email__c == emailId)
                        || (ar.CSO_Approver_Status__c == 'Rejected' && ar.CSO_Approver_Email__c == emailId)) {
                        alreadyApproved = true; 
                    } else
                    if(caseDetails.Case_Approval_Status__c.contains('AR2') && ((ar.CSO_Approver_Status__c == 'Approved' || ar.CSO_Approver_Status__c == 'Open') && ar.CSO_Approver_Email__c == emailId)
                        || (ar.AR2_Approver_Status__c == 'Rejected' && ar.AR2_Approver_Email__c == emailId)) {
                        alreadyApproved = true; 
                    } else
                    if(caseDetails.Case_Approval_Status__c.contains('Case Approved') && ((ar.AR2_Approver_Status__c == 'Approved' || ar.AR2_Approver_Status__c == 'Open') && ar.AR2_Approver_Email__c == emailId)) {
                        alreadyApproved = true; 
                    }
                }
                if(!alreadyApproved) {
                    for(Refunds_ICS__c refund : (List<Refunds_ICS__c>)searchList[1]) {
                        if(caseDetails.Case_Approval_Status__c.contains('AR1') && refund.AR1_Approver_Status__c == 'Rejected' && refund.AR1_Approver_Email_ID__c == emailId) {
                            alreadyApproved = true; 
                        } else
                        if(caseDetails.Case_Approval_Status__c.contains('CSO') && ((refund.AR1_Approver_Status__c == 'Approved' || refund.AR1_Approver_Status__c == 'Open') && refund.AR1_Approver_Email_ID__c == emailId)
                            || (refund.CSO_Approver_Status__c == 'Rejected' && refund.CSO_Approver_EmailID__c == emailId)) {
                            alreadyApproved = true; 
                        } else
                        if(caseDetails.Case_Approval_Status__c.contains('AR2') && ((refund.CSO_Approver_Status__c == 'Approved' || refund.CSO_Approver_Status__c == 'Open') && refund.CSO_Approver_EmailID__c == emailId)
                            || (refund.AR2_Approver_Status__c == 'Rejected' && refund.AR2_Approver_Email_ID__c == emailId)) {
                            alreadyApproved = true; 
                        } else
                        if(caseDetails.Case_Approval_Status__c.contains('Case Approved') && ((refund.AR2_Approver_Status__c == 'Approved' || refund.AR2_Approver_Status__c == 'Open') && refund.AR2_Approver_Email_ID__c == emailId)) {
                            alreadyApproved = true; 
                        }else
                        if(caseDetails.Case_Approval_Status__c.contains('Case Approved') && ((refund.AR1_Approver_Status__c == 'Approved' || refund.AR1_Approver_Status__c == 'Open') && refund.AR1_Approver_Email_ID__c == emailId)) {
                            alreadyApproved = true; 
                        }
                    }
                }
                if(!alreadyApproved) {
                    for(Credit_Memo_ICS__c cm : (List<Credit_Memo_ICS__c>)searchList[2]) {
                        if(caseDetails.Case_Approval_Status__c.contains('LOB') && cm.LOB__c == 'Rejected' && cm.LOB_Approver_Email_ID__c == emailId) {
                            alreadyApproved = true; 
                        } else
                        if(caseDetails.Case_Approval_Status__c.contains('F&R') && ((cm.LOB__c == 'Approved' || cm.LOB__c == 'Open') && cm.LOB_Approver_Email_ID__c == emailId)
                            || (cm.F_R_Approver_Status__c == 'Rejected' && cm.F_R_Approver_Email_ID__c == emailId)) {
                            alreadyApproved = true; 
                        } else
                        if(caseDetails.Case_Approval_Status__c.contains('AR1') && ((cm.F_R_Approver_Status__c == 'Approved' || cm.F_R_Approver_Status__c == 'Open') && cm.F_R_Approver_Email_ID__c == emailId)
                            || (cm.AR1_Approver_Status__c == 'Rejected' && cm.AR1_Approver_Email_ID__c == emailId)) {
                            alreadyApproved = true; 
                        } else
                        if(caseDetails.Case_Approval_Status__c.contains('CSO') && ((cm.AR1_Approver_Status__c == 'Approved' || cm.AR1_Approver_Status__c == 'Open') && cm.AR1_Approver_Email_ID__c == emailId)
                            || (cm.CSO_Approver_Status__c == 'Rejected' && cm.CSO_Approver_Email__c == emailId)) {
                            alreadyApproved = true; 
                        } else
                        if(caseDetails.Case_Approval_Status__c.contains('AR2') && ((cm.CSO_Approver_Status__c == 'Approved' || cm.CSO_Approver_Status__c == 'Open') && cm.CSO_Approver_Email__c == emailId)
                            || (cm.AR2_Approver_Status__c == 'Rejected' && cm.AR2_Approver_Email_ID__c == emailId)) {
                            alreadyApproved = true; 
                        } else
                        if(caseDetails.Case_Approval_Status__c.contains('Additional') && ((cm.AR2_Approver_Status__c == 'Approved' || cm.AR2_Approver_Status__c == 'Open') && cm.AR2_Approver_Email_ID__c == emailId)
                            || (cm.Additional_Approver_Status__c == 'Rejected' && cm.Additional_Approver_Email_ID__c == emailId)) {
                            alreadyApproved = true; 
                        } else
                        if(caseDetails.Case_Approval_Status__c.contains('Case Approved') && ((cm.Additional_Approver_Status__c == 'Approved' || cm.Additional_Approver_Status__c == 'Open') && cm.Additional_Approver_Email_ID__c == emailId)) {
                            alreadyApproved = true; 
                        }
                    }
                }
            }
            system.debug(' alreadyApproved :'+alreadyApproved);
            //added for ICS Issue in June 2019
            if(alreadyApproved)
            {
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'This case '+caseDetails.Oracle_AR_Customer_Number__c +' is already approved.'));
                isAuthenticated=true;
            }
            //added for ICS Issue in June 2019
            //retrieveFiles();
            
        }
        
        /******************
        Method : AuthenticateUser
        Description : This method is invoked from the VF "CaseApproveRejectPage". It's used to authenticate user when a user approve/rejection
                      a record in ICS approval .//added for ICS Issue in June 2019
        created : June 2019 by Gaurav Kumar 
        ******************/
        public pageReference AuthenticateUser(){
            
            system.debug('username :' +userName + ' alreadyApproved :'+alreadyApproved);            
            if(userName != '' && passWord !='')
            {   
                //calling startAppSession service
                ICSwwwViadComSecurityV2.AppSessionInfo obj ;
                ICSwwwViadComSecurityV2.BasicHttpBinding_IAuthenticationService Iobj = new ICSwwwViadComSecurityV2.BasicHttpBinding_IAuthenticationService(); 
                obj = Iobj.StartAppSession('SalesForce','76v.H-_7};9^+4(]J.;3','','');
                system.debug('app session response : '+obj.SessionID);

                //calling authicate userinfo service.
                ICSwwwViadComV1.DirectoryResult objUserInfo;
                objUserInfo = Iobj.AuthenticateUser(obj.SessionID,userName,passWord);
                system.debug('UserInfo response : '+objUserInfo.IsSuccessful+ ' username :'+ userName + ' emailId :'+ emailid); 
                if(objUserInfo.IsSuccessful) 
                {
                    if(emailid.contains (userName) )
                    {
                        renderApprovalPageBlock = true;
                        isAuthenticated=true;
                    }else
                    {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'You are not authorized for approval'));
                    }
                }else
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'You are not authorized for approval'));
                }
            }           
            return null;
            
        }
        
        public pageReference customerAction(){
            //try{
                //system.debug('filename '+filename);
                //system.debug('body '+body);
                List<AR_Adjustments__c> arList =new List<AR_Adjustments__c>();
                List<Credit_Memo_ICS__c> cmList = new  List<Credit_Memo_ICS__c>();
                List<Receipt_Reversals__c> rrList = new List<Receipt_Reversals__c>();
                List<Refunds_ICS__c> refundsList = new List<Refunds_ICS__c>();
                if(status == 'REJECT' && (caseRecord.Review_Comments__c == null || caseRecord.Review_Comments__c == '')){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Comments are mandatory during rejection'));
                    return null;
                }
                Employees__c emp = [SELECT Id, Name, Email_Address__c
                                    FROM Employees__c
                                    WHERE Email_Address__c =: emailId
                                    LIMIT 1
                                   ];
                
                /*Customer_Service_Inquiries_ICS__c caseDetails = [SELECT Id, Case_Approval_Status__c,
                                                                 Case_Requestor_Approval_Status__c, Case_Requestor_Comment__c
                                                                 FROM Customer_Service_Inquiries_ICS__c
                                                                 WHERE Id =: caseRecord.Id
                                                                ];*/
               String arAdjustmentQuery = arAdjustmentQuery();
                Id caseId = caseRecord.Id;
                if(transactionType == 'All') {
                    arAdjustmentQuery += ' where AR_Adj_CSI_ID__c =: caseId';
                    arList = Database.query(arAdjustmentQuery);
                }else
                if(recordId != null && transactionType == 'ARAdjustment') {
                    arAdjustmentQuery += ' where Id =: recordId';
                    arList = Database.query(arAdjustmentQuery); 
                } 
                //system.debug('arList==='+arList);    
                List<Charges__c> chargesList = [SELECT Id, CSI_ICS__c, Pymt_Type__c, Justification_for_Charges_Request__c, Sales_Receipt__c,Sales_Order__c,Total_Amount__c, Total_Charges_Currency__c              
                                                FROM Charges__c
                                                WHERE CSI_ICS__c =: caseRecord.Id
                                               ];
                String creditMemoQuery = creditMemoQuery();
                if(transactionType == 'All') {
                    creditMemoQuery += ' where CSI_ICS__c =: caseId';
                    cmList = Database.query(creditMemoQuery);
                }else
                if(recordId != null && transactionType == 'CreditMemo') {
                    creditMemoQuery += ' where Id =: recordId';
                    cmList = Database.query(creditMemoQuery);
                } 
                String receiptReversalQuery = receiptReversalQuery();
                if(transactionType == 'All') {
                    receiptReversalQuery += ' where CSI_ICS__c =: caseId';
                    rrList = Database.query(receiptReversalQuery);
                }else
                if(recordId != null && transactionType == 'ReceiptReversals') {
                    receiptReversalQuery += ' where Id =: recordId';
                    rrList = Database.query(receiptReversalQuery);
                }                                   
                String refundQuery = refundQuery();
                if(transactionType == 'All') {
                    refundQuery += ' where CSI_ICS__c =: caseId';
                    refundsList = Database.query(refundQuery);
                }else
                if(recordId != null && transactionType == 'Refund') {
                    refundQuery += ' where Id =: recordId';
                    refundsList = Database.query(refundQuery);
                }   
                List<Payment_Transfer_ICS__c> paymentsList = [SELECT Id, CSI_ICS_No__c, Receipt__c, Justification_for_Pymt_Transfer_Request__c, Sales_Order__c, Transfer_Amount__c, Total_Payments_Currency__c                                                        
                                                              FROM Payment_Transfer_ICS__c
                                                              WHERE CSI_ICS_No__c =: caseRecord.Id
                                                             ];
                Integer requestorRejectCount = 0;
                Integer lobRejectCount = 0;
                Integer frRejectCount = 0;
                Integer ar1RejectCount = 0;
                Integer CSORejectCount = 0;
                Integer ar2RejectCount = 0;
                Integer addRejectCount = 0;           
                Boolean isChangedAR = false;
                Boolean isChangedC = false;
                Boolean isChangedCM = false;
                Boolean isChangedRR = false;
                Boolean isChangedR = false;
                Boolean isChangedP = false;
                
                List<Approval_History_ICS__c> approvalHistoryList = new List<Approval_History_ICS__c>();
                //system.debug('caseDetails.Case_Approval_Status__c==='+caseDetails.Case_Approval_Status__c);
                //system.debug('status==='+status);
                if(caseDetails.Case_Approval_Status__c == 'Requestor Submitted' ){
                    if(status == 'APPROVE'){
                        caseDetails.Case_Requestor_Approval_Status__c = 'Approved';
                    } else
                        
                    {
                        caseDetails.Case_Requestor_Approval_Status__c = 'Rejected';
                    }
                    caseDetails.Case_Requestor_Comment__c = caseRecord.Review_Comments__c;
                    
                    
                }else if(caseDetails.Case_Approval_Status__c == 'LOB Submitted' || caseDetails.Case_Approval_Status__c == 'LOB Rejected'){  //&& lobRejectCount == 0
                    for(AR_Adjustments__c ar : arList){
                        //Checks Delegated Approver
                        if(ar.Del_DAM_LOB_Approver_Email__c != null && ar.Del_DAM_LOB_Approver_Email__c == emailId && (transactionType == 'ARAdjustment' || transactionType == 'All')){
                            Approval_History_ICS__c ah = new Approval_History_ICS__c();
                            if(status == 'APPROVE'){
                                ar.DAM_Approver_Status__c = 'Approved';
                                ar.DAM_Approver_Comments__c = caseRecord.Review_Comments__c;
                                isChangedAR = true;
                                ah.AR_Adjustments__c = ar.Id;
                                ah.Case__c = caseRecord.Id;
                                ah.Comments__c = caseRecord.Review_Comments__c;
                                ah.Status__c = 'Approved';
                                ah.Stage__c = 'LOB';
                                ah.Employee_Name__c = emp.Id;
                                approvalHistoryList.add(ah);
                            }else{
                                ar.DAM_Approver_Status__c = 'Rejected';
                                ar.DAM_Approver_Comments__c = caseRecord.Review_Comments__c;
                                isChangedAR = true;
                                ah.AR_Adjustments__c = ar.Id;
                                ah.Case__c = caseRecord.Id;
                                ah.Comments__c = caseRecord.Review_Comments__c;
                                ah.Status__c = 'Rejected';
                                ah.Stage__c = 'LOB';
                                ah.Employee_Name__c = emp.Id;
                                approvalHistoryList.add(ah);
                            }
                        }
                        else { //AR Adjustment LOB Approver
                            if(ar.DAM_Approver_Email_ID__c != null && ar.DAM_Approver_Email_ID__c == emailId && (transactionType == 'ARAdjustment' || transactionType == 'All')){
                                Approval_History_ICS__c ah = new Approval_History_ICS__c();
                                if(status == 'APPROVE'){
                                    ar.DAM_Approver_Status__c = 'Approved';
                                    ar.DAM_Approver_Comments__c = caseRecord.Review_Comments__c;
                                    isChangedAR = true;
                                    ah.AR_Adjustments__c = ar.Id;
                                    ah.Case__c = caseRecord.Id;
                                    ah.Comments__c = caseRecord.Review_Comments__c;
                                    ah.Status__c = 'Approved';
                                    ah.Stage__c = 'LOB';
                                    ah.Employee_Name__c = emp.Id;
                                    approvalHistoryList.add(ah);
                                }else{
                                    ar.DAM_Approver_Status__c = 'Rejected';
                                    ar.DAM_Approver_Comments__c = caseRecord.Review_Comments__c;
                                    isChangedAR = true;
                                    ah.AR_Adjustments__c = ar.Id;
                                    ah.Case__c = caseRecord.Id;
                                    ah.Comments__c = caseRecord.Review_Comments__c;
                                    ah.Status__c = 'Rejected';
                                    ah.Stage__c = 'LOB';
                                    ah.Employee_Name__c = emp.Id;
                                    approvalHistoryList.add(ah);
                                }
                            }
                        }
                            
                    }
                    
                      System.debug('@@@cmList--->'+cmList);  
                    for(Credit_Memo_ICS__c cm : cmList){ //credir memo LOB delegated user
                        System.debug('@@@cm--->'+cm);
                        
                        if(cm.Del_LOB_Approver_Email__c != null && cm.Del_LOB_Approver_Email__c == emailId && (transactionType == 'CreditMemo' || transactionType == 'All')){
                            Approval_History_ICS__c ah = new Approval_History_ICS__c();
                            if(status == 'APPROVE'){
                                cm.LOB__c = 'Approved';
                                cm.LOB_Approver_Comments__c = caseRecord.Review_Comments__c;
                                isChangedCM = true;
                                ah.Credit_Memo__c = cm.Id;
                                ah.Case__c = caseRecord.Id;
                                ah.Comments__c = caseRecord.Review_Comments__c;
                                ah.Status__c = 'Approved';
                                ah.Stage__c = 'LOB';
                                ah.Employee_Name__c = emp.Id;
                                approvalHistoryList.add(ah);
                            }else{
                                cm.LOB__c = 'Rejected';
                                cm.LOB_Approver_Comments__c = caseRecord.Review_Comments__c;
                                isChangedCM = true;
                                ah.Credit_Memo__c = cm.Id;
                                ah.Case__c = caseRecord.Id;
                                ah.Comments__c = caseRecord.Review_Comments__c;
                                ah.Status__c = 'Rejected';
                                ah.Stage__c = 'LOB';
                                ah.Employee_Name__c = emp.Id;
                                approvalHistoryList.add(ah);
                            }
                        }
                        else{  //credit memo LOB Approver
                            System.debug('@@@cm--->'+cm.LOB_Approver_Email_ID__c);
                            if(cm.LOB_Approver_Email_ID__c != null && cm.LOB_Approver_Email_ID__c == emailId && (transactionType == 'CreditMemo' || transactionType == 'All')){
                                Approval_History_ICS__c ah = new Approval_History_ICS__c();
                                if(status == 'APPROVE'){
                                    cm.LOB__c = 'Approved';
                                    cm.LOB_Approver_Comments__c = caseRecord.Review_Comments__c;
                                    isChangedCM = true;
                                    ah.Credit_Memo__c = cm.Id;
                                    ah.Case__c = caseRecord.Id;
                                    ah.Comments__c = caseRecord.Review_Comments__c;
                                    ah.Status__c = 'Approved';
                                    ah.Stage__c = 'LOB';
                                    ah.Employee_Name__c = emp.Id;
                                    approvalHistoryList.add(ah);
                                }else{
                                    cm.LOB__c = 'Rejected';
                                    cm.LOB_Approver_Comments__c = caseRecord.Review_Comments__c;
                                    isChangedCM = true;
                                    ah.Credit_Memo__c = cm.Id;
                                    ah.Case__c = caseRecord.Id;
                                    ah.Comments__c = caseRecord.Review_Comments__c;
                                    ah.Status__c = 'Rejected';
                                    ah.Stage__c = 'LOB';
                                    ah.Employee_Name__c = emp.Id;
                                    approvalHistoryList.add(ah);
                                }
                            }
                        }
                    }   

                    }else if(caseDetails.Case_Approval_Status__c == 'F&R Submitted' || caseDetails.Case_Approval_Status__c == 'F&R Rejected'){  //&& frRejectCount == 0
                    //AR Adjustment F&R Delegated Approver
                    for(AR_Adjustments__c ar : arList){
                         if(ar.Del_F_R_Approver_Email__c != null && ar.Del_F_R_Approver_Email__c == emailId && (transactionType == 'ARAdjustment' || transactionType == 'All')){
                            Approval_History_ICS__c ah = new Approval_History_ICS__c();
                            if(status == 'APPROVE'){
                                ar.F_R_Approvers_Status__c = 'Approved';
                                ar.F_R_Approval_Comments__c = caseRecord.Review_Comments__c;
                                isChangedAR = true;
                                ah.AR_Adjustments__c = ar.Id;
                                ah.Case__c = caseRecord.Id;
                                ah.Comments__c = caseRecord.Review_Comments__c;
                                ah.Status__c = 'Approved';
                                ah.Stage__c = 'F&R';
                                ah.Employee_Name__c = emp.Id;
                                approvalHistoryList.add(ah);
                            }else{
                                ar.F_R_Approvers_Status__c = 'Rejected';
                                ar.F_R_Approval_Comments__c = caseRecord.Review_Comments__c;
                                isChangedAR = true;
                                ah.AR_Adjustments__c = ar.Id;
                                ah.Case__c = caseRecord.Id;
                                ah.Comments__c = caseRecord.Review_Comments__c;
                                ah.Status__c = 'Rejected';
                                ah.Stage__c = 'F&R';
                                ah.Employee_Name__c = emp.Id;
                                approvalHistoryList.add(ah);
                            }
                        }
                        else{ // AR Adjustment F&R Approver
                            if(ar.F_A_Approver_Email__c != null && ar.F_A_Approver_Email__c == emailId && (transactionType == 'ARAdjustment' || transactionType == 'All')){
                                Approval_History_ICS__c ah = new Approval_History_ICS__c();
                                if(status == 'APPROVE'){
                                    ar.F_R_Approvers_Status__c = 'Approved';
                                    ar.F_R_Approval_Comments__c = caseRecord.Review_Comments__c;
                                    isChangedAR = true;
                                    ah.AR_Adjustments__c = ar.Id;
                                    ah.Case__c = caseRecord.Id;
                                    ah.Comments__c = caseRecord.Review_Comments__c;
                                    ah.Status__c = 'Approved';
                                    ah.Stage__c = 'F&R';
                                    ah.Employee_Name__c = emp.Id;
                                    approvalHistoryList.add(ah);
                                }else{
                                    ar.F_R_Approvers_Status__c = 'Rejected';
                                    ar.F_R_Approval_Comments__c = caseRecord.Review_Comments__c;
                                    isChangedAR = true;
                                    ah.AR_Adjustments__c = ar.Id;
                                    ah.Case__c = caseRecord.Id;
                                    ah.Comments__c = caseRecord.Review_Comments__c;
                                    ah.Status__c = 'Rejected';
                                    ah.Stage__c = 'F&R';
                                    ah.Employee_Name__c = emp.Id;
                                    approvalHistoryList.add(ah);
                                }
                            }
                        }
                        
                    }
                    for(Credit_Memo_ICS__c cm : cmList){  // Credit mrmo F&R Delegated user
                        if(cm.Del_F_R_Approver_Email__c != null && cm.Del_F_R_Approver_Email__c == emailId && (transactionType == 'CreditMemo' || transactionType == 'All')){
                            Approval_History_ICS__c ah = new Approval_History_ICS__c();
                            if(status == 'APPROVE'){
                                cm.F_R_Approver_Status__c = 'Approved';
                                cm.F_R_Approver_Comments__c = caseRecord.Review_Comments__c;
                                isChangedCM = true;
                                ah.Credit_Memo__c = cm.Id;
                                ah.Case__c = caseRecord.Id;
                                ah.Comments__c = caseRecord.Review_Comments__c;
                                ah.Status__c = 'Approved';
                                ah.Stage__c = 'F&R';
                                ah.Employee_Name__c = emp.Id;
                                approvalHistoryList.add(ah);
                            }else{ 
                                cm.F_R_Approver_Status__c = 'Rejected';
                                cm.F_R_Approver_Comments__c = caseRecord.Review_Comments__c;
                                isChangedCM = true;
                                ah.Credit_Memo__c = cm.Id;
                                ah.Case__c = caseRecord.Id;
                                ah.Comments__c = caseRecord.Review_Comments__c;
                                ah.Status__c = 'Rejected';
                                ah.Stage__c = 'F&R';
                                ah.Employee_Name__c = emp.Id;
                                approvalHistoryList.add(ah);
                            }
                        }
                        else{   //credit memo F&R Approver
                            if(cm.F_R_Approver_Email_ID__c != null && cm.F_R_Approver_Email_ID__c == emailId && (transactionType == 'CreditMemo' || transactionType == 'All')){
                                Approval_History_ICS__c ah = new Approval_History_ICS__c();
                                if(status == 'APPROVE'){
                                    cm.F_R_Approver_Status__c = 'Approved';
                                    cm.F_R_Approver_Comments__c = caseRecord.Review_Comments__c;
                                    isChangedCM = true;
                                    ah.Credit_Memo__c = cm.Id;
                                    ah.Case__c = caseRecord.Id;
                                    ah.Comments__c = caseRecord.Review_Comments__c;
                                    ah.Status__c = 'Approved';
                                    ah.Stage__c = 'F&R';
                                    ah.Employee_Name__c = emp.Id;
                                    approvalHistoryList.add(ah);
                                }else{
                                    cm.F_R_Approver_Status__c = 'Rejected';
                                    cm.F_R_Approver_Comments__c = caseRecord.Review_Comments__c;
                                    isChangedCM = true;
                                    ah.Credit_Memo__c = cm.Id;
                                    ah.Case__c = caseRecord.Id;
                                    ah.Comments__c = caseRecord.Review_Comments__c;
                                    ah.Status__c = 'Rejected';
                                    ah.Stage__c = 'F&R';
                                    ah.Employee_Name__c = emp.Id;
                                    approvalHistoryList.add(ah);
                                }
                            }
                        }
                    }
                }else if(caseDetails.Case_Approval_Status__c == 'AR1 Submitted' || caseDetails.Case_Approval_Status__c == 'AR1 Rejected'){  //&& ar1RejectCount == 0
                    for(AR_Adjustments__c ar : arList){
                        //Ar Adjustment AR1 Delegated approver
                        if(ar.Del_AR1_Approver_Email__c != null && ar.Del_AR1_Approver_Email__c == emailId && (transactionType == 'ARAdjustment' || transactionType == 'All')){
                            Approval_History_ICS__c ah = new Approval_History_ICS__c();
                            if(status == 'APPROVE'){
                                ar.AR1_Approver_Status__c = 'Approved';
                                ar.AR1_Approval_Comments__c = caseRecord.Review_Comments__c;
                                isChangedAR = true;
                                ah.AR_Adjustments__c = ar.Id;
                                ah.Case__c = caseRecord.Id;
                                ah.Comments__c = caseRecord.Review_Comments__c;
                                ah.Status__c = 'Approved';
                                ah.Stage__c = 'AR1';
                                ah.Employee_Name__c = emp.Id;
                                approvalHistoryList.add(ah);
                            }else{
                                ar.AR1_Approver_Status__c = 'Rejected';
                                ar.AR1_Approval_Comments__c = caseRecord.Review_Comments__c;
                                isChangedAR = true;
                                ah.AR_Adjustments__c = ar.Id;
                                ah.Case__c = caseRecord.Id;
                                ah.Comments__c = caseRecord.Review_Comments__c;
                                ah.Status__c = 'Rejected';
                                ah.Stage__c = 'AR1';
                                ah.Employee_Name__c = emp.Id;
                                approvalHistoryList.add(ah);
                            }
                        }
                        else{ //AR Adjustment AR1 Approver
                            if(ar.AR1_Approver_Email__c != null && ar.AR1_Approver_Email__c == emailId && (transactionType == 'ARAdjustment' || transactionType == 'All')){
                                Approval_History_ICS__c ah = new Approval_History_ICS__c();
                                if(status == 'APPROVE'){
                                    ar.AR1_Approver_Status__c = 'Approved';
                                    ar.AR1_Approval_Comments__c = caseRecord.Review_Comments__c;
                                    isChangedAR = true;
                                    ah.AR_Adjustments__c = ar.Id;
                                    ah.Case__c = caseRecord.Id;
                                    ah.Comments__c = caseRecord.Review_Comments__c;
                                    ah.Status__c = 'Approved';
                                    ah.Stage__c = 'AR1';
                                    ah.Employee_Name__c = emp.Id;
                                    approvalHistoryList.add(ah);
                                }else{
                                    ar.AR1_Approver_Status__c = 'Rejected';
                                    ar.AR1_Approval_Comments__c = caseRecord.Review_Comments__c;
                                    isChangedAR = true;
                                    ah.AR_Adjustments__c = ar.Id;
                                    ah.Case__c = caseRecord.Id;
                                    ah.Comments__c = caseRecord.Review_Comments__c;
                                    ah.Status__c = 'Rejected';
                                    ah.Stage__c = 'AR1';
                                    ah.Employee_Name__c = emp.Id;
                                    approvalHistoryList.add(ah);
                                }
                            }
                        }
                    }
                    for(Credit_Memo_ICS__c cm : cmList){ // credit memo AR1 delegated approver
                        if(cm.Del_AR1_Approver_Email__c != null && cm.Del_AR1_Approver_Email__c == emailId && (transactionType == 'CreditMemo' || transactionType == 'All')){
                            Approval_History_ICS__c ah = new Approval_History_ICS__c();
                            if(status == 'APPROVE'){
                                cm.AR1_Approver_Status__c = 'Approved';
                                cm.AR1_Approver_Comments__c = caseRecord.Review_Comments__c;
                                isChangedCM = true;
                                ah.Credit_Memo__c = cm.Id;
                                ah.Case__c = caseRecord.Id;
                                ah.Comments__c = caseRecord.Review_Comments__c;
                                ah.Status__c = 'Approved';
                                ah.Stage__c = 'AR1';
                                ah.Employee_Name__c = emp.Id;
                                approvalHistoryList.add(ah);
                            }else{
                                cm.AR1_Approver_Status__c = 'Rejected';
                                cm.AR1_Approver_Comments__c = caseRecord.Review_Comments__c;
                                isChangedCM = true;
                                ah.Credit_Memo__c = cm.Id;
                                ah.Case__c = caseRecord.Id;
                                ah.Comments__c = caseRecord.Review_Comments__c;
                                ah.Status__c = 'Rejected';
                                ah.Stage__c = 'AR1';
                                ah.Employee_Name__c = emp.Id;
                                approvalHistoryList.add(ah);
                            }
                        }
                        else{   //credit memo ar1 approver
                            if(cm.AR1_Approver_Email_ID__c != null && cm.AR1_Approver_Email_ID__c == emailId && (transactionType == 'CreditMemo' || transactionType == 'All')){
                                Approval_History_ICS__c ah = new Approval_History_ICS__c();
                                if(status == 'APPROVE'){
                                    cm.AR1_Approver_Status__c = 'Approved';
                                    cm.AR1_Approver_Comments__c = caseRecord.Review_Comments__c;
                                    isChangedCM = true;
                                    ah.Credit_Memo__c = cm.Id;
                                    ah.Case__c = caseRecord.Id;
                                    ah.Comments__c = caseRecord.Review_Comments__c;
                                    ah.Status__c = 'Approved';
                                    ah.Stage__c = 'AR1';
                                    ah.Employee_Name__c = emp.Id;
                                    approvalHistoryList.add(ah);
                                }else{
                                    cm.AR1_Approver_Status__c = 'Rejected';
                                    cm.AR1_Approver_Comments__c = caseRecord.Review_Comments__c;
                                    isChangedCM = true;
                                    ah.Credit_Memo__c = cm.Id;
                                    ah.Case__c = caseRecord.Id;
                                    ah.Comments__c = caseRecord.Review_Comments__c;
                                    ah.Status__c = 'Rejected';
                                    ah.Stage__c = 'AR1';
                                    ah.Employee_Name__c = emp.Id;
                                    approvalHistoryList.add(ah);
                                }
                            }
                        }
                    }
                    for(Refunds_ICS__c r : refundsList){  // refunds AR1 delegated user
                        System.debug('@@@refundsList-->'+r.Del_AR1_Approver_Email__c);
                        if(r.Del_AR1_Approver_Email__c != null && r.Del_AR1_Approver_Email__c == emailId && (transactionType == 'Refund' || transactionType == 'All')){
                            Approval_History_ICS__c ah = new Approval_History_ICS__c();
                            if(status == 'APPROVE'){
                                r.AR1_Approver_Status__c = 'Approved';
                                r.AR1_Approver_Comments__c = caseRecord.Review_Comments__c;
                                isChangedR = true;
                                ah.Refunds__c = r.Id;
                                ah.Case__c = caseRecord.Id;
                                ah.Comments__c = caseRecord.Review_Comments__c;
                                ah.Status__c = 'Approved';
                                ah.Stage__c = 'AR1';
                                ah.Employee_Name__c = emp.Id;
                                approvalHistoryList.add(ah);
                            }else{
                                r.AR1_Approver_Status__c = 'Rejected';
                                r.AR1_Approver_Comments__c = caseRecord.Review_Comments__c;
                                isChangedR = true;
                                ah.Refunds__c = r.Id;
                                ah.Case__c = caseRecord.Id;
                                ah.Comments__c = caseRecord.Review_Comments__c;
                                ah.Status__c = 'Rejected';
                                ah.Stage__c = 'AR1';
                                ah.Employee_Name__c = emp.Id;
                                approvalHistoryList.add(ah);
                            }
                        }
                        else{   // refunds AR1 approver
                            System.debug('@@@r--->'+r.AR1_Approver_Email_ID__c);
                            System.debug('@@@transactionType--->'+transactionType);
                            System.debug('@@@emailId--->'+emailId);
                            if(r.AR1_Approver_Email_ID__c != null && r.AR1_Approver_Email_ID__c == emailId && (transactionType == 'Refund' || transactionType == 'All')){
                                Approval_History_ICS__c ah = new Approval_History_ICS__c();
                                if(status == 'APPROVE'){
                                    r.AR1_Approver_Status__c = 'Approved';
                                    r.AR1_Approver_Comments__c = caseRecord.Review_Comments__c;
                                    isChangedR = true;
                                    ah.Refunds__c = r.Id;
                                    ah.Case__c = caseRecord.Id;
                                    ah.Comments__c = caseRecord.Review_Comments__c;
                                    ah.Status__c = 'Approved';
                                    ah.Stage__c = 'AR1';
                                    ah.Employee_Name__c = emp.Id;
                                    approvalHistoryList.add(ah);
                                }else{
                                    r.AR1_Approver_Status__c = 'Rejected';
                                    r.AR1_Approver_Comments__c = caseRecord.Review_Comments__c;
                                    isChangedR = true;
                                    ah.Refunds__c = r.Id;
                                    ah.Case__c = caseRecord.Id;
                                    ah.Comments__c = caseRecord.Review_Comments__c;
                                    ah.Status__c = 'Rejected';
                                    ah.Stage__c = 'AR1';
                                    ah.Employee_Name__c = emp.Id;
                                    approvalHistoryList.add(ah);
                                }
                            }
                        }
                    }
                
                    
              }else if(caseDetails.Case_Approval_Status__c == 'CSO Submitted' || caseDetails.Case_Approval_Status__c == 'CSO Rejected'){  //&& CSORejectCount == 0
                    for(AR_Adjustments__c ar : arList){ //AR Adjustment CSO Delegated approver
                        if(ar.Del_CSO_Approver_Email__c != null && ar.Del_CSO_Approver_Email__c == emailId && (transactionType == 'ARAdjustment' || transactionType == 'All')){
                            Approval_History_ICS__c ah = new Approval_History_ICS__c();
                            if(status == 'APPROVE'){
                                ar.CSO_Approver_Status__c = 'Approved';
                                ar.CSO_Approval_Comments__c = caseRecord.Review_Comments__c;
                                isChangedAR = true;
                                ah.AR_Adjustments__c = ar.Id;
                                ah.Case__c = caseRecord.Id;
                                ah.Comments__c = caseRecord.Review_Comments__c;
                                ah.Status__c = 'Approved';
                                ah.Stage__c = 'CsO';
                                ah.Employee_Name__c = emp.Id;
                                approvalHistoryList.add(ah);
                            }else{
                                ar.CSO_Approver_Status__c = 'Rejected';
                                ar.CSO_Approval_Comments__c = caseRecord.Review_Comments__c;
                                isChangedAR = true;
                                ah.AR_Adjustments__c = ar.Id;
                                ah.Case__c = caseRecord.Id;
                                ah.Comments__c = caseRecord.Review_Comments__c;
                                ah.Status__c = 'Rejected';
                                ah.Stage__c = 'CSO';
                                ah.Employee_Name__c = emp.Id;
                                approvalHistoryList.add(ah);
                            }
                        }
                        else{ //AR Adjustment CSO approver
                            if(ar.CSO_Approver_Email__c != null && ar.CSO_Approver_Email__c == emailId && (transactionType == 'ARAdjustment' || transactionType == 'All')){
                                Approval_History_ICS__c ah = new Approval_History_ICS__c();
                                if(status == 'APPROVE'){
                                    ar.CSO_Approver_Status__c = 'Approved';
                                    ar.CSO_Approval_Comments__c = caseRecord.Review_Comments__c;
                                    isChangedAR = true;
                                    ah.AR_Adjustments__c = ar.Id;
                                    ah.Case__c = caseRecord.Id;
                                    ah.Comments__c = caseRecord.Review_Comments__c;
                                    ah.Status__c = 'Approved';
                                    ah.Stage__c = 'CsO';
                                    ah.Employee_Name__c = emp.Id;
                                    approvalHistoryList.add(ah);
                                }else{
                                    ar.CSO_Approver_Status__c = 'Rejected';
                                    ar.CSO_Approval_Comments__c = caseRecord.Review_Comments__c;
                                    isChangedAR = true;
                                    ah.AR_Adjustments__c = ar.Id;
                                    ah.Case__c = caseRecord.Id;
                                    ah.Comments__c = caseRecord.Review_Comments__c;
                                    ah.Status__c = 'Rejected';
                                    ah.Stage__c = 'CSO';
                                    ah.Employee_Name__c = emp.Id;
                                    approvalHistoryList.add(ah);
                                }
                            }
                        }  
                    }
                    for(Credit_Memo_ICS__c cm : cmList){  //credit memo CSO delegated approver
                        if(cm.Del_CSO_Approver_Email__c != null && cm.Del_CSO_Approver_Email__c == emailId && (transactionType == 'CreditMemo' || transactionType == 'All')){
                            Approval_History_ICS__c ah = new Approval_History_ICS__c();
                            if(status == 'APPROVE'){
                                cm.CSO_Approver_Status__c = 'Approved';
                                cm.CSO_Approval_Comments__c = caseRecord.Review_Comments__c;
                                isChangedCM = true;
                                ah.Credit_Memo__c = cm.Id;
                                ah.Case__c = caseRecord.Id;
                                ah.Comments__c = caseRecord.Review_Comments__c;
                                ah.Status__c = 'Approved';
                                ah.Stage__c = 'CSO';
                                ah.Employee_Name__c = emp.Id;
                                approvalHistoryList.add(ah);
                            }else{
                                cm.CSO_Approver_Status__c = 'Rejected';
                                cm.CSO_Approval_Comments__c = caseRecord.Review_Comments__c;
                                isChangedCM = true;
                                ah.Credit_Memo__c = cm.Id;
                                ah.Case__c = caseRecord.Id;
                                ah.Comments__c = caseRecord.Review_Comments__c;
                                ah.Status__c = 'Rejected';
                                ah.Stage__c = 'CSO';
                                ah.Employee_Name__c = emp.Id;
                                approvalHistoryList.add(ah);
                            }
                        }
                        else{   //credit memo CSO approver
                            if(cm.CSO_Approver_Email__c != null && cm.CSO_Approver_Email__c == emailId && (transactionType == 'CreditMemo' || transactionType == 'All')){
                                Approval_History_ICS__c ah = new Approval_History_ICS__c();
                                if(status == 'APPROVE'){
                                    cm.CSO_Approver_Status__c = 'Approved';
                                    cm.CSO_Approval_Comments__c = caseRecord.Review_Comments__c;
                                    isChangedCM = true;
                                    ah.Credit_Memo__c = cm.Id;
                                    ah.Case__c = caseRecord.Id;
                                    ah.Comments__c = caseRecord.Review_Comments__c;
                                    ah.Status__c = 'Approved';
                                    ah.Stage__c = 'CSO';
                                    ah.Employee_Name__c = emp.Id;
                                    approvalHistoryList.add(ah);
                                }else{
                                    cm.CSO_Approver_Status__c = 'Rejected';
                                    cm.CSO_Approval_Comments__c = caseRecord.Review_Comments__c;
                                    isChangedCM = true;
                                    ah.Credit_Memo__c = cm.Id;
                                    ah.Case__c = caseRecord.Id;
                                    ah.Comments__c = caseRecord.Review_Comments__c;
                                    ah.Status__c = 'Rejected';
                                    ah.Stage__c = 'CSO';
                                    ah.Employee_Name__c = emp.Id;
                                    approvalHistoryList.add(ah);
                                }
                            }
                        }
                    }
                    for(Refunds_ICS__c r : refundsList){   //Refunds CSO Delegated approver
                        if(r.Del_CSO_Approver_Email__c != null && r.Del_CSO_Approver_Email__c == emailId && (transactionType == 'Refund' || transactionType == 'All')){
                            Approval_History_ICS__c ah = new Approval_History_ICS__c();
                            if(status == 'APPROVE'){
                                r.CSO_Approver_Status__c = 'Approved';
                                r.CSO_Approval_Comments__c = caseRecord.Review_Comments__c;
                                isChangedR = true;
                                ah.Refunds__c = r.Id;
                                ah.Case__c = caseRecord.Id;
                                ah.Comments__c = caseRecord.Review_Comments__c;
                                ah.Status__c = 'Approved';
                                ah.Stage__c = 'CSO';
                                ah.Employee_Name__c = emp.Id;
                                approvalHistoryList.add(ah);
                            }else{
                                r.CSO_Approver_Status__c = 'Rejected';
                                r.CSO_Approval_Comments__c = caseRecord.Review_Comments__c;
                                isChangedR = true;
                                ah.Refunds__c = r.Id;
                                ah.Case__c = caseRecord.Id;
                                ah.Comments__c = caseRecord.Review_Comments__c;
                                ah.Status__c = 'Rejected';
                                ah.Stage__c = 'CSO';
                                ah.Employee_Name__c = emp.Id;
                                approvalHistoryList.add(ah);
                            }
                        }
                        else{  //Refunds CSo Approver
                            if(r.CSO_Approver_EmailID__c != null && r.CSO_Approver_EmailID__c == emailId && (transactionType == 'Refund' || transactionType == 'All')){
                                Approval_History_ICS__c ah = new Approval_History_ICS__c();
                                if(status == 'APPROVE'){
                                    r.CSO_Approver_Status__c = 'Approved';
                                    r.CSO_Approval_Comments__c = caseRecord.Review_Comments__c;
                                    isChangedR = true;
                                    ah.Refunds__c = r.Id;
                                    ah.Case__c = caseRecord.Id;
                                    ah.Comments__c = caseRecord.Review_Comments__c;
                                    ah.Status__c = 'Approved';
                                    ah.Stage__c = 'CSO';
                                    ah.Employee_Name__c = emp.Id;
                                    approvalHistoryList.add(ah);
                                }else{
                                    r.CSO_Approver_Status__c = 'Rejected';
                                    r.CSO_Approval_Comments__c = caseRecord.Review_Comments__c;
                                    isChangedR = true;
                                    ah.Refunds__c = r.Id;
                                    ah.Case__c = caseRecord.Id;
                                    ah.Comments__c = caseRecord.Review_Comments__c;
                                    ah.Status__c = 'Rejected';
                                    ah.Stage__c = 'CSO';
                                    ah.Employee_Name__c = emp.Id;
                                    approvalHistoryList.add(ah);
                                }
                            }
                        }
                    }
                    
                }else if(caseDetails.Case_Approval_Status__c == 'AR2 Submitted' || caseDetails.Case_Approval_Status__c == 'AR2 Rejected'){  //&& ar2RejectCount == 0
                    for(AR_Adjustments__c ar : arList){  // Ar adjustment AR2 Delegated approver
                        if(ar.Del_AR2_Approver_Email__c != null && ar.Del_AR2_Approver_Email__c == emailId && (transactionType == 'ARAdjustment' || transactionType == 'All')){
                            Approval_History_ICS__c ah = new Approval_History_ICS__c();
                            if(status == 'APPROVE'){
                                ar.AR2_Approver_Status__c = 'Approved';
                                ar.AR2_Approval_Comments__c = caseRecord.Review_Comments__c;
                                isChangedAR = true;
                                ah.AR_Adjustments__c = ar.Id;
                                ah.Case__c = caseRecord.Id;
                                ah.Comments__c = caseRecord.Review_Comments__c;
                                ah.Status__c = 'Approved';
                                ah.Stage__c = 'AR2';
                                ah.Employee_Name__c = emp.Id;
                                approvalHistoryList.add(ah);
                            }else{
                                ar.AR2_Approver_Status__c = 'Rejected';
                                ar.AR2_Approval_Comments__c = caseRecord.Review_Comments__c;
                                isChangedAR = true;
                                ah.AR_Adjustments__c = ar.Id;
                                ah.Case__c = caseRecord.Id;
                                ah.Comments__c = caseRecord.Review_Comments__c;
                                ah.Status__c = 'Rejected';
                                ah.Stage__c = 'AR2';
                                ah.Employee_Name__c = emp.Id;
                                approvalHistoryList.add(ah);
                            }
                        }
                        else{   //AR adjustment AR2 approver
                            if(ar.AR2_Approver_Email__c != null && ar.AR2_Approver_Email__c == emailId && (transactionType == 'ARAdjustment' || transactionType == 'All')){
                                Approval_History_ICS__c ah = new Approval_History_ICS__c();
                                if(status == 'APPROVE'){
                                    ar.AR2_Approver_Status__c = 'Approved';
                                    ar.AR2_Approval_Comments__c = caseRecord.Review_Comments__c;
                                    isChangedAR = true;
                                    ah.AR_Adjustments__c = ar.Id;
                                    ah.Case__c = caseRecord.Id;
                                    ah.Comments__c = caseRecord.Review_Comments__c;
                                    ah.Status__c = 'Approved';
                                    ah.Stage__c = 'AR2';
                                    ah.Employee_Name__c = emp.Id;
                                    approvalHistoryList.add(ah);
                                }else{
                                    ar.AR2_Approver_Status__c = 'Rejected';
                                    ar.AR2_Approval_Comments__c = caseRecord.Review_Comments__c;
                                    isChangedAR = true;
                                    ah.AR_Adjustments__c = ar.Id;
                                    ah.Case__c = caseRecord.Id;
                                    ah.Comments__c = caseRecord.Review_Comments__c;
                                    ah.Status__c = 'Rejected';
                                    ah.Stage__c = 'AR2';
                                    ah.Employee_Name__c = emp.Id;
                                    approvalHistoryList.add(ah);
                                }
                            }
                        }   
                    }
                    for(Credit_Memo_ICS__c cm : cmList){    //Credit memo AR2 delegated approver
                        if(cm.Del_AR2_Approver_Email__c != null && cm.Del_AR2_Approver_Email__c == emailId && (transactionType == 'CreditMemo' || transactionType == 'All')){
                            Approval_History_ICS__c ah = new Approval_History_ICS__c();
                            if(status == 'APPROVE'){
                                cm.AR2_Approver_Status__c = 'Approved';
                                cm.AR2_Approver_Comments__c = caseRecord.Review_Comments__c;
                                isChangedCM = true;
                                ah.Credit_Memo__c = cm.Id;
                                ah.Case__c = caseRecord.Id;
                                ah.Comments__c = caseRecord.Review_Comments__c;
                                ah.Status__c = 'Approved';
                                ah.Stage__c = 'AR2';
                                ah.Employee_Name__c = emp.Id;
                                approvalHistoryList.add(ah);
                            }else{
                                cm.AR2_Approver_Status__c = 'Rejected';
                                cm.AR2_Approver_Comments__c = caseRecord.Review_Comments__c;
                                isChangedCM = true;
                                ah.Credit_Memo__c = cm.Id;
                                ah.Case__c = caseRecord.Id;
                                ah.Comments__c = caseRecord.Review_Comments__c;
                                ah.Status__c = 'Rejected';
                                ah.Stage__c = 'AR2';
                                ah.Employee_Name__c = emp.Id;
                                approvalHistoryList.add(ah);
                            }
                        }
                        else{   //credit memo approver
                            if(cm.AR2_Approver_Email_ID__c != null && cm.AR2_Approver_Email_ID__c == emailId && (transactionType == 'CreditMemo' || transactionType == 'All')){
                                Approval_History_ICS__c ah = new Approval_History_ICS__c();
                                if(status == 'APPROVE'){
                                    cm.AR2_Approver_Status__c = 'Approved';
                                    cm.AR2_Approver_Comments__c = caseRecord.Review_Comments__c;
                                    isChangedCM = true;
                                    ah.Credit_Memo__c = cm.Id;
                                    ah.Case__c = caseRecord.Id;
                                    ah.Comments__c = caseRecord.Review_Comments__c;
                                    ah.Status__c = 'Approved';
                                    ah.Stage__c = 'AR2';
                                    ah.Employee_Name__c = emp.Id;
                                    approvalHistoryList.add(ah);
                                }else{
                                    cm.AR2_Approver_Status__c = 'Rejected';
                                    cm.AR2_Approver_Comments__c = caseRecord.Review_Comments__c;
                                    isChangedCM = true;
                                    ah.Credit_Memo__c = cm.Id;
                                    ah.Case__c = caseRecord.Id;
                                    ah.Comments__c = caseRecord.Review_Comments__c;
                                    ah.Status__c = 'Rejected';
                                    ah.Stage__c = 'AR2';
                                    ah.Employee_Name__c = emp.Id;
                                    approvalHistoryList.add(ah);
                                }
                            }
                        }
                    }
                    for(Refunds_ICS__c r : refundsList){
                        if(r.Del_AR2_Approver_Email__c != null && r.Del_AR2_Approver_Email__c == emailId && (transactionType == 'Refund' || transactionType == 'All')){
                            Approval_History_ICS__c ah = new Approval_History_ICS__c();
                            if(status == 'APPROVE'){
                                r.AR2_Approver_Status__c = 'Approved';
                                r.AR2_Approver_Comments__c = caseRecord.Review_Comments__c;
                                isChangedR = true;
                                ah.Refunds__c = r.Id;
                                ah.Case__c = caseRecord.Id;
                                ah.Comments__c = caseRecord.Review_Comments__c;
                                ah.Status__c = 'Approved';
                                ah.Stage__c = 'AR2';
                                ah.Employee_Name__c = emp.Id;
                                approvalHistoryList.add(ah);
                            }else{
                                r.AR2_Approver_Status__c = 'Rejected';
                                r.AR2_Approver_Comments__c = caseRecord.Review_Comments__c;
                                isChangedR = true;
                                ah.Refunds__c = r.Id;
                                ah.Case__c = caseRecord.Id;
                                ah.Comments__c = caseRecord.Review_Comments__c;
                                ah.Status__c = 'Rejected';
                                ah.Stage__c = 'AR2';
                                ah.Employee_Name__c = emp.Id;
                                approvalHistoryList.add(ah);
                            }
                        }
                        else{
                            if(r.AR2_Approver_Email_ID__c != null && r.AR2_Approver_Email_ID__c == emailId && (transactionType == 'Refund' || transactionType == 'All')){
                                Approval_History_ICS__c ah = new Approval_History_ICS__c();
                                if(status == 'APPROVE'){
                                    r.AR2_Approver_Status__c = 'Approved';
                                    r.AR2_Approver_Comments__c = caseRecord.Review_Comments__c;
                                    isChangedR = true;
                                    ah.Refunds__c = r.Id;
                                    ah.Case__c = caseRecord.Id;
                                    ah.Comments__c = caseRecord.Review_Comments__c;
                                    ah.Status__c = 'Approved';
                                    ah.Stage__c = 'AR2';
                                    ah.Employee_Name__c = emp.Id;
                                    approvalHistoryList.add(ah);
                                }else{
                                    r.AR2_Approver_Status__c = 'Rejected';
                                    r.AR2_Approver_Comments__c = caseRecord.Review_Comments__c;
                                    isChangedR = true;
                                    ah.Refunds__c = r.Id;
                                    ah.Case__c = caseRecord.Id;
                                    ah.Comments__c = caseRecord.Review_Comments__c;
                                    ah.Status__c = 'Rejected';
                                    ah.Stage__c = 'AR2';
                                    ah.Employee_Name__c = emp.Id;
                                    approvalHistoryList.add(ah);
                                }
                            }
                        }              
                    }
                }else if(caseDetails.Case_Approval_Status__c == 'Additional Submitted' || caseDetails.Case_Approval_Status__c == 'Additional Rejected'){    //&& addRejectCount == 0
                    for(Credit_Memo_ICS__c cm : cmList){    //credit memo Additional Delegated user
                        if(cm.Del_Additional_Approver_Email__c != null && cm.Del_Additional_Approver_Email__c == emailId && (transactionType == 'CreditMemo' || transactionType == 'All')){
                            Approval_History_ICS__c ah = new Approval_History_ICS__c();
                            if(status == 'APPROVE'){
                                cm.Additional_Approver_Status__c = 'Approved';
                                cm.Additional_Approver_Comments__c = caseRecord.Review_Comments__c;
                                isChangedCM = true;
                                ah.Credit_Memo__c = cm.Id;
                                ah.Case__c = caseRecord.Id;
                                ah.Comments__c = caseRecord.Review_Comments__c;
                                ah.Status__c = 'Approved';
                                ah.Stage__c = 'Additional';
                                ah.Employee_Name__c = emp.Id;
                                approvalHistoryList.add(ah);
                            }else{
                                cm.Additional_Approver_Status__c = 'Rejected';
                                cm.Additional_Approver_Comments__c = caseRecord.Review_Comments__c;
                                isChangedCM = true;
                                ah.Credit_Memo__c = cm.Id;
                                ah.Case__c = caseRecord.Id;
                                ah.Comments__c = caseRecord.Review_Comments__c;
                                ah.Status__c = 'Rejected';
                                ah.Stage__c = 'Additional';
                                ah.Employee_Name__c = emp.Id;
                                approvalHistoryList.add(ah);
                            }
                        }
                        else{   //credit memo additional approver
                            if(cm.Additional_Approver_Email_ID__c != null && cm.Additional_Approver_Email_ID__c == emailId && (transactionType == 'CreditMemo' || transactionType == 'All')){
                                Approval_History_ICS__c ah = new Approval_History_ICS__c();
                                if(status == 'APPROVE'){
                                    cm.Additional_Approver_Status__c = 'Approved';
                                    cm.Additional_Approver_Comments__c = caseRecord.Review_Comments__c;
                                    isChangedCM = true;
                                    ah.Credit_Memo__c = cm.Id;
                                    ah.Case__c = caseRecord.Id;
                                    ah.Comments__c = caseRecord.Review_Comments__c;
                                    ah.Status__c = 'Approved';
                                    ah.Stage__c = 'Additional';
                                    ah.Employee_Name__c = emp.Id;
                                    approvalHistoryList.add(ah);
                                }else{
                                    cm.Additional_Approver_Status__c = 'Rejected';
                                    cm.Additional_Approver_Comments__c = caseRecord.Review_Comments__c;
                                    isChangedCM = true;
                                    ah.Credit_Memo__c = cm.Id;
                                    ah.Case__c = caseRecord.Id;
                                    ah.Comments__c = caseRecord.Review_Comments__c;
                                    ah.Status__c = 'Rejected';
                                    ah.Stage__c = 'Additional';
                                    ah.Employee_Name__c = emp.Id;
                                    approvalHistoryList.add(ah);
                                }
                            }
                        }    
                    }
                    for(Receipt_Reversals__c rr : rrList){ // Receipt reversal Additional delegated approver
                        if(rr.Del_Additional_Approver_Email__c != null && rr.Del_Additional_Approver_Email__c == emailId && (transactionType == 'ReceiptReversals' || transactionType == 'All')){
                            Approval_History_ICS__c ah = new Approval_History_ICS__c();
                            if(status == 'APPROVE'){
                                rr.Approver_Status__c = 'Approved';
                                rr.Approver_Comments__c = caseRecord.Review_Comments__c;
                                isChangedRR = true;
                                ah.Receipt_Reversal__c = rr.Id;
                                ah.Case__c = caseRecord.Id;
                                ah.Comments__c = caseRecord.Review_Comments__c;
                                ah.Status__c = 'Approved';
                                ah.Stage__c = 'Additional'; 
                                ah.Employee_Name__c = emp.Id;
                                approvalHistoryList.add(ah);
                            }else{
                                rr.Approver_Status__c = 'Rejected';
                                rr.Approver_Comments__c = caseRecord.Review_Comments__c;
                                isChangedRR = true;
                                ah.Receipt_Reversal__c = rr.Id;
                                ah.Case__c = caseRecord.Id;
                                ah.Comments__c = caseRecord.Review_Comments__c;
                                ah.Status__c = 'Rejected';
                                ah.Stage__c = 'Additional';
                                ah.Employee_Name__c = emp.Id;
                                approvalHistoryList.add(ah);
                            }
                        }    
                        else {      // Receipt reversal Additional approver
                            if(rr.Approver_Email__c != null && rr.Approver_Email__c == emailId && (transactionType == 'ReceiptReversals' || transactionType == 'All')){
                                Approval_History_ICS__c ah = new Approval_History_ICS__c();
                                if(status == 'APPROVE'){
                                    rr.Approver_Status__c = 'Approved';
                                    rr.Approver_Comments__c = caseRecord.Review_Comments__c;
                                    isChangedRR = true;
                                    ah.Receipt_Reversal__c = rr.Id;
                                    ah.Case__c = caseRecord.Id;
                                    ah.Comments__c = caseRecord.Review_Comments__c;
                                    ah.Status__c = 'Approved';
                                    ah.Stage__c = 'Additional'; 
                                    ah.Employee_Name__c = emp.Id;
                                    approvalHistoryList.add(ah);
                                }else{
                                    rr.Approver_Status__c = 'Rejected';
                                    rr.Approver_Comments__c = caseRecord.Review_Comments__c;
                                    isChangedRR = true;
                                    ah.Receipt_Reversal__c = rr.Id;
                                    ah.Case__c = caseRecord.Id;
                                    ah.Comments__c = caseRecord.Review_Comments__c;
                                    ah.Status__c = 'Rejected';
                                    ah.Stage__c = 'Additional';
                                    ah.Employee_Name__c = emp.Id;
                                    approvalHistoryList.add(ah);
                                }
                            }
                        }
                    }
                }
                caseRecord.Review_Comments__c = '';
                if(isChangedAR)
                    update arList;
                if(isChangedC)
                    update chargesList;
                if(isChangedCM)
                    update cmList;
                if(isChangedRR)
                    update rrList;
                if(isChangedR)
                    update refundsList;
                if(isChangedP)
                    update paymentsList;
                if(approvalHistoryList.size() > 0)
                    insert approvalHistoryList;
                    
                List<Attachment> lstAttach = new List<Attachment>();    
                if(body != null && body != '') {
                  
                  String dat = body.substringAfterLast(',');                    
                    Blob b = EncodingUtil.base64Decode(dat);
                    Attachment attachment = new Attachment();
                    attachment.body = b;
                    attachment.Name = filename;
                    attachment.OwnerId = UserInfo.getUserId();
                    attachment.ParentId = caseDetails.id; // the record the file is attached to
                    lstAttach.add(attachment);
                    //insert attachment;
                    
                    //modified on 13 march to add mu/tiple file upload. 
                    
                   /* ContentVersion ConVer = new ContentVersion();
                    ConVer.versionData = b;
                    ConVer.title = fileName;
                    ConVer.pathOnClient = fileName;
                    //attachment.body = b;
                    //attachment.Name = filename;
                    insert ConVer;
                     ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :ConVer.Id LIMIT 1];
                    ContentDocumentLink contentlink = new ContentDocumentLink();
                    contentlink.LinkedEntityId = casedetails.Id;
                    contentlink.contentdocumentid = contentVersion_2.contentdocumentid;
                    contentlink.ShareType = 'V';
                    insert contentlink; 
                    //return null;*/
            
                }
                if(body1 != null && body1 != '')
                {
                    String dat1 = body1.substringAfterLast(',');                    
                    Blob b1 = EncodingUtil.base64Decode(dat1);
                    attachment = new Attachment();
                    attachment.body = b1;
                    attachment.Name = filename1;
                    attachment.OwnerId = UserInfo.getUserId();
                    attachment.ParentId = caseDetails.id; // the record the file is attached to
                    lstAttach.add(attachment);
                }
                if(body2 != null && body2 != '')
                {
                    String dat2 = body2.substringAfterLast(',');                    
                    Blob b2 = EncodingUtil.base64Decode(dat2);
                    attachment = new Attachment();
                    attachment.body = b2;
                    attachment.Name = filename2;
                    attachment.OwnerId = UserInfo.getUserId();
                    attachment.ParentId = caseDetails.id; // the record the file is attached to
                    lstAttach.add(attachment);
                }
                if(body3 != null && body3 != '')
                {
                    String dat3 = body3.substringAfterLast(',');                    
                    Blob b3 = EncodingUtil.base64Decode(dat3);
                    attachment = new Attachment();
                    attachment.body = b3;
                    attachment.Name = filename3;
                    attachment.OwnerId = UserInfo.getUserId();
                    attachment.ParentId = caseDetails.id; // the record the file is attached to
                    lstAttach.add(attachment);
                }
                if(body4 != null && body4 != '')
                {
                    String dat4 = body4.substringAfterLast(',');                    
                    Blob b4 = EncodingUtil.base64Decode(dat4);
                    attachment = new Attachment();
                    attachment.body = b4;
                    attachment.Name = filename4;
                    attachment.OwnerId = UserInfo.getUserId();
                    attachment.ParentId = caseDetails.id; // the record the file is attached to
                    lstAttach.add(attachment);
                }               
                if(!lstAttach.isEmpty())
                {
                    insert lstAttach;
                }
                
                UpdateCaseICS.caseUpdate(caseDetails, status);
       
            if(caseRecord.Email_Copy_To__c != Null){                
                    Employees__c employee = [select Name,First_Name__c,Last_Name__c,  Email_Address__c from Employees__c where id =: caseRecord.Email_Copy_To__c];
                    //caseRecord.Email_Copy_To__c = caseRecord.Email_Copy_To__c;
                    //EmailTemplate templateId = [Select id from EmailTemplate where name = 'ICS Case Status'];
                    List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    //mail.setSenderDisplayName('noreply@ges.com'); 
                    mail.setSenderDisplayName('National Servicenter <nationalservicenter@ges.com>'); 
                                
                    //Soniya March-8th
                    
                    mail.setSubject('Notification: '+caseDetails.Account_Name__r.Name +'; ' +caseDetails.Opportunity_Name__r.Name +'; ' +caseDetails.Name); 
                   //body = 'Hello ' +caseDetails.Email_Copy_To__r.First_Name__c+' '+caseDetails.Email_Copy_To__r.Last_Name__c+',<br/>'  ;
                   //body = 'Hello ' +caseDetails.Case_Requestor__r.First_Name__c+' '+caseDetails.Case_Requestor__r.Last_Name__c+',<br/>'  ;
                    body = 'Hello ' +Employee.Name+',<br/>'  ;
                    body += '<br/>One or more approvers requested you to be notified of the below transactions. No action required. <br/>';
                    if(caseDetails.Case_Requestor__c != null && caseDetails.Case_Requestor__r.Name != null)
                        body += '<br/>Requestor Name: '+caseDetails.Case_Requestor__r.Name+'<br/>';
                    if(caseDetails.Department__c != null)
                            body += '<br/>Requestor Department: '+caseDetails.Department__c+'<br/>';
                    if(caseDetails.Title__c != null)
                        body += '<br/>Requestor Title: '+caseDetails.Title__c+'<br/>';
                    if(caseDetails.Account_Name__c != null)
                        body += 'Customer Name: '+caseDetails.Account_Name__r.Name+'<br/>';
                    if(caseDetails.Oracle_AR_Customer_Number__c != null) 
                        body += 'Customer Number: '+caseDetails.Oracle_AR_Customer_Number__c+'<br/>';
                    if(caseDetails.Show_Occur__c != null && caseDetails.Show_Occur__r.Name != null)
                        body += 'Show Occurrence Name: '+caseDetails.Show_Occur__r.Name+'<br/>';
                    if(caseDetails.Show_Occur__c != null && caseDetails.Show_Occur__r.Show_Name__c != null && caseDetails.Show_Occur__r.Show_Name__r.Name != null)
                        body += 'Show Name: '+caseDetails.Show_Occur__r.Show_Name__r.Name+'<br/>';
                   if(caseDetails.Opportunity_Name__r.Name != null)
                        body += 'Show Occurrence: '+caseDetails.Opportunity_Name__r.Name+'<br/>';     
                    if(caseDetails.Project__c != null)
                        body += 'Project #: '+caseDetails.Project__c+'<br/>';                    
                    if(caseDetails.Sales_Channel__c != null)
                        body += 'Sales Channel: '+caseDetails.Sales_Channel__c+'<br/>';  
                    if(caseDetails.Booth_Area__c != null)
                       body += 'Booth Area: '+caseDetails.Booth_Area__c+'<br/>'; 
                   
                   
                        if(caseDetails.Case_Approval_Status__c == 'Requestor Submitted' || caseDetails.Case_Approval_Status__c =='Requestor Approved' || caseDetails.Case_Approval_Status__c =='Requestor Rejected'){
                if(cmList.size()>0){ 
                body += '<br/><table border="1">';
                body += '<tr><th colspan="7" align="center">CREDIT MEMO DETAILS</th></tr>';
                body += '<tr><th align="left">Sales Order #</th><th align="left">Line Of Business</th><th align="left">Justification for Credit Memo Request</th><th align="left">Reason</th><th align="right">Amount w/psp</th><th align="right">Tax Amount</th><th align="right">Total Amount</th></tr>';
                Decimal totalAmount = 0;
                
                for(sObject s : cmList){
                    body += '<tr>';
                    body += '<td width="10%">'+s.get('Sales_Order__c')+'</td>'; 
                    body += '<td width="15%">'+s.get('Credit_LOB__c')+'</td>';                   
                    body += '<td width="25%">'+s.get('Justification_for_Credit_Memo_Request__c')+'</td>';
                    body += '<td width="14%">'+s.get('Credit_Memo_Reason__c')+'</td>';
                    body += '<td width="12%" align="right">$ '+currencyFormat((Decimal)s.get('Amount_w_psp__c'))+'</td>';
                    body += '<td width="12%" align="right">$ '+currencyFormat((Decimal)s.get('Tax_Amount__c'))+'</td>';
                    body += '<td width="12%" align="right">$ '+currencyFormat((Decimal)s.get('Total_Amount__c'))+'</td>';
                    body += '</tr>';
                    Id recId = (Id)s.get('Id');
                    Decimal amount = (Decimal)s.get('Total_Amount__c');
                    totalAmount += amount;
                    
                }
                    body += '<b><tr><td colspan="6" align="right">Total Amount</td><td align="right">$ '+ (+currencyFormat(totalAmount)) +'</td></tr></b>';                   
                    body += '</table ></br>';
            }
            if(arList.size()>0){
                body += '<br/><table border="1">';
                body += '<tr><th colspan="5" align="center">AR ADJUSTMENT DETAILS</th></tr>';
                body += '<tr><th align="left">Sales Order #</th><th align="left">Billing Id</th><th align="left">Justification for AR Adjustment Request</th><th align="right">Total Amount</th></tr>';
               Decimal totalAmount = 0;
                for(sObject s : arList){
                    body += '<tr>';
                    body += '<td width="20%">'+s.get('Sales_Order__c')+'</td>';
                    body +='<td width="20%">'+s.get('Billing_ID__c')+'</td>';
                    body +='<td width="40%">'+s.get('Justification_for_AR_Adjustment_Request__c')+'</td>';
                    body +='<td width="20%" align="right">$ '+currencyFormat((Decimal)s.get('Amount__c'))+'</td>';
                    body += '</tr>';
                    Id recId = (Id)s.get('Id');
                    Decimal amount = (Decimal)s.get('Amount__c');
                    totalAmount += amount;
  
                }
                    body += '<b><tr><td colspan="3" align="right">Total Amount</td><td align="right">$ '+ (+currencyFormat(totalAmount)) +'</td></tr></b>';
                    body += '</table ></br>';
            }
           if(refundsList.size()>0){
                body += '<br/><table border="1">';
                body += '<tr><th colspan="5" align="center">REFUND DETAILS</th></tr>';
                body += '<tr><th align="left">Payment Type</th><th align="left">Justification for Refunds Request</th><th align="left">Sales Receipt #</th><th align="left">Sales Order #</th><th align="right">Total Amount</th></tr>';
                Decimal totalAmount = 0;
                for(sObject s : refundsList){
                    body += '<tr>';
                    body += '<td width="15%">'+s.get('Pymt_Type__c')+'</td>';
                    body += '<td width="40%">'+s.get('Justification_for_Refunds_Request__c')+'</td>';                   
                    body += '<td width="15%">'+s.get('Sales_Receipt__c')+'</td>';
                    body += '<td width="15%">'+s.get('Sales_Order__c')+'</td>';
                    body += '<td width="15%" align="right">$ '+currencyFormat((Decimal)s.get('Amount__c'))+'</td>';
                    body += '</tr>';
                    Id recId = (Id)s.get('Id');
                    Decimal amount = (Decimal)s.get('Amount__c');
                    totalAmount += amount;

                }
                    body += '<b><tr><td colspan="4" align="right">Total Amount</td><td align="right">$ '+ (+currencyFormat(totalAmount)) +'</td></tr></b>';
                    body += '</table ></br>';
            }
            if(rrList.size()>0){
                body += '<br/><table border="1">';
                body += '<tr><th colspan="6" align="center">RECEIPT REVERSAL DETAILS</th></tr>';
                body += '<tr><th align="left">Payment Type</th><th align="left">Justification for Receipt Rvsl Request</th><th align="left">Receipt #</th><th align="left">Sales Order #</th><th align="left">Reason</th><th align="right">Total Amount</th></tr>';
                Decimal totalAmount = 0;
                    for(sObject s : rrList){
                    body += '<tr>';
                    body += '<td width="13%">'+s.get('Payment_Method__c')+'</td>';                  
                    body += '<td width="35%">'+s.get('Justification_for_Receipt_Rvsl_Request__c')+'</td>';                   
                    body += '<td width="13%">'+s.get('Receipt_Number__c')+'</td>';
                    body += '<td width="13%">'+s.get('Sales_Order__c')+'</td>';
                    body += '<td width="13%">'+s.get('Reason__c')+'</td>';
                    body += '<td width="13%" align="right">$ '+currencyFormat((Decimal)s.get('Receipt_Reversal_Amount__c'))+'</td>';
                    body += '</tr>';
                    Id recId = (Id)s.get('Id');
                    Decimal amount = (Decimal)s.get('Receipt_Reversal_Amount__c');
                    totalAmount += amount;
                }
                    body += '<b><tr><td colspan="5" align="right">Total Amount</td><td align="right">$ '+ (+currencyFormat(totalAmount)) +'</td></tr></b>';
                    body += '</table ></br>';
            }
            if(paymentsList.size()>0){
                body += '<br/><table border="1">';
                body += '<tr><th colspan="5" align="center">PAYMENTS DETAILS</th></tr>';
                body += '<tr><th align="left">Receipt #</th><th align="left">Justification for Pymt Transfer Request</th><th align="left">From Sales Order #</th><th align="left">To Sales Order #</th><th align="right">Total Amount</th></tr>';
                Decimal totalAmount = 0;
                    for(sObject s : paymentsList){
                    body += '<tr>';
                    body += '<td width="15%">'+s.get('Receipt__c')+'</td>';
                    body += '<td width="40%">'+s.get('Justification_for_Pymt_Transfer_Request__c')+'</td>';
                    body += '<td width="15%">'+s.get('Sales_Order__c')+'</td>';
                    body += '<td width="15%">'+s.get('Sales_Order__c')+'</td>';
                    body += '<td width="15%" align="right">$ '+currencyFormat((Decimal)s.get('Transfer_Amount__c'))+'</td>';
                    body += '</tr>';
                    Id recId = (Id)s.get('Id');
                    Decimal amount = (Decimal)s.get('Transfer_Amount__c');
                    totalAmount += amount;
                }
                    body += '<b><tr><td colspan="4" align="right">Total Amount</td><td align="right">$ '+ (+currencyFormat(totalAmount)) +'</td></tr></b>';
                    body += '</table ></br>';
            }
           if(chargesList.size()>0){
                body += '<br/><table border="1">';
                body += '<tr><th colspan="5" align="center">CHARGES DETAILS</th></tr>';
                body += '<tr><th align="left">Payment Type</th><th align="left">Justification for Charges Request</th><th align="left">Sales Receipt #</th><th align="left">Sales Order #</th><th align="right">Total Amount</th></tr>';
                Decimal totalAmount = 0;
                for(sObject s : chargesList){
                    body += '<tr>';
                    body += '<td width="15%">'+s.get('Pymt_Type__c')+'</td>';                   
                    body += '<td width="35%">'+s.get('Justification_for_Charges_Request__c')+'</td>';
                    body += '<td width="15%">'+s.get('Sales_Receipt__c')+'</td>';
                    body += '<td width="15%">'+s.get('Sales_Order__c')+'</td>';
                    body += '<td width="20%" align="right">$ '+currencyFormat((Decimal)s.get('Total_Amount__c'))+'</td>';
                    body += '</tr>';
                    Id recId = (Id)s.get('Id');
                    Decimal amount = (Decimal)s.get('Total_Amount__c');
                    totalAmount += amount;
                }
                    body += '<b><tr><td colspan="4" align="right">Total Amount</td><td align="right">$ '+ (+currencyFormat(totalAmount)) +'</td></tr></b>';
                    body += '</table ></br>';  
                   
            }
        }   
                   
                   
        else{   
                    
                    if(cmList.size()>0){
                        String cmBody='';
                        cmBody += '<br/><table border="1">';
                        cmBody += '<tr><th colspan="7" align="center">CREDIT MEMO DETAILS</th></tr>';
                        cmBody += '<tr><th align="left">Sales Order #</th><th align="left">Line Of Business</th><th align="left">Justification for Credit Memo Request</th><th align="left">Reason</th><th align="right">Amount w/psp</th><th align="right">Tax Amount</th><th align="right">Total Amount</th></tr>';
                        Decimal totalAmount = 0;
                        String localStatus=System.Label.ICS_Status;
                        Integer checkAvailabilty = 0;
                        
                            for(sObject s : cmList){
                            if((localStatus.Contains((String.ValueOf(s.get('LOB__c')))) && (String.ValueOf(s.get('LOB_Approver_Email_ID__c')))!=null && emailId.equalsIgnoreCase(String.ValueOf(s.get('LOB_Approver_Email_ID__c'))) ) || 
                            (localStatus.Contains((String.ValueOf(s.get('F_R_Approver_Status__c')))) && (String.ValueOf(s.get('F_R_Approver_Email_ID__c')))!=null && emailId.equalsIgnoreCase(String.ValueOf(s.get('F_R_Approver_Email_ID__c'))) ) ||
                             (localStatus.Contains((String.ValueOf(s.get('AR1_Approver_Status__c')))) && (String.ValueOf(s.get('AR1_Approver_Email_ID__c')))!=null && emailId.equalsIgnoreCase(String.ValueOf(s.get('AR1_Approver_Email_ID__c'))) ) || 
                             ( localStatus.Contains((String.ValueOf(s.get('CSO_Approver_Status__c')))) && (String.ValueOf(s.get('CSO_Approver_Email__c')))!=null && emailId.equalsIgnoreCase(String.ValueOf(s.get('CSO_Approver_Email__c'))) ) || 
                             (localStatus.Contains((String.ValueOf(s.get('AR2_Approver_Status__c')))) && (String.ValueOf(s.get('AR2_Approver_Email_ID__c')))!=null && emailId.equalsIgnoreCase(String.ValueOf(s.get('AR2_Approver_Email_ID__c')))) ||
                              (localStatus.Contains((String.ValueOf(s.get('Additional_Approver_Status__c')))) && (String.ValueOf(s.get('Additional_Approver_Email_ID__c')))!=null && emailId.equalsIgnoreCase(String.ValueOf(s.get('Additional_Approver_Email_ID__c')))))
                                {
                                    cmBody += '<tr>';
                                    cmBody += '<td width="10%">'+s.get('Sales_Order__c')+'</td>'; 
                                    cmBody += '<td width="15%">'+s.get('Credit_LOB__c')+'</td>';                   
                                    cmBody += '<td width="25%">'+s.get('Justification_for_Credit_Memo_Request__c')+'</td>';
                                    cmBody += '<td width="14%">'+s.get('Credit_Memo_Reason__c')+'</td>';
                                    cmBody += '<td width="12%" align="right">$ '+currencyFormat((Decimal)s.get('Amount_w_psp__c'))+'</td>';
                                    cmBody += '<td width="12%" align="right">$ '+currencyFormat((Decimal)s.get('Tax_Amount__c'))+'</td>';
                                    cmBody += '<td width="12%" align="right">$ '+currencyFormat((Decimal)s.get('Total_Amount__c'))+'</td>';
                                    cmBody += '</tr>';
                                    Id recId = (Id)s.get('Id');
                                    Decimal amount = (Decimal)s.get('Total_Amount__c');
                                    totalAmount += amount;  
                                    checkAvailabilty+=1;
                                }
                            
                        }
                        
                            cmBody += '<b><tr><td colspan="6" align="right">Total Amount</td><td align="right">$ '+(+currencyFormat(totalAmount))+'</td></tr></b>';   
                            cmBody += '</table ></br>';
                            if(checkAvailabilty>=1){
                                body+= cmBody;
                            }
                      
                    }   
                
                if(arList.size()>0){
                    String arBody='';
                    arBody += '<br/><table border="1">';
                    arBody += '<tr><th colspan="5" align="center">AR ADJUSTMENT DETAILS</th></tr>';
                    arBody += '<tr><th align="left">Sales Order #</th><th align="left">Billing Id</th><th align="left">Justification for AR Adjustment Request</th><th align="right">Total Amount</th></tr>';
                    Decimal totalAmount = 0;
                    String localStatus=System.Label.ICS_Status;
                    Integer checkAvailabilty = 0;
                    
                    for(sObject s : arList ){
                        
                        if((localStatus.Contains((String.ValueOf(s.get('DAM_Approver_Status__c')))) && (String.ValueOf(s.get('DAM_Approver_Email_ID__c')))!=null && emailId.equalsIgnoreCase(String.ValueOf(s.get('DAM_Approver_Email_ID__c'))) ) || 
                            (localStatus.Contains((String.ValueOf(s.get('F_R_Approvers_Status__c')))) && (String.ValueOf(s.get('F_A_Approver_Email__c')))!=null && emailId.equalsIgnoreCase(String.ValueOf(s.get('F_A_Approver_Email__c'))) ) ||
                             (localStatus.Contains((String.ValueOf(s.get('AR1_Approver_Status__c')))) && (String.ValueOf(s.get('AR1_Approver_Email__c')))!=null && emailId.equalsIgnoreCase(String.ValueOf(s.get('AR1_Approver_Email__c'))) ) || 
                             ( localStatus.Contains((String.ValueOf(s.get('CSO_Approver_Status__c')))) && (String.ValueOf(s.get('CSO_Approver_EmailID__c')))!=null && emailId.equalsIgnoreCase(String.ValueOf(s.get('CSO_Approver_EmailID__c'))) ) || 
                             (localStatus.Contains((String.ValueOf(s.get('AR2_Approver_Status__c')))) && (String.ValueOf(s.get('AR2_Approver_Email__c'))!=null && emailId.equalsIgnoreCase(String.ValueOf(s.get('AR2_Approver_Email__c'))) )))
                        {
                            arBody += '<tr>';
                            arBody +='<td width="20%">'+s.get('Sales_Order__c')+'</td>';
                            arBody +='<td width="20%">'+s.get('Billing_ID__c')+'</td>';
                            arBody +='<td width="40%">'+s.get('Justification_for_AR_Adjustment_Request__c')+'</td>';
                            arBody +='<td width="20%" align="right">$ '+currencyFormat((Decimal)s.get('Amount__c'))+'</td>';
                            arBody += '</tr>';
                            Id recId = (Id)s.get('Id');
                            Decimal amount = (Decimal)s.get('Amount__c');
                            totalAmount += amount;
                            checkAvailabilty+=1;
                        }

                    }
                    arBody += '<b><tr><td colspan="3" align="right">Total Amount</td><td align="right">$ '+(+currencyFormat(totalAmount))+'</td></tr></b>';   
                    arBody += '</table ></br>';
                        if(checkAvailabilty>=1){
                            body+= arBody;
                        }
                    
                }
                
                if(refundsList.size()>0){
                    String rfBody='';
                    rfBody += '<br/><table border="1">';
                    rfBody += '<tr><th colspan="5" align="center">REFUND DETAILS</th></tr>';
                    rfBody += '<tr><th align="left">Payment Type</th><th align="left">Justification for Refunds Request</th><th align="left">Sales Receipt #</th><th align="left">Sales Order #</th><th align="right">Total Amount</th></tr>';
                    Decimal totalAmount = 0;
                    String localStatus=System.Label.ICS_Status;
                    Integer checkAvailabilty = 0;
                    
                    for(sObject s : refundsList){
                        if((localStatus.Contains((String.ValueOf(s.get('AR1_Approver_Status__c')))) && (String.ValueOf(s.get('AR1_Approver_Email_ID__c')))!=null && emailId.equalsIgnoreCase(String.ValueOf(s.get('AR1_Approver_Email_ID__c'))) ) || 
                        ( localStatus.Contains((String.ValueOf(s.get('CSO_Approver_Status__c')))) && (String.ValueOf(s.get('CSO_Approver_EmailID__c')))!=null && emailId.equalsIgnoreCase(String.ValueOf(s.get('CSO_Approver_EmailID__c'))) ) || 
                        (localStatus.Contains((String.ValueOf(s.get('AR2_Approver_Status__c')))) && (String.ValueOf(s.get('AR2_Approver_Email_ID__c')))!=null && emailId.equalsIgnoreCase(String.ValueOf(s.get('AR2_Approver_Email_ID__c')))))
                        {
                            rfBody += '<tr>';
                            rfBody += '<td width="15%">'+s.get('Pymt_Type__c')+'</td>';
                            rfBody += '<td width="40%">'+s.get('Justification_for_Refunds_Request__c')+'</td>';                   
                            rfBody += '<td width="15%">'+s.get('Sales_Receipt__c')+'</td>';
                            rfBody += '<td width="15%">'+s.get('Sales_Order__c')+'</td>';
                            rfBody += '<td width="15%" align="right">$ '+currencyFormat((Decimal)s.get('Amount__c'))+'</td>';
                            rfBody += '</tr>';
                            Id recId = (Id)s.get('Id');
                            Decimal amount = (Decimal)s.get('Amount__c');
                            totalAmount += amount;
                            checkAvailabilty+=1;
                        }
                    }
                    rfBody += '<b><tr><td colspan="4" align="right">Total Amount</td><td align="right">$ '+(+currencyFormat(totalAmount))+'</td></tr></b>';   
                    rfBody += '</table ></br>';
                    if(checkAvailabilty>=1){
                        body+= rfBody;
                    }
                }
                    
                if(rrList.size()>0){
                    String rrBody='';
                    rrBody += '<br/><table border="1">';
                    rrBody += '<tr><th colspan="6" align="center">RECEIPT REVERSAL DETAILS</th></tr>';
                    rrBody += '<tr><th align="left">Payment Type</th><th align="left">Justification for Receipt Rvsl Request</th><th align="left">Receipt #</th><th align="left">Sales Order #</th><th align="left">Reason</th><th align="right">Total Amount</th></tr>';                                            
                    Decimal totalAmount = 0;
                    String localStatus=System.Label.ICS_Status;
                    Integer checkAvailabilty = 0;
                    
                    for(sObject s : rrList){
                        if((localStatus.Contains((String.ValueOf(s.get('Approver_Status__c')))) && (String.ValueOf(s.get('Approver_Email__c')))!=null && emailId.equalsIgnoreCase(String.ValueOf(s.get('Approver_Email__c')))))
                        {
                            rrBody += '<tr>';
                            rrBody += '<td width="13%">'+s.get('Payment_Method__c')+'</td>';                  
                            rrBody += '<td width="35%">'+s.get('Justification_for_Receipt_Rvsl_Request__c')+'</td>';                   
                            rrBody += '<td width="13%">'+s.get('Receipt_Number__c')+'</td>';
                            rrBody += '<td width="13%">'+s.get('Sales_Order__c')+'</td>';
                            rrBody += '<td width="13%">'+s.get('Reason__c')+'</td>';
                            rrBody += '<td width="13%" align="right">$ '+currencyFormat((Decimal)s.get('Receipt_Reversal_Amount__c'))+'</td>';
                            rrBody += '</tr>';
                            Id recId = (Id)s.get('Id');
                            Decimal amount = (Decimal)s.get('Receipt_Reversal_Amount__c');
                            totalAmount += amount;
                            checkAvailabilty+=1;
                        }
                    }
                    rrBody += '<b><tr><td colspan="5" align="right">Total Amount</td><td align="right">$ '+(+currencyFormat(totalAmount))+'</td></tr></b>';   
                    rrBody += '</table ></br>';
                     if(checkAvailabilty>=1){
                        body+= rrBody;
                    }
                    
                }  
    
            }   

                    body += '<br/>THIS IS AN AUTO GENERATED MAIL. THANK YOU.</br>';
                    
                    mail.setHTMLBody(body);
                    mail.setSaveAsActivity(false);
                    mail.setToAddresses(new List<String> {employee.Email_Address__c});
                    allmsg.add(mail);
                    Messaging.sendEmail(allmsg,true);
                }
            /*}catch(System.DMLException e){
                system.debug('e==='+e);
                ApexPages.addMessages(e);
                return null;
            }*/
            pageReference thankYou = new pageReference('/apex/ThankYouPage');
            thankYou.setRedirect(true);
            return thankYou;
        }
        
        public static string arAdjustmentQuery() {
            String query = 'SELECT Id, AR_Adj_CSI_ID__c,Sales_Order__c,Total_AR_Currency__c, Billing_ID__c,Justification_for_AR_Adjustment_Request__c,Amount__c, Del_DAM_LOB_Approver_Email__c, Del_F_R_Approver_Email__c, Del_AR1_Approver_Email__c, Del_CSO_Approver_Email__c, Del_AR2_Approver_Email__c,';
            query += ' DAM_Approver_Email_ID__c, DAM_Approver_Status__c, DAM_Approver_Comments__c,';
            query += ' F_A_Approver_Email__c, F_R_Approvers_Status__c, F_R_Approval_Comments__c,';
            query += ' AR1_Approver_Email__c, AR1_Approver_Status__c, AR1_Approval_Comments__c,';
            query += ' CSO_Approver_Email__c, CSO_Approver_Status__c, CSO_Approval_Comments__c,CSO_Approver_EmailID__c,';
            query += ' AR2_Approver_Email__c, AR2_Approver_Status__c, AR2_Approval_Comments__c,';
            query += ' Del_DAM_LOB_Approver__c, Del_F_R_Approver__c,Del_CSO_Approver__c, Del_AR2_Approver__c, Del_AR1_Approver__c FROM AR_Adjustments__c';
            return query;
        }
        
        public static string creditMemoQuery() {
            String query = 'SELECT Id, CSI_ICS__c,Sales_Order__c, Credit_LOB__c,Amount_w_psp__c,Tax_Amount__c,Total_Amount__c, Justification_for_Credit_Memo_Request__c, Credit_Memo_Reason__c, Total_CM_Curreny__c, Del_LOB_Approver_Email__c, Del_F_R_Approver_Email__c, Del_AR1_Approver_Email__c,Del_CSO_Approver_Email__c, Del_AR2_Approver_Email__c, Del_Additional_Approver_Email__c, ';
            query += ' LOB_Approver_Email_ID__c, LOB__c, LOB_Approver_Comments__c, F_R_Approver_Email_ID__c, F_R_Approver_Status__c, F_R_Approver_Comments__c,';
            query += ' AR1_Approver_Email_ID__c, AR1_Approver_Status__c, AR1_Approver_Comments__c, AR2_Approver_Email_ID__c, AR2_Approver_Status__c, AR2_Approver_Comments__c,';
            query += ' CSO_Approver_Email__c, CSO_Approver_Status__c, CSO_Approval_Comments__c,';
            query += ' Additional_Approver_Email_ID__c, Additional_Approver_Status__c, Del_AR1_Approver__c, Del_CSO_Approver__c, Del_AR2_Approver__c, Del_F_R_Approver__c, Del_LOB_Approver__c, Del_Additional_Approver__c';
            query += ' FROM Credit_Memo_ICS__c';
            return query;
        }
        
        public static string receiptReversalQuery() {
            String query = 'SELECT Id, CSI_ICS__c,Payment_Method__c, Justification_for_Receipt_Rvsl_Request__c, Total_Receipt_Reversal_Currency__c,Receipt_Number__c, Sales_Order__c, Reason__c, Receipt_Reversal_Amount__c, Del_Additional_Approver_Email__c, ' ;
            query += ' Approver_Email__c, Approver_Status__c, Approver_Comments__c, Del_Additional_Approver__c FROM Receipt_Reversals__c';
            return query;
        }
        
        public static string refundQuery() {
            String query = 'SELECT Id, CSI_ICS__c,Pymt_Type__c,Total_Refunds_Currency__c, Justification_for_Refunds_Request__c,Sales_Receipt__c,Sales_Order__c, Amount__c, Del_AR1_Approver_Email__c, Del_AR2_Approver_Email__c, Del_CSO_Approver_Email__c, ';
            //query += ' LOB_Approver_Email_ID__c, LOB_Approver_Status__c, LOB_Approver_Comments__c,F_R_Approver_Email_ID__c, F_R_Approver_Status__c, F_R_Approver_Comments__c,';
            query += ' AR1_Approver_Email_ID__c, AR1_Approver_Status__c, AR1_Approver_Comments__c, AR2_Approver_Email_ID__c, AR2_Approver_Status__c, AR2_Approver_Comments__c,';
            query += ' CSO_Approver_EmailID__c, CSO_Approver_Status__c, CSO_Approval_Comments__c,';
            query += '  Del_AR1_Approver__c,Del_CSO_Approver__c, Del_AR2_Approver__c FROM Refunds_ICS__c';
            return query;
        }
                public static string currencyFormat(Decimal amount) {
                String y = String.valueOf(amount);
                String z = '.';
                List<String> args = new String[]{'0','number','###,###,##0.##'};
                String s = String.format(amount.format(), args);
                if(!s.contains(z)) {
                    s = s + z + '00';   
                }
                return s;
            }
                public static string currencyFormatTotal(Decimal totalAmount) {
                    if(totalAmount != null) {
                        String y = String.valueOf(totalAmount);
                        String z = '.';
                        List<String> args = new String[]{'0','number','###,###,##0.##'};
                        String d = String.format(totalAmount.format(), args);
                        if(!d.contains(z)) {
                            d = d + z + '00';   
                        }
                        return d;
                    }
                    return '0.00';
            } 
            
        /*    public List<ContentVersion> listFiles {get; set;}
            public ContentVersion fileToUpload { get; set; }
            public void retrieveFiles() {
                fileToUpload = new ContentVersion();
                //listFiles = new List<ContentVersion>();
                //listFiles = getContentVersions((Id)caseDetails);
            }
            public PageReference doUpload() 
            {
                try{
                
                    insert fileToUpload;
                    ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :fileToUpload.Id LIMIT 1];
                    
                    ContentDocumentLink contentlink = new ContentDocumentLink();
                    contentlink.LinkedEntityId = caseRecord.Id;
                    contentlink.contentdocumentid = contentVersion_2.contentdocumentid;
                    contentlink.ShareType = 'V';
                    insert contentlink; 
                }catch(exception e){
                    GC_PageUtil.AddErrorMessage(e.getStackTraceString());
                }
                return null;
            } */
        
        
    }