public class VFC_ICSDelegateApprover {
    public Customer_Service_Inquiries_ICS__c customerServiceInquiries {get; set;}
    public string requestorApproval {get; set;}
    public string lobApproval {get; set;}
    public string frApproval {get; set;}
    public string ar1Approval {get; set;}
     public string CSOApproval {get; set;}
    public string ar2Approval {get; set;}
    public string additionalApproval {get; set;}
    public List<ICSCustomerServiceInquiries> listCustomerServiceInquiries {get; set;}
    public List<Approvers> listLOBApprovers {get; set;}
    public List<Approvers> listFRApprovers {get; set;}
    public List<Approvers> listAR1Approvers {get; set;}
    public List<Approvers> listCSOApprovers {get; set;}
    public List<Approvers> listAR2Approvers {get; set;}
    public List<Approvers> listAdditionalApprovers {get; set;}
    //Public string currencyFormat {get; set;}
    //Public string currencyFormatTotal {get; set;}
    //Map<Id, List<AttachmentsWrapper>> mapAttachments = new Map<Id, List<AttachmentsWrapper>>();
    Map<Id, List<Attachment>> mapAttachments = new Map<Id, List<Attachment>>();
    Set<Id> setAttachmentParentIds = new Set<Id>();
    public static Map<Id,Map<String, DateTime>> timeStampMap;
    
    public VFC_ICSDelegateApprover(ApexPages.StandardController stdController) {
        listCustomerServiceInquiries = new List<ICSCustomerServiceInquiries>();
        listLOBApprovers = new List<Approvers>();
        listFRApprovers = new List<Approvers>();
        listAR1Approvers = new List<Approvers>();
        listCSOApprovers = new List<Approvers>();
        listAR2Approvers = new List<Approvers>();
        listAdditionalApprovers = new List<Approvers>();
        timeStampMap = new Map<Id,Map<String, DateTime>>();
        Customer_Service_Inquiries_ICS__c customerServiceInquiriesRecord = (Customer_Service_Inquiries_ICS__c)stdController.getRecord();
        customerServiceInquiries = [select Case_Requestor__c, Case_Approval_Status__c, Name, Requestor_Apporval_Required__c,Department__c,
                                    Title__c, Case_Requestor__r.Name,  Show_Occur__c, Priority__c,
                                    Case_Requestor_Email_ID__c, Opportunity_Name__r.Name, Project__c, Show_Occur__r.Name, 
                                    Show_Occur__r.Show_Name__c, Show_Occur__r.Show_Name__r.Name, Booth_Area__c,owner.email,
                                    Sales_Channel__c, Account_Name__r.Name, Oracle_AR_Customer_Number__c, Case_Requestor__r.First_Name__c, Case_Requestor__r.Last_Name__c
                                    //Customer_Name__c, Customer__c,
                                    from Customer_Service_Inquiries_ICS__c where id =: customerServiceInquiriesRecord.Id];
        //Case Attachment
        setAttachmentParentIds.add(customerServiceInquiriesRecord.Id);
        historyMapPopulate();
        if(customerServiceInquiries.Case_Approval_Status__c != null) {
            if((customerServiceInquiries.Case_Approval_Status__c == 'Requestor Submitted'
                || customerServiceInquiries.Case_Approval_Status__c == 'Requestor Approved'
                || customerServiceInquiries.Case_Approval_Status__c == 'Requestor Rejected') && customerServiceInquiries.Requestor_Apporval_Required__c) {
                requestorApproval = 'Show Panel';
            } else
            if(customerServiceInquiries.Case_Approval_Status__c == 'LOB Submitted'
                || customerServiceInquiries.Case_Approval_Status__c == 'LOB Approved'
                || customerServiceInquiries.Case_Approval_Status__c == 'LOB Rejected') {
                if(customerServiceInquiries.Requestor_Apporval_Required__c) {
                    requestorApproval = 'Show Panel';
                }
                lobApproval = 'Show Panel';
            } else
            if(customerServiceInquiries.Case_Approval_Status__c == 'F&R Submitted'
                || customerServiceInquiries.Case_Approval_Status__c == 'F&R Approved'
                || customerServiceInquiries.Case_Approval_Status__c == 'F&R Rejected') {
                if(customerServiceInquiries.Requestor_Apporval_Required__c) {
                    requestorApproval = 'Show Panel';
                }
                lobApproval = 'Show Panel';
                frApproval = 'Show Panel';
            } else
            if(customerServiceInquiries.Case_Approval_Status__c == 'AR1 Submitted'
                || customerServiceInquiries.Case_Approval_Status__c == 'AR1 Approved'
                || customerServiceInquiries.Case_Approval_Status__c == 'AR1 Rejected') {
                if(customerServiceInquiries.Requestor_Apporval_Required__c) {
                    requestorApproval = 'Show Panel';
                }
                lobApproval = 'Show Panel';
                frApproval = 'Show Panel';
                ar1Approval = 'Show Panel';
            } else
                
            if(customerServiceInquiries.Case_Approval_Status__c == 'CSO Submitted'
                || customerServiceInquiries.Case_Approval_Status__c == 'CSO Approved'
                || customerServiceInquiries.Case_Approval_Status__c == 'CSO Rejected') {
                if(customerServiceInquiries.Requestor_Apporval_Required__c) {
                    requestorApproval = 'Show Panel';
                }
                lobApproval = 'Show Panel';
                frApproval = 'Show Panel';
                ar1Approval = 'Show Panel';
                CSOApproval = 'Show Panel';    
            } else    
  
            if(customerServiceInquiries.Case_Approval_Status__c == 'AR2 Submitted'
                || customerServiceInquiries.Case_Approval_Status__c == 'AR2 Approved'
                || customerServiceInquiries.Case_Approval_Status__c == 'AR2 Rejected') {
                if(customerServiceInquiries.Requestor_Apporval_Required__c) {
                    requestorApproval = 'Show Panel';
                }
                lobApproval = 'Show Panel';
                frApproval = 'Show Panel';
                ar1Approval = 'Show Panel';
                CSOApproval = 'Show Panel';       
                ar2Approval = 'Show Panel';
            } else
            if(customerServiceInquiries.Case_Approval_Status__c == 'Additional Submitted'
                || customerServiceInquiries.Case_Approval_Status__c == 'Additional Approved'
                || customerServiceInquiries.Case_Approval_Status__c == 'Additional Rejected'
                || customerServiceInquiries.Case_Approval_Status__c == 'Case Approved') {
                if(customerServiceInquiries.Requestor_Apporval_Required__c) {
                    requestorApproval = 'Show Panel';
                }
                lobApproval = 'Show Panel';
                frApproval = 'Show Panel';
                ar1Approval = 'Show Panel';
                CSOApproval = 'Show Panel';       
                ar2Approval = 'Show Panel';
                additionalApproval = 'Show Panel';
            } 
        }
        if(requestorApproval != null) {
            if(customerServiceInquiries.Case_Approval_Status__c == 'Requestor Submitted') {
                requestorApproval = 'Pending';
            } else
            if(customerServiceInquiries.Case_Approval_Status__c == 'Requestor Rejected') {
                requestorApproval = 'Rejected';
            }else
            {
                requestorApproval = 'Approved';
            }   
            ICSCustomerServiceInquiries csi = prepareRequestor(customerServiceInquiries, requestorApproval);
            listCustomerServiceInquiries.add(csi);
        }
        if(lobApproval != null) {
            for(AR_Adjustments__c ar : getARadjustments(new set<Id>{customerServiceInquiries.Id})) {
                if(ar.DAM_LOB_Approver__c != null) {
                    if(ar.DAM_Approver_Status__c == 'Approved') {
                        lobApproval = 'Approved';
                    } else
                    if(ar.DAM_Approver_Status__c == 'Rejected') {
                        lobApproval = 'Rejected';
                    }else
                    {
                        lobApproval = 'Pending';
                    }   
                    Approvers approver = prepareApprovers(ar, lobApproval, 'LOB');
                    listLOBApprovers.add(approver);
                    setAttachmentParentIds.add(ar.Id);
                }
            }
            for(Credit_Memo_ICS__c creditMemo : getCreditMemo(new set<Id>{customerServiceInquiries.Id})) {
                system.debug('creditMemo==='+creditMemo);
                if(creditMemo.LOB_Approver_Name__c != null) {
                    if(creditMemo.LOB__c == 'Approved') {
                        lobApproval = 'Approved';
                    } else
                    if(creditMemo.LOB__c == 'Rejected') {
                        lobApproval = 'Rejected';
                    } else
                    {
                        lobApproval = 'Pending';
                    }   
                    Approvers approver = prepareApprovers(creditMemo, lobApproval, 'LOB');
                    listLOBApprovers.add(approver);
                    setAttachmentParentIds.add(creditMemo.Id);
                }
            }
        }
        if(frApproval != null) {
            for(AR_Adjustments__c ar : getARadjustments(new set<Id>{customerServiceInquiries.Id})) {
                if(ar.F_R_Approver__c != null) {
                    if(ar.F_R_Approvers_Status__c == 'Approved') {
                        frApproval = 'Approved';
                    } else
                    if(ar.F_R_Approvers_Status__c == 'Rejected') {
                        frApproval = 'Rejected';
                    } else
                    {
                        frApproval = 'Pending';
                    }   
                    Approvers approver = prepareApprovers(ar, frApproval, 'FR');
                    listFRApprovers.add(approver);
                    setAttachmentParentIds.add(ar.Id);
                }
            }
            for(Credit_Memo_ICS__c creditMemo : getCreditMemo(new set<Id>{customerServiceInquiries.Id})) {
                if(creditMemo.F_R_Approver_Name__c != null) {
                    if(creditMemo.F_R_Approver_Status__c == 'Approved') {
                        frApproval = 'Approved';
                    } else
                    if(creditMemo.F_R_Approver_Status__c == 'Rejected') {
                        frApproval = 'Rejected';
                    }else
                    {
                        frApproval = 'Pending';
                    }   
                    Approvers approver = prepareApprovers(creditMemo, frApproval, 'FR');
                    listFRApprovers.add(approver);
                    setAttachmentParentIds.add(creditMemo.Id);
                }
            }
        }
        if(ar1Approval != null) {
            for(AR_Adjustments__c ar : getARadjustments(new set<Id>{customerServiceInquiries.Id})) {
                if(ar.AR1_Approver_Name__c != null) {
                    if(ar.AR1_Approver_Status__c == 'Approved') {
                        ar1Approval = 'Approved';
                    } else
                    if(ar.AR1_Approver_Status__c == 'Rejected') {
                        ar1Approval = 'Rejected';
                    }else
                    {
                        ar1Approval = 'Pending';
                    }
                    Approvers approver = prepareApprovers(ar, ar1Approval, 'AR1');
                    listAR1Approvers.add(approver);
                    setAttachmentParentIds.add(ar.Id);
                }
            }
            for(Credit_Memo_ICS__c creditMemo : getCreditMemo(new set<Id>{customerServiceInquiries.Id})) {
                if(creditMemo.AR1_Approver_Name__c != null) {
                    if(creditMemo.AR1_Approver_Status__c == 'Approved') {
                        ar1Approval = 'Approved';
                    } else
                    if(creditMemo.AR1_Approver_Status__c == 'Rejected') {
                        ar1Approval = 'Rejected';
                    }else
                    {
                        ar1Approval = 'Pending';
                    }
                    Approvers approver = prepareApprovers(creditMemo, ar1Approval, 'AR1');
                    listAR1Approvers.add(approver);
                    setAttachmentParentIds.add(creditMemo.Id);
                }
            }
           for(Refunds_ICS__c refunds : getRefunds(new set<Id>{customerServiceInquiries.Id})) {
                if(refunds.AR1_Approver_Name__c != null) {
                    if(refunds.AR1_Approver_Status__c == 'Approved') {
                        ar1Approval = 'Approved';
                    } else
                    if(refunds.AR1_Approver_Status__c == 'Rejected') {
                        ar1Approval = 'Rejected';
                    }else
                    {
                        ar1Approval = 'Pending';
                    }
                    Approvers approver = prepareApprovers(refunds, ar1Approval, 'AR1');
                    listAR1Approvers.add(approver);
                    setAttachmentParentIds.add(refunds.Id);
                }
            }
        }
        
        if(CSOApproval != null) {
            for(AR_Adjustments__c ar : getARadjustments(new set<Id>{customerServiceInquiries.Id})) {
                if(ar.CSO_Approver_Name__c != null) {
                   if(ar.CSO_Approver_Status__c == 'Approved') {
                        CSOApproval = 'Approved';
                    } else
                    if(ar.CSO_Approver_Status__c == 'Rejected') {
                        CSOApproval = 'Rejected';
                    }else
                    {
                        CSOApproval = 'Pending';
                    }
                    Approvers approver = prepareApprovers(ar, CSOApproval, 'CSO');
                    listCSOApprovers.add(approver);
                    setAttachmentParentIds.add(ar.Id);
                }
            }
            for(Credit_Memo_ICS__c creditMemo : getCreditMemo(new set<Id>{customerServiceInquiries.Id})) {
                if(creditMemo.CSO_Approver_Name__c != null) {
                    if(creditMemo.CSO_Approver_Status__c == 'Approved') {
                        CSOApproval = 'Approved';
                    } else
                    if(creditMemo.CSO_Approver_Status__c == 'Rejected') {
                        CSOApproval = 'Rejected';
                    }else
                    {
                        CSOApproval = 'Pending';
                    }
                    Approvers approver = prepareApprovers(creditMemo, CSOApproval, 'CSO');
                    listCSOApprovers.add(approver);
                    setAttachmentParentIds.add(creditMemo.Id);
                }
            }
            for(Refunds_ICS__c refunds : getRefunds(new set<Id>{customerServiceInquiries.Id})) {
                if(refunds.CSO_Approver_Name__c != null) {
                    if(refunds.CSO_Approver_Status__c == 'Approved') {
                        CSOApproval = 'Approved';
                    } else
                    if(refunds.CSO_Approver_Status__c == 'Rejected') {
                        CSOApproval = 'Rejected';
                    }else
                    {
                        CSOApproval = 'Pending';
                    }
                    Approvers approver = prepareApprovers(refunds, CSOApproval, 'CSO');
                    listCSOApprovers.add(approver);
                    setAttachmentParentIds.add(refunds.Id);
                }
            }
        }
        
        
        
        if(ar2Approval != null) {
            for(AR_Adjustments__c ar : getARadjustments(new set<Id>{customerServiceInquiries.Id})) {
                if(ar.AR2_Approver_Name__c != null) {
                    if(ar.AR2_Approver_Status__c == 'Approved') {
                        ar2Approval = 'Approved';
                    } else
                    if(ar.AR2_Approver_Status__c == 'Rejected') {
                        ar2Approval = 'Rejected';
                    } else
                    {
                        ar2Approval = 'Pending';
                    }   
                    Approvers approver = prepareApprovers(ar, ar2Approval, 'AR2');
                    listAR2Approvers.add(approver);
                    setAttachmentParentIds.add(ar.Id);
                }
            }
            for(Credit_Memo_ICS__c creditMemo : getCreditMemo(new set<Id>{customerServiceInquiries.Id})) {
                if(creditMemo.AR2_Approver_Name__c != null) {
                    if(creditMemo.AR2_Approver_Status__c == 'Approved') {
                        ar2Approval = 'Approved';
                    } else
                    if(creditMemo.AR2_Approver_Status__c == 'Rejected') {
                        ar2Approval = 'Rejected';
                    } else
                    {
                        ar2Approval = 'Pending';
                    }   
                    Approvers approver = prepareApprovers(creditMemo, ar2Approval, 'AR2');
                    listAR2Approvers.add(approver);
                    setAttachmentParentIds.add(creditMemo.Id);
                }
            }
            for(Refunds_ICS__c refunds : getRefunds(new set<Id>{customerServiceInquiries.Id})) {
                if(refunds.AR2_Approver_Name__c != null) {
                    if(refunds.AR2_Approver_Status__c == 'Approved') {
                        ar2Approval = 'Approved';
                    } else
                    if(refunds.AR2_Approver_Status__c == 'Rejected') {
                        ar2Approval = 'Rejected';
                    } else
                    {
                        ar2Approval = 'Pending';
                    }   
                    Approvers approver = prepareApprovers(refunds, ar2Approval, 'AR2');
                    listAR2Approvers.add(approver);
                    setAttachmentParentIds.add(refunds.Id);
                }
            }
        }
        if(additionalApproval != null) {
            for(Credit_Memo_ICS__c creditMemo : getCreditMemo(new set<Id>{customerServiceInquiries.Id})) {
                if(creditMemo.Additional_Approver_Name__c != null) {
                    if(creditMemo.Additional_Approver_Status__c == 'Approved') {
                        additionalApproval = 'Approved';
                    } else
                    if(creditMemo.Additional_Approver_Status__c == 'Rejected') {
                        additionalApproval = 'Rejected';
                    } else
                    {
                        additionalApproval = 'Pending';
                    }   
                    Approvers approver = prepareApprovers(creditMemo, additionalApproval, 'Additional Approver');
                    listAdditionalApprovers.add(approver);
                    setAttachmentParentIds.add(creditMemo.Id);
                }
            }
            for(Receipt_Reversals__c rr : getReceiptReversals(new set<Id>{customerServiceInquiries.Id})) {
                if(rr.Additional_Approver_Name__c != null) {
                    if(rr.Approver_Status__c == 'Approved') {
                        additionalApproval = 'Approved';
                    } else
                    if(rr.Approver_Status__c == 'Rejected') {
                        additionalApproval = 'Rejected';
                    }else
                    {
                        additionalApproval = 'Pending';
                    }   
                    Approvers approver = prepareApprovers(rr, additionalApproval, 'Additional Approver');
                    listAdditionalApprovers.add(approver);
                    setAttachmentParentIds.add(rr.Id);
                }
            }
        }
       /* if(setAttachmentParentIds.size() > 0) {
            for(AttachmentsWrapper att : getAttachments(setAttachmentParentIds)) {
                if(!mapAttachments.containsKey(att.ParentId)) {
                    mapAttachments.put(att.ParentId, new List<AttachmentsWrapper>());
                }
                mapAttachments.get(att.ParentId).add(att);
            }
        }*/
        if(setAttachmentParentIds.size() > 0) {
            for(Attachment att : getAttachments(setAttachmentParentIds)) {
                if(!mapAttachments.containsKey(att.ParentId)) {
                    mapAttachments.put(att.ParentId, new List<Attachment>());
                }
                mapAttachments.get(att.ParentId).add(att);
            }
        }
    }
    
    public static ICSCustomerServiceInquiries prepareRequestor(Customer_Service_Inquiries_ICS__c ics, string reqApproval) {
        ICSCustomerServiceInquiries csi = new ICSCustomerServiceInquiries();
        csi.CSI = ics;
        csi.status = reqApproval;
        return csi;
    }
    
    public Approvers prepareApprovers(sObject approver, String reqApproval, string approverType) {
        Approvers approverRec = new Approvers();
        approverRec.approverStage = approverType;
        if(approver.getSobjectType() == Schema.AR_Adjustments__c.getSObjectType()) {
            AR_Adjustments__c arAdj = (AR_Adjustments__c)approver;
            if(approverType == 'LOB') {
                approverRec.approverName = arAdj.DAM_LOB_Approver__r;           
                approverRec.delegateName = arAdj.Del_DAM_LOB_Approver__c != null ? arAdj.Del_DAM_LOB_Approver__r.Name : '';
                if(timeStampMap.get(arAdj.Id) != null && timeStampMap.get(arAdj.Id).get('DAM_Approver_Status__c') !=  null) {
                    approverRec.timeStamp = timeStampMap.get(arAdj.Id).get('DAM_Approver_Status__c').format('MMM d, yyyy hh:mm aaa');
                }
            } else
            if(approverType == 'FR') {
                approverRec.approverName = arAdj.F_R_Approver__r;
                approverRec.delegateName = arAdj.Del_F_R_Approver__c != null ? arAdj.Del_F_R_Approver__r.Name : '';
                if(timeStampMap.get(arAdj.Id) != null && timeStampMap.get(arAdj.Id).get('F_R_Approvers_Status__c') !=  null) {
                    approverRec.timeStamp = timeStampMap.get(arAdj.Id).get('F_R_Approvers_Status__c').format('MMM d, yyyy hh:mm aaa');
                }
            } else
            if(approverType == 'AR1') {
                approverRec.approverName = arAdj.AR1_Approver_Name__r;
                approverRec.delegateName = arAdj.Del_AR1_Approver__c != null ? arAdj.Del_AR1_Approver__r.Name : '';
                if(timeStampMap.get(arAdj.Id) != null && timeStampMap.get(arAdj.Id).get('AR1_Approver_Status__c') !=  null) {
                    approverRec.timeStamp = timeStampMap.get(arAdj.Id).get('AR1_Approver_Status__c').format('MMM d, yyyy hh:mm aaa');
                }
                
             } else
            if(approverType == 'CSO') {
                approverRec.approverName = arAdj.CSO_Approver_Name__r;
                approverRec.delegateName = arAdj.Del_CSO_Approver__c != null ? arAdj.Del_CSO_Approver__r.Name : '';
                if(timeStampMap.get(arAdj.Id) != null && timeStampMap.get(arAdj.Id).get('CSO_Approver_Status__c') !=  null) {
                    approverRec.timeStamp = timeStampMap.get(arAdj.Id).get('CSO_Approver_Status__c').format('MMM d, yyyy hh:mm aaa');
                }    
                
                
            } else
            if(approverType == 'AR2') {
                approverRec.approverName = arAdj.AR2_Approver_Name__r;
                approverRec.delegateName = arAdj.Del_AR2_Approver__c != null ? arAdj.Del_AR2_Approver__r.Name : '';
                if(timeStampMap.get(arAdj.Id) != null && timeStampMap.get(arAdj.Id).get('AR2_Approver_Status__c') !=  null) {
                    approverRec.timeStamp = timeStampMap.get(arAdj.Id).get('AR2_Approver_Status__c').format('MMM d, yyyy hh:mm aaa');
                }
            }
            approverRec.status = reqApproval;
            approverRec.CSI = customerServiceInquiries;
            approverRec.approvalObj = arAdj;
            approverRec.transactionType = 'AR Adjustment';
            approverRec.recordNumber = arAdj.Name; 
            approverRec.recordId = arAdj.Id; 
        } else
        if(approver.getSobjectType() == Schema.Credit_Memo_ICS__c.getSObjectType()) {
            Credit_Memo_ICS__c creditMemo = (Credit_Memo_ICS__c)approver;
            if(approverType == 'LOB') {
                approverRec.approverName = creditMemo.LOB_Approver_Name__r;
                approverRec.delegateName = creditMemo.Del_LOB_Approver__c != null ? creditMemo.Del_LOB_Approver__r.Name : '';
                if(timeStampMap.get(creditMemo.Id) != null && timeStampMap.get(creditMemo.Id).get('LOB__c') !=  null) {
                    approverRec.timeStamp = timeStampMap.get(creditMemo.Id).get('LOB__c').format('MMM d, yyyy hh:mm aaa');
                }
            } else
            if(approverType == 'FR') {
                approverRec.approverName = creditMemo.F_R_Approver_Name__r;
                approverRec.delegateName = creditMemo.Del_F_R_Approver__c != null ? creditMemo.Del_F_R_Approver__r.Name : '';
                if(timeStampMap.get(creditMemo.Id) != null && timeStampMap.get(creditMemo.Id).get('F_R_Approver_Status__c') !=  null) {
                    approverRec.timeStamp = timeStampMap.get(creditMemo.Id).get('F_R_Approver_Status__c').format('MMM d, yyyy hh:mm aaa');
                }
            } else
            if(approverType == 'AR1') {
                approverRec.approverName = creditMemo.AR1_Approver_Name__r;
                approverRec.delegateName = creditMemo.Del_AR1_Approver__c != null ? creditMemo.Del_AR1_Approver__r.Name : '';
                if(timeStampMap.get(creditMemo.Id) != null && timeStampMap.get(creditMemo.Id).get('AR1_Approver_Status__c') !=  null) {
                    approverRec.timeStamp = timeStampMap.get(creditMemo.Id).get('AR1_Approver_Status__c').format('MMM d, yyyy hh:mm aaa');
                }
                
            } else
            if(approverType == 'CSO') {
                approverRec.approverName = creditMemo.CSO_Approver_Name__r;
                approverRec.delegateName = creditMemo.Del_CSO_Approver__c != null ? creditMemo.Del_CSO_Approver__r.Name : '';
                if(timeStampMap.get(creditMemo.Id) != null && timeStampMap.get(creditMemo.Id).get('CSO_Approver_Status__c') !=  null) {
                    approverRec.timeStamp = timeStampMap.get(creditMemo.Id).get('CSO_Approver_Status__c').format('MMM d, yyyy hh:mm aaa');
                }    
                
                
            } else
            if(approverType == 'AR2') {
                approverRec.approverName = creditMemo.AR2_Approver_Name__r;
                approverRec.delegateName = creditMemo.Del_AR2_Approver__c != null ? creditMemo.Del_AR2_Approver__r.Name : '';
                if(timeStampMap.get(creditMemo.Id) != null && timeStampMap.get(creditMemo.Id).get('AR2_Approver_Status__c') !=  null) {
                    approverRec.timeStamp = timeStampMap.get(creditMemo.Id).get('AR2_Approver_Status__c').format('MMM d, yyyy hh:mm aaa');
                }
            }
            if(approverType == 'Additional Approver') {
                approverRec.approverName = creditMemo.Additional_Approver_Name__r;
                approverRec.delegateName = creditMemo.Del_Additional_Approver__c != null ? creditMemo.Del_Additional_Approver__r.Name : '';
                if(timeStampMap.get(creditMemo.Id) != null && timeStampMap.get(creditMemo.Id).get('Additional_Approver_Status__c') !=  null) {
                    approverRec.timeStamp = timeStampMap.get(creditMemo.Id).get('Additional_Approver_Status__c').format('MMM d, yyyy hh:mm aaa');
                }
            }
            approverRec.status = reqApproval;
            approverRec.CSI = customerServiceInquiries;
            approverRec.approvalObj = creditMemo;
            approverRec.transactionType = 'Credit Memo';
            approverRec.recordNumber = creditMemo.Name; 
            approverRec.recordId = creditMemo.Id; 
        } else
        if(approver.getSobjectType() == Schema.Refunds_ICS__c.getSObjectType()) {
            Refunds_ICS__c refund = (Refunds_ICS__c)approver;
            if(approverType == 'AR1') {
                approverRec.approverName = refund.AR1_Approver_Name__r;
                approverRec.delegateName = refund.Del_AR1_Approver__c != null ? refund.Del_AR1_Approver__r.Name : '';
                system.debug('timeStampMap.get(refund.Id)==='+timeStampMap.get(refund.Id));
                if(timeStampMap.get(refund.Id) != null && timeStampMap.get(refund.Id).get('AR1_Approver_Status__c') !=  null) {
                    approverRec.timeStamp = timeStampMap.get(refund.Id).get('AR1_Approver_Status__c').format('MMM d, yyyy hh:mm aaa');
                }
            }
            
            if(approverType == 'CSO') {
                approverRec.approverName = refund.CSO_Approver_Name__r;
                approverRec.delegateName = refund.Del_CSO_Approver__c != null ? refund.Del_CSO_Approver__r.Name : '';
                system.debug('timeStampMap.get(refund.Id)==='+timeStampMap.get(refund.Id));
                if(timeStampMap.get(refund.Id) != null && timeStampMap.get(refund.Id).get('CSO_Approver_Status__c') !=  null) {
                    approverRec.timeStamp = timeStampMap.get(refund.Id).get('CSO_Approver_Status__c').format('MMM d, yyyy hh:mm aaa');
                }
            }    
            
            
            if(approverType == 'AR2') {
                approverRec.approverName = refund.AR2_Approver_Name__r;
                approverRec.delegateName = refund.Del_AR2_Approver__c != null ? refund.Del_AR2_Approver__r.Name : '';
                if(timeStampMap.get(refund.Id) != null && timeStampMap.get(refund.Id).get('AR2_Approver_Status__c') !=  null) {
                    approverRec.timeStamp = timeStampMap.get(refund.Id).get('AR2_Approver_Status__c').format('MMM d, yyyy hh:mm aaa');
                }
           }
            approverRec.status = reqApproval;
            approverRec.CSI = customerServiceInquiries;
            approverRec.approvalObj = refund;
            approverRec.transactionType = 'Refund';
            approverRec.recordNumber = refund.Name;
            approverRec.recordId = refund.Id; 
        } else
        if(approver.getSobjectType() == Schema.Receipt_Reversals__c.getSObjectType()) {
            Receipt_Reversals__c reciptReversal = (Receipt_Reversals__c)approver;
            if(approverType == 'Additional Approver') {
                approverRec.approverName = reciptReversal.Additional_Approver_Name__r;
                approverRec.delegateName = reciptReversal.Del_Additional_Approver__c != null ? reciptReversal.Del_Additional_Approver__r.Name : '';
                if(timeStampMap.get(reciptReversal.Id) != null && timeStampMap.get(reciptReversal.Id).get('Approver_Status__c') !=  null) {
                    approverRec.timeStamp = timeStampMap.get(reciptReversal.Id).get('Approver_Status__c').format('MMM d, yyyy hh:mm aaa');
                }
            }
            approverRec.status = reqApproval;
            approverRec.CSI = customerServiceInquiries;
            approverRec.approvalObj = reciptReversal;
            approverRec.transactionType = 'Receipt Reversal';
            approverRec.recordNumber = reciptReversal.Name;
            approverRec.recordId = reciptReversal.Id; 
        }
        return approverRec;
    }
    
    public void historyMapPopulate() {
        for(AR_Adjustments__History history : [SELECT Field,Id,NewValue,OldValue,ParentId,CreatedDate FROM AR_Adjustments__History where Parent.AR_Adj_CSI_ID__c =: customerServiceInquiries.Id order by CreatedDate ASC]) {
            if(!timeStampMap.containsKey(history.ParentId)) {
                timeStampMap.put(history.ParentId, new Map<String, DateTime>());
            }
            timeStampMap.get(history.ParentId).put(history.Field, history.CreatedDate);
        }
        for(Credit_Memo_ICS__History history : [SELECT Field,Id,NewValue,OldValue,ParentId,CreatedDate FROM Credit_Memo_ICS__History where Parent.CSI_ICS__c =: customerServiceInquiries.Id order by CreatedDate ASC]) {
            if(!timeStampMap.containsKey(history.ParentId)) {
                timeStampMap.put(history.ParentId, new Map<String, DateTime>());
            }
            timeStampMap.get(history.ParentId).put(history.Field, history.CreatedDate);
        }
        for(Receipt_Reversals__History history : [SELECT Field,Id,NewValue,OldValue,ParentId,CreatedDate FROM Receipt_Reversals__History where Parent.CSI_ICS__c =: customerServiceInquiries.Id order by CreatedDate ASC]) {
            if(!timeStampMap.containsKey(history.ParentId)) {
                timeStampMap.put(history.ParentId, new Map<String, DateTime>());
            }
            timeStampMap.get(history.ParentId).put(history.Field, history.CreatedDate);
        }
        for(Refunds_ICS__History history : [SELECT Field,Id,NewValue,OldValue,ParentId,CreatedDate FROM Refunds_ICS__History where Parent.CSI_ICS__c =: customerServiceInquiries.Id order by CreatedDate ASC]) {
            if(!timeStampMap.containsKey(history.ParentId)) {
                timeStampMap.put(history.ParentId, new Map<String, DateTime>());
            }
            timeStampMap.get(history.ParentId).put(history.Field, history.CreatedDate);
            system.debug('history==='+history);
        }
    }
    
    public static List<AR_Adjustments__c> getARadjustments(Set<Id> customerServiceRequestId) { 
        List<AR_Adjustments__c> listARAdjustments = [SELECT Id, Name, AR_Adj_CSI_ID__c,AR_Adj_CSI_ID__r.Name, AR_Adj_CSI_ID__r.Case_Requestor__c, AR_Adj_CSI_ID__r.Case_Requestor__r.Name,
                                            AR_Adj_CSI_ID__r.Title__c, AR_Adj_CSI_ID__r.Department__c,
                                            AR_Adj_CSI_ID__r.Show_Occur__c,AR_Adj_CSI_ID__r.Case_Requestor_Email_ID__c,AR_Adj_CSI_ID__r.Opportunity_Name__r.Name,
                                           AR_Adj_CSI_ID__r.Project__c, AR_Adj_CSI_ID__r.Sales_Channel__c,
                                           AR_Adj_CSI_ID__r.Show_Occur__r.Name, AR_Adj_CSI_ID__r.Show_Occur__r.Show_Name__c, AR_Adj_CSI_ID__r.Show_Occur__r.Show_Name__r.Name, AR_Adj_CSI_ID__r.Booth_Area__c,
                                          Billing_ID__c, Sales_Order__c, Activity_Name__c, Amount__c,
                                           DAM_Approver_Email_ID__c, F_A_Approver_Email__c,
                                          AR1_Approver_Email__c, AR2_Approver_Email__c, 
                                          DAM_LOB_Approver__c, DAM_LOB_Approver__r.Name,DAM_LOB_Approver__r.Email_Address__c,
                                          F_R_Approver__c, F_R_Approver__r.Name, F_R_Approver__r.Email_Address__c,
                                          AR1_Approver_Name__c, AR1_Approver_Name__r.Name, AR1_Approver_Name__r.Email_Address__c,
                                          AR2_Approver_Name__c, AR2_Approver_Name__r.Name, AR2_Approver_Name__r.Email_Address__c,
                                          DAM_Approver_Status__c,F_R_Approvers_Status__c, AR1_Approver_Status__c, AR2_Approver_Status__c,
                                          Del_DAM_LOB_Approver__c, Del_F_R_Approver__c, Del_AR2_Approver__c, Del_AR1_Approver__c,
                                          Del_DAM_LOB_Approver__r.Name, Del_F_R_Approver__r.Name, Del_AR2_Approver__r.Name, Del_AR1_Approver__r.Name,
                                          Justification_for_AR_Adjustment_Request__c,Del_CSO_Approver__c, Del_CSO_Approver__r.Name,   CSO_Approver_Status__c, 
                                          CSO_Approver_Name__c, CSO_Approver_Name__r.Name,CSO_Approver_Email__c,CSO_Approver_Name__r.Email_Address__c,           
                                           AR_Adj_CSI_ID__r.Account_Name__c, AR_Adj_CSI_ID__r.Oracle_AR_Customer_Number__c
                                           //AR_Adj_CSI_ID__r.Customer_Name__c, AR_Adj_CSI_ID__r.Customer__c,
                                          FROM AR_Adjustments__c
                                          WHERE AR_Adj_CSI_ID__c IN: customerServiceRequestId];
        return listARAdjustments;
    }
    
    public static List<Credit_Memo_ICS__c> getCreditMemo(Set<Id> customerServiceRequestId) {
        List<Credit_Memo_ICS__c> cmList = [SELECT Id, Name, CSI_ICS__c, CSI_ICS__r.Name, CSI_ICS__r.Case_Requestor__c, CSI_ICS__r.Case_Requestor__r.Name,
                                           CSI_ICS__r.Title__c, CSI_ICS__r.Department__c,  
                                           CSI_ICS__r.Show_Occur__c,CSI_ICS__r.Case_Requestor_Email_ID__c, CSI_ICS__r.Opportunity_Name__r.Name,
                                           CSI_ICS__r.Project__c, CSI_ICS__r.Sales_Channel__c,
                                           CSI_ICS__r.Show_Occur__r.Name, CSI_ICS__r.Show_Occur__r.Show_Name__c, CSI_ICS__r.Show_Occur__r.Show_Name__r.Name,
                                           CSI_ICS__r.Booth_Area__c, 
                                           Billing_ID__c, Sales_Order__c, Credit_LOB__c, Credit_Memo_Reason__c, 
                                           LOB_Approver_Email_ID__c, F_R_Approver_Email_ID__c,
                                           AR1_Approver_Email_ID__c, AR2_Approver_Email_ID__c, Additional_Approver_Email_ID__c,
                                           LOB_Approver_Name__c, LOB_Approver_Name__r.Name, LOB_Approver_Name__r.Email_Address__c,
                                           F_R_Approver_Name__c, F_R_Approver_Name__r.Name, F_R_Approver_Name__r.Email_Address__c,
                                           AR1_Approver_Name__c, AR1_Approver_Name__r.Name, AR1_Approver_Name__r.Email_Address__c,
                                           AR2_Approver_Name__c, AR2_Approver_Name__r.Name, AR2_Approver_Name__r.Email_Address__c,
                                           Additional_Approver_Name__c, Additional_Approver_Name__r.Name, Additional_Approver_Name__r.Email_Address__c,
                                           LOB__c, F_R_Approver_Status__c, AR1_Approver_Status__c, AR2_Approver_Status__c, Additional_Approver_Status__c,
                                           Del_AR1_Approver__c, Del_AR2_Approver__c, Del_F_R_Approver__c, Del_LOB_Approver__c, Del_Additional_Approver__c,
                                           Del_AR1_Approver__r.Name, Del_AR2_Approver__r.Name, Del_F_R_Approver__r.Name, Del_LOB_Approver__r.Name, 
                                           Del_Additional_Approver__r.Name, Amount_w_psp__c, Tax_Amount__c, Total_Amount__c, Justification_for_Credit_Memo_Request__c,
                                           Del_CSO_Approver__c, Del_CSO_Approver__r.Name,   CSO_Approver_Status__c, 
                                            CSO_Approver_Name__c, CSO_Approver_Name__r.Name,CSO_Approver_Email__c,CSO_Approver_Name__r.Email_Address__c,
                                            CSI_ICS__r.Account_Name__c, CSI_ICS__r.Oracle_AR_Customer_Number__c
                                          // CSI_ICS__r.Customer_Name__c,CSI_ICS__r.Customer__c, 
                                           FROM Credit_Memo_ICS__c
                                           WHERE CSI_ICS__c IN: customerServiceRequestId];
        return cmList;
    }
    
    public static List<Receipt_Reversals__c> getReceiptReversals(Set<Id> customerServiceRequestId) {
        List<Receipt_Reversals__c> rrList = [SELECT Id, Name, CSI_ICS__c,CSI_ICS__r.Name, CSI_ICS__r.Case_Requestor__c, CSI_ICS__r.Case_Requestor__r.Name,
                                             CSI_ICS__r.Title__c, CSI_ICS__r.Department__c, 
                                             CSI_ICS__r.Show_Occur__c, CSI_ICS__r.Case_Requestor_Email_ID__c, CSI_ICS__r.Opportunity_Name__r.Name,
                                            CSI_ICS__r.Project__c, CSI_ICS__r.Sales_Channel__c, Payment_Method__c, Receipt_Number__c, Reason__c,
                                            CSI_ICS__r.Show_Occur__r.Name, CSI_ICS__r.Show_Occur__r.Show_Name__c, CSI_ICS__r.Show_Occur__r.Show_Name__r.Name,
                                            CSI_ICS__r.Booth_Area__c,Sales_Order__c,Receipt_Reversal_Amount__c,
                                             Approver_Email__c,
                                             Additional_Approver_Name__c, Additional_Approver_Name__r.Name, Additional_Approver_Name__r.Email_Address__c,
                                             Approver_Status__c, Del_Additional_Approver__c, Del_Additional_Approver__r.Name, Justification_for_Receipt_Rvsl_Request__c,
                                             CSI_ICS__r.Account_Name__c, CSI_ICS__r.Oracle_AR_Customer_Number__c
                                             //CSI_ICS__r.Customer_Name__c, CSI_ICS__r.Customer__c,
                                             FROM Receipt_Reversals__c
                                             WHERE CSI_ICS__c IN: customerServiceRequestId];
        return rrList;
    }
    
    public static List<Refunds_ICS__c> getRefunds(Set<Id> customerServiceRequestId) {
        List<Refunds_ICS__c> refundsList = [SELECT Id, Name, CSI_ICS__c, CSI_ICS__r.Name, CSI_ICS__r.Case_Requestor__c, CSI_ICS__r.Case_Requestor__r.Name,
                                            CSI_ICS__r.Title__c, CSI_ICS__r.Department__c, 
                                           CSI_ICS__r.Show_Occur__c,CSI_ICS__r.Case_Requestor_Email_ID__c, CSI_ICS__r.Opportunity_Name__r.Name,
                                            CSI_ICS__r.Project__c, CSI_ICS__r.Sales_Channel__c,
                                            CSI_ICS__r.Show_Occur__r.Name, CSI_ICS__r.Show_Occur__r.Show_Name__c, CSI_ICS__r.Show_Occur__r.Show_Name__r.Name,
                                            CSI_ICS__r.Booth_Area__c,Sales_Order__c, Sales_Receipt__c, Amount__c,                                           
                                            Pymt_Type__c, AR1_Approver_Email_ID__c, AR2_Approver_Email_ID__c,
                                            AR1_Approver_Name__c, AR1_Approver_Name__r.Name, AR1_Approver_Name__r.Email_Address__c,
                                            AR2_Approver_Name__c, AR2_Approver_Name__r.Name,AR2_Approver_Name__r.Email_Address__c,
                                            AR1_Approver_Status__c, AR2_Approver_Status__c, Del_AR1_Approver__c, Del_AR2_Approver__c,
                                            Del_AR1_Approver__r.Name, Del_AR2_Approver__r.Name, Justification_for_Refunds_Request__c,
                                            Del_CSO_Approver__c, Del_CSO_Approver__r.Name, CSO_Approver_Status__c,  
                                            CSO_Approver_Name__c, CSO_Approver_Name__r.Name,CSO_Approver_Name__r.Email_Address__c,
                                             CSI_ICS__r.Account_Name__c, CSI_ICS__r.Oracle_AR_Customer_Number__c,CSO_Approver_EmailID__c
                                            // CSI_ICS__r.Customer__c, CSI_ICS__r.Customer_Name__c, 
                                            FROM Refunds_ICS__c
                                            WHERE CSI_ICS__c IN: customerServiceRequestId];
        return refundsList;
    }
    
    public static List<Attachment> getAttachments(Set<Id> setParentIds) {
        List<Attachment> listAttachment = [select ParentId, Name, Body from Attachment where ParentId IN: setParentIds];
        return listAttachment;
    }
    
    public pagereference delegateApproval() {
        string delegatedEmail = ApexPages.currentpage().getParameters().get('delegateEmail');
        string approverStage = ApexPages.currentpage().getParameters().get('approverstage');
        string transactionType = ApexPages.currentpage().getParameters().get('transactionType');
        string index = ApexPages.currentpage().getParameters().get('index');
        system.debug('delegatedEmail==='+delegatedEmail);
        system.debug('approverStage==='+approverStage);
        system.debug('transactionType==='+transactionType);
        system.debug('index==='+index);
        Id delegateUserId;
        String approvalStage;
        Customer_Service_Inquiries_ICS__c csiICS = new Customer_Service_Inquiries_ICS__c();
        Approvers approver = new Approvers();
        Map<String,List<sObject>> emailData = new Map<String,List<sObject>>();
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        if(approverStage == 'LOB') {
            //for(Approvers a : listLOBApprovers) {
                approvalStage = 'LOB';
                integer indexNumber = integer.valueOf(index) - 1;
                Approvers a = listLOBApprovers.get(indexNumber);
                if(a.arAdjustment.AR2_Approver_Name__c == null) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Please select '+ a.transactionType +' Delegate for '+a.recordNumber));
                    return null;
                }
                if(a.approverName.Email_Address__c == delegatedEmail && a.transactionType == transactionType ) {    //&& a.arAdjustment.AR2_Approver_Name__c != null
                    system.debug('aaaa==='+a);
                    approver = a;
                    csiICS = approver.CSI;
                    delegateUserId = approver.arAdjustment.AR2_Approver_Name__c;
                    if(approver.approvalObj.getSobjectType() == Schema.AR_Adjustments__c.getSObjectType()) {
                        AR_Adjustments__c arAdj = (AR_Adjustments__c)approver.approvalObj;
                        arAdj.Del_DAM_LOB_Approver__c = delegateUserId;
                    } else
                    if(approver.approvalObj.getSobjectType() == Schema.Credit_Memo_ICS__c.getSObjectType()) {
                        Credit_Memo_ICS__c creditMemo = (Credit_Memo_ICS__c)approver.approvalObj;
                        creditMemo.Del_LOB_Approver__c = delegateUserId;
                    }
                   //break;
                }
            //}
        } else
        if(approverStage == 'FR') {
            //for(Approvers a : listFRApprovers) {
                approvalStage = 'FRR';
                integer indexNumber = integer.valueOf(index) - 1;
                Approvers a = listFRApprovers.get(indexNumber);
                if(a.arAdjustment.AR2_Approver_Name__c == null) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Please select '+ a.transactionType +' Delegate for '+a.recordNumber));
                    return null;
                }
                if(a.approverName.Email_Address__c == delegatedEmail && a.transactionType == transactionType) {
                    approver = a;
                    csiICS = approver.CSI;
                    delegateUserId = approver.arAdjustment.AR2_Approver_Name__c;
                    if(approver.approvalObj.getSobjectType() == Schema.AR_Adjustments__c.getSObjectType()) {
                        AR_Adjustments__c arAdj = (AR_Adjustments__c)approver.approvalObj;
                        arAdj.Del_F_R_Approver__c = delegateUserId;
                    } else
                    if(approver.approvalObj.getSobjectType() == Schema.Credit_Memo_ICS__c.getSObjectType()) {
                        Credit_Memo_ICS__c creditMemo = (Credit_Memo_ICS__c)approver.approvalObj;
                        creditMemo.Del_F_R_Approver__c = delegateUserId;
                    }
                    //break;
                }
            //}
        } else
        if(approverStage == 'AR1') {
            //for(Approvers a : listAR1Approvers) {
                approvalStage = 'AR1';
                integer indexNumber = integer.valueOf(index) - 1;
                Approvers a = listAR1Approvers.get(indexNumber);
                if(a.arAdjustment.AR2_Approver_Name__c == null) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Please select '+ a.transactionType +' Delegate for '+a.recordNumber));
                    return null;
                }
                if(a.approverName.Email_Address__c == delegatedEmail && a.transactionType == transactionType) {
                    approver = a;
                    csiICS = approver.CSI;
                    delegateUserId = approver.arAdjustment.AR2_Approver_Name__c;
                    if(approver.approvalObj.getSobjectType() == Schema.AR_Adjustments__c.getSObjectType()) {
                        AR_Adjustments__c arAdj = (AR_Adjustments__c)approver.approvalObj;
                        arAdj.Del_AR1_Approver__c = delegateUserId;
                    } else
                    if(approver.approvalObj.getSobjectType() == Schema.Credit_Memo_ICS__c.getSObjectType()) {
                        Credit_Memo_ICS__c creditMemo = (Credit_Memo_ICS__c)approver.approvalObj;
                        creditMemo.Del_AR1_Approver__c = delegateUserId;
                    } else
                    if(approver.approvalObj.getSobjectType() == Schema.Refunds_ICS__c.getSObjectType()) {
                        Refunds_ICS__c refund = (Refunds_ICS__c)approver.approvalObj;
                        refund.Del_AR1_Approver__c = delegateUserId;
                    }
                    //break;
                }
            //}
        
        
        } else
        if(approverStage == 'CSO') {
            //for(Approvers a : listCSOApprovers) {
                approvalStage = 'CSO';
                integer indexNumber = integer.valueOf(index) - 1;
                Approvers a = listCSOApprovers.get(indexNumber);
                if(a.arAdjustment.CSO_Approver_Name__c == null) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Please select '+ a.transactionType +' Delegate for '+a.recordNumber));
                    return null;
                }
                if(a.approverName.Email_Address__c == delegatedEmail && a.transactionType == transactionType) {
                    approver = a;
                    csiICS = approver.CSI;
                    delegateUserId = approver.arAdjustment.CSO_Approver_Name__c;
                    if(approver.approvalObj.getSobjectType() == Schema.AR_Adjustments__c.getSObjectType()) {
                        AR_Adjustments__c arAdj = (AR_Adjustments__c)approver.approvalObj;
                        arAdj.Del_CSO_Approver__c = delegateUserId;
                    } else
                    if(approver.approvalObj.getSobjectType() == Schema.Credit_Memo_ICS__c.getSObjectType()) {
                        Credit_Memo_ICS__c creditMemo = (Credit_Memo_ICS__c)approver.approvalObj;
                        creditMemo.Del_CSO_Approver__c = delegateUserId;
                    } else
                    if(approver.approvalObj.getSobjectType() == Schema.Refunds_ICS__c.getSObjectType()) {
                        Refunds_ICS__c refund = (Refunds_ICS__c)approver.approvalObj;
                        refund.Del_CSO_Approver__c = delegateUserId;
                    }
                    //break;
                }   
        
            
            
            
        } else
        if(approverStage == 'AR2') {
            //for(Approvers a : listAR2Approvers) {
                approvalStage = 'AR2';
                integer indexNumber = integer.valueOf(index) - 1;
                Approvers a = listAR2Approvers.get(indexNumber);
                if(a.arAdjustment.AR2_Approver_Name__c == null) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Please select '+ a.transactionType +' Delegate for '+a.recordNumber));
                    return null;
                }
            system.debug('a==='+a.approverName.Email_Address__c+a.transactionType);
            system.debug('from url==='+delegatedEmail+transactionType);
                if(a.approverName.Email_Address__c == delegatedEmail && a.transactionType == transactionType) {
                    approver = a;
                    csiICS = approver.CSI;
                    delegateUserId = approver.arAdjustment.AR2_Approver_Name__c;
                    if(approver.approvalObj.getSobjectType() == Schema.AR_Adjustments__c.getSObjectType()) {
                        AR_Adjustments__c arAdj = (AR_Adjustments__c)approver.approvalObj;
                        arAdj.Del_AR2_Approver__c = delegateUserId;
                    } else
                    if(approver.approvalObj.getSobjectType() == Schema.Credit_Memo_ICS__c.getSObjectType()) {
                        Credit_Memo_ICS__c creditMemo = (Credit_Memo_ICS__c)approver.approvalObj;
                        creditMemo.Del_AR2_Approver__c = delegateUserId;
                    } else
                    if(approver.approvalObj.getSobjectType() == Schema.Refunds_ICS__c.getSObjectType()) {
                        Refunds_ICS__c refund = (Refunds_ICS__c)approver.approvalObj;
                        refund.Del_AR2_Approver__c = delegateUserId;
                    }
                    //break;
                }
            //}
        } else
        if(approverStage == 'Additional Approver') {
            //for(Approvers a : listAdditionalApprovers) {
                approvalStage = 'ADA';
                integer indexNumber = integer.valueOf(index) - 1;
                Approvers a = listAdditionalApprovers.get(indexNumber);
                if(a.arAdjustment.AR2_Approver_Name__c == null) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Please select '+ a.transactionType +' Delegate for '+a.recordNumber));
                    return null;
                }
                if(a.approverName.Email_Address__c == delegatedEmail && a.transactionType == transactionType) {
                    approver = a;
                    csiICS = approver.CSI;
                    delegateUserId = approver.arAdjustment.AR2_Approver_Name__c;
                    if(approver.approvalObj.getSobjectType() == Schema.Credit_Memo_ICS__c.getSObjectType()) {
                        Credit_Memo_ICS__c creditMemo = (Credit_Memo_ICS__c)approver.approvalObj;
                        creditMemo.Del_Additional_Approver__c = delegateUserId;
                    } else
                    if(approver.approvalObj.getSobjectType() == Schema.Receipt_Reversals__c.getSObjectType()) {
                        Receipt_Reversals__c reciptReversal = (Receipt_Reversals__c)approver.approvalObj;
                        reciptReversal.Del_Additional_Approver__c = delegateUserId;
                    }
                    //break;
                }
            //}
        }
        system.debug('delegateUserId==='+delegateUserId);
        if(delegateUserId != null) {
            Employees__c emp = [select Name, Email_Address__c from Employees__c where id =: delegateUserId];
            approver.delegateName = emp.Name;
            if(approver.transactionType == 'AR Adjustment') {
                approverStage = approvalStage+'ARAdjustment';
            } else
            if(approver.transactionType == 'Credit Memo') {
                approverStage = approvalStage+'CreditMemo';
            } else
            if(approver.transactionType == 'Refund') { 
                approverStage = approvalStage+'Refund';
            } else
            if(approver.transactionType == 'Receipt Reversal') {
                approverStage = approvalStage+'ReceiptReversals';
            }
            system.debug('approver.approvalObj==='+approver.approvalObj);
            emailData.put(approver.approverName.Email_Address__c, new List<sObject>{approver.approvalObj});
            mails = ICS_SendEmailClassForApproval.generateEmail(emailData, approverStage, csiICS, approver.recordId, mapAttachments);
            system.debug('mails==='+mails);
            mails[0].setToAddresses(new List<String> {emp.Email_Address__c});
            mails[0].setReplyTo(emp.Email_Address__c);
            if(mails.size()>0){
                try {
                    Messaging.sendEmail(mails);
                    update approver.approvalObj;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,'Email sent to delegate approver for Record '+ approver.recordNumber));
                }
                catch(Exception e) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,e.getMessage()));
                }
            }
        }
        return null;
    }
                
  /*  public static List<AttachmentsWrapper> getAttachments(Set<Id> setParentIds) {
        //List<Attachment> listAttachment = [select ParentId, Name, Body from Attachment where ParentId IN: setParentIds];
        //return listAttachment;
        List<AttachmentsWrapper> listAttachment = new List<AttachmentsWrapper>();
        Map<Id, Id> mapContentDocId = new Map<Id, Id>();
        List<ContentDocumentLink> listContentDocument = [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN: setParentIds];
        for(ContentDocumentLink c : listContentDocument) {
            mapContentDocId.put(c.ContentDocumentId, c.LinkedEntityId);
        }
        for(ContentVersion contentVersion_2 : [SELECT Id, Title, versionData, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN: mapContentDocId.keySet()]) {
            AttachmentsWrapper att = new AttachmentsWrapper();
            att.parentId = mapContentDocId.get(contentVersion_2.ContentDocumentId);
            att.Body = contentVersion_2.versionData;
            att.Name = contentVersion_2.Title;
            listAttachment.add(att);
        }
        return listAttachment;
    }*/
    
    public class ICSCustomerServiceInquiries {
        public Customer_Service_Inquiries_ICS__c CSI {get; set;}
        public String status {get; set;}
    }
    
    public class Approvers {
        public Employees__c approverName {get; set;}
        public string status {get; set;}
        public string approverStage {get; set;}
        public AR_Adjustments__c arAdjustment {get; set;}
        public Customer_Service_Inquiries_ICS__c CSI {get; set;}
        public sObject approvalObj {get; set;}
        public string transactionType {get; set;}
        public string delegateName {get; set;}
        public string recordNumber {get; set;}
        public string recordId {get; set;}
        public string timeStamp {get; set;}
        public Approvers() {
            arAdjustment = new AR_Adjustments__c();
        } 
    }  
                
   /* public class AttachmentsWrapper {
        public Id ParentId;
        public ContentVersion contentVer;
        public String Name;
        public Blob Body;
    }*/
}