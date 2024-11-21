public with sharing class GC_Connect2ShowController {
    public List<GC_Show_Attribute__c> showAttributes {get; set;}
    public GC_Show_Attribute__c tempShowAtt {get; set;}
    public List<GC_Show_Team_Member__c> showMembers {get; set;}
    public GC_Connect2_Show__c show {get; set;}
    public GC_Connect2_Show__c targetShow {get; set;}
    public String cloneShowId {get; set;}
    public List<GC_ShowAttributeHolder> showAttHolders {get; set;}
    public List<GC_ShowTeamMemberHolder> stmHolders {get; set;}
    public GC_Connect2ShowController() {
    }

    public GC_Connect2ShowController(ApexPages.StandardController sc) {
        show = GC_Connect2ShowDao.getInstance().getConnect2ShowById(sc.getId());
        // show = (GC_Connect2_Show__c)sc.getRecord();
        showAttHolders = new List<GC_ShowAttributeHolder>();
        stmHolders = new List<GC_ShowTeamMemberHolder>();
        tempShowAtt = new GC_Show_Attribute__c();
        showAttributes = [SELECT Id, Name, RecordType.Name, Connect2_Show__c FROM GC_Show_Attribute__c WHERE Connect2_Show__c = :show.Id];
        showMembers = [SELECT Id, Name, Show_Name_Text__c, Show_Name__c, Show_Role__c, User__c, User_Information__c, Connect2_Show__c FROM GC_Show_Team_Member__c WHERE Connect2_Show__c = :show.Id];
        for (GC_Show_Attribute__c sa : showAttributes) {
            showAttHolders.add(new GC_ShowAttributeHolder(sa));
        }
        for (GC_Show_Team_Member__c stm : showMembers) {
            stmHolders.add( new GC_ShowTeamMemberHolder(stm));
        }
    }

    public PageReference doQuery() {
        if (String.isNotBlank(tempShowAtt.Connect2_Show__c)) {
            targetShow = GC_Connect2ShowDao.getInstance().getConnect2ShowById(tempShowAtt.Connect2_Show__c);

        }
        return null;
    }

    public PageReference cancel() {
        return new PageReference('/' + show.Id);
    }

    public PageReference itemsSelected() {
        cloneShowId = tempShowAtt.Connect2_Show__c;
        List<GC_ShowAttributeHolder> selectedShowAttribute = new List<GC_ShowAttributeHolder>();
        List<String> showAttributeIds = new List<String>();
        List<GC_ShowTeamMemberHolder> selectedShowMember = new List<GC_ShowTeamMemberHolder>();
        List<String> showMemberIds = new List<String>();
        for (GC_ShowAttributeHolder showAttHolder : showAttHolders) {
            if (showAttHolder.selected) {
                selectedShowAttribute.add(showAttHolder);
                showAttributeIds.add(showAttHolder.showAttribute.Id);
            }
        }
        for (GC_ShowTeamMemberHolder stm : stmHolders) {
            if (stm.selected) {
                selectedShowMember.add(stm);
                showMemberIds.add(stm.showTeam.Id);
            }
        }

        if (String.isBlank(cloneShowId)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR , 'Please select a show.'));
            return null;
        }
        if (String.isNotBlank(cloneShowId)) {
            if (selectedShowAttribute.size() == 0 && selectedShowMember.size() == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR , 'Please select a show attribute(s) and/or show team member(s) for selected show.'));
                return null;
            }
        }
        Savepoint sp = Database.setSavepoint();
        GC_Show_Attribute__c showAttributeClone;
        GC_Show_Team_Member__c showMemberClone;
        List<GC_Show_Attribute__c> clonedShowAttributes = new List<GC_Show_Attribute__c>();
        List<GC_Show_Attribute__c> showAttQuery = [SELECT Id, Name, RecordType.Name FROM GC_Show_Attribute__c WHERE Id In :showAttributeIds];
        List<GC_Show_Team_Member__c> clonedShowMembers = new List<GC_Show_Team_Member__c>();
        List<GC_Show_Team_Member__c> showTeamQuery = [SELECT Id, Name, Show_Name_Text__c, Show_Name__c, Show_Role__c, User__c, User_Information__c, Service_Type__c FROM GC_Show_Team_Member__c WHERe Id In :showMemberIds];
        try {
            for (GC_Show_Attribute__c selected : showAttQuery) {
                showAttributeClone = selected.clone(false);
                showAttributeClone.Connect2_Show__c = cloneShowId;
                showAttributeClone.OwnerId = UserInfo.getUserId();
                clonedShowAttributes.add(showAttributeClone);
            }
            Database.insert(clonedShowAttributes, false);
        }
        catch (Exception e) {
            Database.rollback(sp);
            GC_PageUtil.AddErrorMessage(' Failed to clone show attribute(s): ' + e.getMessage());
            return null;
        }
        try {
            for (GC_Show_Team_Member__c selectedStm : showTeamQuery) {
                showMemberClone = selectedStm.clone(false,true,false,false);
                showMemberClone.Connect2_Show__c = cloneShowId;
                showMemberClone.OwnerId = UserInfo.getUserId();
                System.debug('showMemberClone-> '+showMemberClone.Service_Type__c);
                clonedShowMembers.add(showMemberClone);
            }
            insert clonedShowMembers;
        }
        catch (Exception e) {
            Database.rollback(sp);
            GC_PageUtil.AddErrorMessage(' Failed to clone show team member(s): ' + e.getMessage());
            return null;
        }
        return new PageReference('/' + cloneShowId);
    }

    public class GC_ShowAttributeHolder {
        public Boolean selected {get; set;}
        public GC_Show_Attribute__c showAttribute {get; set;}

        public GC_ShowAttributeHolder(GC_Show_Attribute__c sa) {
            this.showAttribute = sa;
            this.selected = false;
        }
    }

    public class GC_ShowTeamMemberHolder {
        public Boolean selected {get; set;}
        public GC_Show_Team_Member__c showTeam {get; set;}

        public GC_ShowTeamMemberHolder(GC_Show_Team_Member__c stm) {
            this.showTeam = stm;
            this.selected = false;
        }
    }
}