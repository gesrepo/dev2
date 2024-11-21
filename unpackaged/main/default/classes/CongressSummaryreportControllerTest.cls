@isTest
public class CongressSummaryreportControllerTest {

    public static testMethod void getShowsTest() {
        CongressSummaryReportController sercong=new CongressSummaryReportController ();
        sercong.resetSearch();
        sercong.Congressedit();
        sercong.searchShows();
        sercong.congressId='2323';
        sercong.setDate();
        sercong.sortColumn();
        sercong.getPagedcongress();   
        sercong.gotoReports();
    }
}