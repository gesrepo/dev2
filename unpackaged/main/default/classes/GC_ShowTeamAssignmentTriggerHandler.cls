/**
* @author Ethos Solutions - www.ethos.com
* @description Trigger logic for Show Team Assignment
* 2016-04-13 : Original Version
**/
public without sharing class GC_ShowTeamAssignmentTriggerHandler {

    public static Map<String, String> mapAccessLevel = new Map<String, String> {
        'GC_Design_Element__c,Account Manager' => 'Edit'
        , 'GC_Design_Element__c,Secondary Account Manager' => 'Edit'
        , 'GC_Design_Element__c,Director of Account Management' => 'Edit'
        , 'GC_Design_Element__c,Sales Manager' => 'Edit'
        , 'GC_Design_Element__c,Creative Director' => 'Edit'
        , 'GC_Design_Element__c,Traffic Administrator' => 'Edit'
        , 'GC_Design_Element__c,Designer' => 'Edit'
        , 'GC_Design_Element__c,Detailer' => 'Edit'
        , 'GC_Design_Element__c,Designer/Detailer' => 'Edit'
    };

    public static void UpdateTaskAccess(List<GC_Show_Team_Assignment__c> showTeamAssignments) {
        Set<Id> deIds = new Set<Id>();
        Set<String> staIds = new Set<String>();
        for (GC_Show_Team_Assignment__c assignment : showTeamAssignments) {
            if (String.isNotBlank(assignment.Design_Element__c)) {
                deIds.add(assignment.Design_Element__c);
            }
            staIds.add(assignment.Id);
        }
        List<GC_Show_Team_Assignment__c> assignments = GC_ShowTeamAssignmentDao.getInstance().getByShowTeamAssignmentIds(staIds);
        List<GC_Design_Element__c> drfElements = [select Id from GC_Design_Element__c where Id in :deIds];
        List<GC_Design_Element__Share> drfElementShares = new List<GC_Design_Element__Share>();
        for (GC_Show_Team_Assignment__c showTeamAssignment : assignments) {
            if (String.isBlank(showTeamAssignment.Design_Element__c)) {
                continue;
            }
            for (GC_Design_Element__c drfElement : drfElements) {
                if (drfElement.Id != showTeamAssignment.Design_Element__c) {
                    continue;
                }
                String mapLookup = drfElement.getSObjectType().getDescribe().getName() + ',' + showTeamAssignment.Team_Member_Role__c;
                if (!mapAccessLevel.containsKey(mapLookup)) {
                    continue;
                }
                GC_Design_Element__Share shareObject = new GC_Design_Element__Share();
                shareObject.ParentId = drfElement.Id;
                shareObject.UserOrGroupId = showTeamAssignment.Show_Team_Member__r.User__c;
                shareObject.AccessLevel = mapAccessLevel.get(mapLookup);
                drfElementShares.add(shareObject);
            }
        }
        Database.SaveResult[] saveResultDET = Database.insert(drfElementShares, false);
    }

    public static void UpdateShowTeamAssignmentUnique(List<GC_Show_Team_Assignment__c> showTeamAssignments) {
        for (GC_Show_Team_Assignment__c sta : showTeamAssignments) {
            if (String.isNotBlank(sta.Design_Element__c)) {
                sta.Show_Team_Assignment_Unique__c = sta.Design_Element__c + '.' + sta.Show_Team_Member__c;
            }
        }
    }
}