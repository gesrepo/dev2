public with sharing class GC_OrderClone_Controller {    
    public List<GC_OrderHolder> orderHolders {get; set;}
    public List<GC_OrderHolder_WODL> orderHoldersWODL {get; set;}
    public GC_Connect2_Show__c show {get; set;}
    public List<SelectOption> deliveryLocations { get; set; }
    public List<SelectOption> deliveryAreas { get; set; }
    public List<SelectOption> departments { get; set; }
    public List<SelectOption> venueLocations { get; set; }
    public List<SelectOption> vendors { get; set; }
    public List<SelectOption> orderAreaDescriptions { get; set; }
    public List<SelectOption> Usernames{get;set;}
    public List<SelectOption> TypeofUsers{get;set;}
    public Set<String> orderIds {get;set;}
  public boolean flag {get;set;}
    public String orderQuery {get; set;}
    public String gotQuery {get; set;}
    public String votQuery {get; set;}
    public String department {get; set;}
    public String delivery {get; set;} // this is delivery area
    public String venue {get; set;}
    public String vendor {get; set;}
    public String Username{get;set;}
    public String TypeofUser{get;set;}
    public String areaDescription {get; set;}
    public String selectedVendor {get; set;}
    public String selectedOADescription {get; set;}
    public String deliveryLocation {get; set;}
    
    public List<GC_Order__c> gesOrders {get; set;}
    public String sortOrder {get; set;}
    public String orderByQuery {get; set;}
    public string str {get;set;}
    public Boolean isDisplayed {get; set;}
    public Boolean showContent {get; set;}
    public Boolean showContent1 {get; set;}
    
     public String searchString {get; set;}
     public String Showid{get;set;}
     public String showJobNumber {get; set;}
     public String fromShowJobNumber {get; set;}
    public Boolean showOrderGrids {get; set;}
    public Boolean showOrderGrids1 {get; set;}
    public List<SelectOption> delLocationToShow{get;set;}
    public List<SelectOption> delLocationFromShow{get;set;}
    
    public string fromShowDelLocMap{get;set;}
    public string toShowDelLocMap{get;set;}
    
    Public Set<String> deliveryLocationsToShow{get;set;}
    Public Set<String> deliveryLocationsFromShow{get;set;}
    public Set<String> deliveryLocationsInToShow{get;set;}
  public Date showDateDelivery {get; set;}
    public Date showDateCompletion {get; set;}
    public Date showDateRemoval {get; set;}
    public Date createdDateFrom {get; set;}
    public Date createdDateTo {get; set;}
    public Date modifiedDateFrom {get; set;}
    public Date modifiedDateTo {get; set;}
    public Map<String, DateTime> boothAreaDDT = new Map<String, DateTime>();        //SAL-537
    public Map<String, DateTime> boothAreaCDT = new Map<String, DateTime>();        //SAL-537
    public Map<String, DateTime> boothAreaRDT = new Map<String, DateTime>();        //SAL-537
    public Map<String, DateTime> boothAreaByName = new Map<String, DateTime>();        //SAL-537
    public Map<String, DateTime> boothAreaByName1 = new Map<String, DateTime>();        //SAL-537
    public Map<String, DateTime> boothAreaByName2 = new Map<String, DateTime>();        //SAL-537
    public Map<String, String> boothAreaIDByName = new Map<String, String>();        //SAL-537
    
    public GC_OrderClone_Controller(ApexPages.StandardController sc){        
        Showid=System.currentPageReference().getParameters().get('id'); 
        show = (GC_Connect2_Show__c)sc.getRecord();
        orderHolders = new List<GC_OrderHolder>();
        orderHoldersWODL = new List<GC_OrderHolder_WODL>();
        showContent = false;
        showContent1 = true;
        showOrderGrids = false;
        showOrderGrids1 = false;
        gesOrders = GC_OrderDao.getInstance().getByConnect2ShowId(show.Id);
        
        for (GC_Order__c order : gesOrders) {
            orderHolders.Add(new GC_OrderHolder(order));
        }
        
        List<GC_GES_Order_Task__c> gesTasks = GC_GESOrderTaskDao.getInstance().getByConnect2ShowId(show.Id);
        List<GC_Vendor_Order_Task__c> vendorTasks = GC_VendorOrderTaskDao.getInstance().getByConnect2ShowId(show.Id);
        
        str= '';
        deliveryLocations = new List<SelectOption>();
        orderAreaDescriptions = new List<SelectOption>();
        deliveryAreas = new List<SelectOption>();
        departments = new List<SelectOption>();
        Usernames =new List<SelectOption>();
        venueLocations = new List<SelectOption>();
        vendors = new List<SelectOption>();
        TypeofUsers=new List<SelectOption>();
        deliveryLocations.add(new SelectOption('', '----None----'));
        orderAreaDescriptions.add(new SelectOption('', '----None----'));
        deliveryAreas.add(new SelectOption('', '----None----'));
        departments.add(new SelectOption('', '----None----'));
        venueLocations.add(new SelectOption('', '----None----'));
        vendors.add(new SelectOption('', '----None----'));
        Usernames.add(new SelectOption('', '----None----'));
        TypeOfUsers.add(new SelectOption('','---None---'));
        delLocationToShow = new List<SelectOption>();
        delLocationFromShow = new List<SelectOption>();
        
        orderByQuery = 'Name';
        sortOrder = 'asc';
        isDisplayed = true;
        
        Set<String> deliveryLocationsSet = new Set<String>();
        Set<String> orderAreaDescriptionsSet = new Set<String>();
        Set<String> deliveryAreasSet = new Set<String>();
        Set<String> departmentsSet = new Set<String>();
        Set<String> venueLocationsSet = new Set<String>();
        Set<String> vendorsSet = new Set<String>();
        Set<String> Usernamesset= new Set<String>();
        Set<String>  TypeofUsersSet=new Set<String>();
        
        for (GC_Order__c o : gesOrders) {
            if (String.isNotBlank(o.Booth_Area__c) && !deliveryLocationsSet.contains(o.Booth_Area__c)) {
                deliveryLocationsSet.add(o.Booth_Area__c);
                deliveryLocations.add(new SelectOption(o.Booth_Area__c, o.Booth_Area__c));
            }
            if (String.isNotBlank(o.Order_Area_Description__c) && !orderAreaDescriptionsSet.contains(o.Order_Area_Description__c)) {
                orderAreaDescriptionsSet.add(o.Order_Area_Description__c);
                orderAreaDescriptions.add(new SelectOption(o.Order_Area_Description__c, o.Order_Area_Description__c));
            }
             if (String.isNotBlank(o.User_Name__c) && !usernamesSet.contains(o.User_Name__c)) {
                usernamesSet.add(o.User_Name__c);
                usernames.add(new SelectOption(o.User_Name__c, o.User_Name__c));
            }
        }
        for (GC_GES_Order_Task__c o : gesTasks) {
            if (String.isNotBlank(o.Delivery_Location__c) && !deliveryAreasSet.contains(o.Delivery_Location__c)) {
                deliveryAreasSet.add(o.Delivery_Location__c);
                deliveryAreas.add(new SelectOption(o.Delivery_Location__c, o.Delivery_Location__c));
            }
            if (String.isNotBlank(o.Department__r.Name) && !departmentsSet.contains(o.Department__r.Name)) {
                departmentsSet.add(o.Department__r.Name);
                departments.add(new SelectOption(o.Department__r.Name, o.Department__r.Name));
            }
            if(String.isNotBlank(o.SA_Venue_Location__r.Name) && !venueLocationsSet.contains(o.SA_Venue_Location__r.Name)){venueLocationsSet.add(o.SA_Venue_Location__r.Name);venueLocations.add(new SelectOption(o.SA_Venue_Location__r.Name, o.SA_Venue_Location__r.Name));}if (String.isNotBlank(o.User_Name__c) && !usernamesSet.contains(o.User_Name__c)){usernamesSet.add(o.User_Name__c);usernames.add(new SelectOption(o.User_Name__c, o.User_Name__c));}
        }
        for (GC_Vendor_Order_Task__c v : vendorTasks){
        if (String.isNotBlank(v.Vendor__r.Name) && !vendorsSet.contains(v.Vendor__r.Name)){
            vendorsSet.add(v.Vendor__r.Name);
            vendors.add(new SelectOption(v.Vendor__r.Name, v.Vendor__r.Name));} 
        
        if (String.isNotBlank(v.Vendor2__r.Name) && !vendorsSet.contains(v.Vendor2__r.Name)) {
            vendorsSet.add(v.Vendor2__r.Name);
            vendors.add(new SelectOption(v.Vendor2__r.Name, v.Vendor2__r.Name));} 
        if (String.isNotBlank(v.Vendor3__r.Name) && !vendorsSet.contains(v.Vendor3__r.Name)){
            vendorsSet.add(v.Vendor3__r.Name);
            vendors.add(new SelectOption(v.Vendor3__r.Name, v.Vendor3__r.Name));}
        if (String.isNotBlank(v.Vendor4__r.Name) && !vendorsSet.contains(v.Vendor4__r.Name)) {
            vendorsSet.add(v.Vendor4__r.Name);
            vendors.add(new SelectOption(v.Vendor4__r.Name, v.Vendor4__r.Name));}
        if (String.isNotBlank(v.Vendor5__r.Name) && !vendorsSet.contains(v.Vendor5__r.Name)) {
            vendorsSet.add(v.Vendor5__r.Name);
            vendors.add(new SelectOption(v.Vendor5__r.Name, v.Vendor5__r.Name));}
        }
    }
    
    public PageReference itemsSelected() {

        List<GC_OrderHolder> selectedOrderShows = new List<GC_OrderHolder>();
        orderIds = new Set<String>();

        for (GC_OrderHolder showHolder : orderHolders) {
            if (showHolder.selected) {
                selectedOrderShows.add(showHolder);
                orderIds.add(showHolder.order.Id);
            }
        }
        
         
        
        if (orderIds.size() == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR , 'You must select at least one Order'));
           // return null;
        }
            return null;
       // return new PageReference('/apex/GC_ShowOnTheGoPDF?urlParamsId=' + urlParamsObject.Id); //to be changed to -> select the shows u want order to
                                                 //be associated to.
    }

           public PageReference searchResults() {
        system.debug('ordersholdersCountBefore>>>>'+orderHolders.size()); 
        system.debug('Username++++'+Username);
        String userNamestr1='';
        String userNamestr='';
        if(String.isNotBlank(Username)){
        userNamestr=Username.replace('[','').replace(']','');
        system.debug('userNamestr++++'+userNamestr);
        String[] arrTest = userNamestr.split('\\,');
        system.debug('arrTest++++'+arrTest);
        for(String str:arrTest)
        {
            userNamestr1 += '\''+str.trim()+'\''+',';
        }
        userNamestr1 = userNamestr1.substring(0,userNamestr1.length()-1);
        System.debug('userNamestr++++'+userNamestr1); 
        }
        gesOrders.clear();
        String orderWhereQuery = '';
        String gotWhereQuery = '';
        String votWhereQuery = '';

        orderQuery = 'SELECT Id,Name,Show_Name__c,Booth_Area__c,User_Name__c,Type_Of_User__c,Booth_Area_ID__c,Completion_Date_Time__c,Connect2_Show__c,Delivery_Date_Time__c,Order_Number__c,Status__c,Removal_Date_Time__c, Order_Area_Description__c,CreatedDate,LastModifiedDate FROM GC_Order__c WHERE Connect2_Show__c = \'' + show.Id + '\'';
        orderWhereQuery += String.isNotBlank(deliveryLocation) ? ' AND Booth_Area__c like \'%' + deliveryLocation + '%\'' : '';
        orderWhereQuery += String.isNotBlank(areaDescription) ? ' AND Order_Area_Description__c like \'%' + areaDescription + '%\'' : '';
        //orderWhereQuery += String.isNotBlank(Username) ? ' AND User_Name__c like \'%' + Username + '%\'' : '';
        orderWhereQuery += String.isNotBlank(userNamestr) ? ' AND User_Name__c in ('+userNamestr1+')' : '';

        orderQuery = orderQuery + orderWhereQuery; 
        System.debug(orderQuery);

        Map<String, GC_Order__c> orders = new Map<String, GC_Order__c>((List<GC_Order__c>)Database.Query(orderQuery + orderWhereQuery));

        gotQuery = 'SELECT Id, Name, Order__c,User_Name__c,Department__r.Name, Delivery_Location__c, SA_Venue_Location__c FROM GC_GES_Order_Task__c WHERE Order__c In (\'' + String.join(new List<String>(orders.keySet()), '\',\'') + '\')';
        gotWhereQuery += String.isNotBlank(department) ? ' AND Department__r.Name like \'%' + department + '%\'' : '';
        gotWhereQuery += String.isNotBlank(delivery) ? ' AND Delivery_Location__c like \'%' + delivery + '%\'' : '';
        gotWhereQuery += String.isNotBlank(venue) ? ' AND SA_Venue_Location__r.Name like \'%' + venue + '%\'' : '';
         //gotWhereQuery += String.isNotBlank(Username) ? ' AND User_Name__c like \'%' + Username + '%\'' : '';
         gotWhereQuery += String.isNotBlank(userNamestr) ? ' AND User_Name__c in ('+userNamestr1+')' : '';
        System.debug('gotQuery:'+gotQuery);
        List<GC_GES_Order_Task__c> gotQueryList = Database.Query(gotQuery + gotWhereQuery);
        Set<String> ordersFilteredFromOrderTasks = new Set<String>();
        Map<String, GC_Order__c> ordersFilteredFromOrderTasksMap = new Map<String, GC_Order__c>();

        for (GC_GES_Order_Task__c task : gotQueryList) {
            if (String.isNotBlank(gotWhereQuery)) {
                ordersFilteredFromOrderTasks.add(task.Order__c);
            }
        }

        if (ordersFilteredFromOrderTasks.size() > 0) {
            orderQuery = 'SELECT Id,Name,Show_Name__c,User_Name__c,Booth_Area__c,Type_Of_User__c,Booth_Area_ID__c,Completion_Date_Time__c,Connect2_Show__c,Delivery_Date_Time__c,Order_Number__c,Status__c,Removal_Date_Time__c, Order_Area_Description__c,CreatedDate,LastModifiedDate  FROM GC_Order__c WHERE Id In (\'' + String.join(new List<String>(ordersFilteredFromOrderTasks), '\',\'') + '\')';
        } else if (String.isNotBlank(department) || String.isNotBlank(delivery)|| String.isBlank(Username)) {
            gesOrders.clear();
            //return null;
        }

        if (ordersFilteredFromOrderTasks.size() > 0) {
            votQuery = 'SELECT Id, Name,Order__c FROM GC_Vendor_Order_Task__c WHERE Order__c In (\'' + String.join(new List<String>(ordersFilteredFromOrderTasks), '\',\'') + '\')';
            votWhereQuery += String.isNotBlank(vendor) ? ' AND Vendor__r.Name like \'%' + vendor + '%\'' : '';

            List<GC_Vendor_Order_Task__c> votQueryList = Database.Query(votQuery + votWhereQuery);
            Set<String> ordersFilteredFromVendorTasks = new Set<String>();

            for (GC_Vendor_Order_Task__c vot : votQueryList) {
                if (String.isNotBlank(votWhereQuery)) {
                    ordersFilteredFromVendorTasks.add(vot.Order__c);
                }
            }

            if (ordersFilteredFromVendorTasks.size() > 0) {
                orderQuery = 'SELECT Id,Name,Show_Name__c,User_Name__c,Booth_Area__c,Type_Of_User__c,Booth_Area_ID__c,Completion_Date_Time__c,Connect2_Show__c,Delivery_Date_Time__c,Order_Number__c,Status__c,Removal_Date_Time__c, Order_Area_Description__c,CreatedDate,LastModifiedDate  FROM GC_Order__c WHERE Id In (\'' + String.join(new List<String>(ordersFilteredFromVendorTasks), '\',\'') + '\')';
            } else if (String.isNotBlank(vendor)) {
                gesOrders.clear();
                return null;
            }
        } // END IF

        else {
            votQuery = 'SELECT Id, Name, Order__c FROM GC_Vendor_Order_Task__c WHERE Order__c In (\'' + String.join(new List<String>(orders.keySet()), '\',\'') + '\')';
            votWhereQuery += String.isNotBlank(vendor) ? ' AND ((Vendor__r.Name like \'%' + vendor + '%\')' : '';
            votWhereQuery += String.isNotBlank(vendor) ? ' OR (Vendor2__r.Name like \'%' + vendor + '%\')' : '';
            votWhereQuery += String.isNotBlank(vendor) ? ' OR (Vendor3__r.Name like \'%' + vendor + '%\')' : '';
            votWhereQuery += String.isNotBlank(vendor) ? ' OR (Vendor4__r.Name like \'%' + vendor + '%\')' : '';
            votWhereQuery += String.isNotBlank(vendor) ? ' OR (Vendor5__r.Name like \'%' + vendor + '%\'))' : '';

            List<GC_Vendor_Order_Task__c> votQueryList = Database.Query(votQuery + votWhereQuery);
            Set<String> ordersFilteredFromVendorTasks = new Set<String>();

            for (GC_Vendor_Order_Task__c vot : votQueryList) {
                if (String.isNotBlank(votWhereQuery)) {
                    ordersFilteredFromVendorTasks.add(vot.Order__c);
                }
            }

            if (ordersFilteredFromVendorTasks.size() > 0) {
                orderQuery = 'SELECT Id,Name,Show_Name__c,Booth_Area__c,Booth_Area_ID__c,Type_Of_User__c,Completion_Date_Time__c,Connect2_Show__c,Delivery_Date_Time__c,Order_Number__c,Status__c,Removal_Date_Time__c,User_Name__c, Order_Area_Description__c ,CreatedDate,LastModifiedDate  FROM GC_Order__c WHERE Id In (\'' + String.join(new List<String>(ordersFilteredFromVendorTasks), '\',\'') + '\')';
            } else if (String.isNotBlank(vendor)) {
                gesOrders.clear();
                //return null;
            }
              
        }
        
        if (showDateDelivery != null) 
        {
            String dateString = getDateString(showDateDelivery)+'T'+ '00:00' + ':' + '00'+'Z';
            String dateString1 = getDateString(showDateDelivery)+'T'+ '23' + ':' + '59'+':59'+'Z';
            
            orderQuery += ' AND (Delivery_Date_Time__c >= '+ dateString;
            orderQuery += ' AND Delivery_Date_Time__c <= '+ dateString1+')';
        }
        if (showDateCompletion != null) 
        {
            String dateString = getDateString(showDateCompletion)+'T'+ '00:00' + ':' + '00'+'Z';
            String dateString1 = getDateString(showDateCompletion)+'T'+ '23' + ':' + '59'+':59'+'Z';
            
            orderQuery += ' AND (Completion_Date_Time__c >= '+ dateString;
            orderQuery += ' AND Completion_Date_Time__c <= '+ dateString1+')';
        }
        
        if (showDateRemoval != null) 
        {
            String dateString = getDateString(showDateRemoval)+'T'+ '00:00' + ':' + '00'+'Z';
            String dateString1 = getDateString(showDateRemoval)+'T'+ '23' + ':' + '59'+':59'+'Z';
            
            orderQuery += ' AND (Removal_Date_Time__c >= '+ dateString;
            orderQuery += ' AND Removal_Date_Time__c <= '+ dateString1+')';
        }
        
        if(createdDateFrom!=null && createdDateTo==null)
        {
            String dateString = getDateString(createdDateFrom)+'T'+ '00:00' + ':' + '00'+'Z';
            String dateString1 = getDateString(createdDateFrom)+'T'+ '23' + ':' + '59'+':59'+'Z';
            orderQuery += ' AND (CreatedDate >= '+ dateString +')';
        }
        
        if(createdDateFrom==null && createdDateTo!=null)
        {
            String dateString = getDateString(createdDateTo)+'T'+ '00:00' + ':' + '00'+'Z';
            String dateString1 = getDateString(createdDateTo)+'T'+ '23' + ':' + '59'+':59'+'Z';
            orderQuery += ' AND (CreatedDate <= '+ dateString + ')';
        }
        
        if(createdDateFrom!=null && createdDateTo!=null)
        {
            String dateString = getDateString(createdDateFrom)+'T'+ '00:00' + ':' + '00'+'Z';
            String dateString1 = getDateString(createdDateTo)+'T'+ '23' + ':' + '59'+':59'+'Z';
            orderQuery += ' AND (CreatedDate >= '+ dateString;
            orderQuery += ' AND CreatedDate <= '+ dateString1+')';
        }
        
        if(modifiedDateFrom!=null && modifiedDateTo==null)
        {
            String dateString = getDateString(modifiedDateFrom)+'T'+ '00:00' + ':' + '00'+'Z';
            String dateString1 = getDateString(modifiedDateFrom)+'T'+ '23' + ':' + '59'+':59'+'Z';
            orderQuery += ' AND (LastModifiedDate>= '+ dateString +')';
        }
        
        if(modifiedDateFrom==null && modifiedDateTo!=null)
        {
            String dateString = getDateString(modifiedDateTo)+'T'+ '00:00' + ':' + '00'+'Z';
            String dateString1 = getDateString(modifiedDateTo)+'T'+ '23' + ':' + '59'+':59'+'Z';
            orderQuery += ' AND (LastModifiedDate<= '+ dateString + ')';
        }
        
        if(modifiedDateFrom!=null && modifiedDateTo!=null)
        {
            String dateString = getDateString(modifiedDateFrom)+'T'+ '00:00' + ':' + '00'+'Z';
            String dateString1 = getDateString(modifiedDateTo)+'T'+ '23' + ':' + '59'+':59'+'Z';
            orderQuery += ' AND (LastModifiedDate>= '+ dateString;
            orderQuery += ' AND LastModifiedDate<= '+ dateString1+')';
        }
        System.debug('orderQuery>>>>'+orderQuery);

         if(String.isNotBlank(searchString))
        {
            orderQuery += ' AND ((Booth_Area__c like \'%' + searchString + '%\')';
            orderQuery += ' OR  (Name like \'%' + searchString + '%\')';
            orderQuery += ' OR  (Show_Name__c like \'%' + searchString + '%\')';
            orderQuery += ' OR  (Status__c like \'%' + searchString + '%\')';
            //orderQuery += ' OR  (User_Name__c like \'%' + searchString + '%\')';
            //orderQuery += ' OR  (Type_Of_User__c like \'%' + searchString + '%\')';
            orderQuery += ' OR  (Order_Area_Description__c  like \'%' + searchString + '%\'))'; 
        }
        
        System.debug('orderQuery>>>>'+orderQuery);
        gesOrders = Database.Query(orderQuery + ' order by ' + orderByQuery + ' ' + sortOrder);
        orderHolders.clear();
     orderHoldersWODL.clear();
        //for (GC_Order__c order : gesOrders) {
        //    orderHolders.Add(new GC_OrderHolder(order));
        //}
            if(deliveryLocationsInToShow!=null){
                if(deliveryLocationsInToShow.size() > 0)
                {
                    for (GC_Order__c order : gesOrders) 
                    {
                        if(deliveryLocationsInToShow.contains(order.Booth_Area__c ))
                        {
                            orderHolders.Add(new GC_OrderHolder(order));
                        }
                        else
                        {
                            orderHoldersWODL.Add(new GC_OrderHolder_WODL(order));
                        }
                    }
                }
                else
                {
                    for (GC_Order__c order : gesOrders) 
                    {
                        orderHoldersWODL.Add(new GC_OrderHolder_WODL(order));
                    }
                }
            }else{
                for (GC_Order__c order : gesOrders) {
                orderHolders.Add(new GC_OrderHolder(order));
            }
            }
        // system.debug('ordersholdersCountAfter>>>>'+orderHolders); 
        // system.debug('ordersholdersCountAfter>>>>'+orderHolders.size()); 

        return null;
      }
       
        
      
      public String selectedshow{get;set;}  // This will hold the show name, the id in here

      public List<SelectOption> getopenShowOptions(){
            List<SelectOption> optns = new List<Selectoption>();

          List<Id> showmem = New List<Id>();
          for(GC_Show_Team_Member__c sm: [select connect2_show__c from GC_Show_Team_Member__c where User__c=:UserInfo.getUserId()]){
              showmem.add(sm.connect2_show__c);
              }

          List<Id> showdisplayed = New List<Id>();

          for(GC_Order__C orderchk : [select id,name,Connect2_Show__c from GC_Order__C where connect2_show__c in : showmem]){

            showdisplayed.add(orderchk.connect2_show__c);
            
          }    
          
          //List<GC_Connect2_Show__c> existingshow =[select Id, Name,Show_Name__c,Facility__c,Facility_Address__c,Show_Start_Date__c,Show_End_Date__c 
          //                                          from GC_Connect2_Show__c  where id not in : showdisplayed and id in :showmem  limit 100];

           List<GC_Connect2_Show__c> existingshow =[select Id, Name,Show_Name__c,Facility__c,Facility_Address__c,Show_Start_Date__c,Show_End_Date__c 
                                                    from GC_Connect2_Show__c  where id in :showmem];

          //List<GC_Connect2_Show__c> existingshow =[select Id, Name,Show_Name__c,Facility__c,Facility_Address__c,Show_Start_Date__c,Show_End_Date__c 
          //                                          from GC_Connect2_Show__c  where id = :'a3r40000000bqdj'];                                                    
          optns.add(new selectOption('', '--None--'));
          for(GC_Connect2_Show__c show : existingshow ){
               str = show.Name+'|'+show.Show_Name__c+'|'+show.Facility__c+'|'+show.Show_Start_Date__c+'|'+show.Show_End_Date__c;
               optns.add(new selectOption(show.Id, str));
            } 
             optns.add(new selectOption('a3r40000000bqdiAAA', 'Test Show'));
             optns.add(new selectOption('a3r4B000000AwjdQAC', 'Test Show1'));  
             optns.add(new selectOption('a3r40000000XkCr', 'Test Show2'));  
             optns.add(new selectOption('a3r40000000XkHQ', 'Test Show3'));  
           return optns;
      }
      
       public PageReference toggleContent() {
        if(showContent){
            showContent = false;
            showContent1 = true;
             }
        else{
            showContent = true;
            showContent1 = false;
            }
        return null;
        }
        
        public PageReference mapDeliveryLocations() 
        {
           // system.debug('fromShowDelLocMap>>>>'+fromShowDelLocMap);
            
            if(orderHoldersWODL.size() > 0)
            {
                for (GC_OrderHolder_WODL showHolder1 : orderHoldersWODL) 
                {
                    if (showHolder1.order.Booth_Area__c == fromShowDelLocMap) 
                    {
                        showHolder1.newDeliveryLocation = toShowDelLocMap;
                    }
                }
            }
            
            fromShowDelLocMap = '';
            toShowDelLocMap = '';
           // system.debug('orderHoldersWODL>>>>>>'+orderHoldersWODL);
            
            return null;
        }
        
         public PageReference showOrderGrids()
         {
             SelectOption noneSelectOption = new SelectOption('', '---None---');
             if(!String.isBlank(selectedshow))
             {
                 deliveryLocationsToShow = new Set<String>();
                 deliveryLocationsFromShow = new Set<String>();
                 deliveryLocationsInToShow = new Set<String>();
                 List<GC_Connect2_Show__c> showDet = [select Id,Job_Number__c from GC_Connect2_Show__c where Id =: selectedshow];
                 List<GC_Connect2_Show__c> showDetFrom = [select Id,Job_Number__c from GC_Connect2_Show__c where Id =: show.Id];
                 if(showDet.size() > 0)
                 {
                     if(!String.isBlank(showDet[0].Job_Number__c))
                     {
                         showJobNumber = showDet[0].Job_Number__c;
                     }
                     else
                     {
                         GC_PageUtil.AddErrorMessage('No Job Number in the selected Show');
                         return null;
                     }
                 }
                 
                 system.debug('showJobNumber>>>>>>>'+showJobNumber);
                 
                 if(showDetFrom.size() > 0)
                 {
                     fromShowJobNumber = showDetFrom[0].Job_Number__c;
                 }
                 
                 system.debug('fromShowJobNumber>>>>>>>'+fromShowJobNumber);
                 
                 system.debug('Debug Point1');
                 
                 GC_Core_Session__c session;
                    String coreSessionId;
                    String showOccrProjectId;
                    //Map<String, Map<String, GC_ItemHolder>> products = new Map<String, Map<String, GC_ItemHolder>>();
                    //List<SelectOption> productList = new List<SelectOption>();
                    //Set<String> prodItemDesc = new Set<String>();
                    List<GC_GES_Order_Task__c> gesOtToUpdate = new List<GC_GES_Order_Task__c>();
                    try {
                        session = GC_CoreUtils.getSessionID();
                        coreSessionId = session.Core_Application_Session_ID__c;
                    }
                    catch (Exception e) {
                        GC_PageUtil.AddErrorMessage(e.getMessage());
                        return null;
                    }
                    
                    system.debug('Debug Point2');
                    
                        
                    CORE_V2.BasicHttpBinding_IShowService projectQuery = new CORE_V2.BasicHttpBinding_IShowService();
                    try {
                        CORE_V2.ShowProject showProject;
                        CORE_V2.ShowProject showProject1;
                        if (Test.isRunningTest()) {
                            showProject = GC_TestUtils.getTestShowProject();
                        }
                        else {
                            showProject = projectQuery.GetShowProjectByProjectNumber(coreSessionId, showJobNumber);
                            showProject1 = projectQuery.GetShowProjectByProjectNumber(coreSessionId, fromShowJobNumber);
                        } 
                        
                        
                        delLocationToShow.Add(noneSelectOption);
                        delLocationFromShow.Add(noneSelectOption);
                        deliveryLocationsToShow.clear();
                        deliveryLocationsFromShow.clear();
                        Map<String, CORE_V2.BoothArea> boothAreaLookup = new Map<String, CORE_V2.BoothArea>();
                        system.debug('showProject.BoothAreas>>>>>'+showProject.BoothAreas);
                        
                        if(showProject.BoothAreas.BoothArea != null)
                        {
                            for (CORE_V2.BoothArea boothArea : showProject.BoothAreas.BoothArea) 
                            {
                                deliveryLocationsToShow.Add(boothArea.Area);
                                delLocationToShow.Add(new SelectOption(String.valueof(boothArea.BoothAreaId)+'_'+boothArea.Area,boothArea.Area));
                                boothAreaDDT.put(String.valueof(boothArea.BoothAreaId), boothArea.DeliveryDateTime);        //SAL-537
                                system.debug('boothAreaDDT==='+boothAreaDDT);
                                boothAreaCDT.put(String.valueof(boothArea.BoothAreaId), boothArea.CompletionDateTime);      //SAL-537
                                system.debug('boothAreaCDT==='+boothAreaCDT);
                                boothAreaRDT.put(String.valueof(boothArea.BoothAreaId), boothArea.RemovalDateTime);         //SAL-537
                                system.debug('boothAreaRDT==='+boothAreaRDT);
                                boothAreaByName.put(boothArea.Area, boothArea.DeliveryDateTime);     //SAL-537
                                boothAreaByName1.put(boothArea.Area, boothArea.CompletionDateTime);  //SAL-537
                                boothAreaByName2.put(boothArea.Area, boothArea.RemovalDateTime);     //SAL-537
                                boothAreaIDByName.put(boothArea.Area, String.valueof(boothArea.BoothAreaId));   //SAL-537
                                
                            }
                        }
                        else
                        {
                            GC_PageUtil.AddErrorMessage('No Delivery Locations found in the Selected Show');
                            return null;
                        }
                        
                        
                        
                        for (CORE_V2.BoothArea boothArea : showProject1.BoothAreas.BoothArea) 
                        {
                            if(showProject1.BoothAreas.BoothArea != null)
                            {
                                deliveryLocationsFromShow.Add(boothArea.Area);
                            }
                        }
                    }
                    catch (Exception e) {
                        System.debug(LoggingLevel.ERROR, e.getMessage() + ' ' + e.getStackTraceString());
                        if(e.getMessage().contains('Show not found in CORE'))
                        {
                            GC_PageUtil.AddErrorMessage('Selected Show not found in CORE');
                        }
                        else
                        {
                            GC_PageUtil.AddErrorMessage(e.getMessage());
                        }
                        return null;
                    }
                    
                    system.debug('deliveryLocationsToShow>>>>>>>'+deliveryLocationsToShow);
                    system.debug('deliveryLocationsFromShow>>>>>>>'+deliveryLocationsFromShow);
                    deliveryLocationsInToShow.clear();
                    for(String str: deliveryLocationsFromShow)
                    {
                        if(deliveryLocationsToShow.contains(str))
                        {
                            deliveryLocationsInToShow.add(str);
                        }
                    }
                    orderHolders.clear();
                    orderHoldersWODL.clear();
                    
                    if(deliveryLocationsInToShow.size() > 0)
                    {
                        for (GC_Order__c order : gesOrders) 
                        {
                            if(deliveryLocationsInToShow.contains(order.Booth_Area__c ))
                            {
                                orderHolders.Add(new GC_OrderHolder(order));
                            }
                            else
                            {
                                orderHoldersWODL.Add(new GC_OrderHolder_WODL(order));
                            }
                        }
                    }
                    else
                    {
                        for (GC_Order__c order : gesOrders) 
                        {
                            orderHoldersWODL.Add(new GC_OrderHolder_WODL(order));
                        }
                    }
                    
                    // system.debug('orderHoldersWODL>>>>>'+orderHoldersWODL);
                    
                    if(orderHoldersWODL.size() > 0)
                    {
                        showOrderGrids1 = true;
                        Set<String> delLocs = new Set<String>();
                        for (GC_OrderHolder_WODL showHolder1 : orderHoldersWODL) 
                        {
                            if(!String.isBlank(showHolder1.order.Booth_Area__c))
                            {
                                delLocs.add(showHolder1.order.Booth_Area__c);
                            }
                        }
                        
                        if(delLocs.size() > 0)
                        {
                            for(String str: delLocs)
                            {
                                if(!String.isBlank(str))
                                {
                                    delLocationFromShow.Add(new SelectOption(str,str));
                                }
                            }
                        }
                    }
                    
                    showOrderGrids = true;
                    return null;
              }
              else
              {
                  showOrderGrids = false;
                  showOrderGrids1 = false;
                  return null;
              }  
         }
        
        public PageReference cancelclone() {

                string showId = ApexPages.currentPage().getParameters().get('Id');
                string isCommunity = ApexPages.currentPage().getParameters().get('isCommunity');
                if(isCommunity == 'true')
                {
                    return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_HomePage?showId='+showId );
                }
                else
                {
                    return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Connect2ShowView?id='+showId+'&sfdc.override=1');
                }
                
            }
        
        public PageReference cloneOrders()
        {
            List<GC_OrderHolder> selectedOrderShows = new List<GC_OrderHolder>();
            List<GC_Order__C> newClonedOrds = new List<GC_Order__C>();
            Map<Id,List<GC_GES_Order_Task__c>> ordOrderTasks = new Map<Id,List<GC_GES_Order_Task__c>>();
            Map<Id,List<GC_Vendor_Order_Task__c>> ordVenTasks = new Map<Id,List<GC_Vendor_Order_Task__c>>();
            List<GC_GES_Order_Task__c> newClonedOrdTasks = new List<GC_GES_Order_Task__c>();
            List<GC_Vendor_Order_Task__c> newClonedVenTasks = new List<GC_Vendor_Order_Task__c>();
            
            Map<Id,String> mapOrdernewDelLoc = new Map<Id,String>();
            
            Map<String,Id> sAttMap = new Map<String,Id>();
            
            orderIds = new Set<String>();
            
            List<GC_Show_Attribute__c> sAtt = [Select Id,Name from GC_Show_Attribute__c where Connect2_Show__c =:selectedshow];
                
                for(GC_Show_Attribute__c sAttri: sAtt)
                {
                    if(!sAttMap.containsKey(sAttri.Name)){
                        sAttMap.put(sAttri.Name,sAttri.Id);
                    }
                }

            for (GC_OrderHolder showHolder : orderHolders) {
                if (showHolder.selected) {
                    selectedOrderShows.add(showHolder);
                    orderIds.add(showHolder.order.Id);
                }
            }
            
            
            
            for (GC_OrderHolder_WODL showHolder1 : orderHoldersWODL) 
            {
                if (showHolder1.selected) 
                {
                    mapOrdernewDelLoc.put(showHolder1.order.Id,showHolder1.newDeliveryLocation);
                    
                    orderIds.add(showHolder1.order.Id);
                }
            }
            
            system.debug('mapOrdernewDelLoc>>>>'+mapOrdernewDelLoc);
            
            if (orderIds.size() == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR , 'You must select at least one Order'));
                return null;
            }   
        
            List<GC_Order__c> ordercln = [select name,Order_Number__c,Status__c,Delivery_Date_Time__c,Booth_Area__c,Booth_Area_ID__c,Order_Area_Description__c,
            (select Order__c,Status__c,Item_Number__c,Description__c,Price__c,Total__c,UOM__c,QuantityNum__c,Item_Category_ID__c,Item_Template__c,Show_Management_Field__c,SA_Venue_Location__c,Onsite_Contact__c,Onsite_Contact_Person_Other__c,Onsite_Contact_Person_Number_Other__c,Delivery_Location__c,Department__c,Budget_Code__c,Delivery_Date_Time__c,Completion_Date_Time__c,Removal_Date_Time__c,Sign_Title__c,GOT_Sign_Type__c,
                        GOT_Single_Double_Sided__c,GOT_Sign_Type_Other__c,Material__c,GOT_Copy_Placement__c,Outdoors__c,Installation_Method__c,Save_Signs__c,GOT_Background__c,Sign_Copy__c,Layout__c from GES_Order_Tasks__r),
            (select Order__c,Status__c,Services__c,Vendor__c,Vendor2__c,Vendor3__c,Vendor4__c,Vendor5__c,GESOrderTask1__c,GESOrderTask2__c,GESOrderTask3__c,GESOrderTask4__c,GESOrderTask5__c,Service_Type__c,Service_Type2__c,Service_Type3__c,Service_Type4__c,Service_Type5__c,SelectAllOrderTasks__c,Vendor5__r.ServiceType__c,Vendor4__r.ServiceType__c,Vendor3__r.ServiceType__c,Vendor2__r.ServiceType__c,Vendor__r.ServiceType__c,SA_Venue_Location_Ven__c,Delivery_Location_Ven__c,Vendor_Instructions__c from Vendor_Order_Tasks__r) from GC_Order__c where Id in : orderIds ];
            
            system.debug('ordercln>>>>>>>'+ordercln);

            for(GC_Order__C ordr : ordercln ){
                GC_Order__c ordernew = New GC_Order__C();
                ordernew.Order_Number__c = ordr.Order_Number__c;
                ordernew.Status__c= 'New';
                if(mapOrdernewDelLoc.containsKey(ordr.Id))
                {
                    String boothAreaId =  mapOrdernewDelLoc.get(ordr.Id);
                    String[] strSplits = boothAreaId.split('_');
                    ordernew.Booth_Area__c = strSplits[1];
                    ordernew.Booth_Area_ID__c = strSplits[0];
                    if(boothAreaDDT.containsKey(ordernew.Booth_Area_ID__c)){
                    system.debug('ordernew.Delivery_Date_Time__c==='+boothAreaDDT.get(ordernew.Booth_Area_ID__c));
                    ordernew.Delivery_Date_Time__c=boothAreaDDT.get(ordernew.Booth_Area_ID__c);     //SAL-537
                    system.debug('ordernew.Completion_Date_Time__c==='+boothAreaCDT.get(ordernew.Booth_Area_ID__c));
                    ordernew.Completion_Date_Time__c=boothAreaCDT.get(ordernew.Booth_Area_ID__c);       //SAl-537
                    system.debug('ordernew.Removal_Date_Time__c==='+boothAreaRDT.get(ordernew.Booth_Area_ID__c));
                    ordernew.Removal_Date_Time__c=boothAreaRDT.get(ordernew.Booth_Area_ID__c);          //SAL-537
                    }
                }
                else
                {
                    ordernew.Booth_Area__c = ordr.Booth_Area__c;
                    //ordernew.Booth_Area_ID__c = ordr.Booth_Area_ID__c;
                    for(String a: boothAreaByName.Keyset()){
                            if(boothAreaByName.containsKey(ordernew.Booth_Area__c)){
                                
                                system.debug('ordernew.Delivery_Date_Time__c==='+boothAreaByName.get(ordernew.Booth_Area__c));
                                ordernew.Delivery_Date_Time__c=boothAreaByName.get(ordernew.Booth_Area__c);     //SAL-537
                                system.debug('ordernew.Completion_Date_Time__c==='+boothAreaByName1.get(ordernew.Booth_Area__c));
                                ordernew.Completion_Date_Time__c=boothAreaByName1.get(ordernew.Booth_Area__c);         //SAl-537
                                system.debug('ordernew.Removal_Date_Time__c==='+boothAreaByName2.get(ordernew.Booth_Area__c));
                                ordernew.Removal_Date_Time__c=boothAreaByName2.get(ordernew.Booth_Area__c);            //SAL-537
                                ordernew.Booth_Area_ID__c = boothAreaIDByName.get(ordernew.Booth_Area__c);
                            }
                        }
                }
                
                ordernew.Connect2_Show__c = selectedshow;
                ordernew.ParentCloneOrder__c = ordr.Id;
                ordernew.Order_Area_Description__c = ordr.Order_Area_Description__c;
                newClonedOrds.add(ordernew);

                if(ordr.GES_Order_Tasks__r.size() > 0)
                {
                    for(GC_GES_Order_Task__c ot: ordr.GES_Order_Tasks__r)
                    {
                        if(!ordOrderTasks.containsKey(ordr.Id))
                        {
                            ordOrderTasks.put(ordr.Id,new List<GC_GES_Order_Task__c>());
                        }
                        ordOrderTasks.get(ordr.Id).add(ot);
                    }
                }

                if(ordr.Vendor_Order_Tasks__r.size() > 0)
                {
                    for(GC_Vendor_Order_Task__c vt: ordr.Vendor_Order_Tasks__r)
                    {
                        if(!ordVenTasks.containsKey(ordr.Id))
                        {
                            ordVenTasks.put(ordr.Id,new List<GC_Vendor_Order_Task__c>());
                        }
                        ordVenTasks.get(ordr.Id).add(vt);
                    }
                }
            }

          //  system.debug('ordOrderTasks>>>>>>>'+ordOrderTasks);
         //   system.debug('ordVenTasks>>>>>>>>>'+ordVenTasks);

            insert newClonedOrds;

            List<Id> newClonedOrdsIds = new List<Id>();

            for(GC_Order__c gc: newClonedOrds)
            {
                newClonedOrdsIds.add(gc.Id);
            }

            system.debug('newClonedOrdsIds>>>>>>>>>'+newClonedOrdsIds); 

            List<GC_Order__c> newClonedOrders = [Select ParentCloneOrder__c from GC_Order__c where Id in : newClonedOrdsIds];

            system.debug('newClonedOrders++++++++'+newClonedOrders);

            for(GC_Order__c newGC: newClonedOrders)
            {
                if(ordOrderTasks.containsKey(newGC.ParentCloneOrder__c))
                {
                    for(GC_GES_Order_Task__c gcOrdTask : ordOrderTasks.get(newGC.ParentCloneOrder__c))
                    {
                        GC_GES_Order_Task__c got = new GC_GES_Order_Task__c(); 
                        got.Order__c = newGC.Id;
                        got.Status__c = 'New';
                        got.Item_Category_ID__c = gcOrdTask.Item_Category_ID__c;
                        got.Item_Number__c = gcOrdTask.Item_Number__c;
                        got.Item_Template__c = gcOrdTask.Item_Template__c;
                        got.Description__c = gcOrdTask.Description__c;
                        got.Price__c = gcOrdTask.Price__c;
                        got.UOM__c = gcOrdTask.UOM__c;
                        got.QuantityNum__c = gcOrdTask.QuantityNum__c;
                        got.Show_Management_Field__c = gcOrdTask.Show_Management_Field__c;
                        got.SA_Venue_Location__c = gcOrdTask.SA_Venue_Location__c;
                        got.Onsite_Contact__c = gcOrdTask.Onsite_Contact__c;
                        got.Onsite_Contact_Person_Other__c = gcOrdTask.Onsite_Contact_Person_Other__c;
                        got.Onsite_Contact_Person_Number_Other__c = gcOrdTask.Onsite_Contact_Person_Number_Other__c;
                        got.Delivery_Location__c = gcOrdTask.Delivery_Location__c;
                        got.Department__c = gcOrdTask.Department__c;
                        got.Budget_Code__c = gcOrdTask.Budget_Code__c;
                        //got.Delivery_Date_Time__c = gcOrdTask.Delivery_Date_Time__c;
                        //got.Completion_Date_Time__c = gcOrdTask.Completion_Date_Time__c;
                        //got.Removal_Date_Time__c = gcOrdTask.Removal_Date_Time__c;
                        got.Sign_Title__c = gcOrdTask.Sign_Title__c;
                        got.GOT_Sign_Type__c = gcOrdTask.GOT_Sign_Type__c;
                        got.GOT_Single_Double_Sided__c = gcOrdTask.GOT_Single_Double_Sided__c;
                        got.GOT_Sign_Type_Other__c = gcOrdTask.GOT_Sign_Type_Other__c;
                        got.Material__c = gcOrdTask.Material__c;
                        got.GOT_Copy_Placement__c = gcOrdTask.GOT_Copy_Placement__c;
                        got.Outdoors__c = gcOrdTask.Outdoors__c;
                        got.Installation_Method__c = gcOrdTask.Installation_Method__c;
                        got.Save_Signs__c = gcOrdTask.Save_Signs__c;
                        got.GOT_Background__c = gcOrdTask.GOT_Background__c;
                        got.Sign_Copy__c = gcOrdTask.Sign_Copy__c;
                        got.Layout__c = gcOrdTask.Layout__c;
                        newClonedOrdTasks.add(got);

                    }
                }
                

                if(ordVenTasks.containsKey(newGC.ParentCloneOrder__c))
                {
                    for(GC_Vendor_Order_Task__c gcVenTask : ordVenTasks.get(newGC.ParentCloneOrder__c))
                    {
                        GC_Vendor_Order_Task__c vot = new GC_Vendor_Order_Task__c();
                        vot.Order__c = newGC.Id;
                        vot.Status__c = 'New';
                        vot.Vendor__c = gcVenTask.Vendor__c;
                        vot.Vendor2__c = gcVenTask.Vendor2__c;
                        vot.Vendor3__c = gcVenTask.Vendor3__c;
                        vot.Vendor4__c = gcVenTask.Vendor4__c;
                        vot.Vendor5__c = gcVenTask.Vendor5__c;
                        vot.GESOrderTask1__c = gcVenTask.GESOrderTask1__c;
                        vot.GESOrderTask2__c = gcVenTask.GESOrderTask2__c;
                        vot.GESOrderTask3__c = gcVenTask.GESOrderTask3__c;
                        vot.GESOrderTask4__c = gcVenTask.GESOrderTask4__c;
                        vot.GESOrderTask5__c = gcVenTask.GESOrderTask5__c;
                        vot.SA_Venue_Location_Ven__c = gcVenTask.SA_Venue_Location_Ven__c;
                        vot.Delivery_Location_Ven__c = gcVenTask.Delivery_Location_Ven__c;
                        vot.Vendor_Instructions__c = gcVenTask.Vendor_Instructions__c;
                        
                        if(gcVenTask.Vendor__c != null)
                        {
                            if(String.isNotBlank(gcVenTask.Vendor__r.ServiceType__c))
                            {
                                if(sAttMap.containsKey(gcVenTask.Vendor__r.ServiceType__c))
                                {
                                    vot.Service_Type__c = sAttMap.get(gcVenTask.Vendor__r.ServiceType__c);
                                }
                            }
                        }
                        
                        if(gcVenTask.Vendor2__c != null)
                        {
                            if(String.isNotBlank(gcVenTask.Vendor2__r.ServiceType__c))
                            {
                                if(sAttMap.containsKey(gcVenTask.Vendor2__r.ServiceType__c))
                                {
                                    vot.Service_Type2__c = sAttMap.get(gcVenTask.Vendor2__r.ServiceType__c);
                                }
                            }
                        }
                        
                        if(gcVenTask.Vendor3__c != null)
                        {
                            if(String.isNotBlank(gcVenTask.Vendor3__r.ServiceType__c))
                            {
                                if(sAttMap.containsKey(gcVenTask.Vendor3__r.ServiceType__c))
                                {
                                    vot.Service_Type3__c = sAttMap.get(gcVenTask.Vendor3__r.ServiceType__c);
                                }
                            }
                        }
                        
                        if(gcVenTask.Vendor4__c != null)
                        {
                            if(String.isNotBlank(gcVenTask.Vendor4__r.ServiceType__c))
                            {
                                if(sAttMap.containsKey(gcVenTask.Vendor4__r.ServiceType__c))
                                {
                                    vot.Service_Type4__c = sAttMap.get(gcVenTask.Vendor4__r.ServiceType__c);
                                }
                            }
                        }
                        
                        if(gcVenTask.Vendor5__c != null)
                        {
                            if(String.isNotBlank(gcVenTask.Vendor5__r.ServiceType__c))
                            {
                                if(sAttMap.containsKey(gcVenTask.Vendor5__r.ServiceType__c))
                                {
                                    vot.Service_Type5__c = sAttMap.get(gcVenTask.Vendor5__r.ServiceType__c);
                                }
                            }
                        }
                        
                        //vot.Service_Type__c = gcVenTask.Service_Type__c;
                        //vot.Service_Type2__c = gcVenTask.Service_Type2__c;
                        //vot.Service_Type3__c = gcVenTask.Service_Type3__c;
                        //vot.Service_Type4__c = gcVenTask.Service_Type4__c;
                        //vot.Service_Type5__c = gcVenTask.Service_Type5__c;
                        vot.SelectAllOrderTasks__c = gcVenTask.SelectAllOrderTasks__c;
                        newClonedVenTasks.add(vot);
                    }
                }
            }

            insert newClonedOrdTasks;
            insert newClonedVenTasks;

            if (String.isNotBlank(selectedshow)) 
            {
                string isCommunity = ApexPages.currentPage().getParameters().get('isCommunity');
                if(isCommunity == 'true')
                {
                    return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_HomePage?showId=' + selectedshow);
                }
                else
                {
                    return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Connect2ShowView?id='+selectedshow+'&sfdc.override=1');
                }
                
            } else {
                return null;
            }
        }
    
    
           public GC_Connect2_Show__c ShowComp{get;set;}
        public List<GC_Order__c> nowShowdata{get;set;}        
        public List<GC_Order__c> nowShowdataAdd{get;set;}
        public  list<GC_Order__c> nownonShowdataAdd{get;set;}
        public List<GC_Order__c> presntorderavoid{get;set;}
        public List<GC_Order__c> afteravoid{get;set;}   
    Map<String, GC_Order__c > showorder= new Map<String, GC_Order__c >();
        Map<String, GC_Order__c > presentshoworder= new Map<String, GC_Order__c >();
    
            public PageReference showSelected()
        {
            orderIds = new Set<String>();             
            nowShowdata=new List<GC_Order__c>();
            nowShowdataAdd=new List<GC_Order__c>();
            nownonShowdataAdd=new list<GC_Order__c>();
            presentshoworder=new Map<String, GC_Order__c >();
            showorder=new Map<String, GC_Order__c >();
            nowShowdataAdd.clear();
            nownonShowdataAdd.clear();
            for(GC_OrderHolder ord : orderHolders)
            {
                orderIds.add(ord .order.Booth_Area__c); 
            }
            system.debug('Now show id'+Showid);
            nowShowdata=[select Name,Booth_Area__c,Booth_Area_ID__c,Order_Number__c,Order_Area_Description__c,Status__c from GC_Order__c where Booth_Area__c = : orderIds and Connect2_Show__c =:Showid];
            system.debug('selectedorders>>>'+nowShowdata.size()); 
            for(GC_Order__c ods : nowShowdata)
            {
                 showorder.put(ods.Booth_Area__c,ods);                 
            }
           // system.debug('Common show order List>>>>'+showorder.values());
            afteravoid =showorder.values();
           // system.debug('Common show order List>>>>'+afteravoid);
            if(selectedshow != null)
            {
                // system.debug('Test show data for now>>>>>>>'+selectedshow); 
                 ShowComp=[select Name,Show_Name__c,(select Name,Booth_Area__c,Show_Name__c,Connect2_Show__c,Order_Number__c,Order_Area_Description__c,Booth_Area_ID__c,Status__c from Orders__r) from GC_Connect2_Show__c where id=:selectedshow];                 
                // system.debug('Number of shows that are existed in show'+ShowComp);                 
                 for(GC_Order__c odf : ShowComp.Orders__r)
                 {
                      presentshoworder.put(odf.Booth_Area__c,odf);  
                 }
                // system.debug('Common show order List>>>>'+presentshoworder.values());
                 presntorderavoid =presentshoworder.values();
                // system.debug('Common show order List>>>>'+presntorderavoid );  
            }
            /*for(GC_Order__c odrs : afteravoid )
            {
                for(GC_Order__c ords : presntorderavoid )
                {
                    if(odrs.Booth_Area__c == ords.Booth_Area__c )
                    {
                        nowShowdataAdd.add(odrs);
                        system.debug('Common show order List>>>>'+nowShowdataAdd);  
                    }
                    else if(!(odrs.Booth_Area__c == ords.Booth_Area__c) )
                    {
                         nownonShowdataAdd.add(odrs);
                         system.debug('Common show order List>>>>'+nownonShowdataAdd);   
                    }
                }
            }*/
            
            //re-factoring for loop
            //iterate through first map
            for(String keyId: showorder.Keyset()){
                
                //iterate through second map if second map does not have the key
                if(!presentshoworder.keySet().contains(keyId)){
                    nownonShowdataAdd.add(showorder.get(keyId));
                }else{
                    //iterate through second map if second map have the key
                    nowShowdataAdd.add(showorder.get(keyId));
                }
            }
          //  system.debug('Common show order List>>>>'+nowShowdataAdd);  
         //   system.debug('Common show order List>>>>'+nowShowdataAdd.size()); 
            if(nowShowdataAdd.size()==0){
            flag=false;
            system.debug('===================='+flag);
            } 
            // system.debug('Common show order List>>>>'+nownonShowdataAdd);  
           // system.debug('Common show order List>>>>'+nownonShowdataAdd.size());             
            return null;
        }
    
    public String getDateString(Date dt) 
    {
        if (dt == null) {
            return '';
        }
        return DateTime.newInstance(dt.year(), dt.month(), dt.day()).format('yyyy-MM-dd');
    }
    
    
    public PageReference resetSearch() {
        deliveryLocation = null;
        areaDescription=null;
        showDateDelivery = null;
        showDateCompletion = null;
        showDateRemoval = null;
        createdDateFrom=null;
        createdDateTo=null;
        modifiedDateFrom=null;
        modifiedDateTo=null;
        selectedVendor = null;
        searchString = null;
        department = null;
        delivery = null;
        venue = null;
        vendor = null;
        Username=null;
        return searchResults();
    }
        
        public class GC_OrderHolder_WODL 
        {
            public GC_Order__c order {get; set;}
            public Boolean selected {get; set;}
            public string newDeliveryLocation {get; set;}
            public List<GC_GES_Order_Task__c> gesTasks {get; set;}
            public List<GC_Vendor_Order_Task__c> vendorTasks {get; set;}

            public GC_OrderHolder_WODL(GC_Order__c order) {
                this.order = order;
                this.selected = false;
                newDeliveryLocation = '';
                gesTasks = new List<GC_GES_Order_Task__c>();
                vendorTasks = new List<GC_Vendor_Order_Task__c>();
            }
        }
}