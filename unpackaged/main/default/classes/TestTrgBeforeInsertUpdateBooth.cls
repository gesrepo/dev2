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
private class TestTrgBeforeInsertUpdateBooth {

    static testMethod void myUnitTest() {
        
		//Create User (for Owner)
		ID OwnerId = UserInfo.getUserId();
		
		//Create User Sales Person
		ID SalesRepId = UserInfo.getUserId();
        
		RecordType FacilityRecordType = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Facility'];
		Id FacilityRecordTypeId = FacilityRecordType.Id;
		        
		RecordType ExhibitorRecordType = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Exhibitor'];
		Id ExhibitorRecordTypeId = ExhibitorRecordType.Id;
		        
		RecordType EDProjectRecordType = [Select Id From RecordType Where SObjectType = 'Opportunity' And Name = 'E&D - Projects'];
		Id EDProjectRecordTypeId = EDProjectRecordType.Id;
        
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
        
        //Create Exhibitor Account
        Account Exhibitor = new Account();
        Exhibitor.Sales_Person__c = SalesRepId;
        Exhibitor.Name = 'SONY ENTERTAINMENT INC';
        Exhibitor.Phone = '7022631500';
        Exhibitor.BillingStreet = '950 Grier Dr';
        Exhibitor.BillingCity = 'Las Vegas';
        Exhibitor.BillingPostalCode = '89119-0000';
        Exhibitor.BillingState = 'NV';
        Exhibitor.BillingCountry = 'US';
        Exhibitor.RecordTypeId = ExhibitorRecordTypeId;
        
        insert Exhibitor;
                
        //Create Show
        Show__c Show = new Show__c();
        Show.Sales_Person__c = SalesRepId;
        Show.Account__c = Exhibitor.Id;
        Show.Name ='International CES';
        Show.Show_Type__c = 'Food Sector';
        Show.Show_ID__c = '123456';
        
        insert Show;         
        
        //Create ShowOccurrence for E&D - Project Record Type
        Opportunity Opty = new Opportunity();
       
        Opty.OwnerId = OwnerId;
        Opty.Sales_Person__c = SalesRepId;
        Opty.Sales_Location__c = '520- Miami, Orlando, Tampa';
        Opty.Name = 'SalesRepProjectOpp';
        Opty.Prime_Contractor__c = null;
        Opty.Production_Location__c = '710- Chicago, Cleveland, Milwaukee, St. Louis';
        Opty.Facility__c = Facility.Id;
        Opty.StageName = 'CR';
        Opty.Amount = 1000;
        Opty.Type = 'ITYFTY';
        Opty.New_Repeat__c = 'New';
        Opty.Frequency__c = 'B1';
        Opty.Job_Number_Status__c = 'Open';
        Opty.AccountId = Exhibitor.Id;
        Opty.Show_Name__c = Show.Id;
        Opty.RecordTypeId = EDProjectRecordTypeId;
        
        Date OpenDate6 = Date.newInstance(DateTime.now().yearGmt()-1,12,1);
        Date CloseDate6 = Date.newInstance(DateTime.now().yearGmt()-1,12,2);
        
        Opty.Show_Open_Date__c = OpenDate6;
        Opty.Show_Close_Date__c = CloseDate6;
        Opty.CloseDate = CloseDate6;
        
        list<Opportunity> OppsToInsert = new list<Opportunity>();
        OppsToInsert.add(Opty);
        
        database.insert(OppsToInsert); 
        
        //Create Booth
        Oracle_Show_Booth__c Booth1 = new Oracle_Show_Booth__c();
        
        Booth1.CONTACT_PHONE_AREA_CODE__c = 702;
        Booth1.BOOTH_CREATION_DATE__c = Datetime.now();
        Booth1.BOOTH_ID__c = '1000';
        Booth1.BOOTH_LAST_UPDATE_DATE__c = Datetime.now();
        Booth1.BOOTH_SHARED_FLAG__c = 'Y';
        Booth1.BOOTH_TYPE__c = 'Inline';
        Booth1.BOOTH_NUMBER__c = 'Z1000';
        Booth1.BOOTH_LENGTH__c = 10;
        Booth1.Booth_Name_Searchable__c = '01100531998 SONY ENTERTAINMENT INC';
        Booth1.BOOTH_SIZE__c = 100;
        Booth1.BOOTH_WIDTH__c = 10;
        Booth1.CONTACT_PHONE_COUNTRY_CODE__c = '1';
        Booth1.CUST_ACCOUNT_ID__c = '10001';
        Booth1.CUST_CONT_ID__c = '10002';
        Booth1.ED_FLAG__c = false;
        Booth1.CONTACT_EMAIL__c = 'integrationissue@ges.com';
        Booth1.Account__c = Exhibitor.Id;
        Booth1.Exhibitor_Name_Denormalized__c = 'SONY ENTERTAINMENT INC';
        Booth1.CONTACT_PHONE_EXTENSION__c = 1500;
        Booth1.CONTACT_FAX__c = '7022631501';
        Booth1.CONTACT_FIRST_NAME__c = 'Jimmy';
        Booth1.INACTIVE_FLAG__c = false;
        Booth1.CONTACT_LAST_NAME__c = 'Johnson';
        Booth1.Logistics_Sales_Stage__c = 'Qualification';
        Booth1.CONTACT_PHONE__c = '2631500';
        Booth1.PROJECT_NUMBER__c = '01100531998';
        Booth1.SHOW_ID__c = 'CES';
        Booth1.Show_Name_Denormalized__c = 'International CES';
        Booth1.Show_Occurrence__c = Opty.Id;
        Booth1.SHOW_ORG_FLAG__c = false;
        Booth1.THIRD_PARTY_FLAG__c = false;
        
        Database.insert(Booth1);
    }
}