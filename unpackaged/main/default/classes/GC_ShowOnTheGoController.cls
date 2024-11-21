/**
* @author Ethos Solutions - www.ethos.com
* @description Controller for the Show On The Go PDF Page
* 2016-04-12 : Original Version
**/
public with sharing class GC_ShowOnTheGoController {
    
    public List<GC_Vendor_Order_Task__c> vots {get; set;}
    public List<GC_GES_Order_Task__c> gots {get; set;}
    public List<GC_Order__c> orders {get; set;}
    public datetime showcreated  {get;set;}
    
    public datetime  showModify {get;set;}
    public string  Showdate{get;set;}
    public date startdate {get;set;}
    public date enddate{get;set;}
    public List<GC_OrderHolder> OrderWrappers {get; set;}
    public String signOrderOpt{get; set;} //for SAL 527
    public String workOrderOpt{get; set;} //for SAL 527
    public GC_Core_Interface_Log__c urlParamsObject;
    public set<id> allIdSet = new set<id>();
    public Map<Id, List<ContentVersion>> result ;
    public map<id, ContentVersion> cdlToDocMap{get; set;}
    
    public GC_ShowOnTheGoController() {
        result= new Map<Id, List<ContentVersion>>();
        reload();
    }
    
    public PageReference reload() {
        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'test'));
        //Grab all related voT and goT Objects and fields
        //Get got/vot Params
        try {
            Set<String> statusValues = new Set<String>();
            String urlParams = ApexPages.currentPage().getParameters().get('urlParamsId');
            String signOrderOpt = ApexPages.currentPage().getParameters().get('signOrderOpt');
            String workOrderOpt = ApexPages.currentPage().getParameters().get('workOrderOpt');
            system.debug('urlParams======================>'+urlParams);
            String orderId;
            urlParamsObject= new GC_Core_Interface_Log__c();
            if (String.isNotBlank(urlParams)) {
                urlParamsObject = [select Id, Name, Method_Name__c, Message_Content__c from GC_Core_Interface_Log__c where Id = :urlParams];
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, JSON.serializePretty(urlParamsObject)));
                System.debug(loggingLevel.Error, '*** urlParamsObject.Method_Name__c: ' + urlParamsObject.Method_Name__c);
                GC_OrderUtils.URLParameters orderParams = (GC_OrderUtils.URLParameters)JSON.deserialize(urlParamsObject.Message_Content__c, GC_OrderUtils.URLParameters.Class);
                orderId = String.join(new List<String>(orderParams.orderIds), ',');
                statusValues = orderParams.statusValues;
                
            } else {
                
                orderId = ApexPages.currentPage().getParameters().get('orderIds');
            }
            
            List<String> orderList = orderId.split(',');
            Set<String> orderSet = new Set<String>();
            
            for (String theOrderList : orderList) {
                orderSet.add(theOrderList);
            }
            
            List<GC_Order__c> orderQuery = GC_OrderDao.getInstance().getOrderByIds(orderSet);
            
            orders = orderQuery;
            
            vots = GC_VendorOrderTaskDao.getInstance().getVendorOrderTaskByOrderSet(orderSet);
            gots = GC_GESOrderTaskDao.getInstance().getGesOrderTaskByOrderSet(orderSet);
            
            OrderWrappers = new List<GC_OrderHolder>();
            
            for (GC_Order__c order : orderQuery) {
                GC_OrderHolder orderHolder = new GC_OrderHolder(order);
                
                for (GC_GES_Order_Task__c gotItem : gots) {
                    if (gotItem.Status__c == 'Archived') {
                        continue;
                    }
                    if (statusValues.size() > 0 && !statusValues.contains(gotItem.Status__c)) {
                        continue;
                    }
                    if (gotItem.Order__c == order.Id) {
                        allIdSet.add(gotItem.id);
                        if(signOrderOpt=='true' && (gotItem.Item_Template__c == 'Graphics' || gotItem.Item_Number__c=='900301')) { //for SAL 527
                            orderHolder.gesTasks.add(gotItem);
                        }
                        if(workOrderOpt =='true' && gotItem.Item_Template__c != 'Graphics') { //for SAL 527
                            orderHolder.gesTasks.add(gotItem);
                        }
                        if((workOrderOpt =='false' && signOrderOpt=='false')|| (workOrderOpt==null && signOrderOpt==null )) { //for SAL 527
                            orderHolder.gesTasks.add(gotItem);
                        }
                    }
                }
                
                for (GC_Vendor_Order_Task__c votItem : vots) {
                    if (votItem.Order__c == order.Id) {
                        orderHolder.vendorTasks.add(votItem);
                        allIdSet.add(votItem.id);
                    }
                }
                OrderWrappers.add(orderHolder);
            }
            system.debug('orderwrappers values ===========================>'+ OrderWrappers);
            set<string> shownum=new set<string>();            
            
            for(GC_OrderHolder gc:OrderWrappers){
                shownum.add(gc.order.Connect2_Show__r.Name);
            }
            
            system.debug('shownum value==============>'+shownum);
            GC_Connect2_Show__c Gc=[select owner.name,CreatedDate,LastModifiedDate,FormulaShowDates__c,Show_Start_Date__c,Show_End_Date__c from GC_Connect2_Show__c where Name IN:shownum];
            
            showcreated=gc.CreatedDate;
            showModify=gc.LastModifiedDate; 
            Showdate=gc.FormulaShowDates__c;
            startdate=Gc.Show_Start_Date__c;
            system.debug('startdate @@@@@@@'+startdate);
            enddate=Gc.Show_End_Date__c;
            system.debug('enddate @@@@'+enddate);
            result=GC_EmailUtils.getContentDocs(allIdSet);
            cdlToDocMap = new map<id, ContentVersion>();
            if(result==null){
                result= new Map<Id, List<ContentVersion>>();
            }else{
                for(id recId: result.keyset()){
                    for(ContentVersion cntVar :result.get(recId)){
                        cdlToDocMap.put(cntVar.ContentDocumentId, cntVar);
                    }
                }
            }
            
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getMessage()));
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getStackTraceString()));
        }
        
        return null;
    }
    
    public String getBaseURL() {
        URL currentURL = URL.getCurrentRequestUrl();
        String currentPath = currentURL.getPath();
        String communityName = currentPath.substringBefore('/apex/');
        String attachmentURL = URL.getSalesforceBaseUrl().toExternalForm() + communityName + '/servlet/servlet.FileDownload?file=';
        return attachmentURL;
    }
    
    public String getBaseURLForDocs() {
        URL currentURL = URL.getCurrentRequestUrl();
        String currentPath = currentURL.getPath();
        String communityName = currentPath.substringBefore('/apex/');
        String attachmentURL = URL.getSalesforceBaseUrl().toExternalForm() + communityName + '/sfc/servlet.shepherd/version/download/';
        return attachmentURL;
    }
}