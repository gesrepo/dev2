/*  Class: AccountTriggerHandler
    Desc: Test Class
    Author: Gaurav
    Created Date: 10 Oct 2017
*/

    @isTest(SeeAllData=false)
    
    Private class AccountTriggerHandlerTest{
    Private static testmethod void TesttriggerControllerMethod(){
    
    
   
   List<Account> acList = new List<Account>();
    Account acc = new Account();
    acc.Name = 'Test';
    acc.BillingStreet = 'Test123';
    acc.BillingCity = 'Delhi';
    acc.BillingState = 'New Delhi';
    acc.BillingCountry = 'India';
    acc.merge_flag__c = 'MP';
    acc.merge_type__c = 'TopAcc';
    acc.RecordTypeId = Label.Account_Exhibitor;
    acc.EMEA__c = false;
    
    acList.add(acc);
    insert acList;
    
    acc.ownerid = '00540000001bR7gAAE';
    update acc;
    
    
    final map<Id,Account> accmap = new map<Id,Account>(); 
    accmap.put(acc.id, acc);   
    
    List<AR_Customer_Info__c> arcList = new List<AR_Customer_Info__c>();
    AR_Customer_Info__c arc = new AR_Customer_Info__c();
    arc.AR_Customer_Number__c = '87123';
    arc.GBMS_ID__c = '78578';
    arc.Oracle_AR_Customer_ID__c = '9879';
    arc.Name = '000000';
    arc.Payment_Terms__c= 'Pay Term';
    
    
    arcList.add(arc);
    insert arcList ;
    
    
    List<Quote__c> qutList = new List<Quote__c>();
    Quote__c qt = new Quote__c();
    
    qt.AR_Customer_Number__c = '87123';
    qt.GBMS_ID__c = '78578';
    qt.Oracle_AR_Customer_ID__c = '9879';
       
        
    
    qutList.add(qt);
    insert qutList ;
    
    
    qt.AR_Customer_Number__c = '87123';
    qt.GBMS_ID__c = '78578';
    qt.Oracle_AR_Customer_ID__c = '9879';
   // qt.Merged_AR_Customer_Number__c = '196553';
    
    update qt;
   
   Contact BC2Contact = new Contact();
        BC2Contact.FirstName = 'Sahara';
        BC2Contact.LastName = 'Jones';
        BC2Contact.Email = 'sjones@ges.com';
        BC2Contact.Phone = '7022631500';
        BC2Contact.MailingStreet = '7000 Lindell Street';
        BC2Contact.MailingCity = 'Las Vegas';
        BC2Contact.MailingState = 'NV';
        BC2Contact.MailingCountry = 'USA';
        BC2Contact.MailingPostalCode = '89119';
        
           
    List<Opportunity> opptList = new List<Opportunity>();
    Opportunity oppty= new Opportunity ();
    oppty.Oracle_AR_Customer_Number__c= '87123';
    oppty.GBMS_ID__c= '78578';
    oppty.Oracle_AR_Customer_ID__c= '9879';
    oppty.Name= 'Test Oppty';
    oppty.StageName = 'Closed Won';
    oppty.CloseDate = System.today() - 25;
        
    
    opptList.add(oppty);
    insert opptList;
    
    List<String> listOpportunityWrapper=new List<String>();       
    OpportunityWrapper oppWrpObj=new OpportunityWrapper(oppty.ID,oppty.Oracle_AR_Customer_Number__c,oppty.GBMS_ID__c,oppty.Oracle_AR_Customer_ID__c);
    listOpportunityWrapper.add(JSON.serialize(oppWrpObj));
    
    List<Oracle_Show_Booth__c> bthList = new List<Oracle_Show_Booth__c>();
    Oracle_Show_Booth__c boo = new Oracle_Show_Booth__c();
    boo.Oracle_AR_Customer_Number__c = '87123';
    boo.GBMS_ID__c = '78578';
    boo.Oracle_AR_Customer_ID__c = '9879';
    boo.Booth_Account_Deleted__c = True;   
     
          
    Test.StartTest();
    AccountTriggerHandler obj= new AccountTriggerHandler();
    obj.triggerControllerMethod(accmap);
    obj.QuoteUpdateOnAccountdelete(accmap);
    obj.OpportunityUpdateOnAccountdeleteBatch(accmap);
    obj.ContactUpdateOnAccountdeleteBatch(accmap);
    //obj.OpportunityUpdateOnAccountdelete(accmap);
    obj.BoothUpdateOnAccountdelete(accmap);
    //obj.contactUpdateOnAccountdelete(accmap);
    obj.ARcustomerUpdateOnAccountdelete(accmap);
    AccountTriggerHandler.updateOpportunityInMerge(listOpportunityWrapper);  
    AccountTriggerHandler.updateProcessedFlag(accmap.keySet()); 
            
     Test.StopTest();
    
    }
       
        
 }