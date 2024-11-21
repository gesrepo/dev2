/**
* @author Ethos Solutions - www.ethos.com
* @description Controller for Design Element designer upload page
* 2016-04-13 : Original Version
**/
public with sharing class GC_DesignElementUploadController {
    public GC_Design_Element__c de {get; set;}
    ApexPages.StandardController scsave;

    public GC_DesignElementUploadController(ApexPages.StandardController sc) {
        de = GC_DesignElementDao.getInstance().getDesignElementById(sc.getId());
        scsave = sc;
    }

    public PageReference loadDesignElement() {
        if (de.Status__c == 'Accepted') {
            de.Status__c = 'Upload';
        }
        else if (de.Status__c == 'Approved') {
            de.Status__c = 'Completed';
        }
        update de;
        //scsave.save();
        return new ApexPages.StandardController(de).view();
    }
    public PageReference onHold() {
        //Requery existing record to get fields not referenced in Visualforce
        GC_Design_Element__c de2 = GC_DesignElementDao.getInstance().getDesignElementById(de.Id);
        if (de2.Status__c == 'Archived') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Can not place an archived task on hold.'));
            return null;
        }
        // Check if current user is AM or Sys Admin, otherwise return error
        Boolean hasPermissions = determineAccountManagerPermissions();

        if (!hasPermissions) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Only the Account / Sales / Directors for the associated Show may put the Design Element on hold'));
            return null;
        }

        if (de2.Status__c != 'On Hold/WFI') {
            if (!GC_ApprovalUtils.isUnderApproval(de.Id)) {
                //SAL-1293 - removed DRF logic as this is no longer required - 12/22/23 - Sajid
                //if (de.Design_Request_Form__r.Status__c == 'New' || de.Design_Request_Form__r.Status__c == 'Active') {
                    de2.Previous_Status__c = de2.Status__c;
                    de2.Status__c = 'On Hold/WFI';
                    update de2;
                //SAL-1293 - else part commented - 12/20/23 - Sajid
                /*}
                else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Design Request Form must be in the New or Active status.'));
                    return null;
                }*/
            }
            else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Can only place an object on hold if the task is not under approval.'));
                return null;
            }
        }
        else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'This record is already on hold or waiting for more information.'));
            return null;
        }

        PageReference viewPage = new ApexPages.StandardController(de).view();
        return viewPage;
    }

    public PageReference releaseHold() {
        //Requery existing record to get fields not referenced in Visualforce
        GC_Design_Element__c de2 = GC_DesignElementDao.getInstance().getDesignElementById(de.Id);
        // Check if current user is AM or Sys Admin, otherwise return error
        Boolean hasPermissions = determineAccountManagerPermissions();

        if (!hasPermissions) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Only the Account / Sales / Directors for the associated Show may release the Design Element from hold'));
            return null;
        }
        if (de2.Status__c == 'On Hold/WFI' && de2.Is_On_Hold__c == true) {
            //SAL-1293 - removed DRF logic as this is no longer required - 12/22/23 - Sajid
            //if (de.Design_Request_Form__r.Status__c == 'New' || de.Design_Request_Form__r.Status__c == 'Active') {
                de2.Status__c = de2.Previous_Status__c;
                update de2;
            //SAL-1293 - else part commented - 12/20/23 - Sajid
            /*}
            else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Design Request Form must be in the New or Active status.'));
                return null;
            }*/
        }
        else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'This record is is not on hold or waiting for information'));
            return null;
        }
        if (GC_ApprovalUtils.isUnderApproval(de.Id)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Can only release an object from hold if the task is not under approval.'));
            return null;
        }
        PageReference viewPage = new ApexPages.StandardController(de).view();
        return viewPage;
    }

    public PageReference cancel() {
        //Requery existing record to get fields not referenced in Visualforce
        GC_Design_Element__c de2 = GC_DesignElementDao.getInstance().getDesignElementById(de.Id);
        if (de2.Status__c == 'Archived') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Can not place an archived task as canceled.'));
            return null;
        }
        // Check if current user is AM or Sys Admin, otherwise return error
        Boolean hasPermissions = determineAccountManagerPermissions();

        if (!hasPermissions) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Only the Account / Sales / Directors for the associated Show can cancel the Design Element'));
            return null;
        }
        if (de2.Status__c != 'Canceled' && de.Show_Close_Date__c < Date.today()) {
            de2.Previous_Status__c = de2.Status__c;
            de2.Status__c = 'Canceled';
            update de2;
        }
        else if (de2.Status__c == 'Canceled') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Record is already canceled.'));
            return null;
        }
        else {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Design request form is not closed.')); //SAL-1293
            //return null; //SAL-1293
        }
        if (GC_ApprovalUtils.isUnderApproval(de.Id)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Can only cancel an object if the task is not under approval.'));
            return null;
        }
        PageReference viewPage = new ApexPages.StandardController(de).view();
        return viewPage;
    }

    public Boolean determineAccountManagerPermissions() {
        Boolean hasPermissions = false;
        List<Profile> profile = [SELECT Id, Name FROM Profile WHERE Id = :userinfo.getProfileId() LIMIT 1];
        String profileName = profile[0].Name;
        hasPermissions = profileName == 'System Administrator';
        if (!hasPermissions) {
            List<String> allowedShowRoles = new List<String>();
            allowedShowRoles.add('Account Manager');
            allowedShowRoles.add('Sales Manager');
            allowedShowRoles.add('Director of Account Management');
            //SAL-1293 - updated where clasue - 12/22/23 - Sajid
            //List<GC_Show_Team_Member__c> accManagers = [SELECT Id, User__c, Show_Role__c FROM GC_Show_Team_Member__c WHERE Connect2_Show__c = :de.Design_Request_Form__r.Connect2_Show__c AND Show_Role__c in :allowedShowRoles];
            List<GC_Show_Team_Member__c> accManagers = [SELECT Id, User__c, Show_Role__c FROM GC_Show_Team_Member__c WHERE Connect2_Show__c = :de.Connect2_Show__c AND Show_Role__c in :allowedShowRoles];
            for (GC_Show_Team_Member__c am : accManagers) {
                if (am.User__c == UserInfo.getUserId()) {
                    hasPermissions = true;
                }
            }
        }
        return hasPermissions;
    }
}