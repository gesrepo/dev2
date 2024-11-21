public class MelissaPersonatorRequest {

public MelissaPersonatorRequest()
{
   Records = new List<Records>();
}

    public String TransmissionReference;
    public String Actions;
    public String Columns;
    public String CustomerID;
    public String Options;
    public List<Records> Records;

    public class Records {
        public String AddressLine1;
        public String AddressLine2;
        public String AddressLine3;
        public String AddressLine4;
        public String City;
        public String CompanyName;
        public String Country;
        public String EmailAddress;
        public String FirstName;
        public String FreeForm;
        public String FullName;
        public String LastLine;
        public String LastName;
        public String PhoneNumber;
        public String PostalCode;
        public String RecordID;
        public String State;
        public String Locality;
        public String AdministrativeArea;
        
            public Records(){
            RecordID='';
            AddressLine1='';
            City='';
            State='';
            PostalCode='';
            Country='';
            Locality='';
            AdministrativeArea='';
        }    
    }

    
    public static MelissaPersonatorRequest parse(String json) {
        return (MelissaPersonatorRequest) System.JSON.deserialize(json, MelissaPersonatorRequest.class);
    }
}