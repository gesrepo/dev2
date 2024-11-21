/**
* @author Ethos Solutions - www.ethos.com
* @description Controller for Design Element revision page
* 2016-04-13 : Original Version
**/
public with sharing class GC_ReviseDesignElement_Controller {

    private final GC_Design_Element__c designElement;

    public GC_ReviseDesignElement_Controller(ApexPages.StandardController stdController) {
        this.designElement = (GC_Design_Element__c)stdController.getRecord();
    }

    public PageReference createRevision() {
        //Check that user has profile that allows revisions
        List<Profile> profile = [SELECT Id, Name FROM Profile WHERE Id = :userinfo.getProfileId() LIMIT 1];
        String profileName = profile[0].Name;
        if (GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_ACCT_MANAGER) &&
            GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_SALES_MGR) &&
            GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_DIRECTOR_ACCT_MGMT) &&
            GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_CREATIVE_DIRECTOR) &&
            GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_TRAFFIC_ADMIN) &&
            GC_SecurityUtil.userHasRole('System Administrator')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'You don\'t have permissions to revise this Design Element'));
            return null;
        }
        //Requery existing record to get fields not referenced in Visualforce
        GC_Design_Element__c de = GC_DesignElementDao.getInstance().getDesignElementById(designElement.Id);
        if (!de.Active__c) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'You may only revise an active Design Element'));
            return null;
        }

        if (de.Status__c == 'New') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'You may only revise Tasks that are not New.'));
            return null;
        }
        if (GC_ApprovalUtils.isUnderApproval(de.Id)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'You may only revise Tasks that are not currently in an approval process.  Please finish the workflow or recall the approval process.'));
            return null;
        }
        // Clone current DE, parameters: (clone id, deep clone, clone timestamps, clone autonumbers)
        // GC-627 No Longer Making Clone
        //oldVersion = de.clone(false, true, false, true);
        //oldVersion.Status__c = 'Archived';
        //oldVersion.Previous_Status__c = de.Status__c;
        //oldVersion.Active__c = false;
        //oldVersion.Revised_Task__c = de.Id;

        //insert oldVersion;

        de.Revision__c = de.Revision__c + 1;
        de.Is_Revision__c = true;
        de.Status__c = 'New';
        de.Rework__c = false;
        de.Previous_Task_Instructions__c = de.Task_Instruction__c;

        try {
            update de;
        }
        catch (DmlException e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Record is currently locked from an approval process.'));
            return null;
        }
        PageReference revisionPage = new ApexPages.StandardController(de).view();
        return revisionPage;
    }

    public GC_Design_Element__c getDesignElement() {
        return designElement;
    }
}