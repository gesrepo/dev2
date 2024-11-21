global with sharing class LogisticsQuoteRates {
    
    global static LogisticsQuoteComplexPriceData complexPrice {get; set; }
    //global static decimal TotalWeight {get; set; }
    //global static decimal TotalCratedWeight {get; set; }
    global static LogisticsQuoteGeneratorService.QuoteRequestObject PriceRequestObjectIb {get; set; }
    global static LogisticsQuoteGeneratorService.QuoteRequestObject PriceRequestObjectOb {get; set; }
    global static LogisticsQuoteGeneratorService.ArrayOfQuoteResponseObject PriceResponseObjectIb {get; set; }
    global static LogisticsQuoteGeneratorService.ArrayOfQuoteResponseObject PriceResponseObjectOb {get; set; }
    global static LogisticsQuoteGeneratorService.QuoteGeneratorWebServiceSoap WS {get; set; }
    global static boolean AirRateEligible {get; set; }
    global static string AirRateIneligibilityMessage {get; set; }
    global static boolean GroundRateEligible {get; set; }
    global static string GroundRateIneligibilityMessage {get; set; }

    public static decimal currencyFixed(decimal N)
    {
        if (N == null)
            return 0.00;
        else
            return N.setScale(2);
    }
    
    public static decimal currencyFixed3Digits(decimal N)
    {
        if (N == null)
            return 0.000;
        else
            return N.setScale(3);
    }    
    
    public static decimal valueToPercent(decimal N)
    {
        if (N == null)
            return 0;
        else
            return integer.valueOf(N.setScale(2) * 100);
    }    
        
    public static string currencyToString(decimal N)
    {
        if (N == null)
            return '0';
        else
            return N.setScale(2).toPlainString();
    }   
    
    WebService static String GetRatesLightning(Id quoteId, string direction)
    {   
        Quote__c q = Database.query(LogisticsQuoteObjectMapper.QuoteSelectQuery + 'Where q.Id = \'' + quoteId + '\'');
        
        string Html = '';
        LogisticsQuoteRates.GetRatesWrapper res = new LogisticsQuoteRates.GetRatesWrapper();
        
        try
        {
            complexPrice = new LogisticsQuoteComplexPriceData();  
            
            direction = direction.toUpperCase();
        
            // Initialize Global variables, Price Request and Response Objects, Web Service Stub
            // and other variables
            Initialize(quoteId, q, direction);
        
            boolean ReturnValue = FillComplexRatesObject(quoteId, direction.toUpperCase(), q, complexPrice);
            
            res =   (ReturnValue ? GetHtmlLightning(direction, complexPrice, q) : new GetRatesWrapper() );
            Html = JSON.serialize(res);

        }
        finally
        {
            q = null;
        }
        
        return Html;
    }
    
    WebService static string GetRates(Id quoteId, string direction)
    {   
        Quote__c q = Database.query(LogisticsQuoteObjectMapper.QuoteSelectQuery + 'Where q.Id = \'' + quoteId + '\'');
        
        string Html = '';
        
        try
        {
            complexPrice = new LogisticsQuoteComplexPriceData();  
            
            direction = direction.toUpperCase();
        
            // Initialize Global variables, Price Request and Response Objects, Web Service Stub
            // and other variables
            Initialize(quoteId, q, direction);
        
            boolean ReturnValue = FillComplexRatesObject(quoteId, direction.toUpperCase(), q, complexPrice);
            
            Html =  (ReturnValue ? GetHtml(direction, complexPrice, q) : '' );

        }
        finally
        {
            q = null;
        }
        
        return Html;
    }
    
    public static void Initialize(Id quoteId, Quote__c q, string direction)
    {
        WS = new LogisticsQuoteGeneratorService.QuoteGeneratorWebServiceSoap();
                
        PriceRequestObjectIb = new LogisticsQuoteGeneratorService.QuoteRequestObject();
        PriceRequestObjectOb = new LogisticsQuoteGeneratorService.QuoteRequestObject();
        PriceResponseObjectIb = new LogisticsQuoteGeneratorService.ArrayOfQuoteResponseObject();
        PriceResponseObjectOb = new LogisticsQuoteGeneratorService.ArrayOfQuoteResponseObject();
        
        WS.timeout_x = 60000;
        WS.clientCertName_x = LogisticsCommon.getCertificateName('GES_Logistics_Rates');//'GES';
        
        AirRateEligible = true;
        AirRateIneligibilityMessage = '';
        
        GroundRateEligible = true;
        GroundRateIneligibilityMessage= '';
        
        direction = direction.toUpperCase();
        
        System.debug('Quote Id from Object: ' + q.Id);
        System.debug('Quote Id from variable: ' + quoteId);
        
        SetRateInEligibilityMessage(quoteId, q);
            
        SetInboundRequestObjectProperties(direction, PriceRequestObjectIb, q);
        SetOutboundRequestObjectProperties(direction, PriceRequestObjectOb, q);
    }
    
    public static void SetRateInEligibilityMessage(Id quoteId, Quote__c q)
    {
        List<Freight_Item__c> FreightItems = [Select Id, Crated_Weight__c, Length__c, Width__c, Height__c, Quantity__c From Freight_Item__c Where Void__c = False And Quote__r.Id = :quoteId];
        
        decimal MaxGirth = 0;
        decimal MaxHeight = 0;
        decimal MaxLength = 0;
        decimal MaxWidth = 0;
        
        try
        {
            if (FreightItems.size() > 0)
            {
                decimal LineGirth = 0;
                
                for(Freight_Item__c fi : FreightItems)
                {
                    if (fi.Quantity__c == null || fi.Quantity__c == 0)
                        fi.Quantity__c = 1;
                                    
                    // For Air Transportation, Dimensions cannot exceed spcecified values
                    if (fi.Length__c != null && fi.Length__c > MaxLength)
                        MaxLength = fi.Length__c;
                        
                    if (fi.Width__c != null && fi.Width__c > MaxWidth)
                        MaxWidth = fi.Width__c;
                        
                    if (fi.Height__c != null && fi.Height__c > MaxHeight)
                        MaxHeight = fi.Height__c;
                    
                    if (fi.Width__c != null && fi.Height__c != null)
                        LineGirth = 2 * (fi.Width__c + fi.Height__c);
                    
                    if (LineGirth > MaxGirth)
                        MaxGirth = LineGirth;
                    
                }         
            }
            else //Items not entered
            {
            }
        }
        finally
        {
            FreightItems = null;
        }
        
        if (MaxGirth > 213)
        {
            AirRateEligible = false;
            AirRateIneligibilityMessage = 'Girth of one or more item is more than max allowed (213")';
        }
        
        if (MaxLength > 84)
        {
            AirRateEligible = false;
            
            if (AirRateIneligibilityMessage != '')
                AirRateIneligibilityMessage += '<br/>';
                
            AirRateIneligibilityMessage += 'Length of one or more item is more than max allowed (84")';
        }
        
        if (MaxHeight > 55)
        {
            AirRateEligible = false;
            
            if (AirRateIneligibilityMessage != '')
                AirRateIneligibilityMessage += '<br/>';
                            
            AirRateIneligibilityMessage += 'Height of one or more item is more than max allowed (55")';
        }
        
        if (MaxLength > 288)
        {
            GroundRateEligible = false;
            
            if (GroundRateIneligibilityMessage != '')
                GroundRateIneligibilityMessage += '<br/>';
                            
            GroundRateIneligibilityMessage += 'Length of one or more item is more than max allowed (288")';
        }
        
        if (MaxWidth > 96)
        {
            GroundRateEligible = false;
            
            if (GroundRateIneligibilityMessage != '')
                GroundRateIneligibilityMessage += '<br/>';
                            
            GroundRateIneligibilityMessage += 'Width of one or more item is more than max allowed (96")';
        }
        
        if (MaxHeight > 96)
        {
            GroundRateEligible = false;
            
            if (GroundRateIneligibilityMessage != '')
                GroundRateIneligibilityMessage += '<br/>';
                            
            GroundRateIneligibilityMessage += 'Height of one or more item is more than max allowed (96")';
        }  
        
    }
    
    public static void SetInboundRequestObjectProperties(string direction, LogisticsQuoteGeneratorService.QuoteRequestObject requestObjectIb, Quote__c q)
    {
        //requestObjectIb.QuoteRequestID = decimal.valueOf(q.Name); 
        requestObjectIb.QuoteRequestID = 0; //Web service expects 0 in this field   
        requestObjectIb.JobCode = q.Project_Number__c;
                                
        requestObjectIb.OriginationState = q.Origination_State__c;
        requestObjectIb.DestinationState = q.Destination_State__c;
        requestObjectIb.ShipmentPUDate = q.Pickup_Date__c; //q.Pickup_Date__c.year() + '-' + (q.Pickup_Date__c.month() + 1) + '-' + (q.Pickup_Date__c.day());       
        requestObjectIb.DeliveryDate = q.Delivery_Date__c;
        requestObjectIb.OrderDate = DateTime.now(); // q.Order_Date__c; //q.Order_Date__c.format('yyyy-MM-dd');                     
        requestObjectIb.IsInsidePickup = (q.Inside_Pickup__c == false ? 'No' : 'Yes');
        requestObjectIb.IsLiftGateNeeded = (q.Lift_Gate__c == false ? 'No' : 'Yes');
        requestObjectIb.IsResidentialPickup = (q.Residential_Pickup__c == false ? 'No' : 'Yes');
        requestObjectIb.IsRoundTrip = (direction == 'ROUNDTRIP' ? 'Yes' : 'No');
        requestObjectIb.IsAMSpecified = (q.AM_Specified__c == false ? 'No' : 'Yes');
        requestObjectIb.IsWeekendPickup = (q.Weekend_Pickup__c == false ? 'No' : 'Yes');
        requestObjectIb.IsWeekendDelivery = (q.Weekend_Delivery__c == false ? 'No' : 'Yes');
        
        //Set this just before invoking the service depending on the mode (Air or Ground or Local)
        requestObjectIb.CreatedWeight = 0;
        
        // Takes three values Inbound, Outbound or Roundtrip 0, 1 or 2              
        requestObjectIb.DirectionID = -1;
                
        //  Fields below need to be populated otherwise Web Service is unable to serialize
        //  and parse the request
        
        requestObjectIb.TypeID = -1;
        requestObjectIb.SelectionID = -1;
        requestObjectIb.ClassOfServiceID = -1;
        requestObjectIb.InboundDestId = -1;     
    }
    
    public static void SetOutboundRequestObjectProperties(string direction, LogisticsQuoteGeneratorService.QuoteRequestObject requestObjectOb, Quote__c q)
    {
        //requestObjectOb.QuoteRequestID = decimal.valueOf(q.Name);
        requestObjectOb.QuoteRequestID = 0; //Web service expects 0 in this field       
        requestObjectOb.JobCode = q.Project_Number__c;      
                
        requestObjectOb.OriginationState = q.OB_Origination_State__c;
        requestObjectOb.DestinationState = q.OB_Destination_State__c;
        requestObjectOb.ShipmentPUDate = q.OB_Pickup_Date__c; //q.OB_Pickup_Date__c.format('yyyy-MM-dd');       
        requestObjectOb.DeliveryDate = q.OB_Delivery_Date__c;
        requestObjectOb.OrderDate = DateTime.now(); //q.Order_Date__c;
                        
        requestObjectOb.IsInsidePickup = (q.OB_Inside_Pickup__c == false ? 'No' : 'Yes');
        requestObjectOb.IsLiftGateNeeded = (q.OB_Lift_Gate__c == false ? 'No' : 'Yes');
        requestObjectOb.IsResidentialPickup = (q.OB_Residential_Pickup__c == false ? 'No' : 'Yes');
        requestObjectOb.IsRoundTrip = (direction == 'ROUNDTRIP' ? 'Yes' : 'No');
        requestObjectOb.IsAMSpecified = (q.OB_AM_Specified__c == false ? 'No' : 'Yes');
        requestObjectOb.IsWeekendPickup = (q.OB_Weekend_Pickup__c == false ? 'No' : 'Yes');
        requestObjectOb.IsWeekendDelivery = (q.OB_Weekend_Delivery__c == false ? 'No' : 'Yes');     
                
        //Set this just before invoking the service depending on the mode (Air or Ground or Local)
        requestObjectOb.CreatedWeight = 0;
        
        // Takes three values Inbound, Outbound or Roundtrip 0, 1 or 2              
        requestObjectOb.DirectionID = -1;
                
        // Fields below need to be populated otherwise Web Service is unable to serialize
        // and parse the request
        
        requestObjectOb.TypeID = -1;        
        requestObjectOb.SelectionID = -1;
        requestObjectOb.ClassOfServiceID = -1;
        requestObjectOb.InboundDestId = -1;     
    }   
    
    private static boolean FillComplexRatesObject(id quoteId, string direction, Quote__c q,LogisticsQuoteComplexPriceData complexPriceData )
    {   
        boolean ReturnValue = true;
        
        if (direction == 'INBOUND' || direction == 'ROUNDTRIP' )
        {
            //GET INBOUND PRICING for GROUND and LOCAL
            try
            {
                PriceRequestObjectIb.CreatedWeight = LogisticsCommon.GetWeight(q, 'Ground');
                //PriceRequestObjectIb.CreatedWeight = GetWeight(q, 'Ground');
                if(!Test.isRunningTest()){
                    PriceResponseObjectIb = InvokeQuoteRatesService(WS, PriceRequestObjectIb);
                    SetInboundLocalRates(complexPrice, PriceResponseObjectIb, q);
                    SetInboundGroundRates(GroundRateEligible, GroundRateInEligibilityMessage, complexPrice, PriceResponseObjectIb, q);
                }
            }
            finally
            {
                PriceResponseObjectIb = null;
            }
            
            
            //GET INBOUND PRICING for AIR TRANSPORTATION
            if (AirRateEligible)
            {
                try
                {
                    PriceRequestObjectIb.CreatedWeight = LogisticsCommon.GetWeight(q, 'Air');
                    //PriceRequestObjectIb.CreatedWeight = GetWeight(q, 'Air');
                                    
                    PriceResponseObjectIb = new LogisticsQuoteGeneratorService.ArrayOfQuoteResponseObject();
                    
                    if(!Test.isRunningTest()){
                        PriceResponseObjectIb = InvokeQuoteRatesService(WS, PriceRequestObjectIb);
                        SetInboundAirRates(AirRateEligible, AirRateIneligibilityMessage, complexPrice, PriceResponseObjectIb, q);
                    }
                }
                finally
                {
                    PriceRequestObjectIb = null;
                    PriceResponseObjectIb = null;
                }
            } // end if air rate not eligible
            else {
                SetInboundAirRates(AirRateEligible, AirRateIneligibilityMessage, complexPrice, PriceResponseObjectIb, q);               
            }
            
        }
        
        
        // OUTBOUND PRICING
        if (direction == 'OUTBOUND' || direction == 'ROUNDTRIP' )
        {   
            //GET OUTBOUND PRICING for GROUND and LOCAL
            try
            {
                PriceRequestObjectOb.CreatedWeight = LogisticsCommon.GetWeight(q, 'Ground');
                //PriceRequestObjectOb.CreatedWeight = GetWeight(q, 'Ground');
                if(!Test.isRunningTest()){              
                    PriceResponseObjectOb = InvokeQuoteRatesService(WS, PriceRequestObjectOb);
                    SetOutboundLocalRates(complexPrice, PriceResponseObjectOb, q);              
                    SetOutboundGroundRates(GroundRateEligible, GroundRateInEligibilityMessage, complexPrice, PriceResponseObjectOb, q);
                }
            }
            finally
            {
                PriceResponseObjectOb = null;
            }
            
            //GET OUTBOUND PRICING for AIR TRANSPORTATION
            if (AirRateEligible)
            {
                try
                {
                    PriceRequestObjectOb.CreatedWeight = LogisticsCommon.GetWeight(q, 'Air');
                    //PriceRequestObjectOb.CreatedWeight = GetWeight(q, 'Air');
                
                    PriceResponseObjectOb = new LogisticsQuoteGeneratorService.ArrayOfQuoteResponseObject();
                    
                    if(!Test.isRunningTest()){
                        PriceResponseObjectOb = InvokeQuoteRatesService(WS, PriceRequestObjectOb);
                        SetOutboundAirRates(AirRateEligible, AirRateIneligibilityMessage, complexPrice, PriceResponseObjectOb, q);
                    }
                }
                finally
                {
                    PriceRequestObjectOb = null;
                    PriceResponseObjectOb = null;
                    WS = null;
                }               
            }  // end if air rate not eligible
            else {
                SetOutboundAirRates(AirRateEligible, AirRateIneligibilityMessage, complexPrice, PriceResponseObjectOb, q);                  
            }
        }
        
        return ReturnValue;
    }   
    
    WebService static string UpdateQuote(id quoteId, string selection, string rates, string unitPrice)
    {
        string RetVal = '';
        Quote__c q;
        
        try
        {           
            q = Database.query(LogisticsQuoteObjectMapper.QuoteSelectQuery + 'Where q.Id = \'' + quoteId + '\'');
            
            system.debug('RATES: ' + rates.toUpperCase());
            system.debug('SELECTION: ' + selection.toUpperCase());
            
            if (selection.toUpperCase() == 'HIAIR2NDDAY')
            {
                q.Shipment_Type__c = 'Air Transportation';
                q.Class_of_Service__c = '2nd Day';
                q.Service_Type__c = 'LTL';
                q.Selection__c = 'High';
            }
            else if (selection.toUpperCase() == 'HIAIRNEXTDAY')
            {
                q.Shipment_Type__c = 'Air Transportation';
                q.Class_of_Service__c = 'Next Day';
                q.Service_Type__c = 'LTL';
                q.Selection__c = 'High';
            }
            else if (selection.toUpperCase() == 'HIGROUNDLTL')
            {
                q.Shipment_Type__c = 'Ground Transportation';
                q.Class_of_Service__c = '';
                q.Service_Type__c = 'LTL';
                q.Selection__c = 'High';
            }
            else if (selection.toUpperCase() == 'HIGROUNDFTL')
            {
                q.Shipment_Type__c = 'Ground Transportation';
                q.Class_of_Service__c = '';
                q.Service_Type__c = 'FTL';
                q.Selection__c = 'High';        
            }
            else if (selection.toUpperCase() == 'HILOCAL')
            {
                q.Shipment_Type__c = 'Local Shipments';
                q.Class_of_Service__c = '';
                q.Service_Type__c = '';             
                q.Selection__c = 'High';                
            }
            else if (selection.toUpperCase() == 'LIAIR2NDDAY')
            {
                q.Shipment_Type__c = 'Air Transportation';
                q.Class_of_Service__c = '2nd Day';
                q.Service_Type__c = 'LTL';
                q.Selection__c = 'Low';             
            }           
            else if (selection.toUpperCase() == 'LIAIRNEXTDAY')
            {
                q.Shipment_Type__c = 'Air Transportation';
                q.Class_of_Service__c = 'Next Day';
                q.Service_Type__c = 'LTL';
                q.Selection__c = 'Low';             
            }
            else if (selection.toUpperCase() == 'LIGROUNDLTL')
            {
                q.Shipment_Type__c = 'Ground Transportation';
                q.Class_of_Service__c = '';
                q.Service_Type__c = 'LTL';
                q.Selection__c = 'Low';
            }
            else if (selection.toUpperCase() == 'LIGROUNDFTL')
            {
                q.Shipment_Type__c = 'Ground Transportation';
                q.Class_of_Service__c = '';
                q.Service_Type__c = 'FTL';
                q.Selection__c = 'Low';             
            }
            else if (selection.toUpperCase() == 'LILOCAL')
            {
                q.Shipment_Type__c = 'Local Shipments';
                q.Class_of_Service__c = '';
                q.Service_Type__c = '';             
                q.Selection__c = 'Low';                 
            }           
            
            if (selection.toUpperCase() == 'HOAIR2NDDAY')
            {
                q.OB_Shipment_Type__c = 'Air Transportation';
                q.OB_Class_of_Service__c = '2nd Day';
                q.OB_Service_Type__c = 'LTL';
                q.OB_Selection__c = 'High';             
            }
            else if (selection.toUpperCase() == 'HOAIRNEXTDAY')
            {
                q.OB_Shipment_Type__c = 'Air Transportation';
                q.OB_Class_of_Service__c = 'Next Day';
                q.OB_Service_Type__c = 'LTL';
                q.OB_Selection__c = 'High';             
            }
            else if (selection.toUpperCase() == 'HOGROUNDLTL')
            {
                q.OB_Shipment_Type__c = 'Ground Transportation';
                q.OB_Class_of_Service__c = '';
                q.OB_Service_Type__c = 'LTL';
                q.OB_Selection__c = 'High';         
            }
            else if (selection.toUpperCase() == 'HOGROUNDFTL')
            {
                q.OB_Shipment_Type__c = 'Ground Transportation';
                q.OB_Class_of_Service__c = '';
                q.OB_Service_Type__c = 'FTL';
                q.OB_Selection__c = 'High';             
            }
            else if (selection.toUpperCase() == 'HOLOCAL')
            {
                q.OB_Shipment_Type__c = 'Local Shipments';
                q.OB_Class_of_Service__c = '';
                q.OB_Service_Type__c = '';              
                q.OB_Selection__c = 'High';             
            }
            else if (selection.toUpperCase() == 'LOAIR2NDDAY')
            {
                q.OB_Shipment_Type__c = 'Air Transportation';
                q.OB_Class_of_Service__c = '2nd Day';
                q.OB_Service_Type__c = 'LTL';
                q.OB_Selection__c = 'Low';              
            }           
            else if (selection.toUpperCase() == 'LOAIRNEXTDAY')
            {
                q.OB_Shipment_Type__c = 'Air Transportation';
                q.OB_Class_of_Service__c = 'Next Day';
                q.OB_Service_Type__c = 'LTL';
                q.OB_Selection__c = 'Low';              
            }
            else if (selection.toUpperCase() == 'LOGROUNDLTL')
            {
                q.OB_Shipment_Type__c = 'Ground Transportation';
                q.OB_Class_of_Service__c = '';              
                q.OB_Service_Type__c = 'LTL';
                q.OB_Selection__c = 'Low';              
            }
            else if (selection.toUpperCase() == 'LOGROUNDFTL')
            {
                q.OB_Shipment_Type__c = 'Ground Transportation';
                q.OB_Class_of_Service__c = '';
                q.OB_Service_Type__c = 'FTL';
                q.OB_Selection__c = 'Low';              
            }
            else if (selection.toUpperCase() == 'LOLOCAL')
            {
                q.OB_Shipment_Type__c = 'Local Shipments';
                q.OB_Class_of_Service__c = '';
                q.OB_Service_Type__c = '';              
                q.OB_Selection__c = 'Low';              
            }
            else if (selection.toUpperCase() == 'CIAIR2NDDAY')
            {
                q.Shipment_Type__c = 'Air Transportation';
                q.Class_of_Service__c = '2nd Day';
                q.Service_Type__c = 'LTL';
                q.Selection__c = 'Name Your Price';
            }
            else if (selection.toUpperCase() == 'CIAIRNEXTDAY')
            {
                q.Shipment_Type__c = 'Air Transportation';
                q.Class_of_Service__c = 'Next Day';
                q.Service_Type__c = 'LTL';
                q.Selection__c = 'Name Your Price';
            }
            else if (selection.toUpperCase() == 'CIGROUNDLTL')
            {
                q.Shipment_Type__c = 'Ground Transportation';
                q.Class_of_Service__c = '';             
                q.Service_Type__c = 'LTL';
                q.Selection__c = 'Name Your Price';             
            }
            else if (selection.toUpperCase() == 'CIGROUNDFTL')
            {
                q.Shipment_Type__c = 'Ground Transportation';
                q.Class_of_Service__c = '';
                q.Service_Type__c = 'FTL';
                q.Selection__c = 'Name Your Price';             
            }
            else if (selection.toUpperCase() == 'CILOCAL')
            {
                q.Shipment_Type__c = 'Local Shipments';
                q.Class_of_Service__c = '';
                q.Service_Type__c = '';
                q.Selection__c = 'Name Your Price';             
            }
            else if (selection.toUpperCase() == 'COAIR2NDDAY')
            {
                q.OB_Shipment_Type__c = 'Air Transportation';
                q.OB_Class_of_Service__c = '2nd Day';
                q.OB_Service_Type__c = 'LTL';
                q.OB_Selection__c = 'Name Your Price';
            }
            else if (selection.toUpperCase() == 'COAIRNEXTDAY')
            {
                q.OB_Shipment_Type__c = 'Air Transportation';
                q.OB_Class_of_Service__c = 'Next Day';
                q.OB_Service_Type__c = 'LTL';
                q.OB_Selection__c = 'Name Your Price';
            }
            else if (selection.toUpperCase() == 'COGROUNDLTL')
            {
                q.OB_Shipment_Type__c = 'Ground Transportation';
                q.OB_Class_of_Service__c = '';              
                q.OB_Service_Type__c = 'LTL';
                q.OB_Selection__c = 'Name Your Price';              
            }
            else if (selection.toUpperCase() == 'COGROUNDFTL')
            {
                q.OB_Shipment_Type__c = 'Ground Transportation';
                q.OB_Class_of_Service__c = '';
                q.OB_Service_Type__c = 'FTL';
                q.OB_Selection__c = 'Name Your Price';              
            }
            else if (selection.toUpperCase() == 'COLOCAL')
            {
                q.OB_Shipment_Type__c = 'Local Shipments';
                q.OB_Class_of_Service__c = '';
                q.OB_Service_Type__c = '';
                q.OB_Selection__c = 'Name Your Price';              
            }
                        
            if (selection.toUpperCase().startsWith('HI') ||selection.toUpperCase().startsWith('LI')|| selection.toUpperCase().startsWith('CI') ) {
                
                q.Unit_Price__c = decimal.valueOf(rates.split(',')[0]);
                q.Fuel_Unit_Surcharge__c = decimal.valueOf(rates.split(',')[1]);
                q.Fuel_Surcharge__c = decimal.valueOf(rates.split(',')[2]);
                q.Sub_total__c = decimal.valueOf(rates.split(',')[12]);
                q.Total__c = decimal.valueOf(rates.split(',')[13]);
                
                q.Lift_Gate_Surcharge__c = decimal.valueOf(rates.split(',')[3]);
                q.Inside_Surcharge__c = decimal.valueOf(rates.split(',')[4]);
                q.Residential_Surcharge__c = decimal.valueOf(rates.split(',')[5]);
                
                if (q.AM_Specified__c)
                    q.AM_Specified_Fee__c = decimal.valueOf(rates.split(',')[6]);
                else
                    q.AM_Specified_Fee__c = 0;
                    
                if (q.Weekend_Pickup__c || q.Weekend_Delivery__c)
                    q.Weekend_Fee__c = decimal.valueOf(rates.split(',')[7]);
                else
                    q.Weekend_Fee__c = 0;
                
                if (q.Wait_Time__c)
                    q.Wait_Time_Fee__c = decimal.valueOf(rates.split(',')[8]);
                else
                    q.Wait_Time_Fee__c = 0;
                
                if (q.Additional_Labor__c)
                    q.Additional_Labor_Fee__c = decimal.valueOf(rates.split(',')[9]);
                else
                    q.Additional_Labor_Fee__c = 0;
                    
                if(q.Palletization__c)
                    q.Palletization_Fee__c = decimal.valueOf(rates.split(',')[10]);
                else
                    q.Palletization_Fee__c = 0;
                    
                if (q.Attempt__c)           
                    q.Attempt_Fee__c = decimal.valueOf(rates.split(',')[11]);
                else
                    q.Attempt_Fee__c = 0;
                
                if (selection.toUpperCase().startsWith('CI'))
                {
                    q.Total__c = q.Total__c - q.Sub_Total__c - q.Fuel_Surcharge__c; 
                    
                    q.Sub_total__c = (q.Sub_total__c/q.Unit_Price__c) * decimal.valueOf(unitPrice);
                    q.Fuel_Surcharge__c = q.Sub_total__c * q.Fuel_Unit_Surcharge__c;
                    
                    //SFDC-280 - Modify the Total Field to include the NY City Fee and Beyond Point Fee fields - 03/07/24 - Sajid
                    //q.Total__c = q.Total__c + q.Sub_Total__c + q.Fuel_Surcharge__c;
                    Double INBeyondPointAndNYFees = 0;
                    if(q.Beyond_Point__c != null){
                        INBeyondPointAndNYFees = q.IN_Beyond_Point_Fee__c;
                    }
                    if(q.NY_City__c){
                        INBeyondPointAndNYFees += q.IN_New_York_City_Fee__c;
                    }
                    if(INBeyondPointAndNYFees != null && INBeyondPointAndNYFees != 0 && INBeyondPointAndNYFees != 0.00){
                        q.Total__c = q.Total__c + q.Sub_Total__c + q.Fuel_Surcharge__c + INBeyondPointAndNYFees;
                    }else{
                        q.Total__c = q.Total__c + q.Sub_Total__c + q.Fuel_Surcharge__c;
                    }
                    //End - SFDC-280
                    
                    q.Unit_Price__c = decimal.valueOf(unitPrice);
                }
                
                q.Advance_Order_Discount__c = decimal.valueOf(rates.split(',')[14]);
                q.Round_Trip_Discount__c = decimal.valueOf(rates.split(',')[15]);
            }
            
            if (selection.toUpperCase().startsWith('HO') ||selection.toUpperCase().startsWith('LO') || selection.toUpperCase().startsWith('CO')) {
                
                q.OB_Unit_Price__c = decimal.valueOf(rates.split(',')[0]);              
                q.OB_Fuel_Unit_Surcharge__c = decimal.valueOf(rates.split(',')[1]);
                q.OB_Fuel_Surcharge__c = decimal.valueOf(rates.split(',')[2]);              
                q.OB_Sub_total__c = decimal.valueOf(rates.split(',')[12]);
                q.OB_Total__c = decimal.valueOf(rates.split(',')[13]);
                
                q.OB_Lift_Gate_Surcharge__c = decimal.valueOf(rates.split(',')[3]);
                q.OB_Inside_Surcharge__c = decimal.valueOf(rates.split(',')[4]);
                q.OB_Residential_Surcharge__c = decimal.valueOf(rates.split(',')[5]);
                
                if (q.OB_AM_Specified__c)
                    q.OB_AM_Specified_Fee__c = decimal.valueOf(rates.split(',')[6]);
                else
                    q.OB_AM_Specified_Fee__c = 0;
                
                if (q.OB_Weekend_Pickup__c || q.OB_Weekend_Delivery__c)
                    q.OB_Weekend_Fee__c = decimal.valueOf(rates.split(',')[7]);
                else
                    q.OB_Weekend_Fee__c = 0;
                
                if (q.OB_Wait_Time__c)
                    q.OB_Wait_Time_Fee__c = decimal.valueOf(rates.split(',')[8]);
                else
                    q.OB_Wait_Time_Fee__c = 0;
                
                if (q.OB_Additional_Labor__c)
                    q.OB_Additional_Labor_Fee__c = decimal.valueOf(rates.split(',')[9]);
                else
                    q.OB_Additional_Labor_Fee__c = 0;
                
                if (q.OB_Palletization__c)
                    q.OB_Palletization_Fee__c = decimal.valueOf(rates.split(',')[10]);
                else
                    q.OB_Palletization_Fee__c  = 0;
                
                if (q.OB_Attempt__c)            
                    q.OB_Attempt_Fee__c = decimal.valueOf(rates.split(',')[11]);
                else
                    q.OB_Attempt_Fee__c = 0;
                
                if (selection.toUpperCase().startsWith('CO'))
                {
                    q.OB_Total__c = q.OB_Total__c - q.OB_Sub_Total__c - q.OB_Fuel_Surcharge__c; 
                    
                    q.OB_Sub_total__c = (q.OB_Sub_total__c/q.OB_Unit_Price__c) * decimal.valueOf(unitPrice);
                    q.OB_Fuel_Surcharge__c = q.OB_Sub_total__c * q.OB_Fuel_Unit_Surcharge__c;
                    
                    //SFDC-280 - Modify the Total Field to include the NY City Fee and Beyond Point Fee fields - 03/07/24 - Sajid
                    //q.OB_Total__c = q.OB_Total__c + q.OB_Sub_Total__c + q.OB_Fuel_Surcharge__c;
                    Double OBBeyondPointAndNYFees = 0;
                    if(q.OB_Beyond_Point__c != null){
                        OBBeyondPointAndNYFees = q.OB_Beyond_Point_Fee__c;
                    }
                    if(q.OB_NY_City__c){
                        OBBeyondPointAndNYFees += q.OB_New_York_City_Fee__c;
                    }
                    if(OBBeyondPointAndNYFees != null && OBBeyondPointAndNYFees != 0 && OBBeyondPointAndNYFees != 0.00){
                        q.OB_Total__c = q.OB_Total__c + q.OB_Sub_Total__c + q.OB_Fuel_Surcharge__c + OBBeyondPointAndNYFees;
                    }else{
                        q.OB_Total__c = q.OB_Total__c + q.OB_Sub_Total__c + q.OB_Fuel_Surcharge__c;
                    }
                    //End - SFDC-280
                    
                    q.OB_Unit_Price__c = decimal.valueOf(unitPrice);
                }
                
                q.OB_Advance_Order_Discount__c = decimal.valueOf(rates.split(',')[14]);
                q.OB_Round_Trip_Discount__c = decimal.valueOf(rates.split(',')[15]);                
            }
            
            q.Message__c = null;
            
            Database.update(q);  
        }
        catch(Exception e)
        {
            RetVal = e.getMessage();
        }
        finally
        {
            q = null;
        }
        
        return RetVal;
    }
    
    public static LogisticsQuoteGeneratorService.ArrayOfQuoteResponseObject InvokeQuoteRatesService(LogisticsQuoteGeneratorService.QuoteGeneratorWebServiceSoap wsStub, LogisticsQuoteGeneratorService.QuoteRequestObject requestObject)
    {
        return wsStub.GetArrayOfAllQuoteResponseOptionsFromQuoteRequestObject(requestObject);
    }
    
    public static void SetInboundLocalRates(LogisticsQuoteComplexPriceData complexPriceObject, LogisticsQuoteGeneratorService.ArrayOfQuoteResponseObject responseObject, Quote__c q)
    {
        for(LogisticsQuoteGeneratorService.QuoteResponseObject qr : responseObject.QuoteResponseObject)
        {   
             // Local Shipments have the same value for High and Low                
            if (qr.TypeID == 3)
            {
                if (qr.Code == null || qr.Code == '')
                {
                    complexPriceObject.High.Inbound.Local.Detail.UnitPrice = currencyFixed(qr.Rate);
                    complexPriceObject.High.Inbound.Local.Detail.FuelUnitSurcharge = currencyFixed3Digits(qr.FuelSurcharge);
                    complexPriceObject.High.Inbound.Local.Detail.FuelSurcharge = currencyFixed(qr.Fuel);
                    complexPriceObject.High.Inbound.Local.Detail.InsideFee = currencyFixed(qr.InsidePickupFee);
                    complexPriceObject.High.Inbound.Local.Detail.LiftGateFee = currencyFixed(qr.LiftGateFee);
                    complexPriceObject.High.Inbound.Local.Detail.ResidentialFee = currencyFixed(qr.ResidentialPickupFee);                   
                    complexPriceObject.High.Inbound.Local.Detail.AMSpecifiedFee = currencyFixed(qr.AMSpecifiedFee);
                    complexPriceObject.High.Inbound.Local.Detail.WeekendFee = currencyFixed(qr.WeekendFee);
                    complexPriceObject.High.Inbound.Local.Detail.WaitTimeFee = currencyFixed(qr.WaitTimeFee);
                    complexPriceObject.High.Inbound.Local.Detail.AdditionalLaborFee = currencyFixed(qr.AdditionalLaborFee);
                    complexPriceObject.High.Inbound.Local.Detail.PalletizationFee = currencyFixed(qr.PalletizationFee);
                    complexPriceObject.High.Inbound.Local.Detail.AttemptFee = currencyFixed(qr.AttemptFee);                 
                    complexPriceObject.High.Inbound.Local.Detail.SubTotal = currencyFixed(qr.Price);
                    complexPriceObject.High.Inbound.Local.Detail.Total = currencyFixed(qr.Total);
                    complexPriceObject.High.Inbound.Local.Detail.RoundTripDiscountPercent = valueToPercent(qr.roundTripDiscountPercent);
                    complexPriceObject.High.Inbound.Local.Detail.AdvOrderDiscountPercent = valueToPercent(qr.AdvOrderDiscountPercent);
                    
                    Decimal TotalHighDiscountPercent = 0;
                    
                    if (qr.roundTripDiscountPercent != null)
                        TotalHighDiscountPercent = valueToPercent(qr.roundTripDiscountPercent);
                        
                    if (qr.AdvOrderDiscountPercent != null)
                        TotalHighDiscountPercent += valueToPercent(qr.AdvOrderDiscountPercent);
                    
                    complexPriceObject.High.Inbound.Local.Detail.TotalDiscountPercent = TotalHighDiscountPercent;
                    complexPriceObject.High.Inbound.Local.Detail.AdvReceivingEndDate = qr.LastDayAdvRecv;                   
                    
                    complexPriceObject.Low.Inbound.Local.Detail.UnitPrice = currencyFixed(qr.Rate);
                    complexPriceObject.Low.Inbound.Local.Detail.FuelUnitSurcharge = currencyFixed3Digits(qr.FuelSurcharge);
                    complexPriceObject.Low.Inbound.Local.Detail.FuelSurcharge = currencyFixed(qr.Fuel);
                    complexPriceObject.Low.Inbound.Local.Detail.InsideFee = currencyFixed(qr.InsidePickupFee);
                    complexPriceObject.Low.Inbound.Local.Detail.LiftGateFee = currencyFixed(qr.LiftGateFee);
                    complexPriceObject.Low.Inbound.Local.Detail.ResidentialFee = currencyFixed(qr.ResidentialPickupFee);                    
                    complexPriceObject.Low.Inbound.Local.Detail.AMSpecifiedFee = currencyFixed(qr.AMSpecifiedFee);
                    complexPriceObject.Low.Inbound.Local.Detail.WeekendFee = currencyFixed(qr.WeekendFee);
                    complexPriceObject.Low.Inbound.Local.Detail.WaitTimeFee = currencyFixed(qr.WaitTimeFee);
                    complexPriceObject.Low.Inbound.Local.Detail.AdditionalLaborFee = currencyFixed(qr.AdditionalLaborFee);
                    complexPriceObject.Low.Inbound.Local.Detail.PalletizationFee = currencyFixed(qr.PalletizationFee);
                    complexPriceObject.Low.Inbound.Local.Detail.AttemptFee = currencyFixed(qr.AttemptFee);                                      
                    complexPriceObject.Low.Inbound.Local.Detail.SubTotal = currencyFixed(qr.Price);
                    complexPriceObject.Low.Inbound.Local.Detail.Total = currencyFixed(qr.Total);
                    complexPriceObject.Low.Inbound.Local.Detail.RoundTripDiscountPercent = valueToPercent(qr.roundTripDiscountPercent);
                    complexPriceObject.Low.Inbound.Local.Detail.AdvOrderDiscountPercent = valueToPercent(qr.AdvOrderDiscountPercent);
                    
                    Decimal TotalLowDiscountPercent = 0;
                    
                    if (qr.roundTripDiscountPercent != null)
                        TotalLowDiscountPercent = valueToPercent(qr.roundTripDiscountPercent);
                        
                    if (qr.AdvOrderDiscountPercent != null)
                        TotalLowDiscountPercent += valueToPercent(qr.AdvOrderDiscountPercent);
                    
                    complexPriceObject.Low.Inbound.Local.Detail.TotalDiscountPercent = TotalLowDiscountPercent;
                    complexPriceObject.Low.Inbound.Local.Detail.AdvReceivingEndDate = qr.LastDayAdvRecv;                    
                }
                else
                {
                    complexPriceObject.High.Inbound.Local.Detail.DisplayCode = qr.Code;
                    complexPriceObject.Low.Inbound.Local.Detail.DisplayCode = qr.Code;
                    complexPriceObject.High.Inbound.Local.Detail.Comments =  qr.CodeDescr;
                    complexPriceObject.Low.Inbound.Local.Detail.Comments = qr.CodeDescr;
                }               
            }
        }       
    }
    
    public static void SetInboundGroundRates(boolean rateEligible, string ineligitiblityMessage, LogisticsQuoteComplexPriceData complexPriceObject, LogisticsQuoteGeneratorService.ArrayOfQuoteResponseObject responseObject, Quote__c q)
    {
        if (rateEligible)
        {
            for(LogisticsQuoteGeneratorService.QuoteResponseObject qr : responseObject.QuoteResponseObject)
            {   
                // Local Shipments have the same value for High and Low
                // Process High
                if (qr.SelectionID == 2 && qr.TypeID == 1) // Ground Transportation
                {
                    if (qr.Code == null || qr.Code == '')
                    {
                        complexPriceObject.High.Inbound.Ground.Ltl.Detail.UnitPrice = currencyFixed(qr.Rate);
                        complexPriceObject.High.Inbound.Ground.Ltl.Detail.FuelUnitSurcharge = currencyFixed3Digits(qr.FuelSurcharge);
                        complexPriceObject.High.Inbound.Ground.Ltl.Detail.FuelSurcharge = currencyFixed(qr.Fuel);
                        complexPriceObject.High.Inbound.Ground.Ltl.Detail.InsideFee = currencyFixed(qr.InsidePickupFee);
                        complexPriceObject.High.Inbound.Ground.Ltl.Detail.LiftGateFee = currencyFixed(qr.LiftGateFee);
                        complexPriceObject.High.Inbound.Ground.Ltl.Detail.ResidentialFee = currencyFixed(qr.ResidentialPickupFee);                  
                        complexPriceObject.High.Inbound.Ground.Ltl.Detail.AMSpecifiedFee = currencyFixed(qr.AMSpecifiedFee);
                        complexPriceObject.High.Inbound.Ground.Ltl.Detail.WeekendFee = currencyFixed(qr.WeekendFee);
                        complexPriceObject.High.Inbound.Ground.Ltl.Detail.WaitTimeFee = currencyFixed(qr.WaitTimeFee);
                        complexPriceObject.High.Inbound.Ground.Ltl.Detail.AdditionalLaborFee = currencyFixed(qr.AdditionalLaborFee);
                        complexPriceObject.High.Inbound.Ground.Ltl.Detail.PalletizationFee = currencyFixed(qr.PalletizationFee);
                        complexPriceObject.High.Inbound.Ground.Ltl.Detail.AttemptFee = currencyFixed(qr.AttemptFee);
                        complexPriceObject.High.Inbound.Ground.Ltl.Detail.SubTotal = currencyFixed(qr.Price);       
                        complexPriceObject.High.Inbound.Ground.Ltl.Detail.Total = currencyFixed(qr.Total);
                        complexPriceObject.High.Inbound.Ground.Ltl.Detail.RoundTripDiscountPercent = valueToPercent(qr.roundTripDiscountPercent);
                        complexPriceObject.High.Inbound.Ground.Ltl.Detail.AdvOrderDiscountPercent = valueToPercent(qr.AdvOrderDiscountPercent);
                    
                        Decimal TotalLtlHighDiscountPercent = 0;
                        
                        if (qr.roundTripDiscountPercent != null)
                            TotalLtlHighDiscountPercent = valueToPercent(qr.roundTripDiscountPercent);
                            
                        if (qr.AdvOrderDiscountPercent != null)
                            TotalLtlHighDiscountPercent += valueToPercent(qr.AdvOrderDiscountPercent);
                                                
                        complexPriceObject.High.Inbound.Ground.Ltl.Detail.TotalDiscountPercent = TotalLtlHighDiscountPercent;
                        complexPriceObject.High.Inbound.Ground.Ltl.Detail.AdvReceivingEndDate = qr.LastDayAdvRecv;                  
                        
                        complexPriceObject.High.Inbound.Ground.Ftl.Detail.UnitPrice = currencyFixed(qr.Rate);
                        complexPriceObject.High.Inbound.Ground.Ftl.Detail.FuelUnitSurcharge = currencyFixed3Digits(qr.FuelSurcharge);
                        complexPriceObject.High.Inbound.Ground.Ftl.Detail.FuelSurcharge = currencyFixed(qr.FuelSurcharge);
                        complexPriceObject.High.Inbound.Ground.Ftl.Detail.InsideFee = currencyFixed(qr.InsidePickupFee);
                        complexPriceObject.High.Inbound.Ground.Ftl.Detail.LiftGateFee = currencyFixed(qr.LiftGateFee);
                        complexPriceObject.High.Inbound.Ground.Ftl.Detail.ResidentialFee =  currencyFixed(qr.ResidentialPickupFee);
                        complexPriceObject.High.Inbound.Ground.Ftl.Detail.AMSpecifiedFee = currencyFixed(qr.AMSpecifiedFee);
                        complexPriceObject.High.Inbound.Ground.Ftl.Detail.WeekendFee = currencyFixed(qr.WeekendFee);
                        complexPriceObject.High.Inbound.Ground.Ftl.Detail.WaitTimeFee = currencyFixed(qr.WaitTimeFee);
                        complexPriceObject.High.Inbound.Ground.Ftl.Detail.AdditionalLaborFee = currencyFixed(qr.AdditionalLaborFee);
                        complexPriceObject.High.Inbound.Ground.Ftl.Detail.PalletizationFee = currencyFixed(qr.PalletizationFee);
                        complexPriceObject.High.Inbound.Ground.Ftl.Detail.AttemptFee = currencyFixed(qr.AttemptFee);
                        complexPriceObject.High.Inbound.Ground.Ftl.Detail.SubTotal = currencyFixed(qr.Price);       
                        complexPriceObject.High.Inbound.Ground.Ftl.Detail.Total = currencyFixed(qr.Total);
                        complexPriceObject.High.Inbound.Ground.Ftl.Detail.RoundTripDiscountPercent = valueToPercent(qr.roundTripDiscountPercent);
                        complexPriceObject.High.Inbound.Ground.Ftl.Detail.AdvOrderDiscountPercent = valueToPercent(qr.AdvOrderDiscountPercent);
                        
                        Decimal TotalFtlHighDiscountPercent = 0;
                        
                        if (qr.roundTripDiscountPercent != null)
                            TotalFtlHighDiscountPercent = valueToPercent(qr.roundTripDiscountPercent);
                            
                        if (qr.AdvOrderDiscountPercent != null)
                            TotalFtlHighDiscountPercent += valueToPercent(qr.AdvOrderDiscountPercent);
                        
                        complexPriceObject.High.Inbound.Ground.Ftl.Detail.TotalDiscountPercent = TotalFtlHighDiscountPercent;
                        complexPriceObject.High.Inbound.Ground.Ftl.Detail.AdvReceivingEndDate = qr.LastDayAdvRecv;                  
                    }
                    else
                    {
                        complexPriceObject.High.Inbound.Ground.Ltl.Detail.DisplayCode = qr.Code;
                        complexPriceObject.High.Inbound.Ground.Ltl.Detail.Comments =  qr.CodeDescr;                 
                        complexPriceObject.High.Inbound.Ground.Ftl.Detail.DisplayCode = qr.Code;
                        complexPriceObject.High.Inbound.Ground.Ftl.Detail.Comments =  qr.CodeDescr;
                    }                           
                }
                // Process Low
                else if (qr.SelectionID == 1 && qr.TypeID == 1) // Ground Transportation
                {
                    if (qr.Code == null || qr.Code == '')
                    {
                        complexPriceObject.Low.Inbound.Ground.Ltl.Detail.UnitPrice = currencyFixed(qr.Rate);
                        complexPriceObject.Low.Inbound.Ground.Ltl.Detail.FuelUnitSurcharge = currencyFixed3Digits(qr.FuelSurcharge);
                        complexPriceObject.Low.Inbound.Ground.Ltl.Detail.FuelSurcharge = currencyFixed(qr.Fuel);
                        complexPriceObject.Low.Inbound.Ground.Ltl.Detail.InsideFee = currencyFixed(qr.InsidePickupFee);
                        complexPriceObject.Low.Inbound.Ground.Ltl.Detail.LiftGateFee = currencyFixed(qr.LiftGateFee);
                        complexPriceObject.Low.Inbound.Ground.Ltl.Detail.ResidentialFee = currencyFixed(qr.ResidentialPickupFee);                   
                        complexPriceObject.Low.Inbound.Ground.Ltl.Detail.AMSpecifiedFee = currencyFixed(qr.AMSpecifiedFee);
                        complexPriceObject.Low.Inbound.Ground.Ltl.Detail.WeekendFee = currencyFixed(qr.WeekendFee);
                        complexPriceObject.Low.Inbound.Ground.Ltl.Detail.WaitTimeFee = currencyFixed(qr.WaitTimeFee);
                        complexPriceObject.Low.Inbound.Ground.Ltl.Detail.AdditionalLaborFee = currencyFixed(qr.AdditionalLaborFee);
                        complexPriceObject.Low.Inbound.Ground.Ltl.Detail.PalletizationFee = currencyFixed(qr.PalletizationFee);
                        complexPriceObject.Low.Inbound.Ground.Ltl.Detail.AttemptFee = currencyFixed(qr.AttemptFee);
                        complexPriceObject.Low.Inbound.Ground.Ltl.Detail.SubTotal = currencyFixed(qr.Price);        
                        complexPriceObject.Low.Inbound.Ground.Ltl.Detail.Total = currencyFixed(qr.Total);
                        complexPriceObject.Low.Inbound.Ground.Ltl.Detail.RoundTripDiscountPercent = valueToPercent(qr.roundTripDiscountPercent);
                        complexPriceObject.Low.Inbound.Ground.Ltl.Detail.AdvOrderDiscountPercent = valueToPercent(qr.AdvOrderDiscountPercent);
                        
                        Decimal TotalLtlLowDiscountPercent = 0;
                        
                        if (qr.roundTripDiscountPercent != null)
                            TotalLtlLowDiscountPercent = valueToPercent(qr.roundTripDiscountPercent);
                            
                        if (qr.AdvOrderDiscountPercent != null)
                            TotalLtlLowDiscountPercent += valueToPercent(qr.AdvOrderDiscountPercent);
                                                    
                        complexPriceObject.Low.Inbound.Ground.Ltl.Detail.TotalDiscountPercent = TotalLtlLowDiscountPercent;
                        complexPriceObject.Low.Inbound.Ground.Ltl.Detail.AdvReceivingEndDate = qr.LastDayAdvRecv;   
                        
                        complexPriceObject.Low.Inbound.Ground.Ftl.Detail.UnitPrice = currencyFixed(qr.Rate);
                        complexPriceObject.Low.Inbound.Ground.Ftl.Detail.FuelUnitSurcharge = currencyFixed3Digits(qr.FuelSurcharge);
                        complexPriceObject.Low.Inbound.Ground.Ftl.Detail.FuelSurcharge = currencyFixed(qr.Fuel);
                        complexPriceObject.Low.Inbound.Ground.Ftl.Detail.InsideFee = currencyFixed(qr.InsidePickupFee);
                        complexPriceObject.Low.Inbound.Ground.Ftl.Detail.LiftGateFee = currencyFixed(qr.LiftGateFee);
                        complexPriceObject.Low.Inbound.Ground.Ftl.Detail.ResidentialFee = currencyFixed(qr.ResidentialPickupFee);
                        complexPriceObject.Low.Inbound.Ground.Ftl.Detail.AMSpecifiedFee = currencyFixed(qr.AMSpecifiedFee);
                        complexPriceObject.Low.Inbound.Ground.Ftl.Detail.WeekendFee = currencyFixed(qr.WeekendFee);
                        complexPriceObject.Low.Inbound.Ground.Ftl.Detail.WaitTimeFee = currencyFixed(qr.WaitTimeFee);
                        complexPriceObject.Low.Inbound.Ground.Ftl.Detail.AdditionalLaborFee = currencyFixed(qr.AdditionalLaborFee);
                        complexPriceObject.Low.Inbound.Ground.Ftl.Detail.PalletizationFee = currencyFixed(qr.PalletizationFee);
                        complexPriceObject.Low.Inbound.Ground.Ftl.Detail.AttemptFee = currencyFixed(qr.AttemptFee);
                        complexPriceObject.Low.Inbound.Ground.Ftl.Detail.SubTotal = currencyFixed(qr.Price);        
                        complexPriceObject.Low.Inbound.Ground.Ftl.Detail.Total = currencyFixed(qr.Total);
                        complexPriceObject.Low.Inbound.Ground.Ftl.Detail.RoundTripDiscountPercent = valueToPercent(qr.roundTripDiscountPercent);
                        complexPriceObject.Low.Inbound.Ground.Ftl.Detail.AdvOrderDiscountPercent = valueToPercent(qr.AdvOrderDiscountPercent);
                        
                        Decimal TotalFtlLowDiscountPercent = 0;
                        
                        if (qr.roundTripDiscountPercent != null)
                            TotalFtlLowDiscountPercent = valueToPercent(qr.roundTripDiscountPercent);
                            
                        if (qr.AdvOrderDiscountPercent != null)
                            TotalFtlLowDiscountPercent += valueToPercent(qr.AdvOrderDiscountPercent);
                        
                        complexPriceObject.Low.Inbound.Ground.Ftl.Detail.TotalDiscountPercent = TotalFtlLowDiscountPercent;
                        complexPriceObject.Low.Inbound.Ground.Ftl.Detail.AdvReceivingEndDate = qr.LastDayAdvRecv;
                    }
                    else
                    {
                        complexPriceObject.Low.Inbound.Ground.Ltl.Detail.DisplayCode = qr.Code;
                        complexPriceObject.Low.Inbound.Ground.Ltl.Detail.Comments =  qr.CodeDescr;                  
                        complexPriceObject.Low.Inbound.Ground.Ftl.Detail.DisplayCode = qr.Code;
                        complexPriceObject.Low.Inbound.Ground.Ftl.Detail.Comments =  qr.CodeDescr;                          
                    }
                }
            } //end for
        }
        else
        {
            complexPriceObject.High.Inbound.Ground.Ltl.Detail.DisplayCode = 'GD';
            complexPriceObject.High.Inbound.Ground.Ftl.Detail.DisplayCode = 'GD';
            complexPriceObject.Low.Inbound.Ground.Ltl.Detail.DisplayCode = 'GD';
            complexPriceObject.Low.Inbound.Ground.Ftl.Detail.DisplayCode = 'GD';
                                
            complexPriceObject.High.Inbound.Ground.Ltl.Detail.Comments = ineligitiblityMessage;
            complexPriceObject.High.Inbound.Ground.Ftl.Detail.Comments = ineligitiblityMessage;
            complexPriceObject.Low.Inbound.Ground.Ltl.Detail.Comments = ineligitiblityMessage;
            complexPriceObject.Low.Inbound.Ground.Ftl.Detail.Comments = ineligitiblityMessage;
        }       
    }
    
    public static void SetInboundAirRates(boolean rateEligible, string ineligitiblityMessage, LogisticsQuoteComplexPriceData complexPriceObject, LogisticsQuoteGeneratorService.ArrayOfQuoteResponseObject responseObject, Quote__c q)
    {
        
        if (rateEligible)
        {       
            for(LogisticsQuoteGeneratorService.QuoteResponseObject qr : responseObject.QuoteResponseObject)
            {   
                // Process High
                if (qr.SelectionID == 2 && qr.TypeID == 2)
                {
                    if (qr.ClassOfServiceID == 1) // Next Day
                    {
                        if (qr.Code == null || qr.Code == '')
                        {
                            complexPriceObject.High.Inbound.Air.AirNextDay.Detail.UnitPrice = currencyFixed(qr.Rate);
                            complexPriceObject.High.Inbound.Air.AirNextDay.Detail.FuelUnitSurcharge = currencyFixed3Digits(qr.FuelSurcharge);
                            complexPriceObject.High.Inbound.Air.AirNextDay.Detail.FuelSurcharge = currencyFixed(qr.Fuel);
                            complexPriceObject.High.Inbound.Air.AirNextDay.Detail.InsideFee = currencyFixed(qr.InsidePickupFee);
                            complexPriceObject.High.Inbound.Air.AirNextDay.Detail.LiftGateFee = currencyFixed(qr.LiftGateFee);
                            complexPriceObject.High.Inbound.Air.AirNextDay.Detail.ResidentialFee = currencyFixed(qr.ResidentialPickupFee);
                            complexPriceObject.High.Inbound.Air.AirNextDay.Detail.AMSpecifiedFee = currencyFixed(qr.AMSpecifiedFee);
                            complexPriceObject.High.Inbound.Air.AirNextDay.Detail.WeekendFee = currencyFixed(qr.WeekendFee);
                            complexPriceObject.High.Inbound.Air.AirNextDay.Detail.WaitTimeFee = currencyFixed(qr.WaitTimeFee);
                            complexPriceObject.High.Inbound.Air.AirNextDay.Detail.AdditionalLaborFee = currencyFixed(qr.AdditionalLaborFee);
                            complexPriceObject.High.Inbound.Air.AirNextDay.Detail.PalletizationFee = currencyFixed(qr.PalletizationFee);
                            complexPriceObject.High.Inbound.Air.AirNextDay.Detail.AttemptFee = currencyFixed(qr.AttemptFee);                    
                            complexPriceObject.High.Inbound.Air.AirNextDay.Detail.SubTotal = currencyFixed(qr.Price);       
                            complexPriceObject.High.Inbound.Air.AirNextDay.Detail.Total = currencyFixed(qr.Total);
                            complexPriceObject.High.Inbound.Air.AirNextDay.Detail.RoundTripDiscountPercent = valueToPercent(qr.roundTripDiscountPercent);
                            complexPriceObject.High.Inbound.Air.AirNextDay.Detail.AdvOrderDiscountPercent = valueToPercent(qr.AdvOrderDiscountPercent);
                            
                            Decimal TotalAirNextDayHighDiscountPercent = 0;
                            
                            if (qr.roundTripDiscountPercent != null)
                                TotalAirNextDayHighDiscountPercent = valueToPercent(qr.roundTripDiscountPercent);
                                
                            if (qr.AdvOrderDiscountPercent != null)
                                TotalAirNextDayHighDiscountPercent += valueToPercent(qr.AdvOrderDiscountPercent);                           
                            
                            complexPriceObject.High.Inbound.Air.AirNextDay.Detail.TotalDiscountPercent = TotalAirNextDayHighDiscountPercent;
                            complexPriceObject.High.Inbound.Air.AirNextDay.Detail.AdvReceivingEndDate = qr.LastDayAdvRecv;
                        }
                        else
                        {
                            complexPriceObject.High.Inbound.Air.AirNextDay.Detail.DisplayCode = qr.Code;
                            complexPriceObject.High.Inbound.Air.AirNextDay.Detail.Comments = qr.CodeDescr;
                        }                       
                    }
                    else if (qr.ClassOfServiceID == 2) // 2nd Day
                    {
                        if (qr.Code == null || qr.Code == '')
                        {
                            complexPriceObject.High.Inbound.Air.Air2ndDay.Detail.UnitPrice = currencyFixed(qr.Rate);
                            complexPriceObject.High.Inbound.Air.Air2ndDay.Detail.FuelUnitSurcharge = currencyFixed3Digits(qr.FuelSurcharge);
                            complexPriceObject.High.Inbound.Air.Air2ndDay.Detail.FuelSurcharge = currencyFixed(qr.Fuel);
                            complexPriceObject.High.Inbound.Air.Air2ndDay.Detail.InsideFee = currencyFixed(qr.InsidePickupFee);
                            complexPriceObject.High.Inbound.Air.Air2ndDay.Detail.LiftGateFee = currencyFixed(qr.LiftGateFee);
                            complexPriceObject.High.Inbound.Air.Air2ndDay.Detail.ResidentialFee = currencyFixed(qr.ResidentialPickupFee);
                            complexPriceObject.High.Inbound.Air.Air2ndDay.Detail.AMSpecifiedFee = currencyFixed(qr.AMSpecifiedFee);
                            complexPriceObject.High.Inbound.Air.Air2ndDay.Detail.WeekendFee = currencyFixed(qr.WeekendFee);
                            complexPriceObject.High.Inbound.Air.Air2ndDay.Detail.WaitTimeFee = currencyFixed(qr.WaitTimeFee);
                            complexPriceObject.High.Inbound.Air.Air2ndDay.Detail.AdditionalLaborFee = currencyFixed(qr.AdditionalLaborFee);
                            complexPriceObject.High.Inbound.Air.Air2ndDay.Detail.PalletizationFee = currencyFixed(qr.PalletizationFee);
                            complexPriceObject.High.Inbound.Air.Air2ndDay.Detail.AttemptFee = currencyFixed(qr.AttemptFee);                 
                            complexPriceObject.High.Inbound.Air.Air2ndDay.Detail.SubTotal = currencyFixed(qr.Price);    
                            complexPriceObject.High.Inbound.Air.Air2ndDay.Detail.Total = currencyFixed(qr.Total);
                            complexPriceObject.High.Inbound.Air.Air2ndDay.Detail.RoundTripDiscountPercent = valueToPercent(qr.roundTripDiscountPercent);
                            complexPriceObject.High.Inbound.Air.Air2ndDay.Detail.AdvOrderDiscountPercent = valueToPercent(qr.AdvOrderDiscountPercent);
                            
                            Decimal TotalAir2ndDayHighDiscountPercent = 0;
                            
                            if (qr.roundTripDiscountPercent != null)
                                TotalAir2ndDayHighDiscountPercent = valueToPercent(qr.roundTripDiscountPercent);
                                
                            if (qr.AdvOrderDiscountPercent != null)
                                TotalAir2ndDayHighDiscountPercent += valueToPercent(qr.AdvOrderDiscountPercent);
                                                        
                            complexPriceObject.High.Inbound.Air.Air2ndDay.Detail.TotalDiscountPercent = TotalAir2ndDayHighDiscountPercent;
                            complexPriceObject.High.Inbound.Air.Air2ndDay.Detail.AdvReceivingEndDate = qr.LastDayAdvRecv;
                        }
                        else
                        {
                            complexPriceObject.High.Inbound.Air.Air2ndDay.Detail.DisplayCode = qr.Code;
                            complexPriceObject.High.Inbound.Air.Air2ndDay.Detail.Comments = qr.CodeDescr;
                        }
                    }               
                }
                // Process Low
                else if (qr.SelectionID == 1 && qr.TypeID == 2)
                {
                    if (qr.ClassOfServiceID == 1) // Next Day
                    {
                        if (qr.Code == null || qr.Code == '')
                        {                       
                            complexPriceObject.Low.Inbound.Air.AirNextDay.Detail.UnitPrice = currencyFixed(qr.Rate);
                            complexPriceObject.Low.Inbound.Air.AirNextDay.Detail.FuelUnitSurcharge = currencyFixed3Digits(qr.FuelSurcharge);
                            complexPriceObject.Low.Inbound.Air.AirNextDay.Detail.FuelSurcharge = currencyFixed(qr.Fuel);
                            complexPriceObject.Low.Inbound.Air.AirNextDay.Detail.InsideFee = currencyFixed(qr.InsidePickupFee);
                            complexPriceObject.Low.Inbound.Air.AirNextDay.Detail.LiftGateFee = currencyFixed(qr.LiftGateFee);
                            complexPriceObject.Low.Inbound.Air.AirNextDay.Detail.ResidentialFee = currencyFixed(qr.ResidentialPickupFee);
                            complexPriceObject.Low.Inbound.Air.AirNextDay.Detail.AMSpecifiedFee = currencyFixed(qr.AMSpecifiedFee);
                            complexPriceObject.Low.Inbound.Air.AirNextDay.Detail.WeekendFee = currencyFixed(qr.WeekendFee);
                            complexPriceObject.Low.Inbound.Air.AirNextDay.Detail.WaitTimeFee = currencyFixed(qr.WaitTimeFee);
                            complexPriceObject.Low.Inbound.Air.AirNextDay.Detail.AdditionalLaborFee = currencyFixed(qr.AdditionalLaborFee);
                            complexPriceObject.Low.Inbound.Air.AirNextDay.Detail.PalletizationFee = currencyFixed(qr.PalletizationFee);
                            complexPriceObject.Low.Inbound.Air.AirNextDay.Detail.AttemptFee = currencyFixed(qr.AttemptFee);                     
                            complexPriceObject.Low.Inbound.Air.AirNextDay.Detail.SubTotal = currencyFixed(qr.Price);        
                            complexPriceObject.Low.Inbound.Air.AirNextDay.Detail.Total = currencyFixed(qr.Total);
                            complexPriceObject.Low.Inbound.Air.AirNextDay.Detail.RoundTripDiscountPercent = valueToPercent(qr.roundTripDiscountPercent);
                            complexPriceObject.Low.Inbound.Air.AirNextDay.Detail.AdvOrderDiscountPercent = valueToPercent(qr.AdvOrderDiscountPercent);
                            
                            Decimal TotalAirNextDayLowDiscountPercent = 0;
                            
                            if (qr.roundTripDiscountPercent != null)
                                TotalAirNextDayLowDiscountPercent = valueToPercent(qr.roundTripDiscountPercent);
                                
                            if (qr.AdvOrderDiscountPercent != null)
                                TotalAirNextDayLowDiscountPercent += valueToPercent(qr.AdvOrderDiscountPercent);
                                                            
                            complexPriceObject.Low.Inbound.Air.AirNextDay.Detail.TotalDiscountPercent = TotalAirNextDayLowDiscountPercent;
                            complexPriceObject.Low.Inbound.Air.AirNextDay.Detail.AdvReceivingEndDate = qr.LastDayAdvRecv;
                        }
                        else
                        {
                            complexPriceObject.Low.Inbound.Air.AirNextDay.Detail.DisplayCode = qr.Code;
                            complexPriceObject.Low.Inbound.Air.AirNextDay.Detail.Comments = qr.CodeDescr;                           
                        }                       
                    }
                    else if (qr.ClassOfServiceID == 2) // 2nd Day
                    {
                        if (qr.Code == null || qr.Code == '')
                        {                           
                            complexPriceObject.Low.Inbound.Air.Air2ndDay.Detail.UnitPrice = currencyFixed(qr.Rate);
                            complexPriceObject.Low.Inbound.Air.Air2ndDay.Detail.FuelUnitSurcharge = currencyFixed3Digits(qr.FuelSurcharge);
                            complexPriceObject.Low.Inbound.Air.Air2ndDay.Detail.FuelSurcharge = currencyFixed(qr.Fuel);
                            complexPriceObject.Low.Inbound.Air.Air2ndDay.Detail.InsideFee = currencyFixed(qr.InsidePickupFee);
                            complexPriceObject.Low.Inbound.Air.Air2ndDay.Detail.LiftGateFee = currencyFixed(qr.LiftGateFee);
                            complexPriceObject.Low.Inbound.Air.Air2ndDay.Detail.ResidentialFee = currencyFixed(qr.ResidentialPickupFee);
                            complexPriceObject.Low.Inbound.Air.Air2ndDay.Detail.AMSpecifiedFee = currencyFixed(qr.AMSpecifiedFee);
                            complexPriceObject.Low.Inbound.Air.Air2ndDay.Detail.WeekendFee = currencyFixed(qr.WeekendFee);
                            complexPriceObject.Low.Inbound.Air.Air2ndDay.Detail.WaitTimeFee = currencyFixed(qr.WaitTimeFee);
                            complexPriceObject.Low.Inbound.Air.Air2ndDay.Detail.AdditionalLaborFee = currencyFixed(qr.AdditionalLaborFee);
                            complexPriceObject.Low.Inbound.Air.Air2ndDay.Detail.PalletizationFee = currencyFixed(qr.PalletizationFee);
                            complexPriceObject.Low.Inbound.Air.Air2ndDay.Detail.AttemptFee = currencyFixed(qr.AttemptFee);                  
                            complexPriceObject.Low.Inbound.Air.Air2ndDay.Detail.SubTotal = currencyFixed(qr.Price);     
                            complexPriceObject.Low.Inbound.Air.Air2ndDay.Detail.Total = currencyFixed(qr.Total);
                            complexPriceObject.Low.Inbound.Air.Air2ndDay.Detail.RoundTripDiscountPercent = valueToPercent(qr.roundTripDiscountPercent);
                            complexPriceObject.Low.Inbound.Air.Air2ndDay.Detail.AdvOrderDiscountPercent = valueToPercent(qr.AdvOrderDiscountPercent);
                            
                            Decimal TotalAir2ndDayLowDiscountPercent = 0;
                            
                            if (qr.roundTripDiscountPercent != null)
                                TotalAir2ndDayLowDiscountPercent = valueToPercent(qr.roundTripDiscountPercent);
                                
                            if (qr.AdvOrderDiscountPercent != null)
                                TotalAir2ndDayLowDiscountPercent += valueToPercent(qr.AdvOrderDiscountPercent);
                                                            
                            complexPriceObject.Low.Inbound.Air.Air2ndDay.Detail.TotalDiscountPercent = TotalAir2ndDayLowDiscountPercent;
                            complexPriceObject.Low.Inbound.Air.Air2ndDay.Detail.AdvReceivingEndDate = qr.LastDayAdvRecv;
                        }
                        else
                        {
                            complexPriceObject.Low.Inbound.Air.Air2ndDay.Detail.DisplayCode = qr.Code;
                            complexPriceObject.Low.Inbound.Air.Air2ndDay.Detail.Comments = qr.CodeDescr;                            
                        }
                    }               
                }   
            }  //end for
        }
        else
        {
            complexPriceObject.High.Inbound.Air.AirNextDay.Detail.DisplayCode = 'AD';
            complexPriceObject.High.Inbound.Air.Air2ndDay.Detail.DisplayCode = 'AD';
            complexPriceObject.Low.Inbound.Air.AirNextDay.Detail.DisplayCode = 'AD';
            complexPriceObject.Low.Inbound.Air.Air2ndDay.Detail.DisplayCode = 'AD';
                                
            complexPriceObject.High.Inbound.Air.AirNextDay.Detail.Comments = ineligitiblityMessage;
            complexPriceObject.High.Inbound.Air.Air2ndDay.Detail.Comments = ineligitiblityMessage;
            complexPriceObject.Low.Inbound.Air.AirNextDay.Detail.Comments = ineligitiblityMessage;
            complexPriceObject.Low.Inbound.Air.Air2ndDay.Detail.Comments = ineligitiblityMessage;
        }

    }   
    
    public static void SetOutboundLocalRates(LogisticsQuoteComplexPriceData complexPriceObject, LogisticsQuoteGeneratorService.ArrayOfQuoteResponseObject responseObject, Quote__c q)
    {
        for(LogisticsQuoteGeneratorService.QuoteResponseObject qr : responseObject.QuoteResponseObject)
        {   
            // Local Shipments have the same value for High and Low             
            if (qr.TypeID == 3)
            {
                if (qr.Code == null || qr.Code == '')
                {
                    complexPriceObject.High.Outbound.Local.Detail.UnitPrice = currencyFixed(qr.Rate);
                    complexPriceObject.High.Outbound.Local.Detail.FuelUnitSurcharge = currencyFixed3Digits(qr.FuelSurcharge);
                    complexPriceObject.High.Outbound.Local.Detail.FuelSurcharge = currencyFixed(qr.Fuel);
                    complexPriceObject.High.Outbound.Local.Detail.InsideFee = currencyFixed(qr.InsidePickupFee);
                    complexPriceObject.High.Outbound.Local.Detail.LiftGateFee = currencyFixed(qr.LiftGateFee);
                    complexPriceObject.High.Outbound.Local.Detail.ResidentialFee = currencyFixed(qr.ResidentialPickupFee);                  
                    complexPriceObject.High.Outbound.Local.Detail.AMSpecifiedFee = currencyFixed(qr.AMSpecifiedFee);
                    complexPriceObject.High.Outbound.Local.Detail.WeekendFee = currencyFixed(qr.WeekendFee);
                    complexPriceObject.High.Outbound.Local.Detail.WaitTimeFee = currencyFixed(qr.WaitTimeFee);
                    complexPriceObject.High.Outbound.Local.Detail.AdditionalLaborFee = currencyFixed(qr.AdditionalLaborFee);
                    complexPriceObject.High.Outbound.Local.Detail.PalletizationFee = currencyFixed(qr.PalletizationFee);
                    complexPriceObject.High.Outbound.Local.Detail.AttemptFee = currencyFixed(qr.AttemptFee);                    
                    complexPriceObject.High.Outbound.Local.Detail.SubTotal = currencyFixed(qr.Price);
                    complexPriceObject.High.Outbound.Local.Detail.Total = currencyFixed(qr.Total);
                    complexPriceObject.High.Outbound.Local.Detail.RoundTripDiscountPercent = valueToPercent(qr.roundTripDiscountPercent);
                    complexPriceObject.High.Outbound.Local.Detail.AdvOrderDiscountPercent = valueToPercent(qr.AdvOrderDiscountPercent);
                    
                    Decimal TotalHighDiscountPercent = 0;
                    
                    if (qr.roundTripDiscountPercent != null)
                        TotalHighDiscountPercent = valueToPercent(qr.roundTripDiscountPercent);
                        
                    if (qr.AdvOrderDiscountPercent != null)
                        TotalHighDiscountPercent += valueToPercent(qr.AdvOrderDiscountPercent);
                                            
                    complexPriceObject.High.Outbound.Local.Detail.TotalDiscountPercent = TotalHighDiscountPercent;
                    complexPriceObject.High.Outbound.Local.Detail.AdvReceivingEndDate = qr.LastDayAdvRecv;                  
                    
                    complexPriceObject.Low.Outbound.Local.Detail.UnitPrice = currencyFixed(qr.Rate);
                    complexPriceObject.Low.Outbound.Local.Detail.FuelUnitSurcharge = currencyFixed3Digits(qr.FuelSurcharge);
                    complexPriceObject.Low.Outbound.Local.Detail.FuelSurcharge = currencyFixed(qr.Fuel);
                    complexPriceObject.Low.Outbound.Local.Detail.InsideFee = currencyFixed(qr.InsidePickupFee);
                    complexPriceObject.Low.Outbound.Local.Detail.LiftGateFee = currencyFixed(qr.LiftGateFee);
                    complexPriceObject.Low.Outbound.Local.Detail.ResidentialFee = currencyFixed(qr.ResidentialPickupFee);                   
                    complexPriceObject.Low.Outbound.Local.Detail.AMSpecifiedFee = currencyFixed(qr.AMSpecifiedFee);
                    complexPriceObject.Low.Outbound.Local.Detail.WeekendFee = currencyFixed(qr.WeekendFee);
                    complexPriceObject.Low.Outbound.Local.Detail.WaitTimeFee = currencyFixed(qr.WaitTimeFee);
                    complexPriceObject.Low.Outbound.Local.Detail.AdditionalLaborFee = currencyFixed(qr.AdditionalLaborFee);
                    complexPriceObject.Low.Outbound.Local.Detail.PalletizationFee = currencyFixed(qr.PalletizationFee);
                    complexPriceObject.Low.Outbound.Local.Detail.AttemptFee = currencyFixed(qr.AttemptFee);                                     
                    complexPriceObject.Low.Outbound.Local.Detail.SubTotal = currencyFixed(qr.Price);
                    complexPriceObject.Low.Outbound.Local.Detail.Total = currencyFixed(qr.Total);
                    complexPriceObject.Low.Outbound.Local.Detail.RoundTripDiscountPercent = valueToPercent(qr.roundTripDiscountPercent);
                    complexPriceObject.Low.Outbound.Local.Detail.AdvOrderDiscountPercent = valueToPercent(qr.AdvOrderDiscountPercent);
                    
                    Decimal TotalLowDiscountPercent = 0;
                    
                    if (qr.roundTripDiscountPercent != null)
                        TotalLowDiscountPercent = valueToPercent(qr.roundTripDiscountPercent);
                        
                    if (qr.AdvOrderDiscountPercent != null)
                        TotalLowDiscountPercent += valueToPercent(qr.AdvOrderDiscountPercent);
                                            
                    complexPriceObject.Low.Outbound.Local.Detail.TotalDiscountPercent = TotalLowDiscountPercent;
                    complexPriceObject.Low.Outbound.Local.Detail.AdvReceivingEndDate = qr.LastDayAdvRecv;                   
                }
                else
                {
                    complexPriceObject.High.Outbound.Local.Detail.DisplayCode = qr.Code;
                    complexPriceObject.Low.Outbound.Local.Detail.DisplayCode = qr.Code;
                    complexPriceObject.High.Outbound.Local.Detail.Comments =  qr.CodeDescr;
                    complexPriceObject.Low.Outbound.Local.Detail.Comments = qr.CodeDescr;
                }               
            }
        }       
    }
        
    public static void SetOutboundGroundRates(boolean rateEligible, string ineligitiblityMessage, LogisticsQuoteComplexPriceData complexPriceObject, LogisticsQuoteGeneratorService.ArrayOfQuoteResponseObject responseObject, Quote__c q)
    {
        if (rateEligible)
        {
            for(LogisticsQuoteGeneratorService.QuoteResponseObject qr : responseObject.QuoteResponseObject)
            {   
                // Local Shipment (Note: Local Shipments have only 1 rates i.e. same value for High and Low)
                if (qr.TypeID == 1 && qr.SelectionID == 2) // Ground Transportation (High)
                {
                    if (qr.Code == null || qr.Code == '')
                    {
                        complexPriceObject.High.Outbound.Ground.Ltl.Detail.UnitPrice = currencyFixed(qr.Rate);
                        complexPriceObject.High.Outbound.Ground.Ltl.Detail.FuelUnitSurcharge = currencyFixed3Digits(qr.FuelSurcharge);
                        complexPriceObject.High.Outbound.Ground.Ltl.Detail.FuelSurcharge = currencyFixed(qr.Fuel);
                        complexPriceObject.High.Outbound.Ground.Ltl.Detail.InsideFee = currencyFixed(qr.InsidePickupFee);
                        complexPriceObject.High.Outbound.Ground.Ltl.Detail.LiftGateFee = currencyFixed(qr.LiftGateFee);
                        complexPriceObject.High.Outbound.Ground.Ltl.Detail.ResidentialFee =  currencyFixed(qr.ResidentialPickupFee);
                        complexPriceObject.High.Outbound.Ground.Ltl.Detail.AMSpecifiedFee = currencyFixed(qr.AMSpecifiedFee);
                        complexPriceObject.High.Outbound.Ground.Ltl.Detail.WeekendFee = currencyFixed(qr.WeekendFee);
                        complexPriceObject.High.Outbound.Ground.Ltl.Detail.WaitTimeFee = currencyFixed(qr.WaitTimeFee);
                        complexPriceObject.High.Outbound.Ground.Ltl.Detail.AdditionalLaborFee = currencyFixed(qr.AdditionalLaborFee);
                        complexPriceObject.High.Outbound.Ground.Ltl.Detail.PalletizationFee = currencyFixed(qr.PalletizationFee);
                        complexPriceObject.High.Outbound.Ground.Ltl.Detail.AttemptFee = currencyFixed(qr.AttemptFee);
                        complexPriceObject.High.Outbound.Ground.Ltl.Detail.SubTotal = currencyFixed(qr.Price);      
                        complexPriceObject.High.Outbound.Ground.Ltl.Detail.Total = currencyFixed(qr.Total);
                        complexPriceObject.High.Outbound.Ground.Ltl.Detail.RoundTripDiscountPercent = valueToPercent(qr.roundTripDiscountPercent);
                        complexPriceObject.High.Outbound.Ground.Ltl.Detail.AdvOrderDiscountPercent = valueToPercent(qr.AdvOrderDiscountPercent);
                        
                        Decimal TotalLtlHighDiscountPercent = 0;
                        
                        if (qr.roundTripDiscountPercent != null)
                            TotalLtlHighDiscountPercent = valueToPercent(qr.roundTripDiscountPercent);
                            
                        if (qr.AdvOrderDiscountPercent != null)
                            TotalLtlHighDiscountPercent += valueToPercent(qr.AdvOrderDiscountPercent);
                                                    
                        complexPriceObject.High.Outbound.Ground.Ltl.Detail.TotalDiscountPercent = TotalLtlHighDiscountPercent;
                        complexPriceObject.High.Outbound.Ground.Ltl.Detail.AdvReceivingEndDate = qr.LastDayAdvRecv; 
        
                        complexPriceObject.High.Outbound.Ground.Ftl.Detail.UnitPrice = currencyFixed(qr.Rate);
                        complexPriceObject.High.Outbound.Ground.Ftl.Detail.FuelUnitSurcharge = currencyFixed3Digits(qr.FuelSurcharge);
                        complexPriceObject.High.Outbound.Ground.Ftl.Detail.FuelSurcharge = currencyFixed(qr.Fuel);
                        complexPriceObject.High.Outbound.Ground.Ftl.Detail.InsideFee= currencyFixed(qr.InsidePickupFee);
                        complexPriceObject.High.Outbound.Ground.Ftl.Detail.LiftGateFee = currencyFixed(qr.LiftGateFee);
                        complexPriceObject.High.Outbound.Ground.Ftl.Detail.ResidentialFee =  currencyFixed(qr.ResidentialPickupFee);
                        complexPriceObject.High.Outbound.Ground.Ftl.Detail.AMSpecifiedFee = currencyFixed(qr.AMSpecifiedFee);
                        complexPriceObject.High.Outbound.Ground.Ftl.Detail.WeekendFee = currencyFixed(qr.WeekendFee);
                        complexPriceObject.High.Outbound.Ground.Ftl.Detail.WaitTimeFee = currencyFixed(qr.WaitTimeFee);
                        complexPriceObject.High.Outbound.Ground.Ftl.Detail.AdditionalLaborFee = currencyFixed(qr.AdditionalLaborFee);
                        complexPriceObject.High.Outbound.Ground.Ftl.Detail.PalletizationFee = currencyFixed(qr.PalletizationFee);
                        complexPriceObject.High.Outbound.Ground.Ftl.Detail.AttemptFee = currencyFixed(qr.AttemptFee);
                        complexPriceObject.High.Outbound.Ground.Ftl.Detail.SubTotal = currencyFixed(qr.Price);      
                        complexPriceObject.High.Outbound.Ground.Ftl.Detail.Total = currencyFixed(qr.Total);
                        complexPriceObject.High.Outbound.Ground.Ftl.Detail.RoundTripDiscountPercent = valueToPercent(qr.roundTripDiscountPercent);
                        complexPriceObject.High.Outbound.Ground.Ftl.Detail.AdvOrderDiscountPercent = valueToPercent(qr.AdvOrderDiscountPercent);
                        
                        Decimal TotalFtlHighDiscountPercent = 0;
                        
                        if (qr.roundTripDiscountPercent != null)
                            TotalFtlHighDiscountPercent = valueToPercent(qr.roundTripDiscountPercent);
                            
                        if (qr.AdvOrderDiscountPercent != null)
                            TotalFtlHighDiscountPercent += valueToPercent(qr.AdvOrderDiscountPercent);
                                                    
                        complexPriceObject.High.Outbound.Ground.Ftl.Detail.TotalDiscountPercent = TotalFtlHighDiscountPercent;
                        complexPriceObject.High.Outbound.Ground.Ftl.Detail.AdvReceivingEndDate = qr.LastDayAdvRecv;                     
                    }
                    else
                    {
                        complexPriceObject.High.Outbound.Ground.Ltl.Detail.DisplayCode = qr.Code;
                        complexPriceObject.High.Outbound.Ground.Ltl.Detail.Comments =  qr.CodeDescr;                    
                        complexPriceObject.High.Outbound.Ground.Ftl.Detail.DisplayCode = qr.Code;
                        complexPriceObject.High.Outbound.Ground.Ftl.Detail.Comments =  qr.CodeDescr;
                    }
                }
                else if (qr.TypeID == 1 && qr.SelectionID == 1) // Ground Transportation (Low)
                {
                    if (qr.Code == null || qr.Code == '')
                    {               
                        complexPriceObject.Low.Outbound.Ground.Ltl.Detail.UnitPrice = currencyFixed(qr.Rate);
                        complexPriceObject.Low.Outbound.Ground.Ltl.Detail.FuelUnitSurcharge = currencyFixed3Digits(qr.FuelSurcharge);
                        complexPriceObject.Low.Outbound.Ground.Ltl.Detail.FuelSurcharge = currencyFixed(qr.Fuel);
                        complexPriceObject.Low.Outbound.Ground.Ltl.Detail.InsideFee = currencyFixed(qr.InsidePickupFee);
                        complexPriceObject.Low.Outbound.Ground.Ltl.Detail.LiftGateFee = currencyFixed(qr.LiftGateFee);
                        complexPriceObject.Low.Outbound.Ground.Ltl.Detail.ResidentialFee =  currencyFixed(qr.ResidentialPickupFee);
                        complexPriceObject.Low.Outbound.Ground.Ltl.Detail.AMSpecifiedFee = currencyFixed(qr.AMSpecifiedFee);
                        complexPriceObject.Low.Outbound.Ground.Ltl.Detail.WeekendFee = currencyFixed(qr.WeekendFee);
                        complexPriceObject.Low.Outbound.Ground.Ltl.Detail.WaitTimeFee = currencyFixed(qr.WaitTimeFee);
                        complexPriceObject.Low.Outbound.Ground.Ltl.Detail.AdditionalLaborFee = currencyFixed(qr.AdditionalLaborFee);
                        complexPriceObject.Low.Outbound.Ground.Ltl.Detail.PalletizationFee = currencyFixed(qr.PalletizationFee);
                        complexPriceObject.Low.Outbound.Ground.Ltl.Detail.AttemptFee = currencyFixed(qr.AttemptFee);            
                        complexPriceObject.Low.Outbound.Ground.Ltl.Detail.SubTotal = currencyFixed(qr.Price);       
                        complexPriceObject.Low.Outbound.Ground.Ltl.Detail.Total = currencyFixed(qr.Total);
                        complexPriceObject.Low.Outbound.Ground.Ltl.Detail.RoundTripDiscountPercent = valueToPercent(qr.roundTripDiscountPercent);
                        complexPriceObject.Low.Outbound.Ground.Ltl.Detail.AdvOrderDiscountPercent = valueToPercent(qr.AdvOrderDiscountPercent);
                        
                        Decimal TotalLtlLowDiscountPercent = 0;
                        
                        if (qr.roundTripDiscountPercent != null)
                            TotalLtlLowDiscountPercent = valueToPercent(qr.roundTripDiscountPercent);
                            
                        if (qr.AdvOrderDiscountPercent != null)
                            TotalLtlLowDiscountPercent += valueToPercent(qr.AdvOrderDiscountPercent);
                                                    
                        complexPriceObject.Low.Outbound.Ground.Ltl.Detail.TotalDiscountPercent = TotalLtlLowDiscountPercent;
                        complexPriceObject.Low.Outbound.Ground.Ltl.Detail.AdvReceivingEndDate = qr.LastDayAdvRecv;                  
        
                        complexPriceObject.Low.Outbound.Ground.Ftl.Detail.UnitPrice = currencyFixed(qr.Rate);
                        complexPriceObject.Low.Outbound.Ground.Ftl.Detail.FuelUnitSurcharge = currencyFixed3Digits(qr.FuelSurcharge);
                        complexPriceObject.Low.Outbound.Ground.Ftl.Detail.FuelSurcharge = currencyFixed(qr.Fuel);
                        complexPriceObject.Low.Outbound.Ground.Ftl.Detail.InsideFee = currencyFixed(qr.InsidePickupFee);
                        complexPriceObject.Low.Outbound.Ground.Ftl.Detail.LiftGateFee = currencyFixed(qr.LiftGateFee);
                        complexPriceObject.Low.Outbound.Ground.Ftl.Detail.ResidentialFee =  currencyFixed(qr.ResidentialPickupFee);
                        complexPriceObject.Low.Outbound.Ground.Ftl.Detail.AMSpecifiedFee = currencyFixed(qr.AMSpecifiedFee);
                        complexPriceObject.Low.Outbound.Ground.Ftl.Detail.WeekendFee = currencyFixed(qr.WeekendFee);
                        complexPriceObject.Low.Outbound.Ground.Ftl.Detail.WaitTimeFee = currencyFixed(qr.WaitTimeFee);
                        complexPriceObject.Low.Outbound.Ground.Ftl.Detail.AdditionalLaborFee = currencyFixed(qr.AdditionalLaborFee);
                        complexPriceObject.Low.Outbound.Ground.Ftl.Detail.PalletizationFee = currencyFixed(qr.PalletizationFee);
                        complexPriceObject.Low.Outbound.Ground.Ftl.Detail.AttemptFee = currencyFixed(qr.AttemptFee);
                        complexPriceObject.Low.Outbound.Ground.Ftl.Detail.SubTotal = currencyFixed(qr.Price);       
                        complexPriceObject.Low.Outbound.Ground.Ftl.Detail.Total = currencyFixed(qr.Total);
                        complexPriceObject.Low.Outbound.Ground.Ftl.Detail.RoundTripDiscountPercent = valueToPercent(qr.roundTripDiscountPercent);
                        complexPriceObject.Low.Outbound.Ground.Ftl.Detail.AdvOrderDiscountPercent = valueToPercent(qr.AdvOrderDiscountPercent);
                        
                        Decimal TotalFtlLowDiscountPercent = 0;
                        
                        if (qr.roundTripDiscountPercent != null)
                            TotalFtlLowDiscountPercent = valueToPercent(qr.roundTripDiscountPercent);
                            
                        if (qr.AdvOrderDiscountPercent != null)
                            TotalFtlLowDiscountPercent += valueToPercent(qr.AdvOrderDiscountPercent);
                                                    
                        complexPriceObject.Low.Outbound.Ground.Ftl.Detail.TotalDiscountPercent = TotalFtlLowDiscountPercent;
                        complexPriceObject.Low.Outbound.Ground.Ftl.Detail.AdvReceivingEndDate = qr.LastDayAdvRecv;
                    }
                    else
                    {
                        complexPriceObject.Low.Outbound.Ground.Ltl.Detail.DisplayCode = qr.Code;
                        complexPriceObject.Low.Outbound.Ground.Ltl.Detail.Comments =  qr.CodeDescr;                 
                        complexPriceObject.Low.Outbound.Ground.Ftl.Detail.DisplayCode = qr.Code;
                        complexPriceObject.Low.Outbound.Ground.Ftl.Detail.Comments =  qr.CodeDescr;                     
                    }                           
                }
            } //end for
        }
        else
        {
            complexPriceObject.High.Outbound.Ground.Ltl.Detail.DisplayCode = 'GD';
            complexPriceObject.High.Outbound.Ground.Ftl.Detail.DisplayCode = 'GD';
            complexPriceObject.Low.Outbound.Ground.Ltl.Detail.DisplayCode = 'GD';
            complexPriceObject.Low.Outbound.Ground.Ftl.Detail.DisplayCode = 'GD';
                                
            complexPriceObject.High.Outbound.Ground.Ltl.Detail.Comments = ineligitiblityMessage;
            complexPriceObject.High.Outbound.Ground.Ftl.Detail.Comments = ineligitiblityMessage;
            complexPriceObject.Low.Outbound.Ground.Ltl.Detail.Comments = ineligitiblityMessage;
            complexPriceObject.Low.Outbound.Ground.Ftl.Detail.Comments = ineligitiblityMessage;         
        }
    }
    
    public static void SetOutboundAirRates(boolean rateEligible, string ineligibilityMessage, LogisticsQuoteComplexPriceData complexPriceObject, LogisticsQuoteGeneratorService.ArrayOfQuoteResponseObject responseObject, Quote__c q)
    {       
        if (rateEligible)
        {
                
            for(LogisticsQuoteGeneratorService.QuoteResponseObject qr : responseObject.QuoteResponseObject)
            {
                // Process High
                if (qr.SelectionID == 2 && qr.TypeID == 2)
                {
                    if (qr.ClassOfServiceID == 1) // Next Day
                    {   
                        if (qr.Code == null || qr.Code == '')
                        {                       
                            complexPriceObject.High.Outbound.Air.AirNextDay.Detail.UnitPrice = currencyFixed(qr.Rate);
                            complexPriceObject.High.Outbound.Air.AirNextDay.Detail.FuelUnitSurcharge = currencyFixed3Digits(qr.FuelSurcharge);                  
                            complexPriceObject.High.Outbound.Air.AirNextDay.Detail.FuelSurcharge = currencyFixed(qr.Fuel);
                            complexPriceObject.High.Outbound.Air.AirNextDay.Detail.InsideFee = currencyFixed(qr.InsidePickupFee);
                            complexPriceObject.High.Outbound.Air.AirNextDay.Detail.LiftGateFee = currencyFixed(qr.LiftGateFee);
                            complexPriceObject.High.Outbound.Air.AirNextDay.Detail.ResidentialFee = currencyFixed(qr.ResidentialPickupFee);
                            complexPriceObject.High.Outbound.Air.AirNextDay.Detail.AMSpecifiedFee = currencyFixed(qr.AMSpecifiedFee);
                            complexPriceObject.High.Outbound.Air.AirNextDay.Detail.WeekendFee = currencyFixed(qr.WeekendFee);
                            complexPriceObject.High.Outbound.Air.AirNextDay.Detail.WaitTimeFee = currencyFixed(qr.WaitTimeFee);
                            complexPriceObject.High.Outbound.Air.AirNextDay.Detail.AdditionalLaborFee = currencyFixed(qr.AdditionalLaborFee);
                            complexPriceObject.High.Outbound.Air.AirNextDay.Detail.PalletizationFee = currencyFixed(qr.PalletizationFee);
                            complexPriceObject.High.Outbound.Air.AirNextDay.Detail.AttemptFee = currencyFixed(qr.AttemptFee);                           
                            complexPriceObject.High.Outbound.Air.AirNextDay.Detail.SubTotal = currencyFixed(qr.Price);      
                            complexPriceObject.High.Outbound.Air.AirNextDay.Detail.Total = currencyFixed(qr.Total);
                            complexPriceObject.High.Outbound.Air.AirNextDay.Detail.RoundTripDiscountPercent = valueToPercent(qr.roundTripDiscountPercent);
                            complexPriceObject.High.Outbound.Air.AirNextDay.Detail.AdvOrderDiscountPercent = valueToPercent(qr.AdvOrderDiscountPercent);
                            
                            Decimal TotalAirNextDayHighDiscountPercent = 0;
                            
                            if (qr.roundTripDiscountPercent != null)
                                TotalAirNextDayHighDiscountPercent = valueToPercent(qr.roundTripDiscountPercent);
                                
                            if (qr.AdvOrderDiscountPercent != null)
                                TotalAirNextDayHighDiscountPercent += valueToPercent(qr.AdvOrderDiscountPercent);
                                                        
                            complexPriceObject.High.Outbound.Air.AirNextDay.Detail.TotalDiscountPercent = TotalAirNextDayHighDiscountPercent;
                            complexPriceObject.High.Outbound.Air.AirNextDay.Detail.AdvReceivingEndDate = qr.LastDayAdvRecv;
                        }
                        else
                        {
                            complexPriceObject.High.Outbound.Air.AirNextDay.Detail.DisplayCode = qr.Code;
                            complexPriceObject.High.Outbound.Air.AirNextDay.Detail.Comments = qr.CodeDescr;
                        }                       
                    }
                    else if (qr.ClassOfServiceID == 2) // 2nd Day
                    {
                        if (qr.Code == null || qr.Code == '')
                        {                       
                            complexPriceObject.High.Outbound.Air.Air2ndDay.Detail.UnitPrice = currencyFixed(qr.Rate);
                            complexPriceObject.High.Outbound.Air.Air2ndDay.Detail.FuelUnitSurcharge = currencyFixed3Digits(qr.FuelSurcharge);
                            complexPriceObject.High.Outbound.Air.Air2ndDay.Detail.FuelSurcharge = currencyFixed(qr.Fuel);
                            complexPriceObject.High.Outbound.Air.Air2ndDay.Detail.InsideFee = currencyFixed(qr.InsidePickupFee);
                            complexPriceObject.High.Outbound.Air.Air2ndDay.Detail.LiftGateFee = currencyFixed(qr.LiftGateFee);
                            complexPriceObject.High.Outbound.Air.Air2ndDay.Detail.ResidentialFee = currencyFixed(qr.ResidentialPickupFee);
                            complexPriceObject.High.Outbound.Air.Air2ndDay.Detail.AMSpecifiedFee = currencyFixed(qr.AMSpecifiedFee);
                            complexPriceObject.High.Outbound.Air.Air2ndDay.Detail.WeekendFee = currencyFixed(qr.WeekendFee);
                            complexPriceObject.High.Outbound.Air.Air2ndDay.Detail.WaitTimeFee = currencyFixed(qr.WaitTimeFee);
                            complexPriceObject.High.Outbound.Air.Air2ndDay.Detail.AdditionalLaborFee = currencyFixed(qr.AdditionalLaborFee);
                            complexPriceObject.High.Outbound.Air.Air2ndDay.Detail.PalletizationFee = currencyFixed(qr.PalletizationFee);
                            complexPriceObject.High.Outbound.Air.Air2ndDay.Detail.AttemptFee = currencyFixed(qr.AttemptFee);                            
                            complexPriceObject.High.Outbound.Air.Air2ndDay.Detail.SubTotal = currencyFixed(qr.Price);       
                            complexPriceObject.High.Outbound.Air.Air2ndDay.Detail.Total = currencyFixed(qr.Total);
                            complexPriceObject.High.Outbound.Air.Air2ndDay.Detail.RoundTripDiscountPercent = valueToPercent(qr.roundTripDiscountPercent);
                            complexPriceObject.High.Outbound.Air.Air2ndDay.Detail.AdvOrderDiscountPercent = valueToPercent(qr.AdvOrderDiscountPercent);
                            
                            Decimal TotalAir2ndDayHighDiscountPercent = 0;
                            
                            if (qr.roundTripDiscountPercent != null)
                                TotalAir2ndDayHighDiscountPercent = valueToPercent(qr.roundTripDiscountPercent);
                                
                            if (qr.AdvOrderDiscountPercent != null)
                                TotalAir2ndDayHighDiscountPercent += valueToPercent(qr.AdvOrderDiscountPercent);
                                                        
                            complexPriceObject.High.Outbound.Air.Air2ndDay.Detail.TotalDiscountPercent = TotalAir2ndDayHighDiscountPercent;
                            complexPriceObject.High.Outbound.Air.Air2ndDay.Detail.AdvReceivingEndDate = qr.LastDayAdvRecv;
                        }
                        else
                        {
                            complexPriceObject.High.Outbound.Air.Air2ndDay.Detail.DisplayCode = qr.Code;
                            complexPriceObject.High.Outbound.Air.Air2ndDay.Detail.Comments = qr.CodeDescr;
                        }
                    }           
                }
                // Process Low
                else if (qr.SelectionID == 1 && qr.TypeID == 2)
                {
                    if (qr.ClassOfServiceID == 1) // Next Day
                    {
                        if (qr.Code == null || qr.Code == '')
                        {                       
                            complexPriceObject.Low.Outbound.Air.AirNextDay.Detail.UnitPrice = currencyFixed(qr.Rate);
                            complexPriceObject.Low.Outbound.Air.AirNextDay.Detail.FuelUnitSurcharge = currencyFixed3Digits(qr.FuelSurcharge);
                            complexPriceObject.Low.Outbound.Air.AirNextDay.Detail.FuelSurcharge = currencyFixed(qr.Fuel);
                            complexPriceObject.Low.Outbound.Air.AirNextDay.Detail.InsideFee = currencyFixed(qr.InsidePickupFee);
                            complexPriceObject.Low.Outbound.Air.AirNextDay.Detail.LiftGateFee = currencyFixed(qr.LiftGateFee);
                            complexPriceObject.Low.Outbound.Air.AirNextDay.Detail.ResidentialFee = currencyFixed(qr.ResidentialPickupFee);
                            complexPriceObject.Low.Outbound.Air.AirNextDay.Detail.AMSpecifiedFee = currencyFixed(qr.AMSpecifiedFee);
                            complexPriceObject.Low.Outbound.Air.AirNextDay.Detail.WeekendFee = currencyFixed(qr.WeekendFee);
                            complexPriceObject.Low.Outbound.Air.AirNextDay.Detail.WaitTimeFee = currencyFixed(qr.WaitTimeFee);
                            complexPriceObject.Low.Outbound.Air.AirNextDay.Detail.AdditionalLaborFee = currencyFixed(qr.AdditionalLaborFee);
                            complexPriceObject.Low.Outbound.Air.AirNextDay.Detail.PalletizationFee = currencyFixed(qr.PalletizationFee);
                            complexPriceObject.Low.Outbound.Air.AirNextDay.Detail.AttemptFee = currencyFixed(qr.AttemptFee);                            
                            complexPriceObject.Low.Outbound.Air.AirNextDay.Detail.SubTotal = currencyFixed(qr.Price);       
                            complexPriceObject.Low.Outbound.Air.AirNextDay.Detail.Total = currencyFixed(qr.Total);
                            complexPriceObject.Low.Outbound.Air.AirNextDay.Detail.RoundTripDiscountPercent = valueToPercent(qr.roundTripDiscountPercent);
                            complexPriceObject.Low.Outbound.Air.AirNextDay.Detail.AdvOrderDiscountPercent = valueToPercent(qr.AdvOrderDiscountPercent);
                            
                            Decimal TotalAirNextDayLowDiscountPercent = 0;
                            
                            if (qr.roundTripDiscountPercent != null)
                                TotalAirNextDayLowDiscountPercent = valueToPercent(qr.roundTripDiscountPercent);
                                
                            if (qr.AdvOrderDiscountPercent != null)
                                TotalAirNextDayLowDiscountPercent += valueToPercent(qr.AdvOrderDiscountPercent);
                                                        
                            complexPriceObject.Low.Outbound.Air.AirNextDay.Detail.TotalDiscountPercent = TotalAirNextDayLowDiscountPercent;
                            complexPriceObject.Low.Outbound.Air.AirNextDay.Detail.AdvReceivingEndDate = qr.LastDayAdvRecv;
                        }
                        else
                        {
                            complexPriceObject.Low.Outbound.Air.AirNextDay.Detail.DisplayCode = qr.Code;
                            complexPriceObject.Low.Outbound.Air.AirNextDay.Detail.Comments = qr.CodeDescr;                          
                        }                   
                    }
                    else if (qr.ClassOfServiceID == 2) // 2nd Day
                    {
                        if (qr.Code == null || qr.Code == '')
                        {                           
                            complexPriceObject.Low.Outbound.Air.Air2ndDay.Detail.UnitPrice = currencyFixed(qr.Rate);
                            complexPriceObject.Low.Outbound.Air.Air2ndDay.Detail.FuelUnitSurcharge = currencyFixed3Digits(qr.FuelSurcharge);
                            complexPriceObject.Low.Outbound.Air.Air2ndDay.Detail.FuelSurcharge = currencyFixed(qr.Fuel);
                            complexPriceObject.Low.Outbound.Air.Air2ndDay.Detail.InsideFee = currencyFixed(qr.InsidePickupFee);
                            complexPriceObject.Low.Outbound.Air.Air2ndDay.Detail.LiftGateFee = currencyFixed(qr.LiftGateFee);
                            complexPriceObject.Low.Outbound.Air.Air2ndDay.Detail.ResidentialFee = currencyFixed(qr.ResidentialPickupFee);
                            complexPriceObject.Low.Outbound.Air.Air2ndDay.Detail.AMSpecifiedFee = currencyFixed(qr.AMSpecifiedFee);
                            complexPriceObject.Low.Outbound.Air.Air2ndDay.Detail.WeekendFee = currencyFixed(qr.WeekendFee);
                            complexPriceObject.Low.Outbound.Air.Air2ndDay.Detail.WaitTimeFee = currencyFixed(qr.WaitTimeFee);
                            complexPriceObject.Low.Outbound.Air.Air2ndDay.Detail.AdditionalLaborFee = currencyFixed(qr.AdditionalLaborFee);
                            complexPriceObject.Low.Outbound.Air.Air2ndDay.Detail.PalletizationFee = currencyFixed(qr.PalletizationFee);
                            complexPriceObject.Low.Outbound.Air.Air2ndDay.Detail.AttemptFee = currencyFixed(qr.AttemptFee);                         
                            complexPriceObject.Low.Outbound.Air.Air2ndDay.Detail.SubTotal = currencyFixed(qr.Price);    
                            complexPriceObject.Low.Outbound.Air.Air2ndDay.Detail.Total = currencyFixed(qr.Total);
                            complexPriceObject.Low.Outbound.Air.Air2ndDay.Detail.RoundTripDiscountPercent = valueToPercent(qr.roundTripDiscountPercent);
                            complexPriceObject.Low.Outbound.Air.Air2ndDay.Detail.AdvOrderDiscountPercent = valueToPercent(qr.AdvOrderDiscountPercent);
                            
                            Decimal TotalAir2ndDayLowDiscountPercent = 0;
                            
                            if (qr.roundTripDiscountPercent != null)
                                TotalAir2ndDayLowDiscountPercent = valueToPercent(qr.roundTripDiscountPercent);
                                
                            if (qr.AdvOrderDiscountPercent != null)
                                TotalAir2ndDayLowDiscountPercent += valueToPercent(qr.AdvOrderDiscountPercent);
                                                        
                            complexPriceObject.Low.Outbound.Air.Air2ndDay.Detail.TotalDiscountPercent = TotalAir2ndDayLowDiscountPercent;
                            complexPriceObject.Low.Outbound.Air.Air2ndDay.Detail.AdvReceivingEndDate = qr.LastDayAdvRecv;
                        }
                        else
                        {
                            complexPriceObject.Low.Outbound.Air.Air2ndDay.Detail.DisplayCode = qr.Code;
                            complexPriceObject.Low.Outbound.Air.Air2ndDay.Detail.Comments = qr.CodeDescr;                           
                        }   
                    }           
                }               
            } //end for
        }
        else
        {
            complexPriceObject.High.Outbound.Air.AirNextDay.Detail.DisplayCode = 'AD';
            complexPriceObject.High.Outbound.Air.Air2ndDay.Detail.DisplayCode = 'AD';
            complexPriceObject.Low.Outbound.Air.AirNextDay.Detail.DisplayCode = 'AD';
            complexPriceObject.Low.Outbound.Air.Air2ndDay.Detail.DisplayCode = 'AD';                    
            
            complexPriceObject.High.Outbound.Air.AirNextDay.Detail.Comments = ineligibilityMessage;
            complexPriceObject.High.Outbound.Air.Air2ndDay.Detail.Comments = ineligibilityMessage;
            complexPriceObject.Low.Outbound.Air.AirNextDay.Detail.Comments = ineligibilityMessage;
            complexPriceObject.Low.Outbound.Air.Air2ndDay.Detail.Comments = ineligibilityMessage;           
        }
        
    }
    
    public class GetRatesWrapper{
        public String html {get;set;}
        /************** InBound-High**************/
        public Boolean inHiAir2ndDayFlag {get;set;}
        public Boolean inHiAir2ndDayShipmentFlag {get;set;}
        public String inHiAir2ndDayRates {get;set;}
        public Boolean inHIAir2ndDayDisCodeXFlag {get;set;}
        
        public Boolean inHIAirNextDayFlag {get;set;}
        public Boolean inHIAirNextDayShipmentFlag {get;set;}
        public String inHIAirNextDayRates {get;set;}
        public Boolean inHIAirNextDayDisCodeXFlag {get;set;}
        
        public Boolean inHIGroundLtlFlag {get;set;}
        public Boolean inHIGroundLtlShipmentFlag {get;set;}
        public String inHIGroundLtlRates {get;set;}
        public Boolean inHIGroundLtlDisCodeXFlag {get;set;}
        
        public Boolean inHiLocalFlag {get;set;}
        public Boolean inHiLocalShipmentFlag {get;set;}
        public String inHiLocalRates {get;set;}
        public Boolean inHiLocalDisCodeXFlag {get;set;}
        
        /************** OutBound-High**************/
        public Boolean outHiAir2ndDayFlag {get;set;}
        public Boolean outHiAir2ndDayShipmentFlag {get;set;}
        public String outHiAir2ndDayRates {get;set;}
        public Boolean outHiAir2ndDayDisCodeXFlag {get;set;}
        
        public Boolean outHiAirNextDayFlag {get;set;}
        public Boolean outHiAirNextDayShipmentFlag {get;set;}
        public String outHiAirNextDayRates {get;set;}
        public Boolean outHiAirNextDayDisCodeXFlag {get;set;}
        
        public Boolean outHiGroundLtlFlag {get;set;}
        public Boolean outHiGroundLtlShipmentFlag {get;set;}
        public String outHiGroundLtlRates {get;set;}
        public Boolean outHiGroundLtlDisCodeXFlag {get;set;}
        
        public Boolean outHiLocalFlag {get;set;}
        public Boolean outHiLocalShipmentFlag {get;set;}
        public String outHiLocalRates {get;set;}
        public Boolean outHiLocalDisCodeXFlag {get;set;}
        
        public Boolean highInOutNoRatesMessageFlag {get;set;}
        public List<String> highInOutNoRatesMessage {get;set;}
        public Boolean highMsgTableFlag {get;set;}
        public Map<String,String> highMsgTable {get;set;}
        
        
        //**************************************/
        
        /************** InBound-low**************/
        public Boolean inlowAir2ndDayFlag {get;set;}
        public Boolean inlowAir2ndDayShipmentFlag {get;set;}
        public String inlowAir2ndDayRates {get;set;}
        public Boolean inlowAir2ndDayDisCodeXFlag {get;set;}
        
        public Boolean inlowAirNextDayFlag {get;set;}
        public Boolean inlowAirNextDayShipmentFlag {get;set;}
        public String inlowAirNextDayRates {get;set;}
        public Boolean inlowAirNextDayDisCodeXFlag {get;set;}
        
        public Boolean inlowGroundLtlFlag {get;set;}
        public Boolean inlowGroundLtlShipmentFlag {get;set;}
        public String inlowGroundLtlRates {get;set;}
        public Boolean inlowGroundLtlDisCodeXFlag {get;set;}
        
        public Boolean inlowLocalFlag {get;set;}
        public Boolean inlowLocalShipmentFlag {get;set;}
        public String inlowLocalRates {get;set;}
        public Boolean inlowLocalDisCodeXFlag {get;set;}
        
        /************** OutBound-low**************/
        public Boolean outLowAir2ndDayFlag {get;set;}
        public Boolean outLowAir2ndDayShipmentFlag {get;set;}
        public String outLowAir2ndDayRates {get;set;}
        public Boolean outLowAir2ndDayDisCodeXFlag {get;set;}
        
        public Boolean outLowAirNextDayFlag {get;set;}
        public Boolean outLowAirNextDayShipmentFlag {get;set;}
        public String outLowAirNextDayRates {get;set;}
        public Boolean outLowAirNextDayDisCodeXFlag {get;set;}
        
        public Boolean outLowGroundLtlFlag {get;set;}
        public Boolean outLowGroundLtlShipmentFlag {get;set;}
        public String outLowGroundLtlRates {get;set;}
        public Boolean outLowGroundLtlDisCodeXFlag {get;set;}
        
        public Boolean outLowLocalFlag {get;set;}
        public Boolean outLowLocalShipmentFlag {get;set;}
        public String outLowLocalRates {get;set;}
        public Boolean outLowLocalDisCodeXFlag {get;set;}
        
        public Boolean lowInOutNoRatesMessageFlag {get;set;}
        public List<String> lowInOutNoRatesMessage {get;set;}
        public Boolean lowMsgTableFlag {get;set;}
        public Map<String,String> lowMsgTable {get;set;}
        
        public List<String> inboundShipmentType {get;set;}
        public List<String> inboundClassOfService {get;set;}
        public String inboundServiceType {get;set;}
        public Double inboundLowPrice {get;set;}
        public Double inboundHighPrice {get;set;}
        public Double inboundPrice {get;set;}
        public String inboundSelectedShipType {get;set;}
        public String inboundSelectedClassSvc {get;set;}
        
        public List<String> outboundShipmentType {get;set;}
        public List<String> outboundClassOfService {get;set;}
        public String outboundServiceType {get;set;}
        public Double outboundLowPrice {get;set;}
        public Double outboundHighPrice {get;set;}
        public Double outboundPrice {get;set;}
        public String outboundSelectedShipType {get;set;}
        public String outboundSelectedClassSvc {get;set;}
        
        public String inLowHigh2ndDayRates {get;set;}
        public String inLowHighAirNextDayRates {get;set;}
        public String inLowHighGroundLtlRates {get;set;}
        public String inLowHighLiLocalRates {get;set;}
            
        public String outLowHigh2ndDayRates {get;set;}
        public String outLowHighAirNextDayRates {get;set;}
        public String outLowHighGroundLtlRates {get;set;}
        public String outLowHighLiLocalRates {get;set;}
        
    }

   public static GetRatesWrapper GetHtmlLightning(string direction, LogisticsQuoteComplexPriceData complexPriceData, Quote__c q)
    {
        GetRatesWrapper getRatesWrp = new GetRatesWrapper();
        List<String> highInOutNoRatesMsg = new List<String>();
        List<String> lowInOutNoRatesMsg = new List<String>();
        List<String> customInShipmentType = new List<String>();
        List<String> customInClassOfService = new List<String>();
        List<String> customOutShipmentType = new List<String>();
        List<String> customOutClassOfService = new List<String>();
        
        map<string, string> HiMoMessages = new map<string, string>{};
        map<string, string> HoMoMessages = new map<string, string>{};
        map<string, string> LiMoMessages = new map<string, string>{};
        map<string, string> LoMoMessages = new map<string, string>{};
        
        
        string Html = '';
        string HiInboundHtmlNoRatesMessage = '';
        string LiInboundHtmlNoRatesMessage = '';
        string HoInboundHtmlNoRatesMessage = '';
        string LoInboundHtmlNoRatesMessage = '';        
        
        direction = direction.toUpperCase();
        
        Html = '<div id=\'priceMatrixDialog\' class=\'container\'>';
        Html += '<div id=\'tabContainer\' class=\'tab_container\'>';        
        Html += '<ul class=\'tabs\'><li class=\'tabLink\'><a href=\'#high\'>High</a></li><li class=\'tabLink\'><a href=\'#low\'>Low</a></li><li class=\'tabLink\'><a href=\'#custom\'>Name Your Price</a></li></ul>';
        Html += '<div id=\'high\'>';
        
        if (direction == 'ROUNDTRIP' || direction == 'INBOUND')
        {
            string HiAir2ndDayRates = complexPriceData.High.Inbound.Air.Air2ndDay.Detail.UnitPrice + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.FuelUnitSurcharge + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.FuelSurcharge + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.LiftGateFee + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.InsideFee + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.ResidentialFee + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.AMSpecifiedFee + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.WeekendFee + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.WaitTimeFee + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.AdditionalLaborFee + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.PalletizationFee + ','  + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.AttemptFee + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.SubTotal + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.Total + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.RoundTripDiscountPercent + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.AdvReceivingEndDate; 
            string HiAirNextDayRates = complexPriceData.High.Inbound.Air.AirNextDay.Detail.UnitPrice + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.FuelUnitSurcharge + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.FuelSurcharge + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.LiftGateFee + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.InsideFee + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.ResidentialFee + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.AMSpecifiedFee + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.WeekendFee + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.WaitTimeFee + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.AdditionalLaborFee + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.PalletizationFee + ','  + complexPriceData.High.Inbound.Air.AirNextDay.Detail.AttemptFee + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.SubTotal + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.Total + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.RoundtripDiscountPercent + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.AdvReceivingEndDate;
            string HiGroundLTLRates = complexPriceData.High.Inbound.Ground.Ltl.Detail.UnitPrice + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.FuelUnitSurcharge + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.FuelSurcharge + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.LiftGateFee + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.InsideFee + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.ResidentialFee + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.AMSpecifiedFee + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.WeekendFee + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.WaitTimeFee + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.AdditionalLaborFee + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.PalletizationFee + ','  + complexPriceData.High.Inbound.Ground.Ltl.Detail.AttemptFee + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.SubTotal + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.Total + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.RoundtripDiscountPercent + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.AdvReceivingEndDate;
            string HiGroundFTLRates = complexPriceData.High.Inbound.Ground.Ftl.Detail.UnitPrice + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.FuelUnitSurcharge + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.FuelSurcharge + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.LiftGateFee + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.InsideFee + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.ResidentialFee + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.AMSpecifiedFee + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.WeekendFee + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.WaitTimeFee + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.AdditionalLaborFee + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.PalletizationFee + ','  + complexPriceData.High.Inbound.Ground.Ftl.Detail.AttemptFee + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.SubTotal + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.Total + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.RoundtripDiscountPercent + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.AdvReceivingEndDate;         
            string HiLocalRates = complexPriceData.High.Inbound.Local.Detail.UnitPrice + ',' + complexPriceData.High.Inbound.Local.Detail.FuelUnitSurcharge + ',' + complexPriceData.High.Inbound.Local.Detail.FuelSurcharge + ',' + complexPriceData.High.Inbound.Local.Detail.LiftGateFee + ',' + complexPriceData.High.Inbound.Local.Detail.InsideFee + ',' + complexPriceData.High.Inbound.Local.Detail.ResidentialFee + ',' + complexPriceData.High.Inbound.Local.Detail.AMSpecifiedFee + ',' + complexPriceData.High.Inbound.Local.Detail.WeekendFee + ',' + complexPriceData.High.Inbound.Local.Detail.WaitTimeFee + ',' + complexPriceData.High.Inbound.Local.Detail.AdditionalLaborFee + ',' + complexPriceData.High.Inbound.Local.Detail.PalletizationFee + ','  + complexPriceData.High.Inbound.Local.Detail.AttemptFee + ',' + complexPriceData.High.Inbound.Local.Detail.SubTotal + ',' + complexPriceData.High.Inbound.Local.Detail.Total + ',' + complexPriceData.High.Inbound.Local.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.High.Inbound.Local.Detail.RoundTripDiscountPercent + ',' + complexPriceData.High.Inbound.Local.Detail.AdvReceivingEndDate;
            
            Html += '<table class=\'priceMatrixTable\'>';
            Html += '<tr class=\'priceMatrixTableHeader\'>';
            Html += '<th class=\'priceMatrixTableHeaderTypeColumn\'>' + 'Inbound' + '</th>';
            Html += '<th class=\'priceMatrixTableHeader\'>' + 'LTL' + '</th>';
            //Html += '<th class=\'priceMatrixTableHeader\'>' + 'FTL' + '</th>';
            Html += '<th class=\'priceMatrixTableHeader\'>' + '2nd Day' + '</th>';
            Html += '<th class=\'priceMatrixTableHeader\'>' + 'Next Day' + '</th>';
            Html += '<th class=\'priceMatrixTableHeader\'>' + 'Other' + '</th>';        
            Html += '</tr>';
            Html += '<tr>';
            Html += '<td class=\'priceMatrixTypeColumn\'>' + 'Air' + '</td>';
            Html += '<td colspan=1 class=\'priceMatrixValueNA\'>' + '' + '</td>';
            
            if (complexPriceData.High.Inbound.Air.Air2ndDay.Detail.DisplayCode == null || complexPriceData.High.Inbound.Air.Air2ndDay.Detail.DisplayCode == '')
            {
                String HIAir2ndDayAdvDiscount = (complexPriceData.High.Inbound.Air.Air2ndDay.Detail.AdvOrderDiscountPercent > 0 ? 'Advance Order Discount: ' + string.valueOf(complexPriceData.High.Inbound.Air.Air2ndDay.Detail.AdvOrderDiscountPercent) + '%': '');
                String HIAir2ndDayRTDiscount = (complexPriceData.High.Inbound.Air.Air2ndDay.Detail.RoundTripDiscountPercent > 0 ? 'Roundtrip Discount: ' + string.valueOf(complexPriceData.High.Inbound.Air.Air2ndDay.Detail.RoundTripDiscountPercent) + '%' : '');
                String HIAir2ndDayDiscount = HIAir2ndDayAdvDiscount + (HIAir2ndDayAdvDiscount != '' ? '\n' : '') + HIAir2ndDayRTDiscount;
                
                String HIAir2ndDayClass = 'priceMatrixValue';
                getRatesWrp.inHiAir2ndDayFlag = true;
                getRatesWrp.inHiAir2ndDayShipmentFlag = true;
                
                if (q.Shipment_Type__c != null && q.Class_of_Service__c != null && q.Selection__c != null)
                {
                    if (q.Shipment_Type__c.toUpperCase() == 'AIR TRANSPORTATION' && q.Class_of_Service__c.toUpperCase() == '2ND DAY' && q.Selection__c.toUpperCase() == 'HIGH' && (q.Message__c == null || q.Message__c == '')){
                        HIAir2ndDayClass = 'priceMatrixValuePriorSelection';
                        getRatesWrp.inHiAir2ndDayShipmentFlag = false;
                    }
                }
                
                Html += '<td id=\'HiAir2ndDay\' class=\'' + HIAir2ndDayClass + '\' onClick=\'changeInboundCellColor(this,"HiAir2ndDay","' + HiAir2ndDayRates +'"); return false;\' title=\'' + HIAir2ndDayDiscount + '\'>' + string.valueOf(complexPriceData.High.Inbound.Air.Air2ndDay.Detail.UnitPrice) + (complexPriceData.High.Inbound.Air.Air2ndDay.Detail.TotalDiscountPercent > 0 ? ' (-' + string.valueOf(complexPriceData.High.Inbound.Air.Air2ndDay.Detail.TotalDiscountPercent) + '%)' : '') + '</td>';
                getRatesWrp.inHiAir2ndDayRates = string.valueOf(complexPriceData.High.Inbound.Air.Air2ndDay.Detail.UnitPrice) + (complexPriceData.High.Inbound.Air.Air2ndDay.Detail.TotalDiscountPercent > 0 ? ' (-' + string.valueOf(complexPriceData.High.Inbound.Air.Air2ndDay.Detail.TotalDiscountPercent) + '%)' : '');           
            }
            else {
                getRatesWrp.inHiAir2ndDayRates = complexPriceData.High.Inbound.Air.Air2ndDay.Detail.DisplayCode;
                
                if (complexPriceData.High.Inbound.Air.Air2ndDay.Detail.DisplayCode != null && complexPriceData.High.Inbound.Air.Air2ndDay.Detail.Comments != null)
                    HiMoMessages.put(complexPriceData.High.Inbound.Air.Air2ndDay.Detail.DisplayCode, complexPriceData.High.Inbound.Air.Air2ndDay.Detail.Comments);
                
                if (complexPriceData.High.Inbound.Air.Air2ndDay.Detail.DisplayCode == 'X'){
                    getRatesWrp.inHIAir2ndDayDisCodeXFlag = true;
                    Html += '<td id=\'HiAir2ndDay\' class=\'priceMatrixValueInvalidEntry\'>' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.DisplayCode + '</td>';
                }
                else
                    Html += '<td id=\'HiAir2ndDay\' class=\'priceMatrixValueSpecial\'>' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.DisplayCode + '</td>';
            }
                    
            if (complexPriceData.High.Inbound.Air.AirNextDay.Detail.DisplayCode == null || complexPriceData.High.Inbound.Air.AirNextDay.Detail.DisplayCode == '')
            {
                String HIAirNextDayAdvDiscount = (complexPriceData.High.Inbound.Air.AirNextDay.Detail.AdvOrderDiscountPercent > 0 ? 'Advance Order Discount: ' + string.valueOf(complexPriceData.High.Inbound.Air.AirNextDay.Detail.AdvOrderDiscountPercent) + '%': '');
                String HIAirNextDayRTDiscount = (complexPriceData.High.Inbound.Air.AirNextDay.Detail.RoundTripDiscountPercent > 0 ? 'Roundtrip Discount: ' + string.valueOf(complexPriceData.High.Inbound.Air.AirNextDay.Detail.RoundTripDiscountPercent) + '%' : '');
                String HIAirNextDayDiscount = HIAirNextDayAdvDiscount + (HIAirNextDayAdvDiscount != '' ? '\n' : '') + HIAirNextDayRTDiscount;
                
                String HIAirNextDayClass = 'priceMatrixValue';
                getRatesWrp.inHIAirNextDayFlag = true;
                getRatesWrp.inHIAirNextDayShipmentFlag = true;
                
                if (q.Shipment_Type__c != null && q.Class_of_Service__c != null && q.Selection__c != null && (q.Message__c == null || q.Message__c == ''))
                {               
                    if (q.Shipment_Type__c.toUpperCase() == 'AIR TRANSPORTATION' && q.Class_of_Service__c.toUpperCase() == 'NEXT DAY' && q.Selection__c.toUpperCase() == 'HIGH'){
                        HIAirNextDayClass = 'priceMatrixValuePriorSelection';
                        getRatesWrp.inHIAirNextDayShipmentFlag = false;
                    }
                }
                                    
                Html += '<td id=\'HiAirNextDay\' class=\'' + HIAirNextDayClass + '\' onClick=\'changeInboundCellColor(this,"HiAirNextDay", "' + HiAirNextDayRates + '"); return false;\' title=\'' + HIAirNextDayDiscount + '\'>' + string.valueOf(complexPriceData.High.Inbound.Air.AirNextDay.Detail.UnitPrice) + (complexPriceData.High.Inbound.Air.AirNextDay.Detail.TotalDiscountPercent > 0 ? ' (-' + string.valueOf(complexPriceData.High.Inbound.Air.AirNextDay.Detail.TotalDiscountPercent) + '%)' : '') + '</td>';
                getRatesWrp.inHIAirNextDayRates =  string.valueOf(complexPriceData.High.Inbound.Air.AirNextDay.Detail.UnitPrice) + (complexPriceData.High.Inbound.Air.AirNextDay.Detail.TotalDiscountPercent > 0 ? ' (-' + string.valueOf(complexPriceData.High.Inbound.Air.AirNextDay.Detail.TotalDiscountPercent) + '%)' : '');
            }
            else {
                getRatesWrp.inHIAirNextDayRates = complexPriceData.High.Inbound.Air.AirNextDay.Detail.DisplayCode;
                
                if (complexPriceData.High.Inbound.Air.AirNextDay.Detail.DisplayCode != null && complexPriceData.High.Inbound.Air.AirNextDay.Detail.Comments != null)                        
                    HiMoMessages.put(complexPriceData.High.Inbound.Air.AirNextDay.Detail.DisplayCode, complexPriceData.High.Inbound.Air.AirNextDay.Detail.Comments);
                
                if (complexPriceData.High.Inbound.Air.AirNextDay.Detail.DisplayCode == 'X'){
                    getRatesWrp.inHIAirNextDayDisCodeXFlag = true;
                    Html += '<td id=\'HiAirNextDay\' class=\'priceMatrixValueInvalidEntry\'>' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.DisplayCode + '</td>';
                }
                else
                    Html += '<td id=\'HiAirNextDay\' class=\'priceMatrixValueSpecial\'>' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.DisplayCode + '</td>';
            }
                    
            Html += '<td class=\'priceMatrixValueNA\'>' + '' + '</td>';
            Html += '</tr>';
            Html += '<tr>'; 
            Html += '<td class=\'priceMatrixTypeColumn\'>' + 'Ground' + '</td>';
            
            if (complexPriceData.High.Inbound.Ground.Ltl.Detail.DisplayCode == null || complexPriceData.High.Inbound.Ground.Ltl.Detail.DisplayCode == '')
            {
                String HIGroundLtlAdvDiscount = (complexPriceData.High.Inbound.Ground.Ltl.Detail.AdvOrderDiscountPercent > 0 ? 'Advance Order Discount: ' + string.valueOf(complexPriceData.High.Inbound.Ground.Ltl.Detail.AdvOrderDiscountPercent) + '%': '');
                String HIGroundLtlRTDiscount = (complexPriceData.High.Inbound.Ground.Ltl.Detail.RoundTripDiscountPercent > 0 ? 'Roundtrip Discount: ' + string.valueOf(complexPriceData.High.Inbound.Ground.Ltl.Detail.RoundTripDiscountPercent) + '%' : '');
                String HIGroundLtlDiscount = HIGroundLtlAdvDiscount + (HIGroundLtlAdvDiscount != '' ? '\n' : '') + HIGroundLtlRTDiscount;
                
                String HIGroundLtlClass = 'priceMatrixValue';
                getRatesWrp.inHIGroundLtlFlag = true;
                getRatesWrp.inHIGroundLtlShipmentFlag = true;
                
                if (q.Shipment_Type__c != null && q.Service_Type__c != null && q.Selection__c != null && (q.Message__c == null || q.Message__c == ''))
                {               
                    if (q.Shipment_Type__c.toUpperCase() == 'GROUND TRANSPORTATION' && q.Service_Type__c.toUpperCase() == 'LTL' && q.Selection__c.toUpperCase() == 'HIGH'){
                        HIGroundLtlClass = 'priceMatrixValuePriorSelection';
                        getRatesWrp.inHIGroundLtlShipmentFlag = false;
                    }
                }
                    
                Html += '<td id=\'HiGroundLTL\' class=\'' + HIGroundLtlClass + '\' onClick=\'changeInboundCellColor(this,"HiGroundLTL", "' + HiGroundLTLRates + '"); return false;\' title=\'' + HIGroundLtlDiscount + '\'>' + string.valueOf(complexPriceData.High.Inbound.Ground.Ltl.Detail.UnitPrice) + (complexPriceData.High.Inbound.Ground.Ltl.Detail.TotalDiscountPercent > 0 ? ' (-' + string.valueOf(complexPriceData.High.Inbound.Ground.Ltl.Detail.TotalDiscountPercent) + '%)' : '') + '</td>';
                getRatesWrp.inHIGroundLtlRates = string.valueOf(complexPriceData.High.Inbound.Ground.Ltl.Detail.UnitPrice) + (complexPriceData.High.Inbound.Ground.Ltl.Detail.TotalDiscountPercent > 0 ? ' (-' + string.valueOf(complexPriceData.High.Inbound.Ground.Ltl.Detail.TotalDiscountPercent) + '%)' : '');
            }
            else {
                getRatesWrp.inHIGroundLtlRates = complexPriceData.High.Inbound.Ground.Ltl.Detail.DisplayCode;
                if (complexPriceData.High.Inbound.Ground.Ltl.Detail.DisplayCode != null && complexPriceData.High.Inbound.Ground.Ltl.Detail.Comments != null)                        
                    HiMoMessages.put(complexPriceData.High.Inbound.Ground.Ltl.Detail.DisplayCode, complexPriceData.High.Inbound.Ground.Ltl.Detail.Comments);
                
                if (complexPriceData.High.Inbound.Ground.Ltl.Detail.DisplayCode == 'X'){
                    Html += '<td id=\'HiGroundLTL\' class=\'priceMatrixValueInvalidEntry\'>' + complexPriceData.High.Inbound.Ground.Ltl.Detail.DisplayCode + '</td>';
                    getRatesWrp.inHIGroundLtlDisCodeXFlag = true;
                }
                else
                    Html += '<td id=\'HiGroundLTL\' class=\'priceMatrixValueSpecial\'>' + complexPriceData.High.Inbound.Ground.Ltl.Detail.DisplayCode + '</td>';
            }
            
            Html += '<td colspan=3 class=\'priceMatrixValueNA\'>' + '</td>';
            Html += '</tr>';
            Html += '<tr>'; 
            Html += '<td class=\'priceMatrixTypeColumn\'>' + 'Local' + '</td>';
            //Html += '<td colspan=4 class=\'priceMatrixValueNA\'>' + '' + '</td>';
            Html += '<td colspan=3 class=\'priceMatrixValueNA\'>' + '' + '</td>';
                    
            if (complexPriceData.High.Inbound.Local.Detail.DisplayCode == null || complexPriceData.High.Inbound.Local.Detail.DisplayCode == '')
            {
                String HILocalClass = 'priceMatrixValue';
                getRatesWrp.inHiLocalFlag = true;
                getRatesWrp.inHiLocalShipmentFlag = true;
                
                if (q.Shipment_Type__c != null && q.Selection__c != null && (q.Message__c == null || q.Message__c == ''))
                {               
                    if (q.Shipment_Type__c.toUpperCase() == 'LOCAL SHIPMENTS' && q.Selection__c.toUpperCase() == 'HIGH'){
                        HILocalClass = 'priceMatrixValuePriorSelection';
                        getRatesWrp.inHiLocalShipmentFlag = false;
                    }
                }
                
                Html += '<td id=\'HiLocal\' class=\'' + HILocalClass + '\' onClick=\'changeInboundCellColor(this,"HiLocal", "' + HiLocalRates + '"); return false;\'>' + string.valueOf(complexPriceData.High.Inbound.Local.Detail.UnitPrice) + '</td>';
                getRatesWrp.inHiLocalRates = string.valueOf(complexPriceData.High.Inbound.Local.Detail.UnitPrice);
            }
            else
            {
                getRatesWrp.inHiLocalRates = complexPriceData.High.Inbound.Local.Detail.DisplayCode;
                if (complexPriceData.High.Inbound.Local.Detail.DisplayCode != null && complexPriceData.High.Inbound.Local.Detail.Comments != null)
                    HiMoMessages.put(complexPriceData.High.Inbound.Local.Detail.DisplayCode, complexPriceData.High.Inbound.Local.Detail.Comments);
                        
                if (complexPriceData.High.Inbound.Local.Detail.DisplayCode == 'X'){
                    Html += '<td id=\'HiLocal\' class=\'priceMatrixValueInvalidEntry\'>' + complexPriceData.High.Inbound.Local.Detail.DisplayCode + '</td>';
                    getRatesWrp.inHiLocalDisCodeXFlag = true;
                }
                else
                    Html += '<td id=\'HiLocal\' class=\'priceMatrixValueSpecial\'>' + complexPriceData.High.Inbound.Local.Detail.DisplayCode + '</td>';                     
            }
                    
            Html += '</tr>';
            Html += '</table>';
        }
        else
        {
            /*
                In a custom quote, the Quote_Subject__c field could be different from the direction argument passed
                to the GetRates method. In this case though, even if the quote subject is "ROUNDTRIP", the direction
                value could be Outbound, because Custom Quote flag is checked on the Inbound. In such a case, display
                this message.               
            */
            
            if (q.Quote_Subject__c.toUpperCase() != Direction && q.Custom_Quote__c){
                HiInboundHtmlNoRatesMessage = '<table style=\'border:none\'><tr><td style=\'padding-top: 20px; color: red\'>Inbound shipment is custom quote.</td></tr></table>';
                getRatesWrp.highInOutNoRatesMessageFlag = true;
                highInOutNoRatesMsg.add(HoInboundHtmlNoRatesMessage);
                getRatesWrp.highInOutNoRatesMessage = highInOutNoRatesMsg;
            }
            /*
                This else portion below is not required. When Quote_Subject__c is Outbound, the code will always
                execute this parent else portion and result in message display, which is not required since the 
                quote is Outbound.NOTE: In normal quote (i.e. not custom quote), the direction argument is always 
                the same as the Quote_Subject__c field.
            */ 
            //else
            //HiInboundHtmlNoRatesMessage = '<table style=\'border:none\'><tr><td style=\'padding-top: 20px;\'>To view rates for Inbound shipment, required field values must be provided.</td></tr></table>';
        }
        
        if (direction == 'ROUNDTRIP' || direction == 'OUTBOUND')
        {
            string HoAir2ndDayRates = complexPriceData.High.Outbound.Air.Air2ndDay.Detail.UnitPrice + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.FuelUnitSurcharge + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.FuelSurcharge + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.LiftGateFee + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.InsideFee + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.ResidentialFee + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.AMSpecifiedFee + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.WeekendFee + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.WaitTimeFee + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.AdditionalLaborFee + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.PalletizationFee + ','  + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.AttemptFee + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.SubTotal + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.Total + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.RoundTripDiscountPercent + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.AdvReceivingEndDate; 
            string HoAirNextDayRates = complexPriceData.High.Outbound.Air.AirNextDay.Detail.UnitPrice + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.FuelUnitSurcharge + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.FuelSurcharge + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.LiftGateFee + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.InsideFee + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.ResidentialFee + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.AMSpecifiedFee + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.WeekendFee + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.WaitTimeFee + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.AdditionalLaborFee + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.PalletizationFee + ','  + complexPriceData.High.Outbound.Air.AirNextDay.Detail.AttemptFee + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.SubTotal + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.Total + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.RoundtripDiscountPercent + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.AdvReceivingEndDate;
            string HoGroundLTLRates = complexPriceData.High.Outbound.Ground.Ltl.Detail.UnitPrice + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.FuelUnitSurcharge + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.FuelSurcharge + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.LiftGateFee + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.InsideFee + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.ResidentialFee + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.AMSpecifiedFee + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.WeekendFee + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.WaitTimeFee + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.AdditionalLaborFee + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.PalletizationFee + ','  + complexPriceData.High.Outbound.Ground.Ltl.Detail.AttemptFee + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.SubTotal + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.Total + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.RoundtripDiscountPercent + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.AdvReceivingEndDate;
            string HoGroundFTLRates = complexPriceData.High.Outbound.Ground.Ftl.Detail.UnitPrice + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.FuelUnitSurcharge + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.FuelSurcharge + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.LiftGateFee + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.InsideFee + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.ResidentialFee + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.AMSpecifiedFee + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.WeekendFee + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.WaitTimeFee + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.AdditionalLaborFee + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.PalletizationFee + ','  + complexPriceData.High.Outbound.Ground.Ftl.Detail.AttemptFee + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.SubTotal + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.Total + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.RoundtripDiscountPercent + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.AdvReceivingEndDate;            
            string HoLocalRates = complexPriceData.High.Outbound.Local.Detail.UnitPrice + ',' + complexPriceData.High.Outbound.Local.Detail.FuelUnitSurcharge + ',' + complexPriceData.High.Outbound.Local.Detail.FuelSurcharge + ',' + complexPriceData.High.Outbound.Local.Detail.LiftGateFee + ',' + complexPriceData.High.Outbound.Local.Detail.InsideFee + ',' + complexPriceData.High.Outbound.Local.Detail.ResidentialFee + ',' + complexPriceData.High.Outbound.Local.Detail.AMSpecifiedFee + ',' + complexPriceData.High.Outbound.Local.Detail.WeekendFee + ',' + complexPriceData.High.Outbound.Local.Detail.WaitTimeFee + ',' + complexPriceData.High.Outbound.Local.Detail.AdditionalLaborFee + ',' + complexPriceData.High.Outbound.Local.Detail.PalletizationFee + ','  + complexPriceData.High.Outbound.Local.Detail.AttemptFee + ',' + complexPriceData.High.Outbound.Local.Detail.SubTotal + ',' + complexPriceData.High.Outbound.Local.Detail.Total + ',' + complexPriceData.High.Outbound.Local.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.High.Outbound.Local.Detail.RoundTripDiscountPercent + ',' + complexPriceData.High.Outbound.Local.Detail.AdvReceivingEndDate;
            
            Html += '<table class=\'priceMatrixTable\'>';
            Html += '<tr class=\'priceMatrixTableHeader\'>';
            Html += '<th class=\'priceMatrixTableHeaderTypeColumn\'>' + 'Outbound' + '</th>';
            Html += '<th class=\'priceMatrixTableHeader\'>' + 'LTL' + '</th>';
            //Html += '<th class=\'priceMatrixTableHeader\'>' + 'FTL' + '</th>';
            Html += '<th class=\'priceMatrixTableHeader\'>' + '2nd Day' + '</th>';
            Html += '<th class=\'priceMatrixTableHeader\'>' + 'Next Day' + '</th>';
            Html += '<th class=\'priceMatrixTableHeader\'>' + 'Other' + '</th>';        
            Html += '</tr>';
            Html += '<tr>'; 
            Html += '<td class=\'priceMatrixTypeColumn\'>' + 'Air' + '</td>';
            Html += '<td colspan=1 class=\'priceMatrixValueNA\'>' + '' + '</td>';
                    
            if (complexPriceData.High.Outbound.Air.Air2ndDay.Detail.DisplayCode == null || complexPriceData.High.Outbound.Air.Air2ndDay.Detail.DisplayCode == '')
            {
                String HOAir2ndDayAdvDiscount = (complexPriceData.High.Outbound.Air.Air2ndDay.Detail.AdvOrderDiscountPercent > 0 ? 'Advance Order Discount: ' + string.valueOf(complexPriceData.High.Outbound.Air.Air2ndDay.Detail.AdvOrderDiscountPercent) + '%': '');
                String HOAir2ndDayRTDiscount = (complexPriceData.High.Outbound.Air.Air2ndDay.Detail.RoundTripDiscountPercent > 0 ? 'Roundtrip Discount: ' + string.valueOf(complexPriceData.High.Outbound.Air.Air2ndDay.Detail.RoundTripDiscountPercent) + '%' : '');
                String HOAir2ndDayDiscount = HOAir2ndDayAdvDiscount + (HOAir2ndDayAdvDiscount != '' ? '\n' : '') + HOAir2ndDayRTDiscount;
                
                String HOAir2ndDayClass = 'priceMatrixValue';
                getRatesWrp.outHiAir2ndDayFlag = true;
                getRatesWrp.outHiAir2ndDayShipmentFlag = true;
                
                if (q.OB_Shipment_Type__c != null && q.OB_Class_of_Service__c != null && q.OB_Selection__c != null && (q.Message__c == null || q.Message__c == ''))
                {
                    if (q.OB_Shipment_Type__c.toUpperCase() == 'AIR TRANSPORTATION' && q.OB_Class_of_Service__c.toUpperCase() == '2ND DAY' && q.OB_Selection__c.toUpperCase() == 'HIGH'){
                        HOAir2ndDayClass = 'priceMatrixValuePriorSelection';
                        getRatesWrp.outHiAir2ndDayShipmentFlag = false;
                    }
                }
                                
                Html += '<td id=\'HoAir2ndDay\' class=\'' + HOAir2ndDayClass + '\' onClick=\'changeOutboundCellColor(this,"HoAir2ndDay", "' + HoAir2ndDayRates + '"); return false;\' title=\'' + HOAir2ndDayDiscount + '\'>' + string.valueOf(complexPriceData.High.Outbound.Air.Air2ndDay.Detail.UnitPrice) + (complexPriceData.High.Outbound.Air.Air2ndDay.Detail.TotalDiscountPercent > 0 ? ' (-' + string.valueOf(complexPriceData.High.Outbound.Air.Air2ndDay.Detail.TotalDiscountPercent) + '%)' : '') + '</td>';
                getRatesWrp.outHiAir2ndDayRates = string.valueOf(complexPriceData.High.Outbound.Air.Air2ndDay.Detail.UnitPrice) + (complexPriceData.High.Outbound.Air.Air2ndDay.Detail.TotalDiscountPercent > 0 ? ' (-' + string.valueOf(complexPriceData.High.Outbound.Air.Air2ndDay.Detail.TotalDiscountPercent) + '%)' : '');
            }
            else {
                getRatesWrp.outHiAir2ndDayRates = complexPriceData.High.Outbound.Air.Air2ndDay.Detail.DisplayCode;
                if (complexPriceData.High.Outbound.Air.Air2ndDay.Detail.DisplayCode != null && complexPriceData.High.Outbound.Air.Air2ndDay.Detail.Comments != null)                        
                    HoMoMessages.put(complexPriceData.High.Outbound.Air.Air2ndDay.Detail.DisplayCode, complexPriceData.High.Outbound.Air.Air2ndDay.Detail.Comments);
                
                if (complexPriceData.High.Outbound.Air.Air2ndDay.Detail.DisplayCode == 'X'){
                    Html += '<td id=\'HoAir2ndDay\' class=\'priceMatrixValueInvalidEntry\'>' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.DisplayCode + '</td>';
                    getRatesWrp.outHiAir2ndDayDisCodeXFlag = true;
                }
                else
                    Html += '<td id=\'HoAir2ndDay\' class=\'priceMatrixValueSpecial\'>' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.DisplayCode + '</td>';
            }
                    
            if (complexPriceData.High.Outbound.Air.AirNextDay.Detail.DisplayCode == null || complexPriceData.High.Outbound.Air.AirNextDay.Detail.DisplayCode == '')
            {
                String HOAirNextDayAdvDiscount = (complexPriceData.High.Outbound.Air.AirNextDay.Detail.AdvOrderDiscountPercent > 0 ? 'Advance Order Discount: ' + string.valueOf(complexPriceData.High.Outbound.Air.AirNextDay.Detail.AdvOrderDiscountPercent) + '%': '');
                String HOAirNextDayRTDiscount = (complexPriceData.High.Outbound.Air.AirNextDay.Detail.RoundTripDiscountPercent > 0 ? 'Roundtrip Discount: ' + string.valueOf(complexPriceData.High.Outbound.Air.AirNextDay.Detail.RoundTripDiscountPercent) + '%' : '');
                String HOAirNextDayDiscount = HOAirNextDayAdvDiscount + (HOAirNextDayAdvDiscount != '' ? '\n' : '') + HOAirNextDayRTDiscount;
                
                String HOAirNextDayClass = 'priceMatrixValue';
                getRatesWrp.outHiAirNextDayFlag = true;
                getRatesWrp.outHiAirNextDayShipmentFlag = true;
                
                if (q.OB_Shipment_Type__c != null && q.OB_Class_of_Service__c != null && q.OB_Selection__c != null && (q.Message__c == null || q.Message__c == ''))
                {
                    if (q.OB_Shipment_Type__c.toUpperCase() == 'AIR TRANSPORTATION' && q.OB_Class_of_Service__c.toUpperCase() == 'NEXT DAY' && q.OB_Selection__c.toUppercase() == 'HIGH'){
                        HOAirNextDayClass = 'priceMatrixValuePriorSelection';
                        getRatesWrp.outHiAirNextDayShipmentFlag = false;
                    }
                }
                
                Html += '<td id=\'HoAirNextDay\' class=\'' + HOAirNextDayClass + '\' onClick=\'changeOutboundCellColor(this,"HoAirNextDay", "' + HoAirNextDayRates + '"); return false;\' title=\'' + HOAirNextDayDiscount + '\'>' + string.valueOf(complexPriceData.High.Outbound.Air.AirNextDay.Detail.UnitPrice) + (complexPriceData.High.Outbound.Air.AirNextDay.Detail.TotalDiscountPercent > 0 ? ' (-' + string.valueOf(complexPriceData.High.Outbound.Air.AirNextDay.Detail.TotalDiscountPercent) + '%)' : '') + '</td>';
                getRatesWrp.outHiAirNextDayRates = string.valueOf(complexPriceData.High.Outbound.Air.AirNextDay.Detail.UnitPrice) + (complexPriceData.High.Outbound.Air.AirNextDay.Detail.TotalDiscountPercent > 0 ? ' (-' + string.valueOf(complexPriceData.High.Outbound.Air.AirNextDay.Detail.TotalDiscountPercent) + '%)' : '');
            }
            else {
                getRatesWrp.outHiAirNextDayRates = complexPriceData.High.Outbound.Air.AirNextDay.Detail.DisplayCode;
                if (complexPriceData.High.Outbound.Air.AirNextDay.Detail.DisplayCode != null && complexPriceData.High.Outbound.Air.AirNextDay.Detail.Comments != null)                      
                    HoMoMessages.put(complexPriceData.High.Outbound.Air.AirNextDay.Detail.DisplayCode, complexPriceData.High.Outbound.Air.AirNextDay.Detail.Comments);
                
                if (complexPriceData.High.Outbound.Air.AirNextDay.Detail.DisplayCode == 'X'){
                    Html += '<td id=\'HoAirNextDay\' class=\'priceMatrixValueInvalidEntry\'>' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.DisplayCode + '</td>';
                    getRatesWrp.outHiAirNextDayDisCodeXFlag = true;
                }
                else
                    Html += '<td id=\'HoAirNextDay\' class=\'priceMatrixValueSpecial\'>' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.DisplayCode + '</td>';
            }
                    
            Html += '<td class=\'priceMatrixValueNA\'>' + '' + '</td>';
            Html += '</tr>';
            Html += '<tr>'; 
            Html += '<td class=\'priceMatrixTypeColumn\'>' + 'Ground' + '</td>';
            
            if (complexPriceData.High.Outbound.Ground.Ltl.Detail.DisplayCode == null || complexPriceData.High.Outbound.Ground.Ltl.Detail.DisplayCode == '')
            {
                String HOGroundLtlAdvDiscount = (complexPriceData.High.Outbound.Ground.Ltl.Detail.AdvOrderDiscountPercent > 0 ? 'Advance Order Discount: ' + string.valueOf(complexPriceData.High.Outbound.Ground.Ltl.Detail.AdvOrderDiscountPercent) + '%': '');
                String HOGroundLtlRTDiscount = (complexPriceData.High.Outbound.Ground.Ltl.Detail.RoundTripDiscountPercent > 0 ? 'Roundtrip Discount: ' + string.valueOf(complexPriceData.High.Outbound.Ground.Ltl.Detail.RoundTripDiscountPercent) + '%' : '');
                String HOGroundLtlDiscount = HOGroundLtlAdvDiscount + (HOGroundLtlAdvDiscount != '' ? '\n' : '') + HOGroundLtlRTDiscount;
                
                String HOGroundLtlClass = 'priceMatrixValue';
                getRatesWrp.outHiGroundLtlFlag = true;
                getRatesWrp.outHiGroundLtlShipmentFlag = true;
                
                if (q.OB_Shipment_Type__c != null && q.OB_Service_Type__c != null && q.OB_Selection__c != null && (q.Message__c == null || q.Message__c == ''))
                {               
                    if (q.OB_Shipment_Type__c.toUpperCase() == 'GROUND TRANSPORTATION' && q.OB_Service_Type__c.toUpperCase() == 'LTL' && q.OB_Selection__c.toUpperCase() == 'HIGH'){
                        HOGroundLtlClass = 'priceMatrixValuePriorSelection';
                        getRatesWrp.outHiGroundLtlShipmentFlag = false;
                    }
                }
                
                Html += '<td id=\'HoGroundLTL\' class=\'' + HOGroundLtlClass + '\' onClick=\'changeOutboundCellColor(this,"HoGroundLTL", "' + HoGroundLTLRates + '"); return false;\' title=\'' + HOGroundLtlDiscount + '\'>' + string.valueOf(complexPriceData.High.Outbound.Ground.Ltl.Detail.UnitPrice) + (complexPriceData.High.Outbound.Ground.Ltl.Detail.TotalDiscountPercent > 0 ? ' (-' + string.valueOf(complexPriceData.High.Outbound.Ground.Ltl.Detail.TotalDiscountPercent) + '%)' : '') + '</td>';
                getRatesWrp.outHiGroundLtlRates = string.valueOf(complexPriceData.High.Outbound.Ground.Ltl.Detail.UnitPrice) + (complexPriceData.High.Outbound.Ground.Ltl.Detail.TotalDiscountPercent > 0 ? ' (-' + string.valueOf(complexPriceData.High.Outbound.Ground.Ltl.Detail.TotalDiscountPercent) + '%)' : '');
            }
            else {
                getRatesWrp.outHiGroundLtlRates = complexPriceData.High.Outbound.Ground.Ltl.Detail.DisplayCode;
                if (complexPriceData.High.Outbound.Ground.Ltl.Detail.DisplayCode != null && complexPriceData.High.Outbound.Ground.Ltl.Detail.Comments != null)                      
                    HoMoMessages.put(complexPriceData.High.Outbound.Ground.Ltl.Detail.DisplayCode, complexPriceData.High.Outbound.Ground.Ltl.Detail.Comments);
                
                if (complexPriceData.High.Outbound.Ground.Ltl.Detail.DisplayCode == 'X'){
                    Html += '<td id=\'HoGroundLTL\' class=\'priceMatrixValueInvalidEntry\'>' + complexPriceData.High.Outbound.Ground.Ltl.Detail.DisplayCode + '</td>';
                    getRatesWrp.outHiGroundLtlDisCodeXFlag = true;
                }
                else
                    Html += '<td id=\'HoGroundLTL\' class=\'priceMatrixValueSpecial\'>' + complexPriceData.High.Outbound.Ground.Ltl.Detail.DisplayCode + '</td>';
            }           
            
            //Html += '<td class=\'priceMatrixValue\' onClick=\'changeOutboundCellColor(this,"HoGroundLTL", "' + HoGroundLTLRates + '"); return false;\'>' + string.valueOf(complexPriceData.High.Outbound.Ground.Ltl.Detail.UnitPrice) + '</td>';
            //Html += '<td class=\'priceMatrixValue\' onClick=\'changeOutboundCellColor(this,"HoGroundFTL", "' + HoGroundFTLRates + '"); return false;\'>' + string.valueOf(complexPriceData.High.Outbound.Ground.Ftl.Detail.UnitPrice) + '</td>';
            Html += '<td colspan=3 class=\'priceMatrixValueNA\'>' + '</td>';
            Html += '</tr>';
            Html += '<tr>'; 
            Html += '<td class=\'priceMatrixTypeColumn\'>' + 'Local' + '</td>';
            //Html += '<td colspan=4 class=\'priceMatrixValueNA\'>' + '' + '</td>';
            Html += '<td colspan=3 class=\'priceMatrixValueNA\'>' + '' + '</td>';
                    
            if (complexPriceData.High.Outbound.Local.Detail.DisplayCode == null ||  complexPriceData.High.Outbound.Local.Detail.DisplayCode == '')
            {
                String HOLocalClass = 'priceMatrixValue';
                getRatesWrp.outHiLocalFlag = true;
                getRatesWrp.outHiLocalShipmentFlag = true;
                
                if (q.OB_Shipment_Type__c != null && q.OB_Selection__c != null && (q.Message__c == null || q.Message__c == ''))
                {               
                    if (q.OB_Shipment_Type__c.toUpperCase() == 'LOCAL SHIPMENTS' && q.OB_Selection__c.toUpperCase() == 'HIGH'){
                        HOLocalClass = 'priceMatrixValuePriorSelection';    
                        getRatesWrp.outHiLocalShipmentFlag = false;
                    }
                }
                                
                Html += '<td id=\'HoLocal\' class=\'' + HOLocalClass + '\' onClick=\'changeOutboundCellColor(this,"HoLocal", "' + HoLocalRates + '"); return false;\'>' + string.valueOf(complexPriceData.High.Outbound.Local.Detail.UnitPrice) + '</td>';
                getRatesWrp.outHiLocalRates = string.valueOf(complexPriceData.High.Outbound.Local.Detail.UnitPrice) ;
            }
            else
            {
                getRatesWrp.outHiLocalRates = complexPriceData.High.Outbound.Local.Detail.DisplayCode;
                if (complexPriceData.High.Outbound.Local.Detail.DisplayCode != null && complexPriceData.High.Outbound.Local.Detail.Comments != null)                        
                    HoMoMessages.put(complexPriceData.High.Outbound.Local.Detail.DisplayCode, complexPriceData.High.Outbound.Local.Detail.Comments);
                
                if (complexPriceData.High.Outbound.Local.Detail.DisplayCode == 'X'){
                    Html += '<td id=\'HoLocal\' class=\'priceMatrixValueInvalidEntry\'>' + complexPriceData.High.Outbound.Local.Detail.DisplayCode + '</td>';
                    getRatesWrp.outHiLocalDisCodeXFlag = true;
                }
                else
                    Html += '<td id=\'HoLocal\' class=\'priceMatrixValueSpecial\'>' + complexPriceData.High.Outbound.Local.Detail.DisplayCode + '</td>';                        
            }
                        
            Html += '</tr>';
            Html += '</table>';
        }
        else
        {
            /*
                In a custom quote, the Quote_Subject__c field could be different from the direction argument passed
                to the GetRates method. In this case though, even if the quote subject is "ROUNDTRIP", the direction
                value could be Inbound, because Custom Quote flag is checked on the Outbound. In such a case, display
                this message.               
            */
            
            if (q.Quote_Subject__c.toUpperCase() != Direction && q.OB_Custom_Quote__c){
                HoInboundHtmlNoRatesMessage = '<table style=\'border:none\'><tr><td style=\'padding-top: 20px; color: red\'>Outbound shipment is custom quote.</td></tr></table>';
                getRatesWrp.highInOutNoRatesMessageFlag = true;
                highInOutNoRatesMsg.add(HoInboundHtmlNoRatesMessage);
                getRatesWrp.highInOutNoRatesMessage = highInOutNoRatesMsg;
            }
            
            /*
                This else portion below is not required. When Quote_Subject__c is Inbound, the code will always
                execute this parent else portion and result in message display, which is not required since the 
                quote is Inbound. NOTE: In normal quote (i.e. not custom quote), the direction argument is always 
                the same as the Quote_Subject__c field.
            */ 
                        
            //else
            //  HoInboundHtmlNoRatesMessage = '<table style=\'border:none\'><tr><td style=\'padding-top: 20px;\'>To view rates for Outbound shipment, required field values must be provided.</td></tr></table>';
        }
                
        Html += HiInboundHtmlNoRatesMessage + HoInboundHtmlNoRatesMessage;  
        
        map<string, string> HMoMessages = new map<string, string>();
                        
        for(string msg : HiMoMessages.keySet())
            HMoMessages.put(msg, HiMoMessages.get(msg));
            
        for(string msg : HoMoMessages.keySet())
            HMoMessages.put(msg, HoMoMessages.get(msg));                    
                                
        string HMsgTable = '';
        
        for(string msg : HMoMessages.keySet())
        {
            HMsgTable += '<tr><td style=\'color: red; font-weight: bold; width: 20px; text-align: top;\'>' + msg + '</td><td style=\'color: red;\'>' + HMoMessages.get(msg) + '</td></tr>';
        }
        
        if (HMsgTable != ''){
            HMsgTable = '<table style=\'border:none; margin-top: 10px;\'>' + HMsgTable + '</table>';
            getRatesWrp.highMsgTableFlag = true;
            getRatesWrp.highMsgTable = HMoMessages;
        }
        
        Html += HMsgTable;              
        
        Html += '</div>';
                
        Html += '<div id=\'low\'>';
        
        if (direction == 'ROUNDTRIP' || direction == 'INBOUND')
        {   
            string LiAir2ndDayRates = complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.UnitPrice + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.FuelSurcharge + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.LiftGateFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.InsideFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.ResidentialFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.WeekendFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.WaitTimeFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.PalletizationFee + ','  + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.AttemptFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.SubTotal + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.Total + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.RoundTripDiscountPercent + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.AdvReceivingEndDate; 
            string LiAirNextDayRates = complexPriceData.Low.Inbound.Air.AirNextDay.Detail.UnitPrice + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.FuelSurcharge + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.LiftGateFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.InsideFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.ResidentialFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.WeekendFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.WaitTimeFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.PalletizationFee + ','  + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.AttemptFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.SubTotal + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.Total + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.RoundtripDiscountPercent + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.AdvReceivingEndDate;
            string LiGroundLTLRates = complexPriceData.Low.Inbound.Ground.Ltl.Detail.UnitPrice + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.FuelSurcharge + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.LiftGateFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.InsideFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.ResidentialFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.WeekendFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.WaitTimeFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.PalletizationFee + ','  + complexPriceData.Low.Inbound.Ground.Ltl.Detail.AttemptFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.SubTotal + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.Total + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.RoundtripDiscountPercent + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.AdvReceivingEndDate;
            string LiGroundFTLRates = complexPriceData.Low.Inbound.Ground.Ftl.Detail.UnitPrice + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.FuelSurcharge + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.LiftGateFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.InsideFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.ResidentialFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.WeekendFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.WaitTimeFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.PalletizationFee + ','  + complexPriceData.Low.Inbound.Ground.Ftl.Detail.AttemptFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.SubTotal + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.Total + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.RoundtripDiscountPercent + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.AdvReceivingEndDate;          
            string LiLocalRates = complexPriceData.Low.Inbound.Local.Detail.UnitPrice + ',' + complexPriceData.Low.Inbound.Local.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Inbound.Local.Detail.FuelSurcharge + ',' + complexPriceData.Low.Inbound.Local.Detail.LiftGateFee + ',' + complexPriceData.Low.Inbound.Local.Detail.InsideFee + ',' + complexPriceData.Low.Inbound.Local.Detail.ResidentialFee + ',' + complexPriceData.Low.Inbound.Local.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Inbound.Local.Detail.WeekendFee + ',' + complexPriceData.Low.Inbound.Local.Detail.WaitTimeFee + ',' + complexPriceData.Low.Inbound.Local.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Inbound.Local.Detail.PalletizationFee + ','  + complexPriceData.Low.Inbound.Local.Detail.AttemptFee + ',' + complexPriceData.Low.Inbound.Local.Detail.SubTotal + ',' + complexPriceData.Low.Inbound.Local.Detail.Total + ',' + complexPriceData.Low.Inbound.Local.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.Low.Inbound.Local.Detail.RoundTripDiscountPercent + ',' + complexPriceData.Low.Inbound.Local.Detail.AdvReceivingEndDate;
            
            //string LiAir2ndDayRates = complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.UnitPrice + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.FuelSurcharge + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.LiftGateFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.InsideFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.ResidentialFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.WeekendFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.WaitTimeFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.PalletizationFee + ','  + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.AttemptFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.SubTotal + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.Total + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.TotalDiscountPercent + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.AdvReceivingEndDate; 
            //string LiAirNextDayRates = complexPriceData.Low.Inbound.Air.AirNextDay.Detail.UnitPrice + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.FuelSurcharge + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.LiftGateFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.InsideFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.ResidentialFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.WeekendFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.WaitTimeFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.PalletizationFee + ','  + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.AttemptFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.SubTotal + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.Total + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.TotalDiscountPercent + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.AdvReceivingEndDate;
            //string LiGroundLTLRates = complexPriceData.Low.Inbound.Ground.Ltl.Detail.UnitPrice + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.FuelSurcharge + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.LiftGateFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.InsideFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.ResidentialFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.WeekendFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.WaitTimeFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.PalletizationFee + ','  + complexPriceData.Low.Inbound.Ground.Ltl.Detail.AttemptFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.SubTotal + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.Total + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.TotalDiscountPercent + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.AdvReceivingEndDate;
            //string LiGroundFTLRates = complexPriceData.Low.Inbound.Ground.Ftl.Detail.UnitPrice + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.FuelSurcharge + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.LiftGateFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.InsideFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.ResidentialFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.WeekendFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.WaitTimeFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.PalletizationFee + ','  + complexPriceData.Low.Inbound.Ground.Ftl.Detail.AttemptFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.SubTotal + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.Total + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.TotalDiscountPercent + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.AdvReceivingEndDate;               
            //string LiLocalRates = complexPriceData.Low.Inbound.Local.Detail.UnitPrice + ',' + complexPriceData.Low.Inbound.Local.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Inbound.Local.Detail.FuelSurcharge + ',' + complexPriceData.Low.Inbound.Local.Detail.LiftGateFee + ',' + complexPriceData.Low.Inbound.Local.Detail.InsideFee + ',' + complexPriceData.Low.Inbound.Local.Detail.ResidentialFee + ',' + complexPriceData.Low.Inbound.Local.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Inbound.Local.Detail.WeekendFee + ',' + complexPriceData.Low.Inbound.Local.Detail.WaitTimeFee + ',' + complexPriceData.Low.Inbound.Local.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Inbound.Local.Detail.PalletizationFee + ','  + complexPriceData.Low.Inbound.Local.Detail.AttemptFee + ',' + complexPriceData.Low.Inbound.Local.Detail.SubTotal + ',' + complexPriceData.Low.Inbound.Local.Detail.Total + ',' + complexPriceData.Low.Inbound.Local.Detail.TotalDiscountPercent + ',' + complexPriceData.Low.Inbound.Local.Detail.AdvReceivingEndDate;
        
            Html += '<table class=\'priceMatrixTable\'>';
            Html += '<tr class=\'priceMatrixTableHeader\'>';
            Html += '<th class=\'priceMatrixTableHeaderTypeColumn\'>' + 'Inbound' + '</th>';
            Html += '<th class=\'priceMatrixTableHeader\'>' + 'LTL' + '</th>';
            //Html += '<th class=\'priceMatrixTableHeader\'>' + 'FTL' + '</th>';
            Html += '<th class=\'priceMatrixTableHeader\'>' + '2nd Day' + '</th>';
            Html += '<th class=\'priceMatrixTableHeader\'>' + 'Next Day' + '</th>';
            Html += '<th class=\'priceMatrixTableHeader\'>' + 'Other' + '</th>';        
            Html += '</tr>';
            Html += '<tr>'; 
            Html += '<td class=\'priceMatrixTypeColumn\'>' + 'Air' + '</td>';
            Html += '<td colspan=1 class=\'priceMatrixValueNA\'>' + '' + '</td>';
                    
            if (complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.DisplayCode == null || complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.DisplayCode == '')
            {
                String LIAir2ndDayAdvDiscount = (complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.AdvOrderDiscountPercent > 0 ? 'Advance Order Discount: ' + string.valueOf(complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.AdvOrderDiscountPercent) + '%': '');
                String LIAir2ndDayRTDiscount = (complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.RoundTripDiscountPercent > 0 ? 'Roundtrip Discount: ' + string.valueOf(complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.RoundTripDiscountPercent) + '%' : '');
                String LIAir2ndDayDiscount = LIAir2ndDayAdvDiscount + (LIAir2ndDayAdvDiscount != '' ? '\n' : '') + LIAir2ndDayRTDiscount;
                
                String LIAir2ndDayClass = 'priceMatrixValue';
                getRatesWrp.inlowAir2ndDayFlag = true;
                getRatesWrp.inlowAir2ndDayShipmentFlag = true;
                
                if (q.Shipment_Type__c != null && q.Class_of_Service__c != null && q.Selection__c != null && (q.Message__c == null || q.Message__c == ''))
                {
                    if (q.Shipment_Type__c.toUpperCase() == 'AIR TRANSPORTATION' && q.Class_of_Service__c.toUpperCase() == '2ND DAY' && q.Selection__c.toUpperCase() == 'LOW'){
                        LIAir2ndDayClass = 'priceMatrixValuePriorSelection';
                        getRatesWrp.inlowAir2ndDayShipmentFlag = false;
                    }
                }
                                
                Html += '<td id=\'LiAir2ndDay\' class=\'' + LIAir2ndDayClass + '\'  onClick=\'changeInboundCellColor(this,"LiAir2ndDay", "' + LiAir2ndDayRates + '"); return false;\' title=\'' + LIAir2ndDayDiscount + '\'>' + string.valueOf(complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.UnitPrice) + (complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.TotalDiscountPercent > 0 ? ' (-' + string.valueOf(complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.TotalDiscountPercent) + '%)' : '') + '</td>';
                getRatesWrp.inlowAir2ndDayRates = string.valueOf(complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.UnitPrice) + (complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.TotalDiscountPercent > 0 ? ' (-' + string.valueOf(complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.TotalDiscountPercent) + '%)' : '');
            }
            else {
                getRatesWrp.inlowAir2ndDayRates = complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.DisplayCode ;
                if (complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.DisplayCode != null && complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.Comments != null)                        
                    LiMoMessages.put(complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.DisplayCode, complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.Comments);
                
                if (complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.DisplayCode == 'X'){
                    Html += '<td id=\'LiAir2ndDay\' class=\'priceMatrixValueInvalidEntry\'>' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.DisplayCode + '</td>';
                    getRatesWrp.inlowAir2ndDayDisCodeXFlag = true;
                }
                else
                    Html += '<td id=\'LiAir2ndDay\' class=\'priceMatrixValueSpecial\'>' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.DisplayCode + '</td>';
            }
                    
            if (complexPriceData.Low.Inbound.Air.AirNextDay.Detail.DisplayCode == null || complexPriceData.Low.Inbound.Air.AirNextDay.Detail.DisplayCode == '')
            {
                String LIAirNextDayAdvDiscount = (complexPriceData.Low.Inbound.Air.AirNextDay.Detail.AdvOrderDiscountPercent > 0 ? 'Advance Order Discount: ' + string.valueOf(complexPriceData.Low.Inbound.Air.AirNextDay.Detail.AdvOrderDiscountPercent) + '%': '');
                String LIAirNextDayRTDiscount = (complexPriceData.Low.Inbound.Air.AirNextDay.Detail.RoundTripDiscountPercent > 0 ? 'Roundtrip Discount: ' + string.valueOf(complexPriceData.Low.Inbound.Air.AirNextDay.Detail.RoundTripDiscountPercent) + '%' : '');
                String LIAirNextDayDiscount = LIAirNextDayAdvDiscount + (LIAirNextDayAdvDiscount != '' ? '\n' : '') + LIAirNextDayRTDiscount;
                    
                String LIAirNextDayClass = 'priceMatrixValue';
                getRatesWrp.inlowAirNextDayFlag = true;
                getRatesWrp.inlowAirNextDayShipmentFlag = true;
                
                if (q.Shipment_Type__c != null && q.Class_of_Service__c != null && q.Selection__c != null && (q.Message__c == null || q.Message__c == ''))
                {
                    if (q.Shipment_Type__c.toUpperCase() == 'AIR TRANSPORTATION' && q.Class_of_Service__c.toUpperCase() == 'NEXT DAY' && q.Selection__c.toUpperCase() == 'LOW'){
                        LIAirNextDayClass = 'priceMatrixValuePriorSelection';
                        getRatesWrp.inlowAirNextDayShipmentFlag = false;
                    }
                }
                
                Html += '<td id=\'LiAirNextDay\' class=\'' + LIAirNextDayClass + '\'  onClick=\'changeInboundCellColor(this,"LiAirNextDay", "' + LiAirNextDayRates + '"); return false;\' title=\'' + LIAirNextDayDiscount + '\'>' + string.valueOf(complexPriceData.Low.Inbound.Air.AirNextDay.Detail.UnitPrice) + (complexPriceData.Low.Inbound.Air.AirNextDay.Detail.TotalDiscountPercent > 0 ? ' (-' + string.valueOf(complexPriceData.Low.Inbound.Air.AirNextDay.Detail.TotalDiscountPercent) + '%)' : '') + '</td>';
                getRatesWrp.inlowAirNextDayRates = string.valueOf(complexPriceData.Low.Inbound.Air.AirNextDay.Detail.UnitPrice) + (complexPriceData.Low.Inbound.Air.AirNextDay.Detail.TotalDiscountPercent > 0 ? ' (-' + string.valueOf(complexPriceData.Low.Inbound.Air.AirNextDay.Detail.TotalDiscountPercent) + '%)' : '');
            }
            else {
                getRatesWrp.inlowAirNextDayRates = complexPriceData.Low.Inbound.Air.AirNextDay.Detail.DisplayCode;
                if (complexPriceData.Low.Inbound.Air.AirNextDay.Detail.DisplayCode != null && complexPriceData.Low.Inbound.Air.AirNextDay.Detail.Comments != null)
                    LiMoMessages.put(complexPriceData.Low.Inbound.Air.AirNextDay.Detail.DisplayCode, complexPriceData.Low.Inbound.Air.AirNextDay.Detail.Comments);
                
                if (complexPriceData.Low.Inbound.Air.AirNextDay.Detail.DisplayCode == 'X'){
                    Html += '<td id=\'LiAirNextDay\' class=\'priceMatrixValueInvalidEntry\'>' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.DisplayCode + '</td>';
                    getRatesWrp.inlowAirNextDayDisCodeXFlag = true;
                }
                else
                    Html += '<td id=\'LiAirNextDay\' class=\'priceMatrixValueSpecial\'>' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.DisplayCode + '</td>';
            }
                    
            Html += '<td class=\'priceMatrixValueNA\'>' + '' + '</td>';
            Html += '</tr>';
            Html += '<tr>'; 
            Html += '<td class=\'priceMatrixTypeColumn\'>' + 'Ground' + '</td>';
            
            if (complexPriceData.Low.Inbound.Ground.Ltl.Detail.DisplayCode == null || complexPriceData.Low.Inbound.Ground.Ltl.Detail.DisplayCode == '')
            {
                String LIGroundLtlAdvDiscount = (complexPriceData.Low.Inbound.Ground.Ltl.Detail.AdvOrderDiscountPercent > 0 ? 'Advance Order Discount: ' + string.valueOf(complexPriceData.Low.Inbound.Ground.Ltl.Detail.AdvOrderDiscountPercent) + '%': '');
                String LIGroundLtlRTDiscount = (complexPriceData.Low.Inbound.Ground.Ltl.Detail.RoundTripDiscountPercent > 0 ? 'Roundtrip Discount: ' + string.valueOf(complexPriceData.Low.Inbound.Ground.Ltl.Detail.RoundTripDiscountPercent) + '%' : '');
                String LIGroundLtlDiscount = LIGroundLtlAdvDiscount + (LIGroundLtlAdvDiscount != '' ? '\n' : '') + LIGroundLtlRTDiscount;
                        
                String LIGroundLtlClass = 'priceMatrixValue';
                getRatesWrp.inlowGroundLtlFlag = true;
                getRatesWrp.inlowGroundLtlShipmentFlag = true;
                
                if (q.Shipment_Type__c != null && q.Service_Type__c != null && q.Selection__c != null && (q.Message__c == null || q.Message__c == ''))
                {               
                    if (q.Shipment_Type__c.toUpperCase() == 'GROUND TRANSPORTATION' && q.Service_Type__c.toUpperCase() == 'LTL' && q.Selection__c.toUpperCase() == 'LOW'){
                        LIGroundLtlClass = 'priceMatrixValuePriorSelection';
                        getRatesWrp.inlowGroundLtlShipmentFlag = false;
                    }
                }
                
                Html += '<td id=\'LiGroundLTL\' class=\'' + LIGroundLtlClass + '\' onClick=\'changeInboundCellColor(this,"LiGroundLTL", "' + LiGroundLTLRates + '"); return false;\' title=\'' + LIGroundLtlDiscount + '\'>' + string.valueOf(complexPriceData.Low.Inbound.Ground.Ltl.Detail.UnitPrice) + (complexPriceData.Low.Inbound.Ground.Ltl.Detail.TotalDiscountPercent > 0 ? ' (-' + string.valueOf(complexPriceData.Low.Inbound.Ground.Ltl.Detail.TotalDiscountPercent) + '%)' : '') + '</td>';
                getRatesWrp.inlowGroundLtlRates = string.valueOf(complexPriceData.Low.Inbound.Ground.Ltl.Detail.UnitPrice) + (complexPriceData.Low.Inbound.Ground.Ltl.Detail.TotalDiscountPercent > 0 ? ' (-' + string.valueOf(complexPriceData.Low.Inbound.Ground.Ltl.Detail.TotalDiscountPercent) + '%)' : '');
            }
            else {
                getRatesWrp.inlowGroundLtlRates = complexPriceData.Low.Inbound.Ground.Ltl.Detail.DisplayCode;
                if (complexPriceData.Low.Inbound.Ground.Ltl.Detail.DisplayCode != null && complexPriceData.Low.Inbound.Ground.Ltl.Detail.Comments != null)                      
                    LiMoMessages.put(complexPriceData.Low.Inbound.Ground.Ltl.Detail.DisplayCode, complexPriceData.Low.Inbound.Ground.Ltl.Detail.Comments);
                
                if (complexPriceData.Low.Inbound.Ground.Ltl.Detail.DisplayCode == 'X'){
                    Html += '<td id=\'LiGroundLTL\' class=\'priceMatrixValueInvalidEntry\'>' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.DisplayCode + '</td>';
                    getRatesWrp.inlowGroundLtlDisCodeXFlag = true;
                }
                else
                    Html += '<td id=\'LiGroundLTL\' class=\'priceMatrixValueSpecial\'>' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.DisplayCode + '</td>';
            }
                        
            //Html += '<td class=\'priceMatrixValue\'  onClick=\'changeInboundCellColor(this,"LiGroundLTL", "' + LiGroundLTLRates + '"); return false;\'>' + string.valueOf(complexPriceData.Low.Inbound.Ground.Ltl.Detail.UnitPrice) + '</td>';
            //Html += '<td class=\'priceMatrixValue\'  onClick=\'changeInboundCellColor(this,"LiGroundFTL", "' + LiGroundFTLRates + '"); return false;\'>' + string.valueOf(complexPriceData.Low.Inbound.Ground.Ftl.Detail.UnitPrice) + '</td>';
            Html += '<td colspan=3 class=\'priceMatrixValueNA\'>' + '</td>';
            Html += '</tr>';
            Html += '<tr>'; 
            Html += '<td class=\'priceMatrixTypeColumn\'>' + 'Local' + '</td>';
            //Html += '<td colspan=4 class=\'priceMatrixValueNA\'>' + '' + '</td>';
            Html += '<td colspan=3 class=\'priceMatrixValueNA\'>' + '' + '</td>';
                    
            if (complexPriceData.Low.Inbound.Local.Detail.DisplayCode == null || complexPriceData.Low.Inbound.Local.Detail.DisplayCode == '')
            {
                String LILocalClass = 'priceMatrixValue';
                getRatesWrp.inlowLocalFlag = true;
                getRatesWrp.inlowLocalShipmentFlag = true;
                
                if (q.Shipment_Type__c != null && q.Selection__c != null && (q.Message__c == null || q.Message__c == ''))
                {               
                    if (q.Shipment_Type__c.toUpperCase() == 'LOCAL SHIPMENTS' && q.Selection__c.toUpperCase() == 'LOW'){
                        LILocalClass = 'priceMatrixValuePriorSelection';    
                        getRatesWrp.inlowLocalShipmentFlag = false;
                    }
                }
                        
                Html += '<td id=\'LiLocal\' class=\'' + LILocalClass + '\'  onClick=\'changeInboundCellColor(this,"LiLocal", "' + LiLocalRates + '"); return false;\'>' + string.valueOf(complexPriceData.Low.Inbound.Local.Detail.UnitPrice) + '</td>';
                getRatesWrp.inlowLocalRates = string.valueOf(complexPriceData.Low.Inbound.Local.Detail.UnitPrice);
            }
            else
            {
                getRatesWrp.inlowLocalRates = complexPriceData.Low.Inbound.Local.Detail.DisplayCode;
                if (complexPriceData.Low.Inbound.Local.Detail.DisplayCode != null && complexPriceData.Low.Inbound.Local.Detail.Comments != null)                        
                    LiMoMessages.put(complexPriceData.Low.Inbound.Local.Detail.DisplayCode, complexPriceData.Low.Inbound.Local.Detail.Comments);
                
                if (complexPriceData.Low.Inbound.Local.Detail.DisplayCode == 'X'){
                    Html += '<td id=\'LiLocal\' class=\'priceMatrixValueInvalidEntry\'>' + complexPriceData.Low.Inbound.Local.Detail.DisplayCode + '</td>';
                    getRatesWrp.inlowLocalDisCodeXFlag = true;
                }
                else
                    Html += '<td id=\'LiLocal\' class=\'priceMatrixValueSpecial\'>' + complexPriceData.Low.Inbound.Local.Detail.DisplayCode + '</td>';                      
            }
            
            Html += '</tr>';
            Html += '</table>';
        }
        else
        {
            /*
                In a custom quote, the Quote_Subject__c field could be different from the direction argument passed
                to the GetRates method. In this case though, even if the quote subject is "ROUNDTRIP", the direction
                value could be Outbound, because Custom Quote flag is checked on the Inbound. In such a case, display
                this message.               
            */
            
            if (q.Quote_Subject__c.toUpperCase() != Direction && q.Custom_Quote__c){
                LiInboundHtmlNoRatesMessage = '<table style=\'border:none\'><tr><td style=\'padding-top: 20px; color: red\'>Inbound shipment is custom quote.</td></tr></table>';
                getRatesWrp.lowInOutNoRatesMessageFlag = true;
                lowInOutNoRatesMsg.add(LiInboundHtmlNoRatesMessage);
                getRatesWrp.lowInOutNoRatesMessage = lowInOutNoRatesMsg;
            }
            
            /*
                This else portion below is not required. When Quote_Subject__c is Outbound, the code will always
                execute this parent else portion and result in message display, which is not required since the 
                quote is Outbound. NOTE: In normal quote (i.e. not custom quote), the direction argument is always 
                the same as the Quote_Subject__c field.
            */ 
                            
            //else
            //  LiInboundHtmlNoRatesMessage = '<table style=\'border:none\'><tr><td style=\'padding-top: 20px;\'>To view rates for Inbound shipment, required field values must be provided.</td></tr></table>';
        }           
                    
        if (direction == 'ROUNDTRIP' || direction == 'OUTBOUND')
        {
            string LoAir2ndDayRates = complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.UnitPrice + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.FuelSurcharge + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.LiftGateFee + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.InsideFee + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.ResidentialFee + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.WeekendFee + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.WaitTimeFee + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.PalletizationFee + ','  + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.AttemptFee + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.SubTotal + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.Total + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.RoundTripDiscountPercent + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.AdvReceivingEndDate; 
            string LoAirNextDayRates = complexPriceData.Low.Outbound.Air.AirNextDay.Detail.UnitPrice + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.FuelSurcharge + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.LiftGateFee + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.InsideFee + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.ResidentialFee + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.WeekendFee + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.WaitTimeFee + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.PalletizationFee + ','  + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.AttemptFee + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.SubTotal + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.Total + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.RoundtripDiscountPercent + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.AdvReceivingEndDate;
            string LoGroundLTLRates = complexPriceData.Low.Outbound.Ground.Ltl.Detail.UnitPrice + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.FuelSurcharge + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.LiftGateFee + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.InsideFee + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.ResidentialFee + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.WeekendFee + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.WaitTimeFee + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.PalletizationFee + ','  + complexPriceData.Low.Outbound.Ground.Ltl.Detail.AttemptFee + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.SubTotal + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.Total + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.RoundtripDiscountPercent + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.AdvReceivingEndDate;
            string LoGroundFTLRates = complexPriceData.Low.Outbound.Ground.Ftl.Detail.UnitPrice + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.FuelSurcharge + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.LiftGateFee + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.InsideFee + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.ResidentialFee + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.WeekendFee + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.WaitTimeFee + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.PalletizationFee + ','  + complexPriceData.Low.Outbound.Ground.Ftl.Detail.AttemptFee + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.SubTotal + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.Total + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.RoundtripDiscountPercent + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.AdvReceivingEndDate;         
            string LoLocalRates = complexPriceData.Low.Outbound.Local.Detail.UnitPrice + ',' + complexPriceData.Low.Outbound.Local.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Outbound.Local.Detail.FuelSurcharge + ',' + complexPriceData.Low.Outbound.Local.Detail.LiftGateFee + ',' + complexPriceData.Low.Outbound.Local.Detail.InsideFee + ',' + complexPriceData.Low.Outbound.Local.Detail.ResidentialFee + ',' + complexPriceData.Low.Outbound.Local.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Outbound.Local.Detail.WeekendFee + ',' + complexPriceData.Low.Outbound.Local.Detail.WaitTimeFee + ',' + complexPriceData.Low.Outbound.Local.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Outbound.Local.Detail.PalletizationFee + ','  + complexPriceData.Low.Outbound.Local.Detail.AttemptFee + ',' + complexPriceData.Low.Outbound.Local.Detail.SubTotal + ',' + complexPriceData.Low.Outbound.Local.Detail.Total + ',' + complexPriceData.Low.Outbound.Local.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.Low.Outbound.Local.Detail.RoundTripDiscountPercent + ',' + complexPriceData.Low.Outbound.Local.Detail.AdvReceivingEndDate;
            
            Html += '<table class=\'priceMatrixTable\'>';
            Html += '<tr class=\'priceMatrixTableHeader\'>';
            Html += '<th class=\'priceMatrixTableHeaderTypeColumn\'>' + 'Outbound' + '</th>';
            Html += '<th class=\'priceMatrixTableHeader\'>' + 'LTL' + '</th>';
            //Html += '<th class=\'priceMatrixTableHeader\'>' + 'FTL' + '</th>';
            Html += '<th class=\'priceMatrixTableHeader\'>' + '2nd Day' + '</th>';
            Html += '<th class=\'priceMatrixTableHeader\'>' + 'Next Day' + '</th>';
            Html += '<th class=\'priceMatrixTableHeader\'>' + 'Other' + '</th>';        
            Html += '</tr>';
            Html += '<tr>'; 
            Html += '<td class=\'priceMatrixTypeColumn\'>' + 'Air' + '</td>';
            Html += '<td colspan=1 class=\'priceMatrixValueNA\'>' + '' + '</td>';
            
            if (complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.DisplayCode == null || complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.DisplayCode == '')
            {
                String LOAir2ndDayAdvDiscount = (complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.AdvOrderDiscountPercent > 0 ? 'Advance Order Discount: ' + string.valueOf(complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.AdvOrderDiscountPercent) + '%': '');
                String LOAir2ndDayRTDiscount = (complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.RoundTripDiscountPercent > 0 ? 'Roundtrip Discount: ' + string.valueOf(complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.RoundTripDiscountPercent) + '%' : '');
                String LOAir2ndDayDiscount = LOAir2ndDayAdvDiscount + (LOAir2ndDayAdvDiscount != '' ? '\n' : '') + LOAir2ndDayRTDiscount;
                
                String LOAir2ndDayClass = 'priceMatrixValue';
                getRatesWrp.outLowAir2ndDayFlag = true;
                getRatesWrp.outLowAir2ndDayShipmentFlag = true;
                
                if (q.OB_Shipment_Type__c != null && q.OB_Class_of_Service__c != null && q.OB_Selection__c != null && (q.Message__c == null || q.Message__c == ''))
                {
                    if (q.OB_Shipment_Type__c.toUpperCase() == 'AIR TRANSPORTATION' && q.OB_Class_of_Service__c.toUpperCase() == '2ND DAY' && q.OB_Selection__c.toUpperCase() == 'LOW'){
                        LOAir2ndDayClass = 'priceMatrixValuePriorSelection';
                        getRatesWrp.outLowAir2ndDayShipmentFlag = false;
                    }
                }
                                
                Html += '<td id=\'LoAir2ndDay\' class=\'' + LOAir2ndDayClass + '\' onClick=\'changeOutboundCellColor(this,"LoAir2ndDay", "' + LoAir2ndDayRates + '"); return false;\' title=\'' + LOAir2ndDayDiscount + '\'>' + string.valueOf(complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.UnitPrice) + (complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.TotalDiscountPercent > 0 ? ' (-' + string.valueOf(complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.TotalDiscountPercent) + '%)' : '') + '</td>';
                getRatesWrp.outLowAir2ndDayRates =  string.valueOf(complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.UnitPrice) + (complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.TotalDiscountPercent > 0 ? ' (-' + string.valueOf(complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.TotalDiscountPercent) + '%)' : '');
            }                       
            else {
                getRatesWrp.outLowAir2ndDayRates = complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.DisplayCode;
                if (complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.DisplayCode != null && complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.Comments != null)                      
                    LoMoMessages.put(complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.DisplayCode, complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.Comments);
                
                if (complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.DisplayCode == 'X'){
                    Html += '<td id=\'LoAir2ndDay\' class=\'priceMatrixValueInvalidEntry\'>' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.DisplayCode + '</td>';
                    getRatesWrp.outLowAir2ndDayDisCodeXFlag = true;
                }
                else
                    Html += '<td id=\'LoAir2ndDay\' class=\'priceMatrixValueSpecial\'>' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.DisplayCode + '</td>';
            }
                    
            if (complexPriceData.Low.Outbound.Air.AirNextDay.Detail.DisplayCode == null || complexPriceData.Low.Outbound.Air.AirNextDay.Detail.DisplayCode == '')
            {
                String LOAirNextDayAdvDiscount = (complexPriceData.Low.Outbound.Air.AirNextDay.Detail.AdvOrderDiscountPercent > 0 ? 'Advance Order Discount: ' + string.valueOf(complexPriceData.Low.Outbound.Air.AirNextDay.Detail.AdvOrderDiscountPercent) + '%': '');
                String LOAirNextDayRTDiscount = (complexPriceData.Low.Outbound.Air.AirNextDay.Detail.RoundTripDiscountPercent > 0 ? 'Roundtrip Discount: ' + string.valueOf(complexPriceData.Low.Outbound.Air.AirNextDay.Detail.RoundTripDiscountPercent) + '%' : '');
                String LOAirNextDayDiscount = LOAirNextDayAdvDiscount + (LOAirNextDayAdvDiscount != '' ? '\n' : '') + LOAirNextDayRTDiscount;
                
                String LOAirNextDayClass = 'priceMatrixValue';
                getRatesWrp.outLowAirNextDayFlag = true;
                getRatesWrp.outLowAirNextDayShipmentFlag = true;
                
                if (q.OB_Shipment_Type__c != null && q.OB_Class_of_Service__c != null && q.OB_Selection__c != null && (q.Message__c == null || q.Message__c == ''))
                {
                    if (q.OB_Shipment_Type__c.toUpperCase() == 'AIR TRANSPORTATION' && q.OB_Class_of_Service__c.toUpperCase() == 'NEXT DAY' && q.OB_Selection__c.toUpperCase() == 'LOW'){
                        LOAirNextDayClass = 'priceMatrixValuePriorSelection';
                        getRatesWrp.outLowAirNextDayShipmentFlag = false;
                    }
                }
                
                Html += '<td id=\'LoAirNextDay\' class=\'' + LOAirNextDayClass + '\' onClick=\'changeOutboundCellColor(this,"LoAirNextDay", "' + LoAirNextDayRates + '"); return false;\' title=\'' + LOAirNextDayDiscount + '\'>' + string.valueOf(complexPriceData.Low.Outbound.Air.AirNextDay.Detail.UnitPrice) + (complexPriceData.Low.Outbound.Air.AirNextDay.Detail.TotalDiscountPercent > 0 ? ' (-' + string.valueOf(complexPriceData.Low.Outbound.Air.AirNextDay.Detail.TotalDiscountPercent) + '%)' : '') + '</td>';
                getRatesWrp.outLowAirNextDayRates = string.valueOf(complexPriceData.Low.Outbound.Air.AirNextDay.Detail.UnitPrice) + (complexPriceData.Low.Outbound.Air.AirNextDay.Detail.TotalDiscountPercent > 0 ? ' (-' + string.valueOf(complexPriceData.Low.Outbound.Air.AirNextDay.Detail.TotalDiscountPercent) + '%)' : '');
            }
            else {
                getRatesWrp.outLowAirNextDayRates = complexPriceData.Low.Outbound.Air.AirNextDay.Detail.DisplayCode;
                if (complexPriceData.Low.Outbound.Air.AirNextDay.Detail.DisplayCode != null && complexPriceData.Low.Outbound.Air.AirNextDay.Detail.Comments != null)                        
                    LoMoMessages.put(complexPriceData.Low.Outbound.Air.AirNextDay.Detail.DisplayCode, complexPriceData.Low.Outbound.Air.AirNextDay.Detail.Comments);
                
                if (complexPriceData.Low.Outbound.Air.AirNextDay.Detail.DisplayCode == 'X'){
                    Html += '<td id=\'LoAirNextDay\' class=\'priceMatrixValueInvalidEntry\'>' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.DisplayCode + '</td>';
                    getRatesWrp.outLowAirNextDayDisCodeXFlag  = true;
                }
                else
                    Html += '<td id=\'LoAirNextDay\' class=\'priceMatrixValueSpecial\'>' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.DisplayCode + '</td>';
            }                   
                    
            Html += '<td class=\'priceMatrixValueNA\'>' + '' + '</td>';
            Html += '</tr>';
            Html += '<tr>'; 
            Html += '<td class=\'priceMatrixTypeColumn\'>' + 'Ground' + '</td>';
            
            if (complexPriceData.Low.Outbound.Ground.Ltl.Detail.DisplayCode == null || complexPriceData.Low.Outbound.Ground.Ltl.Detail.DisplayCode == '')
            {
                String LOGroundLtlAdvDiscount = (complexPriceData.Low.Outbound.Ground.Ltl.Detail.AdvOrderDiscountPercent > 0 ? 'Advance Order Discount: ' + string.valueOf(complexPriceData.Low.Outbound.Ground.Ltl.Detail.AdvOrderDiscountPercent) + '%': '');
                String LOGroundLtlRTDiscount = (complexPriceData.Low.Outbound.Ground.Ltl.Detail.RoundTripDiscountPercent > 0 ? 'Roundtrip Discount: ' + string.valueOf(complexPriceData.Low.Outbound.Ground.Ltl.Detail.RoundTripDiscountPercent) + '%' : '');
                String LOGroundLtlDiscount = LOGroundLtlAdvDiscount + (LOGroundLtlAdvDiscount != '' ? '\n' : '') + LOGroundLtlRTDiscount;
                
                String LOGroundLtlClass = 'priceMatrixValue';
                getRatesWrp.outLowGroundLtlFlag = true;
                getRatesWrp.outLowGroundLtlShipmentFlag = true;
                
                if (q.OB_Shipment_Type__c != null && q.OB_Service_Type__c != null && q.OB_Selection__c != null && (q.Message__c == null || q.Message__c == ''))
                {               
                    if (q.OB_Shipment_Type__c.toUpperCase() == 'GROUND TRANSPORTATION' && q.OB_Service_Type__c.toUpperCase() == 'LTL' && q.OB_Selection__c.toUpperCase() == 'LOW'){
                        LOGroundLtlClass = 'priceMatrixValuePriorSelection';
                        getRatesWrp.outLowGroundLtlShipmentFlag = false;
                    }
                }
                
                Html += '<td id=\'LoGroundLTL\' class=\'' + LOGroundLtlClass + '\' onClick=\'changeOutboundCellColor(this,"LoGroundLTL", "' + LoGroundLTLRates + '"); return false;\' title=\'' + LOGroundLtlDiscount + '\'>' + string.valueOf(complexPriceData.Low.Outbound.Ground.Ltl.Detail.UnitPrice) + (complexPriceData.Low.Outbound.Ground.Ltl.Detail.TotalDiscountPercent > 0 ? ' (-' + string.valueOf(complexPriceData.Low.Outbound.Ground.Ltl.Detail.TotalDiscountPercent) + '%)' : '') + '</td>';
                getRatesWrp.outLowGroundLtlRates = string.valueOf(complexPriceData.Low.Outbound.Ground.Ltl.Detail.UnitPrice) + (complexPriceData.Low.Outbound.Ground.Ltl.Detail.TotalDiscountPercent > 0 ? ' (-' + string.valueOf(complexPriceData.Low.Outbound.Ground.Ltl.Detail.TotalDiscountPercent) + '%)' : '');
            }
            else {
                getRatesWrp.outLowGroundLtlRates = complexPriceData.Low.Outbound.Ground.Ltl.Detail.DisplayCode;
                if (complexPriceData.Low.Outbound.Ground.Ltl.Detail.DisplayCode != null && complexPriceData.Low.Outbound.Ground.Ltl.Detail.Comments != null)                        
                    LoMoMessages.put(complexPriceData.Low.Outbound.Ground.Ltl.Detail.DisplayCode, complexPriceData.Low.Outbound.Ground.Ltl.Detail.Comments);
                
                if (complexPriceData.Low.Outbound.Ground.Ltl.Detail.DisplayCode == 'X'){
                    Html += '<td id=\'LoGroundLTL\' class=\'priceMatrixValueInvalidEntry\'>' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.DisplayCode + '</td>';
                    getRatesWrp.outLowGroundLtlDisCodeXFlag = true;
                }
                else
                    Html += '<td id=\'LoGroundLTL\' class=\'priceMatrixValueSpecial\'>' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.DisplayCode + '</td>';
            }
                        
            //Html += '<td class=\'priceMatrixValue\' onClick=\'changeOutboundCellColor(this,"LoGroundLTL", "' + LoGroundLTLRates + '"); return false;\'>' + string.valueOf(complexPriceData.Low.Outbound.Ground.Ltl.Detail.UnitPrice) + '</td>';
            //Html += '<td class=\'priceMatrixValue\' onClick=\'changeOutboundCellColor(this,"LoGroundFTL", "' + LoGroundFTLRates + '"); return false;\'>' + string.valueOf(complexPriceData.Low.Outbound.Ground.Ftl.Detail.UnitPrice) + '</td>';
            Html += '<td colspan=3 class=\'priceMatrixValueNA\'>' + '</td>';
            Html += '</tr>';
            Html += '<tr>'; 
            Html += '<td class=\'priceMatrixTypeColumn\'>' + 'Local' + '</td>';
            //Html += '<td colspan=4 class=\'priceMatrixValueNA\'>' + '' + '</td>';
            Html += '<td colspan=3 class=\'priceMatrixValueNA\'>' + '' + '</td>';
            
            if (complexPriceData.Low.Outbound.Local.Detail.DisplayCode == null || complexPriceData.Low.Outbound.Local.Detail.DisplayCode == '')
            {
                String LOLocalClass = 'priceMatrixValue';
                getRatesWrp.outLowLocalFlag = true;
                getRatesWrp.outLowLocalShipmentFlag = true;
                
                if (q.OB_Shipment_Type__c != null && q.OB_Selection__c != null && (q.Message__c == null || q.Message__c == ''))
                {               
                    if (q.OB_Shipment_Type__c.toUpperCase() == 'LOCAL SHIPMENTS' && q.OB_Selection__c.toUpperCase() == 'LOW'){
                        LOLocalClass = 'priceMatrixValuePriorSelection';
                        getRatesWrp.outLowLocalShipmentFlag = false;
                    }
                }
                                
                Html += '<td id=\'LoLocal\' class=\'' + LOLocalClass + '\' onClick=\'changeOutboundCellColor(this,"LoLocal", "' + LoLocalRates + '"); return false;\'>' + string.valueOf(complexPriceData.Low.Outbound.Local.Detail.UnitPrice) + '</td>';
                getRatesWrp.outLowLocalRates =  string.valueOf(complexPriceData.Low.Outbound.Local.Detail.UnitPrice);
            }
            else
            {
                getRatesWrp.outLowLocalRates = complexPriceData.Low.Outbound.Local.Detail.DisplayCode;
                if (complexPriceData.Low.Outbound.Local.Detail.DisplayCode != null && complexPriceData.Low.Outbound.Local.Detail.Comments != null)                      
                    LoMoMessages.put(complexPriceData.Low.Outbound.Local.Detail.DisplayCode, complexPriceData.Low.Outbound.Local.Detail.Comments);
                
                if (complexPriceData.Low.Outbound.Local.Detail.DisplayCode == 'X'){
                    Html += '<td id=\'LoLocal\' class=\'priceMatrixValueInvalidEntry\'>' + complexPriceData.Low.Outbound.Local.Detail.DisplayCode + '</td>';
                    getRatesWrp.outLowLocalDisCodeXFlag = true;
                }
                else
                    Html += '<td id=\'LoLocal\' class=\'priceMatrixValueSpecial\'>' + complexPriceData.Low.Outbound.Local.Detail.DisplayCode + '</td>';                     
            }
            
            Html += '</tr>';
            Html += '</table>';
        }
        else
        {
            /*
                In a custom quote, the Quote_Subject__c field could be different from the direction argument passed
                to the GetRates method. In this case though, even if the quote subject is "ROUNDTRIP", the direction
                value could be Inbound, because Custom Quote flag is checked on the Outbound. In such a case, display
                this message.               
            */
            
            if (q.Quote_Subject__c.toUpperCase() != Direction && q.OB_Custom_Quote__c){
                LoInboundHtmlNoRatesMessage = '<table style=\'border:none\'><tr><td style=\'padding-top: 20px; color: red\'>Outbound shipment is custom quote.</td></tr></table>';
                getRatesWrp.lowInOutNoRatesMessageFlag = true;
                lowInOutNoRatesMsg.add(LoInboundHtmlNoRatesMessage);
                getRatesWrp.lowInOutNoRatesMessage = lowInOutNoRatesMsg;
            }
            
            /*
                This else portion below is not required. When Quote_Subject__c is Inbound, the code will always
                execute this parent else portion and result in message display, which is not required since the 
                quote is Inbound. NOTE: In normal quote (i.e. not custom quote), the direction argument is always 
                the same as the Quote_Subject__c field.
            */ 
                
            //else
            //  LoInboundHtmlNoRatesMessage = '<table style=\'border:none\'><tr><td style=\'padding-top: 20px;\'>To view rates for Outbound shipment, required field values must be provided.</td></tr></table>';
        }
                
        Html += LiInboundHtmlNoRatesMessage + LoInboundHtmlNoRatesMessage;
        
        map<string, string> LMoMessages = new map<string, string>();
                        
        for(string msg : LiMoMessages.keySet())
            LMoMessages.put(msg, LiMoMessages.get(msg));
            
        for(string msg : LoMoMessages.keySet())
            LMoMessages.put(msg, LoMoMessages.get(msg));                    
                        
        string LMsgTable = '';
                
        for(string msg : LMoMessages.keySet())
        {
            LMsgTable += '<tr style=\'padding-top: 20px;\'><td style=\'color: red; font-weight: bold; width: 20px; text-align: top;\'>' + msg + '</td><td style=\'color: red;\'>' + HMoMessages.get(msg) + '</td></tr>';
        }
        
        if (LMsgTable != ''){
            LMsgTable = '<table style=\'border:none; margin-top: 10px;\'>' + LMsgTable + '</table>';
            getRatesWrp.lowMsgTableFlag = true;
            getRatesWrp.lowMsgTable = HMoMessages;
        }
        
        Html += LMsgTable;
                
        Html += '</div>';
        
        
        //Build custom tab
        
        //First build the list of selectable shipment type and class of service options
        


        Html += '<div id=\'custom\'>';
        
        if (direction == 'ROUNDTRIP' || direction == 'INBOUND')
        {
            string LiAir2ndDayRates = complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.UnitPrice + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.FuelSurcharge + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.LiftGateFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.InsideFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.ResidentialFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.WeekendFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.WaitTimeFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.PalletizationFee + ','  + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.AttemptFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.SubTotal + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.Total + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.RoundTripDiscountPercent + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.AdvReceivingEndDate; 
            string LiAirNextDayRates = complexPriceData.Low.Inbound.Air.AirNextDay.Detail.UnitPrice + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.FuelSurcharge + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.LiftGateFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.InsideFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.ResidentialFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.WeekendFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.WaitTimeFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.PalletizationFee + ','  + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.AttemptFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.SubTotal + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.Total + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.RoundtripDiscountPercent + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.AdvReceivingEndDate;
            string LiGroundLTLRates = complexPriceData.Low.Inbound.Ground.Ltl.Detail.UnitPrice + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.FuelSurcharge + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.LiftGateFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.InsideFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.ResidentialFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.WeekendFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.WaitTimeFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.PalletizationFee + ','  + complexPriceData.Low.Inbound.Ground.Ltl.Detail.AttemptFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.SubTotal + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.Total + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.RoundtripDiscountPercent + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.AdvReceivingEndDate;
            string LiGroundFTLRates = complexPriceData.Low.Inbound.Ground.Ftl.Detail.UnitPrice + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.FuelSurcharge + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.LiftGateFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.InsideFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.ResidentialFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.WeekendFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.WaitTimeFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.PalletizationFee + ','  + complexPriceData.Low.Inbound.Ground.Ftl.Detail.AttemptFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.SubTotal + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.Total + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.RoundtripDiscountPercent + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.AdvReceivingEndDate;          
            string LiLocalRates = complexPriceData.Low.Inbound.Local.Detail.UnitPrice + ',' + complexPriceData.Low.Inbound.Local.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Inbound.Local.Detail.FuelSurcharge + ',' + complexPriceData.Low.Inbound.Local.Detail.LiftGateFee + ',' + complexPriceData.Low.Inbound.Local.Detail.InsideFee + ',' + complexPriceData.Low.Inbound.Local.Detail.ResidentialFee + ',' + complexPriceData.Low.Inbound.Local.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Inbound.Local.Detail.WeekendFee + ',' + complexPriceData.Low.Inbound.Local.Detail.WaitTimeFee + ',' + complexPriceData.Low.Inbound.Local.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Inbound.Local.Detail.PalletizationFee + ','  + complexPriceData.Low.Inbound.Local.Detail.AttemptFee + ',' + complexPriceData.Low.Inbound.Local.Detail.SubTotal + ',' + complexPriceData.Low.Inbound.Local.Detail.Total + ',' + complexPriceData.Low.Inbound.Local.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.Low.Inbound.Local.Detail.RoundTripDiscountPercent + ',' + complexPriceData.Low.Inbound.Local.Detail.AdvReceivingEndDate;
    
            string HiAir2ndDayRates = complexPriceData.High.Inbound.Air.Air2ndDay.Detail.UnitPrice + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.FuelUnitSurcharge + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.FuelSurcharge + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.LiftGateFee + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.InsideFee + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.ResidentialFee + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.AMSpecifiedFee + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.WeekendFee + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.WaitTimeFee + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.AdditionalLaborFee + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.PalletizationFee + ','  + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.AttemptFee + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.SubTotal + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.Total + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.RoundTripDiscountPercent + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.AdvReceivingEndDate; 
            string HiAirNextDayRates = complexPriceData.High.Inbound.Air.AirNextDay.Detail.UnitPrice + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.FuelUnitSurcharge + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.FuelSurcharge + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.LiftGateFee + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.InsideFee + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.ResidentialFee + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.AMSpecifiedFee + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.WeekendFee + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.WaitTimeFee + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.AdditionalLaborFee + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.PalletizationFee + ','  + complexPriceData.High.Inbound.Air.AirNextDay.Detail.AttemptFee + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.SubTotal + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.Total + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.RoundtripDiscountPercent + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.AdvReceivingEndDate;
            string HiGroundLTLRates = complexPriceData.High.Inbound.Ground.Ltl.Detail.UnitPrice + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.FuelUnitSurcharge + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.FuelSurcharge + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.LiftGateFee + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.InsideFee + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.ResidentialFee + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.AMSpecifiedFee + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.WeekendFee + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.WaitTimeFee + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.AdditionalLaborFee + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.PalletizationFee + ','  + complexPriceData.High.Inbound.Ground.Ltl.Detail.AttemptFee + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.SubTotal + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.Total + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.RoundtripDiscountPercent + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.AdvReceivingEndDate;
            string HiGroundFTLRates = complexPriceData.High.Inbound.Ground.Ftl.Detail.UnitPrice + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.FuelUnitSurcharge + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.FuelSurcharge + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.LiftGateFee + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.InsideFee + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.ResidentialFee + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.AMSpecifiedFee + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.WeekendFee + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.WaitTimeFee + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.AdditionalLaborFee + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.PalletizationFee + ','  + complexPriceData.High.Inbound.Ground.Ftl.Detail.AttemptFee + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.SubTotal + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.Total + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.RoundtripDiscountPercent + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.AdvReceivingEndDate;         
            string HiLocalRates = complexPriceData.High.Inbound.Local.Detail.UnitPrice + ',' + complexPriceData.High.Inbound.Local.Detail.FuelUnitSurcharge + ',' + complexPriceData.High.Inbound.Local.Detail.FuelSurcharge + ',' + complexPriceData.High.Inbound.Local.Detail.LiftGateFee + ',' + complexPriceData.High.Inbound.Local.Detail.InsideFee + ',' + complexPriceData.High.Inbound.Local.Detail.ResidentialFee + ',' + complexPriceData.High.Inbound.Local.Detail.AMSpecifiedFee + ',' + complexPriceData.High.Inbound.Local.Detail.WeekendFee + ',' + complexPriceData.High.Inbound.Local.Detail.WaitTimeFee + ',' + complexPriceData.High.Inbound.Local.Detail.AdditionalLaborFee + ',' + complexPriceData.High.Inbound.Local.Detail.PalletizationFee + ','  + complexPriceData.High.Inbound.Local.Detail.AttemptFee + ',' + complexPriceData.High.Inbound.Local.Detail.SubTotal + ',' + complexPriceData.High.Inbound.Local.Detail.Total + ',' + complexPriceData.High.Inbound.Local.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.High.Inbound.Local.Detail.RoundTripDiscountPercent + ',' + complexPriceData.High.Inbound.Local.Detail.AdvReceivingEndDate;
                
            String InShipTypeOptions = '<select id="inShipTypeSel" onchange="inShipTypeSelChanged(this);">';
            String InClassOfServiceOptions = '<select id="inClassOfServiceSel" onchange="inClassOfServiceSelChanged(this);">';
            String InInitialLowOption = '';
            
            if (complexPriceData.Low.Inbound.Air.AirNextDay.Detail.DisplayCode == null || complexPriceData.Low.Inbound.Air.AirNextDay.Detail.DisplayCode == '')
            {
                customInShipmentType.add('Air Transportation');
                getRatesWrp.inboundShipmentType = customInShipmentType;
                customInClassOfService.add('Next Day');
                getRatesWrp.inboundClassOfService = customInClassOfService;
                getRatesWrp.inLowHighAirNextDayRates = LiAirNextDayRates + '|' + HiAirNextDayRates;
                
                InShipTypeOptions += '<option>Air Transportation</option>';
                InClassOfServiceOptions += '<option value="' + LiAirNextDayRates + '|' + HiAirNextDayRates + '">Next Day</option>';
                InInitialLowOption = 'A1';
            }
            
            if (complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.DisplayCode == null || complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.DisplayCode == '')
            {
                if (InShipTypeOptions.indexOf('<option>Air Transportation</option>') < 0){
                    InShipTypeOptions += '<option>Air Transportation</option>';
                    customInShipmentType.add('Air Transportation');
                    getRatesWrp.inboundShipmentType = customInShipmentType;
                }
                
                customInClassOfService.add('2nd Day');
                getRatesWrp.inboundClassOfService = customInClassOfService;
                getRatesWrp.inLowHigh2ndDayRates = LiAir2ndDayRates + '|' + HiAir2ndDayRates;
                InClassOfServiceOptions += '<option value="' + LiAir2ndDayRates + '|' + HiAir2ndDayRates + '">2nd Day</option>';
                if (InInitialLowOption == '')
                    InInitialLowOption = 'A2';
            }   
            
            if (complexPriceData.Low.Inbound.Ground.Ltl.Detail.DisplayCode == null || complexPriceData.Low.Inbound.Ground.Ltl.Detail.DisplayCode == '')
            {
                customInShipmentType.add('Ground Transportation');
                getRatesWrp.inboundShipmentType = customInShipmentType;
                getRatesWrp.inLowHighGroundLtlRates = LiGroundLtlRates + '|' + HiGroundLtlRates;
                
                InShipTypeOptions += '<option value="' + LiGroundLtlRates + '|' + HiGroundLtlRates + '">Ground Transportation</option>';
                if (InInitialLowOption == '')
                    InInitialLowOption = 'G';               
            }   
            
            if (complexPriceData.Low.Inbound.Local.Detail.DisplayCode == null || complexPriceData.Low.Inbound.Local.Detail.DisplayCode == '')
            {
                customInShipmentType.add('Local');
                getRatesWrp.inboundShipmentType = customInShipmentType;
                getRatesWrp.inLowHighLiLocalRates = LiLocalRates + '|' + HiLocalRates;
                    
                InShipTypeOptions += '<option value="' + LiLocalRates + '|' + HiLocalRates + '">Local</option>';
                if (InInitialLowOption == '')
                    InInitialLowOption = 'L';                   
            }   
            
            InShipTypeOptions += '</select>';
            
            if (InInitialLowOption != 'A1' && InInitialLowOption != 'A2')
                InClassOfServiceOptions = '<select id="inClassOfServiceSel" onchange="inClassOfServiceSelChanged(this);" disabled="true">';
            
            InClassOfServiceOptions += '</select>';
            
            Double InInitialLowUnitPrice = 0;
            Double InInitialHighUnitPrice = 0;
            
            if (InInitialLowOption == 'A1')
            {
                InInitialLowUnitPrice= complexPriceData.Low.Inbound.Air.AirNextDay.Detail.UnitPrice;
                InInitialHighUnitPrice= complexPriceData.High.Inbound.Air.AirNextDay.Detail.UnitPrice;
            }
            else if (InInitialLowOption == 'A2')
            {
                InInitialLowUnitPrice = complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.UnitPrice;
                InInitialHighUnitPrice = complexPriceData.High.Inbound.Air.Air2ndDay.Detail.UnitPrice;
            }
            else if (InInitialLowOption == 'G')
            {
                InInitialLowUnitPrice = complexPriceData.Low.Inbound.Ground.Ltl.Detail.UnitPrice;
                InInitialHighUnitPrice = complexPriceData.High.Inbound.Ground.Ltl.Detail.UnitPrice;
            }
            else if (InInitialLowOption == 'L')
            {
                InInitialLowUnitPrice = complexPriceData.Low.Inbound.Local.Detail.UnitPrice;
                InInitialHighUnitPrice = complexPriceData.High.Inbound.Local.Detail.UnitPrice;
            }
            
            if(customInShipmentType != null && customInShipmentType.size() > 0)
                getRatesWrp.inboundSelectedShipType = customInShipmentType.get(0);
            else
                getRatesWrp.inboundSelectedShipType = '';
            
            if(customInClassOfService != null && customInClassOfService.size() > 0)
                getRatesWrp.inboundSelectedClassSvc = customInClassOfService.get(0);
            else
                getRatesWrp.inboundSelectedClassSvc = '';

            getRatesWrp.inboundLowPrice = InInitialLowUnitPrice;
            getRatesWrp.inboundHighPrice = InInitialHighUnitPrice;
            getRatesWrp.inboundPrice = 0;
            getRatesWrp.inboundServiceType = 'LTL';
            
            
            Html += '<fieldset>';
            Html += '<legend>Inbound</legend>';
            Html += '<table style="border:none">';
            Html += '<tr>';
            Html += '<td style="width:150px;text-align:right;font-weight:bold;">Shipment Type:</td>';
            Html += '<td style="width:200px;text-align:left">' + InShipTypeOptions + '</td>';
            Html += '<td style="text-align:right;font-weight:bold;">High:</td>';
            Html += '<td align="left"><input id="inHighValue" readonly="readonly" type="text" value="' + InInitialHighUnitPrice + '"></input></td>';
            Html += '</tr>';
            Html += '<tr>';
            Html += '<td style="width:150px;text-align:right;font-weight:bold;">Class of Service:</td>';
            Html += '<td style="width:200px;text-align:left">' + InClassOfServiceOptions + '</td>';
            Html += '<td style="text-align:right;font-weight:bold;">Low:</td>';
            Html += '<td align="left"><input id="inLowValue" readonly="readonly" type="text" value="' + InInitialLowUnitPrice + '"></input></td>';
            Html += '</tr>';
            Html += '<tr>';
            Html += '<td style="width:150px;text-align:right;font-weight:bold;">Service Type:</td>';
            Html += '<td style="width:200px;text-align:left">LTL</td>';
            Html += '<td style="text-align:right;font-weight:bold;">Price:</td>';
            Html += '<td align="left"><input id="inUnitPrice" type="text" onchange="inUnitPriceChanged(this);"/></td>';
            Html += '</tr>';
            Html += '</table>';
            Html += '</fieldset>';
        }
        
        if (direction == 'ROUNDTRIP' || direction == 'OUTBOUND')
        {
            string LoAir2ndDayRates = complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.UnitPrice + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.FuelSurcharge + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.LiftGateFee + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.InsideFee + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.ResidentialFee + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.WeekendFee + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.WaitTimeFee + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.PalletizationFee + ','  + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.AttemptFee + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.SubTotal + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.Total + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.RoundTripDiscountPercent + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.AdvReceivingEndDate; 
            string LoAirNextDayRates = complexPriceData.Low.Outbound.Air.AirNextDay.Detail.UnitPrice + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.FuelSurcharge + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.LiftGateFee + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.InsideFee + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.ResidentialFee + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.WeekendFee + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.WaitTimeFee + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.PalletizationFee + ','  + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.AttemptFee + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.SubTotal + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.Total + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.RoundtripDiscountPercent + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.AdvReceivingEndDate;
            string LoGroundLTLRates = complexPriceData.Low.Outbound.Ground.Ltl.Detail.UnitPrice + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.FuelSurcharge + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.LiftGateFee + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.InsideFee + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.ResidentialFee + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.WeekendFee + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.WaitTimeFee + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.PalletizationFee + ','  + complexPriceData.Low.Outbound.Ground.Ltl.Detail.AttemptFee + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.SubTotal + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.Total + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.RoundtripDiscountPercent + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.AdvReceivingEndDate;
            string LoGroundFTLRates = complexPriceData.Low.Outbound.Ground.Ftl.Detail.UnitPrice + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.FuelSurcharge + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.LiftGateFee + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.InsideFee + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.ResidentialFee + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.WeekendFee + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.WaitTimeFee + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.PalletizationFee + ','  + complexPriceData.Low.Outbound.Ground.Ftl.Detail.AttemptFee + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.SubTotal + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.Total + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.RoundtripDiscountPercent + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.AdvReceivingEndDate;         
            string LoLocalRates = complexPriceData.Low.Outbound.Local.Detail.UnitPrice + ',' + complexPriceData.Low.Outbound.Local.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Outbound.Local.Detail.FuelSurcharge + ',' + complexPriceData.Low.Outbound.Local.Detail.LiftGateFee + ',' + complexPriceData.Low.Outbound.Local.Detail.InsideFee + ',' + complexPriceData.Low.Outbound.Local.Detail.ResidentialFee + ',' + complexPriceData.Low.Outbound.Local.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Outbound.Local.Detail.WeekendFee + ',' + complexPriceData.Low.Outbound.Local.Detail.WaitTimeFee + ',' + complexPriceData.Low.Outbound.Local.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Outbound.Local.Detail.PalletizationFee + ','  + complexPriceData.Low.Outbound.Local.Detail.AttemptFee + ',' + complexPriceData.Low.Outbound.Local.Detail.SubTotal + ',' + complexPriceData.Low.Outbound.Local.Detail.Total + ',' + complexPriceData.Low.Outbound.Local.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.Low.Outbound.Local.Detail.RoundTripDiscountPercent + ',' + complexPriceData.Low.Outbound.Local.Detail.AdvReceivingEndDate;
            
            string HoAir2ndDayRates = complexPriceData.High.Outbound.Air.Air2ndDay.Detail.UnitPrice + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.FuelUnitSurcharge + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.FuelSurcharge + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.LiftGateFee + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.InsideFee + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.ResidentialFee + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.AMSpecifiedFee + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.WeekendFee + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.WaitTimeFee + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.AdditionalLaborFee + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.PalletizationFee + ','  + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.AttemptFee + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.SubTotal + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.Total + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.RoundTripDiscountPercent + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.AdvReceivingEndDate; 
            string HoAirNextDayRates = complexPriceData.High.Outbound.Air.AirNextDay.Detail.UnitPrice + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.FuelUnitSurcharge + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.FuelSurcharge + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.LiftGateFee + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.InsideFee + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.ResidentialFee + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.AMSpecifiedFee + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.WeekendFee + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.WaitTimeFee + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.AdditionalLaborFee + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.PalletizationFee + ','  + complexPriceData.High.Outbound.Air.AirNextDay.Detail.AttemptFee + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.SubTotal + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.Total + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.RoundtripDiscountPercent + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.AdvReceivingEndDate;
            string HoGroundLTLRates = complexPriceData.High.Outbound.Ground.Ltl.Detail.UnitPrice + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.FuelUnitSurcharge + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.FuelSurcharge + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.LiftGateFee + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.InsideFee + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.ResidentialFee + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.AMSpecifiedFee + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.WeekendFee + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.WaitTimeFee + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.AdditionalLaborFee + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.PalletizationFee + ','  + complexPriceData.High.Outbound.Ground.Ltl.Detail.AttemptFee + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.SubTotal + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.Total + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.RoundtripDiscountPercent + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.AdvReceivingEndDate;
            string HoGroundFTLRates = complexPriceData.High.Outbound.Ground.Ftl.Detail.UnitPrice + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.FuelUnitSurcharge + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.FuelSurcharge + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.LiftGateFee + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.InsideFee + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.ResidentialFee + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.AMSpecifiedFee + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.WeekendFee + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.WaitTimeFee + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.AdditionalLaborFee + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.PalletizationFee + ','  + complexPriceData.High.Outbound.Ground.Ftl.Detail.AttemptFee + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.SubTotal + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.Total + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.RoundtripDiscountPercent + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.AdvReceivingEndDate;            
            string HoLocalRates = complexPriceData.High.Outbound.Local.Detail.UnitPrice + ',' + complexPriceData.High.Outbound.Local.Detail.FuelUnitSurcharge + ',' + complexPriceData.High.Outbound.Local.Detail.FuelSurcharge + ',' + complexPriceData.High.Outbound.Local.Detail.LiftGateFee + ',' + complexPriceData.High.Outbound.Local.Detail.InsideFee + ',' + complexPriceData.High.Outbound.Local.Detail.ResidentialFee + ',' + complexPriceData.High.Outbound.Local.Detail.AMSpecifiedFee + ',' + complexPriceData.High.Outbound.Local.Detail.WeekendFee + ',' + complexPriceData.High.Outbound.Local.Detail.WaitTimeFee + ',' + complexPriceData.High.Outbound.Local.Detail.AdditionalLaborFee + ',' + complexPriceData.High.Outbound.Local.Detail.PalletizationFee + ','  + complexPriceData.High.Outbound.Local.Detail.AttemptFee + ',' + complexPriceData.High.Outbound.Local.Detail.SubTotal + ',' + complexPriceData.High.Outbound.Local.Detail.Total + ',' + complexPriceData.High.Outbound.Local.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.High.Outbound.Local.Detail.RoundTripDiscountPercent + ',' + complexPriceData.High.Outbound.Local.Detail.AdvReceivingEndDate;
            
            String OutShipTypeOptions = '<select id="outShipTypeSel" onchange="outShipTypeSelChanged(this);">';
            String OutClassOfServiceOptions = '<select id="outClassOfServiceSel" onchange="outClassOfServiceSelChanged(this);">';
            String OutInitialLowOption = '';
            
            if (complexPriceData.Low.Outbound.Air.AirNextDay.Detail.DisplayCode == null || complexPriceData.Low.Outbound.Air.AirNextDay.Detail.DisplayCode == '')
            {
                customOutShipmentType.add('Air Transportation');
                getRatesWrp.outboundShipmentType = customOutShipmentType;
                customOutClassOfService.add('Next Day');
                getRatesWrp.outboundClassOfService = customOutClassOfService;
                getRatesWrp.outLowHighAirNextDayRates = LoAirNextDayRates + '|' + HoAirNextDayRates;
                    
                OutShipTypeOptions += '<option>Air Transportation</option>';
                OutClassOfServiceOptions += '<option value="' + LoAirNextDayRates + '|' + HoAirNextDayRates + '">Next Day</option>';
                OutInitialLowOption = 'A1';
            }
            
            if (complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.DisplayCode == null || complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.DisplayCode == '')
            {
                if (OutShipTypeOptions.indexOf('<option>Air Transportation</option>') < 0){
                    OutShipTypeOptions += '<option>Air Transportation</option>';
                    
                    customOutShipmentType.add('Air Transportation');
                    getRatesWrp.outboundShipmentType = customOutShipmentType;
                }   
                customOutClassOfService.add('2nd Day');
                getRatesWrp.outboundClassOfService = customOutClassOfService;
                getRatesWrp.outLowHigh2ndDayRates = LoAir2ndDayRates + '|' + HoAir2ndDayRates;
                
                OutClassOfServiceOptions += '<option value="' + LoAir2ndDayRates + '|' + HoAir2ndDayRates + '">2nd Day</option>';
                if (OutInitialLowOption == '')
                    OutInitialLowOption = 'A2';         
            }   
            
            if (complexPriceData.Low.Outbound.Ground.Ltl.Detail.DisplayCode == null || complexPriceData.Low.Outbound.Ground.Ltl.Detail.DisplayCode == '')
            {
                customOutShipmentType.add('Ground Transportation');
                getRatesWrp.outboundShipmentType = customOutShipmentType;
                getRatesWrp.outLowHighGroundLtlRates = LoGroundLtlRates + '|' + HoGroundLtlRates;
                
                OutShipTypeOptions += '<option value="' + LoGroundLtlRates + '|' + HoGroundLtlRates + '">Ground Transportation</option>';
                if (OutInitialLowOption == '')
                    OutInitialLowOption = 'G';                  
            }   
            
            if (complexPriceData.Low.Outbound.Local.Detail.DisplayCode == null || complexPriceData.Low.Outbound.Local.Detail.DisplayCode == '')
            {
                customOutShipmentType.add('Local');
                getRatesWrp.outboundShipmentType = customOutShipmentType;
                getRatesWrp.outLowHighLiLocalRates = LoLocalRates + '|' + HoLocalRates;
                
                OutShipTypeOptions += '<option value="' + LoLocalRates + '|' + HoLocalRates + '">Local</option>';
                if (OutInitialLowOption == '')
                    OutInitialLowOption = 'L';                  
            }   
            
            OutShipTypeOptions += '</select>';
            
            if (OutInitialLowOption != 'A1' && OutInitialLowOption != 'A2')
                OutClassOfServiceOptions = '<select id="outClassOfServiceSel" onchange="outClassOfServiceSelChanged(this);" disabled="true">';
            
            OutClassOfServiceOptions += '</select>';
            
            Double OutInitialLowUnitPrice = 0;
            Double OutInitialHighUnitPrice = 0;
            
            if (OutInitialLowOption == 'A1')
            {
                OutInitialLowUnitPrice= complexPriceData.Low.Outbound.Air.AirNextDay.Detail.UnitPrice;
                OutInitialHighUnitPrice= complexPriceData.High.Outbound.Air.AirNextDay.Detail.UnitPrice;
            }
            else if (OutInitialLowOption == 'A2')
            {
                OutInitialLowUnitPrice = complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.UnitPrice;
                OutInitialHighUnitPrice = complexPriceData.High.Outbound.Air.Air2ndDay.Detail.UnitPrice;
            }
            else if (OutInitialLowOption == 'G')
            {
                OutInitialLowUnitPrice = complexPriceData.Low.Outbound.Ground.Ltl.Detail.UnitPrice;
                OutInitialHighUnitPrice = complexPriceData.High.Outbound.Ground.Ltl.Detail.UnitPrice;
            }
            else if (OutInitialLowOption == 'L')
            {
                OutInitialLowUnitPrice = complexPriceData.Low.Outbound.Local.Detail.UnitPrice;
                OutInitialHighUnitPrice = complexPriceData.High.Outbound.Local.Detail.UnitPrice;
            }
            
            if(customOutShipmentType != null && customOutShipmentType.size() > 0)
                getRatesWrp.outboundSelectedShipType = customOutShipmentType.get(0);
            else
                getRatesWrp.outboundSelectedShipType = '';
            
            if(customOutClassOfService != null && customOutClassOfService.size() > 0)
                getRatesWrp.outboundSelectedClassSvc = customOutClassOfService.get(0);
            else
                getRatesWrp.outboundSelectedClassSvc = '';
            
            getRatesWrp.outboundLowPrice = OutInitialLowUnitPrice;
            getRatesWrp.outboundHighPrice = OutInitialHighUnitPrice;
            getRatesWrp.outboundPrice = 0;
            getRatesWrp.outboundServiceType = 'LTL';
            
            Html += '<fieldset>';
            Html += '<legend>Outbound</legend>';
            Html += '<table style="border:none">';
            Html += '<tr>';
            Html += '<td style="width:150px;text-align:right;font-weight:bold;">Shipment Type:</td>';
            Html += '<td style="width:200px;text-align:left">' + OutShipTypeOptions + '</td>';
            Html += '<td style="text-align:right;font-weight:bold;">High:</td>';
            Html += '<td align="left"><input id="outHighValue" readonly="readonly" type="text" value="' + OutInitialHighUnitPrice + '"></input></td>';
            Html += '</tr>';
            Html += '<tr>';
            Html += '<td style="width:150px;text-align:right;font-weight:bold;">Class of Service:</td>';
            Html += '<td style="width:200px;text-align:left">' + OutClassOfServiceOptions + '</td>';
            Html += '<td style="text-align:right;font-weight:bold;">Low:</td>';
            Html += '<td align="left"><input id="outLowValue" readonly="readonly" type="text" value="' + OutInitialLowUnitPrice + '"></input></td>';
            Html += '</tr>';
            Html += '<tr>';
            Html += '<td style="width:150px;text-align:right;font-weight:bold;">Service Type:</td>';
            Html += '<td style="width:200px;text-align:left">LTL</td>';
            Html += '<td style="text-align:right;font-weight:bold;">Price:</td>';
            Html += '<td align="left"><input id="outUnitPrice" type="text" onchange="outUnitPriceChanged(this);"/></td>';
            Html += '</tr>';
            Html += '</table>';
            Html += '</fieldset>';
        }
            
        Html += '</div>';

        Html += '</div>';
        Html += '</div>';
        getRatesWrp.html = Html;
        return getRatesWrp;
    }

    
    
    public static string GetHtml(string direction, LogisticsQuoteComplexPriceData complexPriceData, Quote__c q)
    {
        map<string, string> HiMoMessages = new map<string, string>{};
        map<string, string> HoMoMessages = new map<string, string>{};
        map<string, string> LiMoMessages = new map<string, string>{};
        map<string, string> LoMoMessages = new map<string, string>{};
        
        string Html = '';
        string HiInboundHtmlNoRatesMessage = '';
        string LiInboundHtmlNoRatesMessage = '';
        string HoInboundHtmlNoRatesMessage = '';
        string LoInboundHtmlNoRatesMessage = '';        
        
        direction = direction.toUpperCase();
        
        Html = '<div id=\'priceMatrixDialog\' class=\'container\'>';
        Html += '<div id=\'tabContainer\' class=\'tab_container\'>';        
        Html += '<ul class=\'tabs\'><li class=\'tabLink\'><a href=\'#high\'>High</a></li><li class=\'tabLink\'><a href=\'#low\'>Low</a></li><li class=\'tabLink\'><a href=\'#custom\'>Name Your Price</a></li></ul>';
        Html += '<div id=\'high\'>';
        
        if (direction == 'ROUNDTRIP' || direction == 'INBOUND')
        {
            string HiAir2ndDayRates = complexPriceData.High.Inbound.Air.Air2ndDay.Detail.UnitPrice + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.FuelUnitSurcharge + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.FuelSurcharge + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.LiftGateFee + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.InsideFee + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.ResidentialFee + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.AMSpecifiedFee + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.WeekendFee + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.WaitTimeFee + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.AdditionalLaborFee + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.PalletizationFee + ','  + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.AttemptFee + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.SubTotal + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.Total + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.RoundTripDiscountPercent + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.AdvReceivingEndDate; 
            string HiAirNextDayRates = complexPriceData.High.Inbound.Air.AirNextDay.Detail.UnitPrice + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.FuelUnitSurcharge + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.FuelSurcharge + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.LiftGateFee + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.InsideFee + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.ResidentialFee + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.AMSpecifiedFee + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.WeekendFee + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.WaitTimeFee + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.AdditionalLaborFee + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.PalletizationFee + ','  + complexPriceData.High.Inbound.Air.AirNextDay.Detail.AttemptFee + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.SubTotal + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.Total + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.RoundtripDiscountPercent + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.AdvReceivingEndDate;
            string HiGroundLTLRates = complexPriceData.High.Inbound.Ground.Ltl.Detail.UnitPrice + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.FuelUnitSurcharge + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.FuelSurcharge + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.LiftGateFee + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.InsideFee + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.ResidentialFee + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.AMSpecifiedFee + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.WeekendFee + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.WaitTimeFee + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.AdditionalLaborFee + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.PalletizationFee + ','  + complexPriceData.High.Inbound.Ground.Ltl.Detail.AttemptFee + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.SubTotal + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.Total + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.RoundtripDiscountPercent + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.AdvReceivingEndDate;
            string HiGroundFTLRates = complexPriceData.High.Inbound.Ground.Ftl.Detail.UnitPrice + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.FuelUnitSurcharge + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.FuelSurcharge + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.LiftGateFee + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.InsideFee + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.ResidentialFee + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.AMSpecifiedFee + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.WeekendFee + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.WaitTimeFee + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.AdditionalLaborFee + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.PalletizationFee + ','  + complexPriceData.High.Inbound.Ground.Ftl.Detail.AttemptFee + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.SubTotal + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.Total + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.RoundtripDiscountPercent + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.AdvReceivingEndDate;         
            string HiLocalRates = complexPriceData.High.Inbound.Local.Detail.UnitPrice + ',' + complexPriceData.High.Inbound.Local.Detail.FuelUnitSurcharge + ',' + complexPriceData.High.Inbound.Local.Detail.FuelSurcharge + ',' + complexPriceData.High.Inbound.Local.Detail.LiftGateFee + ',' + complexPriceData.High.Inbound.Local.Detail.InsideFee + ',' + complexPriceData.High.Inbound.Local.Detail.ResidentialFee + ',' + complexPriceData.High.Inbound.Local.Detail.AMSpecifiedFee + ',' + complexPriceData.High.Inbound.Local.Detail.WeekendFee + ',' + complexPriceData.High.Inbound.Local.Detail.WaitTimeFee + ',' + complexPriceData.High.Inbound.Local.Detail.AdditionalLaborFee + ',' + complexPriceData.High.Inbound.Local.Detail.PalletizationFee + ','  + complexPriceData.High.Inbound.Local.Detail.AttemptFee + ',' + complexPriceData.High.Inbound.Local.Detail.SubTotal + ',' + complexPriceData.High.Inbound.Local.Detail.Total + ',' + complexPriceData.High.Inbound.Local.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.High.Inbound.Local.Detail.RoundTripDiscountPercent + ',' + complexPriceData.High.Inbound.Local.Detail.AdvReceivingEndDate;
            
            Html += '<table class=\'priceMatrixTable\'>';
            Html += '<tr class=\'priceMatrixTableHeader\'>';
            Html += '<th class=\'priceMatrixTableHeaderTypeColumn\'>' + 'Inbound' + '</th>';
            Html += '<th class=\'priceMatrixTableHeader\'>' + 'LTL' + '</th>';
            //Html += '<th class=\'priceMatrixTableHeader\'>' + 'FTL' + '</th>';
            Html += '<th class=\'priceMatrixTableHeader\'>' + '2nd Day' + '</th>';
            Html += '<th class=\'priceMatrixTableHeader\'>' + 'Next Day' + '</th>';
            Html += '<th class=\'priceMatrixTableHeader\'>' + 'Other' + '</th>';        
            Html += '</tr>';
            Html += '<tr>';
            Html += '<td class=\'priceMatrixTypeColumn\'>' + 'Air' + '</td>';
            Html += '<td colspan=1 class=\'priceMatrixValueNA\'>' + '' + '</td>';
            
            if (complexPriceData.High.Inbound.Air.Air2ndDay.Detail.DisplayCode == null || complexPriceData.High.Inbound.Air.Air2ndDay.Detail.DisplayCode == '')
            {
                String HIAir2ndDayAdvDiscount = (complexPriceData.High.Inbound.Air.Air2ndDay.Detail.AdvOrderDiscountPercent > 0 ? 'Advance Order Discount: ' + string.valueOf(complexPriceData.High.Inbound.Air.Air2ndDay.Detail.AdvOrderDiscountPercent) + '%': '');
                String HIAir2ndDayRTDiscount = (complexPriceData.High.Inbound.Air.Air2ndDay.Detail.RoundTripDiscountPercent > 0 ? 'Roundtrip Discount: ' + string.valueOf(complexPriceData.High.Inbound.Air.Air2ndDay.Detail.RoundTripDiscountPercent) + '%' : '');
                String HIAir2ndDayDiscount = HIAir2ndDayAdvDiscount + (HIAir2ndDayAdvDiscount != '' ? '\n' : '') + HIAir2ndDayRTDiscount;
                
                String HIAir2ndDayClass = 'priceMatrixValue';
                
                if (q.Shipment_Type__c != null && q.Class_of_Service__c != null && q.Selection__c != null)
                {
                    if (q.Shipment_Type__c.toUpperCase() == 'AIR TRANSPORTATION' && q.Class_of_Service__c.toUpperCase() == '2ND DAY' && q.Selection__c.toUpperCase() == 'HIGH' && (q.Message__c == null || q.Message__c == ''))
                        HIAir2ndDayClass = 'priceMatrixValuePriorSelection';
                }
                
                Html += '<td id=\'HiAir2ndDay\' class=\'' + HIAir2ndDayClass + '\' onClick=\'changeInboundCellColor(this,"HiAir2ndDay","' + HiAir2ndDayRates +'"); return false;\' title=\'' + HIAir2ndDayDiscount + '\'>' + string.valueOf(complexPriceData.High.Inbound.Air.Air2ndDay.Detail.UnitPrice) + (complexPriceData.High.Inbound.Air.Air2ndDay.Detail.TotalDiscountPercent > 0 ? ' (-' + string.valueOf(complexPriceData.High.Inbound.Air.Air2ndDay.Detail.TotalDiscountPercent) + '%)' : '') + '</td>';
            }
            else {
                
                if (complexPriceData.High.Inbound.Air.Air2ndDay.Detail.DisplayCode != null && complexPriceData.High.Inbound.Air.Air2ndDay.Detail.Comments != null)                      
                    HiMoMessages.put(complexPriceData.High.Inbound.Air.Air2ndDay.Detail.DisplayCode, complexPriceData.High.Inbound.Air.Air2ndDay.Detail.Comments);
                
                if (complexPriceData.High.Inbound.Air.Air2ndDay.Detail.DisplayCode == 'X')
                    Html += '<td id=\'HiAir2ndDay\' class=\'priceMatrixValueInvalidEntry\'>' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.DisplayCode + '</td>';
                else
                    Html += '<td id=\'HiAir2ndDay\' class=\'priceMatrixValueSpecial\'>' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.DisplayCode + '</td>';
            }
                    
            if (complexPriceData.High.Inbound.Air.AirNextDay.Detail.DisplayCode == null || complexPriceData.High.Inbound.Air.AirNextDay.Detail.DisplayCode == '')
            {
                String HIAirNextDayAdvDiscount = (complexPriceData.High.Inbound.Air.AirNextDay.Detail.AdvOrderDiscountPercent > 0 ? 'Advance Order Discount: ' + string.valueOf(complexPriceData.High.Inbound.Air.AirNextDay.Detail.AdvOrderDiscountPercent) + '%': '');
                String HIAirNextDayRTDiscount = (complexPriceData.High.Inbound.Air.AirNextDay.Detail.RoundTripDiscountPercent > 0 ? 'Roundtrip Discount: ' + string.valueOf(complexPriceData.High.Inbound.Air.AirNextDay.Detail.RoundTripDiscountPercent) + '%' : '');
                String HIAirNextDayDiscount = HIAirNextDayAdvDiscount + (HIAirNextDayAdvDiscount != '' ? '\n' : '') + HIAirNextDayRTDiscount;
                
                String HIAirNextDayClass = 'priceMatrixValue';
                
                if (q.Shipment_Type__c != null && q.Class_of_Service__c != null && q.Selection__c != null && (q.Message__c == null || q.Message__c == ''))
                {               
                    if (q.Shipment_Type__c.toUpperCase() == 'AIR TRANSPORTATION' && q.Class_of_Service__c.toUpperCase() == 'NEXT DAY' && q.Selection__c.toUpperCase() == 'HIGH')
                        HIAirNextDayClass = 'priceMatrixValuePriorSelection';   
                }
                                    
                Html += '<td id=\'HiAirNextDay\' class=\'' + HIAirNextDayClass + '\' onClick=\'changeInboundCellColor(this,"HiAirNextDay", "' + HiAirNextDayRates + '"); return false;\' title=\'' + HIAirNextDayDiscount + '\'>' + string.valueOf(complexPriceData.High.Inbound.Air.AirNextDay.Detail.UnitPrice) + (complexPriceData.High.Inbound.Air.AirNextDay.Detail.TotalDiscountPercent > 0 ? ' (-' + string.valueOf(complexPriceData.High.Inbound.Air.AirNextDay.Detail.TotalDiscountPercent) + '%)' : '') + '</td>';
            }
            else {
                
                if (complexPriceData.High.Inbound.Air.AirNextDay.Detail.DisplayCode != null && complexPriceData.High.Inbound.Air.AirNextDay.Detail.Comments != null)                        
                    HiMoMessages.put(complexPriceData.High.Inbound.Air.AirNextDay.Detail.DisplayCode, complexPriceData.High.Inbound.Air.AirNextDay.Detail.Comments);
                
                if (complexPriceData.High.Inbound.Air.AirNextDay.Detail.DisplayCode == 'X')
                    Html += '<td id=\'HiAirNextDay\' class=\'priceMatrixValueInvalidEntry\'>' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.DisplayCode + '</td>';
                else
                    Html += '<td id=\'HiAirNextDay\' class=\'priceMatrixValueSpecial\'>' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.DisplayCode + '</td>';
            }
                    
            Html += '<td class=\'priceMatrixValueNA\'>' + '' + '</td>';
            Html += '</tr>';
            Html += '<tr>'; 
            Html += '<td class=\'priceMatrixTypeColumn\'>' + 'Ground' + '</td>';
            
            if (complexPriceData.High.Inbound.Ground.Ltl.Detail.DisplayCode == null || complexPriceData.High.Inbound.Ground.Ltl.Detail.DisplayCode == '')
            {
                String HIGroundLtlAdvDiscount = (complexPriceData.High.Inbound.Ground.Ltl.Detail.AdvOrderDiscountPercent > 0 ? 'Advance Order Discount: ' + string.valueOf(complexPriceData.High.Inbound.Ground.Ltl.Detail.AdvOrderDiscountPercent) + '%': '');
                String HIGroundLtlRTDiscount = (complexPriceData.High.Inbound.Ground.Ltl.Detail.RoundTripDiscountPercent > 0 ? 'Roundtrip Discount: ' + string.valueOf(complexPriceData.High.Inbound.Ground.Ltl.Detail.RoundTripDiscountPercent) + '%' : '');
                String HIGroundLtlDiscount = HIGroundLtlAdvDiscount + (HIGroundLtlAdvDiscount != '' ? '\n' : '') + HIGroundLtlRTDiscount;
                
                String HIGroundLtlClass = 'priceMatrixValue';
                
                if (q.Shipment_Type__c != null && q.Service_Type__c != null && q.Selection__c != null && (q.Message__c == null || q.Message__c == ''))
                {               
                    if (q.Shipment_Type__c.toUpperCase() == 'GROUND TRANSPORTATION' && q.Service_Type__c.toUpperCase() == 'LTL' && q.Selection__c.toUpperCase() == 'HIGH')
                        HIGroundLtlClass = 'priceMatrixValuePriorSelection';    
                }
                    
                Html += '<td id=\'HiGroundLTL\' class=\'' + HIGroundLtlClass + '\' onClick=\'changeInboundCellColor(this,"HiGroundLTL", "' + HiGroundLTLRates + '"); return false;\' title=\'' + HIGroundLtlDiscount + '\'>' + string.valueOf(complexPriceData.High.Inbound.Ground.Ltl.Detail.UnitPrice) + (complexPriceData.High.Inbound.Ground.Ltl.Detail.TotalDiscountPercent > 0 ? ' (-' + string.valueOf(complexPriceData.High.Inbound.Ground.Ltl.Detail.TotalDiscountPercent) + '%)' : '') + '</td>';
            }
            else {
                
                if (complexPriceData.High.Inbound.Ground.Ltl.Detail.DisplayCode != null && complexPriceData.High.Inbound.Ground.Ltl.Detail.Comments != null)                        
                    HiMoMessages.put(complexPriceData.High.Inbound.Ground.Ltl.Detail.DisplayCode, complexPriceData.High.Inbound.Ground.Ltl.Detail.Comments);
                
                if (complexPriceData.High.Inbound.Ground.Ltl.Detail.DisplayCode == 'X')
                    Html += '<td id=\'HiGroundLTL\' class=\'priceMatrixValueInvalidEntry\'>' + complexPriceData.High.Inbound.Ground.Ltl.Detail.DisplayCode + '</td>';
                else
                    Html += '<td id=\'HiGroundLTL\' class=\'priceMatrixValueSpecial\'>' + complexPriceData.High.Inbound.Ground.Ltl.Detail.DisplayCode + '</td>';
            }
            
            Html += '<td colspan=3 class=\'priceMatrixValueNA\'>' + '</td>';
            Html += '</tr>';
            Html += '<tr>'; 
            Html += '<td class=\'priceMatrixTypeColumn\'>' + 'Local' + '</td>';
            //Html += '<td colspan=4 class=\'priceMatrixValueNA\'>' + '' + '</td>';
            Html += '<td colspan=3 class=\'priceMatrixValueNA\'>' + '' + '</td>';
                    
            if (complexPriceData.High.Inbound.Local.Detail.DisplayCode == null || complexPriceData.High.Inbound.Local.Detail.DisplayCode == '')
            {
                String HILocalClass = 'priceMatrixValue';
                
                if (q.Shipment_Type__c != null && q.Selection__c != null && (q.Message__c == null || q.Message__c == ''))
                {               
                    if (q.Shipment_Type__c.toUpperCase() == 'LOCAL SHIPMENTS' && q.Selection__c.toUpperCase() == 'HIGH')
                        HILocalClass = 'priceMatrixValuePriorSelection';    
                }
                
                Html += '<td id=\'HiLocal\' class=\'' + HILocalClass + '\' onClick=\'changeInboundCellColor(this,"HiLocal", "' + HiLocalRates + '"); return false;\'>' + string.valueOf(complexPriceData.High.Inbound.Local.Detail.UnitPrice) + '</td>';
            }
            else
            {
                if (complexPriceData.High.Inbound.Local.Detail.DisplayCode != null && complexPriceData.High.Inbound.Local.Detail.Comments != null)
                    HiMoMessages.put(complexPriceData.High.Inbound.Local.Detail.DisplayCode, complexPriceData.High.Inbound.Local.Detail.Comments);
                        
                if (complexPriceData.High.Inbound.Local.Detail.DisplayCode == 'X')
                    Html += '<td id=\'HiLocal\' class=\'priceMatrixValueInvalidEntry\'>' + complexPriceData.High.Inbound.Local.Detail.DisplayCode + '</td>';
                else
                    Html += '<td id=\'HiLocal\' class=\'priceMatrixValueSpecial\'>' + complexPriceData.High.Inbound.Local.Detail.DisplayCode + '</td>';                     
            }
                    
            Html += '</tr>';
            Html += '</table>';
        }
        else
        {
            /*
                In a custom quote, the Quote_Subject__c field could be different from the direction argument passed
                to the GetRates method. In this case though, even if the quote subject is "ROUNDTRIP", the direction
                value could be Outbound, because Custom Quote flag is checked on the Inbound. In such a case, display
                this message.               
            */
            
            if (q.Quote_Subject__c.toUpperCase() != Direction && q.Custom_Quote__c)
                HiInboundHtmlNoRatesMessage = '<table style=\'border:none\'><tr><td style=\'padding-top: 20px; color: red\'>Inbound shipment is custom quote.</td></tr></table>';
            /*
                This else portion below is not required. When Quote_Subject__c is Outbound, the code will always
                execute this parent else portion and result in message display, which is not required since the 
                quote is Outbound.NOTE: In normal quote (i.e. not custom quote), the direction argument is always 
                the same as the Quote_Subject__c field.
            */ 
            //else
            //HiInboundHtmlNoRatesMessage = '<table style=\'border:none\'><tr><td style=\'padding-top: 20px;\'>To view rates for Inbound shipment, required field values must be provided.</td></tr></table>';
        }
        
        if (direction == 'ROUNDTRIP' || direction == 'OUTBOUND')
        {
            string HoAir2ndDayRates = complexPriceData.High.Outbound.Air.Air2ndDay.Detail.UnitPrice + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.FuelUnitSurcharge + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.FuelSurcharge + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.LiftGateFee + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.InsideFee + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.ResidentialFee + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.AMSpecifiedFee + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.WeekendFee + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.WaitTimeFee + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.AdditionalLaborFee + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.PalletizationFee + ','  + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.AttemptFee + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.SubTotal + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.Total + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.RoundTripDiscountPercent + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.AdvReceivingEndDate; 
            string HoAirNextDayRates = complexPriceData.High.Outbound.Air.AirNextDay.Detail.UnitPrice + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.FuelUnitSurcharge + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.FuelSurcharge + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.LiftGateFee + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.InsideFee + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.ResidentialFee + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.AMSpecifiedFee + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.WeekendFee + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.WaitTimeFee + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.AdditionalLaborFee + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.PalletizationFee + ','  + complexPriceData.High.Outbound.Air.AirNextDay.Detail.AttemptFee + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.SubTotal + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.Total + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.RoundtripDiscountPercent + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.AdvReceivingEndDate;
            string HoGroundLTLRates = complexPriceData.High.Outbound.Ground.Ltl.Detail.UnitPrice + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.FuelUnitSurcharge + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.FuelSurcharge + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.LiftGateFee + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.InsideFee + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.ResidentialFee + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.AMSpecifiedFee + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.WeekendFee + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.WaitTimeFee + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.AdditionalLaborFee + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.PalletizationFee + ','  + complexPriceData.High.Outbound.Ground.Ltl.Detail.AttemptFee + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.SubTotal + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.Total + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.RoundtripDiscountPercent + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.AdvReceivingEndDate;
            string HoGroundFTLRates = complexPriceData.High.Outbound.Ground.Ftl.Detail.UnitPrice + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.FuelUnitSurcharge + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.FuelSurcharge + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.LiftGateFee + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.InsideFee + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.ResidentialFee + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.AMSpecifiedFee + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.WeekendFee + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.WaitTimeFee + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.AdditionalLaborFee + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.PalletizationFee + ','  + complexPriceData.High.Outbound.Ground.Ftl.Detail.AttemptFee + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.SubTotal + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.Total + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.RoundtripDiscountPercent + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.AdvReceivingEndDate;            
            string HoLocalRates = complexPriceData.High.Outbound.Local.Detail.UnitPrice + ',' + complexPriceData.High.Outbound.Local.Detail.FuelUnitSurcharge + ',' + complexPriceData.High.Outbound.Local.Detail.FuelSurcharge + ',' + complexPriceData.High.Outbound.Local.Detail.LiftGateFee + ',' + complexPriceData.High.Outbound.Local.Detail.InsideFee + ',' + complexPriceData.High.Outbound.Local.Detail.ResidentialFee + ',' + complexPriceData.High.Outbound.Local.Detail.AMSpecifiedFee + ',' + complexPriceData.High.Outbound.Local.Detail.WeekendFee + ',' + complexPriceData.High.Outbound.Local.Detail.WaitTimeFee + ',' + complexPriceData.High.Outbound.Local.Detail.AdditionalLaborFee + ',' + complexPriceData.High.Outbound.Local.Detail.PalletizationFee + ','  + complexPriceData.High.Outbound.Local.Detail.AttemptFee + ',' + complexPriceData.High.Outbound.Local.Detail.SubTotal + ',' + complexPriceData.High.Outbound.Local.Detail.Total + ',' + complexPriceData.High.Outbound.Local.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.High.Outbound.Local.Detail.RoundTripDiscountPercent + ',' + complexPriceData.High.Outbound.Local.Detail.AdvReceivingEndDate;
            
            Html += '<table class=\'priceMatrixTable\'>';
            Html += '<tr class=\'priceMatrixTableHeader\'>';
            Html += '<th class=\'priceMatrixTableHeaderTypeColumn\'>' + 'Outbound' + '</th>';
            Html += '<th class=\'priceMatrixTableHeader\'>' + 'LTL' + '</th>';
            //Html += '<th class=\'priceMatrixTableHeader\'>' + 'FTL' + '</th>';
            Html += '<th class=\'priceMatrixTableHeader\'>' + '2nd Day' + '</th>';
            Html += '<th class=\'priceMatrixTableHeader\'>' + 'Next Day' + '</th>';
            Html += '<th class=\'priceMatrixTableHeader\'>' + 'Other' + '</th>';        
            Html += '</tr>';
            Html += '<tr>'; 
            Html += '<td class=\'priceMatrixTypeColumn\'>' + 'Air' + '</td>';
            Html += '<td colspan=1 class=\'priceMatrixValueNA\'>' + '' + '</td>';
                    
            if (complexPriceData.High.Outbound.Air.Air2ndDay.Detail.DisplayCode == null || complexPriceData.High.Outbound.Air.Air2ndDay.Detail.DisplayCode == '')
            {
                String HOAir2ndDayAdvDiscount = (complexPriceData.High.Outbound.Air.Air2ndDay.Detail.AdvOrderDiscountPercent > 0 ? 'Advance Order Discount: ' + string.valueOf(complexPriceData.High.Outbound.Air.Air2ndDay.Detail.AdvOrderDiscountPercent) + '%': '');
                String HOAir2ndDayRTDiscount = (complexPriceData.High.Outbound.Air.Air2ndDay.Detail.RoundTripDiscountPercent > 0 ? 'Roundtrip Discount: ' + string.valueOf(complexPriceData.High.Outbound.Air.Air2ndDay.Detail.RoundTripDiscountPercent) + '%' : '');
                String HOAir2ndDayDiscount = HOAir2ndDayAdvDiscount + (HOAir2ndDayAdvDiscount != '' ? '\n' : '') + HOAir2ndDayRTDiscount;
                
                String HOAir2ndDayClass = 'priceMatrixValue';
                
                if (q.OB_Shipment_Type__c != null && q.OB_Class_of_Service__c != null && q.OB_Selection__c != null && (q.Message__c == null || q.Message__c == ''))
                {
                    if (q.OB_Shipment_Type__c.toUpperCase() == 'AIR TRANSPORTATION' && q.OB_Class_of_Service__c.toUpperCase() == '2ND DAY' && q.OB_Selection__c.toUpperCase() == 'HIGH')
                        HOAir2ndDayClass = 'priceMatrixValuePriorSelection';
                }
                                
                Html += '<td id=\'HoAir2ndDay\' class=\'' + HOAir2ndDayClass + '\' onClick=\'changeOutboundCellColor(this,"HoAir2ndDay", "' + HoAir2ndDayRates + '"); return false;\' title=\'' + HOAir2ndDayDiscount + '\'>' + string.valueOf(complexPriceData.High.Outbound.Air.Air2ndDay.Detail.UnitPrice) + (complexPriceData.High.Outbound.Air.Air2ndDay.Detail.TotalDiscountPercent > 0 ? ' (-' + string.valueOf(complexPriceData.High.Outbound.Air.Air2ndDay.Detail.TotalDiscountPercent) + '%)' : '') + '</td>';
            }
            else {
                
                if (complexPriceData.High.Outbound.Air.Air2ndDay.Detail.DisplayCode != null && complexPriceData.High.Outbound.Air.Air2ndDay.Detail.Comments != null)                        
                    HoMoMessages.put(complexPriceData.High.Outbound.Air.Air2ndDay.Detail.DisplayCode, complexPriceData.High.Outbound.Air.Air2ndDay.Detail.Comments);
                
                if (complexPriceData.High.Outbound.Air.Air2ndDay.Detail.DisplayCode == 'X')
                    Html += '<td id=\'HoAir2ndDay\' class=\'priceMatrixValueInvalidEntry\'>' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.DisplayCode + '</td>';
                else
                    Html += '<td id=\'HoAir2ndDay\' class=\'priceMatrixValueSpecial\'>' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.DisplayCode + '</td>';
            }
                    
            if (complexPriceData.High.Outbound.Air.AirNextDay.Detail.DisplayCode == null || complexPriceData.High.Outbound.Air.AirNextDay.Detail.DisplayCode == '')
            {
                String HOAirNextDayAdvDiscount = (complexPriceData.High.Outbound.Air.AirNextDay.Detail.AdvOrderDiscountPercent > 0 ? 'Advance Order Discount: ' + string.valueOf(complexPriceData.High.Outbound.Air.AirNextDay.Detail.AdvOrderDiscountPercent) + '%': '');
                String HOAirNextDayRTDiscount = (complexPriceData.High.Outbound.Air.AirNextDay.Detail.RoundTripDiscountPercent > 0 ? 'Roundtrip Discount: ' + string.valueOf(complexPriceData.High.Outbound.Air.AirNextDay.Detail.RoundTripDiscountPercent) + '%' : '');
                String HOAirNextDayDiscount = HOAirNextDayAdvDiscount + (HOAirNextDayAdvDiscount != '' ? '\n' : '') + HOAirNextDayRTDiscount;
                
                String HOAirNextDayClass = 'priceMatrixValue';
                
                if (q.OB_Shipment_Type__c != null && q.OB_Class_of_Service__c != null && q.OB_Selection__c != null && (q.Message__c == null || q.Message__c == ''))
                {
                    if (q.OB_Shipment_Type__c.toUpperCase() == 'AIR TRANSPORTATION' && q.OB_Class_of_Service__c.toUpperCase() == 'NEXT DAY' && q.OB_Selection__c.toUppercase() == 'HIGH')
                        HOAirNextDayClass = 'priceMatrixValuePriorSelection';
                }
                
                Html += '<td id=\'HoAirNextDay\' class=\'' + HOAirNextDayClass + '\' onClick=\'changeOutboundCellColor(this,"HoAirNextDay", "' + HoAirNextDayRates + '"); return false;\' title=\'' + HOAirNextDayDiscount + '\'>' + string.valueOf(complexPriceData.High.Outbound.Air.AirNextDay.Detail.UnitPrice) + (complexPriceData.High.Outbound.Air.AirNextDay.Detail.TotalDiscountPercent > 0 ? ' (-' + string.valueOf(complexPriceData.High.Outbound.Air.AirNextDay.Detail.TotalDiscountPercent) + '%)' : '') + '</td>';
            }
            else {
                
                if (complexPriceData.High.Outbound.Air.AirNextDay.Detail.DisplayCode != null && complexPriceData.High.Outbound.Air.AirNextDay.Detail.Comments != null)                      
                    HoMoMessages.put(complexPriceData.High.Outbound.Air.AirNextDay.Detail.DisplayCode, complexPriceData.High.Outbound.Air.AirNextDay.Detail.Comments);
                
                if (complexPriceData.High.Outbound.Air.AirNextDay.Detail.DisplayCode == 'X')
                    Html += '<td id=\'HoAirNextDay\' class=\'priceMatrixValueInvalidEntry\'>' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.DisplayCode + '</td>';
                else
                    Html += '<td id=\'HoAirNextDay\' class=\'priceMatrixValueSpecial\'>' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.DisplayCode + '</td>';
            }
                    
            Html += '<td class=\'priceMatrixValueNA\'>' + '' + '</td>';
            Html += '</tr>';
            Html += '<tr>'; 
            Html += '<td class=\'priceMatrixTypeColumn\'>' + 'Ground' + '</td>';
            
            if (complexPriceData.High.Outbound.Ground.Ltl.Detail.DisplayCode == null || complexPriceData.High.Outbound.Ground.Ltl.Detail.DisplayCode == '')
            {
                String HOGroundLtlAdvDiscount = (complexPriceData.High.Outbound.Ground.Ltl.Detail.AdvOrderDiscountPercent > 0 ? 'Advance Order Discount: ' + string.valueOf(complexPriceData.High.Outbound.Ground.Ltl.Detail.AdvOrderDiscountPercent) + '%': '');
                String HOGroundLtlRTDiscount = (complexPriceData.High.Outbound.Ground.Ltl.Detail.RoundTripDiscountPercent > 0 ? 'Roundtrip Discount: ' + string.valueOf(complexPriceData.High.Outbound.Ground.Ltl.Detail.RoundTripDiscountPercent) + '%' : '');
                String HOGroundLtlDiscount = HOGroundLtlAdvDiscount + (HOGroundLtlAdvDiscount != '' ? '\n' : '') + HOGroundLtlRTDiscount;
                
                String HOGroundLtlClass = 'priceMatrixValue';
                
                if (q.OB_Shipment_Type__c != null && q.OB_Service_Type__c != null && q.OB_Selection__c != null && (q.Message__c == null || q.Message__c == ''))
                {               
                    if (q.OB_Shipment_Type__c.toUpperCase() == 'GROUND TRANSPORTATION' && q.OB_Service_Type__c.toUpperCase() == 'LTL' && q.OB_Selection__c.toUpperCase() == 'HIGH')
                        HOGroundLtlClass = 'priceMatrixValuePriorSelection';    
                }
                
                Html += '<td id=\'HoGroundLTL\' class=\'' + HOGroundLtlClass + '\' onClick=\'changeOutboundCellColor(this,"HoGroundLTL", "' + HoGroundLTLRates + '"); return false;\' title=\'' + HOGroundLtlDiscount + '\'>' + string.valueOf(complexPriceData.High.Outbound.Ground.Ltl.Detail.UnitPrice) + (complexPriceData.High.Outbound.Ground.Ltl.Detail.TotalDiscountPercent > 0 ? ' (-' + string.valueOf(complexPriceData.High.Outbound.Ground.Ltl.Detail.TotalDiscountPercent) + '%)' : '') + '</td>';
            }
            else {
                
                if (complexPriceData.High.Outbound.Ground.Ltl.Detail.DisplayCode != null && complexPriceData.High.Outbound.Ground.Ltl.Detail.Comments != null)                      
                    HoMoMessages.put(complexPriceData.High.Outbound.Ground.Ltl.Detail.DisplayCode, complexPriceData.High.Outbound.Ground.Ltl.Detail.Comments);
                
                if (complexPriceData.High.Outbound.Ground.Ltl.Detail.DisplayCode == 'X')
                    Html += '<td id=\'HoGroundLTL\' class=\'priceMatrixValueInvalidEntry\'>' + complexPriceData.High.Outbound.Ground.Ltl.Detail.DisplayCode + '</td>';
                else
                    Html += '<td id=\'HoGroundLTL\' class=\'priceMatrixValueSpecial\'>' + complexPriceData.High.Outbound.Ground.Ltl.Detail.DisplayCode + '</td>';
            }           
            
            //Html += '<td class=\'priceMatrixValue\' onClick=\'changeOutboundCellColor(this,"HoGroundLTL", "' + HoGroundLTLRates + '"); return false;\'>' + string.valueOf(complexPriceData.High.Outbound.Ground.Ltl.Detail.UnitPrice) + '</td>';
            //Html += '<td class=\'priceMatrixValue\' onClick=\'changeOutboundCellColor(this,"HoGroundFTL", "' + HoGroundFTLRates + '"); return false;\'>' + string.valueOf(complexPriceData.High.Outbound.Ground.Ftl.Detail.UnitPrice) + '</td>';
            Html += '<td colspan=3 class=\'priceMatrixValueNA\'>' + '</td>';
            Html += '</tr>';
            Html += '<tr>'; 
            Html += '<td class=\'priceMatrixTypeColumn\'>' + 'Local' + '</td>';
            //Html += '<td colspan=4 class=\'priceMatrixValueNA\'>' + '' + '</td>';
            Html += '<td colspan=3 class=\'priceMatrixValueNA\'>' + '' + '</td>';
                    
            if (complexPriceData.High.Outbound.Local.Detail.DisplayCode == null ||  complexPriceData.High.Outbound.Local.Detail.DisplayCode == '')
            {
                String HOLocalClass = 'priceMatrixValue';
                
                if (q.OB_Shipment_Type__c != null && q.OB_Selection__c != null && (q.Message__c == null || q.Message__c == ''))
                {               
                    if (q.OB_Shipment_Type__c.toUpperCase() == 'LOCAL SHIPMENTS' && q.OB_Selection__c.toUpperCase() == 'HIGH')
                        HOLocalClass = 'priceMatrixValuePriorSelection';    
                }
                                
                Html += '<td id=\'HoLocal\' class=\'' + HOLocalClass + '\' onClick=\'changeOutboundCellColor(this,"HoLocal", "' + HoLocalRates + '"); return false;\'>' + string.valueOf(complexPriceData.High.Outbound.Local.Detail.UnitPrice) + '</td>';
            }
            else
            {
                if (complexPriceData.High.Outbound.Local.Detail.DisplayCode != null && complexPriceData.High.Outbound.Local.Detail.Comments != null)                        
                    HoMoMessages.put(complexPriceData.High.Outbound.Local.Detail.DisplayCode, complexPriceData.High.Outbound.Local.Detail.Comments);
                
                if (complexPriceData.High.Outbound.Local.Detail.DisplayCode == 'X')
                    Html += '<td id=\'HoLocal\' class=\'priceMatrixValueInvalidEntry\'>' + complexPriceData.High.Outbound.Local.Detail.DisplayCode + '</td>';
                else
                    Html += '<td id=\'HoLocal\' class=\'priceMatrixValueSpecial\'>' + complexPriceData.High.Outbound.Local.Detail.DisplayCode + '</td>';                        
            }
                        
            Html += '</tr>';
            Html += '</table>';
        }
        else
        {
            /*
                In a custom quote, the Quote_Subject__c field could be different from the direction argument passed
                to the GetRates method. In this case though, even if the quote subject is "ROUNDTRIP", the direction
                value could be Inbound, because Custom Quote flag is checked on the Outbound. In such a case, display
                this message.               
            */
            
            if (q.Quote_Subject__c.toUpperCase() != Direction && q.OB_Custom_Quote__c)          
                HoInboundHtmlNoRatesMessage = '<table style=\'border:none\'><tr><td style=\'padding-top: 20px; color: red\'>Outbound shipment is custom quote.</td></tr></table>';
            
            /*
                This else portion below is not required. When Quote_Subject__c is Inbound, the code will always
                execute this parent else portion and result in message display, which is not required since the 
                quote is Inbound. NOTE: In normal quote (i.e. not custom quote), the direction argument is always 
                the same as the Quote_Subject__c field.
            */ 
                        
            //else
            //  HoInboundHtmlNoRatesMessage = '<table style=\'border:none\'><tr><td style=\'padding-top: 20px;\'>To view rates for Outbound shipment, required field values must be provided.</td></tr></table>';
        }
                
        Html += HiInboundHtmlNoRatesMessage + HoInboundHtmlNoRatesMessage;  
        
        map<string, string> HMoMessages = new map<string, string>();
                        
        for(string msg : HiMoMessages.keySet())
            HMoMessages.put(msg, HiMoMessages.get(msg));
            
        for(string msg : HoMoMessages.keySet())
            HMoMessages.put(msg, HoMoMessages.get(msg));                    
                                
        string HMsgTable = '';
        
        for(string msg : HMoMessages.keySet())
        {
            HMsgTable += '<tr><td style=\'color: red; font-weight: bold; width: 20px; text-align: top;\'>' + msg + '</td><td style=\'color: red;\'>' + HMoMessages.get(msg) + '</td></tr>';
        }
        
        if (HMsgTable != '')
            HMsgTable = '<table style=\'border:none; margin-top: 10px;\'>' + HMsgTable + '</table>';
        
        Html += HMsgTable;              
        
        Html += '</div>';
                
        Html += '<div id=\'low\'>';
        
        if (direction == 'ROUNDTRIP' || direction == 'INBOUND')
        {   
            string LiAir2ndDayRates = complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.UnitPrice + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.FuelSurcharge + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.LiftGateFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.InsideFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.ResidentialFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.WeekendFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.WaitTimeFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.PalletizationFee + ','  + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.AttemptFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.SubTotal + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.Total + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.RoundTripDiscountPercent + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.AdvReceivingEndDate; 
            string LiAirNextDayRates = complexPriceData.Low.Inbound.Air.AirNextDay.Detail.UnitPrice + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.FuelSurcharge + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.LiftGateFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.InsideFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.ResidentialFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.WeekendFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.WaitTimeFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.PalletizationFee + ','  + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.AttemptFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.SubTotal + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.Total + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.RoundtripDiscountPercent + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.AdvReceivingEndDate;
            string LiGroundLTLRates = complexPriceData.Low.Inbound.Ground.Ltl.Detail.UnitPrice + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.FuelSurcharge + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.LiftGateFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.InsideFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.ResidentialFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.WeekendFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.WaitTimeFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.PalletizationFee + ','  + complexPriceData.Low.Inbound.Ground.Ltl.Detail.AttemptFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.SubTotal + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.Total + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.RoundtripDiscountPercent + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.AdvReceivingEndDate;
            string LiGroundFTLRates = complexPriceData.Low.Inbound.Ground.Ftl.Detail.UnitPrice + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.FuelSurcharge + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.LiftGateFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.InsideFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.ResidentialFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.WeekendFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.WaitTimeFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.PalletizationFee + ','  + complexPriceData.Low.Inbound.Ground.Ftl.Detail.AttemptFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.SubTotal + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.Total + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.RoundtripDiscountPercent + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.AdvReceivingEndDate;          
            string LiLocalRates = complexPriceData.Low.Inbound.Local.Detail.UnitPrice + ',' + complexPriceData.Low.Inbound.Local.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Inbound.Local.Detail.FuelSurcharge + ',' + complexPriceData.Low.Inbound.Local.Detail.LiftGateFee + ',' + complexPriceData.Low.Inbound.Local.Detail.InsideFee + ',' + complexPriceData.Low.Inbound.Local.Detail.ResidentialFee + ',' + complexPriceData.Low.Inbound.Local.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Inbound.Local.Detail.WeekendFee + ',' + complexPriceData.Low.Inbound.Local.Detail.WaitTimeFee + ',' + complexPriceData.Low.Inbound.Local.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Inbound.Local.Detail.PalletizationFee + ','  + complexPriceData.Low.Inbound.Local.Detail.AttemptFee + ',' + complexPriceData.Low.Inbound.Local.Detail.SubTotal + ',' + complexPriceData.Low.Inbound.Local.Detail.Total + ',' + complexPriceData.Low.Inbound.Local.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.Low.Inbound.Local.Detail.RoundTripDiscountPercent + ',' + complexPriceData.Low.Inbound.Local.Detail.AdvReceivingEndDate;
            
            //string LiAir2ndDayRates = complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.UnitPrice + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.FuelSurcharge + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.LiftGateFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.InsideFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.ResidentialFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.WeekendFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.WaitTimeFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.PalletizationFee + ','  + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.AttemptFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.SubTotal + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.Total + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.TotalDiscountPercent + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.AdvReceivingEndDate; 
            //string LiAirNextDayRates = complexPriceData.Low.Inbound.Air.AirNextDay.Detail.UnitPrice + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.FuelSurcharge + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.LiftGateFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.InsideFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.ResidentialFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.WeekendFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.WaitTimeFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.PalletizationFee + ','  + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.AttemptFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.SubTotal + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.Total + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.TotalDiscountPercent + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.AdvReceivingEndDate;
            //string LiGroundLTLRates = complexPriceData.Low.Inbound.Ground.Ltl.Detail.UnitPrice + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.FuelSurcharge + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.LiftGateFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.InsideFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.ResidentialFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.WeekendFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.WaitTimeFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.PalletizationFee + ','  + complexPriceData.Low.Inbound.Ground.Ltl.Detail.AttemptFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.SubTotal + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.Total + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.TotalDiscountPercent + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.AdvReceivingEndDate;
            //string LiGroundFTLRates = complexPriceData.Low.Inbound.Ground.Ftl.Detail.UnitPrice + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.FuelSurcharge + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.LiftGateFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.InsideFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.ResidentialFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.WeekendFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.WaitTimeFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.PalletizationFee + ','  + complexPriceData.Low.Inbound.Ground.Ftl.Detail.AttemptFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.SubTotal + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.Total + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.TotalDiscountPercent + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.AdvReceivingEndDate;               
            //string LiLocalRates = complexPriceData.Low.Inbound.Local.Detail.UnitPrice + ',' + complexPriceData.Low.Inbound.Local.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Inbound.Local.Detail.FuelSurcharge + ',' + complexPriceData.Low.Inbound.Local.Detail.LiftGateFee + ',' + complexPriceData.Low.Inbound.Local.Detail.InsideFee + ',' + complexPriceData.Low.Inbound.Local.Detail.ResidentialFee + ',' + complexPriceData.Low.Inbound.Local.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Inbound.Local.Detail.WeekendFee + ',' + complexPriceData.Low.Inbound.Local.Detail.WaitTimeFee + ',' + complexPriceData.Low.Inbound.Local.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Inbound.Local.Detail.PalletizationFee + ','  + complexPriceData.Low.Inbound.Local.Detail.AttemptFee + ',' + complexPriceData.Low.Inbound.Local.Detail.SubTotal + ',' + complexPriceData.Low.Inbound.Local.Detail.Total + ',' + complexPriceData.Low.Inbound.Local.Detail.TotalDiscountPercent + ',' + complexPriceData.Low.Inbound.Local.Detail.AdvReceivingEndDate;
        
            Html += '<table class=\'priceMatrixTable\'>';
            Html += '<tr class=\'priceMatrixTableHeader\'>';
            Html += '<th class=\'priceMatrixTableHeaderTypeColumn\'>' + 'Inbound' + '</th>';
            Html += '<th class=\'priceMatrixTableHeader\'>' + 'LTL' + '</th>';
            //Html += '<th class=\'priceMatrixTableHeader\'>' + 'FTL' + '</th>';
            Html += '<th class=\'priceMatrixTableHeader\'>' + '2nd Day' + '</th>';
            Html += '<th class=\'priceMatrixTableHeader\'>' + 'Next Day' + '</th>';
            Html += '<th class=\'priceMatrixTableHeader\'>' + 'Other' + '</th>';        
            Html += '</tr>';
            Html += '<tr>'; 
            Html += '<td class=\'priceMatrixTypeColumn\'>' + 'Air' + '</td>';
            Html += '<td colspan=1 class=\'priceMatrixValueNA\'>' + '' + '</td>';
                    
            if (complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.DisplayCode == null || complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.DisplayCode == '')
            {
                String LIAir2ndDayAdvDiscount = (complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.AdvOrderDiscountPercent > 0 ? 'Advance Order Discount: ' + string.valueOf(complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.AdvOrderDiscountPercent) + '%': '');
                String LIAir2ndDayRTDiscount = (complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.RoundTripDiscountPercent > 0 ? 'Roundtrip Discount: ' + string.valueOf(complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.RoundTripDiscountPercent) + '%' : '');
                String LIAir2ndDayDiscount = LIAir2ndDayAdvDiscount + (LIAir2ndDayAdvDiscount != '' ? '\n' : '') + LIAir2ndDayRTDiscount;
                
                String LIAir2ndDayClass = 'priceMatrixValue';
                
                if (q.Shipment_Type__c != null && q.Class_of_Service__c != null && q.Selection__c != null && (q.Message__c == null || q.Message__c == ''))
                {
                    if (q.Shipment_Type__c.toUpperCase() == 'AIR TRANSPORTATION' && q.Class_of_Service__c.toUpperCase() == '2ND DAY' && q.Selection__c.toUpperCase() == 'LOW')
                        LIAir2ndDayClass = 'priceMatrixValuePriorSelection';
                }
                                
                Html += '<td id=\'LiAir2ndDay\' class=\'' + LIAir2ndDayClass + '\'  onClick=\'changeInboundCellColor(this,"LiAir2ndDay", "' + LiAir2ndDayRates + '"); return false;\' title=\'' + LIAir2ndDayDiscount + '\'>' + string.valueOf(complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.UnitPrice) + (complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.TotalDiscountPercent > 0 ? ' (-' + string.valueOf(complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.TotalDiscountPercent) + '%)' : '') + '</td>';
            }
            else {
                
                if (complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.DisplayCode != null && complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.Comments != null)                        
                    LiMoMessages.put(complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.DisplayCode, complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.Comments);
                
                if (complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.DisplayCode == 'X')
                    Html += '<td id=\'LiAir2ndDay\' class=\'priceMatrixValueInvalidEntry\'>' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.DisplayCode + '</td>';
                else
                    Html += '<td id=\'LiAir2ndDay\' class=\'priceMatrixValueSpecial\'>' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.DisplayCode + '</td>';
            }
                    
            if (complexPriceData.Low.Inbound.Air.AirNextDay.Detail.DisplayCode == null || complexPriceData.Low.Inbound.Air.AirNextDay.Detail.DisplayCode == '')
            {
                String LIAirNextDayAdvDiscount = (complexPriceData.Low.Inbound.Air.AirNextDay.Detail.AdvOrderDiscountPercent > 0 ? 'Advance Order Discount: ' + string.valueOf(complexPriceData.Low.Inbound.Air.AirNextDay.Detail.AdvOrderDiscountPercent) + '%': '');
                String LIAirNextDayRTDiscount = (complexPriceData.Low.Inbound.Air.AirNextDay.Detail.RoundTripDiscountPercent > 0 ? 'Roundtrip Discount: ' + string.valueOf(complexPriceData.Low.Inbound.Air.AirNextDay.Detail.RoundTripDiscountPercent) + '%' : '');
                String LIAirNextDayDiscount = LIAirNextDayAdvDiscount + (LIAirNextDayAdvDiscount != '' ? '\n' : '') + LIAirNextDayRTDiscount;
                    
                String LIAirNextDayClass = 'priceMatrixValue';
                
                if (q.Shipment_Type__c != null && q.Class_of_Service__c != null && q.Selection__c != null && (q.Message__c == null || q.Message__c == ''))
                {
                    if (q.Shipment_Type__c.toUpperCase() == 'AIR TRANSPORTATION' && q.Class_of_Service__c.toUpperCase() == 'NEXT DAY' && q.Selection__c.toUpperCase() == 'LOW')
                        LIAirNextDayClass = 'priceMatrixValuePriorSelection';
                }
                
                Html += '<td id=\'LiAirNextDay\' class=\'' + LIAirNextDayClass + '\'  onClick=\'changeInboundCellColor(this,"LiAirNextDay", "' + LiAirNextDayRates + '"); return false;\' title=\'' + LIAirNextDayDiscount + '\'>' + string.valueOf(complexPriceData.Low.Inbound.Air.AirNextDay.Detail.UnitPrice) + (complexPriceData.Low.Inbound.Air.AirNextDay.Detail.TotalDiscountPercent > 0 ? ' (-' + string.valueOf(complexPriceData.Low.Inbound.Air.AirNextDay.Detail.TotalDiscountPercent) + '%)' : '') + '</td>';
            }
            else {
                            
                if (complexPriceData.Low.Inbound.Air.AirNextDay.Detail.DisplayCode != null && complexPriceData.Low.Inbound.Air.AirNextDay.Detail.Comments != null)
                    LiMoMessages.put(complexPriceData.Low.Inbound.Air.AirNextDay.Detail.DisplayCode, complexPriceData.Low.Inbound.Air.AirNextDay.Detail.Comments);
                
                if (complexPriceData.Low.Inbound.Air.AirNextDay.Detail.DisplayCode == 'X')
                    Html += '<td id=\'LiAirNextDay\' class=\'priceMatrixValueInvalidEntry\'>' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.DisplayCode + '</td>';
                else
                    Html += '<td id=\'LiAirNextDay\' class=\'priceMatrixValueSpecial\'>' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.DisplayCode + '</td>';
            }
                    
            Html += '<td class=\'priceMatrixValueNA\'>' + '' + '</td>';
            Html += '</tr>';
            Html += '<tr>'; 
            Html += '<td class=\'priceMatrixTypeColumn\'>' + 'Ground' + '</td>';
            
            if (complexPriceData.Low.Inbound.Ground.Ltl.Detail.DisplayCode == null || complexPriceData.Low.Inbound.Ground.Ltl.Detail.DisplayCode == '')
            {
                String LIGroundLtlAdvDiscount = (complexPriceData.Low.Inbound.Ground.Ltl.Detail.AdvOrderDiscountPercent > 0 ? 'Advance Order Discount: ' + string.valueOf(complexPriceData.Low.Inbound.Ground.Ltl.Detail.AdvOrderDiscountPercent) + '%': '');
                String LIGroundLtlRTDiscount = (complexPriceData.Low.Inbound.Ground.Ltl.Detail.RoundTripDiscountPercent > 0 ? 'Roundtrip Discount: ' + string.valueOf(complexPriceData.Low.Inbound.Ground.Ltl.Detail.RoundTripDiscountPercent) + '%' : '');
                String LIGroundLtlDiscount = LIGroundLtlAdvDiscount + (LIGroundLtlAdvDiscount != '' ? '\n' : '') + LIGroundLtlRTDiscount;
                        
                String LIGroundLtlClass = 'priceMatrixValue';
                
                if (q.Shipment_Type__c != null && q.Service_Type__c != null && q.Selection__c != null && (q.Message__c == null || q.Message__c == ''))
                {               
                    if (q.Shipment_Type__c.toUpperCase() == 'GROUND TRANSPORTATION' && q.Service_Type__c.toUpperCase() == 'LTL' && q.Selection__c.toUpperCase() == 'LOW')
                        LIGroundLtlClass = 'priceMatrixValuePriorSelection';    
                }
                
                Html += '<td id=\'LiGroundLTL\' class=\'' + LIGroundLtlClass + '\' onClick=\'changeInboundCellColor(this,"LiGroundLTL", "' + LiGroundLTLRates + '"); return false;\' title=\'' + LIGroundLtlDiscount + '\'>' + string.valueOf(complexPriceData.Low.Inbound.Ground.Ltl.Detail.UnitPrice) + (complexPriceData.Low.Inbound.Ground.Ltl.Detail.TotalDiscountPercent > 0 ? ' (-' + string.valueOf(complexPriceData.Low.Inbound.Ground.Ltl.Detail.TotalDiscountPercent) + '%)' : '') + '</td>';
            }
            else {
                
                if (complexPriceData.Low.Inbound.Ground.Ltl.Detail.DisplayCode != null && complexPriceData.Low.Inbound.Ground.Ltl.Detail.Comments != null)                      
                    LiMoMessages.put(complexPriceData.Low.Inbound.Ground.Ltl.Detail.DisplayCode, complexPriceData.Low.Inbound.Ground.Ltl.Detail.Comments);
                
                if (complexPriceData.Low.Inbound.Ground.Ltl.Detail.DisplayCode == 'X')
                    Html += '<td id=\'LiGroundLTL\' class=\'priceMatrixValueInvalidEntry\'>' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.DisplayCode + '</td>';
                else
                    Html += '<td id=\'LiGroundLTL\' class=\'priceMatrixValueSpecial\'>' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.DisplayCode + '</td>';
            }
                        
            //Html += '<td class=\'priceMatrixValue\'  onClick=\'changeInboundCellColor(this,"LiGroundLTL", "' + LiGroundLTLRates + '"); return false;\'>' + string.valueOf(complexPriceData.Low.Inbound.Ground.Ltl.Detail.UnitPrice) + '</td>';
            //Html += '<td class=\'priceMatrixValue\'  onClick=\'changeInboundCellColor(this,"LiGroundFTL", "' + LiGroundFTLRates + '"); return false;\'>' + string.valueOf(complexPriceData.Low.Inbound.Ground.Ftl.Detail.UnitPrice) + '</td>';
            Html += '<td colspan=3 class=\'priceMatrixValueNA\'>' + '</td>';
            Html += '</tr>';
            Html += '<tr>'; 
            Html += '<td class=\'priceMatrixTypeColumn\'>' + 'Local' + '</td>';
            //Html += '<td colspan=4 class=\'priceMatrixValueNA\'>' + '' + '</td>';
            Html += '<td colspan=3 class=\'priceMatrixValueNA\'>' + '' + '</td>';
                    
            if (complexPriceData.Low.Inbound.Local.Detail.DisplayCode == null || complexPriceData.Low.Inbound.Local.Detail.DisplayCode == '')
            {
                String LILocalClass = 'priceMatrixValue';
                
                if (q.Shipment_Type__c != null && q.Selection__c != null && (q.Message__c == null || q.Message__c == ''))
                {               
                    if (q.Shipment_Type__c.toUpperCase() == 'LOCAL SHIPMENTS' && q.Selection__c.toUpperCase() == 'LOW')
                        LILocalClass = 'priceMatrixValuePriorSelection';    
                }
                        
                Html += '<td id=\'LiLocal\' class=\'' + LILocalClass + '\'  onClick=\'changeInboundCellColor(this,"LiLocal", "' + LiLocalRates + '"); return false;\'>' + string.valueOf(complexPriceData.Low.Inbound.Local.Detail.UnitPrice) + '</td>';
            }
            else
            {
                if (complexPriceData.Low.Inbound.Local.Detail.DisplayCode != null && complexPriceData.Low.Inbound.Local.Detail.Comments != null)                        
                    LiMoMessages.put(complexPriceData.Low.Inbound.Local.Detail.DisplayCode, complexPriceData.Low.Inbound.Local.Detail.Comments);
                
                if (complexPriceData.Low.Inbound.Local.Detail.DisplayCode == 'X')
                    Html += '<td id=\'LiLocal\' class=\'priceMatrixValueInvalidEntry\'>' + complexPriceData.Low.Inbound.Local.Detail.DisplayCode + '</td>';
                else
                    Html += '<td id=\'LiLocal\' class=\'priceMatrixValueSpecial\'>' + complexPriceData.Low.Inbound.Local.Detail.DisplayCode + '</td>';                      
            }
            
            Html += '</tr>';
            Html += '</table>';
        }
        else
        {
            /*
                In a custom quote, the Quote_Subject__c field could be different from the direction argument passed
                to the GetRates method. In this case though, even if the quote subject is "ROUNDTRIP", the direction
                value could be Outbound, because Custom Quote flag is checked on the Inbound. In such a case, display
                this message.               
            */
            
            if (q.Quote_Subject__c.toUpperCase() != Direction && q.Custom_Quote__c)         
                LiInboundHtmlNoRatesMessage = '<table style=\'border:none\'><tr><td style=\'padding-top: 20px; color: red\'>Inbound shipment is custom quote.</td></tr></table>';               
            
            /*
                This else portion below is not required. When Quote_Subject__c is Outbound, the code will always
                execute this parent else portion and result in message display, which is not required since the 
                quote is Outbound. NOTE: In normal quote (i.e. not custom quote), the direction argument is always 
                the same as the Quote_Subject__c field.
            */ 
                            
            //else
            //  LiInboundHtmlNoRatesMessage = '<table style=\'border:none\'><tr><td style=\'padding-top: 20px;\'>To view rates for Inbound shipment, required field values must be provided.</td></tr></table>';
        }           
                    
        if (direction == 'ROUNDTRIP' || direction == 'OUTBOUND')
        {
            string LoAir2ndDayRates = complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.UnitPrice + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.FuelSurcharge + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.LiftGateFee + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.InsideFee + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.ResidentialFee + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.WeekendFee + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.WaitTimeFee + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.PalletizationFee + ','  + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.AttemptFee + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.SubTotal + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.Total + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.RoundTripDiscountPercent + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.AdvReceivingEndDate; 
            string LoAirNextDayRates = complexPriceData.Low.Outbound.Air.AirNextDay.Detail.UnitPrice + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.FuelSurcharge + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.LiftGateFee + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.InsideFee + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.ResidentialFee + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.WeekendFee + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.WaitTimeFee + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.PalletizationFee + ','  + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.AttemptFee + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.SubTotal + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.Total + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.RoundtripDiscountPercent + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.AdvReceivingEndDate;
            string LoGroundLTLRates = complexPriceData.Low.Outbound.Ground.Ltl.Detail.UnitPrice + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.FuelSurcharge + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.LiftGateFee + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.InsideFee + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.ResidentialFee + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.WeekendFee + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.WaitTimeFee + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.PalletizationFee + ','  + complexPriceData.Low.Outbound.Ground.Ltl.Detail.AttemptFee + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.SubTotal + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.Total + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.RoundtripDiscountPercent + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.AdvReceivingEndDate;
            string LoGroundFTLRates = complexPriceData.Low.Outbound.Ground.Ftl.Detail.UnitPrice + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.FuelSurcharge + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.LiftGateFee + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.InsideFee + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.ResidentialFee + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.WeekendFee + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.WaitTimeFee + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.PalletizationFee + ','  + complexPriceData.Low.Outbound.Ground.Ftl.Detail.AttemptFee + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.SubTotal + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.Total + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.RoundtripDiscountPercent + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.AdvReceivingEndDate;         
            string LoLocalRates = complexPriceData.Low.Outbound.Local.Detail.UnitPrice + ',' + complexPriceData.Low.Outbound.Local.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Outbound.Local.Detail.FuelSurcharge + ',' + complexPriceData.Low.Outbound.Local.Detail.LiftGateFee + ',' + complexPriceData.Low.Outbound.Local.Detail.InsideFee + ',' + complexPriceData.Low.Outbound.Local.Detail.ResidentialFee + ',' + complexPriceData.Low.Outbound.Local.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Outbound.Local.Detail.WeekendFee + ',' + complexPriceData.Low.Outbound.Local.Detail.WaitTimeFee + ',' + complexPriceData.Low.Outbound.Local.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Outbound.Local.Detail.PalletizationFee + ','  + complexPriceData.Low.Outbound.Local.Detail.AttemptFee + ',' + complexPriceData.Low.Outbound.Local.Detail.SubTotal + ',' + complexPriceData.Low.Outbound.Local.Detail.Total + ',' + complexPriceData.Low.Outbound.Local.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.Low.Outbound.Local.Detail.RoundTripDiscountPercent + ',' + complexPriceData.Low.Outbound.Local.Detail.AdvReceivingEndDate;
            
            Html += '<table class=\'priceMatrixTable\'>';
            Html += '<tr class=\'priceMatrixTableHeader\'>';
            Html += '<th class=\'priceMatrixTableHeaderTypeColumn\'>' + 'Outbound' + '</th>';
            Html += '<th class=\'priceMatrixTableHeader\'>' + 'LTL' + '</th>';
            //Html += '<th class=\'priceMatrixTableHeader\'>' + 'FTL' + '</th>';
            Html += '<th class=\'priceMatrixTableHeader\'>' + '2nd Day' + '</th>';
            Html += '<th class=\'priceMatrixTableHeader\'>' + 'Next Day' + '</th>';
            Html += '<th class=\'priceMatrixTableHeader\'>' + 'Other' + '</th>';        
            Html += '</tr>';
            Html += '<tr>'; 
            Html += '<td class=\'priceMatrixTypeColumn\'>' + 'Air' + '</td>';
            Html += '<td colspan=1 class=\'priceMatrixValueNA\'>' + '' + '</td>';
            
            if (complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.DisplayCode == null || complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.DisplayCode == '')
            {
                String LOAir2ndDayAdvDiscount = (complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.AdvOrderDiscountPercent > 0 ? 'Advance Order Discount: ' + string.valueOf(complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.AdvOrderDiscountPercent) + '%': '');
                String LOAir2ndDayRTDiscount = (complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.RoundTripDiscountPercent > 0 ? 'Roundtrip Discount: ' + string.valueOf(complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.RoundTripDiscountPercent) + '%' : '');
                String LOAir2ndDayDiscount = LOAir2ndDayAdvDiscount + (LOAir2ndDayAdvDiscount != '' ? '\n' : '') + LOAir2ndDayRTDiscount;
                
                String LOAir2ndDayClass = 'priceMatrixValue';
                
                if (q.OB_Shipment_Type__c != null && q.OB_Class_of_Service__c != null && q.OB_Selection__c != null && (q.Message__c == null || q.Message__c == ''))
                {
                    if (q.OB_Shipment_Type__c.toUpperCase() == 'AIR TRANSPORTATION' && q.OB_Class_of_Service__c.toUpperCase() == '2ND DAY' && q.OB_Selection__c.toUpperCase() == 'LOW')
                        LOAir2ndDayClass = 'priceMatrixValuePriorSelection';
                }
                                
                Html += '<td id=\'LoAir2ndDay\' class=\'' + LOAir2ndDayClass + '\' onClick=\'changeOutboundCellColor(this,"LoAir2ndDay", "' + LoAir2ndDayRates + '"); return false;\' title=\'' + LOAir2ndDayDiscount + '\'>' + string.valueOf(complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.UnitPrice) + (complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.TotalDiscountPercent > 0 ? ' (-' + string.valueOf(complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.TotalDiscountPercent) + '%)' : '') + '</td>';
            }                       
            else {
                if (complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.DisplayCode != null && complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.Comments != null)                      
                    LoMoMessages.put(complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.DisplayCode, complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.Comments);
                
                if (complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.DisplayCode == 'X')
                    Html += '<td id=\'LoAir2ndDay\' class=\'priceMatrixValueInvalidEntry\'>' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.DisplayCode + '</td>';
                else
                    Html += '<td id=\'LoAir2ndDay\' class=\'priceMatrixValueSpecial\'>' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.DisplayCode + '</td>';
            }
                    
            if (complexPriceData.Low.Outbound.Air.AirNextDay.Detail.DisplayCode == null || complexPriceData.Low.Outbound.Air.AirNextDay.Detail.DisplayCode == '')
            {
                String LOAirNextDayAdvDiscount = (complexPriceData.Low.Outbound.Air.AirNextDay.Detail.AdvOrderDiscountPercent > 0 ? 'Advance Order Discount: ' + string.valueOf(complexPriceData.Low.Outbound.Air.AirNextDay.Detail.AdvOrderDiscountPercent) + '%': '');
                String LOAirNextDayRTDiscount = (complexPriceData.Low.Outbound.Air.AirNextDay.Detail.RoundTripDiscountPercent > 0 ? 'Roundtrip Discount: ' + string.valueOf(complexPriceData.Low.Outbound.Air.AirNextDay.Detail.RoundTripDiscountPercent) + '%' : '');
                String LOAirNextDayDiscount = LOAirNextDayAdvDiscount + (LOAirNextDayAdvDiscount != '' ? '\n' : '') + LOAirNextDayRTDiscount;
                
                String LOAirNextDayClass = 'priceMatrixValue';
                
                if (q.OB_Shipment_Type__c != null && q.OB_Class_of_Service__c != null && q.OB_Selection__c != null && (q.Message__c == null || q.Message__c == ''))
                {
                    if (q.OB_Shipment_Type__c.toUpperCase() == 'AIR TRANSPORTATION' && q.OB_Class_of_Service__c.toUpperCase() == 'NEXT DAY' && q.OB_Selection__c.toUpperCase() == 'LOW')
                        LOAirNextDayClass = 'priceMatrixValuePriorSelection';
                }
                
                Html += '<td id=\'LoAirNextDay\' class=\'' + LOAirNextDayClass + '\' onClick=\'changeOutboundCellColor(this,"LoAirNextDay", "' + LoAirNextDayRates + '"); return false;\' title=\'' + LOAirNextDayDiscount + '\'>' + string.valueOf(complexPriceData.Low.Outbound.Air.AirNextDay.Detail.UnitPrice) + (complexPriceData.Low.Outbound.Air.AirNextDay.Detail.TotalDiscountPercent > 0 ? ' (-' + string.valueOf(complexPriceData.Low.Outbound.Air.AirNextDay.Detail.TotalDiscountPercent) + '%)' : '') + '</td>';
            }
            else {
                
                if (complexPriceData.Low.Outbound.Air.AirNextDay.Detail.DisplayCode != null && complexPriceData.Low.Outbound.Air.AirNextDay.Detail.Comments != null)                        
                    LoMoMessages.put(complexPriceData.Low.Outbound.Air.AirNextDay.Detail.DisplayCode, complexPriceData.Low.Outbound.Air.AirNextDay.Detail.Comments);
                
                if (complexPriceData.Low.Outbound.Air.AirNextDay.Detail.DisplayCode == 'X')
                    Html += '<td id=\'LoAirNextDay\' class=\'priceMatrixValueInvalidEntry\'>' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.DisplayCode + '</td>';
                else
                    Html += '<td id=\'LoAirNextDay\' class=\'priceMatrixValueSpecial\'>' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.DisplayCode + '</td>';
            }                   
                    
            Html += '<td class=\'priceMatrixValueNA\'>' + '' + '</td>';
            Html += '</tr>';
            Html += '<tr>'; 
            Html += '<td class=\'priceMatrixTypeColumn\'>' + 'Ground' + '</td>';
            
            if (complexPriceData.Low.Outbound.Ground.Ltl.Detail.DisplayCode == null || complexPriceData.Low.Outbound.Ground.Ltl.Detail.DisplayCode == '')
            {
                String LOGroundLtlAdvDiscount = (complexPriceData.Low.Outbound.Ground.Ltl.Detail.AdvOrderDiscountPercent > 0 ? 'Advance Order Discount: ' + string.valueOf(complexPriceData.Low.Outbound.Ground.Ltl.Detail.AdvOrderDiscountPercent) + '%': '');
                String LOGroundLtlRTDiscount = (complexPriceData.Low.Outbound.Ground.Ltl.Detail.RoundTripDiscountPercent > 0 ? 'Roundtrip Discount: ' + string.valueOf(complexPriceData.Low.Outbound.Ground.Ltl.Detail.RoundTripDiscountPercent) + '%' : '');
                String LOGroundLtlDiscount = LOGroundLtlAdvDiscount + (LOGroundLtlAdvDiscount != '' ? '\n' : '') + LOGroundLtlRTDiscount;
                
                String LOGroundLtlClass = 'priceMatrixValue';
                
                if (q.OB_Shipment_Type__c != null && q.OB_Service_Type__c != null && q.OB_Selection__c != null && (q.Message__c == null || q.Message__c == ''))
                {               
                    if (q.OB_Shipment_Type__c.toUpperCase() == 'GROUND TRANSPORTATION' && q.OB_Service_Type__c.toUpperCase() == 'LTL' && q.OB_Selection__c.toUpperCase() == 'LOW')
                        LOGroundLtlClass = 'priceMatrixValuePriorSelection';    
                }
                
                Html += '<td id=\'LoGroundLTL\' class=\'' + LOGroundLtlClass + '\' onClick=\'changeOutboundCellColor(this,"LoGroundLTL", "' + LoGroundLTLRates + '"); return false;\' title=\'' + LOGroundLtlDiscount + '\'>' + string.valueOf(complexPriceData.Low.Outbound.Ground.Ltl.Detail.UnitPrice) + (complexPriceData.Low.Outbound.Ground.Ltl.Detail.TotalDiscountPercent > 0 ? ' (-' + string.valueOf(complexPriceData.Low.Outbound.Ground.Ltl.Detail.TotalDiscountPercent) + '%)' : '') + '</td>';
            }
            else {
                
                if (complexPriceData.Low.Outbound.Ground.Ltl.Detail.DisplayCode != null && complexPriceData.Low.Outbound.Ground.Ltl.Detail.Comments != null)                        
                    LoMoMessages.put(complexPriceData.Low.Outbound.Ground.Ltl.Detail.DisplayCode, complexPriceData.Low.Outbound.Ground.Ltl.Detail.Comments);
                
                if (complexPriceData.Low.Outbound.Ground.Ltl.Detail.DisplayCode == 'X')
                    Html += '<td id=\'LoGroundLTL\' class=\'priceMatrixValueInvalidEntry\'>' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.DisplayCode + '</td>';
                else
                    Html += '<td id=\'LoGroundLTL\' class=\'priceMatrixValueSpecial\'>' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.DisplayCode + '</td>';
            }
                        
            //Html += '<td class=\'priceMatrixValue\' onClick=\'changeOutboundCellColor(this,"LoGroundLTL", "' + LoGroundLTLRates + '"); return false;\'>' + string.valueOf(complexPriceData.Low.Outbound.Ground.Ltl.Detail.UnitPrice) + '</td>';
            //Html += '<td class=\'priceMatrixValue\' onClick=\'changeOutboundCellColor(this,"LoGroundFTL", "' + LoGroundFTLRates + '"); return false;\'>' + string.valueOf(complexPriceData.Low.Outbound.Ground.Ftl.Detail.UnitPrice) + '</td>';
            Html += '<td colspan=3 class=\'priceMatrixValueNA\'>' + '</td>';
            Html += '</tr>';
            Html += '<tr>'; 
            Html += '<td class=\'priceMatrixTypeColumn\'>' + 'Local' + '</td>';
            //Html += '<td colspan=4 class=\'priceMatrixValueNA\'>' + '' + '</td>';
            Html += '<td colspan=3 class=\'priceMatrixValueNA\'>' + '' + '</td>';
            
            if (complexPriceData.Low.Outbound.Local.Detail.DisplayCode == null || complexPriceData.Low.Outbound.Local.Detail.DisplayCode == '')
            {
                String LOLocalClass = 'priceMatrixValue';
                
                if (q.OB_Shipment_Type__c != null && q.OB_Selection__c != null && (q.Message__c == null || q.Message__c == ''))
                {               
                    if (q.OB_Shipment_Type__c.toUpperCase() == 'LOCAL SHIPMENTS' && q.OB_Selection__c.toUpperCase() == 'LOW')
                        LOLocalClass = 'priceMatrixValuePriorSelection';    
                }
                                
                Html += '<td id=\'LoLocal\' class=\'' + LOLocalClass + '\' onClick=\'changeOutboundCellColor(this,"LoLocal", "' + LoLocalRates + '"); return false;\'>' + string.valueOf(complexPriceData.Low.Outbound.Local.Detail.UnitPrice) + '</td>';
            }
            else
            {
                if (complexPriceData.Low.Outbound.Local.Detail.DisplayCode != null && complexPriceData.Low.Outbound.Local.Detail.Comments != null)                      
                    LoMoMessages.put(complexPriceData.Low.Outbound.Local.Detail.DisplayCode, complexPriceData.Low.Outbound.Local.Detail.Comments);
                
                if (complexPriceData.Low.Outbound.Local.Detail.DisplayCode == 'X')
                    Html += '<td id=\'LoLocal\' class=\'priceMatrixValueInvalidEntry\'>' + complexPriceData.Low.Outbound.Local.Detail.DisplayCode + '</td>';
                else
                    Html += '<td id=\'LoLocal\' class=\'priceMatrixValueSpecial\'>' + complexPriceData.Low.Outbound.Local.Detail.DisplayCode + '</td>';                     
            }
            
            Html += '</tr>';
            Html += '</table>';
        }
        else
        {
            /*
                In a custom quote, the Quote_Subject__c field could be different from the direction argument passed
                to the GetRates method. In this case though, even if the quote subject is "ROUNDTRIP", the direction
                value could be Inbound, because Custom Quote flag is checked on the Outbound. In such a case, display
                this message.               
            */
            
            if (q.Quote_Subject__c.toUpperCase() != Direction && q.OB_Custom_Quote__c)          
                LoInboundHtmlNoRatesMessage = '<table style=\'border:none\'><tr><td style=\'padding-top: 20px; color: red\'>Outbound shipment is custom quote.</td></tr></table>';              
            
            /*
                This else portion below is not required. When Quote_Subject__c is Inbound, the code will always
                execute this parent else portion and result in message display, which is not required since the 
                quote is Inbound. NOTE: In normal quote (i.e. not custom quote), the direction argument is always 
                the same as the Quote_Subject__c field.
            */ 
                
            //else
            //  LoInboundHtmlNoRatesMessage = '<table style=\'border:none\'><tr><td style=\'padding-top: 20px;\'>To view rates for Outbound shipment, required field values must be provided.</td></tr></table>';
        }
                
        Html += LiInboundHtmlNoRatesMessage + LoInboundHtmlNoRatesMessage;
        
        map<string, string> LMoMessages = new map<string, string>();
                        
        for(string msg : LiMoMessages.keySet())
            LMoMessages.put(msg, LiMoMessages.get(msg));
            
        for(string msg : LoMoMessages.keySet())
            LMoMessages.put(msg, LoMoMessages.get(msg));                    
                        
        string LMsgTable = '';
                
        for(string msg : LMoMessages.keySet())
        {
            LMsgTable += '<tr style=\'padding-top: 20px;\'><td style=\'color: red; font-weight: bold; width: 20px; text-align: top;\'>' + msg + '</td><td style=\'color: red;\'>' + HMoMessages.get(msg) + '</td></tr>';
        }
        
        if (LMsgTable != '')
            LMsgTable = '<table style=\'border:none; margin-top: 10px;\'>' + LMsgTable + '</table>';
        
        Html += LMsgTable;
                
        Html += '</div>';
        
        
        //Build custom tab
        
        //First build the list of selectable shipment type and class of service options
        


        Html += '<div id=\'custom\'>';
        
        if (direction == 'ROUNDTRIP' || direction == 'INBOUND')
        {
            string LiAir2ndDayRates = complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.UnitPrice + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.FuelSurcharge + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.LiftGateFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.InsideFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.ResidentialFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.WeekendFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.WaitTimeFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.PalletizationFee + ','  + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.AttemptFee + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.SubTotal + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.Total + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.RoundTripDiscountPercent + ',' + complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.AdvReceivingEndDate; 
            string LiAirNextDayRates = complexPriceData.Low.Inbound.Air.AirNextDay.Detail.UnitPrice + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.FuelSurcharge + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.LiftGateFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.InsideFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.ResidentialFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.WeekendFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.WaitTimeFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.PalletizationFee + ','  + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.AttemptFee + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.SubTotal + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.Total + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.RoundtripDiscountPercent + ',' + complexPriceData.Low.Inbound.Air.AirNextDay.Detail.AdvReceivingEndDate;
            string LiGroundLTLRates = complexPriceData.Low.Inbound.Ground.Ltl.Detail.UnitPrice + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.FuelSurcharge + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.LiftGateFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.InsideFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.ResidentialFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.WeekendFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.WaitTimeFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.PalletizationFee + ','  + complexPriceData.Low.Inbound.Ground.Ltl.Detail.AttemptFee + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.SubTotal + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.Total + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.RoundtripDiscountPercent + ',' + complexPriceData.Low.Inbound.Ground.Ltl.Detail.AdvReceivingEndDate;
            string LiGroundFTLRates = complexPriceData.Low.Inbound.Ground.Ftl.Detail.UnitPrice + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.FuelSurcharge + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.LiftGateFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.InsideFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.ResidentialFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.WeekendFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.WaitTimeFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.PalletizationFee + ','  + complexPriceData.Low.Inbound.Ground.Ftl.Detail.AttemptFee + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.SubTotal + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.Total + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.RoundtripDiscountPercent + ',' + complexPriceData.Low.Inbound.Ground.Ftl.Detail.AdvReceivingEndDate;          
            string LiLocalRates = complexPriceData.Low.Inbound.Local.Detail.UnitPrice + ',' + complexPriceData.Low.Inbound.Local.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Inbound.Local.Detail.FuelSurcharge + ',' + complexPriceData.Low.Inbound.Local.Detail.LiftGateFee + ',' + complexPriceData.Low.Inbound.Local.Detail.InsideFee + ',' + complexPriceData.Low.Inbound.Local.Detail.ResidentialFee + ',' + complexPriceData.Low.Inbound.Local.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Inbound.Local.Detail.WeekendFee + ',' + complexPriceData.Low.Inbound.Local.Detail.WaitTimeFee + ',' + complexPriceData.Low.Inbound.Local.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Inbound.Local.Detail.PalletizationFee + ','  + complexPriceData.Low.Inbound.Local.Detail.AttemptFee + ',' + complexPriceData.Low.Inbound.Local.Detail.SubTotal + ',' + complexPriceData.Low.Inbound.Local.Detail.Total + ',' + complexPriceData.Low.Inbound.Local.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.Low.Inbound.Local.Detail.RoundTripDiscountPercent + ',' + complexPriceData.Low.Inbound.Local.Detail.AdvReceivingEndDate;
    
            string HiAir2ndDayRates = complexPriceData.High.Inbound.Air.Air2ndDay.Detail.UnitPrice + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.FuelUnitSurcharge + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.FuelSurcharge + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.LiftGateFee + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.InsideFee + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.ResidentialFee + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.AMSpecifiedFee + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.WeekendFee + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.WaitTimeFee + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.AdditionalLaborFee + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.PalletizationFee + ','  + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.AttemptFee + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.SubTotal + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.Total + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.RoundTripDiscountPercent + ',' + complexPriceData.High.Inbound.Air.Air2ndDay.Detail.AdvReceivingEndDate; 
            string HiAirNextDayRates = complexPriceData.High.Inbound.Air.AirNextDay.Detail.UnitPrice + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.FuelUnitSurcharge + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.FuelSurcharge + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.LiftGateFee + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.InsideFee + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.ResidentialFee + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.AMSpecifiedFee + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.WeekendFee + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.WaitTimeFee + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.AdditionalLaborFee + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.PalletizationFee + ','  + complexPriceData.High.Inbound.Air.AirNextDay.Detail.AttemptFee + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.SubTotal + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.Total + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.RoundtripDiscountPercent + ',' + complexPriceData.High.Inbound.Air.AirNextDay.Detail.AdvReceivingEndDate;
            string HiGroundLTLRates = complexPriceData.High.Inbound.Ground.Ltl.Detail.UnitPrice + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.FuelUnitSurcharge + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.FuelSurcharge + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.LiftGateFee + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.InsideFee + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.ResidentialFee + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.AMSpecifiedFee + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.WeekendFee + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.WaitTimeFee + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.AdditionalLaborFee + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.PalletizationFee + ','  + complexPriceData.High.Inbound.Ground.Ltl.Detail.AttemptFee + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.SubTotal + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.Total + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.RoundtripDiscountPercent + ',' + complexPriceData.High.Inbound.Ground.Ltl.Detail.AdvReceivingEndDate;
            string HiGroundFTLRates = complexPriceData.High.Inbound.Ground.Ftl.Detail.UnitPrice + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.FuelUnitSurcharge + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.FuelSurcharge + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.LiftGateFee + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.InsideFee + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.ResidentialFee + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.AMSpecifiedFee + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.WeekendFee + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.WaitTimeFee + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.AdditionalLaborFee + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.PalletizationFee + ','  + complexPriceData.High.Inbound.Ground.Ftl.Detail.AttemptFee + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.SubTotal + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.Total + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.RoundtripDiscountPercent + ',' + complexPriceData.High.Inbound.Ground.Ftl.Detail.AdvReceivingEndDate;         
            string HiLocalRates = complexPriceData.High.Inbound.Local.Detail.UnitPrice + ',' + complexPriceData.High.Inbound.Local.Detail.FuelUnitSurcharge + ',' + complexPriceData.High.Inbound.Local.Detail.FuelSurcharge + ',' + complexPriceData.High.Inbound.Local.Detail.LiftGateFee + ',' + complexPriceData.High.Inbound.Local.Detail.InsideFee + ',' + complexPriceData.High.Inbound.Local.Detail.ResidentialFee + ',' + complexPriceData.High.Inbound.Local.Detail.AMSpecifiedFee + ',' + complexPriceData.High.Inbound.Local.Detail.WeekendFee + ',' + complexPriceData.High.Inbound.Local.Detail.WaitTimeFee + ',' + complexPriceData.High.Inbound.Local.Detail.AdditionalLaborFee + ',' + complexPriceData.High.Inbound.Local.Detail.PalletizationFee + ','  + complexPriceData.High.Inbound.Local.Detail.AttemptFee + ',' + complexPriceData.High.Inbound.Local.Detail.SubTotal + ',' + complexPriceData.High.Inbound.Local.Detail.Total + ',' + complexPriceData.High.Inbound.Local.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.High.Inbound.Local.Detail.RoundTripDiscountPercent + ',' + complexPriceData.High.Inbound.Local.Detail.AdvReceivingEndDate;
                
            String InShipTypeOptions = '<select id="inShipTypeSel" onchange="inShipTypeSelChanged(this);">';
            String InClassOfServiceOptions = '<select id="inClassOfServiceSel" onchange="inClassOfServiceSelChanged(this);">';
            String InInitialLowOption = '';
            
            if (complexPriceData.Low.Inbound.Air.AirNextDay.Detail.DisplayCode == null || complexPriceData.Low.Inbound.Air.AirNextDay.Detail.DisplayCode == '')
            {
                InShipTypeOptions += '<option>Air Transportation</option>';
                InClassOfServiceOptions += '<option value="' + LiAirNextDayRates + '|' + HiAirNextDayRates + '">Next Day</option>';
                InInitialLowOption = 'A1';
            }
            
            if (complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.DisplayCode == null || complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.DisplayCode == '')
            {
                if (InShipTypeOptions.indexOf('<option>Air Transportation</option>') < 0)
                    InShipTypeOptions += '<option>Air Transportation</option>';
                    
                InClassOfServiceOptions += '<option value="' + LiAir2ndDayRates + '|' + HiAir2ndDayRates + '">2nd Day</option>';
                if (InInitialLowOption == '')
                    InInitialLowOption = 'A2';
            }   
            
            if (complexPriceData.Low.Inbound.Ground.Ltl.Detail.DisplayCode == null || complexPriceData.Low.Inbound.Ground.Ltl.Detail.DisplayCode == '')
            {
                InShipTypeOptions += '<option value="' + LiGroundLtlRates + '|' + HiGroundLtlRates + '">Ground Transportation</option>';
                if (InInitialLowOption == '')
                    InInitialLowOption = 'G';               
            }   
            
            if (complexPriceData.Low.Inbound.Local.Detail.DisplayCode == null || complexPriceData.Low.Inbound.Local.Detail.DisplayCode == '')
            {
                InShipTypeOptions += '<option value="' + LiLocalRates + '|' + HiLocalRates + '">Local</option>';
                if (InInitialLowOption == '')
                    InInitialLowOption = 'L';                   
            }   
            
            InShipTypeOptions += '</select>';
            
            if (InInitialLowOption != 'A1' && InInitialLowOption != 'A2')
                InClassOfServiceOptions = '<select id="inClassOfServiceSel" onchange="inClassOfServiceSelChanged(this);" disabled="true">';
            
            InClassOfServiceOptions += '</select>';
            
            Double InInitialLowUnitPrice = 0;
            Double InInitialHighUnitPrice = 0;
            
            if (InInitialLowOption == 'A1')
            {
                InInitialLowUnitPrice= complexPriceData.Low.Inbound.Air.AirNextDay.Detail.UnitPrice;
                InInitialHighUnitPrice= complexPriceData.High.Inbound.Air.AirNextDay.Detail.UnitPrice;
            }
            else if (InInitialLowOption == 'A2')
            {
                InInitialLowUnitPrice = complexPriceData.Low.Inbound.Air.Air2ndDay.Detail.UnitPrice;
                InInitialHighUnitPrice = complexPriceData.High.Inbound.Air.Air2ndDay.Detail.UnitPrice;
            }
            else if (InInitialLowOption == 'G')
            {
                InInitialLowUnitPrice = complexPriceData.Low.Inbound.Ground.Ltl.Detail.UnitPrice;
                InInitialHighUnitPrice = complexPriceData.High.Inbound.Ground.Ltl.Detail.UnitPrice;
            }
            else if (InInitialLowOption == 'L')
            {
                InInitialLowUnitPrice = complexPriceData.Low.Inbound.Local.Detail.UnitPrice;
                InInitialHighUnitPrice = complexPriceData.High.Inbound.Local.Detail.UnitPrice;
            }
            
            
            Html += '<fieldset>';
            Html += '<legend>Inbound</legend>';
            Html += '<table style="border:none">';
            Html += '<tr>';
            Html += '<td style="width:150px;text-align:right;font-weight:bold;">Shipment Type:</td>';
            Html += '<td style="width:200px;text-align:left">' + InShipTypeOptions + '</td>';
            Html += '<td style="text-align:right;font-weight:bold;">High:</td>';
            Html += '<td align="left"><input id="inHighValue" readonly="readonly" type="text" value="' + InInitialHighUnitPrice + '"></input></td>';
            Html += '</tr>';
            Html += '<tr>';
            Html += '<td style="width:150px;text-align:right;font-weight:bold;">Class of Service:</td>';
            Html += '<td style="width:200px;text-align:left">' + InClassOfServiceOptions + '</td>';
            Html += '<td style="text-align:right;font-weight:bold;">Low:</td>';
            Html += '<td align="left"><input id="inLowValue" readonly="readonly" type="text" value="' + InInitialLowUnitPrice + '"></input></td>';
            Html += '</tr>';
            Html += '<tr>';
            Html += '<td style="width:150px;text-align:right;font-weight:bold;">Service Type:</td>';
            Html += '<td style="width:200px;text-align:left">LTL</td>';
            Html += '<td style="text-align:right;font-weight:bold;">Price:</td>';
            Html += '<td align="left"><input id="inUnitPrice" type="text" onchange="inUnitPriceChanged(this);"/></td>';
            Html += '</tr>';
            Html += '</table>';
            Html += '</fieldset>';
        }
        
        if (direction == 'ROUNDTRIP' || direction == 'OUTBOUND')
        {
            string LoAir2ndDayRates = complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.UnitPrice + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.FuelSurcharge + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.LiftGateFee + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.InsideFee + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.ResidentialFee + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.WeekendFee + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.WaitTimeFee + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.PalletizationFee + ','  + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.AttemptFee + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.SubTotal + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.Total + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.RoundTripDiscountPercent + ',' + complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.AdvReceivingEndDate; 
            string LoAirNextDayRates = complexPriceData.Low.Outbound.Air.AirNextDay.Detail.UnitPrice + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.FuelSurcharge + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.LiftGateFee + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.InsideFee + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.ResidentialFee + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.WeekendFee + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.WaitTimeFee + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.PalletizationFee + ','  + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.AttemptFee + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.SubTotal + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.Total + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.RoundtripDiscountPercent + ',' + complexPriceData.Low.Outbound.Air.AirNextDay.Detail.AdvReceivingEndDate;
            string LoGroundLTLRates = complexPriceData.Low.Outbound.Ground.Ltl.Detail.UnitPrice + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.FuelSurcharge + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.LiftGateFee + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.InsideFee + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.ResidentialFee + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.WeekendFee + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.WaitTimeFee + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.PalletizationFee + ','  + complexPriceData.Low.Outbound.Ground.Ltl.Detail.AttemptFee + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.SubTotal + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.Total + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.RoundtripDiscountPercent + ',' + complexPriceData.Low.Outbound.Ground.Ltl.Detail.AdvReceivingEndDate;
            string LoGroundFTLRates = complexPriceData.Low.Outbound.Ground.Ftl.Detail.UnitPrice + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.FuelSurcharge + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.LiftGateFee + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.InsideFee + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.ResidentialFee + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.WeekendFee + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.WaitTimeFee + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.PalletizationFee + ','  + complexPriceData.Low.Outbound.Ground.Ftl.Detail.AttemptFee + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.SubTotal + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.Total + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.RoundtripDiscountPercent + ',' + complexPriceData.Low.Outbound.Ground.Ftl.Detail.AdvReceivingEndDate;         
            string LoLocalRates = complexPriceData.Low.Outbound.Local.Detail.UnitPrice + ',' + complexPriceData.Low.Outbound.Local.Detail.FuelUnitSurcharge + ',' + complexPriceData.Low.Outbound.Local.Detail.FuelSurcharge + ',' + complexPriceData.Low.Outbound.Local.Detail.LiftGateFee + ',' + complexPriceData.Low.Outbound.Local.Detail.InsideFee + ',' + complexPriceData.Low.Outbound.Local.Detail.ResidentialFee + ',' + complexPriceData.Low.Outbound.Local.Detail.AMSpecifiedFee + ',' + complexPriceData.Low.Outbound.Local.Detail.WeekendFee + ',' + complexPriceData.Low.Outbound.Local.Detail.WaitTimeFee + ',' + complexPriceData.Low.Outbound.Local.Detail.AdditionalLaborFee + ',' + complexPriceData.Low.Outbound.Local.Detail.PalletizationFee + ','  + complexPriceData.Low.Outbound.Local.Detail.AttemptFee + ',' + complexPriceData.Low.Outbound.Local.Detail.SubTotal + ',' + complexPriceData.Low.Outbound.Local.Detail.Total + ',' + complexPriceData.Low.Outbound.Local.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.Low.Outbound.Local.Detail.RoundTripDiscountPercent + ',' + complexPriceData.Low.Outbound.Local.Detail.AdvReceivingEndDate;
            
            string HoAir2ndDayRates = complexPriceData.High.Outbound.Air.Air2ndDay.Detail.UnitPrice + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.FuelUnitSurcharge + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.FuelSurcharge + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.LiftGateFee + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.InsideFee + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.ResidentialFee + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.AMSpecifiedFee + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.WeekendFee + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.WaitTimeFee + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.AdditionalLaborFee + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.PalletizationFee + ','  + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.AttemptFee + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.SubTotal + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.Total + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.RoundTripDiscountPercent + ',' + complexPriceData.High.Outbound.Air.Air2ndDay.Detail.AdvReceivingEndDate; 
            string HoAirNextDayRates = complexPriceData.High.Outbound.Air.AirNextDay.Detail.UnitPrice + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.FuelUnitSurcharge + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.FuelSurcharge + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.LiftGateFee + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.InsideFee + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.ResidentialFee + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.AMSpecifiedFee + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.WeekendFee + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.WaitTimeFee + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.AdditionalLaborFee + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.PalletizationFee + ','  + complexPriceData.High.Outbound.Air.AirNextDay.Detail.AttemptFee + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.SubTotal + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.Total + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.RoundtripDiscountPercent + ',' + complexPriceData.High.Outbound.Air.AirNextDay.Detail.AdvReceivingEndDate;
            string HoGroundLTLRates = complexPriceData.High.Outbound.Ground.Ltl.Detail.UnitPrice + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.FuelUnitSurcharge + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.FuelSurcharge + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.LiftGateFee + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.InsideFee + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.ResidentialFee + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.AMSpecifiedFee + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.WeekendFee + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.WaitTimeFee + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.AdditionalLaborFee + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.PalletizationFee + ','  + complexPriceData.High.Outbound.Ground.Ltl.Detail.AttemptFee + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.SubTotal + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.Total + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.RoundtripDiscountPercent + ',' + complexPriceData.High.Outbound.Ground.Ltl.Detail.AdvReceivingEndDate;
            string HoGroundFTLRates = complexPriceData.High.Outbound.Ground.Ftl.Detail.UnitPrice + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.FuelUnitSurcharge + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.FuelSurcharge + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.LiftGateFee + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.InsideFee + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.ResidentialFee + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.AMSpecifiedFee + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.WeekendFee + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.WaitTimeFee + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.AdditionalLaborFee + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.PalletizationFee + ','  + complexPriceData.High.Outbound.Ground.Ftl.Detail.AttemptFee + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.SubTotal + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.Total + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.RoundtripDiscountPercent + ',' + complexPriceData.High.Outbound.Ground.Ftl.Detail.AdvReceivingEndDate;            
            string HoLocalRates = complexPriceData.High.Outbound.Local.Detail.UnitPrice + ',' + complexPriceData.High.Outbound.Local.Detail.FuelUnitSurcharge + ',' + complexPriceData.High.Outbound.Local.Detail.FuelSurcharge + ',' + complexPriceData.High.Outbound.Local.Detail.LiftGateFee + ',' + complexPriceData.High.Outbound.Local.Detail.InsideFee + ',' + complexPriceData.High.Outbound.Local.Detail.ResidentialFee + ',' + complexPriceData.High.Outbound.Local.Detail.AMSpecifiedFee + ',' + complexPriceData.High.Outbound.Local.Detail.WeekendFee + ',' + complexPriceData.High.Outbound.Local.Detail.WaitTimeFee + ',' + complexPriceData.High.Outbound.Local.Detail.AdditionalLaborFee + ',' + complexPriceData.High.Outbound.Local.Detail.PalletizationFee + ','  + complexPriceData.High.Outbound.Local.Detail.AttemptFee + ',' + complexPriceData.High.Outbound.Local.Detail.SubTotal + ',' + complexPriceData.High.Outbound.Local.Detail.Total + ',' + complexPriceData.High.Outbound.Local.Detail.AdvOrderDiscountPercent + ',' + complexPriceData.High.Outbound.Local.Detail.RoundTripDiscountPercent + ',' + complexPriceData.High.Outbound.Local.Detail.AdvReceivingEndDate;
            
            String OutShipTypeOptions = '<select id="outShipTypeSel" onchange="outShipTypeSelChanged(this);">';
            String OutClassOfServiceOptions = '<select id="outClassOfServiceSel" onchange="outClassOfServiceSelChanged(this);">';
            String OutInitialLowOption = '';
            
            if (complexPriceData.Low.Outbound.Air.AirNextDay.Detail.DisplayCode == null || complexPriceData.Low.Outbound.Air.AirNextDay.Detail.DisplayCode == '')
            {
                OutShipTypeOptions += '<option>Air Transportation</option>';
                OutClassOfServiceOptions += '<option value="' + LoAirNextDayRates + '|' + HoAirNextDayRates + '">Next Day</option>';
                OutInitialLowOption = 'A1';
            }
            
            if (complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.DisplayCode == null || complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.DisplayCode == '')
            {
                if (OutShipTypeOptions.indexOf('<option>Air Transportation</option>') < 0)
                    OutShipTypeOptions += '<option>Air Transportation</option>';
                    
                OutClassOfServiceOptions += '<option value="' + LoAir2ndDayRates + '|' + HoAir2ndDayRates + '">2nd Day</option>';
                if (OutInitialLowOption == '')
                    OutInitialLowOption = 'A2';         
            }   
            
            if (complexPriceData.Low.Outbound.Ground.Ltl.Detail.DisplayCode == null || complexPriceData.Low.Outbound.Ground.Ltl.Detail.DisplayCode == '')
            {
                OutShipTypeOptions += '<option value="' + LoGroundLtlRates + '|' + HoGroundLtlRates + '">Ground Transportation</option>';
                if (OutInitialLowOption == '')
                    OutInitialLowOption = 'G';                  
            }   
            
            if (complexPriceData.Low.Outbound.Local.Detail.DisplayCode == null || complexPriceData.Low.Outbound.Local.Detail.DisplayCode == '')
            {
                OutShipTypeOptions += '<option value="' + LoLocalRates + '|' + HoLocalRates + '">Local</option>';
                if (OutInitialLowOption == '')
                    OutInitialLowOption = 'L';                  
            }   
            
            OutShipTypeOptions += '</select>';
            
            if (OutInitialLowOption != 'A1' && OutInitialLowOption != 'A2')
                OutClassOfServiceOptions = '<select id="outClassOfServiceSel" onchange="outClassOfServiceSelChanged(this);" disabled="true">';
            
            OutClassOfServiceOptions += '</select>';
            
            Double OutInitialLowUnitPrice = 0;
            Double OutInitialHighUnitPrice = 0;
            
            if (OutInitialLowOption == 'A1')
            {
                OutInitialLowUnitPrice= complexPriceData.Low.Outbound.Air.AirNextDay.Detail.UnitPrice;
                OutInitialHighUnitPrice= complexPriceData.High.Outbound.Air.AirNextDay.Detail.UnitPrice;
            }
            else if (OutInitialLowOption == 'A2')
            {
                OutInitialLowUnitPrice = complexPriceData.Low.Outbound.Air.Air2ndDay.Detail.UnitPrice;
                OutInitialHighUnitPrice = complexPriceData.High.Outbound.Air.Air2ndDay.Detail.UnitPrice;
            }
            else if (OutInitialLowOption == 'G')
            {
                OutInitialLowUnitPrice = complexPriceData.Low.Outbound.Ground.Ltl.Detail.UnitPrice;
                OutInitialHighUnitPrice = complexPriceData.High.Outbound.Ground.Ltl.Detail.UnitPrice;
            }
            else if (OutInitialLowOption == 'L')
            {
                OutInitialLowUnitPrice = complexPriceData.Low.Outbound.Local.Detail.UnitPrice;
                OutInitialHighUnitPrice = complexPriceData.High.Outbound.Local.Detail.UnitPrice;
            }
            
            Html += '<fieldset>';
            Html += '<legend>Outbound</legend>';
            Html += '<table style="border:none">';
            Html += '<tr>';
            Html += '<td style="width:150px;text-align:right;font-weight:bold;">Shipment Type:</td>';
            Html += '<td style="width:200px;text-align:left">' + OutShipTypeOptions + '</td>';
            Html += '<td style="text-align:right;font-weight:bold;">High:</td>';
            Html += '<td align="left"><input id="outHighValue" readonly="readonly" type="text" value="' + OutInitialHighUnitPrice + '"></input></td>';
            Html += '</tr>';
            Html += '<tr>';
            Html += '<td style="width:150px;text-align:right;font-weight:bold;">Class of Service:</td>';
            Html += '<td style="width:200px;text-align:left">' + OutClassOfServiceOptions + '</td>';
            Html += '<td style="text-align:right;font-weight:bold;">Low:</td>';
            Html += '<td align="left"><input id="outLowValue" readonly="readonly" type="text" value="' + OutInitialLowUnitPrice + '"></input></td>';
            Html += '</tr>';
            Html += '<tr>';
            Html += '<td style="width:150px;text-align:right;font-weight:bold;">Service Type:</td>';
            Html += '<td style="width:200px;text-align:left">LTL</td>';
            Html += '<td style="text-align:right;font-weight:bold;">Price:</td>';
            Html += '<td align="left"><input id="outUnitPrice" type="text" onchange="outUnitPriceChanged(this);"/></td>';
            Html += '</tr>';
            Html += '</table>';
            Html += '</fieldset>';
        }
            
        Html += '</div>';

        Html += '</div>';
        Html += '</div>';
        
        return Html;
    }
    
    WebService static string PriceCustomQuote(Id quoteId, string direction)
    {   
        Quote__c q = Database.query(LogisticsQuoteObjectMapper.QuoteSelectQuery + 'Where q.Id = \'' + quoteId + '\'');
        
        string RetVal = '';
        
        try
        {       
            direction = direction.toUpperCase();
            
            // Initialize Global variables, Price Request and Response Objects, Web Service Stub and other variables
            Initialize(quoteId, q, direction);
            
            if (q.Flat_Rate_Unit_Price_Type__c != null)
            {
                if ((direction == 'INBOUND' || direction == 'ROUNDTRIP') && q.Flat_Rate_Unit_Price_Type__c.toUpperCase() == 'PER POUND')
                {           
                    String InRetVal = SetInboundRates(quoteId, direction, q);
                    
                    if (InRetVal == null || InRetVal == '')
                    {
                        q.Message__c = null;
                        RetVal = 'Inbound per pound custom quote priced.';
                    }
                    else
                        RetVal = InRetVal;
                }
            }
            
            if (q.OB_Flat_Rate_Unit_Price_Type__c != null)
            {
                if ((direction == 'OUTBOUND' || direction == 'ROUNDTRIP') && q.OB_Flat_Rate_Unit_Price_Type__c.toUpperCase() == 'PER POUND')
                {
                    String OutRetVal = SetOutboundRates(quoteId, direction, q);
                    
                    if (OutRetVal == null || OutRetVal == '')
                    {
                        q.Message__c = null;
                        RetVal = (RetVal == null || RetVal == '' ? 'Outbound per pound custom quote priced.' : 'Inbound and Outbound per pound custom quote priced.');
                    }
                    else
                        RetVal += (RetVal == null || RetVal == '' ? OutRetVal : '\n\n' + OutRetVal);
                }
            }
            
            Database.update(q);         
            
        }
        finally
        {
            q = null;
            PriceResponseObjectIb = null;
            PriceRequestObjectOb = null;
            PriceResponseObjectOb = null;
            WS = null;              
        }       
        
        return RetVal;
    }
    
    private static string SetInboundRates(id quoteId, string direction, Quote__c q)
    {   
        string ReturnValue = null;
        
        if (direction == 'INBOUND' || direction == 'ROUNDTRIP')
        {
            String Mode = null;
            
            if (q.Shipment_Type__c != null && q.Shipment_Type__c != '')
            {
                if (q.Shipment_Type__c.toUpperCase() == 'AIR TRANSPORTATION')
                    Mode = 'AIR';
                else 
                    Mode = 'GROUND';
            }
            else
                ReturnValue = 'Inbound shipment is a per pound priced custom quote. To price this segment, please select "Shipment type", "Class of Service" and "Service Type", if applicable.';
            
            if (Mode != null)
            {
                PriceRequestObjectIb.CreatedWeight = LogisticsCommon.GetWeight(q, Mode);
                if(!Test.isRunningTest()){
                    PriceResponseObjectIb = InvokeQuoteRatesService(WS, PriceRequestObjectIb);
                }
                
                List<LogisticsQuoteGeneratorService.QuoteResponseObject> LoQr = PriceResponseObjectIb.QuoteResponseObject;
                LogisticsQuoteGeneratorService.QuoteResponseObject Qr = LoQr[0];
                
                q.Fuel_Unit_Surcharge__c = currencyFixed3Digits(Qr.FuelSurcharge);
                q.Fuel_Surcharge__c = currencyFixed(q.Fuel_Unit_Surcharge__c * PriceRequestObjectIb.CreatedWeight * q.Unit_Price__c);
                
                if (q.Inside_Pickup__c)
                    q.Inside_Surcharge__c = currencyFixed(Qr.InsidePickupFee);
                else
                    q.Inside_Surcharge__c = 0;
                
                if (q.Lift_Gate__c)
                    q.Lift_Gate_Surcharge__c = currencyFixed(Qr.LiftGateFee);
                else
                    q.Lift_Gate_Surcharge__c = 0;
                
                if (q.Residential_Pickup__c)
                    q.Residential_Surcharge__c = currencyFixed(Qr.ResidentialPickupFee);
                else
                    q.Residential_Surcharge__c = 0;
                
                if (q.AM_Specified__c)
                    q.AM_Specified_Fee__c = currencyFixed(Qr.AMSpecifiedFee);
                else
                    q.AM_Specified_Fee__c = 0;
                
                if (q.Weekend_Pickup__c || q.Weekend_Delivery__c)
                    q.Weekend_Fee__c = currencyFixed(Qr.WeekendFee);
                else
                    q.Weekend_Fee__c = 0;
                
                if (q.Wait_Time__c)
                    q.Wait_Time_Fee__c = currencyFixed(Qr.WaitTimeFee);
                else
                    q.Wait_Time_Fee__c = 0;
                
                if (q.Additional_Labor__c)
                    q.Additional_Labor_Fee__c = currencyFixed(Qr.AdditionalLaborFee);
                else
                    q.Additional_Labor_Fee__c = 0;
                
                if (q.Palletization__c)
                    q.Palletization_Fee__c = currencyFixed(Qr.PalletizationFee);
                else
                    q.Palletization_Fee__c = 0;
                
                if (q.Attempt__c)
                    q.Attempt_Fee__c = currencyFixed(Qr.AttemptFee);
                else
                    q.Attempt_Fee__c = 0;
                
                q.Sub_Total__c = currencyFixed(q.Unit_Price__c * PriceRequestObjectIb.CreatedWeight);
                //SFDC-280 - to add beyond point and ny city fields - 07/04/2024 - Sajid
                /*q.Total__c = q.Sub_Total__c + q.Fuel_Surcharge__c + q.Inside_Surcharge__c + q.Lift_Gate_Surcharge__c
                                + q.Residential_Surcharge__c + q.AM_Specified_Fee__c + q.Weekend_Fee__c 
                                + q.Wait_Time_Fee__c + q.Additional_Labor_Fee__c + q.Palletization_Fee__c
                                + q.Attempt_Fee__c;*/
                Double INBeyondPointAndNYFees = 0;
                if(q.Beyond_Point__c != null){
                    INBeyondPointAndNYFees = q.IN_Beyond_Point_Fee__c;
                }
                if(q.NY_City__c){
                    INBeyondPointAndNYFees += q.IN_New_York_City_Fee__c;
                }
                if(INBeyondPointAndNYFees != null && INBeyondPointAndNYFees != 0 && INBeyondPointAndNYFees != 0.00){
                    q.Total__c = q.Sub_Total__c + q.Fuel_Surcharge__c + q.Inside_Surcharge__c + q.Lift_Gate_Surcharge__c
                                + q.Residential_Surcharge__c + q.AM_Specified_Fee__c + q.Weekend_Fee__c 
                                + q.Wait_Time_Fee__c + q.Additional_Labor_Fee__c + q.Palletization_Fee__c
                                + q.Attempt_Fee__c + INBeyondPointAndNYFees;
                }else{
                    q.Total__c = q.Sub_Total__c + q.Fuel_Surcharge__c + q.Inside_Surcharge__c + q.Lift_Gate_Surcharge__c
                                + q.Residential_Surcharge__c + q.AM_Specified_Fee__c + q.Weekend_Fee__c 
                                + q.Wait_Time_Fee__c + q.Additional_Labor_Fee__c + q.Palletization_Fee__c
                                + q.Attempt_Fee__c;
                }
                //End - SFDC-280
            }
        }
            
        return ReturnValue;
    }
    
    private static string SetOutboundRates(id quoteId, string direction, Quote__c q)
    {   
        string ReturnValue = null;
        
        if (direction == 'OUTBOUND' || direction == 'ROUNDTRIP' )
        {
            String Mode = null;
            
            if (q.OB_Shipment_Type__c != null  && q.OB_Shipment_Type__c != '')
            {
                if (q.OB_Shipment_Type__c.toUpperCase() == 'AIR TRANSPORTATION')
                    Mode = 'AIR';
                else 
                    Mode = 'GROUND';
            }
            else
                ReturnValue = 'Outbound shipment is a per pound priced custom quote. To price this segment, please select "Shipment type", "Class of Service" and "Service Type", if applicable.';
            
            if (Mode != null)
            {
                PriceRequestObjectOb.CreatedWeight = LogisticsCommon.GetWeight(q, Mode);
                if(!Test.isRunningTest()){
                    PriceResponseObjectOb = InvokeQuoteRatesService(WS, PriceRequestObjectOb);
                }
                
                List<LogisticsQuoteGeneratorService.QuoteResponseObject> LoQr = PriceResponseObjectOb.QuoteResponseObject;
                LogisticsQuoteGeneratorService.QuoteResponseObject Qr = LoQr[0];
                
                q.OB_Fuel_Unit_Surcharge__c = currencyFixed3Digits(Qr.FuelSurcharge);
                q.OB_Fuel_Surcharge__c = currencyFixed(q.OB_Fuel_Unit_Surcharge__c * PriceRequestObjectOb.CreatedWeight * q.OB_Unit_Price__c);
                
                if (q.OB_Inside_Pickup__c)
                    q.OB_Inside_Surcharge__c = currencyFixed(Qr.InsidePickupFee);
                else
                    q.OB_Inside_Surcharge__c = 0;
                
                if (q.OB_Lift_Gate__c)
                    q.OB_Lift_Gate_Surcharge__c = currencyFixed(Qr.LiftGateFee);
                else
                    q.OB_Lift_Gate_Surcharge__c = 0;
                
                if (q.OB_Residential_Pickup__c)
                    q.OB_Residential_Surcharge__c = currencyFixed(Qr.ResidentialPickupFee);
                else
                    q.OB_Residential_Surcharge__c = 0;
                
                if (q.OB_AM_Specified__c)
                    q.OB_AM_Specified_Fee__c = currencyFixed(Qr.AMSpecifiedFee);
                else
                    q.OB_AM_Specified_Fee__c = 0;
                
                if (q.OB_Weekend_Pickup__c || q.OB_Weekend_Delivery__c)
                    q.OB_Weekend_Fee__c = currencyFixed(Qr.WeekendFee);
                else
                    q.OB_Weekend_Fee__c = 0;
                
                if (q.OB_Wait_Time__c)
                    q.OB_Wait_Time_Fee__c = currencyFixed(Qr.WaitTimeFee);
                else
                    q.OB_Wait_Time_Fee__c = 0;
                    
                if (q.OB_Additional_Labor__c)
                    q.OB_Additional_Labor_Fee__c = currencyFixed(Qr.AdditionalLaborFee);
                else
                    q.OB_Additional_Labor_Fee__c = 0;
                
                if (q.OB_Palletization__c)
                    q.OB_Palletization_Fee__c =  currencyFixed(Qr.PalletizationFee);
                else
                    q.OB_Palletization_Fee__c = 0;
                
                if (q.OB_Attempt__c)
                    q.OB_Attempt_Fee__c = currencyFixed(Qr.AttemptFee);
                else
                    q.OB_Attempt_Fee__c = 0;
                
                q.OB_Sub_Total__c = currencyFixed(q.OB_Unit_Price__c * PriceRequestObjectOb.CreatedWeight);
                //SFDC-280 - to add beyond point and ny city fields - 07/04/2024 - Sajid
                /*q.OB_Total__c = q.OB_Sub_Total__c + q.OB_Fuel_Surcharge__c + q.OB_Inside_Surcharge__c + q.OB_Lift_Gate_Surcharge__c
                                + q.OB_Residential_Surcharge__c + q.OB_AM_Specified_Fee__c + q.OB_Weekend_Fee__c 
                                + q.OB_Wait_Time_Fee__c + q.OB_Additional_Labor_Fee__c + q.OB_Palletization_Fee__c
                                + q.OB_Attempt_Fee__c;*/
                Double OBBeyondPointAndNYFees = 0;
                if(q.OB_Beyond_Point__c != null){
                    OBBeyondPointAndNYFees = q.OB_Beyond_Point_Fee__c;
                }
                if(q.OB_NY_City__c){
                    OBBeyondPointAndNYFees += + q.OB_New_York_City_Fee__c;
                }
                if(OBBeyondPointAndNYFees != null && OBBeyondPointAndNYFees != 0 && OBBeyondPointAndNYFees != 0.00){
                    q.OB_Total__c = q.OB_Sub_Total__c + q.OB_Fuel_Surcharge__c + q.OB_Inside_Surcharge__c + q.OB_Lift_Gate_Surcharge__c
                        + q.OB_Residential_Surcharge__c + q.OB_AM_Specified_Fee__c + q.OB_Weekend_Fee__c 
                        + q.OB_Wait_Time_Fee__c + q.OB_Additional_Labor_Fee__c + q.OB_Palletization_Fee__c
                        + q.OB_Attempt_Fee__c + OBBeyondPointAndNYFees;
                }else{
                    q.OB_Total__c = q.OB_Sub_Total__c + q.OB_Fuel_Surcharge__c + q.OB_Inside_Surcharge__c + q.OB_Lift_Gate_Surcharge__c
                                + q.OB_Residential_Surcharge__c + q.OB_AM_Specified_Fee__c + q.OB_Weekend_Fee__c 
                                + q.OB_Wait_Time_Fee__c + q.OB_Additional_Labor_Fee__c + q.OB_Palletization_Fee__c
                                + q.OB_Attempt_Fee__c;
                }
                //End - SFDC-280
            }
        }
            
        return ReturnValue;
    }
}