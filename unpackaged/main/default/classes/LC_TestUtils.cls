@isTest
public with sharing class LC_TestUtils{
    public static Opportunity insertOpportunity(){
        RecordType facilityRT = [Select Id, SobjectType, Name From RecordType WHERE Name = 'Facility' and SobjectType = 'Account' limit 1];
        RecordType contractorRT = [Select Id, SobjectType, Name From RecordType WHERE Name = 'Contractor' and SobjectType = 'Account' limit 1];
        RecordType masterShowRT = [Select Id, SobjectType, Name From RecordType WHERE Name = 'Master Show Occurrence' and SobjectType = 'Opportunity' limit 1];
        Account acc = new Account(
            Name = 'Auto Show',
            Phone = '212-460-6659',
            Fax = '212-888-6523',
            BillingStreet = '1201 S Figueroa St.' ,
            BillingCity = '42' ,
            BillingState = 'CA',
            BillingPostalCode = '90015-1308',
            NumberOfEmployees = 500,
            AnnualRevenue = 60000000);
        Account facility = new Account(
            Name = 'Las Vegas Convention Center',
            Phone = '(702) 892-0711',
            Fax = '555-555-5555',
            BillingStreet = '43150 Paradise Rd.',
            BillingCity = '42',
            BillingState = 'NV' ,
            BillingPostalCode = '89109',
            NumberOfEmployees = 200,
            LMS_Facility_ID__c = '123456',
            AnnualRevenue = 20000000,
            RecordTypeId = facilityRT.Id);
        List<Account> accList = new List<Account>();
        accList.add(acc);
        accList.add(facility);
        insert acclist;
        Opportunity opp = new Opportunity(
            //Name = 'LA Auto Show',
            Name = 'New Opportunity',
            AccountId = acc.Id,
            Facility__c = facility.Id,
            CloseDate = System.Today() + 40,
            StageName = 'CV',
            Amount = 30000,
            Show_Start_Date_Time__c = System.Today() + 12,
            Show_End_Date_Time__c = System.Today() + 17,
            Exhibit_Hall_Hours_Day_1__c = '5:00 PM To 8:00 PM',
            Exhibit_Hall_Hours_Day_2__c = '7:00 AM To 6:30 PM',
            Exhibit_Hall_Hours_Day_3__c = '8:00 AM To 4:00 PM',
            Exhibit_Hall_Hours_Day_4__c = '9:00 AM To 10:00 PM',
            Exhibit_Hall_Hours_Day_5__c = '9:00 AM To 10:00 PM',
            Exhibitor_Move_In_Date__c = System.Today() + 11,
            RecordTypeId = masterShowRT.Id,
            Production_Location__c='110- Las Vegas',
            Prime_Contractor__c = acc.Id,
            Move_Out__c = System.Today() + 14);
        insert opp;
        return opp;
    }
    
    public static CA_Main_Event__c insertMainEvent(){
        RecordType mainEventRT = [Select Id, SobjectType, Name From RecordType WHERE Name = 'BMS Main Event' and SobjectType = 'CA_Main_Event__c' limit 1];
        CA_Main_Event__c mainEventObj = new CA_Main_Event__c();
        mainEventObj.Name_of_Event__c = 'Test Event';
        mainEventObj.Event_Acronym__c = 'TE';
        mainEventObj.RecordTypeId = mainEventRT.Id;
        insert mainEventObj;
        return mainEventObj;
        
    }
    
    public static CA_Personalized_Object_Setting__c insertMainEventPersonSetObj(){
        RecordType mainEventRT = [Select Id, SobjectType, Name From RecordType WHERE Name = 'BMS Main Event' and SobjectType = 'CA_Main_Event__c' limit 1];
        CA_Personalized_Object_Setting__c perSetObj = new CA_Personalized_Object_Setting__c();
        perSetObj.Available_Tiles__c = 'Analytics;Congresses;Files';
        perSetObj.Object_Label__c = 'Congress';
        perSetObj.Object_Name__c = 'CA_Main_Event__c';
        perSetObj.Profile_Name__c = 'GC BMS Profile';
        perSetObj.Field_Label_Map__c = '{"apiToFieldSettings":{"Connect2_Show_Lookup__c":{"isRequired":false,"isReadOnly":false,"displayLabel":"Connect2 Show","dataType":"REFERENCE"},"Hotel_4_Country__c":{"isRequired":false,"isReadOnly":false,"displayLabel":"Country","dataType":"STRING"},"Hotel_3_Country__c":{"isRequired":false,"isReadOnly":false,"displayLabel":"Country","dataType":"STRING"},"Hotel_2_Country__c":{"isRequired":false,"isReadOnly":false,"displayLabel":"Country","dataType":"STRING","Name_of_Event__c":{"isRequired":true,"isReadOnly":false,"displayLabel":"Name of Congress","dataType":"STRING"}}}}';
        perSetObj.Number_Of_Sections__c = 2; 
        perSetObj.Record_Type_ID__c = mainEventRT.Id;
        perSetObj.Save_Button_Label__c = 'Save Congress';
        perSetObj.Table_Columns__c = 'Name_of_Event__c,Event_Acronym__c,Event_Start_Date__c,Event_End_Date__c,Event_Cancelled__c';
        perSetObj.Delete_Children__c = false;
        perSetObj.Object_Color__c = '#903e3e00';
        perSetObj.Run_Trigger__c = false;
        perSetObj.Create_Button_Label__c = 'Create';
        perSetObj.Error_Message__c = 'Error Message';
        perSetObj.Global_Button_Style__c = 'Color : white;';
        perSetObj.Save_Button_Label__c = 'Save';
        perSetObj.Success_Message__c = 'Record was Saved';
        perSetObj.Search_Filters__c = 'Name';
        perSetObj.Customer_Logo__c = '';
        insert perSetObj;
        return perSetObj;
    }
    
    public static CA_Personalized_Object_Setting__c insertExhibitPersonSetObj(){
        RecordType mainEventRT = [Select Id, SobjectType, Name From RecordType WHERE Name = 'CA Exhibit BMS' and SobjectType = 'CA_Exhibit__c' limit 1];
        CA_Personalized_Object_Setting__c perSetObj = new CA_Personalized_Object_Setting__c();
        perSetObj.Available_Tiles__c = 'Analytics;Congresses;Files';
        perSetObj.Object_Label__c = 'Exhibit';
        perSetObj.Object_Name__c = 'CA_Exhibit__c';
        perSetObj.Profile_Name__c = 'GC BMS Profile';
        perSetObj.Number_Of_Sections__c = 2;
        perSetObj.Record_Type_ID__c = mainEventRT.Id;
        perSetObj.Save_Button_Label__c = 'Save Congress';
        perSetObj.Table_Columns__c = 'Exhibit_Name__c,Booth_Number__c';
        insert perSetObj;
        return perSetObj;
    }
    
    public static CA_Personalized_Object_Setting__c insertSponsorshipPersonSetObj(){
        RecordType mainEventRT = [Select Id, SobjectType, Name From RecordType WHERE Name = 'BMS Main Event' and SobjectType = 'CA_Sponsorship__c' limit 1];
        CA_Personalized_Object_Setting__c perSetObj = new CA_Personalized_Object_Setting__c();
        perSetObj.Available_Tiles__c = 'Analytics;Congresses;Files';
        perSetObj.Object_Label__c = 'Sponsorship';
        perSetObj.Object_Name__c = 'CA_Sponsorship__c';
        perSetObj.Profile_Name__c = 'GC BMS Profile';
        perSetObj.Number_Of_Sections__c = 2;
        perSetObj.Record_Type_ID__c = mainEventRT.Id;
        perSetObj.Save_Button_Label__c = 'Save Congress';
        perSetObj.Table_Columns__c = 'Sponsorship_Name__c,Name';
        insert perSetObj;
        return perSetObj;
    }
    
    public static CA_Personalized_Object_Setting__c insertSpeakingEngagementPersonSetObj(){
        RecordType mainEventRT = [Select Id, SobjectType, Name From RecordType WHERE Name = 'BMS Main Event' and SobjectType = 'CA_Speaking_Engagement__c' limit 1];
        CA_Personalized_Object_Setting__c perSetObj = new CA_Personalized_Object_Setting__c();
        perSetObj.Available_Tiles__c = 'Analytics;Congresses;Files';
        perSetObj.Object_Label__c = 'Speaking Engagement';
        perSetObj.Object_Name__c = 'CA_Speaking_Engagement__c';
        perSetObj.Profile_Name__c = 'GC BMS Profile';
        perSetObj.Number_Of_Sections__c = 2;
        perSetObj.Record_Type_ID__c = mainEventRT.Id;
        perSetObj.Save_Button_Label__c = 'Save Congress';
        perSetObj.Table_Columns__c = 'Name';
        insert perSetObj;
        return perSetObj;
    }
    
    public static CA_Personalized_Object_Setting__c insertMeetingRoomPersonSetObj(){
        RecordType mainEventRT = [Select Id, SobjectType, Name From RecordType WHERE Name = 'BMS Main Event' and SobjectType = 'CA_Meeting_Room__c' limit 1];
        CA_Personalized_Object_Setting__c perSetObj = new CA_Personalized_Object_Setting__c();
        perSetObj.Available_Tiles__c = 'Analytics;Congresses;Files';
        perSetObj.Object_Label__c = 'Meeting Room';
        perSetObj.Object_Name__c = 'CA_Meeting_Room__c';
        perSetObj.Profile_Name__c = 'GC BMS Profile';
        perSetObj.Number_Of_Sections__c = 2;
        perSetObj.Record_Type_ID__c = mainEventRT.Id;
        perSetObj.Save_Button_Label__c = 'Save Congress';
        perSetObj.Table_Columns__c = 'Name';
        insert perSetObj;
        return perSetObj;
    }
    
    public static CA_Personalized_Object_Setting__c insertMeetingPlanningPersonSetObj(){
        RecordType mainEventRT = [Select Id, SobjectType, Name From RecordType WHERE Name = 'BMS Main Event' and SobjectType = 'CA_Meeting_Planning__c' limit 1];
        CA_Personalized_Object_Setting__c perSetObj = new CA_Personalized_Object_Setting__c();
        perSetObj.Available_Tiles__c = 'Analytics;Congresses;Files';
        perSetObj.Object_Label__c = 'Meeting Planning';
        perSetObj.Object_Name__c = 'CA_Meeting_Planning__c';
        perSetObj.Profile_Name__c = 'GC BMS Profile';
        perSetObj.Number_Of_Sections__c = 2;
        perSetObj.Record_Type_ID__c = mainEventRT.Id;
        perSetObj.Save_Button_Label__c = 'Save Congress';
        perSetObj.Table_Columns__c = 'Name';
        insert perSetObj;
        return perSetObj;
    }
    
    public static CA_Personalized_Object_Setting__c insertProductPersonSetObj(){
        RecordType mainEventRT = [Select Id, SobjectType, Name From RecordType WHERE Name = 'BMS Main Event' and SobjectType = 'CA_Product__c' limit 1];
        CA_Personalized_Object_Setting__c perSetObj = new CA_Personalized_Object_Setting__c();
        perSetObj.Available_Tiles__c = 'Analytics;Congresses;Files';
        perSetObj.Object_Label__c = 'Product';
        perSetObj.Object_Name__c = 'CA_Product__c';
        perSetObj.Profile_Name__c = 'GC BMS Profile';
        perSetObj.Number_Of_Sections__c = 2;
        perSetObj.Record_Type_ID__c = mainEventRT.Id;
        perSetObj.Save_Button_Label__c = 'Save Congress';
        perSetObj.Table_Columns__c = 'Therapeutic_Area__c,Business_Unit';
        insert perSetObj;
        return perSetObj;
    }
    
    
    public static GC_Connect2_Show__c insertShow(string oppId,string oppName){
        GC_Connect2_Show__c newShow = new GC_Connect2_Show__c();
        newShow.Opportunity_Name__c = oppName;
        newShow.Opportunity_Id__c = oppId;
        newShow.Show_Name__c = 'test show';
        newShow.Job_Number__c = '12345';
        newShow.Production_Location__c='71';
        newShow.Show_Start_Date__c = system.today().addDays(-10);
        newShow.Show_End_Date__c = system.today().addDays(-2);
        newShow.Exhibit_Hall_Hours_Day_1__c = '5:00 PM To 8:00 PM';
        newShow.Exhibit_Hall_Hours_Day_2__c = '7:00 AM To 6:30 PM';
        newShow.Exhibit_Hall_Hours_Day_3__c = '8:00 AM To 4:00 PM';
        newShow.Exhibit_Hall_Hours_Day_4__c = '9:00 AM To 10:00 PM';
        //newShow.CreatedById=userinfo.getUserId();
        //newShow.TeamMemberDefaultList__c='shubhashree.joshi@slkgroup.com,';
        insert newShow; 
        return newShow;
    }
    public static GC_Connect2_Show__c insertShow1(string oppId,string oppName){
        GC_Connect2_Show__c newShow1 = new GC_Connect2_Show__c();
        newShow1.Opportunity_Name__c = oppName;
        newShow1.Opportunity_Id__c = oppId;
        newShow1.Show_Name__c = 'test show1';
        newShow1.Job_Number__c = '123456';
        newShow1.Production_Location__c='71';
        newShow1.Show_Start_Date__c = system.today().addDays(-10);
        newShow1.Show_End_Date__c = system.today().addDays(-2);
        newShow1.Exhibit_Hall_Hours_Day_1__c = '5:00 PM To 8:00 PM';
        newShow1.Exhibit_Hall_Hours_Day_2__c = '7:00 AM To 6:30 PM';
        newShow1.Exhibit_Hall_Hours_Day_3__c = '8:00 AM To 4:00 PM';
        newShow1.Exhibit_Hall_Hours_Day_4__c = '9:00 AM To 10:00 PM';
        // newShow1.TeamMemberDefaultList__c='shubhashree.joshi@slkgroup.com,';
        insert newShow1; 
        return newShow1;
    }
    
    public static Id getUserId(string userName){
        User u= new User();
        u=[select Id from User where Name=:userName Limit 1];
        return u.Id;
    }
    
    public static GC_Order__c insertOrder(Id showId){
        GC_Order__c newOrder= new GC_Order__c();
        newOrder.Booth_Area__c='new Booth Area';
        newOrder.Connect2_Show__c=showId;
        newOrder.Delivery_Date_Time__c=system.today().addDays(10);
        newOrder.Completion_Date_Time__c=system.today().addDays(5);
        newOrder.Removal_Date_Time__c=system.today().addDays(15);
        newOrder.Order_Area_Description__c='new order area';
        newOrder.Booth_Area_ID__c = '1390260';
        insert newOrder;
        return newOrder;
    }
    
    public static GC_Show_Attribute__c insertDeptAttributes(Id showId){
        list<RecordType> showAttributerec = [select id from RecordType where sObjecttype ='GC_Show_Attribute__c' and DeveloperName=:'Department'];
        GC_Show_Attribute__c deptAtt = new GC_Show_Attribute__c();
        deptAtt.Name='Test Department attribut1';
        deptAtt.RecordTypeId=showAttributerec[0].Id; //'012400000005hkmAAA';
        deptAtt.Connect2_Show__c=showId;
        insert deptAtt;
        return  deptAtt;
    }
    
    public static GC_Show_Attribute__c insertVenueAttributes(Id showId){
        list<RecordType> showAttributeVenuerec = [select id from RecordType where sObjecttype ='GC_Show_Attribute__c' and DeveloperName=:'Venue_Location'];
        GC_Show_Attribute__c venueAtt = new GC_Show_Attribute__c();
        venueAtt.Name='Test Venue attribut1';
        venueAtt.RecordTypeId=showAttributeVenuerec[0].Id;//'012400000005hkrAAA';
        venueAtt.Connect2_Show__c=showId;
        insert venueAtt;
        return venueAtt;
    }
    
    public static GC_Show_Attribute__c insertServiceAttributes(Id showId){
        list<RecordType> showAttributeServicerec = [select id from RecordType where sObjecttype ='GC_Show_Attribute__c' and DeveloperName=:'Show_Service'];
        GC_Show_Attribute__c serviceAtt = new GC_Show_Attribute__c();
        serviceAtt.Name='Test Service attribut1';
        serviceAtt.RecordTypeId=showAttributeServicerec[0].Id;//'012400000005hkoAAA';
        serviceAtt.Connect2_Show__c=showId;
        insert serviceAtt;
        return serviceAtt;
    }
    
    public static GC_GES_Order_Task__c insertGOT(Id orderId,Id venueId,Id departmentId){
        GC_GES_Order_Task__c gesOT= new GC_GES_Order_Task__c();
        gesOT.Order__c=orderId;
        gesOT.Delivery_Location__c='Test GES Delivery Location';
        gesOT.Status__c='Approved';
        gesOT.Item_Number__c = '900025';
        gesOT.UOM__c = 'SF';
        gesOT.Description__c = 'Test Description';
        gesOT.Item_Template__c = 'Carpet';
        gesOT.Carpet_Length__c = 100;
        gesOT.Carpet_Width__c = 100;
        gesOT.QuantityNum__c = 10000;
        gesOT.Electrical_Ordered__c = true;
        gesOT.Electrical_Under__c = false;
        gesOT.Department__c=departmentId;
        gesOT.SA_Venue_Location__c=venueId;
        gesOT.Onsite_Contact_Person_Other__c='Onsite Contact Person Other';
        insert gesOT;
        return gesOT;
    }
    public static GC_GES_Order_Task__c insertGOT1(Id orderId,Id venueId,Id departmentId){
        GC_GES_Order_Task__c gesOT= new GC_GES_Order_Task__c();
        gesOT.Order__c=orderId;
        gesOT.Delivery_Location__c='Test GES Delivery Location1';
        gesOT.Status__c='New';
        gesOT.Item_Number__c = '100052';
        gesOT.Description__c = 'Test Description 1';
        gesOT.Item_Template__c = 'Graphics';
        gesOT.Save_Signs__c = 'Yes';
        gesOT.GOT_Sign_Type__c = 'Aisle Sign';
        gesOT.GOT_Sign_Type_Other__c = 'Test Sign Type';
        gesOT.QuantityNum__c = 15;
        gesOT.Installation_Method__c = '1M Eco Cardboard';
        gesOT.Department__c = departmentId;
        gesOT.SA_Venue_Location__c=venueId;
        gesOT.Onsite_Contact_Person_Other__c='Onsite Contact Person Other 1';
        insert gesOT;
        return gesOT;
    }
    public static GC_Vendor_Order_Task__c insertVOT(Id orderId,Id serviceAttributeId){
        GC_Vendor_Order_Task__c vendorOT= new GC_Vendor_Order_Task__c();
        vendorOT.Order__c=orderId;
        vendorOT.Vendor__c=userInfo.getUserId();
        vendorOT.Service_Type__c=serviceAttributeId;
        vendorOT.Service_Type2__c=serviceAttributeId;
        vendorOT.Service_Type3__c=serviceAttributeId;
        vendorOT.Service_Type4__c=serviceAttributeId;
        vendorOT.Service_Type5__c=serviceAttributeId;
        vendorOT.Delivery_Date_Time_Ven__c=system.today().addDays(10);
        vendorOT.Completion_Date_Time_Ven__c=system.today().addDays(5);
        vendorOT.Removal_Date_Time_Ven__c=system.today().addDays(20);
        vendorOT.Delivery_Location_Ven__c='votForExistingMethod Location';
        vendorOT.Vendor_Instructions__c = 'Do This';
        vendorOT.Status__c = 'New';
        insert vendorOT;
        return vendorOT;
    }
    public static GC_Show_Team_Member__c insertShowTeamMember(Id attributeId,Id showId){
        User u= new User();
        u=[select Id,Name,Profile.Name,CompanyName from User where Profile.Name='GC Community Client' limit 1];
        GC_Show_Team_Member__c vendor2= new GC_Show_Team_Member__c();
        vendor2.Service_Type__c=attributeId;
        vendor2.Show_Role__c='Show Organizer';
        vendor2.User__c=u.Id;
        vendor2.Connect2_Show__c=showId;
        insert vendor2;
        return vendor2;
    }
    public static GC_Show_Team_Member__c insertShowTeamMember1(Id attributeId,Id showId){
        User u= new User();
        u=[select Id,Name,Profile.Name,CompanyName from User where Profile.Name='GC Community Client' limit 1]; 
        GC_Show_Team_Member__c vendor2= new GC_Show_Team_Member__c();
        vendor2.Service_Type__c=attributeId;
        vendor2.User__c=u.Id;
        vendor2.LastModifiedById=u.Id;
        vendor2.OwnerId=u.Id;
        vendor2.Connect2_Show__c=showId;
        insert vendor2;
        return vendor2;
    }
    
    public static GC_Show_Team_Member__c insertShowTeamMember2(Id attributeId,Id showId){
        User u= new User();
        u=[select Id,Name,Profile.Name,CompanyName from User where Profile.Name='GC Account Manager' limit 1];  
        GC_Show_Team_Member__c vendor2= new GC_Show_Team_Member__c();
        vendor2.Service_Type__c=attributeId;
        vendor2.Show_Role__c='Account Manager';
        vendor2.User__c=u.Id;
        vendor2.Connect2_Show__c=showId;
        insert vendor2;
        return vendor2;
    }
    
    public static GC_Show_Team_Member__c insertShowTeamMember3(Id attributeId,Id showId){
        User u= new User();
        u=[select Id,Name,Profile.Name,CompanyName from User where Profile.Name='GC Graphics Project Manager' limit 1];
        GC_Show_Team_Member__c vendor2= new GC_Show_Team_Member__c();
        vendor2.Service_Type__c=attributeId;
        vendor2.Show_Role__c='Graphics Project Manager';
        vendor2.User__c=u.Id;
        vendor2.Connect2_Show__c=showId;
        insert vendor2;
        return vendor2;
    }
    public static GC_Design_Request_Form__c insertDesignRequestForm(Id showId,Id requesterId){
        list<RecordType> showAttributeServicerec = [select id from RecordType where sObjecttype ='GC_Design_Request_Form__c' and DeveloperName=:'RFP'];
        GC_Design_Request_Form__c requestForm= new GC_Design_Request_Form__c();
        requestForm.Connect2_Show__c=showId;
        requestForm.Status__c='New';
        requestForm.Requester__c=requesterId;
        requestForm.Facility__c='testFacility';
        requestForm.RecordTypeId=showAttributeServicerec[0].Id;//'012400000005hkiAAA';//recordTypeName=RFP (Exhibition or Event)
        insert requestForm;
        return requestForm;
    }
    
    public static GC_Design_Element__c insertDesignElementTask(Id showId){
        GC_Design_Element__c newDE= new GC_Design_Element__c();
        //newDE.Design_Request_Form__c = designRequestFormId;
        newDE.Requester__c = UserInfo.getUserId();
        newDE.Task_Type__c = 'Design';
        newDE.Design_Element__c = 'EntranceForTest';
        newDE.Task_Description__c = 'Test Design Element 2';
        newDE.Deliverable__c = 'Graphics';
        newDE.Status__c = 'New';
        newDE.Active__c=false;
        newDE.Revision__c = 1;
        newDE.LOC1__c = '5678';
        newDE.LOC2__c = '9101';
        newDE.LOC3__c = '1234';
        newDE.Connect2_Show__c=showId;
        insert newDE;
        return newDE;
    }
}