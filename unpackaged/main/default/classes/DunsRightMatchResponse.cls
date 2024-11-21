public class DunsRightMatchResponse{

    public class AdditionalInformation {
        public String name;
        public String value;
    }

    public class Errors {
        public String statusCode;
        public String message;
    }

    public class MatchRecords {
        public List<AdditionalInformation> additionalInformation;
        public List<FieldDiffs> fieldDiffs;
        public Double matchConfidence;
        public Record record;
    }

    public List<Errors> errors;
    public String matchEngine;
    public List<MatchRecords> matchRecords;
    public String rule;
    public Integer size;
    public Boolean success;

    public class FieldDiffs {
        public String difference;
        public String name;
    }

    public class Attributes {
        public String type;
    }

    public class Record {
        public Attributes attributes;
        public String DunsNumber;
        public String Name;
    } 

   public static List<DunsRightMatchResponse> parseJsonArray(String json) {
         return (List<DunsRightMatchResponse>) System.JSON.deserialize(json, List<DunsRightMatchResponse>.class);
    }
    
    
}