public class MelissaJasonResponse {

    public String Version;
    public String TransmissionReference;
    public String TransmissionResults;
    public String TotalRecords;
    public List<Records> Records;

    public class Records {
        public String RecordID;
        public String Results;
        public String FormattedAddress;
        public String Organization;
        public String AddressLine1;
        public String AddressLine2;
        public String AddressLine3;
        public String AddressLine4;
        public String AddressLine5;
        public String AddressLine6;
        public String AddressLine7;
        public String AddressLine8;
        public String SubPremises;
        public String DoubleDependentLocality;
        public String DependentLocality;
        public String Locality;
        public String SubAdministrativeArea;
        public String AdministrativeArea;
        public String PostalCode;
        public String AddressType;
        public String AddressKey;
        public String SubNationalArea;
        public String CountryName;
        public String CountryISO3166_1_Alpha2;
        public String CountryISO3166_1_Alpha3;
        public String CountryISO3166_1_Numeric;
        public String CountrySubdivisionCode;
        public String CountryCode;
        public String Thoroughfare;
        public String ThoroughfarePreDirection;
        public String ThoroughfareLeadingType;
        public String ThoroughfareName;
        public String ThoroughfareTrailingType;
        public String ThoroughfarePostDirection;
        public String DependentThoroughfare;
        public String DependentThoroughfarePreDirection;
        public String DependentThoroughfareLeadingType;
        public String DependentThoroughfareName;
        public String DependentThoroughfareTrailingType;
        public String DependentThoroughfarePostDirection;
        public String Building;
        public String PremisesType;
        public String PremisesNumber;
        public String SubPremisesType;
        public String SubPremisesNumber;
        public String PostBox;
        public String Latitude;
        public String Longitude;
        public String City;
        public String State;
    }

    
    public static MelissaJasonResponse parse(String json) {
        return (MelissaJasonResponse) System.JSON.deserialize(json, MelissaJasonResponse.class);
    }
}