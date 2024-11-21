/**
* @author Ethos Solutions - www.ethos.com
* @description Controller for Design Request Form
* 2016-04-13 : Original Version
**/
public with sharing class GC_DesignRequestFormController {

    private GC_Design_Request_Form__c drf;

    public GC_DesignRequestFormController(ApexPages.StandardController stdController) {
        this.drf = (GC_Design_Request_Form__c)stdController.getRecord();
    }

    public PageReference closeDRF() {

        //Requery existing record to get fields not referenced in Visualforce
        drf = GC_DesignRequestFormDao.getInstance().getDesignRequestFormById(drf.Id);

        // Check if current user is AM or Sys Admin, otherwise return error
        Boolean hasPermissions = false;

        List<Profile> profile = [SELECT Id, Name FROM Profile WHERE Id = :userinfo.getProfileId() LIMIT 1];
        String profileName = profile[0].Name;

        if (profileName == 'System Administrator') {
            hasPermissions = true;
        }

        if (!hasPermissions) {
            List<GC_Show_Team_Member__c> accManagers = [SELECT Id, User__c, Show_Role__c FROM GC_Show_Team_Member__c WHERE Connect2_Show__c = :drf.Connect2_Show__c AND Show_Role__c = 'Account Manager'];

            for (GC_Show_Team_Member__c am : accManagers) {
                if (am.User__c == UserInfo.getUserId()) {
                    hasPermissions = true;
                }
            }
        }

        if (!hasPermissions) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Only the Account Manager for the associated Show may close the Design Request Form'));
            return null;
        }

        // Check if the show is over, else can't close the DRF
        if (drf.FormulaShowCloseDate__c > Date.today()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'You may only close this Design Request Form after the show is over'));
            return null;
        }

        drf.Status__c = 'Closed';
        update drf;

        PageReference viewPage = new ApexPages.StandardController(drf).view();
        return viewPage;
    }

    public GC_Design_Request_Form__c getDRF() {
        return drf;
    }
}