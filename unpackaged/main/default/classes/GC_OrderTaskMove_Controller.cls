public with sharing class GC_OrderTaskMove_Controller {
    
    public String sortOrder {get; set;}
    public String orderByQuery {get; set;}
    public string str {get;set;}
    public string str1 {get;set;}
    public Boolean isDisplayed {get; set;}
    public Boolean showContent {get; set;}
    public Boolean showContent1 {get; set;}
    public Boolean display {get; set;}
    public Boolean display1 {get; set;}
    public List<SelectOption> opt {get;set;}
    public List<wrapOrdTask> ordTaskList {get; set;}
    public List<GC_GES_Order_Task__c> selectedOrdTasks{get;set;}
    public List<GC_GES_Order_Task__c> gotMov{get;set;}
    public List<SelectOption> optns {get;set;}
    public set<Id> TaskId {get;set;}
    public String Connect2ShowId {get; set;}

     public GC_OrderTaskMove_Controller(ApexPages.StandardController sc)
     {
         str='';
         str1='';
         showContent = false;
         showContent1 = true;
         display = false;
         display1 = true;
         String orderId = ApexPages.currentPage().getParameters().get('OrderId');
         String showId = ApexPages.currentPage().getParameters().get('showId');
        if(ordTaskList == null) {
            ordTaskList = new List<wrapOrdTask>();
            for(GC_GES_Order_Task__c got : [select Id,Name,Description__c,Total__c,Item_Number__c,Price__c,QuantityNum__c,UOM__c,Order__r.Connect2_Show__c from GC_GES_Order_Task__c where order__c=:orderId and (Status__c='New' or Status__c='Submitted' or Status__c='Approved')]) 
            {
                ordTaskList.add(new wrapOrdTask(got));
                Connect2ShowId = got.Order__r.Connect2_Show__c;
            }
        }
        
        opt = new List<Selectoption>();
                List<GC_Order__C> existingOrder =[select Id,name,status__c,Delivery_Date_Time__c,Booth_Area__c,User_Name__c,
                                                  Connect2_Show__c  from GC_Order__C where Connect2_Show__c =:showId  order by Name ASC];
    
        for(GC_Order__C ordr : existingOrder){
            str1 = ordr.Name+'|'+ordr.Booth_Area__c+'|'+ordr.Delivery_Date_Time__c+'|'+ordr.status__c+'|'+ordr.User_Name__c;
            opt.add(new selectOption(ordr.Id, str1));
        }  
    }


         public class wrapOrdTask
         {
            public GC_GES_Order_Task__c ordtask {get; set;}
            public Boolean selected {get; set;}
 
            public wrapOrdTask(GC_GES_Order_Task__c g) {
                ordtask = g;
                selected = false;
            }
         }
        
         public String selectedshow{get;set;}  // This will hold the show name, the id in here
         public String selectedOrder{get;set;}// This will hold the order name, the id in here
         
          
        public PageReference cancelclone() 
        {
            //string showId = ApexPages.currentPage().getParameters().get('showId');
            string orderId = ApexPages.currentPage().getParameters().get('orderId');
            string isCommunity = ApexPages.currentPage().getParameters().get('isCommunity');
            if(isCommunity == 'true')
            {
              return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_OrderView?orderId=' + orderId +'&showId='+Connect2ShowId);
            }
            else
            {
              return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_OrderView?id=' + orderId +'&sfdc.override=1');
            }
            
        }
    
        public PageReference moveOrdTasks()
        {
            selectedOrdTasks = New List<GC_GES_Order_Task__c>();
            TaskId = New set<Id>();
            List<GC_GES_Order_Task__c> ordTasksToBeMoved = New List<GC_GES_Order_Task__c>();
            for(wrapOrdTask Task : ordTaskList){
                if(Task.selected==True){
                    selectedOrdTasks.add(Task.ordtask);
                }
            }
            
            for(GC_GES_Order_Task__c ordtsk: selectedOrdTasks){
                TaskId.add(ordtsk.Id);
            }
            
            if(String.isBlank(selectedOrder))
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR , 'You must select an Order'));
                return null;
            }

            if (TaskId.size() == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR , 'You must select at least one Order Task'));
                return null;
            }

            gotMov = [select id,order__c from GC_GES_Order_Task__c where Id in : TaskId];
            
            for(GC_GES_Order_Task__c movGot : gotMov)
            { 
                movGot.order__c = selectedOrder; 
                ordTasksToBeMoved.add(movGot);
            }
            
            update ordTasksToBeMoved;

            if (String.isNotBlank(selectedOrder)) 
            {
                return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_OrderView?id='+selectedOrder+'&sfdc.override=1');
            }
            else
            {
               return null;
            }
        }
}