public with sharing class GC_Community_HomePageController {
    public GC_Connect2_Show__c show {get; set;}
    public List<GC_Order__c> gesOrders {get; set;}
    public String showId {get; set;}

    // For Demonstration purposes of how the colored bars in
    // Graphics and orders sections will work
    public String orderCreatePage { get; private set; }
    public String homePage { get; private set; }
    public String orderQuery {get; set;}
    public String gotQuery {get; set;}
    public String votQuery {get; set;}
    public String boothName {get; set;} // this is delivery location
    public String department {get; set;}
    public String delivery {get; set;} // this is delivery area
    public String venue {get; set;}
    public String vendor {get; set;}
    public List<String> Username{get;set;}
    public String TypeofUser{get;set;}
    public String areaDescription {get; set;}
    public Boolean CanCreate {get; set;}
    public List<String> oponsiteContactPerson {get; set;}
    public List<String> oponsiteContactPersonOther {get; set;}
    public String searchString {get; set;}

    public List<SelectOption> deliveryLocations { get; set; }
    public List<SelectOption> deliveryAreas { get; set; }
    public List<SelectOption> departments { get; set; }
    public List<SelectOption> venueLocations { get; set; }
    public List<SelectOption> vendors { get; set; }
    public List<SelectOption> orderAreaDescriptions { get; set; }
    public List<SelectOption> Usernames{get;set;}
    public List<SelectOption> TypeofUsers{get;set;}
    public List<SelectOption> OPOnsiteContactPersons {get; set;}
    public List<SelectOption> OPOnsiteContactPersonOthers {get; set;}
    
    public DateTime deliveryDateTime {get; set;}
    public DateTime completionDateTime {get; set;}
    public DateTime removalDateTime {get; set;}
    public DateTime CreationDateTime {get; set;}
    
    public string deliveryDateTimeString {get; set;}
    public string deliveryDateTimeString1 {get; set;}
    
    public string CreationDateTimeString {get; set;}
    public string CreationDateTimeString1 {get; set;}
    
    public string removalDateTimeString {get; set;}
    public string removalDateTimeString1 {get; set;}
    
    public string completionDateTimeString {get; set;}
    public string completionDateTimeString1 {get; set;}
    
    public Date showDateDelivery {get; set;}
    public Date showDateCompletion {get; set;}
    public Date showDateRemoval {get; set;}
    public Date showDateCreation {get; set;}
    
    public Date createdDateFrom{get; set;}
    public Date createdDateTo{get; set;}
    public Date modifiedDateFrom{get; set;}
    public Date modifiedDateTo{get; set;}   
    public Boolean orderCreatedByFlag{get; set;}
    public GC_Report_Filters__c OrderFilter{get; set;} //SAL-558

    public GC_Community_HomePageController() {
        showId = ApexPages.currentPage().getParameters().get('showId');
        orderByQuery = 'Name';
        sortOrder = 'asc';
        orderCreatedByFlag=true;
        Integer createdNumber=0;
        if (String.isNotBlank(showId)) {
            show = GC_Connect2ShowDao.getInstance().getConnect2ShowById(showId);
            gesOrders = GC_OrderDao.getInstance().getByConnect2ShowId(showId, orderByQuery);
            if(gesOrders.size()>0){
                for(GC_Order__c varOrder: gesOrders){
                    if(varOrder.CreatedById== UserInfo.getUserId()){
                        createdNumber+=1;
                    }
                }
                if(createdNumber>0){
                    orderCreatedByFlag= false;
                }
                
            }
            
            orderCreatePage = '/GC_Community_OrderCreateEdit?showId=' + showId;
            homePage = '/GC_Community_Home_Page?showId=' + showId;
        } else {
            orderCreatePage = '/GC_Community_ShowSearch';
            homePage = '/GC_Community_ShowSearch';
            return;
        }

        CanCreate = true;
        List<Profile> profile = [SELECT Id, Name FROM Profile WHERE Id = :userinfo.getProfileId() LIMIT 1];
        String profileName = profile[0].Name;

        if (profileName == 'GC Community Vendor') {
            CanCreate = false;
        }

        if (profileName == 'GC Community Client') {
            User theUser = [SELECT Id, Name FROM User WHERE Id = :userinfo.getUserId() LIMIT 1];

            List<GC_Show_Team_Member__c> stm = [SELECT Id, Name, User__c, Show_Role__c, Connect2_Show__c FROM GC_Show_Team_Member__c WHERE Connect2_Show__c = :show.Id AND User__c = :theUser.Id];

            if (stm != null && stm.size() == 1) {
                String memberRole = stm[0].Show_Role__c;

                if (memberRole == 'Show Organizer - Read Only') {
                    CanCreate = false; 
                }
            }
        }

        List<GC_Order__c> orders = GC_OrderDao.getInstance().getByConnect2ShowId(showId);
        List<GC_GES_Order_Task__c> gesTasks = GC_GESOrderTaskDao.getInstance().getByConnect2ShowId(showId);
        List<GC_Vendor_Order_Task__c> vendorTasks = GC_VendorOrderTaskDao.getInstance().getByConnect2ShowId(showId);

        deliveryLocations = new List<SelectOption>();
        orderAreaDescriptions = new List<SelectOption>();
        deliveryAreas = new List<SelectOption>();
        departments = new List<SelectOption>();
        Usernames =new List<SelectOption>();
        venueLocations = new List<SelectOption>();
        vendors = new List<SelectOption>();
        TypeofUsers=new List<SelectOption>();
        OPOnsiteContactPersons = new List<SelectOption>();
        OPOnsiteContactPersonOthers = new List<SelectOption>();
        
        deliveryLocations.add(new SelectOption('', '----None----'));
        orderAreaDescriptions.add(new SelectOption('', '----None----'));
        deliveryAreas.add(new SelectOption('', '----None----'));
        departments.add(new SelectOption('', '----None----'));
        venueLocations.add(new SelectOption('', '----None----'));
        vendors.add(new SelectOption('', '----None----'));
        Usernames.add(new SelectOption('', '----None----'));
        TypeOfUsers.add(new SelectOption('','---None---'));
        OPOnsiteContactPersons.add(new SelectOption('','----None----'));
        OPOnsiteContactPersonOthers.add(new SelectOption('','----None----'));

        Set<String> deliveryLocationsSet = new Set<String>();
        Set<String> orderAreaDescriptionsSet = new Set<String>();
        Set<String> deliveryAreasSet = new Set<String>();
        Set<String> departmentsSet = new Set<String>();
        Set<String> venueLocationsSet = new Set<String>();
        Set<String> vendorsSet = new Set<String>();
        Set<String> Usernamesset= new Set<String>();
        Set<String> TypeofUsersSet=new Set<String>();
        Set<String> OnsiteContactPersonsSet= new Set<String>();
        Set<String> OnsiteContactPersonOthersSet = new Set<String>();

        for (GC_Order__c o : orders) {
            if (String.isNotBlank(o.Booth_Area__c) && !deliveryLocationsSet.contains(o.Booth_Area__c)) {
                deliveryLocationsSet.add(o.Booth_Area__c);
                deliveryLocations.add(new SelectOption(o.Booth_Area__c, o.Booth_Area__c));
            }
            if (String.isNotBlank(o.Order_Area_Description__c) && !orderAreaDescriptionsSet.contains(o.Order_Area_Description__c)) {
                orderAreaDescriptionsSet.add(o.Order_Area_Description__c);
                orderAreaDescriptions.add(new SelectOption(o.Order_Area_Description__c, o.Order_Area_Description__c));
            }
            // Added by gopala krishna
             if (String.isNotBlank(o.User_Name__c) && !usernamesSet.contains(o.User_Name__c)) {
                usernamesSet.add(o.User_Name__c);
                usernames.add(new SelectOption(o.User_Name__c, o.User_Name__c));
            }
            /**if (String.isNotBlank(o.Type_Of_User__c) && !usernamesSet.contains(o.Type_Of_User__c)) {
                usernamesSet.add(o.Type_Of_User__c);
                usernames.add(new SelectOption(o.Username__c, o.Type_Of_User__c));
            }***/
               //Added by "gopala krishna";    
               }

        for (GC_GES_Order_Task__c o : gesTasks) {
            // This is really delivery area
            if (String.isNotBlank(o.Delivery_Location__c) && !deliveryAreasSet.contains(o.Delivery_Location__c)) {
                deliveryAreasSet.add(o.Delivery_Location__c);
                deliveryAreas.add(new SelectOption(o.Delivery_Location__c, o.Delivery_Location__c));
            }

            if (String.isNotBlank(o.Department__r.Name) && !departmentsSet.contains(o.Department__r.Name)) {
                departmentsSet.add(o.Department__r.Name);
                departments.add(new SelectOption(o.Department__r.Name, o.Department__r.Name));
            }

            if (String.isNotBlank(o.SA_Venue_Location__r.Name) && !venueLocationsSet.contains(o.SA_Venue_Location__r.Name)) {
                venueLocationsSet.add(o.SA_Venue_Location__r.Name);
                venueLocations.add(new SelectOption(o.SA_Venue_Location__r.Name, o.SA_Venue_Location__r.Name));
            }
             if ((o.Onsite_Contact__c != null) && String.isNotBlank(o.Onsite_Contact__r.Name) && !OnsiteContactPersonsSet.contains(o.Onsite_Contact__r.Name)) {
                OnsiteContactPersonsSet.add(o.Onsite_Contact__r.Name);
                OPOnsiteContactPersons.add(new SelectOption(o.Onsite_Contact__r.Name, o.Onsite_Contact__r.Name));
            }
            if (String.isNotBlank(o.Onsite_Contact_Person_Other__c) && !OnsiteContactPersonOthersSet.contains(o.Onsite_Contact_Person_Other__c)) {
                OnsiteContactPersonOthersSet.add(o.Onsite_Contact_Person_Other__c);
                OPOnsiteContactPersonOthers.add(new SelectOption(o.Onsite_Contact_Person_Other__c, o.Onsite_Contact_Person_Other__c));
            }
            if (String.isNotBlank(o.User_Name__c) && !usernamesSet.contains(o.User_Name__c)) {
                usernamesSet.add(o.User_Name__c);
                usernames.add(new SelectOption(o.User_Name__c, o.User_Name__c));
            }
                        

        }

        for (GC_Vendor_Order_Task__c v : vendorTasks) {
            if (String.isNotBlank(v.Vendor__r.Name) && !vendorsSet.contains(v.Vendor__r.Name)) {
                vendorsSet.add(v.Vendor__r.Name);
                vendors.add(new SelectOption(v.Vendor__r.Name, v.Vendor__r.Name));
            }

            if (String.isNotBlank(v.Vendor2__r.Name) && !vendorsSet.contains(v.Vendor2__r.Name)) {
                vendorsSet.add(v.Vendor2__r.Name);
                vendors.add(new SelectOption(v.Vendor2__r.Name, v.Vendor2__r.Name));
            }

            if (String.isNotBlank(v.Vendor3__r.Name) && !vendorsSet.contains(v.Vendor3__r.Name)) {
                vendorsSet.add(v.Vendor3__r.Name);
                vendors.add(new SelectOption(v.Vendor3__r.Name, v.Vendor3__r.Name));
            }

            if (String.isNotBlank(v.Vendor4__r.Name) && !vendorsSet.contains(v.Vendor4__r.Name)) {
                vendorsSet.add(v.Vendor4__r.Name);
                vendors.add(new SelectOption(v.Vendor4__r.Name, v.Vendor4__r.Name));
            }

            if (String.isNotBlank(v.Vendor5__r.Name) && !vendorsSet.contains(v.Vendor5__r.Name)) {
                vendorsSet.add(v.Vendor5__r.Name);
                vendors.add(new SelectOption(v.Vendor5__r.Name, v.Vendor5__r.Name));
            }
        }
        
        //SAL-558
        system.debug('areaDescription===='+areaDescription);
        Username= new List<String>();
        try{
            Id userId = UserInfo.getUserID();
            OrderFilter= [SELECT Id, Name, OP_Delivery_Location__c, OP_Area_Description__c, OP_Delivery_Area__c, OP_Department__c, OP_User_Name__c, OP_Venue_Location__c, OP_Modified_Date_From__c,OP_Modified_Date_To__c,OP_Creation_Date_From__c, OP_Creation_Date_To__c, OP_Delivery_Date_Time__c, OP_Completion_Date_Time__c,OP_Keyword_Search__c, OP_Vendor__c, OP_Removal_Date_Time__c, User__c,OP_Onsite_Contact_Person__c,OP_Onsite_Contact_Person_Other__c, Onsite_Contact_Person__c, Onsite_Contact_Person_Other__c, User_Name__c from GC_Report_Filters__c WHERE User__c = : userId ];
            
        }catch(exception e){
            system.debug(e);
            OrderFilter = new GC_Report_Filters__c();
            OrderFilter.User__c= UserInfo.getUserID();
            
        }
        if(OrderFilter.Id!=null){
                boothName = OrderFilter.OP_Delivery_Location__c; 
                areaDescription = OrderFilter.OP_Area_Description__c;
                delivery = OrderFilter.OP_Delivery_Area__c;
                department = OrderFilter.OP_Department__c;
                String selectedUsers= OrderFilter.OP_User_Name__c; 
                venue = OrderFilter.OP_Venue_Location__c;
                modifiedDateFrom = OrderFilter.OP_Modified_Date_From__c;
                modifiedDateTo = OrderFilter.OP_Modified_Date_To__c;
                createdDateFrom = OrderFilter.OP_Creation_Date_From__c;
                createdDateTo = OrderFilter.OP_Creation_Date_To__c;
                showDateDelivery = OrderFilter.OP_Delivery_Date_Time__c;
                showDateCompletion = OrderFilter.OP_Completion_Date_Time__c;
                searchString = OrderFilter.OP_Keyword_Search__c;
                vendor = OrderFilter.OP_Vendor__c;
                showDateRemoval = OrderFilter.OP_Removal_Date_Time__c;
                //oponsiteContactPerson = OrderFilter.OP_Onsite_Contact_Person__c;
                //oponsiteContactPersonOther = OrderFilter.OP_Onsite_Contact_Person_Other__c;
                
                if(OrderFilter.OP_Onsite_Contact_Person__c != null){
                oponsiteContactPerson = new List<String>();
                oponsiteContactPerson = multiSelectString(OrderFilter.OP_Onsite_Contact_Person__c, oponsiteContactPerson);
                }
            
               if(OrderFilter.OP_Onsite_Contact_Person_Other__c != null){
                oponsiteContactPersonOther = new List<String>();
                oponsiteContactPersonOther = multiSelectString(OrderFilter.OP_Onsite_Contact_Person_Other__c, oponsiteContactPersonOther);
                }
            
              if(OrderFilter.User_Name__c != null){
                username = new List<String>();
                username = multiSelectString(OrderFilter.User_Name__c, username);
            }
        }
        
    }

    /**
     * @description Loads home page if showId is empty
     * @return PageReference to home page of the community
     **/
    public PageReference loadPage() {
        if (String.isBlank(showId)) {
            return new PageReference(GC_PageUtil.CheckApexDomain() + homePage);
        }else{
            if(show.job_number__c.indexOf('000')>0||show.job_number__c.indexOf('0000')==0){
                PageReference analyticsPage = Page.gc_community_expressoreportslist;
                analyticsPage.setRedirect(true);
                analyticsPage.getParameters().put('showId', showId);
                analyticsPage.getParameters().put('projectNumber', show.job_number__c);
                return analyticsPage;
            }
        }

        return null;
    }

    /**
     * @description Allows user to create a order from home page
     * @return PageReference to order create edit page
     **/
    public PageReference createOrder() {
        showId = ApexPages.currentPage().getParameters().get('showId');

        if (showId != null) {
            return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_OrderCreateEdit?showId=' + showId);
        }

        return null;
    }
    
    
    
 
    /**
     * @description Emptying filter values once reset button is clicked and then requeries search results
     * @return PageReference
     **/
    public PageReference resetSearch() {
        boothName = null;
        areaDescription=null;
        department = null;
        delivery = null;
        venue = null;
        vendor = null;
        Username.clear();
        TypeOfUser=null;
        showDateDelivery = null;
        showDateCompletion = null;
        showDateRemoval = null;
        showDateCreation = null;
        createdDateFrom=null;
        createdDateTo=null;
        modifiedDateFrom=null;
        modifiedDateTo=null;
        oponsiteContactPerson.clear();
        oponsiteContactPersonOther.clear();
       return searchResults();
       
    }
    
     
     
     public String getDateString(Date date1) 
     {
        if (date1 == null) {
            return '';
        }
        DateTime dt = DateTime.newInstance(date1.year(), date1.month(), date1.day());
        return dt.format('yyyy-MM-dd');
     }

    /**
     * @description Perfoming filtering on the home page of communities
     * @return PageReference
     **/
     
    public PageReference searchResults() 
    { 
        system.debug('Today++++'+datetime.now());
        system.debug('deliveryDateTime++++'+deliveryDateTime);
        system.debug('completionDateTime++++'+completionDateTime);
        system.debug('removalDateTime++++'+removalDateTime);
        system.debug('Username++++'+Username);
        system.debug('createdDateFrom++++'+createdDateFrom);
        String userNamestr1='';
        userNamestr1 = concatenateAndCommaSeperate(Username);
       
        String oponsCntPerson1  = '';
        oponsCntPerson1 = concatenateAndCommaSeperate(oponsiteContactPerson);
        
        String oponsCntPersonOther1  = '';
        oponsCntPersonOther1 = concatenateAndCommaSeperate(oponsiteContactPersonOther);
        
        gesOrders.clear();
        String orderWhereQuery = '';
        String gotWhereQuery = '';
        String votWhereQuery = '';

        orderQuery = 'SELECT Id,Name,Booth_Area__c,User_Name__c,Type_Of_User__c,Booth_Area_ID__c,Completion_Date_Time__c,Connect2_Show__c,Delivery_Date_Time__c,CreatedById,Order_Number__c,Status__c,Removal_Date_Time__c, Order_Area_Description__c,CreatedDate,LastModifiedDate FROM GC_Order__c WHERE Connect2_Show__c = \'' + showId + '\'';
        orderWhereQuery += String.isNotBlank(boothName) ? ' AND Booth_Area__c like \'%' + boothName + '%\'' : '';
        orderWhereQuery += String.isNotBlank(areaDescription) ? ' AND Order_Area_Description__c like \'%' + areaDescription + '%\'' : '';
        //orderWhereQuery += String.isNotBlank(Username) ? ' AND User_Name__c like \'%' + Username + '%\'' : '';
        orderWhereQuery += Username.size() > 0 && userNamestr1!='' ? ' AND User_Name__c in ('+userNamestr1+')' : '';
        
        
         system.debug('createdDateFrom===========>'+createdDateFrom);
         system.debug('createdDateTo==========>'+createdDateTo);
         system.debug('modifiedDateFrom===>'+modifiedDateFrom);
         system.debug('modifiedDateTo========>'+modifiedDateTo);
        
             
         
       
        
        
        orderQuery = orderQuery + orderWhereQuery;
        System.debug(orderQuery);

        Map<String, GC_Order__c> orders = new Map<String, GC_Order__c>((List<GC_Order__c>)Database.Query(orderQuery + orderWhereQuery));

        gotQuery = 'SELECT Id, Name, Order__c,User_Name__c,Department__r.Name, Delivery_Location__c, SA_Venue_Location__c,Onsite_Contact__r.Name,Onsite_Contact_Person_Other__c FROM GC_GES_Order_Task__c WHERE Order__c In (\'' + String.join(new List<String>(orders.keySet()), '\',\'') + '\')';
        gotWhereQuery += String.isNotBlank(department) ? ' AND Department__r.Name like \'%' + department + '%\'' : '';
        gotWhereQuery += String.isNotBlank(delivery) ? ' AND Delivery_Location__c like \'%' + delivery + '%\'' : '';
        gotWhereQuery += String.isNotBlank(venue) ? ' AND SA_Venue_Location__r.Name like \'%' + venue + '%\'' : '';
         //gotWhereQuery += String.isNotBlank(Username) ? ' AND User_Name__c like \'%' + Username + '%\'' : '';
        //gotWhereQuery += String.isNotBlank(oponsiteContactPerson) ? ' AND Onsite_Contact__r.Name like\'%' + oponsiteContactPerson + '%\'' : '';
        //gotWhereQuery += String.isNotBlank(oponsiteContactPersonOther) ? ' AND Onsite_Contact_Person_Other__c like\'%' + oponsiteContactPersonOther + '%\'' : '';
        
        gotWhereQuery += oponsiteContactPerson.size() > 0 && oponsCntPerson1 !='' ? ' AND Onsite_Contact__r.Name in (' + oponsCntPerson1 + ')' : '';
        gotWhereQuery += oponsiteContactPersonOther.size() > 0 && oponsCntPersonOther1 !='' ? ' AND Onsite_Contact_Person_Other__c in (' + oponsCntPersonOther1 + ')' : '';
        gotWhereQuery += Username.size()>0 && userNamestr1 !='' ? ' AND User_Name__c in ('+userNamestr1+')' : '';
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
            orderQuery = 'SELECT Id,Name,User_Name__c,Booth_Area__c,Type_Of_User__c,Booth_Area_ID__c,Completion_Date_Time__c,Connect2_Show__c,Delivery_Date_Time__c,CreatedById,Order_Number__c,Status__c,Removal_Date_Time__c, Order_Area_Description__c,CreatedDate,LastModifiedDate FROM GC_Order__c WHERE Id In (\'' + String.join(new List<String>(ordersFilteredFromOrderTasks), '\',\'') + '\')';
        } else if (String.isNotBlank(department) || String.isNotBlank(delivery)|| Username.size()>0) {
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
                orderQuery = 'SELECT Id,Name,User_Name__c,Booth_Area__c,Type_Of_User__c,Booth_Area_ID__c,Completion_Date_Time__c,Connect2_Show__c,Delivery_Date_Time__c,CreatedById,CreatedDate,LastModifiedDate,Order_Number__c,Status__c,Removal_Date_Time__c, Order_Area_Description__c FROM GC_Order__c WHERE Id In (\'' + String.join(new List<String>(ordersFilteredFromVendorTasks), '\',\'') + '\')';
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
                orderQuery = 'SELECT Id,Name,Booth_Area__c,Booth_Area_ID__c,Type_Of_User__c,Completion_Date_Time__c,Connect2_Show__c,Delivery_Date_Time__c,CreatedById,CreatedDate,LastModifiedDate,Order_Number__c,Status__c,Removal_Date_Time__c,User_Name__c, Order_Area_Description__c FROM GC_Order__c WHERE Id In (\'' + String.join(new List<String>(ordersFilteredFromVendorTasks), '\',\'') + '\')';
            } else if (String.isNotBlank(vendor)) {
                gesOrders.clear();
                return null;
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



        /**
        *Modified Date
        **/
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
        System.debug('searchString>>>>'+searchString);

        if(String.isNotBlank(searchString))
        {
            orderQuery += ' AND ((Booth_Area__c like \'%' + searchString + '%\')';
            orderQuery += ' OR  (Name like \'%' + searchString + '%\')';
            orderQuery += ' OR  (Status__c like \'%' + searchString + '%\')';
            orderQuery += ' OR  (User_Name__c like \'%' + searchString + '%\')';
            orderQuery += ' OR  (Type_Of_User__c like \'%' + searchString + '%\')';
            orderQuery += ' OR  (Order_Area_Description__c  like \'%' + searchString + '%\'))'; 
        }


        gesOrders = Database.Query(orderQuery + ' order by ' + orderByQuery + ' ' + sortOrder);
       // SaveOrderFilter();
        return null;
    }

    /**
     * @description Allows the user to print all orders that are related to the currently selected show
     * @return PageReference to show on the go page
     **/
    public PageReference printShow() {
        String showId = ApexPages.currentPage().getParameters().get('showId');
        return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_ShowOnTheGo?Id=' + showId + '&isCommunity=true');
    }
    
    //Added for OrderClone functionality
    public PageReference cloneOrder() {
        String showId = ApexPages.currentPage().getParameters().get('showId');
        return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Order_Clone_SelectView?Id=' + showId + '&isCommunity=true');
    }
    //Added for OrderClone functionality

    public String sortOrder {get; set;}
    public String orderByQuery {get; set;}
    public PageReference sortColumn() {
        String previousColumn = orderByQuery;

        if (Apexpages.currentPage().getParameters().containsKey('orderByCol')) {
            orderByQuery = Apexpages.currentPage().getParameters().get('orderByCol');
        }

        if (previousColumn != orderByQuery) {
            sortOrder = 'asc';
        } else if (sortOrder.contains('asc')) {
            sortOrder = sortOrder.replace('asc', 'desc');
        } else if (sortOrder.contains('desc')) {
            sortOrder = sortOrder.replace('desc', 'asc');
        }

        return searchResults();
    }
    
    //SAL-558
     public void SaveOrderFilter(){
        system.debug('OrderFilter.Id==='+OrderFilter.Id);
        system.debug('username==='+username);
        OrderFilter.OP_Delivery_Location__c = string.isNotBlank(boothName) ? boothName : '';
        OrderFilter.OP_Area_Description__c = string.isNotBlank(areaDescription) ? areaDescription : '';       
        OrderFilter.OP_Delivery_Area__c = string.isNotBlank(delivery) ? delivery : '';
        OrderFilter.OP_Department__c = string.isNotBlank(department) ? department : '';
        //OrderFilter.OP_User_Name__c = username.size()>0 ? username : '';
        OrderFilter.OP_Venue_Location__c = string.isNotBlank(venue) ? venue : '';
        OrderFilter.OP_Modified_Date_From__c = modifiedDateFrom;
        OrderFilter.OP_Modified_Date_To__c = modifiedDateTo;
        OrderFilter.OP_Creation_Date_From__c = createdDateFrom;
        OrderFilter.OP_Creation_Date_To__c = createdDateTo;
        OrderFilter.OP_Delivery_Date_Time__c = showDateDelivery;
        OrderFilter.OP_Completion_Date_Time__c = showDateCompletion;
        OrderFilter.OP_Keyword_Search__c = string.isNotBlank(searchString) ? searchString : '';
        OrderFilter.OP_Vendor__c = string.isNotBlank(vendor) ? vendor : '';
        OrderFilter.OP_Removal_Date_Time__c = showDateRemoval;
        //OrderFilter.OP_Onsite_Contact_Person__c= string.isNotBlank(OPOnsiteContactPerson) ? OPOnsiteContactPerson : '';
        //OrderFilter.OP_Onsite_Contact_Person_Other__c = string.isNotBlank(OPOnsiteContactPersonOther) ? OPOnsiteContactPersonOther : '';
            
        OrderFilter.OP_Onsite_Contact_Person__c= (OPOnsiteContactPerson!= null) ? filterString(OPOnsiteContactPerson) : '';
        OrderFilter.OP_Onsite_Contact_Person_Other__c = (OPOnsiteContactPersonOther != null) ? filterString(OPOnsiteContactPersonOther) : '';
        OrderFilter.User_Name__c = filterString(username);
        
        Upsert OrderFilter;
                
    }
    public String concatenateAndCommaSeperate(List<String> multiselectInput){
        String resultString='';
        String inputString='';
        String inputStringList= '[';
        for(String str: multiselectInput){
            inputStringList+=str+',';
        }
        inputStringList+= ']';
        if (String.isNotBlank(inputStringList)){
            inputString=inputStringList.replace('[','').replace(']','');
            String[] arrTest = inputString.split('\\,');
            
            for(String str:arrTest)
            {
                resultString += '\''+str.trim()+'\''+',';
            }
            if(resultString.length()>0){
                resultString = resultString.substring(0,resultString.length()-1);
            }
        }
        return resultString;
    }
    
    public String filterString(List<String> filterCriterias){
        string criteria='[';
        if(filterCriterias.size()>0){
            for(String fc:filterCriterias){
                criteria+= fc+',';
            }
        }
        criteria+=']';
        return criteria;
    }
    
    public List<String> multiSelectString(String filterCriteria, List<String> listToAppend){
        String[] arrTest = filterCriteria.replace('[','').replace(']','').split('\\,');
        List<String> sortedvalue = filterCriteria.replace('[','').replace(']','').split(',');
        for(String str : sortedvalue) {
            listToAppend.add(str);
        }
        return listToAppend;
    }
    
}