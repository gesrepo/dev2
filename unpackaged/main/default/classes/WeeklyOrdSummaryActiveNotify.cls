global class WeeklyOrdSummaryActiveNotify implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        String actStatus = 'Active';
        //String showId = 'a3r40000000bqdj'; 
        
        //String soql = 'Select Id,Name,Connect2_Show__c,Connect2_Show__r.Name,Booth_Area__c,Order_Area_Description__c,Delivery_Date_Time__c,Completion_Date_Time__c,Removal_Date_Time__c,Order_Number__c,Status__c,CreatedBy.Name from GC_Order__c WHERE Status__c=\''+actStatus+'\'';
        //String soql = 'Select Id,OwnerId,Name,Connect2_Show__c,Connect2_Show__r.Name,Booth_Area__c,Order_Area_Description__c,Delivery_Date_Time__c,Completion_Date_Time__c,Removal_Date_Time__c,Order_Number__c,Status__c,CreatedBy.Name from GC_Order__c WHERE Connect2_Show__c=\''+showId+'\'';
        String soql = 'Select Id,OwnerId,Name,Connect2_Show__c,Connect2_Show__r.Name,Booth_Area__c,Order_Area_Description__c,Delivery_Date_Time__c,Completion_Date_Time__c,Removal_Date_Time__c,Order_Number__c,Status__c,CreatedBy.Name from GC_Order__c Where LastModifiedDate = LAST_N_DAYS:7';
        system.debug('soql>>>>>>'+soql);
        return Database.getQueryLocator(soql);
    }
   
    global void execute(Database.BatchableContext bc, List<GC_Order__c> recs) {
        system.debug('recs>>>>'+recs.size());
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        Map<Id,List<GC_Order__c>> showOrders= new Map<Id,List<GC_Order__c>>();
        Map<Id,List<String>> showMemEmail = new Map<Id,List<String>>();
        Map<Id,List<String>> showMemEmaiMyOrders = new Map<Id,List<String>>();
        Map<Id,String> showName = new Map<Id,String>();
        List<GC_Show_Team_Member__c> showTeamMemList = new List<GC_Show_Team_Member__c>();
        List<GC_Show_Team_Member__c> showTeamMemListMyOrders = new List<GC_Show_Team_Member__c>();
        Map<Id,String> showmemEmailMyOrders = new Map<Id,String>();

        //String[] toaddress = new String[]{};
        String html1 = '';
        

        for(GC_Order__c ord: recs)
        {
            if(!showOrders.containsKey(ord.Connect2_Show__c)){
                showOrders.put(ord.Connect2_Show__c,new List<GC_Order__c>());
            }
            showOrders.get(ord.Connect2_Show__c).add(ord);
            
            if(!showName.containsKey(ord.Connect2_Show__c)){
                showName.put(ord.Connect2_Show__c,ord.Connect2_Show__r.Name);
            }
        }
 
        //showTeamMemList = [Select Id,User__r.Email,Connect2_Show__c from GC_Show_Team_Member__c where Show_Role__c = 'Show Organizer' and Connect2_Show__c in : showOrders.keySet() and (User__r.ReceiveNotAll__c = true)];
        showTeamMemList = [Select Id,User__r.Email,Connect2_Show__c from GC_Show_Team_Member__c where  Connect2_Show__c in : showOrders.keySet() and (ReceiveNotificationAllOrders__c = true)];
        //showTeamMemListMyOrders = [Select Id,User__r.Email,Connect2_Show__c from GC_Show_Team_Member__c where Show_Role__c = 'Show Organizer' and Connect2_Show__c in : showOrders.keySet() and (User__r.ReceiveNotificationMyOrders__c = true)];
        showTeamMemListMyOrders = [Select Id,User__r.Email,Connect2_Show__c from GC_Show_Team_Member__c where  Connect2_Show__c in : showOrders.keySet() and (ReceiveNotificationMyOrders__c = true)];

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

        system.debug('showOrders>>>>'+showOrders);
        system.debug('showMemEmail>>>>'+showMemEmail);
        system.debug('showName>>>>'+showName);

        for(Id showId: showOrders.keySet())
        {
            //All Order Summary
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
            //for(String emailSet: toEmailSet)
            //{
            //    toEmailList.add(emailSet);
            //}
            mail.setToAddresses(toEmailList);
            //mail.setToAddresses(new String[] {'asomashekaraiah@ges.com'});
            mail.setSaveAsActivity(false);
            if(showName.containsKey(showId))
            {
                mail.setSubject('Active Orders summary for Connect2 show Name:'+showName.get(showId));
            }
            html1 = '<style>table, th, td { border: 1px solid black;}</style><b>Listed below is your weekly order summary</b></ br></ br><table><tr><th> Order Name </th><th> Booth Area </th><th> Order Area Description</th><th> Delivery Date/Time</th><th> Completion Date/Time</th><th>Removal Date/Time</th><th> Order Number</th><th> Order Status</th><th>CreatedBy</th></tr>';
            for(GC_Order__c con : showOrders.get(showId))
            {
                html1 += '<tr><td><a href="https://ges--dev2.sandbox.my.salesforce.com/apex/GC_OrderView?id='+con.id+'&sfdc.override=1" target="_blank">'+ con.Name+'</a> </td> <td>'+ (String.isNotBlank(con.Booth_Area__c) ? con.Booth_Area__c : '' )+' </td> <td>'+ (String.isNotBlank(con.Order_Area_Description__c) ? con.Order_Area_Description__c : '')+'</td><td>'+ (con.Delivery_Date_Time__c != null ? con.Delivery_Date_Time__c.format() : '')+' </td><td>'+ (con.Completion_Date_Time__c != null ? con.Completion_Date_Time__c.format() : '')+' </td><td>'+ (con.Removal_Date_Time__c != null ? con.Removal_Date_Time__c.format() : '')+' </td><td>'+ con.Order_Number__c+' </td><td>'+ con.Status__c+' </td><td>'+ con.CreatedBy.Name+' </td></tr>';
            }                           
            mail.setHtmlBody(html1);
            if(toEmailList.size()>0) 
            {
                mailList.add(mail);  
            }


            //Specific Orders Owned Summary
            //Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
            Set<String> toEmailSet1 = new Set<String>();
            List<String> toEmailList1;
            Map<Id,List<GC_Order__c>> ordOwnerMap = new Map<Id,List<GC_Order__c>>();

            for(GC_Order__c con : showOrders.get(showId))
            {
                if(showmemEmailMyOrders.containsKey(con.OwnerId))
                {
                    if(!ordOwnerMap.containsKey(con.OwnerId)){
                        ordOwnerMap.put(con.OwnerId,new List<GC_Order__c>());
                    }
                    ordOwnerMap.get(con.OwnerId).add(con);
                }
                
            }

            system.debug('ordOwnerMap>>>>'+ordOwnerMap);

            for(Id ownerId: ordOwnerMap.keySet())
            {
                Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
                mail1.setSaveAsActivity(false);
                if(showName.containsKey(showId))
                {
                    mail1.setSubject('Active Orders summary for Connect2 show Name:'+showName.get(showId));
                }
                html1 = '<style>table, th, td { border: 1px solid black;}</style><b>Listed below is your weekly order summary Owner</b></ br></ br><table><tr><th> Order Name </th><th> Booth Area </th><th> Order Area Description</th><th> Delivery Date/Time</th><th> Completion Date/Time</th><th>Removal Date/Time</th><th> Order Number</th><th> Order Status</th><th>CreatedBy</th></tr>';
                for(GC_Order__c con : ordOwnerMap.get(ownerId))
                {
                    html1 += '<tr><td><a href="https://ges--dev2.sandbox.my.salesforce.com/apex/GC_OrderView?id='+con.id+'&sfdc.override=1" target="_blank">'+ con.Name+'</a> </td> <td>'+ (String.isNotBlank(con.Booth_Area__c) ? con.Booth_Area__c : '' )+' </td> <td>'+ (String.isNotBlank(con.Order_Area_Description__c) ? con.Order_Area_Description__c : '')+'</td><td>'+ (con.Delivery_Date_Time__c != null ? con.Delivery_Date_Time__c.format() : '')+' </td><td>'+ (con.Completion_Date_Time__c != null ? con.Completion_Date_Time__c.format() : '')+' </td><td>'+ (con.Removal_Date_Time__c != null ? con.Removal_Date_Time__c.format() : '')+' </td><td>'+ (String.isNotBlank(con.Order_Number__c) ? con.Order_Number__c:'')+' </td><td>'+ con.Status__c+' </td><td>'+ con.CreatedBy.Name+' </td></tr>';
                }

                if(showmemEmailMyOrders.containsKey(ownerId))
                {
                    toEmailSet1.add(showmemEmailMyOrders.get(ownerId));
                }
                toEmailList1 = new List<String>(toEmailSet1);
                system.debug('toEmailList1>>>>'+toEmailList1);
                mail1.setToAddresses(toEmailList1);
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