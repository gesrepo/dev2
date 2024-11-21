/**
* @author Ethos Solutions - www.ethos.com
* @description Test code for Opportunity trigger handler
* 2016-04-13 : Original Version
**/
@isTest
public class GC_OpportunityTriggerHandlerTest {

    static testMethod void validateOpportunityUpdate() {
        
        Opportunity opp = GC_TestUtils.getTestOpportunity();
        RecordType masterShowRT = [Select Id, SobjectType, Name From RecordType WHERE Name = 'EMEA - Exhibition' and SobjectType = 'Opportunity' limit 1];
        opp.RecordTypeId = masterShowRT.Id;
        opp.SOP_Event_ID__c = 11.0;
        Test.startTest();
        update opp;
        List<Opportunity> oppList= [select RecordType_Name__c, SOP_Event_ID__c, Job_Number__c from Opportunity];
        system.debug('op==='+oppList);
        GC_OpportunityTriggerHandler.HandleOpps(oppList);
        // Re-query to get lookup fields
        opp = GC_OpportunityDao.getInstance().getOppById(opp.Id);
        Test.stopTest();

        /*GC_Connect2_Show__c show = GC_Connect2ShowDao.getInstance().getByOpportunityId(opp.Id);
        System.assertEquals(opp.Exhibit_Hall_Hours_Day_1__c, show.Exhibit_Hall_Hours_Day_1__c);
        System.assertEquals(opp.Exhibit_Hall_Hours_Day_2__c, show.Exhibit_Hall_Hours_Day_2__c);
        System.assertEquals(opp.Exhibit_Hall_Hours_Day_3__c, show.Exhibit_Hall_Hours_Day_3__c);
        System.assertEquals(opp.Exhibit_Hall_Hours_Day_4__c, show.Exhibit_Hall_Hours_Day_4__c);
        System.assertEquals(opp.Exhibit_Hall_Hours_Day_5__c, show.Exhibit_Hall_Hours_Day_5__c);
        System.assertEquals(opp.Name, show.Opportunity_Name__c);
        System.assertEquals(opp.Facility__c, show.Facility_lk__c);
        System.assertEquals(opp.LMS_Facility_ID__c, show.Facility_ID__c);*/
    }
    
    static testMethod void validateOpportunityUpdateNoShowOccurance() 
    {        
        RecordType facilityRT = [Select Id, SobjectType, Name From RecordType WHERE Name = 'Facility' and SobjectType = 'Account' limit 1];
        RecordType contractorRT = [Select Id, SobjectType, Name From RecordType WHERE Name = 'Contractor' and SobjectType = 'Account' limit 1];
        RecordType masterShowRT = [Select Id, SobjectType, Name From RecordType WHERE Name = 'E&D - Projects - Read Only' and SobjectType = 'Opportunity' limit 1];
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
            LMS_Facility_ID__c = '123456',
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
            SOP_Event_ID__c = 11.0,
            StageName = 'Closed Won',
            ED_Opportunity_Owner__c = 'Test ED Owner',
            Move_Out__c = System.Today() + 14);
        insert opp;
        Test.setCreatedDate(opp.Id, DateTime.newInstance(2012,12,12));
        
        Test.startTest();
        update opp;
        
        List<Opportunity> oppList= [select RecordType_Name__c, SOP_Event_ID__c, Job_Number__c, StageName from Opportunity];
        GC_OpportunityTriggerHandler.HandleOpps(oppList);
        system.debug('EDoppList==' +oppList);
        opp = GC_OpportunityDao.getInstance().getOppById(opp.Id);
        Test.stopTest();
    }

    static testMethod void validateOpportunityUpdateWithShowOccurance() 
    {        
        RecordType facilityRT = [Select Id, SobjectType, Name From RecordType WHERE Name = 'Facility' and SobjectType = 'Account' limit 1];
        RecordType contractorRT = [Select Id, SobjectType, Name From RecordType WHERE Name = 'Contractor' and SobjectType = 'Account' limit 1];
        RecordType masterShowRT = [Select Id, SobjectType, Name From RecordType WHERE Name = 'E&D - Projects - Read Only' and SobjectType = 'Opportunity' limit 1];
        RecordType x = [Select Id, SobjectType, Name From RecordType WHERE Name = 'Master Show Occurrence' and SobjectType = 'Opportunity' limit 1];
        Account acc = new Account(
            Name = 'Auto Show2',
            Phone = '212-460-6657',
            Fax = '212-888-6533',
            BillingStreet = '1202 S Figueroa St.' ,
            BillingCity = 'Los Angeles 2' ,
            BillingState = 'FL',
            BillingPostalCode = '90115-1308',
            NumberOfEmployees = 501,
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
            LMS_Facility_ID__c = '123456',
            AnnualRevenue = 20000000,
            RecordTypeId = facilityRT.Id);
        List<Account> accList = new List<Account>();
        accList.add(acc);
        accList.add(facility);
        insert acclist;
        Opportunity opp2 = new Opportunity(
            Name = 'LA Auto Show2',
            AccountId = acc.Id,
            Facility__c = facility.Id,
            CloseDate = System.Today() + 41,
            Amount = 30001,
            Show_Start_Date_Time__c = System.Today() + 13,
            Show_End_Date_Time__c = System.Today() + 18,
            Exhibit_Hall_Hours_Day_1__c = '6:00 PM To 8:00 PM',
            Exhibit_Hall_Hours_Day_2__c = '8:00 AM To 6:30 PM',
            Exhibit_Hall_Hours_Day_3__c = '9:00 AM To 4:00 PM',
            Exhibit_Hall_Hours_Day_4__c = '10:00 AM To 10:00 PM',
            Exhibit_Hall_Hours_Day_5__c = '11:00 AM To 10:00 PM',
            Exhibitor_Move_In_Date__c = System.Today() + 11,
            RecordTypeId = x.Id,
            Prime_Contractor__c = acc.Id,
            SOP_Event_ID__c = 12.0,
            StageName = 'Closed Won',
            ED_Opportunity_Owner__c = 'Test ED Owner2',
            Move_Out__c = System.Today() + 14);
        insert opp2;
        Opportunity opp = new Opportunity(
            Name = 'LA Auto Show2',
            AccountId = acc.Id,
            Facility__c = facility.Id,
            CloseDate = System.Today() + 41,
            Amount = 30001,
            Show_Start_Date_Time__c = System.Today() + 13,
            Show_End_Date_Time__c = System.Today() + 18,
            Exhibit_Hall_Hours_Day_1__c = '6:00 PM To 8:00 PM',
            Exhibit_Hall_Hours_Day_2__c = '8:00 AM To 6:30 PM',
            Exhibit_Hall_Hours_Day_3__c = '9:00 AM To 4:00 PM',
            Exhibit_Hall_Hours_Day_4__c = '10:00 AM To 10:00 PM',
            Exhibit_Hall_Hours_Day_5__c = '11:00 AM To 10:00 PM',
            Exhibitor_Move_In_Date__c = System.Today() + 11,
            RecordTypeId = masterShowRT.Id,
            Prime_Contractor__c = acc.Id,
            SOP_Event_ID__c = 12.0,
            StageName = 'Closed Won',
            ED_Opportunity_Owner__c = 'Test ED Owner2',
            Show_Occurrence__c = opp2.Id,
            Move_Out__c = System.Today() + 14);
        insert opp;
        Test.setCreatedDate(opp.Id, DateTime.newInstance(2012,12,12));
        
        Test.startTest();
        update opp;
        
        List<Opportunity> oppList= [select RecordType_Name__c, SOP_Event_ID__c, Job_Number__c, StageName from Opportunity];
        GC_OpportunityTriggerHandler.HandleOpps(oppList);
        system.debug('EDoppList==' +oppList);
        opp = GC_OpportunityDao.getInstance().getOppById(opp.Id);
        Test.stopTest();
    }


    static testMethod void testBatch() {
        Opportunity opp = GC_TestUtils.getTestOpportunity();
        opp.GES_Move_In__c = System.Today();
        update opp;

        String selectStr = GC_OpportunityDao.getInstance().getSelect('', '', null);
        GC_OpportunityToShowBatch b = new GC_OpportunityToShowBatch(selectStr);

        Test.startTest();

        Database.executeBatch(b);

        Test.stopTest();

        //GC_Connect2_Show__c show = GC_Connect2ShowDao.getInstance().getByOpportunityId(opp.Id);

        //System.assertNotEquals(null, show);
    }
}