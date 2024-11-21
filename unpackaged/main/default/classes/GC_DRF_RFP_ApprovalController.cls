/**
* @author Ethos Solutions - www.ethos.com
* @description Controller for Design Request Form RFP approval display page
* 2016-04-13 : Original Version
**/
public with sharing class GC_DRF_RFP_ApprovalController {
    public GC_Design_Request_Form__c drf;
    public GC_Design_Element__c de  {get; set;}
    ApexPages.StandardController scsave;

    public Profile currentUserProfile {get; set;}

    public GC_DRF_RFP_ApprovalController(ApexPages.StandardController sc) {
        currentUserProfile = [select Id, Name from Profile where Id = :UserInfo.getProfileId()];
        de = GC_DesignElementDao.getInstance().getDesignElementById(((GC_Design_Element__c)sc.getRecord()).Id);
        scsave = sc;
    }

    public PageReference cancel() {
        return scsave.cancel();
    }

    public PageReference setApprover() {
        if (de.Status__c == 'Archived') {
            GC_PageUtil.AddErrorMessage('Cannot submit for approval when the Task is Archived.');
            return null;
        }
        if (de.Status__c == 'On Hold/WFI') {
            GC_PageUtil.AddErrorMessage('Cannot submit for approval when the Task is On Hold.');
            return null;
        }
        if (String.isBlank(de.Creative_Director_Approvers__c) || String.isBlank(de.Traffic_Administrator_Approver__c)) {
            GC_PageUtil.AddErrorMessage('You must assign a Creative Director and Traffic Administrator to this task to submit for approval.');
            return null;
        }
        if (!getCanSubmitForApproval()) {
            GC_PageUtil.AddErrorMessage('This user ' + UserInfo.getName() + ' can not submit for Approval.');
            return null;
        }
        if (GC_ApprovalUtils.isUnderApproval(de.Id)) {
            GC_PageUtil.AddErrorMessage('This task is currently under approval, you must recall or exit the approval process to resubmit for approval.');
            return null;
        }
        //Commenting out 1/28/2019 fixes for DET Process
        /*if (de.OwnerId != UserInfo.getUserId()) {
            GC_PageUtil.AddErrorMessage('Only the Task owner can submit this element for approval.  Change ownership of the item to submit to approval.');
            return null;
        }*/
        else {
            List<GC_Design_Element__c> des = new List<GC_Design_Element__c>();
            des.add(de);
            GC_DesignElementTaskTriggerHandler.SetAccountManager(des);
            update des;
            de = GC_DesignElementDao.getInstance().getDesignElementById(de.Id);
            if (de.Secondary_Account_Manager__c == null) {
                de.Secondary_Account_Manager__c = de.Account_Manager__c;
                update de;
            }

            if (GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_CREATIVE_DIRECTOR) || GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_TRAFFIC_ADMIN)) {
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Submitting request for approval');
                req1.setObjectId(de.Id);
                //if (String.isNotBlank(de.Detailer_Approver__c)) {
                    //req1.setNextApproverIds(new Id[] {de.Detailer_Approver__c});  //Amarab 04062021 SAL-1243 Replacing old Designer/Detailer Approver1 field with new field
                /*if (String.isNotBlank(de.Contact_Designer_Detailer_Approver1__c)) {
                    req1.setNextApproverIds(new Id[] {de.Contact_Designer_Detailer_Approver1__c});
                }
                else {
                    GC_PageUtil.AddErrorMessage('A Detailer must be selected to be submitted for approval.');
                    return null;
                }*/ //Amarab 04062021 SAL-1243 Designer Detailer Approver assignment is now managed in Workfront  

                req1.setProcessDefinitionNameOrId('DE_Approval_Process11');
                try {
                    Approval.ProcessResult result = Approval.process(req1);
                }
                catch (Exception e) {
                    GC_PageUtil.AddErrorMessage('Failed to Submit this task for Approval: ' + e.getMessage());
                    return null;
                }
            }
            else {
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Submitting request for approval');
                req1.setObjectId(de.Id);
                List<Id> approvers = new List<Id>();
                if (String.isNotBlank(de.Creative_Director_Approvers__c)) {
                    approvers.add(de.Creative_Director_Approvers__c);
                }
                if (String.isNotBlank(de.Traffic_Administrator_Approver__c)) {
                    approvers.add(de.Traffic_Administrator_Approver__c);
                }

                req1.setNextApproverIds(approvers);
                req1.setProcessDefinitionNameOrId('DE_Approval_Process9');
                try {
                    Approval.ProcessResult result = Approval.process(req1);
                }
                catch (Exception e) {
                    GC_PageUtil.AddErrorMessage('Failed to Submit this task for Approval: ' + e.getMessage());
                    return null;
                }
            }

            return new PageReference('/' + de.Id);
        }
        return null;
    }

    public Boolean getCanSubmitForApproval() {

        if (GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_ACCT_MANAGER)
                || GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_SALES_MGR)
                || GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_CREATIVE_DIRECTOR)
                || GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_TRAFFIC_ADMIN)
                || GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_DIRECTOR_ACCT_MGMT)
                || GC_SecurityUtil.userHasRole('System Administrator')) {
            return true;
        }
        else {
            return false;
        }
    }
}