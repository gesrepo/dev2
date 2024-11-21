@isTest
public class CongressSearchControllerTest {

    public static testMethod void getShowsTest() {
        GC_Community_CongressSearchController sercong=new GC_Community_CongressSearchController ();
        sercong.resetSearch();
        sercong.Congressedit();
        sercong.searchShows();
        sercong.congressId='123';
        sercong.setDate();
        sercong.sortColumn();
        sercong.getPagedcongress();
        sercong.gotoReports();
        String dateresult=sercong.getDateString(Date.Today());
    
    
    
      /*  //GES_Connect_Corporate_Accounts__c congress = new GES_Connect_Corporate_Accounts__c(); //GC_TestUtils.getTestCongress();
         GES_Connect_Corporate_Accounts__c show = new GES_Connect_Corporate_Accounts__c();
        show.Name_of_Congress__c = 'Test';
       // show.Job_Number__c = '1';
      //  show.Congress_Website__c  = 'www.test.com';
        update show;
        GC_Community_CongressSearchController cont = new GC_Community_CongressSearchController();
      //  cont.Name_of_Congress__c = 'Test';
     //   cont.showDate = Date.today();
        cont.searchShows();
        List<GES_Connect_Corporate_Accounts__c> congressQuery = cont.getPagedcongress();
        cont.congressId = show.Id;
        System.assertEquals(congressQuery.size() , 1);
        System.assertEquals(congressQuery.get(0).Name_of_Congress__c , show.Name_of_Congress__c);
        cont.resetSearch();
        congressQuery = cont.getPagedcongress();

        System.assertEquals(congressQuery.size() , 1);
        System.assertEquals(congressQuery.get(0).Name_of_Congress__c , show.Name_of_Congress__c);
        System.assertEquals(cont.getDateString(null), '');
        cont.sortColumn();*/               
    }
}