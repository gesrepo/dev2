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
private class TestLOBDetailsCalculations 
{      
    static testMethod void myUnitTest() 
    {
        User u = getUser();
        system.runAs(u)
        {
            //Create User (for Owner)            
            ID OwnerId = UserInfo.getUserId();
        
            //Create User Sales Person
            ID SalesRepId = UserInfo.getUserId();
            
            //Create facility Account
            Account facility = getFacilityAccount(SalesRepId);
            insert facility;
            
            //Create Firm Account
            Account firm = getFirmAccount(SalesRepId);
            insert firm;
            
            //Create Show
            Show__c Show = getShow(SalesRepId, firm.Id);
            insert show;
            
            Opportunity Opp1 = new Opportunity();
            Opp1.Job_Number__c = '201212313';        
            Opp1.OwnerId = OwnerId;   
            Opp1.Sales_Person__c = SalesRepId;        
            Opp1.Sales_Location__c = '110- Las Vegas';        
            Opp1.Name = 'MyTestShow # 1';        
            Opp1.Prime_Contractor__c = null;        
            Opp1.Production_Location__c = '110- Las Vegas';        
            Opp1.Facility__c = Facility.Id;        
            Opp1.StageName = 'CR';        
            Opp1.Amount = 1000;        
            Opp1.Probability = 0;        
            Opp1.Type = 'ITYFTY';        
            Opp1.New_Repeat__c = 'New';        
            Opp1.Frequency__c = 'B1';        
            Opp1.AccountId = Firm.Id;       
            Opp1.Show_Name__c = Show.Id;        
            Opp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('EMEA - Exhibition').getRecordTypeId();              
            Opp1.Show_Open_Date__c = Date.newInstance(DateTime.now().yearGmt()-1,12,1);       
            Opp1.Show_Close_Date__c = Date.today().addDays(1);
            Opp1.CloseDate = Date.newInstance(DateTime.now().yearGmt()-1,12,2); 
            opp1.Requested_Stage__c = '';
            opp1.Show_Occurrence__c =  opp1.id;
            opp1.Show_Name__c = Show.id;                        
            
            Opportunity Opp2 = new Opportunity();
            Opp2.Job_Number__c = '201212313';        
            Opp2.OwnerId = OwnerId;   
            Opp2.Sales_Person__c = SalesRepId;        
            Opp2.Sales_Location__c = '110- Las Vegas';        
            Opp2.Name = 'MyTestShow # 1';        
            Opp2.Prime_Contractor__c = null;        
            Opp2.Production_Location__c = '110- Las Vegas';        
            Opp2.Facility__c = Facility.Id;        
            Opp2.StageName = 'CR';        
            Opp2.Amount = 1000;        
            Opp2.Probability = 0;        
            Opp2.Type = 'ITYFTY';        
            Opp2.New_Repeat__c = 'New';        
            Opp2.Frequency__c = 'B1';        
            Opp2.AccountId = Firm.Id;       
            Opp2.Show_Name__c = Show.Id;        
            Opp2.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Master Show Occurrence').getRecordTypeId();              
            Opp2.Show_Open_Date__c = Date.newInstance(DateTime.now().yearGmt()-1,12,1);       
            Opp2.Show_Close_Date__c = Date.today().addDays(2);
            Opp2.CloseDate = Date.newInstance(DateTime.now().yearGmt()-1,12,2); 
            opp2.Requested_Stage__c = '';
            opp2.Show_Occurrence__c =  opp1.id;
            opp2.Show_Name__c = Show.id;   
            opp2.Prime_Contractor__c = Firm.Id;         
            insert new list<Opportunity>{opp1, opp2};  
            
            LOBDetailsCalculations.LOBDetailsCalculations(new Set<Id>{show.Id});
            LOBDetailsCalculations.NewLOBDetailsCalculations(new Set<Id>{show.Id});
        }
    }
    static testMethod void myUnitTest2() 
    {
        User u = getUser();
        system.runAs(u)
        {
            //Create User (for Owner)            
            ID OwnerId = UserInfo.getUserId();
        
            //Create User Sales Person
            ID SalesRepId = UserInfo.getUserId();
            
            //Create facility Account
            Account facility = getFacilityAccount(SalesRepId);
            insert facility;
            
            //Create Firm Account
            Account firm = getFirmAccount(SalesRepId);
            insert firm;
            
            //Create Show
            Show__c Show = getShow(SalesRepId, firm.Id);
            insert show;
            
            Opportunity Opp1 = new Opportunity();
            Opp1.Job_Number__c = '201212313';        
            Opp1.OwnerId = OwnerId;   
            Opp1.Sales_Person__c = SalesRepId;        
            Opp1.Sales_Location__c = '110- Las Vegas';        
            Opp1.Name = 'MyTestShow # 1';        
            Opp1.Prime_Contractor__c = null;        
            Opp1.Production_Location__c = '110- Las Vegas';        
            Opp1.Facility__c = Facility.Id;        
            Opp1.StageName = 'CR';        
            Opp1.Amount = 1000;        
            Opp1.Probability = 0;        
            Opp1.Type = 'ITYFTY';        
            Opp1.New_Repeat__c = 'New';        
            Opp1.Frequency__c = 'B1';        
            Opp1.AccountId = Firm.Id;       
            Opp1.Show_Name__c = Show.Id;        
            Opp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('AV - CR').getRecordTypeId();              
            Opp1.Show_Open_Date__c = Date.newInstance(DateTime.now().yearGmt()-1,12,1);       
            Opp1.Show_Close_Date__c = Date.today().addDays(1);
            Opp1.CloseDate = Date.newInstance(DateTime.now().yearGmt()-1,12,2); 
            opp1.Requested_Stage__c = '';
            opp1.Show_Occurrence__c =  opp1.id;
            opp1.Show_End_Date_Time__c = system.today();
            opp1.Show_Name__c = Show.id;                        
            insert opp1;
            
            Test.startTest();
            Opportunity Opp2 = new Opportunity();
            Opp2.Job_Number__c = '201212313';        
            Opp2.OwnerId = OwnerId;   
            Opp2.Sales_Person__c = SalesRepId;        
            Opp2.Sales_Location__c = '110- Las Vegas';        
            Opp2.Name = 'MyTestShow # 1';        
            Opp2.Prime_Contractor__c = null;        
            Opp2.Production_Location__c = '110- Las Vegas';        
            Opp2.Facility__c = Facility.Id;        
            Opp2.StageName = 'CR';        
            Opp2.Amount = 1000;        
            Opp2.Probability = 0;        
            Opp2.Type = 'ITYFTY';        
            Opp2.New_Repeat__c = 'New';        
            Opp2.Frequency__c = 'B1';        
            Opp2.AccountId = Firm.Id;       
            Opp2.Show_Name__c = Show.Id;        
            Opp2.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('EMEA - AV').getRecordTypeId();              
            Opp2.Show_Open_Date__c = Date.newInstance(DateTime.now().yearGmt()-1,12,1);       
            Opp2.Show_Close_Date__c = Date.today().addDays(2);
            Opp2.CloseDate = Date.newInstance(DateTime.now().yearGmt()-1,12,2); 
            opp2.Requested_Stage__c = '';
            opp2.Show_Occurrence__c =  opp1.id;
            opp2.Show_Name__c = Show.id;   
            opp2.Prime_Contractor__c = Firm.Id;  
            opp2.Show_End_Date_Time__c = system.today();   
            insert opp2;                          
            Test.stopTest();
            
            LOBDetailsCalculations.LOBDetailsCalculations(new Set<Id>{show.Id});    
            LOBDetailsCalculations.NewLOBDetailsCalculations(new Set<Id>{show.Id});        
        }
    }
    //Housing -1 
    static testMethod void myUnitTest3() 
    {
        User u = getUser();
        system.runAs(u)
        {
            //Create User (for Owner)            
            ID OwnerId = UserInfo.getUserId();
        
            //Create User Sales Person
            ID SalesRepId = UserInfo.getUserId();
            
            //Create facility Account
            Account facility = getFacilityAccount(SalesRepId);
            insert facility;
            
            //Create Firm Account
            Account firm = getFirmAccount(SalesRepId);
            insert firm;
            
            //Create Show
            Show__c Show = getShow(SalesRepId, firm.Id);
            insert show;
                        
            Opportunity Opp1 = new Opportunity();
            Opp1.Job_Number__c = '201212313';        
            Opp1.OwnerId = OwnerId;   
            Opp1.Sales_Person__c = SalesRepId;        
            Opp1.Sales_Location__c = '110- Las Vegas';        
            Opp1.Name = 'MyTestShow # 1';        
            Opp1.Prime_Contractor__c = null;        
            Opp1.Production_Location__c = '110- Las Vegas';        
            Opp1.Facility__c = Facility.Id;        
            Opp1.StageName = 'CR';        
            Opp1.Amount = 1000;        
            Opp1.Probability = 0;        
            Opp1.Type = 'ITYFTY';        
            Opp1.New_Repeat__c = 'New';        
            Opp1.Frequency__c = 'B1';        
            Opp1.AccountId = Firm.Id;       
            Opp1.Show_Name__c = Show.Id;        
            Opp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('EMEA – Housing').getRecordTypeId();              
            Opp1.Show_Open_Date__c = Date.newInstance(DateTime.now().yearGmt()-1,12,1);       
            Opp1.Show_Close_Date__c = Date.today().addDays(1);
            Opp1.CloseDate = Date.newInstance(DateTime.now().yearGmt()-1,12,2); 
            opp1.Requested_Stage__c = '';
            opp1.Show_Occurrence__c =  opp1.id;
            opp1.Show_End_Date_Time__c = system.today();
            opp1.Show_Name__c = Show.id;                        
            insert opp1;
            
            Test.startTest();
            Opportunity Opp2 = new Opportunity();
            Opp2.Job_Number__c = '201212313';        
            Opp2.OwnerId = OwnerId;   
            Opp2.Sales_Person__c = SalesRepId;        
            Opp2.Sales_Location__c = '110- Las Vegas';        
            Opp2.Name = 'MyTestShow # 1';        
            Opp2.Prime_Contractor__c = null;        
            Opp2.Production_Location__c = '110- Las Vegas';        
            Opp2.Facility__c = Facility.Id;        
            Opp2.StageName = 'CR';        
            Opp2.Amount = 1000;        
            Opp2.Probability = 0;        
            Opp2.Type = 'ITYFTY';        
            Opp2.New_Repeat__c = 'New';        
            Opp2.Frequency__c = 'B1';        
            Opp2.AccountId = Firm.Id;       
            Opp2.Show_Name__c = Show.Id;        
            Opp2.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('EMEA – Housing').getRecordTypeId();              
            Opp2.Show_Open_Date__c = Date.newInstance(DateTime.now().yearGmt()-1,12,1);       
            Opp2.Show_Close_Date__c = Date.today().addDays(2);
            Opp2.CloseDate = Date.newInstance(DateTime.now().yearGmt()-1,12,2); 
            opp2.Requested_Stage__c = '';
            opp2.Show_Occurrence__c =  opp1.id;
            opp2.Show_Name__c = Show.id;   
            opp2.Prime_Contractor__c = Firm.Id;  
            opp2.Show_End_Date_Time__c = system.today();   
            insert opp2;                          
            Test.stopTest();
            
            LOBDetailsCalculations.LOBDetailsCalculations(new Set<Id>{show.Id});
            LOBDetailsCalculations.NewLOBDetailsCalculations(new Set<Id>{show.Id});            
        }
    }
    static testMethod void myUnitTest4() 
    {
        User u = getUser();
        system.runAs(u)
        {
            //Create User (for Owner)            
            ID OwnerId = UserInfo.getUserId();
        
            //Create User Sales Person
            ID SalesRepId = UserInfo.getUserId();
            
            //Create facility Account
            Account facility = getFacilityAccount(SalesRepId);
            insert facility;
            
            //Create Firm Account
            Account firm = getFirmAccount(SalesRepId);
            insert firm;
            
            //Create Show
            Show__c Show = getShow(SalesRepId, firm.Id);
            show.Registration_Not_Applicable__c = false;
            insert show;
            
            Opportunity Opp1 = new Opportunity();
            Opp1.Job_Number__c = '201212313';        
            Opp1.OwnerId = OwnerId;   
            Opp1.Sales_Person__c = SalesRepId;        
            Opp1.Sales_Location__c = '110- Las Vegas';        
            Opp1.Name = 'MyTestShow # 1';        
            Opp1.Prime_Contractor__c = null;        
            Opp1.Production_Location__c = '110- Las Vegas';        
            Opp1.Facility__c = Facility.Id;        
            Opp1.StageName = 'CR';        
            Opp1.Amount = 1000;        
            Opp1.Probability = 0;        
            Opp1.Type = 'ITYFTY';        
            Opp1.New_Repeat__c = 'New';        
            Opp1.Frequency__c = 'B1';        
            Opp1.AccountId = Firm.Id;       
            Opp1.Show_Name__c = Show.Id;        
            Opp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('US - Registration').getRecordTypeId();              
            Opp1.Show_Open_Date__c = Date.newInstance(DateTime.now().yearGmt()-1,12,1);       
            Opp1.Show_Close_Date__c = Date.today().addDays(1);
            Opp1.CloseDate = Date.newInstance(DateTime.now().yearGmt()-1,12,2); 
            opp1.Requested_Stage__c = '';
            opp1.Show_Occurrence__c =  opp1.id;
            opp1.Show_Close_Date__c = system.today();
            opp1.Show_Name__c = Show.id;                        
            insert opp1;
            
            Opportunity Opp2 = new Opportunity();
            Opp2.Job_Number__c = '201212313';        
            Opp2.OwnerId = OwnerId;   
            Opp2.Sales_Person__c = SalesRepId;        
            Opp2.Sales_Location__c = '110- Las Vegas';        
            Opp2.Name = 'MyTestShow # 1';        
            Opp2.Prime_Contractor__c = null;        
            Opp2.Production_Location__c = '110- Las Vegas';        
            Opp2.Facility__c = Facility.Id;        
            Opp2.StageName = 'CR';        
            Opp2.Amount = 1000;        
            Opp2.Probability = 0;        
            Opp2.Type = 'ITYFTY';        
            Opp2.New_Repeat__c = 'New';        
            Opp2.Frequency__c = 'B1';        
            Opp2.AccountId = Firm.Id;       
            Opp2.Show_Name__c = Show.Id;        
            Opp2.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('US - Registration').getRecordTypeId();
            Opp2.Show_Open_Date__c = Date.newInstance(DateTime.now().yearGmt()-1,12,1);       
            Opp2.Show_Close_Date__c = Date.today().addDays(2);
            Opp2.CloseDate = Date.newInstance(DateTime.now().yearGmt()-1,12,2); 
            opp2.Requested_Stage__c = '';
            opp2.Show_Occurrence__c =  opp1.id;
            opp2.Show_Name__c = Show.id;   
            opp2.Prime_Contractor__c = Firm.Id;  
            opp2.Show_Close_Date__c = system.today();   
            insert opp2; 
            
            LOBDetailsCalculations.LOBDetailsCalculations(new Set<Id>{show.Id});       
            LOBDetailsCalculations.NewLOBDetailsCalculations(new Set<Id>{show.Id});
        }
    }
    private static User getUser()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator']; 
        User u = new User(Alias = 'culatons', 
                          Email='standarduserTestLOBDetailsCalculations@testorg.com', 
                          EmailEncodingKey='UTF-8', 
                          LastName='Testing', 
                          LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', 
                          ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', 
                          UserName='standarduserTestLOBDetailsCalculations@testorg.com');
        insert u;
        return u;
    }
    private static Account getFacilityAccount(Id SalesRepId)
    {
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
        Facility.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Facility').getRecordTypeId();
        return Facility;
    }
    private static Account getFirmAccount(Id SalesRepId)
    {
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
        Firm.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Firm').getRecordTypeId();
        return firm;
    }
    private static Show__c getShow(Id SalesRepId, Id firmId)
    {
        Show__c Show = new Show__c();
        Show.Sales_Person__c = SalesRepId;
        Show.Account__c = firmId;
        Show.Name ='International CES';
        Show.Show_Type__c = 'Food Sector';
        Show.Show_ID__c = '123456';
        return show;
    }
}