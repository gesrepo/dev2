public class DunsRightMatchRequest{

public DunsRightMatchRequest ()
{
    Entities = new List<Entities>();
    MatchOptions = new MatchOptions();
}

    public List<Entities> entities;
    public MatchOptions matchOptions;

    public class MatchOptions {
        public String fields;       
        public MatchOptions(){
                fields='DunsNumber,Name';
                }
    }

    public class Attributes {
        public String type;
        public attributes(){
                type='';
                }  
    }

    public class Entities {
        public Attributes attributes;
        public String Name;
        public String Street;
        public String City;
        public String State;
        public String Zip;
        public String Country;
        
          public entities(){
            attributes = new attributes();
            Name='';
            Street='';
            City='';
            State='';
            Zip='';
            Country='';
          }  
    }

    
    public static DunsRightMatchRequest parse(String json) {
        return (DunsRightMatchRequest) System.JSON.deserialize(json, DunsRightMatchRequest.class);
    }
    
 
}