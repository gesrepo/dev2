/**
* @author Ethos Solutions - www.ethos.com
* @description Controller for home page component
* 2016-04-13 : Original Version
**/
public with sharing class GC_HomePageInfo_Controller {
    public List<GC_Connect2_Show__c> shows;

    public List<GC_Connect2_Show__c> getShows() {
        if (shows == null) {
            shows = GC_Connect2ShowDao.getInstance().getShowsEndingAfterToday();
        }
        return shows;
    }
}