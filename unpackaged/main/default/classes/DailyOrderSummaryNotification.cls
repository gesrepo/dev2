global class DailyOrderSummaryNotification implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        String newStatus = 'New';
        String submitted = 'Submitted';
        String approved = 'Approved';
        
        String queryToGetTasks = 'Select Id, OwnerId,Name, Delivery_Date_Time__c, Removal_Date_Time__c, Order__c, Order__r.Connect2_Show__c, Order__r.Show_Name__c, Completion_Date_Time__c, Order_Number__c,Status__c,CreatedBy.Name, Order__r.Connect2_Show__r.Name from GC_GES_Order_Task__c WHERE (LastModifiedDate = LAST_N_DAYS:1 AND Order__r.Connect2_Show__r.Show_End_Date__c>=TODAY)';
        system.debug('queryToGetTasks>>>>>>'+queryToGetTasks);
        return Database.getQueryLocator(queryToGetTasks);
    }
    
    global void execute(Database.BatchableContext bc, List<GC_GES_Order_Task__c> listOfTasks) {
        system.debug('listOfTasks>>>>'+listOfTasks.size());
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        Map<Id,List<String>> showMemEmail = new Map<Id,List<String>>();
        Map<Id,List<String>> showMemEmaiMyOrders = new Map<Id,List<String>>();
        //Map<Id,List<GC_Order__c>> showOrders= new Map<Id,List<GC_Order__c>>();
        Map<Id,String> showmemEmailMyOrders = new Map<Id,String>();
        //Map<Id,List<GC_GES_Order_Task__c>> ordOrdTask = new Map<Id,List<GC_GES_Order_Task__c>>(); // map key= orders, value= order task
        Map<Id,List<GC_GES_Order_Task__c>> showAndTask = new Map<Id,List<GC_GES_Order_Task__c>>();
        String html1 = '';
        Set<Id> setOfShows= new Set<Id>();
        //Set<String> setOfTaskOwner =new Set<String>();
        //Map<Id,String> showOwnerEmail = new Map<Id,String>();
        Map<Id,String> showName = new Map<Id,String>();
        List<GC_Show_Team_Member__c> showTeamMemList = new List<GC_Show_Team_Member__c>();
        List<GC_Show_Team_Member__c> showTeamMemListMyOrders = new List<GC_Show_Team_Member__c>();
        
        for(GC_GES_Order_Task__c got: listOfTasks)
        {
                        
            if(!showAndTask.containsKey(got.Order__r.Connect2_Show__c)){
                showAndTask.put(got.Order__r.Connect2_Show__c,new List<GC_GES_Order_Task__c>());
            }
            showAndTask.get(got.Order__r.Connect2_Show__c).add(got);
            setOfShows.add(got.Order__r.Connect2_Show__c);
            
            if(!showName.containsKey(got.Order__r.Connect2_Show__c)){
                    showName.put(got.Order__r.Connect2_Show__c,got.Order__r.Show_Name__c); 
                }
            
        }
        
        if(showAndTask.keySet().size() > 0)
        {
            //get a list of Show Organisers who opted to recieve notifications on all order tasks
            showTeamMemList = [Select Id,Name,User__r.Email,Connect2_Show__c from GC_Show_Team_Member__c where  Connect2_Show__c in : showAndTask.keySet() and (ReceiveNotificationAllOrders__c = true AND Daily_Order_Summary_Emails__c = true AND No_Notification_Emails__c = false) AND Show_Role__c='Show Organizer'];
            //get a list of Show Organisers who opted to recieve notifications only on their order tasks
            showTeamMemListMyOrders = [Select Id,Name,User__r.Email,Connect2_Show__c from GC_Show_Team_Member__c where  Connect2_Show__c in : showAndTask.keySet() and (ReceiveNotificationMyOrders__c = true AND Daily_Order_Summary_Emails__c = true AND No_Notification_Emails__c = false) AND Show_Role__c='Show Organizer'];
        }
        
        for(GC_Show_Team_Member__c stm: showTeamMemList) 
            {
                 if(!showMemEmail.containsKey(stm.Connect2_Show__c)){
                    showMemEmail.put(stm.Connect2_Show__c,new List<String>());
                }
                showMemEmail.get(stm.Connect2_Show__c).add(stm.User__r.Email);
            }

            for(GC_Show_Team_Member__c stm: showTeamMemListMyOrders) 
            {
                 if(!showMemEmaiMyOrders.containsKey(stm.Connect2_Show__c)){
                    showMemEmaiMyOrders.put(stm.Connect2_Show__c,new List<String>());
                }
                showMemEmaiMyOrders.get(stm.Connect2_Show__c).add(stm.User__r.Email);

                if(!showmemEmailMyOrders.containsKey(stm.User__c)){
                    showmemEmailMyOrders.put(stm.User__c,stm.User__r.Email);
                }
            }

            system.debug('showAndTask>>>>'+showAndTask);
            system.debug('showMemEmail>>>>'+showMemEmail);
            system.debug('showmemEmailMyOrders>>>>'+showmemEmailMyOrders);
            
        for(Id showId: setOfShows)
            {
                //Summary email for all Order tasks to show organisers who opted for such options
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                Set<String> toEmailSet = new Set<String>();
                
                List<String> toEmailList;

                if(showMemEmail.containsKey(showId))
                {
                   for(String email: showMemEmail.get(showId))
                   {
                        toEmailSet.add(email);
                   }
                }
                
                toEmailList = new List<String>(toEmailSet);
                system.debug('toEmailList>>>>'+toEmailList);
                
                mail.setToAddresses(toEmailList);
                mail.setSaveAsActivity(false);
                if(showName.containsKey(showId))
                {
                    mail.setSubject('Order Tasks Summary for Connect2 Show Name: '+showName.get(showId));
                }
                html1 = '<style>table, th, td { border: 1px solid black;}</style><b>Listed below is your daily order task summary</b></ br></ br><table><tr><th> Order Name </th><th> Delivery Date/Time</th><th> Completion Date/Time</th><th>Removal Date/Time</th><th> Order Number</th><th> Order Status</th><th>CreatedBy</th></tr>';
                for(GC_GES_Order_Task__c con : showAndTask.get(showId))
                {
                    html1 += '<tr><td><a href="https://ges--c.vf.force.com/apex/GC_OrderView?id='+con.id+'&sfdc.override=1" target="_blank">'+ con.Name+'</a> </td> <td>'+ (con.Delivery_Date_Time__c != null ? con.Delivery_Date_Time__c.format() : '')+' </td><td>'+ (con.Completion_Date_Time__c != null ? con.Completion_Date_Time__c.format() : '')+' </td><td>'+ (con.Removal_Date_Time__c != null ? con.Removal_Date_Time__c.format() : '')+' </td><td>'+ (con.Order_Number__c != null ? con.Order_Number__c : '')+' </td><td>'+ con.Status__c+' </td><td>'+ con.CreatedBy.Name+' </td></tr>';
                }
                 mail.setHtmlBody(html1);
                if(toEmailList.size()>0) 
                {
                    mailList.add(mail);  
                }
                Set<String> toEmailSet1 = new Set<String>();
                List<String> toEmailList1;
                Map<Id,List<GC_GES_Order_Task__c>> ordOwnerMap = new Map<Id,List<GC_GES_Order_Task__c>>();
                
            for(GC_GES_Order_Task__c con : showAndTask.get(showId))
            {
                if(showmemEmailMyOrders.containsKey(con.OwnerId))
                {
                    if(!ordOwnerMap.containsKey(con.OwnerId)){
                        ordOwnerMap.put(con.OwnerId,new List<GC_GES_Order_Task__c>());
                    }
                    ordOwnerMap.get(con.OwnerId).add(con);
                }
                
            }
        for(Id ownerId: ordOwnerMap.keySet())
            {
                Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
                mail1.setSaveAsActivity(false);
                if(showName.containsKey(showId))
                {
                    mail1.setSubject('Order Tasks Summary for Connect2 Show Name: '+showName.get(showId));
                }
                html1 = '<style>table, th, td { border: 1px solid black;}</style><b>Listed below is your daily order task summary</b></ br></ br><table><tr><th> Order Name </th><th> Delivery Date/Time</th><th> Completion Date/Time</th><th>Removal Date/Time</th><th> Order Number</th><th> Order Status</th><th>CreatedBy</th></tr>';
                if(ordOwnerMap.get(ownerId) != null) {
                  for(GC_GES_Order_Task__c con : ordOwnerMap.get(ownerId))
                  {
                      html1 += '<tr><td><a href="https://ges--c.vf.force.com/apex/GC_OrderView?id='+con.id+'&sfdc.override=1" target="_blank">'+ con.Name+'</a> </td> <td>'+ (con.Delivery_Date_Time__c != null ? con.Delivery_Date_Time__c.format() : '')+' </td><td>'+ (con.Completion_Date_Time__c != null ? con.Completion_Date_Time__c.format() : '')+' </td><td>'+ (con.Removal_Date_Time__c != null ? con.Removal_Date_Time__c.format() : '')+' </td><td>'+ (con.Order_Number__c != null ? con.Order_Number__c : '')+' </td><td>'+ con.Status__c+' </td><td>'+ con.CreatedBy.Name+' </td></tr>';
                  }
                }
                if(showmemEmailMyOrders.containsKey(ownerId))
                    {
                        toEmailSet1.add(showmemEmailMyOrders.get(ownerId));
                    }
                    toEmailList1 = new List<String>(toEmailSet1);
                    system.debug('toEmailList1>>>>'+toEmailList1);
                    mail1.setToAddresses(toEmailList1);
                    
                    system.debug('toEmailList1>>>>'+toEmailList1);
                    
                    mail1.setHtmlBody(html1);
                    if(toEmailList1.size()>0)
                    {
                        mailList.add(mail1); 
                    }
                
            }
        }
            
            
            
        Messaging.sendEmail(mailList);
    }
    global void finish(Database.BatchableContext bc) {
    }
}