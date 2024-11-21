@isTest
public class CA_ConEvSchReportCtrlTest{
    
    @testSetup
    public static void testsetupMethod(){
        CA_Personalized_Object_Setting__c perSetObj01 = CA_TestDataFactory.getPersonSetObj('BMS Main Event','CA_Main_Event__c','GC BMS Profile');
        CA_Main_Event__c mainEvent = CA_TestDataFactory.getMainEvent(null);        
        List<CA_Manager__c> corpAccMgr= CA_TestDataFactory.getContacts();
        CA_TestDataFactory.getEventWithProduct('CA Event BMS',mainEvent.id);
        CA_TestDataFactory.getExhibit('CA Exhibit BMS',mainEvent.id);
        CA_TestDataFactory.getSponsorship('CA Sponsorship BMS',mainEvent.id);
        CA_TestDataFactory.getMeetingPlanning('CA Meeting Planning BMS',mainEvent.id);
        CA_TestDataFactory.getMeetingRoom('CA Meeting Room BMS',mainEvent.id);
        CA_TestDataFactory.getMembershipRecord(mainEvent.id);
        CA_TestDataFactory.getSpeakingEngadgement('CA Speaking Engagement BMS',mainEvent.id);
        CA_TestDataFactory.getSportingEvent(mainEvent.id);
    }
    
    @isTest
    public static void testRunReport(){
        RecordType mainEventRT = [Select Id, SobjectType, Name From RecordType WHERE Name ='BMS Main Event'  and SobjectType = 'CA_Main_Event__c' limit 1];
        CA_ConEvSchReportCtrl.runReport(mainEventRT.Id);
    }
    
    @isTest
    public static void testFetchSettings(){
        CA_ExhibitScheduleReportCtrl.fetchSettings();
        CA_Personalized_Object_Setting__c settingsObj=CA_ExhibitScheduleReportCtrl.fetchSettings();
        CA_ConEvSchReportCtrl.fetchCols(settingsObj.ExSchRep_Column_Map__c);
        
    }
}