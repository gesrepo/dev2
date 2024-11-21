@isTest
public class CA_ExSchRepControllerTest { 
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
    public static void testReports(){
        
		//CA_Personalized_Object_Setting__c perSetObj01 = LC_TestUtils.insertMainEventPersonSetObj();
        CA_Personalized_Object_Setting__c perSetObj02= CA_ExSchRepController.getConnectSettings();
        CA_ExSchRepController.fetchReports('','',perSetObj02.Record_Type_ID__c);        
    }
    
}