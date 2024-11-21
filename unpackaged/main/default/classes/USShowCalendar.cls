public with sharing class USShowCalendar {

  public List<OpportunityWrapper> show {get;set;}
  public string searchQuery{get;set;}
  public list<string> monthValue{get;set;} 
  public list<string> productionLocation {get;set;}
  public list<string> yearValue{get;set;}
  public string stageFilter{get;set;}
  public transient string venueFilter{get;set;}
  public transient string probabilityFilter{get;set;}

  

  public USShowCalendar(ApexPages.StandardSetController controller){
   // monthValue = 'THIS_MONTH';
   // productionLocation = 'All';
    stageFilter = 'All';
    venueFilter = 'All';
    probabilityFilter = 'All';
  }

  //public void search(){ Amarab 1/6/2016
  public void searchquery(){
   system.debug('monthValue=====================' +monthValue);
   system.debug('yearValue=====================' +yearValue);

    system.debug('productionLocation =====================' +productionLocation);
    searchQuery= 'SELECT RecordType_Name__c, Production_Location__c,StageName,Show_Name__r.name,Sales_Person__r.name, probability, amount, Show_Name__c, Name, Facility__r.name, Show_Open_Date__c, Show_Close_Date__c, Sales_Person__c FROM Opportunity';
   // searchQuery += ' WHERE Show_Open_Date__c = ' + monthValue;
    searchQuery += ' WHERE  (RecordType_Name__c LIKE \'Field%\' OR RecordType_Name__c LIKE \'Sales Rep Show Occurrence%\' OR RecordType_Name__c = \'Master Show Occurrence\')';
    system.debug('productionLocation =====================' +productionLocation.size());
    
    // check if a filter on production location has been applied
    String checkprlocation ;
    string searchQuery1 =' ' ;
    string searchQuerymonth =' ' ;
    string searchQueryyear =' ' ;


    for (string  s : productionLocation)
    { 
     if(s == 'All'){  
      checkprlocation = 'true';   
      }      
     else{
     searchQuery1 +=' production_Location__c =' + '\'' +  s + '\' ' + 'or'  ;
    }
 }   
 
   if(productionLocation.size() > 0) {
    if (checkprlocation != 'true' )
       {
        searchQuery1 = searchQuery1.substring(0, searchQuery1.length() - 2);
        searchQuery +=' AND (' + searchQuery1 +')'; 
        }
   }    
        system.debug('SearchQuery for pr location===='+ searchQuery);
        
      for (string  s : monthValue)
    { 
     
     searchQuerymonth  +=' CALENDAR_MONTH(Show_Open_Date__c) =' +  +  s +  + 'or'  ;
     
          //searchQuerymonth  +=' CALENDAR_MONTH(Show_Open_Date__c) =' + '\'' +  s + '\' ' + 'or'  ;

    
 }   
 
   if(monthValue.size() > 0) {
   
        searchQuerymonth  = searchQuerymonth.substring(0, searchQuerymonth.length() - 2);
        searchQuery +=' AND (' + searchQuerymonth +')'; 
        
   }    
        system.debug('SearchQuery for month===='+ searchQuery);
  
        for (string  s : yearValue)
    { 
     
     searchQueryyear +=' CALENDAR_YEAR(Show_Open_Date__c) =' +  +  s +  + 'or'  ;
    
 }   
  system.debug('SearchQuery for month===='+ searchQuery);
  if(yearValue.size() > 0) {
   
        searchQueryyear = searchQueryyear.substring(0, searchQueryyear.length() - 2);
        searchQuery +=' AND (' + searchQueryyear +')'; 
        
   }    
        system.debug('SearchQuery for month===='+ searchQuery);
    
        

    // check if a filter has been set on stage
    
    
     if (stageFilter =='CR/CV')
        searchQuery += ' AND (stagename = \'CR\' or stagename = \'CV\')';

    if (stageFilter =='PO/PS')
        searchQuery += ' AND (stagename = \'PO\' or stagename = \'PS\')';
    if (stageFilter =='SL1/SL3')
        searchQuery += ' AND (stagename = \'SL1\' or stagename = \'SL3\')';
    if (stageFilter =='Open (PO/PS/SL1/SL3)')
        searchQuery += ' AND (stagename = \'PO\' or stagename = \'PS\' or stagename = \'SL1\' or stagename = \'SL3\')';
    if (stageFilter =='TS')
        searchQuery += ' AND (stagename = \'TS\' or stagename = \'TS\')';
    if (stageFilter =='LO/LR/LPE/LPM')
        searchQuery += ' AND (stagename = \'LO\' or stagename = \'LR\' or stagename = \'LPE\' or stagename = \'LPM\')';
    if (stageFilter =='CC/DB/IA/SC/NE/SM')
        searchQuery += ' AND (stagename = \'CC\' or stagename = \'DB\' or stagename = \'IA\' or stagename = \'SC\' or stagename = \'NE\'or stagename = \'SM\')';
        
        
        
    // check if a filter has been set on venue
    if (venueFilter != 'All')
        searchQuery += ' AND (facility__r.name = \'' + venueFilter + '\')';
        
    // check if a filter has been set on probability
    if (probabilityFilter != 'All')
        searchQuery += ' AND (probability = ' + probabilityFilter + ')';
   
    searchQuery += ' ORDER BY Show_Close_Date__c Limit 1500';
    string.escapeSingleQuotes(searchQuery);
    System.debug(searchQuery);
   }
   
  public void search(){
    searchquery();
    List<Opportunity> showTemp = Database.query(searchQuery);
    show = new List<OpportunityWrapper>();
    for (Opportunity o : showTemp) {
      show.add(new OpportunityWrapper(o));
     }
  }

  public void clear() {
    show.clear();
  }

  
  public pageReference exportxlsmeth(){ 
     searchquery();
     String temp = EncodingUtil.urlEncode(searchQuery, 'UTF-8');
     System.debug('temp --------------------------' + temp );
       return new PageReference('/apex/US_Show_Calendar_Excel?searchQueryforExcel=' + temp );     
     }  
  
  public class OpportunityWrapper {
    
    public Opportunity opp { get; set; }
    
    public string products {
      get {
        string prods = '';
        for (OpportunityLineItem oli : opp.OpportunityLineItems) {
          if (prods != '')
            prods += ', ';
          prods += oli.Product2.Name;
        }
        return prods;
      }
    }
    
    public OpportunityWrapper(Opportunity o) {
      opp = o;
    }
    
  }
}