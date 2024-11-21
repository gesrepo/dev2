public class TMSFullShippingOrderTriggerHandler {
    
    public static void updateQuoteANDFreightItems(List<TMS_Full_Shipping_Order_Stg__c> tmsFullShippingOrders){
        
        List<Quote__c> listQuote = new List<Quote__c>();
        List<Freight_Item__c> listFreightItem = new List<Freight_Item__c>();
        
        for(TMS_Full_Shipping_Order_Stg__c tmsShippingOrder : tmsFullShippingOrders){
            if(tmsShippingOrder.Quote_Id__c != null){
                Quote__c quote = updateQuote(tmsShippingOrder.Quote_Id__c, tmsShippingOrder);
                listQuote.add(quote);
            }
            
            if(tmsShippingOrder.FI_Id__c != null){
                Freight_Item__c freightItem = updateFreightItem(tmsShippingOrder);
                listFreightItem.add(freightItem);
            }
        }
        

        Map<id,Quote__c> quoteMap = new Map<id,Quote__c>();
        quoteMap.putall(listQuote);
        if(quoteMap.size()>0){
            update quoteMap.values();
        }
        
        Map<id,Freight_Item__c> fItemMap = new Map<id,Freight_Item__c>();
        fItemMap.putall(listFreightItem);
        if(fItemMap.size()>0){
            update fItemMap.values();
        }
        
    }
    
    public static Quote__c updateQuote(Id quoteId, TMS_Full_Shipping_Order_Stg__c tmsFullShippingOrder){
        Quote__c quote = new Quote__c();
        
        quote.Id = tmsFullShippingOrder.Quote_Id__c;
        quote.Additional_Labor__c = tmsFullShippingOrder.Additional_Labor__c;
        quote.Additional_Labor_Fee__c = tmsFullShippingOrder.Additional_Labor_Fee__c;
        quote.Addl_Information__c = tmsFullShippingOrder.Addl_Information__c;
        quote.Advance_Order_Discount__c = tmsFullShippingOrder.Advance_Order_Discount__c;
        quote.AM_Specified__c = tmsFullShippingOrder.AM_Specified__c;
        quote.AM_Specified_Fee__c = tmsFullShippingOrder.AM_Specified_Fee__c;
        quote.Apply_Round_Trip_Discount__c = tmsFullShippingOrder.Apply_Round_Trip_Discount__c;
        quote.Attempt__c = tmsFullShippingOrder.Attempt__c;
        quote.Attempt_Fee__c = tmsFullShippingOrder.Attempt_Fee__c;

        quote.Booth__c = tmsFullShippingOrder.Booth__c;
        quote.Call_Before_Delivery__c = tmsFullShippingOrder.Call_Before_Delivery__c;
        quote.Call_Before_Pickup__c = tmsFullShippingOrder.Call_Before_Pickup__c;
        quote.Carrier_Notes__c = tmsFullShippingOrder.Carrier_Notes__c;
        quote.Class_of_Service__c = tmsFullShippingOrder.Class_of_Service__c;
        quote.Complete_By__c = tmsFullShippingOrder.Complete_By__c;
        quote.Copy_To_OB_Destination_Address__c = tmsFullShippingOrder.Copy_to_OB_Destination_Address__c;
        quote.Copy_To_OB_Pickup_Address__c = tmsFullShippingOrder.Copy_To_OB_Pickup_Address__c;
        quote.CORE_Order_Number__c = tmsFullShippingOrder.CORE_Order_Number__c;
        quote.Crated_Weight__c = tmsFullShippingOrder.Crated_Weight__c;
        quote.CurrencyIsoCode = tmsFullShippingOrder.Quote_CurrencyIsoCode__c;
        quote.Custom_Quote__c = tmsFullShippingOrder.Custom_Quote__c;
        quote.Delivery_Booth_No__c = tmsFullShippingOrder.Delivery_Booth_No__c;
        quote.Delivery_Contact_Fax__c = tmsFullShippingOrder.Delivery_Contact_Fax__c;
        quote.Delivery_Contact_Name__c = tmsFullShippingOrder.Delivery_Contact_Name__c;
        quote.Delivery_Contact_Phone__c = tmsFullShippingOrder.Delivery_Contact_Phone__c;
        quote.Delivery_Date__c = tmsFullShippingOrder.Delivery_Date__c;
        quote.Delivery_Destination__c = tmsFullShippingOrder.Delivery_Destination__c;
        quote.Delivery_Show_Contractor__c = tmsFullShippingOrder.Delivery_Show_Contractor__c;
        quote.Delivery_Show_Name__c = tmsFullShippingOrder.Delivery_Show_Name__c;
        quote.Delivery_Window_Start__c = tmsFullShippingOrder.Delivery_Window_Start__c;
        quote.Destination_Address__c = tmsFullShippingOrder.Destination_Address__c;
        quote.Destination_City__c = tmsFullShippingOrder.Destination_City__c;
        quote.Destination_Country__c = tmsFullShippingOrder.Destination_Country__c;
        quote.Destination_Postal_Code__c = tmsFullShippingOrder.Destination_Postal_Code__c;
        quote.Destination_State__c = tmsFullShippingOrder.Destination_State__c;
        quote.Destination_Street__c = tmsFullShippingOrder.Destination_Street__c;
        quote.Dim_Weight__c = tmsFullShippingOrder.Dim_Weight__c;
        quote.EDV_Amount__c = tmsFullShippingOrder.EDV_Amount__c;
        quote.EDV_Amount_Exceeds_Limit__c = tmsFullShippingOrder.EDV_Amount_Exceeds_Limit__c;
        
        quote.Flat_Rate_Unit_Price_Type__c = tmsFullShippingOrder.Flat_Rate_Unit_Price_Type__c;
        quote.Fuel_Surcharge__c = tmsFullShippingOrder.Fuel_Surcharge__c;
        quote.Fuel_Unit_Surcharge__c = tmsFullShippingOrder.Fuel_Unit_Surcharge__c;
        quote.Hazardous_Materials__c = tmsFullShippingOrder.Hazardous_Material__c;
        quote.HM_Contact_Phone__c = tmsFullShippingOrder.HM_Contact_Phone__c;
        quote.Inside_Pickup__c = tmsFullShippingOrder.Inside_Pickup__c;
        quote.Inside_Surcharge__c = tmsFullShippingOrder.Inside_Surcharge__c;
        quote.Job_Code__c = tmsFullShippingOrder.Job_Code__c;
        quote.Lift_Gate__c = tmsFullShippingOrder.Lift_Gate__c;
        quote.Lift_Gate_Surcharge__c = tmsFullShippingOrder.Lift_Gate_Surcharge__c;
        quote.Lost_Comment__c = tmsFullShippingOrder.Lost_Comment__c;
        quote.Lost_Reason__c = tmsFullShippingOrder.Lost_Reason__c;
        quote.Message__c = tmsFullShippingOrder.Message__c;
        quote.OB_Additional_Labor__c = tmsFullShippingOrder.OB_Additional_Labor__c;
        quote.OB_Additional_Labor_Fee__c = tmsFullShippingOrder.OB_Additional_Labor_Fee__c;
        quote.OB_Addl_Information__c = tmsFullShippingOrder.OB_Addl_Information__c;
        quote.OB_Advance_Order_Discount__c = tmsFullShippingOrder.OB_Advance_Order_Discount__c;
        quote.OB_AM_Specified__c = tmsFullShippingOrder.OB_AM_Specified__c;
        quote.OB_AM_Specified_Fee__c = tmsFullShippingOrder.OB_AM_Specified_Fee__c;
        quote.OB_Attempt__c = tmsFullShippingOrder.OB_Attempt__c;
        quote.OB_Attempt_Fee__c = tmsFullShippingOrder.OB_Attempt_Fee__c;
        quote.OB_Call_Before_Delivery__c = tmsFullShippingOrder.OB_Call_Before_Delivery__c;
        quote.OB_Call_Before_Pickup__c = tmsFullShippingOrder.OB_Call_Before_Pickup__c;
        quote.OB_Carrier_Notes__c = tmsFullShippingOrder.OB_Carrier_Notes__c;
        quote.OB_Class_of_Service__c = tmsFullShippingOrder.OB_Class_of_Service__c;
        quote.OB_Custom_Quote__c = tmsFullShippingOrder.OB_Custom_Quote__c;
        quote.OB_Delivery_Booth_No__c = tmsFullShippingOrder.OB_Delivery_Booth_No__c;
        quote.OB_Delivery_Contact_Name__c = tmsFullShippingOrder.OB_Delivery_Contact_Name__c;
        quote.OB_Delivery_Contact_Phone__c = tmsFullShippingOrder.OB_Delivery_Contact_Phone__c;
        quote.OB_Delivery_Date__c = tmsFullShippingOrder.OB_Delivery_Date__c;
        quote.OB_Delivery_Destination__c = tmsFullShippingOrder.OB_Delivery_Destination__c;
        quote.OB_Delivery_Show_Contractor__c = tmsFullShippingOrder.OB_Delivery_Show_Contractor__c;
        quote.OB_Delivery_Show_Name__c = tmsFullShippingOrder.OB_Delivery_Show_Name__c;
        quote.OB_Delivery_Window_Start__c = tmsFullShippingOrder.OB_Delivery_Window_Start__c;
        quote.OB_Destination_Address__c = tmsFullShippingOrder.OB_Destination_Address__c;
        quote.OB_Destination_City__c = tmsFullShippingOrder.OB_Destination_City__c;
        quote.OB_Destination_Country__c = tmsFullShippingOrder.OB_Destination_Country__c;
        quote.OB_Destination_Postal_Code__c = tmsFullShippingOrder.OB_Destination_Postal_Code__c;
        quote.OB_Destination_State__c = tmsFullShippingOrder.OB_Destination_State__c;
        quote.OB_Destination_Street__c = tmsFullShippingOrder.OB_Destination_Street__c;
        quote.OB_Flat_Rate_Unit_Price_Type__c = tmsFullShippingOrder.OB_Flat_Rate_Unit_Price_Type__c;
        quote.OB_Fuel_Surcharge__c = tmsFullShippingOrder.OB_Fuel_Surcharge__c;
        quote.OB_Fuel_Unit_Surcharge__c = tmsFullShippingOrder.OB_Fuel_Unit_Surcharge__c;
        quote.OB_Hazardous_Materials__c = tmsFullShippingOrder.OB_Hazardous_Materials__c;
        quote.OB_HM_Contact_Phone__c = tmsFullShippingOrder.OB_HM_Contact_Phone__c;
        quote.OB_Inside_Pickup__c = tmsFullShippingOrder.OB_Inside_Pickup__c;
        quote.OB_Inside_Surcharge__c = tmsFullShippingOrder.OB_Inside_Surcharge__c;
        quote.OB_Lift_Gate__c = tmsFullShippingOrder.OB_Lift_Gate__c;
        quote.OB_Lift_Gate_Surcharge__c = tmsFullShippingOrder.OB_Lift_Gate_Surcharge__c;
        quote.OB_Origination_City__c = tmsFullShippingOrder.OB_Origination_City__c;
        quote.OB_Origination_Country__c = tmsFullShippingOrder.OB_Origination_Country__c;
        quote.OB_Origination_Postal_Code__c = tmsFullShippingOrder.OB_Origination_Postal_Code__c;
        quote.OB_Origination_State__c = tmsFullShippingOrder.OB_Origination_State__c;
        quote.OB_Origination_Street__c = tmsFullShippingOrder.OB_Origination_Street__c;
        quote.OB_Pallet_Jack__c = tmsFullShippingOrder.OB_Pallet_Jack__c;
        quote.OB_Palletization__c = tmsFullShippingOrder.OB_Palletization__c;
        quote.OB_Palletization_Fee__c = tmsFullShippingOrder.OB_Palletization_Fee__c;
        quote.OB_Pickup_Address__c = tmsFullShippingOrder.OB_Pickup_Address__c;
        quote.OB_Pickup_Booth_No__c = tmsFullShippingOrder.OB_Pickup_Booth_No__c;
        quote.OB_Pickup_Contact_Name__c = tmsFullShippingOrder.OB_Pickup_Contact_Name__c;
        quote.OB_Pickup_Contact_Phone__c = tmsFullShippingOrder.OB_Pickup_Contact_Phone__c;
        quote.OB_Pickup_Date__c = tmsFullShippingOrder.OB_Pickup_Date__c;
        quote.OB_Pickup_Show_Contractor__c = tmsFullShippingOrder.OB_Pickup_Show_Contractor__c;
        quote.OB_Pickup_Show_Name__c = tmsFullShippingOrder.OB_Pickup_Show_Name__c;
        quote.OB_Pickup_Window_Start__c = tmsFullShippingOrder.OB_Pickup_Window_Start__c;
        quote.OB_Pickup_Window_Start_Late__c = tmsFullShippingOrder.OB_Pickup_Window_Start_Late__c;
        quote.OB_Residential_Pickup__c = tmsFullShippingOrder.OB_Residential_Pickup__c;
        quote.OB_Residential_Surcharge__c = tmsFullShippingOrder.OB_Residential_Surcharge__c;
        quote.OB_Round_Trip_Discount__c = tmsFullShippingOrder.OB_Round_Trip_Discount__c;
        quote.OB_Selection__c = tmsFullShippingOrder.OB_Selection__c;
        quote.OB_Service_Type__c = tmsFullShippingOrder.OB_Service_Type__c;
        quote.OB_Shipment_Type__c = tmsFullShippingOrder.OB_Shipment_Type__c;
        quote.OB_Sub_Total__c = tmsFullShippingOrder.OB_Sub_Total__c;
        quote.OB_Total__c = tmsFullShippingOrder.OB_Total__c;
        quote.OB_Unit_Price__c = tmsFullShippingOrder.OB_Unit_Price__c;
        quote.OB_Wait_Time__c = tmsFullShippingOrder.OB_Wait_Time__c;
        quote.OB_Wait_Time_Fee__c = tmsFullShippingOrder.OB_Wait_Time_Fee__c;
        quote.OB_Weekend_Delivery__c = tmsFullShippingOrder.OB_Weekend_Delivery__c;
        quote.OB_Weekend_Fee__c = tmsFullShippingOrder.OB_Weekend_Fee__c;
        quote.OB_Weekend_Pickup__c = tmsFullShippingOrder.OB_Weekend_Pickup__c;
        quote.Order_Date__c = tmsFullShippingOrder.Order_Date__c;
        quote.Origination_City__c = tmsFullShippingOrder.Origination_City__c;
        quote.Origination_Country__c = tmsFullShippingOrder.Origination_Country__c;
        quote.Origination_Postal_Code__c = tmsFullShippingOrder.Origination_Postal_Code__c;
        quote.Origination_State__c = tmsFullShippingOrder.Origination_State__c;
        quote.Origination_Street__c = tmsFullShippingOrder.Origination_Street__c;
        quote.Pallet_Jack__c = tmsFullShippingOrder.Pallet_Jack__c;
        quote.Palletization__c = tmsFullShippingOrder.Palletization__c;
        quote.Palletization_Fee__c = tmsFullShippingOrder.Palletization_Fee__c;
        quote.Pickup_Address__c = tmsFullShippingOrder.Pickup_Address__c;
        quote.Pickup_Booth_No__c = tmsFullShippingOrder.Pickup_Booth_No__c;
        quote.Pickup_Contact_Fax__c = tmsFullShippingOrder.Pickup_Contact_Fax__c;
        quote.Pickup_Contact_Name__c = tmsFullShippingOrder.Pickup_Contact_Name__c;
        quote.Pickup_Contact_Phone__c = tmsFullShippingOrder.Pickup_Contact_Phone__c;
        quote.Pickup_Date__c = tmsFullShippingOrder.Pickup_Date__c;
        quote.Pickup_Show_Contractor__c = tmsFullShippingOrder.Pickup_Show_Contractor__c;
        quote.Pickup_Show_Name__c = tmsFullShippingOrder.Pickup_Show_Name__c;
        quote.Pickup_Window_Start__c = tmsFullShippingOrder.Pickup_Window_Start__c;
        quote.Pickup_Window_Start_Late__c = tmsFullShippingOrder.Pickup_Window_Start_Late__c;
        quote.Quote_Inside_Surcharge__c = tmsFullShippingOrder.Quote_Inside_Surcharge__c;
        quote.Quote_Subject__c = tmsFullShippingOrder.Quote_Subject__c;
        quote.Quoted_Fuel_Surcharge__c = tmsFullShippingOrder.Quoted_Fuel_Surcharge__c;
        quote.Quoted_Lift_Gate_Surcharge__c = tmsFullShippingOrder.Quoted_Lift_Gate_Surcharge__c;
        quote.Quoted_Residential_Surcharge__c = tmsFullShippingOrder.Quoted_Residential_Surcharge__c;
        quote.Quoted_Total__c = tmsFullShippingOrder.Quoted_Total__c;
        quote.RecordTypeId = tmsFullShippingOrder.Quote_RecordTypeId__c;
        quote.Residential_Pickup__c = tmsFullShippingOrder.Residential_Pickup__c;
        quote.Residential_Surcharge__c = tmsFullShippingOrder.Residential_Surcharge__c;
        quote.Round_Trip_Discount__c = tmsFullShippingOrder.Round_Trip_Discount__c;
        quote.Selection__c = tmsFullShippingOrder.Selection__c;
        quote.Service_Type__c = tmsFullShippingOrder.Service_Type__c;
        quote.Ship_To_Location__c = tmsFullShippingOrder.Ship_To_Location__c;
        quote.Shipment_Type__c = tmsFullShippingOrder.Shipment_Type__c;
        quote.Source__c = tmsFullShippingOrder.Source__c;
        quote.Special_Discount_Program__c = tmsFullShippingOrder.Special_Discount_Program__c;
        quote.Stage__c = tmsFullShippingOrder.Stage__c;
        quote.Status__c = tmsFullShippingOrder.Status__c;
        quote.Sub_Total__c = tmsFullShippingOrder.Sub_Total__c;
        quote.Total__c = tmsFullShippingOrder.Total__c;
        quote.Type__c = tmsFullShippingOrder.Type__c;
        quote.Unit_Price__c = tmsFullShippingOrder.Unit_Price__c;
        quote.Wait_Time__c = tmsFullShippingOrder.Wait_Time__c;
        quote.Wait_Time_Fee__c = tmsFullShippingOrder.Wait_Time_Fee__c;
        quote.Weekend_Delivery__c = tmsFullShippingOrder.Weekend_Delivery__c;
        quote.Weekend_Fee__c = tmsFullShippingOrder.Weekend_Fee__c;
        quote.Weekend_Pickup__c = tmsFullShippingOrder.Weekend_Pickup__c;
        quote.Weight_Override__c = tmsFullShippingOrder.Weight_Override__c;
        quote.TOPS_Quote_Number__c = tmsFullShippingOrder.TOPS_Quote_Number__c;
        //AMARAB 2/2/2024 to add emails
        quote.Delivery_Contact_Email__c = tmsFullShippingOrder.Delivery_Contact_Email__c;
        quote.OB_Delivery_Contact_Email__c = tmsFullShippingOrder.OB_Delivery_Contact_Email__c;
        quote.OB_Pickup_Contact_Email__c = tmsFullShippingOrder.OB_Pickup_Contact_Email__c;
        quote.Pickup_Contact_Email__c = tmsFullShippingOrder.Pickup_Contact_Email__c;
        //AMARAB 5/21/2024 to add Order # and Stage
        quote.Inbound_Stage__c = tmsFullShippingOrder.Inbound_Stage__c;
        quote.Outbound_Stage__c = tmsFullShippingOrder.Outbound_Stage__c;
        quote.TMS_Inbound_Shipping_Order__c = tmsFullShippingOrder.TMS_Inbound_Shipping_Order__c;
        quote.TMS_Outbound_Shipping_Order__c = tmsFullShippingOrder.TMS_Outbound_Shipping_Order__c;
        //Amarab 06/28/2024 to add beyond point and ny city fields
        quote.Beyond_Point__c = tmsFullShippingOrder.Beyond_Point__c;
        quote.OB_Beyond_Point__c = tmsFullShippingOrder.OB_Beyond_Point__c; 
        quote.IN_Beyond_Point_Fee__c = tmsFullShippingOrder.IN_Beyond_Point_Fee__c; 
        quote.OB_Beyond_Point_Fee__c = tmsFullShippingOrder.OB_Beyond_Point_Fee__c;
        quote.NY_City__c = tmsFullShippingOrder.NY_City__c;
        quote.OB_NY_City__c = tmsFullShippingOrder.OB_NY_City__c;
        quote.IN_New_York_City_Fee__c = tmsFullShippingOrder.IN_New_York_City_Fee__c; 
        quote.OB_New_York_City_Fee__c = tmsFullShippingOrder.OB_New_York_City_Fee__c; 

        return quote;
    }
    
    public static Freight_Item__c updateFreightItem(TMS_Full_Shipping_Order_Stg__c tmsFullShippingOrder){
        Freight_Item__c freightItem = new Freight_Item__c();
        freightItem.Id = tmsFullShippingOrder.FI_Id__c;
        freightItem.Crated_Weight__c = tmsFullShippingOrder.FI_Crated_Weight__c;
        freightItem.CurrencyIsoCode = tmsFullShippingOrder.FI_CurrencyIsoCode__c;
        freightItem.Description__c = tmsFullShippingOrder.Description__c;
        freightItem.Hazardous_Material__c = tmsFullShippingOrder.Hazardous_Material__c;
        freightItem.Height__c = tmsFullShippingOrder.Height__c;
        freightItem.Length__c = tmsFullShippingOrder.Length__c;
        freightItem.Line_Number__c = tmsFullShippingOrder.Line_Number__c;
        freightItem.Quantity__c = tmsFullShippingOrder.Quantity__c;
        freightItem.Width__c = tmsFullShippingOrder.Width__c;
        freightItem.Void__c = tmsFullShippingOrder.Void__c;
        
        return freightItem;
    }
    
}