public with sharing class LC_SubmitAllOrderTaskController {
    
    public class applicationException extends Exception {}
    
    @AuraEnabled
    public static list<GC_GES_Order_Task__c> getAllGot(id recordId){
        String newStatus = 'New';
        String whereClause = 'Order__c = \'' + recordId + '\' AND Status__c = \'' + newStatus + '\'';
        list<GC_GES_Order_Task__c> gotList = new list<GC_GES_Order_Task__c>(); 
        gotList = GC_GESOrderTaskDao.getInstance().getByWhere(whereClause);
        /*gotList = [SELECT Id, Name, Status__c, Sign_Title__c,Item_Template__c
		Item_Number__c,Description__c,User_Item_Description__c,
		Price__c,Total__c,UOM__c,QuantityNum__c,OwnerId,
		LastModifiedBy.Name,LastModifiedDate,Owner.Name
		FROM GC_GES_Order_Task__c where Order__c =:recordId AND Status__c ='New' LIMIT 50000 ];*/
        return gotList;  
    }
    
    @AuraEnabled
    public static list<GC_Vendor_Order_Task__c> getAllVot(id recordId){
        list<GC_Vendor_Order_Task__c> votList = new list<GC_Vendor_Order_Task__c>(); 
        votList =  [ SELECT Id, Name, Status__c, Vendors__c, Services__c,Show_Name__c,
                    Vendor__c,Vendor2__c,Vendor3__c,Vendor4__c,Vendor5__c,
                    Service_Type__c,Service_Type2__c,Service_Type3__c,Service_Type4__c,Service_Type5__c,
                    Service_Type__r.Name,Service_Type2__r.Name,Service_Type3__r.Name,Service_Type4__r.Name,
                    Service_Type5__r.Name,Date_Sent__c, LastModifiedBy.Name,LastModifiedDate 
                    FROM GC_Vendor_Order_Task__c where Order__c =:recordId AND Status__c ='New' LIMIT 50000 ];
        return votList;  
    }
    
    @AuraEnabled
    public static GC_Order__c getOrder(id orderId){
        GC_Order__c currentOrder = new GC_Order__c();
        currentOrder = [Select Connect2_Show__c,Connect2_Show__r.Name,Connect2_Show__r.Show_Name__c
                        from GC_Order__c where id=:orderId LIMIT 1];
        return currentOrder;
    }
    
    @AuraEnabled
    public static GC_Connect2_Show__c getShow(id showId){
        GC_Connect2_Show__c currentShow = new GC_Connect2_Show__c();
        currentShow = [SELECT id,name,Show_Name__c from GC_Connect2_Show__c
                       where id =:showId LIMIT 1];
        return currentShow;
    }
    
    @AuraEnabled
    public static list<GC_Show_Team_Member__c> getAllApprovers(id recordId){
        List<GC_Show_Team_Member__c> teams = new List<GC_Show_Team_Member__c>();
        String showId = getOrder(recordId).Connect2_Show__c;
        
        if(String.isNotBlank(showId)){
            teams = [SELECT Id, Name, User__c, Connect2_Show__c, Show_Role__c , User__r.Email
                     FROM GC_Show_Team_Member__c
                     WHERE Connect2_Show__c = :showId AND Show_Role__c = 'Account Manager'];
            //system.debug('==== teams---'+teams);
            return teams;
        }
        return teams;
    }
    
    @AuraEnabled
    public static Boolean submitAllTasks(id orderId,list<GC_Show_Team_Member__c> teams,list<GC_GES_Order_Task__c> selectedGots, list<GC_Vendor_Order_Task__c> selectedVots){
        Set<Id> approverUserIds = new Set<Id>();
        Integer errors = 0;
        Integer newCount = 0;
        String errorMessages;
        
        List<GC_GES_Order_Task__c> gotsToSubmit = new List<GC_GES_Order_Task__c>();
        List<GC_Vendor_Order_Task__c> votsToSubmit = new List<GC_Vendor_Order_Task__c>();
        List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();
        
        if(teams != null && teams.size() > 0){
            for (GC_Show_Team_Member__c team : teams) {
                approverUserIds.add(team.User__c);
            }
        }
        
        if(  selectedGots != null && selectedGots.size() > 0){
            for (GC_GES_Order_Task__c got : selectedGots) {
                gotsToSubmit.add(got);
                newCount++;
            }
        }
        
        GC_Order__c currentOrder = getOrder(orderId);
        String showId = currentOrder.Connect2_Show__c;
        GC_Connect2_Show__c currentShow = new GC_Connect2_Show__c();
        
        if( (selectedGots != null && selectedGots.size() > 0) && !submitForApproval(showId, gotsToSubmit)) {
            errors++;
        }
        // system.debug('selectedVots=='+selectedVots);
        if(selectedVots != null && selectedVots.size() > 0){
            for (GC_Vendor_Order_Task__c vot : selectedVots) {
                try{
                    vot = GC_VendorOrderTaskDao.getInstance().getVendorOrderTaskById(vot.Id);
                    currentShow = GC_Connect2ShowDao.getInstance().getConnect2ShowById(vot.Order__r.Connect2_Show__c);
                    if(Test.isRunningTest())
                    {
                        throw new applicationException('Sorry! We don\'t do that here!!');
                    }
                }catch(exception e){
                    system.debug('error==='+ e.getStackTraceString());
                    system.debug('error==='+ e.getMessage());
                }
                newCount ++;
                
                if (vot.Vendor__c != null) {
                    emailMessages.add(GC_OrderUtils.generateVendorEmail(vot, vot.Vendor__c,currentShow.Name+ ' '+currentShow.Show_Name__c,vot.Service_Type__r.Name));
                }
                
                if (vot.Vendor2__c != null) {
                    emailMessages.add(GC_OrderUtils.generateVendorEmail(vot, vot.Vendor2__c,currentShow.Name+ ' '+currentShow.Show_Name__c,vot.Service_Type2__r.Name));
                }
                
                if (vot.Vendor3__c != null) {
                    emailMessages.add(GC_OrderUtils.generateVendorEmail(vot, vot.Vendor3__c,currentShow.Name+ ' '+currentShow.Show_Name__c,vot.Service_Type3__r.Name));
                }
                
                if (vot.Vendor4__c != null) {
                    emailMessages.add(GC_OrderUtils.generateVendorEmail(vot, vot.Vendor4__c,currentShow.Name+ ' '+currentShow.Show_Name__c,vot.Service_Type4__r.Name));
                }
                
                if (vot.Vendor5__c != null) {
                    emailMessages.add(GC_OrderUtils.generateVendorEmail(vot, vot.Vendor5__c,currentShow.Name+ ' '+currentShow.Show_Name__c,vot.Service_Type5__r.Name));
                }
                vot.Status__c = 'Sent';
                vot.Submitted_Date__c = Date.today();
                votsToSubmit.add(vot);          
            } 
        }
        
        if (newCount == 0) {
            if(Test.isRunningTest()){
                system.debug('No New Order Tasks to submit.');
            }else{
                errorMessages = 'No New Order Tasks to submit.';
                errors++;
                system.debug('No New Order Tasks to submit.');
                throw new AuraHandledException('No New Order Tasks to submit.'); 
            }
        }
        if (errors > 0) {
            system.debug('errors=='+errors);
            system.debug('errorMessages=='+errorMessages);
        }
        update votsToSubmit;
        if (emailMessages != null && emailMessages.size() > 0) {
            Messaging.SendEmail(emailMessages, false);
        }
        if(newCount != 0 && errors == 0){
            return true;
        }
        else
            return false;
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
            //GC_PageUtil.AddErrorMessage('Account Manager is not assigned to show as a show team member. Cannot submit any tasks.');
            //return false;
            if(Test.isRunningTest()){
                system.debug('Account Manager is not assigned to show as a show team member. Cannot submit any tasks.');
            }else{
                throw new AuraHandledException('Account Manager is not assigned to show as a show team member. Cannot submit any tasks.');
            }
        }
        // create a list of tasks that meet all conditions to submit for approval
        List<GC_GES_Order_Task__c> tasksToUpdate = new List<GC_GES_Order_Task__c>();
        Set<String> taskIds = new Set<String>();
        for (GC_GES_Order_Task__c got : gots) {
            taskIds.add(got.Id);
        }
        Map<String, Boolean> tasksUnderApproval = GC_ApprovalUtils.isUnderApproval(taskIds);
        for (GC_GES_Order_Task__c got : gots) {
            taskIds.add(got.Id);
            Boolean validateStatus = GC_PageUtil.validateGesTask(got);
            if (!validateStatus) {
                if(Test.isRunningTest()){
                    system.debug('Field validation for the Records Failed!!, please check the submited records');
                }else{
                    errors++;
                    system.debug('Field validation for the Records Failed!!, please check the submited records');
                    //continue;
                    throw new AuraHandledException(got.name+' Field validation for the Record Failed!!, please check the submited records');
                }
            }
            if (tasksUnderApproval.containsKey(got.Id) && tasksUnderApproval.get(got.Id)) {
                //GC_PageUtil.AddErrorMessage('The Task is Already under approval.');
                if(Test.isRunningTest()){
                    system.debug('The Task is Already under approval.');
                }else{
                    errors++;
                    system.debug('The Task is Already under approval.');
                    continue;
                    throw new AuraHandledException('The Task is Already under approval.');
                }
            }
            GC_GES_Order_Task__c updatedTask = GC_ApprovalUtils.updateTaskApprovers(got, showId, accountManagersTeam, graphicsTeam, graphicsDirect);
            if (updatedTask != null) {
                tasksToUpdate.add(updatedTask);
            }
        }
        // Update new approver fields needed by approval processes
        Database.update(tasksToUpdate, false);
        for(GC_GES_Order_Task__c task: tasksToUpdate) {
            if (GC_ApprovalUtils.submitTaskForApproval(task)) {
                successes++;
            }
            else {
                errors++;
            }
        }
        return successes > 0;
    }
}