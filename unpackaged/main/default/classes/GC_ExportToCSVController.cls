public with sharing class GC_ExportToCSVController {
    public String csvContent {get; set;}
    public List<GC_Vendor_Order_Task__c> vots {get; set;}
    public List<GC_GES_Order_Task__c> gots {get; set;}
    public List<GC_Order__c> orders {get; set;}

    public List<GC_OrderHolder> OrderWrappers {get; set;}
    public GC_ExportToCSVController() {

        try {
            String isCommunity = ApexPages.currentPage().getParameters().get('isCommunity');

            String urlParams = ApexPages.currentPage().getParameters().get('urlParamsId');

            if (String.isNotBlank(urlParams)) {
                GC_Core_Interface_Log__c urlParamsObject = [select Id, Name, Method_Name__c, Message_Content__c from GC_Core_Interface_Log__c where Id = :urlParams];
                System.debug(loggingLevel.Error, '*** urlParamsObject.Method_Name__c: ' + urlParamsObject.Method_Name__c);
                GC_OrderUtils.URLParameters orderParams = (GC_OrderUtils.URLParameters)JSON.deserialize(urlParamsObject.Message_Content__c, GC_OrderUtils.URLParameters.Class);
                String orderIds = String.join(new List<String>(orderParams.orderIds), ',');

                if (String.isNotBlank(orderIds)) {
                    csvContent = GC_PageUtil.exportToCSV(orderIds, isCommunity == 'true');
                }
            } else {
                String orderIds = ApexPages.currentPage().getParameters().get('orderIds');

                if (String.isNotBlank(orderIds)) {
                    csvContent = GC_PageUtil.exportToCSV(orderIds, isCommunity == 'true');
                }
            }


        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getMessage()));
        }
    }
}