@isTest
public class TestIntegration {
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    
    @isTest
    static void TestSchedule() 
    {
        Test.startTest();
        String jobId = System.schedule('ScheduleApexClassTest',
                                       CRON_EXP, 
                                       new scheduledIntegration());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                          FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(CRON_EXP, 
                            ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals('2022-03-15 00:00:00', 
                            String.valueOf(ct.NextFireTime));
        Test.stopTest();
    }
    

	@isTest
    static void TestBatch(){
        // Create a unique UserName
        String uniqueUserName = 'Testuser' + DateTime.now().getTime() + '@testorg.com';
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='EMEA System Administrator'];
        User u = new User(Alias = 'standt', Email='Testuser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName=uniqueUserName);
        System.runAs(u) {
            List<Field_map__c> Test_data = Test.loadData(Field_map__c.sobjectType,'Mapping');
            System.debug('Test Custom setting data --->'+Test_data);
            //insert(Test_data);
        }

        Account acc = new Account ();
        acc.name = 'Test';
        acc.BillingCountry = 'AE';
        //acc.RecordTypeId = '0124000000012Ob';
        insert acc;
        
        Opportunity oppty = new Opportunity ();
        oppty.name = 'test Oppty';
        oppty.Event_Code__c = 'CWIEME Berlin 2018';
        oppty.Token__c = 'ABCDEF';
        oppty.Last_Run_Date__c = Date.today().addDays(-1);
        oppty.AccountId = acc.Id;
        oppty.StageName = 'CR';
        oppty.CloseDate = Date.today();
        insert oppty;
        
        BatchableIntegration a = new BatchableIntegration();
        system.debug('Query result:'+[SELECT AccountId,Event_Code__c,Id,Last_Run_Date__c FROM Opportunity WHERE Id =: oppty.Id]);
        a.query = 'SELECT AccountId,Event_Code__c,Id,Last_Run_Date__c FROM Opportunity WHERE Id =\''+oppty.Id+'\'';
        a.retOpportunities=[SELECT AccountId,Event_Code__c,Id,Last_Run_Date__c FROM Opportunity WHERE Id =:oppty.Id];
        Database.executebatch(a);
    }
}