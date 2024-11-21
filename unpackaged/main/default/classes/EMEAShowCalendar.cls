public with sharing class EMEAShowCalendar {

    public List<OpportunityWrapper> show {get;set;}
    public string searchQuery{get;set;}
    public string monthValue{get;set;} 

    public Map<String, String> periodsMap = new Map<String, String> {
        'THIS_MONTH' => 'This Month',
        'LAST_MONTH' => 'Last Month',
        'NEXT_MONTH' => 'Next Month',
        'THIS_QUARTER' => 'This Quarter',
        'NEXT_QUARTER' => 'Next Quarter',
        'LAST_QUARTER' => 'Last Quarter',
        'THIS_YEAR' => 'This Year',
        'LAST_YEAR' => 'Last Year',
        'NEXT_YEAR' => 'Next Year'
    };

    public EMEAShowCalendar(ApexPages.StandardSetController controller){
        monthValue = 'THIS_MONTH';
    }

    public void search(){
        string searchQuery=  'SELECT Event_Manager__c, Sop_Event_ID__c, Show_Name__c, Name, Id, Facility__c, AccountId, Show_Open_Date__c, Show_Close_Date__c, Sales_Person__c, GES_Move_In__c, GES_Move_Out_Date_1__c, (SELECT ProductCode__c, Product2.Name FROM OpportunityLineItems) FROM Opportunity';
        searchQuery += ' WHERE RecordType_Name__c = \'EMEA - Exhibition\'' ;
        searchQuery += ' AND Show_Open_Date__c = ' + monthValue;
        searchQuery += ' AND (StageName = \'CR\' OR StageName = \'CV\') ';
        searchQuery += ' ORDER BY Show_Open_Date__c Limit 1000';
        string.escapeSingleQuotes(searchQuery);
        List<Opportunity> showTemp = Database.query(searchQuery);
        
        system.debug('Search Results: ' + showTemp);
        
        show = new List<OpportunityWrapper>();
        for (Opportunity o : showTemp) {
            show.add(new OpportunityWrapper(o));
        }
    }

    public void clear() {
        show.clear();
    }

    public PageReference print() {
        return new PageReference('/apex/EMEA_Show_Calendar_Print?v=' + monthValue + '&l=' + periodsMap.get(monthValue));
    }

    public PageReference excel() {
        return new PageReference('/apex/EMEA_Show_Calendar_Excel?v=' + monthValue + '&l=' + periodsMap.get(monthValue));
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