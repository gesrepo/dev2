/**
* @author Ethos Solutions - www.ethos.com
* @description Trigger logic for GES Order Task
* 2016-04-13 : Original Version
**/
public without sharing class GC_GESOrderTaskTriggerHandler {
    public static void UpdateShowTeamAccess(List<GC_GES_Order_Task__c> gotOrderTask) {
        Set<Id> gotIds = new Set<Id>();

        for (GC_GES_Order_Task__c got : gotOrderTask) {
            gotIds.add(got.Id);
        }

        List<GC_GES_Order_Task__c> gotQuery = [select Id,Order__r.Connect2_Show__c,Order__r.Name,Order__r.Show_Name__c,Name,Connect2_Show_Number__c,Item_Number__c,Job_Number__c from GC_GES_Order_Task__c where Id In :gotIds];
        Set<Id> showIds = new Set<Id>();

        for (GC_GES_Order_Task__c got : gotQuery) {
            showIds.add(got.Order__r.Connect2_Show__c);
        }

        List<GC_Show_Team_Member__c> showTeamMembers = [select Id, Name, User__c, Show_Role__c, Connect2_Show__c from GC_Show_Team_Member__c where Connect2_Show__c in :showIds];
        GC_ShowTeamMemberTriggerHandler.UpdateRecordAccessGESOrderTasks(showTeamMembers, gotQuery);
    }

    /*public static void HandleOnHoldStatus(List<GC_GES_Order_Task__c> gesOrders) {
        for (GC_GES_Order_Task__c ges : gesOrders) {
            if (ges.Status__c == 'On Hold' && ges.Is_On_Hold__c == false) {
                ges.Is_On_Hold__c = true;

            } else if (ges.Status__c == 'On Hold' && ges.Is_On_Hold__c == true) {
                ges.addError('Object has be placed on hold, no edits are allowed.');

            } else if (ges.Status__c != 'On Hold' && ges.Is_On_Hold__c == true) {
                ges.Is_On_Hold__c = false;
            }
        }
    }*/

    public static void HandleCancelStatus(List<GC_GES_Order_Task__c> gesOrders) {
        for (GC_GES_Order_Task__c ges : gesOrders) {
            // this should only ever be set through code, and if set through code, we allow it.
            if (ges.Core_Cancelled__c == true) {
                continue;
            }

            if (ges.Status__c == 'Canceled' && ges.Is_Canceled__c == false) {
                ges.Is_Canceled__c = true;

            } else if (ges.Status__c == 'Canceled' && ges.Is_Canceled__c == true) {
                ges.addError(' Object is canceled. Please clone in order to make changes.');

            } else if (ges.Status__c != 'Canceled' && ges.Is_Canceled__c == true) {
                ges.Is_Canceled__c = false;
            }
        }
    }

 public static void HandleOrderStatus(List<GC_GES_Order_Task__c> gesOrders) {
    Set<String> activeOrders = new Set<String>();
    Set<String> cancelledOrders = new Set<String>();
    Map<String, String> mapOrderStatus = new Map<String, String>();
    Map<String, List<GC_GES_Order_Task__c>> orderTaskMap = new Map<String, List<GC_GES_Order_Task__c>>();

    for (GC_GES_Order_Task__c task : gesOrders) {
        orderTaskMap.put(task.Order__c, new List<GC_GES_Order_Task__c>());
    }

    //---Create map of Order Id -> list of Order tasks
    for (GC_GES_Order_Task__c task : GC_GESOrderTaskDao.getInstance().getGesOrderTaskByOrderSet(orderTaskMap.keySet())) {
        Id orderId = task.Order__c;
        orderTaskMap.get(orderId).add(task);
    }

    //---Loop through list of order tasks
    //---If any order task is Active the whole order is active
    //---If all order tasks are Canceled, the order is Canceled
    for (String orderId : orderTaskMap.keySet()) {
        //Boolean isActive = false;
        //Boolean isCancelled = true;
        Integer onHoldTask = 0;
        Integer canceledTask = 0;
        Integer approvedTask = 0;
       // Integer excludedTask = 0; // SAL-536 all integers are being added to update the order status based on the status of order tasks
        Integer totalTask = 0;
        Integer submittedTask = 0;
        Integer newTask = 0;
        Integer activeTask = 0;
        Integer releasedTask = 0;
        Integer submittedGraphicsTask= 0;

        for (GC_GES_Order_Task__c task : orderTaskMap.get(orderId)) {
            totalTask += 1;
            //if(task.status__c=='Active' ){  --Amarab 06/22/2023 SAL-1287 Status not reflecting correctly when Orders are in Proof Status
            if(task.status__c=='Active' || task.status__c== 'Proof Waiting for Approval' || task.status__c== 'Proof Changes Required' || task.status__c== 'Proof Approved'){               
                activeTask +=1;                
            } else
            if(task.status__c=='Released'){
                releasedTask += 1;
            }else
            if(task.status__c=='Canceled' || task.status__c=='Rejected'||task.status__c=='Archived'){
                canceledTask += 1;
            } else
            if(task.status__c=='On Hold'){
                onHoldTask += 1;
            } else 
            if(task.status__c=='Approved'){
                approvedTask += 1;
            }else if(task.status__c=='Submitted'){
                submittedTask += 1;
            } else if(task.status__c=='Graphics Submitted' || task.status__c=='Submitted to Graphics'){
                submittedGraphicsTask += 1;
            }else {
                newTask += 1;
                break;
            }
        }
                
            if(newTask > 0) {
            mapOrderStatus.put(orderId, 'New');
          // if any one task is new, The entire order will be updated as New
            } else
            if(submittedTask>0 && newTask==0) {
                mapOrderStatus.put(orderId, 'Submitted'); // order status will be Submitted if all task are submitted excluding tasks which are on 
                // hold / cancelled. The same logic apllies for the other status changes
            } else
            if( approvedTask>0 && newTask==0 && submittedTask==0) {
                mapOrderStatus.put(orderId, 'Approved');
            } else
            if (activeTask>0 && newTask==0 && submittedTask==0 && approvedTask==0) {
                mapOrderStatus.put(orderId, 'Active');
            } else
            if (submittedGraphicsTask >0 && (activeTask== totalTask-(canceledTask + onHoldTask + submittedGraphicsTask)) ) {
                mapOrderStatus.put(orderId, 'Submitted to Graphics');
            }else
            if(totalTask == (releasedTask + canceledTask + onHoldTask) && releasedTask>0) {
                mapOrderStatus.put(orderId, 'Released');
            }  else
            if(totalTask == canceledTask) {
                mapOrderStatus.put(orderId, 'Canceled'); // if all tasks are cancelled, The  order will be updated as cancelled
            } else
            if(totalTask == onHoldTask) {
                mapOrderStatus.put(orderId, 'On Hold'); // if all tasks are on hold, The  order will be updated as On Hold
            }
    }

    Set<String> allIds = new Set<String>();
    allIds.addAll(mapOrderStatus.keySet());

    //---Update parent order status
    if (!allIds.isEmpty()) {
        List<GC_Order__c> updateOrders = GC_OrderDao.getInstance().getOrderByIds(allIds);

        for (GC_Order__c order : updateOrders) { // SAl-536
            String orderIdToUpdate = order.Id;
            if (mapOrderStatus.containsKey(orderIdToUpdate)) {
                order.Status__c = mapOrderStatus.get(orderIdToUpdate);
            }
        }

        update updateOrders;
    }
}


    public static void HandleOrderNumbers(Map<Id, GC_GES_Order_Task__c> oldMap, Map<Id, GC_GES_Order_Task__c> newMap) {
        Map<String, GC_GES_Order_Task__c> orderTaskMap = new Map<String, GC_GES_Order_Task__c>();

        for (GC_GES_Order_Task__c task : newMap.values()) {
            if (oldMap.get(task.Id).Status__c != 'Active' && task.Status__c == 'Active') {
                orderTaskMap.put(task.Order__c, task);
            }
        }

        if (!orderTaskMap.isEmpty()) {
            List<GC_Order__c> updateOrders = GC_OrderDao.getInstance().getOrderByIds(orderTaskMap.keySet());

            for (GC_Order__c order : updateOrders) {
                order.Order_Number__c = orderTaskMap.get(order.Id).Order_Number__c;
            }

            update updateOrders;
        }
    }

    // GC-722
    public static void HandleOrderRevisions(Map<Id, GC_GES_Order_Task__c> oldMap, Map<Id, GC_GES_Order_Task__c> newMap) {
        Set<String> revisions = new Set<String>();

        for (GC_GES_Order_Task__c task : newMap.values()) {
            if (task.Previous_Revision__c != null && ((oldMap.get(task.Id).Status__c != 'Active' && task.Status__c == 'Active') || task.Status__c == 'New')) {
                revisions.add(task.Previous_Revision__c);
            }
        }

        if (revisions.size() > 0) {
            List<GC_GES_Order_Task__c> revisedTasks = GC_GESOrderTaskDao.getInstance().getGESOrderTaskByIds(revisions);

            for (GC_GES_Order_Task__c task : revisedTasks) {
                task.Status__c = 'Archived';
                task.Is_Active__c = false;
            }

            update revisedTasks;
        }
    }

    public static void HandleEmailToOriginator(Map<Id, GC_GES_Order_Task__c> oldMap, Map<Id, GC_GES_Order_Task__c> newMap) {
       /* List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();

        for (Id i : oldMap.keySet()) {
            if (oldMap.get(i).Status__c == 'Approved' && newMap.get(i).Status__c == 'Active' && newMap.get(i).OwnerId != UserInfo.getUserId()) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTargetObjectId(newMap.get(i).OwnerId);
                //mail.setSubject('Task ' + newMap.get(i).Name + ' has been submitted to the external system');
                mail.setSubject('Order ' + newMap.get(i).Order__r.Name + ' / Task ' + newMap.get(i).Name + ' is now active');
                String body = '';
                body += 'Task: ' + newMap.get(i).Name + ' has been submitted to the external system.\r\n';
                body += 'Submitted by: ' + UserInfo.getUserName() + '.\r\n';
                body += 'Show Name: ' + newMap.get(i).Order__r.Show_Name__c+ '.\r\n';   
                body += 'Job Number: ' + newMap.get(i).Job_Number__c+ '.\r\n'; 
                body += 'Connect2 Show: ' + newMap.get(i).Connect2_Show_Number__c+ '.\r\n';
                body += 'Order Number: ' + newMap.get(i).Order__r.Name + '.\r\n';
                body += 'Booth Area: ' + newMap.get(i).Formula_Booth_Area__c + '.\r\n';
                body += 'Item Type: ' + newMap.get(i).Item_Template__c + '.\r\n';
                body += 'Item Description: ' + newMap.get(i).Description__c + '.\r\n';
                body += 'Item Number: ' + newMap.get(i).Item_Number__c + '.\r\n';
                body += 'Special Instructions: ' + newMap.get(i).Show_Management_Field__c + '.\r\n';
                body += 'User Description: ' + newMap.get(i).User_Item_Description__c + '.\r\n';
                mail.setPlainTextBody(body);
                mail.setSaveAsActivity(false);
                mails.add(mail);
            }
        }

        try {
            if (mails.size() > 0) {
                Messaging.sendEmail(mails, true);
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
        } */
    } 


    public static void HandleEmailToGraphics(Map<Id, GC_GES_Order_Task__c> oldMap, Map<Id, GC_GES_Order_Task__c> newMap) {
        return;
        // Below is some apex code to send emails via apex, alternatively we'll send email alerts through workflows.
//        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();

//        Set<String> newSubmittedTasks = new Set<String>();
//        Set<String> newActiveTasks = new Set<String>();

//        for (Id i : oldMap.keySet()) {
//            // ignore all non graphics items.
//            if (newMap.get(i).Item_Template__c == null || !newMap.get(i).Item_Template__c.contains('Graphics')) {
//                continue;
//            }

//            // capture all graphics team members when the state changes from approved to active
//            if (oldMap.get(i).Status__c == 'Approved' && newMap.get(i).Status__c == 'Active') {
//                newActiveTasks.add(i);
//            }

//            // capture all graphics team member direct when the state changes from approved to active.
//            if (oldMap.get(i).Status__c != 'Submitted' && newMap.get(i).Status__c == 'Submitted') {
//                newSubmittedTasks.add(i);
//            }
//        }

//        if (newActiveTasks.size() == 0 && newSubmittedTasks.size() == 0) {
//            return;
//        }

//        List<EmailTemplate> emailTemplates = [select Id, Name from EmailTemplate where DeveloperName = 'GPM_Task_Summary'];

//        if (emailTemplates.size() == 0) {
//            System.debug(loggingLevel.Error, '*** There are no email templates of the name GPM Task Summary: ');
//            return;
//        }

//        if (newActiveTasks.size() > 0) {
//            // TODO need to find all show team members for each show and obtain a mapping.
//            List<GC_GES_Order_Task__c> activeTasks = GC_GESOrderTaskDao.getInstance().getGESOrderTaskByIds(newActiveTasks);
//            System.debug(loggingLevel.Error, '*** activeTasks: ' + activeTasks);

//            Set<Id> showIds = new Set<Id>();

//            for (GC_GES_Order_Task__c task : activeTasks) {
//                showIds.add(task.Order__r.Connect2_Show__c);
//                mails.add(buildGraphicsEmail('bfaber@ethos.com', task, emailTemplates[0]));
//            }

//            // determine who to send to

//            //List<GC_Show_Team_Member__c> gpms = [select Id, Name, Connect2_Show__c from GC_Show_Team_Member__c where Connect2_Show__c in :showIds
////                                                 and Show_Role__c = 'Graphics Project Manager'];

//            // Find all graphics project managers by show
//        }

//        if (newSubmittedTasks.size() > 0) {
//            List<GC_GES_Order_Task__c> submittedTasks = GC_GESOrderTaskDao.getInstance().getGESOrderTaskByIds(newSubmittedTasks);
//        }

//        System.debug(loggingLevel.Error, '*** mails: ' + mails);

//        if (mails.size() > 0) {
//            try {
//                Messaging.sendEmail(mails);

//            } catch (Exception e) {
//                System.debug(LoggingLevel.ERROR, e.getMessage() + ' -- ' + e.getStackTraceString());
//            }
//        }
    }

    //private static Messaging.SingleEmailMessage buildGraphicsEmail(String emailAddress, GC_GES_Order_Task__c task, EmailTemplate template) {
    //    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    //    mail.setTargetObjectId(task.Id);
    //    mail.setTemplateId(template.Id);
    //    mail.setToAddresses(new String[]{emailAddress});
    //    return mail;
    //}

    public static final Set<String> NOTIFY_CHANGE_FIELDS = new Set<String> {
        'Delivery_Date_Time__c'
        , 'Removal_Date_Time__c'
        , 'Completion_Date_Time__c'
        , 'Item_Number__c'
        , 'Description__c'
        , 'Price__c'
        , 'Quantity__c'
        , 'QuantityNum__c'
        , 'UOM__c'
        , 'Sign_Title__c'
        , 'Carpet_Length__c'
        , 'Carpet_Width__c'
        , 'User_Item_Description__c'
        , 'Submitted_Date__c'
        , 'Revision__c'
        , 'Line_Item_Status__c'
        , 'Line_Item_Number__c'
        , 'Status__c'
    };

    public static void HandleFieldUpdateEmails(Map<Id, GC_GES_Order_Task__c> oldMap, Map<Id, GC_GES_Order_Task__c> newMap) {
        if (!(GC_OrderUtils.getCustomSettings().Send_Show_Org_Emails__c == true)) {
            return;
        }

        Set<Id> orderIds = new Set<Id>();

        for (GC_GES_Order_Task__c gesTask : newMap.values()) {
            orderIds.add(gesTask.Order__c);
        }

        Map<Id, GC_Order__c> orders = new Map<Id, GC_Order__c>([Select Id, Name, Connect2_Show__c from GC_Order__c where Id in :orderIds]);

        Set<Id> showIds = new Set<Id>();

        for (GC_Order__c order : orders.values()) {
            showIds.add(order.Connect2_Show__c);
        }

        List<GC_Show_Team_Member__c> showOrganizers = [Select Id, User__c, Connect2_Show__c from GC_Show_Team_Member__c
                where Connect2_Show__c in :showIds
                and Show_Role__c = 'Show Organizer'];

        Map<Id, Set<Id>> organizersByShow = new Map<Id, Set<Id>>();

        System.debug(LoggingLevel.ERROR, 'Show organizers: ' + JSON.serialize(showOrganizers));

        for (GC_Show_Team_Member__c organizer : showOrganizers) {
            if (!organizersByShow.containsKey(organizer.Connect2_Show__c)) {
                organizersByShow.put(organizer.Connect2_Show__c, new Set<Id>());
            }

            organizersByShow.get(organizer.Connect2_Show__c).add(organizer.User__c);
        }

        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        for (Id taskId : newMap.keySet()) {
            GC_GES_Order_Task__c oldObj = oldMap.get(taskId);
            GC_GES_Order_Task__c newObj = newMap.get(taskId);

            List<String> changedFields = new List<String>();

            for (String fieldName : NOTIFY_CHANGE_FIELDS) {
                if (GC_ReflectionUtil.fieldChanged(oldObj, newObj, fieldName)) {
                    changedFields.add(fieldName);
                }
            }

            if (changedFields.size() > 0) {
                GC_Order__c order = orders.get(newObj.Order__c);
                Id showId = order.Connect2_Show__c;

                if (organizersByShow.containsKey(showId) && !organizersByShow.get(showId).contains(UserInfo.getUserId())) {
                    // Current user is not an organizer

                    for (Id organizerId : organizersByShow.get(showId)) {
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

                        mail.setTargetObjectId(organizerId);

                        mail.setSubject('Task ' + newObj.Name + ' has been changed');

                        String body = '';
                        body += 'Task: ' + newObj.Name + ' has been changed.\r\n';
                        body += 'Submitted by: ' + UserInfo.getName() + ' (' + UserInfo.getUserName() + ').\r\n';
                        body += 'Show Name: ' + newObj.Show_Name__c + '\r\n';
                        body += 'Order Number: ' + order.Name + '\r\n';
                        body += 'Booth Area: ' + newObj.Formula_Booth_Area__c + '\r\n';


                        for (String fieldName : changedFields) {
                            body += '\r\n------------\r\nField: ' + GC_ReflectionUtil.getLabel('GC_GES_Order_Task__c', fieldName) + '\r\n';

                            if (GC_ReflectionUtil.getDisplayType('GC_GES_Order_Task__c', fieldName) == Schema.DisplayType.DateTime) {
                                body += oldObj.get(fieldName) != null ? 'Old Value: ' + ((DateTime)oldObj.get(fieldName)).format() + '\r\n' : 'Old Value: ' + oldObj.get(fieldName) + '\r\n';
                                body += newObj.get(fieldName) != null ? 'New Value: ' + ((DateTime)newObj.get(fieldName)).format() + '\r\n' : 'New Value: ' + newObj.get(fieldName) + '\r\n';

                            } else {
                                body += 'Old Value: ' + oldObj.get(fieldName) + '\r\n';
                                body += 'New Value: ' + newObj.get(fieldName) + '\r\n';
                            }
                        }

                        mail.setPlainTextBody(body);
                        mail.setSaveAsActivity(false);
                        emails.add(mail);
                    }
                }
            }
        }

        if (emails.size() > 0) {
            try {
                Messaging.sendEmail(emails);

            } catch (Exception e) {
                System.debug(LoggingLevel.ERROR, e.getMessage() + ' -- ' + e.getStackTraceString());
            }
        }
    }

    public static void CheckChangeOwner(Map<Id, GC_GES_Order_Task__c> oldMap, Map<Id, GC_GES_Order_Task__c> newMap) {
        List<GC_GES_Order_Task__c> recalcRecords = new List<GC_GES_Order_Task__c>();

        for (Id taskId : Trigger.newMap.keySet()) {
            if (oldMap.get(taskId).OwnerId != newMap.get(taskId).OwnerId) {
                recalcRecords.add(newMap.get(taskId));

                if (recalcRecords.size() > 0) {
                    UpdateShowTeamAccess(recalcRecords);

                }
            }
        }
    }
}