/**
* @author Ethos Solutions - www.ethos.com
* @description Controller for Design Request Form budget approval display page
* 2016-04-13 : Original Version
**/
public with sharing class GC_DRF_BudgetApprovalController {
    public GC_Design_Request_Form_Budget__c drfB {get; set;}
    public Boolean canSubmit {get; set;}
    ApexPages.StandardController scsave;
    public String approverName {get; set;}

    public GC_DRF_BudgetApprovalController(ApexPages.StandardController sc) {
        drfB = [select Id, Name, Next_ApproverSTM__c, Status__c, Design_Request_Form__r.Connect2_Show__c, Design_Request_Form__c, OwnerId from GC_Design_Request_Form_Budget__c where Id = :sc.getId()];
        scsave = sc;
    }

    public PageReference loadAction() {
        if (drfB.OwnerId != UserInfo.getUserId()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR , 'Only the Budget owner can submit the budget for approval'));
            canSubmit = false;
            return null;
        }
        if (drfB.Status__c != 'New') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR , 'Cannot submit for approval when the Task is not New.'));
            canSubmit = false;
            return null;
        }
        List<GC_Show_Team_Member__c> stms = [select Id, Name, User__r.Name from GC_Show_Team_Member__c where Connect2_Show__c = :drfB.Design_Request_Form__r.Connect2_Show__c AND Show_Role__c = 'Director of Account Management'];
        canSubmit = true;
        if (stms.size() > 0) {
            drfB.Next_ApproverSTM__c = stms.get(0).Id;
            approverName = stms.get(0).User__r.Name;
        }
        else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR , 'Cannot submit for approval when a Director of Account Management has not been added to the show team.'));
            canSubmit = false;
        }
        return null;
    }

    public PageReference cancel() {
        return scsave.cancel();
    }

    public PageReference cancelSubmitForApproval() {
        return new PageReference('/' + drfB.Design_Request_Form__c);
    }

    public PageReference approverChanged() {
        GC_Show_Team_Member__c teamMember = [select Id, Name, User__r.Name from GC_Show_Team_Member__c where Connect2_Show__c = :drfB.Design_Request_Form__r.Connect2_Show__c AND Show_Role__c = 'Director of Account Management'];
        if (teamMember != null) {
            approverName = teamMember.User__r.Name;
        }
        return null;
    }

    public PageReference setApprover() {
        if (String.isNotBlank(drfB.Next_ApproverSTM__c)) {
            GC_Show_Team_Member__c team = [select Id, Name, User__c from GC_Show_Team_Member__c where Id = :drfB.Next_ApproverSTM__c];
            //System.debug('Approver :'+ team.Show_Team_Member__r.User__c);
            drfB.Director_AM_Approver__c = team.User__c;
            try {
                update drfB;
            }
            catch (DmlException e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR , 'Record is Currently Locked from an approval process, you must create a revision to submit.'));
                return null;
            }
            scsave.save();
        }
        //create an approval request
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval');
        req1.setObjectId(drfB.Id);
        if (String.isNotBlank(drfB.Next_ApproverSTM__c)) {
            GC_Show_Team_Member__c team = [select Id, Name, User__c from GC_Show_Team_Member__c where Id = :drfB.Next_ApproverSTM__c];
            req1.setNextApproverIds(new Id[] {team.User__c});
        }
        //submit the record to specific process and skip the criteria evaluation
        req1.setProcessDefinitionNameOrId('DRF_Budget_Approval_Process');
        //submit the approval request for the account
        Approval.ProcessResult result = Approval.process(req1);
        //verify the result
        System.assert(result.isSuccess());
        System.assertEquals(
            'Pending', result.getInstanceStatus(),
            'Instance Status' + result.getInstanceStatus());
        return new PageReference('/' + drfB.Design_Request_Form__c);
    }

    public String getUserName() {
        return UserInfo.getName();
    }

    public Boolean getCanSubmitForApproval() {
        if (GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_ACCT_MANAGER)
                || GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_SALES_MGR)
                || GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_DIRECTOR_ACCT_MGMT)
                ||  GC_SecurityUtil.userHasRole('System Administrator')) {
            return true;
        }
        else {
            return false;
        }

    }
}