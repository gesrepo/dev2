trigger GC_ShowTeamMemberTrigger on GC_Show_Team_Member__c (after insert, after delete, after update, before insert, before update) {
    List<GC_Show_Team_Member__c> showTeamMembers = trigger.New;
    List<GC_Show_Team_Member__c> showTeamMemberOld = trigger.Old;
    if (trigger.isBefore) {
        GC_ShowTeamMemberTriggerHandler.BeforeUpdateShowName(showTeamMembers);
        GC_ShowTeamMemberTriggerHandler.TotalAMWeight(showTeamMembers,showTeamMemberOld);
        /*if(!GC_ShowTeamMemberTriggerHandler.TotalAMWeight(showTeamMembers)){
            showTeamMembers[0].AM_Weight__c.addError('Errof failed');
        }*/
        for (GC_Show_Team_Member__c checkShowTeam : trigger.New) {
            checkShowTeam.Name_Unique__c = checkShowTeam.User__c + '-' + checkShowTeam.Connect2_Show__c + '-' + checkShowTeam.Show_Role__c;
        }
        
    }
    else if (trigger.isAfter && trigger.isDelete) {
        GC_ShowTeamMemberTriggerHandler.HandleShowTeamMemberDelete(trigger.Old);
        GC_ShowTeamMemberTriggerHandler.UpdateShowTeamMemberIdsField(trigger.Old, true);
    }
    else if (trigger.isAfter && trigger.isInsert) {
        GC_ShowTeamMemberTriggerHandler.UpdateShowRecordAccess(showTeamMembers);
        GC_ShowTeamMemberTriggerHandler.UpdateShowTeamMemberIdsField(showTeamMembers, false);
        GC_ShowTeamMemberTriggerHandler.sendEmailNewShowTeamMemberAdd(showTeamMembers);
    }
    else if (trigger.isAfter && trigger.isUpdate) {
        GC_ShowTeamMemberTriggerHandler.UpdateShowRecordAccess(showTeamMembers);
        GC_ShowTeamMemberTriggerHandler.UpdateShowTeamMemberIdsField(trigger.Old, true);
        // If update, call delete with old values to clear out the previous userId then insert with the new
        GC_ShowTeamMemberTriggerHandler.UpdateShowTeamMemberIdsField(showTeamMembers, false);
    }
}