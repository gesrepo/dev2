@isTest
public class GC_Connect2ShowCreateControllerTest {
    public GC_Connect2_Show__c  testShow2= GC_TestUtils.getTestConnect2Show();
    public static testMethod void initializeClass() {
    GC_Connect2ShowCreateController cntrlr = new GC_Connect2ShowCreateController();  
       
        cntrlr.connect2Show = new GC_Connect2_Show__c();
        cntrlr.connect2Show.Opportunity_Name__c = '01453-201601-';
        cntrlr.connect2Show.Opportunity_Id__c = '006f000000F6EbtAAF';
        cntrlr.connect2Show.Show_Name__c = 'test show';
        cntrlr.connect2Show.Job_Number__c = '12345';
        cntrlr.connect2Show.Show_Start_Date__c = Date.today();
        cntrlr.connect2Show.Show_End_Date__c = Date.today();
        cntrlr.connect2Show.Exhibit_Hall_Hours_Day_1__c = '5:00 PM To 8:00 PM';
        cntrlr.connect2Show.Exhibit_Hall_Hours_Day_2__c = '7:00 AM To 6:30 PM';
        cntrlr.connect2Show.Exhibit_Hall_Hours_Day_3__c = '8:00 AM To 4:00 PM';
        cntrlr.connect2Show.Exhibit_Hall_Hours_Day_4__c = '9:00 AM To 10:00 PM';
        cntrlr.connect2Show.Exhibit_Hall_Hours_Day_5__c = '9:00 AM To 10:00 PM';
        PageReference landingPage = cntrlr.saveAction();
        
        cntrlr.connect2Show.Opportunity_Name__c = '01453-201601-';
        landingPage = cntrlr.saveAction();
        
        cntrlr.connect2Show.Job_Number__c = '123456';
        landingPage = cntrlr.saveAction();
        GC_Connect2ShowCreateController cntrlr1 = new GC_Connect2ShowCreateController();  
        cntrlr1.connect2Show = GC_TestUtils.getTestConnect2Show1();
        PageReference returningPage = cntrlr1.cancelAction();
    }
}