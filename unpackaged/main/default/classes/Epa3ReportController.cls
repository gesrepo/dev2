/*
Created by Adarsh G
Created on: 3/11/19
Last Modified on:3/15/19

*/
global class Epa3ReportController {
    public String congressId {get; set;}
    public Date congressDate {get; set;}
    public Date congressToDate {get; set;}
    //  public Date congressDate {get; set;}
    public String acronymName {get; set;}
    //public String username{get;set;}
    public String congressQuery {get; set;}
    public String orderByQuery {get; set;}
    public String sortOrder {get; set;}
    public String nullsOrder {get; set;}
    public static List<GES_Connect_Corporate_Accounts__c> theshows{get; set;}
    public static     List<congressListWrapper> wrapList {get; set;}
    public    List<congressListWrapper> dispWrapper {get; set;}
    
    Integer counter = 0;//TO track the number of records parsed
    Integer limitSize = 50;//Number of records to be displayed
    Integer totalSize =0; //To Store the total number of records available
    
    
    //--Pagination
    
    
   
    public  Epa3ReportController(){
        orderByQuery = 'Name_of_Congress__c';
        sortOrder = 'asc';
        nullsOrder = 'nulls last';
        wrapList=new  List<congressListWrapper>();
        beginning();
    }
    
    
    
    
    public void beginning(){
        searchShows();
        dispWrapper = new List<congressListWrapper>();
        totalSize = wrapList.size();
        counter=0;
        if((counter + limitSize) <= totalSize){
            
            for(Integer i=0;i<limitSize;i++){
                dispWrapper.add(wrapList.get(i));
            }   
            
        } else{
            
            for(Integer i=0;i<totalSize;i++){
                dispWrapper.add(wrapList.get(i));
            }       
            
        }
        
    }
    
    public void next(){
        searchShows();
        dispWrapper = new List<congressListWrapper>();
        counter=counter+limitSize;
        
        if((counter+limitSize) <= totalSize){
            for(Integer i=counter-1;i<(counter+limitSize);i++){
                dispWrapper.add(wrapList.get(i));
            }
        } else{
            for(Integer i=counter;i<totalSize;i++){
                dispWrapper.add(wrapList.get(i));
            }
        }
    }
    
    public void previous(){
        searchShows();
        dispWrapper = new List<congressListWrapper>();
        
        counter=counter-limitSize;       
        
        for(Integer i=counter;i<(counter+limitSize); i++){
            dispWrapper.add(wrapList.get(i));
        }
    }
    
    public void last (){
        searchShows();
        dispWrapper = new List<congressListWrapper>();
        
        if(math.mod(totalSize , limitSize) == 0){
            counter = limitSize * ((totalSize/limitSize)-1);
        } else if (math.mod(totalSize , limitSize) != 0){
            counter = limitSize * ((totalSize/limitSize));
        }
        
        for(Integer i=counter-1;i<totalSize-1;i++){
            dispWrapper.add(wrapList.get(i));
        }
        
    }
    
    public Boolean getDisableNext(){
        
        if((counter + limitSize) >= totalSize )
            return true ;
        else
            return false ;
    }
    
    public Boolean getDisablePrevious(){
        
        if(counter == 0)
            return true ;
        else
            return false ;
    } 
    
    
    
    public PageReference resetSearch() {
        congressDate = null;
        // congressName = null;
        congressToDate =null;
        beginning();
        return null;
        // return searchShows();
    }
    
    
    public PageReference searchShows() {
        wrapList=new  List<congressListWrapper>();
        
        if (theshows != null) {
            theshows.clear();
        }
        String congWhereClause = '';
        Date today = Date.today();
        
        congressQuery = 'SELECT Id, Epa3_Closed__c,Epa3_Closed_Date__c, Congress_Level__c, Name, Acronym_of_Congress__c, Name_of_Congress__c, Congress_Type__c, Congress_Start_Date__c, Congress_End_Date__c, (select GES_Congress_Manager__c, GES_Account_Manager__c, GES_Account_Executive__c from Activity_Type_Exhibit_Instance__r ), (select GES_Congress_Manager__c, GES_Account_Manager__c, GES_Account_Executive__c from Sponsorship_Instance__r), (select GES_Congress_Manager__c, GES_Account_Manager__c, GES_Account_Executive__c from Product_Theater__r), (select GES_Congress_Manager__c, GES_Account_Manager__c, GES_Account_Executive__c from Symposia__r), (select GES_Congress_Manager__c, GES_Account_Manager__c, GES_Account_Executive__c from Meeting_Room__r) FROM GES_Connect_Corporate_Accounts__c where id!=null ';
        system.debug('List Data'+congressQuery );
        
        if(congressDate != null && congressToDate != null) {
            congressQuery += ' AND Congress_Start_Date__c >=: congressDate AND Congress_End_Date__c <=: congressToDate';
        } else
            if(congressDate != null) {
                congressQuery += ' AND Congress_Start_Date__c >=: congressDate';
            } else
                if(congressToDate != null) {
                    congressQuery += ' AND Congress_End_Date__c <=: congressToDate';
                }
        congressQuery = congressQuery +  congWhereClause +' order by ' + orderByQuery + ' ' + sortOrder + ' ' + nullsOrder + ' limit 10000';
        
        
        system.debug('List Data'+congressQuery );
        theshows=Database.Query(congressQuery);
        
        
        ///
        for(GES_Connect_Corporate_Accounts__c shw:theshows){
            if(shw.Activity_Type_Exhibit_Instance__r.size()>0){
                for(integer i=0;i<shw.Activity_Type_Exhibit_Instance__r.size();i++){
                    wrapList.add(new congressListWrapper(shw.Name_of_Congress__c,
                                                         shw.Acronym_of_Congress__c,
                                                         shw.Congress_Level__c,
                                                         shw.Activity_Type_Exhibit_Instance__r[i].GES_Congress_Manager__c,
                                                         shw.Activity_Type_Exhibit_Instance__r[i].GES_Account_Manager__c,
                                                         shw.Activity_Type_Exhibit_Instance__r[i].GES_Account_Executive__c,
                                                         shw.Congress_Start_Date__c,
                                                         shw.Congress_End_Date__c,
                                                         shw.Epa3_Closed_Date__c,
                                                         'Exhibit') 
                                );
                }
            }
            if(shw.Sponsorship_Instance__r.size()>0){
                for(integer i=0;i<shw.Sponsorship_Instance__r.size();i++){
                    wrapList.add(new congressListWrapper(shw.Name_of_Congress__c,
                                                         shw.Acronym_of_Congress__c,
                                                         shw.Congress_Level__c,
                                                         shw.Sponsorship_Instance__r[i].GES_Congress_Manager__c,
                                                         shw.Sponsorship_Instance__r[i].GES_Account_Manager__c,
                                                         shw.Sponsorship_Instance__r[i].GES_Account_Executive__c,
                                                         shw.Congress_Start_Date__c,
                                                         shw.Congress_End_Date__c,
                                                         shw.Epa3_Closed_Date__c,
                                                         'Sponsorship') 
                                );
                }
            }
            if(shw.Product_Theater__r.size()>0){
                for(integer i=0;i<shw.Product_Theater__r.size();i++){
                    wrapList.add(new congressListWrapper(shw.Name_of_Congress__c,
                                                         shw.Acronym_of_Congress__c,
                                                         shw.Congress_Level__c,
                                                         shw.Product_Theater__r[i].GES_Congress_Manager__c,
                                                         shw.Product_Theater__r[i].GES_Account_Manager__c,
                                                         shw.Product_Theater__r[i].GES_Account_Executive__c,
                                                         shw.Congress_Start_Date__c,
                                                         shw.Congress_End_Date__c,
                                                         shw.Epa3_Closed_Date__c,
                                                         'Product Theater') 
                                );
                }
            }
            if(shw.Symposia__r.size()>0){
                for(integer i=0;i<shw.Symposia__r.size();i++){
                    wrapList.add(new congressListWrapper(shw.Name_of_Congress__c,
                                                         shw.Acronym_of_Congress__c,
                                                         shw.Congress_Level__c,
                                                         shw.Symposia__r[i].GES_Congress_Manager__c,
                                                         shw.Symposia__r[i].GES_Account_Manager__c,
                                                         shw.Symposia__r[i].GES_Account_Executive__c,
                                                         shw.Congress_Start_Date__c,
                                                         shw.Congress_End_Date__c,
                                                         shw.Epa3_Closed_Date__c,
                                                         'Symposia') 
                                );
                }
            }
            if(shw.Meeting_Room__r.size()>0){
                for(integer i=0;i<shw.Meeting_Room__r.size();i++){
                    wrapList.add(new congressListWrapper(shw.Name_of_Congress__c,
                                                         shw.Acronym_of_Congress__c,
                                                         shw.Congress_Level__c,
                                                         shw.Meeting_Room__r[i].GES_Congress_Manager__c,
                                                         shw.Meeting_Room__r[i].GES_Account_Manager__c,
                                                         shw.Meeting_Room__r[i].GES_Account_Executive__c,
                                                         shw.Congress_Start_Date__c,
                                                         shw.Congress_End_Date__c,
                                                         shw.Epa3_Closed_Date__c,
                                                         'Meeting Room') 
                                );
                }
            }
        }
        
        return null;
    }
    
    
       public PageReference back() 
   {
        return page.ReportsList;
        
    }
      
   
    
    public PageReference excelReport() {
        PageReference reports=new PageReference('/apex/Ep3_ExcelDownload');
        reports.setRedirect(false);
        return reports;
        // return page.Ep3_ExcelDownload;     
        // return Page.Ep3_ExcelDownload.setRedirect(false); 
    } 
    
    
    public PageReference gotoReports()
    {
        PageReference reports=new PageReference('/apex/ReportsList');
        reports.setRedirect(true);
        return reports;
    }
    
    
    public class congressListWrapper {
        public String nameOfCongress {get; set;}
        public String acronym {get; set;}
        public String level {get; set;}
        public string GesCongressMgr{get; set;}
        public string GESAccountMgr{get; set;}
        public string GESAccountExe{get; set;}
        public Date exhiBitOpenDate {get; set;}
        public Date exhiBitCloseDate {get; set;}
        public Date epCloseDate{get;set;}
        public String ActivityType {get; set;}
        public congressListWrapper (String nameOfCongress,String acronym,String Level,String GesCongressMgr,String GESAccountMgr,String GESAccountExe,Date exhiBitOpenDate ,Date exhiBitCloseDate,Date ep,String actvity) 
        {
            
            this.nameOfCongress = nameOfCongress;
            this.acronym = acronym;
            this.level = level;
            this.GesCongressMgr = GesCongressMgr;
            this.GESAccountMgr = GESAccountMgr;
            this.GESAccountExe = GESAccountExe;
            this.ActivityType= actvity;
            this.exhiBitOpenDate =exhiBitOpenDate ;
            this.exhiBitCloseDate =exhiBitCloseDate ;
            this.epCloseDate=ep;
            
        }
    }
}