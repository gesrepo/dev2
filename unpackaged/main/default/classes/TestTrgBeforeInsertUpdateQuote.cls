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
private class TestTrgBeforeInsertUpdateQuote {

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
		
		RecordType LogisticsDomesticQuoteRecordType = [Select Id From RecordType Where SObjectType = 'Quote__c' And Name = 'Logistics Domestic'];
		Id LogisticsDomesticQuoteRecordTypeId = LogisticsDomesticQuoteRecordType.Id;		
        
        List<Account> listAcc = new List<Account>();
        //Create Facility Account
        Account Facility = new Account();
        Facility.Sales_Person__c = SalesRepId;
		Facility.Name = 'MyTestFacilityName';
		Facility.Type = 'Hotel';
		Facility.GES_Status__c = 'Preferred';
		Facility.LMS_Facility_ID__c = 'ABCFAC';
		Facility.BillingStreet = '950 Grier Dr';
		Facility.BillingCity = 'Las Vegas';
		Facility.BillingPostalCode = '89119-1111';
		Facility.BillingState = 'NV';
		Facility.BillingCountry = 'US';
		Facility.RecordTypeId = FacilityRecordTypeId;
		        
        listAcc.add(Facility);
        		        
        //Create Exhibitor Account
        Account Exhibitor = new Account();
        Exhibitor.Sales_Person__c = SalesRepId;
        Exhibitor.Name = 'SONY ENTERTAINMENT INC';
        Exhibitor.Phone = '7022631500';
        Exhibitor.BillingStreet = '950 Grier Dr';
        Exhibitor.BillingCity = 'Las Vegas';
        Exhibitor.BillingPostalCode = '89119-1111';
        Exhibitor.BillingState = 'NV';
        Exhibitor.BillingCountry = 'US';
        Exhibitor.RecordTypeId = ExhibitorRecordTypeId;
        
        listAcc.add(Exhibitor);
        insert listAcc;
        
        List<Shipping_Address__c> listShippingAdd = new List<Shipping_Address__c>();
        Shipping_Address__c ExhibitorAddress = new Shipping_Address__c();
        ExhibitorAddress.Address_1__c = '7000 Bagel Pkwy';
        ExhibitorAddress.City__c = 'Pheonix';
        ExhibitorAddress.State__c = 'AZ';
        ExhibitorAddress.Postal_Code__c = '56044';
        ExhibitorAddress.Country__c = 'United States';
        ExhibitorAddress.Account__c = Exhibitor.Id;
        
        listShippingAdd.add(ExhibitorAddress);
        
        Shipping_Address__c ExhibitorAddress2 = new Shipping_Address__c();
        ExhibitorAddress2.Address_1__c = '7150 S Tenaya Way';
        ExhibitorAddress2.City__c = 'Las Vegas';
        ExhibitorAddress2.State__c = 'NV';
        ExhibitorAddress2.Postal_Code__c = '89123';
        ExhibitorAddress2.Country__c = 'United States';
        ExhibitorAddress2.Account__c = Exhibitor.Id;
        
        listShippingAdd.add(ExhibitorAddress2);
        insert listShippingAdd;
        
        //Create Show
        Show__c Show = new Show__c();
        Show.Sales_Person__c = SalesRepId;
        Show.Account__c = Exhibitor.Id;
        Show.Name ='International CES';
        Show.Show_Type__c = 'Food Sector';
        Show.Show_ID__c = '123456';
        
        Database.insert(Show);        
        
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
                
        database.insert(Opty);
        
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
                
        //Create Quote
        List<Quote__c> listQuote = new List<Quote__c>();
        Quote__c q = new Quote__c();
        
        q.RecordTypeId = LogisticsDomesticQuoteRecordTypeId;
        q.Quote_Subject__c = 'Roundtrip';
        q.Account_Id__c = Exhibitor.Id;
        q.Show_Occurrence__c = Opty.Id;
        q.Booth__c = Booth1.Id;
        q.Sales_Rep__c = SalesRepId;
        q.Job_Code__c = 'JOB001';
        //q.Discount_End_Date__c = Date.newInstance(2012,12,1);
        //q.Billing_Contact__c = '';
        q.Origination_Street__c = '7000 Lindell Rd';
        q.Origination_City__c = 'Las Vegas';
        q.Origination_State__c = 'NV';
        q.Origination_Postal_Code__c = '89113';
        q.Origination_Country__c = 'USA';
		q.Pickup_Show_Name__c = 'International CES';
		q.Pickup_Booth_No__c = '1000';
		q.Pickup_Show_Contractor__c = 'GES';
		q.Pickup_Contact_Name__c = 'John Doe';
		q.Pickup_Contact_Phone__c = '7022631500';
		q.Pickup_Date__c = Date.newInstance(2020,12,1);
		q.Pickup_Window_Start__c = '13:00';
		q.Destination_Street__c = '9000 Convention Dr';
		q.Destination_City__c = 'Orlando';
		q.Destination_State__c = 'FL';
		q.Destination_Postal_Code__c = '32345';
		q.Destination_Country__c = 'USA';
		q.Delivery_Show_Name__c = 'Some Delivery Show';
		q.Delivery_Booth_No__c = 'DELBOOTH';		
        q.Delivery_Show_Contractor__c = 'Freeman';
        q.Delivery_Contact_Name__c = 'Del Contact Joe';
        q.Delivery_Contact_Phone__c = '9042345767';
        q.Delivery_Date__c = Date.newInstance(2020,12,20);
        q.Delivery_Window_Start__c = '08:00';
        q.Delivery_Destination__c = 'Show Site';
        q.Class_of_Service__c = '2nd Day';
        q.Order_Date__c = Date.newInstance(2020,11,15);
        q.Shipment_Type__c = 'Air Transportation';
        q.Service_Type__c = '';
        q.Ship_To_Location__c = 'Warehouse';
        q.Inside_Pickup__c = true;
        q.Lift_Gate__c = true;
        q.Pallet_Jack__c = true;
        q.Residential_Pickup__c = true;
        q.Call_Before_Pickup__c = true;
        q.Call_Before_Delivery__c = true;
        q.Weekend_Pickup__c = true;
        q.Weekend_Delivery__c = true;
        q.Hazardous_Materials__c = true;
        q.Carrier_Notes__c = 'Carrier Notes';
        q.EDV_Amount__c = 1500;
        q.Crated_Weight__c = 250;
        q.Weight_Override__c = 500;
        q.Fuel_Surcharge__c = 50;
        q.Inside_Surcharge__c = 75;
        q.Lift_Gate_Surcharge__c = 25;
        q.Residential_Surcharge__c = 20;
        
        q.Sub_Total__c = 500;
        q.Total__c = 1000;
        q.Custom_Quote__c = true;
        q.Selection__c = 'Low';
        q.OB_Origination_Street__c = '5000 Union St';
        q.OB_Origination_City__c = 'Orlando';
        q.OB_Origination_State__c = 'FL';
        q.OB_Origination_Postal_Code__c = '32245';
        q.OB_Origination_Country__c = 'USA';
        q.OB_Pickup_Show_Name__c = 'Show Some';
        q.OB_Pickup_Booth_No__c = 'PickBooth'; 
        q.OB_Pickup_Show_Contractor__c = 'Freeman';
        q.OB_Pickup_Contact_Name__c = 'Jane Doe';
        q.OB_Pickup_Contact_Phone__c = '9042309898';
        q.OB_Pickup_Date__c = Date.newInstance(2020,12,20);
        q.OB_Pickup_Window_Start__c = '13:00';
        q.OB_Destination_Street__c = '200 Pine St';
        q.OB_Destination_City__c = 'Salt Lake City'; 
        q.OB_Destination_State__c = 'UT';
        q.OB_Destination_Postal_Code__c = '56565';
        q.OB_Delivery_Show_Name__c = 'Del Show';
        q.OB_Delivery_Booth_No__c = '19871';
        q.OB_Delivery_Show_Contractor__c = 'None';
        q.OB_Delivery_Contact_Name__c = 'James Cook';
        q.OB_Delivery_Contact_Phone__c = '678-923-9876';
        q.OB_Delivery_Date__c = Date.newInstance(2020,12,30);
        q.OB_Delivery_Window_Start__c = '08:00';
        q.OB_Shipment_Type__c = 'Ground Transportation';
        q.OB_Class_of_Service__c = '';
        q.OB_Service_Type__c = 'LTL';
        q.OB_Inside_Pickup__c = true;
        q.OB_Lift_Gate__c = true;
        q.OB_Pallet_Jack__c = true;
        q.OB_Residential_Pickup__c = true;
        q.OB_Call_Before_Pickup__c = true;
        q.OB_Call_Before_Delivery__c = true; 
        q.OB_Weekend_Pickup__c = true;
        q.OB_Weekend_Delivery__c = true;
        q.OB_Hazardous_Materials__c = true; 
        q.OB_Carrier_Notes__c = 'Notes';
        q.OB_Fuel_Surcharge__c = 23; 
        q.OB_Inside_Surcharge__c = 15;
        q.OB_Lift_Gate_Surcharge__c = 50; 
        q.OB_Residential_Surcharge__c = 75;
        q.OB_Sub_Total__c = 120;
        q.OB_Total__c = 200;
        q.OB_Custom_Quote__c = true; 
        q.OB_Selection__c = 'High';
        
        listQuote.add(q);
        
        Quote__c q1 = new Quote__c();
        
        q1.RecordTypeId = LogisticsDomesticQuoteRecordTypeId;        
        q1.Quote_Subject__c = 'Roundtrip';
        q1.Account_Id__c = Exhibitor.Id;
        q1.Show_Occurrence__c = Opty.Id;
        q1.Booth__c = Booth1.Id;
        q1.Sales_Rep__c = null;
        q1.Job_Code__c = 'JOB001';
        //q1.Discount_End_Date__c = Date.newInstance(2012,12,1);
        //q1.Billing_Contact__c = '';
        q1.Origination_Street__c = null;
        q1.Origination_City__c = 'Las Vegas';
        q1.Origination_State__c = 'NV';
        q1.Origination_Postal_Code__c = '89113';
        q1.Origination_Country__c = 'USA';
		q1.Pickup_Show_Name__c = 'International CES';
		q1.Pickup_Booth_No__c = '1000';
		q1.Pickup_Show_Contractor__c = 'GES';
		q1.Pickup_Contact_Name__c = 'John Doe';
		q1.Pickup_Contact_Phone__c = '7022631500';
		q1.Pickup_Date__c = Date.newInstance(2020,12,1);
		q1.Pickup_Window_Start__c = '13:00';
		q1.Destination_Street__c = '9000 Convention Dr';
		q1.Destination_City__c = 'Orlando';
		q1.Destination_State__c = 'FL';
		q1.Destination_Postal_Code__c = '32345';
		q1.Destination_Country__c = 'USA';
		q1.Delivery_Show_Name__c = 'Some Delivery Show';
		q1.Delivery_Booth_No__c = 'DELBOOTH';		
        q1.Delivery_Show_Contractor__c = 'Freeman';
        q1.Delivery_Contact_Name__c = 'Del Contact Joe';
        q1.Delivery_Contact_Phone__c = '9042345767';
        q1.Delivery_Date__c = Date.newInstance(2020,12,20);
        q1.Delivery_Window_Start__c = '08:00';
        q1.Delivery_Destination__c = 'Show Site';
        q1.Class_of_Service__c = '2nd Day';
        q1.Order_Date__c = Date.newInstance(2020,11,15);
        q1.Shipment_Type__c = null;
        q1.Service_Type__c = '';
        q1.Ship_To_Location__c = 'Warehouse';
        q1.Inside_Pickup__c = true;
        q1.Lift_Gate__c = true;
        q1.Pallet_Jack__c = true;
        q1.Residential_Pickup__c = true;
        q1.Call_Before_Pickup__c = true;
        q1.Call_Before_Delivery__c = true;
        q1.Weekend_Pickup__c = true;
        q1.Weekend_Delivery__c = true;
        q1.Hazardous_Materials__c = true;
        q1.Carrier_Notes__c = 'Carrier Notes';
        q1.EDV_Amount__c = 1500;
        q1.Crated_Weight__c = 250;
        q1.Weight_Override__c = 500;
        q1.Fuel_Surcharge__c = 50;
        q1.Inside_Surcharge__c = 75;
        q1.Lift_Gate_Surcharge__c = 25;
        q1.Residential_Surcharge__c = 20;
        
        q1.Sub_Total__c = 500;
        q1.Total__c = 1000;
        q1.Custom_Quote__c = true;
        q1.Selection__c = 'Low';
        q1.OB_Origination_Street__c = '5000 Union St';
        q1.OB_Origination_City__c = 'Orlando';
        q1.OB_Origination_State__c = 'FL';
        q1.OB_Origination_Postal_Code__c = '32245';
        q1.OB_Origination_Country__c = 'USA';
        q1.OB_Pickup_Show_Name__c = 'Show Some';
        q1.OB_Pickup_Booth_No__c = 'PickBooth'; 
        q1.OB_Pickup_Show_Contractor__c = 'Freeman';
        q1.OB_Pickup_Contact_Name__c = 'Jane Doe';
        q1.OB_Pickup_Contact_Phone__c = '9042309898';
        q1.OB_Pickup_Date__c = Date.newInstance(2020,12,20);
        q1.OB_Pickup_Window_Start__c = '13:00';
        q1.OB_Destination_Street__c = '200 Pine St';
        q1.OB_Destination_City__c = 'Salt Lake City'; 
        q1.OB_Destination_State__c = 'UT';
        q1.OB_Destination_Postal_Code__c = '56565';
        q1.OB_Delivery_Show_Name__c = 'Del Show';
        q1.OB_Delivery_Booth_No__c = '19871';
        q1.OB_Delivery_Show_Contractor__c = 'None';
        q1.OB_Delivery_Contact_Name__c = 'James Cook';
        q1.OB_Delivery_Contact_Phone__c = '678-923-9876';
        q1.OB_Delivery_Date__c = Date.newInstance(2020,12,30);
        q1.OB_Delivery_Window_Start__c = '08:00';
        q1.OB_Shipment_Type__c = null;
        q1.OB_Class_of_Service__c = '';
        q1.OB_Service_Type__c = 'LTL';
        q1.OB_Inside_Pickup__c = true;
        q1.OB_Lift_Gate__c = true;
        q1.OB_Pallet_Jack__c = true;
        q1.OB_Residential_Pickup__c = true;
        q1.OB_Call_Before_Pickup__c = true;
        q1.OB_Call_Before_Delivery__c = true; 
        q1.OB_Weekend_Pickup__c = true;
        q1.OB_Weekend_Delivery__c = true;
        q1.OB_Hazardous_Materials__c = true; 
        q1.OB_Carrier_Notes__c = 'Notes';
        q1.OB_Fuel_Surcharge__c = 23; 
        q1.OB_Inside_Surcharge__c = 15;
        q1.OB_Lift_Gate_Surcharge__c = 50; 
        q1.OB_Residential_Surcharge__c = 75;
        q1.OB_Sub_Total__c = 120;
        q1.OB_Total__c = 200;
        q1.OB_Custom_Quote__c = true; 
        q1.OB_Selection__c = 'High';        
        
        listQuote.add(q1);
        
        Quote__c q2 = new Quote__c();
        
        q2.RecordTypeId = LogisticsDomesticQuoteRecordTypeId;        
        q2.Quote_Subject__c = 'Roundtrip';
        q2.Account_Id__c = Exhibitor.Id;
        q2.Show_Occurrence__c = Opty.Id;
        q2.Booth__c = Booth1.Id;
        q2.Sales_Rep__c = null;
        q2.Job_Code__c = 'JOB001';
        //q2.Discount_End_Date__c = Date.newInstance(2012,12,1);
        //q2.Billing_Contact__c = '';
        q2.Origination_Shipping_Address__c = ExhibitorAddress.Id;
        q2.Pickup_Show_Name__c = 'International CES';
        q2.Pickup_Booth_No__c = '1000';
        q2.Pickup_Show_Contractor__c = 'GES';
        q2.Pickup_Contact_Name__c = 'John Doe';
        q2.Pickup_Contact_Phone__c = '7022631500';
        q2.Pickup_Date__c = Date.newInstance(2020,12,1);
        q2.Pickup_Window_Start__c = '13:00';
        q2.Destination_Shipping_Address__c = ExhibitorAddress2.Id;
        q2.Delivery_Show_Name__c = 'Some Delivery Show';
        q2.Delivery_Booth_No__c = 'DELBOOTH';        
        q2.Delivery_Show_Contractor__c = 'Freeman';
        q2.Delivery_Contact_Name__c = 'Del Contact Joe';
        q2.Delivery_Contact_Phone__c = '9042345767';
        q2.Delivery_Date__c = Date.newInstance(2020,12,20);
        q2.Delivery_Window_Start__c = '08:00';
        q2.Delivery_Destination__c = 'Show Site';
        q2.Class_of_Service__c = '2nd Day';
        q2.Order_Date__c = Date.newInstance(2020,11,15);
        q2.Shipment_Type__c = null;
        q2.Service_Type__c = '';
        q2.Ship_To_Location__c = 'Warehouse';
        q2.Inside_Pickup__c = true;
        q2.Lift_Gate__c = true;
        q2.Pallet_Jack__c = true;
        q2.Residential_Pickup__c = true;
        q2.Call_Before_Pickup__c = true;
        q2.Call_Before_Delivery__c = true;
        q2.Weekend_Pickup__c = true;
        q2.Weekend_Delivery__c = true;
        q2.Hazardous_Materials__c = true;
        q2.Carrier_Notes__c = 'Carrier Notes';
        q2.EDV_Amount__c = 1500;
        q2.Crated_Weight__c = 250;
        q2.Weight_Override__c = 500;
        q2.Fuel_Surcharge__c = 50;
        q2.Inside_Surcharge__c = 75;
        q2.Lift_Gate_Surcharge__c = 25;
        q2.Residential_Surcharge__c = 20;
        
        q2.Sub_Total__c = 500;
        q2.Total__c = 1000;
        q2.Custom_Quote__c = true;
        q2.Selection__c = 'Low';
        q2.OB_Origination_Shipping_Address__c = ExhibitorAddress2.Id;
        q2.OB_Pickup_Show_Name__c = 'Show Some';
        q2.OB_Pickup_Booth_No__c = 'PickBooth'; 
        q2.OB_Pickup_Show_Contractor__c = 'Freeman';
        q2.OB_Pickup_Contact_Name__c = 'Jane Doe';
        q2.OB_Pickup_Contact_Phone__c = '9042309898';
        q2.OB_Pickup_Date__c = Date.newInstance(2020,12,20);
        q2.OB_Pickup_Window_Start__c = '13:00';
        q2.OB_Destination_Shipping_Address__c = ExhibitorAddress.Id;
        q2.OB_Delivery_Show_Name__c = 'Del Show';
        q2.OB_Delivery_Booth_No__c = '19871';
        q2.OB_Delivery_Show_Contractor__c = 'None';
        q2.OB_Delivery_Contact_Name__c = 'James Cook';
        q2.OB_Delivery_Contact_Phone__c = '678-923-9876';
        q2.OB_Delivery_Date__c = Date.newInstance(2020,12,30);
        q2.OB_Delivery_Window_Start__c = '08:00';
        q2.OB_Shipment_Type__c = null;
        q2.OB_Class_of_Service__c = '';
        q2.OB_Service_Type__c = 'LTL';
        q2.OB_Inside_Pickup__c = true;
        q2.OB_Lift_Gate__c = true;
        q2.OB_Pallet_Jack__c = true;
        q2.OB_Residential_Pickup__c = true;
        q2.OB_Call_Before_Pickup__c = true;
        q2.OB_Call_Before_Delivery__c = true; 
        q2.OB_Weekend_Pickup__c = true;
        q2.OB_Weekend_Delivery__c = true;
        q2.OB_Hazardous_Materials__c = true; 
        q2.OB_Carrier_Notes__c = 'Notes';
        q2.OB_Fuel_Surcharge__c = 23; 
        q2.OB_Inside_Surcharge__c = 15;
        q2.OB_Lift_Gate_Surcharge__c = 50; 
        q2.OB_Residential_Surcharge__c = 75;
        q2.OB_Sub_Total__c = 120;
        q2.OB_Total__c = 200;
        q2.OB_Custom_Quote__c = true; 
        q2.OB_Selection__c = 'High';        
        
        listQuote.add(q2);
        
        Quote__c q3 = new Quote__c();
        
        q3.RecordTypeId = LogisticsDomesticQuoteRecordTypeId;        
        q3.Quote_Subject__c = 'Roundtrip';
        q3.Account_Id__c = Exhibitor.Id;
        q3.Show_Occurrence__c = Opty.Id;
        //q3.Booth__c = Booth1.Id; DO NOT SET THE BOOTH, SO LINE # 262, 264, 266 AND 267 will be tested
        q3.Sales_Rep__c = null;
        q3.Job_Code__c = 'JOB001';
        //q3.Discount_End_Date__c = Date.newInstance(2012,12,1);
        //q3.Billing_Contact__c = '';
        q3.Origination_Shipping_Address__c = ExhibitorAddress.Id;
        q3.Copy_To_OB_Destination_Address__c = true;
        q3.Pickup_Show_Name__c = 'International CES';
        q3.Pickup_Booth_No__c = '1000';
        q3.Pickup_Show_Contractor__c = 'GES';
        q3.Pickup_Contact_Name__c = 'John Doe';
        q3.Pickup_Contact_Phone__c = '7022631500';
        q3.Pickup_Date__c = Date.newInstance(2020,12,1);
        q3.Pickup_Window_Start__c = '16:00';
        q3.Pickup_Window_Start_Late__c = true;
        q3.Facility__c = Facility.Id;
        q3.Delivery_Show_Name__c = 'Some Delivery Show';
        q3.Delivery_Booth_No__c = 'DELBOOTH';        
        q3.Delivery_Show_Contractor__c = 'Freeman';
        q3.Delivery_Contact_Name__c = 'Del Contact Joe';
        q3.Delivery_Contact_Phone__c = '9042345767';
        q3.Delivery_Date__c = Date.newInstance(2020,12,20);
        q3.Delivery_Window_Start__c = '16:00';
        q3.Delivery_Destination__c = 'Show Site';
        q3.Class_of_Service__c = '2nd Day';
        q3.Order_Date__c = Date.newInstance(2020,11,15);
        q3.Shipment_Type__c = null;
        q3.Service_Type__c = '';
        q3.Ship_To_Location__c = 'Warehouse';
        q3.Inside_Pickup__c = true;
        q3.Lift_Gate__c = true;
        q3.Pallet_Jack__c = true;
        q3.Residential_Pickup__c = true;
        q3.Call_Before_Pickup__c = true;
        q3.Call_Before_Delivery__c = true;
        q3.Weekend_Pickup__c = true;
        q3.Weekend_Delivery__c = true;
        q3.Hazardous_Materials__c = true;
        q3.Carrier_Notes__c = 'Carrier Notes';
        q3.EDV_Amount__c = 25000;
        q3.EDV_Amount_Exceeds_Limit__c = true;
        q3.Crated_Weight__c = 250;
        q3.Weight_Override__c = 500;
        q3.Fuel_Surcharge__c = 50;
        q3.Inside_Surcharge__c = 75;
        q3.Lift_Gate_Surcharge__c = 25;
        q3.Residential_Surcharge__c = 20;
        
        q3.Sub_Total__c = 500;
        q3.Total__c = 1000;
        q3.Custom_Quote__c = true;
        q3.Selection__c = 'Low';
        q3.OB_Facility__c = Facility.Id;
        q3.OB_Pickup_Show_Name__c = 'Show Some';
        q3.OB_Pickup_Booth_No__c = 'PickBooth'; 
        q3.OB_Pickup_Show_Contractor__c = 'Freeman';
        q3.OB_Pickup_Contact_Name__c = 'Jane Doe';
        q3.OB_Pickup_Contact_Phone__c = '9042309898';
        q3.OB_Pickup_Date__c = Date.newInstance(2020,12,20);
        q3.OB_Pickup_Window_Start__c = '15:00';
        q3.OB_Pickup_Window_Start_Late__c = true;
        q3.OB_Destination_Shipping_Address__c = ExhibitorAddress.Id;
        q3.OB_Delivery_Show_Name__c = 'Del Show';
        q3.OB_Delivery_Booth_No__c = '19871';
        q3.OB_Delivery_Show_Contractor__c = 'None';
        q3.OB_Delivery_Contact_Name__c = 'James Cook';
        q3.OB_Delivery_Contact_Phone__c = '678-923-9876';
        q3.OB_Delivery_Date__c = Date.newInstance(2020,12,30);
        q3.OB_Delivery_Window_Start__c = '08:00';
        q3.OB_Shipment_Type__c = null;
        q3.OB_Class_of_Service__c = '';
        q3.OB_Service_Type__c = 'LTL';
        q3.OB_Inside_Pickup__c = true;
        q3.OB_Lift_Gate__c = true;
        q3.OB_Pallet_Jack__c = true;
        q3.OB_Residential_Pickup__c = true;
        q3.OB_Call_Before_Pickup__c = true;
        q3.OB_Call_Before_Delivery__c = true; 
        q3.OB_Weekend_Pickup__c = true;
        q3.OB_Weekend_Delivery__c = true;
        q3.OB_Hazardous_Materials__c = true; 
        q3.OB_Carrier_Notes__c = 'Notes';
        q3.OB_Fuel_Surcharge__c = 23; 
        q3.OB_Inside_Surcharge__c = 15;
        q3.OB_Lift_Gate_Surcharge__c = 50; 
        q3.OB_Residential_Surcharge__c = 75;
        q3.OB_Sub_Total__c = 120;
        q3.OB_Total__c = 200;
        q3.OB_Custom_Quote__c = true; 
        q3.OB_Selection__c = 'High';        
        
        listQuote.add(q3);
       
        Quote__c q4 = new Quote__c();
        
        q4.RecordTypeId = LogisticsDomesticQuoteRecordTypeId;        
        q4.Quote_Subject__c = 'Roundtrip';
        q4.Account_Id__c = Exhibitor.Id;
        //q4.Show_Occurrence__c = Opty.Id; IN ADDITION TO q3 DO NOT SET SHOW
        //q4.Booth__c = Booth1.Id; DO NOT SET THE BOOTH, SO LINE # 262, 264, 266 AND 267 will be tested
        q4.Sales_Rep__c = null;
        //q4.Discount_End_Date__c = Date.newInstance(2012,12,1);
        //q4.Billing_Contact__c = '';
        q4.Origination_Shipping_Address__c = ExhibitorAddress.Id;
        q4.Pickup_Show_Name__c = 'International CES';
        q4.Pickup_Booth_No__c = '1000';
        q4.Pickup_Show_Contractor__c = 'GES';
        q4.Pickup_Contact_Name__c = 'John Doe';
        q4.Pickup_Contact_Phone__c = '7022631500';
        q4.Pickup_Date__c = Date.newInstance(2020,12,1);
        q4.Pickup_Window_Start__c = '16:00';
        q4.Pickup_Window_Start_Late__c = true;
        q4.Facility__c = Facility.Id;
        q4.Delivery_Show_Name__c = 'Some Delivery Show';
        q4.Delivery_Booth_No__c = 'DELBOOTH';        
        q4.Delivery_Show_Contractor__c = 'Freeman';
        q4.Delivery_Contact_Name__c = 'Del Contact Joe';
        q4.Delivery_Contact_Phone__c = '9042345767';
        q4.Delivery_Date__c = Date.newInstance(2020,12,20);
        q4.Delivery_Window_Start__c = '16:00';
        q4.Delivery_Destination__c = 'Show Site';
        q4.Copy_To_OB_Pickup_Address__c = true;
        q4.Class_of_Service__c = '2nd Day';
        q4.Order_Date__c = Date.newInstance(2020,11,15);
        q4.Shipment_Type__c = null;
        q4.Service_Type__c = '';
        q4.Ship_To_Location__c = 'Warehouse';
        q4.Inside_Pickup__c = true;
        q4.Lift_Gate__c = true;
        q4.Pallet_Jack__c = true;
        q4.Residential_Pickup__c = true;
        q4.Call_Before_Pickup__c = true;
        q4.Call_Before_Delivery__c = true;
        q4.Weekend_Pickup__c = true;
        q4.Weekend_Delivery__c = true;
        q4.Hazardous_Materials__c = true;
        q4.Carrier_Notes__c = 'Carrier Notes';
        q4.EDV_Amount__c = 25000;
        q4.EDV_Amount_Exceeds_Limit__c = true;
        q4.Crated_Weight__c = 250;
        q4.Weight_Override__c = 500;
        q4.Fuel_Surcharge__c = 50;
        q4.Inside_Surcharge__c = 75;
        q4.Lift_Gate_Surcharge__c = 25;
        q4.Residential_Surcharge__c = 20;
        
        q4.Sub_Total__c = 500;
        q4.Total__c = 1000;
        q4.Custom_Quote__c = true;
        q4.Selection__c = 'Low';
        q4.OB_Facility__c = Facility.Id;
        q4.OB_Pickup_Show_Name__c = 'Show Some';
        q4.OB_Pickup_Booth_No__c = 'PickBooth'; 
        q4.OB_Pickup_Show_Contractor__c = 'Freeman';
        q4.OB_Pickup_Contact_Name__c = 'Jane Doe';
        q4.OB_Pickup_Contact_Phone__c = '9042309898';
        q4.OB_Pickup_Date__c = Date.newInstance(2020,12,20);
        q4.OB_Pickup_Window_Start__c = '15:00';
        q4.OB_Pickup_Window_Start_Late__c = true;
        q4.OB_Destination_Shipping_Address__c = ExhibitorAddress.Id;
        q4.OB_Delivery_Show_Name__c = 'Del Show';
        q4.OB_Delivery_Booth_No__c = '19871';
        q4.OB_Delivery_Show_Contractor__c = 'None';
        q4.OB_Delivery_Contact_Name__c = 'James Cook';
        q4.OB_Delivery_Contact_Phone__c = '678-923-9876';
        q4.OB_Delivery_Date__c = Date.newInstance(2020,12,30);
        q4.OB_Delivery_Window_Start__c = '08:00';
        q4.OB_Shipment_Type__c = null;
        q4.OB_Class_of_Service__c = '';
        q4.OB_Service_Type__c = 'LTL';
        q4.OB_Inside_Pickup__c = true;
        q4.OB_Lift_Gate__c = true;
        q4.OB_Pallet_Jack__c = true;
        q4.OB_Residential_Pickup__c = true;
        q4.OB_Call_Before_Pickup__c = true;
        q4.OB_Call_Before_Delivery__c = true; 
        q4.OB_Weekend_Pickup__c = true;
        q4.OB_Weekend_Delivery__c = true;
        q4.OB_Hazardous_Materials__c = true; 
        q4.OB_Carrier_Notes__c = 'Notes';
        q4.OB_Fuel_Surcharge__c = 23; 
        q4.OB_Inside_Surcharge__c = 15;
        q4.OB_Lift_Gate_Surcharge__c = 50; 
        q4.OB_Residential_Surcharge__c = 75;
        q4.OB_Sub_Total__c = 120;
        q4.OB_Total__c = 200;
        q4.OB_Custom_Quote__c = true; 
        q4.OB_Selection__c = 'High';        
        
        listQuote.add(q4);
        insert listQuote;
        
        Test.startTest();
        q3.Stage__c = 'Pending Carrier Quote';
        q3.Quote_Subject__c = 'Inbound';
        q3.Weight_Override__c = 600;
        q3.Crated_Weight__c = 300;
        q3.Dim_Weight__c = 120;
        q3.EDV_Amount__c = 10000;
        
        Database.update(q3);
        
        q3.Quote_Subject__c = 'Roundtrip';
        q3.Pickup_Date__c = Date.newInstance(2021,1,1);
        q3.Delivery_Date__c = Date.newInstance(2021,1,10);
        q3.OB_Pickup_Date__c = Date.newInstance(2021,1,11);
        q3.OB_Delivery_Date__c = Date.newInstance(2021,1,20);        
        q3.Origination_Shipping_Address__c = ExhibitorAddress.Id;
        q3.Facility__c = null;
        q3.Destination_Shipping_Address__c = ExhibitorAddress2.Id;
        q3.OB_Origination_Shipping_Address__c = ExhibitorAddress.Id;
        q3.OB_Facility__c = null;
        q3.OB_Destination_Shipping_Address__c = ExhibitorAddress2.Id;        
        q3.Additional_Labor__c = true;
        q3.Attempt__c = true;
        q3.AM_Specified__c = true;
        q3.Call_Before_Pickup__c = false;
        q3.Call_Before_Delivery__c = false;
        q3.Lift_Gate__c = false;
        q3.Hazardous_Materials__c = false;
        q3.Pallet_Jack__c = false;
        q3.Palletization__c = true;
        q3.Inside_Pickup__c = false;
        q3.Residential_Pickup__c = false;
        q3.Wait_Time__c = true;
        q3.Weekend_Pickup__c = false;
        q3.Weekend_Delivery__c = false;
        q3.OB_Additional_Labor__c = true;
        q3.OB_Attempt__c = true;
        q3.OB_AM_Specified__c = true;
        q3.OB_Call_Before_Pickup__c = false;
        q3.OB_Call_Before_Delivery__c = false;
        q3.OB_Lift_Gate__c = false;
        q3.OB_Hazardous_Materials__c = false;
        q3.OB_Pallet_Jack__c = false;
        q3.OB_Palletization__c = true;
        q3.OB_Inside_Pickup__c = false;
        q3.OB_Residential_Pickup__c = false;
        q3.OB_Wait_Time__c = true;
        q3.OB_Weekend_Pickup__c = false;
        q3.OB_Weekend_Delivery__c = false;
        q3.Inbound_Stage__c = null;
        q3.Outbound_Stage__c = null;
        
        Database.update(q3);
        Test.stopTest();
    }
}