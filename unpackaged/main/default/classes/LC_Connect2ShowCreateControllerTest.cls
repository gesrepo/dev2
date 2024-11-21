@isTest
public class LC_Connect2ShowCreateControllerTest {
    
   
    static TestMethod void testAllMethods() {
        Opportunity oppObj1 = GC_TestUtils.getTestOpportunity();
        
        Opportunity oppObj2 = new Opportunity();
        oppObj2.Name = 'LA Auto Show';
        oppObj2.AccountId = oppObj1.AccountId;
        oppObj2.Facility__c = oppObj1.Facility__c;
        oppObj2.CloseDate = System.Today() + 40;
        oppObj2.StageName = 'CV';
        oppObj2.Amount = 30000;
        oppObj2.Show_Start_Date_Time__c = System.Today() + 12;
        oppObj2.Show_End_Date_Time__c = System.Today() + 17;
        oppObj2.Exhibit_Hall_Hours_Day_1__c = '5:00 PM To 8:00 PM';
        oppObj2.Exhibit_Hall_Hours_Day_2__c = '7:00 AM To 6:30 PM';
        oppObj2.Exhibit_Hall_Hours_Day_3__c = '8:00 AM To 4:00 PM';
        oppObj2.Exhibit_Hall_Hours_Day_4__c = '9:00 AM To 10:00 PM';
        oppObj2.Exhibit_Hall_Hours_Day_5__c = '9:00 AM To 10:00 PM';
        oppObj2.Exhibitor_Move_In_Date__c = System.Today() + 11;
        oppObj2.RecordTypeId = oppObj1.RecordTypeId;
        oppObj2.Prime_Contractor__c = oppObj1.Prime_Contractor__c;
        oppObj2.Move_Out__c = System.Today() + 14;
        insert oppObj2;
            
        GC_Connect2_Show__c connect2Show = new GC_Connect2_Show__c();  
        Account testAcc = GC_TestUtils.getTestFacility();
        testAcc.LMS_Firm_ID__c = '7356';
        testAcc.BillingCity = 'ny';
        testAcc.BillingPostalCode = 'test';
        testAcc.BillingState = 'test';
        testAcc.BillingCountry = 'test';
        upsert testAcc;
        
        connect2Show.Opportunity_Name__c = '01453-201601-';
        connect2Show.Opportunity_Id__c = oppObj2.Id;
        connect2Show.Show_Name__c = 'test show';
        connect2Show.Job_Number__c = '12345';
        connect2Show.Show_Start_Date__c = Date.today();
        connect2Show.Show_End_Date__c = Date.today();
        connect2Show.Exhibit_Hall_Hours_Day_1__c = '5:00 PM To 8:00 PM';
        connect2Show.Exhibit_Hall_Hours_Day_2__c = '7:00 AM To 6:30 PM';
        connect2Show.Exhibit_Hall_Hours_Day_3__c = '8:00 AM To 4:00 PM';
        connect2Show.Exhibit_Hall_Hours_Day_4__c = '9:00 AM To 10:00 PM';
        connect2Show.Exhibit_Hall_Hours_Day_5__c = '9:00 AM To 10:00 PM';
        connect2Show.Opportunity_Name__c = '01453-201601-';
        connect2Show.Job_Number__c = '123456';
        connect2Show.Facility_lk__c = testAcc.Id;
        insert connect2Show;
                
        LC_Connect2ShowCreateController.isOpportunityUnique(oppObj2.Id);
        LC_Connect2ShowCreateController.isOpportunityUnique(oppObj1.Id);
        LC_Connect2ShowCreateController.getFacilityAccFields(testAcc.Id);
    }
}