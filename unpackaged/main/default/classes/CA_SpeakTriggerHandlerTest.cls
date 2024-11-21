@isTest
public class CA_SpeakTriggerHandlerTest {

    
     @isTest
    public static void testSpeakingEngadgement(){ 
        
        CA_Manager__c manager = CA_TestDataFactory.getManager('Alita','Mathews');
        CA_Manager__c manager2 =CA_TestDataFactory.getManager('Debbie','Boncek');
        
        List<CA_Manager__c> corpAccMgr= CA_TestDataFactory.getContacts();
        
        CA_Main_Event__c mainEventObj = CA_TestDataFactory.getMainEvent('BMS Main Event');
        /*** @author Birlasoft : Devender ***/
          mainEventObj.Event_Cancelled__c =false;
            update mainEventObj;
        CA_Speaking_Engagement__c speakingEngagement = CA_TestDataFactory.getSpeakingEngadgement('CA Speaking Engagement BMS',mainEventObj.id);
 
        CA_Product__c tempProd= new CA_Product__c();
        tempProd.Speaking_Engagement__c=speakingEngagement.Id;
        tempProd.Event__c=mainEventObj.id;
        insert tempProd;
        
        
        test.startTest();
        speakingEngagement.Cancelled__c = true;
        speakingEngagement.Cancellation_Date_Time__c=DateTime.now();
        speakingEngagement.Reason_for_Cancellation__c='Product Owner Decision';
        update speakingEngagement;
        
        speakingEngagement.Cancelled__c = false;
        update speakingEngagement;
        
        delete speakingEngagement;
        test.stopTest();
    }
    

}