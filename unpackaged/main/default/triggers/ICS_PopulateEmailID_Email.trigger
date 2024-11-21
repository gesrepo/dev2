trigger ICS_PopulateEmailID_Email on Customer_Service_Inquiries_ICS__c (before insert,before Update) {
     Set<ID> setConIds = new Set<ID>(); 
     for(Customer_Service_Inquiries_ICS__c  obj : trigger.new) 
       { 
             if(obj.Case_Requestor__c  != null) 
             setConIds.add(obj.Case_Requestor__c );

       } 
 
  MAP<ID , Employees__c> mapCon = new MAP<ID , Employees__c>([Select Email_Address__c from Employees__c where id in: setConIds]); 

   for(Customer_Service_Inquiries_ICS__c obj : trigger.new) 
   { 

        if(obj.Case_Requestor__c  != null) 

          { 

            Employees__c  c = mapCon.get(obj.Case_Requestor__c ); 
            obj.Case_Requestor_Email_ID__c = c.Email_Address__c;
           // obj.Case_Requestor_Approval_Status__c = 'Open';

          } 

   } 
}