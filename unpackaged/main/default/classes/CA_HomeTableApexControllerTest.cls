@isTest
public class CA_HomeTableApexControllerTest {
    
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
        LC_TestUtils.insertMainEventPersonSetObj();
    }

    @isTest
    public static void allTestMethod(){
        CA_HomeTableApexController.getSettingObjectList();
		CA_Personalized_Object_Setting__c perSetObj = CA_TestDataFactory.getPersonSetObj('BMS Main Event','CA_Main_Event__c','GC BMS Profile');
            //[SELECT Id,Table_Columns__c,Record_Type_ID__c FROM CA_Personalized_Object_Setting__c WHERE Object_Name__c='CA_Main_Event__c' AND Profile_Name__c = 'GC BMS Profile'];
        CA_HomeTableApexController.getEventList(perSetObj.Table_Columns__c, perSetObj.Record_Type_ID__c);
    }
}