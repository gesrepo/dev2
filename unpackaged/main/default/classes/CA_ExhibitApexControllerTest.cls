@isTest
public class CA_ExhibitApexControllerTest {
    
    @testSetup
    public static void testsetupMethod(){
        LC_TestUtils.insertMainEventPersonSetObj();
    }
    
    @isTest
    public static void allTestMethod(){
               
        CA_Main_Event__c mainEvent = CA_TestDataFactory.getMainEvent(null);
        CA_Event__c parentEvent  = new CA_Event__c();
        parentEvent.Event__c= mainEvent.Id;
        parentEvent.Event_Name__c='test event';
        insert parentEvent;
        CA_Product__c tempProd= new CA_Product__c();
        tempProd.Product_Name__c ='Lobrena';
        tempProd.CA_Event__c=parentEvent.Id;
        tempProd.Event__c=mainEvent.Id;
        insert tempProd;
        CA_ExhibitApexController.getSettingObjectList('CA_Main_Event__c');
        CA_ExhibitApexController.getParntObjName(tempProd.Id);
        CA_ExhibitApexController.getPickListValues('Adjuvant');
    }
}