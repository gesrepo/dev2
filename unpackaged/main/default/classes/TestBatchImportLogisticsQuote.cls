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
private class TestBatchImportLogisticsQuote {

    static testMethod void myUnitTest() {
    // TO DO: implement unit test                              
      

    /*
        Create a stage quote to test the update logic i.e. quote 
        must already exist as a Salesforce.com Account.
                    
        This tests the code block 'Class Of Service must be specified (cannot be null) for Outbound' for existing 
        account.
            
        TODO: This quote must exist for the unit test to get code coverage.  Therefore,
        prior to deploying this code, create a quote in production Org or update
        the Quote_Number__c  and Quote_id__c field of any quote to this value in production org.
            
        Alternative, change the line (marked below) to a value of customer id that exists
        in production org.          
    */
        
        Quote__c quote = new Quote__c();           
          
        quote.Additional_Labor__c = true;
        quote.Additional_Labor_Fee__c = 123.45 ;            
        quote.Advance_Order_Discount__c = 110.63;            
        quote.AM_Specified__c = true;            
        quote.AM_Specified_Fee__c = 123.45;            
        quote.Apply_Round_Trip_Discount__c = true;
        quote.Attempt__c = true;
        quote.Attempt_Fee__c = 123.45;         
        quote.Call_Before_Delivery__c = true;
        quote.Call_Before_Pickup__c = true;
        quote.Carrier_Notes__c = 'Sample Carrier Notes';
        quote.Class_of_Service__c = 'Next Day'; // picklist
        quote.Complete_By__c =  Date.newInstance(DateTime.now().yearGmt(),DateTime.now().monthGmt()+1,1);
        quote.CORE_Order_Number__c = null;
        quote.Custom_Quote__c = false;
        quote.Delivery_Booth_No__c = 'E1200';
        quote.Delivery_Contact_Fax__c = '+17656538002';
        quote.Delivery_Contact_Name__c = 'BRIANNA PINSON';
        quote.Delivery_Contact_Phone__c = '+17656538002';
        quote.Delivery_Date__c = Date.newInstance(DateTime.now().yearGmt(),DateTime.now().monthGmt()+1,1);
        quote.Delivery_Destination__c = null;
        quote.Delivery_Show_Contractor__c = 'GES';
        quote.Delivery_Show_Name__c = 'The Consumer Electronices Show';
        quote.Delivery_Window_Start__c = '09:00';
        quote.Destination_City__c = 'Las Vegas';
        quote.Destination_Country__c = 'USA';
        quote.Destination_Postal_Code__c = '08654';
        quote.Destination_State__c = 'NV';
        quote.Destination_Street__c = '950 Grier Dr';         
        quote.EDV_Amount__c = 5000;
        quote.EDV_Amount_Exceeds_Limit__c = false;
        quote.Flat_Rate_Unit_Price_Type__c = 'Per Pound';
        quote.Fuel_Surcharge__c =  549.58;
        quote.Fuel_Unit_Surcharge__c = .345;
        quote.Hazardous_Materials__c = true;
        quote.HM_Contact_Phone__c = '+19875655644';         
        quote.Inside_Pickup__c = false;
        quote.Inside_Surcharge__c = 0.345;
        quote.Job_Code__c = 'PCEACA';
        quote.Lift_Gate__c = false;
        quote.Lift_Gate_Surcharge__c = 0.00;
        quote.Lost_Comment__c = null;
        quote.Lost_Reason__c = null;           
        quote.OB_Additional_Labor__c = false;
        quote.OB_Additional_Labor_Fee__c = 0.00;
        quote.OB_Advance_Order_Discount__c = 0.00;
        quote.OB_AM_Specified__c = false;
        quote.OB_AM_Specified_Fee__c = 0.00;
        quote.OB_Attempt__c = false;
        quote.OB_Attempt_Fee__c = 0.00;
        quote.OB_Call_Before_Delivery__c = false;
        quote.OB_Call_Before_Pickup__c = false;
        quote.OB_Carrier_Notes__c = 'Please call before delivery at this number (702) 000-0000';
        quote.OB_Class_of_Service__c = '2nd Day';
        quote.OB_Custom_Quote__c = false;
        quote.OB_Delivery_Booth_No__c = '2281';
        quote.OB_Delivery_Contact_Name__c = 'BRIANNA PINSON';
        quote.OB_Delivery_Contact_Phone__c = '+17656538262';
        quote.OB_Delivery_Date__c = Date.newInstance(DateTime.now().yearGmt(),DateTime.now().monthGmt()+1,1);
        quote.OB_Delivery_Destination__c = 'Lindell Warehouse';
        quote.OB_Delivery_Show_Contractor__c = 'GES';
        quote.OB_Delivery_Show_Name__c = 'Entertainment Annual Show';
        quote.OB_Delivery_Window_Start__c = null;
        quote.OB_Destination_City__c = 'Victorville';
        quote.OB_Destination_Country__c ='USA';
        quote.OB_Destination_Postal_Code__c = '40010';
        quote.OB_Destination_State__c = 'CA';
        quote.OB_Destination_Street__c = '123 Paradise Rd';
        quote.OB_Flat_Rate_Unit_Price_Type__c = 'Per Pound';
        quote.OB_Fuel_Surcharge__c = 549.58;
        quote.OB_Fuel_Unit_Surcharge__c = .345;
        quote.OB_Hazardous_Materials__c = true;
        quote.OB_HM_Contact_Phone__c = '+19875655644';
        quote.OB_Inside_Pickup__c = false;
        quote.OB_Inside_Surcharge__c = 0.00;
        quote.OB_Lift_Gate__c = false;
        quote.OB_Lift_Gate_Surcharge__c = 0.00;
        quote.OB_Origination_City__c = 'Helena';
        quote.OB_Origination_Country__c = 'USA';
        quote.OB_Origination_Postal_Code__c = '23000';
        quote.OB_Origination_State__c = 'MT';
        quote.OB_Origination_Street__c = '8001 Union St';
        quote.OB_Pallet_Jack__c = false;
        quote.OB_Palletization__c = false;
        quote.OB_Palletization_Fee__c = 0.00;
        quote.OB_Pickup_Booth_No__c = 'A1000';
        quote.OB_Pickup_Contact_Name__c = 'BRIANNA PINSON';
        quote.OB_Pickup_Contact_Phone__c = '+17656538262';
        quote.OB_Pickup_Date__c = Date.newInstance(DateTime.now().yearGmt(),DateTime.now().monthGmt()+1,1);
        quote.OB_Pickup_Show_Contractor__c = 'GES';
        quote.OB_Pickup_Show_Name__c = 'CES';
        quote.OB_Pickup_Window_Start__c = '15:00';
        quote.OB_Pickup_Window_Start_Late__c = true;
        quote.OB_Residential_Pickup__c = false;
        quote.OB_Residential_Surcharge__c = 0.00;
        quote.OB_Round_Trip_Discount__c = 0.00;
        quote.OB_Selection__c = 'Name Your Price';
        quote.OB_Service_Type__c = 'LTL';
        quote.OB_Shipment_Type__c = 'Air Transportation';
        quote.OB_Sub_Total__c = 1062.00;
        quote.OB_Total__c = 1428.39;
        quote.OB_Unit_Price__c = 2.00;
        quote.OB_Wait_Time__c = false;
        quote.OB_Wait_Time_Fee__c = 0.00;
        quote.OB_Weekend_Delivery__c = true;
        quote.OB_Weekend_Fee__c = 0.00;
        quote.OB_Weekend_Pickup__c = false;
        quote.Origination_City__c =  'LAS VEGAS';
        quote.Origination_Country__c = 'United States';
        quote.Origination_Postal_Code__c = '89123';
        quote.Origination_State__c = 'NV';
        quote.Origination_Street__c = '950 Grier Dr';
        quote.Pallet_Jack__c = false;
        quote.Palletization__c = true;
        quote.Palletization_Fee__c = 0.00;
        quote.Pickup_Booth_No__c = 'A1000';
        quote.Pickup_Contact_Fax__c = '+17656538262';
        quote.Pickup_Contact_Name__c = 'BRIANNA PINSON';
        quote.Pickup_Contact_Phone__c = '+17656538262';
        quote.Pickup_Date__c = Date.newInstance(DateTime.now().yearGmt(),DateTime.now().monthGmt()+1,1);
        quote.Pickup_Show_Contractor__c = 'Freeman';
        quote.Pickup_Show_Name__c = 'Entertainment Annual Show';
        quote.Pickup_Window_Start__c = '14:00';
        quote.Pickup_Window_Start_Late__c = true;         
        quote.Quote_Subject__c = 'Roundtrip';
        quote.Residential_Pickup__c = true;
        quote.Residential_Surcharge__c = 0.00;
        quote.Round_Trip_Discount__c = 10.00;
        quote.Selection__c = 'Name Your Price';
        quote.Service_Type__c = 'LTL';
        quote.Ship_To_Location__c = null; //'The Consumer Electronics Show';
        quote.Shipment_Type__c = 'Ground Transportation';
        quote.Source__c = 'Chat - Logistics Link';
        quote.Stage__c = 'Pending Traffic Quote';
        quote.Sub_Total__c = 1593;
        quote.Total__c = 2142;
        quote.Type__c = 'Logistics Domestic - Inbound';
        quote.Unit_Price__c = 3.00;
        quote.Wait_Time__c = false;
        quote.Wait_Time_Fee__c = 0.00;
        quote.Weekend_Delivery__c = false;
        quote.Weekend_Fee__c = 0.00;
        quote.Weekend_Pickup__c = false;
        quote.Weight_Override__c = null;
        
        Database.insert(quote);
        
        Quote_Staging__c QuoteStaging = new Quote_Staging__c();        
       
        
        QuoteStaging.Quote_id__c = quote.Id;    
        QuoteStaging.Quote_Number__c = quote.Name;  
        QuoteStaging.Additional_Labor__c = true;
        QuoteStaging.Additional_Labor_Fee__c = 123.45 ;            
        QuoteStaging.Advance_Order_Discount__c = 110.63;            
        QuoteStaging.AM_Specified__c = true;            
        QuoteStaging.AM_Specified_Fee__c = 123.45;            
        QuoteStaging.Apply_Round_Trip_Discount__c = true;
        QuoteStaging.Attempt__c = true;
        QuoteStaging.Attempt_Fee__c = 123.45;         
        QuoteStaging.Call_Before_Delivery__c = true;
        QuoteStaging.Call_Before_Pickup__c = true;
        QuoteStaging.Carrier_Notes__c = 'Sample Carrier Notes';
        QuoteStaging.Class_of_Service__c = 'Next Day'; // picklist
        QuoteStaging.Complete_By__c =  Date.newInstance(DateTime.now().yearGmt(),DateTime.now().monthGmt()+1,1);
        QuoteStaging.CORE_Order_Number__c = null;
        QuoteStaging.Custom_Quote__c = false;
        QuoteStaging.Delivery_Booth_No__c = 'E1200';
        QuoteStaging.Delivery_Contact_Fax__c = '+17656538002';
        QuoteStaging.Delivery_Contact_Name__c = 'BRIANNA PINSON';
        QuoteStaging.Delivery_Contact_Phone__c = '+17656538002';
        QuoteStaging.Delivery_Date__c = Date.newInstance(DateTime.now().yearGmt(),DateTime.now().monthGmt()+1,1);
        QuoteStaging.Delivery_Destination__c = null;
        QuoteStaging.Delivery_Show_Contractor__c = 'GES';
        QuoteStaging.Delivery_Show_Name__c = 'The Consumer Electronices Show';
        QuoteStaging.Delivery_Window_Start__c = '09:00';
        QuoteStaging.Destination_City__c = 'Las Vegas';
        QuoteStaging.Destination_Country__c = 'USA';
        QuoteStaging.Destination_Postal_Code__c = '08654';
        QuoteStaging.Destination_State__c = 'NV';
        QuoteStaging.Destination_Street__c = '950 Grier Dr';         
        QuoteStaging.EDV_Amount__c = 5000;
        QuoteStaging.EDV_Amount_Exceeds_Limit__c = false;
        QuoteStaging.Flat_Rate_Unit_Price_Type__c = 'Per Pound';
        QuoteStaging.Fuel_Surcharge__c =  549.58;
        QuoteStaging.Fuel_Unit_Surcharge__c = .345;
        QuoteStaging.Hazardous_Materials__c = true;
        QuoteStaging.HM_Contact_Phone__c = '+19875655644';         
        QuoteStaging.Inside_Pickup__c = false;
        QuoteStaging.Inside_Surcharge__c = 0.345;
        QuoteStaging.Job_Code__c = 'PCEACA';
        QuoteStaging.Lift_Gate__c = false;
        QuoteStaging.Lift_Gate_Surcharge__c = 0.00;
        QuoteStaging.Lost_Comment__c = null;
        QuoteStaging.Lost_Reason__c = null;           
        QuoteStaging.OB_Additional_Labor__c = false;
        QuoteStaging.OB_Additional_Labor_Fee__c = 0.00;
        QuoteStaging.OB_Advance_Order_Discount__c = 0.00;
        QuoteStaging.OB_AM_Specified__c = false;
        QuoteStaging.OB_AM_Specified_Fee__c = 0.00;
        QuoteStaging.OB_Attempt__c = false;
        QuoteStaging.OB_Attempt_Fee__c = 0.00;
        QuoteStaging.OB_Call_Before_Delivery__c = false;
        QuoteStaging.OB_Call_Before_Pickup__c = false;
        QuoteStaging.OB_Carrier_Notes__c = 'Please call before delivery at this number (702) 000-0000';
        QuoteStaging.OB_Class_of_Service__c = '2nd Day';
        QuoteStaging.OB_Custom_Quote__c = false;
        QuoteStaging.OB_Delivery_Booth_No__c = '2281';
        QuoteStaging.OB_Delivery_Contact_Name__c = 'BRIANNA PINSON';
        QuoteStaging.OB_Delivery_Contact_Phone__c = '+17656538262';
        QuoteStaging.OB_Delivery_Date__c = Date.newInstance(DateTime.now().yearGmt(),DateTime.now().monthGmt()+1,1);
        QuoteStaging.OB_Delivery_Destination__c = 'Lindell Warehouse';
        QuoteStaging.OB_Delivery_Show_Contractor__c = 'GES';
        QuoteStaging.OB_Delivery_Show_Name__c = 'Entertainment Annual Show';
        QuoteStaging.OB_Delivery_Window_Start__c = null;
        QuoteStaging.OB_Destination_City__c = 'Victorville';
        QuoteStaging.OB_Destination_Country__c ='USA';
        QuoteStaging.OB_Destination_Postal_Code__c = '40010';
        QuoteStaging.OB_Destination_State__c = 'CA';
        QuoteStaging.OB_Destination_Street__c = '123 Paradise Rd';
        QuoteStaging.OB_Flat_Rate_Unit_Price_Type__c = 'Per Pound';
        QuoteStaging.OB_Fuel_Surcharge__c = 549.58;
        QuoteStaging.OB_Fuel_Unit_Surcharge__c = .345;
        QuoteStaging.OB_Hazardous_Materials__c = true;
        QuoteStaging.OB_HM_Contact_Phone__c = '+19875655644';
        QuoteStaging.OB_Inside_Pickup__c = false;
        QuoteStaging.OB_Inside_Surcharge__c = 0.00;
        QuoteStaging.OB_Lift_Gate__c = false;
        QuoteStaging.OB_Lift_Gate_Surcharge__c = 0.00;
        QuoteStaging.OB_Origination_City__c = 'Helena';
        QuoteStaging.OB_Origination_Country__c = 'USA';
        QuoteStaging.OB_Origination_Postal_Code__c = '23000';
        QuoteStaging.OB_Origination_State__c = 'MT';
        QuoteStaging.OB_Origination_Street__c = '8001 Union St';
        QuoteStaging.OB_Pallet_Jack__c = false;
        QuoteStaging.OB_Palletization__c = false;
        QuoteStaging.OB_Palletization_Fee__c = 0.00;
        QuoteStaging.OB_Pickup_Booth_No__c = 'A1000';
        QuoteStaging.OB_Pickup_Contact_Name__c = 'BRIANNA PINSON';
        QuoteStaging.OB_Pickup_Contact_Phone__c = '+17656538262';
        QuoteStaging.OB_Pickup_Date__c = Date.newInstance(DateTime.now().yearGmt(),DateTime.now().monthGmt()+1,1);
        QuoteStaging.OB_Pickup_Show_Contractor__c = 'GES';
        QuoteStaging.OB_Pickup_Show_Name__c = 'CES';
        QuoteStaging.OB_Pickup_Window_Start__c = '15:00';
        QuoteStaging.OB_Pickup_Window_Start_Late__c = true;
        QuoteStaging.OB_Residential_Pickup__c = false;
        QuoteStaging.OB_Residential_Surcharge__c = 0.00;
        QuoteStaging.OB_Round_Trip_Discount__c = 0.00;
        QuoteStaging.OB_Selection__c = 'Name Your Price';
        QuoteStaging.OB_Service_Type__c = 'LTL';
        QuoteStaging.OB_Shipment_Type__c = 'Air Transportation';
        QuoteStaging.OB_Sub_Total__c = 1062.00;
        QuoteStaging.OB_Total__c = 1428.39;
        QuoteStaging.OB_Unit_Price__c = 2.00;
        QuoteStaging.OB_Wait_Time__c = false;
        QuoteStaging.OB_Wait_Time_Fee__c = 0.00;
        QuoteStaging.OB_Weekend_Delivery__c = true;
        QuoteStaging.OB_Weekend_Fee__c = 0.00;
        QuoteStaging.OB_Weekend_Pickup__c = false;
        QuoteStaging.Origination_City__c =  'LAS VEGAS';
        QuoteStaging.Origination_Country__c = 'United States';
        QuoteStaging.Origination_Postal_Code__c = '89123';
        QuoteStaging.Origination_State__c = 'NV';
        QuoteStaging.Origination_Street__c = '950 Grier Dr';
        QuoteStaging.Pallet_Jack__c = false;
        QuoteStaging.Palletization__c = true;
        QuoteStaging.Palletization_Fee__c = 0.00;
        QuoteStaging.Pickup_Booth_No__c = 'A1000';
        QuoteStaging.Pickup_Contact_Fax__c = '+17656538262';
        QuoteStaging.Pickup_Contact_Name__c = 'BRIANNA PINSON';
        QuoteStaging.Pickup_Contact_Phone__c = '+17656538262';
        QuoteStaging.Pickup_Date__c = Date.newInstance(DateTime.now().yearGmt(),DateTime.now().monthGmt()+1,1);
        QuoteStaging.Pickup_Show_Contractor__c = 'Freeman';
        QuoteStaging.Pickup_Show_Name__c = 'Entertainment Annual Show';
        QuoteStaging.Pickup_Window_Start__c = '14:00';
        QuoteStaging.Pickup_Window_Start_Late__c = true;         
        QuoteStaging.Quote_Subject__c = 'Roundtrip';
        QuoteStaging.Residential_Pickup__c = true;
        QuoteStaging.Residential_Surcharge__c = 0.00;
        QuoteStaging.Round_Trip_Discount__c = 10.00;
        QuoteStaging.Selection__c = 'Name Your Price';
        QuoteStaging.Service_Type__c = 'LTL';
        QuoteStaging.Ship_To_Location__c = null; //'The Consumer Electronics Show';
        QuoteStaging.Shipment_Type__c = 'Ground Transportation';
        QuoteStaging.Source__c = 'Chat - Logistics Link';
        QuoteStaging.Stage__c = 'Pending Traffic Quote';
        QuoteStaging.Sub_Total__c = 1593;
        QuoteStaging.Total__c = 2142;
        QuoteStaging.Type__c = 'Logistics Domestic - Inbound';
        QuoteStaging.Unit_Price__c = 3.00;
        QuoteStaging.Wait_Time__c = false;
        QuoteStaging.Wait_Time_Fee__c = 0.00;
        QuoteStaging.Weekend_Delivery__c = false;
        QuoteStaging.Weekend_Fee__c = 0.00;
        QuoteStaging.Weekend_Pickup__c = false;
        QuoteStaging.Weight_Override__c = null;
        
        Database.insert(QuoteStaging); 
        
        
       Quote__c QuoteFailed = new Quote__c();        
       
          
        QuoteFailed.Additional_Labor__c = true;
        QuoteFailed.Additional_Labor_Fee__c = 123.45 ;            
        QuoteFailed.Advance_Order_Discount__c = 110.63;            
        QuoteFailed.AM_Specified__c = true;            
        QuoteFailed.AM_Specified_Fee__c = 123.45;            
        QuoteFailed.Apply_Round_Trip_Discount__c = true;
        QuoteFailed.Attempt__c = true;
        QuoteFailed.Attempt_Fee__c = 123.45;         
        QuoteFailed.Call_Before_Delivery__c = true;
        QuoteFailed.Call_Before_Pickup__c = true;
        QuoteFailed.Carrier_Notes__c = 'Sample Carrier Notes';
        QuoteFailed.Class_of_Service__c = 'Next Day'; // picklist
        QuoteFailed.Complete_By__c =  Date.newInstance(DateTime.now().yearGmt(),DateTime.now().monthGmt()+1,1);
        QuoteFailed.CORE_Order_Number__c = null;
        QuoteFailed.Custom_Quote__c = false;
        QuoteFailed.Delivery_Booth_No__c = 'E1200';
        QuoteFailed.Delivery_Contact_Fax__c = '+17656538002';
        QuoteFailed.Delivery_Contact_Name__c = 'BRIANNA PINSON';
        QuoteFailed.Delivery_Contact_Phone__c = '+17656538002';
        QuoteFailed.Delivery_Date__c = Date.newInstance(DateTime.now().yearGmt(),DateTime.now().monthGmt()+1,1);
        QuoteFailed.Delivery_Destination__c = null;
        QuoteFailed.Delivery_Show_Contractor__c = 'GES';
        QuoteFailed.Delivery_Show_Name__c = 'The Consumer Electronices Show';
        QuoteFailed.Delivery_Window_Start__c = '09:00';
        QuoteFailed.Destination_City__c = 'Las Vegas';
        QuoteFailed.Destination_Country__c = 'USA';
        QuoteFailed.Destination_Postal_Code__c = '08654';
        QuoteFailed.Destination_State__c = 'NV';
        QuoteFailed.Destination_Street__c = '950 Grier Dr';         
        QuoteFailed.EDV_Amount__c = 5000;
        QuoteFailed.EDV_Amount_Exceeds_Limit__c = false;
        QuoteFailed.Flat_Rate_Unit_Price_Type__c = 'Per Pound';
        QuoteFailed.Fuel_Surcharge__c =  549.58;
        QuoteFailed.Fuel_Unit_Surcharge__c = .345;
        QuoteFailed.Hazardous_Materials__c = true;
        QuoteFailed.HM_Contact_Phone__c = '+19875655644';         
        QuoteFailed.Inside_Pickup__c = false;
        QuoteFailed.Inside_Surcharge__c = 0.345;
        QuoteFailed.Job_Code__c = 'PCEACA';
        QuoteFailed.Lift_Gate__c = false;
        QuoteFailed.Lift_Gate_Surcharge__c = 0.00;
        QuoteFailed.Lost_Comment__c = null;
        QuoteFailed.Lost_Reason__c = null;           
        QuoteFailed.OB_Additional_Labor__c = false;
        QuoteFailed.OB_Additional_Labor_Fee__c = 0.00;
        QuoteFailed.OB_Advance_Order_Discount__c = 0.00;
        QuoteFailed.OB_AM_Specified__c = false;
        QuoteFailed.OB_AM_Specified_Fee__c = 0.00;
        QuoteFailed.OB_Attempt__c = false;
        QuoteFailed.OB_Attempt_Fee__c = 0.00;
        QuoteFailed.OB_Call_Before_Delivery__c = false;
        QuoteFailed.OB_Call_Before_Pickup__c = false;
        QuoteFailed.OB_Carrier_Notes__c = 'Please call before delivery at this number (702) 000-0000';
        QuoteFailed.OB_Class_of_Service__c = '2nd Day';
        QuoteFailed.OB_Custom_Quote__c = false;
        QuoteFailed.OB_Delivery_Booth_No__c = '2281';
        QuoteFailed.OB_Delivery_Contact_Name__c = 'BRIANNA PINSON';
        QuoteFailed.OB_Delivery_Contact_Phone__c = '+17656538262';
        QuoteFailed.OB_Delivery_Date__c = Date.newInstance(DateTime.now().yearGmt(),DateTime.now().monthGmt()+1,1);
        QuoteFailed.OB_Delivery_Destination__c = 'Lindell Warehouse';
        QuoteFailed.OB_Delivery_Show_Contractor__c = 'GES';
        QuoteFailed.OB_Delivery_Show_Name__c = 'Entertainment Annual Show';
        QuoteFailed.OB_Delivery_Window_Start__c = null;
        QuoteFailed.OB_Destination_City__c = 'Victorville';
        QuoteFailed.OB_Destination_Country__c ='USA';
        QuoteFailed.OB_Destination_Postal_Code__c = '40010';
        QuoteFailed.OB_Destination_State__c = 'CA';
        QuoteFailed.OB_Destination_Street__c = '123 Paradise Rd';
        QuoteFailed.OB_Flat_Rate_Unit_Price_Type__c = 'Per Pound';
        QuoteFailed.OB_Fuel_Surcharge__c = 549.58;
        QuoteFailed.OB_Fuel_Unit_Surcharge__c = .345;
        QuoteFailed.OB_Hazardous_Materials__c = true;
        QuoteFailed.OB_HM_Contact_Phone__c = '+19875655644';
        QuoteFailed.OB_Inside_Pickup__c = false;
        QuoteFailed.OB_Inside_Surcharge__c = 0.00;
        QuoteFailed.OB_Lift_Gate__c = false;
        QuoteFailed.OB_Lift_Gate_Surcharge__c = 0.00;
        QuoteFailed.OB_Origination_City__c = 'Helena';
        QuoteFailed.OB_Origination_Country__c = 'USA';
        QuoteFailed.OB_Origination_Postal_Code__c = '23000';
        QuoteFailed.OB_Origination_State__c = 'MT';
        QuoteFailed.OB_Origination_Street__c = '8001 Union St';
        QuoteFailed.OB_Pallet_Jack__c = false;
        QuoteFailed.OB_Palletization__c = false;
        QuoteFailed.OB_Palletization_Fee__c = 0.00;
        QuoteFailed.OB_Pickup_Booth_No__c = 'A1000';
        QuoteFailed.OB_Pickup_Contact_Name__c = 'BRIANNA PINSON';
        QuoteFailed.OB_Pickup_Contact_Phone__c = '+17656538262';
        QuoteFailed.OB_Pickup_Date__c = Date.newInstance(DateTime.now().yearGmt(),DateTime.now().monthGmt()+1,1);
        QuoteFailed.OB_Pickup_Show_Contractor__c = 'GES';
        QuoteFailed.OB_Pickup_Show_Name__c = 'CES';
        QuoteFailed.OB_Pickup_Window_Start__c = '15:00';
        QuoteFailed.OB_Pickup_Window_Start_Late__c = true;
        QuoteFailed.OB_Residential_Pickup__c = false;
        QuoteFailed.OB_Residential_Surcharge__c = 0.00;
        QuoteFailed.OB_Round_Trip_Discount__c = 0.00;
        QuoteFailed.OB_Selection__c = 'Name Your Price';
        QuoteFailed.OB_Service_Type__c = 'LTL';
        QuoteFailed.OB_Shipment_Type__c = 'Air Transportation';
        QuoteFailed.OB_Sub_Total__c = 1062.00;
        QuoteFailed.OB_Total__c = 1428.39;
        QuoteFailed.OB_Unit_Price__c = 2.00;
        QuoteFailed.OB_Wait_Time__c = false;
        QuoteFailed.OB_Wait_Time_Fee__c = 0.00;
        QuoteFailed.OB_Weekend_Delivery__c = true;
        QuoteFailed.OB_Weekend_Fee__c = 0.00;
        QuoteFailed.OB_Weekend_Pickup__c = false;
        QuoteFailed.Origination_City__c =  'LAS VEGAS';
        QuoteFailed.Origination_Country__c = 'United States';
        QuoteFailed.Origination_Postal_Code__c = '89123';
        QuoteFailed.Origination_State__c = 'NV';
        QuoteFailed.Origination_Street__c = '950 Grier Dr';
        QuoteFailed.Pallet_Jack__c = false;
        QuoteFailed.Palletization__c = true;
        QuoteFailed.Palletization_Fee__c = 0.00;
        QuoteFailed.Pickup_Booth_No__c = 'A1000';
        QuoteFailed.Pickup_Contact_Fax__c = '+17656538262';
        QuoteFailed.Pickup_Contact_Name__c = 'BRIANNA PINSON';
        QuoteFailed.Pickup_Contact_Phone__c = '+17656538262';
        QuoteFailed.Pickup_Date__c = Date.newInstance(DateTime.now().yearGmt(),DateTime.now().monthGmt()+1,1);
        QuoteFailed.Pickup_Show_Contractor__c = 'Freeman';
        QuoteFailed.Pickup_Show_Name__c = 'Entertainment Annual Show';
        QuoteFailed.Pickup_Window_Start__c = '14:00';
        QuoteFailed.Pickup_Window_Start_Late__c = true;         
        QuoteFailed.Quote_Subject__c = 'Roundtrip';
        QuoteFailed.Residential_Pickup__c = true;
        QuoteFailed.Residential_Surcharge__c = 0.00;
        QuoteFailed.Round_Trip_Discount__c = 10.00;
        QuoteFailed.Selection__c = 'Name Your Price';
        QuoteFailed.Service_Type__c = 'LTL';
        QuoteFailed.Ship_To_Location__c = null; //'The Consumer Electronics Show';
        QuoteFailed.Shipment_Type__c = 'Ground Transportation';
        QuoteFailed.Source__c = 'Chat - Logistics Link';
        QuoteFailed.Stage__c = 'Pending Traffic Quote';
        QuoteFailed.Sub_Total__c = 1593;
        QuoteFailed.Total__c = 2142;
        QuoteFailed.Type__c = 'Logistics Domestic - Inbound';
        QuoteFailed.Unit_Price__c = 3.00;
        QuoteFailed.Wait_Time__c = false;
        QuoteFailed.Wait_Time_Fee__c = 0.00;
        QuoteFailed.Weekend_Delivery__c = false;
        QuoteFailed.Weekend_Fee__c = 0.00;
        QuoteFailed.Weekend_Pickup__c = false;
        QuoteFailed.Weight_Override__c = null;
        
        Database.insert(QuoteFailed);     
        
        
       Quote_Staging__c QuoteStgFailed = new Quote_Staging__c();        
       
        
        QuoteStgFailed.Quote_id__c = QuoteFailed.Id;    
        QuoteStgFailed.Quote_Number__c = QuoteFailed.Name;  
        QuoteStgFailed.Additional_Labor__c = true;
        QuoteStgFailed.Additional_Labor_Fee__c = 123.45 ;            
        QuoteStgFailed.Advance_Order_Discount__c = 110.63;            
        QuoteStgFailed.AM_Specified__c = true;            
        QuoteStgFailed.AM_Specified_Fee__c = 123.45;            
        QuoteStgFailed.Apply_Round_Trip_Discount__c = true;
        QuoteStgFailed.Attempt__c = true;
        QuoteStgFailed.Attempt_Fee__c = 123.45;         
        QuoteStgFailed.Call_Before_Delivery__c = true;
        QuoteStgFailed.Call_Before_Pickup__c = true;
        QuoteStgFailed.Carrier_Notes__c = 'Sample Carrier Notes';
        QuoteStgFailed.Class_of_Service__c = 'Next Day'; // picklist
        QuoteStgFailed.Complete_By__c =  Date.newInstance(DateTime.now().yearGmt(),DateTime.now().monthGmt()+1,1);
        QuoteStgFailed.CORE_Order_Number__c = null;
        QuoteStgFailed.Custom_Quote__c = false;
        QuoteStgFailed.Delivery_Booth_No__c = 'E1200';
        QuoteStgFailed.Delivery_Contact_Fax__c = '+17656538002';
        QuoteStgFailed.Delivery_Contact_Name__c = 'BRIANNA PINSON';
        QuoteStgFailed.Delivery_Contact_Phone__c = '+17656538002';
        QuoteStgFailed.Delivery_Date__c = Date.newInstance(DateTime.now().yearGmt(),DateTime.now().monthGmt()+1,1);
        QuoteStgFailed.Delivery_Destination__c = null;
        QuoteStgFailed.Delivery_Show_Contractor__c = 'GES';
        QuoteStgFailed.Delivery_Show_Name__c = 'The Consumer Electronices Show';
        QuoteStgFailed.Delivery_Window_Start__c = '09:00';
        QuoteStgFailed.Destination_City__c = 'Las Vegas';
        QuoteStgFailed.Destination_Country__c = 'USA';
        QuoteStgFailed.Destination_Postal_Code__c = '08654';
        QuoteStgFailed.Destination_State__c = 'NV';
        QuoteStgFailed.Destination_Street__c = '950 Grier Dr';         
        QuoteStgFailed.EDV_Amount__c = 5000;
        QuoteStgFailed.EDV_Amount_Exceeds_Limit__c = false;
        QuoteStgFailed.Flat_Rate_Unit_Price_Type__c = 'Per Pound';
        QuoteStgFailed.Fuel_Surcharge__c =  549.58;
        QuoteStgFailed.Fuel_Unit_Surcharge__c = .345;
        QuoteStgFailed.Hazardous_Materials__c = true;
        QuoteStgFailed.HM_Contact_Phone__c = '+19875655644';         
        QuoteStgFailed.Inside_Pickup__c = false;
        QuoteStgFailed.Inside_Surcharge__c = 0.345;
        QuoteStgFailed.Job_Code__c = 'PCEACA';
        QuoteStgFailed.Lift_Gate__c = false;
        QuoteStgFailed.Lift_Gate_Surcharge__c = 0.00;
        QuoteStgFailed.Lost_Comment__c = null;
        QuoteStgFailed.Lost_Reason__c = null;           
        QuoteStgFailed.OB_Additional_Labor__c = false;
        QuoteStgFailed.OB_Additional_Labor_Fee__c = 0.00;
        QuoteStgFailed.OB_Advance_Order_Discount__c = 0.00;
        QuoteStgFailed.OB_AM_Specified__c = false;
        QuoteStgFailed.OB_AM_Specified_Fee__c = 0.00;
        QuoteStgFailed.OB_Attempt__c = false;
        QuoteStgFailed.OB_Attempt_Fee__c = 0.00;
        QuoteStgFailed.OB_Call_Before_Delivery__c = false;
        QuoteStgFailed.OB_Call_Before_Pickup__c = false;
        QuoteStgFailed.OB_Carrier_Notes__c = 'Please call before delivery at this number (702) 000-0000';
        QuoteStgFailed.OB_Class_of_Service__c = null;
        QuoteStgFailed.OB_Custom_Quote__c = false;
        QuoteStgFailed.OB_Delivery_Booth_No__c = '2281';
        QuoteStgFailed.OB_Delivery_Contact_Name__c = 'BRIANNA PINSON';
        QuoteStgFailed.OB_Delivery_Contact_Phone__c = '+17656538262';
        QuoteStgFailed.OB_Delivery_Date__c = Date.newInstance(DateTime.now().yearGmt(),DateTime.now().monthGmt()+1,1);
        QuoteStgFailed.OB_Delivery_Destination__c = 'Lindell Warehouse';
        QuoteStgFailed.OB_Delivery_Show_Contractor__c = 'GES';
        QuoteStgFailed.OB_Delivery_Show_Name__c = 'Entertainment Annual Show';
        QuoteStgFailed.OB_Delivery_Window_Start__c = null;
        QuoteStgFailed.OB_Destination_City__c = 'Victorville';
        QuoteStgFailed.OB_Destination_Country__c ='USA';
        QuoteStgFailed.OB_Destination_Postal_Code__c = '40010';
        QuoteStgFailed.OB_Destination_State__c = 'CA';
        QuoteStgFailed.OB_Destination_Street__c = '123 Paradise Rd';
        QuoteStgFailed.OB_Flat_Rate_Unit_Price_Type__c = 'Per Pound';
        QuoteStgFailed.OB_Fuel_Surcharge__c = 549.58;
        QuoteStgFailed.OB_Fuel_Unit_Surcharge__c = .345;
        QuoteStgFailed.OB_Hazardous_Materials__c = true;
        QuoteStgFailed.OB_HM_Contact_Phone__c = '+19875655644';
        QuoteStgFailed.OB_Inside_Pickup__c = false;
        QuoteStgFailed.OB_Inside_Surcharge__c = 0.00;
        QuoteStgFailed.OB_Lift_Gate__c = false;
        QuoteStgFailed.OB_Lift_Gate_Surcharge__c = 0.00;
        QuoteStgFailed.OB_Origination_City__c = 'Helena';
        QuoteStgFailed.OB_Origination_Country__c = 'USA';
        QuoteStgFailed.OB_Origination_Postal_Code__c = '23000';
        QuoteStgFailed.OB_Origination_State__c = 'MT';
        QuoteStgFailed.OB_Origination_Street__c = '8001 Union St';
        QuoteStgFailed.OB_Pallet_Jack__c = false;
        QuoteStgFailed.OB_Palletization__c = false;
        QuoteStgFailed.OB_Palletization_Fee__c = 0.00;
        QuoteStgFailed.OB_Pickup_Booth_No__c = 'A1000';
        QuoteStgFailed.OB_Pickup_Contact_Name__c = 'BRIANNA PINSON';
        QuoteStgFailed.OB_Pickup_Contact_Phone__c = '+17656538262';
        QuoteStgFailed.OB_Pickup_Date__c = Date.newInstance(DateTime.now().yearGmt(),DateTime.now().monthGmt()+1,1);
        QuoteStgFailed.OB_Pickup_Show_Contractor__c = 'GES';
        QuoteStgFailed.OB_Pickup_Show_Name__c = 'CES';
        QuoteStgFailed.OB_Pickup_Window_Start__c = '15:00';
        QuoteStgFailed.OB_Pickup_Window_Start_Late__c = true;
        QuoteStgFailed.OB_Residential_Pickup__c = false;
        QuoteStgFailed.OB_Residential_Surcharge__c = 0.00;
        QuoteStgFailed.OB_Round_Trip_Discount__c = 0.00;
        QuoteStgFailed.OB_Selection__c = 'Name Your Price';
        QuoteStgFailed.OB_Service_Type__c = 'LTL';
        QuoteStgFailed.OB_Shipment_Type__c = 'Air Transportation';
        QuoteStgFailed.OB_Sub_Total__c = 1062.00;
        QuoteStgFailed.OB_Total__c = 1428.39;
        QuoteStgFailed.OB_Unit_Price__c = 2.00;
        QuoteStgFailed.OB_Wait_Time__c = false;
        QuoteStgFailed.OB_Wait_Time_Fee__c = 0.00;
        QuoteStgFailed.OB_Weekend_Delivery__c = true;
        QuoteStgFailed.OB_Weekend_Fee__c = 0.00;
        QuoteStgFailed.OB_Weekend_Pickup__c = false;
        QuoteStgFailed.Origination_City__c =  'LAS VEGAS';
        QuoteStgFailed.Origination_Country__c = 'United States';
        QuoteStgFailed.Origination_Postal_Code__c = '89123';
        QuoteStgFailed.Origination_State__c = 'NV';
        QuoteStgFailed.Origination_Street__c = '950 Grier Dr';
        QuoteStgFailed.Pallet_Jack__c = false;
        QuoteStgFailed.Palletization__c = true;
        QuoteStgFailed.Palletization_Fee__c = 0.00;
        QuoteStgFailed.Pickup_Booth_No__c = 'A1000';
        QuoteStgFailed.Pickup_Contact_Fax__c = '+17656538262';
        QuoteStgFailed.Pickup_Contact_Name__c = 'BRIANNA PINSON';
        QuoteStgFailed.Pickup_Contact_Phone__c = '+17656538262';
        QuoteStgFailed.Pickup_Date__c = Date.newInstance(DateTime.now().yearGmt(),DateTime.now().monthGmt()+1,1);
        QuoteStgFailed.Pickup_Show_Contractor__c = 'Freeman';
        QuoteStgFailed.Pickup_Show_Name__c = 'Entertainment Annual Show';
        QuoteStgFailed.Pickup_Window_Start__c = '14:00';
        QuoteStgFailed.Pickup_Window_Start_Late__c = true;         
        QuoteStgFailed.Quote_Subject__c = 'Roundtrip';
        QuoteStgFailed.Residential_Pickup__c = true;
        QuoteStgFailed.Residential_Surcharge__c = 0.00;
        QuoteStgFailed.Round_Trip_Discount__c = 10.00;
        QuoteStgFailed.Selection__c = 'Name Your Price';
        QuoteStgFailed.Service_Type__c = 'LTL';
        QuoteStgFailed.Ship_To_Location__c = null; //'The Consumer Electronics Show';
        QuoteStgFailed.Shipment_Type__c = 'Ground Transportation';
        QuoteStgFailed.Source__c = 'Chat - Logistics Link';
        QuoteStgFailed.Stage__c = 'Pending Traffic Quote';
        QuoteStgFailed.Sub_Total__c = 1593;
        QuoteStgFailed.Total__c = 2142;
        QuoteStgFailed.Type__c = 'Logistics Domestic - Inbound';
        QuoteStgFailed.Unit_Price__c = 3.00;
        QuoteStgFailed.Wait_Time__c = false;
        QuoteStgFailed.Wait_Time_Fee__c = 0.00;
        QuoteStgFailed.Weekend_Delivery__c = false;
        QuoteStgFailed.Weekend_Fee__c = 0.00;
        QuoteStgFailed.Weekend_Pickup__c = false;
        QuoteStgFailed.Weight_Override__c = null;
       
        
        Database.insert(QuoteStgFailed);   
        
                
        test.StartTest();
                
        // Test Insert of new Quotes and update failures
        BatchImportLogisticsQuote BatchQuotes = new BatchImportLogisticsQuote();      
        
        String query = 'Select q.Weight_Override__c, q.Weekend_Pickup__c, q.Weekend_Fee__c, q.Weekend_Delivery__c, q.Wait_Time__c, q.Wait_Time_Fee__c, q.Unit_Price__c, q.Type__c, q.Total__c, q.SystemModstamp, q.Sub_Total__c, q.Stage__c, q.Source__c, q.Shipment_Type__c, q.Ship_To_Location__c, q.Service_Type__c, q.Selection__c, q.Round_Trip_Discount__c, q.Residential_Surcharge__c, q.Residential_Pickup__c, q.Quote_Subject__c, q.Quote_Number__c, q.Quote_Id__c, q.Project_Number__c, q.Pickup_Window_Start__c, q.Pickup_Window_Start_Late__c, q.Pickup_Show_Name__c, q.Pickup_Show_Contractor__c, q.Pickup_Date__c, q.Pickup_Contact_Phone__c, q.Pickup_Contact_Name__c, q.Pickup_Contact_Fax__c, q.Pickup_Booth_No__c, q.Palletization__c, q.Palletization_Fee__c, q.Pallet_Jack__c, q.OwnerId, q.Origination_Street__c, q.Origination_State__c, q.Origination_Postal_Code__c, q.Origination_Country__c, q.Origination_City__c, q.OB_Weekend_Pickup__c, q.OB_Weekend_Fee__c, q.OB_Weekend_Delivery__c, q.OB_Wait_Time__c, q.OB_Wait_Time_Fee__c, q.OB_Unit_Price__c, q.OB_Total__c, q.OB_Sub_Total__c, q.OB_Shipment_Type__c, q.OB_Service_Type__c, q.OB_Selection__c, q.OB_Round_Trip_Discount__c, q.OB_Residential_Surcharge__c, q.OB_Residential_Pickup__c, q.OB_Pickup_Window_Start__c, q.OB_Pickup_Window_Start_Late__c, q.OB_Pickup_Show_Name__c, q.OB_Pickup_Show_Contractor__c, q.OB_Pickup_Date__c, q.OB_Pickup_Contact_Phone__c, q.OB_Pickup_Contact_Name__c, q.OB_Pickup_Booth_No__c, q.OB_Palletization__c, q.OB_Palletization_Fee__c, q.OB_Pallet_Jack__c, q.OB_Origination_Street__c, q.OB_Origination_State__c, q.OB_Origination_Postal_Code__c, q.OB_Origination_Country__c, q.OB_Origination_City__c, q.OB_Lift_Gate__c, q.OB_Lift_Gate_Surcharge__c, q.OB_Inside_Surcharge__c, q.OB_Inside_Pickup__c, q.OB_Hazardous_Materials__c, q.OB_HM_Contact_Phone__c, q.OB_Fuel_Unit_Surcharge__c, q.OB_Fuel_Surcharge__c, q.OB_Flat_Rate_Unit_Price_Type__c, q.OB_Destination_Street__c, q.OB_Destination_State__c, q.OB_Destination_Postal_Code__c, q.OB_Destination_Country__c, q.OB_Destination_City__c, q.OB_Delivery_Window_Start__c, q.OB_Delivery_Show_Name__c, q.OB_Delivery_Show_Contractor__c, q.OB_Delivery_Destination__c, q.OB_Delivery_Date__c, q.OB_Delivery_Contact_Phone__c, q.OB_Delivery_Contact_Name__c, q.OB_Delivery_Booth_No__c, q.OB_Custom_Quote__c, q.OB_Class_of_Service__c, q.OB_Carrier_Notes__c, q.OB_Call_Before_Pickup__c, q.OB_Call_Before_Delivery__c, q.OB_Attempt__c, q.OB_Attempt_Fee__c, q.OB_Advance_Order_Discount__c, q.OB_Additional_Labor__c, q.OB_Additional_Labor_Fee__c, q.OB_AM_Specified__c, q.OB_AM_Specified_Fee__c, q.Name, q.Lost_Reason__c, q.Lost_Comment__c, q.Lift_Gate__c, q.Lift_Gate_Surcharge__c, q.LastModifiedDate, q.LastModifiedById, q.Job_Code__c, q.IsDeleted, q.Interface_Status__c, q.Interface_Process_Attempts__c, q.Interface_Error_Message__c, q.Interface_Batch_Number__c, q.Inside_Surcharge__c, q.Inside_Pickup__c, q.Id, q.Hazardous_Materials__c, q.HM_Contact_Phone__c, q.Fuel_Unit_Surcharge__c, q.Fuel_Surcharge__c, q.Flat_Rate_Unit_Price_Type__c, q.EDV_Amount__c, q.EDV_Amount_Exceeds_Limit__c, q.Discount_End_Date__c, q.Destination_Street__c, q.Destination_State__c, q.Destination_Postal_Code__c, q.Destination_Country__c, q.Destination_City__c, q.Delivery_Window_Start__c, q.Delivery_Show_Name__c, q.Delivery_Show_Contractor__c, q.Delivery_Destination__c, q.Delivery_Date__c, q.Delivery_Contact_Phone__c, q.Delivery_Contact_Name__c, q.Delivery_Contact_Fax__c, q.Delivery_Booth_No__c, q.Custom_Quote__c, q.CurrencyIsoCode, q.CreatedDate, q.CreatedById, q.Complete_By__c, q.Class_of_Service__c, q.Carrier_Notes__c, q.Call_Before_Pickup__c, q.Call_Before_Delivery__c, q.CORE_Order_Number__c, q.Booth_Number__c, q.Attempt__c, q.Attempt_Fee__c, q.Apply_Round_Trip_Discount__c, q.Advance_Order_Discount__c, q.Additional_Labor__c, q.Additional_Labor_Fee__c, q.AM_Specified__c, q.AM_Specified_Fee__c, q.TOPS_Quote_Number__c From Quote_Staging__c q Where q.Interface_Status__c = \'New\' Limit 200';
        BatchQuotes.query = query;              
        
        ID BatchQuoteId =  Database.executeBatch(BatchQuotes, 200);        
        
        
        test.stopTest();
        
        System.abortJob(BatchQuoteId);
                                  
    }
}