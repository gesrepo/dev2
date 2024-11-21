public class UpdateCase {
    public Case c { get; set; }
    
    public UpdateCase(ApexPages.StandardController stdController) {
        c = (Case)stdController.getRecord();
        c.Reassign_to_Onsite_Owner__c = 'Yes';
        
    }
    
    public PageReference SaveCase(){
        if(c.Delegated_Owner__C != null && c.Reassign_to_Onsite_Owner__c == 'Yes'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Delegated Owner can not populated if Reassign to On-site Owner is "Yes".'));
        	return null;
        }
        upsert c;
        return new PageReference('/'+c.Id);
    }
}