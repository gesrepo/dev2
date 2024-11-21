public class CasetoSQR 
{
    public Case CaseId { get; set; }
    public Case c { get; set; }
    
    public CasetoSQR(ApexPages.StandardController stdController) 
    {
        CaseId = (Case)stdController.getRecord(); 
        c = new case();
        c = [SELECT Id, GES_Type__c, Reason__c, Show_Status__c, Booth__r.BOOTH_ID__c, Send_CORE_SQR_Status__c FROM Case WHERE Id = :CaseId.Id];
        
        if(c.Booth__r.BOOTH_ID__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'CORE SQR cannot be created without a Booth. Please update the Booth and try again.'));          
        } 
    }  
    public PageReference save()
    {
        if(String.isBlank(c.Booth__r.BOOTH_ID__c))
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'CORE SQR cannot be created without a Booth. Please update the Booth and try again.')); 
            return null;         
        }
        
        if(String.isBlank(c.GES_Type__c))
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Type is mandatory.'));
            return null;
        }
        
        if(String.isBlank(c.Reason__c))
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Reason is mandatory.'));
            return null;
        }
        if(String.isBlank(c.Send_CORE_SQR_Status__c))
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Send CORE SQR Status is mandatory.'));
            return null;
        }
        
        try{
            SQRServiceClient.SQRInvoked = true;
            upsert c;
            SQRServiceClient.submitCaseSQRs(c.Id);  
        }catch(exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You do not have sufficient privileges to perform this operation. Please check with your System Administrator. To go back, press Cancel. For more details, please refer to the detailed error message here- '+e.getMessage()));
            return null;
        }
        PageReference pg = new PageReference('/'+c.Id);
        pg.setRedirect(true);
        return pg;
    } 
    public PageReference Cancel()
    {
        PageReference pg = new PageReference('/'+c.Id);
        pg.setRedirect(true);
        return pg;
    } 
}