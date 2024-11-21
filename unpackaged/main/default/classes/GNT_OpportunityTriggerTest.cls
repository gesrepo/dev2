/**
* @author Brian Lau
* @version 1.0
* @description COMPONENT: GNT (GES New/Repeat Trigger)
*              CLASS: GNT_OpportunityTriggerTest
*              PURPOSE: Test class for GNT_OpportunityTrigger
*              CREATED: 08/2016 Ethos Solutions - www.ethos.com
**/
@isTest
private class GNT_OpportunityTriggerTest {

    @isTest static void testAfterInsert() {
        GNT_OpportunityTriggerHandler.runUnitTests = true;
        List<Opportunity> opps = GNT_TestUtil.createTestOpportunity(2);
        opps[1].StageName = 'TS';
        opps[1].Show_Close_Date__c = System.today() + 60;

        Test.startTest();
        insert opps;
        Test.stopTest();
        Opportunity repeatValue = [Select Id, New_Repeat__c, Show_Occurrence__c from Opportunity where Id =: opps[1].Id];
        System.assertEquals('Repeat', repeatValue.New_Repeat__c);
        opps[0].StageName = 'LR';
        update opps[0];

        Opportunity newValue = [Select Id, New_Repeat__c from Opportunity where Id =: opps[1].Id];
        System.assertEquals('New', newValue.New_Repeat__c);
    }

    @isTest static void testAfterUpdate() {
        GNT_OpportunityTriggerHandler.runUnitTests = true;

        List<Opportunity> opps = GNT_TestUtil.createTestOpportunity(1);
        insert opps;

        Test.startTest();
        Opportunity opp1 = [Select Id, Show_Occurrence__c, New_Repeat__c from Opportunity where Id =: opps[0].Id];
        System.assertEquals('New', opp1.New_Repeat__c);

        Opportunity exhibitionOpp = [Select Id from Opportunity where Id=: opp1.Show_Occurrence__c];
        exhibitionOpp.StageName = 'LR';
        update exhibitionOpp;
        Test.stopTest();

        opp1 = [Select Id, New_Repeat__c from Opportunity where Id =: opps[0].Id];
        System.assertEquals('New', opp1.New_Repeat__c);

        opp1.StageName = 'CR';
        update opp1;

    }

    @isTest static void testAfterDelete() {
        GNT_OpportunityTriggerHandler.runUnitTests = true;

        List<Opportunity> opps = GNT_TestUtil.createTestOpportunity(3);
        opps[1].Show_Close_Date__c = System.today() + 90;
        opps[2].Show_Close_Date__c = System.today() + 60;
        insert opps;

        Opportunity repeatValue = [Select Id, New_Repeat__c, Show_Occurrence__c from Opportunity where Id =: opps[1].Id];
        System.assertEquals('Repeat', repeatValue.New_Repeat__c);
        opps[2].StageName = 'LR';
        update opps[2];

        Opportunity newValue = [Select Id, New_Repeat__c from Opportunity where Id =: opps[1].Id];
        System.assertEquals('New', newValue.New_Repeat__c);

        Test.startTest();
        delete opps[2];
        newValue = [Select Id, New_Repeat__c from Opportunity where Id =: opps[1].Id];
        System.assertEquals('Repeat', newValue.New_Repeat__c);
        Test.stopTest();
    }

    //@isTest static void testFacilityIdKey() {
    //    List<Opportunity> opps = GNT_TestUtil.createTestOpportunity(2);
    //    opps[1].StageName = 'TS';
    //    opps[1].Show_Close_Date__c = System.today() + 60;
    //    opps[1].Facility__c = null;

    //    Test.startTest();
    //    insert opps;
    //    Test.stopTest();
    //    Opportunity repeatValue = [Select Id, New_Repeat__c, Show_Occurrence__c from Opportunity where Id =: opps[1].Id];
    //    System.assertEquals('New', repeatValue.New_Repeat__c);
    //    opps[1].Facility__c = opps[0].Facility__c;
    //    update opps[1];

    //    Opportunity newValue = [Select Id, New_Repeat__c from Opportunity where Id =: opps[1].Id];
    //    System.assertEquals('Repeat', newValue.New_Repeat__c);
    //}

    @isTest static void testIgnoredRecordTypes() {
        GNT_OpportunityTriggerHandler.runUnitTests = true;

        RecordType sg = [Select Id from RecordType where DeveloperName = 'Sales_Goal'];
        List<Opportunity> opps = GNT_TestUtil.createTestOpportunity(2);
        opps[1].RecordTypeId = sg.Id;
        opps[1].New_Repeat__c = 'Test';

        Test.startTest();
        insert opps;
        Test.stopTest();
        Opportunity newValue = [Select Id, New_Repeat__c, Show_Occurrence__c from Opportunity where Id =: opps[1].Id];
        System.assertEquals('Test', newValue.New_Repeat__c);
        opps[1].RecordTypeId = opps[0].RecordTypeId;
        update opps[1];

        Opportunity repeatValue = [Select Id, New_Repeat__c from Opportunity where Id =: opps[1].Id];
        System.assertEquals('Repeat', repeatValue.New_Repeat__c);
    }

}