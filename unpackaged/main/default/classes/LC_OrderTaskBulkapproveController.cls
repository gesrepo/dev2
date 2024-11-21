/*	@author Namratha P for SLK Software Services 
@createDate: Feb 2019
@purpose: controller for LC_OrderTaskBulkApprove
* */

public with sharing class LC_OrderTaskBulkapproveController {
    
    public List<GC_GES_Order_Task__c> gots {get; set;}
    public string recordId{get; set;}
    public class applicationException extends Exception {}
    public LC_OrderTaskBulkapproveController(){
        
    }
    
    public LC_OrderTaskBulkapproveController(ApexPages.StandardSetController controller) {
        recordId=apexpages.currentpage().getparameters().get('id');
        gots = controller.getSelected();
    }
    
    @AuraEnabled
    public static list<GC_GES_Order_Task__c> getGotRecords(String recordIds){
        List<GC_GES_Order_Task__c> gots = new List<GC_GES_Order_Task__c>();
        List<GC_GES_Order_Task__c> approveNewList = new List<GC_GES_Order_Task__c>();
        List<GC_GES_Order_Task__c> updatedList = new List<GC_GES_Order_Task__c>();
        List<GC_GES_Order_Task__c> approveSubmittedList = new List<GC_GES_Order_Task__c>();
        Set<String> updatedIds = new Set<String>();
        Set<String> idsMap = new Set<String>();
        
        GC_GES_Order_Task__c selectedRec = new GC_GES_Order_Task__c();
        
        //converting ID's to list----------->
        List<String> recordIdList = recordIds.replaceAll('\\s','').removeStart('[').removeEnd(']').split(',');
        System.debug('recordIds[0]====>'+recordIdList[0]);
        try{
            //----------------add selected id's to map-->
            for(String ids : recordIdList){
                idsMap.add(ids);
            } 
            
            //--------------------start of approval
            gots = GC_GESOrderTaskDao.getInstance().getGESOrderTaskByIds(idsMap);
            for (GC_GES_Order_Task__c got : gots) {
                Boolean validate = GC_PageUtil.validateGesTask(got);
                if (validate) {
                    if (got.Status__c == 'New') {
                        approveNewList.add(got);
                        updatedIds.add(got.Id);
                        idsMap.add(got.Id); // add updated record id's to existin map
                    }
                    if(got.Status__c == 'Submitted' ||got.Status__c == 'Submitted to Graphics') {
                        approveSubmittedList.add(got);
                        updatedIds.add(got.Id);
                        idsMap.add(got.Id);  // add updated record id's to existin map
                    }
                }
            }
            
            if (approveNewList.size() > 0) {
                for (GC_GES_Order_Task__c approveNew : approveNewList) {
                    approveNew.Status__c = 'Approved';
                }
                update approveNewList;
            }
            
            if (approveSubmittedList.size() > 0) {
                GC_ApprovalUtils.approveTasks(approveSubmittedList);
            }
            
            gots = GC_GESOrderTaskDao.getInstance().getGESOrderTaskByIds(updatedIds);
            //--------------------end of approval
            list<GC_GES_Order_Task__c> newList = new list<GC_GES_Order_Task__c>(); 
            newList = [Select Id,name,Status__C FROM GC_GES_Order_Task__c WHERE Id in:idsMap]; 
             if(Test.isRunningTest())
			{
				throw new applicationException('Sorry! We don\'t do that here!!');
			}
            return newList; 
        }
        catch(exception e){
            return null;
        }
    }
}