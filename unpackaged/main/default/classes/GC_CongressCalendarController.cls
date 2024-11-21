global with sharing class GC_CongressCalendarController{
    public List<GC_BrandWrapper> filteredBrandWrapperList{get; set;}
    public string inputCountry{get; set;}
    public string inputBrand{get; set;}
    public List<SelectOption> brands{get; set;}
    public List<SelectOption> countries{get; set;}
    public Date inputStartDate{get; set;}
    public Date congressDate {get; set;}
    public Date congressToDate{get;set;} 
    public String query{get; set;}
    public String orderByClause{get; set;}
    public String sortOrder {get; set;}
    public String nullsOrder {get; set;}
    public String CongressName {get; set;}
    public String acronymName {get; set;}
    public string initialOrderByClause;
    Boolean falseValue = false;
    
    public GC_CongressCalendarController(){
        
        query = 'SELECT id, name,Brand_Name__c, GES_Connect_Corporate_Accounts__r.id, GES_Connect_Corporate_Accounts__r.name, GES_Connect_Corporate_Accounts__r.Name_of_Congress__c, GES_Connect_Corporate_Accounts__r.Acronym_of_Congress__c, GES_Connect_Corporate_Accounts__r.Congress_Start_Date__c, GES_Connect_Corporate_Accounts__r.Congress_End_Date__c, GES_Connect_Corporate_Accounts__r.Shipping_City__c , GES_Connect_Corporate_Accounts__r.Shipping_State_Province__c, GES_Connect_Corporate_Accounts__r.Shipping_Country__c, Exhibit_Instance__r.id, Exhibit_Instance__r.GES_Congress_Manager__c, Exhibit_Instance__r.Congress_Lead__c,Exhibit_Instance__r.Canceled__c, Meeting_Room__r.id, Meeting_Room__r.name, Meeting_Room__r.GES_Congress_Manager__c, Meeting_Room__r.Congress_Lead__c,Meeting_Room__r.Canceled__c,  Product_Theater__r.id, Product_Theater__r.name,Product_Theater__r.GES_Congress_Manager__c, Product_Theater__r.Congress_Lead__c, Product_Theater__r.Canceled__c, Sponsorship__r.id, Sponsorship__r.name,Sponsorship__r.GES_Congress_Manager__c, Sponsorship__r.Congress_Lead__c, Sponsorship__r.Canceled__c, Symposia__r.id, Symposia__r.name,Symposia__r.GES_Congress_Manager__c, Symposia__r.Congress_Lead__c, Symposia__r.Canceled__c FROM Brand__c WHERE Canceled__c  = FALSE AND GES_Connect_Corporate_Accounts__r.Congress_Start_Date__c > TODAY ';
        initialOrderByClause ='ORDER BY GES_Connect_Corporate_Accounts__r.Congress_Start_Date__c ';
        //query += ' where Canceled__c = false';
        filteredBrandWrapperList = new List<GC_BrandWrapper>();
        CongressName='';
        acronymName='';
        sortOrder=' ASC ';
        nullsOrder=' NULLS LAST ';
        searchCongressWithFilter();     
    }
    
    public String getDateString(Date date1) {
        if (date1 == null) {
            return '';
        }
        DateTime dt = DateTime.newInstance(date1.year(), date1.month(), date1.day());
        return dt.format('yyyy-MM-dd');
    }
    
     public void setDate() {
        try {
            congressDate = Date.parse(Apexpages.currentPage().getParameters().get('CongressStart'));
        }
        catch (Exception e) {
            System.debug(e.getMessage());
        }
    }
    
    public PageReference searchCongress(String queryString){
        try{
            List<Brand__c>  filteredBrandList= Database.query(queryString);
            system.debug('filteredBrandList=='+ filteredBrandList.size());
            system.debug('queryString=='+ queryString);
            brands = new List<SelectOption>();
            countries = new List<SelectOption>();
            filteredBrandWrapperList.clear();
            set<string> brandNames= new set<string>();
            set<string> countryNames= new set<string>();
            brandNames.add('--None--');
            countryNames.add('--None--');
            for(Brand__c singleBrand: filteredBrandList){
                if(!(singleBrand.Exhibit_Instance__r.Canceled__c || singleBrand.Meeting_Room__r.Canceled__c || singleBrand.Product_Theater__r.Canceled__c || singleBrand.Sponsorship__r.Canceled__c || singleBrand.Symposia__r.Canceled__c )){
                    GC_BrandWrapper singleBranWrapper= new GC_BrandWrapper(singleBrand);
                    brandNames.add(singleBrand.Brand_Name__c);
                    if(string.isNotBlank(singleBrand.GES_Connect_Corporate_Accounts__r.Shipping_Country__c)){
                        countryNames.add(singleBrand.GES_Connect_Corporate_Accounts__r.Shipping_Country__c);
                    } 
                    filteredBrandWrapperList.add(singleBranWrapper);
                }
                
            }
            for(string brand: brandNames){
                SelectOption brandSo= new SelectOption(brand,brand);
                brands.add(brandSo);
            }
            for(string country: countryNames){
                SelectOption countrySo= new SelectOption(country,country);
                countries.add(countrySo);
            }
            system.debug('filteredBrandWrapperList=='+ filteredBrandWrapperList.size());
            
        }catch(exception e){
            
            system.debug('error at=='+ e.getStackTraceString());            
        }
        return null;
    }
   
    public class GC_BrandWrapper {
        public string CongressName {get; set;}
        public string Acronym {get; set;}
        public string CongressStart {get; set;}
        public string CongressEnd {get; set;}
        public string Location {get; set;}
        public string Country {get; set;}
        public string ActivityType {get; set;}
        public string Brand {get; set;}
        public string CongressManager {get; set;}
        public string CongressLead {get; set;}
        
        public GC_BrandWrapper(){}
           public GC_BrandWrapper(Brand__c singleBrand){
            this.ActivityType= '';
            this.CongressManager='';
            this.CongressLead='';
            this.CongressStart='';
            this.CongressEnd='';
            this.CongressName=string.isNotBlank(singleBrand.GES_Connect_Corporate_Accounts__r.Name_of_Congress__c) ? singleBrand.GES_Connect_Corporate_Accounts__r.Name_of_Congress__c : '';
            this.Acronym=string.isNotBlank(singleBrand.GES_Connect_Corporate_Accounts__r.Acronym_of_Congress__c) ? singleBrand.GES_Connect_Corporate_Accounts__r.Acronym_of_Congress__c : '';
            //this.CongressStart= (singleBrand.GES_Connect_Corporate_Accounts__r.Congress_Start_Date__c!=null) ? string.valueOf(singleBrand.GES_Connect_Corporate_Accounts__r.Congress_Start_Date__c) : '';
            if(singleBrand.GES_Connect_Corporate_Accounts__r.Congress_Start_Date__c!=null){
                List<String> parts = string.valueOf(singleBrand.GES_Connect_Corporate_Accounts__r.Congress_Start_Date__c).split('-');
                this.CongressStart= parts[1].removeStart('0')+'/'+parts[2].removeStart('0') +'/'+parts[0];
            }
            if(singleBrand.GES_Connect_Corporate_Accounts__r.Congress_End_Date__c!=null){
                List<String> parts = string.valueOf(singleBrand.GES_Connect_Corporate_Accounts__r.Congress_End_Date__c).split('-');
                this.CongressEnd= parts[1].removeStart('0')+'/'+parts[2].removeStart('0') +'/'+parts[0];
            }
            this.Location=string.isNotBlank(singleBrand.GES_Connect_Corporate_Accounts__r.Shipping_City__c) ? singleBrand.GES_Connect_Corporate_Accounts__r.Shipping_City__c : '';
            this.Location+=string.isNotBlank(singleBrand.GES_Connect_Corporate_Accounts__r.Shipping_State_Province__c) ? (','+singleBrand.GES_Connect_Corporate_Accounts__r.Shipping_State_Province__c) : '';
            this.Country=string.isNotBlank(singleBrand.GES_Connect_Corporate_Accounts__r.Shipping_Country__c) ? singleBrand.GES_Connect_Corporate_Accounts__r.Shipping_Country__c : '';
            if(string.isNotBlank(singleBrand.Exhibit_Instance__r.id)){
                this.ActivityType= 'Exhibit';
                this.CongressManager=singleBrand.Exhibit_Instance__r.GES_Congress_Manager__c;
                this.CongressLead=singleBrand.Exhibit_Instance__r.Congress_Lead__c;
            }
            if(string.isNotBlank(singleBrand.Meeting_Room__r.id)){
                this.ActivityType= 'Meeting Room';
                this.CongressManager=singleBrand.Meeting_Room__r.GES_Congress_Manager__c;
                this.CongressLead=singleBrand.Meeting_Room__r.Congress_Lead__c;
            }
            if(string.isNotBlank(singleBrand.Product_Theater__r.id)){
                this.ActivityType= 'Product Theater';
                this.CongressManager=singleBrand.Product_Theater__r.GES_Congress_Manager__c;
                this.CongressLead=singleBrand.Product_Theater__r.Congress_Lead__c;
            }
            if(string.isNotBlank(singleBrand.Sponsorship__r.id)){
                this.ActivityType= 'Sponsorship';
                this.CongressManager=singleBrand.Sponsorship__r.GES_Congress_Manager__c;
                this.CongressLead=singleBrand.Sponsorship__r.Congress_Lead__c;
            }
            if(string.isNotBlank(singleBrand.Symposia__r.id)){
                this.ActivityType= 'Symposia';
                this.CongressManager=singleBrand.Symposia__r.GES_Congress_Manager__c;
                this.CongressLead=singleBrand.Symposia__r.Congress_Lead__c;
            }
            this.Brand= singleBrand.Brand_Name__c;          
        }
       
    }
    
    public PageReference searchCongressWithFilter(){
        String brandQuery= (string.isNotBlank(inputBrand) && inputBrand !='--None--') ? ' AND Brand_Name__c= \'' + inputBrand + '\'' : '';
        String countryQuery= (string.isNotBlank(inputCountry) && inputCountry !='--None--') ?' AND GES_Connect_Corporate_Accounts__r.Shipping_Country__c= \'' + inputCountry + '\'' : '';
        string congressNameQuery= String.isNotBlank(CongressName) ? ' AND GES_Connect_Corporate_Accounts__r.Name_of_Congress__c like \'%' + congressName + '%\'' : '';
        string congressAcronymQuery= String.isNotBlank(acronymName) ? ' AND GES_Connect_Corporate_Accounts__r.Acronym_of_Congress__c like \'%' + acronymName+ '%\'' : '';
        
        if(string.isNotBlank(orderByClause) && orderByClause!=initialOrderByClause){
            orderByClause= ' ORDER BY '+ orderByClause ;
        }else{
            orderByClause= initialOrderByClause;
        }
        if (congressDate != null) {
            orderByClause += ' AND singleBrand.GES_Connect_Corporate_Accounts__r.Congress_Start_Date__c=' + getDateString(congressDate);
        }
        String finalQuery = query+' '+brandQuery+' '+countryQuery+' '+congressNameQuery+' '+congressAcronymQuery+' '+orderByClause+' '+sortOrder+' '+nullsOrder;
        system.debug('finalQuery=='+ finalQuery);
        return searchCongress(finalQuery);
    }    
    public PageReference sortColumn() {
        String previousColumn = orderByClause;
        if (Apexpages.currentPage().getParameters().containsKey('orderByCol')) {
            orderByClause = Apexpages.currentPage().getParameters().get('orderByCol');
        }

        if (previousColumn != orderByClause) {
            sortOrder = 'asc';
            nullsOrder = 'nulls last';
        }
        else if (sortOrder.contains('asc')) {
            sortOrder = sortOrder.replace('asc', 'desc');

            if (nullsOrder.contains('nulls first')) {
                nullsOrder = nullsOrder.replace('nulls first', 'nulls last');
            }
            else if (nullsOrder.contains('nulls last')) {
                nullsOrder = nullsOrder.replace('nulls last', 'nulls first');
            }
        }
        else if (sortOrder.contains('desc')) {
            sortOrder = sortOrder.replace('desc', 'asc');

            if (nullsOrder.contains('nulls first')) {
                nullsOrder = nullsOrder.replace('nulls first', 'nulls last');
            }
            else if (nullsOrder.contains('nulls last')) {
                nullsOrder = nullsOrder.replace('nulls last', 'nulls first');
            }
        }

        return searchCongressWithFilter();
    }
     public PageReference save() 
   {
        return page.GC_CongressCalender_Export;        
   } 
   
    public PageReference resetSearch() {
        inputBrand = null;
        inputCountry = null;
        CongressName = null;
        acronymName =null;
        return searchCongressWithFilter();
    }  
    
}