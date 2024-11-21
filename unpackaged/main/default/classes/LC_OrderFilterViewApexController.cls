public with sharing class LC_OrderFilterViewApexController {
    public static Map<String, DateTime> newDLWithCompletionDate=new Map<String, DateTime>();
    public static Map<String, DateTime> newDLWithDeliveryDate=new Map<String, DateTime>();
    public static Map<String, DateTime> newDLWithRemovalDate=new Map<String, DateTime>();
    public static Map<String, String> newDLWithId=new Map<String, String>();
    
    public string recordId{get; set;}
    
    public LC_OrderFilterViewApexController(ApexPages.StandardSetController controller){
        recordId=apexpages.currentpage().getparameters().get('id');
    }
    public static GC_Connect2_Show__c show;
    public static List<GC_Order__c> gesOrders;
    public static string orderByQuery='Booth_Area__c';
    public static string sortOrder='asc';
    public static Set<String> deliveryLocationsSet = new Set<String>();
    public static Set<String> orderAreaDescriptionsSet = new Set<String>();
    public static Set<String> usernamesSet = new Set<String>();
    public static Set<String> deliveryAreasSet = new Set<String>();
    public static Set<String> departmentsSet= new Set<String>();
    public static Set<String> venueLocationsSet= new Set<String>();
    public static Set<String> OnsiteContactPersonsSet= new Set<String>();
    public static Set<String> OnsiteContactPersonOthersSet= new Set<String>();
    public static Set<String> vendorsSet= new Set<String>();
    public static Set<String> ownerNameSet = new Set<String>(); //SAL-1214 - Fitler by OwnerName - 03/15/24 - Sajid
    
    public class WrapperClass{
        @AuraEnabled   public List<string> deliveryLocations{get;set;}
        @AuraEnabled   public List<string>  orderAreaDescription{get;set;}
        @AuraEnabled   public List<string> userName{get;set;}
        @AuraEnabled   public List<string> deliveryArea{get;set;}
        @AuraEnabled   public List<string> department{get;set;}
        @AuraEnabled   public List<string> venueLocations{get;set;}
        @AuraEnabled   public List<string> onsiteContactPerson{get;set;}
        @AuraEnabled   public List<string> onsiteContactPersonOthers{get;set;}
        @AuraEnabled   public List<string> vendors{get;set;}
        @AuraEnabled   public List<string> ownerName{get;set;} //SAL-1214 - Fitler by OwnerName - 03/15/24 - Sajid
    }
    
    @AuraEnabled
    public Static String getProfileName(){
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        List<PermissionSetAssignment> currentUserPerSet =  [SELECT Id, PermissionSet.Name,AssigneeId
                                                            FROM PermissionSetAssignment
                                                            WHERE AssigneeId = :Userinfo.getUserId() 
                                                            AND PermissionSet.Name = 'GC_Director_Of_Account_Management_Connect'];
        
        if(currentUserPerSet != null && currentUserPerSet.size() == 1){
            if(PROFILE[0].Name == 'System Administrator'){
                return PROFILE[0].Name;
            }else{
                return 'GES Connect - AM, DAM, SM';
            }
        }
        else{
            return PROFILE[0].Name;
        }
    }
    
    //Method to get  the picklist values using which user can search the Orders
    @AuraEnabled
    public static WrapperClass getPicklistValues(string showId){
        WrapperClass wrapperObj= new WrapperClass();
        wrapperObj.deliveryLocations= new List<string>();
        wrapperObj.orderAreaDescription= new List<string>();
        wrapperObj.userName= new List<string>();
        wrapperObj.deliveryArea= new List<string>();
        wrapperObj.department= new List<string>();
        wrapperObj.venueLocations= new List<string>();
        wrapperObj.onsiteContactPerson= new List<string>();
        wrapperObj.onsiteContactPersonOthers= new List<string>();
        wrapperObj.vendors= new List<string>();
        wrapperObj.ownerName= new List<string>();//SAL-1214 - Fitler by OwnerName - 03/15/24 - Sajid
        
        try{
            List<GC_Order__c> orders = GC_OrderDao.getInstance().getByConnect2ShowId(showId,orderByQuery);
            List<GC_GES_Order_Task__c> gesTasks = GC_GESOrderTaskDao.getInstance().getByConnect2ShowId(showId);
            List<GC_Vendor_Order_Task__c> vendorTasks = GC_VendorOrderTaskDao.getInstance().getByConnect2ShowId(showId);
            if(orders.size()>0){
                for (GC_Order__c o : orders) {
                    if (String.isNotBlank(o.Booth_Area__c) && !deliveryLocationsSet.contains(o.Booth_Area__c)) {
                        deliveryLocationsSet.add(o.Booth_Area__c);
                        string bootharea= o.Booth_Area__c;
                        wrapperObj.deliveryLocations.add(bootharea);
                    }
                    if (String.isNotBlank(o.Order_Area_Description__c) && !orderAreaDescriptionsSet.contains(o.Order_Area_Description__c)) {
                        orderAreaDescriptionsSet.add(o.Order_Area_Description__c);
                        string orderareadesc= o.Order_Area_Description__c;
                        wrapperObj.orderAreaDescription.add(orderareadesc);
                    }
                    if (String.isNotBlank(o.User_Name__c) && !usernamesSet.contains(o.User_Name__c)) {
                        usernamesSet.add(o.User_Name__c);
                        string user= o.User_Name__c;
                        wrapperObj.userName.add(user);
                    }
                    //SAL-1214 - Fitler by OwnerName - 03/15/24 - Sajid
                    if (String.isNotBlank(o.Owner.Name) && !ownerNameSet.contains(o.Owner.Name)) {
                        ownerNameSet.add(o.Owner.Name);
                        string ownerUser= o.Owner.Name;
                        wrapperObj.ownerName.add(ownerUser);
                    }
                    //end-SAL-1214
                }
            }
            if(gesTasks.size()>0){
                for (GC_GES_Order_Task__c o : gesTasks) {
                    
                    if (String.isNotBlank(o.Delivery_Location__c) && !deliveryAreasSet.contains(o.Delivery_Location__c)) {
                        deliveryAreasSet.add(o.Delivery_Location__c);
                        string deliveryArea=o.Delivery_Location__c;
                        wrapperObj.deliveryArea.add(deliveryArea);
                    }
                    if (String.isNotBlank(o.Department__r.Name) && !departmentsSet.contains(o.Department__r.Name)) {
                        departmentsSet.add(o.Department__r.Name);
                        string depart=o.Department__r.Name;
                        wrapperObj.department.add(depart);
                    }
                    
                    if (String.isNotBlank(o.SA_Venue_Location__r.Name) && !venueLocationsSet.contains(o.SA_Venue_Location__r.Name)) {
                        venueLocationsSet.add(o.SA_Venue_Location__r.Name);
                        string venue=o.SA_Venue_Location__r.Name;
                        wrapperObj.venueLocations.add(venue);
                    }
                    if ((o.Onsite_Contact__c != null) && String.isNotBlank(o.Onsite_Contact__r.Name) && !OnsiteContactPersonsSet.contains(o.Onsite_Contact__r.Name)) {
                        OnsiteContactPersonsSet.add(o.Onsite_Contact__r.Name);
                        string onsitePerson=o.Onsite_Contact__r.Name;
                        wrapperObj.onsiteContactPerson.add(onsitePerson);
                    }
                    if (String.isNotBlank(o.Onsite_Contact_Person_Other__c) && !OnsiteContactPersonOthersSet.contains(o.Onsite_Contact_Person_Other__c)) {
                        OnsiteContactPersonOthersSet.add(o.Onsite_Contact_Person_Other__c);
                        string onsitePersonOther=o.Onsite_Contact_Person_Other__c;
                        wrapperObj.onsiteContactPersonOthers.add(onsitePersonOther);
                    }
                    if (String.isNotBlank(o.User_Name__c) && !usernamesSet.contains(o.User_Name__c)) {
                        usernamesSet.add(o.User_Name__c);
                        string user= o.User_Name__c;
                        wrapperObj.userName.add(user);
                    }
                }
            }
            if(vendorTasks.size()>0){
                for (GC_Vendor_Order_Task__c v : vendorTasks) {
                    if (String.isNotBlank(v.Vendor__r.Name) && !vendorsSet.contains(v.Vendor__r.Name)) {
                        vendorsSet.add(v.Vendor__r.Name);
                        string vend1=v.Vendor__r.Name;
                        wrapperObj.vendors.add(vend1);
                    }
                    
                    if (String.isNotBlank(v.Vendor2__r.Name) && !vendorsSet.contains(v.Vendor2__r.Name)) {
                        vendorsSet.add(v.Vendor2__r.Name);
                        string vend2=v.Vendor2__r.Name;
                        wrapperObj.vendors.add(vend2);
                    }
                    
                    if (String.isNotBlank(v.Vendor3__r.Name) && !vendorsSet.contains(v.Vendor3__r.Name)) {
                        vendorsSet.add(v.Vendor3__r.Name);
                        string vend3=v.Vendor3__r.Name;
                        wrapperObj.vendors.add(vend3);
                    }
                    
                    if (String.isNotBlank(v.Vendor4__r.Name) && !vendorsSet.contains(v.Vendor4__r.Name)) {
                        vendorsSet.add(v.Vendor4__r.Name);
                        string vend4=v.Vendor4__r.Name;
                        wrapperObj.vendors.add(vend4);
                    }
                    
                    if (String.isNotBlank(v.Vendor5__r.Name) && !vendorsSet.contains(v.Vendor5__r.Name)) {
                        vendorsSet.add(v.Vendor5__r.Name);
                        string vend5=v.Vendor5__r.Name;
                        wrapperObj.vendors.add(vend5);
                    }
                    
                }
            }
            return wrapperObj; 
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    //Method to display all the Orders of particular show in table
    @AuraEnabled
    public static List<GC_Order__c> fetchTableData(string showId){
        List<GC_Order__c> orders=new List<GC_Order__c>();
        try{
            orders=GC_OrderDao.getInstance().getByConnect2ShowId(showId, orderByQuery);
            return orders;
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    public static String getDateString(Date dt) 
    {
        if (dt == null) {
            return '';
        }
        return DateTime.newInstance(dt.year(), dt.month(), dt.day()).format('yyyy-MM-dd');
    }
    
    public static string escapeSpecialCharacters(string stringvalueToRemoveSpecialCharacters){
        List<string> specialCharacters= new List<String>();
        specialCharacters.add('\\');
        specialCharacters.add('\'');
        specialCharacters.add('<');
        specialCharacters.add('>');
        specialCharacters.add('?');
        specialCharacters.add('^');
        specialCharacters.add('$');
        specialCharacters.add('{');
        specialCharacters.add('}');
        specialCharacters.add('%');
        specialCharacters.add('_');
        specialCharacters.add('*');//= {,'^','$','{','}','[',']','(',')','.','*','+','?','|','<','>','-','&','%'};
        for(integer i=0;i<specialCharacters.size();i++){
            if(stringvalueToRemoveSpecialCharacters.contains(specialCharacters[i])){
                stringvalueToRemoveSpecialCharacters=stringvalueToRemoveSpecialCharacters.replace(specialCharacters[i],'\\'+specialCharacters[i]);
            }
        }
        return stringvalueToRemoveSpecialCharacters;
    }
    
    //SAL-1214 - Added filterByOwner parameter in the method - 03/18/24 - Sajid
    //Method to display the table data based on the user Entered criteria to search
    @AuraEnabled
    public static List<GC_Order__c> getTableValue(string showId,string deliveryLoc,string areaDesc,List<string> user,string keyword,
                                                  Date deliveryDate,Date completionDate,Date removalDate,Date createdFrom,Date createdTo,
                                                  Date modifiedFrom,Date modifiedTo,string vendors,string department,string delivery,
                                                  string venue,List<string> onsitePerson,List<string> onsitePersonOther,List<string> selectedStatusValues, Boolean filterByOwner){//,string completionDate,string removalDate){
                                                      system.debug('showId------------------------------'+showId);
                                                      system.debug('deliveryLoc----------------------------'+deliveryLoc);
                                                      system.debug('areaDesc-----------------------------------'+areaDesc);
                                                      system.debug('user-------------------------------------'+user);
                                                      system.debug('keyword--------------------------------------------------'+keyword);
                                                      system.debug('deliveryDate------------------------'+deliveryDate);
                                                      system.debug('completionDate----------------'+completionDate);
                                                      system.debug('removalDate-------------------------'+removalDate);
                                                      system.debug('createdFrom--------'+createdFrom);
                                                      system.debug('createdTo----------------------------------------'+createdTo);
                                                      system.debug('modifiedFrom-----------------------------'+modifiedFrom);
                                                      system.debug('modifiedTo--------------------------------------'+modifiedTo);
                                                      system.debug('vendors------------'+vendors);
                                                      system.debug('department----------------------'+department);
                                                      system.debug('delivery------------------'+delivery);
                                                      system.debug('venue------------------'+venue);
                                                      system.debug('onsitePerson----------------'+onsitePerson);
                                                      system.debug('onsitePersonOther------------------------'+onsitePersonOther);
                                                      system.debug('selectedStatusValues------------------------'+selectedStatusValues.size());
                                                      if(onsitePerson.isempty()){
                                                          system.debug('onsite contact person is empty');
                                                      }
                                                      if(user.contains(userinfo.getUserId())){
                                                          system.debug('user contains loggedInuser');
                                                      }
                                                      if(String.isNotBlank(deliveryLoc)){
                                                          deliveryLoc=escapeSpecialCharacters(deliveryLoc);
                                                      }
                                                      if(String.isNotBlank(areaDesc)){
                                                          areaDesc=escapeSpecialCharacters(areaDesc);
                                                          system.debug('areaDesc Val'+areaDesc);
                                                      }
                                                      if(String.isNotBlank(keyword)){
                                                          keyword=escapeSpecialCharacters(keyword);
                                                      }
                                                      if(String.isNotBlank(vendors)){
                                                          vendors=escapeSpecialCharacters(vendors);
                                                      }
                                                      if(String.isNotBlank(department)){
                                                          department=escapeSpecialCharacters(department);
                                                      }
                                                      if(String.isNotBlank(delivery)){
                                                          delivery=escapeSpecialCharacters(delivery);
                                                      }
                                                      if(String.isNotBlank(venue)){
                                                          venue=escapeSpecialCharacters(venue);
                                                      }
                                                      
                                                      List<GC_Order__c> searchedResultsToBeReturned= new List<GC_Order__c>();
                                                      List<string> userNamesWithInvertedCommas=new List<string>();
                                                      List<string> onsiteContactPersonWithInvertedCommas= new List<String>();
                                                      List<String> onsiteContactPersonOthersWithInvertedCommas = new List<String>();
                                                      List<String> selectedStatusWithInvertedCommas = new List<String>();
                                                      
                                                      if(user!=null){
                                                          for(Integer i=0;i<user.size();i++){
                                                              user[i]=escapeSpecialCharacters(user[i]);
                                                              string u='\''+user[i]+'\'';
                                                              userNamesWithInvertedCommas.add(u);
                                                          }
                                                      }
                                                      if(onsitePerson!=null){
                                                          for(Integer i=0;i<onsitePerson.size();i++){
                                                              onsitePerson[i]=escapeSpecialCharacters(onsitePerson[i]);
                                                              string onsite='\''+onsitePerson[i]+'\'';
                                                              onsiteContactPersonWithInvertedCommas.add(onsite);
                                                          }
                                                      }
                                                      if(onsitePersonOther!=null){
                                                          for(Integer i=0;i<onsitePersonOther.size();i++){
                                                              onsitePersonOther[i]=escapeSpecialCharacters(onsitePersonOther[i]);
                                                              string onsiteOther='\''+onsitePersonOther[i]+'\'';
                                                              onsiteContactPersonOthersWithInvertedCommas.add(onsiteOther);
                                                          }
                                                      }
                                                      List<GC_Order__c> ordersOfRelatedShow=new List<GC_Order__c>();
                                                     List<String> ordersId= new List<String>();
                                                      ordersOfRelatedShow=[select Id,Name from GC_Order__c where Connect2_Show__c=:showId];
                                                      System.debug('ordersOfRelatedShow'+ordersOfRelatedShow);
                                                      System.debug('ordersOfRelatedShow length'+ordersOfRelatedShow.size());
                                                      for(GC_Order__c o:ordersOfRelatedShow){
                                                          //String orderId = '\''+o.Id+'\'';
                                                          ordersId.add(o.Id) ;
                                                     }
                                                      System.debug('ordersIdlist'+ordersId);
                                                      try{
                                                          //SAL-1214 - added owner.name field in orderQuery - 03/15/24 - Sajid
                                                          //string orderQuery='select Id,Name,Booth_Area__c,Order_Area_Description__c,Delivery_Date_Time__c,Completion_Date_Time__c,Removal_Date_Time__c,Order_Number__c,Status__c,User_Name__c,Createddate,LastModifiedDate from GC_Order__c where Id!=null';
                                                          string orderQuery='select Id,Name,Booth_Area__c,Order_Area_Description__c,Delivery_Date_Time__c,Completion_Date_Time__c,Removal_Date_Time__c,Order_Number__c,Status__c,User_Name__c,Createddate,LastModifiedDate, Owner.Name from GC_Order__c where Id!=null';
                                                          string votQuery='select Id, Name, Order__c FROM GC_Vendor_Order_Task__c WHERE Id!=null';
                                                          string gotQuery='SELECT Id, Name, Order__c,Connect2_Show_Number__c,User_Name__c,Department__r.Name, Delivery_Location__c, SA_Venue_Location__c, Onsite_Contact__r.Name, Onsite_Contact_Person_Other__c FROM GC_GES_Order_Task__c WHERE Id!=null';
                                                          string orderWhereQuery='';
                                                          string votWhereQuery='';
                                                          string gotWhereQuery='';
                                                          string showName = null;
                                      					List<GC_Connect2_Show__c> showNames = [select Name from GC_Connect2_Show__c where ID =:showId]; 
                                                          for(GC_Connect2_Show__c show:showNames){
                                                              showName = show.Name;
                                                          }                                                       
                                                          if((deliveryLoc == ''||deliveryLoc == null) && (areaDesc == '' ||areaDesc == null) && (user.isEmpty() || user.contains(userinfo.getUserId())) && 
                                                             (vendors == ''||vendors == null) && (department =='' || department == null) && (venue == '' || venue == null) && 
                                                             keyword == null && completionDate == null && removalDate == null &&  createdFrom == null && 
                                                             createdTo == null && modifiedFrom == null && modifiedTo == null && onsitePerson.isempty() 
                                                             && onsitePersonOther.isempty() && selectedStatusValues.isempty() && delivery == null || delivery == '' & user.isEmpty()){ // deliveryDate == null &&
                                                              orderWhereQuery+=' AND Connect2_Show__c =\''+showId+'\'';
                                                              orderQuery+=orderWhereQuery;
                                                              orderQuery+='ORDER BY '+orderByQuery;
                                                                 System.debug('finalorderQueryIF###'+orderQuery);
                                                              List<GC_Order__c> orders=Database.Query(orderQuery);
                                                              for(GC_Order__c o:orders){
                                                                  searchedResultsToBeReturned.add(o);
                                                              }
                                                          }
                                                          else{
                                                              orderWhereQuery+=' AND Connect2_Show__c =\''+showId+'\'';
                                                              orderWhereQuery+= String.isNotBlank(deliveryLoc) ? ' AND Booth_Area__c like \'%' + deliveryLoc+ '%\'' : '';
                                                              orderWhereQuery += String.isNotBlank(areaDesc) ? ' AND Order_Area_Description__c like \'%' + areaDesc + '\'' : '';
                                                              System.debug('orderWhereQuery-areaDesc'+orderWhereQuery);
                                                              
                                                              //SAL-1214 - Fitler by OwnerName - 03/15/24 - Sajid
                                                              //orderWhereQuery += (user!=null && user.size() > 0)  ? ' AND User_Name__c in'+userNamesWithInvertedCommas+'' : '';
                                                              if(filterByOwner){
                                                                  orderWhereQuery += (user!=null && user.size() > 0)  ? ' AND Owner.Name in'+userNamesWithInvertedCommas+'' : '';
                                                              }else{
                                                                  orderWhereQuery += (user!=null && user.size() > 0)  ? ' AND User_Name__c in'+userNamesWithInvertedCommas+'' : '';
                                                              } 
                                                              //End SAL-1214
                                                              
                                                              if(String.isNotBlank(keyword)){
                                                                  orderWhereQuery += ' AND ((Booth_Area__c like \'%' + keyword + '%\')';
                                                                  orderWhereQuery += ' OR  (Name like \'%' + keyword + '%\')';
                                                                  orderWhereQuery += ' OR  (Status__c like \'%' + keyword + '%\')';
                                                                  orderWhereQuery += ' OR  (Type_Of_User__c like \'%' + keyword + '%\')';
                                                                  orderWhereQuery += ' OR  (Order_Area_Description__c  like \'%' + keyword + '%\'))'; 
                                                              }
                                                              if (deliveryDate != null) 
                                                              {
                                                                  String dateString = getDateString(deliveryDate)+'T00:00:00Z';
                                                                  String dateString1 = getDateString(deliveryDate)+'T23:59:59Z';
                                                                  
                                                                  orderWhereQuery += ' AND (Delivery_Date_Time__c >= '+ dateString;
                                                                  orderWhereQuery += ' AND Delivery_Date_Time__c <= '+ dateString1+')';
                                                              }
                                                              if (completionDate != null) 
                                                              {
                                                                  String dateString = getDateString(completionDate)+'T00:00:00Z';
                                                                  String dateString1 = getDateString(completionDate)+'T23:59:59Z';
                                                                  
                                                                  orderWhereQuery += ' AND (Completion_Date_Time__c >= '+ dateString;
                                                                  orderWhereQuery += ' AND Completion_Date_Time__c <= '+ dateString1+')';
                                                              }
                                                              if (removalDate != null) 
                                                              {
                                                                  String dateString = getDateString(removalDate)+'T00:00:00Z';
                                                                  String dateString1 = getDateString(removalDate)+'T00:00:00Z';
                                                                  
                                                                  orderWhereQuery += ' AND (Removal_Date_Time__c >= '+ dateString;
                                                                  orderWhereQuery += ' AND Removal_Date_Time__c <= '+ dateString1+')';
                                                              }
                                                              if(createdFrom!=null && createdTo==null)
                                                              {
                                                                  String dateString = getDateString(createdFrom)+'T00:00:00Z';
                                                                  String dateString1 = getDateString(createdFrom)+'T00:00:00Z';
                                                                  orderWhereQuery += ' AND (CreatedDate >= '+ dateString +')';
                                                              }
                                                              
                                                              if(createdFrom==null && createdTo!=null)
                                                              {
                                                                  String dateString = getDateString(createdTo)+'T00:00:00Z';
                                                                  String dateString1 = getDateString(createdTo)+'T00:00:00Z';
                                                                  orderWhereQuery += ' AND (CreatedDate <= '+ dateString + ')';
                                                              }
                                                              
                                                              if(createdFrom!=null && createdTo!=null)
                                                              {
                                                                  String dateString = getDateString(createdFrom)+'T00:00:00Z';
                                                                  String dateString1 = getDateString(createdTo)+'T00:00:00Z';
                                                                  orderWhereQuery += ' AND (CreatedDate >= '+ dateString;
                                                                  orderWhereQuery += ' AND CreatedDate <= '+ dateString1+')';
                                                              }
                                                              
                                                              if(modifiedFrom!=null && modifiedTo==null)
                                                              {
                                                                  String dateString = getDateString(modifiedFrom)+'T00:00:00Z';
                                                                  String dateString1 = getDateString(modifiedFrom)+'T00:00:00Z';
                                                                  orderWhereQuery += ' AND (LastModifiedDate>= '+ dateString +')';
                                                              }
                                                              
                                                              if(modifiedFrom==null && modifiedTo!=null)
                                                              {
                                                                  String dateString = getDateString(modifiedTo)+'T00:00:00Z';
                                                                  String dateString1 = getDateString(modifiedTo)+'T00:00:00Z';
                                                                  orderWhereQuery += ' AND (LastModifiedDate<= '+ dateString + ')';
                                                              }
                                                              
                                                              if(modifiedFrom!=null && modifiedTo!=null)
                                                              {
                                                                  String dateString = getDateString(modifiedFrom)+'T00:00:00Z';
                                                                  String dateString1 = getDateString(modifiedTo)+'T00:00:00Z';
                                                                  orderWhereQuery += ' AND (LastModifiedDate>= '+ dateString;
                                                                  orderWhereQuery += ' AND LastModifiedDate<= '+ dateString1+')';
                                                              }
                                                              if(selectedStatusValues!=null && selectedStatusValues.size()>0){
                                                              for(Integer i=0;i<selectedStatusValues.size();i++){
                                                              string statusValues='\''+selectedStatusValues[i]+'\'';
                                                              selectedStatusWithInvertedCommas.add(statusValues);
                                                          }
														  orderWhereQuery += ' AND Status__c in'+selectedStatusWithInvertedCommas+'';
                                                      }
                                                              orderQuery+=orderWhereQuery;
                                                              if(String.isNotBlank(deliveryLoc)||String.isNotBlank(areaDesc)||
															  (user!=null && user.size()>0)||String.isNotBlank(keyword)||deliveryDate!=null||
															  completionDate!=null||removalDate!=null||createdFrom!=null||createdTo!=null||
															  modifiedFrom!=null||modifiedTo!=null ||(selectedStatusValues!=null && selectedStatusValues.size()>0)){
                                                                  
                                                                  orderQuery+='ORDER BY '+orderByQuery;
                                                                  System.debug('finalorderQuery###'+orderQuery);
                                                                  List<GC_Order__c> orders=Database.Query(orderQuery);
                                                                  System.debug('orders.size'+orders.size());
                                                                  for(GC_Order__c o:orders){
                                                                      searchedResultsToBeReturned.add(o);
             	                                                     }
                                                              }else{
                                                                  votWhereQuery += String.isNotBlank(vendors) ? ' AND ((Vendor__r.Name like \'%' + vendors + '%\')' : '';
                                                              votWhereQuery += String.isNotBlank(vendors) ? ' OR (Vendor2__r.Name like \'%' + vendors + '%\')' : '';
                                                              votWhereQuery += String.isNotBlank(vendors) ? ' OR (Vendor3__r.Name like \'%' + vendors + '%\')' : '';
                                                              votWhereQuery += String.isNotBlank(vendors) ? ' OR (Vendor4__r.Name like \'%' + vendors + '%\')' : '';
                                                              votWhereQuery += String.isNotBlank(vendors) ? ' OR (Vendor5__r.Name like \'%' + vendors + '%\'))' : '';
                                                              votQuery+=votWhereQuery;
                                                              if(ordersId.size() > 0 && String.isNotBlank(vendors) ){
                                                                  List<GC_Vendor_Order_Task__c> vend=Database.query(votQuery);
                                                                  List<Id> orderIdsFromVOT= new List<Id>();
                                                                  for(GC_Vendor_Order_Task__c v:vend){
                                                                      if(ordersId.contains(v.Order__c)){ //showName.equals(v.Connect2_Show_Number__c
                                                                          orderIdsFromVOT.add(v.Order__c);
                                                                      }
                                                                  }
                                                                  List<GC_Order__c> ordersRecordsForVot=[select Id,Name,Booth_Area__c,Order_Area_Description__c,Delivery_Date_Time__c,Completion_Date_Time__c,Removal_Date_Time__c,Order_Number__c,Status__c,User_Name__c,Createddate,LastModifiedDate from GC_Order__c where Id=:orderIdsFromVOT];
                                                                  for(GC_Order__c o:ordersRecordsForVot){
                                                                      searchedResultsToBeReturned.add(o);
                                                                  }
                                                              }
                                                              //gotWhereQuery +=ordersId.size() > 0  ? ' AND Order__c in : ordersId ' : '';
                                                              gotWhereQuery += String.isNotBlank(department) ? ' AND Department__r.Name like \'%' + department + '%\'' : '';
                                                              gotWhereQuery += String.isNotBlank(delivery) ? ' AND Delivery_Location__c like \'%' + delivery + '%\'' : '';
                                                              gotWhereQuery += String.isNotBlank(venue) ? ' AND SA_Venue_Location__r.Name like \'%' + venue + '%\'' : '';
                                                              gotWhereQuery += (onsiteContactPersonWithInvertedCommas!=null && onsiteContactPersonWithInvertedCommas.size() > 0 ) ? ' AND Onsite_Contact__r.Name in'+onsiteContactPersonWithInvertedCommas+'' : '';
                                                              gotWhereQuery += (onsiteContactPersonOthersWithInvertedCommas!=null && onsiteContactPersonOthersWithInvertedCommas.size() > 0)  ? ' AND Onsite_Contact_Person_Other__c in'+onsiteContactPersonOthersWithInvertedCommas+'' : '';
                                                              gotWhereQuery += (user!=null && user.size() > 0)  ? ' AND User_Name__c in'+userNamesWithInvertedCommas+'' : '';
                                                              gotQuery+=gotWhereQuery;
                                                              System.debug('gotQueryFinal#####'+gotQuery);
                                                              if(ordersId.size() > 0 && (String.isNotBlank(department)||String.isNotBlank(delivery)||
                                                               (onsiteContactPersonWithInvertedCommas!=null && onsiteContactPersonWithInvertedCommas.size() > 0)||
                                                               (onsiteContactPersonOthersWithInvertedCommas!=null && 
                                                                  onsiteContactPersonOthersWithInvertedCommas.size() > 0)||(user!=null && user.size() > 0) 
                                                                                         ||String.isNotBlank(venue))){
                                                                  List<GC_GES_Order_Task__c> got=Database.query(gotQuery);
                                                                  List<Id> orderIdsFromGOT= new List<Id>();   
                                                                  for(GC_GES_Order_Task__c g:got){
                                                                      if(ordersId.contains(g.Order__c)){ 
                                                                          orderIdsFromGOT.add(g.Order__c);
                                                                      }
                                                                  }
                                                                System.debug('orderIdsFromGOT----'+orderIdsFromGOT);
                                                                  List<GC_Order__c> ordersRecordsForGot=[select Id,Name,Booth_Area__c,
                                                       Order_Area_Description__c,Delivery_Date_Time__c,Completion_Date_Time__c,Removal_Date_Time__c,
                                                          Order_Number__c,Status__c,User_Name__c,Createddate,LastModifiedDate from GC_Order__c where Id=:orderIdsFromGOT];
                                                                                             System.debug('ordersRecordsForGot-----'+ordersRecordsForGot);
                                                                  for(GC_Order__c o:ordersRecordsForGot){
                                                                      searchedResultsToBeReturned.add(o);
                                                                  }
                                                              }
                                                          }
                                                          for(Integer i=0;i<searchedResultsToBeReturned.size();i++){
                                                              for(Integer j=i+1;j<searchedResultsToBeReturned.size();j++){
                                                                  if(searchedResultsToBeReturned[i]==searchedResultsToBeReturned[j])
                                                                  {
                                                                      searchedResultsToBeReturned.remove(j);
                                                                  }
                                                              }
                                                          }
                                                              }
                                                              
                                                          return searchedResultsToBeReturned;
                                                      }
                                                      catch(Exception e){
                                                          system.debug('error at==='+e.getStackTraceString()+'==='+e.getMessage());
                                                          throw new AuraHandledException(e.getMessage());
                                                      }
                                                      
                                                  }
    
    //Method to update the filter values based on the current User Search
    @AuraEnabled
    public static void saveFilteredValues(string deliveryLoc,string areaDesc,List<string> user,List<string> onsitePerson,List<string> onsiteOther,string keyword,Date deliveryDate,Date completionDate,Date removalDate,Date createdFrom,Date createdTo,Date modifiedFrom,Date modifiedTo,string vendors,string department,string delivery,string venue){
        string userFilter='';
        string onsiteFilter='';
        string onsiteOtherFilter='';
        if(user.size()>=1){
            for(Integer i=0;i<user.size();i++){
                userFilter+=user[i]+',';
            }
        }
        if(onsitePerson.size()>=1){
            for(Integer i=0;i<onsitePerson.size();i++){
                onsiteFilter+=onsitePerson[i]+',';
            }
        }
        if(onsiteOther.size()>=1){
            for(Integer i=0;i<onsiteOther.size();i++){
                onsiteOtherFilter+=onsiteOther[i]+',';
            }
        }
        Id loggedInUserId=UserInfo.getUserID();
        try{
            GC_Report_Filters__c filters= new GC_Report_Filters__c();
            try{
                filters=[select Id from GC_Report_Filters__c where User__c=:loggedInUserId];
            }
            catch(exception e){
                filters.User__c=loggedInUserId;
                insert filters;
            }
            filters.OP_Delivery_Location__c=deliveryLoc;
            filters.OP_Area_Description__c=areaDesc;
            filters.User_Name__c=userFilter;
            filters.OP_Onsite_Contact_Person__c=onsiteFilter;
            filters.OP_Onsite_Contact_Person_Other__c=onsiteOtherFilter;
            filters.OP_Keyword_Search__c=keyword;
            filters.OP_Delivery_Date_Time__c=deliveryDate;
            filters.OP_Completion_Date_Time__c=completionDate;
            filters.OP_Removal_Date_Time__c=removalDate;
            filters.OP_Creation_Date_From__c=createdFrom;
            filters.OP_Creation_Date_To__c=createdTo;
            filters.OP_Modified_Date_From__c=modifiedFrom;
            filters.OP_Modified_Date_To__c=modifiedTo;
            filters.OP_Vendor__c=vendors;
            filters.OP_Department__c=department;
            filters.OP_Delivery_Area__c=delivery;
            filters.OP_Venue_Location__c=venue;
            filters.User__c=loggedInUserId;
            upsert filters;
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    //Method to get the filter values based on previous search
    @AuraEnabled
    public static GC_Report_Filters__c getFilterValues(){
        GC_Report_Filters__c filters=new GC_Report_Filters__c();
        try{
            filters=[select OP_Delivery_Location__c,User_Name__c,OP_Onsite_Contact_Person__c,OP_Onsite_Contact_Person_Other__c,OP_Area_Description__c,OP_Keyword_Search__c,OP_Delivery_Date_Time__c,OP_Completion_Date_Time__c,OP_Removal_Date_Time__c,OP_Creation_Date_From__c,OP_Creation_Date_To__c,OP_Modified_Date_From__c,OP_Modified_Date_To__c,OP_Vendor__c,OP_Department__c,OP_Delivery_Area__c,OP_Venue_Location__c from GC_Report_Filters__c where User__c=:UserInfo.getUserID()];
            
        }
        catch(Exception e){
            filters=new GC_Report_Filters__c();
            system.debug('error is'+e.getMessage());
            //throw new AuraHandledException(e.getMessage());
        }
        return filters;
        
    }
    
    @AuraEnabled
    public static boolean isCommunity(){
        return LC_AppUtils.isCommunity();
    }
    
    //Method to get the Orders Created By Particular user for particular show
    @AuraEnabled 
    public static  List<GC_Order__c> fetchUser(string ShowId){
        List<GC_Order__c> orders = [SELECT Id,Name FROM GC_Order__c WHERE Connect2_Show__c =:ShowId AND OwnerId=:userInfo.getUserId()];
        return orders;
    }
    public class orderCloneWrapper{
        @AuraEnabled public List<String> newDeliveryLocations;
        @AuraEnabled public String errorMsg;
        @AuraEnabled public Map<String, DateTime> newDLDeliveryDate;
        @AuraEnabled public Map<String, DateTime> newDLCompletionDate;
        @AuraEnabled public Map<String, DateTime> newDLRemovalDate;
        @AuraEnabled public Map<String, String> newDLId;
    }
    
    //Method to fetch session id
    @AuraEnabled
    public static String getSessionId(){
        try{
            String sId = LC_CoreUtils.getSessionID().Core_Application_Session_ID__c;
            return sId;
        }catch(exception e){
            return '';
        }}
    
    //Method to get the deliveryLocations to Clone the Order
    @AuraEnabled
    public static orderCloneWrapper getNewDeliveryLocations(string showToBeCloned,string cloneFromShow, string ssid){
        orderCloneWrapper objToReturn = new orderCloneWrapper();
        objToReturn.newDeliveryLocations=new List<String>();
        objToReturn.newDLDeliveryDate = new Map<String,DateTime>();
        objToReturn.newDLCompletionDate = new Map<String,DateTime>();
        objToReturn.newDLRemovalDate = new Map<String,DateTime>();
        objToReturn.newDLId = new Map<String,String>();
        
        string showJobNumber = '';
        List<GC_Connect2_Show__c> showToClone = [select Id,Job_Number__c from GC_Connect2_Show__c where Id =: showToBeCloned];
        //system.debug('showToClone------------------------------'+showToClone);
        if(showToClone.size() > 0){
            if(!String.isBlank(showToClone[0].Job_Number__c)){
                showJobNumber = showToClone[0].Job_Number__c;
                try{
                    CORE_V2.BasicHttpBinding_IShowService projectQuery = new CORE_V2.BasicHttpBinding_IShowService();
                    CORE_V2.ShowProject showProject;
                    if (Test.isRunningTest()) {
                         showProject = GC_TestUtils.getTestShowProject();
                    }
                    else{
                        showProject = projectQuery.GetShowProjectByProjectNumber(ssid, showJobNumber);
                    }
                    if(showProject.BoothAreas != null){
                        if(showProject.BoothAreas.BoothArea != null){
                            for (CORE_V2.BoothArea boothArea : showProject.BoothAreas.BoothArea) {
                                objToReturn.newDLDeliveryDate.put(boothArea.Area, boothArea.DeliveryDateTime);
                                objToReturn.newDLCompletionDate.put(boothArea.Area,boothArea.CompletionDateTime);
                                objToReturn.newDLRemovalDate.put(boothArea.Area,boothArea.RemovalDateTime);
                                objToReturn.newDLId.put(boothArea.Area,String.valueof(boothArea.BoothAreaId));
                                objToReturn.newDeliveryLocations.add(boothArea.Area);
                            }
                        }
                        else{
                            objToReturn.errorMsg='No Delivery Locations in the selected Show';
                        }
                    }
                }
                catch(Exception e){
                    if(e.getMessage().contains('Show not found in CORE')){
                        throw new AuraHandledException('Selected Show not found in CORE');
                    }
                    else{
                        system.debug('error in catch block'+e.getMessage());
                        throw new AuraHandledException(e.getMessage());
                    }
                }
            }
            else{
                objToReturn.errorMsg='No Job number in the selected Show';
            }
        }
        return objToReturn;  
    }
    
    //Method to clone order from one show to another
    @AuraEnabled
    public static String cloneOrdersToShow(List<String> selectedNewDeliveryLoc,List<String> selectedAvailableDelivery,string showToBeCloned,string cloneFromShow,Map<String, DateTime> boothAreaDeliveryMap,Map<String, DateTime> boothAreaCompletionMap,Map<String, DateTime> boothAreaRemovalMap,Map<String, String> boothAreaIdMap){
        List<String> orderIds = new List<String>();
        List<GC_Order__C> newClonedOrds = new List<GC_Order__C>();
        Map<String,String> mapOrdernewDelLoc = new Map<String,String>();
        Map<Id,List<GC_GES_Order_Task__c>> orderGOT = new Map<Id,List<GC_GES_Order_Task__c>>();
        Map<Id,List<GC_Vendor_Order_Task__c>> orderVOT = new Map<Id,List<GC_Vendor_Order_Task__c>>();
        List<GC_GES_Order_Task__c> newClonedGESOrdTasks = new List<GC_GES_Order_Task__c>();
        List<GC_Vendor_Order_Task__c> newClonedVenTasks= new List<GC_Vendor_Order_Task__c>();
        System.debug('showToBeCloned----'+showToBeCloned);
        for(Integer i=0;i<selectedNewDeliveryLoc.size();i++){
            String orderIdOfNewDeliveryLoc=selectedNewDeliveryLoc[i].substringBefore('**');
            string BoothNameofNewDeliveryLoc=selectedNewDeliveryLoc[i].substringAfter('**');
            orderIds.add(orderIdOfNewDeliveryLoc);
            mapOrdernewDelLoc.put(orderIdOfNewDeliveryLoc,BoothNameofNewDeliveryLoc);
        }
        for(Integer i=0;i<selectedAvailableDelivery.size();i++){
            orderIds.add(selectedAvailableDelivery[i]);
        }
        Map<String,Id> sAttMap = new Map<String,Id>();
        List<GC_Show_Attribute__c> sAtt = [Select Id,Name from GC_Show_Attribute__c where Connect2_Show__c =:showToBeCloned];
        System.debug('sAtt-------'+sAtt);
        for(GC_Show_Attribute__c sAttri: sAtt){
            if(!sAttMap.containsKey(sAttri.Name)){
                sAttMap.put(sAttri.Name,sAttri.Id);
            }
        }
        //string result=cloneShowMembersAndAttributes(showToBeCloned,cloneFromShow);
        //if(result.equalsIgnoreCase('Success')){
        try{
            List<GC_Order__c> ordercln = [select name,Order_Number__c,Status__c,Delivery_Date_Time__c,Completion_Date_Time__c,Removal_Date_Time__c,Booth_Area__c,Booth_Area_ID__c,Order_Area_Description__c,
                                          (select Order__c,Status__c,Item_Number__c,Description__c,Price__c,Total__c,UOM__c,QuantityNum__c,Item_Category_ID__c,Item_Template__c,Show_Management_Field__c,SA_Venue_Location__c,Onsite_Contact__c,Onsite_Contact_Person_Other__c,Onsite_Contact_Person_Number_Other__c,Delivery_Location__c,Department__c,Budget_Code__c,Delivery_Date_Time__c,Completion_Date_Time__c,Removal_Date_Time__c,Sign_Title__c,GOT_Sign_Type__c,
                                           GOT_Single_Double_Sided__c,GOT_Sign_Type_Other__c,Material__c,GOT_Copy_Placement__c,Outdoors__c,Installation_Method__c,Save_Signs__c,GOT_Background__c,Sign_Copy__c,Layout__c from GES_Order_Tasks__r),
                                          (select Order__c,Status__c,Services__c,Vendor__c,Vendor2__c,Vendor3__c,Vendor4__c,Vendor5__c,GESOrderTask1__c,GESOrderTask2__c,GESOrderTask3__c,GESOrderTask4__c,GESOrderTask5__c,Service_Type__c,Service_Type2__c,Service_Type3__c,Service_Type4__c,Service_Type5__c,SelectAllOrderTasks__c,Vendor5__r.ServiceType__c,Vendor4__r.ServiceType__c,Vendor3__r.ServiceType__c,Vendor2__r.ServiceType__c,Vendor__r.ServiceType__c,SA_Venue_Location_Ven__c,Delivery_Location_Ven__c,Vendor_Instructions__c from Vendor_Order_Tasks__r) from GC_Order__c where Id in : orderIds ];
            for(GC_Order__C ordr : ordercln ){
                GC_Order__c ordernew = New GC_Order__C();
                ordernew.Order_Number__c = ordr.Order_Number__c;
                ordernew.Status__c= 'New';
                if(mapOrdernewDelLoc.containsKey(ordr.Id)){
                    ordernew.Booth_Area__c = mapOrdernewDelLoc.get(ordr.Id);
                }
                else{
                    ordernew.Booth_Area__c = ordr.Booth_Area__c;
                    //for orders ready for cloning
                    ordernew.Delivery_Date_Time__c=ordr.Delivery_Date_Time__c;
                    ordernew.Completion_Date_Time__c=ordr.Completion_Date_Time__c;
                    ordernew.Removal_Date_Time__c=ordr.Removal_Date_Time__c;
                    ordernew.Booth_Area_ID__c=ordr.Booth_Area_ID__c;
                }
                for(String a: boothAreaRemovalMap.Keyset()){
                    if(boothAreaRemovalMap.containsKey(ordernew.Booth_Area__c))
                        ordernew.Removal_Date_Time__c=boothAreaRemovalMap.get(ordernew.Booth_Area__c);
                }
                for(String a: boothAreaCompletionMap.Keyset()){
                    if(boothAreaCompletionMap.containsKey(ordernew.Booth_Area__c))
                        ordernew.Completion_Date_Time__c=boothAreaCompletionMap.get(ordernew.Booth_Area__c);
                }
                for(String a: boothAreaIdMap.Keyset()){
                    if(boothAreaIdMap.containsKey(ordernew.Booth_Area__c))
                        ordernew.Booth_Area_ID__c=boothAreaIdMap.get(ordernew.Booth_Area__c);
                }                    
                for(String a: boothAreaDeliveryMap.Keyset()){
                    if(boothAreaDeliveryMap.containsKey(ordernew.Booth_Area__c))
                        ordernew.Delivery_Date_Time__c=boothAreaDeliveryMap.get(ordernew.Booth_Area__c);
                }
                
                ordernew.Connect2_Show__c = showToBeCloned;
                ordernew.ParentCloneOrder__c = ordr.Id;
                ordernew.Order_Area_Description__c = ordr.Order_Area_Description__c;
                newClonedOrds.add(ordernew);
                if(ordr.GES_Order_Tasks__r.size() > 0){
                    for(GC_GES_Order_Task__c ot: ordr.GES_Order_Tasks__r){
                        if(!orderGOT.containsKey(ordr.Id)){
                            orderGOT.put(ordr.Id,new List<GC_GES_Order_Task__c>());
                        }
                        orderGOT.get(ordr.Id).add(ot);
                    }
                }
                if(ordr.Vendor_Order_Tasks__r.size() > 0){
                    for(GC_Vendor_Order_Task__c vt: ordr.Vendor_Order_Tasks__r){
                        if(!orderVOT.containsKey(ordr.Id)){
                            orderVOT.put(ordr.Id,new List<GC_Vendor_Order_Task__c>());
                        }
                        orderVOT.get(ordr.Id).add(vt);
                    }
                }
            }
            insert newClonedOrds;
            List<Id> newClonedOrdsIds = new List<Id>();
            for(GC_Order__c gc: newClonedOrds){
                newClonedOrdsIds.add(gc.Id);
            }
            List<GC_Order__c> newClonedOrders = [Select ParentCloneOrder__c from GC_Order__c where Id in : newClonedOrdsIds];
            for(GC_Order__c newGC: newClonedOrders){
                if(orderGOT.containsKey(newGC.ParentCloneOrder__c)){
                    Set<String> gotIds = new Set<String>();
                    for(GC_GES_Order_Task__c gcOrdTask : orderGOT.get(newGC.ParentCloneOrder__c)){
                        gotIds.add(gcOrdTask.Id);
                    }
                    List<GC_GES_Order_Task__c> gesOrderTasks = GC_GESOrderTaskDao.getInstance().getGESOrderTaskByIds(gotIds);
                    for(GC_GES_Order_Task__c gesTask : gesOrderTasks){
                        String oldVenue = gesTask.SA_Venue_Location__c;
                        String oldDept = gesTask.Department__c;
                        String materialName = gesTask.Material__c;
                        if(oldDept!=null){
                  			gesTask.Department__c = null;
                        }
                        if(materialName!=null){
                			gesTask.Material__c = null;
            			}
                        String venueOldName = null;
                        if(oldVenue!=null && oldVenue!=''){
                       List<GC_Show_Attribute__c> venueList = [select Name from GC_Show_Attribute__c where Id=:oldVenue];
                            if(venueList.size()>0){
                                for(GC_Show_Attribute__c venues : venueList){
                                    venueOldName = venues.Name;
                            if(venueOldName!=null){
                        List<GC_Show_Attribute__c> newVenues =[select Id from GC_Show_Attribute__c where Connect2_Show__c=:showToBeCloned And Name =:venueOldName];
                                    String newVenueId = null;
                                    if(newVenues.size()>0){
                                       for(GC_Show_Attribute__c newVenue: newVenues){
                                        newVenueId = newVenue.Id;
                                    }
                                    gesTask.SA_Venue_Location__c = newVenueId;
                                    }else{
                                     gesTask.SA_Venue_Location__c = newVenueId;   
                                    }
                                }
                                }
                            }
                        }
                        //Added by KN, 7/29/2019 SAL-1164
                        GC_GES_Order_Task__c got = GC_PageUtil.cloneTask(gesTask);
                        //End
                        got.Order__c = newGC.Id;
                        
                        //Added by KN to do HTML operations before Clone
                        got = LC_AppUtils.copyGOTFields(got);
                        System.debug('got--'+got);
                        newClonedGESOrdTasks.add(got);
                        System.debug('newClonedGESOrdTasks'+newClonedGESOrdTasks);
                    }
                }
                if(orderVOT.containsKey(newGC.ParentCloneOrder__c)){
                    for(GC_Vendor_Order_Task__c gcVenTask : orderVOT.get(newGC.ParentCloneOrder__c)){
                        System.debug('gcVenTask-----'+gcVenTask);
                        System.debug('Venue_vendortask-----'+gcVenTask.SA_Venue_Location_Ven__c);
                        String oldVenue = gcVenTask.SA_Venue_Location_Ven__c;
                        String venueOldName = null;
                        if(oldVenue!=null && oldVenue!=''){
                       List<GC_Show_Attribute__c> venueList = [select Name from GC_Show_Attribute__c where Id=:oldVenue];
                            if(venueList.size()>0){
                                for(GC_Show_Attribute__c venues : venueList){
                                    venueOldName = venues.Name;
                                    System.debug('venueOldName-----'+venueOldName);
                            if(venueOldName!=null){
                        List<GC_Show_Attribute__c> newVenues =[select Id from GC_Show_Attribute__c where Connect2_Show__c=:showToBeCloned And Name =:venueOldName];
                                    String newVenueId = null;
                                    if(newVenues.size()>0){
                                       for(GC_Show_Attribute__c newVenue: newVenues){
                                        newVenueId = newVenue.Id;
                                       System.debug('newVenueId-----'+newVenueId);
                                    }
                                    gcVenTask.SA_Venue_Location_Ven__c = newVenueId;
                                    System.debug('vendorTaskUpdated-----'+gcVenTask);
                                    }else{
                                     gcVenTask.SA_Venue_Location_Ven__c = newVenueId;   
                                    }
                                }
                                }
                            }
                        }
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
                        vot.SelectAllOrderTasks__c = gcVenTask.SelectAllOrderTasks__c;
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
                        
                        newClonedVenTasks.add(vot);
                        System.debug('newClonedVenTasks----'+newClonedVenTasks);
                    } 
                }
            }
            insert newClonedGESOrdTasks;
            insert newClonedVenTasks;
            return 'success';
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage()); 
        }
    }
    @AuraEnabled
    public static string getShowID(string ShowsId) {
        GC_Connect2_Show__c show =new GC_Connect2_Show__c();
        show=[SELECT Id, Name, Job_Number__c,Facility_Address__c  FROM GC_Connect2_Show__c WHERE Id =:ShowsId];
        return show.Job_Number__c;
    }   
}