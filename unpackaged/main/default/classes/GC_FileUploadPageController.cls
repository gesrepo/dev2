public with sharing class GC_FileUploadPageController {

    /* public GC_FileUploadPageController(ApexPages.StandardController controller) {
        recordId= ApexPages.currentPage().getParameters().get('recordId');
        task=GC_VendorOrderTaskDao.getInstance().getVendorOrderTaskById(recordId);
        task.id=recordId;
    }    */

    public String recordId{get;set;}
    public String recordName{get;set;}
    public GC_Vendor_Order_Task__c task{get;set;}
    public GC_FileUploadPageController(){
        //recordName='';
        recordId= ApexPages.currentPage().getParameters().get('recordId');
        recordName=ApexPages.currentPage().getParameters().get('recordName');
        if(string.isBlank(recordName)){
            recordName=' ';
        }
        try{
            task=GC_VendorOrderTaskDao.getInstance().getVendorOrderTaskById(recordId);
        }catch(exception e){}
    }
}