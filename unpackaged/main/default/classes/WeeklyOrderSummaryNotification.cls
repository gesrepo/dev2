global class WeeklyOrderSummaryNotification implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        String newStatus = 'New';
        String submitted = 'Submitted';
        String approved = 'Approved';
        
        String soql = 'Select Id,Order__c from GC_GES_Order_Task__c WHERE (Status__c=\''+newStatus+'\''+' or Status__c =\''+submitted+'\''+' or Status__c=\''+approved+'\''+') AND (Completion_Date_Time__c = NEXT_N_DAYS:7)';
        system.debug('soql>>>>>>'+soql);
        return Database.getQueryLocator(soql);
    }
   
    global void execute(Database.BatchableContext bc, List<GC_GES_Order_Task__c> recs) {
        system.debug('recs>>>>'+recs.size());
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        Map<Id,List<GC_Order__c>> showOrders= new Map<Id,List<GC_Order__c>>();
        Map<Id,List<GC_GES_Order_Task__c>> ordOrdTask = new Map<Id,List<GC_GES_Order_Task__c>>();
        String html1 = '';
        List<GC_Order__c> orderlist= new List<GC_Order__c>();
        Map<Id,String> showOwnerEmail = new Map<Id,String>();
        Map<Id,String> showName = new Map<Id,String>();
        //Map<Id,List<GC_GES_Order_Task__c>> ordOrdTask = new Map<Id,List<GC_GES_Order_Task__c>>();
        
        for(GC_GES_Order_Task__c got: recs)
        {
            if(!ordOrdTask.containsKey(got.Order__c)){
                ordOrdTask.put(got.Order__c,new List<GC_GES_Order_Task__c>());
            }
            ordOrdTask.get(got.Order__c).add(got);
        }
        
        if(ordOrdTask.keySet().size() > 0)
        {
            orderlist = [Select Connect2_Show__c,Connect2_Show__r.Owner.Email,id,name,Booth_Area__c,Order_Area_Description__c,Connect2_Show__r.Name,Delivery_Date_Time__c,Completion_Date_Time__c,Removal_Date_Time__c,Order_Number__c,Status__c,CreatedBy.Name from GC_Order__c where Id in : ordOrdTask.keySet()];
        }
        
        system.debug('orderlist>>>>'+orderlist.size());
        
        for(GC_Order__c ord: orderlist)
        {
            if(!showOrders.containsKey(ord.Connect2_Show__c)){
                showOrders.put(ord.Connect2_Show__c,new List<GC_Order__c>());
            }
            showOrders.get(ord.Connect2_Show__c).add(ord);
            
            
            if(!showOwnerEmail.containsKey(ord.Connect2_Show__c)){
                showOwnerEmail.put(ord.Connect2_Show__c,ord.Connect2_Show__r.Owner.Email);
            }
            
            if(!showName.containsKey(ord.Connect2_Show__c)){
                showName.put(ord.Connect2_Show__c,ord.Connect2_Show__r.Name);
            }
        }
        
        system.debug('showOrders>>>>'+showOrders);
        system.debug('showOwnerEmail>>>>'+showOwnerEmail);
        system.debug('showName>>>>'+showName);
        
        for(Id showId: showOrders.keySet())
        {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            if(showOwnerEmail.containsKey(showId))
            {
                mail.setToAddresses(new String[] {showOwnerEmail.get(showId)});
            }
            //mail.setToAddresses(new String[] {'asomashekaraiah@ges.com'});
            mail.setSaveAsActivity(false);
            if(showName.containsKey(showId))
            {
                mail.setSubject('Listed below is your weekly order summary for Connect2 show Name:'+showName.get(showId));
            }
            
            html1 = '<style>table, th, td { border: 1px solid black;}</style><b>Listed below is your weekly order summary</b></ br></ br><table><tr><th> Order Name </th><th> Booth Area </th><th> Order Area Description</th><th> Delivery Date/Time</th><th> Completion Date/Time</th><th>Removal Date/Time</th><th> Order Number</th><th> Order Status</th><th>CreatedBy</th></tr>';
            for(GC_Order__c con : showOrders.get(showId))
            {
                html1 += '<tr><td><a href="https://ges--dev2.sandbox.my.salesforce.com/apex/GC_OrderView?id='+con.id+'&sfdc.override=1" target="_blank">'+ con.Name+'</a> </td> <td>'+ con.Booth_Area__c+' </td> <td>'+ con.Order_Area_Description__c+'</td><td>'+ con.Delivery_Date_Time__c+' </td><td>'+ con.Completion_Date_Time__c+' </td><td>'+ con.Removal_Date_Time__c+' </td><td>'+ con.Order_Number__c+' </td><td>'+ con.Status__c+' </td><td>'+ con.CreatedBy.Name+' </td></tr>';
            }                           
            mail.setHtmlBody(html1);
            mailList.add(mail);  
        }
        
        Messaging.sendEmail(mailList);
    }
   
    global void finish(Database.BatchableContext bc) {
    }
}