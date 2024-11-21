/**
* @author Ethos Solutions - www.ethos.com
* @description Controller class for design budget calculator
* 2016-04-13 : Original Version
**/
public with sharing class GC_DesignBudgetCalculator_Controller {

    private final GC_Design_Request_Form__c drf;
    List<GC_Design_Request_Form_Budget__c> budgetList;
    public GC_Design_Request_Form_Budget__c Budget { get; private set; }
    public GC_Design_Request_Form_Budget__c Clone { get; private set; }
    public GC_Design_Request_Form_Budget__c Source {
        get {
            if (Clone != null) {
                return Clone;
            }
            else {
                return Budget;
            }
        }
    }

    public GC_DesignBudgetCalculator_Controller(ApexPages.StandardController stdController) {
        this.drf = (GC_Design_Request_Form__c)stdController.getRecord();
        budgetList = new List<GC_Design_Request_Form_Budget__c>();
        if (Budget == null) {
            queryBudget();
        }
        String isRevision = ApexPages.currentPage().getParameters().get('IsRevision');
        if (isRevision == '1') {
            Clone = Budget.clone();
            Clone.OwnerId = UserInfo.getUserId();
            Clone.Revision__c = Budget.Revision__c + 1;
            Clone.Previous_Revision__c = Budget.Id;
            Clone.Design_Request_Form__c = drf.Id;
            Clone.Status__c = 'New';
        }
    }

    public Boolean getHasBudgetAccess() {
        return Schema.SObjectType.GC_Design_Request_Form_Budget__c.isAccessible();
    }

    public Boolean getHasBudgetEditAccess() {
        return Schema.SObjectType.GC_Design_Request_Form_Budget__c.isUpdateable();
    }

    public GC_Design_Request_Form__c getDRF() {
        return drf;
    }

    public PageReference backToDRF() {
        return new PageReference('/' + drf.Id);
    }

    public Boolean getCanCreateRevision() {
        if (budget.Status__c == 'Pending' || budget.Status__c == 'Approved' || budget.Status__c == 'Rejected' || budget.Status__c == 'Archived') {
            return true;
        }
        else {
            return false;
        }
    }

    public Boolean getCanEdit() {
        if (budget.Status__c == 'New' || budget.Status__c == 'Rejected') {
            return true;
        }
        else {
            return false;
        }
    }

    public PageReference updateBudget() {
        //if (GC_ApprovalUtils.isUnderApproval(Budget.Id)) {
        //    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'The budget is currently locked from an approval process.  Please accept/reject the budget from approval.'));
        //    return null;
        //}
        if (Clone != null) {
            Budget.Status__c = 'Archived';
            Budget.Active__c = false;
            try {
                update Budget;
                insert Clone;
            }
            catch (Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error Creating Revision. ' + e.getMessage()));
                return null;
            }
            return new PageReference('/' + drf.Id);
        }
        else {
            update budget;
            queryBudget();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Design Request Form Budget has been saved but not submitted'));
            return null;
        }
    }

    public PageReference cancelBudget() {
        return new PageReference('/' + drf.Id);
    }

    public GC_Design_Request_Form_Budget__c getClone() {
        if (clone == null) {
            // Pass back clone so changes can be made without saving to actual Budget attached to DRF
            clone = Budget.clone(false, true, false, true);
            return clone;
        }
        return clone;
    }

    public PageReference getBudgetLink() {
        return new PageReference('/' + Budget.Id);
    }

    public PageReference createNewBudget() {
        budget = new GC_Design_Request_Form_Budget__c();
        budget.Design_Request_Form__c = drf.Id;
        insert budget;
        queryBudget();
        return null;
    }

    public GC_Design_Request_Form_Budget__c queryBudget() {
        budgetList = GC_DesignRequestFormBudgetDao.getInstance().getByDrfId(drf.Id);
        if (budgetList.size() > 0) {
            Budget = budgetList.get(0);
            return budgetList.get(0);
        }
        return null;
    }

    public Boolean getCanSubmitForApproval() {
        //if (Budget.OwnerId != UserInfo.getUserId()) {
        //    return false;
        //}
        if (Budget.Status__c != 'New') {
            return false;
        }

        if (GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_ACCT_MANAGER)
                || GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_SALES_MGR)
                || GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_DIRECTOR_ACCT_MGMT)
                || GC_SecurityUtil.userHasRole('System Administrator')) {
            return true;
        }
        else {
            return false;
        }
    }
}