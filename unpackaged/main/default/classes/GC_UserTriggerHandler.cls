/**
* @author Ethos Solutions - www.ethos.com
* @description Trigger logic for User. Assigns Show Team Role based on profile name
* 2016-08-08 : Original Version
**/
public without sharing class GC_UserTriggerHandler {
    public static void handleBeforeInsert(List<User> newList) {
        updateShowRoles(newList);

    }

    public static void handleBeforeUpdate(Map<Id, User> oldMap, Map<Id, User> newMap) {
        List<User> changedUsers = new List<User>();

        for (Id userId : oldMap.keySet()) {
            Id oldProfileId = oldMap.get(userId).ProfileId;
            Id newProfileId = newMap.get(userId).ProfileId;

            if (oldProfileId != newProfileId) {
                changedUsers.add(newMap.get(userId));
            }
        }

        if (changedUsers.size() > 0) {
            updateShowRoles(changedUsers);
        }
    }

    private static void updateShowRoles(List<User> newList) {
        Set<Id> profileIds = new Set<Id>();

        for (User u : newList) {
            profileIds.add(u.ProfileId);
        }

        Map<Id, Profile> profileMap = new Map<Id, Profile>([Select Id, Name from Profile where Id in :profileIds]);

        Set<String> gcShowRolePlValues = new Set<String>();

        Schema.DescribeFieldResult fieldResult = User.GC_Show_Role__c.getDescribe();
        for (Schema.PicklistEntry f : fieldResult.getPicklistValues()) gcShowRolePlValues.add(f.getValue());

        for (User u : newList) {
            if (String.isNotBlank(u.ProfileId) && profileMap.containsKey(u.ProfileId)) {
                Profile p = profileMap.get(u.ProfileId);
                if (gcShowRolePlValues.contains(p.Name)) {
                    u.GC_Show_Role__c = p.Name;
                }
            }
        }
    }
    
    public static void handleAfterInsert(list<User> newUsers)
    {
        assignUserToProjectCentralShowGroup(newUsers, null);
    }
    public static void handleAfterUpdate(list<User> newUsers, Map<Id, User> OldMap)
    {
        assignUserToProjectCentralShowGroup(newUsers, OldMap);
    }
    public static void assignUserToProjectCentralShowGroup(list<User> newUsers, Map<Id, User> OldMap)
    {
        if(String.isBlank(system.Label.GC_Profiles))        return;
        if(String.isBlank(system.Label.GC_ProjectCentralShowGroup))        return;
                
        list<Profile> profiles = [SELECT Id, Name FROM Profile WHERE Name IN: system.Label.GC_Profiles.split(',')];
        if(profiles.isEmpty())    return;
        
        list<Group> groups = [SELECT Id, Name, (SELECT Id, UserOrGroupId FROM GroupMembers) FROM Group WHERE Name =: system.Label.GC_ProjectCentralShowGroup];
        if(groups.isEmpty())    return;
        
        list<Id> profileIds = new list<Id>();
        for(Profile prof : profiles){
            profileIds.add(prof.Id);
        }
        
        Set<Id> existingGroupMemberIds = new Set<Id>();
        for(Group g : groups){
            for(GroupMember gm : g.GroupMembers){
                existingGroupMemberIds.add(gm.UserOrGroupId);
            }
        }
        
        Set<Id> usersToAdd = new Set<Id>();
        Set<Id> usersToRemove = new Set<Id>();
        for(User u : newUsers)
        {            
            if(Trigger.isInsert && profileIds.contains(u.ProfileId))
            {
                usersToAdd.add(u.Id);
            }
            if(Trigger.isUpdate && u.ProfileId != OldMap.get(u.Id).ProfileId)
            {
                //interchange
                if(profileIds.contains(u.ProfileId) && profileIds.contains(OldMap.get(u.Id).ProfileId)){
                    //do nothing
                    if(!existingGroupMemberIds.contains(u.Id)){
                        usersToAdd.add(u.Id);
                    }
                }
                if(profileIds.contains(u.ProfileId) && !profileIds.contains(OldMap.get(u.Id).ProfileId)){
                    usersToAdd.add(u.Id);
                }
                if(!profileIds.contains(u.ProfileId) && profileIds.contains(OldMap.get(u.Id).ProfileId)){
                    usersToRemove.add(u.Id);
                }
                if(!profileIds.contains(OldMap.get(u.Id).ProfileId) && !profileIds.contains(u.ProfileId)){
                    //do nothing
                    if(existingGroupMemberIds.contains(u.Id)){
                        usersToRemove.add(u.Id);
                    }
                }
            }         
        }
        //newUsers[0].addError('hi'+usersToAdd.size()+'-'+usersToRemove.size());
        if(!usersToAdd.isEmpty())
        {
            list<GroupMember> groupMembersToInsert = new list<GroupMember>();
            for(Group g : groups)
            {
                for(Id userId : usersToAdd)
                {
                    GroupMember gm = new GroupMember();
                    gm.GroupId = g.Id;
                    gm.UserOrGroupId = userId;
                    groupMembersToInsert.add(gm);
                }
            }
            insert groupMembersToInsert;
        }
        if(!usersToRemove.isEmpty())
        {
            delete [SELECT Id 
                    FROM GroupMember 
                    WHERE GroupId IN: groups
                    AND UserOrGroupId IN: usersToRemove];
        }
    }
    
    // SFDC-301 Call center updated when Role is changed - 10/14/24 - SM
    public static void updateCallCenter(Map<Id, User> oldMap, Map<Id, User> newMap) {
        List<User> listUser = new List<User>();
        for(User u : newMap.values()){
            User oldRec = oldMap.get(u.Id);
            if(u.UserRoleId != oldRec.UserRoleId){
                listUser.add(u);
            }
        }
        if(!listUser.isEmpty()){
            
            List<Call_Center_Mapping__mdt> listCCM = Call_Center_Mapping__mdt.getAll().values();
            if(listCCM != null && listCCM.size() > 0){
                
                //Define Role to Call Center mappings.
                Map<String, String> roleToCallCenterMap = new Map<String, String>();      
                for(Call_Center_Mapping__mdt ccm : listCCM){
                    roleToCallCenterMap.put(ccm.User_Role__c,ccm.Call_Center__c);
                }
            
                //Extract the role and call center names.
                List<String> roleNames = new List<String>(roleToCallCenterMap.keySet());
                List<String> callCenterNames = new List<String>(roleToCallCenterMap.values());
                
                // Query UserRoles.
                Map<Id, String> userRoleIdToName = new Map<Id, String>();
                for (UserRole role : [SELECT Id, Name FROM UserRole WHERE Name IN :roleNames]) {
                    userRoleIdToName.put(role.Id, role.Name);
                }
                
                // Query CallCenters.
                Map<String, Id> callCenterNameToId = new Map<String, Id>();
                for (CallCenter cc : [SELECT Id, Name FROM CallCenter WHERE Name IN :callCenterNames]) {
                    callCenterNameToId.put(cc.Name, cc.Id);
                }
                
                //Update call center
                for(User usr: listUser){
                    if(userRoleIdToName.containsKey(usr.UserRoleId)){
                        String userRoleName = userRoleIdToName.get(usr.UserRoleId);
                        if(roleToCallCenterMap.containsKey(userRoleName)){
                            String callCenterName = roleToCallCenterMap.get(userRoleName);
                            usr.CallCenterId = callCenterNameToId.get(callCenterName);
                        }
                    }
                }
            }
        }
    }
}