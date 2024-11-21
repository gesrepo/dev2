@isTest
public class GT_EventCreateControllerTest {
    
    public static Account testFac {get; set;}
    
    static TestMethod void testAllMethods() {
        Opportunity testOpp = getTestOpportunity();
        
        GC_Connect2_Show__c testShow = getTestConnect2Show();
        testShow.Opportunity_Id__c = testOpp.Id;
        update testShow;
        
        GT_EventCreateController.getFacilityRelated(testFac.Id);
        GT_EventCreateController.getShowRelated(testShow.Id);
    }
    
    static GC_Connect2_Show__c getTestConnect2Show() {        
        GC_Connect2_Show__c newShow = new GC_Connect2_Show__c();
        newShow.Opportunity_Name__c = '01453-201601-';
        newShow.Show_Name__c = 'test show';
        newShow.Show_Start_Date__c = Date.today();
        newShow.Show_End_Date__c = Date.today();
        newShow.Exhibit_Hall_Hours_Day_1__c = '5:00 PM To 8:00 PM';
        newShow.Exhibit_Hall_Hours_Day_2__c = '7:00 AM To 6:30 PM';
        newShow.Exhibit_Hall_Hours_Day_3__c = '8:00 AM To 4:00 PM';
        newShow.Exhibit_Hall_Hours_Day_4__c = '9:00 AM To 10:00 PM';
        newShow.Exhibit_Hall_Hours_Day_5__c = '9:00 AM To 10:00 PM';
        insert newShow;
        return newShow;
    }
    
    static Opportunity getTestOpportunity() {
        testFac = getTestFacilityAccount();
        
        Opportunity Opp1 = new Opportunity();
        Opp1.Job_Number__c = '201212313';        
        Opp1.OwnerId = UserInfo.getUserId();   
        Opp1.Sales_Person__c = UserInfo.getUserId();        
        Opp1.Sales_Location__c = '110- Las Vegas';        
        Opp1.Name = 'MyTestShow # 1';        
        Opp1.Prime_Contractor__c = null;        
        Opp1.Production_Location__c = '110- Las Vegas';        
        Opp1.Facility__c = testFac.Id;    
        Opp1.StageName = 'AV';        
        Opp1.Amount = 1000;        
        Opp1.Probability = 0;        
        Opp1.Type = 'ITYFTY';        
        Opp1.New_Repeat__c = 'New';        
        Opp1.Frequency__c = 'B1';  
        Opp1.RecordTypeId = SObjectType.Opportunity.getRecordTypeInfosByName().get(Properties.edProjectsRecordTypeName).getRecordTypeId();
        Opp1.Show_Open_Date__c = Date.newInstance(DateTime.now().yearGmt()-1,12,1);       
        Opp1.Show_Close_Date__c = Date.newInstance(DateTime.now().yearGmt()-1,12,2);        
        Opp1.CloseDate = Date.newInstance(DateTime.now().yearGmt()-1,12,2); 
        Opp1.Requested_Stage__c = '';
        insert Opp1;
        return Opp1;
    }
    
    static Account getTestFacilityAccount() {
        RecordType facilityRT = [Select Id, SobjectType, Name From RecordType WHERE Name = 'Facility' and SobjectType = 'Account' limit 1];
        Account facility = new Account(
            Name = 'Las Vegas Convention Center',
            Phone = '(702) 892-0711',
            Fax = '555-555-5555',
            BillingStreet = '43150 Paradise Rd.',
            BillingCity = 'Las Vegas',
            BillingState = 'NV' ,
            BillingPostalCode = '89109',
            NumberOfEmployees = 200,
            AnnualRevenue = 20000000,
            RecordTypeId = facilityRT.Id);
        insert facility;
        return facility;
    }
}