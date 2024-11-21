public class LeadTriggerClass
{
    static testMethod void testLeadTrigger()
    {
        Lead lead  = new Lead();
        lead.FirstName = 'TEST';
        lead.LastName = 'TEST';
        lead.Company = 'TEST';
        lead.City = 'TEST';
        lead.State = 'AL';
        lead.Street = '1234 W TEST AVE';
        lead.PostalCode = '12342-0000';
        lead.Country = 'US';
        lead.Phone = '7022631500';
        insert lead;
        
        update lead;
        
        Show_Intelligence__c showIntelligence = new Show_Intelligence__c();
        showIntelligence.Lead__c = lead.Id;
        insert showIntelligence;
        
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(lead.id);
        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true
        limit 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        Database.LeadConvertResult lcr = Database.convertLead(lc);        
    }
}