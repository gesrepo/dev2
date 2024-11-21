/* Class Name: OpportunityWrapper */

@isTest
                                
public class Test_OpportunityWrapper  {

    public ID oppId;
    public string arCustomerNo;
    public string GBMSId;
    public string arCustomerID;

static  testMethod void testMethod1() {

Test.startTest();
RecordType rt = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' and name= 'Exhibitor' LIMIT 1];
      ID OwnerId = UserInfo.getUserId();
      
      //Create User Sales Person
      ID SalesRepId = UserInfo.getUserId();
      
      RecordType FacilityRecordType = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Facility'];
      Id FacilityRecordTypeId = FacilityRecordType.Id;

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
      
      Account Acc= new Account();
    Acc.Name= 'Test';
    Acc.BillingStreet= 'Test1';
    Acc.BillingCity= 'Delhi';
    Acc.BillingState= 'New Delhi';
    Acc.BillingPostalCode= '201013';
    Acc.BillingCountry= 'US';
    Acc.EMEA__c = False; 
    Acc.Melissa_Integration_Status__c = 'Success';
    Acc.RecordTypeId = rt.id;
    Acc.GBMS_CustomerID__c ='123456';
    Acc.ORACLE_AR_CUST_NUMBER__c='12345';
    Acc.ORACLE_AR_CUST_ACCOUNT_ID__c='44444';
  //  Acc.Processed_Flag__c=true;
    //Test.StartTest();
    insert Acc;

Show__c Show = new Show__c();
      Show.Sales_Person__c = SalesRepId;
      Show.Account__c = Acc.Id;
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
      Opp1.StageName = 'AV';        
      Opp1.Amount = 1000;        
      Opp1.Probability = 0;        
      Opp1.Type = 'ITYFTY';        
      Opp1.New_Repeat__c = 'New';        
      Opp1.Frequency__c = 'B1';        
      Opp1.AccountId = Acc.Id;       
      Opp1.Show_Name__c = Show.Id;        
      //Opp1.RecordTypeId = SalesRepRecordTypeId;                
      Opp1.Show_Open_Date__c = Date.newInstance(DateTime.now().yearGmt()-1,12,1);       
      Opp1.Show_Close_Date__c = Date.newInstance(DateTime.now().yearGmt()-1,12,2);        
      Opp1.CloseDate = Date.newInstance(DateTime.now().yearGmt()-1,12,2); 
      opp1.Requested_Stage__c = '';
      opp1.Show_Occurrence__c =  opp1.id;
      opp1.Show_Name__c = Show.id;
      opp1.Oracle_AR_Customer_Number__c='123456';
      opp1.GBMS_ID__c='984356';
      opp1.Oracle_AR_Customer_ID__c='34521';
     
      Database.insert(Opp1);
      Id str1=opp1.id;
       String str2='23456';
       String str3='123456';
       String str4='0875656';
OpportunityWrapper oppty = new OpportunityWrapper(str1, str2,str3,str4);
//oppty.OpportunityWrapper111(str1, str2,str3,str4);
 //oppty.OpportunityWrapper111 obj = new oppty.OpportunityWrapper111(str1, str2,str3,str4);
Test.StopTest();
}

}