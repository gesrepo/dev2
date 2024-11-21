@istest
public with sharing class DailyOrderEmailSchTest {
    static testmethod void test1() {
        GC_GES_Order_Task__c  orderTask = GC_TestUtils.setupOrderAndTask();
        GC_Show_Team_Member__c teamMember = [Select Id,Name,User__r.Email,Connect2_Show__c from GC_Show_Team_Member__c limit 1];
        teamMember.ReceiveNotificationAllOrders__c = true;
        teamMember.Daily_Order_Summary_Emails__c = true;
        teamMember.No_Notification_Emails__c = false;
        teamMember.ReceiveNotificationMyOrders__c = true;
        teamMember.Show_Role__c = 'Show Organizer';
        update teamMember;
        Test.startTest();
          
        DailyOrderSummaryNotification d = new DailyOrderSummaryNotification();
        Database.executeBatch(d);
        Test.stopTest();
    }
    static testmethod void test2() {
        
        Test.startTest();
        Datetime dt = Datetime.now().addMinutes(1);
        String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
        String jobId = System.schedule('DailyOrderSummary1', CRON_EXP, new DailyOrderSummaryNotifySch() );   
        Test.stopTest();
    }
    
     static testmethod void testWeeklyEmails() {
        GC_GES_Order_Task__c  orderTask = GC_TestUtils.setupOrderAndTask();
        GC_Show_Team_Member__c teamMember = [Select Id,Name,User__r.Email,Connect2_Show__c from GC_Show_Team_Member__c limit 1];
        teamMember.ReceiveNotificationAllOrders__c = true;
        teamMember.Weekly_Order_Summary_Emails__c = true;
        teamMember.No_Notification_Emails__c = false;
        teamMember.ReceiveNotificationMyOrders__c = true;
        teamMember.Show_Role__c = 'Show Organizer';
        update teamMember;
        Test.startTest();
           
        WeeklyOrderTaskSummaryEmailNotification d = new WeeklyOrderTaskSummaryEmailNotification();
        Database.executeBatch(d);
        Test.stopTest();
    }
    static testmethod void testWeeklySch() {
        
        Test.startTest();
        Datetime dt = Datetime.now().addMinutes(1);
        String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
        String jobId = System.schedule('DailyOrderSummary1', CRON_EXP, new WeeklyOrderTaskSummaryEmailSch() );   
        Test.stopTest();
    }
    
}