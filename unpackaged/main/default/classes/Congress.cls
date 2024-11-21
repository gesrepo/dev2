Public Class Congress{ 
    public string congid{get;set;}
    public string emailError {get;set;} 
    public string noOfRoomsRequiredError {get;set;} 
    public string BrandError {get;set;}
    public string housingLogisticVendorError {get;set;}
    public string housingLogisticVendorOtherError {get;set;}
    public Boolean showHousingFields{get;set;}
    public Boolean showHousingLogisticVendorOther{get;set;}
    public Boolean style{get;set;}
    public Boolean exStyle{get;set;}
    public String openday1{get;set;}
    public String closeday1{get;set;}
    public String openday2{get;set;}
    public String closeday2{get;set;}
    public String openday3{get;set;}
    public String closeday3{get;set;}
    public String openday4{get;set;}
    public String closeday4{get;set;}
    
    
    public Boolean opendayFlag1{get;set;}
    public Boolean closedayFlag1{get;set;}
    public Boolean opendayFlag2{get;set;}
    public Boolean closedayFlag2{get;set;}
    public Boolean opendayFlag3{get;set;}
    public Boolean closedayFlag3{get;set;}
    public Boolean opendayFlag4{get;set;}
    public Boolean closedayFlag4{get;set;}
    
    
    public GC_Connect2_Show__c  connShow {get;set;}  
    public Congress(ApexPages.StandardController controller) {
        showHousingFields = false;
        style=false;
        exStyle=false;
        openday1='init';
        closeday1='init';
        openday2='init';
        closeday2='init';
        openday3='init';
        closeday3='init';
        openday4='init';
        closeday4='init';
        
        opendayFlag1=false;
        closedayFlag1=false;
        opendayFlag2=false;
        closedayFlag2=false;
        opendayFlag3=false;
        closedayFlag3=false;
        opendayFlag4=false;
        closedayFlag4=false;
        
        showHousingLogisticVendorOther = false;
        connShow = new GC_Connect2_Show__c();
        congid=System.currentPageReference().getParameters().get('congressid'); 
        if (String.isNotBlank(congid)) 
        {
            a = [select id,Name,Show_Name__c,Project_Complete__c,Epa3_Closed_Date__c,Facility_Name_Account__c, Name_of_Congress__c,Shipping_City__c,Shipping_City_c__c,Shipping_Street__c,Shipping_Street_c__c,Congress_Website__c,Congress_Type__c,Congress_End_Date__c,Acronym_of_Congress__c,Exhibit_Close_Date__c,Exhibit_Open_Date__c,Exhibit_Date_Day1__c,
                 Exhibit_Hours_Open_Day_1__c,Exhibit_Hours_Close_Day_1__c,Exhibit_Date_Day_2__c,Exhibit_Hours_Open_Day_2__c,Exhibit_Hours_Close_Day_2__c,Exhibit_Date_Day_3__c,Exhibit_Hours_Open_Day_3__c,Exhibit_Hours_Close_Day_3__c,Exhibit_Date_Day_4__c,
                 Exhibit_Hours_Open_Day_4__c,Exhibit_Hours_Close_Day_4__c,GES_Account_Executive__c,GES_Account_Manager__c,GES_Project_Manager__c,GES_Meeting_Planner__c,Association_Name__c,Association_Contact_Name__c,
                 Association_phone__c,Association_Email__c,Shipping_Zip_Postal_Code__c,Shipping_Zip_Postal_Code_c__c,General_Contractor_Name__c,General_Contractor_Contact_Name__c,Congress_Start_Date__c,General_Contractor_Phone__c,General_Contractor_Website__c,Facility_Name__c,
                 Shipping_State_Province__c,Shipping_Country__c,Advanced_Warehouse_Location_Name__c,Shipping_State_Province_c__c,Shipping_Country_c__c,Housing_Logistics_Vendor__c,Housing_Logistics_Vendor_Other__c,
                 Housing_Contact__c,Housing_Contact_Phone__c,Congress_Cancelled__c,Reason_for_Cancellation__c,Congress_Cancellation_Date__c,Housing_Contact_e_mail__c,AssociationHousing_Website_Portal_Log_In__c,Housing_Opens__c,Housing_Deadline__c,Number_of_rooms_to_Secure__c,Number_of_rooms_Secured__c,Room_Block_Start_Date__c,Room_Block_end_Date__c,Deposit_Paid__c,
                 Hotel_1_Name__c,Hotel_1_room_rate__c,Hotel_1_cancellation_date__c,Hotel_1_cancellation_policy__c,Hotel_2_Name__c,Hotel_2_room_rate__c,Hotel_2_cancellation_date__c,Hotel_2_cancellation_policy__c,Hotel_3_Name__c,Hotel_3_room_rate__c,Hotel_3_cancellation_date__c,Hotel_3_cancellation_policy__c,
                 Ancillary_Meeting_Space_Required__c,Number_of_Meeting_Rooms__c,Meeting_Room_1_Date__c,Meeting_Room_1_Time__c,Meeting_Room_1_Location__c,Meeting_Room_1_Number__c,Funding_Owner__c,Cost_Center__c,Meeting_Room_2_Date__c,Meeting_Room_2_Time__c,Meeting_Room_2_Location__c,Meeting_Room_2_Number__c,
                 Funding_Owner_O__c,Cost_Center_c__c,Registration_Website__c,Complimentary_Badges__c,Badges_Required__c,Cost_center_for_additional_badges__c,CSI_Received__c,Application_Status__c,PO_Status__c,GES_Final_Invoice_Received__c,FCPA_Status__c, Payment_Status_Type__c, 
                 Epa3_Closed__c, PO_Closed__c,Notes__c,GES_Project_Number__c,Client_PO__c,Deposit_Invoice_Amount__c,Deposit_Invoice__c,Deposit_Invoice_Date_issued__c,Final_Invoice_Amount__c,Final_Invoice__c,Final_Invoice_Date_issued__c,Payment_Received_Date__c,IDSupervisor__c, 
                 Congress_Level__c, Secretariat_Contact_Email__c, Secretariat_Contact_Name__c, Secretariat_Contact_Phone__c, Secretariat_Name__c, Secretariat_Same_as_Association__c, Congress_Shipping__c, Congress_WHS__c, First_Day_Freight__c, Last_Day_Freight__c, CSI_Received_Date__c, of_HCP_s_in_Attendance__c,
                 FCPA_Received_Date__c, FRF_Received_Date__c,FRF_Status__c, CSI_form_submitted_by_CM__c, Housing_Notes__c, Reason_RE_not_used__c, Social_Media_Utilized__c, Social_Media_Used__c, Quantity_of_Staffers__c,Staffing_Strategy__c,Congress_Occurence__c,Pfizer_Previously_Attended__c, Planning_Commenced__c,Sales_Direct_to_GES__c,Housing_Required_PL__c,
                 Date_Legal_Reached_Out__c, GES_Paid__c, GES_Paid_Date__c,Number_of_Attendees__c,If_not_appropriate_audience_Explanation__c, FRF_Approval__c, Budget_Status__c, Legal_Reached_out_to_Assoc__c,Brand_Approval__c,GES_Proposal_Received__c,Total_No_of_Rooms_Req__c ,Brand_1__c,Brand_2__c,Brand_3__c,Brand_4__c,Brand_5__c,Number_of_Rooms_Requested_1__c,
                 Number_of_Rooms_Requested_2__c,Number_of_Rooms_Requested_3__c,Number_of_Rooms_Requested_4__c,Number_of_Rooms_Requested_5__c,Reality_Engineering_Utilized__c, NonShowPRJ__c, Event_Type__c, Assoc_Activity_Type_offered__c, Assoc_Provided_Data__c, Exhibit_Hall_Registrants__c, Active_Registrants__c, Congress_Registrants__c  
                 from GES_Connect_Corporate_Accounts__c where id=:congid];
            // removed , for SCA-726 rsinha               
            if(a.Housing_Required_PL__c==null)
                a.Housing_Required_PL__c='No';
            
            if(a.Housing_Required_PL__c == 'Yes'){
                showHousingFields = true;
            }
            
            if(a.Housing_Logistics_Vendor__c == 'Other'){
                showHousingLogisticVendorOther = true;
            }
            
            
            
            
        }
        
    }
    
    /*****************Custom Popup************************/
    public String accountName {get; set;}
    public Id accountId {get; set;}
    public String query {get; set;}
    public string domainName {get; set;}
    public List<Account> accounts {get; set;}
    public Congress() {
        accounts = new List<Account>();
        String facilityName = apexpages.currentpage().getparameters().get('facilityName');
        if(facilityName != '' && facilityName != null) {
            query = facilityName;
            runQuery();
        }
    }
    public PageReference runQuery(){
        //List<RecordType> facilityRecordType = [SELECT DeveloperName,Id,SobjectType FROM RecordType WHERE DeveloperName = 'Facility' AND SobjectType = 'Account'];
        //Id facilityRTId = facilityRecordType[0].Id;
        List<List<Account>> searchResults=[FIND :query IN ALL FIELDS RETURNING Account (id, name, billingstreet, billingcity, billingpostalcode where recordType.DeveloperName = 'Facility')];
        accounts=searchResults[0];
        return null;
    }
    /*****************Custom Popup Till Here************************/
    
    GES_Connect_Corporate_Accounts__c a=new GES_Connect_Corporate_Accounts__c();    
    Public GES_Connect_Corporate_Accounts__c geta(){
        return a;
    }
    Public PageReference Congressedit(){
        emailError = '';
        BrandError = '';
        noOfRoomsRequiredError = '';
        housingLogisticVendorError = '';
        
        system.debug('Congress Start date'+a.Congress_Start_Date__c);
        String facilityId = String.valueof(a.Facility_Name_Account__c);
        if(a.Facility_Name__c == null || a.Facility_Name__c == '') {
            emailError = 'Error: You must enter a value';
            return null;
        }
        if((a.Brand_1__c == Null || a.Brand_1__c == '') && a.Housing_Required_PL__c == 'Yes'){
            BrandError = 'Error: This field cannot be empty';
            return null;
        }
        if(a.Number_of_Rooms_Requested_1__c < 1 && a.Housing_Required_PL__c == 'Yes'){
            noOfRoomsRequiredError = 'Error: This field cannot be 0';
            return null;
        }
        if((a.Housing_Logistics_Vendor_Other__c == '' || a.Housing_Logistics_Vendor_Other__c == null) && a.Housing_Logistics_Vendor__c == 'Other'){
            housingLogisticVendorOtherError = 'Error: You must enter a value';
            return null;
        }
        if(a.Housing_Required_PL__c == 'Yes' &&(a.Housing_Logistics_Vendor__c == null || a.Housing_Logistics_Vendor__c == '' || a.Housing_Logistics_Vendor__c == '--None--')){
            housingLogisticVendorError = 'Error : please select a value here';
            return null;
        }
        
        
        
        upsert a;
        system.debug('Data'+a.id);
        PageReference Congressdetails= new PageReference('/apex/Congressdetails');
        Congressdetails.getParameters().put('id',String.valueOf(a.id));
        Congressdetails.getParameters().put('connect2show',String.valueOf(connShow.Name));  
        Congressdetails.setRedirect(true);
        return Congressdetails;
    }
    public PageReference cancelAction() {
        if(String.isNotBlank(congid))
        {
            return new PageReference(GC_PageUtil.CheckApexDomain() + '/Congressdetails?id='+congid);
        }
        else{
            return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_ShowCongress');
        }
    }
    public String getSaveTitle() {
        return 'Saves the current Congress. Returns to the Congress view page.';
    }
    public String getCancelTitle() {
        return 'Cancels the current page edit and returns back to the List Of Congress Home Page.';
    }
    
    public PageReference fetchConnect2ShowDetails(){
        if(a.Show_Name__c != null){
            system.debug('Entered Actions');
            connShow = [SELECT Name, Opportunity_Id__c FROM GC_Connect2_Show__c WHERE Id = : a.Show_Name__c];
            system.debug('connect Id'+connShow.Opportunity_Id__c);
            Opportunity ExhbOpp = [SELECT Show_Name__r.Name, Show_Name__r.Show_ID__c, Facility__c, Facility__r.Name, Facility__r.BillingStreet, Facility__r.BillingCity, Facility__r.BillingState, Facility__r.BillingCountry, Facility__r.BillingPostalCode, Show_Open_Date__c, Show_Close_Date__c FROM Opportunity WHERE Id = : connShow.Opportunity_Id__c];
            
            system.debug('connect Id'+connShow.Name);
            a.Name_of_Congress__c           = ExhbOpp.Show_Name__r.Name;
            a.Acronym_of_Congress__c        = ExhbOpp.Show_Name__r.Show_ID__c;
            a.Exhibit_Open_Date__c          = ExhbOpp.Show_Open_Date__c; 
            a.Exhibit_Close_Date__c         = ExhbOpp.Show_Close_Date__c;
            a.Facility_Name__c              = ExhbOpp.Facility__r.Name;
            
        }
        return null; 
    }
    
    public void onFacilitySelect() {
        List<Account> acc = [select Name, BillingCity,BillingPostalCode,BillingCountry,BillingState,ShippingStreet from account where id=: a.Facility_Name_Account__c];
        if(acc.size() > 0) {
            a.Shipping_City__c = acc[0].BillingCity;
            a.Shipping_Zip_Postal_Code__c= acc[0].BillingPostalCode;
            a.Shipping_Country__c = acc[0].BillingCountry ;
            a.Shipping_State_Province__c= acc[0].BillingState; 
            a.Shipping_Street__c= acc[0].ShippingStreet; 
            a.Facility_Name__c = acc[0].Name;
        }
        
    }
    
    public PageReference copyAssociationValues() {
        system.debug('Entered copyAssociationValues');
        if(a.Secretariat_Same_as_Association__c == True){                           
            a.Secretariat_Contact_Email__c = a.Association_Email__c;
            a.Secretariat_Contact_Name__c= a.Association_Contact_Name__c;
            a.Secretariat_Contact_Phone__c=a.Association_phone__c;
            a.Secretariat_Name__c=a.Association_Name__c;
        }else{
            a.Secretariat_Contact_Email__c = null;
            a.Secretariat_Contact_Name__c= null;
            a.Secretariat_Contact_Phone__c=null;
            a.Secretariat_Name__c=null;
        }
        
        return null;
    }
    
    public PageReference updateDate(){
        System.debug('inside edit');
        if(a.Epa3_Closed__c)
            a.Epa3_Closed_Date__c=date.Today();
        else
            a.Epa3_Closed_Date__c=null;
        return null;
    }
    
    public PageReference updateCancelledDate(){
        if(a.Congress_Cancelled__c){
            a.Congress_Cancellation_Date__c=date.Today();
        }
        else{
            a.Congress_Cancellation_Date__c=null;
            a.Reason_for_Cancellation__c=null;
        }
        return null;
    }
    
    
    
    public void showHousingRequiredFields(){
        showHousingFields = false;
        system.debug('>>>>>>>>>>' + a.Housing_Required_PL__c);
        if(a.Housing_Required_PL__c == 'Yes'){
            showHousingFields = true;
            system.debug('>>>>>>>>>>' + showHousingFields);
        }
        else{
            showHousingFields = false;
            a.Brand_1__c = '';
            a.Brand_2__c = '';
            a.Brand_3__c = '';
            a.Brand_4__c = '';
            a.Brand_5__c = '';
            a.Number_of_Rooms_Requested_1__c = 0;
            a.Number_of_Rooms_Requested_2__c = 0;
            a.Number_of_Rooms_Requested_3__c = 0;
            a.Number_of_Rooms_Requested_4__c = 0;
            a.Number_of_Rooms_Requested_5__c = 0;
            a.Housing_Logistics_Vendor__c='';
            a.Housing_Logistics_Vendor_Other__c='';
            showHousingLogisticVendorOther=false;
        }
    }
    
    public void showHousingLogisticVendorOtherField(){
        if(a.Housing_Logistics_Vendor__c == 'Other'){
            showHousingLogisticVendorOther = true;
        }
        else{
            a.Housing_Logistics_Vendor_other__c = '';
            showHousingLogisticVendorOther = false;
        }
    }
    
    
    
    
    
    
}