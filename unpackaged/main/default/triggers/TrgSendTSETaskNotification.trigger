trigger TrgSendTSETaskNotification on Task (after update) {
    /*
        Created By: Joy Varughese
        Created Date: 05-16-2013
        
        Purpose:
        Send notification to a TSE outlook distribution list
        when a special type of task is created. Task must be
        associated to a case.
    */
    
    List<Messaging.SingleEmailMessage> Mails = new List<Messaging.SingleEmailMessage>();
    
    String CaseKeyPrefix = Case.sObjectType.getDescribe().getKeyPrefix(); 
    
    // Mappings
    Set<Id> SoCaseIds = new Set<Id>();
    Set<Id> SoTaskIds = new Set<Id>();
    Set<Id> SoTaskOwnerIds = new Set<Id>();
    Map<Id, Id> MOTaskIdCaseId = new Map<Id, Id> ();
    Map<Id, Task> MOTaskIdTask = new Map<Id, Task> ();
    Map<Id, Case> MOCaseIdCase = new Map<Id, Case>(); 
    Map<Id, User> MOUserIdUser = new Map<Id, User>(); 
    
    List<Task> LoTasks = new List<Task>();
   
    for (Task t: Trigger.new)
    {
        // check if task is connected to a case
        if (t.WhatId != null) 
        {   
            String taskWhatId = t.WhatId;
            
            if (taskWhatId.startsWith(caseKeyPrefix) && t.Type.toUpperCase() == 'ELECTRICAL PROBLEM ORDERS') 
            {  
                LoTasks.add(t);
                SoTaskIds.add(t.Id);
                SoCaseIds.add(t.WhatId);
                SoTaskOwnerIds.add(t.OwnerId);                        
                MOTaskIdCaseId.put(t.Id, t.WhatId);
                MOTaskIdTask.put(t.Id, t);
            }
        }
    }  
   
    for (Case c : [Select Id, CaseNumber, Case.Customer_Name__c, Case.Show_Name__r.Name, Case.Booth_Number__c, Case.Reason__c From Case Where Id in : SoCaseIds ])
        MOCaseIdCase.put(c.Id, c); 
   
    for ( User usr : [Select Id, Email, FirstName, LastName  from User  Where Id in  :SoTaskOwnerIds])
        MOUserIdUser.put(usr.Id, usr);
   
    // Use Organization Wide Address 
    Id OrgEmailSFId = null; 
    
    for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress])
    {
        if(owa.DisplayName.contains('National Servicenter General'))
        {
            OrgEmailSFId = owa.id;
            break;
        }
    }
    
    for (Task t : LoTasks)
    {
        User Owner = MOUserIdUser.get(t.OwnerId);
        Case C = MOCaseIdCase.get(t.WhatId);
        
        String TaskOwnerName = '';
        String[] ToAddresses = null;
        
        if (Owner != null)
        {
            TaskOwnerName = Owner.FirstName + ' '+ Owner.LastName;
            ToAddresses = new String[] {'GES@ts-electric.com'}; //{Owner.Email}; 
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();          
            
            mail.setSaveAsActivity(false); 
            mail.setOrgWideEmailAddressId(OrgEmailSFId);
            
            String CaseNumber = '';
            String CustomerName = '';
            String ShowName = '';
            String BoothNumber = '';
            String Reason = '';
            
            if (C != null) 
            {
                CaseNumber = C.CaseNumber;
                CustomerName = C.Customer_Name__c;
                ShowName = (C.Show_Name__r != null ? C.Show_Name__r.Name : '');
                BoothNumber = C.Booth_Number__c;
                Reason = C.Reason__c;                   
            }
            
            string HtmlBody = 
                    '<div style="font-family: Verdana; font-size: smaller;">' +
                    '<p>' + 
                    'Please review SF case # ' +
                    '<span style="font-weight: bold" >' + CaseNumber + '</span>. ' +
                    'This is an Electrical Problem Order for ' + 
                    '<span style="font-weight: bold">' + (CustomerName == null ? '[Not Specified]' : CustomerName) + '</span> ' +
                    'at the ' + 
                    '<span style="font-weight: bold">' + (ShowName == null ? '[Not Specified]' : ShowName) + '</span> ' +
                    'in Booth # ' + 
                    '<span style="font-weight: bold">' + (BoothNumber == null ? '[Not Specified]' : BoothNumber) + '</span>.' +
                    '</p>' +
                    '</div>' ;
            
            mail.setHtmlBody(HtmlBody );
            mail.setSubject('SF case # ' + CaseNumber + ', Electrical Problem Order for ' + (ShowName == null ? '[Not Specified]' : ShowName));
            mail.setToAddresses(ToAddresses);   
            //This piece of code is used if a email template is used.
            //mail.setTargetObjectId(t.OwnerId);
            //mail.setTemplateId(etemp.id);  
            //mail.setWhatId(WhoId);       
            Mails.add(mail);
        }   
    }
    
    try
    {
    	system.debug('MAIL ARRAY SIZE: ' + Mails.size());
    	
        if (Mails.size() > 0)
        {
            Messaging.SendEmailResult[] Results = Messaging.sendEmail(Mails, false);
        	
            if (!Results[0].isSuccess())
                system.debug('Error sending TSE email: ' + Results.get(0).getErrors()[0].getMessage());
        }
        else
            system.debug('TSE no emails to send');
    }
    catch(DMLException e){
        system.debug('ERROR SENDING FIRST EMAIL:' + e.getDMLMessage(0)); 
    } 
}