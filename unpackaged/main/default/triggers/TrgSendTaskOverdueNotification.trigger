// Trigger to notify the case task owner when the task is overdue.
trigger TrgSendTaskOverdueNotification on Task (after update) {
    
    List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
    //EmailTemplate etemp = [select id from EmailTemplate where Name = 'Task overdue by 1 day' and isactive=TRUE];
    
    String caseKeyPrefix = Case.sObjectType.getDescribe().getKeyPrefix(); 
     
    // Mappings
    Set<Id> socaseIds = new Set<Id>();
    Set<Id> sotaskIds = new Set<Id>();
    Set<Id> sotaskownerIds = new Set<Id>();
    Map<Id, Id> MOTaskIdCaseId = new Map<Id, Id> ();
    Map<Id, Task> MOTaskIdTask = new Map<Id, Task> ();
    Map<Id, Case> MOCaseIdCase = new Map<Id, Case>(); 
    Map<Id, User> MOUserIdUser = new Map<Id, User>(); 
     
    Task[] task = Trigger.new;   
   
    for (Task t:task)
    {
       // check if task is connected to a case and if custom task overdue flag field is true
       if (t.WhatId != null) 
       {   
            String taskWhatId = t.WhatId;
             
             if (t.IsTaskDue__c != null && t.IsTaskDue__c && taskWhatId.startsWith(caseKeyPrefix ) ) 
             {  
                 sotaskIds.add(t.Id);
                 socaseIds.add(t.WhatId);
                 sotaskownerIds.add(t.OwnerId);                        
                 MOTaskIdCaseId.put(t.Id, t.WhatId);
                 MOTaskIdTask.put(t.Id, t);
             }
            
       }
   }  
   
   for ( Case c : [Select Id, CaseNumber, Case.Customer_Name__c, Case.Show_Name__r.Name, Case.Booth_Number__c, Case.Reason__c From Case Where Id in : socaseIds ])
   {
     if (c.Id != null)
     {
        MOCaseIdCase.put(c.Id, c); 
     }  
   }
   
	for ( User usr : [Select Id, Email, FirstName, LastName  from User  Where Id in  :sotaskownerIds])
	{
		if (usr.Id != null)
		{
			MOUserIdUser.put(usr.Id, usr); 
		}  
	}
   
	// Use Organization Wide Address 
	String orgEmailAddress = null; 
	for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress]) {
	if(owa.DisplayName.contains('Global Experience Specialists')) orgEmailAddress = owa.id; }

    
	for (Task t : task)
	{ 
        if(t.WhatId != null) { 
            
            if (MOTaskIdCaseId .containsKey(t.Id)) 
            {                 

                String taskOwner = MOUserIdUser.get(t.OwnerId).FirstName +' '+ MOUserIdUser.get(t.OwnerId).LastName; 
                String[] toAddresses = new String[] {MOUserIdUser.get(t.OwnerId).Email};       
                
                Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();          
                
                mail.setSaveAsActivity(false); 
                mail.setOrgWideEmailAddressId(orgEmailAddress);  
                                               
                string htmlbody = 
                        '<div style=" font-family: Verdana; font-size: smaller;">' +
                        '<p>Task Overdue</p>' + 
                        '<p>Case #: <b>' + MOCaseIdCase.get(MOTaskIdTask.get(t.Id).WhatId).CaseNumber + '</b></p>' +
                        '<p>Customer Name: <b>' + MOCaseIdCase.get(MOTaskIdTask.get(t.Id).WhatId).Customer_Name__c + '</b></p>'+
                        '<p>Show Name: <b>' + MOCaseIdCase.get(MOTaskIdTask.get(t.Id).WhatId).Show_Name__r.Name + '</b></p>' +
                        '<p>Booth #: <b>' + MOCaseIdCase.get(MOTaskIdTask.get(t.Id).WhatId).Booth_Number__c + '</b></p>'+
                        '<p>Task Owner: <b>' + taskOwner + '</b></p>'+
                        '<p>Case Reason: <b>' + MOCaseIdCase.get(MOTaskIdTask.get(t.Id).WhatId).Reason__c + '</b></p>' +
                        '</div>' ;
                        
                mail.setHtmlBody(htmlbody );
                mail.setSubject('Your Task is Overdue');
                mail.setToAddresses(toAddresses );   
                //This piece of code is used if a email template is used.
                //mail.setTargetObjectId(t.OwnerId);
                //mail.setTemplateId(etemp.id);  
                //mail.setWhatId(WhoId);       
                mails.add(mail);
            }
        }      
	}
    
	try
	{ 
		Messaging.sendEmail(mails); 
	}
	catch(DMLException e){
		system.debug('ERROR SENDING FIRST EMAIL:'+e.getDMLMessage(0)); 
	} 
}