@isTest
public class CampaignTriggerTest {

    @isTest 
    static void test_method_one() {
        String uid = [SELECT Id FROM User WHERE Alias = 'CorpAcct' LIMIT 1].Id;
        Id TradeshowRTId = ((RecordType)[SELECT Id FROM RecordType WHERE Name = 'Sales Rep Show Occurrence' And SObjectType = 'Opportunity']).Id;
        Id FirmRTId = ((RecordType)[SELECT Id FROM RecordType WHERE Name = 'Firm' And SObjectType = 'Account']).Id;
        Id ExhibitorRTId = ((RecordType)[SELECT Id FROM RecordType WHERE Name = 'Exhibitor' And SObjectType = 'Account']).Id;

        Account acc = new Account();
        acc.Name = 'name-firm';
        acc.RecordTypeId = FirmRTId;
        acc.BillingCity = 'city';
        acc.BillingCountry = 'US';
        acc.BillingState = 'AL';
        acc.BillingPostalCode = '12345-1234';
        acc.BillingStreet = 'street';
        acc.Phone = '12345';
        insert acc;
        
        Account exh = new Account();
        exh.Name = 'name-exhibitor';
        exh.RecordTypeId = ExhibitorRTId;
        exh.BillingCity = 'city';
        exh.BillingCountry = 'US';
        exh.BillingState = 'AL';
        exh.BillingPostalCode = '12345-1234';
        exh.BillingStreet = 'street';
        exh.Phone = '12345';
        exh.Inactive__c = false;
        insert exh;     
        
        Show__c show = TestDataUtil.CreateTestShow(acc.id);
   
        Opportunity opp = new Opportunity();
        opp.RecordTypeId = TradeshowRTId;
        opp.CloseDate = date.today();
        opp.Name = 'name';
        opp.StageName = 'Closed Won';
        opp.Job_Number__c = '12345XYZ';
        opp.Amount = 1;
        opp.AccountId = acc.Id;
        opp.Show_Name__c = show.Id;
        insert opp;
        
        Campaign cmp = new Campaign();
        cmp.Status = 'In Progress';
        cmp.Name = 'name-12345xYZ';
        cmp.Opportunity__c = opp.Id;
        insert cmp;
        
        Campaign c = [select id, Exhibition_Opportunity__c from Campaign where id=: cmp.Id limit 1];
        System.assertEquals(cmp.Opportunity__c, c.Exhibition_Opportunity__c, 'Exhibition Oppty is populated from show Oppoty');
    }
}