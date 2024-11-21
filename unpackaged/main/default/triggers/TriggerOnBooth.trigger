/******************************************************************
    Date      : 28/March/2017   
    Action    : This trigger invokes handler class: BoothTriggerHandler.
    Change desription:
    Developer         Date                  Description 
    
*******************************************************************/    
trigger TriggerOnBooth on Oracle_Show_Booth__c( after insert, after update, after delete, after undelete) {
    
    //Desc:  Below code to avoid trigger execute during the merge of account from Demand tool
    // Date: 25-May-2017
    // Added By : Kumud 
    
    if(Userinfo.getProfileID()==Label.MergeSystemAdminId){
      
        return;
    }
    
    //End here
    
    BoothTriggerHandler BoothHandler = new BoothTriggerHandler();
    if(trigger.isAfter) {
        if(trigger.isInsert) {
            BoothHandler.updateShowOppNameOnAcc(trigger.new, null, null, null, 'After', 'Insert');
        }
        if(trigger.isUpdate){
            BoothHandler.updateShowOppNameOnAcc(trigger.new, trigger.old, trigger.newMap, trigger.oldMap, 'After', 'Update');
            BoothHandler.deleteCampaignMembers(Trigger.new, Trigger.oldMap);
            BoothHandler.insertCampaignMembers(Trigger.new, Trigger.oldMap);
        } 
        if(trigger.isDelete) {
            BoothHandler.updateShowOppNameOnAcc(null, trigger.old, null, null, 'After', 'Delete'); 
        }
        if(trigger.isUndelete){ 
            BoothHandler.updateShowOppNameOnAcc(trigger.new, null, null, null, 'After', 'Undelete');
        }                   
    }
}