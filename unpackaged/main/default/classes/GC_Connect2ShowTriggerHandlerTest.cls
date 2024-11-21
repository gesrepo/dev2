/**
* @author Ethos Solutions - www.ethos.com
* @description Test code for Connect2 Show trigger handler class
* 2016-04-13 : Original Version
**/
@isTest
private class GC_Connect2ShowTriggerHandlerTest {
    
    @isTest
    public static void testTriggerInsert() {
        GC_Connect2_Show__c show =  GC_TestUtils.getTestConnect2Show();
        GC_Design_Request_Form__c newDRF = GC_TestUtils.getTestDRF(show.Id);
        Test.startTest();
        GC_Design_Request_Form__c drf = new GC_Design_Request_Form__c();
        drf.Connect2_Show__c = show.Id;
        try {
            insert drf;
            System.assert(false, 'Expected a Duplicate DRF error but did not receive one.');
        }
        catch (Exception e) {
            if (!e.getMessage().contains('This show already has a DRF attached to it')) {
                System.assert(false, 'Received an unknown exception.');
            }
        }
        Test.stopTest();
    }

    @isTest
    public static void testShowTeamIds() {

        User amUser = GC_TestUtils.createUser('GC Account Manager', 'test', 'am');
        User taUser = GC_TestUtils.createUser('GC Traffic Administrator', 'test', 'ta');

        System.runAs(amUser) {
            GC_Connect2_Show__c show =  GC_TestUtils.getTestConnect2Show();
            GC_Show_Team_Member__c stm1 = new GC_Show_Team_Member__c();
            stm1.Connect2_Show__c = show.Id;
            stm1.User__c = taUser.Id;
            stm1.Show_Role__c = 'Account Manager';
            GC_Show_Team_Member__c stm2 = new GC_Show_Team_Member__c();
            stm2.Connect2_Show__c = show.Id;
            stm2.User__c = taUser.Id;
            stm2.Show_Role__c = 'Traffic Administrator';
            insert stm1;
            //insert stm2;
            show = GC_Connect2ShowDao.getInstance().getConnect2ShowById(show.Id);

            // Shouldn't be blank due to insert triggers
            System.assertNotEquals(null, show.Show_Team_Member_Ids__c);

            // Blank it out to test a different method
            show.Show_Team_Member_Ids__c = null;
            update show;
            show = GC_Connect2ShowDao.getInstance().getConnect2ShowById(show.Id);
            // testing to make sure it was blanked out
            System.assertEquals(null, show.Show_Team_Member_Ids__c);

            List<GC_Connect2_Show__c> shows = new List<GC_Connect2_Show__c>();
            shows.add(show);
            GC_Connect2ShowTriggerHandler.UpdateShowTeamMembersField(shows);
            show = GC_Connect2ShowDao.getInstance().getConnect2ShowById(show.Id);
            // now this method can be used to backfill any old data and repopulate this field needed for the show view page.
            System.assertNotEquals(null, show.Show_Team_Member_Ids__c);
        }
    }
    
    @isTest
    public static void updateKYSNoficationDateTest(){
        
        Account acc = TestDataUtil.CreateTestFirm(); 
        Opportunity opp = new Opportunity(Name='MyTestShow # 1',Job_Number__c='020121231',StageName='SL1',CloseDate = Date.newInstance(2030,12,2),AccountId=acc.Id,RecordTypeId=TestDataUtil.OpportunitySalesRepRecordTypeId);
        Database.insert(opp);
        
        GC_Connect2_Show__c newShow = new GC_Connect2_Show__c();
        newShow.Opportunity_Name__c = '01453-201601-Test1';
        newShow.Opportunity_Id__c = opp.Id;
        newShow.Show_Name__c = 'test show';
        newShow.Job_Number__c = '12345';
        newShow.Show_Start_Date__c = Date.today();
        newShow.Show_End_Date__c = Date.today();
        newShow.Know_Your_Show_Complete__c = true;
        insert newShow; 
		GC_Connect2_Show__c showRec = [select id, KYS_Notification_Date__c from GC_Connect2_Show__c where id =: newShow.Id limit 1];
		System.assertEquals(true, showRec.KYS_Notification_Date__c != null, 'Notification date should not be null and it is set to current date and time');
    }
    
     @isTest
    public static void updateKYSFieldsTest1(){
        
        Account acc = TestDataUtil.CreateTestFirm(); 
        Opportunity opp = new Opportunity(Name='MyTestShow # 1',Job_Number__c='020121231',StageName='SL1',CloseDate = Date.newInstance(2030,12,2),AccountId=acc.Id,RecordTypeId=TestDataUtil.OpportunitySalesRepRecordTypeId);
        Database.insert(opp);
        
        GC_Connect2_Show__c newShow = new GC_Connect2_Show__c();
        newShow.Opportunity_Name__c = '01453-201601-Test1';
        newShow.Opportunity_Id__c = opp.Id;
        newShow.Show_Name__c = 'test show';
        newShow.Job_Number__c = '12345';
        newShow.Show_Start_Date__c = Date.today();
        newShow.Show_End_Date__c = Date.today();
        newShow.Know_Your_Show_Complete__c = false;
        insert newShow;
        newShow.Know_Your_Show_Complete__c = true;
        update newShow;
        GC_Connect2_Show__c showRec = [select id, KYS_Notification_Date__c from GC_Connect2_Show__c where id =: newShow.Id limit 1];
        System.assertEquals(true, showRec.KYS_Notification_Date__c != null, 'Notification date should not be null and it is set to current date and time');
    }
    
    @isTest
    public static void updateKYSFieldsTest2(){
        
        Account acc = TestDataUtil.CreateTestFirm(); 
        Opportunity opp = new Opportunity(Name='MyTestShow # 1',Job_Number__c='020121231',StageName='SL1',CloseDate = Date.newInstance(2030,12,2),AccountId=acc.Id,RecordTypeId=TestDataUtil.OpportunitySalesRepRecordTypeId);
        Database.insert(opp);
        
        GC_Connect2_Show__c newShow = new GC_Connect2_Show__c();
        newShow.Opportunity_Name__c = '01453-201601-Test1';
        newShow.Opportunity_Id__c = opp.Id;
        newShow.Show_Name__c = 'test show';
        newShow.Job_Number__c = '12345';
        newShow.Show_Start_Date__c = Date.today();
        newShow.Show_End_Date__c = Date.today();
        newShow.Additional_Comments__c = 'test';
		newShow.Know_Your_Show_Complete__c = true;
        insert newShow;
        newShow.Additional_Comments__c = 'test2';
        update newShow;
        GC_Connect2_Show__c showRec = [select id, Know_Your_Show_Complete__c from GC_Connect2_Show__c where id =: newShow.Id limit 1];
        System.assertEquals(false, showRec.Know_Your_Show_Complete__c, 'Notification date should not be null and it is set to current date and time');
    }
    
    @isTest
    public static void sendEmailToNSCTest(){
        
        Account acc = TestDataUtil.CreateTestFirm(); 
        Contact cont = new Contact(LastName='Test Contact',MobilePhone='+18606005240',Email='test@ges.com',AccountId=acc.Id);
        insert cont;
        
        Opportunity opp = new Opportunity(Name='MyTestShow # 1',Job_Number__c='020121231',StageName='SL1',CloseDate = Date.newInstance(2030,12,2),AccountId=acc.Id,RecordTypeId=TestDataUtil.OpportunitySalesRepRecordTypeId);
        Database.insert(opp);
        
        Project_Central_Setting__c pcSetting = new Project_Central_Setting__c(Email_Address__c='test@test.com.invalid');
        insert pcSetting;
        
        GC_Connect2_Show__c newShow = new GC_Connect2_Show__c();
        newShow.Opportunity_Name__c = '01453-201601-Test1';
        newShow.Opportunity_Id__c = opp.Id;
        newShow.Show_Name__c = 'test show';
        newShow.Job_Number__c = '12345';
        newShow.Show_Start_Date__c = Date.today();
        newShow.Show_End_Date__c = Date.today();
        newShow.Additional_Comments__c = 'test';
        newShow.Know_Your_Show_Complete__c = true;
        insert newShow;
    }

}