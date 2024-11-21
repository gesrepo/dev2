/**
* @author Ethos Solutions - www.ethos.com
* @description Controller for Show On The Go PDF page that passes Order ids into page parameter
* 2016-04-13 : Original Version
**/
public with sharing class GC_ShowOnTheGoHolderController {
    public List<GC_OrderHolder> orderHolders {get; set;}
    public GC_Connect2_Show__c show {get; set;}
    
    //public Set<String> statusValues {get; set;}
    public List<SelectOption> availableStatus {get; set;}
    public List<SelectOption> selectedStatus {get; set;}
    
    public GC_Core_Interface_Log__c urlParamsObject {get; set;} // use this object with details of the user every time they print pdf.
    
    
    public List<SelectOption> deliveryLocations { get; set; }
    public List<SelectOption> deliveryAreas { get; set; }
    public List<SelectOption> departments { get; set; }
    public List<SelectOption> venueLocations { get; set; }
    public List<SelectOption> vendors { get; set; }
    public List<SelectOption> orderAreaDescriptions { get; set; }
    public List<SelectOption> Usernames{get;set;}
    public List<SelectOption> TypeofUsers{get;set;}
    public List<SelectOption> OnsiteContactPersons {get; set;}
    public List<SelectOption> OnsiteContactPersonOthers {get; set;}
    
    public String orderQuery {get; set;}
    public String gotQuery {get; set;}
    public String votQuery {get; set;}
    public String deliveryLocation {get; set;} // this is delivery location
    public String department {get; set;}
    public String delivery {get; set;} // this is delivery area
    public String venue {get; set;}
    public List<String> onsiteContactPerson {get; set;}
    public List<String> onsiteContactPersonOther {get; set;}
    public String vendor {get; set;}
    public List<String> Username{get;set;}
    public String TypeofUser{get;set;}
    public String areaDescription {get; set;}
    public String User{get;set;}
    
    public List<GC_Order__c> gesOrders {get; set;}
    public String sortOrder {get; set;}
    public String orderByQuery {get; set;}
    public Boolean isDisplayed {get; set;}
    public String searchString {get; set;}
    
    public Date showDateDelivery {get; set;}
    public Date showDateCompletion {get; set;}
    public Date showDateRemoval {get; set;}
    public Date createdDateFrom {get; set;}
    public Date createdDateTo {get; set;}
    public Date modifiedDateFrom {get; set;}
    public Date modifiedDateTo {get; set;}
    
    public Boolean signOrder{get; set;} //for SAL 527
    public Boolean workOrder{get; set;} //for SAL 527
    public String signOrderOpt{get; set;} //for SAL 527
    public String workOrderOpt{get; set;} //for SAL 527
    public GC_Report_Filters__c reportFilter{get; set;} //SAL-558
    public string initialOrderByQuery {get; set;} //SAL-633
    public string prevSortOrder {get; set;} //SAL-633
    public Boolean pdfByLocation{get; set;} //SAL-633
    public List<GC_Core_Interface_Log__c> urlParamsObjectList{get; set;}    //SAL-633
    public String isCommunity {get; set;}
    public Boolean isCommunityBool{get; set;}
    
    
    public GC_ShowOnTheGoHolderController(ApexPages.StandardController sc) {
        show = (GC_Connect2_Show__c)sc.getRecord();
        isCommunity = GC_PageUtil.getParam('isCommunity');
        if(string.isNotBlank(isCommunity)&& isCommunity=='true'){
            isCommunityBool=true;
        }else{
            isCommunityBool=false;
        }
        orderHolders = new List<GC_OrderHolder>();
        signOrderOpt='false'; //for SAL 527
        workOrderOpt='false'; //for SAL 527
        initialOrderByQuery= 'Booth_Area__c';   //SAL-633
        prevSortOrder='asc';
        initialOrderByQuery= initialOrderByQuery +' '+ prevSortOrder;       //SAL-633
        gesOrders = GC_OrderDao.getInstance().getByConnect2ShowId(show.Id, initialOrderByQuery);    //SAL-633
        
        for (GC_Order__c order : gesOrders) {
            orderHolders.Add(new GC_OrderHolder(order));
        }
        
        //urlParamsObjectList = [select id from GC_Core_Interface_Log__c limit 5];
        
        Set<String> statusValuesToShow = new Set<String>();
        Set<String> statusValuesToHide = new Set<String>();
        availableStatus = new List<SelectOption>();
        selectedStatus = new List<SelectOption>();
        statusValuesToShow.add('New');
        statusValuesToShow.add('Approved');
        statusValuesToShow.add('Submitted');
        statusValuesToShow.add('Approved');
        statusValuesToShow.add('Active');
        statusValuesToShow.add('On Hold');
        statusValuesToHide.add('Rejected');
        statusValuesToHide.add('Cancelled');
        statusValuesToHide.add('Released');
        statusValuesToHide.add('Submitted To Graphics');
        
        for (String status : statusValuesToShow) {
            selectedStatus.add(new SelectOption(status, status));
        }
        for (String status : statusValuesToHide) {
            availableStatus.add(new SelectOption(status, status));
        }
        
        //List<GC_Order__c> orders = GC_OrderDao.getInstance().getByConnect2ShowId(showId);
        List<GC_GES_Order_Task__c> gesTasks = GC_GESOrderTaskDao.getInstance().getByConnect2ShowId(show.Id);
        List<GC_Vendor_Order_Task__c> vendorTasks = GC_VendorOrderTaskDao.getInstance().getByConnect2ShowId(show.Id);
        
        deliveryLocations = new List<SelectOption>();
        orderAreaDescriptions = new List<SelectOption>();
        deliveryAreas = new List<SelectOption>();
        departments = new List<SelectOption>();
        Usernames =new List<SelectOption>();
        venueLocations = new List<SelectOption>();
        OnsiteContactPersons = new List<SelectOption>();
        OnsiteContactPersonOthers = new List<SelectOption>();
        vendors = new List<SelectOption>();
        TypeofUsers=new List<SelectOption>();
        
        deliveryLocations.add(new SelectOption('', '----None----'));
        orderAreaDescriptions.add(new SelectOption('', '----None----'));
        deliveryAreas.add(new SelectOption('', '----None----'));
        departments.add(new SelectOption('', '----None----'));
        venueLocations.add(new SelectOption('', '----None----'));
        OnsiteContactPersons.add(new SelectOption('','----None----'));
        OnsiteContactPersonOthers.add(new SelectOption('','----None----'));
        vendors.add(new SelectOption('', '----None----'));
        Usernames.add(new SelectOption('', '----None----'));
        TypeOfUsers.add(new SelectOption('','---None---'));
        
        orderByQuery = 'Name';
        sortOrder = 'asc';
        isDisplayed = true;
        
        Set<String> deliveryLocationsSet = new Set<String>();
        Set<String> orderAreaDescriptionsSet = new Set<String>();
        Set<String> deliveryAreasSet = new Set<String>();
        Set<String> departmentsSet = new Set<String>();
        Set<String> venueLocationsSet = new Set<String>();
        Set<String> OnsiteContactPersonsSet = new Set<String>();
        Set<String> OnsiteContactPersonOthersSet = new Set<String>();
        Set<String> vendorsSet = new Set<String>();
        Set<String> Usernamesset= new Set<String>();
        Set<String> TypeofUsersSet=new Set<String>();
        
        for (GC_Order__c o : gesOrders) {
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
                OnsiteContactPersons.add(new SelectOption(o.Onsite_Contact__r.Name, o.Onsite_Contact__r.Name));
            }
            if (String.isNotBlank(o.Onsite_Contact_Person_Other__c) && !OnsiteContactPersonOthersSet.contains(o.Onsite_Contact_Person_Other__c)) {
                OnsiteContactPersonOthersSet.add(o.Onsite_Contact_Person_Other__c);
                OnsiteContactPersonOthers.add(new SelectOption(o.Onsite_Contact_Person_Other__c, o.Onsite_Contact_Person_Other__c));
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
        Username = new List<String>();
        try{
            Id userId = UserInfo.getUserID();
            reportFilter= [SELECT Id, Name,Area_Description__c, Completion_Date_Time__c, Creation_Date_From__c,Creation_Date_To__c, Delivery_Area__c, Delivery_Date_Time__c, Delivery_Location__c,Department__c, Keyword_Search__c, Modified_Date_To__c, Modified_Date_From__c, Removal_Date_Time__c, User_Name__c, Vendor__c, Venue_Location__c, Onsite_Contact_Person__c, Onsite_Contact_Person_Other__c, User__c from GC_Report_Filters__c WHERE User__c = : userId ];
        }catch(exception e){
            system.debug(e);
            reportFilter = new GC_Report_Filters__c();
            reportFilter.User__c= UserInfo.getUserID();
        }
        if(reportFilter.Id!=null){
            areaDescription = reportFilter.Area_Description__c; 
            showDateCompletion = reportFilter.Completion_Date_Time__c;
            createdDateFrom = reportFilter.Creation_Date_From__c;
            createdDateTo = reportFilter.Creation_Date_To__c;
            delivery = reportFilter.Delivery_Area__c;               
            showDateDelivery = reportFilter.Delivery_Date_Time__c;
            deliveryLocation = reportFilter.Delivery_Location__c;
            department = reportFilter.Department__c;
            searchString = reportFilter.Keyword_Search__c;
            modifiedDateFrom = reportFilter.Modified_Date_From__c;
            modifiedDateTo = reportFilter.Modified_Date_To__c;
            showDateRemoval = reportFilter.Removal_Date_Time__c;
            //Username = reportFilter.User_Name__c;
            vendor = reportFilter.Vendor__c;
            venue = reportFilter.Venue_Location__c;
            
            if(reportFilter.Onsite_Contact_Person__c != null){
                onsiteContactPerson = new List<String>();
                onsiteContactPerson = multiSelectString(reportFilter.Onsite_Contact_Person__c, onsiteContactPerson);
                }
            
            if(reportFilter.Onsite_Contact_Person_Other__c != null){
                onsiteContactPersonOther = new List<String>();
                onsiteContactPersonOther = multiSelectString(reportFilter.Onsite_Contact_Person_Other__c, onsiteContactPersonOther);
                }
            
            if(reportFilter.User_Name__c != null){
                username = new List<String>();
                username = multiSelectString(reportFilter.User_Name__c, username);
            }
        }
    }
    
    public PageReference itemsSelected() {
        
        List<GC_OrderHolder> selectedOrderShows = new List<GC_OrderHolder>();
        Set<String> orderIds = new Set<String>();
        Set<String> selectedLocations = new Set<String>();  //SAL-633
        Set<String> selectedStatusValues = new Set<String>();   //SAL-633
        Map<String, Set<String>> selectedOrdersByLocation =new  Map<String, Set<String>>(); //SAL-633
        List <PageReference> prList = new List <PageReference>();
        for (GC_OrderHolder showHolder : orderHolders) {
            if (showHolder.selected) {
                selectedOrderShows.add(showHolder);
                orderIds.add(showHolder.order.Id);
                selectedLocations.add(showHolder.order.Booth_Area__c);
            }
        }
        
        if (orderIds.size() == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR , 'You must select at least one Order'));
            return null;
        }
        
        for(SelectOption so: selectedStatus) {
            selectedStatusValues.add(so.getValue());
        }
        
        urlParamsObject = new GC_Core_Interface_Log__c();
        GC_OrderUtils.URLParameters urlParams = new GC_OrderUtils.URLParameters();
        urlParams.orderIds = orderIds;
        urlParams.statusValues = selectedStatusValues;
        urlParamsObject.Method_Name__c = 'PDF Print ' + DateTime.now() + ' ' + UserInfo.getUserName();
        urlParamsObject.Message_Content__c = JSON.serialize(urlParams);
        //insert urlParamsObject;
        
        if(signOrder ==true){
            signOrderOpt='true';
        }
        if(workOrder ==true){
            workOrderOpt='true';
        }
        
        if(pdfByLocation){
            urlParamsObjectList = new List<GC_Core_Interface_Log__c> ();
            for (GC_OrderHolder showHolder : selectedOrderShows){
                if(selectedOrdersByLocation.containsKey(showHolder.order.Booth_Area__c)){
                    continue;
                }else{
                    selectedOrdersByLocation.put(showHolder.order.Booth_Area__c, new Set<String>());
                }
                selectedOrdersByLocation.get(showHolder.order.Booth_Area__c).add(showHolder.order.id);
            }
            for(String key: selectedOrdersByLocation.keySet()){
                GC_Core_Interface_Log__c urlParamsObject1 = new GC_Core_Interface_Log__c();
                GC_OrderUtils.URLParameters urlParams1 = new GC_OrderUtils.URLParameters();
                urlParams1.orderIds = selectedOrdersByLocation.get(key);
                urlParams1.statusValues = selectedStatusValues;
                urlParamsObject1.Method_Name__c = 'PDF Print ' + DateTime.now() + ' ' + UserInfo.getUserName();
                urlParamsObject1.Message_Content__c = JSON.serialize(urlParams1);
                urlParamsObjectList.add(urlParamsObject1);
            }
            insert urlParamsObjectList;
            system.debug('urlParamsObjectList==='+urlParamsObjectList.size());
            return null;
            
        }else{
            insert urlParamsObject;
            return new PageReference('/apex/GC_ShowOnTheGoPDF?urlParamsId=' + urlParamsObject.Id+'&signOrderOpt='+signOrderOpt+'&workOrderOpt='+workOrderOpt+'&pdfByLocation='+pdfByLocation);
        }
    }
    
    public PageReference itemsSelectedtoExportCSV() {
        List<GC_OrderHolder> selectedOrderShows = new List<GC_OrderHolder>();
        Set<String> orderIds = new Set<String>();
        Set<String> selectedStatusValues = new Set<String>();
        
        for (GC_OrderHolder showHolder : orderHolders) {
            if (showHolder.selected) {
                selectedOrderShows.add(showHolder);
                orderIds.add(showHolder.order.Id);
            }
        }
        
        if (orderIds.size() == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR , 'You must select at least one Order'));
            return null;
        }
        
        for(SelectOption so: selectedStatus) {
            selectedStatusValues.add(so.getValue());
        }
        
        isCommunity = GC_PageUtil.getParam('isCommunity');
        
        urlParamsObject = new GC_Core_Interface_Log__c();
        GC_OrderUtils.URLParameters urlParams = new GC_OrderUtils.URLParameters();
        urlParams.orderIds = orderIds;
        urlParams.statusValues = selectedStatusValues;
        urlParamsObject.Method_Name__c = 'PDF Print ' + DateTime.now() + ' ' + UserInfo.getUserName();
        urlParamsObject.Message_Content__c = JSON.serialize(urlParams);
        insert urlParamsObject;
        return new PageReference('/apex/GC_ExportToCSV?urlParamsId=' + urlParamsObject.Id + '&isCommunity=' + isCommunity);
    }
    
    public PageReference searchResults() {
        system.debug('ordersholdersCountBefore>>>>'+orderHolders.size()); 
        
        String userNamestr1='';
        userNamestr1 = concatenateAndCommaSeperate(Username);
       
        String onsCntPerson1  = '';
        onsCntPerson1 = concatenateAndCommaSeperate(onsiteContactPerson);
        
        String onsCntPersonOther1  = '';
        onsCntPersonOther1 = concatenateAndCommaSeperate(onsiteContactPersonOther);
        
        gesOrders.clear();
        String orderWhereQuery = '';
        String gotWhereQuery = '';
        String votWhereQuery = '';
        
        orderQuery = 'SELECT Id,Name,Show_Name__c,Booth_Area__c,User_Name__c,Type_Of_User__c,Booth_Area_ID__c,Completion_Date_Time__c,Connect2_Show__c,Delivery_Date_Time__c,Order_Number__c,Status__c,Removal_Date_Time__c, Order_Area_Description__c,CreatedDate,LastModifiedDate  FROM GC_Order__c WHERE Connect2_Show__c = \'' + show.Id + '\'';
        orderWhereQuery += String.isNotBlank(deliveryLocation) ? ' AND Booth_Area__c like \'%' + deliveryLocation + '%\'' : '';
        orderWhereQuery += String.isNotBlank(areaDescription) ? ' AND Order_Area_Description__c like \'%' + areaDescription + '%\'' : '';
        orderWhereQuery += Username.size() > 0 && userNamestr1!='' ? ' AND User_Name__c in ('+userNamestr1+')' : '';
        
        orderQuery = orderQuery + orderWhereQuery; 
        
        Map<String, GC_Order__c> orders = new Map<String, GC_Order__c>((List<GC_Order__c>)Database.Query(orderQuery + orderWhereQuery));
        
        gotQuery = 'SELECT Id, Name, Order__c,User_Name__c,Department__r.Name, Delivery_Location__c, SA_Venue_Location__c,Onsite_Contact__r.Name,Onsite_Contact_Person_Other__c FROM GC_GES_Order_Task__c WHERE Order__c In (\'' + String.join(new List<String>(orders.keySet()), '\',\'') + '\')';
        gotWhereQuery += String.isNotBlank(department) ? ' AND Department__r.Name like \'%' + department + '%\'' : '';
        gotWhereQuery += String.isNotBlank(delivery) ? ' AND Delivery_Location__c like \'%' + delivery + '%\'' : '';
        gotWhereQuery += String.isNotBlank(venue) ? ' AND SA_Venue_Location__r.Name like \'%' + venue + '%\'' : '';
        
        
        gotWhereQuery += onsiteContactPerson.size() > 0 && onsCntPerson1 !='' ? ' AND Onsite_Contact__r.Name in (' + onsCntPerson1 + ')' : '';
        gotWhereQuery += onsiteContactPersonOther.size() > 0 && onsCntPersonOther1 !='' ? ' AND Onsite_Contact_Person_Other__c in (' + onsCntPersonOther1 + ')' : '';
        gotWhereQuery += Username.size()>0 && userNamestr1!='' ? ' AND User_Name__c in ('+userNamestr1+')' : '';
        System.debug('got and WhereQuery===' + gotQuery + gotWhereQuery);
        List<GC_GES_Order_Task__c> gotQueryList = Database.Query(gotQuery + gotWhereQuery);
        
        Set<String> ordersFilteredFromOrderTasks = new Set<String>();
        Map<String, GC_Order__c> ordersFilteredFromOrderTasksMap = new Map<String, GC_Order__c>();
        
        
        for (GC_GES_Order_Task__c task : gotQueryList) {
            if (String.isNotBlank(gotWhereQuery)) {
                ordersFilteredFromOrderTasks.add(task.Order__c);
            }
        }
        
        //system.debug('ordersFilteredFromOrderTasks==='+ordersFilteredFromOrderTasks.size());
        
        if (ordersFilteredFromOrderTasks.size() > 0) {
            orderQuery = 'SELECT Id,Name,Show_Name__c,User_Name__c,Booth_Area__c,Type_Of_User__c,Booth_Area_ID__c,Completion_Date_Time__c,Connect2_Show__c,Delivery_Date_Time__c,Order_Number__c,Status__c,Removal_Date_Time__c, Order_Area_Description__c,CreatedDate,LastModifiedDate FROM GC_Order__c WHERE Id In (\'' + String.join(new List<String>(ordersFilteredFromOrderTasks), '\',\'') + '\')';
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
                orderQuery = 'SELECT Id,Name,Show_Name__c,Booth_Area__c,Booth_Area_ID__c,Type_Of_User__c,Completion_Date_Time__c,Connect2_Show__c,Delivery_Date_Time__c,Order_Number__c,Status__c,Removal_Date_Time__c,User_Name__c, Order_Area_Description__c,CreatedDate,LastModifiedDate  FROM GC_Order__c WHERE Id In (\'' + String.join(new List<String>(ordersFilteredFromVendorTasks), '\',\'') + '\')';
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
        
        if(modifiedDateFrom!=null && modifiedDateTo==null)
        {
            system.debug('modifiedDateFrom1==='+modifiedDateFrom);
            String dateString = getDateString(modifiedDateFrom)+'T'+ '00:00' + ':' + '00'+'Z';
            String dateString1 = getDateString(modifiedDateFrom)+'T'+ '23' + ':' + '59'+':59'+'Z';
            orderQuery += ' AND (LastModifiedDate>= '+ dateString +')';
            reportFilter.Modified_Date_From__c = modifiedDateFrom;
        }
        
        if(modifiedDateFrom==null && modifiedDateTo!=null)
        {
            String dateString = getDateString(modifiedDateTo)+'T'+ '00:00' + ':' + '00'+'Z';
            String dateString1 = getDateString(modifiedDateTo)+'T'+ '23' + ':' + '59'+':59'+'Z';
            orderQuery += ' AND (LastModifiedDate<= '+ dateString + ')';
        }
        
        if(modifiedDateFrom!=null && modifiedDateTo!=null)
        {
            system.debug('modifiedDateFrom2==='+modifiedDateFrom);
            String dateString = getDateString(modifiedDateFrom)+'T'+ '00:00' + ':' + '00'+'Z';
            String dateString1 = getDateString(modifiedDateTo)+'T'+ '23' + ':' + '59'+':59'+'Z';
            orderQuery += ' AND (LastModifiedDate>= '+ dateString;
            orderQuery += ' AND LastModifiedDate<= '+ dateString1+')';
            reportFilter.Modified_Date_From__c = modifiedDateFrom;
        }
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
        gesOrders = Database.Query(orderQuery + ' order by ' + orderByQuery + ' ' + sortOrder);
        orderHolders.clear();
        
        for (GC_Order__c order : gesOrders) {
            orderHolders.Add(new GC_OrderHolder(order));
        }
        system.debug('ordersholdersCountAfter>>>>'+orderHolders.size()); 
        
        return null;
    }
    
    public String getDateString(Date dt) {
        if (dt == null) {
            return '';
        }
        return DateTime.newInstance(dt.year(), dt.month(), dt.day()).format('yyyy-MM-dd');
    }
    
    public PageReference resetSearch() {
        areaDescription=null;
        showDateDelivery = null;
        showDateCompletion = null;
        showDateRemoval = null;
        createdDateFrom=null;
        createdDateTo=null;
        modifiedDateFrom=null;
        modifiedDateTo=null;
        searchString = null;
        department = null;
        delivery = null;
        venue = null;
        onsiteContactPerson.clear();
        onsiteContactPersonOther.clear();
        vendor = null;
        Username.clear();
        return searchResults();
    }
    
    //SAL-558
    public void SavePDFFilter(){
        system.debug('modifiedDateFrom==='+modifiedDateFrom);
        system.debug('reportFilter.Modified_Date_From__c==='+reportFilter.Modified_Date_From__c);
        reportFilter.Area_Description__c = areaDescription;
        reportFilter.Completion_Date_Time__c = showDateCompletion;
        reportFilter.Creation_Date_From__c = createdDateFrom;
        reportFilter.Creation_Date_To__c = createdDateTo;
        reportFilter.Delivery_Area__c = string.isNotBlank(delivery) ? delivery : '';                
        reportFilter.Delivery_Date_Time__c = showDateDelivery;
        reportFilter.Delivery_Location__c = string.isNotBlank(deliveryLocation) ? deliveryLocation : '';
        reportFilter.Department__c = string.isNotBlank(department) ? department : '';
        reportFilter.Keyword_Search__c = string.isNotBlank(searchString) ? searchString : '';
        //reportFilter.Modified_Date_From__c = modifiedDateFrom;
        reportFilter.Modified_Date_To__c = modifiedDateTo;
        reportFilter.Removal_Date_Time__c = showDateRemoval;
        reportFilter.Vendor__c = string.isNotBlank(vendor) ? vendor : '';
        reportFilter.Venue_Location__c = string.isNotBlank(venue) ? venue : '';
        reportFilter.Onsite_Contact_Person__c= (onsiteContactPerson!= null) ? filterString(onsiteContactPerson) : '';
        reportFilter.Onsite_Contact_Person_Other__c = (onsiteContactPersonOther != null) ? filterString(onsiteContactPersonOther) : '';
        reportFilter.User_Name__c = filterString(username);        
        Upsert reportFilter;
    }
    
    public void performSort(){
        String previousSortByQuery = initialOrderByQuery;
        initialOrderByQuery= Apexpages.currentPage().getParameters().get('initialOrderByQuery');
        
        if(string.isNotBlank(initialOrderByQuery)){  
            system.debug('initialOrderByQuery==='+initialOrderByQuery);
            system.debug('prevSortOrder==='+prevSortOrder);
            gesOrders = GC_OrderDao.getInstance().getByConnect2ShowId(show.Id, initialOrderByQuery);
            orderHolders.clear();
            for (GC_Order__c order : gesOrders) {
                orderHolders.Add(new GC_OrderHolder(order));
            }
        }
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