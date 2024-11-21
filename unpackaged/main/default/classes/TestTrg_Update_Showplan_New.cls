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
@isTest(SeeAllData=false)
private class TestTrg_Update_Showplan_New {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        //Create User (for Owner)
        ID OwnerId = UserInfo.getUserId();
        
        //Create User Sales Person
        ID SalesRepId = UserInfo.getUserId();
        
        //Create Facility
        Account Facility = new Account();
        Facility.Sales_Person__c = SalesRepId;
        Facility.Name = 'MyTestFacilityName';
        Facility.Type = 'Hotel';
        Facility.GES_Status__c = 'Preferred';
        Facility.LMS_Facility_ID__c = 'ABCFAC';
        Facility.BillingStreet = '950 Grier Dr';
        Facility.BillingCity = 'Las Vegas';
        Facility.BillingPostalCode = '89119-0000';
        Facility.BillingState = 'Nevada';
        Facility.BillingCountry = 'US';
        Facility.RecordTypeId = '012400000005NYN';
        
        insert Facility;
        
        //Create Account
        Account Exhibitor = new Account();
        Exhibitor.Sales_Person__c = SalesRepId;
        Exhibitor.Name = 'MyTestExhibitorName';
        Exhibitor.Phone = '7022631500';
        Exhibitor.BillingStreet = '950 Grier Dr';
        Exhibitor.BillingCity = 'Las Vegas';
        Exhibitor.BillingPostalCode = '89119-0000';
        Exhibitor.BillingState = 'NV';
        Exhibitor.BillingCountry = 'US';
        Exhibitor.RecordTypeId = '0124000000012Ob';
        
        insert Exhibitor;
                
        //Create Show
        Show__c Show = new Show__c();
        Show.Sales_Person__c = SalesRepId;
        Show.Account__c = Exhibitor.Id;
        Show.Name ='MyTestShow';
        Show.Show_Type__c = 'Food Sector';
        Show.Show_ID__c = '123456';
        
        Test.startTest();
        insert Show;        
        
        Id EDRecordTypeId = null;
        Id EDWonRecordTypeId = null;
        Id EDProposalRecordTypeId = null;
        //Id BEProjectsRecordTypeId = null;
        //Id BEProjectsReadOnlyRecordTypeId = null;
        Id SalesRepShowOccurrenceRecordTypeId = null;
    
        // Fetch RecordTypeIds
        List<string> listRecordTypes = new List<string>();
        listRecordTypes.add(Properties.edProjectsRecordTypeName);
        listRecordTypes.add(Properties.edProjectsProposalRecordTypeName);
        listRecordTypes.add(Properties.edProjectsReadOnlyRecordTypeName);
        //listRecordTypes.add(Properties.beProjectsRecordTypeName);
        //listRecordTypes.add(Properties.beProjectsReadOnlyRecordTypeName); 
        listRecordTypes.add('Sales Rep Show Occurrence');
        
        for(RecordType r : [SELECT Id, Name FROM RecordType WHERE Name IN : listRecordTypes AND SobjectType = 'Opportunity']){
          if(r.Name == Properties.edProjectsRecordTypeName){
              EDRecordTypeId = r.Id;
            }
            else if(r.Name == Properties.edProjectsProposalRecordTypeName){
              EDWonRecordTypeId = r.Id;
            }
            else if(r.Name == Properties.edProjectsReadOnlyRecordTypeName){
              EDProposalRecordTypeId = r.Id;
            }
            /* else if (r.Name == Properties.beProjectsRecordTypeName) {
              BEProjectsRecordTypeId = r.Id;
            }
            else if (r.Name == Properties.beProjectsReadOnlyRecordTypeName) {
              BEProjectsReadOnlyRecordTypeId = r.Id;
            } */
            else if (r.Name == 'Sales Rep Show Occurrence') {
                SalesRepShowOccurrenceRecordTypeId = r.Id;
            }
        }        
        
        /*
        //Create ShowOccurrence for E&D Record Type
        Opportunity EDShowOcc = new Opportunity();
       
        EDShowOcc.OwnerId = OwnerId;
        EDShowOcc.Sales_Person__c = SalesRepId;
        EDShowOcc.Sales_Location__c = '520- Miami, Orlando, Tampa';
        EDShowOcc.Name = 'E&DOpp';
        EDShowOcc.Prime_Contractor__c = null;
        EDShowOcc.Production_Location__c = '710- Chicago, Cleveland, Milwaukee, St. Louis';
        EDShowOcc.Facility__c = Facility.Id;
        EDShowOcc.StageName = 'OF';
        EDShowOcc.Amount = 1000;
        EDShowOcc.Type = 'ITYFTY';
        EDShowOcc.New_Repeat__c = 'New';
        EDShowOcc.Frequency__c = 'B1';
        EDShowOcc.Job_Number_Status__c = 'Open';
        EDShowOcc.AccountId = Exhibitor.Id;
        EDShowOcc.Show_Name__c = Show.Id;
        EDShowOcc.RecordTypeId = EDRecordTypeId;
        
        Date OpenDate1 = Date.newInstance(DateTime.now().yearGmt(),12,1);
        Date CloseDate1 = Date.newInstance(DateTime.now().yearGmt(),12,2);
        
        EDShowOcc.Show_Open_Date__c = OpenDate1;
        EDShowOcc.Show_Close_Date__c = CloseDate1;
        EDShowOcc.CloseDate = CloseDate1;
        
        //Create ShowOccurrence for E&D Won Record Type
        Opportunity EDWonShowOcc = new Opportunity();
       
        EDWonShowOcc.OwnerId = OwnerId;
        EDWonShowOcc.Sales_Person__c = SalesRepId;
        EDWonShowOcc.Sales_Location__c = '520- Miami, Orlando, Tampa';
        EDWonShowOcc.Name = 'E&DWonOpp';
        EDWonShowOcc.Prime_Contractor__c = null;
        EDWonShowOcc.Production_Location__c = '710- Chicago, Cleveland, Milwaukee, St. Louis';
        EDWonShowOcc.Facility__c = Facility.Id;
        EDWonShowOcc.StageName = 'OF';
        EDWonShowOcc.Amount = 1000;
        EDWonShowOcc.Type = 'ITYFTY';
        EDWonShowOcc.New_Repeat__c = 'New';
        EDWonShowOcc.Frequency__c = 'B1';
        EDWonShowOcc.Job_Number_Status__c = 'Open';
        EDWonShowOcc.AccountId = Exhibitor.Id;
        EDWonShowOcc.Show_Name__c = Show.Id;
        
        Date OpenDate2 = Date.newInstance(DateTime.now().yearGmt(),12,1);
        Date CloseDate2 = Date.newInstance(DateTime.now().yearGmt(),12,2);
        
        EDWonShowOcc.Show_Open_Date__c = OpenDate2;
        EDWonShowOcc.Show_Close_Date__c = CloseDate2;
        EDWonShowOcc.CloseDate = CloseDate2;
        EDWonShowOcc.RecordTypeId = EDWonRecordTypeId;
              
        //Create ShowOccurrence for E&D Proposal Record Type
        Opportunity EDProposalShowOcc = new Opportunity();
       
        EDProposalShowOcc.OwnerId = OwnerId;
        EDProposalShowOcc.Sales_Person__c = SalesRepId;
        EDProposalShowOcc.Sales_Location__c = '520- Miami, Orlando, Tampa';
        EDProposalShowOcc.Name = 'E&DProposalOpp';
        EDProposalShowOcc.Prime_Contractor__c = null;
        EDProposalShowOcc.Production_Location__c = '710- Chicago, Cleveland, Milwaukee, St. Louis';
        EDProposalShowOcc.Facility__c = Facility.Id;
        EDProposalShowOcc.StageName = 'OF';
        EDProposalShowOcc.Amount = 1000;
        EDProposalShowOcc.Type = 'ITYFTY';
        EDProposalShowOcc.New_Repeat__c = 'New';
        EDProposalShowOcc.Frequency__c = 'B1';
        EDProposalShowOcc.Job_Number_Status__c = 'Open';
        EDProposalShowOcc.AccountId = Exhibitor.Id;
        EDProposalShowOcc.Show_Name__c = Show.Id;
        EDProposalShowOcc.RecordTypeId = EDProposalRecordTypeId;
        
        Date OpenDate3 = Date.newInstance(DateTime.now().yearGmt(),12,1);
        Date CloseDate3 = Date.newInstance(DateTime.now().yearGmt(),12,2);
        
        EDProposalShowOcc.Show_Open_Date__c = OpenDate3;
        EDProposalShowOcc.Show_Close_Date__c = CloseDate3;
        EDProposalShowOcc.CloseDate = CloseDate3;
        
        */
        
        /*
        //Create ShowOccurrence for BE Projects Record Type
        Opportunity BEProjectsShowOcc = new Opportunity();
       
        BEProjectsShowOcc.OwnerId = OwnerId;
        BEProjectsShowOcc.Sales_Person__c = SalesRepId;
        BEProjectsShowOcc.Sales_Location__c = '520- Miami, Orlando, Tampa';
        BEProjectsShowOcc.Name = 'BEProjectOpp';
        BEProjectsShowOcc.Prime_Contractor__c = null;
        BEProjectsShowOcc.Production_Location__c = '710- Chicago, Cleveland, Milwaukee, St. Louis';
        BEProjectsShowOcc.Facility__c = Facility.Id;
        BEProjectsShowOcc.StageName = 'OF';
        BEProjectsShowOcc.Amount = 1000;
        BEProjectsShowOcc.Type = 'ITYFTY';
        BEProjectsShowOcc.New_Repeat__c = 'New';
        BEProjectsShowOcc.Frequency__c = 'B1';
        BEProjectsShowOcc.Job_Number_Status__c = 'Open';
        BEProjectsShowOcc.AccountId = Exhibitor.Id;
        BEProjectsShowOcc.Show_Name__c = Show.Id;
        BEProjectsShowOcc.RecordTypeId = BEProjectsRecordTypeId;
        
        Date OpenDate4 = Date.newInstance(DateTime.now().yearGmt(),12,1);
        Date CloseDate4 = Date.newInstance(DateTime.now().yearGmt(),12,2);
        
        BEProjectsShowOcc.Show_Open_Date__c = OpenDate4;
        BEProjectsShowOcc.Show_Close_Date__c = CloseDate4;
        BEProjectsShowOcc.CloseDate = CloseDate4; 
        
        //Create ShowOccurrence for BE Projects Read Only Record Type
        Opportunity BEProjectsReadOnlyShowOcc = new Opportunity();
       
        BEProjectsReadOnlyShowOcc.OwnerId = OwnerId;
        BEProjectsReadOnlyShowOcc.Sales_Person__c = SalesRepId;
        BEProjectsReadOnlyShowOcc.Sales_Location__c = '520- Miami, Orlando, Tampa';
        BEProjectsReadOnlyShowOcc.Name = 'BEProjectOpp';
        BEProjectsReadOnlyShowOcc.Prime_Contractor__c = null;
        BEProjectsReadOnlyShowOcc.Production_Location__c = '710- Chicago, Cleveland, Milwaukee, St. Louis';
        BEProjectsReadOnlyShowOcc.Facility__c = Facility.Id;
        BEProjectsReadOnlyShowOcc.StageName = 'OF';
        BEProjectsReadOnlyShowOcc.Amount = 1000;
        BEProjectsReadOnlyShowOcc.Type = 'ITYFTY';
        BEProjectsReadOnlyShowOcc.New_Repeat__c = 'New';
        BEProjectsReadOnlyShowOcc.Frequency__c = 'B1';
        BEProjectsReadOnlyShowOcc.Job_Number_Status__c = 'Open';
        BEProjectsReadOnlyShowOcc.AccountId = Exhibitor.Id;
        BEProjectsReadOnlyShowOcc.Show_Name__c = Show.Id;
        BEProjectsReadOnlyShowOcc.RecordTypeId = BEProjectsReadOnlyRecordTypeId;
        
        Date OpenDate5 = Date.newInstance(DateTime.now().yearGmt(),12,1);
        Date CloseDate5 = Date.newInstance(DateTime.now().yearGmt(),12,2);
        
        BEProjectsReadOnlyShowOcc.Show_Open_Date__c = OpenDate5;
        BEProjectsReadOnlyShowOcc.Show_Close_Date__c = CloseDate5;
        BEProjectsReadOnlyShowOcc.CloseDate = CloseDate5;
        
        */
               
        //Create ShowOccurrence for Sales Rep Show Occurrence Record Type
        Opportunity SalesRepShowOcc = new Opportunity();
       
        SalesRepShowOcc.OwnerId = OwnerId;
        SalesRepShowOcc.Sales_Person__c = SalesRepId;
        SalesRepShowOcc.Sales_Location__c = '520- Miami, Orlando, Tampa';
        SalesRepShowOcc.Name = 'SalesRepProjectOpp';
        SalesRepShowOcc.Prime_Contractor__c = null;
        SalesRepShowOcc.Production_Location__c = '710- Chicago, Cleveland, Milwaukee, St. Louis';
        SalesRepShowOcc.Facility__c = Facility.Id;
        SalesRepShowOcc.StageName = 'Closed Won';
        SalesRepShowOcc.Amount = 1000;
        SalesRepShowOcc.Type = 'ITYFTY';
        SalesRepShowOcc.New_Repeat__c = 'New';
        SalesRepShowOcc.Frequency__c = 'B1';
        SalesRepShowOcc.Job_Number_Status__c = 'Open';
        SalesRepShowOcc.AccountId = Exhibitor.Id;
        SalesRepShowOcc.Show_Name__c = Show.Id;
        SalesRepShowOcc.RecordTypeId = SalesRepShowOccurrenceRecordTypeId;
        
        Date OpenDate6 = Date.newInstance(DateTime.now().yearGmt()-1,12,1);
        Date CloseDate6 = Date.newInstance(DateTime.now().yearGmt()-1,12,2);
        
        SalesRepShowOcc.Show_Open_Date__c = OpenDate6;
        SalesRepShowOcc.Show_Close_Date__c = CloseDate6;
        SalesRepShowOcc.CloseDate = CloseDate6;
        
        list<Opportunity> OppsToInsert = new list<Opportunity>();
        
        /*
        OppsToInsert.add(EDShowOcc);
        OppsToInsert.add(EDWonShowOcc);
        OppsToInsert.add(EDProposalShowOcc);
        */
        //OppsToInsert.add(BEProjectsShowOcc);
        //OppsToInsert.add(BEProjectsReadOnlyShowOcc);
        
        OppsToInsert.add(SalesRepShowOcc);
                
        database.insert(OppsToInsert); 
        
        Show_Plan__c ShowPlan = new Show_Plan__c();
        ShowPlan.Show_Opportunity__c = SalesRepShowOcc.Id;
        ShowPlan.Proposal_Due_Date__c = Date.newInstance(DateTime.now().yearGmt()-1,DateTime.now().monthGmt()+1,1);
        ShowPlan.Previous_Occurrence_Revenue__c = 9000;
        ShowPlan.Show_Name__c = SalesRepShowOcc.Show_Name__c;
        
        //Database.insert(ShowPlan, false);
        
        //database.update(OppsToInsert);
        
        //Create ShowOccurrence for Sales Rep Show Occurrence Record Type
        Opportunity NextSalesRepShowOcc = new Opportunity();
       
        NextSalesRepShowOcc.OwnerId = OwnerId;
        NextSalesRepShowOcc.Sales_Person__c = SalesRepId;
        NextSalesRepShowOcc.Sales_Location__c = '520- Miami, Orlando, Tampa';
        NextSalesRepShowOcc.Name = 'SalesRepProjectOpp';
        NextSalesRepShowOcc.Prime_Contractor__c = null;
        NextSalesRepShowOcc.Production_Location__c = '710- Chicago, Cleveland, Milwaukee, St. Louis';
        NextSalesRepShowOcc.Facility__c = Facility.Id;
        NextSalesRepShowOcc.StageName = 'OF';
        NextSalesRepShowOcc.Amount = 1000;
        NextSalesRepShowOcc.Type = 'ITYFTY';
        NextSalesRepShowOcc.New_Repeat__c = 'New';
        NextSalesRepShowOcc.Frequency__c = 'B1';
        NextSalesRepShowOcc.Job_Number_Status__c = 'Open';
        NextSalesRepShowOcc.AccountId = Exhibitor.Id;
        NextSalesRepShowOcc.Show_Name__c = Show.Id;
        NextSalesRepShowOcc.RecordTypeId = SalesRepShowOccurrenceRecordTypeId;
        
        Date OpenDate7 = Date.newInstance(DateTime.now().yearGmt(),12,1);
        Date CloseDate7 = Date.newInstance(DateTime.now().yearGmt(),12,2);
        
        NextSalesRepShowOcc.Show_Open_Date__c = OpenDate7;
        NextSalesRepShowOcc.Show_Close_Date__c = CloseDate7;
        NextSalesRepShowOcc.CloseDate = CloseDate7;
        
        list<Opportunity> NextOppsToInsert = new list<Opportunity>();
               
        NextOppsToInsert.add(NextSalesRepShowOcc);
                
        //database.insert(NextOppsToInsert); 
        
        Show_Plan__c NextShowPlan = new Show_Plan__c();
        NextShowPlan.Show_Opportunity__c = NextSalesRepShowOcc.Id;
        NextShowPlan.Proposal_Due_Date__c = Date.newInstance(DateTime.now().yearGmt(),DateTime.now().monthGmt()+1,1);
        NextShowPlan.Previous_Occurrence_Revenue__c = 9000;
        NextShowPlan.Show_Name__c = NextSalesRepShowOcc.Show_Name__c;
        
        //Database.insert(NextShowPlan, false);
        
        //NextOppsToInsert.add(SalesRepShowOcc);
        
        List<Show_Plan__c>  SP = new List<Show_Plan__c>();
        SP.add(ShowPlan);
        SP.add(NextShowPlan);
        
        database.insert(SP);  
        
        SalesRepShowOcc.Account_Plan__c = ShowPlan.Id;
        NextSalesRepShowOcc.Account_Plan__c = NextShowPlan.Id;
                
        database.insert(NextOppsToInsert);
        
        test.stopTest();
     
               
    }
}