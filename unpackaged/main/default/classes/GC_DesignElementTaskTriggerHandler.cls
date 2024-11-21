/**
* @author Ethos Solutions - www.ethos.com
* @description Trigger logic for Design Element Tasks
* 2016-04-13 : Original Version
**/
public without sharing class GC_DesignElementTaskTriggerHandler {

    //public static Boolean IsExecutingBeforeInsertTrigger = false;
    //public static Boolean IsExecutingBeforeUpdateTrigger = false;
    //public static Boolean IsExecutingAfterInsertTrigger = false;
    //public static Boolean IsExecutingAfterUpdateTrigger = false;

    public static void ClearRevisionInfo(List<GC_Design_Element__c> designElementTasks) {
        // Reset revision number and previous revision unless isRevision flag is set, to clear out revision info from clones
        for (GC_Design_Element__c det : designElementTasks) {
            if (!det.Is_Revision__c) {
                det.Revision__c = 1;
                det.Previous_Revision__c = null;
            }
        }
    }

    public static void CheckArchivedStatus(Map<Id, GC_Design_Element__c> oldMap, Map<Id, GC_Design_Element__c> newMap) {
        for (Id deId : newMap.keySet()) {
            if (oldMap.get(deId).Status__c == 'Archived' && newMap.get(deId).Status__c == 'Archived') {
                newMap.get(deId).Status__c.addError('Changes can not be made to a record that is archived');
            }
        }
    }

    public static void CheckApprovedStatus(Map<Id, GC_Design_Element__c> oldMap, Map<Id, GC_Design_Element__c> newMap) {
        for (Id deId : newMap.keySet()) {
            //if ((oldMap.get(deId).Status__c == 'GES Approved' && newMap.get(deId).Status__c == 'GES Approved') &&  //Amarab 04062021 SAL-1243 Replace Status GES Approved to Proof Approved 
            if ((oldMap.get(deId).Status__c == 'Proof Approved' && newMap.get(deId).Status__c == 'Proof Approved') &&
                    (oldMap.get(deId).Revision__c == newMap.get(deId).Revision__c)) {
                //newMap.get(deId).Status__c.addError('Changes can not be made to a record that is GES Approved, please Revise the task');
                newMap.get(deId).Status__c.addError('Changes can not be made to a record that is Proof Approved, please Revise the task');
            }
        }
    }

    /*public static void CheckDetailer(List<GC_Design_Element__c> designElementTasks) {
        for (GC_Design_Element__c de : designElementTasks) {
            if (de.Do_DetailerCheck__c && String.isBlank(de.Detailer_Approver__c)) {
                de.AddError('The Current Approval Process Step Requires a Designer/Detailer to be assigned to the Task before Approval can be done.');
            } else {
                de.Do_DetailerCheck__c = false;
            }
        }
    }*/ //Amarab 04062021 SAL-1243 Remove check as assignment is managed in Workfront


    public static void CheckChangeOwner(Map<Id, GC_Design_Element__c> oldMap, Map<Id, GC_Design_Element__c> newMap) {
        List<GC_Design_Element__c> recalcRecords = new List<GC_Design_Element__c>();

        for (Id taskId : Trigger.newMap.keySet()) {
            if (oldMap.get(taskId).OwnerId != newMap.get(taskId).OwnerId) {
                recalcRecords.add(newMap.get(taskId));
            }
        }

        if (recalcRecords.size() > 0) {
            UpdateShowTeamAccess(recalcRecords);
            UpdateShowTeamAssignmentsAccess(recalcRecords);
        }
    }

    public static void UpdateShowTeamAccess(List<GC_Design_Element__c> designElementTasks) {
        Set<Id> detIds = new Set<Id>();

        for (GC_Design_Element__c de : designElementTasks) {
            detIds.add(de.Id);
        }

        List<GC_Design_Element__c> dets = GC_DesignElementDao.getInstance().getDesignElementByIds(detIds);
        Set<Id> showIds = new Set<Id>();

        for (GC_Design_Element__c det : dets) {
            //SAL-1293 - removed DRF reference - 12/26/23
            //showIds.Add(det.Design_Request_Form__r.Connect2_Show__c);
            showIds.Add(det.Connect2_Show__c);
        }

        List<GC_Show_Team_Member__c> showTeamMembers = [select Id, Name, User__c, Show_Role__c, Connect2_Show__c from GC_Show_Team_Member__c where Connect2_Show__c in :showIds];
        GC_ShowTeamMemberTriggerHandler.UpdateRecordAccessDesignElementTasks(showTeamMembers, dets);
    }

    public static void UpdateShowTeamAssignmentsAccess(List<GC_Design_Element__c> designElementTasks) {
        Set<Id> detIds = new Set<Id>();

        for (GC_Design_Element__c de : designElementTasks) {
            detIds.add(de.Id);
        }

        List<GC_Show_Team_Assignment__c> showTeamAssignments = [select Id, Name, Design_Element__c, Show_Team_Member__c, Team_Member_Name__c, Team_Member_Role__c from GC_Show_Team_Assignment__c where Design_Element__c in :detIds];
        GC_ShowTeamAssignmentTriggerHandler.UpdateTaskAccess(showTeamAssignments);
    }

    public static void CheckCreativeDirectorsAndDetailers(List<GC_Design_Element__c> designElementTasks) {
        Set<String> cdUserIds = new Set<String>();
        Set<String> taUserIds = new Set<String>();
        Set<String> detailerUserIds = new Set<String>();

        for (GC_Design_Element__c det : designElementTasks) {
            if (det.Creative_Director_Approvers__c != null) {
                cdUserIds.add(det.Creative_Director_Approvers__c);
            }

            if (det.Traffic_Administrator_Approver__c != null) {
                taUserIds.add(det.Traffic_Administrator_Approver__c);
            }

            /*if (det.Detailer_Approver__c != null) {
                detailerUserIds.add(det.Detailer_Approver__c);
            }*/  //Amarab 04062021 SAL-1243 Replacing old Designer/Detailer Approver1 field with new field
            
            if (det.Contact_Designer_Detailer_Approver1__c != null) {
                detailerUserIds.add(det.Contact_Designer_Detailer_Approver1__c);
            }

            if (det.Detailer_Approver2__c != null) {
                detailerUserIds.add(det.Detailer_Approver2__c);
            }

            if (det.Detailer_Approver3__c != null) {
                detailerUserIds.add(det.Detailer_Approver3__c);
            }

            if (det.Detailer_Approver4__c != null) {
                detailerUserIds.add(det.Detailer_Approver4__c);
            }

            if (det.Detailer_Approver5__c != null) {
                detailerUserIds.add(det.Detailer_Approver5__c);
            }
        }

        List<User> cdUsers = [select Id, Name, GC_Show_Role__c, Profile.Name from User where Id in :cdUserIds ];
        List<User> taUsers = [select Id, Name, GC_Show_Role__c, Profile.Name from User where Id in :taUserIds ];
        List<User> detailerUsers = [select Id, Name, GC_Show_Role__c, Profile.Name from User where Id in :detailerUserIds];
        Map<String, String> cdtaErrors = new Map<String, String>();
        Map<String, String> detailerErrors = new Map<String, String>();

        /*for (User cdUser : cdUsers) {
            if (!GC_SecurityUtil.userHasRole(cdUser, GC_SecurityUtil.R_CREATIVE_DIRECTOR)) {
                cdtaErrors.put(cdUser.Id, 'User ' + cdUser.Name + ' must have the profile GC Creative Director');
            }
        }*/  //Amarab 04062021 SAL-1243 Remove the profile restriction/check on Creative Director Approver

        for (User taUser : taUsers) {
            if (!GC_SecurityUtil.userHasRole(taUser, GC_SecurityUtil.R_TRAFFIC_ADMIN)) {
                cdtaErrors.put(taUser.Id, 'User ' + taUser.Name + ' must have the profile GC Traffic Administrator');
            }
        }
//Commenting out 1/28/2019 per Clay Lovelace-Carol Bickmore
       /*
       for (User detailerUser : detailerUsers) {
            if (!GC_SecurityUtil.userHasRole(detailerUser, GC_SecurityUtil.R_DETAILER)) {
                detailerErrors.put(detailerUser.Id, 'User ' + detailerUser.Name + ' must have the profile GC Detailer');
            }
        }
        */

        for (GC_Design_Element__c det : designElementTasks) {
            if (det.Creative_Director_Approvers__c != null && cdtaErrors.containsKey(det.Creative_Director_Approvers__c)) {
                det.Creative_Director_Approvers__c.addError(cdtaErrors.get(det.Creative_Director_Approvers__c));
            }

            if (det.Traffic_Administrator_Approver__c != null && cdtaErrors.containsKey(det.Traffic_Administrator_Approver__c)) {
                det.Traffic_Administrator_Approver__c.addError(cdtaErrors.get(det.Traffic_Administrator_Approver__c));
            }

            /*if (det.Detailer_Approver__c != null && detailerErrors.containsKey(det.Detailer_Approver__c)) {
                det.Detailer_Approver__c.addError(detailerErrors.get(det.Detailer_Approver__c));
            }*/  //Amarab 04062021 SAL-1243 Replacing old Designer/Detailer Approver1 field with new field
            
            if (det.Contact_Designer_Detailer_Approver1__c != null && detailerErrors.containsKey(det.Contact_Designer_Detailer_Approver1__c)) {
                det.Contact_Designer_Detailer_Approver1__c.addError(detailerErrors.get(det.Contact_Designer_Detailer_Approver1__c));
            }

            if (det.Detailer_Approver2__c != null && detailerErrors.containsKey(det.Detailer_Approver2__c)) {
                det.Detailer_Approver2__c.addError(detailerErrors.get(det.Detailer_Approver2__c));
            }

            if (det.Detailer_Approver3__c != null && detailerErrors.containsKey(det.Detailer_Approver3__c)) {
                det.Detailer_Approver3__c.addError(detailerErrors.get(det.Detailer_Approver3__c));
            }

            if (det.Detailer_Approver4__c != null && detailerErrors.containsKey(det.Detailer_Approver4__c)) {
                det.Detailer_Approver4__c.addError(detailerErrors.get(det.Detailer_Approver4__c));
            }

            if (det.Detailer_Approver5__c != null && detailerErrors.containsKey(det.Detailer_Approver5__c)) {
                det.Detailer_Approver5__c.addError(detailerErrors.get(det.Detailer_Approver5__c));
            }
        }
    }

    public static Set<Id> GetTeamChanges(Map<Id, GC_Design_Element__c> oldMap, Map<Id, GC_Design_Element__c> newMap) {
        Set<Id> idsToUpdate = new Set<Id>();

        for (Id deId : Trigger.newMap.keySet()) {
            if (oldMap.get(deId).Creative_Director_Approvers__c != newMap.get(deId).Creative_Director_Approvers__c) {
                idsToUpdate.add(deId);
            }

            if (oldMap.get(deId).Traffic_Administrator_Approver__c != newMap.get(deId).Traffic_Administrator_Approver__c) {
                idsToUpdate.add(deId);
            }

            /*if (oldMap.get(deId).Detailer_Approver__c != newMap.get(deId).Detailer_Approver__c) {
                idsToUpdate.add(deId);
            }*/  //Amarab 04062021 SAL-1243 Replacing old Designer/Detailer Approver1 field with new field
            
            if (oldMap.get(deId).Contact_Designer_Detailer_Approver1__c!= newMap.get(deId).Contact_Designer_Detailer_Approver1__c) {
                idsToUpdate.add(deId);
            }

            if (oldMap.get(deId).Detailer_Approver2__c != newMap.get(deId).Detailer_Approver2__c) {
                idsToUpdate.add(deId);
            }

            if (oldMap.get(deId).Detailer_Approver3__c != newMap.get(deId).Detailer_Approver3__c) {
                idsToUpdate.add(deId);
            }

            if (oldMap.get(deId).Detailer_Approver4__c != newMap.get(deId).Detailer_Approver4__c) {
                idsToUpdate.add(deId);
            }

            if (oldMap.get(deId).Detailer_Approver5__c != newMap.get(deId).Detailer_Approver5__c) {
                idsToUpdate.add(deId);
            }
        }

        return idsToUpdate;
    }



    public static void AddAssignments(Set<Id> deIds) {
        List<GC_Design_Element__c> designElementTasks = GC_DesignElementDao.getInstance().getDesignElementByIds(deIds);
        Set<String> cdUserIds = new Set<String>();
        Set<String> taUserIds = new Set<String>();
        Set<String> detailerUserIds = new Set<String>();
        Set<String> showIds = new Set<String>();
        Set<String> detIds = new Set<String>();

        for (GC_Design_Element__c det : designElementTasks) {
            if (det.Creative_Director_Approvers__c != null) {
                cdUserIds.add(det.Creative_Director_Approvers__c);
            }

            if (det.Traffic_Administrator_Approver__c != null) {
                taUserIds.add(det.Traffic_Administrator_Approver__c);
            }

            /*if (det.Detailer_Approver__c != null) {
                detailerUserIds.add(det.Detailer_Approver__c);
            }*/  //Amarab 04062021 SAL-1243 Replacing old Designer/Detailer Approver1 field with new field
            
            if (det.Contact_Designer_Detailer_Approver1__c!= null) {
                detailerUserIds.add(det.Contact_Designer_Detailer_Approver1__c);
            }

            if (det.Detailer_Approver2__c != null) {
                detailerUserIds.add(det.Detailer_Approver2__c);
            }

            if (det.Detailer_Approver3__c != null) {
                detailerUserIds.add(det.Detailer_Approver3__c);
            }

            if (det.Detailer_Approver4__c != null) {
                detailerUserIds.add(det.Detailer_Approver4__c);
            }

            if (det.Detailer_Approver5__c != null) {
                detailerUserIds.add(det.Detailer_Approver5__c);
            }

            if (String.isNotBlank(det.Connect2_Show_Formula__c)) {
                showIds.add(det.Connect2_Show_Formula__c);
            }

            detIds.add(det.Id);
        }

        List<GC_Show_Team_Member__c> stms = [select Id, Name, User__c, Connect2_Show__c, Show_Role__c from GC_Show_Team_Member__c where Connect2_Show__c in :showIds AND (User__c in :cdUserIds OR User__c in :taUserIds OR User__c in :detailerUserIds)];
        Map<String, GC_Show_Team_Member__c> stmsMap = new Map<String, GC_Show_Team_Member__c>();

        for (GC_Show_Team_Member__c stm : stms) {
            String key = (String.valueOf(stm.Connect2_Show__c).substring(0, 15) + '.' + stm.User__c).toLowerCase();

            if (!stmsMap.containsKey(key)) {
                stmsMap.put(key, stm);
            }
        }

        List<GC_Show_Team_Member__c> stmsToInsert = new List<GC_Show_Team_Member__c>();

        for (GC_Design_Element__c det : designElementTasks) {
            if (det.Creative_Director_Approvers__c == null || stmsMap.containsKey((det.Connect2_Show_Formula__c + '.' + det.Creative_Director_Approvers__c).toLowerCase())) {
            } else {
                stmsToInsert.add(new GC_Show_Team_Member__c(Connect2_Show__c = det.Connect2_Show_Formula__c, User__c = det.Creative_Director_Approvers__c, Show_Role__c = 'Creative Director'));
            }

            if (det.Traffic_Administrator_Approver__c == null || stmsMap.containsKey((det.Connect2_Show_Formula__c + '.' + det.Traffic_Administrator_Approver__c).toLowerCase())) {
            } else {
                stmsToInsert.add(new GC_Show_Team_Member__c(Connect2_Show__c = det.Connect2_Show_Formula__c, User__c = det.Traffic_Administrator_Approver__c, Show_Role__c = 'Traffic Administrator'));
            }
        }

        for (GC_Design_Element__c det : designElementTasks) {
            /*if (det.Detailer_Approver__c == null || stmsMap.containsKey((det.Connect2_Show_Formula__c + '.' + det.Detailer_Approver__c).toLowerCase()))  {
            } else {
                stmsToInsert.add(new GC_Show_Team_Member__c(Connect2_Show__c = det.Connect2_Show_Formula__c, User__c = det.Detailer_Approver__c, Show_Role__c = 'Designer/Detailer'));
            }*/  //Amarab 04062021 SAL-1243 Replacing old Designer/Detailer Approver1 field with new field
            
            if (det.Contact_Designer_Detailer_Approver1__c == null || stmsMap.containsKey((det.Connect2_Show_Formula__c + '.' + det.Contact_Designer_Detailer_Approver1__c).toLowerCase()))  {
            } else {
                stmsToInsert.add(new GC_Show_Team_Member__c(Connect2_Show__c = det.Connect2_Show_Formula__c, User__c = det.Contact_Designer_Detailer_Approver1__c, Show_Role__c = 'Designer/Detailer'));
            }

            if (det.Detailer_Approver2__c == null || stmsMap.containsKey((det.Connect2_Show_Formula__c + '.' + det.Detailer_Approver2__c).toLowerCase()))  {
            } else {
                stmsToInsert.add(new GC_Show_Team_Member__c(Connect2_Show__c = det.Connect2_Show_Formula__c, User__c = det.Detailer_Approver2__c, Show_Role__c = 'Designer/Detailer'));
            }

            if (det.Detailer_Approver3__c == null || stmsMap.containsKey((det.Connect2_Show_Formula__c + '.' + det.Detailer_Approver3__c).toLowerCase()))  {
            } else {
                stmsToInsert.add(new GC_Show_Team_Member__c(Connect2_Show__c = det.Connect2_Show_Formula__c, User__c = det.Detailer_Approver3__c, Show_Role__c = 'Designer/Detailer'));
            }

            if (det.Detailer_Approver4__c == null || stmsMap.containsKey((det.Connect2_Show_Formula__c + '.' + det.Detailer_Approver4__c).toLowerCase()))  {
            } else {
                stmsToInsert.add(new GC_Show_Team_Member__c(Connect2_Show__c = det.Connect2_Show_Formula__c, User__c = det.Detailer_Approver4__c, Show_Role__c = 'Designer/Detailer'));
            }

            if (det.Detailer_Approver5__c == null || stmsMap.containsKey((det.Connect2_Show_Formula__c + '.' + det.Detailer_Approver5__c).toLowerCase()))  {
            } else {
                stmsToInsert.add(new GC_Show_Team_Member__c(Connect2_Show__c = det.Connect2_Show_Formula__c, User__c = det.Detailer_Approver5__c, Show_Role__c = 'Designer/Detailer'));
            }
        }

        Database.Insert(stmsToInsert, false);
        // now I should have the updated users, requery.
        List<GC_Show_Team_Assignment__c> stasToInsert = new List<GC_Show_Team_Assignment__c>();
        stms = [select Id, Name, User__c, Connect2_Show__c, Show_Role__c from GC_Show_Team_Member__c where Connect2_Show__c in :showIds AND (User__c in :cdUserIds OR User__c in :taUserIds OR User__c in :detailerUserIds)];
        Map<String, RecordType> staRecordTypes = getRecordType('GC_Show_Team_Assignment__c');

        for (GC_Design_Element__c det : designElementTasks) {
            for (GC_Show_Team_Member__c stm : stms) {
                System.debug(det.Connect2_Show_Formula__c.toLowerCase());
                System.debug(String.valueOf(stm.Connect2_Show__c).substring(0, 15).toLowerCase());

                if (det.Connect2_Show_Formula__c.toLowerCase() !=  String.valueOf(stm.Connect2_Show__c).substring(0, 15).toLowerCase()) {
                    continue;
                }

                GC_Show_Team_Assignment__c sta = new GC_Show_Team_Assignment__c();
                //sta.Connect2_Show__c = stm.Connect2_Show__c;
                sta.Design_Element__c = det.Id;
                sta.Show_Team_Member__c = stm.Id;
                sta.RecordTypeId = staRecordTypes.get('Design Element Assignment').Id;
                stasToInsert.add(sta);
            }
        }

        Database.Insert(stasToInsert, false);
    }

    public static Map<String, RecordType> getRecordType(String sObjectType) {
        List<RecordType> records = [Select Id, SobjectType, Name From RecordType WHERE SobjectType = :sObjectType];
        //System.Debug(JSON.serializePretty(records));
        Map<String, RecordType> recordTypes = new Map<String, RecordType>();

        for (RecordType record : records) {
            recordTypes.put(record.Name, record);
        }

        //System.Debug(JSON.serializePretty(recordTypes));

        return recordTypes;
    }

    public static void HandleOnHoldBeforeUpdate(List<GC_Design_Element__c> designElements) {
        Set<Id> deIdList = new Set<Id>();

        for (GC_Design_Element__c de : designElements) {
            deIdList.add(de.Id);
        }

        for (GC_Design_Element__c de : designElements) {
            if (de.Status__c == 'On Hold/WFI' && de.Is_On_Hold__c == false) {
                de.Is_On_Hold__c = true;
            } else if (de.Status__c == 'On Hold/WFI' && de.Is_On_Hold__c == true) {
                de.addError(' Object has been placed on hold, no edits are allowed.');
            } else if (de.Status__c != 'On Hold/WFI' && de.Is_On_Hold__c == true) {
                de.Is_On_Hold__c = false;
            }
        }
    }

    // Commented this method - SAL-1293 - Sajid
    /*public static void SetAccountManager(List<GC_Design_Element__c> deList) {
        List<GC_Design_Element__c> designElementsNew = new List<GC_Design_Element__c>();

        for (GC_Design_Element__c de : deList) {
            if (String.isBlank(de.Account_Manager__c)) {
                designElementsNew.add(de);
            }
        }

        if (designElementsNew.size() == 0) {
            return;
        }

        Set<String> drfIds = new Set<String>();

        for (GC_Design_Element__c de : designElementsNew) {
            drfIds.add(de.Design_Request_Form__c);
        }

        List<GC_Design_Request_Form__c> drfs = GC_DesignRequestFormDao.getInstance().getDesignRequestFormByIds(drfIds);
        Set<String> showIds = new Set<String>();
        Map<String, String> showIdToDrfs = new Map<String, String>();

        for (GC_Design_Request_Form__c drf : drfs) {
            showIdToDrfs.put(drf.Id, drf.Connect2_Show__c);
            showIds.add(drf.Connect2_Show__c);
        }

        List<GC_Show_Team_Member__c> stmsTemp = [select Id, Name, Show_Role__c, User__c, Connect2_Show__c
                                                from GC_Show_Team_Member__c
                                                where (Show_Role__c = 'Account Manager' OR Show_Role__c = 'Sales Manager')
                                                AND Connect2_Show__c in :showIds
                                                order by Show_Role__c, CreatedDate desc];


        Map<String, List<String>> amsByShow = new Map<String, List<String>>();

        for (GC_Show_Team_Member__c stm : stmsTemp) {
            if (!amsByShow.containsKey(stm.Connect2_Show__c)) {
                amsByShow.put(stm.Connect2_Show__c, new List<String>());
            }
            amsByShow.get(stm.Connect2_Show__c).add(stm.User__c);
        }

        for (GC_Design_Element__c de : designElementsNew) {
            if (showIdToDrfs.containsKey(de.Design_Request_Form__c)) {
                String showId = showIdToDrfs.get(de.Design_Request_Form__c);
                if (amsByShow.containsKey(showId)) {
                    for (String userId : amsByShow.get(showId)) {
                        if (de.Account_Manager__c == null) {
                            de.Account_Manager__c = userId;
                        }

                        if (de.Secondary_Account_Manager__c == null) {
                            de.Secondary_Account_Manager__c = userId;
                        }
                    }
                }
            }

            if (de.Secondary_Account_Manager__c == null &&
                    de.Account_Manager__c != null) {
                de.Secondary_Account_Manager__c = de.Account_Manager__c;
            }
        }
    }
    */
    
    // updated this method to remove reference of DRF - SAL-1293 - Sajid
    public static void SetAccountManager(List<GC_Design_Element__c> deList) {
        List<GC_Design_Element__c> designElementsNew = new List<GC_Design_Element__c>();
        Set<String> showIds = new Set<String>();
        
        for (GC_Design_Element__c de : deList) {
            if (String.isBlank(de.Account_Manager__c)) {
                designElementsNew.add(de);
                showIds.add(de.Connect2_Show__c);
            }
        }

        if (designElementsNew.size() == 0) {
            return;
        }

        List<GC_Show_Team_Member__c> stmsTemp = [select Id, Name, Show_Role__c, User__c, Connect2_Show__c
                                                from GC_Show_Team_Member__c
                                                where (Show_Role__c = 'Account Manager' OR Show_Role__c = 'Sales Manager')
                                                AND Connect2_Show__c in :showIds
                                                order by Show_Role__c, CreatedDate desc];


        Map<String, List<String>> amsByShow = new Map<String, List<String>>();

        for (GC_Show_Team_Member__c stm : stmsTemp) {
            if (!amsByShow.containsKey(stm.Connect2_Show__c)) {
                amsByShow.put(stm.Connect2_Show__c, new List<String>());
            }
            amsByShow.get(stm.Connect2_Show__c).add(stm.User__c);
        }

        if(amsByShow != null && amsByShow.size() > 0){
            for (GC_Design_Element__c de : designElementsNew) {
                String showId = de.Connect2_Show__c;
                if (amsByShow.containsKey(showId)) {
                    for (String userId : amsByShow.get(showId)) {
                        if (de.Account_Manager__c == null) {
                            de.Account_Manager__c = userId;
                        }
                        
                        if (de.Secondary_Account_Manager__c == null) {
                            de.Secondary_Account_Manager__c = userId;
                        }
                    }
                }
                
                if (de.Secondary_Account_Manager__c == null &&
                    de.Account_Manager__c != null) {
                        de.Secondary_Account_Manager__c = de.Account_Manager__c;
                    }
            }
        }
    }

    public static void UpdateAssignments(Set<Id> deIds) {
        List<GC_Show_Team_Assignment__c> deleteAssignments = new List<GC_Show_Team_Assignment__c>();
        Map<Id, GC_Design_Element__c> designElementTasksMap = new Map<Id, GC_Design_Element__c>(GC_DesignElementDao.getInstance().getDesignElementByIds(deIds));

        for (GC_Show_Team_Assignment__c sta : [Select Id, Design_Element__c,
                                               Team_Member_Role__c, Show_Team_Member__r.User__c
                                               from GC_Show_Team_Assignment__c
                                               where Design_Element__c IN: deIds]) {
            Id deId = sta.Design_Element__c;
            Id userId = sta.Show_Team_Member__r.User__c;
            GC_Design_Element__c de = designElementTasksMap.get(deId);

            if ((sta.Team_Member_Role__c == 'Creative Director' && de.Creative_Director_Approvers__c != userId)
                    || (sta.Team_Member_Role__c == 'Traffic Administrator' && de.Traffic_Administrator_Approver__c != userId)
                    || ((sta.Team_Member_Role__c == 'Detailer' || sta.Team_Member_Role__c == 'Designer' || sta.Team_Member_Role__c == 'Designer/Detailer') && !getDetailerIds(de).contains(userId))) {
                deleteAssignments.add(sta);
            }
        }

        if (!deleteAssignments.isEmpty()) {
            delete deleteAssignments;
        }
    }

    private static Set<Id> getDetailerIds(GC_Design_Element__c de) {
        Set<Id> detailerIds = new Set<Id>();

        /*if (de.Detailer_Approver__c != null) {
            detailerIds.add(de.Detailer_Approver__c);
        }*/  //Amarab 04062021 SAL-1243 Replacing old Designer/Detailer Approver1 field with new field
        
        if (de.Contact_Designer_Detailer_Approver1__c != null) {
            detailerIds.add(de.Contact_Designer_Detailer_Approver1__c);
        }

        if (de.Detailer_Approver2__c != null) {
            detailerIds.add(de.Detailer_Approver2__c);
        }

        if (de.Detailer_Approver3__c != null) {
            detailerIds.add(de.Detailer_Approver3__c);
        }

        if (de.Detailer_Approver4__c != null) {
            detailerIds.add(de.Detailer_Approver4__c);
        }

        if (de.Detailer_Approver5__c != null) {
            detailerIds.add(de.Detailer_Approver5__c);
        }

        return detailerIds;
    }
    
    public static void updateApproverFields(List<GC_Design_Element__c> newRecords){

        Map<String, String> mapCityCodeToUserIdDAM = new Map<String, String>();
        Map<String, String> mapCityCodeToUserIdCD = new Map<String, String>();
        Map<String, String> mapCityCodeToUserIdTA = new Map<String, String>();

        String queryDAM = 'SELECT id, User_ID__c, City_Code__c FROM GC_DETDAMApprover__mdt';
        List<GC_DETDAMApprover__mdt> damApprovers= Database.query(queryDAM);
        for(GC_DETDAMApprover__mdt damApprover: damApprovers){
            List<String> allCityCodes = damApprover.City_Code__c.split(',');
            for(String cityCode : allCityCodes){
                mapCityCodeToUserIdDAM.put(cityCode, damApprover.User_ID__c);
            } 
        }
        
        String queryCD = 'SELECT id, User_ID__c, City_Code__c FROM GC_DETCDApprover__mdt';
        List<GC_DETCDApprover__mdt> cdApprovers = Database.query(queryCD);
        for(GC_DETCDApprover__mdt cdApprover: cdApprovers){
            List<String> allCityCodes = cdApprover.City_Code__c.split(',');
            for(String cityCode : allCityCodes){
                mapCityCodeToUserIdCD.put(cityCode, cdApprover.User_ID__c);
            } 
        }
        
        String queryTA = 'SELECT id, User_ID__c, City_Code__c FROM GC_DET_TAApprover__mdt';
        List<GC_DET_TAApprover__mdt> taApprovers = Database.query(queryTA);
        for(GC_DET_TAApprover__mdt taApprover: taApprovers){
            List<String> allCityCodes = taApprover.City_Code__c.split(',');
            for(String cityCode : allCityCodes){
                mapCityCodeToUserIdTA.put(cityCode, taApprover.User_ID__c);
            } 
        }
        
        for(GC_Design_Element__c designElement : newRecords){
            String cityCode = String.isNotBlank(designElement.FormulaShowJobNumber__c) ? designElement.FormulaShowJobNumber__c.substringBefore('-'): '12345';
            String damUser = mapCityCodeToUserIdDAM != null && mapCityCodeToUserIdDAM.size() > 0 ? mapCityCodeToUserIdDAM.get(cityCode) : '';
            designElement.Director_of_Account_Manager__c = damUser;
            
            String cdUser = mapCityCodeToUserIdCD != null && mapCityCodeToUserIdCD.size() > 0 ? mapCityCodeToUserIdCD.get(cityCode) : '';
            designElement.Creative_Director_Approvers__c = cdUser;
            
            String taUser = mapCityCodeToUserIdTA != null && mapCityCodeToUserIdTA.size() > 0 ? mapCityCodeToUserIdTA.get(cityCode) : '';
            designElement.Traffic_Administrator_Approver__c = taUser;
            
        }
    }
}