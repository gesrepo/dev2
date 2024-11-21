trigger CampaignMemberAll on CampaignMember (before insert, before update) {

    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        UpdateCampaignMemberExhibitorAndBooth();
    }
    
    public void UpdateCampaignMemberExhibitorAndBooth() {
        
        Set<Id> campaignIds = new Set<Id>();
        Set<Id> contactIds = new Set<Id>();
        for (CampaignMember cm : Trigger.new) {
            if ((cm.Booth__c == null || cm.Exhibitor__c == null) && cm.ContactId != null) {
                campaignIds.add(cm.CampaignId);
                contactIds.add(cm.ContactId);
            }
        }
        
        Map<Id, Campaign> campaignsMap = new Map<Id, Campaign>([SELECT Exhibition_Opportunity__c FROM Campaign WHERE Id IN :campaignIds AND Show__c != NULL]);
        
        Set<Id> oppIds = new Set<Id>();
        for (Campaign c : campaignsMap.values()) {
            oppIds.add(c.Exhibition_Opportunity__c);
        }
        
        List<Oracle_Show_Booth_Contact__c> boothContacts = [SELECT Account_Id__c, Contact__c, Oracle_Show_Booth__r.Show_Occurrence__c, Oracle_Show_Booth__c FROM Oracle_Show_Booth_Contact__c WHERE Contact__c IN :contactIds AND Oracle_Show_Booth__r.Show_Occurrence__c IN :oppIds];
        Map<String, Oracle_Show_Booth_Contact__c> boothContactsMap = new Map<String, Oracle_Show_Booth_Contact__c>();
        for (Oracle_Show_Booth_Contact__c bc : boothContacts) {
            boothContactsMap.put(bc.Contact__c + '~' + bc.Oracle_Show_Booth__r.Show_Occurrence__c, bc);
        }
        
        for (CampaignMember cm : Trigger.new) {
            if ((cm.Booth__c == null || cm.Exhibitor__c == null) && cm.ContactId != null) {
                if (campaignsMap.containsKey(cm.campaignId)) {
                    string key = cm.ContactId + '~' + campaignsMap.get(cm.campaignId).Exhibition_Opportunity__c;
                    if (boothContactsMap.containsKey(key)) {
                        if (cm.Booth__c == null)
                            cm.Booth__c = boothContactsMap.get(key).Oracle_Show_Booth__c;
                        if (cm.Exhibitor__c == null)
                            cm.Exhibitor__c = boothContactsMap.get(key).Account_Id__c;
                    }
                }
            }
        }
        
    }

}