/**
* @author Ethos Solutions - www.ethos.com
* @description Trigger logic for Design Request Form budget
* 2016-04-13 : Original Version
**/
public without sharing class GC_DRFBudgetTriggerHandler {
    public static void HandleBeforeInsert(List<GC_Design_Request_Form_Budget__c> drfBudgetList) {
        for (GC_Design_Request_Form_Budget__c budget : drfBudgetList) {
            if (String.isBlank(budget.Status__c) || budget.Status__c != 'New') {
                budget.Status__c = 'New';
            }
        }
    }

    public static void HandleExistingBudgetInsert(List<GC_Design_Request_Form_Budget__c> drfBudgetList) {
        Set<Id> budgetIds = new Set<Id>();
        for (GC_Design_Request_Form_Budget__c drfBudget : drfBudgetList) {
            budgetIds.add(drfBudget.Id);
        }
        List<GC_Design_Request_Form_Budget__c> budgets = [select Id, Design_Request_Form__c from GC_Design_Request_Form_Budget__c where Id in :budgetIds];
        Set<Id> drfIds = new Set<Id>();
        for (GC_Design_Request_Form_Budget__c drfBudget : budgets) {
            drfIds.add(drfBudget.Design_Request_Form__c);
        }
        List<GC_Design_Request_Form_Budget__c> existingDRFBudgets = [select Id, Name, Revision__c, Design_Request_Form__c, Design_Request_Form__r.Name from GC_Design_Request_Form_Budget__c where Id not in :budgetIds AND Design_Request_Form__c in :drfIds];
        Map<String, Set<Integer>> existingDRFBudgetMap = new Map<String, Set<Integer>>();
        for (GC_Design_Request_Form_Budget__c existingDRFBudget : existingDRFBudgets) {
            // We don't necessarily care to keep track of all existing budgets, but we want to know if the design request form has an existing budget.
            if (!existingDRFBudgetMap.containsKey(existingDRFBudget.Design_Request_Form__c)) {
                // TODO if there is any kind of status checking here.
                existingDRFBudgetMap.put(existingDRFBudget.Design_Request_Form__c, new Set<Integer>());
            }
            existingDRFBudgetMap.get(existingDRFBudget.Design_Request_Form__c).add(Integer.valueOf(existingDRFBudget.Revision__c));
        }
        for (GC_Design_Request_Form_Budget__c drfBudget : drfBudgetList) {
            if (existingDRFBudgetMap.containsKey(drfBudget.Design_Request_Form__c)) {
                Set<Integer> revisionList = existingDRFBudgetMap.get(drfBudget.Design_Request_Form__c);
                if (revisionList.contains(Integer.valueOf(drfBudget.Revision__c))) {
                    drfBudget.addError(' An existing Budget with Revision ' + drfBudget.Revision__c + ' Exists.  Once a budget is created for a Design Request Form, you can only create revisions.  If you are cloning, please choose the new Design Request Form.');
                }
                continue;
            }
        }
    }

    public static void HandleAfterInsert(List<GC_Design_Request_Form_Budget__c> drfBudgetList) {
        Set<Id> budgetIds = new Set<Id>();
        for (GC_Design_Request_Form_Budget__c drfBudget : drfBudgetList) {
            budgetIds.add(drfBudget.Id);
        }
        List<GC_Design_Request_Form_Budget__c> budgets = [select Id, Design_Request_Form__r.Connect2_Show__c from GC_Design_Request_Form_Budget__c where Id in :budgetIds];
        Set<Id> showIds = new Set<Id>();
        for (GC_Design_Request_Form_Budget__c budget : budgets) {
            showIds.Add(budget.Design_Request_Form__r.Connect2_Show__c);
        }
        List<GC_Show_Team_Member__c> showTeamMembers = [select Id, Name, User__c, Show_Role__c, Connect2_Show__c from GC_Show_Team_Member__c where Connect2_Show__c in :showIds];
        GC_ShowTeamMemberTriggerHandler.UpdateRecordAccessDRFBudget(showTeamMembers, budgets);
    }

    public static void CheckChangeOwner(Map<Id, GC_Design_Request_Form_Budget__c> oldMap, Map<Id, GC_Design_Request_Form_Budget__c> newMap) {
        List<GC_Design_Request_Form_Budget__c> recalcRecords = new List<GC_Design_Request_Form_Budget__c>();
        for (Id taskId : Trigger.newMap.keySet()) {
            if (oldMap.get(taskId).OwnerId != newMap.get(taskId).OwnerId) {
                recalcRecords.add(newMap.get(taskId));
            }
        }
        if (recalcRecords.size() > 0) {
            HandleAfterInsert(recalcRecords);
        }
    }

    public static void UpdateConnect2ShowField(List<GC_Design_Request_Form_Budget__c> drfBudgetList) {
        Set<Id> drfIds = new Set<Id>();
        for (GC_Design_Request_Form_Budget__c drfBudget : drfBudgetList) {
            drfIds.add((Id)drfBudget.Design_Request_Form__c);
        }
        List<GC_Design_Request_Form__c> drfs = [select Id, Connect2_Show__c from GC_Design_Request_Form__c where Id in :drfIds];
        Map<Id, GC_Design_Request_Form__c> drfMap = new Map<Id, GC_Design_Request_Form__c>(drfs);
        for (GC_Design_Request_Form_Budget__c drfBudget : drfBudgetList) {
            if (drfMap.containsKey(drfBudget.Design_Request_Form__c)) {
                drfBudget.Connect2_Show__c = drfMap.get(drfBudget.Design_Request_Form__c).Connect2_Show__c;
            }
        }
    }
}