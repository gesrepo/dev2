public class MelissaJasonRequestForPersonator {

public MelissaJasonRequestForPersonator()
{
   Records = new List<Records>();
}

    public String CustomerID;
    public String Options;
    public String Columns;
    public String TransmissionReference;
    public String Actions;
    public List<Records> Records;

    public class Records {
    
        public String RecordID;
        public String AddressLine1;
        public String AddressLine2;
        public String AddressLine3;
        public String AddressLine4;
        public String PostalCode;
        public String Country;
        public String City;
        public String State;
        
            public Records(){
            RecordID='';
            AddressLine1='';
            AddressLine2='';
            AddressLine3='';
            AddressLine4='';
            City='';
            State='';
            PostalCode='';
            Country='';
        }    
    }

    
    public static MelissaJasonRequestForPersonator parse(String json) {
        return (MelissaJasonRequestForPersonator) System.JSON.deserialize(json, MelissaJasonRequestForPersonator.class);
    }
}