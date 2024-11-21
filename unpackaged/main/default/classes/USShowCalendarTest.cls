@isTest    
public class USShowCalendarTest{
     
    static testMethod void MyTest2(){
   RecordType facilityRT = [Select Id, SobjectType, Name From RecordType WHERE Name = 'Facility' and SobjectType = 'Account' limit 1];
        RecordType masterShowRT = [Select Id, SobjectType, Name From RecordType WHERE DeveloperName = 'AV_CR' and SobjectType = 'Opportunity' limit 1];
        RecordType fieldSecurityRT = [Select Id from RecordType where DeveloperName = 'FieldSecurityLR' and SobjectType = 'Opportunity'];
        Account acc = new Account(
            Name = 'Auto Show',
            Phone = '212-460-6659',
            Fax = '212-888-6523',
            BillingStreet = '1201 S Figueroa St.' ,
            BillingCity = 'Los Angeles' ,
            BillingState = 'CA',
            BillingPostalCode = '90015-1308',
            NumberOfEmployees = 500,
            AnnualRevenue = 60000000);
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
            LMS_Facility_ID__c = '2ks9as',
            RecordTypeId = facilityRT.Id);
        List<Account> accList = new List<Account> {
            acc,
            facility
        };
        insert acclist;

        //Show__c show = new Show__c(Show_Id__c = 'TESTSH');
       // insert show;

        Opportunity showOpp = new Opportunity(
            Name = 'LA Auto Show',
            AccountId = acc.Id,
            Facility__c = facility.Id,
            CloseDate = System.Today(),
            Show_Close_Date__c = System.Today(),
            StageName = 'CV',
            Amount = 30000,
            Show_Start_Date_Time__c = System.Today() + 12,
            Show_End_Date_Time__c = System.Today() + 17,
            Exhibit_Hall_Hours_Day_1__c = '5:00 PM To 8:00 PM',
            Exhibit_Hall_Hours_Day_2__c = '7:00 AM To 6:30 PM',
            Exhibit_Hall_Hours_Day_3__c = '8:00 AM To 4:00 PM',
            Exhibit_Hall_Hours_Day_4__c = '9:00 AM To 10:00 PM',
            Exhibit_Hall_Hours_Day_5__c = '9:00 AM To 10:00 PM',
            Exhibitor_Move_In_Date__c = System.Today() + 11,
            RecordTypeId = fieldSecurityRT.Id,
            Prime_Contractor__c = acc.Id,
            Move_Out__c = System.Today() + 14
            );
        insert showOpp;
            List<Opportunity> opps = new List<Opportunity>();
            opps.add(showOpp);
      
       USShowCalendar usc = new USShowCalendar(new ApexPages.StandardSetController(opps));

       list<string> ss = new list<string>();
       string s1 = 'All';
       ss.add(s1);
       usc.productionLocation = ss;
       list<string> ss1 = new list<string>();
       string s2 = '1';
       ss1.add(s2);
       usc.monthValue = ss1;
       list<string> ss2 = new list<string>();
       string s3 = '2016';
       ss2.add(s3);
       usc.yearValue = ss2;
       usc.search();
       usc.clear();
       usc.exportxlsmeth();
       USShowCalendar.OpportunityWrapper upc = new USShowCalendar.OpportunityWrapper(showOpp);
    
        USShowCalendarexcelomethod.OpportunityWrapper upc1 = new USShowCalendarexcelomethod.OpportunityWrapper(showOpp);
        
    }
}