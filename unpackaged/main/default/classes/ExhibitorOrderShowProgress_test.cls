@isTest
public class ExhibitorOrderShowProgress_test {
    
    static TestMethod void ExhibitorOrderShowProgress()
    {
        GC_Connect2_Show__c show = GC_TestUtils.getTestConnect2Show();
        string showId = show.Id;
        
        GC_Connect2_Show__c cgs=new GC_Connect2_Show__c();   
        cgs.Show_Start_Date__c=Date.parse('3/4/2015');
        cgs.Show_End_Date__c=Date.parse('3/4/2015');
        cgs.Job_Number__c = '123456789';
        insert cgs;
        
        GC_Core_Session__c sessionObj = new GC_Core_Session__c ();
        sessionObj.Expresso_Session_ID__c =  '1111111111111111111';
        sessionObj.Expresso_Session_Expiration__c = NULL; // DateTime.now().addDays(20);
        sessionObj.Expresso_Session_Error_Message__c= 'Test error msg';
        insert sessionObj;
        
        String startDate = String.valueOf(Date.Today());
        String endDate = String.valueOf(Date.Today());
        List<string> readTasks = new List<string>();
        readTasks.add('Read');
        readTasks.add('Unread');
        
        ApexPages.StandardController sc=new ApexPages.StandardController(cgs); 
        ExhibitorOrderShowProgressController exOrSh = new ExhibitorOrderShowProgressController();
        exOrSh.loadCheckListTasks();
        //ExhibitorOrderShowProgressController.markAsRead('123456789', readTasks);
        String myStr=ExhibitorOrderShowProgressController.PrintSlectedTasksApex('123456789',readTasks,'1234567');
        
        Test.startTest();
        Test.setMock(WebServiceMock.class, new wwwViadComV1_allMockImpl());
        ExhibitorOrderShowProgressController.getExSessionID();
        ExhibitorOrderShowProgressController.GetExhibitorFormProgress('123456789','exh1');
        ExhibitorOrderShowProgressController.getReport('123456789','exh2');
        ExhibitorOrderShowProgressController.GetExhibitorChecklistStatus('123456789','exh2');
        ExhibitorOrderShowProgressController.GetExhibitorOrderTypeStatus('123456789', '1234', startDate, endDate); //34567
        ExhibitorOrderShowProgressController.ShowInstanceChecklistItems('123456789', cgs.Id); //showId
        ExhibitorOrderShowProgressController.GetRegistrationCheckListTasks('123456789', 1);
        ExhibitorOrderShowProgressController.PrintSlectedTasksApex('123456789',readTasks,'123456');
        ExhibitorOrderShowProgressController.RegistrationCheckListTaskDetails('123456789', 1);
        Pagereference pr= ExhibitorOrderShowProgressController.returnToReportList();
        Test.stopTest();
    }
}