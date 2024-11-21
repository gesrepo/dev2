/* Developed for the ticket - SAL-892
    * Controller for LC_AddmyselfToShow Lightning Component.
    * author: Namratha P for SLK Software Services 
    * */

public with sharing class LC_AddMyselfToShowController {
    @auraEnabled
    public static List<String> getRoles(ID showId){
        List<String> showRoles = new List<String>();
        // get GC roles for the user before adding to the show.
        User currentUser = [select Id, Name, GC_Show_Role__c from User where Id = :UserInfo.getUserId()];
        //system.debug('GC show roles ----'+currentUser.GC_Show_Role__c);
        if(currentUser.GC_Show_Role__c != null){
            for (String role : currentUser.GC_Show_Role__c.split(';')) {
                String allowedRole = role.replace('GC ', '');
                //SAL-506
                if(System.Label.GC_Label_ProfileToAdd.contains(allowedRole)){
                    String roleOption1 = System.Label.GC_Label_AccMgrProfile;
                    showRoles.add(roleOption1);
                }
                else{
                    showRoles.add(allowedRole);
                }
                //system.debug('showRoles----'+showRoles);
            }
        } 
        return showRoles;
    }
   
      // Check if the user is a system Admin
    @auraEnabled
    public static Boolean checkIsAdmin(){
        Boolean isSysAdmin;
        Id profileId = userinfo.getProfileId();
        System.debug('profileId-----'+profileId);
        Profile profileName = [Select Id,Name from Profile where Id=:profileId];
        if(profileName.Name == 'System Administrator'){
            isSysAdmin = true;
        }
        //System.debug('isSysAdmin-----'+isSysAdmin);
        return isSysAdmin;
    }
    
     // check If use is on the show 
    @auraEnabled
    public static Boolean checkIsOnShow(ID ShowId){
        Boolean isOnShow;
        List<GC_Show_Team_Member__c> showTeamMembers = [select Id, Name, User__c from GC_Show_Team_Member__c where User__c = :UserInfo.getUserId() AND Connect2_Show__c = :ShowId];
        isOnShow = showTeamMembers.size() > 0;
        //System.debug('isOnShow-----'+isOnShow);
        return isOnShow;
    }
    
     // add the user to the current show
    @auraEnabled
    public static void addMyselfToshow(ID ShowId,string selectedRole){
        GC_Show_Team_Member__c ShowTeamMember = new GC_Show_Team_Member__c();
        ShowTeamMember.User__c = UserInfo.getUserId();
        ShowTeamMember.Show_Role__c = selectedRole;
        ShowTeamMember.Connect2_Show__c = ShowId;
        insert ShowTeamMember;
    }
}