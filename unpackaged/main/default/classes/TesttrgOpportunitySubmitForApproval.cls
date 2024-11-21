@isTest(SeeAllData=false)
private class TesttrgOpportunitySubmitForApproval {
  
  private static User ADMIN_USER = [SELECT Id FROM User WHERE Profile.Name = 'EMEA System Administrator' AND isActive = true and ManagerId != null LIMIT 1] ;
  
    static testMethod void myUnitTest() {
        system.runAs(ADMIN_USER){
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

      SOPAuthentication__c newAuth = new SOPAuthentication__c();
            newAuth.Name = 'Login Credentials';
            newAuth.Password__c = 'lalalala';
            newAuth.Username__c = 'lalalala';
            insert newAuth;      

            SOPService__c serv = new SOPService__c();
            serv.Name = 'Default';
            serv.URL__c = 'test';
            insert serv;      

      Test.startTest();
             
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
      insert(Opp1); 
      
      Opp1.RFP_Due_Date__c = Date.newInstance(DateTime.now().yearGmt()-1,12,2);
      Opp1.Requested_Stage__c = 'PS';
      update(Opp1);
      
      test.stopTest();
        
      /*set<Id> SoOpps = new set<Id>();
      List<Opportunity> LoOppportunities = [Select Id, Name, Facility__c From Opportunity Where Id = :Opp1.Id];
      
      for (Opportunity objopp : LoOppportunities) 
      {
            SoOpps.add(opp1.Id);
      }     
      
      if (SoOpps.size() > 0)
      {
        map<Id,Id> MoProcessInstance  = new map<Id, Id>();
        set<Id> SoProcessInstance = new set<Id>();
      
      list<ProcessInstance> ProcInst = [Select Id, TargetObjectId From ProcessInstance where Status in ('Pending') limit 5 ];   
        
        if (ProcInst != null)
        {
          for(ProcessInstance pi : ProcInst)
          {
              MoProcessInstance.put(pi.TargetObjectId,pi.Id);         
          }
        }

          
          }
          
          Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
          req1.setComments('Submitting request for approval.');
          req1.setObjectId(opp1.Id);  
          
          test.stopTest();*/
          }
   }    
}