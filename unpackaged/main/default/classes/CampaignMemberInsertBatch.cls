/*************************************************************************************************
Class     :  CampaignMemberInsertBatch.cls
Developer :  Najmal M K Muhammed
Created   :  June 21,2023
Modified  :  June 21,2023
Objective :  //#336693 - This class provides for creating campaign members from BoothUploadAll.apxt

*************************************************************************************************/
global class CampaignMemberInsertBatch implements Database.Batchable<sObject>, Database.Stateful {
    global List<CampaignMember> campaignMembersTobeInsert { get; set; }
    
    global campaignMemberInsertBatch(List<CampaignMember> campaignMembers) {
        campaignMembersTobeInsert = campaignMembers;
    }
    
     global List<CampaignMember> start(Database.BatchableContext BC) {
        return campaignMembersTobeInsert;
    }

    global void execute(Database.BatchableContext BC, List<CampaignMember> campaignMembers) {
        try{
        	insert campaignMembers;
        }catch(Exception e){
            System.debug(e.getMessage());
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        system.debug('Finished');
    }
}