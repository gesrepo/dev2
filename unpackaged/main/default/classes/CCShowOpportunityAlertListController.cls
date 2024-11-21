public with sharing class CCShowOpportunityAlertListController {
    
    private ApexPages.StandardController controller;
    private final Case c;
    private List<Show_Opportunity_Alert__c> loAlerts;
    private Integer alertCount = 0;
    
    public CCShowOpportunityAlertListController(ApexPages.StandardController stdController)
    {
        controller = stdController;
        this.c = (Case)stdController.getRecord();
        
        if (this.c != null && this.c.Id != null) {
        	
	        Case TheCase = [Select Id, Show_Opportunity__c From Case Where Id = :this.c.Id];
	    	
	    	loAlerts= new List<Show_Opportunity_Alert__c>();
	    	
	    	if (TheCase != null) {
		    	if (TheCase.Show_Opportunity__c != null)
		    	{
		    		loAlerts = [SELECT Id, Name, Message__c, LastModifiedDate FROM Show_Opportunity_Alert__c WHERE Show_Opportunity__c = :TheCase.Show_Opportunity__c And IsActive__c = True ORDER BY Order__c];
		    		this.alertCount = loAlerts.size();
		    	}
	    	}
        }
     
    }
    
    public List<Show_Opportunity_Alert__c> getShowOpportunityAlerts() {
        return loAlerts;
    }    
        
	public Boolean getAlertsAvailable()
	{
		return (this.alertCount > 0 ? true : false);
	}

}