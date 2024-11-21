public class ICS_SendEmailClassForApproval {
    
   public static List<Messaging.SingleEmailMessage> generateEmail(Map<String,List<sObject>> emailData, 
                        String currentStage, Customer_Service_Inquiries_ICS__c caseDetail, String recordId,
                        
                        Map<Id,List<Attachment>> mapAttachments){
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        List<Approval_History_ICS__c> ahList = [SELECT Id, Name, Case__c, AR_Adjustments__c, LastModifiedBy.Name,
                                                Charges__c, Credit_Memo__c, Payment_Transfer__c,
                                                Receipt_Reversal__c, Refunds__c, Employee_Name__c,
                                                Employee_Name__r.Name,Transaction_Name__c,
                                                Stage__c, Status__c, Comments__c, Transaction_Amount__c, createdDate
                                                FROM Approval_History_ICS__c
                                                WHERE Case__c =: caseDetail.Id
                                                ORDER BY Transaction_Name__c ASC , createdDate Desc
                                               ];
            for(String mailAddress : emailData.keySet()){
            system.debug(mailAddress+' '+emailData.get(mailAddress));
            List<sObject> arEmailList = new List<sObject>();
            List<sObject> chargesEmailList = new List<sObject>();   
            List<sObject> cmEmailList = new List<sObject>();
            List<sObject> rrEmailList = new List<sObject>();
            List<sObject> refundsEmailList = new List<sObject>();
            List<sObject> paymentsEmailList = new List<sObject>();
            for(sObject s : emailData.get(mailAddress)){
            //for(sObject d : emailData.get(mailAddress))
                system.debug('s==='+s);
                String sObjectType = ''+s.getSObjectType();
                if(sObjectType=='AR_Adjustments__c')
                    arEmailList.add(s);
                if(sObjectType=='Charges__c')
                    chargesEmailList.add(s);
                if(sObjectType=='Credit_Memo_ICS__c')
                    cmEmailList.add(s);
                if(sObjectType=='Receipt_Reversals__c')
                    rrEmailList.add(s);
                if(sObjectType=='Refunds_ICS__c')
                    refundsEmailList.add(s);
                if(sObjectType=='Payment_Transfer_ICS__c')
                    paymentsEmailList.add(s);
            }
            Decimal sumOfTotals=0.00;
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
           // mail.setToAddresses(new List<String> {'BAmarapalli@ges.com'});
           //mail.setToAddresses(new List<String> {caseDetail.Case_Requestor_Email_ID__c});
           List<String> emailAddrList = new List<String>();
           emailAddrList.addAll(emailData.keySet());
           mail.setToAddresses(emailAddrList);                    
           //mail.setReplyTo('soniya.gopu@slkgroup.com');
           mail.setSenderDisplayName(caseDetail.Owner.Email);
           if(caseDetail.priority__c=='Urgent'){
                mail.setSubject('Approval Request (URGENT): '+caseDetail.Account_Name__r.Name +'; ' +caseDetail.Opportunity_Name__r.Name +'; ' +caseDetail.Name );
            }else{
                mail.setSubject('Approval Request: '+caseDetail.Account_Name__r.Name +'; ' +caseDetail.Opportunity_Name__r.Name +'; ' +caseDetail.Name );
            }
            String body = 'Hello ' +caseDetail.Case_Requestor__r.First_Name__c+' '+caseDetail.Case_Requestor__r.Last_Name__c+',<br/>'  ;
            //String body = 'Hello ' +caseDetail.Case_Requestor__r.Last_Name__c+ ',<br/>'  ;
            //String body = 'Hello<br/>' +Messaging.SingleEmailMessage+ ','  ;
            body += '<br/>Please review the below case details and approve/reject the same.<br/>';
            if(caseDetail.Case_Requestor__c != null && caseDetail.Case_Requestor__r.Name != null)
                body += '<br/>Requestor Name: '+caseDetail.Case_Requestor__r.Name+'<br/>';
            if(caseDetail.Department__c != null)
                body += '<br/>Requestor Department: '+caseDetail.Department__c+'<br/>';
            if(caseDetail.Title__c != null)
                body += '<br/>Requestor Title: '+caseDetail.Title__c+'<br/>';
            body += 'Customer Name: '+caseDetail.Account_Name__r.Name+'<br/>';
            if(caseDetail.Oracle_AR_Customer_Number__c != null) 
                body += 'Customer Number: '+caseDetail.Oracle_AR_Customer_Number__c+'<br/>';
            if(caseDetail.Show_Occur__c != null && caseDetail.Show_Occur__r.Name != null)
                body += 'Show Occurrence Name: '+caseDetail.Show_Occur__r.Name+'<br/>';
            if(caseDetail.Show_Occur__c != null && caseDetail.Show_Occur__r.Show_Name__c != null && caseDetail.Show_Occur__r.Show_Name__r.Name != null)
                body += 'Show Name: '+caseDetail.Show_Occur__r.Show_Name__r.Name+'<br/>';
           if(caseDetail.Opportunity_Name__r.Name != null)
                body += 'Show Occurrence: '+caseDetail.Opportunity_Name__r.Name+'<br/>';     
            if(caseDetail.Project__c != null)
                body += 'Project #: '+caseDetail.Project__c+'<br/>';                    
            if(caseDetail.Sales_Channel__c != null)
                body += 'Sales Channel: '+caseDetail.Sales_Channel__c+'<br/>';  
            if(caseDetail.Booth_Area__c != null)
               body += 'Booth Area: '+caseDetail.Booth_Area__c+'<br/>'; 
                    
            
            //Table
            if(cmEmailList.size()>0){ 
                body += '<br/><table border="1">';
                body += '<tr><th colspan="7" align="center">CREDIT MEMO DETAILS</th></tr>';
                body += '<tr><th align="left">Sales Order #</th><th align="left">Line Of Business</th><th align="left">Justification for Credit Memo Request</th><th align="left">Reason</th><th align="right">Amount w/psp</th><th align="right">Tax Amount</th><th align="right">Total Amount</th></tr>';
                Decimal totalAmount = 0;
                
                for(sObject s : cmEmailList){
                    system.debug(s);
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
       
                    if(mapAttachments.get(recId) != null) {
                        for(Attachment a : mapAttachments.get(recId)) {
                            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                            efa.setFileName(a.Name);
                            efa.setBody(a.Body);
                            fileAttachments.add(efa);
                        }
                    }
                    
                }
                    body += '<b><tr><td colspan="6" align="right">Total Amount</td><td align="right">$ '+ (+currencyFormat(totalAmount)) +'</td></tr></b>';                   
                    body += '</table ></br>';
            }
            if(arEmailList.size()>0){
                body += '<br/><table border="1">';
                body += '<tr><th colspan="5" align="center">AR ADJUSTMENT DETAILS</th></tr>';
                body += '<tr><th align="left">Sales Order #</th><th align="left">Billing Id</th><th align="left">Justification for AR Adjustment Request</th><th align="right">Total Amount</th></tr>';
               Decimal totalAmount = 0;
                for(sObject s : arEmailList){
                    body += '<tr>';
                    body += '<td width="20%">'+s.get('Sales_Order__c')+'</td>';
                    body +='<td width="20%">'+s.get('Billing_ID__c')+'</td>';
                    body +='<td width="40%">'+s.get('Justification_for_AR_Adjustment_Request__c')+'</td>';
                    body +='<td width="20%" align="right">$ '+currencyFormat((Decimal)s.get('Amount__c'))+'</td>';
                    body += '</tr>';
                    Id recId = (Id)s.get('Id');
                    Decimal amount = (Decimal)s.get('Amount__c');
                    totalAmount += amount;
                    if(mapAttachments.get(recId) != null) {
                        for(Attachment a : mapAttachments.get(recId)) {
                            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                            efa.setFileName(a.Name);
                            efa.setBody(a.Body);
                            fileAttachments.add(efa);
                        }
                    }
                }
                    body += '<b><tr><td colspan="3" align="right">Total Amount</td><td align="right">$ '+ (+currencyFormat(totalAmount)) +'</td></tr></b>';
                    body += '</table ></br>';
            }
           if(refundsEmailList.size()>0){
                body += '<br/><table border="1">';
                body += '<tr><th colspan="5" align="center">REFUND DETAILS</th></tr>';
                body += '<tr><th align="left">Payment Type</th><th align="left">Justification for Refunds Request</th><th align="left">Sales Receipt #</th><th align="left">Sales Order #</th><th align="right">Total Amount</th></tr>';
                Decimal totalAmount = 0;
                for(sObject s : refundsEmailList){
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
                    if(mapAttachments.get(recId) != null) {
                        for(Attachment a : mapAttachments.get(recId)) {
                            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                            efa.setFileName(a.Name);
                            efa.setBody(a.Body);
                            fileAttachments.add(efa);
                        }
                    }

                }
                    body += '<b><tr><td colspan="4" align="right">Total Amount</td><td align="right">$ '+ (+currencyFormat(totalAmount)) +'</td></tr></b>';
                    body += '</table ></br>';
            }
            if(rrEmailList.size()>0){
                body += '<br/><table border="1">';
                body += '<tr><th colspan="6" align="center">RECEIPT REVERSAL DETAILS</th></tr>';
                body += '<tr><th align="left">Payment Type</th><th align="left">Justification for Receipt Rvsl Request</th><th align="left">Receipt #</th><th align="left">Sales Order #</th><th align="left">Reason</th><th align="right">Total Amount</th></tr>';
                Decimal totalAmount = 0;
                    for(sObject s : rrEmailList){
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
                    if(mapAttachments.get(recId) != null) {
                        for(Attachment a : mapAttachments.get(recId)) {
                            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                            efa.setFileName(a.Name);
                            efa.setBody(a.Body);
                            fileAttachments.add(efa);
                        }
                    }
                }
                    body += '<b><tr><td colspan="5" align="right">Total Amount</td><td align="right">$ '+ (+currencyFormat(totalAmount)) +'</td></tr></b>';
                    body += '</table ></br>';
            }
            if(paymentsEmailList.size()>0){
                body += '<br/><table border="1">';
                body += '<tr><th colspan="5" align="center">PAYMENTS DETAILS</th></tr>';
                body += '<tr><th align="left">Receipt #</th><th align="left">Justification for Pymt Transfer Request</th><th align="left">From Sales Order #</th><th align="left">To Sales Order #</th><th align="right">Total Amount</th></tr>';
                Decimal totalAmount = 0;
                    for(sObject s : paymentsEmailList){
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
                    if(mapAttachments.get(recId) != null) {
                        for(Attachment a : mapAttachments.get(recId)) {
                            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                            efa.setFileName(a.Name);
                            efa.setBody(a.Body);
                            fileAttachments.add(efa);
                        }
                    }
                }
                    body += '<b><tr><td colspan="4" align="right">Total Amount</td><td align="right">$ '+ (+currencyFormat(totalAmount)) +'</td></tr></b>';
                    body += '</table ></br>';
            }
           if(chargesEmailList.size()>0){
                body += '<br/><table border="1">';
                body += '<tr><th colspan="5" align="center">CHARGES DETAILS</th></tr>';
                body += '<tr><th align="left">Payment Type</th><th align="left">Justification for Charges Request</th><th align="left">Sales Receipt #</th><th align="left">Sales Order #</th><th align="right">Total Amount</th></tr>';
                Decimal totalAmount = 0;
                for(sObject s : chargesEmailList){
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
                    if(mapAttachments.get(recId) != null) {
                        for(Attachment a : mapAttachments.get(recId)) {
                            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                            efa.setFileName(a.Name);
                            efa.setBody(a.Body);
                            fileAttachments.add(efa);
                        }
                    }
                }
                    body += '<b><tr><td colspan="4" align="right">Total Amount</td><td align="right">$ '+ (+currencyFormat(totalAmount)) +'</td></tr></b>';
                    body += '</table ></br>';  
                   // body += '<br/>THIS IS AN AUTO GENERATED MAIL. PLEASE CLICK ON THE LINKS PROVIDED BELOW RATHER THAN REPLYING TO THIS MAIL. THANK YOU.</br>';
            }
            body += '<br/>THIS IS AN AUTO GENERATED MAIL. PLEASE CLICK ON THE LINKS PROVIDED BELOW RATHER THAN REPLYING TO THIS MAIL. THANK YOU.</br>';
            //Buttons
            body += '<br/><table border="1"><tr><td style="text-align:center;padding:10px"><a href="'+ system.label.CL_SiteUrl +'/apex/CaseApproveRejectPage?Id='+caseDetail.Id+'&email='+mailAddress+'&status=APPROVE&transactionType='+currentStage;
            if(recordId != '') {
                body += '&recordId='+recordId;
      
            }
            body += '">APPROVE</a></td>';
            body += '<td style="text-align:center;padding:10px"><a href="'+ system.label.CL_SiteUrl +'/apex/CaseApproveRejectPage?Id='+caseDetail.Id+'&email='+mailAddress+'&status=REJECT&transactionType='+currentStage;
            if(recordId != '') {
                body += '&recordId='+recordId;
            }
            body += '">REJECT</a></td></tr></table></br>';
            String buttonbody = '<br/><table border="1"><tr><td style="text-align:center;padding:10px"><a href="'+ system.label.CL_SiteUrl +'/apex/CaseApproveRejectPage?Id='+caseDetail.Id+'&email='+mailAddress+'&status=APPROVE">APPROVE</a></td>';
            buttonbody += '<td style="text-align:center;padding:10px"><a href="'+ system.label.CL_SiteUrl +'/apex/CaseApproveRejectPage?Id='+caseDetail.Id+'&email='+mailAddress+'&status=REJECT">REJECT</a></td></tr></table></br>';
            system.debug('buttonbody '+buttonbody);

            //Approval History
            if(ahList.size()>0){
                
                
               
                body += '<br/><table border="1">';
                body += '<tr><th colspan="6" align="center">APPROVAL HISTORY</th></tr>';
                body += '<tr><th>Transaction Name</th><th>Transaction Amount</th><th>Employee Name</th><th>Stage</th><th>Status</th><th>Last Modified Date/Time</th></tr>';
                for(Approval_History_ICS__c ah : ahList){
                    body += '<tr>';
                    //body += '<td>'+ah.Name+'</td>';
                    body += '<td>'+ah.Transaction_Name__c+'</td>';
                    body += '<td align="right">$'+HistorycurrencyFormat((Decimal)ah.get('Transaction_Amount__c'))+'</td>';
                    body += '<td>'+ah.Employee_Name__r.Name+'</td>';
                    body += '<td>'+ah.Stage__c+'</td>';
                    body += '<td>'+ah.Status__c+'</td>';                  
                    body += '<td>'+changeToPST(ah.createdDate)+'</td>';
                    body += '</tr>';
                }
                body += '</table><br/>';
                
            }

            if(mapAttachments.get(caseDetail.Id) != null) {
                        for(Attachment a : mapAttachments.get(caseDetail.Id)) {
                            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                            efa.setFileName(a.Name);
                            efa.setBody(a.Body);
                            fileAttachments.add(efa);
                        }
            }  
            mail.setHtmlBody(body);
            mail.setFileAttachments(fileAttachments);
            mails.add(mail);
        }
        return mails;
    
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
        public static string HistorycurrencyFormat(Decimal Historyamount) {
            if(Historyamount != null) {
                String y = String.valueOf(Historyamount);
                String z = '.';
                List<String> args = new String[]{'0','number','###,###,##0.##'};
                String h = String.format(Historyamount.format(), args);
                if(!h.contains(z)) {
                    h = h + z + '00';   
                }
                return h;
            }
         return '0.00';
        }
            
        public static String changeToPST(DateTime thisDT){
            String pstDate = thisDT.format('yyyy-MM-dd HH:mm:ss', 'PST');
            return pstDate;
        }

        
}