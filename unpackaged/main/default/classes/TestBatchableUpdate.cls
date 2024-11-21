/*  Class: BatchableOpportunityUpdate
    Desc: Test Class
    Author: Gaurav
    Created Date: 09 Feb 2018
*/

    @isTest(SeeAllData=false)
    
    Private class TestBatchableUpdate{
    
    private static User ADMIN_USER = [select id  from user where username like 'accountmerge%' AND isActive = true LIMIT 1];
  
    static testMethod void unitTestBatchableOpportunity() {
        system.runAs(ADMIN_USER){
    
   
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
    
        
        //Create User (for Owner)
      ID OwnerId = UserInfo.getUserId();
      
      //Create User Sales Person
      ID SalesRepId = UserInfo.getUserId();
           
      RecordType FacilityRecordType = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Facility'];
      Id FacilityRecordTypeId = FacilityRecordType.Id;
                   
      RecordType FirmRecordType = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Firm'];
      Id FirmRecordTypeId = FirmRecordType.Id;
              
      RecordType SalesRepRecordType = [Select Id From RecordType Where SObjectType = 'Opportunity' And Name = 'Sales Rep Show Occurrence'];
      Id SalesRepRecordTypeId = SalesRepRecordType.Id;      
      
      //Create Facility Account
      Account Facility = new Account();
      Facility.Sales_Person__c = SalesRepId;
      Facility.Name = 'MyTestFacilityName';
      Facility.Type = 'Hotel';
      Facility.GES_Status__c = 'Preferred';
      Facility.LMS_Facility_ID__c = 'ABCFAC';
      Facility.BillingStreet = '950 Grier Dr';
      Facility.BillingCity = 'Las Vegas';
      Facility.BillingPostalCode = '89119-0000';
      Facility.BillingState = 'NV';
      Facility.BillingCountry = 'US';
      Facility.RecordTypeId = FacilityRecordTypeId;
              
      Database.insert(Facility);
                      
      //Create Firm Account
      Account Firm = new Account();
      Firm.Sales_Person__c = SalesRepId;
      Firm.Name = 'SONY ENTERTAINMENT INC';
      Firm.Phone = '7022631500';
      Firm.BillingStreet = '950 Grier Dr';
      Firm.BillingCity = 'Las Vegas';
      Firm.BillingPostalCode = '89119-0000';
      Firm.BillingState = 'NV';
      Firm.BillingCountry = 'US';
      Firm.RecordTypeId = FirmRecordTypeId;
      
      Database.insert(Firm);
      
      //Create Show
      Show__c Show = new Show__c();
      Show.Sales_Person__c = SalesRepId;
      Show.Account__c = Firm.Id;
      Show.Name ='International CES';
      Show.Show_Type__c = 'Food Sector';
      Show.Show_ID__c = '123456';
      
      Database.insert(Show);            
             
      Opportunity Opp1 = new Opportunity();
      Opp1.Job_Number__c = '201212313';        
      Opp1.OwnerId = OwnerId;   
      Opp1.Sales_Person__c = SalesRepId;        
      Opp1.Sales_Location__c = '110- Las Vegas';        
      Opp1.Name = 'MyTestShow # 1';        
      Opp1.Prime_Contractor__c = null;        
      Opp1.Production_Location__c = '110- Las Vegas';        
      Opp1.Facility__c = Facility.Id;        
      Opp1.StageName = 'SL1';        
      Opp1.Amount = 1000;        
      Opp1.Probability = 25;        
      Opp1.Type = 'ITYFTY';        
      Opp1.New_Repeat__c = 'New';        
      Opp1.Frequency__c = 'B1';        
      Opp1.AccountId = Firm.Id;       
      Opp1.Show_Name__c = Show.Id;        
      Opp1.RecordTypeId = SalesRepRecordTypeId;                
      Opp1.Show_Open_Date__c = Date.newInstance(DateTime.now().yearGmt()-1,12,1);       
      Opp1.Show_Close_Date__c = Date.newInstance(DateTime.now().yearGmt()-1,12,2);        
      Opp1.CloseDate = Date.newInstance(DateTime.now().yearGmt()-1,12,2); 
      opp1.Requested_Stage__c = '';
      Database.insert(Opp1);  
          
      Opp1.RFP_Due_Date__c = Date.newInstance(DateTime.now().yearGmt()-1,12,2);
      Opp1.Requested_Stage__c = 'PS';
      Database.update(Opp1);
         
    map<Id, Opportunity> opptyMap = new map<Id, Opportunity> ();
    opptyMap.put(opp1.Id, opp1);
    
        
    Test.StartTest();
    BatchableOpportunityUpdate obj = new BatchableOpportunityUpdate(opptyMap);
    Database.executeBatch(obj);
    
        
    Test.StopTest();
            
    }
       
       
   } 

    static testMethod void unitTestBatchableContact() {
        system.runAs(ADMIN_USER){
    
   
    List<AR_Customer_Info__c> arcList = new List<AR_Customer_Info__c>();
    AR_Customer_Info__c arc = new AR_Customer_Info__c();
    arc.AR_Customer_Number__c = '87123';
    arc.GBMS_ID__c = '78578';
    arc.Oracle_AR_Customer_ID__c = '9879';
    arc.Name = '000000';
    arc.Payment_Terms__c= 'Pay Term';
    
    
    arcList.add(arc);
    insert arcList ;
    
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
    
    
       List<Contact> cntList = new List<Contact>();
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
        system.debug('Account ID is ---->'+acc.id);
        BC2Contact.AccountId = acc.id;
        
        cntList.add(BC2Contact);
        insert cntList;
        
        BC2Contact.ownerid = '00540000001bR7gAAE';
        update BC2Contact;
        
    map <Id, Contact> cnctMap = new map <Id, Contact>();
    cnctMap.put(BC2Contact.Id, BC2Contact);
    
    Test.StartTest();
       
    BatchableContactUpdate obj1 = new BatchableContactUpdate(cnctMap);
    Database.executeBatch(obj1);
    
    Test.StopTest();
            
    }
       
       
   } 
 }