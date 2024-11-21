@isTest
public class LC_OrderCloneControllerTest {
    @testsetup
    public static void testSetup(){
        User insertUser = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'GC Account Manager'].Id,
            LastName = 'insertUserForTest1',
            Email = 'test@test.com',
            Username = 'test@test.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        insert insertUser;
        GC_Connect2_Show__c newShow = new GC_Connect2_Show__c();
        newShow.Show_Name__c = 'test show OrderClone';
        newShow.Job_Number__c = '12345';
        newShow.Production_Location__c='71';
        newShow.Show_Start_Date__c = system.today().addDays(-10);
        newShow.Show_End_Date__c = system.today().addDays(-2);
        newShow.Exhibit_Hall_Hours_Day_1__c = '5:00 PM To 8:00 PM';
        newShow.Exhibit_Hall_Hours_Day_2__c = '7:00 AM To 6:30 PM';
        newShow.Exhibit_Hall_Hours_Day_3__c = '8:00 AM To 4:00 PM';
        newShow.Exhibit_Hall_Hours_Day_4__c = '9:00 AM To 10:00 PM';
        insert newShow;
        
        GC_Show_Attribute__c deptat= LC_TestUtils.insertDeptAttributes(newShow.Id);
        
        GC_Show_Team_Member__c member = new GC_Show_Team_Member__c();
        member.Service_Type__c=deptat.Id;
        member.Show_Role__c='Account Manager';
        member.User__c = insertUser.Id;
        member.Connect2_Show__c=newShow.Id;
        insert member;
        
        
    }
    @isTest
    public static void testMethod1(){
        List<GC_Connect2_Show__c> show=[select Id from GC_Connect2_Show__c where Show_Name__c ='test show OrderClone' limit 1];
        Test.startTest(); 
        User u=[select id from user where LastName = 'insertUserForTest1' Limit 1];
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(show);
        LC_OrderCloneController obj= new LC_OrderCloneController(sc);
        System.runAs(u) {
            LC_OrderCloneController.getopenShowOptions(); 
        }
        Test.stopTest();
        
    }
    
}