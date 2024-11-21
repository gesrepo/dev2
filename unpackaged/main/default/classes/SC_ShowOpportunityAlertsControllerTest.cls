@isTest
private class SC_ShowOpportunityAlertsControllerTest {

    @isTest static void testShowOpportunityController() {

        Opportunity opp = getTestOpportunity();
        addAlert(opp.Id);
        addAlert(opp.Id);
        addAlert(opp.Id);
        addAlert(opp.Id);
        addAlert(opp.Id);
        addAlert(opp.Id);
        addAlert(opp.Id);
        addAlert(opp.Id);
        addAlert(opp.Id);
        addAlert(opp.Id);
        addAlert(opp.Id);
        
        Case testCase = new Case();
        testCase.Show_Opportunity__c = opp.Id;
        insert testCase;

        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        SC_ShowOpportunityAlertsController controller = new SC_ShowOpportunityAlertsController(sc);

        System.assertEquals(controller.errorMessage, null);
        System.assertEquals(controller.oppAlerts.size(), 11);

        System.assertEquals(controller.getRecords().size(), 4);
        controller.getPageRange();
        controller.con.next();
        controller.con.next();
        controller.getPageRange();
    }

    @isTest static void testShowOpportunityControllerNoShow() {
        Case testCase = new Case();
        testCase.Show_Opportunity__c = null;
        insert testCase;

        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        SC_ShowOpportunityAlertsController controller = new SC_ShowOpportunityAlertsController(sc);

        System.assertEquals(controller.errorMessage, 'This case is not linked to a show opportunity.');
    }

    @isTest static void testShowOpportunityControllerNoAlerts() {
        Opportunity opp = getTestOpportunity();
        Case testCase = new Case();
        testCase.Show_Opportunity__c = opp.Id;
        insert testCase;

        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        SC_ShowOpportunityAlertsController controller = new SC_ShowOpportunityAlertsController(sc);

        System.assert(String.isNotBlank(controller.errorMessage));
    }

    public static Opportunity getTestOpportunity() {
        RecordType facilityRT = [Select Id, SobjectType, Name From RecordType WHERE Name = 'Facility' and SobjectType = 'Account' limit 1];
        RecordType contractorRT = [Select Id, SobjectType, Name From RecordType WHERE Name = 'Contractor' and SobjectType = 'Account' limit 1];
        RecordType masterShowRT = [Select Id, SobjectType, Name From RecordType WHERE Name = 'Master Show Occurrence' and SobjectType = 'Opportunity' limit 1];
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
            RecordTypeId = facilityRT.Id);
        List<Account> accList = new List<Account>();
        accList.add(acc);
        accList.add(facility);
        insert acclist;
        Opportunity opp = new Opportunity(
            Name = 'LA Auto Show',
            AccountId = acc.Id,
            Facility__c = facility.Id,
            CloseDate = System.Today() + 40,
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
            RecordTypeId = masterShowRT.Id,
            Prime_Contractor__c = acc.Id,
            Move_Out__c = System.Today() + 14);
        insert opp;
        return opp;
    }

    public static Show_Opportunity_Alert__c addAlert(String oppId) {
        Show_Opportunity_Alert__c newAlert = new Show_Opportunity_Alert__c();
        newAlert.Show_Opportunity__c = oppId;
        newAlert.Message__c = 'This is a test';
        insert newAlert;
        return newAlert;
    }
}