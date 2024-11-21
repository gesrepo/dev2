/**
* @author Ethos Solutions - www.ethos.com
* @description Trigger logic for Connect2 Show
* 2016-04-13 : Original Version
**/
public without sharing class GC_Connect2ShowTriggerHandler {

    public static void CheckChangeOwner(Map<Id, GC_Connect2_Show__c> oldMap, Map<Id, GC_Connect2_Show__c> newMap) {
        List<GC_Connect2_Show__c> recalcRecords = new List<GC_Connect2_Show__c>();

        for (Id showId : Trigger.newMap.keySet()) {
            if (oldMap.get(showId).OwnerId != newMap.get(showId).OwnerId) {
                recalcRecords.add(newMap.get(showId));
            }
        }

        if (recalcRecords.size() > 0) {
            UpdateShowTeamAccess(recalcRecords);
            AddShowTeamMembers(recalcRecords);
            UpdateVendorTasks(recalcRecords);
        }
    }

    public static void UpdateShowTeamAccess(List<GC_Connect2_Show__c> shows) {
        Set<Id> showIds = new Set<Id>();

        for (GC_Connect2_Show__c show : shows) {
            showIds.add(show.Id);
        }

        List<GC_Show_Team_Member__c> entireShowTeam = [select Id, User__c, Connect2_Show__c, Show_Role__c from GC_Show_Team_Member__c where Connect2_Show__c in :showIds];
        GC_ShowTeamMemberTriggerHandler.UpdateRecordAccessShows(entireShowTeam, shows);
    }

    public static void UpdateVendorTasks(List<GC_Connect2_Show__c> shows) {
        Set<Id> showIds = new Set<Id>();

        for (GC_Connect2_Show__c show : shows) {
            showIds.add(show.Id);
        }

        List<GC_Vendor_Order_Task__c> vendorTasks = [select Id, Vendor__c from GC_Vendor_Order_Task__c where Order__r.Connect2_Show__c In :showIds AND Vendor__c != null];

        if (vendorTasks.size() > 0) {
            GC_VendorOrderTaskTriggerHandler.HandleVendorShares(vendorTasks);
        }
    }

    // need to do this after insert only.
    public static void AddShowTeamMembers(List<GC_Connect2_Show__c> shows) {
        // look at created by and owner, if they are not show team members for the opportunity then add them to the show.
        if (shows.size() == 0) {
            return;
        }

        Set<Id> usersOnConnect2Show = new Set<Id>();
        Set<Id> showIds = new Set<Id>();

        for (GC_Connect2_Show__c show : shows) {
            usersOnConnect2Show.add(show.CreatedById);
            usersOnConnect2Show.add(show.OwnerId);
            showIds.add(show.Id);
        }

        Map<Id, User> usersOnConnect2ShowMap = new Map<Id, User>([select Id, Name, GC_Show_Role__c, Profile.Name from User where Id in :usersOnConnect2Show]);
        List<GC_Show_Team_Member__c> stms = [select Id, Name, User__c, Connect2_Show__c, Show_Role__c from GC_Show_Team_Member__c where Connect2_Show__c in :showIds AND User__c in :usersOnConnect2Show];
        Map<String, GC_Show_Team_Member__c> existingShowTeamMembers = new Map<String, GC_Show_Team_Member__c>();

        List<GC_Show_Team_Member__c> tmpDelete = new List<GC_Show_Team_Member__c>();

        for (GC_Show_Team_Member__c stm : stms) {
            String key = (stm.User__c + '.' + stm.Connect2_Show__c).toLowerCase();

            if (!existingShowTeamMembers.containsKey(key)) {
                existingShowTeamMembers.put(key, stm);
            } else {
                tmpDelete.add(stm);
            }
        }

        //delete tmpDelete;
        List<GC_Show_Team_Member__c> showTeamMembersToAdd = new List<GC_Show_Team_Member__c>();

        for (GC_Connect2_Show__c show : shows) {
            if (usersOnConnect2ShowMap.containsKey(show.CreatedById)) {
                User createdByUser = usersOnConnect2ShowMap.get(show.CreatedById);

                if (GC_SecurityUtil.userHasRole(createdByUser, GC_SecurityUtil.R_SALES_MGR)) {
                    String key = (show.CreatedById + '.' + show.Id).toLowerCase();

                    if (existingShowTeamMembers.containsKey(key)) {
                        System.Debug('This user ' + show.CreatedById + ' is already on the show ' + show.Id);
                    } else {
                        GC_Show_Team_Member__c newStm = new GC_Show_Team_Member__c();
                        newStm.Connect2_Show__c = show.Id;
                        newStm.Show_Role__c = 'Sales Manager';
                        newStm.User__c = show.CreatedById;
                        showTeamMembersToAdd.add(newStm);
                    }
                }
            }

            if (usersOnConnect2ShowMap.containsKey(show.OwnerId)) {
                User ownerUser = usersOnConnect2ShowMap.get(show.OwnerId);

                if (GC_SecurityUtil.userHasRole(ownerUser, GC_SecurityUtil.R_ACCT_MANAGER)) {
                    String key = (show.OwnerId + '.' + show.Id).toLowerCase();

                    if (existingShowTeamMembers.containsKey(key)) {
                        System.Debug('This user ' + show.OwnerId + ' is already on the show ' + show.Id);
                    } else {
                        GC_Show_Team_Member__c newStm = new GC_Show_Team_Member__c();
                        newStm.Connect2_Show__c = show.Id;
                        newStm.Show_Role__c = 'Account Manager';
                        newStm.User__c = show.OwnerId;
                        showTeamMembersToAdd.add(newStm);
                    }
                }
            }
        }

        insert showTeamMembersToAdd;
    }

    // as of 1/1/2017 there were 2200 show team member records in the system, so this should be able to be run without batch processing
    public static void UpdateShowTeamMembersField(List<GC_Connect2_Show__c> shows) {
        Set<String> showIds = new Set<String>();

        for (GC_Connect2_Show__c show : shows) {
            showIds.add(show.Id);
        }

        List<GC_Show_Team_Member__c> stms = [select Id, Name, Connect2_Show__c, User__c from GC_Show_Team_Member__c where Connect2_Show__c in :showIds AND Show_Role__c != 'Vendor' AND Show_Role__c != 'Show Organizer - Read Only' AND Show_Role__c != 'Show Organizer' order by createdDate asc limit 10000];

        Map<String, Set<String>> showTeamIdsByShow = new Map<String, Set<String>>();

        for (GC_Show_Team_Member__c stm : stms) {
            if (!showTeamIdsByShow.containsKey(stm.Connect2_Show__c)) {
                showTeamIdsByShow.put(stm.Connect2_Show__c, new Set<String>());
            }

            showTeamIdsByShow.get(stm.Connect2_Show__c).add(stm.User__c);
        }

        List<GC_Connect2_Show__c> showsToUpdate = new List<GC_Connect2_Show__c>();
        List<GC_Connect2_Show__c> existingShows = GC_Connect2ShowDao.getInstance().getShowsByIds(showIds);

        for (GC_Connect2_Show__c show : existingShows) {
            if (showTeamIdsByShow.containsKey(show.Id)) {
                String showTeamCSV = String.join(new List<String>(showTeamIdsByShow.get(show.Id)), ',');
                System.debug(loggingLevel.Debug, '*** showTeamCSV: ' + showTeamCSV);
                show.Show_Team_Member_Ids__c = showTeamCSV;
                showsToUpdate.add(show);
            }
        }

        Database.update(showsToUpdate, false);
    }
    
    //SAL-1315 - KYS NoficationDate field updated on record insert - 12/14/23 - Sajid
    public static void updateKYSNoficationDate(List<GC_Connect2_Show__c> newRecords) {
        for(GC_Connect2_Show__c show : newRecords){
            if(show.Know_Your_Show_Complete__c){
                show.KYS_Notification_Date__c = System.now();
            } 
        }
    }
    
    //SAL-1315 - KYS NoficationDate and KYS Complete field updated on record update - 12/14/23 - Sajid
    public static void updateKYSFields(List<GC_Connect2_Show__c> newRecords, Map<Id, GC_Connect2_Show__c> oldMap) {
        for(GC_Connect2_Show__c show : newRecords){
            GC_Connect2_Show__c oldRecord = oldMap.get(show.Id);
            if(show.Know_Your_Show_Complete__c != oldRecord.Know_Your_Show_Complete__c && show.Know_Your_Show_Complete__c){
                show.KYS_Notification_Date__c = System.now();
            }
            else if(checkKYSFieldsChanged(show, oldRecord)){
                show.Know_Your_Show_Complete__c = false;
            }
            
        }
    }
    
    //SAL-1315 - checking if KYS fields updated to populate false value in 'KYS Complete' field - 12/14/23 - Sajid
    public static Boolean checkKYSFieldsChanged(GC_Connect2_Show__c newRecord, GC_Connect2_Show__c oldRecord){
        if(newRecord.Know_Your_Show_Complete__c && 
           (newRecord.KYS_Overall_Comments__c != oldRecord.KYS_Overall_Comments__c ||
           newRecord.Will_there_be_Booth_Statuses__c != oldRecord.Will_there_be_Booth_Statuses__c ||
           newRecord.If_so_how_would_you_like_Order_Entry_to__c != oldRecord.If_so_how_would_you_like_Order_Entry_to__c || 
           newRecord.Method_of_Entry_of_Booth_Statuses__c != oldRecord.Method_of_Entry_of_Booth_Statuses__c || 
           newRecord.Are_hanging_signs_allowed__c != oldRecord.Are_hanging_signs_allowed__c || 
           newRecord.Will_GES_provide_the_service__c != oldRecord.Will_GES_provide_the_service__c || 
           newRecord.Will_approval_be_needed_prior_to_entry__c != oldRecord.Will_approval_be_needed_prior_to_entry__c || 
           newRecord.If_approval_is_needed_please_provide_a__c != oldRecord.If_approval_is_needed_please_provide_a__c	 ||
           newRecord.Is_there_Storage_Labor__c != oldRecord.Is_there_Storage_Labor__c || 
           newRecord.Is_the_show_targeted__c != oldRecord.Is_the_show_targeted__c || 
           newRecord.Provide_CSM_comments_for_Target_Change_p__c != oldRecord.Provide_CSM_comments_for_Target_Change_p__c || 
           newRecord.Is_it_for_both_inbound_and_or_outbound__c != oldRecord.Is_it_for_both_inbound_and_or_outbound__c || 
           newRecord.Include_internal_and_external_links__c != oldRecord.Include_internal_and_external_links__c || 
           newRecord.Is_early_move_in_available__c != oldRecord.Is_early_move_in_available__c || 
           newRecord.If_yes_provide_CSM_comments__c != oldRecord.If_yes_provide_CSM_comments__c || 
           newRecord.Is_Access_Storage_available__c != oldRecord.Is_Access_Storage_available__c || 
           newRecord.If_no_provide_CSM_comments__c != oldRecord.If_no_provide_CSM_comments__c || 
           newRecord.Last_day_to_ship_to_the_warehouse__c != oldRecord.Last_day_to_ship_to_the_warehouse__c || 
           newRecord.Non_GES_advance_warehouse_is_being_used__c != oldRecord.Non_GES_advance_warehouse_is_being_used__c || 
           newRecord.Post_Show_Info__c != oldRecord.Post_Show_Info__c || 
           newRecord.Is_the_hall_carpeted__c != oldRecord.Is_the_hall_carpeted__c || 
           newRecord.Is_flooring_required_for_this_show__c != oldRecord.Is_flooring_required_for_this_show__c || 
           newRecord.Power_from_the_ceiling_or_floor__c != oldRecord.Power_from_the_ceiling_or_floor__c || 
           newRecord.Show_site__c != oldRecord.Show_site__c || 
           newRecord.Is_Lead_Retrieval_being_offered_on_this__c != oldRecord.Is_Lead_Retrieval_being_offered_on_this__c || 
           newRecord.Any_Column_S_inside_booth__c != oldRecord.Any_Column_S_inside_booth__c || 
           newRecord.Dimensions_of_columns_posted_in_Expresso__c != oldRecord.Dimensions_of_columns_posted_in_Expresso__c || 
           newRecord.Additional_Comments__c != oldRecord.Additional_Comments__c)){
               return true;
           }else{
               return false;
           }
    }
    
    //SAL-1315 - Notify to NSC team if KYS field marked as Complete - 12/14/23 - Sajid
    public static void sendEmailToNSC(List<GC_Connect2_Show__c> newRecords, Map<Id, GC_Connect2_Show__c> oldMap) {
        Id senderOrgId = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'noreply@ges.com' LIMIT 1].Id;
        Id templateId = [SELECT Id FROM EmailTemplate WHERE name = 'PC Know Your Show KYS Marked as Complete'].Id;
        
        List<String> toEmails = new List<String>();
        Project_Central_Setting__c pcSetting = Project_Central_Setting__c.getOrgDefaults();
        String toEmailAddress = pcSetting.Email_Address__c;
        if(toEmailAddress != null){
            toEmails = toEmailAddress.split(',');
        }
        
        List<Contact> conts = [SELECT id FROM Contact LIMIT 1];
        if (conts != null && conts.size() > 0) {
            List<Messaging.SingleEmailMessage> messageList = new List<Messaging.SingleEmailMessage>();
            
            for(GC_Connect2_Show__c show : newRecords){
                if((Trigger.isInsert || (Trigger.isUpdate && show.Know_Your_Show_Complete__c != oldMap.get(show.Id).Know_Your_Show_Complete__c)) && show.Know_Your_Show_Complete__c){
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                    message.setOrgWideEmailAddressId(senderOrgId);
                    message.setToAddresses(toEmails);
                    message.setTemplateId(templateId);
                    message.setSaveAsActivity(false);
                    message.setWhatId(show.Id);
                    message.setTreatTargetObjectAsRecipient(false);
                    message.setTargetObjectId(conts.get(0).Id);
                    messageList.add(message);
                }
            }
            if (messageList != null && messageList.size() > 0){
                Messaging.sendEmail(messageList); 
            }
        }
    }
}