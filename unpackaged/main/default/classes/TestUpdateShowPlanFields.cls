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
private class TestUpdateShowPlanFields {

    static testMethod void myUnitTest() {
    	        
        //Create User (for Owner)
        ID OwnerId = UserInfo.getUserId();
        
        //Create User Sales Person
        ID SalesRepId = UserInfo.getUserId();
        
        RecordType SalesRepRecordType = [Select Id From RecordType Where SObjectType = 'Opportunity' And Name = 'Sales Rep Show Occurrence'];
        Id SalesRepShowOccurrenceRecordTypeId = SalesRepRecordType.Id;
        
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
        Facility.BillingState = 'NV';
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
        
		insert Show;         
        
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
        OppsToInsert.add(SalesRepShowOcc);
        
        database.insert(OppsToInsert); 

        Show_Plan__c ShowPlan = new Show_Plan__c();
        ShowPlan.Proposal_Due_Date__c = Date.newInstance(DateTime.now().yearGmt(),DateTime.now().monthGmt()+1,1);
        ShowPlan.Previous_Occurrence_Revenue__c = 9000;
        ShowPlan.Show_Name__c = SalesRepShowOcc.Show_Name__c;
        
        List<Show_Plan__c>  SP = new List<Show_Plan__c>();
        SP.add(ShowPlan);
               
        database.insert(SP);
        
        test.startTest();
        
        UpdateShowPlanFields.UpdateEmptyValues(SP);
        UpdateShowPlanFields.UpdateRevenueAndIncumbent(OppsToInsert, ShowPlan);
        UpdateShowPlanFields.UpdateDummyAndRevenue(SP, OppsToInsert);
        UpdateShowPlanFields.UpdateEmptyValues(SP);
        UpdateShowPlanFields.UpdateEmptyValuesToRevenue(SP);
        
        test.stopTest();
     
    }
}