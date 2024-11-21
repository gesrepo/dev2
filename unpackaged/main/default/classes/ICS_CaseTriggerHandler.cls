public class ICS_CaseTriggerHandler { 
    public static void CaseStatus_AfterUpdate(Set<Id> setCaseIds, List<Customer_Service_Inquiries_ICS__c> listCases){
        Map<Id, List<AR_Adjustments__c>> mapARAdjustment = new Map<Id, List<AR_Adjustments__c>>();
        Map<Id, List<Credit_Memo_ICS__c>> mapCreditMemo = new Map<Id, List<Credit_Memo_ICS__c>>();
        Map<Id, List<Receipt_Reversals__c>> mapReceiptReversal = new Map<Id, List<Receipt_Reversals__c>>();
        Map<Id, List<Refunds_ICS__c>> mapRefunds = new Map<Id, List<Refunds_ICS__c>>();
        List<sObject> listToUpdate = new List<sObject>();

        /*List<Customer_Service_Inquiries_ICS__c> listCase= [SELECT Id, Name,
                                                        Case_Approval_Status__c,
                                                        Case_Requestor__c, Case_Requestor__r.Name,
                                                        Requestor_Apporval_Required__c
                                                        FROM Customer_Service_Inquiries_ICS__c
                                                        WHERE Id = : caseId
                                                       ];*/
       for(AR_Adjustments__c ar : getARadjustments(setCaseIds)) {
            if(!mapARAdjustment.containsKey(ar.AR_Adj_CSI_ID__c)) {
                mapARAdjustment.put(ar.AR_Adj_CSI_ID__c, new List<AR_Adjustments__c>());
            }
            mapARAdjustment.get(ar.AR_Adj_CSI_ID__c).add(ar);
        }
        for(Credit_Memo_ICS__c creditMemo : getCreditMemo(setCaseIds)) {
            if(!mapCreditMemo.containsKey(creditMemo.CSI_ICS__c)) {
                mapCreditMemo.put(creditMemo.CSI_ICS__c, new List<Credit_Memo_ICS__c>());
            }
            mapCreditMemo.get(creditMemo.CSI_ICS__c).add(creditMemo);
        }
        for(Receipt_Reversals__c rr : getReceiptReversals(setCaseIds)) {
            if(!mapReceiptReversal.containsKey(rr.CSI_ICS__c)) {
                mapReceiptReversal.put(rr.CSI_ICS__c, new List<Receipt_Reversals__c>());
            }
            mapReceiptReversal.get(rr.CSI_ICS__c).add(rr);
        }
        for(Refunds_ICS__c refund : getRefunds(setCaseIds)) {
            if(!mapRefunds.containsKey(refund.CSI_ICS__c)) {
                mapRefunds.put(refund.CSI_ICS__c, new List<Refunds_ICS__c>());
            }
            mapRefunds.get(refund.CSI_ICS__c).add(refund);
        }
        for(Customer_Service_Inquiries_ICS__c icsCase : listCases) {
            if(icsCase.Case_Approval_Status__c == 'LOB Submitted') {
                if(mapARAdjustment.get(icsCase.Id) != null) {
                    for(AR_Adjustments__c ar : mapARAdjustment.get(icsCase.Id)) {
                        if(ar.DAM_LOB_Approver__c != null && ar.DAM_Approver_Status__c != 'Approved') {
                            ar.DAM_Approver_Status__c = 'Submitted';
                            listToUpdate.add(ar);
                        }
                    }
                }
                if(mapCreditMemo.get(icsCase.Id) != null) {
                    for(Credit_Memo_ICS__c cm : mapCreditMemo.get(icsCase.Id)) {
                        if(cm.LOB_Approver_Name__c != null && cm.LOB__c != 'Approved') {
                            cm.LOB__c = 'Submitted';
                            listToUpdate.add(cm);
                        }
                    }
                }
            }
            if(icsCase.Case_Approval_Status__c == 'F&R Submitted') {
                if(mapARAdjustment.get(icsCase.Id) != null) {
                    for(AR_Adjustments__c ar : mapARAdjustment.get(icsCase.Id)) {
                        if(ar.F_R_Approver__c != null && ar.F_R_Approvers_Status__c != 'Approved' ) {
                            ar.F_R_Approvers_Status__c = 'Submitted';
                            listToUpdate.add(ar);
                        }
                    }
                }
                if(mapCreditMemo.get(icsCase.Id) != null) {
                    for(Credit_Memo_ICS__c cm : mapCreditMemo.get(icsCase.Id)) {
                        if(cm.F_R_Approver_Name__c != null && cm.F_R_Approver_Status__c != 'Approved' ) {
                            cm.F_R_Approver_Status__c = 'Submitted';
                            listToUpdate.add(cm);
                        }
                    }
                }
            }
            if(icsCase.Case_Approval_Status__c == 'AR1 Submitted') {
                if(mapARAdjustment.get(icsCase.Id) != null) {
                    for(AR_Adjustments__c ar : mapARAdjustment.get(icsCase.Id)) {
                        if(ar.AR1_Approver_Name__c != null && ar.AR1_Approver_Status__c != 'Approved') {
                            ar.AR1_Approver_Status__c = 'Submitted';
                            listToUpdate.add(ar);
                        }
                    }
                }
                if(mapCreditMemo.get(icsCase.Id) != null) {
                    for(Credit_Memo_ICS__c cm : mapCreditMemo.get(icsCase.Id)) {
                        if(cm.AR1_Approver_Name__c != null && cm.AR1_Approver_Status__c != 'Approved') {
                            cm.AR1_Approver_Status__c = 'Submitted';
                            listToUpdate.add(cm);
                        }
                    }
                }
                if(mapRefunds.get(icsCase.Id) != null) {
                    for(Refunds_ICS__c refund : mapRefunds.get(icsCase.Id)) {
                        if(refund.AR1_Approver_Name__c != null && refund.AR1_Approver_Status__c != 'Approved') {
                            refund.AR1_Approver_Status__c = 'Submitted';
                            listToUpdate.add(refund);
                        }
                    }
                }
            }
            
            if(icsCase.Case_Approval_Status__c == 'CSO Submitted') {
                if(mapARAdjustment.get(icsCase.Id) != null) {
                    for(AR_Adjustments__c ar : mapARAdjustment.get(icsCase.Id)) {
                        if(ar.CSO_Approver_Email__c != null && ar.CSO_Approver_Status__c!= 'Approved') {
                            ar.CSO_Approver_Status__c = 'Submitted';
                            listToUpdate.add(ar);
                        }
                    }
                }
                if(mapCreditMemo.get(icsCase.Id) != null) {
                    for(Credit_Memo_ICS__c cm : mapCreditMemo.get(icsCase.Id)) {
                        if(cm.CSO_Approver_Email__c != null && cm.CSO_Approver_Status__c != 'Approved' ) {
                            cm.CSO_Approver_Status__c = 'Submitted';
                            listToUpdate.add(cm);
                        }
                    }
                }
                if(mapRefunds.get(icsCase.Id) != null) {
                    for(Refunds_ICS__c refund : mapRefunds.get(icsCase.Id)) {
                        if(refund.CSO_Approver_EmailID__c != null && refund.CSO_Approver_Status__c != 'Approved' ) {
                            refund.CSO_Approver_Status__c = 'Submitted';
                            listToUpdate.add(refund);
                        }
                    }
                }
            }
            
            if(icsCase.Case_Approval_Status__c == 'AR2 Submitted') {
                if(mapARAdjustment.get(icsCase.Id) != null) {
                    for(AR_Adjustments__c ar : mapARAdjustment.get(icsCase.Id)) {
                        if(ar.AR2_Approver_Name__c != null && ar.AR2_Approver_Status__c != 'Approved') {
                            ar.AR2_Approver_Status__c = 'Submitted';
                            listToUpdate.add(ar);
                        }
                    }
                }
                if(mapCreditMemo.get(icsCase.Id) != null) {
                    for(Credit_Memo_ICS__c cm : mapCreditMemo.get(icsCase.Id)) {
                        if(cm.AR2_Approver_Name__c != null && cm.AR2_Approver_Status__c != 'Approved' ) {
                            cm.AR2_Approver_Status__c = 'Submitted';
                            listToUpdate.add(cm);
                        }
                    }
                }
                if(mapRefunds.get(icsCase.Id) != null) {
                    for(Refunds_ICS__c refund : mapRefunds.get(icsCase.Id)) {
                        if(refund.AR2_Approver_Name__c != null && refund.AR2_Approver_Status__c != 'Approved' ) {
                            refund.AR2_Approver_Status__c = 'Submitted';
                            listToUpdate.add(refund);
                        }
                    }
                }
            }
            if(icsCase.Case_Approval_Status__c == 'Additional Submitted') {
                if(mapCreditMemo.get(icsCase.Id) != null) {
                    for(Credit_Memo_ICS__c cm : mapCreditMemo.get(icsCase.Id)) {
                        if(cm.Additional_Approver_Name__c != null && cm.Additional_Approver_Status__c != 'Approved') {
                            cm.Additional_Approver_Status__c = 'Submitted';
                            listToUpdate.add(cm);
                        }
                    }
                }
                if(mapReceiptReversal.get(icsCase.Id) != null) {
                    for(Receipt_Reversals__c rr : mapReceiptReversal.get(icsCase.Id)) {
                        if(rr.Additional_Approver_Name__c != null && rr.Approver_Status__c != 'Approved') {
                            rr.Approver_Status__c = 'Submitted';
                            listToUpdate.add(rr);
                        }
                    }
                }
            }
        }
        if(listToUpdate.size() > 0) {
            update listToUpdate;
        }
    }
    
      public static List<AR_Adjustments__c> getARadjustments(Set<Id> customerServiceRequestId) { 
        List<AR_Adjustments__c> listARAdjustments = [SELECT Id, Name, AR_Adj_CSI_ID__c,AR_Adj_CSI_ID__r.Name, AR_Adj_CSI_ID__r.Case_Requestor__c, AR_Adj_CSI_ID__r.Case_Requestor__r.Name,
                                             AR_Adj_CSI_ID__r.Show_Occur__c,
                                           AR_Adj_CSI_ID__r.Show_Occur__r.Name, AR_Adj_CSI_ID__r.Show_Occur__r.Show_Name__c, AR_Adj_CSI_ID__r.Show_Occur__r.Show_Name__r.Name,
                                           AR_Adj_CSI_ID__r.Booth_Area__c, Total_AR_Currency__c,
                                          Billing_ID__c, Sales_Order__c, Activity_Name__c, Amount__c,
                                          DAM_Approver_Email_ID__c, F_A_Approver_Email__c,
                                          AR1_Approver_Email__c, AR2_Approver_Email__c, 
                                          DAM_LOB_Approver__c, DAM_LOB_Approver__r.Name,DAM_LOB_Approver__r.Email_Address__c,
                                          F_R_Approver__c, F_R_Approver__r.Name, F_R_Approver__r.Email_Address__c,
                                          AR1_Approver_Name__c, AR1_Approver_Name__r.Name, AR1_Approver_Name__r.Email_Address__c,
                                          AR2_Approver_Name__c, AR2_Approver_Name__r.Name, AR2_Approver_Name__r.Email_Address__c,
                                          CSO_Approver_Name__c, CSO_Approver_Name__r.Name, CSO_Approver_Name__r.Email_Address__c,
                                          CSO_Approver_Email__c,CSO_Approver_Status__c, CSO_Approval_Comments__c,                  
                                          DAM_Approver_Status__c,F_R_Approvers_Status__c, AR1_Approver_Status__c, AR2_Approver_Status__c,
                                          Del_DAM_LOB_Approver__c, Del_F_R_Approver__c, Del_AR2_Approver__c, Del_AR1_Approver__c,
                                          Del_DAM_LOB_Approver__r.Name, Del_F_R_Approver__r.Name, Del_AR2_Approver__r.Name, Del_AR1_Approver__r.Name,
                                          Justification_for_AR_Adjustment_Request__c 
                                          //AR_Adj_CSI_ID__r.Account_Name__c, AR_Adj_CSI_ID__r.Oracle_AR_Customer_Number__c
                                          //AR_Adj_CSI_ID__r.Customer_Name__c, AR_Adj_CSI_ID__r.Customer__c,
                                          FROM AR_Adjustments__c
                                          WHERE AR_Adj_CSI_ID__c IN: customerServiceRequestId];
        return listARAdjustments;
    }
    
    public static List<Credit_Memo_ICS__c> getCreditMemo(Set<Id> customerServiceRequestId) {
        List<Credit_Memo_ICS__c> cmList = [SELECT Id, Name, CSI_ICS__c, CSI_ICS__r.Name, CSI_ICS__r.Case_Requestor__c, CSI_ICS__r.Case_Requestor__r.Name,
                                            CSI_ICS__r.Show_Occur__c,
                                           CSI_ICS__r.Show_Occur__r.Name, CSI_ICS__r.Show_Occur__r.Show_Name__c, CSI_ICS__r.Show_Occur__r.Show_Name__r.Name,
                                           CSI_ICS__r.Booth_Area__c, Total_CM_Curreny__c,
                                           Billing_ID__c, Sales_Order__c, Credit_LOB__c, Credit_Memo_Reason__c, 
                                           LOB_Approver_Email_ID__c, F_R_Approver_Email_ID__c,                                    
                                           AR1_Approver_Email_ID__c, AR2_Approver_Email_ID__c, Additional_Approver_Email_ID__c,
                                           LOB_Approver_Name__c, LOB_Approver_Name__r.Name, LOB_Approver_Name__r.Email_Address__c,
                                           F_R_Approver_Name__c, F_R_Approver_Name__r.Name, F_R_Approver_Name__r.Email_Address__c,
                                           AR1_Approver_Name__c, AR1_Approver_Name__r.Name, AR1_Approver_Name__r.Email_Address__c,
                                           CSO_Approver_Name__c, CSO_Approver_Name__r.Name, CSO_Approver_Name__r.Email_Address__c,
                                           CSO_Approver_Email__c,CSO_Approver_Status__c, CSO_Approval_Comments__c,
                                           AR2_Approver_Name__c, AR2_Approver_Name__r.Name, AR2_Approver_Name__r.Email_Address__c,
                                           Additional_Approver_Name__c, Additional_Approver_Name__r.Name, Additional_Approver_Name__r.Email_Address__c,
                                           LOB__c, F_R_Approver_Status__c, AR1_Approver_Status__c, AR2_Approver_Status__c, Additional_Approver_Status__c,
                                           Del_AR1_Approver__c, Del_AR2_Approver__c, Del_F_R_Approver__c, Del_LOB_Approver__c, Del_Additional_Approver__c,
                                           Del_AR1_Approver__r.Name, Del_AR2_Approver__r.Name, Del_F_R_Approver__r.Name, Del_LOB_Approver__r.Name, 
                                           Del_Additional_Approver__r.Name, Amount_w_psp__c, Tax_Amount__c, Total_Amount__c, Justification_for_Credit_Memo_Request__c
                                           //CSI_ICS__r.Account_Name__c, CSI_ICS__r.Oracle_AR_Customer_Number__c
                                           //CSI_ICS__r.Customer_Name__c, CSI_ICS__r.Customer__c,
                                           FROM Credit_Memo_ICS__c
                                           WHERE CSI_ICS__c IN: customerServiceRequestId];
        return cmList;
    }
    
    public static List<Receipt_Reversals__c> getReceiptReversals(Set<Id> customerServiceRequestId) {
        List<Receipt_Reversals__c> rrList = [SELECT Id, Name, CSI_ICS__c,CSI_ICS__r.Name, CSI_ICS__r.Case_Requestor__c, CSI_ICS__r.Case_Requestor__r.Name,
                                             CSI_ICS__r.Show_Occur__c, Sales_Order__c,Receipt_Reversal_Amount__c,
                                            CSI_ICS__r.Show_Occur__r.Name, CSI_ICS__r.Show_Occur__r.Show_Name__c, CSI_ICS__r.Show_Occur__r.Show_Name__r.Name,
                                            CSI_ICS__r.Booth_Area__c, Total_Receipt_Reversal_Currency__c, Approver_Email__c,                
                                             Payment_Method__c, Receipt_Number__c, Reason__c,                                          
                                             Additional_Approver_Name__c, Additional_Approver_Name__r.Name, Additional_Approver_Name__r.Email_Address__c,
                                             Approver_Status__c, Del_Additional_Approver__c, Del_Additional_Approver__r.Name, Justification_for_Receipt_Rvsl_Request__c
                                             //CSI_ICS__r.Account_Name__c, CSI_ICS__r.Oracle_AR_Customer_Number__c
                                            //CSI_ICS__r.Customer_Name__c, CSI_ICS__r.Customer__c,
                                             FROM Receipt_Reversals__c
                                             WHERE CSI_ICS__c IN: customerServiceRequestId];
        return rrList;
    }
    
    public static List<Refunds_ICS__c> getRefunds(Set<Id> customerServiceRequestId) {
        List<Refunds_ICS__c> refundsList = [SELECT Id, Name, CSI_ICS__c, CSI_ICS__r.Name, CSI_ICS__r.Case_Requestor__c, CSI_ICS__r.Case_Requestor__r.Name,
                                            CSI_ICS__r.Show_Occur__c,
                                            CSI_ICS__r.Show_Occur__r.Name, CSI_ICS__r.Show_Occur__r.Show_Name__c, CSI_ICS__r.Show_Occur__r.Show_Name__r.Name,
                                            CSI_ICS__r.Booth_Area__c,  Total_Refunds_Currency__c,Sales_Order__c, Sales_Receipt__c, Amount__c,                                     
                                            Pymt_Type__c, AR1_Approver_Email_ID__c, AR2_Approver_Email_ID__c,
                                            AR1_Approver_Name__c, AR1_Approver_Name__r.Name, AR1_Approver_Name__r.Email_Address__c,
                                            AR2_Approver_Name__c, AR2_Approver_Name__r.Name,AR2_Approver_Name__r.Email_Address__c,
                                            CSO_Approver_Name__c, CSO_Approver_Name__r.Name, CSO_Approver_Name__r.Email_Address__c,
                                            CSO_Approver_EmailID__c,CSO_Approver_Status__c, CSO_Approval_Comments__c,                                           
                                            AR1_Approver_Status__c, AR2_Approver_Status__c, Del_AR1_Approver__c, Del_AR2_Approver__c,
                                            Del_AR1_Approver__r.Name, Del_AR2_Approver__r.Name, Justification_for_Refunds_Request__c
                                            //CSI_ICS__r.Account_Name__c, CSI_ICS__r.Oracle_AR_Customer_Number__c
                                            //CSI_ICS__r.Customer_Name__c, CSI_ICS__r.Customer__c,
                                            FROM Refunds_ICS__c
                                            WHERE CSI_ICS__c IN: customerServiceRequestId];
        return refundsList;
    } 

}