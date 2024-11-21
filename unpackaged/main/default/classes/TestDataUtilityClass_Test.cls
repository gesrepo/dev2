@isTest
private class TestDataUtilityClass_Test
{ 
    @testSetup static void setup() {
        // Create common test opportunities
        List<Opportunity> testOptys = new List<Opportunity>();
        for(Integer i=0;i<2;i++) {
            testOptys.add(new Opportunity(Name = 'TestOpty'+i, PRF_Sent_to_CORE__c = True,Processed_in_CORE__c = false,
            Type  =  'Competitor CORE Show',stagename='Prospecting',CloseDate=date.today()));
        }
        insert testOptys;        
    }
    
    static testMethod void testOppCreation()
    {
        Opportunity opp=[select id,PRF_Sent_to_CORE__c  from Opportunity limit 1];
        TestDataUtilityClass tc=new TestDataUtilityClass();

        Test.startTest();
        tc.oppCreation(1);
        Test.stopTest();
        System.assertEquals(True,opp.PRF_Sent_to_CORE__c);
        
    }
    
      static testMethod void testRecordTypeCreation()
    {
        String obj='Opportunity';
        Test.startTest();
        TestDataUtilityClass.recordTypeCreation(obj);
        Test.stopTest();
        
    }
}