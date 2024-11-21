/**
* @author Ethos Solutions - www.ethos.com
* @description Utility class for approvals
* 2016-04-13 : Original Version
**/
public with sharing class GC_ApprovalUtils {
    public static final String ShowOrgSubmit = 'GES_Order_Approval_Process';
    public static final String ShowOrgGraphicsSubmit = 'GES_Order_Approval_Process_GPMDirect';
    public static final String ShowOrgGpmToAMSubmit = 'GES_Order_Approval_Process_AM_Review';
    //public static final String AccountMgrGraphicsSubmit = 'GES_Graphics_Order_AM_Approval_Process';

    public static Boolean isUnderApproval(String objectId) {
        List<ProcessInstanceWorkitem> wiList
            = [Select Id, ProcessInstance.Status, ProcessInstance.TargetObjectId, ProcessInstanceId
               From ProcessInstanceWorkitem where ProcessInstance.TargetObjectId = :objectId];
        return wiList.size() != 0;
    }

    public static Map<String, Boolean> isUnderApproval(Set<String> objectIds) {

        List<ProcessInstanceWorkitem> wiList = [Select Id, ProcessInstance.Status, ProcessInstance.TargetObjectId, ProcessInstanceId
                                                From ProcessInstanceWorkitem where ProcessInstance.TargetObjectId in :objectIds];

        Map<String, Boolean> approvalItems = new Map<String, Boolean>();

        for (String objectId : objectIds) {
            approvalItems.put(objectId, false);
        }

        for (ProcessInstanceWorkitem wi : wiList) {
            String procId = String.valueOf(wi.ProcessInstance.TargetObjectId);

            if (approvalItems.containsKey(procId)) {
                approvalItems.put(procId, true);
            }
        }

        return approvalItems;
    }

    public static Boolean submitForApproval(GC_GES_Order_Task__c got) {
        return submitForApproval(got.Order__r.Connect2_Show__c, new List<GC_GES_Order_Task__c> {got});
    }

    public static Boolean submitForApproval(String showId, List<GC_GES_Order_Task__c> gots) {
        Integer errors = 0;
        Integer successes = 0;
        // Get the show team
        List<GC_Show_Team_Member__c> accountManagersTeam = [Select Id, Name, User__c, Connect2_Show__c, Show_Role__c , User__r.Email
                From GC_Show_Team_Member__c
                Where Connect2_Show__c = :showId and (Show_Role__c = 'Account Manager' or
                                         Show_Role__c = 'Secondary Account Manager')
                                         Order By Show_Role__c asc, LastModifiedDate desc];

        List<GC_Show_Team_Member__c> graphicsTeam = [Select Id, Name, User__c, Connect2_Show__c, Show_Role__c , User__r.Email
                From GC_Show_Team_Member__c
                Where Connect2_Show__c = :showId
                                         and (Show_Role__c = 'Graphics Project Manager')
                                         Order By LastModifiedDate desc];

        List<GC_Show_Team_Member__c> graphicsDirect = [Select Id, Name, User__c, Connect2_Show__c, Show_Role__c , User__r.Email
                From GC_Show_Team_Member__c
                Where Connect2_Show__c = :showId
                                         and (Show_Role__c = 'Graphics Project Manager Direct')
                                         Order By LastModifiedDate desc];

        if (accountManagersTeam.size() == 0) {
            GC_PageUtil.AddErrorMessage('Account Manager is not assigned to show as a show team member. Cannot submit any tasks.');
            return false;
        }

        // create a list of tasks that meet all conditions to submit for approval
        List<GC_GES_Order_Task__c> tasksToUpdate = new List<GC_GES_Order_Task__c>();
        Set<String> taskIds = new Set<String>();

        for (GC_GES_Order_Task__c got : gots) {
            taskIds.add(got.Id);
        }

        Map<String, Boolean> tasksUnderApproval = isUnderApproval(taskIds);

        for (GC_GES_Order_Task__c got : gots) {
            taskIds.add(got.Id);

            Boolean validateStatus = GC_PageUtil.validateGesTask(got);

            if (!validateStatus) {
                errors++;
                continue;
            }

            if (tasksUnderApproval.containsKey(got.Id) && tasksUnderApproval.get(got.Id)) {
                GC_PageUtil.AddErrorMessage('The Task is Already under approval.');
                errors++;
                continue;
            }

            GC_GES_Order_Task__c updatedTask = updateTaskApprovers(got, showId, accountManagersTeam, graphicsTeam, graphicsDirect);

            if (updatedTask != null) {
                tasksToUpdate.add(updatedTask);
            }
        }

        // Update new approver fields needed by approval processes
        Database.update(tasksToUpdate, false);
      /*  List<GC_GES_Order_Task__Share> shareTaskWithGPMD = new List<GC_GES_Order_Task__Share>();
        for(GC_GES_Order_Task__c task: tasksToUpdate) {
            
            // create share objects so that the GPM Direct user will be able to edit the record.
            if(task.GPM_Direct__c != null && (task.Item_Template__c =='Graphics') ){
                GC_GES_Order_Task__Share shareObject = new GC_GES_Order_Task__Share();
                shareObject.ParentId = task.Id;
                shareObject.UserOrGroupId = task.GPM_Direct__c;
                shareObject.AccessLevel = 'Edit';
                shareTaskWithGPMD.add(shareObject);
            }
        }
        //database.insert(shareTaskWithGPMD, false);
        system.debug('shareTaskWithGPMD==='+shareTaskWithGPMD);
        */
        for(GC_GES_Order_Task__c task: tasksToUpdate) {
            
            
            if (submitTaskForApproval(task)) {
                successes++;
            }
            else {
                errors++;
            }
        }
        
        
        
        return successes > 0;
    }

    //public List<GC_GES_Order_Task__c> tasksToUpdate {get; private set;}

    //public static Boolean submitForApproval(GC_GES_Order_Task__c got) {
    //    return submitForApproval(got, null, null, null, null, null);
    //}

    //public static Boolean submitForApproval(GC_GES_Order_Task__c got, String showId, List<GC_Show_Team_Member__c> accountTeam, List<GC_Show_Team_Member__c> graphicsTeam, List<GC_Show_Team_Member__c> gpmDirect, List<GC_GES_Order_Task__c> tasks) {
    //    if (got.OwnerId != UserInfo.getUserId()) {
    //        GC_PageUtil.AddErrorMessage('The task may only be submitted by the task owner.');
    //        return false;
    //    } else {
    //        //Validation Rule:
    //        Boolean validateStatus = GC_PageUtil.validateGesTask(got);

    //        if (!validateStatus) {
    //            return false;
    //        }

    //        if (GC_ApprovalUtils.isUnderApproval(got.Id)) {
    //            GC_PageUtil.AddErrorMessage('The Task is Already under approval.');
    //            return false;
    //        }

    //        got = updateTaskApprovers(got, showId, accountTeam, graphicsTeam, gpmDirect);

    //        if (got == null) {
    //            return false;
    //        }

    //        if (tasks != null) {
    //            tasks.add(got);
    //        } else {
    //            update got;
    //            return submitTaskForApproval(got);
    //        }

    //        return true;
    //    }
    //}

    public static GC_GES_Order_Task__c updateTaskApprovers(GC_GES_Order_Task__c got, String showId, List<GC_Show_Team_Member__c> accountTeam, List<GC_Show_Team_Member__c> graphicsTeam, List<GC_Show_Team_Member__c> gpmDirect) {
        if (showId == null) {
            showId = got.Order__r.Connect2_Show__c;
        }

        if (accountTeam == null) {
            accountTeam = [Select Id, Name, User__c, Connect2_Show__c, Show_Role__c , User__r.Email
                           From GC_Show_Team_Member__c
                           Where Connect2_Show__c = :showId and (Show_Role__c = 'Account Manager' or
                                                    Show_Role__c = 'Secondary Account Manager')
                                                    Order By Show_Role__c asc, LastModifiedDate desc];
        }

        if (graphicsTeam == null) {
            graphicsTeam = [Select Id, Name, User__c, Connect2_Show__c, Show_Role__c , User__r.Email
                            From GC_Show_Team_Member__c
                            Where Connect2_Show__c = :showId
                                    and (Show_Role__c = 'Graphics Project Manager')
                                    Order By LastModifiedDate desc];
        }

        if (gpmDirect == null) {
            gpmDirect = [Select Id, Name, User__c, Connect2_Show__c, Show_Role__c , User__r.Email
                         From GC_Show_Team_Member__c
                         Where Connect2_Show__c = :showId
                                                  and (Show_Role__c = 'Graphics Project Manager Direct')
                                                  Order By LastModifiedDate desc];
        }

        // Blank out all approver fields and repopulate in case record has been submitted previously and team changed
        got.AM_Approver_1__c = null;
        got.AM_Approver_2__c = null;
        got.AM_Approver_3__c = null;
        got.AM_Approver_4__c = null;
        got.AM_Approver_5__c = null;
        got.AM_Approver_6__c = null;
        got.AM_Approver_7__c = null;
        got.AM_Approver_8__c = null;
        got.AM_Approver_9__c = null;
        got.AM_Approver_10__c = null;
        got.AM_Approver_11__c = null;
        got.AM_Approver_12__c = null;
        got.AM_Approver_13__c = null;
        got.AM_Approver_14__c = null;
        got.AM_Approver_15__c = null;

        got.GPM_Approver_1__c = null;
        got.GPM_Approver_2__c = null;
        got.GPM_Approver_3__c = null;
        got.GPM_Direct__c = null;

        for (GC_Show_Team_Member__c teamMember : accountTeam) {
            if (got.AM_Approver_1__c == null) {
                got.AM_Approver_1__c = teamMember.User__c;
            } else if (got.AM_Approver_2__c == null) {
                got.AM_Approver_2__c = teamMember.User__c;
            } else if (got.AM_Approver_3__c == null) {
                got.AM_Approver_3__c = teamMember.User__c;
            } else if (got.AM_Approver_4__c == null) {
                got.AM_Approver_4__c = teamMember.User__c;
            } else if (got.AM_Approver_5__c == null) {
                got.AM_Approver_5__c = teamMember.User__c;
            } else if (got.AM_Approver_6__c == null) {
                got.AM_Approver_6__c = teamMember.User__c;
            } else if (got.AM_Approver_7__c == null) {
                got.AM_Approver_7__c = teamMember.User__c;
            } else if (got.AM_Approver_8__c == null) {
                got.AM_Approver_8__c = teamMember.User__c;
            } else if (got.AM_Approver_9__c == null) {
                got.AM_Approver_9__c = teamMember.User__c;
            } else if (got.AM_Approver_10__c == null) {
                got.AM_Approver_10__c = teamMember.User__c;
            } else if (got.AM_Approver_11__c == null) {
                got.AM_Approver_11__c = teamMember.User__c;
            } else if (got.AM_Approver_12__c == null) {
                got.AM_Approver_12__c = teamMember.User__c;
            } else if (got.AM_Approver_13__c == null) {
                got.AM_Approver_13__c = teamMember.User__c;
            } else if (got.AM_Approver_14__c == null) {
                got.AM_Approver_14__c = teamMember.User__c;
            } else if (got.AM_Approver_15__c == null) {
                got.AM_Approver_15__c = teamMember.User__c;
            }
        }

        for (GC_Show_Team_Member__c teamMember : graphicsTeam) {
            if (got.GPM_Approver_1__c == null) {
                got.GPM_Approver_1__c = teamMember.User__c;
            } else if (got.GPM_Approver_2__c == null) {
                got.GPM_Approver_2__c = teamMember.User__c;
            } else if (got.GPM_Approver_3__c == null) {
                got.GPM_Approver_3__c = teamMember.User__c;
            }
        }

        if (gpmDirect.size() > 0) {
            got.GPM_Direct__c = gpmDirect[0].User__c;
        }

        // If any of the approver lookups are empty, need to fill them out with existing approver to prevent error
        if (got.AM_Approver_1__c != null) {
            if (got.AM_Approver_2__c == null) {
                got.AM_Approver_2__c = got.AM_Approver_1__c;
            }

            if (got.AM_Approver_3__c == null) {
                got.AM_Approver_3__c = got.AM_Approver_1__c;
            }

            if (got.AM_Approver_4__c == null) {
                got.AM_Approver_4__c = got.AM_Approver_1__c;
            }

            if (got.AM_Approver_5__c == null) {
                got.AM_Approver_5__c = got.AM_Approver_1__c;
            }

            if (got.AM_Approver_6__c == null) {
                got.AM_Approver_6__c = got.AM_Approver_1__c;
            }

            if (got.AM_Approver_7__c == null) {
                got.AM_Approver_7__c = got.AM_Approver_1__c;
            }

            if (got.AM_Approver_8__c == null) {
                got.AM_Approver_8__c = got.AM_Approver_1__c;
            }

            if (got.AM_Approver_9__c == null) {
                got.AM_Approver_9__c = got.AM_Approver_1__c;
            }

            if (got.AM_Approver_10__c == null) {
                got.AM_Approver_10__c = got.AM_Approver_1__c;
            }

            if (got.AM_Approver_11__c == null) {
                got.AM_Approver_11__c = got.AM_Approver_1__c;
            }

            if (got.AM_Approver_12__c == null) {
                got.AM_Approver_12__c = got.AM_Approver_1__c;
            }

            if (got.AM_Approver_13__c == null) {
                got.AM_Approver_13__c = got.AM_Approver_1__c;
            }

            if (got.AM_Approver_14__c == null) {
                got.AM_Approver_14__c = got.AM_Approver_1__c;
            }

            if (got.AM_Approver_15__c == null) {
                got.AM_Approver_15__c = got.AM_Approver_1__c;
            }
        } else {
            GC_PageUtil.AddErrorMessage('Account Manager is not assigned to show as a show team member. Cannot submit task.');
            return null;
        }

        if (got.GPM_Approver_1__c != null) {
            if (got.GPM_Approver_2__c == null) {
                got.GPM_Approver_2__c = got.GPM_Approver_1__c;
            }

            if (got.GPM_Approver_3__c == null) {
                got.GPM_Approver_3__c = got.GPM_Approver_1__c;
            }
        }
        return got;
    }

    public static Boolean submitTaskForApproval(GC_GES_Order_Task__c got) {
        // Create an approval request
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval');
        req1.setObjectId(got.Id);
        
// for SAL - 421== forking the approval process based on criteria
        if (got.GPM_Direct__c != null && (got.Item_Template__c =='Graphics') && got.Status__c=='Pending AM Review' ){
            req1.setProcessDefinitionNameOrId(ShowOrgGpmToAMSubmit);
        }
        /*if(got.GPM_Direct__c != null && (got.Item_Template__c =='Graphics') ){           
            req1.setProcessDefinitionNameOrId(ShowOrgGraphicsSubmit);
            // create a sharing rule to give access to the GPM Direct user
            
        } */
        else if (got.GPM_Direct__c != null && (got.Item_Template__c =='Graphics')){
            req1.setProcessDefinitionNameOrId(ShowOrgGraphicsSubmit);
        }else{
            req1.setProcessDefinitionNameOrId(ShowOrgSubmit);
        }
        

        // Submit the approval request for the account
        try {
            Approval.ProcessResult result = Approval.process(req1);
            GC_PageUtil.AddDeveloperMessage('Task has been Submitted for approval');
            return true;
            // GC-739 Email will be sent as a result of this to any GPM Direct Role Users.
            // Upon Active change.
        } catch (Exception e) {
            GC_PageUtil.AddErrorMessage('Failed to Submit the Task for Approval ' + e.getMessage());
            GC_PageUtil.AddDeveloperMessage('Failed to Submit the Task for Approval ' + e.getStackTraceString());
            return false;
        }
    }
    
    // for SAL 421- rksinha
    public static Boolean submitForGPMApproval(GC_GES_Order_Task__c got, String approvalProcess) {
        system.debug('got==='+got);
        // Create an approval request
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for GPM approval');
        req1.setObjectId(got.Id);
        
        req1.setProcessDefinitionNameOrId(approvalProcess);

        // Submit the approval request for the account
        try {
            Approval.ProcessResult result = Approval.process(req1);
            GC_PageUtil.AddDeveloperMessage('Task has been Submitted for GPM approval');
            return true;
            // GC-739 Email will be sent as a result of this to any GPM Direct Role Users.
            // Upon Active change.
        } catch (Exception e) {
            GC_PageUtil.AddErrorMessage('Failed to Submit the Task for Approval ' + e.getMessage());
            GC_PageUtil.AddDeveloperMessage('Failed to Submit the Task for Approval ' + e.getStackTraceString());
            return false;
        }
    }

    public static Boolean approveTask(GC_GES_Order_Task__c got) {
        try {
            Set<Id> gotIds = new Set<Id>();
            gotIds.add(got.Id);
            approveRecord(gotIds, 'Approve for submission to Core.');
            return true;
        } catch (Exception e) {
            GC_PageUtil.AddErrorMessage('Failed to approve task due to: ' + e.getMessage());
            return false;
        }
    }

    public static Boolean approveTasks(List<GC_GES_Order_Task__c> gots) {
        try {
            Set<Id> gotIds = new Set<Id>();
            for (GC_GES_Order_Task__c got : gots) {
                gotIds.add(got.Id);
            }
            approveRecord(gotIds, 'Approve for submission to Core.');
            return true;
        } catch (Exception e) {
            GC_PageUtil.AddErrorMessage('Failed to approve task due to: ' + e.getMessage());
            return false;
        }
    }

    public static void approveRecord(Set<Id> workItemId, String approvalText) {
        Set<Id> procinIds = new Set<Id>();
        Set<Id> setTargetObjectIds = new Set<Id>();
        system.debug('workItemId==='+workItemId);
        List<ProcessInstance> procins = [select Id from ProcessInstance where Status = 'Pending' and TargetObjectId in :workItemId];
        system.debug('procins==='+procins);
        for (ProcessInstance procin : procins) {
             procinIds.add(procin.Id);
        }
        system.debug('procinIds==='+procinIds);
        // Retrieve the process work instance id associated to the process instance
        List<ProcessInstanceWorkitem>  workitems = [select Id, ProcessInstance.TargetObjectId, ActorId from ProcessInstanceWorkitem where ProcessInstanceId in :procinIds];
        system.debug('workitems==='+workitems.size());
        for (ProcessInstanceWorkitem item : workitems) {
            if(!setTargetObjectIds.contains(item.ProcessInstance.TargetObjectId) && item.ActorId==UserInfo.getUserId()) {
                Approval.ProcessWorkItemRequest pwr = new Approval.ProcessWorkItemRequest();
               // system.debug('item==='+item);
               //system.debug('ProcessInstance.TargetObjectId==='+item.ProcessInstance.TargetObjectId);
               //system.debug('item.ActorId==='+item.ActorId);
                pwr.SetComments(approvalText);
                pwr.setWorkItemId(item.id);
                pwr.setAction('Approve');
                system.debug('pwr==='+pwr);
                // Execute process request
                try {
                    Approval.ProcessResult pr = Approval.process(pwr);
                    // setTargetObjectIds.add(item.ProcessInstance.TargetObjectId);
                } catch(Exception e) {
                    GC_PageUtil.AddErrorMessage('Failed to approve the task.' + e.getMessage());
                    System.debug(e.getMessage());
                }
            }
        }
    }

}