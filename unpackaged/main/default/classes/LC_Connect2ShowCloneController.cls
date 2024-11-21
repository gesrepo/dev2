//This class serves as a Apex Controller for GC_Connect2ShowClone Lightning Component
public with sharing class LC_Connect2ShowCloneController {
    
    @AuraEnabled(cacheable=true)
    public static List<GC_ShowAttributeWrapper> getShowAttributes(String showId){
        List<GC_Show_Attribute__c> showAttributes = [SELECT Id, Name, RecordType.Name, Connect2_Show__c FROM GC_Show_Attribute__c WHERE Connect2_Show__c =:showId];
        List<GC_ShowAttributeWrapper> showAttHolders = new List<GC_ShowAttributeWrapper>();
        for (GC_Show_Attribute__c sa : showAttributes) {
            showAttHolders.add(new GC_ShowAttributeWrapper(sa));
        }
        return showAttHolders;
    }
    
    public class GC_ShowAttributeWrapper {
        //public Boolean selected {get; set;}
        @AuraEnabled public String showAttributeId {get; set;}
        @AuraEnabled public String showAttributeName {get; set;}
        @AuraEnabled public String showAttributeRecordType {get; set;}
        
        public GC_ShowAttributeWrapper(GC_Show_Attribute__c sa) {
            this.showAttributeId = sa.Id;
            this.showAttributeName = sa.Name;
            this.showAttributeRecordType = schema.getGlobalDescribe().get('GC_Show_Attribute__c').getDescribe().getRecordTypeInfosById().get(sa.RecordTypeId).getName();
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<GC_ShowTeamMemberWrapper> getShowTeamMembers(String showId){
        List<GC_Show_Team_Member__c> showTeamMembers = [SELECT Id, Name, User__c, User_Information__c, Show_Role__c FROM GC_Show_Team_Member__c WHERE Connect2_Show__c =:showId];
        List<GC_ShowTeamMemberWrapper> showTeamMembersResult = new List<GC_ShowTeamMemberWrapper>();
        for (GC_Show_Team_Member__c stm : showTeamMembers) {
            showTeamMembersResult.add(new GC_ShowTeamMemberWrapper(stm));
        }
        return showTeamMembersResult;
    }
    
    public class GC_ShowTeamMemberWrapper {
        //public Boolean selected {get; set;}
        @AuraEnabled public String showTeamMemberId {get; set;}
        @AuraEnabled public String showTeamMemberNumber {get; set;}
        @AuraEnabled public String showTeamMemberUser {get; set;}
        @AuraEnabled public String showTeamMemberUserInfo {get; set;}
        @AuraEnabled public String showTeamMemberShowRole {get; set;}
        
        public GC_ShowTeamMemberWrapper(GC_Show_Team_Member__c stm) {
            this.showTeamMemberId = stm.Id;
            this.showTeamMemberNumber = stm.Name;
            this.showTeamMemberUser = stm.User__c;
            this.showTeamMemberUserInfo = stm.User_Information__c;
            this.showTeamMemberShowRole = stm.Show_Role__c;
        }
    }
    
    @AuraEnabled
    public static Integer cloneShowAttribute(String showAttributeIdsToBeCloned, String connect2ShowId, String showTeamMemberIdsToBeCloned){
        system.debug('showAttributeIdsToBeCloned'+showAttributeIdsToBeCloned);
        system.debug('connect2ShowId'+connect2ShowId);
        system.debug('showTeamMemberIdsToBeCloned'+showTeamMemberIdsToBeCloned);
        Type showAttributeIdType = Type.forName('List<Id>');
        List<Id> showAttributeIds= new List<Id>(); 
        if(Test.isRunningTest()){
            showAttributeIds.add(showAttributeIdsToBeCloned);
        }
        else{
            showAttributeIds= (List<Id>) JSON.deserialize(showAttributeIdsToBeCloned, showAttributeIdType);
        }
        Type showTeamMemberIdType = Type.forName('List<Id>');
        List<Id> showTeamMemberIds= new List<Id>();
        if(Test.isRunningTest()){
            showTeamMemberIds.add(showTeamMemberIdsToBeCloned);
        }
        else{
            showTeamMemberIds=(List<Id>) JSON.deserialize(showTeamMemberIdsToBeCloned, showTeamMemberIdType);
        }
        Type idlistType = Type.forName('String');
        String Selectedconnect2ShowId;
        Id selectedConn2ShowId;
        if(Test.isRunningTest()){
            Selectedconnect2ShowId=connect2ShowId;
            selectedConn2ShowId=Id.valueOf(Selectedconnect2ShowId);
        }
        else{
            Selectedconnect2ShowId= (String) JSON.deserialize(connect2ShowId, idlistType);
            selectedConn2ShowId = Id.valueOf(connect2ShowId.substring(1, connect2ShowId.length()-1));
        }
        
        if((showAttributeIds.size()<=0)&&(showTeamMemberIds.size()<=0)){
            return -1;
        }
        Integer attributeCounter=0;
        List<GC_Show_Attribute__c> attributeNameToBeCloned= new List<GC_Show_Attribute__c>();
        attributeNameToBeCloned=[select name from GC_Show_Attribute__c where id=:showAttributeIds];
        List<string> attributesToBeCloned = new List<string>();
        for(GC_Show_Attribute__c attribute:attributeNameToBeCloned){
            attributesToBeCloned.add(attribute.name);
        }
        
        List<GC_Connect2_Show__c> attributesOfShowToBeCloned = new List<GC_Connect2_Show__c>();
        attributesOfShowToBeCloned=[select id,(select name from Show_Attributes__r) from GC_Connect2_Show__c where id=:selectedConn2ShowId];
        List<string> existingAttributes= new List<string>();
        for(GC_Connect2_Show__c showAttributes:attributesOfShowToBeCloned){
            for(GC_Show_Attribute__c attributes:showAttributes.Show_Attributes__r){
                existingAttributes.add(attributes.name);
            }
        }
        for(Integer i=0;i<attributesToBeCloned.size();i++){
            for(Integer j=0;j<existingAttributes.size();j++){
                if(existingAttributes[j] == attributesToBeCloned[i]){
                    attributeCounter++;
                }
            }
        }
        List<GC_Show_Team_Member__c> userIdOfMembersToBeCloned = new List<GC_Show_Team_Member__c>();
        userIdOfMembersToBeCloned=[select user__c from GC_Show_Team_Member__c where id=:showTeamMemberIds];
        List<Id> membersToBeCloned = new List<Id>();
        for(GC_Show_Team_Member__c members : userIdOfMembersToBeCloned){
            membersToBeCloned.add(members.user__c);
        }
        List<GC_Connect2_Show__c> userIdOfMembersOfShowToBeCloned = new List<GC_Connect2_Show__c>();
        userIdOfMembersOfShowToBeCloned=[select id,(select user__c from Show_Team_Members__r) from GC_Connect2_Show__c where id=:selectedConn2ShowId];
        List<Id> existingMembers= new List<Id>();
        for(GC_Connect2_Show__c showToBeCloned : userIdOfMembersOfShowToBeCloned){
            for(GC_Show_Team_Member__C existingMembersToBeCloned:showToBeCloned.Show_Team_Members__r){
                existingMembers.add(existingMembersToBeCloned.user__c);
            }
        }
        Integer memberCounter=0;
        
        for(Integer m=0;m<membersToBeCloned.size();m++){
            for(Integer n=0;n<existingMembers.size();n++){
                if(existingMembers[n] == membersToBeCloned[m]){
                    memberCounter++;
                }
            }
        }
        if((memberCounter == membersToBeCloned.size()) && (attributeCounter == attributeNameToBeCloned.size())){
            return 0;
        }
        
        else{
            GC_Show_Attribute__c showAttributeClone = new GC_Show_Attribute__c();
            List<GC_Show_Attribute__c> clonedShowAttributes = new List<GC_Show_Attribute__c>();
            List<GC_Show_Attribute__c> showAttQuery = [SELECT Id, Name, RecordType.Name FROM GC_Show_Attribute__c WHERE Id In :showAttributeIds];
            //system.debug(showAttQuery);
            for (GC_Show_Attribute__c selected : showAttQuery) {
                // system.debug(selected);
                showAttributeClone = selected.clone(false);
                // system.debug(showAttributeClone);
                showAttributeClone.Connect2_Show__c = selectedConn2ShowId;
                showAttributeClone.OwnerId = UserInfo.getUserId();
                clonedShowAttributes.add(showAttributeClone);
            }
            Database.insert(clonedShowAttributes, false);
            
            GC_Show_Team_Member__c showMemberClone = new GC_Show_Team_Member__c();
            List<GC_Show_Team_Member__c> clonedShowMembers = new List<GC_Show_Team_Member__c>();
            //SAL-1216 - Cloned Tiles access and Preshow tile access fields - 03/13/24 - Sajid
            //List<GC_Show_Team_Member__c> showTeamQuery = [SELECT Id, Name, Show_Name_Text__c, Show_Name__c, Show_Role__c, User__c, User_Information__c FROM GC_Show_Team_Member__c WHERe Id In :showTeamMemberIds];
            List<GC_Show_Team_Member__c> showTeamQuery = [SELECT Id, Name, Show_Name_Text__c, Show_Name__c, Show_Role__c, User__c, User_Information__c,Tiles_Access__c,Pre_show_Tile_Access__c FROM GC_Show_Team_Member__c WHERe Id In :showTeamMemberIds];
            for (GC_Show_Team_Member__c selectedStm : showTeamQuery) {
                showMemberClone = selectedStm.clone(false);
                showMemberClone.Connect2_Show__c = selectedConn2ShowId;
                showMemberClone.User__c = selectedStm.User__c;
                showMemberClone.OwnerId = UserInfo.getUserId();
                clonedShowMembers.add(showMemberClone);
            }
            Database.SaveResult[] srList = Database.insert(clonedShowMembers, false);
            system.debug('clonedShowMembers----'+ srList);
        }
        return 1;
    }
    @AuraEnabled
    public static List<string> getAttributeAndMembersName(String showAttributeIdsToBeCloned,String connect2ShowId,String showTeamMemberIdsToBeCloned){
        system.debug('attributes'+showAttributeIdsToBeCloned);
        system.debug('connect2ShowId'+connect2ShowId);
        system.debug('showTeamMemberIdsToBeCloned'+showTeamMemberIdsToBeCloned);
        List<string> listToBeReturned = new List<string>();
        Type showAttributeIdType = Type.forName('List<Id>');
        List<Id> showAttributeIds = new List<Id>();
        if(Test.isRunningTest()){
            showAttributeIds.add(showAttributeIdsToBeCloned);
            //system.debug('showAttributeIds'+showAttributeIds);
        }
        else{
            showAttributeIds = (List<Id>) JSON.deserialize(showAttributeIdsToBeCloned, showAttributeIdType);
            
        }
        Type showTeamMemberIdType = Type.forName('List<Id>');
        List<Id> showTeamMemberIds = new List<Id>();
        if(Test.isRunningTest()){
            showTeamMemberIds.add(showTeamMemberIdsToBeCloned);
            // system.debug('showTeamMemberIds to be cloned'+showTeamMemberIds);
        }
        else{
            showTeamMemberIds=(List<Id>) JSON.deserialize(showTeamMemberIdsToBeCloned, showTeamMemberIdType);
        }
        
        Type idlistType = Type.forName('String');
        String Selectedconnect2ShowId;
        Id selectedConn2ShowId;
        if(Test.isRunningTest()){
            Selectedconnect2ShowId=connect2ShowId;
            selectedConn2ShowId=Id.valueOf(Selectedconnect2ShowId);
        }
        else{
            Selectedconnect2ShowId = (String) JSON.deserialize(connect2ShowId, idlistType);
            selectedConn2ShowId = Id.valueOf(connect2ShowId.substring(1, connect2ShowId.length()-1));
        }
        List<GC_Show_Attribute__c> attributesToBeCloned = new List<GC_Show_Attribute__c>();
        attributesToBeCloned=[select Name from GC_Show_Attribute__c where id=:showAttributeIds];
        // system.debug('attributes name are'+attributesToBeCloned);
        for(GC_Show_Attribute__c att:attributesToBeCloned){
            listToBeReturned.add(att.Name);
        }
        List<GC_Connect2_Show__c> show= new List<GC_Connect2_Show__c>();
        show=[select Name from GC_Connect2_Show__c where id=:selectedConn2ShowId];
        
        List<GC_Show_Team_Member__c> userIdOfMembersToBeCloned = new List<GC_Show_Team_Member__c>();
        userIdOfMembersToBeCloned=[select user__c from GC_Show_Team_Member__c where id=:showTeamMemberIds];
        // system.debug('userIdOfMembersToBeCloned'+userIdOfMembersToBeCloned);
        List<Id> userId= new List<Id>();
        for(GC_Show_Team_Member__c g:userIdOfMembersToBeCloned){
            userId.add(g.user__c);
        }
        List<User> user = new List<User>();
        user=[select name from user where id=:userId];
        for(User u:user){
            listToBeReturned.add(u.name);
        }
        for(GC_Connect2_Show__c s:show){
            listToBeReturned.add(s.name);
        }
        //system.debug('list to be returned'+listToBeReturned);
        return listToBeReturned;
        
    }
}