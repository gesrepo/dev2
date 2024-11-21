trigger ICS_CaseTrigger on Customer_Service_Inquiries_ICS__c (before update) { 
    
   //Variable Declaration 
    List<Id> caseIds = new List<Id>();   
    Set<Id> setAttachmentParentIds = new Set<Id>();
    Map<Id, List<Attachment>> mapAttachments = new Map<Id, List<Attachment>>();
    //Map<Id, List<VFC_ICSDelegateApprover.AttachmentsWrapper>> mapAttachments = new Map<Id, List<VFC_ICSDelegateApprover.AttachmentsWrapper>>();
    Map<Id,List<sObject>> caseIdTransactionTypeMap = new Map<Id,List<sObject>>();
    Map<String,List<sObject>> emailData = new Map<String,List<sObject>>();
    List<String> emailList = new List<String>();
    Map<Id,String> caseCurrentStage = new Map<Id,String>();
    Map<Id, Boolean> mapCaseStageCheck = new Map<Id, Boolean>();
    
    //Fetching Case Ids
    for(Customer_Service_Inquiries_ICS__c c : trigger.new){
        caseIds.add(c.Id);
        setAttachmentParentIds.add(c.id);
    }
    Map<Id,Customer_Service_Inquiries_ICS__c> mapCases = new Map<Id,Customer_Service_Inquiries_ICS__c>([SELECT Id, Name,
                                                    Case_Approval_Status__c,
                                                     Case_Requestor_Email_ID__c, Case_Requestor__r.Name,
                                                     //Customer_Name__c,Customer__c,
                                                     Account_Name__r.Name ,Oracle_AR_Customer_Number__c,Department__c,Title__c,
                                                     Show_Occur__c, Show_Occur__r.Name, 
                                                     Project__c, Sales_Channel__c, Opportunity_Name__c, Opportunity_Name__r.Name,
                                                     Show_Occur__r.Show_Name__c, Show_Occur__r.Show_Name__r.Name,
                                                     Booth_Area__c,Credit_Memo_Total_Amount__c,Adjustment_Total_Amt__c,
                                                     Charges_Total_Amount__c,Payemnt_Transfer_Total_Amount__c,
                                                     Refunds_Total_Amount__c,Receipt_Reversal_Total_Amount__c,
                                                     Priority__c, Case_Requestor__r.First_Name__c, Case_Requestor__r.Last_Name__c,
                                                     Owner.Email
                                                     FROM Customer_Service_Inquiries_ICS__c
                                                     WHERE Id IN : caseIds
                                                    ]);
     
    //Fetching all Transaction Types for all Case Ids
    List<AR_Adjustments__c> arList = [SELECT Id, Name, AR_Adj_CSI_ID__c,CSO_Approver_Email__c,
                                          Billing_ID__c, Sales_Order__c, Activity_Name__c, 
                                            Amount__c,Justification_for_AR_Adjustment_Request__c,   
                                        Total_AR_Currency__c,
                                           DAM_Approver_Email_ID__c, F_A_Approver_Email__c,
                                          AR1_Approver_Email__c, AR2_Approver_Email__c FROM AR_Adjustments__c
                                          WHERE AR_Adj_CSI_ID__c IN: caseIds
                                        ];
        List<Charges__c> chargesList = [SELECT Id, Name, CSI_ICS__c,
                                        Sales_Order__c, Sales_Receipt__c, 
                                        Total_Amount__c, Justification_for_Charges_Request__c,
                                        Pymt_Type__c, Total_Charges_Currency__c
                                        FROM Charges__c
                                        WHERE CSI_ICS__c IN: caseIds
                                       ];
        List<Credit_Memo_ICS__c> cmList = [SELECT Id, Name, CSI_ICS__c,CSO_Approver_Email__c,
                                           Billing_ID__c, Sales_Order__c, Credit_LOB__c, Credit_Memo_Reason__c,
                                            Amount_w_psp__c, Tax_Amount__c, Total_Amount__c,Total_CM_Curreny__c,
                                           LOB_Approver_Email_ID__c, F_R_Approver_Email_ID__c,
                                           AR1_Approver_Email_ID__c, AR2_Approver_Email_ID__c, Additional_Approver_Email_ID__c
                                           ,Justification_for_Credit_Memo_Request__c
                                           FROM Credit_Memo_ICS__c
                                           WHERE CSI_ICS__c IN: caseIds
                                          ];
        List<Receipt_Reversals__c> rrList = [SELECT Id, Name, CSI_ICS__c,
                                             Sales_Order__c, Justification_for_Receipt_Rvsl_Request__c,
                                             Receipt_Reversal_Amount__c,
                                             Total_Receipt_Reversal_Currency__c,
                                             Payment_Method__c, Receipt_Number__c, Reason__c,
                                             Approver_Email__c
                                             FROM Receipt_Reversals__c
                                             WHERE CSI_ICS__c IN: caseIds
                                            ];
        List<Refunds_ICS__c> refundsList = [SELECT Id, Name, CSI_ICS__c,CSO_Approver_EmailID__c,
                                            Sales_Order__c, Sales_Receipt__c, Total_Refunds_Currency__c,
                                            Amount__c,
                                            Justification_for_Refunds_Request__c,
                                            Pymt_Type__c, AR1_Approver_Email_ID__c, AR2_Approver_Email_ID__c
                                            FROM Refunds_ICS__c
                                            WHERE CSI_ICS__c IN: caseIds
                                           ];
        List<Payment_Transfer_ICS__c> paymentList = [SELECT Id, Name, CSI_ICS_No__c,
                                                     Sales_Order__c, Justification_for_Pymt_Transfer_Request__c,
                                                     Transfer_Amount__c, Total_Payments_Currency__c,
                                                     Receipt__c
                                                     FROM Payment_Transfer_ICS__c
                                                     WHERE CSI_ICS_No__c IN: caseIds
                                                    ];
    
    //Mapping each Transaction Type to corresponding Case
    for(AR_Adjustments__c ar : arList){
        if(caseIdTransactionTypeMap.containsKey(ar.AR_Adj_CSI_ID__c)){
            caseIdTransactionTypeMap.get(ar.AR_Adj_CSI_ID__c).add(ar);
        }else{
            caseIdTransactionTypeMap.put(ar.AR_Adj_CSI_ID__c, new List<sObject> {ar});
        }
    }
    for(Charges__c c : chargesList){
        if(caseIdTransactionTypeMap.containsKey(c.CSI_ICS__c)){
            caseIdTransactionTypeMap.get(c.CSI_ICS__c).add(c);
        }else{
            caseIdTransactionTypeMap.put(c.CSI_ICS__c, new List<sObject> {c});
        }
    }
    for(Credit_Memo_ICS__c cm : cmList){
        if(caseIdTransactionTypeMap.containsKey(cm.CSI_ICS__c)){
            caseIdTransactionTypeMap.get(cm.CSI_ICS__c).add(cm);
        }else{
            caseIdTransactionTypeMap.put(cm.CSI_ICS__c, new List<sObject> {cm});
        }
    }
    for(Receipt_Reversals__c rr : rrList){
        if(caseIdTransactionTypeMap.containsKey(rr.CSI_ICS__c)){
            caseIdTransactionTypeMap.get(rr.CSI_ICS__c).add(rr);
        }else{
            caseIdTransactionTypeMap.put(rr.CSI_ICS__c, new List<sObject> {rr});
        }
    }
    for(Refunds_ICS__c r : refundsList){
        if(caseIdTransactionTypeMap.containsKey(r.CSI_ICS__c)){
            caseIdTransactionTypeMap.get(r.CSI_ICS__c).add(r);
        }else{
            caseIdTransactionTypeMap.put(r.CSI_ICS__c, new List<sObject> {r});
        }
    }
    for(Payment_Transfer_ICS__c p : paymentList){
        if(caseIdTransactionTypeMap.containsKey(p.CSI_ICS_No__c)){
            caseIdTransactionTypeMap.get(p.CSI_ICS_No__c).add(p);
        }else{
            caseIdTransactionTypeMap.put(p.CSI_ICS_No__c, new List<sObject> {p});
        }
    }
    
    for(Customer_Service_Inquiries_ICS__c c : trigger.new){
       /*if(c.Case_Approval_Status__c == 'Requestor Approved'){
           system.debug('c===='+c);
            caseCurrentStage.put(c.Id, 'LOB');
            for(AR_Adjustments__c ar : arList){
                if(ar.DAM_Approver_Email_ID__c != null){
                    if(emailData.containsKey(ar.DAM_Approver_Email_ID__c)){
                        emailData.get(ar.DAM_Approver_Email_ID__c).add(ar);
                    }else{
                        emailData.put(ar.DAM_Approver_Email_ID__c, new List<sObject> {ar});
                    }
                    setAttachmentParentIds.add(ar.Id);
                }
            }
            for(Credit_Memo_ICS__c cm : cmList){
                if(cm.LOB_Approver_Email_ID__c != null){
                    if(emailData.containsKey(cm.LOB_Approver_Email_ID__c)){
                        emailData.get(cm.LOB_Approver_Email_ID__c).add(cm);
                    }else{
                        emailData.put(cm.LOB_Approver_Email_ID__c, new List<sObject> {cm});
                    }
                    setAttachmentParentIds.add(cm.Id);
                }
            }
            if(emailData.size()==0)
                c.Case_Approval_Status__c = 'LOB Approved';
        }*/
       
       if(emailData.size() == 0 && c.Case_Approval_Status__c == 'LOB Approved') {
            caseCurrentStage.put(c.Id, 'FR');
            system.debug('cdddd===='+c);
            for(AR_Adjustments__c ar : arList){
                if(ar.F_A_Approver_Email__c != null){
                    if(emailData.containsKey(ar.F_A_Approver_Email__c)){
                        emailData.get(ar.F_A_Approver_Email__c).add(ar);
                    }else{
                        emailData.put(ar.F_A_Approver_Email__c, new List<sObject> {ar});
                    }
                    setAttachmentParentIds.add(ar.Id);
                }
            }
            for(Credit_Memo_ICS__c cm : cmList){
                if(cm.F_R_Approver_Email_ID__c != null){
                    if(emailData.containsKey(cm.F_R_Approver_Email_ID__c)){
                        emailData.get(cm.F_R_Approver_Email_ID__c).add(cm);
                    }else{
                        emailData.put(cm.F_R_Approver_Email_ID__c, new List<sObject> {cm});
                    }
                    setAttachmentParentIds.add(cm.Id);
                }
            }
            if(emailData.size()==0)
                c.Case_Approval_Status__c = 'F&R Approved';
        } 
        if(emailData.size()==0 && c.Case_Approval_Status__c == 'F&R Approved'){
            caseCurrentStage.put(c.Id, 'AR1');
            system.debug('cdeee===='+c);
            for(AR_Adjustments__c ar : arList){
                if(ar.AR1_Approver_Email__c != null){
                    if(emailData.containsKey(ar.AR1_Approver_Email__c)){
                        emailData.get(ar.AR1_Approver_Email__c).add(ar);
                    }else{
                        emailData.put(ar.AR1_Approver_Email__c, new List<sObject> {ar});
                    }
                    setAttachmentParentIds.add(ar.Id);
                }
            }
            for(Credit_Memo_ICS__c cm : cmList){
                if(cm.AR1_Approver_Email_ID__c != null){
                    if(emailData.containsKey(cm.AR1_Approver_Email_ID__c)){
                        emailData.get(cm.AR1_Approver_Email_ID__c).add(cm);
                    }else{
                        emailData.put(cm.AR1_Approver_Email_ID__c, new List<sObject> {cm});
                    }
                    setAttachmentParentIds.add(cm.Id);
                }
            }
            for(Refunds_ICS__c r : refundsList){
                if(r.AR1_Approver_Email_ID__c != null){
                    if(emailData.containsKey(r.AR1_Approver_Email_ID__c)){
                        emailData.get(r.AR1_Approver_Email_ID__c).add(r);
                    }else{
                        emailData.put(r.AR1_Approver_Email_ID__c, new List<sObject> {r});
                    }
                    setAttachmentParentIds.add(r.Id);
                }
            }
            if(emailData.size()==0)
                c.Case_Approval_Status__c = 'AR1 Approved';
        }
        
        
         if(emailData.size()==0 && c.Case_Approval_Status__c == 'AR1 Approved'){
            caseCurrentStage.put(c.Id, 'CSO');
            system.debug('cssss===='+c);
            for(AR_Adjustments__c ar : arList){
                if(ar.CSO_Approver_Email__c != null){
                    if(emailData.containsKey(ar.CSO_Approver_Email__c)){
                        emailData.get(ar.CSO_Approver_Email__c).add(ar);
                    }else{
                        emailData.put(ar.CSO_Approver_Email__c, new List<sObject> {ar});
                    }
                    setAttachmentParentIds.add(ar.Id);
                }
            }
            for(Credit_Memo_ICS__c cm : cmList){
                if(cm.CSO_Approver_Email__c != null){
                    if(emailData.containsKey(cm.CSO_Approver_Email__c)){
                        emailData.get(cm.CSO_Approver_Email__c).add(cm);
                    }else{
                        emailData.put(cm.CSO_Approver_Email__c, new List<sObject> {cm});
                    }
                    setAttachmentParentIds.add(cm.Id);
                }
            }
            for(Refunds_ICS__c r : refundsList){
                if(r.CSO_Approver_EmailID__c != null){
                    if(emailData.containsKey(r.CSO_Approver_EmailID__c)){
                        emailData.get(r.CSO_Approver_EmailID__c).add(r);
                    }else{
                        emailData.put(r.CSO_Approver_EmailID__c, new List<sObject> {r});
                    }
                    setAttachmentParentIds.add(r.Id);
                }
            }
            if(emailData.size()==0)
                c.Case_Approval_Status__c = 'CSO Approved';
        }
        
        
        
        
        
        if(emailData.size()==0 && c.Case_Approval_Status__c == 'CSO Approved'){
            caseCurrentStage.put(c.Id, 'AR2');
            for(AR_Adjustments__c ar : arList){
                if(ar.AR2_Approver_Email__c != null){
                    if(emailData.containsKey(ar.AR2_Approver_Email__c)){
                        emailData.get(ar.AR2_Approver_Email__c).add(ar);
                    }else{
                        emailData.put(ar.AR2_Approver_Email__c, new List<sObject> {ar});
                    }
                    setAttachmentParentIds.add(ar.Id);
                }
            }
            for(Credit_Memo_ICS__c cm : cmList){
                if(cm.AR2_Approver_Email_ID__c != null){
                    if(emailData.containsKey(cm.AR2_Approver_Email_ID__c)){
                        emailData.get(cm.AR2_Approver_Email_ID__c).add(cm);
                    }else{
                        emailData.put(cm.AR2_Approver_Email_ID__c, new List<sObject> {cm});
                    }
                    setAttachmentParentIds.add(cm.Id);
                }
            }
            for(Refunds_ICS__c r : refundsList){
                if(r.AR2_Approver_Email_ID__c != null){
                    if(emailData.containsKey(r.AR2_Approver_Email_ID__c)){
                        emailData.get(r.AR2_Approver_Email_ID__c).add(r);
                    }else{
                        emailData.put(r.AR2_Approver_Email_ID__c, new List<sObject> {r});
                    }
                    setAttachmentParentIds.add(r.Id);
                }
            }
            if(emailData.size()==0)
                c.Case_Approval_Status__c = 'AR2 Approved';
        }
        if(emailData.size()==0 && c.Case_Approval_Status__c == 'AR2 Approved'){
            caseCurrentStage.put(c.Id, 'ADDITIONAL');
            for(Credit_Memo_ICS__c cm : cmList){
                if(cm.Additional_Approver_Email_ID__c != null){
                    if(emailData.containsKey(cm.Additional_Approver_Email_ID__c)){
                        emailData.get(cm.Additional_Approver_Email_ID__c).add(cm);
                    }else{
                        emailData.put(cm.Additional_Approver_Email_ID__c, new List<sObject> {cm});
                    }
                    setAttachmentParentIds.add(cm.Id);
                }
            }
            for(Receipt_Reversals__c rr : rrList){
                if(rr.Approver_Email__c != null){
                    if(emailData.containsKey(rr.Approver_Email__c)){
                        emailData.get(rr.Approver_Email__c).add(rr);
                    }else{
                        emailData.put(rr.Approver_Email__c, new List<sObject> {rr});
                    }
                    setAttachmentParentIds.add(rr.Id);
                }
            }
            if(emailData.size()==0)
                c.Case_Approval_Status__c = 'Case Approved';
        }
    }
    if(setAttachmentParentIds.size() > 0) {
        for(Attachment att : VFC_ICSDelegateApprover.getAttachments(setAttachmentParentIds)) {
            if(!mapAttachments.containsKey(att.ParentId)) {
                mapAttachments.put(att.ParentId, new List<Attachment>());
            }
            mapAttachments.get(att.ParentId).add(att);
        }
        system.debug('setAttachmentParentIds==='+setAttachmentParentIds);
       /* for(VFC_ICSDelegateApprover.AttachmentsWrapper att : VFC_ICSDelegateApprover.getAttachments(setAttachmentParentIds)) {
            if(!mapAttachments.containsKey(att.ParentId)) {
                mapAttachments.put(att.ParentId, new List<VFC_ICSDelegateApprover.AttachmentsWrapper>());
            }
            mapAttachments.get(att.ParentId).add(att);
        } */
        system.debug('mapAttachments==='+mapAttachments);
    }
    for(Customer_Service_Inquiries_ICS__c caseDetail : trigger.new){
        SYSTEM.DEBUG('caseCurrentStage.get(caseDetail.Id) '+caseCurrentStage.get(caseDetail.Id));
        if(caseCurrentStage.get(caseDetail.Id) != null){
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            if(emailData.size()>0){
                system.debug('emailData '+emailData.size());
                mails = ICS_SendEmailClassForApproval.generateEmail(emailData, 'All', mapCases.get(caseDetail.Id), '', mapAttachments);
            }
            if(mails.size()>0){
                Messaging.sendEmail(mails);
                if(caseCurrentStage.get(caseDetail.Id) == 'LOB') {
                    caseDetail.Case_Approval_Status__c = 'LOB Submitted';
                } else if(caseCurrentStage.get(caseDetail.Id) == 'FR') {
                    caseDetail.Case_Approval_Status__c = 'F&R Submitted';
                } else if(caseCurrentStage.get(caseDetail.Id) == 'AR1') {
                    caseDetail.Case_Approval_Status__c = 'AR1 Submitted';
                } else if(caseCurrentStage.get(caseDetail.Id) == 'CSO') {
                    caseDetail.Case_Approval_Status__c = 'CSO Submitted';                       
                } else if(caseCurrentStage.get(caseDetail.Id) == 'AR2') {
                    caseDetail.Case_Approval_Status__c = 'AR2 Submitted';
                } else if(caseCurrentStage.get(caseDetail.Id) == 'ADDITIONAL') {
                    caseDetail.Case_Approval_Status__c = 'Additional Submitted';
                }
            }
        }
    } 
}