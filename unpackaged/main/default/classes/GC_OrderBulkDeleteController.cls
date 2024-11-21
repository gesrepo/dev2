/**
* @author Rahul Sinha   for SLK Software Services
* @description Controller for Bulk deletion of GES Order Tasks
* 23-02-2018 : Original Version
**/

public with sharing class GC_OrderBulkDeleteController {

    public List<GC_Order__c> orders {get; set;}
    public List<ResultWrapper> resultList {get; set;}
    //public String header {get; set;}
    //public String message {get; set;}
    public Set<Id> ordersToDelete = new Set<Id>();
    public GC_OrderBulkDeleteController(ApexPages.StandardSetController controller) {
        orders = controller.getSelected();
        resultList = new List<ResultWrapper>();
    }

    public void bulkDelete(){
        if(orders.size()>0){
            //header='Are You Sure?';
            //message='Please Confirm else close this dialog box.';
            for(GC_Order__c order:orders){
                ordersToDelete.add(order.Id);
            }
            List<GC_GES_Order_Task__c> relatedTasksToDelete= [SELECT id, Name from GC_GES_Order_Task__c WHERE Order__c In :ordersToDelete ];
            List<GC_Vendor_Order_Task__c> relatedVOTsToDelete= [SELECT id, Name from GC_Vendor_Order_Task__c WHERE Order__c In :ordersToDelete ];
            Database.delete(relatedTasksToDelete, false);
            Database.delete(relatedVOTsToDelete, false);
        }//else{
            //header='No Orders Selected';
            //message='Please select one or more orders to delete.';
        //}
        
        Database.DeleteResult[] deleteResultsList = Database.delete(orders, false);
        
        if(deleteResultsList.size()>0){
            for(Database.DeleteResult dr : deleteResultsList) {
                ResultWrapper rw= new ResultWrapper(dr);
                resultList.add(rw);
            }
        }
    }
    public PageReference backAction() {
        return new PageReference('/' + GC_Order__c.sobjecttype.getDescribe().getKeyPrefix());
    }
    
    public class ResultWrapper{
        public String name {get; set;}
        public String status {get; set;}
        
        public resultWrapper(Database.DeleteResult dr){
            this.name= string.valueOf(dr.getId());
            //this.status= string.valueOf(dr.isSuccess());
            if(dr.isSuccess()){
                this.status='Deleted Successfully';
            }else{
                for(Database.Error err : dr.getErrors()) {
                        this.status='The following error has occurred--'+string.valueOf(err.getMessage());
                    }
            }
        }
    }
}