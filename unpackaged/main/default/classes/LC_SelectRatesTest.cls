@isTest
public class LC_SelectRatesTest {

    @isTest
    static void Test1(){
        String direction = 'ROUNDTRIP';
        String selection = 'CiAir2ndDay';
        String rates = '1.88,0.360,68.36,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,189.88,258.24,0,0,0001-01-01 00:00:00';
        String unitPrice = '0.01';
        Quote__c q = new Quote__c();
        
        q.Quote_Subject__c = 'Roundtrip';
        q.Job_Code__c = 'JOB001';
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
        
        Database.insert(q);
		
        GES_Logistics_Certificate_Name__c cs = new GES_Logistics_Certificate_Name__c(name='GES_Logistics_Rates',Active__c=true, Certificate_Name__c='GES_Logistics_Rates');
        insert cs;
        
        
        LogisticsQuoteComplexPriceData cp = new LogisticsQuoteComplexPriceData();
        LogisticsQuoteRates.complexPrice = cp;
        LogisticsQuoteRates.Initialize(q.Id, q, direction);
        
        LC_SelectRates.fetchQuote(q.Id);
        LC_SelectRates.getQuoteRates(q.Id, direction);
        LC_SelectRates.updateInboundOutboundQuote(q.Id, selection, rates, unitPrice);
        LC_SelectRates.priceCustomQuote(q.Id, direction);
        LogisticsQuoteRates.GetRates(q.Id, direction);
    }
    
    @isTest
    static void Test2(){
        String direction = 'ROUNDTRIP';
        String selection = 'CoAir2ndDay';
        String rates = '1.88,0.360,68.36,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,189.88,258.24,0,0,0001-01-01 00:00:00';
        String unitPrice = '0.01';
        Quote__c q = new Quote__c();
        
        q.Quote_Subject__c = 'Roundtrip';
        q.Job_Code__c = 'JOB001';
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
        
        Database.insert(q);
		
        GES_Logistics_Certificate_Name__c cs = new GES_Logistics_Certificate_Name__c(name='GES_Logistics_Rates',Active__c=true, Certificate_Name__c='GES_Logistics_Rates');
        insert cs;
        
        
        LogisticsQuoteComplexPriceData cp = new LogisticsQuoteComplexPriceData();
        LogisticsQuoteRates.complexPrice = cp;
        LogisticsQuoteRates.Initialize(q.Id, q, direction);
        
        LC_SelectRates.getQuoteRates(q.Id, direction);
        LC_SelectRates.updateInboundOutboundQuote(q.Id, selection, rates, unitPrice);
        LC_SelectRates.priceCustomQuote(q.Id, direction);
    }

}