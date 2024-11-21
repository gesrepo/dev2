/** @@desc: trigger to update the ICS cases in case the approver matrix gets updated. Can be used for other purposes as well
    @@ author: soniyia gopu for SLK Soft. Services
    @@ original version; 12-03-2018
**/

trigger ICS_UpdateApproverFromMatrixTrigger on ICS_Approver_Matrix__c (after update) {
    
    /* use this logic to bypass the trigger in case you need to do a data load and you don't  need the trigger to upload the records
    if(UserInfo.getProfileId()!='00e40000000vv0VAAQ'){
        ICS_UpdateApproverFromMatrixHandler.handleApprovers(trigger.new);
    }   */
    ICS_UpdateApproverFromMatrixHandler.handleApprovers(trigger.new);
}