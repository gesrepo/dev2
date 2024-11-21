global class CaseSubmitForApproval {
    
    webservice static void generateEmail(Id caseRecordId){
        Id caseId = caseRecordId;
        Set<Id> setAttachmentParentIds = new Set<Id>();
        setAttachmentParentIds.add(caseRecordId);
        Map<Id, List<Attachment>> mapAttachments = new Map<Id, List<Attachment>>();
        //Map<Id, List<VFC_ICSDelegateApprover.AttachmentsWrapper>> mapAttachments = new Map<Id, List<VFC_ICSDelegateApprover.AttachmentsWrapper>>();
        Customer_Service_Inquiries_ICS__c caseDetail = [SELECT Id, Name,
                                                        Case_Approval_Status__c,
                                                        Case_Requestor__r.Name,
                                                        //Customer_Name__c, Customer__c, 
                                                        Department__c, Title__c,Account_Name__r.Name,
                                                        Oracle_AR_Customer_Number__c,
                                                        Show_Occur__c, Show_Occur__r.Name,
                                                        Show_Occur__r.Show_Name__c, Show_Occur__r.Show_Name__r.Name,
                                                        Booth_Area__c,Project__c,Sales_Channel__c,Opportunity_Name__c,Opportunity_Name__r.Name,
                                                        Requestor_Apporval_Required__c,Credit_Memo_Total_Amount__c,                                                       
                                                        Adjustment_Total_Amt__c,Charges_Total_Amount__c,OwnerId,Owner.Email,
                                                        Payemnt_Transfer_Total_Amount__c,Refunds_Total_Amount__c,
                                                        Receipt_Reversal_Total_Amount__c,Case_Requestor_Email_ID__c,
                                                        Priority__c,Case_Requestor__r.First_Name__c, Case_Requestor__r.Last_Name__c
                                                        FROM Customer_Service_Inquiries_ICS__c
                                                        WHERE Id = : caseId
                                                       ];
        List<AR_Adjustments__c> arList = [SELECT Id, Name, AR_Adj_CSI_ID__c,
                                          Billing_ID__c, Sales_Order__c, Activity_Name__c, Amount__c,
                                          DAM_Approver_Email_ID__c, F_A_Approver_Email__c, 
                                          AR1_Approver_Email__c, AR2_Approver_Email__c,
                                          DAM_Approver_Status__c, F_R_Approvers_Status__c,
                                          AR1_Approver_Status__c, AR2_Approver_Status__c,
                                          Justification_for_AR_Adjustment_Request__c,
                                        Total_AR_Currency__c,
                                          CSO_Approver_Name__c, CSO_Approver_Email__c,
                                         CSO_Approver_Status__c, CSO_Approval_Comments__c,
                                         Del_DAM_LOB_Approver_Email__c,Del_DAM_LOB_Approver__c,
                                         Del_F_R_Approver_Email__c, Del_AR1_Approver_Email__c,
                                         Del_CSO_Approver_Email__c, Del_AR2_Approver_Email__c
                                          FROM AR_Adjustments__c
                                          WHERE AR_Adj_CSI_ID__c =: caseId
                                         ];
        List<Charges__c> chargesList = [SELECT Id, Name, CSI_ICS__c,Total_Charges_Currency__c,
                                        Sales_Order__c, Sales_Receipt__c, Total_Amount__c,
                                        Pymt_Type__c, Justification_for_Charges_Request__c
                                        FROM Charges__c
                                        WHERE CSI_ICS__c =: caseId
                                       ];
        List<Credit_Memo_ICS__c> cmList = [SELECT Id, Name, CSI_ICS__c,
                                           Billing_ID__c, Sales_Order__c,Amount_w_psp__c, 
                                           Tax_Amount__c, Total_Amount__c,   
                                           LOB_Approver_Email_ID__c,F_R_Approver_Email_ID__c,
                                           AR1_Approver_Email_ID__c, AR2_Approver_Email_ID__c,
                                           Additional_Approver_Email_ID__c,Total_CM_Curreny__c,
                                           Credit_LOB__c, Credit_Memo_Reason__c,
                                           LOB__c, F_R_Approver_Status__c, AR1_Approver_Status__c,
                                           AR2_Approver_Status__c, Additional_Approver_Status__c,
                                           Justification_for_Credit_Memo_Request__c,
                                           CSO_Approver_Name__c, CSO_Approver_Email__c,
                                         CSO_Approver_Status__c, CSO_Approval_Comments__c,
                                         Del_LOB_Approver_Email__c, Del_F_R_Approver_Email__c, Del_AR1_Approver_Email__c,
                                          Del_CSO_Approver_Email__c, Del_AR2_Approver_Email__c, Del_Additional_Approver_Email__c
                                           FROM Credit_Memo_ICS__c
                                           WHERE CSI_ICS__c =: caseId
                                          ];
         
        List<Receipt_Reversals__c> rrList = [SELECT Id, Name, CSI_ICS__c,
                                             Sales_Order__c, Receipt_Reversal_Amount__c,
                                             Approver_Email__c,Approver_Status__c,Total_Receipt_Reversal_Currency__c,
                                             Payment_Method__c, Receipt_Number__c, Reason__c ,Justification_for_Receipt_Rvsl_Request__c,
                                             Del_Additional_Approver_Email__c
                                             FROM Receipt_Reversals__c
                                             WHERE CSI_ICS__c =: caseId
                                            ];
        List<Refunds_ICS__c> refundsList = [SELECT Id, Name, CSI_ICS__c,
                                            Sales_Order__c, Sales_Receipt__c, Amount__c,
                                           AR1_Approver_Email_ID__c,
                                            AR2_Approver_Email_ID__c, Pymt_Type__c,
                                            AR1_Approver_Status__c, AR2_Approver_Status__c,
                                            Justification_for_Refunds_Request__c, 
                                            Total_Refunds_Currency__c,
                                            CSO_Approver_Name__c, CSO_Approver_EmailID__c,
                                            CSO_Approver_Status__c, CSO_Approval_Comments__c,
                                            Del_AR1_Approver_Email__c, Del_AR2_Approver_Email__c, Del_CSO_Approver_Email__c
                                            FROM Refunds_ICS__c
                                            WHERE CSI_ICS__c =: caseId
                                           ];
       /*if(refundsList.size() == 0){
            if(Test.isRunningTest() && refundsList.isEmpty()){
            refundsList.add(TestDataUtil.createTestRefund(caseId));
          }
        }*/
        
        //System.debug('arList ICS List '+cmList[0].LOB_Approver_Email_ID__c);
        List<Payment_Transfer_ICS__c> paymentList = [SELECT Id, Name, CSI_ICS_No__c,Total_Payments_Currency__c,
                                                     Sales_Order__c, Transfer_Amount__c,
                                                     Receipt__c, Justification_for_Pymt_Transfer_Request__c
                                                     FROM Payment_Transfer_ICS__c
                                                     WHERE CSI_ICS_No__c =: caseId
                                                    ];
        Map<String,List<sObject>> emailData = new Map<String,List<sObject>>();
        //System.debug('lisstttttttttttttttt keyyyyyyyysssssssssssss '+emailData.keySet());
        system.debug('status====='+caseDetail.Case_Approval_Status__c);
        String currentStage = null;
        if((caseDetail.Case_Approval_Status__c == 'Case Open' || caseDetail.Case_Approval_Status__c == 'Requestor Rejected') && (caseDetail.Requestor_Apporval_Required__c == True)) {
            currentStage = 'REQUESTOR';
            system.debug('currentstage===='+currentStage);
            if(caseDetail.Case_Requestor_Email_ID__c != null && caseDetail.Requestor_Apporval_Required__c){
                for(AR_Adjustments__c ar : arList){
                    system.debug('fffffffffffffffffffffffffffff '+caseDetail.Case_Requestor_Email_ID__c);
                    if(emailData.containsKey(caseDetail.Case_Requestor_Email_ID__c)){
                        emailData.get(caseDetail.Case_Requestor_Email_ID__c).add(ar);
                    }else{
                       emailData.put(caseDetail.Case_Requestor_Email_ID__c, new List<sObject> {ar});
                    }
                    setAttachmentParentIds.add(ar.id);
                }
                for(Charges__c c : chargesList){
                    if(emailData.containsKey(caseDetail.Case_Requestor_Email_ID__c)){
                        emailData.get(caseDetail.Case_Requestor_Email_ID__c).add(c);
                    }else{
                        emailData.put(caseDetail.Case_Requestor_Email_ID__c, new List<sObject> {c});
                    }
                    setAttachmentParentIds.add(c.id);
                }
                for(Credit_Memo_ICS__c cm : cmList){
                    if(emailData.containsKey(caseDetail.Case_Requestor_Email_ID__c)){
                        emailData.get(caseDetail.Case_Requestor_Email_ID__c).add(cm);
                    }else{
                        emailData.put(caseDetail.Case_Requestor_Email_ID__c, new List<sObject> {cm});
                    }
                    setAttachmentParentIds.add(cm.id);
                }
                for(Receipt_Reversals__c rr : rrList){
                    if(emailData.containsKey(caseDetail.Case_Requestor_Email_ID__c)){
                        emailData.get(caseDetail.Case_Requestor_Email_ID__c).add(rr);
                    }else{
                        emailData.put(caseDetail.Case_Requestor_Email_ID__c, new List<sObject> {rr});
                    }
                    setAttachmentParentIds.add(rr.id);
                }
                for(Refunds_ICS__c r : refundsList){
                    if(emailData.containsKey(caseDetail.Case_Requestor_Email_ID__c)){
                        emailData.get(caseDetail.Case_Requestor_Email_ID__c).add(r);
                    }else{
                        emailData.put(caseDetail.Case_Requestor_Email_ID__c, new List<sObject> {r});
                    }
                    setAttachmentParentIds.add(r.id);
                }
                for(Payment_Transfer_ICS__c p : paymentList){
                    if(emailData.containsKey(caseDetail.Case_Requestor_Email_ID__c)){
                        emailData.get(caseDetail.Case_Requestor_Email_ID__c).add(p);
                    }else{
                        emailData.put(caseDetail.Case_Requestor_Email_ID__c, new List<sObject> {p});
                    }
                    setAttachmentParentIds.add(p.id);
                }
            }
        }else 
            {
                if(caseDetail.Case_Approval_Status__c == 'Case Open' || caseDetail.Case_Approval_Status__c == 'LOB Open' || caseDetail.Case_Approval_Status__c == 'LOB Rejected' || caseDetail.Case_Approval_Status__c == 'Requestor Approved'){
                    currentStage = 'LOB';
                    system.debug('currentstage===='+currentStage);
                    for(AR_Adjustments__c ar : arList){
                        //system.debug('ar.Del_DAM_LOB_Approver_Email__c==='+ar.Del_DAM_LOB_Approver_Email__c+'===='+ar.DAM_Approver_Status__c);
                        if(ar.Del_DAM_LOB_Approver_Email__c!=null && ar.DAM_Approver_Status__c != 'Approved' ){
                           // system.debug('ar.Del_DAM_LOB_Approver_Email__c==='+ar.Del_DAM_LOB_Approver_Email__c+ar.DAM_Approver_Status__c);
                            if(emailData.containsKey(ar.Del_DAM_LOB_Approver_Email__c)){    //AR LOB Delegation
                                emailData.get(ar.Del_DAM_LOB_Approver_Email__c).add(ar);
                            }else{
                                emailData.put(ar.Del_DAM_LOB_Approver_Email__c, new List<sObject> {ar});
                            }
                            setAttachmentParentIds.add(ar.id);
                        }
                        else{
                            system.debug('ar.DAM_Approver_Email_ID__c=== '+ar.DAM_Approver_Email_ID__c+'---d status-----'+ar.DAM_Approver_Status__c);
                            if(ar.DAM_Approver_Email_ID__c != null && ar.DAM_Approver_Status__c != 'Approved'){     //AR LOB Approval
                                System.debug('coming in nnnnn');
                                if(emailData.containsKey(ar.DAM_Approver_Email_ID__c)){
                                    emailData.get(ar.DAM_Approver_Email_ID__c).add(ar);
                                }else{
                                    emailData.put(ar.DAM_Approver_Email_ID__c, new List<sObject> {ar});
                                }
                                setAttachmentParentIds.add(ar.id);
                            }
                        }
                    }
                for(Credit_Memo_ICS__c cm : cmList){
                    if(cm.Del_LOB_Approver_Email__c != null  && cm.LOB__c != 'Approved'){   //CM LOB Delegation
                        if(emailData.containsKey(cm.Del_LOB_Approver_Email__c)){
                            emailData.get(cm.Del_LOB_Approver_Email__c).add(cm);
                        }else{
                            emailData.put(cm.Del_LOB_Approver_Email__c, new List<sObject> {cm});
                        }
                        setAttachmentParentIds.add(cm.id);
                        system.debug('setAttachmentParentIds==== '+setAttachmentParentIds);
                    }
                    else{
                        if(cm.LOB_Approver_Email_ID__c != null  && cm.LOB__c != 'Approved'){    //CM LOB Approval
                            if(emailData.containsKey(cm.LOB_Approver_Email_ID__c)){
                                emailData.get(cm.LOB_Approver_Email_ID__c).add(cm);
                            }else{
                                emailData.put(cm.LOB_Approver_Email_ID__c, new List<sObject> {cm});
                            }
                            setAttachmentParentIds.add(cm.id);
                            system.debug('setAttachmentParentIds==== '+setAttachmentParentIds);
                        }
                    }
                }
                if(emailData.size() == 0)
                    caseDetail.Case_Approval_Status__c = 'F&R Open';
                }
                if(caseDetail.Case_Approval_Status__c == 'F&R Open' || caseDetail.Case_Approval_Status__c == 'F&R Rejected'){
                    currentstage = 'FR';
                    system.debug('currentstage===='+currentStage);
                    for(AR_Adjustments__c ar : arList){     //AR F&R Delegated approver
                        if(ar.Del_F_R_Approver_Email__c != null && ar.F_R_Approvers_Status__c != 'Approved'){
                            if(emailData.containsKey(ar.Del_F_R_Approver_Email__c)){
                                emailData.get(ar.Del_F_R_Approver_Email__c).add(ar);
                            }else{
                                emailData.put(ar.Del_F_R_Approver_Email__c, new List<sObject> {ar});
                            }
                            system.debug('setAttachmentParentIds==== '+setAttachmentParentIds);
                                setAttachmentParentIds.add(ar.id);
                        }
                        else{
                            if(ar.F_A_Approver_Email__c != null && ar.F_R_Approvers_Status__c != 'Approved'){
                                if(emailData.containsKey(ar.F_A_Approver_Email__c)){    // AR F&R Approver
                                    emailData.get(ar.F_A_Approver_Email__c).add(ar);
                                }else{
                                    emailData.put(ar.F_A_Approver_Email__c, new List<sObject> {ar});
                                }
                                system.debug('setAttachmentParentIds==== '+setAttachmentParentIds);
                                setAttachmentParentIds.add(ar.id);
                            }
                        }
                        setAttachmentParentIds.add(ar.id);
                    }
                    for(Credit_Memo_ICS__c cm : cmList){   
                        if(cm.Del_F_R_Approver_Email__c != null && cm.F_R_Approver_Status__c != 'Approved'){
                            if(emailData.containsKey(cm.Del_F_R_Approver_Email__c)){    //CM F&R Delegated approver
                                emailData.get(cm.Del_F_R_Approver_Email__c).add(cm);
                            }else{
                                emailData.put(cm.Del_F_R_Approver_Email__c, new List<sObject> {cm});
                            }
                            setAttachmentParentIds.add(cm.id);
                        }
                        else{
                            if(cm.F_R_Approver_Email_ID__c != null && cm.F_R_Approver_Status__c != 'Approved'){
                                if(emailData.containsKey(cm.F_R_Approver_Email_ID__c)){     //CM F&R Approver
                                    emailData.get(cm.F_R_Approver_Email_ID__c).add(cm);
                                }else{
                                    emailData.put(cm.F_R_Approver_Email_ID__c, new List<sObject> {cm});
                                }
                                setAttachmentParentIds.add(cm.id);
                            }
                        }
                    }
                    if(emailData.size() == 0)
                        caseDetail.Case_Approval_Status__c = 'AR1 Open';
                }
                if(caseDetail.Case_Approval_Status__c == 'AR1 Open' || caseDetail.Case_Approval_Status__c == 'AR1 Rejected'){
                    currentstage = 'AR1';
                    system.debug('currentstage===='+currentStage);
                    for(AR_Adjustments__c ar : arList){
                         if(ar.Del_AR1_Approver_Email__c != null && ar.AR1_Approver_Status__c != 'Approved'){
                            if(emailData.containsKey(ar.Del_AR1_Approver_Email__c)){    //AR AR1 delegated approver
                                emailData.get(ar.Del_AR1_Approver_Email__c).add(ar);
                            }else{
                                emailData.put(ar.Del_AR1_Approver_Email__c, new List<sObject> {ar});
                            }
                            setAttachmentParentIds.add(ar.id);
                        }
                        else{
                            if(ar.AR1_Approver_Email__c != null && ar.AR1_Approver_Status__c != 'Approved'){
                                if(emailData.containsKey(ar.AR1_Approver_Email__c)){        //AR AR1 approver
                                    emailData.get(ar.AR1_Approver_Email__c).add(ar);
                                }else{
                                    emailData.put(ar.AR1_Approver_Email__c, new List<sObject> {ar});
                                }
                                setAttachmentParentIds.add(ar.id);
                            }
                        }
                    }
                    for(Credit_Memo_ICS__c cm : cmList){
                        if(cm.Del_AR1_Approver_Email__c != null && cm.AR1_Approver_Status__c != 'Approved'){
                            if(emailData.containsKey(cm.Del_AR1_Approver_Email__c)){    //CM AR1 delegated approver
                                emailData.get(cm.Del_AR1_Approver_Email__c).add(cm);
                            }else{
                                emailData.put(cm.Del_AR1_Approver_Email__c, new List<sObject> {cm});
                            }
                            setAttachmentParentIds.add(cm.id);
                        }
                        else{
                            if(cm.AR1_Approver_Email_ID__c != null && cm.AR1_Approver_Status__c != 'Approved'){
                                if(emailData.containsKey(cm.AR1_Approver_Email_ID__c)){     //CM AR1 approver
                                    emailData.get(cm.AR1_Approver_Email_ID__c).add(cm);
                                }else{
                                    emailData.put(cm.AR1_Approver_Email_ID__c, new List<sObject> {cm});
                                }
                                setAttachmentParentIds.add(cm.id);
                            }
                        }
                    }
                    for(Refunds_ICS__c r : refundsList){
                        if(r.Del_AR1_Approver_Email__c != null && r.AR1_Approver_Status__c != 'Approved'){
                            if(emailData.containsKey(r.Del_AR1_Approver_Email__c)){     //refunds AR1 delegated approver
                                emailData.get(r.Del_AR1_Approver_Email__c).add(r);
                            }else{
                                emailData.put(r.Del_AR1_Approver_Email__c, new List<sObject> {r});
                            }
                            setAttachmentParentIds.add(r.id);
                        }
                        else{
                            if(r.AR1_Approver_Email_ID__c != null && r.AR1_Approver_Status__c != 'Approved'){
                                if(emailData.containsKey(r.AR1_Approver_Email_ID__c)){      //refuds AR1 approver
                                    emailData.get(r.AR1_Approver_Email_ID__c).add(r);
                                }else{
                                    emailData.put(r.AR1_Approver_Email_ID__c, new List<sObject> {r});
                                }
                                setAttachmentParentIds.add(r.id);
                            }
                        }
                    }
                    if(emailData.size() == 0)
                        caseDetail.Case_Approval_Status__c = 'CSO Open';
                }
                if(caseDetail.Case_Approval_Status__c == 'CSO Open' || caseDetail.Case_Approval_Status__c == 'CSO Rejected'){
                    currentstage = 'CSO';
                    system.debug('currentstage===='+currentStage);
                    for(AR_Adjustments__c ar : arList){
                        if(ar.Del_CSO_Approver_Email__c != null && ar.CSO_Approver_Status__c != 'Approved'){
                            if(emailData.containsKey(ar.Del_CSO_Approver_Email__c)){    //AR CSo Delegted approver
                                emailData.get(ar.Del_CSO_Approver_Email__c).add(ar);
                            }else{
                                emailData.put(ar.Del_CSO_Approver_Email__c, new List<sObject> {ar});
                            }
                            setAttachmentParentIds.add(ar.id);
                        }
                        else{
                            if(ar.CSO_Approver_Email__c != null && ar.CSO_Approver_Status__c != 'Approved'){
                                if(emailData.containsKey(ar.CSO_Approver_Email__c)){        // AR CSO Approver
                                    emailData.get(ar.CSO_Approver_Email__c).add(ar);
                                }else{
                                    emailData.put(ar.CSO_Approver_Email__c, new List<sObject> {ar});
                                }
                                setAttachmentParentIds.add(ar.id);
                            }
                        }
                    }
                    for(Credit_Memo_ICS__c cm : cmList){
                        if(cm.Del_CSO_Approver_Email__c != null && cm.CSO_Approver_Status__c != 'Approved'){
                            if(emailData.containsKey(cm.Del_CSO_Approver_Email__c)){    //credit memo CSO delegated approver
                                emailData.get(cm.Del_CSO_Approver_Email__c).add(cm);
                            }else{
                                emailData.put(cm.Del_CSO_Approver_Email__c, new List<sObject> {cm});
                            }
                            setAttachmentParentIds.add(cm.id);
                        }
                        else{
                            if(cm.CSO_Approver_Email__c != null && cm.CSO_Approver_Status__c != 'Approved'){
                                if(emailData.containsKey(cm.CSO_Approver_Email__c)){    //credit memo CSO approver
                                    emailData.get(cm.CSO_Approver_Email__c).add(cm);
                                }else{
                                    emailData.put(cm.CSO_Approver_Email__c, new List<sObject> {cm});
                                }
                                setAttachmentParentIds.add(cm.id);
                            }
                        }
                    }
                    for(Refunds_ICS__c r : refundsList){
                        if(r.Del_CSO_Approver_Email__c != null && r.CSO_Approver_Status__c != 'Approved'){
                            if(emailData.containsKey(r.Del_CSO_Approver_Email__c)){     //refunds CSO delegated approver
                                emailData.get(r.Del_CSO_Approver_Email__c).add(r);
                            }else{
                                emailData.put(r.Del_CSO_Approver_Email__c, new List<sObject> {r});
                            }
                            setAttachmentParentIds.add(r.id);
                        }
                        else{
                            if(r.CSO_Approver_EmailID__c != null && r.CSO_Approver_Status__c != 'Approved'){
                                if(emailData.containsKey(r.CSO_Approver_EmailID__c)){ //refunds CSO delegated approver
                                    emailData.get(r.CSO_Approver_EmailID__c).add(r);
                                }else{
                                    emailData.put(r.CSO_Approver_EmailID__c, new List<sObject> {r});
                                }
                                setAttachmentParentIds.add(r.id);
                            }
                        }
                    }     
                    if(emailData.size() == 0)
                        caseDetail.Case_Approval_Status__c = 'AR2 Open'; 
                    
                    
                    
                }
                if(caseDetail.Case_Approval_Status__c == 'AR2 Open' || caseDetail.Case_Approval_Status__c == 'AR2 Rejected'){
                    currentstage = 'AR2';
                    system.debug('currentstage====='+currentStage);
                    for(AR_Adjustments__c ar : arList){
                        if(ar.Del_AR2_Approver_Email__c != null && ar.AR2_Approver_Status__c != 'Approved'){
                            if(emailData.containsKey(ar.Del_AR2_Approver_Email__c)){    //AR AR2 delegated approver
                                emailData.get(ar.Del_AR2_Approver_Email__c).add(ar);
                            }else{
                                emailData.put(ar.Del_AR2_Approver_Email__c, new List<sObject> {ar});
                            }
                            setAttachmentParentIds.add(ar.id);
                        }
                        else{
                            if(ar.AR2_Approver_Email__c != null && ar.AR2_Approver_Status__c != 'Approved'){
                                if(emailData.containsKey(ar.AR2_Approver_Email__c)){        //AR AR2 approver
                                    emailData.get(ar.AR2_Approver_Email__c).add(ar);
                                }else{
                                    emailData.put(ar.AR2_Approver_Email__c, new List<sObject> {ar});
                                }
                                setAttachmentParentIds.add(ar.id);
                            }
                        }
                    }
                    for(Credit_Memo_ICS__c cm : cmList){
                        if(cm.Del_AR2_Approver_Email__c != null && cm.AR2_Approver_Status__c != 'Approved'){
                            if(emailData.containsKey(cm.Del_AR2_Approver_Email__c)){    // credit memo AR2 delegated approver
                                emailData.get(cm.Del_AR2_Approver_Email__c).add(cm);
                            }else{
                                emailData.put(cm.Del_AR2_Approver_Email__c, new List<sObject> {cm});
                            }
                            setAttachmentParentIds.add(cm.id);
                        }
                        else{
                            if(cm.AR2_Approver_Email_ID__c != null && cm.AR2_Approver_Status__c != 'Approved'){
                                if(emailData.containsKey(cm.AR2_Approver_Email_ID__c)){     // credit memo AR2 approver
                                    emailData.get(cm.AR2_Approver_Email_ID__c).add(cm);
                                }else{
                                    emailData.put(cm.AR2_Approver_Email_ID__c, new List<sObject> {cm});
                                }
                                setAttachmentParentIds.add(cm.id);
                            }
                        }
                    }
                    for(Refunds_ICS__c r : refundsList){
                        if(r.Del_AR2_Approver_Email__c != null && r.AR2_Approver_Status__c != 'Approved'){
                            if(emailData.containsKey(r.Del_AR2_Approver_Email__c)){     //refunds AR2 delegated approver
                                emailData.get(r.Del_AR2_Approver_Email__c).add(r);
                            }else{
                                emailData.put(r.Del_AR2_Approver_Email__c, new List<sObject> {r});
                            }
                            setAttachmentParentIds.add(r.id);
                        }
                        else{
                            if(r.AR2_Approver_Email_ID__c != null && r.AR2_Approver_Status__c != 'Approved'){
                                if(emailData.containsKey(r.AR2_Approver_Email_ID__c)){      //refunds AR2 approver
                                    emailData.get(r.AR2_Approver_Email_ID__c).add(r);
                                }else{
                                    emailData.put(r.AR2_Approver_Email_ID__c, new List<sObject> {r});
                                }
                                setAttachmentParentIds.add(r.id);
                            }
                        }
                    }
                    if(emailData.size() == 0)
                        caseDetail.Case_Approval_Status__c = 'Additional Open'; 
                }
                if(caseDetail.Case_Approval_Status__c == 'Additional Open' || caseDetail.Case_Approval_Status__c == 'Additional Rejected'){
                    currentstage = 'ADDITIONAL';
                    system.debug('currentstage====='+currentStage);
                    System.debug('@@@cmList--Add-->'+cmList);
                    for(Credit_Memo_ICS__c cm : cmList){
                        System.debug('@@@Add-->'+cm.Del_Additional_Approver_Email__c);
                        System.debug('@@@Status-->'+cm.Additional_Approver_Status__c);
                        if(cm.Del_Additional_Approver_Email__c != null && cm.Additional_Approver_Status__c != 'Approved'){
                            if(emailData.containsKey(cm.Del_Additional_Approver_Email__c)){     //credit memo Additional Delegated approver
                                emailData.get(cm.Del_Additional_Approver_Email__c).add(cm);
                            }else{
                                emailData.put(cm.Del_Additional_Approver_Email__c, new List<sObject> {cm});
                            }
                            setAttachmentParentIds.add(cm.id);
                        }
                        else{
                              if(cm.Additional_Approver_Email_ID__c != null && cm.Additional_Approver_Status__c != 'Approved'){
                                if(emailData.containsKey(cm.Additional_Approver_Email_ID__c)){  //credit memo Additional  approver
                                    emailData.get(cm.Additional_Approver_Email_ID__c).add(cm);
                                }else{
                                    emailData.put(cm.Additional_Approver_Email_ID__c, new List<sObject> {cm});
                                }
                                setAttachmentParentIds.add(cm.id);
                            }
                        }
                    }
                    for(Receipt_Reversals__c rr : rrList){
                         if(rr.Del_Additional_Approver_Email__c != null && rr.Approver_Status__c != 'Approved'){
                            if(emailData.containsKey(rr.Del_Additional_Approver_Email__c)){     //Receipt reversal Additional Delegated approver
                                emailData.get(rr.Del_Additional_Approver_Email__c).add(rr);
                            }else{
                                emailData.put(rr.Del_Additional_Approver_Email__c, new List<sObject> {rr});
                            }
                            setAttachmentParentIds.add(rr.id);
                        }
                        else{
                            if(rr.Approver_Email__c!= null && rr.Approver_Status__c != 'Approved'){
                                if(emailData.containsKey(rr.Approver_Email__c)){     //Receipt reversal Additional approver
                                    emailData.get(rr.Approver_Email__c).add(rr);
                                }else{
                                    emailData.put(rr.Approver_Email__c, new List<sObject> {rr});
                                }
                                setAttachmentParentIds.add(rr.id); 
                            }
                        }
                    }
                }
            } 
        
        if(currentStage != null){
            system.debug('currentStage==== '+currentStage);
            if(setAttachmentParentIds.size() > 0) {
                for(Attachment att : VFC_ICSDelegateApprover.getAttachments(setAttachmentParentIds)) {
                    if(!mapAttachments.containsKey(att.ParentId)) {
                        mapAttachments.put(att.ParentId, new List<Attachment>());
                    }
                    mapAttachments.get(att.ParentId).add(att);
                }
                
              /*  for(VFC_ICSDelegateApprover.AttachmentsWrapper att : VFC_ICSDelegateApprover.getAttachments(setAttachmentParentIds)) {
                    if(!mapAttachments.containsKey(att.ParentId)) {
                        mapAttachments.put(att.ParentId, new List<VFC_ICSDelegateApprover.AttachmentsWrapper>());
                    }
                    mapAttachments.get(att.ParentId).add(att);
                }*/
            }
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            if(emailData.size()>0){
                system.debug('emailData '+emailData.size());
                mails = ICS_SendEmailClassForApproval.generateEmail(emailData, 'All', caseDetail, '', mapAttachments);
            }
            system.debug('mails.size()==== '+mails.size());
            if(mails.size()>0){
                Messaging.sendEmail(mails);
                if(currentStage == 'REQUESTOR')
                    caseDetail.Case_Approval_Status__c = 'Requestor Submitted';
                else if(currentStage == 'LOB')
                    caseDetail.Case_Approval_Status__c = 'LOB Submitted';
                else if(currentStage == 'FR')
                    caseDetail.Case_Approval_Status__c = 'F&R Submitted';
                else if(currentstage == 'AR1')
                    caseDetail.Case_Approval_Status__c = 'AR1 Submitted';
                else if(currentstage == 'CSO')
                    caseDetail.Case_Approval_Status__c = 'CSO Submitted';
                else if(currentstage == 'AR2')
                    caseDetail.Case_Approval_Status__c = 'AR2 Submitted';
                else if(currentstage == 'ADDITIONAL')
                    caseDetail.Case_Approval_Status__c = 'Additional Submitted';
                update caseDetail;
            }
        }
    }   
}