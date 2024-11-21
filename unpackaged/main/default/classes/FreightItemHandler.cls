public class FreightItemHandler {

    public void updateTMSShippingOrderStg(List<Freight_Item__c> listFreightItem, Set<Id> quoteIds){
        List<TMS_Full_Shipping_Order_Stg__c> insertTMSShippingOrderStgRecords = new List<TMS_Full_Shipping_Order_Stg__c>();
        List<TMS_Full_Shipping_Order_Stg__c> updateTMSShippingOrderStgRecords = new List<TMS_Full_Shipping_Order_Stg__c>();
        Set<Id> fiIds = new Set<Id>();
        Map<Id, LIST<TMS_Full_Shipping_Order_Stg__c>> mapFreightItemIdTOShippingOrderStg = new Map<Id, LIST<TMS_Full_Shipping_Order_Stg__c>>();
        
        Map<Id, Quote__c> mapItemIdTOQuote = new Map<Id, Quote__c>([Select Id, Account_Id__c, Account_Id__r.Name, Account_Id__r.Oracle_AR_Cust_Account_Id__c, Account_Id__r.Oracle_AR_Cust_Number__c, Additional_Labor__c, Additional_Labor_Fee__c, Addl_Information__c, 
                                                                    Advance_Order_Discount__c, AGS_Beyond_Point__c, AM_Specified__c, AM_Specified_Fee__c, Apply_Round_Trip_Discount__c, Attempt__c, Attempt_Fee__c, Billing_Contact__c, Billing_Contact__r.Email,
                                                                    Billing_Contact__r.Fax, Billing_Contact__r.FirstName, Billing_Contact__r.LastName, Billing_Contact__r.Phone, Booth__c, Booth_Number__c, Call_Before_Delivery__c, Call_Before_Pickup__c, Carrier_Notes__c, 
                                                                    Class_of_Service__c, Complete_By__c, Copy_to_OB_Destination_Address__c, Copy_To_OB_Pickup_Address__c, CORE_Order_Number__c, Crated_Weight__c, CreatedById, CreatedDate, CurrencyIsoCode, Custom_Quote__c, 
                                                                    Delivery_Booth_No__c, Delivery_Contact_Fax__c, Delivery_Contact_Name__c, Delivery_Contact_Phone__c, Delivery_Date__c, Delivery_Destination__c, Delivery_Show_Contractor__c, Delivery_Show_Name__c, 
                                                                    Delivery_Window_Start__c, Destination_Address__c, Destination_City__c, Destination_Country__c, Destination_Postal_Code__c, Destination_State__c, Destination_Street__c, Dim_Weight__c, Discount_End_Date__c, 
                                                                    EDV_Amount__c, EDV_Amount_Exceeds_Limit__c, Facility__c, Facility__r.LMS_Facility_ID__c, Facility__r.Name, Flat_Rate_Unit_Price_Type__c, Fuel_Surcharge__c, Fuel_Unit_Surcharge__c, Hazardous_Materials__c,
                                                                    HM_Contact_Phone__c, Inside_Pickup__c, Inside_Surcharge__c, Job_Code__c, LastActivityDate, LastModifiedById, LastModifiedDate, Lift_Gate__c, Lift_Gate_Surcharge__c, Lost_Comment__c, Lost_Reason__c,
                                                                    Message__c, Name, OB_Additional_Labor__c, OB_Additional_Labor_Fee__c, OB_Addl_Information__c, OB_Advance_Order_Discount__c, OB_AM_Specified__c, OB_AM_Specified_Fee__c, OB_Attempt__c, OB_Attempt_Fee__c, 
                                                                    OB_Call_Before_Delivery__c, OB_Call_Before_Pickup__c, OB_Carrier_Notes__c, OB_Class_of_Service__c, OB_Custom_Quote__c, OB_Delivery_Booth_No__c, OB_Delivery_Contact_Name__c, OB_Delivery_Contact_Phone__c,
                                                                    OB_Delivery_Date__c, OB_Delivery_Destination__c, OB_Delivery_Show_Contractor__c, OB_Delivery_Show_Name__c, OB_Delivery_Window_Start__c, OB_Destination_Address__c, OB_Destination_City__c, OB_Destination_Country__c, 
                                                                    OB_Destination_Postal_Code__c, OB_Destination_State__c, OB_Destination_Street__c, OB_Facility__c, OB_Facility__r.LMS_Facility_ID__c, OB_Facility__r.Name, OB_Flat_Rate_Unit_Price_Type__c, OB_Fuel_Surcharge__c, 
                                                                    OB_Fuel_Unit_Surcharge__c, OB_Hazardous_Materials__c, OB_HM_Contact_Phone__c, OB_Inside_Pickup__c, OB_Inside_Surcharge__c, OB_Lift_Gate__c, OB_Lift_Gate_Surcharge__c, OB_Origination_City__c, OB_Origination_Country__c, 
                                                                    OB_Origination_Postal_Code__c, OB_Origination_State__c, OB_Origination_Street__c, OB_Pallet_Jack__c, OB_Palletization__c, OB_Palletization_Fee__c, OB_Pickup_Address__c, OB_Pickup_Booth_No__c, OB_Pickup_Contact_Name__c, 
                                                                    OB_Pickup_Contact_Phone__c, OB_Pickup_Date__c, OB_Pickup_Show_Contractor__c, OB_Pickup_Show_Name__c, OB_Pickup_Window_Start__c, OB_Pickup_Window_Start_Late__c, OB_Residential_Pickup__c, OB_Residential_Surcharge__c,
                                                                    OB_Round_Trip_Discount__c, OB_Selection__c, OB_Service_Type__c, OB_Shipment_Type__c, OB_Sub_Total__c, OB_Total__c, OB_Unit_Price__c, OB_Wait_Time__c, OB_Wait_Time_Fee__c, OB_Weekend_Delivery__c, OB_Weekend_Fee__c, 
                                                                    OB_Weekend_Pickup__c, Order_Date__c, Origination_City__c, Origination_Country__c, Origination_Postal_Code__c, Origination_State__c, Origination_Street__c, Owner.FirstName, Owner.LastName, Owner.Name, OwnerId,
                                                                    Pallet_Jack__c, Palletization__c, Palletization_Fee__c, Parent_Quote__c, Parent_Quote__r.Name, Pickup_Address__c, Pickup_Booth_No__c, Pickup_Contact_Fax__c, Pickup_Contact_Name__c, Pickup_Contact_Phone__c, Pickup_Date__c,
                                                                    Pickup_Show_Contractor__c, Pickup_Show_Name__c, Pickup_Window_Start__c, Pickup_Window_Start_Late__c, Project_Number__c, Quote_Inside_Surcharge__c, Quote_Subject__c, Quoted_Total__c, Quoted_Fuel_Surcharge__c,
                                                                    Quoted_Lift_Gate_Surcharge__c, Quoted_Residential_Surcharge__c, RecordType.Name, RecordTypeId, Residential_Pickup__c, Residential_Surcharge__c, Round_Trip_Discount__c, Sales_Rep__c, Sales_Rep__r.FirstName, 
                                                                    Sales_Rep__r.LastName, Selection__c, Service_Type__c, Ship_To_Location__c, Shipment_Type__c, Show__c, Show_Occurrence__c, Show_Occurrence__r.Name, Source__c, Special_Discount_Program__c, Stage__c, Status__c, 
                                                                    Sub_Total__c, Total__c, Type__c, Unit_Price__c, Wait_Time__c, Wait_Time_Fee__c, Weekend_Delivery__c, Weekend_Fee__c, Weekend_Pickup__c, Weight_Override__c, TOPS_Quote_Number__c, Merged_AR_Customer_Number__c,Formula_Merged_AR_Customer_Number__c
                                                                    , Delivery_Contact_Email__c, OB_Delivery_Contact_Email__c, Pickup_Contact_Email__c, OB_Pickup_Contact_Email__c  //AMARAB 2/2/2024 to add emails
                                                                    , Inbound_Stage__c, Outbound_Stage__c, TMS_Inbound_Shipping_Order__c, TMS_Outbound_Shipping_Order__c   //AMARAB 5/21/2024 to add Order # and Stage
                                                                    , Beyond_Point__c, OB_Beyond_Point__c, IN_Beyond_Point_Fee__c, OB_Beyond_Point_Fee__c, NY_City__c, OB_NY_City__c, IN_New_York_City_Fee__c, OB_New_York_City_Fee__c //Amarab 06/28/2024 to add beyond point and ny city fields
                                                                    , Show_Open_Date__c, Show_Close_Date__c, Oracle_Booth_Id__c, Inbound_Owner__c, Outbound_Owner__c //Amarab 09/11/2024 to add booth, Inbound Outbound Owner fields
                                                                    From Quote__c Where Id IN :quoteIds]);
        
        QuoteTriggerHandler quoteTriggerHandler = new QuoteTriggerHandler();
        //if(!Test.isRunningTest())
            quoteTriggerHandler.updateTMSShippingOrderStg(mapItemIdTOQuote.values());
    }  

}