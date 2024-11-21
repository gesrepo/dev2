/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestTrgUpdateOpportunityName {
  
  private static User ADMIN_USER = [SELECT Id FROM User WHERE Profile.Name = 'EMEA System Administrator' AND isActive = true LIMIT 1];
  
    static testMethod void myUnitTest() {
        system.runAs(ADMIN_USER){
         Test.startTest();
         try{
      //Create User (for Owner)
      ID OwnerId = UserInfo.getUserId();
      
      //Create User Sales Person
      ID SalesRepId = UserInfo.getUserId();
      
      SOPAuthentication__c newAuth = new SOPAuthentication__c();
      newAuth.Name = 'Login Credentials';
      newAuth.Password__c = 'lalalala';
      newAuth.Username__c = 'lalalala';
      insert newAuth;
      
        insert new SOPService__c(Name = 'Default', URL__c = 'https://uatapi.viad.com/GES/v2/SOPService.svc');
           
      RecordType FacilityRecordType = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Facility'];
      Id FacilityRecordTypeId = FacilityRecordType.Id;
                   
      RecordType FirmRecordType = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Firm'];
      Id FirmRecordTypeId = FirmRecordType.Id;
              
      RecordType SalesRepRecordType = [Select Id From RecordType Where SObjectType = 'Opportunity' And Name = 'AV - Master'];
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
      
       Opportunity Opp2 = new Opportunity();
      Opp2.Job_Number__c = '201212313';        
      Opp2.OwnerId = OwnerId;   
      Opp2.Sales_Person__c = SalesRepId;        
      Opp2.Sales_Location__c = '110- Las Vegas';        
      Opp2.Name = 'MyTestShow # 1';        
      Opp2.Prime_Contractor__c = null;        
      Opp2.Production_Location__c = '110- Las Vegas';        
      Opp2.Facility__c = Facility.Id;        
      Opp2.StageName = 'SL1';        
      Opp2.Amount = 1000;        
      Opp2.Probability = 25;        
      Opp2.Type = 'ITYFTY';        
      Opp2.New_Repeat__c = 'New';        
      Opp2.Frequency__c = 'B1';        
      Opp2.AccountId = Firm.Id;       
      Opp2.Show_Name__c = Show.Id;        
      Opp2.RecordTypeId = SalesRepRecordTypeId;                
      Opp2.Show_Open_Date__c = Date.newInstance(DateTime.now().yearGmt()-1,12,1);       
      Opp2.Show_Close_Date__c = Date.newInstance(DateTime.now().yearGmt()-1,12,2);        
      Opp2.CloseDate = Date.newInstance(DateTime.now().yearGmt()-1,12,2); 
      opp2.Requested_Stage__c = '';
      
      Database.insert(Opp2);  
      
      
      
            
             
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
      opp1.Show_Occurrence__c  = opp2.id;
     
       
      
      Database.insert(Opp1);  
      
       
          
        //  Opp1.RFP_Due_Date__c = Date.newInstance(DateTime.now().yearGmt()-1,12,2);
      Opp2.Name= 'PS';
      
     
      Database.update(Opp2);
      
      }catch(exception e){}
      
      Test.stopTest();
      
        }
    }  
}