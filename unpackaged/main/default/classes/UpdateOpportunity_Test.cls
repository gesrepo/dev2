@isTest
public without sharing class UpdateOpportunity_Test
{ 
    @testSetup static void  dataSetup()
    {
        TestDataUtilityClass testData=new TestDataUtilityClass();//Intantiating the TestDataUtil.
        testData.oppCreation(1);
        //creation of opportunity record
        
    }
    
    static testMethod void testOppCreation()
    {
        Opportunity opp=[select id,PRF_Sent_to_CORE__c  from Opportunity limit 1];
        Test.startTest();
        UpdateOpportunity.upadateOpportunity(opp.Id);
        Test.stopTest();
        Opportunity oppRecord=[select id,PRF_Sent_to_CORE__c  from Opportunity limit 1];
        System.assertEquals(True,oppRecord.PRF_Sent_to_CORE__c);
    }
}