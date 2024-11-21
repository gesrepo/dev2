@isTest
public class LC_IntegrationsApexControllerTest {
    /*@testSetup static void setup(){
Opportunity opp=new Opportunity(Name='Test',CloseDate=Date.today(),StageName='Open / Pending');
insert opp;
GC_Connect2_Show__c shw = new GC_Connect2_Show__c(Job_Number__c='P00000001',Show_Start_Date__c=Date.today(),Show_End_Date__c=Date.today()+3,Opportunity_Id__c=opp.ID);
insert shw;
User usr = new User(
ProfileId = [SELECT Id FROM Profile WHERE Name = 'Digital Products/IT Admin'].Id,
LastName = 'last',
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
insert usr;

GC_Show_Team_Member__c STM= new GC_Show_Team_Member__c(Tiles_Access__c='Tasks',User__c=usr.Id,Connect2_Show__c=shw.Id);
insert STM;
}*/
    public static testMethod void testgetReport() {
        wwwViadComV1_all.ExhibitorInfo exInfo = new wwwViadComV1_all.ExhibitorInfo();
        LC_IntegrationsApexController.ExhibitorInfoWrapper testExhibitorInfoWrapper= new LC_IntegrationsApexController.ExhibitorInfoWrapper(exInfo);
        wwwViadComV1_all.OrderProgressSummary OrderProgressSummary = new wwwViadComV1_all.OrderProgressSummary();
        OrderProgressSummary.ExhbitorsWithOrdersCount=10;
        OrderProgressSummary.ExhibitorsCount=15;
        LC_IntegrationsApexController.OrderProSumWrapper testOrderProSumWrapper= new LC_IntegrationsApexController.OrderProSumWrapper(OrderProgressSummary);
        Test.setMock(WebServiceMock.class, new wwwViadComV1_allMockImpl());
        LC_IntegrationsApexController.showAndExListWrapper testshowAndExListWrapper = LC_IntegrationsApexController.getReport('12345');
    }    
    public static testMethod void testGetExhibitorFormProgress(){
        Test.setMock(WebServiceMock.class, new wwwViadComV1_allMockImpl());
        LC_IntegrationsApexController.ExOrProReportWrapper testExOrProReportWrapper= LC_IntegrationsApexController.GetExhibitorFormProgress('P001');
    }
    public static testMethod void testGetExhibitorOrderTypeStatus(){
        
        Test.setMock(WebServiceMock.class, new wwwViadComV1_allMockImpl());
        LC_IntegrationsApexController.ExOrCatReportWrapper testExOrCatReportWrapper=LC_IntegrationsApexController.GetExhibitorOrderTypeStatus('P00000001',Date.today(),Date.today()+7);
    }
    
    public static testMethod void testsetExpoCadURL(){
        String result=LC_IntegrationsApexController.setExpoCadURL('P001');
    }
    public static testMethod void testgetSessionIDWithLogin(){
        String result=LC_IntegrationsApexController.getSessionIDWithLogin();
    }
    public static testMethod void testgetUserSessionID(){
        String result=LC_IntegrationsApexController.getUserSessionID();
    }
    public static testMethod void testShowInstanceChecklistItems(){
        Test.setMock(WebServiceMock.class, new wwwViadComV1_allMockImpl());
        LC_IntegrationsApexController.ChecklistItemsWrapper testChecklistItemsWrapper=LC_IntegrationsApexController.ShowInstanceChecklistItems('P00000001');
    }
    public static testMethod void testGetRegistrationCheckListTasks(){
        Test.setMock(WebServiceMock.class, new wwwViadComV1_allMockImpl());
        String  testGetRegistrationCheckListTasks=LC_IntegrationsApexController.GetRegistrationCheckListTasks('P00000001',10);
        
    }
}