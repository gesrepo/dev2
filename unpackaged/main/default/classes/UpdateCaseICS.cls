public class UpdateCaseICS {
    
    public static void caseUpdate(Customer_Service_Inquiries_ICS__c caseRecord, String status){
        List<AR_Adjustments__c> arList = [SELECT Id, AR_Adj_CSI_ID__c,
                                          DAM_Approver_Email_ID__c, DAM_Approver_Status__c, DAM_Approver_Comments__c,
                                          F_A_Approver_Email__c, F_R_Approvers_Status__c, F_R_Approval_Comments__c,
                                          AR1_Approver_Email__c, AR1_Approver_Status__c, AR1_Approval_Comments__c,
                                          CSO_Approver_Email__c, CSO_Approver_Status__c, CSO_Approval_Comments__c,
                                          AR2_Approver_Email__c, AR2_Approver_Status__c, AR2_Approval_Comments__c,
                                          Del_DAM_LOB_Approver_Email__c, Del_F_R_Approver_Email__c, Del_AR1_Approver_Email__c,
                                          Del_CSO_Approver_Email__c, Del_AR2_Approver_Email__c
                                          FROM AR_Adjustments__c
                                          WHERE AR_Adj_CSI_ID__c =: caseRecord.Id
                                         ];
        List<Charges__c> chargesList = [SELECT Id, CSI_ICS__c                                  
                                        FROM Charges__c
                                        WHERE CSI_ICS__c =: caseRecord.Id
                                       ];
        List<Credit_Memo_ICS__c> cmList = [SELECT Id, CSI_ICS__c,
                                           LOB_Approver_Email_ID__c, LOB__c, LOB_Approver_Comments__c,
                                           F_R_Approver_Email_ID__c, F_R_Approver_Status__c, F_R_Approver_Comments__c,
                                           AR1_Approver_Email_ID__c, AR1_Approver_Status__c, AR1_Approver_Comments__c,
                                           CSO_Approver_Email__c, CSO_Approver_Status__c, CSO_Approval_Comments__c,
                                           AR2_Approver_Email_ID__c, AR2_Approver_Status__c, AR2_Approver_Comments__c,
                                           Additional_Approver_Status__c, Additional_Approver_Email_ID__c,
                                           Del_LOB_Approver_Email__c, Del_F_R_Approver_Email__c, Del_AR1_Approver_Email__c,
                                          Del_CSO_Approver_Email__c, Del_AR2_Approver_Email__c, Del_Additional_Approver_Email__c
                                           FROM Credit_Memo_ICS__c
                                           WHERE CSI_ICS__c =: caseRecord.Id
                                          ];
        List<Receipt_Reversals__c> rrList = [SELECT Id, CSI_ICS__c,
                                             Approver_Email__c, Approver_Status__c, Approver_Comments__c,
                                             Del_Additional_Approver_Email__c
                                             FROM Receipt_Reversals__c
                                             WHERE CSI_ICS__c =: caseRecord.Id
                                            ];
        List<Refunds_ICS__c> refundsList = [SELECT Id, CSI_ICS__c,                                        
                                            AR1_Approver_Email_ID__c, AR1_Approver_Status__c, AR1_Approver_Comments__c,
                                            CSO_Approver_EmailID__c, CSO_Approver_Status__c, CSO_Approval_Comments__c,
                                            AR2_Approver_Email_ID__c, AR2_Approver_Status__c, AR2_Approver_Comments__c,
                                            Del_AR1_Approver_Email__c, Del_AR2_Approver_Email__c, Del_CSO_Approver_Email__c
                                            FROM Refunds_ICS__c
                                            WHERE CSI_ICS__c =: caseRecord.Id
                                           ];
        List<Payment_Transfer_ICS__c> paymentsList = [SELECT Id, CSI_ICS_No__c                                                                                                     
                                                      FROM Payment_Transfer_ICS__c
                                                      WHERE CSI_ICS_No__c =: caseRecord.Id
                                                     ];
        List<Customer_Service_Inquiries_ICS__c> CaseDetails = [SELECT Id, Requestor_Apporval_Required__c,Owner.Email,
                                                               Case_Requestor_Approval_Status__c, Case_Requestor_Comment__c,                                            
                                                               Case_Requestor_Email_ID__c from Customer_Service_Inquiries_ICS__c
                                                                 ];           
        Integer requestorApproveCount = 0;
        Integer lobApproveCount = 0;
        Integer frApproveCount = 0;
        Integer ar1ApproveCount = 0;
        Integer CSOApproveCount = 0;
        Integer ar2ApproveCount = 0;
        Integer addApproveCount = 0;
        Integer requestorTotalCount = 0;
        Integer lobTotalCount = 0;
        Integer frTotalCount = 0;
        Integer ar1TotalCount = 0;
        Integer CSOTotalCount = 0;
        Integer ar2TotalCount = 0;
        Integer addTotalCount = 0;
        Boolean isChanged = false;
        
        for(Customer_Service_Inquiries_ICS__c cd : CaseDetails){
            if(cd.Case_Requestor_Email_ID__c!= null)
                requestorApproveCount++;
                if(cd.Case_Requestor_Email_ID__c != null && cd.Case_Requestor_Approval_Status__c == 'Approved')
                requestorApproveCount++;
        }
        for(AR_Adjustments__c ar : arList){
            if(ar.DAM_Approver_Email_ID__c != null)
                lobTotalCount++;
            if(ar.DAM_Approver_Email_ID__c != null && ar.DAM_Approver_Status__c == 'Approved')
                lobApproveCount++;           
            if(ar.F_A_Approver_Email__c != null)
                frTotalCount++;
            if(ar.F_A_Approver_Email__c != null && ar.F_R_Approvers_Status__c == 'Approved')
                frApproveCount++;
            if(ar.AR1_Approver_Email__c != null)
                ar1TotalCount++;
            if(ar.AR1_Approver_Email__c != null && ar.AR1_Approver_Status__c == 'Approved')
                ar1ApproveCount++;
            if(ar.CSO_Approver_Email__c != null)
                CSOTotalCount++;
            if(ar.CSO_Approver_Email__c != null && ar.CSO_Approver_Status__c == 'Approved')
                CSOApproveCount++;           
            if(ar.AR2_Approver_Email__c != null)
                ar2TotalCount++;
            if(ar.AR2_Approver_Email__c != null && ar.AR2_Approver_Status__c == 'Approved')
                ar2ApproveCount++;
        }
        for(Credit_Memo_ICS__c cm : cmList){ 
            if(cm.LOB_Approver_Email_ID__c != null)
                lobTotalCount++;
            if(cm.LOB_Approver_Email_ID__c != null && cm.LOB__c == 'Approved')
                lobApproveCount++;
            if(cm.F_R_Approver_Email_ID__c != null)
                frTotalCount++;
            if(cm.F_R_Approver_Email_ID__c != null && cm.F_R_Approver_Status__c == 'Approved')
                frApproveCount++;
            if(cm.AR1_Approver_Email_ID__c != null)
                ar1TotalCount++;
            if(cm.AR1_Approver_Email_ID__c != null && cm.AR1_Approver_Status__c == 'Approved')
                ar1ApproveCount++;
            if(cm.CSO_Approver_Email__c != null)
                CSOTotalCount++;
            if(cm.CSO_Approver_Email__c != null && cm.CSO_Approver_Status__c == 'Approved')
                CSOApproveCount++;              
            if(cm.AR2_Approver_Email_ID__c != null)
                ar2TotalCount++;
            if(cm.AR2_Approver_Email_ID__c != null && cm.AR2_Approver_Status__c == 'Approved')
                ar2ApproveCount++;
            if(cm.Additional_Approver_Email_ID__c != null)
                addTotalCount++;
            if(cm.Additional_Approver_Email_ID__c != null && cm.Additional_Approver_Status__c == 'Approved')
                addApproveCount++;
        }
        for(Receipt_Reversals__c rr : rrList){
            if(rr.Approver_Email__c!= null)
                addTotalCount++;
            if(rr.Approver_Email__c!= null && rr.Approver_Status__c == 'Approved')
                addApproveCount++;
        }
        for(Refunds_ICS__c r : refundsList){
            if(r.AR1_Approver_Email_ID__c != null)
                ar1TotalCount++;
            if(r.AR1_Approver_Email_ID__c != null && r.AR1_Approver_Status__c == 'Approved')
                ar1ApproveCount++;
            if(r.CSO_Approver_EmailID__c != null)
                CSOTotalCount++;
            if(r.CSO_Approver_EmailID__c != null && r.CSO_Approver_Status__c == 'Approved')
                CSOApproveCount++;                   
            if(r.AR2_Approver_Email_ID__c != null)
                ar2TotalCount++;
            if(r.AR2_Approver_Email_ID__c != null && r.AR2_Approver_Status__c == 'Approved')
                ar2ApproveCount++;
        }
        
        //system.debug('ar1ApproveCount'+ar1ApproveCount);
        //system.debug('ar1TotalCount'+ar1TotalCount);
        if(status == 'APPROVE') {
            if(caseRecord.Case_Approval_Status__c == 'Requestor Submitted'){
                caseRecord.Case_Approval_Status__c = 'Requestor Approved';
                caseRecord.Case_Requestor_Approval_Status__c = 'Approved';
                isChanged = true;
            }else if(caseRecord.Case_Approval_Status__c == 'LOB Submitted' && lobApproveCount == lobTotalCount){
                caseRecord.Case_Approval_Status__c = 'LOB Approved';
                isChanged = true;
            }else if(caseRecord.Case_Approval_Status__c == 'F&R Submitted' && frApproveCount == frTotalCount){
                caseRecord.Case_Approval_Status__c = 'F&R Approved';
                isChanged = true;
            }else if(caseRecord.Case_Approval_Status__c == 'AR1 Submitted' && ar1ApproveCount == ar1TotalCount){
                caseRecord.Case_Approval_Status__c = 'AR1 Approved';
                isChanged = true;
            }else if(caseRecord.Case_Approval_Status__c == 'CSO Submitted' && CSOApproveCount == CSOTotalCount){
                caseRecord.Case_Approval_Status__c = 'CSO Approved';
                isChanged = true;                   
            }else if(caseRecord.Case_Approval_Status__c == 'AR2 Submitted' && ar2ApproveCount == ar2TotalCount){
                caseRecord.Case_Approval_Status__c = 'AR2 Approved';
                isChanged = true;
            }else if(caseRecord.Case_Approval_Status__c == 'Additional Submitted' && addApproveCount == addTotalCount){
                caseRecord.Case_Approval_Status__c = 'Case Approved';
                isChanged = true;
            }
        }
        if(isChanged)
            update caseRecord;
        else if(status == 'REJECT'){
            if(caseRecord.Case_Approval_Status__c == 'Requestor Submitted'){
                caseRecord.Case_Approval_Status__c = 'Requestor Rejected';
                caseRecord.Case_Requestor_Approval_Status__c = 'Rejected';
            }else if(caseRecord.Case_Approval_Status__c == 'LOB Submitted'){
                caseRecord.Case_Approval_Status__c = 'LOB Rejected';
            }else if(caseRecord.Case_Approval_Status__c == 'F&R Submitted'){
                caseRecord.Case_Approval_Status__c = 'F&R Rejected';
            }else if(caseRecord.Case_Approval_Status__c == 'AR1 Submitted'){
                caseRecord.Case_Approval_Status__c = 'AR1 Rejected';
            }else if(caseRecord.Case_Approval_Status__c == 'CSO Submitted'){
                caseRecord.Case_Approval_Status__c = 'CSO Rejected';                   
            }else if(caseRecord.Case_Approval_Status__c == 'AR2 Submitted'){
                caseRecord.Case_Approval_Status__c = 'AR2 Rejected';
            }else if(caseRecord.Case_Approval_Status__c == 'Additional Submitted'){
                caseRecord.Case_Approval_Status__c = 'Additional Rejected';
            }
            update caseRecord;
        }
    }

}