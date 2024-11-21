global class LogisticsQuoteComplexPriceData {
    
    public HighPricing High {get; set;}
    public LowPricing Low {get; set; }
    
    public LogisticsQuoteComplexPriceData ()
    {
        High = new HighPricing();
        Low = new LowPricing();
    }
    
    public class HighPricing
    {
        public InboundPricing Inbound;
        public OutboundPricing Outbound;
        
        public HighPricing()
        {
            Inbound = new InboundPricing();
            Outbound = new OutboundPricing();
        }
    }
    
    public class LowPricing
    {
        public InboundPricing Inbound;
        public OutboundPricing Outbound;
        
        public LowPricing()
        {
            Inbound = new InboundPricing();
            Outbound = new OutboundPricing();
        }
    }
    
    public class InboundPricing
    {
        public GroundPricing Ground;
        public AirPricing Air;
        public LocalPricing Local;
        
        public InboundPricing()
        {
            Ground = new GroundPricing();
            Air = new AirPricing();
            Local = new LocalPricing();
        }
    }
    
    public class OutboundPricing
    {
        public GroundPricing Ground;
        public AirPricing Air;
        public LocalPricing Local;
        
        public OutboundPricing()
        {
            Ground = new GroundPricing();
            Air = new AirPricing();
            Local = new LocalPricing();
        }
    }
    
    public class GroundPricing
    {
        public LTLPricing Ltl;
        public FTLPricing Ftl;
        
        public GroundPricing()
        {
            Ltl = new LTLPricing();
            Ftl = new FTLPricing();
        }
    }
    
    public class LTLPricing
    {
        public PricingDetail Detail;
        
        public LTLPricing()
        {
            Detail = new PricingDetail();           
        }
    }
    
    public class FTLPricing
    {
        public PricingDetail Detail;
        
        public FTLPricing()
        {
            Detail = new PricingDetail();           
        }
    }   
    
    public class AirPricing
    {
        public Air2ndDayPricing Air2ndDay;
        public AirNextDayPricing AirNextDay;
        
        public AirPricing()
        {
            Air2ndDay = new Air2ndDayPricing();
            AirNextDay = new AirNextDayPricing();
        }       
    }
    
    public class Air2ndDayPricing
    {
        public PricingDetail Detail;
                
        public Air2ndDayPricing()
        {
            Detail = new PricingDetail();           
        }       
    }
    
    public class AirNextDayPricing
    {
        public PricingDetail Detail;
                
        public AirNextDayPricing()
        {
            Detail = new PricingDetail();           
        }       
    }
    
    public class LocalPricing
    {
        public PricingDetail Detail;
        
        public LocalPricing()
        {
            Detail = new PricingDetail();
        }   
    }
    
    public class PricingDetail
    {
    	public decimal UnitPrice {get; set; }
    	public decimal FuelUnitSurcharge {get; set;}
        public decimal FuelSurcharge {get; set;}
        public decimal InsideFee {get; set;}
        public decimal LiftGateFee {get; set;}
        public decimal ResidentialFee {get; set;}
        public decimal AMSpecifiedFee {get; set; }
        public decimal WeekendFee {get; set; }
        public decimal WaitTimeFee {get; set; }
        public decimal AdditionalLaborFee {get; set; }
        public decimal PalletizationFee {get; set; }
        public decimal AttemptFee {get; set; }
        public decimal SubTotal {get; set;}
        public decimal Total {get; set;}
        public decimal AdvOrderDiscountPercent {get; set;}
        public decimal RoundTripDiscountPercent {get; set;}
        public decimal TotalDiscountPercent {get; set; }
        public datetime AdvReceivingEndDate {get; set; }
        public string DisplayCode {get; set; }
        public string Comments {get; set; }  
    }
    
}