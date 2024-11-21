global with sharing class LC_VOTRelatedListController {
    public class VOTWrapper{
        @AuraEnabled        public Id votId;
        @AuraEnabled        public String votName;
        @AuraEnabled        public string status;
        @AuraEnabled        public string vendors;
        @AuraEnabled         public string services;
        @AuraEnabled        public Date datesent;
        @AuraEnabled        public string LastModifiedByName;
        @AuraEnabled        public Datetime lastmodifiedDate;
        @AuraEnabled        public Boolean booleanStatus;
         @AuraEnabled        public Boolean disableDeleteBasedOnProfile;
        @AuraEnabled        public Boolean booleanStatusToReSend;
        @AuraEnabled       public  Map<Integer,string> wrapperServiceTypes;
        @AuraEnabled       public  Map<Integer,string> wrapperVendors;
        @AuraEnabled	   public string wrapperVendorInstructions;
        @AuraEnabled	   public Boolean wrapperSelectAllOrderTasks;
        @AuraEnabled	   public string wrapperDeliveryArea;
        @AuraEnabled	   public DateTime wrapperDeliveryDate;
        @AuraEnabled	   public DateTime wrapperCompletionDate;
        @AuraEnabled	   public DateTime wrapperRemovalDate;
        @AuraEnabled	   public string wrapperVenueLocation;
        @AuraEnabled	   public Id wrapperOrderId;
        string wrapperService1;
        string wrapperService2;
        string wrapperService3;
        string wrapperService4;
        string wrapperService5;
        string wrappervendor1;
        string wrappervendor2;
        string wrappervendor3;
        string wrappervendor4;
        string wrappervendor5;
        @AuraEnabled public Id insertedVot;
         @AuraEnabled public string insertStatus;
       
    }
    @AuraEnabled
    public static List<VOTWrapper> fetchVOTData(Id orderId){ //Method to display table data
        List<VOTWrapper> votObj=new List<VOTWrapper>();
        for ( GC_Vendor_Order_Task__c vot : [ SELECT Id, Name, Status__c, Vendors__c, Services__c, Date_Sent__c, LastModifiedBy.Name,LastModifiedDate FROM GC_Vendor_Order_Task__c where Order__c =:orderId ORDER BY LastModifiedDate desc]){
            VOTWrapper votWrap = new VOTWrapper();
            votWrap.votId=vot.Id;
            votWrap.votName = vot.Name;
            votWrap.status = vot.Status__c;
            votWrap.vendors=vot.Vendors__c;
            votWrap.services=vot.Services__c;
            votWrap.datesent = vot.Date_Sent__c;
            votWrap.LastModifiedByName = vot.LastModifiedBy.Name;
            votWrap.LastModifiedDate = vot.LastModifiedDate;
            if(vot.Status__c == 'NEW'){
                votWrap.booleanStatus=false;  
                votWrap.booleanStatusToReSend=true;
            }
            else{
                votWrap.booleanStatus=true;  
                votWrap.booleanStatusToReSend=false;
            }
            if(getCurrentUserProfile()=='GC Community Vendor'){
                votWrap.disableDeleteBasedOnProfile=false;
            }
            else{
                votWrap.disableDeleteBasedOnProfile=true;
            }
            
            votObj.add(votWrap);
        }
        return votObj;
    }
    
    @AuraEnabled
    public static String getCurrentUserProfile(){
        List<Profile> profile = [SELECT Id, Name FROM Profile WHERE Id = :userinfo.getProfileId() LIMIT 1];
        String profileName = profile[0].Name;
        return profileName;
    }
    
    @AuraEnabled
    public static  Map<string,List<string>> getPicklistValues(string orderId){//Method to get all the service type picklist values and vendor picklist values
        List<String> picklistValues= new List<String>();
        Id showId=getShowOfOrder(orderId);
        List<GC_Show_Attribute__c> showAttributes = [select Id, Name, RecordType.Name from GC_Show_Attribute__c where Connect2_Show__c = :showId ORDER BY Name];
        for (GC_Show_Attribute__c showAttribute : showAttributes) {
            if (showAttribute.RecordType.Name == 'Show Service') {
                picklistValues.add(showAttribute.Name);
            }
        }
        Map<string,List<string>> vendorsToAllServiceTypes= new  Map<string,List<string>>();
        List<GC_Show_Attribute__c> IdOfPickList=[Select Id,Name from GC_Show_Attribute__c where Connect2_Show__c =:showId AND Name In: picklistValues];
        Map<Id,String> mapOFServiceTypeNameAndId= new Map<Id,String>();
        for(GC_Show_Attribute__c att:IdOfPickList){
            mapOFServiceTypeNameAndId.put(att.Id,att.Name);
        }
        List<GC_Show_Team_Member__c> stmVen =[Select Id,User__c,User__r.Name,User__r.CompanyName,Service_Type__r.Name,Service_Type__c from GC_Show_Team_Member__c where Service_Type__c In: IdOfPickList Order BY Service_Type__r.Name];
        Map<Id,List<String>> mapOFServiceTypeIdAndVendors= new  Map<Id,List<String>>();
        for(id serviceTypeId : mapOFServiceTypeNameAndId.keySet()){
            List<string> vendors= new List<string>();
            for(GC_Show_Team_Member__c mem:stmVen){
                if(serviceTypeId == mem.Service_Type__c){
                    if(mem.user__r.CompanyName != null || String.isNotBlank(mem.User__r.CompanyName)){
                        string option=mem.User__r.Name+'-'+mem.User__r.CompanyName;
                        vendors.Add(option);
                        //system.debug('Vendors-------' + Vendors);
                    }
                    else{
                        string option=mem.User__r.Name;
                        vendors.Add(option);
                        //system.debug('Vendors-------' + Vendors);
                    }
                    mapOFServiceTypeIdAndVendors.put(mem.Service_Type__c,vendors);
                }
            }
        }
        Set<Id> IdsOfStmMem=new Set<Id>();
        IdsOfStmMem=mapOFServiceTypeNameAndId.keySet();
        for(Id i:IdsOfStmMem){
            List<string> emptyList= new List<String>();
            if(!mapOFServiceTypeIdAndVendors.containsKey(i)){
                mapOFServiceTypeIdAndVendors.put(i,emptyList);
            }
        }
        for(Id serviceTypeId: mapOFServiceTypeNameAndId.keySet()){
            for(Id memberServiceTypeId:mapOFServiceTypeIdAndVendors.keySet()){
                if(serviceTypeId == memberServiceTypeId){
                    vendorsToAllServiceTypes.put(mapOFServiceTypeNameAndId.get(serviceTypeId),mapOFServiceTypeIdAndVendors.get(memberServiceTypeId));
                }
            }
        }
        return vendorsToAllServiceTypes;
    }
    @AuraEnabled
    public static List<String> getVenueLocations(string orderId){ //Method to get the picklist values of Venues
        List<String> VenuesToBeReturned= new List<String>();
        Id showId= getShowOfOrder(orderId);
        List<GC_Show_Attribute__c> attribute = new List<GC_Show_Attribute__c>();
        attribute=[select Id, Name, RecordType.Name from GC_Show_Attribute__c where Connect2_Show__c = :showId];
        for(GC_Show_Attribute__c att:attribute){
            if(att.RecordType.Name == 'Venue Location'){
                VenuesToBeReturned.Add(att.Name);
            }
        }
        return VenuesToBeReturned;
    }
    
    public static Id getShowOfOrder(string orderId){
        GC_Order__c order= [select Connect2_Show__c from GC_Order__c where Id=:orderId];
        return order.Connect2_Show__c;
    }
    
    @AuraEnabled
    public static VOTWrapper InsertVOT(string votName,Boolean cloneVOT,string orderId,string sT,string sT2,string sT3,string sT4,string sT5,string v1,string v2,string v3,string v4,string v5,string vendorInst,string venueLocation,string deliveryArea,Date deliveryDate,Date completionDate,Date removalDate){
        //vendorInst,string got1,string got2,string got3,string got4,string got5,string vendorInst
        VOTWrapper wrapperObjToReturn=new VOTWrapper();
        VOTWrapper w= new VOTWrapper();
        Id showId= getShowOfOrder(orderId);
        List<string> serviceTypeList = new List<string>();
        serviceTypeList.add('\''+sT+'\'');
        serviceTypeList.add('\''+sT2+'\'');
        serviceTypeList.add('\''+sT3+'\'');
        serviceTypeList.add('\''+sT4+'\'');
        serviceTypeList.add('\''+sT5+'\'');
        system.debug('serviceTypeList'+serviceTypeList);
        List<string> vendorsList = new List<string>();
        if((v1 !='')&&(v1 != null)){ // ='' condition for insert and null condition check for update
            v1=v1.substringBefore('-');
            vendorsList.add('\''+v1+'\'');
        }
        if((v2 !='')&&(v2 != null)){
            v2=v2.substringBefore('-');
            vendorsList.add('\''+v2+'\'');
        }
        if((v3 !='')&&(v3 != null)){
            v3=v3.substringBefore('-');
            vendorsList.add('\''+v3+'\'');
        }
        if((v4 !='')&&(v4 != null)){
            v4=v4.substringBefore('-');
            vendorsList.add('\''+v4+'\'');
        }
        if((v5 !='')&&(v5 != null)){
            v5=v5.substringBefore('-');
            vendorsList.add('\''+v5+'\'');
        }

        List<GC_Show_Attribute__c> serviceTypeId= new List<GC_Show_Attribute__c>();// get the Id of all service types using Names
        string queryString='Select Id,Name from GC_Show_Attribute__c where Connect2_Show__c = '+'\''+showId+'\'';
        queryString+=' AND Name In '+serviceTypeList;
        
        if((sT != '')||(sT2 != '')||(sT3 != '')||(sT4 != '')||(sT5 != '')){
            serviceTypeId=Database.query(queryString);
            system.debug('serviceTypeId'+serviceTypeId);
        }
        Map<String,Id> serviceTypeIdMap = new Map<String,Id>();
        for(Integer i=0;i<serviceTypeId.size();i++){
            serviceTypeIdMap.put(serviceTypeId[i].Name,serviceTypeId[i].Id);
        }
        Boolean service1HasValue; Boolean service2HasValue; Boolean service3HasValue; Boolean service4HasValue; Boolean service5HasValue;
        Boolean vendor1HasValue; Boolean vendor2HasValue; Boolean vendor3HasValue; Boolean vendor4HasValue; Boolean vendor5HasValue;
     for(Integer i=0;i<serviceTypeList.size();i++){
            if((sT != '' && serviceTypeList[i].remove('\'') == sT) && (service1HasValue == null)){
                w.wrapperService1= serviceTypeIdMap.get(sT);
                service1HasValue=true;
                continue;
            }
            if((sT2 != '' && serviceTypeList[i].remove('\'') == sT2) && (service2HasValue == null)) {
                w.wrapperService2=serviceTypeIdMap.get(sT2);
                service2HasValue=true;
                continue;
            }
            
            if((sT3 != '' && serviceTypeList[i].remove('\'') == sT3)&&(service3HasValue == null)){
                w.wrapperService3=serviceTypeIdMap.get(sT3);
                service3HasValue=true;
                continue;
            }
            
            if((sT4 != ''&& serviceTypeList[i].remove('\'') == sT4)&&(service4HasValue == null)){
                w.wrapperService4=serviceTypeIdMap.get(sT4);
                service4HasValue=true;
                continue;
            }
            
            if((sT5 != ''&& serviceTypeList[i].remove('\'') == sT5)&&(service5HasValue == null)){
                w.wrapperService5=serviceTypeIdMap.get(sT5);
                service5HasValue=true;
                continue;
            }
        }
        
        List<GC_Show_Team_Member__c> vendor= new List<GC_Show_Team_Member__c>();
        string vendorQueryString='select User__c,User__r.Name from GC_Show_Team_Member__c where Connect2_Show__c='+'\''+showId+'\'';
        vendorQueryString+=' AND  User__r.Name In '+vendorsList;
        if(((v1 != '')&&(v1 != null))||((v2 != '')&&(v2 != null))||((v3 != '')&&(v3 != null))||((v4 != '')&&(v4 != null))||((v5 != '')&&(v5 != null))){
            vendor=Database.query(vendorQueryString);
        }
        Map<String,Id> vendorIdMap = new Map<String,Id>();
        for(Integer i=0;i<vendor.size();i++){
            vendorIdMap.put(vendor[i].User__r.Name,vendor[i].User__c);
        }
        for(Integer i=0;i<vendorsList.size();i++){
            if((v1 != '' && vendorsList[i].remove('\'') == v1 ) && (vendor1HasValue == null)){
                w.wrappervendor1=vendorIdMap.get(v1);
                vendor1HasValue=true;
                continue;
            }
            if((v2 != '' && vendorsList[i].remove('\'') == v2) && (vendor2HasValue == null)){
                w.wrappervendor2=vendorIdMap.get(v2);
                vendor2HasValue=true;
                continue;
            }
            if((v3 != '' && vendorsList[i].remove('\'') == v3) && (vendor3HasValue == null)){
                w.wrappervendor3=vendorIdMap.get(v3);
                vendor3HasValue=true;
                continue;
            }
            if((v4 != '' && vendorsList[i].remove('\'') == v4) && (vendor4HasValue == null)){
                w.wrappervendor4=vendorIdMap.get(v4);
                vendor4HasValue=true;
                continue;
            }
            if((v5 != '' && vendorsList[i].remove('\'') == v5) && (vendor5HasValue == null)){
                w.wrappervendor5=vendorIdMap.get(v5);
                vendor5HasValue=true;
                continue;
            }
        }
        GC_Show_Attribute__c venue= new GC_Show_Attribute__c();
        if((venueLocation != '')&&(venueLocation != null)){
            venue=[select Id from GC_Show_Attribute__c where Name=:venueLocation and Connect2_Show__c=:showId];
        }
        
        GC_Vendor_Order_Task__c insertVot= new GC_Vendor_Order_Task__c();
        Boolean updateRecord;
        Boolean insertRecord;
        if((votName != null)&&(cloneVOT == false)){
            insertVot=[select Id from GC_Vendor_Order_Task__c where Id=:votName];
            updateRecord=true;
        }
        else{
            insertRecord=true;
        }
        insertVot.Order__c=orderId;
        insertVot.Service_Type__c=w.wrapperService1;
        insertVot.Service_Type2__c=w.wrapperService2;
        insertVot.Service_Type3__c=w.wrapperService3;
        insertVot.Service_Type4__c=w.wrapperService4;
        insertVot.Service_Type5__c=w.wrapperService5;
        insertVot.Vendor__c=w.wrappervendor1;
        insertVot.Vendor2__c=w.wrappervendor2;
        insertVot.Vendor3__c=w.wrappervendor3;
        insertVot.Vendor4__c=w.wrappervendor4;
        insertVot.Vendor5__c=w.wrappervendor5;
        insertVot.Vendor_Instructions__c=vendorInst;
        insertVot.SA_Venue_Location_Ven__c=venue.Id;
        insertVot.Delivery_Location_Ven__c=deliveryArea;
        insertVot.Delivery_Date_Time_Ven__c=deliveryDate;
        insertVot.Completion_Date_Time_Ven__c=completionDate;
        insertVot.Removal_Date_Time_Ven__c=removalDate;
        if(updateRecord == true){
            updateRecord=false;
            update insertVot;
            wrapperObjToReturn.insertedVot=insertVot.Id;
            wrapperObjToReturn.insertStatus='update';
            return wrapperObjToReturn;
            //return '';
        }
        if((insertRecord == true)&&(cloneVOT == false)){
            insertRecord=false;
            insert insertVot;
            //return 'insert';
            wrapperObjToReturn.insertedVot=insertVot.Id;
            wrapperObjToReturn.insertStatus='insert';
            return wrapperObjToReturn;
        }
        if((insertRecord == true)&&(cloneVOT == true)){
            system.debug('clone');
            insert insertVot;
            //return 'clone';
            wrapperObjToReturn.insertedVot=insertVot.Id;
            wrapperObjToReturn.insertStatus='clone';
            return wrapperObjToReturn;
        }
        else{
            return null;
        }
        
    }
    
    @AuraEnabled
    public static  List<VOTWrapper> existingValues(string votId){
        List<VOTWrapper> votObjList=new List<VOTWrapper>();
        VOTWrapper vObj= new VOTWrapper();
        GC_Vendor_Order_Task__c vot= new GC_Vendor_Order_Task__c();
        vot=[select Id,Name,Order__c,Service_Type__r.Name,Service_Type2__r.Name,Service_Type3__r.Name,Service_Type4__r.Name,Service_Type5__r.Name,Vendor__c,Vendor2__c,Vendor3__c,Vendor4__c,
             Vendor5__c,Vendor_Instructions__c,SA_Venue_Location_Ven__r.Name,Delivery_Location_Ven__c,Delivery_Date_Time_Ven__c,Completion_Date_Time_Ven__c,Removal_Date_Time_Ven__c from GC_Vendor_Order_Task__c where Id=:votId];
        Map<Integer,String> serviceTypeAndNames= new Map<Integer,String>();
        if(vot.Service_Type__r.Name != null){
            serviceTypeAndNames.put(0,vot.Service_Type__r.Name);
        }
        if(vot.Service_Type2__r.Name != null){
            serviceTypeAndNames.put(1,vot.Service_Type2__r.Name);
        }
        if(vot.Service_Type3__r.Name != null){
            serviceTypeAndNames.put(2,vot.Service_Type3__r.Name);
        }
        if(vot.Service_Type4__r.Name != null){
            serviceTypeAndNames.put(3,vot.Service_Type4__r.Name);
        }
        if(vot.Service_Type5__r.Name != null){
            serviceTypeAndNames.put(4,vot.Service_Type5__r.Name);
        }
        vObj.wrapperServiceTypes=serviceTypeAndNames;         
        List<Id> vendorId = new List<Id>();
        vendorId.add(vot.Vendor__c);
        vendorId.add(vot.Vendor2__c);
        vendorId.add(vot.Vendor3__c);
        vendorId.add(vot.Vendor4__c);
        vendorId.add(vot.Vendor5__c);
        Map<Id,string> vendorsMap = new Map<Id,string>();
        List<GC_Show_Team_Member__c> vendors= new List<GC_Show_Team_Member__c>();
        vendors = [select Id,User__c,User__r.Name,User__r.CompanyName from GC_Show_Team_Member__c where User__c in:vendorId];
        for(GC_Show_Team_Member__c m:vendors){
            if(m.User__r.CompanyName != null || String.isNotBlank(m.User__r.CompanyName)){
                vendorsMap.put(m.User__c,m.User__r.Name+'-'+m.User__r.CompanyName);
            }
            else{
                vendorsMap.put(m.User__c,m.User__r.Name);
            }
        }
        Map<Integer,string> vendorNames= new Map<Integer,string>();
        for(Integer i=0;i<vendorId.size();i++){
            for(Id vId:vendorsMap.keyset()){
                if(vendorId[i]==vId){
                    vendorNames.put(i,vendorsMap.get(vId));
                    vObj.wrapperVendors=vendorNames;
                }
            }
        }
        if(vot.SA_Venue_Location_Ven__c != null){
            vObj.wrapperVenueLocation=vot.SA_Venue_Location_Ven__r.Name;
        }
        vObj.wrapperVendorInstructions=vot.Vendor_Instructions__c;
        vObj.wrapperDeliveryArea=vot.Delivery_Location_Ven__c;
        vObj.wrapperDeliveryDate=vot.Delivery_Date_Time_Ven__c;
        vObj.wrapperCompletionDate=vot.Completion_Date_Time_Ven__c;
        vObj.wrapperRemovalDate=vot.Removal_Date_Time_Ven__c;
        vObj.wrapperOrderId=vot.Order__c;
        votObjList.add(vObj);
        return votObjList;
        
    }
    @AuraEnabled
    public static void deleteVOTRecords(string votId){
        GC_Vendor_Order_Task__c deleteVOT= new GC_Vendor_Order_Task__c();
        deleteVOT=[select Id from GC_Vendor_Order_Task__c where Id=:votId];
        delete deleteVOT;
    }
    
    @AuraEnabled
    webservice static Boolean submitRecord(Id votRecordId) { //webservice is used to expose the class as custom Soap webservice calls.This allows external app to invoke apex web service to perform action in sf.A developer of an external application can integrate with an Apex class containing webservice methods by generating a WSDL for the class
        GC_Vendor_Order_Task__c vot = new GC_Vendor_Order_Task__c();
        GC_Connect2_Show__c show = new GC_Connect2_Show__c();
        try{
            vot= GC_VendorOrderTaskDao.getInstance().getVendorOrderTaskById(votRecordId);
            show=GC_Connect2ShowDao.getInstance().getConnect2ShowById(vot.Order__r.Connect2_Show__c);
        }catch(exception e){
             throw new AuraHandledException(e.getMessage());
        }
        
        List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();
        
        if (vot.Vendor__c != null) {
            emailMessages.add(LC_OrderUtils.generateVendorEmail(vot, vot.Vendor__c,show.Name+' - '+show.Show_Name__c,vot.Service_Type__r.Name));
        }
        
        if (vot.Vendor2__c != null) {
            emailMessages.add(LC_OrderUtils.generateVendorEmail(vot, vot.Vendor2__c,show.Name+' - '+show.Show_Name__c,vot.Service_Type2__r.Name));
        }
        
        if (vot.Vendor3__c != null) {
            emailMessages.add(LC_OrderUtils.generateVendorEmail(vot, vot.Vendor3__c,show.Name+' - '+show.Show_Name__c,vot.Service_Type3__r.Name));
        }
        
        if (vot.Vendor4__c != null) {
            emailMessages.add(LC_OrderUtils.generateVendorEmail(vot, vot.Vendor4__c,show.Name+' - '+show.Show_Name__c,vot.Service_Type4__r.Name));
        }
        
        if (vot.Vendor5__c != null) {
            emailMessages.add(LC_OrderUtils.generateVendorEmail(vot, vot.Vendor5__c,show.Name+' - '+show.Show_Name__c,vot.Service_Type5__r.Name));
        }
        
        //set allOrNone to false to allow non-error messages to be sent even if some fail
        try{
            Messaging.sendEmail(emailMessages, false);
            vot.Status__c = 'Sent';
            vot.Submitted_Date__c = Date.today();
            update vot;
            return true;
        }catch(exception e){
            return false;
        }
    }
    @AuraEnabled
    public static Boolean vendorsAssigned(string VendorOrderTaskId){
        GC_Vendor_Order_Task__c vendors=new GC_Vendor_Order_Task__c();
        vendors=[select id, name, status__c, Vendor__c,Vendor5__c,Vendor2__c,Vendor3__c,Vendor4__c from GC_Vendor_Order_Task__c where id =: VendorOrderTaskId];
        if((vendors.Vendor__c == null) && (vendors.Vendor2__c == null) && (vendors.Vendor3__c == null)&&(vendors.Vendor4__c == null)&&(vendors.Vendor5__c == null)){
            return false;
        }
        else{
            return true;
        }
        
    }
    @AuraEnabled
    public static Id getClonedVOT(){
        Id userId= UserInfo.getUserId();
        GC_Vendor_Order_Task__c recentVOT= new GC_Vendor_Order_Task__c();
        recentVOT=[select Id from GC_Vendor_Order_Task__c where CreatedById=:userId order by CreatedDate desc limit 1];
        return recentVOT.Id;
    }
   
    
    @AuraEnabled
    public static GC_Vendor_Order_Task__c getVotBannerData(Id votId){
        list<GC_Vendor_Order_Task__c> votObject = new list<GC_Vendor_Order_Task__c>();
        votObject = [SELECT id, name,Status__c,Order__c FROM GC_Vendor_Order_Task__c WHERE id =: votId LIMIT 1];
        // system.debug('votObject---'+votObject);
        if(votObject.size() > 0){
            return votObject[0];
        }
        else return new GC_Vendor_Order_Task__c();
    }
    
    @auraEnabled
    public static GC_Order__c getOrdersData(string orderId){
        GC_Order__c order =[select Id,Name from GC_Order__c where Id=:orderId];
        return order;
    }
    
     @AuraEnabled // Added by AGouda
    public static boolean isCommunity(){
        Id siteId = Site.getSiteId(); // take a look at the apex class Site, you may find more useful method concerning site/community
        if (siteId != null) {
            return true;
        }
        return false;
    }
}