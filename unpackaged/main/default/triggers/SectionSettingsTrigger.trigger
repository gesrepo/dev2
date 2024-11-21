trigger SectionSettingsTrigger on CA_Section_Setting__c (before insert, before update) {
    
    public String fieldsOnDetailPage ='';
    public String fieldsOnEditPage ='';
    public List<CA_Section_Setting__c> updatedSectionSettings = new List<CA_Section_Setting__c>();
    
    
    for(CA_Section_Setting__c singleSection : trigger.new){
        List<String> uniqueFields = new List<String>();
        List<String> uniqueEditFields = new List<String>();
        if(singleSection.Fields_On_Detail_Page__c != null){
            uniqueFields.addAll(singleSection.Fields_On_Detail_Page__c.split(','));
            for(String field : uniqueFields){
                fieldsOnDetailPage += field.trim() + ',';
            }
        }
        if(singleSection.Fields_On_Edit_Page__c != null){
            uniqueEditFields.addAll(singleSection.Fields_On_Edit_Page__c.split(','));
            for(String field : uniqueEditFields){
                fieldsOnEditPage += field.trim() + ',';
            }
        }
        fieldsOnDetailPage.removeEnd(',');
        fieldsOnEditPage.removeEnd(',');
        singleSection.Fields_On_Detail_Page__c = fieldsOnDetailPage;
        singleSection.Fields_On_Edit_Page__c = fieldsOnEditPage;
        system.debug('singleSection.Fields_On_Detail_Page__c ==='+singleSection.Fields_On_Detail_Page__c );
        system.debug('singleSection.Fields_On_Edit_Page__c ==='+singleSection.Fields_On_Edit_Page__c );
    }
}