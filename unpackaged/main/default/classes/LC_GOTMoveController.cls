//This controller is used for both Move and Clone actions of GOT List
public with sharing class LC_GOTMoveController {
    
    @AuraEnabled
    public static List<ShowWrapper> getOpenShows(){
        List<ShowWrapper> showWrapList = new List<ShowWrapper>();
        Set<Id> showmem = New Set<Id>();
        for(GC_Show_Team_Member__c sm: [SELECT connect2_show__c FROM GC_Show_Team_Member__c WHERE User__c=:UserInfo.getUserId()]){
            showmem.add(sm.connect2_show__c);
        }
        List<GC_Connect2_Show__c> existingShows = [SELECT Id, Name, Show_Name__c, Facility__c, Facility_Address__c, 
                                                   Show_Start_Date__c, Show_End_Date__c FROM GC_Connect2_Show__c
                                                   WHERE Id IN :showmem  LIMIT 1000];
        
        for(GC_Connect2_Show__c show: existingShows){
            String showDescription = show.Name + '|' + show.Show_Name__c + '|' + show.Facility__c + '|' 
                + show.Show_Start_Date__c + '|' + show.Show_End_Date__c;
            
            ShowWrapper sWrap = new ShowWrapper(show.Id, showDescription);
            showWrapList.add(sWrap); 
        }
        return showWrapList;
    }
    
    @AuraEnabled
    public static List<OrderWrapper> getExistingOrdersForShowByOrderId(string orderId){
        String showId = LC_AppUtils.getShowIdforOrder(orderId).Connect2_Show__c;
        return getExistingOrdersForShow(showId, orderId);
    }
    
    @AuraEnabled
    public static List<OrderWrapper> getExistingOrdersForShow(string showId, string orderId){
        List<OrderWrapper> orderWrappers = new List<OrderWrapper>();
        
        List<GC_Order__C> existingOrders =[SELECT Id, Name, status__c, Delivery_Date_Time__c, Booth_Area__c, User_Name__c,
                                           Connect2_Show__c FROM GC_Order__c WHERE Connect2_Show__c =:showId and Id !=:orderId
                                           ORDER BY Name ASC];
        
        for(GC_Order__C ordr : existingOrders){
            String orderInfo = ordr.Name + '|' + ordr.Booth_Area__c + '|' + ordr.Delivery_Date_Time__c + '|' + ordr.status__c + '|' + ordr.User_Name__c;
            OrderWrapper ordWrapper = new OrderWrapper(String.valueOf(ordr.Id), orderInfo);
            orderWrappers.add(ordWrapper);
        }
        return orderWrappers;
    }
    
    @AuraEnabled
    public static List<GC_GES_Order_Task__c> getAvailableOrderTasksForOrder(string orderId, string context){
        
        List<GC_GES_Order_Task__c> gots = new List<GC_GES_Order_Task__c>();
        
        if(context.equalsIgnoreCase('Move')){
            gots =  [SELECT Id, Name, Description__c, Total__c, Item_Number__c, Price__c,
                     QuantityNum__c, UOM__c, Order__r.Connect2_Show__c FROM GC_GES_Order_Task__c
                     WHERE order__c=:orderId AND (Status__c='New' OR Status__c='Submitted' OR Status__c='Approved')];
            
        }
        else if(context.equalsIgnoreCase('Clone')){
            gots =  [SELECT Id, Name, Description__c, Total__c, Item_Number__c, Price__c,
                     QuantityNum__c, UOM__c, Order__r.Connect2_Show__c FROM GC_GES_Order_Task__c
                     WHERE order__c=:orderId AND (Status__c != 'Archived')];
        }
        
        if(gots.size() > 0)
            return gots;
        else
            throw new AuraHandledException('No Tasks are available to ' + context);
    }
    
    @AuraEnabled
    public static void moveGESOrderTasks(string orderId, List<string> taskIds){
        System.debug('Move----Move');
        List<GC_GES_Order_Task__c> ordTasksToBeMoved = New List<GC_GES_Order_Task__c>();
        
        if(String.isBlank(orderId))
            throw new AuraHandledException('You must select an Order');
        
        if (taskIds.size() == 0)
            throw new AuraHandledException('You must select at least one Order Task');
        
        List<GC_GES_Order_Task__c> gotsToMove = [SELECT Id, Order__c FROM GC_GES_Order_Task__c WHERE Id IN : taskIds];
        
        for(GC_GES_Order_Task__c movGot : gotsToMove){ 
            movGot.order__c = orderId; 
            ordTasksToBeMoved.add(movGot);
        }
        try{
            update ordTasksToBeMoved;
        }
        catch(DMLException dme){
            throw new AuraHandledException(dme.getMessage());
        }
    }
    
    @AuraEnabled
    public static void cloneGESOrderTasks(string showId, string orderId, List<string> taskIds){
        System.debug('taskIds-----'+taskIds);
        System.debug('showId-----'+showId);
        System.debug('orderId-----'+orderId);
        List<GC_GES_Order_Task__c> ordTasksToBeCloned = New List<GC_GES_Order_Task__c>();
        
        Set<String> taskIdSet = new Set<String>();
        taskIdSet.addAll(taskIds);
        
        if(String.isBlank(showId))
            throw new AuraHandledException('You must select a Show');
        
        if(String.isBlank(orderId))
            throw new AuraHandledException('You must select an Order');
        
        if (taskIds.size() == 0)
            throw new AuraHandledException('You must select at least one Order Task');
        
        //not all fields should be cloned, so including the required fields only
        /*List<GC_GES_Order_Task__c> gotsToClone = [SELECT Id, Item_Number__c, Description__c, User_Item_Description__c,
UOM__c, QuantityNum__c,Price__c, Item_Category_ID__c, Item_Template__c,
Show_Management_Field__c, SA_Venue_Location__c, Onsite_Contact__c,
Onsite_Contact_Person_Other__c, Onsite_Contact_Person_Number_Other__c,
Delivery_Location__c, Department__c, Budget_Code__c, Sign_Title__c, 
GOT_Sign_Type__c, GOT_Single_Double_Sided__c, GOT_Sign_Type_Other__c,
Material__c, GOT_Copy_Placement__c, Booth_Area_Discount__c, 
Labor_In_Out__c, Booth_Area_Discount_Override__c, Discount_Reason_Code__c,
Discount_Reason_Text__c, Delivery_Date_Time__c, Completion_Date_Time__c,
Removal_Date_Time__c, Outdoors__c, Installation_Method__c, Save_Signs__c,
GOT_Background__c, Sign_Copy__c, Layout__c FROM GC_GES_Order_Task__c 
WHERE Id in : taskIds];*/
        List<GC_GES_Order_Task__c> gotsToClone = GC_GESOrderTaskDao.getInstance().getGESOrderTaskByIds(taskIdSet);
        for(GC_GES_Order_Task__c cloneGot : gotsToClone){
            String oldVenue = cloneGot.SA_Venue_Location__c;
            String venueOldName = null;
            String oldDept = cloneGot.Department__c;
            String materialName = cloneGot.Material__c;
                        if(oldDept!=null){
                            cloneGot.Department__c = null;
                        }
            if(materialName!=null){
                cloneGot.Material__c = null;
            }
                        if(oldVenue!=null && oldVenue!=''){
                       List<GC_Show_Attribute__c> venueList = [select Name from GC_Show_Attribute__c where Id=:oldVenue];
                            if(venueList.size()>0){
                                for(GC_Show_Attribute__c venues : venueList){
                                    venueOldName = venues.Name;
                            if(venueOldName!=null){
                        List<GC_Show_Attribute__c> newVenues =[select Id from GC_Show_Attribute__c where Connect2_Show__c=:showId And Name =:venueOldName];
                                    String newVenueId = null;
                                    if(newVenues.size()>0){
                                       for(GC_Show_Attribute__c newVenue: newVenues){
                                        newVenueId = newVenue.Id;
                                    }
                                    cloneGot.SA_Venue_Location__c = newVenueId;
                                    }else{
                                     cloneGot.SA_Venue_Location__c = newVenueId;   
                                    }
                                }
                                }
                            }
                        }
            GC_GES_Order_Task__c newGOT = GC_PageUtil.cloneTask(cloneGot);  
            //Added by KN, 7/29/2019 SAL-1164 and HTML copy issue
            newGOT = LC_AppUtils.copyGOTFields(newGOT);
            System.debug('newcloneGOT----'+newGOT);
            newGOT.Order__c = orderId;
            ordTasksToBeCloned.add(newGOT);
        }
        try{
            insert ordTasksToBeCloned;
        }
        catch(DMLException dme){
            throw new AuraHandledException(dme.getMessage());
        }
    }
    
    public class OrderWrapper{
        @AuraEnabled
        public String orderId {get; set;}
        @AuraEnabled
        public String orderDescription {get; set;}
        
        public OrderWrapper(string oid, string odesc) {
            orderId = oid;
            orderDescription = odesc;
        }
    }
    
    public class ShowWrapper{
        @AuraEnabled
        public String showId {get; set;}
        @AuraEnabled
        public String showDescription {get; set;}
        
        public ShowWrapper(string sid, string sdesc) {
            showId = sid;
            showDescription = sdesc;
        }
    }
}