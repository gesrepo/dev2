trigger CampaignTrigger on Campaign (before insert, before update) {
	
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        Set<Id> setOppIds = new Set<Id>();
        for (Campaign cmp : Trigger.new) {
            if(cmp.Exhibition_Opportunity__c == null){
                cmp.Exhibition_Opportunity__c = cmp.Opportunity__c;
            }
            if(cmp.Show__c == null){
                setOppIds.add(cmp.Exhibition_Opportunity__c);
            }
        }

        if(!setOppIds.isEmpty()){
            Map<Id, Opportunity> mapOpps = new Map<Id, Opportunity>([select id,Show_Name__c from Opportunity where id IN: setOppIds]);   
            for (Campaign cmp : Trigger.new) {
                if(cmp.Show__c == null && mapOpps.containsKey(cmp.Exhibition_Opportunity__c)){
                    cmp.Show__c = mapOpps.get(cmp.Exhibition_Opportunity__c).Show_Name__c;
                }
            }
        }
    }
}