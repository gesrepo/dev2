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
private class TestBatchImportLogisticsFreightItem {

 static testMethod void myUnitTest() {
    // TO DO: implement unit test                              
      

    /*
        Create a stage freight item to test the update logic i.e. freight Item 
        must already exist as a Salesforce.com Account.
                    
        This tests the code block '' for existing
        account.
            
        TODO: This freight item must exist for the unit test to get code coverage.  Therefore,
        prior to deploying this code, create a freight item in production Org or update
        the Freight_Item__c field of any quote to this value in production org.
            
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
    
    
        Freight_Item__C fi = new Freight_Item__C();
    
        //Set fields here - map between staging and freight item objects 
        fi.Width__c = 300.10;          
        fi.Quote__c = quote.Id; 
        fi.Quantity__c = 20000;
        fi.Length__c = 300.52;
        fi.Height__c = 255.36;
        fi.Hazardous_Material__c = true;
        fi.Description__c = 'Sample Freight';
        fi.Crated_Weight__c = 58.9;
    
        Database.insert(fi);
        
        
    
        Freight_Item_Staging__C stgfreightItem = new Freight_Item_Staging__C();
    
        //Set fields here - map between staging and freight item objects 
        stgfreightItem.Width__c = 300.10;          
        stgfreightItem.Quote__c = quote.Id;
        stgfreightItem.freight_item__c = fi.Id;
        stgfreightItem.Quantity__c = 20000;
        stgfreightItem.Length__c = 300.52;
        stgfreightItem.Height__c = 255.36;
        stgfreightItem.Hazardous_Material__c = true;
        stgfreightItem.Description__c = 'Sample Freight';
        stgfreightItem.Crated_Weight__c = 58.9;
    
        Database.insert(stgfreightItem);


        Freight_Item__C fifailed = new Freight_Item__C();
    
        //Set fields here - map between staging and freight item objects 
        fifailed.Width__c = 300.10;          
        fifailed.Quote__c = quote.Id;
        fifailed.Quantity__c = 20000;
        fifailed.Length__c = 300.52;
        fifailed.Height__c = 255.36;
        fifailed.Hazardous_Material__c = true;
        fifailed.Description__c = 'Sample Freight';
        fifailed.Crated_Weight__c = 58.9;
    
        Database.insert(fifailed);
        
        
        
        
        Freight_Item_Staging__C stgfreightItemFailed = new Freight_Item_Staging__C();
    
        //Set fields here - map between staging and freight item objects 
        stgfreightItemFailed.Width__c = 300.10;          
        stgfreightItemFailed.Quote__c = quote.Id;
        stgfreightItemFailed.freight_item__c = fifailed.Id;
        stgfreightItemFailed.Quantity__c = 20000;
        stgfreightItemFailed.Length__c = 0;
        stgfreightItemFailed.Height__c = 255.36;
        stgfreightItemFailed.Hazardous_Material__c = true;
        stgfreightItemFailed.Description__c = 'Sample Freight';
        stgfreightItemFailed.Crated_Weight__c = 58.9;
    
        Database.insert(stgfreightItemFailed); 
        
        
    
        test.StartTest();
                
        // Test Insert of new Freight Items and insert failures
        BatchImportLogisticsFreightItem BatchFreightItems = new BatchImportLogisticsFreightItem();      
        
        String query = 'Select f.freight_item__c, f.Width__c, f.SystemModstamp, f.Quote__c, f.Quantity__c, f.OwnerId, f.Name, f.Length__c, f.LastModifiedDate, f.LastModifiedById, f.LastActivityDate, f.IsDeleted, f.Interface_Status__c, f.Interface_Process_Attempts__c, f.Interface_Error_Message__c, f.Interface_Batch_Number__c, f.Id, f.Height__c, f.Hazardous_Material__c, f.Description__c, f.CurrencyIsoCode, f.CreatedDate, f.CreatedById, f.Crated_Weight__c From Freight_Item_Staging__c f Where f.Interface_Status__c = \'New\' Limit 200';
        BatchFreightItems.query = query;              
        
        ID BatchFreightItemId =  Database.executeBatch(BatchFreightItems, 200); 
        
        // Test Update of existing Freight Item
        //stgfreightItem.Interface_Status__c = 'Failed';
        //stgfreightItem.Height__c = null;
        //Database.update(stgfreightItem);
        
       // BatchFreightItemId = Database.executeBatch(BatchFreightItems, 200);
        
        test.stopTest();
        
        System.abortJob(BatchFreightItemId);
                                  
    }
}