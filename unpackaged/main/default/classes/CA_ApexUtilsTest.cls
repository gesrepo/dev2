@isTest
public class CA_ApexUtilsTest {
    
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
        //User currentUser = [select id,Name,profile.name,IsPortalEnabled FROM User Where id =: userInfo.getUserId()];
        //CA_ApexUtils.getHomeTableSettings(currentUser.profile.name,'CA_Main_Event__c',false);//GC BMS Profile
        CA_ApexUtils.getHomeTableSettings('GC BMS Profile','CA_Main_Event__c',false);
        CA_ApexUtils.getHomeTableSettings('GC BMS Profile','CA_Main_Event__c',true);
        CA_ApexUtils.getAllFields('CA_Main_Event__c');
    }
}