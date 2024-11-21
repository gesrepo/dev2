public without sharing class GC_Connect2ShowCreateController {
    
    public GC_Connect2_Show__c connect2Show {get; set;}
    public List<SelectOption> productionLocations {get; set;}
    
    
    
    //public GC_Connect2ShowCreateController(ApexPages.StandardController sc) {
      //  connect2Show = new GC_Connect2_Show__c();
        
    //}
    
    public GC_Connect2ShowCreateController() { 
        connect2Show = new GC_Connect2_Show__c();
        connect2Show.StageName__c = 'CR';
        productionLocations = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResult = Opportunity.Production_Location__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)   {
            productionLocations.add(new SelectOption(f.getLabel(), f.getValue()));
        }
    }
    
    public PageReference saveAction(){
        List<GC_Connect2_Show__c> uniqueOpportunityc2s = [select Opportunity_Name__c from GC_Connect2_Show__c where Opportunity_Name__c=:connect2Show.Opportunity_Name__c];
        if(uniqueOpportunityc2s.size() > 0) {
            GC_PageUtil.AddErrorMessage('Opportunity Name should be unique');
            return null;
        }
        List<GC_Connect2_Show__c> uniuqeJobc2s = [select Job_Number__c from GC_Connect2_Show__c where Job_Number__c=:connect2Show.Job_Number__c];
        if(uniuqeJobc2s.size() > 0) {
            GC_PageUtil.AddErrorMessage('Job Number should be unique');
            return null;
        }
        try {
            upsert connect2Show;
        }
        catch (Exception e) {
            GC_PageUtil.AddErrorMessage('Error Saving the Record. ' + e.getMessage());
            return null;
        }
        PageReference viewPage = new PageReference('/' + connect2Show.Id);
        return viewPage;
    }
    
    public PageReference cancelAction(){
        try{
            String baseURL= URL.getSalesforceBaseUrl().toExternalForm()+'/a3r/o';
            PageReference pr = new PageReference(baseURL);
            return pr;
        }catch(exception e){
            system.debug('error=='+e.getMessage()+e.getStackTraceString());
            return null;
        }
    }
}