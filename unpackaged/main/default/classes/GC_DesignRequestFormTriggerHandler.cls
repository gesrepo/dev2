/**
* @author Ethos Solutions - www.ethos.com
* @description Trigger logic for Design Request Form
* 2016-04-13 : Original Version
**/
public without sharing class GC_DesignRequestFormTriggerHandler {

    public static void HandleBeforeUpdate(List<GC_Design_Request_Form__c> designRequestForms) {
        // GC-625 Removing obsolete trigger code.
        //Set<Id> drfShowIds = new Set<Id>();
        //for (GC_Design_Request_Form__c drf : designRequestForms) {
        //    drfShowIds.add(drf.Connect2_Show__c);
        //}
        //List<GC_Connect2_Show__c> showList = [SELECT Id, Show_Name__c, Show_ID__c, City_Code__c, Job_Number__c
        //                                      , Show_Month_Year__c, Facility__c, Revenue__c, Show_Dates__c
        //                                      , Last_Day_Of_Move_Out__c, Halls__c
        //                                      , Requester__c, Date_Requested__c, Requester_Phone_Number__c
        //                                      , Creative_Director__c, Design_Team__c, GES_Move_In_Date_1__c FROM GC_Connect2_Show__c WHERE Id IN :drfShowIds];
        //Map<Id, GC_Connect2_Show__c> showMap = new Map<Id, GC_Connect2_Show__c>(showList);
        //for (GC_Design_Request_Form__c drfLoop : designRequestForms) {
        //    if (showMap.containsKey(drfLoop.Connect2_Show__c)) {
        //        GC_Connect2_Show__c show = showMap.get(drfLoop.Connect2_Show__c);

        //        if (drfLoop.RecordType_Name__c != 'RFP (Exhibition or Event)') {
        //            drfLoop.DRF_Show_Name__c = show.Show_Name__c;
        //            drfLoop.DRF_Show_ID__c = show.Show_ID__c;
        //            drfLoop.DRF_Job_Number__c = show.Job_Number__c;
        //            drfLoop.DRF_Show_Month_And_Year__c = show.Show_Month_Year__c;
        //            drfLoop.Facility__c = show.Facility__c;

        //            try {
        //                drfLoop.DRF_Revenue__c = show.Revenue__c;
        //                drfLoop.City_Code__c = show.City_Code__c;
        //                //drfLoop.Last_Year_s_Job_Number__c = show.Last_Year_s_Job_Number__c;
        //                drfLoop.Last_Day_of_Move_Out__c = show.Last_Day_Of_Move_Out__c;
        //                drfLoop.Move_In_Date__c = show.GES_Move_In_Date_1__c;
        //            }
        //            catch (Exception e) {
        //                System.debug(e.getMessage());
        //            }

        //            drfLoop.DRF_Show_Dates__c = show.Show_Dates__c;
        //            drfLoop.Hall__c = show.Halls__c;
        //            drfLoop.Requesters__c = show.Requester__c;
        //            drfLoop.DRF_Requester_Phone_Number__c = show.Requester_Phone_Number__c;
        //            drfLoop.Creative_Director__c = show.Creative_Director__c;
        //            drfLoop.Design_Team__c = show.Design_Team__c;
        //        }
        //        else {
        //            // For RFP record type, only populate show dates if user didn't enter it in.
        //            if (String.isBlank(drfLoop.DRF_Show_Dates__c)) drfLoop.DRF_Show_Dates__c = show.Show_Dates__c;
        //            if (String.isBlank(drfLoop.DRF_Job_Number__c)) drfLoop.DRF_Job_Number__c = show.Job_Number__c;
        //            if (String.isBlank(drfLoop.DRF_Show_Name__c)) drfLoop.DRF_Show_Name__c = show.Show_Name__c;
        //            if (String.isBlank(drfLoop.DRF_Show_ID__c)) drfLoop.DRF_Show_ID__c = show.Show_ID__c;

        //        }
        //    }
        //}
    }

    public static void HandleShowTeamRecordAccess(List<GC_Design_Request_Form__c> designRequestForms) {
        Set<String> showIds = new Set<String>();
        for (GC_Design_Request_Form__c drf : designRequestForms) {
            showIds.add((String)drf.Connect2_Show__c);
        }
        List<GC_Show_Team_Member__c> showTeamMembers = [select Id, Name, User__c, Show_Role__c, Connect2_Show__c from GC_Show_Team_Member__c where Connect2_Show__c in :showIds];
        GC_ShowTeamMemberTriggerHandler.UpdateShowRecordAccess(showTeamMembers);
    }

    public static void CheckMoreThanOneDRF(List<GC_Design_Request_Form__c> designRequestForms) {
        for (GC_Design_Request_Form__c drf : designRequestForms) {
            List<GC_Design_Request_Form__c> existingDRF = [Select Id From GC_Design_Request_Form__c Where Connect2_Show__c = :drf.Connect2_Show__c];
            if (existingDRF.size() > 0) {
                drf.Connect2_Show__c.addError('This show already has a DRF attached to it');
            }
        }
    }

    public static void HandleCancelActionTrigger(List<GC_Design_Request_Form__c> designRequestForms) {
        Set<Id> drfShowIds = new Set<Id>();
        Set<Id> drfIds = new Set<Id>();

        for (GC_Design_Request_Form__c drf : designRequestForms) {
            drfShowIds.add(drf.Connect2_Show__c);
            drfIds.add(drf.Id);
        }
        List<GC_Connect2_Show__c> showList = [SELECT Id, Name FROM GC_Connect2_Show__c WHERE Id IN :drfShowIds];
        List<GC_Design_Element__c> elementList = [SELECT Id, Name, Status__c, Design_Request_Form__c FROM GC_Design_Element__c WHERE Design_Request_Form__c IN :drfIds];

        Map<Id, List<GC_Design_Element__c>> deDrfMap = new Map<Id, List<GC_Design_Element__c>>();

        for (GC_Design_Element__c de : elementList) {
            if (!deDrfMap.containsKey(de.Design_Request_Form__c)) {
                deDrfMap.put(de.Design_Request_Form__c, new List<GC_Design_Element__c>());
            }
            deDrfMap.get(de.Design_Request_Form__c).add(de);
        }
        Map<Id, GC_Design_Element__c> elementMap = new Map<Id, GC_Design_Element__c>(elementList);

        for (GC_Design_Request_Form__c drfLoop : designRequestForms) {
            if (drfLoop.Status__c == 'Canceled' && Userinfo.getUserId() != drfLoop.Requester_User__c) {
                drfLoop.addError(' Only assigned requester user can cancel a design request form');
            }
            else if (drfLoop.Status__c == 'Canceled') {
                Boolean hasApprovedOrClosedStatus = false;

                for (GC_Design_Element__c de : deDrfMap.get(drfLoop.Id)) {
                    if (de.Status__c == 'Approved' || de.Status__c == 'Closed') {
                        hasApprovedOrClosedStatus = true;
                        break;
                    }
                }
                if (hasApprovedOrClosedStatus) {
                    drfLoop.addError(' Cannot cancel a DRF when 1 or more design element tasks have the status of approved or closed');
                }
            }
        }
    }

    public static void DetermineRequester(Map<Id, GC_Design_Request_Form__c> oldMap, Map<Id, GC_Design_Request_Form__c> newMap) {
        List<GC_Design_Request_Form__c> drfs = new List<GC_Design_Request_Form__c>();
        for (Id drfId : newMap.keySet()) {
            if (oldMap.get(drfId).Requester_User__c != newMap.get(drfId).Requester_User__c) {
                drfs.add(newMap.get( drfId ));
            }
            else if (oldMap.get(drfId).Requester_Secondary_User__c != newMap.get(drfId).Requester_Secondary_User__c) {
                drfs.add(newMap.get( drfId ));
            }
        }
        if (drfs.size() > 0) {
            GC_DesignRequestFormTriggerHandler.HandleValidRequester(drfs);
        }
    }

    public static void HandleValidRequester(List<GC_Design_Request_Form__c> designRequestForms) {
        Set<Id> drfIdList = new Set<Id>();
        Set<Id> drfShowIds = new Set<Id>();
        Set<Id> drfUserIds = new Set<Id>();

        for (GC_Design_Request_Form__c drf : designRequestForms ) {
            drfIdList.add(drf.Id);
            drfShowIds.add(drf.Connect2_Show__c);
            drfUserIds.add(drf.Requester_User__c);
            drfUserIds.add(drf.Requester_Secondary_User__c);
        }


        Map<String, User> requestorUsers = new Map<String, User>([select Id, Name, GC_Show_Role__c, Profile.Name from User where Id in :drfUserIds]);

        List<GC_Connect2_Show__c> showList = [SELECT Id, Name FROM GC_Connect2_Show__c WHERE Id IN :drfShowIds];
        List<GC_Show_Team_Member__c> showTeamMembers = [select Id, Name, User__c, Show_Role__c, Connect2_Show__c from GC_Show_Team_Member__c where Connect2_Show__c in :drfShowIds AND User__c IN :drfUserIds];


        Map<Id, GC_Show_Team_Member__c> teamMemberMap = new Map<Id, GC_Show_Team_Member__c>();
        for ( GC_Show_Team_Member__c stm : showTeamMembers) {
            teamMemberMap.put(stm.User__c, stm);
        }

        Map<String, GC_Show_Team_Member__c> stms = new Map<String, GC_Show_Team_Member__c>();

        for ( GC_Design_Request_Form__c drfLoop : designRequestForms) {
            if (teamMemberMap.containsKey(drfLoop.Requester_User__c)) {
                stms.put(drfLoop.Requester_User__c + ',' + drfLoop.Connect2_Show__c, teamMemberMap.get(drfLoop.Requester_User__c));
            }
            else if (drfLoop.Requester_User__c != null) {
                GC_Show_Team_Member__c newMember = new GC_Show_Team_Member__c();
                newMember.User__c = drfLoop.Requester_User__c;
                newMember.Connect2_Show__c = drfLoop.Connect2_Show__c;

                if (GC_SecurityUtil.userHasRole(requestorUsers.get(drfLoop.Requester_User__c), GC_SecurityUtil.R_CREATIVE_DIRECTOR)) {
                    newMember.Show_Role__c = 'Creative Director';
                }
                else if (GC_SecurityUtil.userHasRole(requestorUsers.get(drfLoop.Requester_User__c), GC_SecurityUtil.R_TRAFFIC_ADMIN )) {
                    newMember.Show_Role__c = 'Traffic Administrator';
                }
                else if (GC_SecurityUtil.userHasRole(requestorUsers.get(drfLoop.Requester_User__c), GC_SecurityUtil.R_ACCT_MANAGER)) {
                    newMember.Show_Role__c = 'Account Manager';
                }
                else if (GC_SecurityUtil.userHasRole(requestorUsers.get(drfLoop.Requester_User__c), GC_SecurityUtil.R_SALES_MGR)) {
                    newMember.Show_Role__c = 'Account Manager';
                }
                else if (GC_SecurityUtil.userHasRole(requestorUsers.get(drfLoop.Requester_User__c), GC_SecurityUtil.R_DIRECTOR_ACCT_MGMT)) {
                    newMember.Show_Role__c = 'Director of Account Management';
                }
                else {
                    // FIXME GC-14, need a mechanism to determine what show role to give,
                    // right now we'll default all others to sales manager just so we can get it inserted.
                    // If they have the permissions set, this should insert just fine, otherwise the validation rule on show team member will kick back and show team member won't get inserted.
                    newMember.Show_Role__c = 'Sales Manager';
                }

                stms.put(drfLoop.Requester_User__c + ',' + drfLoop.Connect2_Show__c, newMember);
            }

            if (teamMemberMap.containsKey(drfLoop.Requester_Secondary_User__c)) {
                stms.put(drfLoop.Requester_Secondary_User__c + ',' + drfLoop.Connect2_Show__c, teamMemberMap.get(drfLoop.Requester_Secondary_User__c));
            }
            else if (drfLoop.Requester_Secondary_User__c != null) {
                GC_Show_Team_Member__c newMember = new GC_Show_Team_Member__c();
                newMember.User__c = drfLoop.Requester_Secondary_User__c;
                newMember.Connect2_Show__c = drfLoop.Connect2_Show__c;

                if (GC_SecurityUtil.userHasRole(requestorUsers.get(drfLoop.Requester_Secondary_User__c), GC_SecurityUtil.R_CREATIVE_DIRECTOR)) {
                    newMember.Show_Role__c = 'Creative Director';
                }
                else if (GC_SecurityUtil.userHasRole(requestorUsers.get(drfLoop.Requester_Secondary_User__c), GC_SecurityUtil.R_TRAFFIC_ADMIN)) {
                    newMember.Show_Role__c = 'Traffic Administrator';
                }
                else if (GC_SecurityUtil.userHasRole(requestorUsers.get(drfLoop.Requester_Secondary_User__c), GC_SecurityUtil.R_ACCT_MANAGER)) {
                    newMember.Show_Role__c = 'Account Manager';
                }
                else if (GC_SecurityUtil.userHasRole(requestorUsers.get(drfLoop.Requester_Secondary_User__c), GC_SecurityUtil.R_SALES_MGR)) {
                    newMember.Show_Role__c = 'Account Manager';
                }
                else if (GC_SecurityUtil.userHasRole(requestorUsers.get(drfLoop.Requester_Secondary_User__c), GC_SecurityUtil.R_DIRECTOR_ACCT_MGMT)) {
                    newMember.Show_Role__c = 'Director of Account Management';
                }
                else {
                    newMember.Show_Role__c = 'Sales Manager';
                }

                stms.put(drfLoop.Requester_Secondary_User__c + ',' + drfLoop.Connect2_Show__c, newMember);
            }

        }
        Database.upsert(stms.values(), false);

        for (GC_Design_Request_Form__c drfLoop : designRequestForms) {
            String key = drfLoop.Requester_User__c + ',' + drfLoop.Connect2_Show__c;
            String secondaryKey = drfLoop.Requester_Secondary_User__c + ',' + drfLoop.Connect2_Show__c;
            if (stms.containsKey(key)) {
                drfLoop.Requester_STM__c = stms.get(key).Id;
            }
            if (stms.containsKey(secondaryKey)) {
                drfLoop.Requester_Secondary_STM__c = stms.get(secondaryKey).Id;
            }
        }
        //update drfList;
    }

    public static void CheckChangeOwner(Map<Id, GC_Design_Request_Form__c> oldMap, Map<Id, GC_Design_Request_Form__c> newMap) {
        List<GC_Design_Request_Form__c> drfs = new List<GC_Design_Request_Form__c>();
        for (Id drfId : newMap.keySet()) {
            if (oldMap.get(drfId).OwnerId != newMap.get(drfId).OwnerId) {
                drfs.add(newMap.get( drfId ));
            }
            if (drfs.size() > 0) {
                HandleShowTeamRecordAccess(drfs);
            }
        }
    }

    public static void PopulateLastYearsJobNumber(List<GC_Design_Request_Form__c> designRequestForms) {
        Set<Id> showIds = new Set<Id>();
        for (GC_Design_Request_Form__c drf : designRequestForms) {
            showIds.add(drf.Connect2_Show__c);
        }
        List<GC_Connect2_Show__c> shows = [select Id, Name, Job_Number__c, YRMO__c, Show_ID__c, Last_Worked_YRMO_JN__c from GC_Connect2_Show__c where Id in :showIds];
        Set<String> lmsShowIds = new Set<String>();
        for (GC_Connect2_Show__c show : shows) {
            // check to see if it's already set, and if so move on, it should only be correct
            if (String.isNotBlank(show.Last_Worked_YRMO_JN__c)) {
                continue;
            }
            lmsShowIds.add(show.Show_ID__c);
        }
        List<GC_Connect2_Show__c> showsToUpdate = new List<GC_Connect2_Show__c>();

        List<GC_Connect2_Show__c> linkedShows = [select Id, Name, Job_Number__c, YRMO__c, Show_ID__c from GC_Connect2_Show__c where Show_ID__c in :lmsShowIds order by Show_ID__c desc, YRMO__c desc];
        // TODO can probably make this for loop a little more efficient by building up a map, but for the most part we're only going to be inserting / updating one design request form, so it's not that big of a deal.

        // go through each show with the same show id, and find the job numbers associated.
        for (GC_Connect2_Show__c show : shows) {
            Boolean lastShowFlag = false;
            for (GC_Connect2_Show__c linkedShow : linkedShows) {
                if (lastShowFlag) {
                    show.Last_Worked_YRMO_JN__c = linkedShow.YRMO__c + '-' + linkedShow.Job_Number__c;
                    showsToUpdate.add(show);
                    lastShowFlag = false;
                    break;
                }
                if (show.Show_ID__c == linkedShow.Show_ID__c && show.YRMO__c == linkedShow.YRMO__c) {
                    lastShowFlag = true;
                    continue;
                }
            }
        }
        update showsToUpdate;
    }
}