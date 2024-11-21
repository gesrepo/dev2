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
private class TestLogisticsQuoteServices {

    static testMethod void myUnitTest() {

		//Test the Stub - Can't test the stub because APEX test class does not call it or invoke its methods
		/*
		LogisticsQuoteGeneratorService QGS = new LogisticsQuoteGeneratorService();
		
		LogisticsQuoteGeneratorService.GetQuoteResponseObjectByQuoteRequestObject_element SubClass1 = new LogisticsQuoteGeneratorService.GetQuoteResponseObjectByQuoteRequestObject_element();
		SubClass1.qGRequestObject = new LogisticsQuoteGeneratorService.QuoteRequestObject();
		
		LogisticsQuoteGeneratorService.ArrayOfQuoteResponseObject SubClass2 = new LogisticsQuoteGeneratorService.ArrayOfQuoteResponseObject();
        SubClass2.QuoteResponseObject = new LogisticsQuoteGeneratorService.QuoteResponseObject[]{};
                
        LogisticsQuoteGeneratorService.GetQuoteResponseObjectByID_element SubClass3 = new LogisticsQuoteGeneratorService.GetQuoteResponseObjectByID_element();
        SubClass3.quoteRequestID = 1.0;
        
		LogisticsQuoteGeneratorService.GetArrayOfAllQuoteResponseOptionsFromQuoteRequestObject_element SubClass4 = new LogisticsQuoteGeneratorService.GetArrayOfAllQuoteResponseOptionsFromQuoteRequestObject_element();
		SubClass4.qGRequestObject = new LogisticsQuoteGeneratorService.QuoteRequestObject();
		*/   
        
        
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
        
        Database.insert(q);
        
        LogisticsQuoteRates.SetRateInEligibilityMessage(q.Id, q);
        
        Freight_Item__c FItem = new Freight_Item__c();
        FItem.Quote__c  = q.Id;
        FItem.Crated_Weight__c = 10;
        FItem.Description__c = 'Crates (Wooden)';
        FItem.Hazardous_Material__c = true;
        FItem.Height__c = 1;
        FItem.Length__c = 1;
        FItem.Quantity__c = 1;
        FItem.Width__c = 1;
        
        Database.insert(FItem);
        
        LogisticsQuoteRates.SetRateInEligibilityMessage(q.Id, q);
        
        FItem.Crated_Weight__c = 100;
        FItem.Height__c = 55;
        FItem.Length__c = 84;
        FItem.Quantity__c = 1;
        FItem.Width__c = 60;
                
        decimal FixedCurrency = LogisticsQuoteRates.currencyFixed(10.0);
        string CurrencyString = LogisticsQuoteRates.currencyToString(10.0);
        
        string Direction = 'ROUNDTRIP';
        
        LogisticsQuoteComplexPriceData cp = new LogisticsQuoteComplexPriceData();
        LogisticsQuoteRates.complexPrice = cp;
        
        System.assert(q.Id != null);
        
        LogisticsQuoteRates.Initialize(q.Id, q, direction);
 		
 		LogisticsQuoteGeneratorService.QuoteRequestObject PriceRequestObjectIb = new LogisticsQuoteGeneratorService.QuoteRequestObject();
 		LogisticsQuoteGeneratorService.QuoteRequestObject PriceRequestObjectOb = new LogisticsQuoteGeneratorService.QuoteRequestObject();
 		LogisticsQuoteGeneratorService.ArrayOfQuoteResponseObject ArrPriceResponseObjectIb = new LogisticsQuoteGeneratorService.ArrayOfQuoteResponseObject();
 		LogisticsQuoteGeneratorService.ArrayOfQuoteResponseObject ArrPriceResponseObjectOb = new LogisticsQuoteGeneratorService.ArrayOfQuoteResponseObject();
 		
 		LogisticsQuoteGeneratorService.QuoteResponseObject ResponseObjectIb = new LogisticsQuoteGeneratorService.QuoteResponseObject();
 		LogisticsQuoteGeneratorService.QuoteResponseObject ResponseObjectOb = new LogisticsQuoteGeneratorService.QuoteResponseObject();
 		
 		ArrPriceResponseObjectIb.QuoteResponseObject = new List<LogisticsQuoteGeneratorService.QuoteResponseObject>{ResponseObjectIb };
 		ArrPriceResponseObjectOb.QuoteResponseObject = new List<LogisticsQuoteGeneratorService.QuoteResponseObject>{ResponseObjectOb };
 		
 		// INBOUND Set Rates - Start
 		
 		//Inbound Local Shipment and Amount Non Zero
 		ResponseObjectIb.TypeID = 3;
		ResponseObjectIb.Rate = 1.0;
		ResponseObjectIb.FuelSurcharge = 10;
		ResponseObjectIb.Fuel = 100;
		ResponseObjectIb.InsidePickupFee = 50;
		ResponseObjectIb.LiftGateFee = 50;
		ResponseObjectIb.ResidentialPickupFee = 50;		    	
		ResponseObjectIb.AMSpecifiedFee = 150;
		ResponseObjectIb.WeekendFee = 300;
		ResponseObjectIb.WaitTimeFee = 30;
		ResponseObjectIb.AdditionalLaborFee = 100;
		ResponseObjectIb.PalletizationFee = 50;
		ResponseObjectIb.AttemptFee = 50;		    	
		ResponseObjectIb.Price = 100;
		ResponseObjectIb.Total = 500;
		ResponseObjectIb.roundTripDiscountPercent = 10;
		ResponseObjectIb.AdvOrderDiscountPercent = 15;
		ResponseObjectIb.LastDayAdvRecv = datetime.newInstance(01, 01, 2013);

		LogisticsQuoteRates.SetInboundLocalRates(LogisticsQuoteRates.complexPrice, ArrPriceResponseObjectIb, q);
		
		//Inbound Local Shipment and Amount Zero Same State
 		ResponseObjectIb.TypeID = 3;
 		ResponseObjectIb.Total = 0;
 		q.Origination_State__c = 'NV';
 		q.Destination_State__c = 'NV';

		LogisticsQuoteRates.SetInboundLocalRates(LogisticsQuoteRates.complexPrice, ArrPriceResponseObjectIb, q); 
		
		//Inbound Local Shipment and Amount Zero Different State
 		ResponseObjectIb.TypeID = 3;
 		ResponseObjectIb.Total = 0;
 		q.Origination_State__c = 'NV';
 		q.Destination_State__c = 'CA';

		LogisticsQuoteRates.SetInboundLocalRates(LogisticsQuoteRates.complexPrice, ArrPriceResponseObjectIb, q); 		
 		
		//Inbound Ground Shipment High
 		ResponseObjectIb.TypeID = 1;
 		ResponseObjectIb.SelectionID = 2;

 		LogisticsQuoteRates.SetInboundGroundRates(true, '', LogisticsQuoteRates.complexPrice, ArrPriceResponseObjectIb, q);

		//Inbound Ground Shipment Low
 		ResponseObjectIb.TypeID = 1;
 		ResponseObjectIb.SelectionID = 1;

 		LogisticsQuoteRates.SetInboundGroundRates(true, '', LogisticsQuoteRates.complexPrice, ArrPriceResponseObjectIb, q);

		boolean RateEligible = true;
		string IneligibilityMessage = 'Some Message';
		
		//Inbound Air High Next Day
 		ResponseObjectIb.TypeID = 2;
 		ResponseObjectIb.SelectionID = 2;
 		ResponseObjectIb.ClassOfServiceID = 1;

 		LogisticsQuoteRates.SetInboundAirRates(RateEligible, IneligibilityMessage, LogisticsQuoteRates.complexPrice, ArrPriceResponseObjectIb, q);

		//Inbound Air High 2nd Day
 		ResponseObjectIb.TypeID = 2;
 		ResponseObjectIb.SelectionID = 2;
 		ResponseObjectIb.ClassOfServiceID = 2;

 		LogisticsQuoteRates.SetInboundAirRates(RateEligible, IneligibilityMessage, LogisticsQuoteRates.complexPrice, ArrPriceResponseObjectIb, q);

		//Inbound Air Low Next Day
 		ResponseObjectIb.TypeID = 2;
 		ResponseObjectIb.SelectionID = 1;
 		ResponseObjectIb.ClassOfServiceID = 1;

 		LogisticsQuoteRates.SetInboundAirRates(RateEligible, IneligibilityMessage, LogisticsQuoteRates.complexPrice, ArrPriceResponseObjectIb, q);

		//Inbound Air Low 2nd Day
 		ResponseObjectIb.TypeID = 2;
 		ResponseObjectIb.SelectionID = 1;
 		ResponseObjectIb.ClassOfServiceID = 2;

 		LogisticsQuoteRates.SetInboundAirRates(RateEligible, IneligibilityMessage, LogisticsQuoteRates.complexPrice, ArrPriceResponseObjectIb, q);

		//Inbound Air Ineligible
		RateEligible = false;

 		LogisticsQuoteRates.SetInboundAirRates(RateEligible, IneligibilityMessage, LogisticsQuoteRates.complexPrice, ArrPriceResponseObjectIb, q);

		//INBOUND Set Rates - End
		
 		//OUTBOUND Set Rates - Start
 		
 		//Outbound Local Shipment and Amount Non Zero
 		ResponseObjectOb.TypeID = 3;
		ResponseObjectOb.Rate = 1.0;
		ResponseObjectOb.FuelSurcharge = 10;
		ResponseObjectOb.Fuel = 100;
		ResponseObjectOb.InsidePickupFee = 50;
		ResponseObjectOb.LiftGateFee = 50;
		ResponseObjectOb.ResidentialPickupFee = 50;		    	
		ResponseObjectOb.AMSpecifiedFee = 150;
		ResponseObjectOb.WeekendFee = 300;
		ResponseObjectOb.WaitTimeFee = 30;
		ResponseObjectOb.AdditionalLaborFee = 100;
		ResponseObjectOb.PalletizationFee = 50;
		ResponseObjectOb.AttemptFee = 50;		    	
		ResponseObjectOb.Price = 100;
		ResponseObjectOb.Total = 500;
		ResponseObjectOb.roundTripDiscountPercent = 10;
		ResponseObjectOb.AdvOrderDiscountPercent = 15;
		ResponseObjectOb.LastDayAdvRecv = datetime.newInstance(01, 01, 2013);
 		
		LogisticsQuoteRates.SetOutboundLocalRates(LogisticsQuoteRates.complexPrice, ArrPriceResponseObjectOb, q);
		
		//Outbound Local Shipment and Amount Zero Same State
 		ResponseObjectOb.TypeID = 3;
 		ResponseObjectOb.Total = 0;
 		q.OB_Origination_State__c = 'NV';
 		q.OB_Destination_State__c = 'NV';

		LogisticsQuoteRates.SetOutboundLocalRates(LogisticsQuoteRates.complexPrice, ArrPriceResponseObjectOb, q);
		
		//Outbound Local Shipment and Amount Zero Different State
 		ResponseObjectOb.TypeID = 3;
 		ResponseObjectOb.Total = 0;
 		q.OB_Origination_State__c = 'NV';
 		q.OB_Destination_State__c = 'CA';

		LogisticsQuoteRates.SetOutboundLocalRates(LogisticsQuoteRates.complexPrice, ArrPriceResponseObjectOb, q);	
 		
		//Outbound Ground Shipment High
 		ResponseObjectOb.TypeID = 1;
 		ResponseObjectOb.SelectionID = 2;

 		LogisticsQuoteRates.SetOutboundGroundRates(true, '', LogisticsQuoteRates.complexPrice, ArrPriceResponseObjectOb, q);

		//Outbound Ground Shipment Low
 		ResponseObjectOb.TypeID = 1;
 		ResponseObjectOb.SelectionID = 1;

 		LogisticsQuoteRates.SetOutboundGroundRates(true, '', LogisticsQuoteRates.complexPrice, ArrPriceResponseObjectOb, q);
		
		RateEligible = true;
		
		//Outbound Air High Next Day
 		ResponseObjectOb.TypeID = 2;
 		ResponseObjectOb.SelectionID = 2;
 		ResponseObjectOb.ClassOfServiceID = 1;

 		LogisticsQuoteRates.SetOutboundAirRates(RateEligible, IneligibilityMessage, LogisticsQuoteRates.complexPrice, ArrPriceResponseObjectOb, q);

		//Outbound Air High 2nd Day
 		ResponseObjectOb.TypeID = 2;
 		ResponseObjectOb.SelectionID = 2;
 		ResponseObjectOb.ClassOfServiceID = 2;

 		LogisticsQuoteRates.SetOutboundAirRates(RateEligible, IneligibilityMessage, LogisticsQuoteRates.complexPrice, ArrPriceResponseObjectOb, q);

		//Outbound Air Low Next Day
 		ResponseObjectOb.TypeID = 2;
 		ResponseObjectOb.SelectionID = 1;
 		ResponseObjectOb.ClassOfServiceID = 1;

 		LogisticsQuoteRates.SetOutboundAirRates(RateEligible, IneligibilityMessage, LogisticsQuoteRates.complexPrice, ArrPriceResponseObjectOb, q);

		//Outbound Air Low 2nd Day
 		ResponseObjectOb.TypeID = 2;
 		ResponseObjectOb.SelectionID = 1;
 		ResponseObjectOb.ClassOfServiceID = 2;

 		LogisticsQuoteRates.SetOutboundAirRates(RateEligible, IneligibilityMessage, LogisticsQuoteRates.complexPrice, ArrPriceResponseObjectOb, q);

		//Outbound Air Ineligible
		RateEligible = false;

 		LogisticsQuoteRates.SetOutboundAirRates(RateEligible, IneligibilityMessage, LogisticsQuoteRates.complexPrice, ArrPriceResponseObjectOb, q);

		//OUTBOUND Set Rates - End

   
        String Rates = '';
        
        //INBOUND High Get Rates Html - Start
        
        LogisticsQuoteRates.complexPrice.High.Inbound.Air.Air2ndDay.Detail.DisplayCode = '';
        Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.High.Inbound.Air.Air2ndDay.Detail.DisplayCode = 'X';
        Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.High.Inbound.Air.Air2ndDay.Detail.DisplayCode = 'H';
        Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
          
        LogisticsQuoteRates.complexPrice.High.Inbound.Air.AirNextDay.Detail.DisplayCode = '';
        Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.High.Inbound.Air.AirNextDay.Detail.DisplayCode = 'X';
        Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.High.Inbound.Air.AirNextDay.Detail.DisplayCode = 'H';
        Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
        
        LogisticsQuoteRates.complexPrice.High.Inbound.Ground.Ltl.Detail.DisplayCode = '';
        Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.High.Inbound.Ground.Ltl.Detail.DisplayCode = 'X';
        Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.High.Inbound.Ground.Ltl.Detail.DisplayCode = 'H';
        Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
           
		LogisticsQuoteRates.complexPrice.High.Inbound.Local.Detail.Total = 10;
		Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
		
		LogisticsQuoteRates.complexPrice.High.Inbound.Local.Detail.Total = 0;
		LogisticsQuoteRates.complexPrice.High.Inbound.Local.Detail.DisplayCode = 'X';
		Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
		
		LogisticsQuoteRates.complexPrice.High.Inbound.Local.Detail.DisplayCode = 'H';
		Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);        
        
        //INBOUND High Get Rates Html - End
        
        //OUTBOUND High Get Rates Html - Start
        
        LogisticsQuoteRates.complexPrice.High.Outbound.Air.Air2ndDay.Detail.DisplayCode = '';
        Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.High.Outbound.Air.Air2ndDay.Detail.DisplayCode = 'X';
        Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.High.Outbound.Air.Air2ndDay.Detail.DisplayCode = 'H';
        Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
         
        LogisticsQuoteRates.complexPrice.High.Outbound.Air.AirNextDay.Detail.DisplayCode = '';
        Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.High.Outbound.Air.AirNextDay.Detail.DisplayCode = 'X';
        Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.High.Outbound.Air.AirNextDay.Detail.DisplayCode = 'H';
        Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
        
        LogisticsQuoteRates.complexPrice.High.Outbound.Ground.Ltl.Detail.DisplayCode = '';
        Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.High.Outbound.Ground.Ltl.Detail.DisplayCode = 'X';
        Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.High.Outbound.Ground.Ltl.Detail.DisplayCode = 'H';
        Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
           
		LogisticsQuoteRates.complexPrice.High.Outbound.Local.Detail.Total = 10;
		Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
		
		LogisticsQuoteRates.complexPrice.High.Outbound.Local.Detail.Total = 0;
		LogisticsQuoteRates.complexPrice.High.Outbound.Local.Detail.DisplayCode = 'X';
		Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
		
		LogisticsQuoteRates.complexPrice.High.Outbound.Local.Detail.DisplayCode = 'H';
		Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);        
        
        //OUTBOUND High Get Rates Html - End 
        
        //INBOUND Low Get Rates Html - Start
        
        LogisticsQuoteRates.complexPrice.Low.Inbound.Air.Air2ndDay.Detail.DisplayCode = '';
        Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.Low.Inbound.Air.Air2ndDay.Detail.DisplayCode = 'X';
        Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.Low.Inbound.Air.Air2ndDay.Detail.DisplayCode = 'H';
        Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
          
        LogisticsQuoteRates.complexPrice.Low.Inbound.Air.AirNextDay.Detail.DisplayCode = '';
        Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.Low.Inbound.Air.AirNextDay.Detail.DisplayCode = 'X';
        Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.Low.Inbound.Air.AirNextDay.Detail.DisplayCode = 'H';
        Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
        
        LogisticsQuoteRates.complexPrice.Low.Inbound.Ground.Ltl.Detail.DisplayCode = '';
        Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.Low.Inbound.Ground.Ltl.Detail.DisplayCode = 'X';
        Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.Low.Inbound.Ground.Ltl.Detail.DisplayCode = 'H';
        Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
           
		LogisticsQuoteRates.complexPrice.Low.Inbound.Local.Detail.Total = 10;
		Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
		
		LogisticsQuoteRates.complexPrice.Low.Inbound.Local.Detail.Total = 0;
		LogisticsQuoteRates.complexPrice.Low.Inbound.Local.Detail.DisplayCode = 'X';
		Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
		
		LogisticsQuoteRates.complexPrice.Low.Inbound.Local.Detail.DisplayCode = 'H';
		Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);        
        
        //INBOUND Low Get Rates Html - End
        
        //OUTBOUND Low Get Rates Html - Start
        
        LogisticsQuoteRates.complexPrice.Low.Outbound.Air.Air2ndDay.Detail.DisplayCode = '';
        Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.Low.Outbound.Air.Air2ndDay.Detail.DisplayCode = 'X';
        Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.Low.Outbound.Air.Air2ndDay.Detail.DisplayCode = 'H';
        Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
         
        LogisticsQuoteRates.complexPrice.Low.Outbound.Air.AirNextDay.Detail.DisplayCode = '';
        Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.Low.Outbound.Air.AirNextDay.Detail.DisplayCode = 'X';
        Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.Low.Outbound.Air.AirNextDay.Detail.DisplayCode = 'H';
        Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
        
        LogisticsQuoteRates.complexPrice.Low.Outbound.Ground.Ltl.Detail.DisplayCode = '';
        Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.Low.Outbound.Ground.Ltl.Detail.DisplayCode = 'X';
        Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.Low.Outbound.Ground.Ltl.Detail.DisplayCode = 'H';
        Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
           
		LogisticsQuoteRates.complexPrice.Low.Outbound.Local.Detail.Total = 10;
		Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
		
		LogisticsQuoteRates.complexPrice.Low.Outbound.Local.Detail.Total = 0;
		LogisticsQuoteRates.complexPrice.Low.Outbound.Local.Detail.DisplayCode = 'X';
		Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);
		
		LogisticsQuoteRates.complexPrice.Low.Outbound.Local.Detail.DisplayCode = 'H';
		Rates = LogisticsQuoteRates.GetHtml(direction, LogisticsQuoteRates.complexPrice, q);        
        
        //OUTBOUND Low Get Rates Html - End 
                
        String RetVal = '';
        String UnitPrice = '1.0';
        
        RetVal = LogisticsQuoteRates.UpdateQuote(q.Id, 'HIAIR2NDDAY', Rates, UnitPrice);
        RetVal = LogisticsQuoteRates.UpdateQuote(q.Id, 'HIAIRNEXTDAY', Rates, UnitPrice);
        RetVal = LogisticsQuoteRates.UpdateQuote(q.Id, 'HIGROUNDLTL', Rates, UnitPrice);
        RetVal = LogisticsQuoteRates.UpdateQuote(q.Id, 'HIGROUNDFTL', Rates, UnitPrice);
        RetVal = LogisticsQuoteRates.UpdateQuote(q.Id, 'HILOCAL', Rates, UnitPrice);
        RetVal = LogisticsQuoteRates.UpdateQuote(q.Id, 'LIAIR2NDDAY', Rates, UnitPrice);
        RetVal = LogisticsQuoteRates.UpdateQuote(q.Id, 'LIAIRNEXTDAY', Rates, UnitPrice);
        RetVal = LogisticsQuoteRates.UpdateQuote(q.Id, 'LIGROUNDLTL', Rates, UnitPrice);
        RetVal = LogisticsQuoteRates.UpdateQuote(q.Id, 'LIGROUNDFTL', Rates, UnitPrice);
        RetVal = LogisticsQuoteRates.UpdateQuote(q.Id, 'LILOCAL', Rates, UnitPrice);
        RetVal = LogisticsQuoteRates.UpdateQuote(q.Id, 'HOAIR2NDDAY', Rates, UnitPrice);
        RetVal = LogisticsQuoteRates.UpdateQuote(q.Id, 'HOAIRNEXTDAY', Rates, UnitPrice);
        RetVal = LogisticsQuoteRates.UpdateQuote(q.Id, 'HOGROUNDLTL', Rates, UnitPrice);
        RetVal = LogisticsQuoteRates.UpdateQuote(q.Id, 'HOGROUNDFTL', Rates, UnitPrice);
        RetVal = LogisticsQuoteRates.UpdateQuote(q.Id, 'HOLOCAL', Rates, UnitPrice);
        RetVal = LogisticsQuoteRates.UpdateQuote(q.Id, 'LOAIR2NDDAY', Rates, UnitPrice);
        RetVal = LogisticsQuoteRates.UpdateQuote(q.Id, 'LOAIRNEXTDAY', Rates, UnitPrice);
        RetVal = LogisticsQuoteRates.UpdateQuote(q.Id, 'LOGROUNDLTL', Rates, UnitPrice);
        RetVal = LogisticsQuoteRates.UpdateQuote(q.Id, 'LOGROUNDFTL', Rates, UnitPrice);
        RetVal = LogisticsQuoteRates.UpdateQuote(q.Id, 'LOLOCAL', Rates, UnitPrice);
        
        RetVal = LogisticsQuoteRates.UpdateQuote(q.Id, 'CIAIR2NDDAY', Rates, UnitPrice);
        RetVal = LogisticsQuoteRates.UpdateQuote(q.Id, 'CIAIRNEXTDAY', Rates, UnitPrice);
        RetVal = LogisticsQuoteRates.UpdateQuote(q.Id, 'CIGROUNDLTL', Rates, UnitPrice);
        RetVal = LogisticsQuoteRates.UpdateQuote(q.Id, 'CIGROUNDFTL', Rates, UnitPrice);
        RetVal = LogisticsQuoteRates.UpdateQuote(q.Id, 'CILOCAL', Rates, UnitPrice);
        RetVal = LogisticsQuoteRates.UpdateQuote(q.Id, 'COAIR2NDDAY', Rates, UnitPrice);
        RetVal = LogisticsQuoteRates.UpdateQuote(q.Id, 'COAIRNEXTDAY', Rates, UnitPrice);
        RetVal = LogisticsQuoteRates.UpdateQuote(q.Id, 'COGROUNDLTL', Rates, UnitPrice);
        RetVal = LogisticsQuoteRates.UpdateQuote(q.Id, 'COGROUNDFTL', Rates, UnitPrice);
        RetVal = LogisticsQuoteRates.UpdateQuote(q.Id, 'COLOCAL', Rates, UnitPrice);
        
        LogisticsQuoteComplexPriceData complexPrice = new LogisticsQuoteComplexPriceData();
        LogisticsQuoteGeneratorService.ArrayOfQuoteResponseObject responseObject = new LogisticsQuoteGeneratorService.ArrayOfQuoteResponseObject();
        
        //LogisticsQuoteRates.SetInboundNonAirRates(complexPrice, responseObject, q);
        //LogisticsQuoteRates.SetInboundAirRates(complexPrice, responseObject, q);        
        
    }
    
    static testMethod void myUnitTestLightning() {

        
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
        //q.Flat_Rate_Unit_Price_Type__c = 'PER POUND';
        //q.OB_Flat_Rate_Unit_Price_Type__c = 'PER POUND';
        
        Database.insert(q);

        string direction = 'ROUNDTRIP';
        
        LogisticsQuoteComplexPriceData cp = new LogisticsQuoteComplexPriceData();
        LogisticsQuoteRates.complexPrice = cp;

        
        //INBOUND High Get Rates Html - Start
        LogisticsQuoteRates.complexPrice.High.Inbound.Air.Air2ndDay.Detail.DisplayCode = '';
        LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.High.Inbound.Air.Air2ndDay.Detail.DisplayCode = 'X';
        LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.High.Inbound.Air.Air2ndDay.Detail.DisplayCode = 'H';
        LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
         
        LogisticsQuoteRates.complexPrice.High.Inbound.Air.AirNextDay.Detail.DisplayCode = '';
        LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.High.Inbound.Air.AirNextDay.Detail.DisplayCode = 'X';
        LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.High.Inbound.Air.AirNextDay.Detail.DisplayCode = 'H';
        LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
        
        LogisticsQuoteRates.complexPrice.High.Inbound.Ground.Ltl.Detail.DisplayCode = '';
        LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.High.Inbound.Ground.Ltl.Detail.DisplayCode = 'X';
        LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.High.Inbound.Ground.Ltl.Detail.DisplayCode = 'H';
        LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
           
		LogisticsQuoteRates.complexPrice.High.Inbound.Local.Detail.Total = 10;
		LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
		
		LogisticsQuoteRates.complexPrice.High.Inbound.Local.Detail.Total = 0;
		LogisticsQuoteRates.complexPrice.High.Inbound.Local.Detail.DisplayCode = 'X';
		LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
		
		LogisticsQuoteRates.complexPrice.High.Inbound.Local.Detail.DisplayCode = 'H';
		LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);        
        
        //INBOUND High Get Rates Html - End
        
        //OUTBOUND High Get Rates Html - Start
        
        LogisticsQuoteRates.complexPrice.High.Outbound.Air.Air2ndDay.Detail.DisplayCode = '';
        LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.High.Outbound.Air.Air2ndDay.Detail.DisplayCode = 'X';
        LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.High.Outbound.Air.Air2ndDay.Detail.DisplayCode = 'H';
        LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
          
        LogisticsQuoteRates.complexPrice.High.Outbound.Air.AirNextDay.Detail.DisplayCode = '';
        LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.High.Outbound.Air.AirNextDay.Detail.DisplayCode = 'X';
        LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.High.Outbound.Air.AirNextDay.Detail.DisplayCode = 'H';
        LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
        
        LogisticsQuoteRates.complexPrice.High.Outbound.Ground.Ltl.Detail.DisplayCode = '';
        LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.High.Outbound.Ground.Ltl.Detail.DisplayCode = 'X';
        LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.High.Outbound.Ground.Ltl.Detail.DisplayCode = 'H';
        LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
           
		LogisticsQuoteRates.complexPrice.High.Outbound.Local.Detail.Total = 10;
		LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
		
		LogisticsQuoteRates.complexPrice.High.Outbound.Local.Detail.Total = 0;
		LogisticsQuoteRates.complexPrice.High.Outbound.Local.Detail.DisplayCode = 'X';
		LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
		
		LogisticsQuoteRates.complexPrice.High.Outbound.Local.Detail.DisplayCode = 'H';
		LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);        
        
        //OUTBOUND High Get Rates Html - End 
        
        //INBOUND Low Get Rates Html - Start
        
        LogisticsQuoteRates.complexPrice.Low.Inbound.Air.Air2ndDay.Detail.DisplayCode = '';
        LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.Low.Inbound.Air.Air2ndDay.Detail.DisplayCode = 'X';
        LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q); 
        LogisticsQuoteRates.complexPrice.Low.Inbound.Air.Air2ndDay.Detail.DisplayCode = 'H';
        LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
          
        LogisticsQuoteRates.complexPrice.Low.Inbound.Air.AirNextDay.Detail.DisplayCode = '';
        LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.Low.Inbound.Air.AirNextDay.Detail.DisplayCode = 'X';
        LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.Low.Inbound.Air.AirNextDay.Detail.DisplayCode = 'H';
        LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
        
        LogisticsQuoteRates.complexPrice.Low.Inbound.Ground.Ltl.Detail.DisplayCode = '';
        LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.Low.Inbound.Ground.Ltl.Detail.DisplayCode = 'X';
        LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.Low.Inbound.Ground.Ltl.Detail.DisplayCode = 'H';
        LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
           
		LogisticsQuoteRates.complexPrice.Low.Inbound.Local.Detail.Total = 10;
		LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
		
		LogisticsQuoteRates.complexPrice.Low.Inbound.Local.Detail.Total = 0;
		LogisticsQuoteRates.complexPrice.Low.Inbound.Local.Detail.DisplayCode = 'X';
		LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
		
		LogisticsQuoteRates.complexPrice.Low.Inbound.Local.Detail.DisplayCode = 'H';
		LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);        
        
        //INBOUND Low Get Rates Html - End
        
        //OUTBOUND Low Get Rates Html - Start
        
        LogisticsQuoteRates.complexPrice.Low.Outbound.Air.Air2ndDay.Detail.DisplayCode = '';
        LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.Low.Outbound.Air.Air2ndDay.Detail.DisplayCode = 'X';
        LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.Low.Outbound.Air.Air2ndDay.Detail.DisplayCode = 'H';
        LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
        
        LogisticsQuoteRates.complexPrice.Low.Outbound.Air.AirNextDay.Detail.DisplayCode = '';
        LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.Low.Outbound.Air.AirNextDay.Detail.DisplayCode = 'X';
        LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.Low.Outbound.Air.AirNextDay.Detail.DisplayCode = 'H';
        LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
        
        LogisticsQuoteRates.complexPrice.Low.Outbound.Ground.Ltl.Detail.DisplayCode = '';
        LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.Low.Outbound.Ground.Ltl.Detail.DisplayCode = 'X';
        LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
        LogisticsQuoteRates.complexPrice.Low.Outbound.Ground.Ltl.Detail.DisplayCode = 'H';
        LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
           
		LogisticsQuoteRates.complexPrice.Low.Outbound.Local.Detail.Total = 10;
		LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
		
		LogisticsQuoteRates.complexPrice.Low.Outbound.Local.Detail.Total = 0;
		LogisticsQuoteRates.complexPrice.Low.Outbound.Local.Detail.DisplayCode = 'X';
		LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);
		
		LogisticsQuoteRates.complexPrice.Low.Outbound.Local.Detail.DisplayCode = 'H';
		LogisticsQuoteRates.GetHtmlLightning(direction, LogisticsQuoteRates.complexPrice, q);        
        
        //OUTBOUND Low Get Rates Html - End 
        
        LogisticsQuoteRates.PriceCustomQuote(q.Id, direction);
        //LogisticsQuoteRates.SetInboundRates(q.Id,direction,q);
		//LogisticsQuoteRates.SetOutboundRates(q.Id,direction,q);
        
    }
}