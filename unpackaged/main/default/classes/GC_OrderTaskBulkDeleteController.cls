/**
* @author Rahul Sinha   for SLK Software Services
* @description Controller for Bulk deletion of GES Order Tasks
* 23-02-2018 : Original Version
**/

public with sharing class GC_OrderTaskBulkDeleteController {

    public List<GC_GES_Order_Task__c> gots {get; set;}
    public List<ResultWrapper> resultList {get; set;}

    public GC_OrderTaskBulkDeleteController(ApexPages.StandardSetController controller) {
        gots = controller.getSelected();
    }

    public void bulkDelete(){
        Database.DeleteResult[] deleteResultsList = Database.delete(gots, false);
        resultList = new List<ResultWrapper>();
        if(deleteResultsList.size()>0){
            for(Database.DeleteResult dr : deleteResultsList) {
                ResultWrapper rw= new ResultWrapper(dr);
                resultList.add(rw);
                
            }

        }
                
        //backAction();
    }
    public PageReference backAction() {
        return new PageReference('/' + GC_GES_Order_Task__c.sobjecttype.getDescribe().getKeyPrefix());
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