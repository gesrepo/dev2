@isTest
public class GC_PDFRecordRemover_SchedulerTest {
    
    public static testMethod void GC_ShowOnTheGoRecordRemover_SchedulerTest() {
        
        GC_Core_Interface_Log__c cil = new GC_Core_Interface_Log__c();
        cil.Method_Name__c  = 'PDF Print';
        insert cil;
        
        Test.startTest();
        Datetime dt = Datetime.now().addMinutes(1);
        String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
        String jobId = System.schedule('GC_ShowGRScheduler', CRON_EXP, new GC_ShowOnTheGoRecordRemover_Scheduler());   
        GC_ShowOnTheGoRecordRemover_Scheduler sgrrs = new GC_ShowOnTheGoRecordRemover_Scheduler();
        Test.stopTest();
        
    }
}