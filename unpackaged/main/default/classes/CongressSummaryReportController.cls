public with sharing class CongressSummaryReportController {
    public String congressId {get; set;}
    public String congressName {get; set;}
    public Date congressDate {get; set;}
    public String acronymName {get; set;}
    //public String username{get;set;}
    public String congressQuery {get; set;}
    public String orderByQuery {get; set;}
    public String sortOrder {get; set;}
    public String nullsOrder {get; set;}
    public transient List<GES_Connect_Corporate_Accounts__c> theshows {get; set;}
    //--Pagination
    public Integer noOfCongressRecords { get; set; }
    public Integer size { get; set; }
    public Integer pageNumber = null;


    public ApexPages.StandardSetController setcongress { get; set; }

    public CongressSummaryReportController () {
        //theshows =  GC_Connect2ShowDao.getInstance().getShowsWithJobNumberPopulated();
        orderByQuery = 'Name_of_Congress__c';
        sortOrder = 'asc';
        nullsOrder = 'nulls last';
        searchShows();
    }

    public PageReference resetSearch() {
        congressDate = null;
        congressName = null;
        acronymName =null;
        return searchShows();
    }
    Public PageReference Congressedit(){
        congressDate = null;
        congressName = null;
    return Page.Congressedit;
    }
    
    public PageReference searchShows() {
        setcongress = null;
        if (theshows != null) {
            theshows.clear();
        }
        String congWhereClause = '';
        Date today = Date.today();

        congressQuery = 'SELECT Id,Show_Name__r.Name,Name,Acronym_of_Congress__c,Name_of_Congress__c,Congress_Type__c,Congress_Website__c,Congress_Start_Date__c,Congress_End_Date__c,Exhibit_Open_Date__c,Exhibit_Close_Date__c, Shipping_City__c,Shipping_State_Province__c  FROM GES_Connect_Corporate_Accounts__c WHERE Exhibit_Open_Date__c!= null';
        system.debug('List Data'+congressQuery );
        //congressQuery = 'SELECT Id, Name, Show_Name__c,Facility__c,Facility_Address__c,Show_Start_Date__c,Show_End_Date__c FROM GC_Connect2_Show__c WHERE Show_End_Date__c >= ' + getDateString(today) + ' AND Job_Number__c != null';
        congWhereClause += String.isNotBlank(congressName) ? ' AND Name_of_Congress__c like \'%' + congressName + '%\'' : '';
        system.debug('List congWhereClause '+congWhereClause );
        system.debug('Date congWhereClause '+congressDate );
        if (congressDate != null) {
            congWhereClause += ' AND Exhibit_Open_Date__c=' + getDateString(congressDate);
        }
        system.debug('acronymName  congWhereClause '+acronymName );
      congWhereClause += String.isNotBlank(acronymName) ? ' AND Acronym_of_Congress__c like \'%' + acronymName+ '%\'' : '';
        congressQuery = congressQuery +  congWhereClause +' order by ' + orderByQuery + ' ' + sortOrder + ' ' + nullsOrder + ' limit 10000';
        system.debug('List Data'+congressQuery );
        if (setcongress != null) {
            pageNumber = setcongress .getPageNumber();
        }
        system.debug('List Data'+congressQuery );
        setcongress = new ApexPages.StandardSetController(Database.Query(congressQuery));
        
        size = 100;
        system.debug('setcongress Data'+setcongress );
        setcongress.setPageSize(size);
        noOfCongressRecords = setcongress .getResultSize();
        if (pageNumber != null) {
            setcongress .setPageNumber(pageNumber);
            system.debug('setcongress Data'+setcongress );
        }  
         system.debug('setcongress Records'+noOfCongressRecords );    
        return null;
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
            congressDate = Date.parse(Apexpages.currentPage().getParameters().get('inputDate'));
        }
        catch (Exception e) {
            System.debug(e.getMessage());
        }
    }

    public PageReference sortColumn() {
        String previousColumn = orderByQuery;

        if (Apexpages.currentPage().getParameters().containsKey('orderByCol')) {
            orderByQuery = Apexpages.currentPage().getParameters().get('orderByCol');
        }

        if (previousColumn != orderByQuery) {
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

        return searchShows();
    }

    public List<GES_Connect_Corporate_Accounts__c> getPagedcongress() {
        Set<String> showIds = new Set<String>();
        for (GES_Connect_Corporate_Accounts__c show : (List<GES_Connect_Corporate_Accounts__c>)setcongress.getRecords()) {
            showIds.add(show.Id);
        }

        return getShowsByIds(showIds, orderByQuery + ' ' + sortOrder + ' ' + nullsOrder);
    }
    
    public List<sObject> getSObjectByIdSet(String field, Set<String> ids, String whereClause, String orderBy) {
        if (ids == null) {
            return null;
        }
        String query = 'select Show_Name__r.Name,Name, Acronym_of_Congress__c,Name_of_Congress__c,Congress_Type__c,Congress_Website__c,Exhibit_Open_Date__c,Exhibit_Close_Date__c ,Congress_Start_Date__c,Congress_End_Date__c,Shipping_City__c,Shipping_State_Province__c from GES_Connect_Corporate_Accounts__c where Id in: ids ';
        if (String.isNotBlank(whereClause)) {
            query += ' AND ' + whereClause;
        }
        if (String.isNotBlank(orderBy)) {
            query += ' order by ' + orderBy;
        }
        return Database.query(query);
    }
    
     public List<GES_Connect_Corporate_Accounts__c> getShowsByIds(Set<String> showIds, String orderBy) {
        return (List<GES_Connect_Corporate_Accounts__c>)getSObjectByIdSet('Id', showIds, null, orderBy);
    }
    public PageReference back() 
   {
        return page.ReportsList;
        
    }
    public PageReference gotoReports()
    {
        PageReference reports=new PageReference('/apex/ReportsList');
        reports.setRedirect(true);
        return reports;
    }
}