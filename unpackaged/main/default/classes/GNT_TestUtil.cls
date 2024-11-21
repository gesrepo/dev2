/**
* @author Brian Lau
* @version 1.0
* @description COMPONENT: GNT (GES New/Repeat Trigger)
*              CLASS: GNT_TestUtil
*              PURPOSE: Test utility class
*              CREATED: 08/2016 Ethos Solutions - www.ethos.com
**/
@isTest
public class GNT_TestUtil {

    public static List<Opportunity> createTestOpportunity(Integer numOfOpportunities) {
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

        Show__c show = new Show__c(Show_Id__c = 'TESTSH');
        insert show;

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
            Move_Out__c = System.Today() + 14,
            Show_Name__c = show.Id);
        insert showOpp;

        List<Opportunity> opps = new List<Opportunity>();
        for (Integer i = 0; i < numOfOpportunities; i++) {
            Opportunity opp = new Opportunity(
                Name = 'LA Auto Show',
                AccountId = acc.Id,
                Facility__c = facility.Id,
                CloseDate = System.Today() + 30,
                Show_Close_Date__c = System.Today() + 30,
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
                Move_Out__c = System.Today() + 14,
                Show_Occurrence__c = showOpp.Id);
            opps.add(opp);
        }
        return opps;
    }

    public static void createTestCustomSettings() {
        List<LOB__c> lobs = new List<LOB__c>();
        Map<String, String> rtMapping = new Map<String, String>();
        rtMapping.put('EMEA_AV', 'EMEA - AV');
        rtMapping.put('EMEA_Custom_Build', 'EMEA - Custom Build');
        rtMapping.put('EMEA_Exhibition', 'EMEA - Exhibition');
        rtMapping.put('EMEA_ADP', 'EMEA - ADP');
        rtMapping.put('E_D_Projects', 'North America - Corporate Accounts');
        rtMapping.put('E_D_Projects_Proposal', 'North America - Corporate Accounts');
        rtMapping.put('E_D_Projects_Read_Only', 'North America - Corporate Accounts');
        rtMapping.put('FieldSecurityCR', 'North America - Exhibition & Events');
        rtMapping.put('FieldSecurityCV', 'North America - Exhibition & Events');
        rtMapping.put('FieldSecurityDB', 'North America - Exhibition & Events');
        rtMapping.put('FieldSecurity_IA', 'North America - Exhibition & Events');
        rtMapping.put('FieldSecurityLO', 'North America - Exhibition & Events');
        rtMapping.put('FieldSecurityLPE', 'North America - Exhibition & Events');
        rtMapping.put('FieldSecurityLPM', 'North America - Exhibition & Events');
        rtMapping.put('FieldSecurityLR', 'North America - Exhibition & Events');
        rtMapping.put('FieldSecurity_NE', 'North America - Exhibition & Events');
        rtMapping.put('FieldSecurityPS', 'North America - Exhibition & Events');
        rtMapping.put('FieldSecurityTS', 'North America - Exhibition & Events');
        rtMapping.put('MasterShowOccurrence', 'North America - Exhibition & Events');
        rtMapping.put('SalesRepShowOccurrence', 'North America - Exhibition & Events');
        rtMapping.put('US_Housing', 'North America - Housing');
        rtMapping.put('US_Registration', 'North America - Registration');
        rtMapping.put('AV', 'North America - AV');
        rtMapping.put('AV_CR', 'North America - AV');
        rtMapping.put('AV_LO', 'North America - AV');
        rtMapping.put('AV_Master', 'North America - AV');
        rtMapping.put('AV_PO', 'North America - AV');
        rtMapping.put('AV_PS', 'North America - AV');
        rtMapping.put('AV_TS', 'North America - AV');
        rtMapping.put('AV_CV', 'North America - AV');
        rtMapping.put('AV_CC', 'North America - AV');
        rtMapping.put('AAV_DB', 'North America - AV');
        rtMapping.put('AV_IA', 'North America - AV');
        for (String rtDevName : rtMapping.keySet()) {
            lobs.add(new LOB__c(Name = rtDevName, RTDevName__c = rtDevName, Picklist_value__c = rtMapping.get(rtDevName)));
        }
        insert lobs;
    }
}