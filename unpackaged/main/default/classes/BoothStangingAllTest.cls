@isTest
public class BoothStangingAllTest {


	@testSetup static void setup() {
				SOPAuthentication__c sAuth = new SOPAuthentication__c();
		sAuth.Name = 'Login Credentials';
		sAuth.Username__c = 'Vertiba';
		sAuth.Password__c = 'sf4GFK@)GJSv674hS/gfht4K{L';
		insert sAuth;

		SOPService__c soapServ = new SOPService__c();
		soapServ.Name = 'Default';
		soapServ.URL__c = 'https://uatapi.viad.com/GES/v2/SOPService.svc';
		insert soapServ;
	}	



    public static testmethod void test1() {
        
        RecordType facilityRecordType = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Facility'];
		Id facilityRT = facilityRecordType.Id;
        Id userId = UserInfo.getUserId();
        List<Account> aList = new List<Account>();
        
        Account Facility = new Account(
	        Sales_Person__c = userId,
	        Name = 'MyTestFacilityName',
	        Type = 'Hotel',
	        GES_Status__c = 'Preferred',
	        LMS_Facility_ID__c = 'ABCFAC',
	        BillingStreet = '950 Grier Dr',
	        BillingCity = 'Las Vegas',
	        BillingPostalCode = '89119-0000',
	        BillingState = 'NV',
	        BillingCountry = 'US',
	        RecordTypeId = facilityRT
        );
        aList.add(Facility);
        
        RecordType FirmRecordType = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Firm'];
		Id FirmRecordTypeId = FirmRecordType.Id;
	
	  	Account Firm = new Account(
			Sales_Person__c = userId,
			Name = 'SONY ENTERTAINMENT INC',
			Phone = '7022631500',
			BillingStreet = '950 Grier Dr',
			BillingCity = 'Las Vegas',
			BillingPostalCode = '89119-0000',
			BillingState = 'NV',
			BillingCountry = 'US',
			RecordTypeId = FirmRecordTypeId
		);
		aList.add(firm);
        
        insert aList;
        
        //Create Show
        Show__c Show = new Show__c(
        	Sales_Person__c = userId,
	        Account__c = firm.Id,
	        Name ='MyTestShow',
	        Show_Type__c = 'Food Sector',
	        Show_ID__c = '123456'
        );
        
		insert Show;         
        
        Opportunity opp = new Opportunity(
        	OwnerId = userId,
	        Sales_Person__c = userId,
	        Sales_Location__c = '520- Miami, Orlando, Tampa',
	        Name = 'SalesRepProjectOpp',
	        Prime_Contractor__c = Firm.Id,
	        Production_Location__c = '710- Chicago, Cleveland, Milwaukee, St. Louis',
	        Facility__c = Facility.Id,
	        StageName = 'CR',
	        Amount = 1000,
	        Type = 'ITYFTY',
	        New_Repeat__c = 'New',
	        Frequency__c = 'B1',
	        Job_Number_Status__c = 'Open',
	        AccountId = Firm.Id,
	        Show_Name__c = Show.Id,
	        CloseDate = date.today()
        );
    	insert opp;
        
        
        Booth_Upload__c bu = new Booth_Upload__c(
        	Opportunity__c = opp.Id
        );
        insert bu;
        
        Booth_Upload_Settings__c bus = new Booth_Upload_Settings__c();
        bus.Booth_Upload_Id__c = bu.id;
        bus.User_Id__c = UserInfo.getUserId();
        bus.Name = UserInfo.getUserName();
        insert bus;
        
        Booth_Staging__c bs = new Booth_Staging__c();
        insert bs;
        
        bs = [SELECT Booth_Upload__c FROM Booth_Staging__c WHERE Id = :bs.Id];
        System.AssertEquals(bu.Id, bs.Booth_Upload__c);
    }
}