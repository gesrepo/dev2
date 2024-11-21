/*************************************************************************
*
* PURPOSE: DAO for Connect2 Show
*
* CLASS: Connect2ShowDao
* CREATED: 12/4/2015 Ethos Solutions - www.ethos.com
* AUTHOR: Zack Smith
***************************************************************************/
public with sharing class GC_Connect2ShowDao extends GC_BaseDao {

    private static final GC_Connect2ShowDao Connect2ShowDao = new GC_Connect2ShowDao();
    private static Set<String> relatedFields;

    private GC_Connect2ShowDao() {
        super('GC_Connect2_Show__c');
    }

    public static GC_Connect2ShowDao getInstance() {
        return Connect2ShowDao;
    }

    public GC_Connect2_Show__c getConnect2ShowById(String showId) {
        return (GC_Connect2_Show__c)getSObjectById(showId);
    }

    public GC_Connect2_Show__c getByOpportunityId(String oppId) {
        return Database.query(getSelect('Opportunity_Id__c = :oppId', '', null));
    }

    public List<GC_Connect2_Show__c> getAllShows() {
        return Database.query(getSelect('', '', 1000)); // need to limit to 1000 or you'll get a limit exception
    }

    public List<GC_Connect2_Show__c> getShowsEndingAfterToday() {
        Date today = Date.today();
        return Database.query(getSelect('Show_End_Date__c >= :today', 'Show_End_Date__c', 1000));
    }

    public List<GC_Connect2_Show__c> getShowsEndingAfterTodayJobNumberPopulated() {
        Date today = Date.today();
        return Database.query(getSelect('Show_End_Date__c >= :today AND Job_Number__c != null', 'Name, Show_End_Date__c', 1000));
    }

    public List<GC_Connect2_Show__c> getShowsWithJobNumberPopulated() {
        Date today = Date.today();
        return Database.query(getSelect('Job_Number__c != null', 'Name, Show_End_Date__c', 1000));
    }

    public List<GC_Connect2_Show__c> getShowsByIds(Set<String> showIds) {
        return (List<GC_Connect2_Show__c>)getSObjectByIdSet('Id', showIds);
    }

    public List<GC_Connect2_Show__c> getShowsByIds(Set<String> showIds, String orderBy) {
        return (List<GC_Connect2_Show__c>)getSObjectByIdSet('Id', showIds, null, orderBy);
    }
}