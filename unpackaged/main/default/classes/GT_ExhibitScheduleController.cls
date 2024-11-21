public class GT_ExhibitScheduleController {
    
    /**
* @Author   :		Karthik Nagaraj
* @Date		:		21-Sept-2018
* @Desc		:		Controller for GT_ExhibitSchedule Lightning Component
* */
    
    public static Date eventFromDate {get;set;}
    public static Date eventToDate {get;set;}
    public static Set<string> setCountryNames = new Set<String>();
    public static List<string> listCountryNames = new List<String>();
    public static Set<string> setBrandNames = new Set<String>();
    public static List<string> listBrandNames;
    public static String customerName = '';
    
    //Navigation variables
    static Integer totalSize =0; //To Store the total number of records available
    
    @AuraEnabled
    public static Generic_Template_Setting__mdt getConnectSettings() {
        
        Id profileId = userinfo.getProfileId();
        String profileName = [SELECT Id, Name FROM Profile WHERE Id=:profileId].Name;
        
        switch on profileName {
            when 'GC Crown Castle' {
                customerName = 'Crown Castle';
            }
            when 'GC Novo Nordisk' {
                customerName = 'Novo Nordisk';
            }
            when 'GC Pharma Template' {
                customerName = 'Pharma Template';
            }
            when 'GC Merck' {
                customerName = 'Merck';
            }
            when 'GC Sig Sauer' {
                customerName = 'Sig Sauer';
            }
            when else {
                customerName = 'Generic Template';
            }
        }
        List<Generic_Template_Setting__mdt> customSettings = [SELECT Program_Name__c,Customer_Name__c FROM Generic_Template_Setting__mdt WHERE Customer_Name__c =: customerName LIMIT 1]; 
        return customSettings[0]; 
    }
    
    /*@AuraEnabled
public static List<String> fetchBrandNames(){ 
listBrandNames.sort();
return listBrandNames;
}*/
    
    @AuraEnabled
    public static List<String> fetchCountryNames(){ 
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = GT_Event__c.Shipping_Country__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        } 
        //system.debug(pickListValuesList);
        return pickListValuesList;
    }
    @AuraEnabled
    public static List<String> fetchBusinessUnitCategory(){
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = GT_Brand__c.Product_Category_CrownCastle__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        } 
        //system.debug(pickListValuesList);
        return pickListValuesList;
    }
    
    
    @AuraEnabled
    public static list<exhibitListWrapper> fetchReports(String eFromDate, String eToDate, String customerNameFromJSCtrl){
        customerName = customerNameFromJSCtrl;
        listBrandNames = new List<String>();
        eventFromDate = String.isBlank(eFromDate)? null: date.valueOf(eFromDate);
        eventToDate = String.isBlank(eToDate)? null: date.valueOf(eToDate);
        
        List<exhibitListWrapper> listDispWrapper = new List<exhibitListWrapper>();
        
        listDispWrapper = loadExhibitschDatabrand();
        
        // System.debug('dispWrapper==============' + listDispWrapper);
        
        for(integer i=0;i<listDispWrapper.size();i++){
            list<string> splitBrandNames = listDispWrapper[i].brands.split(',');
            //list<string> splitCountryNames = listDispWrapper[i].country.split(',');
            //setCountryNames.addAll(splitCountryNames);
            
        }
        //listCountryNames.addAll(setCountryNames);
        //system.debug(listDispWrapper);*/
        return listDispWrapper;
    }
    
    public static List<exhibitListWrapper> loadExhibitschDatabrand() {
        Boolean falseValue = false	;
        List<exhibitListWrapper> listDispWrapper = new List<exhibitListWrapper>();
        Set<Id> setGCEventIds = new Set<Id>();
        Map<Id, List<GT_Exhibit__c>> mapExhibit = new Map<Id, List<GT_Exhibit__c>>();
        Map<Id, List<GT_Sponsorship__c>> mapSponsorship = new Map<Id, List<GT_Sponsorship__c>>();
        Map<Id, List<GT_Speaking_Engagement__c>> mapSpkingEngmnt = new Map<Id, List<GT_Speaking_Engagement__c>>();
        Map<Id, List<GT_Meeting_Room__c>> mapMeetingRoom = new Map<Id, List<GT_Meeting_Room__c>>();
        Map<Id, List<GT_Event_RL__c>> mapEventRL = new Map<Id, List<GT_Event_RL__c>>();
        Map<Id, List<GT_Reg_Attend_Only__c>> mapRegAttend = new Map<Id, List<GT_Reg_Attend_Only__c>>();
        Map<Id, List<GT_Membership__c>> memberMap = new Map<Id, List<GT_Membership__c>>();
        Map<Id, List<GT_Sporting_Event__c>> spEventMap = new Map<Id, List<GT_Sporting_Event__c>>();
        
        String exhibitQuery = exhibitQuery();
        exhibitQuery+= filterQuery();
        
        
        List<GT_Exhibit__c> exhibitList = Database.query(exhibitQuery);
        for(GT_Exhibit__c e : exhibitList) {
            setGCEventIds.add(e.GES_Connect_Event__c);
            if(!mapExhibit.containsKey(e.GES_Connect_Event__c)) {
                mapExhibit.put(e.GES_Connect_Event__c, new List<GT_Exhibit__c>());
            }
            mapExhibit.get(e.GES_Connect_Event__c).add(e);
        }
        
        //Get Sponsorship Record
        String sponsorshipQuery = sponsorshipQuery();
        if(eventFromDate != null) {
            sponsorshipQuery += ' AND GES_Connect_Event__r.Event_Start_Date__c >=: eventFromDate';
        } 
        else if(eventToDate != null) {
            sponsorshipQuery += ' AND GES_Connect_Event__r.Event_End_Date__c <=: eventToDate';
        }
        sponsorshipQuery += ' order by GES_Connect_Event__r.Event_Start_Date__c limit 10000';
        
        List<GT_Sponsorship__c> listSponsorship = Database.query(sponsorshipQuery);
        for(GT_Sponsorship__c e : listSponsorship) {
            setGCEventIds.add(e.GES_Connect_Event__c);
            if(!mapSponsorship.containsKey(e.GES_Connect_Event__c)) {
                mapSponsorship.put(e.GES_Connect_Event__c, new List<GT_Sponsorship__c>());
            }
            mapSponsorship.get(e.GES_Connect_Event__c).add(e);
        }
        
        //Get Speaking Engagement Record
        String spkingEngmntQuery = spkingEngmntQuery();
        if(eventFromDate != null) {
            spkingEngmntQuery += ' AND GES_Connect_Event__r.Event_Start_Date__c >=: eventFromDate';
        } 
        else if(eventToDate != null) {
            spkingEngmntQuery += ' AND GES_Connect_Event__r.Event_End_Date__c <=: eventToDate';
        }
        spkingEngmntQuery += ' order by GES_Connect_Event__r.Event_Start_Date__c';
        
        List<GT_Speaking_Engagement__c> listspkingEngmnt = Database.query(spkingEngmntQuery);
        for(GT_Speaking_Engagement__c e : listspkingEngmnt) {
            setGCEventIds.add(e.GES_Connect_Event__c);
            if(!mapSpkingEngmnt.containsKey(e.GES_Connect_Event__c)) {
                mapSpkingEngmnt.put(e.GES_Connect_Event__c, new List<GT_Speaking_Engagement__c>());
            }
            mapSpkingEngmnt.get(e.GES_Connect_Event__c).add(e);
        }
        
        //Get Meeting Room Record
        String meetingRoomQuery = meetingRoomQuery();
        if(eventFromDate != null) {
            meetingRoomQuery += ' AND GES_Connect_Event__r.Event_Start_Date__c >=: eventFromDate';
        } 
        else if(eventToDate != null) {
            meetingRoomQuery += ' AND GES_Connect_Event__r.Event_End_Date__c <=: eventToDate';
        }
        meetingRoomQuery += ' order by GES_Connect_Event__r.Event_Start_Date__c';
        
        List<GT_Meeting_Room__c> listMeetingRoom = Database.query(meetingRoomQuery);
        for(GT_Meeting_Room__c e : listMeetingRoom) {
            setGCEventIds.add(e.GES_Connect_Event__c);
            
            if(!mapMeetingRoom.containsKey(e.GES_Connect_Event__c)) {
                mapMeetingRoom.put(e.GES_Connect_Event__c, new List<GT_Meeting_Room__c>());
            }
            mapMeetingRoom.get(e.GES_Connect_Event__c).add(e);
        }
        
        //Get Event(RL) Record
        String eventQuery = eventQuery();
        if(eventFromDate != null) {
            eventQuery += ' AND GES_Connect_Event__r.Event_Start_Date__c >=: eventFromDate';
        } 
        else if(eventToDate != null) {
            eventQuery += ' AND GES_Connect_Event__r.Event_End_Date__c <=: eventToDate';
        }
        eventQuery += ' order by GES_Connect_Event__r.Event_Start_Date__c';
        
        List<GT_Event_RL__c> listEvent = Database.query(eventQuery);
        for(GT_Event_RL__c e : listEvent) {
            setGCEventIds.add(e.GES_Connect_Event__c);
            if(!mapEventRL.containsKey(e.GES_Connect_Event__c)) {
                mapEventRL.put(e.GES_Connect_Event__c, new List<GT_Event_RL__c>());
            }
            mapEventRL.get(e.GES_Connect_Event__c).add(e);
        }
        
        //Get Registration/Attend Only Record
        
        String regAttendOnlyQuery = regAttendOnlyQuery();
        if(eventFromDate != null) {
            regAttendOnlyQuery += ' AND GES_Connect_Event__r.Event_Start_Date__c >=: eventFromDate';
        } 
        else if(eventToDate != null) {
            regAttendOnlyQuery += ' AND GES_Connect_Event__r.Event_End_Date__c <=: eventToDate';
        }
        regAttendOnlyQuery += ' order by GES_Connect_Event__r.Event_Start_Date__c limit 10000';
        
        List<GT_Reg_Attend_Only__c> listRegAttendOnly = Database.query(regAttendOnlyQuery);
        
        for(GT_Reg_Attend_Only__c e : listRegAttendOnly) {
            setGCEventIds.add(e.GES_Connect_Event__c);
            if(!mapRegAttend.containsKey(e.GES_Connect_Event__c)) {
                mapRegAttend.put(e.GES_Connect_Event__c, new List<GT_Reg_Attend_Only__c>());
            }
            mapRegAttend.get(e.GES_Connect_Event__c).add(e);
        }
        
        //Membership Record
        String memberQuery = membershipQuery();
        if(eventFromDate != null) {
            memberQuery += ' AND GES_Connect_Event__r.Event_Start_Date__c >=: eventFromDate';
        } 
        else if(eventToDate != null) {
            memberQuery += ' AND GES_Connect_Event__r.Event_End_Date__c <=: eventToDate';
        }
        memberQuery += ' order by GES_Connect_Event__r.Event_Start_Date__c limit 10000';
        
        List<GT_Membership__c> memberList = Database.query(memberQuery);
        //System.debug('memberList>>>>>'+memberList);
        for(GT_Membership__c e : memberList) {
            setGCEventIds.add(e.GES_Connect_Event__c);
            if(!memberMap.containsKey(e.GES_Connect_Event__c)) {
                memberMap.put(e.GES_Connect_Event__c, new List<GT_Membership__c>());
            }
            memberMap.get(e.GES_Connect_Event__c).add(e);
        }
        //end
        //Sporting Evet
        String spQuery = sportingEventQuery();
        if(eventFromDate != null) {
            spQuery += ' AND GES_Connect_Event__r.Event_Start_Date__c >=: eventFromDate';
        } 
        else if(eventToDate != null) {
            spQuery += ' AND GES_Connect_Event__r.Event_End_Date__c <=: eventToDate';
        }
        spQuery += ' order by GES_Connect_Event__r.Event_Start_Date__c limit 10000';
        
        List<GT_Sporting_Event__c> spList = Database.query(spQuery);
        //System.debug('memberList>>>>>'+memberList);
        for(GT_Sporting_Event__c e : spList) {
            setGCEventIds.add(e.GES_Connect_Event__c);
            if(!spEventMap.containsKey(e.GES_Connect_Event__c)) {
                spEventMap.put(e.GES_Connect_Event__c, new List<GT_Sporting_Event__c>());
            }
            spEventMap.get(e.GES_Connect_Event__c).add(e);
        }
        
        //end
        for(Id eventId : setGCEventIds) {
            
            if(mapExhibit.get(eventId) != null)
            {
                String brandsConcat = '';
                List<String> productFields = new List<String>();
                String BusinessUnitCategory = '';
                String TherapeuticArea = '';
                String BusinessUnitPharma = '';
                String BrandNamePharma = '';
                String Exhibit_Hours_Day_1 = '';
                String Exhibit_Hours_Day_2 = '';
                String Exhibit_Hours_Day_3 = '';
                String Exhibit_Hours_Day_4 = '';
                String ExhibitHours = '';
                String cmConcat = '';
                String clConcat = '';
                String startDate = '';
                String closeDate = '';
                String congressStartDate = '';
                String congressCloseDate = '';
                String Location = '';
                String EventLevel = '';
                String brandTeamContact = '';
                for(GT_Exhibit__c ex: mapExhibit.get(eventId)){
                    
                    if(ex.Brands__r.size() > 0){
                        for(GT_Brand__c br:ex.Brands__r){
                            system.debug('--------------------' + customerName);
                            if(customerName != 'Sig Sauer'){
                                if(br.Brand_Name__c != null && !brandsConcat.contains(br.Brand_Name__c)) {
                                    brandsConcat += br.Brand_Name__c+', ';
                                    system.debug('Inside Brand Cat ?????????????????????????????/');
                                }
                            }
                            
                            if(br.Brand_Team_Contact__c !=null && !brandTeamContact.contains(br.Brand_Team_Contact__c)){
                                brandTeamContact += br.Brand_Team_Contact__c+', ';
                            }
                            
                            if(br.Product_Category_CrownCastle__c !=null){
                                BusinessUnitCategory = br.Product_Category_CrownCastle__c;
                            }
                            
                            if(br.Therapeutic_Area__c !=null && !TherapeuticArea.contains(br.Therapeutic_Area__c)){
                                TherapeuticArea += br.Therapeutic_Area__c+', ';
                            }
                            
                            if(br.Business_Unit_Pharma__c != null && !BusinessUnitPharma.contains(br.Business_Unit_Pharma__c)) {
                                BusinessUnitPharma += br.Business_Unit_Pharma__c+', ';
                            }
                            if(br.Brand_Name_Pharma__c != null && !BrandNamePharma.contains(br.Brand_Name_Pharma__c)) {
                                BrandNamePharma += br.Brand_Name_Pharma__c+', ';
                            }
                        }
                    }
                    if(customerName == 'Sig Sauer'){
                        if(ex.Product__c != null){
                            brandsConcat =  ex.Product__c.replace(';', ',');
                        }
                    }
                    brandsConcat =  brandsConcat.removeEnd(', ');
                    TherapeuticArea =  TherapeuticArea.removeEnd(', ');
                    BusinessUnitPharma =  BusinessUnitPharma.removeEnd(', ');
                    BrandNamePharma =  BrandNamePharma.removeEnd(', ');
                    brandTeamContact = brandTeamContact.removeEnd(', ');
                    
                    productFields.add(brandsConcat);
                    productFields.add(brandTeamContact);
                    productFields.add(ex.GES_Connect_Event__r.Status__c);
                    productFields.add(ex.GES_Connect_Event__r.Housing_Logistics_Vendor__c);
                    productFields.add(ex.On_Site_Staff__c);
                    productFields.add(ex.GES_Connect_Event__r.Congress_Notes__c);
                    productFields.add(ex.GES_Connect_Event__r.US_Ex_US__c);
                    productFields.add(ex.GES_Project_Number_CrownCastle__c);
                    
                    if(ex.GES_Connect_Event__r.Event_Start_Date__c != null){
                        List<String> splitDate = string.valueOf(ex.GES_Connect_Event__r.Event_Start_Date__c).split('-');
                        startDate = splitDate[1]+'/'+splitDate[2]+'/'+splitDate[0];
                    }
                    
                    if(ex.GES_Connect_Event__r.Event_End_Date__c != null){
                        List<String> splitDate1 = string.valueOf(ex.GES_Connect_Event__r.Event_End_Date__c).split('-');
                        closeDate = splitDate1[1]+'/'+splitDate1[2]+'/'+splitDate1[0];
                    }
                    if(ex.GES_Connect_Event__r.Congress_Start_Date__c != null){
                        List<String> splitDate = string.valueOf(ex.GES_Connect_Event__r.Congress_Start_Date__c).split('-');
                        congressStartDate = splitDate[1]+'/'+splitDate[2]+'/'+splitDate[0];
                    }
                    
                    if(ex.GES_Connect_Event__r.Congress_End_Date__c != null){
                        List<String> splitDate1 = string.valueOf(ex.GES_Connect_Event__r.Congress_End_Date__c).split('-');
                        congressCloseDate = splitDate1[1]+'/'+splitDate1[2]+'/'+splitDate1[0];
                    }
                    if(ex.GES_Connect_Event__r.Exhibit_Hours_Day_1__c != null){
                        ExhibitHours += 'Exhibit Hours Day 1 : ' + ex.GES_Connect_Event__r.Exhibit_Hours_Day_1__c;
                    }
                    if(ex.GES_Connect_Event__r.Exhibit_Hours_Day_2__c != null){
                        ExhibitHours += ' ,    ' + 'Exhibit Hours Day 2 : ' + ex.GES_Connect_Event__r.Exhibit_Hours_Day_2__c;
                    }
                    if(ex.GES_Connect_Event__r.Exhibit_Hours_Day_3__c != null){
                        ExhibitHours += ' ,    ' + 'Exhibit Hours Day 3 : ' + ex.GES_Connect_Event__r.Exhibit_Hours_Day_3__c;
                    }
                    if(ex.GES_Connect_Event__r.Exhibit_Hours_Day_4__c != null){
                        ExhibitHours += ' ,    ' + 'Exhibit Hours Day 4 : ' + ex.GES_Connect_Event__r.Exhibit_Hours_Day_4__c;
                    }
                    ExhibitHours.removeStart(' , ');
                    ExhibitHours.removeEnd(' , ');
                    
                    List<String> Locations = new List<String>();
                    
                    if(!String.isBlank(ex.GES_Connect_Event__r.Shipping_City__c)){
                        Locations.add(ex.GES_Connect_Event__r.Shipping_City__c);
                    }
                    if(!String.isBlank(ex.GES_Connect_Event__r.Shipping_State_Province__c)){
                        Locations.add(ex.GES_Connect_Event__r.Shipping_State_Province__c);
                    }
                    if(!String.isBlank(ex.GES_Connect_Event__r.Shipping_Country__c)){
                        if(ex.GES_Connect_Event__r.Shipping_Country__c != 'United States' && ex.GES_Connect_Event__r.Shipping_Country__c != 'US' && ex.GES_Connect_Event__r.Shipping_Country__c != 'USA') {
                            Locations.add(ex.GES_Connect_Event__r.Shipping_Country__c);
                        }
                    }
                    Location = String.join(Locations, ', ');
                    
                    EventLevel = String.isBlank(ex.GES_Connect_Event__r.Congress_Level__c) ? ex.GES_Connect_Event__r.Event_Level__c : ex.GES_Connect_Event__r.Congress_Level__c;
                    
                    ExhibitWrapperParams exWrp = new ExhibitWrapperParams(ex.GES_Connect_Event__r.GES_Supported_Event__c,String.valueOf(ex.Contacts_Made__c)); //SAL-1306 - passing Contacts_Made__c parameter 12/04/23 - Sajid
                    listDispWrapper.Add(new exhibitListWrapper(ex.GES_Connect_Event__r.Name_of_Event__c,
                                                               ex.GES_Connect_Event__r.Name_of_Congress__c,
                                                               ex.GES_Connect_Event__r.Event_Acronym__c,
                                                               ex.GES_Connect_Event__r.Congress_Acronym__c,
                                                               EventLevel,
                                                               ex.GES_Connect_Event__r.Congress_Type__c,
                                                               ex.GES_Connect_Event__r.No_of_HCP_s_in_Attendance__c,
                                                               ex.GES_Connect_Event__r.Congress_Website__c,
                                                               ex.Activity_Level__c,
                                                               ex.GES_Account_Manager__c,
                                                               ex.GES_Account_Executive__c,
                                                               ex.Event_Manager__c,
                                                               ex.Congress_Manager__c,
                                                               ex.GES_Project_Manager__c,
                                                               'Exhibit',
                                                               ex.GES_Connect_Event__r.Shipping_Country__c,
                                                               Location,
                                                               ex.GES_Connect_Event__r.Facility_Name__c,
                                                               ex.Booth_Length__c,
                                                               ex.Booth_Width__c,
                                                               ex.Booth_Number__c,	
                                                               productFields,
                                                               BusinessUnitCategory,
                                                               TherapeuticArea,
                                                               BusinessUnitPharma,
                                                               BrandNamePharma,
                                                               ExhibitHours,
                                                               startDate,
                                                               congressStartDate,
                                                               closeDate,
                                                               congressCloseDate,
                                                               exWrp
                                                              ));
                    brandsConcat = '';
                    BusinessUnitCategory = '';
                }
            }
            
            //Sponsorship Activity Type
            if(mapSponsorship.get(eventId) != null) {
                List<exhibitListWrapper> dispSponsorshipWrapper = populateSponsorshipWrapperValues(mapSponsorship.get(eventId));
                if(dispSponsorshipWrapper.size() > 0) {
                    listDispWrapper.addAll(dispSponsorshipWrapper);
                }
            }
            //Sponsorship Activity Type Till here
            
            //Speaking Engagement Activity Type
            if(mapSpkingEngmnt.get(eventId) != null) {
                List<exhibitListWrapper> dispspkingEngmntWrapper = populateSpkingEngmntWrapperValues(mapSpkingEngmnt.get(eventId));
                if(dispspkingEngmntWrapper.size() > 0) {
                    listDispWrapper.addAll(dispspkingEngmntWrapper);
                }
            }
            //Speaking Engagement Activity Type Till here
            
            //Meeting Room Activity Type
            if(mapMeetingRoom.get(eventId) != null) {
                List<exhibitListWrapper> dispMeetingRoomWrapper = populateMRWrapperValues(mapMeetingRoom.get(eventId));
                if(dispMeetingRoomWrapper.size() > 0) {
                    listDispWrapper.addAll(dispMeetingRoomWrapper);
                }
            }
            //Meeting Room Activity Type Till here
            
            //Event Activity Type
            if(mapEventRL.get(eventId) != null) {
                List<exhibitListWrapper> dispEventWrapper = populateEventWrapperValues(mapEventRL.get(eventId));
                if(dispEventWrapper.size() > 0) {
                    listDispWrapper.addAll(dispEventWrapper);
                }
            }
            //Event Activity Type Till here
            
            //Registration/Attend Only Activity Type
            if(mapRegAttend.get(eventId) != null) {
                List<exhibitListWrapper> dispRegAttendWrapper = populateRegAttendOnlyValues(mapRegAttend.get(eventId));
                if(dispRegAttendWrapper.size() > 0) {
                    listDispWrapper.addAll(dispRegAttendWrapper);
                }
            }
            
            //Registration/Attend Only Activity Type Till here
            //Membership
            if(memberMap.get(eventId) != null) {
                List<exhibitListWrapper> dispMemberwrap = populateMembership(memberMap.get(eventId));
                if(dispMemberwrap.size() > 0) {
                    listDispWrapper.addAll(dispMemberwrap);
                }
            }
            
            //Sporting Event
            if(spEventMap.get(eventId) != null) {
                List<exhibitListWrapper> spWrap = populateSportingEvet(spEventMap.get(eventId));
                if(spWrap.size() > 0) {
                    listDispWrapper.addAll(spWrap);
                }
            }
        }
        return listDispWrapper;
    }
    
    
    public static string exhibitQuery() {
        String exhibitQuery = 'Select Contacts_Made__c, GES_Connect_Event__c, GES_Connect_Event__r.Event_Level__c, GES_Connect_Event__r.Congress_Notes__c, GES_Connect_Event__r.Status__c,Product__c,GES_Connect_Event__r.Housing_Logistics_Vendor__c, Event_Manager__c, GES_Connect_Event__r.Name_of_Event__c,GES_Connect_Event__r.Name_Of_Congress__c, GES_Connect_Event__r.Congress_Acronym__c, GES_Connect_Event__r.Congress_Start_Date__c, GES_Connect_Event__r.Congress_End_Date__c, GES_Connect_Event__r.Event_Acronym__c, GES_Connect_Event__r.GES_Supported_Event__c,'; 
        exhibitQuery += ' Activity_Level__c, GES_Project_Number_CrownCastle__c, On_Site_Staff__c, Exhibit_Name__c, GES_Project_Manager__c, Congress_Manager__c, GES_Connect_Event__r.Congress_Level__c, GES_Connect_Event__r.Congress_Type__c, GES_Connect_Event__r.No_of_HCP_s_in_Attendance__c, GES_Connect_Event__r.Congress_Website__c, GES_Connect_Event__r.Event_Start_Date__c, GES_Connect_Event__r.Event_End_Date__c, GES_Connect_Event__r.Shipping_City__c, GES_Account_Manager__c, GES_Account_Executive__c, Project_Manager_CrownCastle__c, ';
        
        exhibitQuery += ' GES_Connect_Event__r.Shipping_State_Province__c, GES_Connect_Event__r.US_Ex_US__c, GES_Connect_Event__r.Shipping_Country__c, GES_Connect_Event__r.Facility_Name__c, Booth_Length__c, Booth_Width__c, Booth_Number__c, GES_Connect_Event__r.GES_Account_Manager__c,';
        
        exhibitQuery += ' GES_Connect_Event__r.GES_Meeting_Planner__c,GES_Connect_Event__r.Exhibit_Hours_Day_1__c, GES_Connect_Event__r.Exhibit_Hours_Day_2__c, GES_Connect_Event__r.Exhibit_Hours_Day_3__c, GES_Connect_Event__r.Exhibit_Hours_Day_4__c , GES_Connect_Event__r.ID_Supervisor__c, GES_Connect_Event__r.GES_Account_Executive__c,';
        
        exhibitQuery += ' (select Brand_Name__c,Product_Category_CrownCastle__c, Brand_Team_Contact__c, Therapeutic_Area__c,Business_Unit_Pharma__c,Brand_Name_Pharma__c from Brands__r where Canceled__c =: falseValue) from GT_Exhibit__c';
        
        exhibitQuery += ' where Canceled__c =: falseValue';
        return exhibitQuery;
    }
    
    public static string sponsorshipQuery() {
        
        Boolean falseValue = false;
        String sponsorshipQuery = 'select Activity_Level__c, Sponsorship_Name__c,GES_Connect_Event__r.Congress_Notes__c, GES_Connect_Event__r.Status__c,GES_Connect_Event__r.Housing_Logistics_Vendor__c,Product__c, GES_Connect_Event__r.Event_Level__c, GES_Account_Manager__c, GES_Account_Executive__c, GES_Connect_Event__r.Name_Of_Congress__c, GES_Connect_Event__r.Congress_Acronym__c, GES_Connect_Event__r.Congress_Start_Date__c, GES_Connect_Event__r.Congress_End_Date__c,';
        sponsorshipQuery += ' GES_Connect_Event__r.Name_of_Event__c,Congress_Manager__c, Project_Manager_CrownCastle__c, GES_Connect_Event__r.Event_Acronym__c, GES_Connect_Event__r.Congress_Level__c, GES_Connect_Event__r.Congress_Type__c, GES_Connect_Event__r.No_of_HCP_s_in_Attendance__c, GES_Connect_Event__r.Congress_Website__c, GES_Connect_Event__r.Shipping_City__c, GES_Connect_Event__r.GES_Supported_Event__c,';
        
        sponsorshipQuery += ' GES_Connect_Event__r.Shipping_State_Province__c, GES_Connect_Event__r.US_Ex_US__c,  GES_Connect_Event__r.Shipping_Country__c,  GES_Connect_Event__r.Event_Start_Date__c, GES_Connect_Event__r.Event_End_Date__c,';
        
        sponsorshipQuery += ' GES_Connect_Event__r.Facility_Name__c,GES_Connect_Event__r.Exhibit_Hours_Day_1__c, GES_Connect_Event__r.Exhibit_Hours_Day_2__c, GES_Connect_Event__r.Exhibit_Hours_Day_3__c, GES_Connect_Event__r.Exhibit_Hours_Day_4__c , GES_Connect_Event__r.GES_Account_Manager__c, GES_Connect_Event__r.GES_Meeting_Planner__c, GES_Connect_Event__r.ID_Supervisor__c, GES_Connect_Event__r.GES_Account_Executive__c,';
        sponsorshipQuery += ' (select Brand_Name__c,Product_Category_CrownCastle__c, Brand_Team_Contact__c, Therapeutic_Area__c,Business_Unit_Pharma__c,Brand_Name_Pharma__c from Brands__r where Canceled__c =: falseValue) from GT_Sponsorship__c';
        sponsorshipQuery += ' where Canceled__c =: falseValue';
        return sponsorshipQuery;
    }
    
    public static List<exhibitListWrapper> populateSponsorshipWrapperValues(List<GT_Sponsorship__c> listSponsorship) {
        List<exhibitListWrapper> dispSponsorshipWrapper = new List<exhibitListWrapper>();
        for(GT_Sponsorship__c ex: listSponsorship)
        {
            List<String> productFields = new List<String>();
            String brandTeamContact = '';
            String brandsConcat = '';
            String BusinessUnitCategory = '';
            String TherapeuticArea = '';
            String BusinessUnitPharma = '';
            String BrandNamePharma = '';
            String Exhibit_Hours_Day_1 = '';
            String Exhibit_Hours_Day_2 = '';
            String Exhibit_Hours_Day_3 = '';
            String Exhibit_Hours_Day_4 = '';
            String cmConcat = '';
            String clConcat = '';
            String startDate = '';
            String closeDate = '';
            String congressStartDate = '';
            String congressCloseDate = '';
            String Location = '';
            String EventLevel;
            if(ex.Brands__r.size() > 0)
            {
                for(GT_Brand__c br:ex.Brands__r)
                {
                    if(customerName != 'Sig Sauer'){
                        if(br.Brand_Name__c != null && !brandsConcat.contains(br.Brand_Name__c)) {
                            brandsConcat += br.Brand_Name__c+', ';
                            system.debug('Inside Brand Cat ?????????????????????????????/');
                        }
                    }
                    
                    if(br.Brand_Team_Contact__c !=null && !brandTeamContact.contains(br.Brand_Team_Contact__c)){
                        brandTeamContact += br.Brand_Team_Contact__c+', ';
                    }
                    
                    if(br.Product_Category_CrownCastle__c !=null){
                        BusinessUnitCategory = br.Product_Category_CrownCastle__c;
                    }
                    if(br.Therapeutic_Area__c != null && !TherapeuticArea.contains(br.Therapeutic_Area__c)) {
                        TherapeuticArea += br.Therapeutic_Area__c+', ';
                    }
                    if(br.Business_Unit_Pharma__c != null && !BusinessUnitPharma.contains(br.Business_Unit_Pharma__c)) {
                        BusinessUnitPharma += br.Business_Unit_Pharma__c+', ';
                    }
                    if(br.Brand_Name_Pharma__c != null && !BrandNamePharma.contains(br.Brand_Name_Pharma__c)) {
                        BrandNamePharma += br.Brand_Name_Pharma__c+', ';
                    }
                }
            }
            if(customerName == 'Sig Sauer'){
                if(ex.Product__c != null){
                    brandsConcat =  ex.Product__c.replace(';', ',');
                }
            }
            brandsConcat =  brandsConcat.removeEnd(', ');
            TherapeuticArea =  TherapeuticArea.removeEnd(', ');
            brandTeamContact =  brandTeamContact.removeEnd(', ');
            BusinessUnitPharma =  BusinessUnitPharma.removeEnd(', ');
            BrandNamePharma =  BrandNamePharma.removeEnd(', ');
            
            productFields.add(brandsConcat);
            productFields.add(brandTeamContact);
            productFields.add(ex.GES_Connect_Event__r.Status__c);
            productFields.add(ex.GES_Connect_Event__r.Housing_Logistics_Vendor__c);
            productFields.add(null);
            productFields.add(ex.GES_Connect_Event__r.Congress_Notes__c);
            productFields.add(ex.GES_Connect_Event__r.US_Ex_US__c);
            productFields.add(null);
            
            if(ex.GES_Connect_Event__r.Event_Start_Date__c != null){
                List<String> splitDate = string.valueOf(ex.GES_Connect_Event__r.Event_Start_Date__c).split('-');
                startDate = splitDate[1]+'/'+splitDate[2]+'/'+splitDate[0];
            }
            
            if(ex.GES_Connect_Event__r.Event_End_Date__c != null){
                List<String> splitDate1 = string.valueOf(ex.GES_Connect_Event__r.Event_End_Date__c).split('-');
                closeDate = splitDate1[1]+'/'+splitDate1[2]+'/'+splitDate1[0];
            }
            if(ex.GES_Connect_Event__r.Congress_Start_Date__c != null){
                List<String> splitDate = string.valueOf(ex.GES_Connect_Event__r.Congress_Start_Date__c).split('-');
                congressStartDate = splitDate[1]+'/'+splitDate[2]+'/'+splitDate[0];
            }
            
            if(ex.GES_Connect_Event__r.Congress_End_Date__c != null){
                List<String> splitDate1 = string.valueOf(ex.GES_Connect_Event__r.Congress_End_Date__c).split('-');
                congressCloseDate = splitDate1[1]+'/'+splitDate1[2]+'/'+splitDate1[0];
            }
            
            String ExhibitHours = '';
            system.debug('------ex.GES_Connect_Event__r.Exhibit_Hours_Day_1__c' + ex.GES_Connect_Event__r.Exhibit_Hours_Day_1__c);
            if(ex.GES_Connect_Event__r.Exhibit_Hours_Day_1__c != null){
                ExhibitHours += 'Exhibit Hours Day 1 : ' + ex.GES_Connect_Event__r.Exhibit_Hours_Day_1__c;
            }
            system.debug('------ex.GES_Connect_Event__r.Exhibit_Hours_Day_2__c' + ex.GES_Connect_Event__r.Exhibit_Hours_Day_2__c);
            if(ex.GES_Connect_Event__r.Exhibit_Hours_Day_2__c != null){
                ExhibitHours += ' ,    ' + 'Exhibit Hours Day 2 : ' + ex.GES_Connect_Event__r.Exhibit_Hours_Day_2__c;
            }
            system.debug('------ex.GES_Connect_Event__r.Exhibit_Hours_Day_3__c' + ex.GES_Connect_Event__r.Exhibit_Hours_Day_3__c);
            if(ex.GES_Connect_Event__r.Exhibit_Hours_Day_3__c != null){
                ExhibitHours += ' ,    ' + 'Exhibit Hours Day 3 : ' + ex.GES_Connect_Event__r.Exhibit_Hours_Day_3__c;
            }
            system.debug('------ex.GES_Connect_Event__r.Exhibit_Hours_Day_4__c' + ex.GES_Connect_Event__r.Exhibit_Hours_Day_4__c);
            if(ex.GES_Connect_Event__r.Exhibit_Hours_Day_4__c != null){
                ExhibitHours += ' ,    ' + 'Exhibit Hours Day 4 : ' + ex.GES_Connect_Event__r.Exhibit_Hours_Day_4__c;
            }
            ExhibitHours.removeStart(' , ');
            ExhibitHours.removeEnd(' , ');
            system.debug('------ExhibitHours' + ExhibitHours);
            
            
            List<String> Locations = new List<String>();
            
            if(!String.isBlank(ex.GES_Connect_Event__r.Shipping_City__c)){
                Locations.add(ex.GES_Connect_Event__r.Shipping_City__c);
            }
            if(!String.isBlank(ex.GES_Connect_Event__r.Shipping_State_Province__c)){
                Locations.add(ex.GES_Connect_Event__r.Shipping_State_Province__c);
            }
            if(!String.isBlank(ex.GES_Connect_Event__r.Shipping_Country__c)){
                if(ex.GES_Connect_Event__r.Shipping_Country__c != 'United States' && ex.GES_Connect_Event__r.Shipping_Country__c != 'US' && ex.GES_Connect_Event__r.Shipping_Country__c != 'USA') {
                    Locations.add(ex.GES_Connect_Event__r.Shipping_Country__c);
                }
            }
            Location = String.join(Locations, ', ');
            
            EventLevel = String.isBlank(ex.GES_Connect_Event__r.Congress_Level__c) ? ex.GES_Connect_Event__r.Event_Level__c : ex.GES_Connect_Event__r.Congress_Level__c;
            
            ExhibitWrapperParams exWrp = new ExhibitWrapperParams(ex.GES_Connect_Event__r.GES_Supported_Event__c,null); //SAL-1306 - passing Contacts_Made__c parameter 12/04/23 - Sajid
            dispSponsorshipWrapper.Add(new exhibitListWrapper(											
                ex.GES_Connect_Event__r.Name_of_Event__c,
                ex.GES_Connect_Event__r.Name_of_Congress__c,
                ex.GES_Connect_Event__r.Event_Acronym__c,  
                ex.GES_Connect_Event__r.Congress_Acronym__c,
                EventLevel,
                ex.GES_Connect_Event__r.Congress_Type__c,
                ex.GES_Connect_Event__r.No_of_HCP_s_in_Attendance__c,
                ex.GES_Connect_Event__r.Congress_Website__c,
                ex.Activity_Level__c,  
                ex.GES_Account_Manager__c,   
                ex.GES_Account_Executive__c,
                null,
                ex.Congress_Manager__c,
                ex.Project_Manager_CrownCastle__c,
                'Sponsorship', 
                ex.GES_Connect_Event__r.Shipping_Country__c,
                Location, 		
                ex.GES_Connect_Event__r.Facility_Name__c,                
                0,                                            
                0,                                             
                '',                                                
                productFields,
                BusinessUnitCategory,
                TherapeuticArea,
                BusinessUnitPharma,
                BrandNamePharma,
                ExhibitHours,
                startDate,
                congressStartDate,
                closeDate,
                congressCloseDate,
                exWrp
            ));
        }
        return dispSponsorshipWrapper;
    }
    
    public static string spkingEngmntQuery() {
        Boolean falseValue = false;
        String spkingEngmntQuery = 'select Activity_Level__c, Event_Manager__c,GES_Connect_Event__r.Congress_Notes__c, GES_Connect_Event__r.Status__c,GES_Connect_Event__r.Housing_Logistics_Vendor__c,Product__c,GES_Connect_Event__r.Event_Level__c , Speaking_Engagement_Type__c, GES_Account_Manager__c, GES_Account_Executive__c, ';
        
        spkingEngmntQuery += ' GES_Connect_Event__r.Name_of_Event__c,Congress_Manager__c, Project_Manager_CrownCastle__c, GES_Connect_Event__r.Event_Acronym__c, GES_Connect_Event__r.Shipping_City__c, GES_Connect_Event__r.GES_Project_Number__c,GES_Connect_Event__r.GES_Supported_Event__c,';
        
        spkingEngmntQuery += 'GES_Connect_Event__r.Name_Of_Congress__c, GES_Connect_Event__r.US_Ex_US__c,  GES_Connect_Event__r.Congress_Acronym__c, GES_Connect_Event__r.Congress_Level__c, GES_Connect_Event__r.Congress_Type__c, GES_Connect_Event__r.No_of_HCP_s_in_Attendance__c, GES_Connect_Event__r.Congress_Website__c, GES_Connect_Event__r.Congress_Start_Date__c, GES_Connect_Event__r.Congress_End_Date__c,';
        
        spkingEngmntQuery += ' GES_Connect_Event__r.Shipping_State_Province__c, GES_Connect_Event__r.Shipping_Country__c,  GES_Connect_Event__r.Event_Start_Date__c, GES_Connect_Event__r.Event_End_Date__c,';
        
        spkingEngmntQuery += ' GES_Connect_Event__r.Facility_Name__c,GES_Connect_Event__r.Exhibit_Hours_Day_1__c, GES_Connect_Event__r.Exhibit_Hours_Day_2__c, GES_Connect_Event__r.Exhibit_Hours_Day_3__c, GES_Connect_Event__r.Exhibit_Hours_Day_4__c , GES_Connect_Event__r.GES_Account_Manager__c, GES_Connect_Event__r.GES_Meeting_Planner__c, GES_Connect_Event__r.ID_Supervisor__c, GES_Connect_Event__r.GES_Account_Executive__c,';
        
        spkingEngmntQuery += ' (select Brand_Name__c,Product_Category_CrownCastle__c, Brand_Team_Contact__c, Therapeutic_Area__c,Business_Unit_Pharma__c,Brand_Name_Pharma__c from Brands__r where Canceled__c =: falseValue) from GT_Speaking_Engagement__c';
        spkingEngmntQuery += ' where Canceled__c =: falseValue';
        return spkingEngmntQuery;
    }
    
    public static string filterQuery() {
        string query = '';
        if(eventFromDate != null && eventToDate != null) {
            query += ' AND GES_Connect_Event__r.Event_Start_Date__c >=: eventFromDate AND GES_Connect_Event__r.Event_End_Date__c <=: eventToDate';
        } else
            if(eventFromDate != null) {
                query += ' AND GES_Connect_Event__r.Event_Start_Date__c >=: eventFromDate';
            } else
                if(eventToDate != null) {
                    query += ' AND GES_Connect_Event__r.Event_End_Date__c <=: eventToDate';
                }
        query += ' order by GES_Connect_Event__r.Event_Start_Date__c limit 10000';
        return query;
        
    }
    
    public static List<exhibitListWrapper> populateSpkingEngmntWrapperValues(List<GT_Speaking_Engagement__c> listSpkingEngmnt) {
        List<exhibitListWrapper> dispSpkingEngmntWrapper = new List<exhibitListWrapper>();
        for(GT_Speaking_Engagement__c ex: listSpkingEngmnt){
            List<String> productFields = new List<String>();
            String brandTeamContact = '';
            
            String brandsConcat = '';
            String BusinessUnitCategory = '';
            String TherapeuticArea = '';
            String BusinessUnitPharma = '';
            String BrandNamePharma = '';
            String cmConcat = '';
            String clConcat = '';
            String startDate = '';
            String closeDate = '';
            String congressStartDate = '';
            String congressCloseDate = '';
            String Location = '';
            String EventLevel;
            if(ex.Brands__r.size() > 0)
            {
                for(GT_Brand__c br:ex.Brands__r)
                {
                    if(customerName != 'Sig Sauer'){
                        if(br.Brand_Name__c != null && !brandsConcat.contains(br.Brand_Name__c)) {
                            brandsConcat += br.Brand_Name__c+', ';
                            system.debug('Inside Brand Cat ?????????????????????????????/');
                        }
                    }
                    if(br.Brand_Team_Contact__c !=null && !brandTeamContact.contains(br.Brand_Team_Contact__c)){
                        brandTeamContact += br.Brand_Team_Contact__c+', ';
                    }
                    
                    if(br.Product_Category_CrownCastle__c !=null){
                        BusinessUnitCategory = br.Product_Category_CrownCastle__c;
                    }
                    if(br.Therapeutic_Area__c != null && !TherapeuticArea.contains(br.Therapeutic_Area__c)) {
                        TherapeuticArea += br.Therapeutic_Area__c+', ';
                    }
                    
                    if(br.Business_Unit_Pharma__c != null && !BusinessUnitPharma.contains(br.Business_Unit_Pharma__c)) {
                        BusinessUnitPharma += br.Business_Unit_Pharma__c+', ';
                    }
                    if(br.Brand_Name_Pharma__c != null && !BrandNamePharma.contains(br.Brand_Name_Pharma__c)) {
                        BrandNamePharma += br.Brand_Name_Pharma__c+', ';
                    }
                }
            }
            if(customerName == 'Sig Sauer'){
                if(ex.Product__c != null){
                    brandsConcat =  ex.Product__c.replace(';', ',');
                }
            }
            brandsConcat =  brandsConcat.removeEnd(', ');
            TherapeuticArea =  TherapeuticArea.removeEnd(', ');
            brandTeamContact =  brandTeamContact.removeEnd(', ');
            BusinessUnitPharma =  BusinessUnitPharma.removeEnd(', ');
            BrandNamePharma =  BrandNamePharma.removeEnd(', ');
            
            productFields.add(brandsConcat);
            productFields.add(brandTeamContact);
            productFields.add(ex.GES_Connect_Event__r.Status__c);
            productFields.add(ex.GES_Connect_Event__r.Housing_Logistics_Vendor__c);
            productFields.add(null);
            productFields.add(ex.GES_Connect_Event__r.Congress_Notes__c);
            productFields.add(ex.GES_Connect_Event__r.US_Ex_US__c);
            productFields.add(null);
            
            if(ex.GES_Connect_Event__r.Event_Start_Date__c != null)
            {
                List<String> splitDate = string.valueOf(ex.GES_Connect_Event__r.Event_Start_Date__c).split('-');
                startDate = splitDate[1]+'/'+splitDate[2]+'/'+splitDate[0];
            }
            
            if(ex.GES_Connect_Event__r.Event_End_Date__c != null)
            {
                List<String> splitDate1 = string.valueOf(ex.GES_Connect_Event__r.Event_End_Date__c).split('-');
                closeDate = splitDate1[1]+'/'+splitDate1[2]+'/'+splitDate1[0];
            }
            if(ex.GES_Connect_Event__r.Congress_Start_Date__c != null){
                List<String> splitDate = string.valueOf(ex.GES_Connect_Event__r.Congress_Start_Date__c).split('-');
                congressStartDate = splitDate[1]+'/'+splitDate[2]+'/'+splitDate[0];
            }
            
            if(ex.GES_Connect_Event__r.Congress_End_Date__c != null){
                List<String> splitDate1 = string.valueOf(ex.GES_Connect_Event__r.Congress_End_Date__c).split('-');
                congressCloseDate = splitDate1[1]+'/'+splitDate1[2]+'/'+splitDate1[0];
            }
            
            String ExhibitHours = '';
            if(ex.GES_Connect_Event__r.Exhibit_Hours_Day_1__c != null){
                ExhibitHours += 'Exhibit Hours Day 1 : ' + ex.GES_Connect_Event__r.Exhibit_Hours_Day_1__c;
            }
            if(ex.GES_Connect_Event__r.Exhibit_Hours_Day_2__c != null){
                ExhibitHours += ' ,    ' + 'Exhibit Hours Day 2 : ' + ex.GES_Connect_Event__r.Exhibit_Hours_Day_2__c;
            }
            if(ex.GES_Connect_Event__r.Exhibit_Hours_Day_3__c != null){
                ExhibitHours += ' ,    ' + 'Exhibit Hours Day 3 : ' + ex.GES_Connect_Event__r.Exhibit_Hours_Day_3__c;
            }
            if(ex.GES_Connect_Event__r.Exhibit_Hours_Day_4__c != null){
                ExhibitHours += ' ,    ' + 'Exhibit Hours Day 4 : ' + ex.GES_Connect_Event__r.Exhibit_Hours_Day_4__c;
            }
            ExhibitHours.removeStart(' , ');
            ExhibitHours.removeEnd(' , ');
            system.debug('------ExhibitHours' + ExhibitHours);
            
            List<String> Locations = new List<String>();
            
            if(!String.isBlank(ex.GES_Connect_Event__r.Shipping_City__c)){
                Locations.add(ex.GES_Connect_Event__r.Shipping_City__c);
            }
            if(!String.isBlank(ex.GES_Connect_Event__r.Shipping_State_Province__c)){
                Locations.add(ex.GES_Connect_Event__r.Shipping_State_Province__c);
            }
            if(!String.isBlank(ex.GES_Connect_Event__r.Shipping_Country__c)){
                if(ex.GES_Connect_Event__r.Shipping_Country__c != 'United States' && ex.GES_Connect_Event__r.Shipping_Country__c != 'US' && ex.GES_Connect_Event__r.Shipping_Country__c != 'USA') {
                    Locations.add(ex.GES_Connect_Event__r.Shipping_Country__c);
                }
            }
            Location = String.join(Locations, ', ');
            system.debug('+++++++' + ex.Event_Manager__c);
            EventLevel = String.isBlank(ex.GES_Connect_Event__r.Congress_Level__c) ? ex.GES_Connect_Event__r.Event_Level__c : ex.GES_Connect_Event__r.Congress_Level__c;
            
            ExhibitWrapperParams exWrp = new ExhibitWrapperParams(ex.GES_Connect_Event__r.GES_Supported_Event__c,null); //SAL-1306 - passing Contacts_Made__c parameter 12/04/23 - Sajid
            dispSpkingEngmntWrapper.Add(new exhibitListWrapper(
                ex.GES_Connect_Event__r.Name_of_Event__c,
                ex.GES_Connect_Event__r.Name_of_Congress__c,
                ex.GES_Connect_Event__r.Event_Acronym__c,
                ex.GES_Connect_Event__r.Congress_Acronym__c,
                EventLevel,
                ex.GES_Connect_Event__r.Congress_Type__c,
                ex.GES_Connect_Event__r.No_of_HCP_s_in_Attendance__c,
                ex.GES_Connect_Event__r.Congress_Website__c,
                ex.Activity_Level__c,
                ex.GES_Account_Manager__c,
                ex.GES_Account_Executive__c,
                ex.Event_Manager__c,
                ex.Congress_Manager__c,
                ex.Project_Manager_CrownCastle__c,
                'Speaking Engagement',
                ex.GES_Connect_Event__r.Shipping_Country__c,
                Location,
                ex.GES_Connect_Event__r.Facility_Name__c,
                0,
                0,
                '',
                productFields,
                BusinessUnitCategory,
                TherapeuticArea,
                BusinessUnitPharma,
                BrandNamePharma,
                ExhibitHours,
                startDate,
                congressStartDate,
                closeDate,
                congressCloseDate,
                exWrp
            ));
        }
        return dispSpkingEngmntWrapper;
    }
    
    public static string meetingRoomQuery() {
        Boolean falseValue = false;
        String meetingRoomQuery = 'select Activity_Level__c, Event_Manager__c, GES_Connect_Event__r.Congress_Notes__c, GES_Connect_Event__r.Status__c,GES_Connect_Event__r.Housing_Logistics_Vendor__c,Product__c, GES_Connect_Event__r.Event_Level__c, Meeting_Room_Name__c, GES_Account_Manager__c, GES_Account_Executive__c,';
        meetingRoomQuery += ' GES_Connect_Event__r.Name_of_Event__c,Congress_Manager__c, Project_Manager__c, GES_Connect_Event__r.Event_Acronym__c, GES_Connect_Event__r.Shipping_City__c, GES_Connect_Event__r.GES_Supported_Event__c,';
        
        meetingRoomQuery += 'GES_Connect_Event__r.Name_Of_Congress__c, GES_Connect_Event__r.Congress_Acronym__c,GES_Connect_Event__r.Congress_Level__c, GES_Connect_Event__r.Congress_Type__c, GES_Connect_Event__r.No_of_HCP_s_in_Attendance__c, GES_Connect_Event__r.Congress_Website__c, GES_Connect_Event__r.Congress_Start_Date__c, GES_Connect_Event__r.Congress_End_Date__c,';
        
        meetingRoomQuery += ' GES_Connect_Event__r.Shipping_State_Province__c, GES_Connect_Event__r.US_Ex_US__c,  GES_Connect_Event__r.Shipping_Country__c,  GES_Connect_Event__r.Event_Start_Date__c, GES_Connect_Event__r.Event_End_Date__c,';
        
        meetingRoomQuery += ' GES_Connect_Event__r.Facility_Name__c,GES_Connect_Event__r.Exhibit_Hours_Day_1__c, GES_Connect_Event__r.Exhibit_Hours_Day_2__c, GES_Connect_Event__r.Exhibit_Hours_Day_3__c, GES_Connect_Event__r.Exhibit_Hours_Day_4__c , GES_Connect_Event__r.GES_Account_Manager__c, GES_Connect_Event__r.GES_Meeting_Planner__c, GES_Connect_Event__r.ID_Supervisor__c, GES_Connect_Event__r.GES_Account_Executive__c,';
        
        meetingRoomQuery += ' (select Brand_Name__c,Product_Category_CrownCastle__c, Brand_Team_Contact__c, Therapeutic_Area__c,Business_Unit_Pharma__c,Brand_Name_Pharma__c from Brands__r where Canceled__c =: falseValue) from GT_Meeting_Room__c';
        meetingRoomQuery += ' where Canceled__c =: falseValue';
        return meetingRoomQuery;
    }
    
    public static List<exhibitListWrapper> populateMRWrapperValues(List<GT_Meeting_Room__c> listMeetingRoom) {
        List<exhibitListWrapper> dispMeetingRoomWrapper = new List<exhibitListWrapper>();
        for(GT_Meeting_Room__c ex: listMeetingRoom){
            List<String> productFields = new List<String>();
            String brandTeamContact = '';
            
            String brandsConcat = '';
            String BusinessUnitCategory = '';
            String TherapeuticArea = '';
            String BusinessUnitPharma = '';
            String BrandNamePharma = '';
            String cmConcat = '';
            String clConcat = '';
            String startDate = '';
            String closeDate = '';
            String congressStartDate = '';
            String congressCloseDate = '';
            String Location = '';
            String EventLevel;
            if(ex.Brands__r.size() > 0){
                for(GT_Brand__c br:ex.Brands__r){
                    if(customerName != 'Sig Sauer'){
                        if(br.Brand_Name__c != null && !brandsConcat.contains(br.Brand_Name__c)) {
                            brandsConcat += br.Brand_Name__c+', ';
                            system.debug('Inside Brand Cat ?????????????????????????????/');
                        }
                    }
                    
                    if(br.Brand_Team_Contact__c !=null && !brandTeamContact.contains(br.Brand_Team_Contact__c)){
                        brandTeamContact += br.Brand_Team_Contact__c+', ';
                    }
                    
                    if(br.Product_Category_CrownCastle__c !=null){
                        BusinessUnitCategory = br.Product_Category_CrownCastle__c;
                    }
                    if(br.Therapeutic_Area__c != null && !TherapeuticArea.contains(br.Therapeutic_Area__c)) {
                        TherapeuticArea += br.Therapeutic_Area__c+', ';
                    }
                    if(br.Business_Unit_Pharma__c != null && !BusinessUnitPharma.contains(br.Business_Unit_Pharma__c)) {
                        BusinessUnitPharma += br.Business_Unit_Pharma__c+', ';
                    }
                    if(br.Brand_Name_Pharma__c != null && !BrandNamePharma.contains(br.Brand_Name_Pharma__c)) {
                        BrandNamePharma += br.Brand_Name_Pharma__c+', ';
                    }
                }
            }
            if(customerName == 'Sig Sauer'){
                if(ex.Product__c != null){
                    brandsConcat =  ex.Product__c.replace(';', ',');
                }
            }
            brandsConcat =  brandsConcat.removeEnd(', ');
            TherapeuticArea =  TherapeuticArea.removeEnd(', ');
            brandTeamContact =  brandTeamContact.removeEnd(', ');
            BusinessUnitPharma =  BusinessUnitPharma.removeEnd(', ');
            BrandNamePharma =  BrandNamePharma.removeEnd(', ');
            
            productFields.add(brandsConcat);
            productFields.add(brandTeamContact);
            productFields.add(ex.GES_Connect_Event__r.Status__c);
            productFields.add(ex.GES_Connect_Event__r.Housing_Logistics_Vendor__c);
            productFields.add(null);
            productFields.add(ex.GES_Connect_Event__r.Congress_Notes__c);
            productFields.add(ex.GES_Connect_Event__r.US_Ex_US__c);
            productFields.add(null);
            
            if(ex.GES_Connect_Event__r.Event_Start_Date__c != null){
                List<String> splitDate = string.valueOf(ex.GES_Connect_Event__r.Event_Start_Date__c).split('-');
                startDate = splitDate[1]+'/'+splitDate[2]+'/'+splitDate[0];
            }
            
            if(ex.GES_Connect_Event__r.Event_End_Date__c != null){
                List<String> splitDate1 = string.valueOf(ex.GES_Connect_Event__r.Event_End_Date__c).split('-');
                closeDate = splitDate1[1]+'/'+splitDate1[2]+'/'+splitDate1[0];
            }
            if(ex.GES_Connect_Event__r.Congress_Start_Date__c != null){
                List<String> splitDate = string.valueOf(ex.GES_Connect_Event__r.Congress_Start_Date__c).split('-');
                congressStartDate = splitDate[1]+'/'+splitDate[2]+'/'+splitDate[0];
            }
            
            if(ex.GES_Connect_Event__r.Congress_End_Date__c != null){
                List<String> splitDate1 = string.valueOf(ex.GES_Connect_Event__r.Congress_End_Date__c).split('-');
                congressCloseDate = splitDate1[1]+'/'+splitDate1[2]+'/'+splitDate1[0];
            }
            
            String ExhibitHours = '';
            if(ex.GES_Connect_Event__r.Exhibit_Hours_Day_1__c != null){
                ExhibitHours += 'Exhibit Hours Day 1 : ' + ex.GES_Connect_Event__r.Exhibit_Hours_Day_1__c;
            }
            if(ex.GES_Connect_Event__r.Exhibit_Hours_Day_2__c != null){
                ExhibitHours += ' ,    ' + 'Exhibit Hours Day 2 : ' + ex.GES_Connect_Event__r.Exhibit_Hours_Day_2__c;
            }
            if(ex.GES_Connect_Event__r.Exhibit_Hours_Day_3__c != null){
                ExhibitHours += ' ,    ' + 'Exhibit Hours Day 3 : ' + ex.GES_Connect_Event__r.Exhibit_Hours_Day_3__c;
            }
            if(ex.GES_Connect_Event__r.Exhibit_Hours_Day_4__c != null){
                ExhibitHours += ' ,    ' + 'Exhibit Hours Day 4 : ' + ex.GES_Connect_Event__r.Exhibit_Hours_Day_4__c;
            }
            ExhibitHours.removeStart(' , ');
            ExhibitHours.removeEnd(' , ');
            system.debug('------ExhibitHours' + ExhibitHours);
            
            List<String> Locations = new List<String>();
            
            if(!String.isBlank(ex.GES_Connect_Event__r.Shipping_City__c)){
                Locations.add(ex.GES_Connect_Event__r.Shipping_City__c);
            }
            if(!String.isBlank(ex.GES_Connect_Event__r.Shipping_State_Province__c)){
                Locations.add(ex.GES_Connect_Event__r.Shipping_State_Province__c);
            }
            if(!String.isBlank(ex.GES_Connect_Event__r.Shipping_Country__c)){
                if(ex.GES_Connect_Event__r.Shipping_Country__c != 'United States' && ex.GES_Connect_Event__r.Shipping_Country__c != 'US' && ex.GES_Connect_Event__r.Shipping_Country__c != 'USA') {
                    Locations.add(ex.GES_Connect_Event__r.Shipping_Country__c);
                }
            }
            Location = String.join(Locations, ', ');
            
            EventLevel = String.isBlank(ex.GES_Connect_Event__r.Congress_Level__c) ? ex.GES_Connect_Event__r.Event_Level__c : ex.GES_Connect_Event__r.Congress_Level__c;
            
            ExhibitWrapperParams exWrp = new ExhibitWrapperParams(ex.GES_Connect_Event__r.GES_Supported_Event__c,null); //SAL-1306 - passing Contacts_Made__c parameter 12/04/23 - Sajid
            dispMeetingRoomWrapper.Add(new exhibitListWrapper(
                ex.GES_Connect_Event__r.Name_of_Event__c,
                ex.GES_Connect_Event__r.Name_of_Congress__c,
                ex.GES_Connect_Event__r.Event_Acronym__c,
                ex.GES_Connect_Event__r.Congress_Acronym__c,
                EventLevel,
                ex.GES_Connect_Event__r.Congress_Type__c,
                ex.GES_Connect_Event__r.No_of_HCP_s_in_Attendance__c,
                ex.GES_Connect_Event__r.Congress_Website__c,
                ex.Activity_Level__c,
                ex.GES_Account_Manager__c,
                ex.GES_Account_Executive__c,
                ex.Event_Manager__c,
                ex.Congress_Manager__c,
                ex.Project_Manager__c,
                'Meeting Room',
                ex.GES_Connect_Event__r.Shipping_Country__c,
                Location,
                ex.GES_Connect_Event__r.Facility_Name__c,
                0,
                0,
                '',
                productFields,
                BusinessUnitCategory,
                TherapeuticArea,
                BusinessUnitPharma,
                BrandNamePharma,
                ExhibitHours,
                startDate,
                congressStartDate,
                closeDate,
                congressCloseDate,
                exWrp
            ));
        }
        return dispMeetingRoomWrapper;
    }
    
    public static string eventQuery() {
        Boolean falseValue = false;
        String eventQuery = 'select Activity_Level__c, Event_Room_Name__c, GES_Connect_Event__r.Congress_Notes__c, GES_Connect_Event__r.Status__c,GES_Connect_Event__r.Housing_Logistics_Vendor__c,Product__c, GES_Connect_Event__r.Event_Level__c, Event_Manager__c, GES_Account_Manager__c, GES_Account_Executive__c, Project_Manager_CrownCastle__c, ';
        
        eventQuery += ' GES_Connect_Event__r.Name_of_Event__c,Congress_Manager__c, GES_Connect_Event__r.Event_Acronym__c, GES_Connect_Event__r.Shipping_City__c, GES_Connect_Event__r.GES_Project_Number__c, GES_Connect_Event__r.GES_Supported_Event__c,';
        
        eventQuery += 'GES_Connect_Event__r.Name_Of_Congress__c, GES_Connect_Event__r.Congress_Acronym__c,GES_Connect_Event__r.Congress_Level__c, GES_Connect_Event__r.Congress_Type__c, GES_Connect_Event__r.No_of_HCP_s_in_Attendance__c, GES_Connect_Event__r.Congress_Website__c, GES_Connect_Event__r.Congress_Start_Date__c, GES_Connect_Event__r.Congress_End_Date__c,';
        
        eventQuery += ' GES_Connect_Event__r.Shipping_State_Province__c, GES_Connect_Event__r.US_Ex_US__c,  GES_Connect_Event__r.Shipping_Country__c,  GES_Connect_Event__r.Event_Start_Date__c, GES_Connect_Event__r.Event_End_Date__c,';
        
        eventQuery += ' GES_Connect_Event__r.Facility_Name__c,GES_Connect_Event__r.Exhibit_Hours_Day_1__c, GES_Connect_Event__r.Exhibit_Hours_Day_2__c, GES_Connect_Event__r.Exhibit_Hours_Day_3__c, GES_Connect_Event__r.Exhibit_Hours_Day_4__c , GES_Connect_Event__r.GES_Account_Manager__c, GES_Connect_Event__r.GES_Meeting_Planner__c, GES_Connect_Event__r.ID_Supervisor__c, GES_Connect_Event__r.GES_Account_Executive__c,';
        
        eventQuery += ' (select Brand_Name__c,Product_Category_CrownCastle__c, Brand_Team_Contact__c, Therapeutic_Area__c,Business_Unit_Pharma__c,Brand_Name_Pharma__c from Brands__r where Canceled__c =: falseValue) from GT_Event_RL__c';
        eventQuery += ' where Canceled__c =: falseValue';
        return eventQuery;
    }
    
    public static List<exhibitListWrapper> populateEventWrapperValues(List<GT_Event_RL__c> listEvent) {
        List<exhibitListWrapper> dispEventWrapper = new List<exhibitListWrapper>();
        for(GT_Event_RL__c ex: listEvent)
        {
            List<String> productFields = new List<String>();
            String brandTeamContact = '';
            
            String brandsConcat = '';
            String BusinessUnitCategory = '';
            String TherapeuticArea = '';
            String BusinessUnitPharma = '';
            String BrandNamePharma = '';
            String cmConcat = '';
            String clConcat = '';
            String startDate = '';
            String closeDate = '';
            String congressStartDate = '';
            String congressCloseDate = '';
            String Location = '';
            String EventLevel;
            if(ex.Brands__r.size() > 0)
            {
                for(GT_Brand__c br:ex.Brands__r)
                {
                    if(customerName != 'Sig Sauer'){
                        if(br.Brand_Name__c != null && !brandsConcat.contains(br.Brand_Name__c)) {
                            brandsConcat += br.Brand_Name__c+', ';
                            system.debug('Inside Brand Cat ?????????????????????????????/');
                        }
                    }
                    if(br.Brand_Team_Contact__c !=null && !brandTeamContact.contains(br.Brand_Team_Contact__c)){
                        brandTeamContact += br.Brand_Team_Contact__c+', ';
                    }
                    
                    if(br.Product_Category_CrownCastle__c !=null){
                        BusinessUnitCategory = br.Product_Category_CrownCastle__c;
                    }
                    if(br.Therapeutic_Area__c != null && !TherapeuticArea.contains(br.Therapeutic_Area__c)) {
                        TherapeuticArea += br.Therapeutic_Area__c+', ';
                    }
                    if(br.Business_Unit_Pharma__c != null && !BusinessUnitPharma.contains(br.Business_Unit_Pharma__c)) {
                        BusinessUnitPharma += br.Business_Unit_Pharma__c+', ';
                    }
                    if(br.Brand_Name_Pharma__c != null && !BrandNamePharma.contains(br.Brand_Name_Pharma__c)) {
                        BrandNamePharma += br.Brand_Name_Pharma__c+', ';
                    }
                }
                if(customerName == 'Sig Sauer'){
                    if(ex.Product__c != null){
                        brandsConcat =  ex.Product__c.replace(';', ',');
                    }
                }
                brandsConcat =  brandsConcat.removeEnd(', ');
                TherapeuticArea =  TherapeuticArea.removeEnd(', ');
                BusinessUnitPharma =  BusinessUnitPharma.removeEnd(', ');
                BrandNamePharma =  BrandNamePharma.removeEnd(', ');
                brandTeamContact =  brandTeamContact.removeEnd(', ');
                
                productFields.add(brandsConcat);
                productFields.add(brandTeamContact);
                productFields.add(ex.GES_Connect_Event__r.Status__c);
                productFields.add(ex.GES_Connect_Event__r.Housing_Logistics_Vendor__c);
                productFields.add(null);
                productFields.add(ex.GES_Connect_Event__r.Congress_Notes__c);
                productFields.add(ex.GES_Connect_Event__r.US_Ex_US__c);
                productFields.add(null);
                
                if(ex.GES_Connect_Event__r.Event_Start_Date__c != null){
                    List<String> splitDate = string.valueOf(ex.GES_Connect_Event__r.Event_Start_Date__c).split('-');
                    startDate = splitDate[1]+'/'+splitDate[2]+'/'+splitDate[0];
                }
                
                if(ex.GES_Connect_Event__r.Event_End_Date__c != null){
                    List<String> splitDate1 = string.valueOf(ex.GES_Connect_Event__r.Event_End_Date__c).split('-');
                    closeDate = splitDate1[1]+'/'+splitDate1[2]+'/'+splitDate1[0];
                }
                if(ex.GES_Connect_Event__r.Congress_Start_Date__c != null){
                    List<String> splitDate = string.valueOf(ex.GES_Connect_Event__r.Congress_Start_Date__c).split('-');
                    congressStartDate = splitDate[1]+'/'+splitDate[2]+'/'+splitDate[0];
                }
                
                if(ex.GES_Connect_Event__r.Congress_End_Date__c != null){
                    List<String> splitDate1 = string.valueOf(ex.GES_Connect_Event__r.Congress_End_Date__c).split('-');
                    congressCloseDate = splitDate1[1]+'/'+splitDate1[2]+'/'+splitDate1[0];
                }
                
                String ExhibitHours = '';
                if(ex.GES_Connect_Event__r.Exhibit_Hours_Day_1__c != null){
                    ExhibitHours += 'Exhibit Hours Day 1 : ' + ex.GES_Connect_Event__r.Exhibit_Hours_Day_1__c;
                }
                if(ex.GES_Connect_Event__r.Exhibit_Hours_Day_2__c != null){
                    ExhibitHours += ' ,    ' + 'Exhibit Hours Day 2 : ' + ex.GES_Connect_Event__r.Exhibit_Hours_Day_2__c;
                }
                if(ex.GES_Connect_Event__r.Exhibit_Hours_Day_3__c != null){
                    ExhibitHours += ' ,    ' + 'Exhibit Hours Day 3 : ' + ex.GES_Connect_Event__r.Exhibit_Hours_Day_3__c;
                }
                if(ex.GES_Connect_Event__r.Exhibit_Hours_Day_4__c != null){
                    ExhibitHours += ' ,    ' + 'Exhibit Hours Day 4 : ' + ex.GES_Connect_Event__r.Exhibit_Hours_Day_4__c;
                }
                ExhibitHours.removeStart(' , ');
                ExhibitHours.removeEnd(' , ');
                system.debug('------ExhibitHours' + ExhibitHours);
                
                List<String> Locations = new List<String>();
                
                if(!String.isBlank(ex.GES_Connect_Event__r.Shipping_City__c)){
                    Locations.add(ex.GES_Connect_Event__r.Shipping_City__c);
                }
                if(!String.isBlank(ex.GES_Connect_Event__r.Shipping_State_Province__c)){
                    Locations.add(ex.GES_Connect_Event__r.Shipping_State_Province__c);
                }
                if(!String.isBlank(ex.GES_Connect_Event__r.Shipping_Country__c)){
                    if(ex.GES_Connect_Event__r.Shipping_Country__c != 'United States' && ex.GES_Connect_Event__r.Shipping_Country__c != 'US' && ex.GES_Connect_Event__r.Shipping_Country__c != 'USA') {
                        Locations.add(ex.GES_Connect_Event__r.Shipping_Country__c);
                    }
                }
                Location = String.join(Locations, ', ');
                
                EventLevel = String.isBlank(ex.GES_Connect_Event__r.Congress_Level__c) ? ex.GES_Connect_Event__r.Event_Level__c : ex.GES_Connect_Event__r.Congress_Level__c;
                
                ExhibitWrapperParams exWrp = new ExhibitWrapperParams(ex.GES_Connect_Event__r.GES_Supported_Event__c,null); //SAL-1306 - passing Contacts_Made__c parameter 12/04/23 - Sajid
                dispEventWrapper.Add(new exhibitListWrapper(
                    ex.GES_Connect_Event__r.Name_of_Event__c,
                    ex.GES_Connect_Event__r.Name_of_Congress__c,
                    ex.GES_Connect_Event__r.Event_Acronym__c,
                    ex.GES_Connect_Event__r.Congress_Acronym__c,
                    EventLevel,
                    ex.GES_Connect_Event__r.Congress_Type__c,
                    ex.GES_Connect_Event__r.No_of_HCP_s_in_Attendance__c,
                    ex.GES_Connect_Event__r.Congress_Website__c,
                    ex.Activity_Level__c,
                    ex.GES_Account_Manager__c,
                    ex.GES_Account_Executive__c,
                    ex.Event_Manager__c,
                    ex.Congress_Manager__c,
                    ex.Project_Manager_CrownCastle__c,
                    'Event',
                    ex.GES_Connect_Event__r.Shipping_Country__c,
                    Location,
                    ex.GES_Connect_Event__r.Facility_Name__c,
                    0,
                    0,
                    '',
                    productFields,
                    BusinessUnitCategory,
                    TherapeuticArea,
                    BusinessUnitPharma,
                    BrandNamePharma,
                    ExhibitHours,
                    startDate,
                    congressStartDate,
                    closeDate,
                    congressCloseDate,
                    exWrp
                ));
            }
            
        }
        return dispEventWrapper;
    }
    
    public static string regAttendOnlyQuery() {
        Boolean falseValue = false;
        String regAttendOnlyQuery = 'select Activity_Level__c, Reg_Attend_Name__c,  GES_Account_Manager__c, GES_Account_Executive__c, Project_Manager_CrownCastle__c, ';
        
        regAttendOnlyQuery += ' GES_Connect_Event__r.Name_of_Event__c, GES_Connect_Event__r.Event_Acronym__c, GES_Connect_Event__r.Shipping_City__c, GES_Connect_Event__r.GES_Project_Number__c, GES_Connect_Event__r.GES_Supported_Event__c,';
        
        regAttendOnlyQuery += 'GES_Connect_Event__r.Name_Of_Congress__c, GES_Connect_Event__r.Congress_Acronym__c,GES_Connect_Event__r.Congress_Level__c, GES_Connect_Event__r.Congress_Type__c, GES_Connect_Event__r.No_of_HCP_s_in_Attendance__c, GES_Connect_Event__r.Congress_Website__c, GES_Connect_Event__r.Congress_Start_Date__c, GES_Connect_Event__r.Congress_End_Date__c,';
        
        regAttendOnlyQuery += ' GES_Connect_Event__r.Shipping_State_Province__c, GES_Connect_Event__r.US_Ex_US__c,  GES_Connect_Event__r.Shipping_Country__c,  GES_Connect_Event__r.Event_Start_Date__c, GES_Connect_Event__r.Event_End_Date__c,';
        
        regAttendOnlyQuery += ' GES_Connect_Event__r.Facility_Name__c,GES_Connect_Event__r.Exhibit_Hours_Day_1__c, GES_Connect_Event__r.Exhibit_Hours_Day_2__c, GES_Connect_Event__r.Exhibit_Hours_Day_3__c, GES_Connect_Event__r.Exhibit_Hours_Day_4__c , GES_Connect_Event__r.GES_Account_Manager__c, GES_Connect_Event__r.GES_Meeting_Planner__c, GES_Connect_Event__r.ID_Supervisor__c, GES_Connect_Event__r.GES_Account_Executive__c,';
        
        regAttendOnlyQuery += ' (select Brand_Name__c,Product_Category_CrownCastle__c,Therapeutic_Area__c,Business_Unit_Pharma__c,Brand_Name_Pharma__c from Brands__r where Canceled__c =: falseValue) from GT_Reg_Attend_Only__c';
        regAttendOnlyQuery += ' where Canceled__c =: falseValue';
        
        return regAttendOnlyQuery;
    }
    
    public static List<exhibitListWrapper> populateRegAttendOnlyValues(List<GT_Reg_Attend_Only__c> listRegAttend) {
        List<exhibitListWrapper> dispEventWrapper = new List<exhibitListWrapper>();
        for(GT_Reg_Attend_Only__c ex: listRegAttend)
        {
            String brandsConcat = '';
            List<String> productFields = new List<String>();
            String BusinessUnitCategory = '';
            String TherapeuticArea = '';
            String BusinessUnitPharma = '';
            String BrandNamePharma = '';
            String startDate = '';
            String closeDate = '';
            String congressStartDate = '';
            String congressCloseDate = '';
            String Location = '';
            String EventLevel;
            if(ex.Brands__r.size() > 0)
            {
                for(GT_Brand__c br:ex.Brands__r)
                {
                    if(br.Brand_Name__c != null && !brandsConcat.contains(br.Brand_Name__c)) {
                        brandsConcat += br.Brand_Name__c+', ';
                    }
                    if(br.Product_Category_CrownCastle__c !=null){
                        BusinessUnitCategory = br.Product_Category_CrownCastle__c;
                    }
                    if(br.Therapeutic_Area__c != null && !TherapeuticArea.contains(br.Therapeutic_Area__c)) {
                        TherapeuticArea += br.Therapeutic_Area__c+', ';
                    }
                    
                    if(br.Business_Unit_Pharma__c != null && !BusinessUnitPharma.contains(br.Business_Unit_Pharma__c)) {
                        BusinessUnitPharma += br.Business_Unit_Pharma__c+', ';
                    }
                    if(br.Brand_Name_Pharma__c != null && !BrandNamePharma.contains(br.Brand_Name_Pharma__c)) {
                        BrandNamePharma += br.Brand_Name_Pharma__c+', ';
                    }
                }
                brandsConcat =  brandsConcat.removeEnd(', ');
                TherapeuticArea =  TherapeuticArea.removeEnd(', ');
                BusinessUnitPharma =  BusinessUnitPharma.removeEnd(', ');
                BrandNamePharma =  BrandNamePharma.removeEnd(', ');
                
                productFields.add(brandsConcat);
                productFields.add(null);
                productFields.add(null);
                productFields.add(null);
                productFields.add(null);
                productFields.add(null);
                productFields.add(null);
                productFields.add(null);
                
                if(ex.GES_Connect_Event__r.Event_Start_Date__c != null){
                    List<String> splitDate = string.valueOf(ex.GES_Connect_Event__r.Event_Start_Date__c).split('-');
                    startDate = splitDate[1]+'/'+splitDate[2]+'/'+splitDate[0];
                }
                
                if(ex.GES_Connect_Event__r.Event_End_Date__c != null){
                    List<String> splitDate1 = string.valueOf(ex.GES_Connect_Event__r.Event_End_Date__c).split('-');
                    closeDate = splitDate1[1]+'/'+splitDate1[2]+'/'+splitDate1[0];
                }
                if(ex.GES_Connect_Event__r.Congress_Start_Date__c != null){
                    List<String> splitDate = string.valueOf(ex.GES_Connect_Event__r.Congress_Start_Date__c).split('-');
                    congressStartDate = splitDate[1]+'/'+splitDate[2]+'/'+splitDate[0];
                }
                
                if(ex.GES_Connect_Event__r.Congress_End_Date__c != null){
                    List<String> splitDate1 = string.valueOf(ex.GES_Connect_Event__r.Congress_End_Date__c).split('-');
                    congressCloseDate = splitDate1[1]+'/'+splitDate1[2]+'/'+splitDate1[0];
                }
                
                String ExhibitHours = '';
                if(ex.GES_Connect_Event__r.Exhibit_Hours_Day_1__c != null){
                    ExhibitHours += 'Exhibit Hours Day 1 : ' + ex.GES_Connect_Event__r.Exhibit_Hours_Day_1__c;
                }
                if(ex.GES_Connect_Event__r.Exhibit_Hours_Day_2__c != null){
                    ExhibitHours += ' ,    ' + 'Exhibit Hours Day 2 : ' + ex.GES_Connect_Event__r.Exhibit_Hours_Day_2__c;
                }
                if(ex.GES_Connect_Event__r.Exhibit_Hours_Day_3__c != null){
                    ExhibitHours += ' ,    ' + 'Exhibit Hours Day 3 : ' + ex.GES_Connect_Event__r.Exhibit_Hours_Day_3__c;
                }
                if(ex.GES_Connect_Event__r.Exhibit_Hours_Day_4__c != null){
                    ExhibitHours += ' ,    ' + 'Exhibit Hours Day 4 : ' + ex.GES_Connect_Event__r.Exhibit_Hours_Day_4__c;
                }
                ExhibitHours.removeStart(' , ');
                ExhibitHours.removeEnd(' , ');
                system.debug('------ExhibitHours' + ExhibitHours);
                
                List<String> Locations = new List<String>();
                
                if(!String.isBlank(ex.GES_Connect_Event__r.Shipping_City__c)){
                    Locations.add(ex.GES_Connect_Event__r.Shipping_City__c);
                }
                if(!String.isBlank(ex.GES_Connect_Event__r.Shipping_State_Province__c)){
                    Locations.add(ex.GES_Connect_Event__r.Shipping_State_Province__c);
                }
                if(!String.isBlank(ex.GES_Connect_Event__r.Shipping_Country__c)){
                    if(ex.GES_Connect_Event__r.Shipping_Country__c != 'United States' && ex.GES_Connect_Event__r.Shipping_Country__c != 'US' && ex.GES_Connect_Event__r.Shipping_Country__c != 'USA') {
                        Locations.add(ex.GES_Connect_Event__r.Shipping_Country__c);
                    }
                }
                Location = String.join(Locations, ', ');
                
                //EventLevel = String.isBlank(ex.GES_Connect_Event__r.Congress_Level__c) ? ex.GES_Connect_Event__r.Event_Level__c : ex.GES_Connect_Event__r.Congress_Level__c;
                
                ExhibitWrapperParams exWrp = new ExhibitWrapperParams(ex.GES_Connect_Event__r.GES_Supported_Event__c,null); //SAL-1306 - passing Contacts_Made__c parameter 12/04/23 - Sajid
                dispEventWrapper.Add(new exhibitListWrapper(
                    ex.GES_Connect_Event__r.Name_of_Event__c,
                    ex.GES_Connect_Event__r.Name_of_Congress__c,
                    ex.GES_Connect_Event__r.Event_Acronym__c,
                    ex.GES_Connect_Event__r.Congress_Acronym__c,
                    null,
                    ex.GES_Connect_Event__r.Congress_Type__c,
                    ex.GES_Connect_Event__r.No_of_HCP_s_in_Attendance__c,
                    ex.GES_Connect_Event__r.Congress_Website__c,
                    ex.Activity_Level__c, 
                    ex.GES_Account_Manager__c,
                    ex.GES_Account_Executive__c,
                    null,
                    null,
                    ex.Project_Manager_CrownCastle__c,
                    'Registration/Attend Only',
                    ex.GES_Connect_Event__r.Shipping_Country__c,
                    Location,
                    ex.GES_Connect_Event__r.Facility_Name__c,
                    0,
                    0,
                    '',
                    productFields,
                    BusinessUnitCategory,
                    TherapeuticArea,
                    BusinessUnitPharma,
                    BrandNamePharma,
                    ExhibitHours,
                    startDate,
                    congressStartDate,
                    closeDate,
                    congressCloseDate,
                    exWrp
                ));
            }
        }
        return dispEventWrapper;
    }
    
    
    public static List<exhibitListWrapper> populateMembership(List<GT_Membership__c> listRegAttend) {
        List<exhibitListWrapper> dispEventWrapper = new List<exhibitListWrapper>();
        for(GT_Membership__c ex: listRegAttend)
        {
            String brandsConcat = '';
            List<String> productFields = new List<String>();
            String BusinessUnitCategory = '';
            String TherapeuticArea = '';
            String BusinessUnitPharma = '';
            String BrandNamePharma = '';
            String startDate = '';
            String closeDate = '';
            String congressStartDate = '';
            String congressCloseDate = '';
            String Location = '';
            String EventLevel;
            if(ex.Products__r.size() > 0)
            {
                for(GT_Brand__c br:ex.Products__r)
                {
                    if(br.Brand_Name__c != null && !brandsConcat.contains(br.Brand_Name__c)) {
                        brandsConcat += br.Brand_Name__c+', ';
                    }
                    if(br.Product_Category_CrownCastle__c !=null){
                        BusinessUnitCategory = br.Product_Category_CrownCastle__c;
                    }
                    if(br.Therapeutic_Area__c != null && !TherapeuticArea.contains(br.Therapeutic_Area__c)) {
                        TherapeuticArea += br.Therapeutic_Area__c+', ';
                    }
                    
                    if(br.Business_Unit_Pharma__c != null && !BusinessUnitPharma.contains(br.Business_Unit_Pharma__c)) {
                        BusinessUnitPharma += br.Business_Unit_Pharma__c+', ';
                    }
                    if(br.Brand_Name_Pharma__c != null && !BrandNamePharma.contains(br.Brand_Name_Pharma__c)) {
                        BrandNamePharma += br.Brand_Name_Pharma__c+', ';
                    }
                }
            }
            brandsConcat =  brandsConcat.removeEnd(', ');
            TherapeuticArea =  TherapeuticArea.removeEnd(', ');
            
            BusinessUnitPharma =  BusinessUnitPharma.removeEnd(', ');
            BrandNamePharma =  BrandNamePharma.removeEnd(', ');
            productFields.add(brandsConcat);
            productFields.add(null);
            productFields.add(null);
            productFields.add(null);
            productFields.add(null);
            productFields.add(null);
            productFields.add(null);
            productFields.add(null);
            
            if(ex.GES_Connect_Event__r.Event_Start_Date__c != null){
                List<String> splitDate = string.valueOf(ex.GES_Connect_Event__r.Event_Start_Date__c).split('-');
                startDate = splitDate[1]+'/'+splitDate[2]+'/'+splitDate[0];
            }
            
            if(ex.GES_Connect_Event__r.Event_End_Date__c != null){
                List<String> splitDate1 = string.valueOf(ex.GES_Connect_Event__r.Event_End_Date__c).split('-');
                closeDate = splitDate1[1]+'/'+splitDate1[2]+'/'+splitDate1[0];
            }
            if(ex.GES_Connect_Event__r.Congress_Start_Date__c != null){
                List<String> splitDate = string.valueOf(ex.GES_Connect_Event__r.Congress_Start_Date__c).split('-');
                congressStartDate = splitDate[1]+'/'+splitDate[2]+'/'+splitDate[0];
            }
            
            if(ex.GES_Connect_Event__r.Congress_End_Date__c != null){
                List<String> splitDate1 = string.valueOf(ex.GES_Connect_Event__r.Congress_End_Date__c).split('-');
                congressCloseDate = splitDate1[1]+'/'+splitDate1[2]+'/'+splitDate1[0];
            }
            
            String ExhibitHours = '';
            if(ex.GES_Connect_Event__r.Exhibit_Hours_Day_1__c != null){
                ExhibitHours += 'Exhibit Hours Day 1 : ' + ex.GES_Connect_Event__r.Exhibit_Hours_Day_1__c;
            }
            if(ex.GES_Connect_Event__r.Exhibit_Hours_Day_2__c != null){
                ExhibitHours += ' ,    ' + 'Exhibit Hours Day 2 : ' + ex.GES_Connect_Event__r.Exhibit_Hours_Day_2__c;
            }
            if(ex.GES_Connect_Event__r.Exhibit_Hours_Day_3__c != null){
                ExhibitHours += ' ,    ' + 'Exhibit Hours Day 3 : ' + ex.GES_Connect_Event__r.Exhibit_Hours_Day_3__c;
            }
            if(ex.GES_Connect_Event__r.Exhibit_Hours_Day_4__c != null){
                ExhibitHours += ' ,    ' + 'Exhibit Hours Day 4 : ' + ex.GES_Connect_Event__r.Exhibit_Hours_Day_4__c;
            }
            ExhibitHours.removeStart(' , ');
            ExhibitHours.removeEnd(' , ');
            system.debug('------ExhibitHours' + ExhibitHours);
            
            List<String> Locations = new List<String>();
            
            if(!String.isBlank(ex.GES_Connect_Event__r.Shipping_City__c)){
                Locations.add(ex.GES_Connect_Event__r.Shipping_City__c);
            }
            if(!String.isBlank(ex.GES_Connect_Event__r.Shipping_State_Province__c)){
                Locations.add(ex.GES_Connect_Event__r.Shipping_State_Province__c);
            }
            if(!String.isBlank(ex.GES_Connect_Event__r.Shipping_Country__c)){
                if(ex.GES_Connect_Event__r.Shipping_Country__c != 'United States' && ex.GES_Connect_Event__r.Shipping_Country__c != 'US' && ex.GES_Connect_Event__r.Shipping_Country__c != 'USA') {
                    Locations.add(ex.GES_Connect_Event__r.Shipping_Country__c);
                }
            }
            Location = String.join(Locations, ', ');
            
            //EventLevel = String.isBlank(ex.GES_Connect_Event__r.Congress_Level__c) ? ex.GES_Connect_Event__r.Event_Level__c : ex.GES_Connect_Event__r.Congress_Level__c;
            
            ExhibitWrapperParams exWrp = new ExhibitWrapperParams(ex.GES_Connect_Event__r.GES_Supported_Event__c,null); //SAL-1306 - passing Contacts_Made__c parameter 12/04/23 - Sajid
            dispEventWrapper.Add(new exhibitListWrapper(
                ex.GES_Connect_Event__r.Name_of_Event__c,
                ex.GES_Connect_Event__r.Name_of_Congress__c,
                ex.GES_Connect_Event__r.Event_Acronym__c,
                ex.GES_Connect_Event__r.Congress_Acronym__c,
                null,
                ex.GES_Connect_Event__r.Congress_Type__c,
                ex.GES_Connect_Event__r.No_of_HCP_s_in_Attendance__c,
                ex.GES_Connect_Event__r.Congress_Website__c,
                '', 
                ex.GES_Account_Manager__c,
                ex.GES_Account_Executive__c,
                null,
                null,
                ex.CC_Project_Manager__c,
                'Membership',
                ex.GES_Connect_Event__r.Shipping_Country__c,
                Location,
                ex.GES_Connect_Event__r.Facility_Name__c,
                0,
                0,
                '',
                productFields,
                BusinessUnitCategory,
                TherapeuticArea,
                BusinessUnitPharma,
                BrandNamePharma,
                ExhibitHours,
                startDate,
                congressStartDate,
                closeDate,
                congressCloseDate,
                exWrp
            ));
            
        }
        // System.debug('dispEventWrapper-----'+dispEventWrapper);
        return dispEventWrapper;
    }
    
    
    
    public static string membershipQuery() {
        Boolean falseValue = false;
        String membershipQueryString = 'select  GES_Connect_Event__c,Membership_Name__c, GES_Account_Manager__c, GES_Account_Executive__c, CC_Project_Manager__c, ';
        
        membershipQueryString += ' GES_Connect_Event__r.Name_of_Event__c, GES_Connect_Event__r.Event_Acronym__c, GES_Connect_Event__r.Shipping_City__c, GES_Connect_Event__r.GES_Project_Number__c, GES_Connect_Event__r.GES_Supported_Event__c,';
        
        membershipQueryString += 'GES_Connect_Event__r.Name_Of_Congress__c, GES_Connect_Event__r.Congress_Acronym__c,GES_Connect_Event__r.Congress_Level__c, GES_Connect_Event__r.Congress_Type__c, GES_Connect_Event__r.No_of_HCP_s_in_Attendance__c, GES_Connect_Event__r.Congress_Website__c, GES_Connect_Event__r.Congress_Start_Date__c, GES_Connect_Event__r.Congress_End_Date__c,';
        
        membershipQueryString += ' GES_Connect_Event__r.Shipping_State_Province__c, GES_Connect_Event__r.US_Ex_US__c,  GES_Connect_Event__r.Shipping_Country__c,  GES_Connect_Event__r.Event_Start_Date__c, GES_Connect_Event__r.Event_End_Date__c,';
        
        membershipQueryString += ' GES_Connect_Event__r.Facility_Name__c,GES_Connect_Event__r.Exhibit_Hours_Day_1__c, GES_Connect_Event__r.Exhibit_Hours_Day_2__c, GES_Connect_Event__r.Exhibit_Hours_Day_3__c, GES_Connect_Event__r.Exhibit_Hours_Day_4__c ,GES_Connect_Event__r.GES_Account_Manager__c, GES_Connect_Event__r.GES_Meeting_Planner__c, GES_Connect_Event__r.ID_Supervisor__c, GES_Connect_Event__r.GES_Account_Executive__c,';
        
        membershipQueryString += ' (select Brand_Name__c,Product_Category_CrownCastle__c,Therapeutic_Area__c,Business_Unit_Pharma__c,Brand_Name_Pharma__c from Products__r where Canceled__c =: falseValue) from GT_Membership__c';
        membershipQueryString += ' where Canceled__c =: falseValue';
        return membershipQueryString;
    }
    
    //Sporting Event
    public static List<exhibitListWrapper> populateSportingEvet(List<GT_Sporting_Event__c> listRegAttend) {
        List<exhibitListWrapper> dispEventWrapper = new List<exhibitListWrapper>();
        for(GT_Sporting_Event__c ex: listRegAttend)
        {
            String brandsConcat = '';
            List<String> productFields = new List<String>();
            String BusinessUnitCategory = '';
            String TherapeuticArea = '';
            String BusinessUnitPharma = '';
            String BrandNamePharma = '';
            String startDate = '';
            String closeDate = '';
            String congressStartDate = '';
            String congressCloseDate = '';
            String Location = '';
            String EventLevel;
            if(ex.Products__r.size() > 0)
            {
                for(GT_Brand__c br:ex.Products__r)
                {
                    if(br.Brand_Name__c != null && !brandsConcat.contains(br.Brand_Name__c)) {
                        brandsConcat += br.Brand_Name__c+', ';
                    }
                    if(br.Product_Category_CrownCastle__c !=null){
                        BusinessUnitCategory = br.Product_Category_CrownCastle__c;
                    }
                    if(br.Therapeutic_Area__c != null && !TherapeuticArea.contains(br.Therapeutic_Area__c)) {
                        TherapeuticArea += br.Therapeutic_Area__c+', ';
                    }
                    
                    if(br.Business_Unit_Pharma__c != null && !BusinessUnitPharma.contains(br.Business_Unit_Pharma__c)) {
                        BusinessUnitPharma += br.Business_Unit_Pharma__c+', ';
                    }
                    if(br.Brand_Name_Pharma__c != null && !BrandNamePharma.contains(br.Brand_Name_Pharma__c)) {
                        BrandNamePharma += br.Brand_Name_Pharma__c+', ';
                    }
                }
            }
            brandsConcat =  brandsConcat.removeEnd(', ');
            TherapeuticArea =  TherapeuticArea.removeEnd(', ');
            BusinessUnitPharma =  BusinessUnitPharma.removeEnd(', ');
            BrandNamePharma =  BrandNamePharma.removeEnd(', ');
            productFields.add(brandsConcat);
            productFields.add(null);
            productFields.add(null);
            productFields.add(null);
            productFields.add(null);
            productFields.add(null);
            productFields.add(null);
            productFields.add(null);
            
            if(ex.GES_Connect_Event__r.Event_Start_Date__c != null){
                List<String> splitDate = string.valueOf(ex.GES_Connect_Event__r.Event_Start_Date__c).split('-');
                startDate = splitDate[1]+'/'+splitDate[2]+'/'+splitDate[0];
            }
            
            if(ex.GES_Connect_Event__r.Event_End_Date__c != null){
                List<String> splitDate1 = string.valueOf(ex.GES_Connect_Event__r.Event_End_Date__c).split('-');
                closeDate = splitDate1[1]+'/'+splitDate1[2]+'/'+splitDate1[0];
            }
            
            if(ex.GES_Connect_Event__r.Congress_Start_Date__c != null){
                List<String> splitDate = string.valueOf(ex.GES_Connect_Event__r.Congress_Start_Date__c).split('-');
                congressStartDate = splitDate[1]+'/'+splitDate[2]+'/'+splitDate[0];
            }
            
            if(ex.GES_Connect_Event__r.Congress_End_Date__c != null){
                List<String> splitDate1 = string.valueOf(ex.GES_Connect_Event__r.Congress_End_Date__c).split('-');
                congressCloseDate = splitDate1[1]+'/'+splitDate1[2]+'/'+splitDate1[0];
            }
            
            String ExhibitHours = '';
            system.debug('------ex.GES_Connect_Event__r.Exhibit_Hours_Day_1__c' + ex.GES_Connect_Event__r.Exhibit_Hours_Day_1__c);
            if(ex.GES_Connect_Event__r.Exhibit_Hours_Day_1__c != null){
                ExhibitHours += 'Exhibit Hours Day 1 : ' + ex.GES_Connect_Event__r.Exhibit_Hours_Day_1__c;
            }
            system.debug('------ex.GES_Connect_Event__r.Exhibit_Hours_Day_2__c' + ex.GES_Connect_Event__r.Exhibit_Hours_Day_2__c);
            if(ex.GES_Connect_Event__r.Exhibit_Hours_Day_2__c != null){
                ExhibitHours += ' ,    ' + 'Exhibit Hours Day 2 : ' + ex.GES_Connect_Event__r.Exhibit_Hours_Day_2__c;
            }
            system.debug('------ex.GES_Connect_Event__r.Exhibit_Hours_Day_3__c' + ex.GES_Connect_Event__r.Exhibit_Hours_Day_3__c);
            if(ex.GES_Connect_Event__r.Exhibit_Hours_Day_3__c != null){
                ExhibitHours += ' ,    ' + 'Exhibit Hours Day 3 : ' + ex.GES_Connect_Event__r.Exhibit_Hours_Day_3__c;
            }
            system.debug('------ex.GES_Connect_Event__r.Exhibit_Hours_Day_4__c' + ex.GES_Connect_Event__r.Exhibit_Hours_Day_4__c);
            if(ex.GES_Connect_Event__r.Exhibit_Hours_Day_4__c != null){
                ExhibitHours += ' ,    ' + 'Exhibit Hours Day 4 : ' + ex.GES_Connect_Event__r.Exhibit_Hours_Day_4__c;
            }
            ExhibitHours.removeStart(' , ');
            ExhibitHours.removeEnd(' , ');
            system.debug('------ExhibitHours' + ExhibitHours);
            
            List<String> Locations = new List<String>();
            
            if(!String.isBlank(ex.GES_Connect_Event__r.Shipping_City__c)){
                Locations.add(ex.GES_Connect_Event__r.Shipping_City__c);
            }
            if(!String.isBlank(ex.GES_Connect_Event__r.Shipping_State_Province__c)){
                Locations.add(ex.GES_Connect_Event__r.Shipping_State_Province__c);
            }
            if(!String.isBlank(ex.GES_Connect_Event__r.Shipping_Country__c)){
                if(ex.GES_Connect_Event__r.Shipping_Country__c != 'United States' && ex.GES_Connect_Event__r.Shipping_Country__c != 'US' && ex.GES_Connect_Event__r.Shipping_Country__c != 'USA') {
                    Locations.add(ex.GES_Connect_Event__r.Shipping_Country__c);
                }
            }
            Location = String.join(Locations, ', ');
            
            //EventLevel = String.isBlank(ex.GES_Connect_Event__r.Congress_Level__c) ? ex.GES_Connect_Event__r.Event_Level__c : ex.GES_Connect_Event__r.Congress_Level__c;
            
            ExhibitWrapperParams exWrp = new ExhibitWrapperParams(ex.GES_Connect_Event__r.GES_Supported_Event__c,null); //SAL-1306 - passing Contacts_Made__c parameter 12/04/23 - Sajid
            dispEventWrapper.Add(new exhibitListWrapper(
                ex.GES_Connect_Event__r.Name_of_Event__c,
                ex.GES_Connect_Event__r.Name_of_Congress__c,
                ex.GES_Connect_Event__r.Event_Acronym__c,
                ex.GES_Connect_Event__r.Congress_Acronym__c,
                null,
                ex.GES_Connect_Event__r.Congress_Type__c,
                ex.GES_Connect_Event__r.No_of_HCP_s_in_Attendance__c,
                ex.GES_Connect_Event__r.Congress_Website__c,
                '', 
                ex.GES_Account_Manager__c,
                ex.GES_Account_Executive__c,
                null,
                null,
                ex.CC_Project_Manager__c,
                'Sporting Event',
                ex.GES_Connect_Event__r.Shipping_Country__c,
                Location,
                ex.GES_Connect_Event__r.Facility_Name__c,
                0,
                0,
                '',
                productFields,
                BusinessUnitCategory,
                TherapeuticArea,
                BusinessUnitPharma,
                BrandNamePharma,
                ExhibitHours,
                startDate,
                congressStartDate,
                closeDate,
                congressCloseDate,
                exWrp
            ));
            
        }
        //System.debug('dispEventWrapper-----'+dispEventWrapper);
        return dispEventWrapper;
    }
    
    
    
    public static string sportingEventQuery() {
        Boolean falseValue = false;
        String spEventQueryString = 'select  GES_Connect_Event__c, Sporting_event_Name__c, GES_Account_Manager__c, GES_Account_Executive__c, CC_Project_Manager__c, ';
        
        spEventQueryString += ' GES_Connect_Event__r.Name_of_Event__c, GES_Connect_Event__r.Event_Acronym__c, GES_Connect_Event__r.Shipping_City__c, GES_Connect_Event__r.GES_Project_Number__c, GES_Connect_Event__r.GES_Supported_Event__c,';
        
        spEventQueryString += 'GES_Connect_Event__r.Name_Of_Congress__c, GES_Connect_Event__r.US_Ex_US__c,  GES_Connect_Event__r.Congress_Acronym__c,GES_Connect_Event__r.Congress_Level__c, GES_Connect_Event__r.Congress_Type__c, GES_Connect_Event__r.No_of_HCP_s_in_Attendance__c, GES_Connect_Event__r.Congress_Website__c, GES_Connect_Event__r.Congress_Start_Date__c, GES_Connect_Event__r.Congress_End_Date__c,';
        
        spEventQueryString += ' GES_Connect_Event__r.Shipping_State_Province__c, GES_Connect_Event__r.Shipping_Country__c,  GES_Connect_Event__r.Event_Start_Date__c, GES_Connect_Event__r.Event_End_Date__c,';
        
        spEventQueryString += ' GES_Connect_Event__r.Facility_Name__c,GES_Connect_Event__r.Exhibit_Hours_Day_1__c, GES_Connect_Event__r.Exhibit_Hours_Day_2__c, GES_Connect_Event__r.Exhibit_Hours_Day_3__c, GES_Connect_Event__r.Exhibit_Hours_Day_4__c , GES_Connect_Event__r.GES_Account_Manager__c, GES_Connect_Event__r.GES_Meeting_Planner__c, GES_Connect_Event__r.ID_Supervisor__c, GES_Connect_Event__r.GES_Account_Executive__c,';
        
        spEventQueryString += ' (select Brand_Name__c,Product_Category_CrownCastle__c,Therapeutic_Area__c,Business_Unit_Pharma__c,Brand_Name_Pharma__c from Products__r where Canceled__c =: falseValue) from GT_Sporting_Event__c';
        spEventQueryString += ' where Canceled__c =: falseValue';
        return spEventQueryString;
    }
    
    
    public class exhibitListWrapper {
        @AuraEnabled public String Name_Of_Event {get; set;}
        @AuraEnabled public String Name_Of_Congress {get; set;}
        @AuraEnabled public String Event_Acronym {get; set;}
        @AuraEnabled public String Congress_Acronym {get; set;}
        @AuraEnabled public String Congress_Level {get; set;}
        @AuraEnabled public String Congress_Type {get; set;}
        @AuraEnabled public String Congress_Status {get; set;}
        @AuraEnabled public String No_of_HCP_s_in_Attendance {get; set;}
        @AuraEnabled public String Congress_Website {get; set;}
        @AuraEnabled public String Activity_Level {get; set;}
        @AuraEnabled public String Activity_Type {get; set;}
        @AuraEnabled public String Event_Start_Date {get; set;}
        @AuraEnabled public String Congress_Start_Date {get; set;}
        @AuraEnabled public String Event_End_Date {get; set;}
        @AuraEnabled public String Congress_End_Date {get; set;}
        @AuraEnabled public Boolean GES_Supported_Event_Boolean {get; set;}
        @AuraEnabled public String GES_Supported_Event_String {get; set;}
        @AuraEnabled public String Housing_Logistics_Vendor {get; set;}
        @AuraEnabled public String City {get; set;}
        @AuraEnabled public String State{get;set;}
        @AuraEnabled public String Country{get; set;}
        @AuraEnabled public String Facility_Name {get;set;}
        @AuraEnabled public String On_Site_Staff {get;set;}
        @AuraEnabled public String Congress_Notes {get;set;}
        @AuraEnabled public String Booth_Length {get; set;}
        @AuraEnabled public String Booth_Width {get; set;}
        @AuraEnabled public String Booth_Number {get; set;}
        @AuraEnabled public String Brands {get; set;}
        @AuraEnabled public String Business_Unit_Category {get; set;}
        @AuraEnabled public String Brand_Team_Contact {get; set;}
        @AuraEnabled public String Therapeutic_Area {get; set;}
        @AuraEnabled public String Business_Unit_Pharma {get; set;}
        @AuraEnabled public String Brand_Name_Pharma {get; set;}
        @AuraEnabled public String ExhibitHours {get; set;}
        @AuraEnabled public String Event_Manager {get; set;}
        @AuraEnabled public String Congress_Manager {get; set;}
        @AuraEnabled public String Project_Manager {get; set;}
        @AuraEnabled public String GES_Account_Manager {get; set;}        
        @AuraEnabled public String GES_Account_Executive{get; set;}
        @AuraEnabled public String Location {get; set;}
        @AuraEnabled public String US_Ex_US {get; set;}
        @AuraEnabled public String GES_Project_Number_CrownCastle {get; set;}
        @AuraEnabled public String noOfContsMade {get; set;}
        
        
        
        public exhibitListWrapper (String nameOfEvent,String nameOfCongress, String eventAcronym, String congressAcronym,String congressLevel, String congressType, Decimal noHCPAttendance, String congressWebsite, String Level, String GESAccountMgr, String GESAccountExe,String eventManager, String CongressManager, String ProjectManager,
                                   String ActivityType,String Country, String Location, String FacilityName,
                                   Decimal exhibitSize, Decimal exhibitSize1, String boothNo, List<String> brandsList,String BusinessUnitCategory,String TherapeuticArea, String BusinessUnitPharma, String BrandNamePharma, String exhibitHours, String eventStartDate, string congressStartDate, string eventEndDate, string congressEndDate, ExhibitWrapperParams exhibitWrapParams)
        { 
            
            Name_Of_Event = nameOfEvent;
            Name_Of_Congress = nameOfCongress;
            Event_Acronym = eventAcronym;
            Congress_Acronym = congressAcronym;
            Activity_Level = level;
            this.Country = country;
            Congress_Level = congressLevel;
            Congress_Type = congressType;
            No_of_HCP_s_in_Attendance = String.valueOf(noHCPAttendance);
            Congress_Website = congressWebsite;
            GES_Account_Manager = GESAccountMgr;
            GES_Account_Executive = GESAccountExe;
            Activity_Type = ActivityType;
            Event_Start_Date = eventStartDate ;
            Congress_Start_Date = congressStartDate;
            Event_End_Date = eventEndDate ;
            Congress_End_Date = congressEndDate;
            Facility_Name = FacilityName ;
            Event_Manager = eventManager ;
            Congress_Manager = CongressManager;
            Project_Manager = ProjectManager;
            GES_Supported_Event_Boolean = exhibitWrapParams.GES_Supported_Event_Boolean;
            
            if(GES_Supported_Event_Boolean){
                GES_Supported_Event_String = 'YES';
            }
            else{
                GES_Supported_Event_String = 'NO';
            }
            
            if(exhibitSize != 0){
                Booth_Length = String.valueOf(exhibitSize);
            }else{
                Booth_Length = '';
            }
            
            if(exhibitSize1 != 0){
                this.Booth_Width = String.valueOf(exhibitSize1);
            }else{
                this.Booth_Width = '';
            }
            Booth_Number = boothNo;
            Brands = brandsList[0];
            Business_Unit_Category = BusinessUnitCategory;
            Therapeutic_Area = TherapeuticArea;
            Business_Unit_Pharma = BusinessUnitPharma;
            Brand_Name_Pharma = BrandNamePharma;
            this.ExhibitHours = exhibitHours; 
            Brand_Team_Contact = brandsList[1];
            Congress_Status = brandsList[2];
            Housing_Logistics_Vendor = brandsList[3];
            On_Site_Staff = brandsList[4];
            Congress_Notes = brandsList[5];
            US_Ex_US = brandsList[6];
            GES_Project_Number_CrownCastle = brandsList[7];
            List<String> brandNames = brandsList[0].split(',');
            for(String brand: brandNames){
                if(!listBrandNames.contains(brand.trim()))
                    listBrandNames.add(brand.trim());
            }
            
            /*New Location Logic
List<String> Locations = new List<String>();
city = (city == null)? '': city;
state = (state == null)? '': state;
country = (country == null)? '': country;


if(!String.isBlank(city)){
Locations.add(city);
}
if(!String.isBlank(state)){
Locations.add(state);
}
if(!String.isBlank(country)){
if(country != 'United States' && country != 'US' && country != 'USA') {
Locations.add(country);
}
}
Location = String.join(Locations, ', ');
//End New Location Logic*/
            this.Location = location;
            this.noOfContsMade = exhibitWrapParams.noOfContsMade; //SAL-1306 -  12/04/23 - Sajid
        }
        public exhibitListWrapper() {}
    }
    
    public class ExhibitWrapperParams {
        @AuraEnabled public Boolean GES_Supported_Event_Boolean {get; set;}
        @AuraEnabled public String noOfContsMade {get; set;} //SAL-1306 -  12/04/23 - Sajid
        
        public ExhibitWrapperParams(Boolean GES_Supported_Event_Boolean, String noOfContsMade){
            this.GES_Supported_Event_Boolean = GES_Supported_Event_Boolean;
            this.noOfContsMade = noOfContsMade;
        } 
    }
}