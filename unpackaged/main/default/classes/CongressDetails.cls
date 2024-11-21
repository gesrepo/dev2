public class CongressDetails{
    public GES_Connect_Corporate_Accounts__c gcca { get; set; }
    public GES_Connect_Corporate_Accounts__c gc { get; set; }
    public string congid{get;set;}
    // public string conid{get;set;}   
    public string Cntsw{get;set;}
    public string connect2show{get;set;}
    public GC_Connect2_Show__c  connect2showname{get;set;}
    public String nameOFCong {get; set;}
    public string emailError {get;set;}   
    public Boolean profileCheck {get; set;}
    public Boolean showHousingFields {get; set;}
    public Boolean showHousingLogisticVendorOther {get; set;}
    public Boolean showHousingFieldsClone {get; set;}
    public Boolean showHousingLogisticVendorOtherClone {get; set;}
    public Boolean showCancelledFields {get; set;}
    public string noOfRoomsRequiredError {get;set;} 
    public string BrandError {get;set;}
    public string housingLogisticVendorError {get;set;}
    public string housingLogisticVendorOtherError {get;set;}
    public Double offset{get{
        TimeZone tz = UserInfo.getTimeZone();
        //Milliseconds to Day
        return tz.getOffset(DateTime.now()) / (1000 * 3600 * 24.0);
    }}
    public string exhibitHoursOpenDay1{get; set;}
    public string exhibitHoursOpenDay2{get; set;}
    public string exhibitHoursOpenDay3{get; set;}
    public string exhibitHoursOpenDay4{get; set;} 
    public string exhibitHoursCloseDay1{get; set;}
    public string exhibitHoursCloseDay2{get; set;}
    public string exhibitHoursCloseDay3{get; set;}
    public string exhibitHoursCloseDay4{get; set;} 
    
    
    public CongressDetails(ApexPages.StandardController controller) {
        showHousingLogisticVendorOther = false;
        showHousingFields = false;
        showHousingLogisticVendorOtherClone = false;
        showHousingFieldsClone = false;
        showCancelledFields = false;
        congid =System.currentPageReference().getParameters().get('id'); 
        gcca =new GES_Connect_Corporate_Accounts__c();
        gc =new GES_Connect_Corporate_Accounts__c();
        system.debug('Cong id'+ congid);
        if(String.isNotBlank(congid))
        {
            connect2show=System.currentPageReference().getParameters().get('connect2show'); 
            gcca=[select id,Name,Project_Complete__c,Show_Name__c,Facility_Name_Account__c,Shipping_Street__c,Shipping_City__c,Shipping_City_c__c,Shipping_Street_c__c, Name_of_Congress__c,Congress_Website__c,Congress_Type__c,Congress_End_Date__c,Acronym_of_Congress__c,Exhibit_Close_Date__c,Exhibit_Open_Date__c,Exhibit_Date_Day1__c,
                  Exhibit_Hours_Open_Day_1__c,Exhibit_Hours_Close_Day_1__c,Exhibit_Date_Day_2__c,Exhibit_Hours_Open_Day_2__c,Exhibit_Hours_Close_Day_2__c,Exhibit_Date_Day_3__c,Exhibit_Hours_Open_Day_3__c,Exhibit_Hours_Close_Day_3__c,Exhibit_Date_Day_4__c,
                  Exhibit_Hours_Open_Day_4__c,Exhibit_Hours_Close_Day_4__c,GES_Account_Executive__c,GES_Account_Manager__c,GES_Project_Manager__c,GES_Meeting_Planner__c,Association_Name__c,Association_Contact_Name__c,
                  Association_phone__c,Association_website__c,Association_Email__c,General_Contractor_Name__c,General_Contractor_Contact_Name__c,Congress_Start_Date__c,General_Contractor_Phone__c,General_Contractor_Website__c,Facility_Name__c,
                  Shipping_State_Province__c,Shipping_Country__c,Shipping_Zip_Postal_Code__c,Shipping_Zip_Postal_Code_c__c,Advanced_Warehouse_Location_Name__c,Shipping_State_Province_c__c,Shipping_Country_c__c,Housing_Logistics_Vendor__c,Housing_Logistics_Vendor_Other__c,
                  Housing_Contact__c,Housing_Contact_Phone__c,Congress_Cancelled__c,Reason_for_Cancellation__c,Congress_Cancellation_Date__c,Housing_Contact_e_mail__c,AssociationHousing_Website_Portal_Log_In__c,Housing_Opens__c,Housing_Deadline__c,Number_of_rooms_to_Secure__c,Number_of_rooms_Secured__c,Room_Block_Start_Date__c,Room_Block_end_Date__c,Deposit_Paid__c,
                  Hotel_1_Name__c,Hotel_1_room_rate__c,Hotel_1_cancellation_date__c,Hotel_1_cancellation_policy__c,Hotel_2_Name__c,Hotel_2_room_rate__c,Hotel_2_cancellation_date__c,Hotel_2_cancellation_policy__c,Hotel_3_Name__c,Hotel_3_room_rate__c,Hotel_3_cancellation_date__c,Hotel_3_cancellation_policy__c,
                  Ancillary_Meeting_Space_Required__c,Number_of_Meeting_Rooms__c,Meeting_Room_1_Date__c,Meeting_Room_1_Time__c,Meeting_Room_1_Location__c,Meeting_Room_1_Number__c,Funding_Owner__c,Cost_Center__c,Meeting_Room_2_Date__c,Meeting_Room_2_Time__c,Meeting_Room_2_Location__c,Meeting_Room_2_Number__c,
                  Funding_Owner_O__c,Cost_Center_c__c,Registration_Website__c,Registration_Login__c,Complimentary_Badges__c,Badges_Required__c,Cost_center_for_additional_badges__c,CSI_Received__c,Application_Status__c,PO_Status__c,GES_Final_Invoice_Received__c,FCPA_Status__c, Payment_Status_Type__c, 
                  Epa3_Closed__c, PO_Closed__c,Notes__c,GES_Project_Number__c,Client_PO__c,Deposit_Invoice_Amount__c,Deposit_Invoice__c,Deposit_Invoice_Date_issued__c,Final_Invoice_Amount__c,Final_Invoice__c,Final_Invoice_Date_issued__c,Payment_Received_Date__c,IDSupervisor__c, Congress_Level__c, 
                  Secretariat_Contact_Email__c, Secretariat_Contact_Name__c, Secretariat_Contact_Phone__c, Secretariat_Name__c, Secretariat_Same_as_Association__c, Congress_Shipping__c, Congress_WHS__c, First_Day_Freight__c, Last_Day_Freight__c, CSI_Received_Date__c, FCPA_Received_Date__c, 
                  FRF_Received_Date__c,FRF_Status__c, CurrencyIsoCode, CSI_form_submitted_by_CM__c, Reason_RE_not_used__c,Sales_Direct_to_GES__c,Social_Media_Utilized__c, Social_Media_Used__c, of_HCP_s_in_Attendance__c, Staffing_Strategy__c,Quantity_of_Staffers__c, Planning_Commenced__c,Congress_Occurence__c,Pfizer_Previously_Attended__c, Housing_Required_PL__c, Date_Legal_Reached_Out__c,
                  GES_Paid__c, GES_Paid_Date__c,Epa3_Closed_Date__c,Number_of_Attendees__c,If_not_appropriate_audience_Explanation__c, FRF_Approval__c, Housing_Notes__c, Budget_Status__c, Legal_Reached_out_to_Assoc__c,Brand_Approval__c,GES_Proposal_Received__c,Total_No_of_Rooms_Req__c ,Brand_1__c,Brand_2__c,Brand_3__c,Brand_4__c,Brand_5__c,
                  Number_of_Rooms_Requested_1__c,Number_of_Rooms_Requested_2__c,Number_of_Rooms_Requested_3__c,Number_of_Rooms_Requested_4__c,Number_of_Rooms_Requested_5__c,Reality_Engineering_Utilized__c, NonShowPRJ__c, Event_Type__c, Assoc_Activity_Type_offered__c, Assoc_Provided_Data__c, Exhibit_Hall_Registrants__c, Active_Registrants__c, Congress_Registrants__c
                  from GES_Connect_Corporate_Accounts__c where id=:congid];  
            // removed , for SCA-726 rsinha
            
            if(gcca.Housing_Required_PL__c == 'Yes'){
                showHousingFields = true;
            }
            if(gcca.Housing_Logistics_Vendor__c == 'Other'){
                showHousingLogisticVendorOther = true;
            }
            if(gcca.Congress_Cancelled__c){
                showCancelledFields = true;
            }
        }
        
        ExhibitList();
        SponsorshipList();
        ProductTheaterList();
        SymposiaList();
        MeetingRoomList();
        Cntsw=gcca.Show_Name__c;
        nameOfCong= gcca.Name_of_Congress__c;
        if(String.isNotBlank(Cntsw))
        {
            connect2showname= [SELECT Name FROM GC_Connect2_Show__c WHERE Id = : Cntsw];
        }
        system.debug('connect 2 show id'+Cntsw);
        profileCheck = false;
        if(userinfo.getProfileId() == system.label.CLGCCongressInternalProfileId) {
            profileCheck = true;
        }
        //exhibitHoursOpenDay1 = gcca.Exhibit_Hours_Open_Day_1__c.format('MMMM d, yyyy  hh:mm a', UserInfo.getTimeZone().toString());
        //exhibitHoursOpenDay2 = gcca.Exhibit_Hours_Open_Day_2__c.format('MMMM d, yyyy  hh:mm a', UserInfo.getTimeZone().toString());
        // exhibitHoursOpenDay3 = gcca.Exhibit_Hours_Open_Day_3__c.format('MMMM d, yyyy  hh:mm a', UserInfo.getTimeZone().toString());
        // exhibitHoursOpenDay4 = gcca.Exhibit_Hours_Open_Day_4__c.format('MMMM d, yyyy  hh:mm a', UserInfo.getTimeZone().toString());
        if(gcca.Exhibit_Hours_Open_Day_1__c!=null){
            exhibitHoursOpenDay1 = gcca.Exhibit_Hours_Open_Day_1__c.format('MMMM d, yyyy  hh:mm a', UserInfo.getTimeZone().toString());
        }else{
            exhibitHoursOpenDay1='';
        }
        if(gcca.Exhibit_Hours_Open_Day_2__c!=null){
            exhibitHoursOpenDay2 = gcca.Exhibit_Hours_Open_Day_2__c.format('MMMM d, yyyy  hh:mm a', UserInfo.getTimeZone().toString());
        }else{
            exhibitHoursOpenDay2='';
        }
        if(gcca.Exhibit_Hours_Open_Day_3__c!=null){
            exhibitHoursOpenDay3 = gcca.Exhibit_Hours_Open_Day_3__c.format('MMMM d, yyyy  hh:mm a', UserInfo.getTimeZone().toString());
        }else{
            exhibitHoursOpenDay3='';
        }
        if(gcca.Exhibit_Hours_Open_Day_4__c!=null){
            exhibitHoursOpenDay4 = gcca.Exhibit_Hours_Open_Day_4__c.format('MMMM d, yyyy  hh:mm a', UserInfo.getTimeZone().toString());
        }else{
            exhibitHoursOpenDay4='';
        }
        if(gcca.Exhibit_Hours_Close_Day_1__c!=null){
            exhibitHoursCloseDay1 = gcca.Exhibit_Hours_Close_Day_1__c.format('MMMM d, yyyy  hh:mm a', UserInfo.getTimeZone().toString());
        }else{
            exhibitHoursCloseDay1='';
        }
        if(gcca.Exhibit_Hours_Close_Day_2__c!=null){
            exhibitHoursCloseDay2 = gcca.Exhibit_Hours_Close_Day_2__c.format('MMMM d, yyyy  hh:mm a', UserInfo.getTimeZone().toString());
        }else{
            exhibitHoursCloseDay2='';
        }
        if(gcca.Exhibit_Hours_Close_Day_3__c!=null){
            exhibitHoursCloseDay3 = gcca.Exhibit_Hours_Close_Day_3__c.format('MMMM d, yyyy  hh:mm a', UserInfo.getTimeZone().toString());
        }else{
            exhibitHoursCloseDay3='';
        }
        if(gcca.Exhibit_Hours_Close_Day_4__c!=null){
            exhibitHoursCloseDay4 = gcca.Exhibit_Hours_Close_Day_4__c.format('MMMM d, yyyy  hh:mm a', UserInfo.getTimeZone().toString());
        }else{
            exhibitHoursCloseDay4='';
        }
    }
    public List<GES_Connect_Corporate_Accounts__c> gccalst{get;set;}
    public List<Exhibit__c> extlst{get;set;}
    
    public PageReference updateDate(){
        System.debug('inside edit');
        if(gc.Epa3_Closed__c)
            gc.Epa3_Closed_Date__c=date.Today();
        else
            gc.Epa3_Closed_Date__c=null;
        return null;
    }
    
    //string congid = ApexPages.currentPage().getParameters().get('id');    
    GES_Connect_Corporate_Accounts__c a=new GES_Connect_Corporate_Accounts__c();
    Exhibit__c e=new Exhibit__c();
    public PageReference NewExhibit()
    { 
        PageReference newExhibitedit= new PageReference('/apex/Exhibitedit');   
        newExhibitedit.getParameters().put('congressName',String.valueOf(gcca.Name));
        newExhibitedit.getParameters().put('congressid',String.valueOf(gcca.id));
        newExhibitedit.setRedirect(true);
        return newExhibitedit;          
    }    
    
    public PageReference NewSponsorship()
    { 
        PageReference newSponsorship= new PageReference('/apex/Sponsorshipedit');   
        newSponsorship.getParameters().put('congName',String.valueOf(gcca.Name));
        newSponsorship.getParameters().put('congid',String.valueOf(gcca.id));
        newSponsorship.setRedirect(true);
        return newSponsorship;          
    }
    public PageReference NewProductTheater()
    { 
        PageReference newProductTheater= new PageReference('/apex/ProductTheateredit');   
        newProductTheater.getParameters().put('congName',String.valueOf(gcca.Name));
        newProductTheater.getParameters().put('congid',String.valueOf(gcca.id));
        newProductTheater.setRedirect(true);
        return newProductTheater;          
    }
    public PageReference NewSymposia()
    { 
        PageReference newSymposia= new PageReference('/apex/Symposiaedit');   
        newSymposia.getParameters().put('congName',String.valueOf(gcca.Name));
        newSymposia.getParameters().put('congid',String.valueOf(gcca.id));
        newSymposia.setRedirect(true);
        return newSymposia;          
    }
    public PageReference NewMeetingRoom()
    { 
        PageReference newMeetingRoom= new PageReference('/apex/MeetingRoomedit');   
        newMeetingRoom.getParameters().put('congName',String.valueOf(gcca.Name));
        newMeetingRoom.getParameters().put('congid',String.valueOf(gcca.id));
        newMeetingRoom.setRedirect(true);
        return newMeetingRoom;          
    }
    public List<Exhibit__c> lstExt {get;set;}
    public PageReference ExhibitList()
    {
        if(congid!='')
        {
            system.debug('Cong id 59'+congid);
            lstExt=[select id,Name,Exhibit_Name__c,Booth_Length__c,Booth_Width__c,Activity_Level__c,Activity_Type_Exhibit_Instance_c__c,Createddate,lastmodifieddate,Canceled__c,HCP_tracking__c,In_booth_promotion_detail__c,In_booth_hospitality_detail__c,Congress_Lead__c, GES_Congress_Manager__c  from Exhibit__c where Activity_Type_Exhibit_Instance_c__c =:congid order by Name DESC];
            system.debug('List of Exhibit Data'+lstExt);
        }
        return null;
    }
    public List<Sponsorship__c> lstSpnsp{get;set;}
    public PageReference SponsorshipList()
    {
        if(congid!='')
        {
            system.debug('Cong id 82'+congid);
            lstSpnsp=[select id,Name,Activity_Level__c,Exhibit_Bundled_with_Sponsorsip__c,Sponsorship__c,Sponsorship_Costs_Actual__c,Sponsorship_Costs_Estimated__c,Sponsorship_Name__c,Createddate,lastmodifieddate,Canceled__c,Congress_Lead__c, GES_Congress_Manager__c from Sponsorship__c where Sponsorship__c=:congid order by Name DESC];       
        }
        return null;
    }
    public List<Product_Theater__c> lstptrs {get;set;}
    public PageReference ProductTheaterList()
    {
        if(congid!='')
        {
            system.debug('Cong id 59'+congid);
            lstptrs =[select id,Name,Activity_Level__c,Congress__c,Product_Theater_Date__c,Product_Theater_Lead__c,Product_Theater_Location__c,Product_Theater_Name__c,Product_Theater_Time__c,Createddate,lastmodifieddate,Canceled__c,Congress_Lead__c, GES_Congress_Manager__c  from Product_Theater__c where Congress__c=:congid order by Name DESC];
            system.debug('List of Product Theater Data'+lstptrs);
        }
        return null;
    }
    public List<Symposia__c> lstsy {get;set;}
    public PageReference SymposiaList()
    {
        if(congid!='')
        {
            system.debug('Cong id 59'+congid);
            lstsy =[select id,Name,Activity_Level__c,Congress__c,Symposia_Name__c,Symposium_Date__c,Symposium_Lead__c,Symposium_Location__c,Symposium_Time__c,Createddate,lastmodifieddate,Canceled__c,Congress_Lead__c, GES_Congress_Manager__c,GES_Account_Manager__c  from Symposia__c where Congress__c =:congid order by Name DESC];
            system.debug('List of Symposia Data'+lstptrs);
        }
        return null;
    }
    public List<Meeting_Room__c> lstmr {get;set;}
    public PageReference MeetingRoomList()
    {
        if(congid!='')
        {
            system.debug('Cong id 59'+congid);
            lstmr =[select id,Name,Activity_Level__c,Congress__c,GES_Project_Number__c,Meeting_Room_Date__c,Meeting_Room_Lead__c,Meeting_Room_Location__c,Meeting_Room_Name__c,Meeting_Room_Number__c,Meeting_Room_Time__c,Createddate,lastmodifieddate,Canceled__c,Congress_Lead__c, GES_Congress_Manager__c  from Meeting_Room__c where Congress__c=:congid order by Name DESC];
            system.debug('List of Meeting Room Data'+lstptrs);
        }
        return null;
    }
    Public PageReference Congressedit(){
        
        if(gc.GES_Final_Invoice_Received__c == 'No')
        {
            gc.GES_Final_Invoice_Received__c ='N/A';
        }
        if(!Test.isRunningTest()){
            if(gc.Facility_Name__c == null || gc.Facility_Name__c == '') {
                emailError = 'Error: You must enter a value';
                return null;
            }
            if((gc.Brand_1__c == Null || gc.Brand_1__c == '') && gc.Housing_Required_PL__c == 'Yes'){
                BrandError = 'Error: This field cannot be empty';
                return null;
            }
            if(gc.Number_of_Rooms_Requested_1__c < 1 && gc.Housing_Required_PL__c == 'Yes'){
                noOfRoomsRequiredError = 'Error: This field cannot be 0';
                return null;
            }
            if((gc.Housing_Logistics_Vendor_Other__c == '' || gc.Housing_Logistics_Vendor_Other__c == null) && gc.Housing_Logistics_Vendor__c == 'Other'){
                housingLogisticVendorOtherError = 'Error: You must enter a value';
                return null;
            }
            if(gc.Housing_Required_PL__c == 'Yes' &&(gc.Housing_Logistics_Vendor__c == null || gc.Housing_Logistics_Vendor__c == '' || gc.Housing_Logistics_Vendor__c == '--None--')){
                housingLogisticVendorError = 'Error : please select a value here';
                return null;
            }
            String facilityId = String.valueof(gc.Facility_Name_Account__c);
            if(gc.Facility_Name__c == null || gc.Facility_Name__c == '') {
                emailError = 'Error: You must enter a value';
                return null;
            }
        }
        upsert gc;
        
        List<Exhibit__c> listExhibitToInsert = new List<Exhibit__c>();
        List<Sponsorship__c> listSponsorshipToInsert = new List<Sponsorship__c>();
        List<Product_Theater__c> listProductTheaterToInsert = new List<Product_Theater__c>();
        List<Symposia__c> listSymposiaToInsert = new List<Symposia__c>();
        List<Meeting_Room__c> listMeetingRoomToInsert = new List<Meeting_Room__c>();
        List<Brand__c> listBrandToInsert = new List<Brand__c>();
        Map<Id,Exhibit__c> mapExhibit = new Map<Id,Exhibit__c>();
        Map<Id,List<Brand__c>> mapBrand = new Map<Id,List<Brand__c>>();
        Map<Id,Sponsorship__c> mapSponsorship = new Map<Id,Sponsorship__c>();
        Map<Id,Product_Theater__c> mapProductTheater = new Map<Id,Product_Theater__c>();
        Map<Id,Meeting_Room__c> mapMeetingRoom = new Map<Id,Meeting_Room__c>();
        Map<Id,Symposia__c> mapSymposia = new Map<Id,Symposia__c>();
        //Map<Id,List<Brand__c>> mapBrand = new Map<Id,List<Brand__c>>(); 
        for(Exhibit__c e : lstExt) {
            if(e.Canceled__c != true){
                Exhibit__c exhibit = e.clone(false, true);
                exhibit.Activity_Type_Exhibit_Instance_c__c = gc.Id;
                exhibit.Booth_Number__c = null;
                exhibit.GES_Project_Number__c = null;
                exhibit.Medical_Information__c = null;
                exhibit.Disease_State_booth__c = false;
                exhibit.E_Permissions__c = false;
                exhibit.Exhibit_Bundled_with_Sponsorsip__c = false;
                exhibit.DoD_Properties__c = false;
                exhibit.In_booth_promotion__c = false;
                exhibit.In_booth_hospitality__c = false;
                exhibit.Disease_State_booth__c = false;
                
                listExhibitToInsert.add(exhibit);
                mapExhibit.put(e.Id, exhibit);
            }
        }
        for(Sponsorship__c s : lstSpnsp) {
            if(s.Canceled__c != true){
                Sponsorship__c Sponsorship = s.clone(false, true);
                Sponsorship.Sponsorship__c= gc.Id;
                listSponsorshipToInsert.add(Sponsorship);
                mapSponsorship.put(s.Id, Sponsorship);
            }
        }
        for(Product_Theater__c p : lstptrs) {
            if(p.Canceled__c != true){
                Product_Theater__c ProductTheater = p.clone(false, true);
                ProductTheater.Congress__c= gc.Id;
                listProductTheaterToInsert.add(ProductTheater);
                mapProductTheater.put(p.Id, ProductTheater); 
            }
        }
        for(Meeting_Room__c m : lstmr ) {
            if(m.Canceled__c != true){
                Meeting_Room__c MeetingRoom= m.clone(false, true);
                MeetingRoom.Congress__c= gc.Id;
                listMeetingRoomToInsert.add(MeetingRoom);
                mapMeetingRoom.put(m.Id, MeetingRoom);
            }
        }
        for(Symposia__c sy : lstsy) {
            if(sy.Canceled__c != true){
                Symposia__c Symposia = sy.clone(false, true);
                Symposia.Congress__c= gc.Id;
                listSymposiaToInsert.add(Symposia);
                mapSymposia.put(sy.Id, Symposia);
            }
        }
        if(listExhibitToInsert.size() > 0) {
            insert listExhibitToInsert;
        }
        if(listSponsorshipToInsert.size() > 0) {
            insert listSponsorshipToInsert;
        }
        if(listProductTheaterToInsert.size() > 0) {
            insert listProductTheaterToInsert;
        }
        if(listSymposiaToInsert.size() > 0) {
            insert listSymposiaToInsert;
        }
        if(listMeetingRoomToInsert.size() > 0) {
            insert listMeetingRoomToInsert;
        }
        for(Brand__c b : [select id,Name,Brand_Name__c,GES_Connect_Corporate_Accounts__c,GES_Congress_Manager__c,Brand_Category__c,Congress_Lead__c,Business_Unit__c,COE_Supported__c,Exhibit_Instance__c,Createddate,lastmodifieddate,Canceled__c from Brand__c where Exhibit_Instance__c IN:mapExhibit.keyset()]) {
            Brand__c brand = b.clone(false, true);
            if(mapExhibit.containsKey(b.Exhibit_Instance__c)){
                brand.Exhibit_Instance__c = mapExhibit.get(b.Exhibit_Instance__c).Id;
                brand.GES_Connect_Corporate_Accounts__c=gc.Id;
                brand.Booth_Space_Cost_Estimated__c=null;
                brand.Booth_Space_Cost_Actual__c=null;
                brand.Exhibit_Costs_Estimated__c=null;
                brand.Exhibit_Costs_Actual__c=null;
                brand.Brand_Team_Contact__c=null;
                brand.Funding_Provider_Region__c=null;
                brand.Funding_Provider_Brand__c=null;
                brand.Funding_Provider_Department__c=null;
                brand.Cost_Center__c=null;
                brand.Brand_Name__c = b.Brand_Name__c;
                brand.Brand_Category__c = b.Brand_Category__c;
                brand.Business_Unit__c = b.Business_Unit__c;
                
                
                listBrandToInsert.add(brand);
            }
        }
        for(Brand__c b : [select id,Name,Brand_Name__c,GES_Congress_Manager__c,Brand_Category__c,Congress_Lead__c,Business_Unit__c,COE_Supported__c,Sponsorship__c,Createddate,lastmodifieddate,Canceled__c,Sponsorship_Budget_Actual__c,Sponsorship_Budget_Estimated__c from Brand__c where Sponsorship__c IN:mapSponsorship.keyset()]) {
            if(b.Canceled__c != true){
                Brand__c brand = b.clone(false, true);
                if(mapSponsorship.containsKey(b.Sponsorship__c)){
                    brand.Sponsorship__c= mapSponsorship.get(b.Sponsorship__c).Id;
                    brand.GES_Connect_Corporate_Accounts__c=gc.Id;
                    brand.Booth_Space_Cost_Estimated__c=null;
                    brand.Booth_Space_Cost_Actual__c=null;
                    brand.Exhibit_Costs_Estimated__c=null;
                    brand.Exhibit_Costs_Actual__c=null;
                    brand.Brand_Team_Contact__c=null;
                    brand.Funding_Provider_Region__c=null;
                    brand.Funding_Provider_Brand__c=null;
                    brand.Funding_Provider_Department__c=null;
                    brand.Cost_Center__c=null;
                    brand.Brand_Name__c = b.Brand_Name__c;
                    brand.Brand_Category__c = b.Brand_Category__c;
                    brand.Business_Unit__c = b.Business_Unit__c;
                    
                    
                    listBrandToInsert.add(brand);
                }
            }
        }
        for(Brand__c b : [select id,Name,Brand_Name__c,GES_Congress_Manager__c,Brand_Category__c,Congress_Lead__c,Business_Unit__c,COE_Supported__c,Product_Theater__c,Createddate,lastmodifieddate,Canceled__c,Product_Theater_Costs_Estimated__c,Product_Theater_Costs_Actual__c from Brand__c where Product_Theater__c IN:mapProductTheater.keyset()]) {
            if(b.Canceled__c != true){
                Brand__c brand = b.clone(false, true);
                if(mapProductTheater.containsKey(b.Product_Theater__c)){
                    brand.Product_Theater__c= mapProductTheater.get(b.Product_Theater__c).Id;
                    brand.GES_Connect_Corporate_Accounts__c=gc.Id;
                    brand.Booth_Space_Cost_Estimated__c=null;
                    brand.Booth_Space_Cost_Actual__c=null;
                    brand.Exhibit_Costs_Estimated__c=null;
                    brand.Exhibit_Costs_Actual__c=null;
                    brand.Brand_Team_Contact__c=null;
                    brand.Funding_Provider_Region__c=null;
                    brand.Funding_Provider_Brand__c=null;
                    brand.Funding_Provider_Department__c=null;
                    brand.Cost_Center__c=null;
                    brand.Brand_Name__c = b.Brand_Name__c;
                    brand.Brand_Category__c = b.Brand_Category__c;
                    brand.Business_Unit__c = b.Business_Unit__c;
                    
                    listBrandToInsert.add(brand);
                }
            }
        }
        for(Brand__c b : [select id,Name,Brand_Name__c,GES_Congress_Manager__c,Brand_Category__c,Congress_Lead__c,Business_Unit__c,COE_Supported__c,Symposia__c,Createddate,lastmodifieddate,Canceled__c from Brand__c where Symposia__c IN:mapSymposia.keyset()]) {
            if(b.Canceled__c != true){
                Brand__c brand = b.clone(false, true);
                if(mapSymposia.containsKey(b.Symposia__c)){
                    brand.Symposia__c= mapSymposia.get(b.Symposia__c).Id;
                    brand.GES_Connect_Corporate_Accounts__c=gc.Id;
                    brand.Booth_Space_Cost_Estimated__c=null;
                    brand.Booth_Space_Cost_Actual__c=null;
                    brand.Exhibit_Costs_Estimated__c=null;
                    brand.Exhibit_Costs_Actual__c=null;
                    brand.Brand_Team_Contact__c=null;
                    brand.Funding_Provider_Region__c=null;
                    brand.Funding_Provider_Brand__c=null;
                    brand.Funding_Provider_Department__c=null;
                    brand.Cost_Center__c=null;
                    brand.Brand_Name__c = b.Brand_Name__c;
                    brand.Brand_Category__c = b.Brand_Category__c;
                    brand.Business_Unit__c = b.Business_Unit__c;
                    
                    listBrandToInsert.add(brand);
                }
            }
        }
        for(Brand__c b : [select id,Name,Brand_Name__c,GES_Congress_Manager__c,Brand_Category__c,Congress_Lead__c,Business_Unit__c,COE_Supported__c,Meeting_Room__c,Createddate,lastmodifieddate,Canceled__c from Brand__c where Meeting_Room__c IN:mapMeetingRoom.keyset()]) {
            if(b.Canceled__c != true){
                Brand__c brand = b.clone(false, true);
                if(mapMeetingRoom.containsKey(b.Meeting_Room__c)){
                    brand.Meeting_Room__c= mapMeetingRoom.get(b.Meeting_Room__c).Id;
                    brand.GES_Connect_Corporate_Accounts__c=gc.Id;
                    brand.Booth_Space_Cost_Estimated__c=null;
                    brand.Booth_Space_Cost_Actual__c=null;
                    brand.Exhibit_Costs_Estimated__c=null;
                    brand.Exhibit_Costs_Actual__c=null;
                    brand.Brand_Team_Contact__c=null;
                    brand.Funding_Provider_Region__c=null;
                    brand.Funding_Provider_Brand__c=null;
                    brand.Funding_Provider_Department__c=null;
                    brand.Cost_Center__c=null;
                    brand.Brand_Name__c = b.Brand_Name__c;
                    brand.Brand_Category__c = b.Brand_Category__c;
                    brand.Business_Unit__c = b.Business_Unit__c;
                    
                    listBrandToInsert.add(brand);
                }
            }
        }
        if(listBrandToInsert.size() > 0) {
            insert listBrandToInsert;
        }
        
        system.debug('Test Data'+gcca.Name_of_Congress__c);
        
        //PageReference Congressdetails1= new PageReference('/apex/Congressdetails?accid=a6Qc00000007lWh');
        PageReference Congressdetails1= new PageReference('/apex/Congressdetails?id='+gc.id);
        // Congressdetails1.getParameters().put('Congress',String.valueOf(a.Name_of_Congress__c));  
        Congressdetails1.setRedirect(true);
        return Congressdetails1;
    }
    
    public PageReference cloneCongress()
        
    {
        
        gc= gcca.clone (false, true);
        gc.Exhibit_Open_Date__c= null;
        gc.Congress_Start_Date__c= null;
        gc.Exhibit_Close_Date__c= null;
        gc.Congress_End_Date__c= null;
        gc.Exhibit_Date_Day_2__c= null;
        gc.Exhibit_Date_Day_3__c= null;
        gc.Exhibit_Date_Day_4__c= null;
        gc.Exhibit_Date_Day1__c= null;
        gc.Exhibit_Hours_Close_Day_1__c= null;
        gc.Exhibit_Hours_Close_Day_2__c= null;
        gc.Exhibit_Hours_Close_Day_3__c= null;
        gc.Exhibit_Hours_Close_Day_4__c= null;
        gc.Exhibit_Hours_Open_Day_1__c= null;
        gc.Exhibit_Hours_Open_Day_2__c= null;
        gc.Exhibit_Hours_Open_Day_3__c= null;
        gc.Exhibit_Hours_Open_Day_4__c= null;
        
        
        return new PageReference(GC_PageUtil.CheckApexDomain() + '/CongressDetailsclone?congressid='+gcca.Id);
        
    }
    
    Public PageReference editCongress()
    {
        
        return new PageReference(GC_PageUtil.CheckApexDomain() + '/Congressedit?congressid='+gcca.Id);
    }
    Public PageReference cancelclone()
    {
        
        return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_ShowCongress?congressid='+gcca.Id);
    }
    public GC_Connect2_Show__c  connShow {get;set;}  
    public PageReference fetchConnect2ShowDetails()
    {
        system.debug('Entered Actions');
        connShow = [SELECT Name, Opportunity_Id__c FROM GC_Connect2_Show__c WHERE Id = : gcca.Show_Name__c];
        system.debug('connect Id'+connShow.Opportunity_Id__c);
        Opportunity ExhbOpp = [SELECT Show_Name__r.Name, Show_Name__r.Show_ID__c, Facility__r.Name, Facility__r.BillingStreet, Facility__r.BillingCity, Facility__r.BillingState, Facility__r.BillingCountry, Facility__r.BillingPostalCode, Show_Open_Date__c, Show_Close_Date__c FROM Opportunity WHERE Id = : connShow.Opportunity_Id__c];
        
        system.debug('connect Id'+connShow.Name);
        gcca.Name_of_Congress__c           = ExhbOpp.Show_Name__r.Name;
        gcca.Acronym_of_Congress__c        = ExhbOpp.Show_Name__r.Show_ID__c;
        gcca.Congress_Website__c           = '';
        gcca.Congress_Type__c              = '';
        
        return null; 
    }
    
    public PageReference copyAssociationValues() {
        system.debug('Entered copyAssociationValues');
        if(gc.Secretariat_Same_as_Association__c == True){                           
            gc.Secretariat_Contact_Email__c = gc.Association_Email__c;
            gc.Secretariat_Contact_Name__c= gc.Association_Contact_Name__c;
            gc.Secretariat_Contact_Phone__c=gc.Association_phone__c;
            gc.Secretariat_Name__c=gc.Association_Name__c;
        }else{
            gc.Secretariat_Contact_Email__c = null;
            gc.Secretariat_Contact_Name__c= null;
            gc.Secretariat_Contact_Phone__c=null;
            gc.Secretariat_Name__c=null;
        }
        
        return null;
    } 
    
    public void onFacilitySelect() {
        List<Account> acc = [select Name, BillingCity,BillingPostalCode,BillingCountry,BillingState,ShippingStreet from account where id=: gc.Facility_Name_Account__c];
        if(acc.size() > 0) {
            gc.Shipping_City__c = acc[0].BillingCity;
            gc.Shipping_Zip_Postal_Code__c= acc[0].BillingPostalCode;
            gc.Shipping_Country__c = acc[0].BillingCountry ;
            gc.Shipping_State_Province__c= acc[0].BillingState; 
            gc.Shipping_Street__c= acc[0].ShippingStreet; 
            gc.Facility_Name__c = acc[0].Name;
        }
        
    }
    
    public void showHousingRequiredFields(){
        if(gc.Housing_Required_PL__c == 'Yes'){
            showHousingFieldsClone = true;
        }
        else{
            showHousingFieldsClone = false;
            gc.Brand_1__c = '';
            gc.Brand_2__c = '';
            gc.Brand_3__c = '';
            gc.Brand_4__c = '';
            gc.Brand_5__c = '';
            gc.Number_of_Rooms_Requested_1__c = 0;
            gc.Number_of_Rooms_Requested_2__c = 0;
            gc.Number_of_Rooms_Requested_3__c = 0;
            gc.Number_of_Rooms_Requested_4__c = 0;
            gc.Number_of_Rooms_Requested_5__c = 0;
        }
    }
    
    public void showHousingLogisticVendorOtherField(){
        if(gc.Housing_Logistics_Vendor__c == 'Other'){
            showHousingLogisticVendorOtherClone = true;
        }
        else{
            gc.Housing_Logistics_Vendor_other__c = '';
            showHousingLogisticVendorOtherClone = false;
        }
    }
    
}