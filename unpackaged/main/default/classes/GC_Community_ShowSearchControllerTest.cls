/**
* @author Ethos Solutions - www.ethos.com
* @description Test code for the Show Search controller
* 2016-04-12 : Original Version
**/
@isTest
public class GC_Community_ShowSearchControllerTest {

    public static testMethod void getShowsTest() {
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        show.Facility__c = 'facility 1';
        show.Job_Number__c = '1';
        show.Show_Start_Date__c = Date.today();
        update show;
        GC_Community_ShowSearchController cont = new GC_Community_ShowSearchController();
        cont.showDate = Date.today();
        cont.searchShows();
        List<GC_Connect2_Show__c> showQuery = cont.getPagedShows();
        cont.showId = show.Id;
        System.assertEquals(showQuery.size() , 1);
        System.assertEquals(showQuery.get(0).Facility__c , show.Facility__c);
        cont.resetSearch();
        showQuery = cont.getPagedShows();

        System.assertEquals(showQuery.size() , 1);
        System.assertEquals(showQuery.get(0).Facility__c , show.Facility__c);
        System.assertEquals(cont.getDateString(null), '');
        cont.sortColumn();
        cont.noAccess();
    }
}