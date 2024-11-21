@isTest
public class GC_Community_ExpressoReports_test {
    
   public static testMethod void searchResultsTest() {
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        User usr = [SELECT Id, Name FROM User WHERE Id = :userinfo.getUserId() LIMIT 1];
        string showId = show.Id;
        show.job_number__c='123456789';
       update show;
        GC_Show_Attribute__c GCshow=new GC_Show_Attribute__c();
        GCshow.Connect2_Show__c =show.Id;
        GCshow.name='test';
        insert GCshow;
        Test.setCurrentPageReference(new PageReference('Page.GC_Community_ExpressoReportsList'));
        ApexPages.currentPage().getParameters().put('Id' , showId);
        ApexPages.currentPage().getParameters().put('projectNumber' , show.job_number__c);  //pass this as if a parameter is made available in URL
        GC_Community_ExpressoReportsController cont = new GC_Community_ExpressoReportsController();
        //cont.showId =  show.Id;
      
        //test to check search result returned 
        PageReference pr = cont.ExhibitorOrderShowProgress();
        PageReference pr1 = cont.ExhibitorOrdersByCategory();
        PageReference pr2 = cont.SubmittedFormShowProgress();
        PageReference pr3 = cont.ExhibitorChecklistStatus();
        PageReference pr4 = cont.ShowInstanceChecklistItems();
        cont.checkValidations();
    }
    
     public static testMethod void searchResultsTestForExceptions() {
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        User usr = [SELECT Id, Name FROM User WHERE Id = :userinfo.getUserId() LIMIT 1];
        string showId = show.Id;
        
        GC_Show_Attribute__c GCshow=new GC_Show_Attribute__c();
        GCshow.Connect2_Show__c =show.Id;
        GCshow.name='test';
        insert GCshow;
        Test.setCurrentPageReference(new PageReference('Page.GC_Community_ExpressoReportsList'));
        ApexPages.currentPage().getParameters().put('Id' , showId);
        ApexPages.currentPage().getParameters().put('projectNumber' , '12345678');  //pass this as if a parameter is made available in URL
        GC_Community_ExpressoReportsController cont = new GC_Community_ExpressoReportsController();
        //cont.showId =  show.Id;
      
        //test to check search result returned 
        PageReference pr = cont.ExhibitorOrderShowProgress();
        PageReference pr1 = cont.ExhibitorOrdersByCategory();
        PageReference pr2 = cont.SubmittedFormShowProgress();
        PageReference pr3 = cont.ExhibitorChecklistStatus();
        PageReference pr4 = cont.ShowInstanceChecklistItems();
        cont.checkValidations();
    }
}