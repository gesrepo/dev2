public class MelissaJasonRequestForGlobal {

    public MelissaJasonRequestForGlobal()
    {
       Records = new List<Records>();
    }

    public String CustomerID;
    public String Options;
    public String TransmissionReference;
    
    public List<Records> Records;

    public class Records {
    
        public String RecordID;
        public String Organization;
        public String AddressLine1;
        public String AddressLine2;
        public String AddressLine3;
        public String AddressLine4;
        public String AddressLine5;
        public String AddressLine6;
        public String AddressLine7;
        public String AddressLine8;
        public String DoubleDependentLocality;
        public String DependentLocality;
        public String Locality;
        public String SubAdministrativeArea;
        public String AdministrativeArea;
        public String PostalCode;
        public String SubNationalArea;
        public String Country;
       
        
            public Records(){
            RecordID='';
            Organization='';
            AddressLine1='';
            AddressLine2='';
            AddressLine3='';
            AddressLine4='';
            AddressLine5='';
            AddressLine6='';
            AddressLine7='';
            AddressLine8='';
            DoubleDependentLocality='';
            DependentLocality='';
            Locality='';
            SubAdministrativeArea='';
            AdministrativeArea='';
            PostalCode='';
            SubNationalArea='';
            Country='';
           
           
        }    
    }

    
    public static MelissaJasonRequestForGlobal parse(String json) {
        return (MelissaJasonRequestForGlobal) System.JSON.deserialize(json, MelissaJasonRequestForGlobal.class);
    }
}