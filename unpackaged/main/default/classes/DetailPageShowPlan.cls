public class DetailPageShowPlan {
    private List<Contact> cntacts;
    private Show_Plan__c shoplan; 
    public DetailPageShowPlan(ApexPages.StandardController controller) {
        this.shoplan= (Show_Plan__c)controller.getRecord();
    }
    
    public List<Contact> getcntacts()
    {
        Show_Plan__c splan = [Select id, Show_Name__r.id FROM Show_Plan__c where id = :shoplan.id];
        if (splan.Show_Name__c == null)
         return null;

        cntacts = [Select id, Name, Title, Email, Phone from Contact 
                  Where id IN (Select Contact__c from Show_Contact__c 
                  where Show__r.id = :splan.Show_Name__r.id)];
        return cntacts;
    }
}