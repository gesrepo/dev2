public with sharing class USShowCalendarexcelomethod{

    public USShowCalendarexcelomethod(ApexPages.StandardController controller) {
        searchQuery = ApexPages.currentPage().getParaMeters().get('searchQueryforExcel');
  
  system.debug('-----------searchQuery -----------'+searchQuery);
    
    }


  public List<OpportunityWrapper> show {get;set;}
  public string searchQuery{get;set;}

  public void mainmethod(){
  
    string.escapeSingleQuotes(searchQuery);
    
      String s1 = searchQuery;
      String target = '+';
      String replacement = ' ';
      String s2 = s1.replace(target, replacement);
      System.debug('Birla>>>>'+s2);
      
   List<Opportunity> showTemp = Database.query(s2);
    show = new List<OpportunityWrapper>();
    
    for (Opportunity o : showTemp) {
      show.add(new OpportunityWrapper(o));
    } 
  }

  
  public class OpportunityWrapper {
    
    public Opportunity opp { get; set; }
  
    public OpportunityWrapper(Opportunity o) {
      opp = o;
    }
    
  }
}