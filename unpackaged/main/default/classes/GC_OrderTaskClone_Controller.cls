public with sharing class GC_OrderTaskClone_Controller {
    
    public String sortOrder {get; set;}
    public String orderByQuery {get; set;}
    public string str {get;set;}
    public string str1 {get;set;}
    public Boolean isDisplayed {get; set;}
    public Boolean showContent {get; set;}
    public Boolean showContent1 {get; set;}
    public Boolean display {get; set;}
    public Boolean display1 {get; set;}
    public Boolean noOrderError{get; set;}
    public Boolean disableCloneBtn{get; set;}
    public List<SelectOption> opt {get;set;}
    public List<wrapOrdTask> ordTaskList {get; set;}
    public List<GC_GES_Order_Task__c> selectedOrdTasks{get;set;}
    public List<GC_GES_Order_Task__c> gotcln{get;set;}
    public List<SelectOption> optns {get;set;}
    public set<Id> TaskId {get;set;}
    public String Connect2ShowId {get; set;}
    
    public GC_OrderTaskClone_Controller(ApexPages.StandardController sc){
        str='';
        str1='';
        showContent = false;
        showContent1 = true;
        display = false;
        display1 = true;
        noOrderError= false;
        disableCloneBtn = false;
        String orderId = ApexPages.currentPage().getParameters().get('orderId');
        if(ordTaskList == null) {
            ordTaskList = new List<wrapOrdTask>();
            for(GC_GES_Order_Task__c got : [select id,Name,Total__c,Item_Number__c,Description__c,User_Item_Description__c,UOM__c,QuantityNum__c,Price__c,Item_Category_ID__c,Item_Template__c,Show_Management_Field__c,SA_Venue_Location__c,Onsite_Contact__c,Onsite_Contact_Person_Other__c,Onsite_Contact_Person_Number_Other__c,Delivery_Location__c,Department__c,Budget_Code__c,Sign_Title__c,GOT_Sign_Type__c,GOT_Single_Double_Sided__c,GOT_Sign_Type_Other__c,Material__c,GOT_Copy_Placement__c,
                                            Outdoors__c,Installation_Method__c, Booth_Area_Discount__c,Labor_In_Out__c,Booth_Area_Discount_Override__c,Discount_Reason_Code__c,Discount_Reason_Text__c,Delivery_Date_Time__c,Completion_Date_Time__c,Removal_Date_Time__c,Save_Signs__c,GOT_Background__c,Sign_Copy__c,Layout__c,Order__r.Connect2_Show__c from GC_GES_Order_Task__c where order__c=:orderId AND Status__c != 'Archived']) {
                                                
                                                ordTaskList.add(new wrapOrdTask(got));
                                                Connect2ShowId = got.Order__r.Connect2_Show__c;
                                            }
        }
    }
    
    
    public class wrapOrdTask{
        public GC_GES_Order_Task__c ordtask {get; set;}
        public Boolean selected {get; set;}
        
        public wrapOrdTask(GC_GES_Order_Task__c g) {
            ordtask = g;
            selected = false;
        }
    }
    
    public String selectedshow{get;set;}  // This will hold the show name, the id in here
    
    public String selectedOrder{get;set;}// This will hold the order name, the id in here
    
    public PageReference getopenShowOptions(){
        system.debug('get shows');
        if(showContent){
            showContent = false;
            showContent1 = true;
        }
        else{
            showContent = true;
            showContent1 = false;
        }
        optns = new List<Selectoption>();
        
        List<Id> showmem = New List<Id>();
        system.debug('user id '+UserInfo.getUserId());
        for(GC_Show_Team_Member__c sm: [select connect2_show__c from GC_Show_Team_Member__c where User__c=:UserInfo.getUserId()]){
            showmem.add(sm.connect2_show__c);
        }
        
        system.debug('show ids'+showmem);
        List<GC_Connect2_Show__c> existingshow =[select Id, Name,Show_Name__c,Facility__c,Facility_Address__c,Show_Start_Date__c,Show_End_Date__c 
                                                 from GC_Connect2_Show__c  where id in :showmem  limit 100];
        
        //List<GC_Connect2_Show__c> existingshow =[select Id, Name,Show_Name__c,Facility__c,Facility_Address__c,Show_Start_Date__c,Show_End_Date__c 
        //                                         from GC_Connect2_Show__c  where id = :'a3r40000000bqdj'];                                                    
        system.debug('existing shows'+existingshow);
        optns.add(new selectOption('', '--None--'));
        for(GC_Connect2_Show__c show : existingshow ){
            str = show.Name+'|'+show.Show_Name__c+'|'+show.Facility__c+'|'+show.Show_Start_Date__c+'|'+show.Show_End_Date__c;
            optns.add(new selectOption(show.Id, str));   
        } 
        system.debug('showid>>>>>'+selectedshow);
        
        return null;
    }
    
    public PageReference getopenOrderOptions(){
        system.debug('showid>>>>>++++++'+selectedshow);
        opt = new List<Selectoption>();
        List<GC_Order__C> existingOrder =[select Id,name,status__c,Delivery_Date_Time__c,Booth_Area__c,User_Name__c,Connect2_Show__c  from GC_Order__C where Connect2_Show__c = :selectedshow];
        if(existingOrder.IsEmpty()){
            noOrderError = true;
        	disableCloneBtn= true;
        }
        for(GC_Order__C ordr : existingOrder){
            noOrderError = false;
        	disableCloneBtn= false;
            str1 = ordr.Name+'|'+ordr.Booth_Area__c+'|'+ordr.Delivery_Date_Time__c+'|'+ordr.status__c+'|'+ordr.User_Name__c;
            opt.add(new selectOption(ordr.Id, str1));
        }  
        return null;
    }
    
    
    public PageReference cancelclone() {
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
    
    public PageReference cloneOrdTasks(){
        selectedOrdTasks = New List<GC_GES_Order_Task__c>();
        TaskId = New set<Id>();
        List<GC_GES_Order_Task__c> colnedOrdTasks = New List<GC_GES_Order_Task__c>();
        for(wrapOrdTask Task : ordTaskList){
            if(Task.selected==True){
                selectedOrdTasks.add(Task.ordtask);
            }
        }
        
        for(GC_GES_Order_Task__c ordtsk: selectedOrdTasks){
            TaskId.add(ordtsk.Id);
        }
        
        if (TaskId.size() == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR , 'You must select at least one Order Task'));
            return null;
        }
        
        gotcln = [select id,Item_Number__c,Description__c,User_Item_Description__c,UOM__c,QuantityNum__c,Price__c,Item_Category_ID__c,Item_Template__c,Show_Management_Field__c,SA_Venue_Location__c,Onsite_Contact__c,Onsite_Contact_Person_Other__c,Onsite_Contact_Person_Number_Other__c,Delivery_Location__c,Department__c,Budget_Code__c,Sign_Title__c,GOT_Sign_Type__c,GOT_Single_Double_Sided__c,GOT_Sign_Type_Other__c,Material__c,GOT_Copy_Placement__c,
                  Booth_Area_Discount__c,Labor_In_Out__c,Booth_Area_Discount_Override__c,Discount_Reason_Code__c,Discount_Reason_Text__c,Delivery_Date_Time__c,Completion_Date_Time__c,Removal_Date_Time__c,Outdoors__c,Installation_Method__c,Save_Signs__c,GOT_Background__c,Sign_Copy__c,Layout__c from GC_GES_Order_Task__c where Id in : TaskId];
        system.debug(gotcln);
        for(GC_GES_Order_Task__c clngot : gotcln){ 
            GC_GES_Order_Task__c newtask = new GC_GES_Order_Task__c();
            System.debug('selectedOrder-----------'+selectedOrder);
            newtask.order__c = selectedOrder;
            newtask.status__c = 'New';
            newtask.Item_Category_ID__c = clngot.Item_Category_ID__c;
            newtask.Item_Number__c = clngot.Item_Number__c;
            newtask.Item_Template__c = clngot.Item_Template__c;
            newtask.Description__c = clngot.Description__c;
            newtask.User_Item_Description__c = clngot.User_Item_Description__c;
            newtask.UOM__c = clngot.UOM__c; 
            newtask.QuantityNum__c = clngot.QuantityNum__c;
            newtask.Price__c = clngot.Price__c;
            newtask.Show_Management_Field__c = clngot.Show_Management_Field__c;
            newtask.SA_Venue_Location__c = clngot.SA_Venue_Location__c;
            newtask.Onsite_Contact__c = clngot.Onsite_Contact__c;
            newtask.Onsite_Contact_Person_Other__c = clngot.Onsite_Contact_Person_Other__c;
            newtask.Onsite_Contact_Person_Number_Other__c = clngot.Onsite_Contact_Person_Number_Other__c;
            newtask.Delivery_Location__c = clngot.Delivery_Location__c;
            newtask.Department__c = clngot.Department__c;
            newtask.Budget_Code__c = clngot.Budget_Code__c;
            newtask.Sign_Title__c = clngot.Sign_Title__c;
            newtask.GOT_Sign_Type__c = clngot.GOT_Sign_Type__c;
            newtask.GOT_Single_Double_Sided__c = clngot.GOT_Single_Double_Sided__c;
            newtask.GOT_Sign_Type_Other__c = clngot.GOT_Sign_Type_Other__c;
            newtask.Material__c = clngot.Material__c;
            newtask.GOT_Copy_Placement__c = clngot.GOT_Copy_Placement__c;
            newtask.Outdoors__c = clngot.Outdoors__c;
            newtask.Installation_Method__c = clngot.Installation_Method__c;
            newtask.Save_Signs__c = clngot.Save_Signs__c;
            newtask.GOT_Background__c = clngot.GOT_Background__c;
            newtask.Sign_Copy__c = clngot.Sign_Copy__c;
            newtask.Layout__c = clngot.Layout__c; 
            newtask.Delivery_Date_Time__c = clngot.Delivery_Date_Time__c;
            newtask.Completion_Date_Time__c =clngot.Completion_Date_Time__c;
            newtask.Removal_Date_Time__c= clngot.Removal_Date_Time__c;
            newtask.Labor_In_Out__c= clngot.Labor_In_Out__c;
            newtask.Discount_Reason_Code__c=clngot.Discount_Reason_Code__c;
            newtask.Discount_Reason_Text__c= clngot.Discount_Reason_Text__c;
            newtask.Booth_Area_Discount__c=clngot.Booth_Area_Discount__c;
            newtask.Booth_Area_Discount_Override__c = clngot.Booth_Area_Discount_Override__c;
            colnedOrdTasks.add(newtask);
            
            
        }
        
        system.debug(colnedOrdTasks);
        insert colnedOrdTasks;
        
        if (String.isNotBlank(selectedOrder)) 
        {
            string isCommunity = ApexPages.currentPage().getParameters().get('isCommunity');
            system.debug('isCommunity==='+isCommunity);
            if(isCommunity == 'true'){
                return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_OrderView?showId=' + selectedshow + '&orderId=' + selectedOrder);
            }
            else{
                system.debug('return to classic');
                return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_OrderView?id='+selectedOrder+'&sfdc.override=1');
            }
            
        } else {
            return null;
        }
        
    }
}