@isTest
public class GESCustomReportTest {

    public static testMethod void test1() {
        
        Opportunity exOpp = new Opportunity();
        exOpp.Name = 'Ex Opp';
        exOpp.Amount = 1000;
        exOpp.CloseDate = Date.today();
        exOpp.StageName = 'PO';
        exOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Master Show Occurrence').getRecordTypeId();
        insert exOpp;
        
        Opportunity avOpp = new Opportunity();
        avOpp.Name = 'AV Opp';
        avOpp.Amount = 1000;
        avOpp.CloseDate = Date.today();
        avOpp.StageName = 'PO';
        avOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('EMEA - AV').getRecordTypeId();
        avOpp.Show_Occurrence__c = exOpp.Id;
        insert avOpp;
        
        Opportunity hsOpp = new Opportunity();
        hsOpp.Name = 'HS Opp';
        hsOpp.Amount = 1000;
        hsOpp.CloseDate = Date.today();
        hsOpp.StageName = 'PO';
        hsOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('EMEA – Housing').getRecordTypeId();
        hsOpp.Show_Occurrence__c = exOpp.Id;
        insert hsOpp;
        
        Opportunity regOpp = new Opportunity();
        regOpp.Name = 'Reg Opp';
        regOpp.Amount = 1000;
        regOpp.CloseDate = Date.today();
        regOpp.StageName = 'PO';
        regOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('EMEA - Registration').getRecordTypeId();
        regOpp.Show_Occurrence__c = exOpp.Id;
        insert regOpp;
        
        GESCustomReportController cr = new GESCustomReportController();
        
        cr.getMyCheckboxLOBs();
        cr.getMyCheckboxStages();
        GESCustomReportController.getOpenStages();
        GESCustomReportController.getWonStages();
        GESCustomReportController.getOtherStages();
        
        GESCustomReportController.FilterWrapper fw = new GESCustomReportController.FilterWrapper();
        fw.lob = new List<String> { 'Exhibition' };
        fw.stage = new List<String> { 'PO' };
        fw.fromCurrency = 0;
        fw.toCurrency = 10000;
        
        GESCustomReportController.FilterWrapper fw2 = new GESCustomReportController.FilterWrapper();
        fw2.lob = new List<String> { 'AV' };
        fw2.stage = new List<String> { 'PO' };
        fw2.fromCurrency = 0;
        fw2.toCurrency = 10000;
        
        GESCustomReportController.FilterWrapper fw3 = new GESCustomReportController.FilterWrapper();
        fw3.lob = new List<String> { 'Registration' };
        fw3.stage = new List<String> { 'PO' };
        fw3.fromCurrency = 0;
        fw3.toCurrency = 10000;
        
        GESCustomReportController.getOpportunities(new List<GESCustomReportController.FilterWrapper> { fw, fw2, fw3 });
        
        GESCustomReportController.getOpportunitiesExport(new List<GESCustomReportController.FilterWrapper> { fw });
        
    }
    
}