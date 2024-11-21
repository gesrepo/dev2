trigger GC_ShowAttributeTrigger on GC_Show_Attribute__c (before insert, before update, after insert) {
    if (trigger.isBefore) {
        for (GC_Show_Attribute__c checkAttribute : Trigger.New) {
            checkAttribute.Name_Unique__c = checkAttribute.RecordType.Name + '-' + checkAttribute.Name + '-' + checkAttribute.Connect2_Show__c;
        }
    }
    else if (trigger.isAfter) {
        Set<Id> showIds = new Set<Id>();
        for (GC_Show_Attribute__c sa : trigger.New) {
            showIds.Add(sa.Connect2_Show__c);
        }
        List<GC_Show_Team_Member__c> showTeamMembers = [select Id, Name, User__c, Show_Role__c, Connect2_Show__c from GC_Show_Team_Member__c where Connect2_Show__c in :showIds];
        GC_ShowTeamMemberTriggerHandler.UpdateRecordAccessShowAttributes(showTeamMembers, Trigger.New);
    }
}