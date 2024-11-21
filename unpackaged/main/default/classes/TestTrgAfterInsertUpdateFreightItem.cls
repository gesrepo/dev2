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
private class TestTrgAfterInsertUpdateFreightItem {

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
        
        Opty.Show_Open_Date__c = Date.newInstance(2024,09,01);
        Opty.Show_Close_Date__c = CloseDate6;
        Opty.CloseDate = CloseDate6;
                
        database.insert(Opty);
    	
        Quote__c q = new Quote__c();
        
        q.Quote_Subject__c = 'Roundtrip';
        //q.Account_Id__c = '';
        q.Job_Code__c = 'JOB001';
        //q.Project_Number__c = '00123456';
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
        q.Show_Occurrence__c = Opty.Id;
        
        Database.insert(q);        
        List<Freight_Item__c> listfreightItem = new List<Freight_Item__c>();
        Freight_Item__c FItem = new Freight_Item__c();
        FItem.Quote__c  = q.Id;
        FItem.Crated_Weight__c = 30;
        FItem.Description__c = 'Crates (Wooden)';
        FItem.Hazardous_Material__c = true;
        FItem.Height__c = 1;
        FItem.Length__c = 1;
        FItem.Quantity__c = 1;
        FItem.Width__c = 1;

        listfreightItem.add(FItem);        
        
        Freight_Item__c FItem2 = new Freight_Item__c();
        FItem2.Quote__c  = q.Id;
        FItem2.Crated_Weight__c = 30;
        FItem2.Description__c = 'Crates (Wooden)';
        FItem2.Hazardous_Material__c = true;
        FItem2.Height__c = 3;
        FItem2.Length__c = 10;
        FItem2.Quantity__c = 1;
        FItem2.Width__c = 5;
        
        listfreightItem.add(FItem2);        
		
        Freight_Item__c FItem3 = new Freight_Item__c();
        FItem3.Quote__c  = q.Id;
        FItem3.Crated_Weight__c = 30;
        FItem3.Description__c = 'Crates (Wooden)';
        FItem3.Hazardous_Material__c = true;
        FItem3.Height__c = 3;
        FItem3.Length__c = 10;
        FItem3.Quantity__c = 1;
        FItem3.Width__c = 5;
        
        listfreightItem.add(FItem3);
        
        Freight_Item__c FItem4 = new Freight_Item__c();
        FItem4.Quote__c  = q.Id;
        FItem4.Crated_Weight__c = 30;
        FItem4.Description__c = 'Crates (Wooden)';
        FItem4.Hazardous_Material__c = true;
        FItem4.Height__c = 3;
        FItem4.Length__c = 10;
        FItem4.Quantity__c = null;
        FItem4.Width__c = 5;
        
        listfreightItem.add(FItem4); 
        insert listfreightItem;
        
        test.startTest();
        
        Database.delete(FItem3.Id);
        
        test.stopTest();
        
    }

}