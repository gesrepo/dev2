public with sharing class SC_ShowOpportunityAlertsController {

    private final Case showOpportunityCase;
    public ApexPages.StandardSetController con {get; set;}
    public transient List<Show_Opportunity_Alert__c> oppAlerts {get; set;}
    public String errorMessage {get; set;}
    public Integer pageSize {get; set;}

    public SC_ShowOpportunityAlertsController(ApexPages.StandardController stdController) {
        showOpportunityCase = [select Id, Show_Opportunity__c, Show_Opportunity__r.Name, LastModifiedDate from Case where Id = :stdController.getId()];
        if (String.isBlank(showOpportunityCase.Show_Opportunity__c)) {
            errorMessage = 'This case is not linked to a show opportunity.';
        }
        else {
            oppAlerts = [select Id, Name, CreatedBy.Name, IsActive__c, Message__c, Order__c, Show_Opportunity__c, LastModifiedDate, URL__c from Show_Opportunity_Alert__c where Show_Opportunity__c = :showOpportunityCase.Show_Opportunity__c order by Name];
            if (oppAlerts == null || oppAlerts.size() == 0) {
                errorMessage = 'The Show Opportunity ' + showOpportunityCase.Show_Opportunity__r.Name + ' does not have any alerts.';
            }
            else {
                initializeStandardSetController();
            }
        }
    }

    public void initializeStandardSetController() {
        con = new ApexPages.StandardSetController(oppAlerts);
        if (pageSize == null) {
            pageSize = 4;
        }
        con.setPageSize(pageSize);
    }

    public List<Show_Opportunity_Alert__c> getRecords() {
        return (List<Show_Opportunity_Alert__c>)con.getRecords();
    }

    public String getPageRange() {
        Integer startRecord = ((con.getPageNumber() - 1) * pageSize) + 1;
        Integer endRecord = con.getPageNumber() * pageSize;
        if (endRecord > con.getResultSize()) {
            endRecord = con.getResultSize();
        }
        return 'Displaying ' + startRecord + ' - ' + endRecord + ' of ' + con.getResultSize() + ' Alerts';
    }
}