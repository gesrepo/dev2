/**
* @author Ethos Solutions - www.ethos.com
* @description Controller for the Search Shows page on community
* 2016-04-12 : Original Version
**/
public with sharing class GC_Community_ShowSearchController {
    public String showId {get; set;}
    public String showName {get; set;}
    public Date showDate {get; set;}
    public String showQuery {get; set;}
    public String orderByQuery {get; set;}
    public String sortOrder {get; set;}
    public String nullsOrder {get; set;}
    public transient List<GC_Connect2_Show__c> theshows {get; set;}
    //--Pagination
    public Integer noOfShowRecords { get; set; }
    public Integer size { get; set; }
    public Integer pageNumber = null;
    public Boolean isClassic{get; set;}
    Public String showHeaderVal{get; set;}

    public ApexPages.StandardSetController setShow { get; set; }

    public GC_Community_ShowSearchController() {
        //theshows =  GC_Connect2ShowDao.getInstance().getShowsWithJobNumberPopulated();
        orderByQuery = 'Name';
        sortOrder = 'asc';
        nullsOrder = 'nulls last';
        searchShows();
        String ntwrkId = Network.getNetworkId();
        system.debug('ntwrkId==='+ntwrkId);
        if(ntwrkId==null){
            isClassic= true;
            showHeaderVal='true';
            
        }else{
            isClassic= false;
            showHeaderVal='false';
        }
    }

    public PageReference resetSearch() {
        showDate = null;
        showName = null;
        return searchShows();
    }

    public PageReference searchShows() {
        setShow = null;
        if (theshows != null) {
            theshows.clear();
        }
        String showWhereClause = '';
        Date today = Date.today();

        showQuery = 'SELECT Id FROM GC_Connect2_Show__c WHERE Job_Number__c != null ';
        //showQuery = 'SELECT Id, Name, Show_Name__c,Facility__c,Facility_Address__c,Show_Start_Date__c,Show_End_Date__c FROM GC_Connect2_Show__c WHERE Show_End_Date__c >= ' + getDateString(today) + ' AND Job_Number__c != null';
        showWhereClause += String.isNotBlank(showName) ? ' AND Show_Name__c like \'%' + showName + '%\'' : '';

        if (showDate != null) {
            showWhereClause += ' AND Show_Start_Date__c = ' + getDateString(showDate);
        }
        showQuery = showQuery + showWhereClause + ' order by ' + orderByQuery + ' ' + sortOrder + ' ' + nullsOrder + ' limit 10000';

        if (setShow != null) {
            pageNumber = setShow.getPageNumber();
        }
        setShow = new ApexPages.StandardSetController(Database.Query(showQuery));

        size = 100;

        setShow.setPageSize(size);
        noOfShowRecords = setShow.getResultSize();
        if (pageNumber != null) {
            setShow.setPageNumber(pageNumber);
        }
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
            showDate = Date.parse(Apexpages.currentPage().getParameters().get('inputDate'));
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

    public List<GC_Connect2_Show__c> getPagedShows() {
        Set<String> showIds = new Set<String>();
        for (GC_Connect2_Show__c show : (List<GC_Connect2_Show__c>)setShow.getRecords()) {
            showIds.add(show.Id);
        }

        return GC_Connect2ShowDao.getInstance().getShowsByIds(showIds, orderByQuery + ' ' + sortOrder + ' ' + nullsOrder);
    }
    
    public pageReference noAccess()
    {
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String MyProflieName = PROFILE[0].Name;
        if(MyProflieName == 'GC Congress Client' || MyProflieName == 'GC Congress Internal'){
            pageReference p = Page.GC_Community_ShowCongress;
            p.setRedirect(true);
            return p;
            
        }/*else{
            string fullURL= System.Label.LC_CommunityURL;
            PageReference pageRef = new PageReference(fullURL);
            pageRef.setRedirect(true);
            return pageRef;
        }   */
        return null;
    }
}