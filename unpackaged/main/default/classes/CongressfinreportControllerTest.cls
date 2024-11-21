@isTest
public class CongressfinreportControllerTest {

    public static testMethod void getShowsTest() {
        GC_Community_CongressreportController sercong=new GC_Community_CongressreportController ();
        sercong.resetSearch();
        sercong.Congressedit();
        sercong.searchShows();
        sercong.congressId='2323';
        sercong.setDate();
        sercong.sortColumn();
        sercong.getPagedcongress();   
        sercong.gotoReports();
    }
    public static testMethod void CSItest() {
        GC_Community_CSI_ReportController csiSearch=new GC_Community_CSI_ReportController();
        csiSearch.resetSearch();
        csiSearch.Congressedit();
        csiSearch.searchShows();
        csiSearch.congressId='2323';
        csiSearch.setDate();
        csiSearch.sortColumn();
        csiSearch.getPagedcongress();   
        csiSearch.gotoReports();
        csiSearch.runReport();
        csiSearch.back();
        csiSearch.getDateString(date.Today());
    }
}