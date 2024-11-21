@istest
public with sharing class WeeklyOrderSummaryNotSchTest {
    static testmethod void test1() {
        Test.startTest();
        Datetime dt = Datetime.now().addMinutes(1);
        String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
        String jobId = System.schedule('WeeklyOrderSummary1', CRON_EXP, new WeeklyOrderSummaryNotSch() );   
        Test.stopTest();
    }
    
    static testmethod void test2() {
        Test.startTest();
        Datetime dt = Datetime.now().addMinutes(1);
        String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
        String jobId = System.schedule('WeeklyOrderSummary2', CRON_EXP, new WeeklyOrderSummaryNotifySch() );   
        Test.stopTest();
    }

}