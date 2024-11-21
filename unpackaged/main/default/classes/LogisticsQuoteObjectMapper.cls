global with sharing class LogisticsQuoteObjectMapper {
    
    public static string certificate = '';
    public static string password = '';
    public static string QuoteSelectQuery = 'Select q.Account_Id__c, q.Additional_Labor__c, q.Additional_Labor_Fee__c, q.Addl_Information__c, q.Advance_Order_Discount__c, q.AGS_Beyond_Point__c, q.AM_Specified__c, q.AM_Specified_Fee__c, q.Apply_Round_Trip_Discount__c, q.Attempt__c, q.Attempt_Fee__c, q.Billing_Contact__c, q.Booth__c, q.Booth_Number__c, q.Call_Before_Delivery__c, q.Call_Before_Pickup__c, q.Carrier_Notes__c, q.Class_of_Service__c, q.Complete_By__c, q.CORE_Order_Number__c, q.Crated_Weight__c, q.CreatedById, q.CreatedDate, q.CurrencyIsoCode, q.Custom_Quote__c, q.Delivery_Booth_No__c, q.Delivery_Contact_Fax__c, q.Delivery_Contact_Name__c, q.Delivery_Contact_Phone__c, q.Delivery_Date__c, q.Delivery_Destination__c, q.Delivery_Show_Contractor__c, q.Delivery_Show_Name__c, q.Delivery_Window_Start__c, q.Destination_Address__c, q.Destination_City__c, q.Destination_Country__c, q.Destination_Postal_Code__c, q.Destination_State__c, q.Destination_Street__c, q.Dim_Weight__c, q.Discount_End_Date__c, q.EDV_Amount__c, q.EDV_Amount_Exceeds_Limit__c, q.Flat_Rate_Unit_Price_Type__c, q.Fuel_Surcharge__c, q.Fuel_Unit_Surcharge__c, q.Hazardous_Materials__c, q.HM_Contact_Phone__c, q.Id, q.Inside_Pickup__c, q.Inside_Surcharge__c, q.IsDeleted, q.Job_Code__c, q.LastActivityDate, q.LastModifiedById, q.LastModifiedDate, q.Lift_Gate__c, q.Lift_Gate_Surcharge__c, q.Message__c, q.Name, q.OB_Additional_Labor__c, q.OB_Additional_Labor_Fee__c, q.OB_Addl_Information__c, q.OB_Advance_Order_Discount__c, q.OB_AM_Specified__c, q.OB_AM_Specified_Fee__c, q.OB_Attempt__c, q.OB_Attempt_Fee__c, q.OB_Call_Before_Delivery__c, q.OB_Call_Before_Pickup__c, q.OB_Carrier_Notes__c, q.OB_Class_of_Service__c, q.OB_Custom_Quote__c, q.OB_Delivery_Booth_No__c, q.OB_Delivery_Contact_Name__c, q.OB_Delivery_Contact_Phone__c, q.OB_Delivery_Date__c, q.OB_Delivery_Destination__c, q.OB_Delivery_Show_Contractor__c, q.OB_Delivery_Show_Name__c, q.OB_Delivery_Window_Start__c, q.OB_Destination_Address__c, q.OB_Destination_City__c, q.OB_Destination_Country__c, q.OB_Destination_Postal_Code__c, q.OB_Destination_State__c, q.OB_Destination_Street__c, q.OB_Flat_Rate_Unit_Price_Type__c, q.OB_Fuel_Surcharge__c, q.OB_Fuel_Unit_Surcharge__c, q.OB_Hazardous_Materials__c, q.OB_HM_Contact_Phone__c, q.OB_Inside_Pickup__c, q.OB_Inside_Surcharge__c, q.OB_Lift_Gate__c, q.OB_Lift_Gate_Surcharge__c, q.OB_Origination_City__c, q.OB_Origination_Country__c, q.OB_Origination_Postal_Code__c, q.OB_Origination_State__c, q.OB_Origination_Street__c, q.OB_Pallet_Jack__c, q.OB_Palletization__c, q.OB_Palletization_Fee__c, q.OB_Pickup_Address__c, q.OB_Pickup_Booth_No__c, q.OB_Pickup_Contact_Name__c, q.OB_Pickup_Contact_Phone__c, q.OB_Pickup_Date__c, q.OB_Pickup_Show_Contractor__c, q.OB_Pickup_Show_Name__c, q.OB_Pickup_Window_Start__c, q.OB_Pickup_Window_Start_Late__c, q.OB_Residential_Pickup__c, q.OB_Residential_Surcharge__c, q.OB_Round_Trip_Discount__c, q.OB_Selection__c, q.OB_Service_Type__c, q.OB_Shipment_Type__c, q.OB_Sub_Total__c, q.OB_Total__c, q.OB_Unit_Price__c, q.OB_Wait_Time__c, q.OB_Wait_Time_Fee__c, q.OB_Weekend_Delivery__c, q.OB_Weekend_Fee__c, q.OB_Weekend_Pickup__c, q.Order_Date__c, q.Origination_City__c, q.Origination_Country__c, q.Origination_Postal_Code__c, q.Origination_State__c, q.Origination_Street__c, q.OwnerId, q.Pallet_Jack__c, q.Palletization__c, q.Palletization_Fee__c, q.Pickup_Address__c, q.Pickup_Booth_No__c, q.Pickup_Contact_Fax__c, q.Pickup_Contact_Name__c, q.Pickup_Contact_Phone__c, q.Pickup_Date__c, q.Pickup_Show_Contractor__c, q.Pickup_Show_Name__c, q.Pickup_Window_Start__c, q.Pickup_Window_Start_Late__c, q.Project_Number__c, q.Quote_Inside_Surcharge__c, q.Quote_Subject__c, q.Quoted_Fuel_Surcharge__c, q.Quoted_Lift_Gate_Surcharge__c, q.Quoted_Residential_Surcharge__c, q.Quoted_Total__c, q.RecordTypeId, q.Residential_Pickup__c, q.Residential_Surcharge__c, q.Round_Trip_Discount__c, q.Sales_Rep__c, q.Selection__c, q.Service_Type__c, q.Ship_To_Location__c, q.Shipment_Type__c, q.Show__c, q.Show_Occurrence__c, q.Source__c, q.Stage__c, q.Status__c, q.Sub_Total__c, q.SystemModstamp, q.Total__c, q.Type__c, q.Unit_Price__c, q.Wait_Time__c, q.Wait_Time_Fee__c, q.Weekend_Delivery__c, q.Weekend_Fee__c, q.Weekend_Pickup__c, q.Weight_Override__c, q.Account_Id__r.GES_Master_Customer_Number__c, q.Account_Id__r.Name, q.Billing_Contact__r.Email, q.Billing_Contact__r.Fax, q.Billing_Contact__r.Name, q.Billing_Contact__r.Phone, q.Owner.Name From Quote__c q ';
    public static string FreightItemSelectQuery = 'Select f.Crated_Weight__c, f.Description__c, f.Hazardous_Material__c, f.Height__c, f.Id, f.Length__c, f.Quantity__c, f.Width__c  From Freight_Item__c f';
    
    public static string currencyToString(decimal N)
    {
        return N.setScale(2).toPlainString();
    }
    
    public static Quote__c getQuote(id quoteId)
    {
        return Database.query(QuoteSelectQuery + 'Where q.Id = \'' + quoteId + '\'');
    }
    
    public static Freight_Item__c[] getFreightItems(id quoteId)
    {
        return Database.query(FreightItemSelectQuery + ' Where f.Void__c = false And f.Quote__c = \'' + quoteId + '\'');
    }
    
    public static boolean mapInboundQuoteToExternalQuote(Quote__c q, Freight_Item__c[] arrFI, LogisticsQuoteReportService.ExternalQuote exQ, LogisticsQuoteReportService.ArrayOfExternalQuoteLine arrExQLines)
    {
        Boolean RetVal = true;
        
        exQ.DatePrepared = Datetime.now().format('dd-MMM-yyyy');
        
        //Unit test fails because the "Name" field is not populated or is null
        //when unit test is run.
            
        if (q.Name != null && q.Name != '')
            exQ.QuoteNumber = String.valueOf(long.valueOf(q.Name));
        else
            exQ.QuoteNumber = '';
            
        exQ.Owner = q.Owner.Name;
        exQ.ExhibitorName = q.Account_Id__r.Name;
        exQ.CompanyName = q.Account_Id__r.Name;
        exQ.CompanyNumber = q.Account_Id__r.GES_Master_Customer_Number__c;        
        exQ.JobCode = q.Job_Code__c;
        exQ.ProjectNumber = q.Project_Number__c;
        exQ.BillingContactName = q.Billing_Contact__r.Name;
        exQ.BillingContactEmail = q.Billing_Contact__r.Email;
        exQ.BillingContactPhone = q.Billing_Contact__r.Phone;
        exQ.BillingContactFax = q.Billing_Contact__r.Fax;
        
        //Pickup Information
        exQ.OriginationStreetAddress = q.Origination_Street__c;
        exQ.OriginationCity = q.Origination_City__c;
        exQ.OriginationState = q.Origination_State__c;
        exQ.OriginationPostalCode = q.Origination_Postal_Code__c;                        
        exQ.OriginationCountry = q.Origination_Country__c;  
        exQ.PickupShowName = q.Pickup_Show_Name__c;
        exQ.PickupBoothNumber = q.Pickup_Booth_No__c;
        exQ.PickupShowContractor = q.Pickup_Show_Contractor__c;
        
        exQ.PickupContactName = q.Pickup_Contact_Name__c;
        exQ.PickupContactPhone = q.Pickup_Contact_Phone__c;
        
        exQ.PickupDate = q.Pickup_Date__c;
        
        string PickupWindow = '';
        
        if (q.Pickup_Window_Start__c != null && q.Pickup_Window_Start__c != 'None')
        {
            Integer PickupWindowEndTime = Integer.valueOf(q.Pickup_Window_Start__c.split(':')[0]) + 4;
            
            if (PickupWindowEndTime <= 9)
                exQ.PickupWindow = q.Pickup_Window_Start__c + ' - ' + '0' + String.valueOf(PickupWindowEndTime) + ':00';
            else
                exQ.PickupWindow = q.Pickup_Window_Start__c + ' - ' + String.valueOf(PickupWindowEndTime) + ':00';              
        } 

        //Delivery Information
        exQ.DeliveryDestination = q.Delivery_Destination__c;
        
        exQ.DeliveryStreetAddress = q.Destination_Street__c;
        exQ.DeliveryCity = q.Destination_City__c;
        exQ.DeliveryState = q.Destination_State__c;
        exQ.DeliveryPostalCode = q.Destination_Postal_Code__c;                        
        
        exQ.DeliveryCountry = q.Destination_Country__c;  
        
        exQ.DeliveryShowName = q.Delivery_Show_Name__c;
        exQ.DeliveryBoothNumber = q.Delivery_Booth_No__c;
        
        exQ.DeliveryShowContractor = q.Delivery_Show_Contractor__c;
        exQ.DeliveryContactName = q.Delivery_Contact_Name__c;
        exQ.DeliveryContactPhone = q.Delivery_Contact_Phone__c;
        exQ.DeliveryDate = q.Delivery_Date__c;
        
        if (q.Delivery_Window_Start__c != null && q.Delivery_Window_Start__c != 'None')
        {
            Integer DeliveryWindowEndTime = Integer.valueOf(q.Delivery_Window_Start__c.split(':')[0]) + 4;
            
            if (DeliveryWindowEndTime <= 9)
                exQ.DeliveryWindow = q.Delivery_Window_Start__c + ' - ' + '0' + String.valueOf(DeliveryWindowEndTime) + ':00';
            else
                exQ.DeliveryWindow = q.Delivery_Window_Start__c + ' - ' + String.valueOf(DeliveryWindowEndTime) + ':00';                
        } 
        
        // Options
        if (q.Shipment_Type__c == 'Air Transportation')
        {
            if (q.Class_of_Service__c == 'Next Day')
                exQ.AirNextDay = 'X';
            else if (q.Class_of_Service__c == '2nd Day')
                exQ.AirSecondDay = 'X';
        }
        
        if (q.Shipment_Type__c == 'Ground Transportation')
        {
            exQ.Ground = 'X';
            
            if (q.Service_Type__c == 'LTL')
                exQ.LTL = 'X';
            else if (q.Service_Type__c == 'FTL')
                exQ.Truckload = 'X';
        }

        exQ.Inbound = 'X';
        
        if (q.Quote_Subject__c.toUpperCase() == 'ROUNDTRIP')
            exQ.RoundTrip = 'X';
                            
        // TODO: Figure out if separate custom quote fields are required, one for 
        // inbound and another for outbound
        exQ.CustomQuote = (q.Custom_Quote__c ? 'X' : '');
        
        exQ.SpecialInsideService = (q.Inside_Pickup__c ? 'X' : '');
        exQ.SpecialLiftGate = (q.Lift_Gate__c ? 'X' : '');
        exQ.SpecialPalletJack = (q.Pallet_Jack__c ? 'X' : '');       
        exQ.SpecialResidential = (q.Residential_Pickup__c ? 'X' : '');
        
        // For Inbound, Call Before Flag in the report needs to be the Quote's 
        // Call Before Pickup field. Report display InstructionsCallBeforePickup
        // field.
        exQ.InstructionsCallBeforePickup = (q.Call_Before_Pickup__c ? 'Y' : '');
        exQ.InstructionsCallBeforeDelivery = (q.Call_Before_Delivery__c ? 'Y' : '');
        
        exQ.InstructionsWeekendPickup = (q.Weekend_Pickup__c ? 'X' : '');          
        exQ.InstructionsWeekendDelivery = (q.Weekend_Delivery__c ? 'X' : '');      
        exQ.SpecialHazardousMaterials = (q.Hazardous_Materials__c ? 'X' : '');
        exQ.SpecialAdditionalLabor = (q.Additional_Labor__c ? 'X' : '');
        exQ.SpecialAMSpecified = (q.AM_Specified__c ? 'X' : '');
        exQ.SpecialPalletization = (q.Palletization__c ? 'X' : '');
        
        if (q.Additional_Labor__c || q.AM_Specified__c || q.Palletization__c
            || q.Call_Before_Pickup__c || q.Call_Before_Delivery__c || q.Lift_Gate__c
            || q.Hazardous_Materials__c || q.Pallet_Jack__c || q.Inside_Pickup__c
            || q.Residential_Pickup__c || q.Weekend_Pickup__c || q.Weekend_Delivery__c)
        {
            exQ.CarrierNotes = 'Please see accessorial callout.' + (q.Carrier_Notes__c != '' && q.Carrier_Notes__c != null ? ' ' + q.Carrier_Notes__c : '');
        }
        else
        {
            exQ.CarrierNotes = q.Carrier_Notes__c;
        }
        
        if (q.EDV_Amount__c != null)
            exQ.DeclaredValue = q.EDV_Amount__c.setScale(2);
        else
            exQ.DeclaredValue = 0;
            
        exQ.DeclaredValueCheck =  (q.EDV_Amount__c != null && q.EDV_Amount__c > 0 ? 'X' : '');
        
        exQ.UnitPrice = q.Unit_Price__c;
        
        exQ.FuelSurcharge = q.Fuel_Surcharge__c;
        exQ.InsideSurcharge = q.Inside_Surcharge__c;
        exQ.LiftGateSurcharge = q.Lift_Gate_Surcharge__c;
        exQ.ResidentialSurcharge = q.Residential_Surcharge__c;
        exQ.AMSpecifiedFee = q.AM_Specified_Fee__c;
        exQ.WeekendFee = q.Weekend_Fee__c;
        exQ.WaitTimeFee = (q.Wait_Time__c ? q.Wait_Time_Fee__c : 0);
        exQ.AdditionalLaborFee = (q.Additional_Labor__c ? q.Additional_Labor_Fee__c : 0);
        exQ.PalletizationFee = (q.Palletization__c ? q.Palletization_Fee__c : 0);
        exQ.AttemptFee = (q.Attempt__c ? q.Attempt_Fee__c : 0);
        exQ.SubTotal = q.Sub_Total__c;
        exQ.Total = q.Total__c;
        
        exQ.AdvanceOrderDiscountPercent = q.Advance_Order_Discount__c;
        exQ.RoundtripDiscountPercent = q.Round_Trip_Discount__c;

        exQ.HMContactNumber = q.HM_Contact_Phone__c;        
               
        LogisticsQuoteReportService.ExternalQuoteLine[] QuoteLines = new LogisticsQuoteReportService.ExternalQuoteLine[]{};       
        
        integer TotalPieces = 0;
        
        for(Freight_Item__c fi : arrFI)
        {  
            LogisticsQuoteReportService.ExternalQuoteLine QuoteLine = new LogisticsQuoteReportService.ExternalQuoteLine();      
            QuoteLine.Length = (fi.Length__c ==  null ? 0 : fi.Length__c.intValue());
            QuoteLine.Width = (fi.Width__c ==  null ? 0 : fi.Width__c.intValue());
            QuoteLine.Height = (fi.Height__c ==  null ? 0 : fi.Height__c.intValue());
            QuoteLine.Description = fi.Description__c;
            QuoteLine.HazardousMaterial = (fi.Hazardous_Material__c ? 'X' : '');
            QuoteLine.Quantity = (fi.Quantity__c == null ? 0 : fi.Quantity__c.intValue());
            
            QuoteLine.Weight = fi.Crated_Weight__c;
            
            TotalPieces += QuoteLine.Quantity;
                     
            QuoteLines.add(QuoteLine);
        }
        
        exQ.ItemCount = TotalPieces;
        
        String Mode = '';
        
        if (q.Shipment_Type__c != null && q.Shipment_Type__c.toUpperCase() == 'AIR TRANSPORTATION')
            Mode = 'AIR';
        else
            Mode = 'Ground or Local';
        
        exQ.TotalWeight = LogisticsCommon.GetWeight(q, Mode);        
        
        arrExQLines.ExternalQuoteLine = QuoteLines;
        
        exQ.QuoteLines = arrExQLines;
        
        setRateDisplayFields(exQ);
                
        return RetVal;
    }
    
    public static boolean mapOutboundQuoteToExternalQuote(Quote__c q, Freight_Item__c[] arrFI, LogisticsQuoteReportService.ExternalQuote exQ, LogisticsQuoteReportService.ArrayOfExternalQuoteLine arrExQLines)
    {
        Boolean RetVal = true;
        
        exQ.DatePrepared = Datetime.now().format('dd-MMM-yyyy');
        
        //Unit test fails because the "Name" field is not populated or is null
        //when unit test is run.
            
        if (q.Name != null && q.Name != '')
            exQ.QuoteNumber = String.valueOf(long.valueOf(q.Name)) + 'A';
        else
            exQ.QuoteNumber = '';
        
        exQ.Owner = q.Owner.Name;
        exQ.ExhibitorName = q.Account_Id__r.Name;
        exQ.CompanyName = q.Account_Id__r.Name;
        exQ.CompanyNumber = q.Account_Id__r.GES_Master_Customer_Number__c;        
        exQ.JobCode = q.Job_Code__c;
        exQ.ProjectNumber = q.Project_Number__c;
        exQ.BillingContactName = q.Billing_Contact__r.Name;
        exQ.BillingContactEmail = q.Billing_Contact__r.Email;
        exQ.BillingContactPhone = q.Billing_Contact__r.Phone;
        exQ.BillingContactFax = q.Billing_Contact__r.Fax;
        
        //Pickup Information
        exQ.OriginationStreetAddress = q.OB_Origination_Street__c;
        exQ.OriginationCity = q.OB_Origination_City__c;
        exQ.OriginationState = q.OB_Origination_State__c;
        exQ.OriginationPostalCode = q.OB_Origination_Postal_Code__c;                        
        exQ.OriginationCountry = q.OB_Origination_Country__c;  
        exQ.PickupShowName = q.OB_Pickup_Show_Name__c;
        exQ.PickupBoothNumber = q.OB_Pickup_Booth_No__c;
        exQ.PickupShowContractor = q.OB_Pickup_Show_Contractor__c;
        
        exQ.PickupContactName = q.OB_Pickup_Contact_Name__c;
        exQ.PickupContactPhone = q.OB_Pickup_Contact_Phone__c;
        
        exQ.PickupDate = q.OB_Pickup_Date__c;
        
        if (q.OB_Pickup_Window_Start__c != null && q.OB_Pickup_Window_Start__c != 'None')
        {
            Integer PickupWindowEndTime = Integer.valueOf(q.OB_Pickup_Window_Start__c.split(':')[0]) + 4;
            
            if (PickupWindowEndTime <= 9)
                exQ.PickupWindow = q.OB_Pickup_Window_Start__c + ' - ' + '0' + String.valueOf(PickupWindowEndTime) + ':00';
            else
                exQ.PickupWindow = q.OB_Pickup_Window_Start__c + ' - ' + String.valueOf(PickupWindowEndTime) + ':00';               
        }         

        //TODO: This one does not exist in Outbound ??
        exQ.DeliveryDestination = q.OB_Delivery_Destination__c;
        
        exQ.DeliveryStreetAddress = q.OB_Destination_Street__c;
        exQ.DeliveryCity = q.OB_Destination_City__c;
        exQ.DeliveryState = q.OB_Destination_State__c;
        exQ.DeliveryPostalCode = q.OB_Destination_Postal_Code__c;                        
        
        exQ.DeliveryCountry = q.OB_Destination_Country__c;
        
        exQ.DeliveryShowName = q.OB_Delivery_Show_Name__c;
        exQ.DeliveryBoothNumber = q.OB_Delivery_Booth_No__c;
        
        exQ.DeliveryShowContractor = q.OB_Delivery_Show_Contractor__c;
        exQ.DeliveryContactName = q.OB_Delivery_Contact_Name__c;
        exQ.DeliveryContactPhone = q.OB_Delivery_Contact_Phone__c;
        exQ.DeliveryDate = q.OB_Delivery_Date__c;
        
        if (q.OB_Delivery_Window_Start__c != null && q.OB_Delivery_Window_Start__c != 'None')
        {
            Integer DeliveryWindowEndTime = Integer.valueOf(q.OB_Delivery_Window_Start__c.split(':')[0]) + 4;
            
            if (DeliveryWindowEndTime <= 9)
                exQ.DeliveryWindow = q.OB_Delivery_Window_Start__c + ' - ' + '0' + String.valueOf(DeliveryWindowEndTime) + ':00';
            else
                exQ.DeliveryWindow = q.OB_Delivery_Window_Start__c + ' - ' + String.valueOf(DeliveryWindowEndTime) + ':00';             
        } 
        
        // Options
        if (q.OB_Shipment_Type__c == 'Air Transportation')
        {
            if (q.OB_Class_of_Service__c == 'Next Day')
                exQ.AirNextDay = 'X';
            else if (q.OB_Class_of_Service__c == '2nd Day')
                exQ.AirSecondDay = 'X';
        }
        
        if (q.OB_Shipment_Type__c == 'Ground Transportation')
        {
            exQ.Ground = 'X';
            
            if (q.OB_Service_Type__c == 'LTL')
                exQ.LTL = 'X';
            else if (q.OB_Service_Type__c == 'FTL')
                exQ.Truckload = 'X';
        }

        exQ.Outbound = 'X';
        
        if (q.Quote_Subject__c.toUpperCase() == 'ROUNDTRIP')
            exQ.RoundTrip = 'X';
                            
        // TODO: Figure out if separate custom quote fields are required, one for 
        // inbound and another for outbound
        exQ.CustomQuote = (q.OB_Custom_Quote__c ? 'X' : '');
        
        exQ.SpecialInsideService = (q.OB_Inside_Pickup__c ? 'X' : '');
        exQ.SpecialLiftGate = (q.OB_Lift_Gate__c ? 'X' : '');
        exQ.SpecialPalletJack = (q.OB_Pallet_Jack__c ? 'X' : '');       
        exQ.SpecialResidential = (q.OB_Residential_Pickup__c ? 'X' : '');
        exQ.SpecialAdditionalLabor = (q.OB_Additional_Labor__c ? 'X' : '');
        exQ.SpecialAMSpecified = (q.OB_AM_Specified__c ? 'X' : '');
        exQ.SpecialPalletization = (q.OB_Palletization__c ? 'X' : '');        
        
        // For Outbound, Call Before Flag in the report needs to be the Quote's 
        // Call Before Delivery field. Report display InstructionsCallBeforePickup
        // field.
        
        exQ.InstructionsCallBeforePickup = (q.OB_Call_Before_Pickup__c ? 'Y' : '');
        exQ.InstructionsCallBeforeDelivery = (q.OB_Call_Before_Delivery__c ? 'Y' : '');
        
        exQ.InstructionsWeekendPickup = (q.OB_Weekend_Pickup__c ? 'X' : '');          
        exQ.InstructionsWeekendDelivery = (q.OB_Weekend_Delivery__c ? 'X' : '');      
        exQ.SpecialHazardousMaterials = (q.OB_Hazardous_Materials__c ? 'X' : '');

        if (q.OB_Additional_Labor__c || q.OB_AM_Specified__c || q.OB_Palletization__c
            || q.OB_Call_Before_Pickup__c || q.OB_Call_Before_Delivery__c || q.OB_Lift_Gate__c
            || q.OB_Hazardous_Materials__c || q.OB_Pallet_Jack__c || q.OB_Inside_Pickup__c
            || q.OB_Residential_Pickup__c || q.OB_Weekend_Pickup__c || q.OB_Weekend_Delivery__c)
        {
            exQ.CarrierNotes = 'Please see accessorial callout.' + (q.OB_Carrier_Notes__c != null && q.OB_Carrier_Notes__c != '' ? ' ' + q.OB_Carrier_Notes__c : '');
        }
        else
        {
            exQ.CarrierNotes = q.OB_Carrier_Notes__c;
        }
        
        if (q.EDV_Amount__c != null)
            exQ.DeclaredValue = q.EDV_Amount__c.setScale(2);
        else
            exQ.DeclaredValue = 0;
            
        exQ.DeclaredValueCheck =  (q.EDV_Amount__c != null && q.EDV_Amount__c > 0 ? 'X' : '');   
        
        exQ.UnitPrice = q.OB_Unit_Price__c;
        
        exQ.FuelSurcharge = q.OB_Fuel_Surcharge__c;
        exQ.InsideSurcharge = q.OB_Inside_Surcharge__c;
        exQ.LiftGateSurcharge = q.OB_Lift_Gate_Surcharge__c;
        exQ.ResidentialSurcharge = q.OB_Residential_Surcharge__c;
        exQ.AMSpecifiedFee = q.OB_AM_Specified_Fee__c;
        exQ.WeekendFee = q.OB_Weekend_Fee__c;
        exQ.WaitTimeFee = (q.OB_Wait_Time__c ? q.OB_Wait_Time_Fee__c : 0);
        exQ.AdditionalLaborFee = (q.OB_Additional_Labor__c ? q.OB_Additional_Labor_Fee__c : 0);
        exQ.PalletizationFee = (q.OB_Palletization__c ? q.OB_Palletization_Fee__c : 0);
        exQ.AttemptFee = (q.OB_Attempt__c ? q.OB_Attempt_Fee__c : 0);        
        exQ.SubTotal = q.OB_Sub_Total__c;
        exQ.Total = q.OB_Total__c;
        
        exQ.AdvanceOrderDiscountPercent = q.OB_Advance_Order_Discount__c;
        exQ.RoundtripDiscountPercent = q.OB_Round_Trip_Discount__c;
        
        exQ.HMContactNumber = q.OB_HM_Contact_Phone__c;        
        
        LogisticsQuoteReportService.ExternalQuoteLine[] QuoteLines = new LogisticsQuoteReportService.ExternalQuoteLine[]{};        
        
        integer TotalPieces = 0;
        
        for(Freight_Item__c fi : arrFI)
        {
            LogisticsQuoteReportService.ExternalQuoteLine QuoteLine = new LogisticsQuoteReportService.ExternalQuoteLine();
            QuoteLine.Length = (fi.Length__c ==  null ? 0 : fi.Length__c.intValue());
            QuoteLine.Width = (fi.Width__c ==  null ? 0 : fi.Width__c.intValue());
            QuoteLine.Height = (fi.Height__c ==  null ? 0 : fi.Height__c.intValue());
            QuoteLine.Description = fi.Description__c;
            QuoteLine.HazardousMaterial = (fi.Hazardous_Material__c ? 'X' : '');
            QuoteLine.Quantity = (fi.Quantity__c == null ? 0 : fi.Quantity__c.intValue());
            QuoteLine.Weight = fi.Crated_Weight__c;
                        
            TotalPieces += QuoteLine.Quantity;
            
            QuoteLines.add(QuoteLine);
        }
        
        exQ.ItemCount = TotalPieces;
        
        String Mode = '';
        
        if (q.OB_Shipment_Type__c != null && q.OB_Shipment_Type__c.toUpperCase() == 'AIR TRANSPORTATION')
            Mode = 'AIR';
        else
            Mode = 'Ground or Local';
                    
        exQ.TotalWeight = LogisticsCommon.GetWeight(q, Mode);  
        
        arrExQLines.ExternalQuoteLine = QuoteLines;
        
        exQ.QuoteLines = arrExQLines;
        
        setRateDisplayFields(exQ); 
        
        return RetVal;
    } 
    
    public static void setRateDisplayFields(LogisticsQuoteReportService.ExternalQuote exQ)
    {
        if (exQ.UnitPrice != null && exQ.UnitPrice > 0)
        {
            if (exQ.CustomQuote != null && exQ.CustomQuote != '')
                exQ.RatesLabel = 'Flat Rate or Per Pound Price ($):' + '\n';
            else if (exQ.TotalWeight <= 100)
                exQ.RatesLabel = 'Minimum Price ($):' + '\n';
            else
                exQ.RatesLabel = 'Per Pound Price ($):' + '\n';
			
            exQ.Rates = currencyToString(exQ.UnitPrice) + '\n'; 
        }
        
        if (exQ.FuelSurcharge != null && exQ.FuelSurcharge > 0)
        {
            if (exQ.RatesLabel != null)
                exQ.RatesLabel += 'Fuel Surcharge ($):' + '\n';
            else
                exQ.RatesLabel = 'Fuel Surcharge ($):' + '\n';
            
            if (exQ.Rates != null)
                exQ.Rates += currencyToString(exQ.FuelSurcharge) + '\n';
            else
                exQ.Rates = currencyToString(exQ.FuelSurcharge) + '\n';
        }        
            
        if (exQ.InsideSurcharge != null && exQ.InsideSurcharge > 0)
        {
            if (exQ.RatesLabel != null)
                exQ.RatesLabel += 'Inside Surcharge ($):' + '\n';
            else
                exQ.RatesLabel = 'Inside Surcharge ($):' + '\n';
            
            if (exQ.Rates != null)
                exQ.Rates += currencyToString(exQ.InsideSurcharge) + '\n';
            else
                exQ.Rates = currencyToString(exQ.InsideSurcharge) + '\n';
        }
            
        if (exQ.LiftGateSurcharge != null && exQ.LiftGateSurcharge > 0)
        {
            if (exQ.RatesLabel != null)
                exQ.RatesLabel += 'Lift Gate Fee ($):' + '\n';
            else
                exQ.RatesLabel = 'Lift Gate Fee ($):' + '\n';
            
            if (exQ.Rates != null)
                exQ.Rates += currencyToString(exQ.LiftGateSurcharge) + '\n';
            else
                exQ.Rates = currencyToString(exQ.LiftGateSurcharge) + '\n';
        }
        
        if (exQ.ResidentialSurcharge != null && exQ.ResidentialSurcharge > 0)
        {
            if (exQ.RatesLabel != null)
                exQ.RatesLabel += 'Residential Fee ($):' + '\n';
            else
                exQ.RatesLabel = 'Residential Fee ($):' + '\n';
            
            if (exQ.Rates != null)
                exQ.Rates += currencyToString(exQ.ResidentialSurcharge) + '\n';
            else
                exQ.Rates = currencyToString(exQ.ResidentialSurcharge) + '\n';
        }
        
        if (exQ.AMSpecifiedFee != null && exQ.AMSpecifiedFee > 0)
        {
            if (exQ.RatesLabel != null)
                exQ.RatesLabel += 'AM Specified Fee (Min $125):' + '\n';
            else
                exQ.RatesLabel = 'AM Specified Fee (Min $125):' + '\n';
            
            if (exQ.Rates != null)
                exQ.Rates += currencyToString(exQ.AMSpecifiedFee) + '\n';
            else
                exQ.Rates = currencyToString(exQ.AMSpecifiedFee) + '\n';
        }
        
        if (exQ.WeekendFee != null && exQ.WeekendFee > 0)
        {
            if (exQ.RatesLabel != null)
                exQ.RatesLabel += 'Weekend Fee (Min $125):' + '\n';
            else
                exQ.RatesLabel = 'Weekend Fee (Min $125):' + '\n';
            
            if (exQ.Rates != null)
                exQ.Rates += currencyToString(exQ.WeekendFee) + '\n';
            else
                exQ.Rates = currencyToString(exQ.WeekendFee) + '\n';
        }        
            
        if (exQ.SubTotal != null && exQ.SubTotal > 0)
        {
            if (exQ.RatesLabel != null)
                exQ.RatesLabel += 'Sub Total ($):' + '\n';
            else
                exQ.RatesLabel = 'Sub Total ($):' + '\n';
            
            if (exQ.Rates != null)
                exQ.Rates += currencyToString(exQ.SubTotal) + '\n';
            else
                exQ.Rates = currencyToString(exQ.SubTotal) + '\n';
        }
            
        if (exQ.Total != null && exQ.Total > 0)
        {
            if (exQ.RatesLabel != null)
                exQ.RatesLabel += 'Total ($):' + '\n';
            else
                exQ.RatesLabel = 'Total ($):' + '\n';
            
            if (exQ.Rates != null)
                exQ.Rates += currencyToString(exQ.Total) + '\n';
            else
                exQ.Rates = currencyToString(exQ.Total) + '\n';
        }
        
        //Additional Rate Fields
        
        exQ.RatesAdditionalLabel = '\n';
        exQ.RatesAdditional = '\n';
        
        if (exQ.WaitTimeFee != null && exQ.WaitTimeFee > 0)
        {
            exQ.RatesAdditionalLabel += 'Wait Time ($ Per Hour):' + '\n';
            exQ.RatesAdditional += currencyToString(exQ.WaitTimeFee) + '\n';
        }
        
        if (exQ.AdditionalLaborFee != null && exQ.AdditionalLaborFee > 0)
        {
            if (exQ.RatesAdditionalLabel != null)
                exQ.RatesAdditionalLabel += 'Additional Labor ($ Per Labor / Hour):' + '\n';
            else
                exQ.RatesAdditionalLabel = 'Additional Labor ($ Per Labor / Hour):' + '\n';
            
            if (exQ.RatesAdditional != null)
                exQ.RatesAdditional += currencyToString(exQ.AdditionalLaborFee) + '\n';
            else
                exQ.RatesAdditional = currencyToString(exQ.AdditionalLaborFee) + '\n';
        }
        
        if (exQ.PalletizationFee != null && exQ.PalletizationFee > 0)
        {
            if (exQ.RatesAdditionalLabel != null)
                exQ.RatesAdditionalLabel += 'Palletization ($ Per Pallet):' + '\n';
            else
                exQ.RatesAdditionalLabel = 'Palletization ($ Per Pallet):' + '\n';
            
            if (exQ.RatesAdditional != null)
                exQ.RatesAdditional += currencyToString(exQ.PalletizationFee) + '\n';
            else
                exQ.RatesAdditional = currencyToString(exQ.PalletizationFee) + '\n';
        }
        
        if (exQ.AttemptFee != null && exQ.AttemptFee > 0)
        {
            if (exQ.RatesAdditionalLabel != null)
                exQ.RatesAdditionalLabel += 'Attempt ($ Per Attempt):' + '\n';
            else
                exQ.RatesAdditionalLabel = 'Attempt ($ Per Attempt):' + '\n';
            
            if (exQ.RatesAdditional != null)
                exQ.RatesAdditional += currencyToString(exQ.AttemptFee) + '\n';
            else
                exQ.RatesAdditional = currencyToString(exQ.AttemptFee) + '\n';
        }
        
        if (exQ.DeclaredValue != null && exQ.DeclaredValue > 0)
        {   
            Double InsuranceAmount = 0;
            
            if (exQ.DeclaredValue != null && exQ.DeclaredValue != 0)
            {
                InsuranceAmount = (exQ.DeclaredValue / 100 <= 50 ? 100 : (Math.Round((exQ.DeclaredValue / 100) * 2)));
            }

            if (exQ.RatesAdditionalLabel != null)
                exQ.RatesAdditionalLabel += 'EDV Fee (Min $100, $2 / $100):' + '\n';
            else
                exQ.RatesAdditionalLabel = 'EDV Fee (Min $100, $2 / $100):' + '\n';
            
            if (exQ.RatesAdditional != null)
                exQ.RatesAdditional += currencyToString(InsuranceAmount) + '\n';
            else
                exQ.RatesAdditional = currencyToString(InsuranceAmount) + '\n';
        }
        
        if (exQ.AdvanceOrderDiscountPercent != null && exQ.AdvanceOrderDiscountPercent > 0) 
        {
            if (exQ.RatesAdditionalLabel != null)
                exQ.RatesAdditionalLabel += 'Advance Order Discount (%):' + '\n';
            else
                exQ.RatesAdditionalLabel = 'Advance Order Discount (%):' + '\n';
            
            if (exQ.RatesAdditional != null)
                exQ.RatesAdditional += currencyToString(exQ.AdvanceOrderDiscountPercent) + '\n';
            else
                exQ.RatesAdditional = currencyToString(exQ.AdvanceOrderDiscountPercent) + '\n';         
        }
        
        if (exQ.RoundtripDiscountPercent != null && exQ.RoundtripDiscountPercent > 0) 
        {
            if (exQ.RatesAdditionalLabel != null)
                exQ.RatesAdditionalLabel += 'Roundtrip Discount (%):' + '\n';
            else
                exQ.RatesAdditionalLabel = 'Roundtrip Discount (%):' + '\n';
            
            if (exQ.RatesAdditional != null)
                exQ.RatesAdditional += currencyToString(exQ.RoundtripDiscountPercent) + '\n';
            else
                exQ.RatesAdditional = currencyToString(exQ.RoundtripDiscountPercent) + '\n';            
        }           
    }
    
    /*
    public static Integer GetWeight(Quote__c q)
    {
        Integer TotalWeight = 0;
        
        //If Weight Override is specified, use that. Otherwise, check if
        //Dim Weight is greater than Crated Weight. If so, use Dim Weight
        //otherwise use Crated Weight
        if (q.Weight_Override__c == null || q.Weight_Override__c <= 0)
        {                           
            if (q.Dim_Weight__c != null && q.Crated_Weight__c != null)
            {
                if (q.Dim_Weight__c > q.Crated_Weight__c)
                {
                    TotalWeight = q.Dim_Weight__c.intValue();
                }
                else
                {
                    TotalWeight = q.Crated_Weight__c.intValue();
                }
            }
            else if (q.Dim_Weight__c == null && q.Crated_Weight__c != null)
                TotalWeight = q.Crated_Weight__c.intValue();
            else if (q.Crated_Weight__c == null && q.Dim_Weight__c != null)
                TotalWeight = q.Dim_Weight__c.intValue();
        }
        else
        {
            TotalWeight = q.Weight_Override__c.intValue();
        }
        
        return TotalWeight;     
    }
    */
}