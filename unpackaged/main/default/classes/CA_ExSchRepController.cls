public class CA_ExSchRepController {
    
    /**
* @Author   :       Rahul Kumar Sinha
* @Date     :       17-Feb-2020
* @Desc     :       Controller for CA_ExhibitScheduleReport Lightning Component
* */
    
    public static Date eventFromDate {get;set;}
    public static Date eventToDate {get;set;}
    public static Set<string> setCountryNames = new Set<String>();
    public static List<string> listCountryNames = new List<String>();
    public static Set<string> setBrandNames = new Set<String>();
    public static List<string> listBrandNames;
    public static String customerName = '';
    public static String mainEventRecordTypeId = '';
    
    //Navigation variables
    static Integer totalSize =0; //To Store the total number of records available
    
    @AuraEnabled
    public static CA_Personalized_Object_Setting__c getConnectSettings(){
        User currentUser = [select id,Name,profile.name,IsPortalEnabled FROM User Where id =: userInfo.getUserId()];
        String profileName=currentUser.profile.name;
        If (Test.isRunningTest()){profileName='GC BMS Profile';}
        CA_Personalized_Object_Setting__c sDebug = CA_ApexUtils.getHomeTableSettings(profileName, 'CA_Main_Event__c', true);
        //mainEventRecordTypeId = sDebug.Record_Type_ID__c;
        system.debug('-------' + sDebug);
        return sDebug;
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
    public static list<exhibitListWrapper> fetchReports(String eFromDate, String eToDate, String recordTypeId){
        mainEventRecordTypeId = recordTypeId;
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
        Boolean falseValue = false  ;
        List<exhibitListWrapper> listDispWrapper = new List<exhibitListWrapper>();
        Set<Id> setGCEventIds = new Set<Id>();
        Map<Id, List<CA_Exhibit__c>> mapExhibit = new Map<Id, List<CA_Exhibit__c>>();
        Map<Id, List<CA_Sponsorship__c>> mapSponsorship = new Map<Id, List<CA_Sponsorship__c>>();
        Map<Id, List<CA_Speaking_Engagement__c>> mapSpkingEngmnt = new Map<Id, List<CA_Speaking_Engagement__c>>();
        Map<Id, List<CA_Meeting_Room__c>> mapMeetingRoom = new Map<Id, List<CA_Meeting_Room__c>>();
        Map<Id, List<CA_Event__c>> mapEventRL = new Map<Id, List<CA_Event__c>>();
        Map<Id, List<GT_Reg_Attend_Only__c>> mapRegAttend = new Map<Id, List<GT_Reg_Attend_Only__c>>();
        Map<Id, List<GT_Membership__c>> memberMap = new Map<Id, List<GT_Membership__c>>();
        Map<Id, List<GT_Sporting_Event__c>> spEventMap = new Map<Id, List<GT_Sporting_Event__c>>();
        
        String exhibitQuery = exhibitQuery();
        exhibitQuery+= filterQuery();
        system.debug('## exhibitQuery ' + exhibitQuery);
        
        List<CA_Exhibit__c> exhibitList = Database.query(exhibitQuery);
        for(CA_Exhibit__c e : exhibitList) {
            setGCEventIds.add(e.Event__c);
            if(!mapExhibit.containsKey(e.Event__c)) {
                mapExhibit.put(e.Event__c, new List<CA_Exhibit__c>());
            }
            mapExhibit.get(e.Event__c).add(e);
        }
        
        //Get Sponsorship Record
        String sponsorshipQuery = sponsorshipQuery();
        if(eventFromDate != null) {
            sponsorshipQuery += ' AND Event__r.Event_Start_Date__c >=: eventFromDate';
        } 
        else if(eventToDate != null) {
            sponsorshipQuery += ' AND Event__r.Event_End_Date__c <=: eventToDate';
        }
        sponsorshipQuery += ' order by Event__r.Event_Start_Date__c limit 10000';
        
        List<CA_Sponsorship__c> listSponsorship = Database.query(sponsorshipQuery);
        for(CA_Sponsorship__c e : listSponsorship) {
            setGCEventIds.add(e.Event__c);
            if(!mapSponsorship.containsKey(e.Event__c)) {
                mapSponsorship.put(e.Event__c, new List<CA_Sponsorship__c>());
            }
            mapSponsorship.get(e.Event__c).add(e);
        }
        
        //Get Speaking Engagement Record
        String spkingEngmntQuery = spkingEngmntQuery();
        if(eventFromDate != null) {
            spkingEngmntQuery += ' AND Event__r.Event_Start_Date__c >=: eventFromDate';
        } 
        else if(eventToDate != null) {
            spkingEngmntQuery += ' AND Event__r.Event_End_Date__c <=: eventToDate';
        }
        spkingEngmntQuery += ' order by Event__r.Event_Start_Date__c';
        
        List<CA_Speaking_Engagement__c> listspkingEngmnt = Database.query(spkingEngmntQuery);
        for(CA_Speaking_Engagement__c e : listspkingEngmnt) {
            setGCEventIds.add(e.Event__c);
            if(!mapSpkingEngmnt.containsKey(e.Event__c)) {
                mapSpkingEngmnt.put(e.Event__c, new List<CA_Speaking_Engagement__c>());
            }
            mapSpkingEngmnt.get(e.Event__c).add(e);
        }
        
        //Get Meeting Room Record
        String meetingRoomQuery = meetingRoomQuery();
        if(eventFromDate != null) {
            meetingRoomQuery += ' AND Event__r.Event_Start_Date__c >=: eventFromDate';
        } 
        else if(eventToDate != null) {
            meetingRoomQuery += ' AND Event__r.Event_End_Date__c <=: eventToDate';
        }
        meetingRoomQuery += ' order by Event__r.Event_Start_Date__c';
        
        List<CA_Meeting_Room__c> listMeetingRoom = Database.query(meetingRoomQuery);
        for(CA_Meeting_Room__c e : listMeetingRoom) {
            setGCEventIds.add(e.Event__c);
            
            if(!mapMeetingRoom.containsKey(e.Event__c)) {
                mapMeetingRoom.put(e.Event__c, new List<CA_Meeting_Room__c>());
            }
            mapMeetingRoom.get(e.Event__c).add(e);
        }
        
        //Get Event(RL) Record
        String eventQuery = eventQuery();
        if(eventFromDate != null) {
            eventQuery += ' AND Event__r.Event_Start_Date__c >=: eventFromDate';
        } 
        else if(eventToDate != null) {
            eventQuery += ' AND Event__r.Event_End_Date__c <=: eventToDate';
        }
        eventQuery += ' order by Event__r.Event_Start_Date__c';
        
        List<CA_Event__c> listEvent = Database.query(eventQuery);
        for(CA_Event__c e : listEvent) {
            setGCEventIds.add(e.Event__c);
            if(!mapEventRL.containsKey(e.Event__c)) {
                mapEventRL.put(e.Event__c, new List<CA_Event__c>());
            }
            mapEventRL.get(e.Event__c).add(e);
        }
        /*
//Get Registration/Attend Only Record

String regAttendOnlyQuery = regAttendOnlyQuery();
if(eventFromDate != null) {
regAttendOnlyQuery += ' AND Event__r.Event_Start_Date__c >=: eventFromDate';
} 
else if(eventToDate != null) {
regAttendOnlyQuery += ' AND Event__r.Event_End_Date__c <=: eventToDate';
}
regAttendOnlyQuery += ' order by Event__r.Event_Start_Date__c limit 10000';

List<GT_Reg_Attend_Only__c> listRegAttendOnly = Database.query(regAttendOnlyQuery);

for(GT_Reg_Attend_Only__c e : listRegAttendOnly) {
setGCEventIds.add(e.CA_Main_Event__c);
if(!mapRegAttend.containsKey(e.CA_Main_Event__c)) {
mapRegAttend.put(e.CA_Main_Event__c, new List<GT_Reg_Attend_Only__c>());
}
mapRegAttend.get(e.CA_Main_Event__c).add(e);
}

//Membership Record
String memberQuery = membershipQuery();
if(eventFromDate != null) {
memberQuery += ' AND Event__r.Event_Start_Date__c >=: eventFromDate';
} 
else if(eventToDate != null) {
memberQuery += ' AND Event__r.Event_End_Date__c <=: eventToDate';
}
memberQuery += ' order by Event__r.Event_Start_Date__c limit 10000';

List<GT_Membership__c> memberList = Database.query(memberQuery);
//System.debug('memberList>>>>>'+memberList);
for(GT_Membership__c e : memberList) {
setGCEventIds.add(e.CA_Main_Event__c);
if(!memberMap.containsKey(e.CA_Main_Event__c)) {
memberMap.put(e.CA_Main_Event__c, new List<GT_Membership__c>());
}
memberMap.get(e.CA_Main_Event__c).add(e);
}
//end
//Sporting Evet
String spQuery = sportingEventQuery();
if(eventFromDate != null) {
spQuery += ' AND Event__r.Event_Start_Date__c >=: eventFromDate';
} 
else if(eventToDate != null) {
spQuery += ' AND Event__r.Event_End_Date__c <=: eventToDate';
}
spQuery += ' order by Event__r.Event_Start_Date__c limit 10000';

List<GT_Sporting_Event__c> spList = Database.query(spQuery);
//System.debug('memberList>>>>>'+memberList);
for(GT_Sporting_Event__c e : spList) {
setGCEventIds.add(e.CA_Main_Event__c);
if(!spEventMap.containsKey(e.CA_Main_Event__c)) {
spEventMap.put(e.CA_Main_Event__c, new List<GT_Sporting_Event__c>());
}
spEventMap.get(e.CA_Main_Event__c).add(e);
}

//end*/
        for(Id eventId : setGCEventIds) {
            
            if(mapExhibit.get(eventId) != null)
            {
                String brandsConcat = '';
                String BusinessUnitCategory = '';
                String TherapeuticArea = '';
                String BusinessUnitPharma = '';
                String BrandNamePharma = '';
                String ProdTeamCon = '';
                String Exhibit_Hours_Day_1 = '';
                String Exhibit_Hours_Day_2 = '';
                String Exhibit_Hours_Day_3 = '';
                String Exhibit_Hours_Day_4 = '';
                String ExhibitHours = '';
                String cmConcat = '';
                String clConcat = '';
                String startDate = '';
                String closeDate = '';
                String Location = '';
                String EventLevel = '';
                for(CA_Exhibit__c ex: mapExhibit.get(eventId)){
                    
                    if(ex.CA_Products__r.size() > 0){
                        for(CA_Product__c br:ex.CA_Products__r){
                            if(br.Product_Name__c != null && !brandsConcat.contains(br.Product_Name__c)) {
                                brandsConcat += br.Product_Name__c+', ';
                            }
                            
                            if(br.Product_Category__c !=null){
                                BusinessUnitCategory = br.Product_Category__c;
                            }
                            
                            if(br.Therapeutic_Area__c !=null && !TherapeuticArea.contains(br.Therapeutic_Area__c)){
                                TherapeuticArea += br.Therapeutic_Area__c+', ';
                            }
                            
                            if(br.Business_Unit__c != null && !BusinessUnitPharma.contains(br.Business_Unit__c)) {
                                BusinessUnitPharma += br.Business_Unit__c+', ';
                            }
                            if(br.Fiber_Business_Unit__c != null && !BrandNamePharma.contains(br.Fiber_Business_Unit__c)) {
                                BrandNamePharma += br.Fiber_Business_Unit__c+', ';
                            }
                            if(br.Product_Team_Contact__c != null && !ProdTeamCon.contains(br.Product_Team_Contact__c)) {
                                ProdTeamCon += br.Product_Team_Contact__c+', ';
                            }
                        }
                    }
                    brandsConcat =  brandsConcat.removeEnd(', ');
                    TherapeuticArea =  TherapeuticArea.removeEnd(', ');
                    BusinessUnitPharma =  BusinessUnitPharma.removeEnd(', ');
                    BrandNamePharma =  BrandNamePharma.removeEnd(', ');
                    ProdTeamCon=ProdTeamCon.removeEnd(', ');
                    
                    if(ex.Event__r.Event_Start_Date__c != null){
                        List<String> splitDate = string.valueOf(ex.Event__r.Event_Start_Date__c).split('-');
                        startDate = splitDate[1]+'/'+splitDate[2]+'/'+splitDate[0];
                       
                    }
                    
                    if(ex.Event__r.Event_End_Date__c != null){
                        List<String> splitDate1 = string.valueOf(ex.Event__r.Event_End_Date__c).split('-');
                        closeDate = splitDate1[1]+'/'+splitDate1[2]+'/'+splitDate1[0];
                       
                    }
                    
                    system.debug('------ex.Event__r.Exhibit_Hours_Day_1__c' + ex.Event__r.Exhibit_Hours_Day_1__c);
                    if(ex.Event__r.Exhibit_Hours_Day_1__c != null){
                        ExhibitHours += 'Exhibit Hours Day 1 : ' + ex.Event__r.Exhibit_Hours_Day_1__c;
                    }
                    system.debug('------ex.Event__r.Exhibit_Hours_Day_2__c' + ex.Event__r.Exhibit_Hours_Day_2__c);
                    if(ex.Event__r.Exhibit_Hours_Day_2__c != null){
                        ExhibitHours += ' ,    ' + 'Exhibit Hours Day 2 : ' + ex.Event__r.Exhibit_Hours_Day_2__c;
                    }
                    system.debug('------ex.Event__r.Exhibit_Hours_Day_3__c' + ex.Event__r.Exhibit_Hours_Day_3__c);
                    if(ex.Event__r.Exhibit_Hours_Day_3__c != null){
                        ExhibitHours += ' ,    ' + 'Exhibit Hours Day 3 : ' + ex.Event__r.Exhibit_Hours_Day_3__c;
                    }
                    system.debug('------ex.Event__r.Exhibit_Hours_Day_4__c' + ex.Event__r.Exhibit_Hours_Day_4__c);
                    if(ex.Event__r.Exhibit_Hours_Day_4__c != null){
                        ExhibitHours += ' ,    ' + 'Exhibit Hours Day 4 : ' + ex.Event__r.Exhibit_Hours_Day_4__c;
                    }
                    ExhibitHours.removeStart(' , ');
                    ExhibitHours.removeEnd(' , ');
                    system.debug('------ExhibitHours' + ExhibitHours);
                    
                    List<String> Locations = new List<String>();
                    
                    if(!String.isBlank(ex.Event__r.Shipping_City__c)){
                        Locations.add(ex.Event__r.Shipping_City__c);
                    }
                    if(!String.isBlank(ex.Event__r.Shipping_State_Province__c)){
                        Locations.add(ex.Event__r.Shipping_State_Province__c);
                    }
                    if(!String.isBlank(ex.Event__r.Shipping_Country__c)){
                        if(ex.Event__r.Shipping_Country__c != 'United States' && ex.Event__r.Shipping_Country__c != 'US' && ex.Event__r.Shipping_Country__c != 'USA') {
                            Locations.add(ex.Event__r.Shipping_Country__c);
                        }
                    }
                    Location = String.join(Locations, ', ');
                    
                    EventLevel = String.isNotBlank(ex.Event__r.Event_Level__c) ? ex.Event__r.Event_Level__c :'';
                    
                    listDispWrapper.Add(new exhibitListWrapper(ex.Event__r.Name_of_Event__c,
                                                               '',
                                                               ex.Event__r.Event_Acronym__c,
                                                               '',
                                                               EventLevel,
                                                               '',
                                                               ex.Event__r.No_of_HCP_s_in_Attendance__c,
                                                               '',
                                                               ex.Activity_Level__c,
                                                               ex.GES_Account_Manager__c,
                                                               ex.GES_Account_Executive__c,
                                                               ex.Event_Manager__c,
                                                               '',
                                                               ex.GES_Project_Manager__c,
                                                               'Exhibit',
                                                               ex.Event__r.Shipping_Country__c,
                                                               Location,
                                                               ex.Event__r.Name_of_the_Facility__c,
                                                               ex.Booth_Length__c,
                                                               ex.Booth_Width__c,
                                                               ex.Booth_Number__c,  
                                                               brandsConcat,
                                                               BusinessUnitCategory,
                                                               TherapeuticArea,
                                                               BusinessUnitPharma,
                                                               BrandNamePharma,
                                                               ExhibitHours,
                                                               startDate,
                                                               '',
                                                               closeDate,
                                                               '',
                                                               ex.Event__r.GES_Supported_Event__c
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
            /*
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
*/
        }
        return listDispWrapper;
    }
    
    
    public static string exhibitQuery() {
        String exhibitQuery = 'Select Event__c, Event__r.Event_Level__c, Event_Manager__c, Event__r.Name_of_Event__c, Event__r.Event_Acronym__c, Event__r.GES_Supported_Event__c,'; 
        exhibitQuery += ' Activity_Level__c,GES_Project_Number__c, Exhibit_Name__c, GES_Project_Manager__c,  Event__r.No_of_HCP_s_in_Attendance__c, Event__r.US_Ex_US__c, Event__r.Event_Start_Date__c, Event__r.Event_End_Date__c, Event__r.Shipping_City__c, GES_Account_Manager__c, GES_Account_Executive__c, Congress_Manager_Onsite__c , ';
        
        exhibitQuery += ' Event__r.Shipping_State_Province__c, Event__r.Shipping_Country__c, Event__r.Name_of_the_Facility__c, Booth_Length__c, Exhibit_Space_Type__c, Booth_Width__c, Booth_Number__c, Event__r.GES_Account_Manager__c,';
        
        exhibitQuery += ' Event__r.GES_Meeting_Planner__c,Event__r.Exhibit_Hours_Day_1__c, Event__r.Exhibit_Hours_Day_2__c, Event__r.Exhibit_Hours_Day_3__c, Event__r.Exhibit_Hours_Day_4__c , Event__r.GES_Account_Executive__c,';
        
        exhibitQuery += ' (select Product_Name__c,Business_Unit__c,Product_Category__c,Therapeutic_Area__c,Business_Unit_Pharma__c,Fiber_Business_Unit__c,Product_Team_Contact__c from CA_Products__r where Cancelled__c =: falseValue) from CA_Exhibit__c';
        
        exhibitQuery += ' where Cancelled__c =: falseValue AND Event__r.RecordTypeId = :mainEventRecordTypeId ';
        system.debug('mainEventRecordTypeId==='+mainEventRecordTypeId);
        
        return exhibitQuery;
    }
    
    public static string sponsorshipQuery() {
        
        Boolean falseValue = false;
        String sponsorshipQuery = 'select Activity_Level__c, Sponsorship_Name__c, Event__r.Event_Level__c, GES_Account_Manager__c, GES_Account_Executive__c,';
        sponsorshipQuery += ' Event__r.Name_of_Event__c, Event__r.Event_Acronym__c,  Event__r.No_of_HCP_s_in_Attendance__c, Event__r.US_Ex_US__c, Event__r.Shipping_City__c, Event__r.GES_Supported_Event__c,';
        
        sponsorshipQuery += ' Event__r.Shipping_State_Province__c, Event__r.Shipping_Country__c,  Event__r.Event_Start_Date__c, Event__r.Event_End_Date__c,';
        
        sponsorshipQuery += ' Event__r.Name_of_the_Facility__c,Event__r.Exhibit_Hours_Day_1__c, Event__r.Exhibit_Hours_Day_2__c, Event__r.Exhibit_Hours_Day_3__c, Event__r.Exhibit_Hours_Day_4__c , Event__r.GES_Account_Manager__c, Event__r.GES_Meeting_Planner__c, Event__r.GES_Account_Executive__c,';
        sponsorshipQuery += ' (select Product_Name__c,Business_Unit__c,Product_Category__c,Therapeutic_Area__c,Business_Unit_Pharma__c,Fiber_Business_Unit__c, Product_Team_Contact__c from CA_Products__r where Cancelled__c =: falseValue) from CA_Sponsorship__c';
        sponsorshipQuery += ' where Cancelled__c =: falseValue AND Event__r.RecordTypeId = :mainEventRecordTypeId ';
        return sponsorshipQuery;
    }
    
    public static List<exhibitListWrapper> populateSponsorshipWrapperValues(List<CA_Sponsorship__c> listSponsorship) {
        List<exhibitListWrapper> dispSponsorshipWrapper = new List<exhibitListWrapper>();
        for(CA_Sponsorship__c ex: listSponsorship)
        {
            String brandsConcat = '';
            String BusinessUnitCategory = '';
            String TherapeuticArea = '';
            String BusinessUnitPharma = '';
            String ProdTeamCon = '';
            String BrandNamePharma = '';
            String Exhibit_Hours_Day_1 = '';
            String Exhibit_Hours_Day_2 = '';
            String Exhibit_Hours_Day_3 = '';
            String Exhibit_Hours_Day_4 = '';
            String cmConcat = '';
            String clConcat = '';
            String startDate = '';
            String closeDate = '';
            String Location = '';
            String EventLevel;
            if(ex.CA_Products__r.size() > 0)
            {
                for(CA_Product__c br:ex.CA_Products__r)
                {
                    if(br.Product_Name__c != null && !brandsConcat.contains(br.Product_Name__c)) {
                        brandsConcat += br.Product_Name__c+', ';
                    }
                    if(br.Product_Category__c !=null){
                        BusinessUnitCategory = br.Product_Category__c;
                    }
                    if(br.Therapeutic_Area__c != null && !TherapeuticArea.contains(br.Therapeutic_Area__c)) {
                        TherapeuticArea += br.Therapeutic_Area__c+', ';
                    }
                    if(br.Business_Unit__c != null && !BusinessUnitPharma.contains(br.Business_Unit__c)) {
                        BusinessUnitPharma += br.Business_Unit__c+', ';
                    }
                    if(br.Fiber_Business_Unit__c != null && !BrandNamePharma.contains(br.Fiber_Business_Unit__c)) {
                        BrandNamePharma += br.Fiber_Business_Unit__c+', ';
                    }
                    if(br.Product_Team_Contact__c != null && !ProdTeamCon.contains(br.Product_Team_Contact__c)) {
                        ProdTeamCon += br.Product_Team_Contact__c+', ';
                    }
                }
            }
            brandsConcat =  brandsConcat.removeEnd(', ');
            TherapeuticArea =  TherapeuticArea.removeEnd(', ');
            
            BusinessUnitPharma =  BusinessUnitPharma.removeEnd(', ');
            BrandNamePharma =  BrandNamePharma.removeEnd(', ');
            
            if(ex.Event__r.Event_Start_Date__c != null){
                List<String> splitDate = string.valueOf(ex.Event__r.Event_Start_Date__c).split('-');
                startDate = splitDate[1]+'/'+splitDate[2]+'/'+splitDate[0];
            }
            
            if(ex.Event__r.Event_End_Date__c != null){
                List<String> splitDate1 = string.valueOf(ex.Event__r.Event_End_Date__c).split('-');
                closeDate = splitDate1[1]+'/'+splitDate1[2]+'/'+splitDate1[0];
            }
            
            String ExhibitHours = '';
            //system.debug('------ex.Event__r.Exhibit_Hours_Day_1__c' + ex.Event__r.Exhibit_Hours_Day_1__c);
            if(ex.Event__r.Exhibit_Hours_Day_1__c != null){
                ExhibitHours += 'Exhibit Hours Day 1 : ' + ex.Event__r.Exhibit_Hours_Day_1__c;
            }
            //system.debug('------ex.Event__r.Exhibit_Hours_Day_2__c' + ex.Event__r.Exhibit_Hours_Day_2__c);
            if(ex.Event__r.Exhibit_Hours_Day_2__c != null){
                ExhibitHours += ' ,    ' + 'Exhibit Hours Day 2 : ' + ex.Event__r.Exhibit_Hours_Day_2__c;
            }
            //system.debug('------ex.Event__r.Exhibit_Hours_Day_3__c' + ex.Event__r.Exhibit_Hours_Day_3__c);
            if(ex.Event__r.Exhibit_Hours_Day_3__c != null){
                ExhibitHours += ' ,    ' + 'Exhibit Hours Day 3 : ' + ex.Event__r.Exhibit_Hours_Day_3__c;
            }
            //system.debug('------ex.Event__r.Exhibit_Hours_Day_4__c' + ex.Event__r.Exhibit_Hours_Day_4__c);
            if(ex.Event__r.Exhibit_Hours_Day_4__c != null){
                ExhibitHours += ' ,    ' + 'Exhibit Hours Day 4 : ' + ex.Event__r.Exhibit_Hours_Day_4__c;
            }
            ExhibitHours.removeStart(' , ');
            ExhibitHours.removeEnd(' , ');
            //system.debug('------ExhibitHours' + ExhibitHours);
            
            
            List<String> Locations = new List<String>();
            
            if(!String.isBlank(ex.Event__r.Shipping_City__c)){
                Locations.add(ex.Event__r.Shipping_City__c);
            }
            if(!String.isBlank(ex.Event__r.Shipping_State_Province__c)){
                Locations.add(ex.Event__r.Shipping_State_Province__c);
            }
            if(!String.isBlank(ex.Event__r.Shipping_Country__c)){
                if(ex.Event__r.Shipping_Country__c != 'United States' && ex.Event__r.Shipping_Country__c != 'US' && ex.Event__r.Shipping_Country__c != 'USA') {
                    Locations.add(ex.Event__r.Shipping_Country__c);
                }
            }
            Location = String.join(Locations, ', ');
            
            EventLevel = String.isBlank(ex.Event__r.Event_Level__c) ? ex.Event__r.Event_Level__c : '';
            
            dispSponsorshipWrapper.Add(new exhibitListWrapper(                                          
                ex.Event__r.Name_of_Event__c,
                '',
                ex.Event__r.Event_Acronym__c,  
                '',
                EventLevel,
                '',
                ex.Event__r.No_of_HCP_s_in_Attendance__c,
                '',
                ex.Activity_Level__c,  
                ex.GES_Account_Manager__c,   
                ex.GES_Account_Executive__c,
                null,
                '',
                '',
                'Sponsorship', 
                ex.Event__r.Shipping_Country__c,
                Location,       
                ex.Event__r.Name_of_the_Facility__c,                
                0,                                            
                0,                                             
                '',                                                
                brandsConcat,
                BusinessUnitCategory,
                TherapeuticArea,
                BusinessUnitPharma,
                BrandNamePharma,
                ExhibitHours,
                startDate,
                '',
                closeDate,
                '',
                ex.Event__r.GES_Supported_Event__c
            ));
        }
        return dispSponsorshipWrapper;
    }
    
    public static string spkingEngmntQuery() {
        Boolean falseValue = false;
        String spkingEngmntQuery = 'select Activity_Level__c, Event_Manager__c,Event__r.Event_Level__c , Speaking_Engagement_Type__c, GES_Account_Manager__c, GES_Account_Executive__c, ';
        
        spkingEngmntQuery += ' Event__r.Name_of_Event__c, Event__r.Event_Acronym__c, Event__r.Shipping_City__c, Event__r.GES_Project_Number__c,Event__r.GES_Supported_Event__c,';
        
        spkingEngmntQuery += '  Event__r.No_of_HCP_s_in_Attendance__c, Event__r.US_Ex_US__c, ';
        
        spkingEngmntQuery += ' Event__r.Shipping_State_Province__c, Event__r.Shipping_Country__c,  Event__r.Event_Start_Date__c, Event__r.Event_End_Date__c,';
        
        spkingEngmntQuery += ' Event__r.Name_of_the_Facility__c,Event__r.Exhibit_Hours_Day_1__c, Event__r.Exhibit_Hours_Day_2__c, Event__r.Exhibit_Hours_Day_3__c, Event__r.Exhibit_Hours_Day_4__c , Event__r.GES_Account_Manager__c, Event__r.GES_Meeting_Planner__c, Event__r.GES_Account_Executive__c,';
        
        spkingEngmntQuery += ' (select Product_Name__c,Business_Unit__c,Product_Category__c,Therapeutic_Area__c,Business_Unit_Pharma__c,Fiber_Business_Unit__c, Product_Team_Contact__c from CA_Products__r where Cancelled__c =: falseValue) from CA_Speaking_Engagement__c';
        spkingEngmntQuery += ' where Cancelled__c =: falseValue AND Event__r.RecordTypeId = :mainEventRecordTypeId' ;
        return spkingEngmntQuery;
    }
    
    public static string filterQuery() {
        string query = '';
        if(eventFromDate != null && eventToDate != null) {
            query += ' AND Event__r.Event_Start_Date__c >=: eventFromDate AND Event__r.Event_End_Date__c <=: eventToDate';
        } else
            if(eventFromDate != null) {
                query += ' AND Event__r.Event_Start_Date__c >=: eventFromDate';
            } else
                if(eventToDate != null) {
                    query += ' AND Event__r.Event_End_Date__c <=: eventToDate';
                }
        query += ' order by Event__r.Event_Start_Date__c limit 10000';
        return query;
        
    }
    
    public static List<exhibitListWrapper> populateSpkingEngmntWrapperValues(List<CA_Speaking_Engagement__c> listSpkingEngmnt) {
        List<exhibitListWrapper> dispSpkingEngmntWrapper = new List<exhibitListWrapper>();
        for(CA_Speaking_Engagement__c ex: listSpkingEngmnt){
            String brandsConcat = '';
            String BusinessUnitCategory = '';
            String TherapeuticArea = '';
            String BusinessUnitPharma = '';
            String BrandNamePharma = '';
            String ProdTeamCon = '';
            String cmConcat = '';
            String clConcat = '';
            String startDate = '';
            String closeDate = '';
            String Location = '';
            String EventLevel;
            if(ex.CA_Products__r.size() > 0)
            {
                for(CA_Product__c br:ex.CA_Products__r)
                {
                    if(br.Product_Name__c != null && !brandsConcat.contains(br.Product_Name__c)) {
                        brandsConcat += br.Product_Name__c+', ';
                    }
                    if(br.Product_Category__c !=null){
                        BusinessUnitCategory = br.Product_Category__c;
                    }
                    if(br.Therapeutic_Area__c != null && !TherapeuticArea.contains(br.Therapeutic_Area__c)) {
                        TherapeuticArea += br.Therapeutic_Area__c+', ';
                    }
                    
                    if(br.Business_Unit__c != null && !BusinessUnitPharma.contains(br.Business_Unit__c)) {
                        BusinessUnitPharma += br.Business_Unit__c+', ';
                    }
                    if(br.Fiber_Business_Unit__c != null && !BrandNamePharma.contains(br.Fiber_Business_Unit__c)) {
                        BrandNamePharma += br.Fiber_Business_Unit__c+', ';
                    }
                    if(br.Product_Team_Contact__c != null && !ProdTeamCon.contains(br.Product_Team_Contact__c)) {
                        ProdTeamCon += br.Product_Team_Contact__c+', ';
                    }
                }
            }
            brandsConcat =  brandsConcat.removeEnd(', ');
            TherapeuticArea =  TherapeuticArea.removeEnd(', ');
            
            BusinessUnitPharma =  BusinessUnitPharma.removeEnd(', ');
            BrandNamePharma =  BrandNamePharma.removeEnd(', ');
            
            if(ex.Event__r.Event_Start_Date__c != null)
            {
                List<String> splitDate = string.valueOf(ex.Event__r.Event_Start_Date__c).split('-');
                startDate = splitDate[1]+'/'+splitDate[2]+'/'+splitDate[0];
            }
            
            if(ex.Event__r.Event_End_Date__c != null)
            {
                List<String> splitDate1 = string.valueOf(ex.Event__r.Event_End_Date__c).split('-');
                closeDate = splitDate1[1]+'/'+splitDate1[2]+'/'+splitDate1[0];
            }
            
            String ExhibitHours = '';
            if(ex.Event__r.Exhibit_Hours_Day_1__c != null){
                ExhibitHours += 'Exhibit Hours Day 1 : ' + ex.Event__r.Exhibit_Hours_Day_1__c;
            }
            if(ex.Event__r.Exhibit_Hours_Day_2__c != null){
                ExhibitHours += ' ,    ' + 'Exhibit Hours Day 2 : ' + ex.Event__r.Exhibit_Hours_Day_2__c;
            }
            if(ex.Event__r.Exhibit_Hours_Day_3__c != null){
                ExhibitHours += ' ,    ' + 'Exhibit Hours Day 3 : ' + ex.Event__r.Exhibit_Hours_Day_3__c;
            }
            if(ex.Event__r.Exhibit_Hours_Day_4__c != null){
                ExhibitHours += ' ,    ' + 'Exhibit Hours Day 4 : ' + ex.Event__r.Exhibit_Hours_Day_4__c;
            }
            ExhibitHours.removeStart(' , ');
            ExhibitHours.removeEnd(' , ');
            system.debug('------ExhibitHours' + ExhibitHours);
            
            List<String> Locations = new List<String>();
            
            if(!String.isBlank(ex.Event__r.Shipping_City__c)){
                Locations.add(ex.Event__r.Shipping_City__c);
            }
            if(!String.isBlank(ex.Event__r.Shipping_State_Province__c)){
                Locations.add(ex.Event__r.Shipping_State_Province__c);
            }
            if(!String.isBlank(ex.Event__r.Shipping_Country__c)){
                if(ex.Event__r.Shipping_Country__c != 'United States' && ex.Event__r.Shipping_Country__c != 'US' && ex.Event__r.Shipping_Country__c != 'USA') {
                    Locations.add(ex.Event__r.Shipping_Country__c);
                }
            }
            Location = String.join(Locations, ', ');
            system.debug('+++++++' + ex.Event_Manager__c);
            EventLevel = String.isBlank(ex.Event__r.Event_Level__c) ? ex.Event__r.Event_Level__c : '';
            
            dispSpkingEngmntWrapper.Add(new exhibitListWrapper(
                ex.Event__r.Name_of_Event__c,
                '',
                ex.Event__r.Event_Acronym__c,
                '',
                EventLevel,
                '',
                ex.Event__r.No_of_HCP_s_in_Attendance__c,
                '',
                ex.Activity_Level__c,
                ex.GES_Account_Manager__c,
                ex.GES_Account_Executive__c,
                ex.Event_Manager__c,
                '',
                '',
                'Speaking Engagement',
                ex.Event__r.Shipping_Country__c,
                Location,
                ex.Event__r.Name_of_the_Facility__c,
                0,
                0,
                '',
                brandsConcat,
                BusinessUnitCategory,
                TherapeuticArea,
                BusinessUnitPharma,
                BrandNamePharma,
                ExhibitHours,
                startDate,
                '',
                closeDate,
                '',
                ex.Event__r.GES_Supported_Event__c
            ));
        }
        return dispSpkingEngmntWrapper;
    }
    
    public static string meetingRoomQuery() {
        Boolean falseValue = false;
        String meetingRoomQuery = 'select Activity_Level__c, Event_Manager__c, Event__r.Event_Level__c, Meeting_Room_Name__c, GES_Account_Manager__c, GES_Account_Executive__c,';
        meetingRoomQuery += ' Event__r.Name_of_Event__c, Event__r.Event_Acronym__c, Event__r.Shipping_City__c, Event__r.GES_Supported_Event__c,';
        
        meetingRoomQuery += ' Event__r.No_of_HCP_s_in_Attendance__c, Event__r.US_Ex_US__c,';
        
        meetingRoomQuery += ' Event__r.Shipping_State_Province__c, Event__r.Shipping_Country__c,  Event__r.Event_Start_Date__c, Event__r.Event_End_Date__c,';
        
        meetingRoomQuery += ' Event__r.Name_of_the_Facility__c,Event__r.Exhibit_Hours_Day_1__c, Event__r.Exhibit_Hours_Day_2__c, Event__r.Exhibit_Hours_Day_3__c, Event__r.Exhibit_Hours_Day_4__c , Event__r.GES_Account_Manager__c, Event__r.GES_Meeting_Planner__c, Event__r.GES_Account_Executive__c,';
        
        meetingRoomQuery += ' (select Product_Name__c,Business_Unit__c,Product_Category__c,Therapeutic_Area__c,Business_Unit_Pharma__c,Fiber_Business_Unit__c, Product_Team_Contact__c from CA_Products__r where Cancelled__c =: falseValue) from CA_Meeting_Room__c';
        meetingRoomQuery += ' where Cancelled__c =: falseValue AND Event__r.RecordTypeId = :mainEventRecordTypeId' ;
        return meetingRoomQuery;
    }
    
    public static List<exhibitListWrapper> populateMRWrapperValues(List<CA_Meeting_Room__c> listMeetingRoom) {
        List<exhibitListWrapper> dispMeetingRoomWrapper = new List<exhibitListWrapper>();
        for(CA_Meeting_Room__c ex: listMeetingRoom){
            String brandsConcat = '';
            String BusinessUnitCategory = '';
            String TherapeuticArea = '';
            String BusinessUnitPharma = '';
            String BrandNamePharma = '';
            String ProdTeamCon = '';
            String cmConcat = '';
            String clConcat = '';
            String startDate = '';
            String closeDate = '';
            String congressStartDate = '';
            String congressCloseDate = '';
            String Location = '';
            String EventLevel;
            if(ex.CA_Products__r.size() > 0){
                for(CA_Product__c br:ex.CA_Products__r){
                    if(br.Product_Name__c != null && !brandsConcat.contains(br.Product_Name__c)) {
                        brandsConcat += br.Product_Name__c+', ';
                    }
                    if(br.Product_Category__c !=null){
                        BusinessUnitCategory = br.Product_Category__c;
                    }
                    if(br.Therapeutic_Area__c != null && !TherapeuticArea.contains(br.Therapeutic_Area__c)) {
                        TherapeuticArea += br.Therapeutic_Area__c+', ';
                    }
                    if(br.Business_Unit__c != null && !BusinessUnitPharma.contains(br.Business_Unit__c)) {
                        BusinessUnitPharma += br.Business_Unit__c+', ';
                    }
                    if(br.Fiber_Business_Unit__c != null && !BrandNamePharma.contains(br.Fiber_Business_Unit__c)) {
                        BrandNamePharma += br.Fiber_Business_Unit__c+', ';
                    }
                    if(br.Product_Team_Contact__c != null && !ProdTeamCon.contains(br.Product_Team_Contact__c)) {
                        ProdTeamCon += br.Product_Team_Contact__c+', ';
                    }
                }
            }
            brandsConcat =  brandsConcat.removeEnd(', ');
            TherapeuticArea =  TherapeuticArea.removeEnd(', ');
            
            BusinessUnitPharma =  BusinessUnitPharma.removeEnd(', ');
            BrandNamePharma =  BrandNamePharma.removeEnd(', ');
            
            if(ex.Event__r.Event_Start_Date__c != null){
                List<String> splitDate = string.valueOf(ex.Event__r.Event_Start_Date__c).split('-');
                startDate = splitDate[1]+'/'+splitDate[2]+'/'+splitDate[0];
            }
            
            if(ex.Event__r.Event_End_Date__c != null){
                List<String> splitDate1 = string.valueOf(ex.Event__r.Event_End_Date__c).split('-');
                closeDate = splitDate1[1]+'/'+splitDate1[2]+'/'+splitDate1[0];
            }
            
            String ExhibitHours = '';
            if(ex.Event__r.Exhibit_Hours_Day_1__c != null){
                ExhibitHours += 'Exhibit Hours Day 1 : ' + ex.Event__r.Exhibit_Hours_Day_1__c;
            }
            if(ex.Event__r.Exhibit_Hours_Day_2__c != null){
                ExhibitHours += ' ,    ' + 'Exhibit Hours Day 2 : ' + ex.Event__r.Exhibit_Hours_Day_2__c;
            }
            if(ex.Event__r.Exhibit_Hours_Day_3__c != null){
                ExhibitHours += ' ,    ' + 'Exhibit Hours Day 3 : ' + ex.Event__r.Exhibit_Hours_Day_3__c;
            }
            if(ex.Event__r.Exhibit_Hours_Day_4__c != null){
                ExhibitHours += ' ,    ' + 'Exhibit Hours Day 4 : ' + ex.Event__r.Exhibit_Hours_Day_4__c;
            }
            ExhibitHours.removeStart(' , ');
            ExhibitHours.removeEnd(' , ');
            system.debug('------ExhibitHours' + ExhibitHours);
            
            List<String> Locations = new List<String>();
            
            if(!String.isBlank(ex.Event__r.Shipping_City__c)){
                Locations.add(ex.Event__r.Shipping_City__c);
            }
            if(!String.isBlank(ex.Event__r.Shipping_State_Province__c)){
                Locations.add(ex.Event__r.Shipping_State_Province__c);
            }
            if(!String.isBlank(ex.Event__r.Shipping_Country__c)){
                if(ex.Event__r.Shipping_Country__c != 'United States' && ex.Event__r.Shipping_Country__c != 'US' && ex.Event__r.Shipping_Country__c != 'USA') {
                    Locations.add(ex.Event__r.Shipping_Country__c);
                }
            }
            Location = String.join(Locations, ', ');
            
            EventLevel = String.isBlank(ex.Event__r.Event_Level__c) ? ex.Event__r.Event_Level__c : '';
            
            dispMeetingRoomWrapper.Add(new exhibitListWrapper(
                ex.Event__r.Name_of_Event__c,
                '',
                ex.Event__r.Event_Acronym__c,
                '',
                EventLevel,
                '',
                ex.Event__r.No_of_HCP_s_in_Attendance__c,
                '',
                ex.Activity_Level__c,
                ex.GES_Account_Manager__c,
                ex.GES_Account_Executive__c,
                ex.Event_Manager__c,
                '',
                '',
                'Meeting Room',
                ex.Event__r.Shipping_Country__c,
                Location,
                ex.Event__r.Name_of_the_Facility__c,
                0,
                0,
                '',
                brandsConcat,
                BusinessUnitCategory,
                TherapeuticArea,
                BusinessUnitPharma,
                BrandNamePharma,
                ExhibitHours,
                startDate,
                '',
                closeDate,
                '',
                ex.Event__r.GES_Supported_Event__c
            ));
        }
        return dispMeetingRoomWrapper;
    }
    
    public static string eventQuery() {
        Boolean falseValue = false;
        String eventQuery = 'select Event__c,Activity_Level__c, Event__r.Event_Level__c, Event_Manager__c, GES_Account_Manager__c, GES_Account_Executive__c, ';
        
        eventQuery += ' Event__r.Name_of_Event__c, Event__r.Event_Acronym__c, Event__r.Shipping_City__c, Event__r.GES_Project_Number__c, Event__r.GES_Supported_Event__c,';
        
        eventQuery += '  Event__r.No_of_HCP_s_in_Attendance__c, Event__r.US_Ex_US__c,';
        
        eventQuery += ' Event__r.Shipping_State_Province__c, Event__r.Shipping_Country__c,  Event__r.Event_Start_Date__c, Event__r.Event_End_Date__c,';
        
        eventQuery += ' Event__r.Name_of_the_Facility__c,Event__r.Exhibit_Hours_Day_1__c, Event__r.Exhibit_Hours_Day_2__c, Event__r.Exhibit_Hours_Day_3__c, Event__r.Exhibit_Hours_Day_4__c , Event__r.GES_Account_Manager__c, Event__r.GES_Meeting_Planner__c, Event__r.GES_Account_Executive__c,';
        
        eventQuery += ' (select Product_Name__c,Business_Unit__c,Product_Category__c,Therapeutic_Area__c,Business_Unit_Pharma__c,Fiber_Business_Unit__c, Product_Team_Contact__c from CA_Products__r where Cancelled__c =: falseValue) from CA_Event__c';
        eventQuery += ' where Cancelled__c =: falseValue AND Event__r.RecordTypeId = :mainEventRecordTypeId' ;
        return eventQuery;
    }
    
    public static List<exhibitListWrapper> populateEventWrapperValues(List<CA_Event__c> listEvent) {
        List<exhibitListWrapper> dispEventWrapper = new List<exhibitListWrapper>();
        for(CA_Event__c ex: listEvent)
        {
            String brandsConcat = '';
            String BusinessUnitCategory = '';
            String TherapeuticArea = '';
            String BusinessUnitPharma = '';
            String BrandNamePharma = '';
            String ProdTeamCon = '';
            String cmConcat = '';
            String clConcat = '';
            String startDate = '';
            String closeDate = '';
            String congressStartDate = '';
            String congressCloseDate = '';
            String Location = '';
            String EventLevel;
            if(ex.CA_Products__r.size() > 0)
            {
                for(CA_Product__c br:ex.CA_Products__r)
                {
                    if(br.Product_Name__c != null && !brandsConcat.contains(br.Product_Name__c)) {
                        brandsConcat += br.Product_Name__c+', ';
                    }
                    if(br.Product_Category__c !=null){
                        BusinessUnitCategory = br.Product_Category__c;
                    }
                    if(br.Therapeutic_Area__c != null && !TherapeuticArea.contains(br.Therapeutic_Area__c)) {
                        TherapeuticArea += br.Therapeutic_Area__c+', ';
                    }
                    if(br.Business_Unit__c != null && !BusinessUnitPharma.contains(br.Business_Unit__c)) {
                        BusinessUnitPharma += br.Business_Unit__c+', ';
                    }
                    if(br.Fiber_Business_Unit__c != null && !BrandNamePharma.contains(br.Fiber_Business_Unit__c)) {
                        BrandNamePharma += br.Fiber_Business_Unit__c+', ';
                    }
                    if(br.Product_Team_Contact__c != null && !ProdTeamCon.contains(br.Product_Team_Contact__c)) {
                        ProdTeamCon += br.Product_Team_Contact__c+', ';
                    }
                }
                brandsConcat =  brandsConcat.removeEnd(', ');
                TherapeuticArea =  TherapeuticArea.removeEnd(', ');
                BusinessUnitPharma =  BusinessUnitPharma.removeEnd(', ');
                BrandNamePharma =  BrandNamePharma.removeEnd(', ');
                
                if(ex.Event__r.Event_Start_Date__c != null){
                    List<String> splitDate = string.valueOf(ex.Event__r.Event_Start_Date__c).split('-');
                    startDate = splitDate[1]+'/'+splitDate[2]+'/'+splitDate[0];
                }
                
                if(ex.Event__r.Event_End_Date__c != null){
                    List<String> splitDate1 = string.valueOf(ex.Event__r.Event_End_Date__c).split('-');
                    closeDate = splitDate1[1]+'/'+splitDate1[2]+'/'+splitDate1[0];
                }
                
                String ExhibitHours = '';
                if(ex.Event__r.Exhibit_Hours_Day_1__c != null){
                    ExhibitHours += 'Exhibit Hours Day 1 : ' + ex.Event__r.Exhibit_Hours_Day_1__c;
                }
                if(ex.Event__r.Exhibit_Hours_Day_2__c != null){
                    ExhibitHours += ' ,    ' + 'Exhibit Hours Day 2 : ' + ex.Event__r.Exhibit_Hours_Day_2__c;
                }
                if(ex.Event__r.Exhibit_Hours_Day_3__c != null){
                    ExhibitHours += ' ,    ' + 'Exhibit Hours Day 3 : ' + ex.Event__r.Exhibit_Hours_Day_3__c;
                }
                if(ex.Event__r.Exhibit_Hours_Day_4__c != null){
                    ExhibitHours += ' ,    ' + 'Exhibit Hours Day 4 : ' + ex.Event__r.Exhibit_Hours_Day_4__c;
                }
                ExhibitHours.removeStart(' , ');
                ExhibitHours.removeEnd(' , ');
                system.debug('------ExhibitHours' + ExhibitHours);
                
                List<String> Locations = new List<String>();
                
                if(!String.isBlank(ex.Event__r.Shipping_City__c)){
                    Locations.add(ex.Event__r.Shipping_City__c);
                }
                if(!String.isBlank(ex.Event__r.Shipping_State_Province__c)){
                    Locations.add(ex.Event__r.Shipping_State_Province__c);
                }
                if(!String.isBlank(ex.Event__r.Shipping_Country__c)){
                    if(ex.Event__r.Shipping_Country__c != 'United States' && ex.Event__r.Shipping_Country__c != 'US' && ex.Event__r.Shipping_Country__c != 'USA') {
                        Locations.add(ex.Event__r.Shipping_Country__c);
                    }
                }
                Location = String.join(Locations, ', ');
                
                EventLevel = String.isBlank(ex.Event__r.Event_Level__c) ? ex.Event__r.Event_Level__c : '';
                
                dispEventWrapper.Add(new exhibitListWrapper(
                    ex.Event__r.Name_of_Event__c,
                    '',
                    ex.Event__r.Event_Acronym__c,
                    '',
                    EventLevel,
                    '',
                    ex.Event__r.No_of_HCP_s_in_Attendance__c,
                    '',
                    ex.Activity_Level__c,
                    ex.GES_Account_Manager__c,
                    ex.GES_Account_Executive__c,
                    ex.Event_Manager__c,
                    '',
                    '',
                    'Event',
                    ex.Event__r.Shipping_Country__c,
                    Location,
                    ex.Event__r.Name_of_the_Facility__c,
                    0,
                    0,
                    '',
                    brandsConcat,
                    BusinessUnitCategory,
                    TherapeuticArea,
                    BusinessUnitPharma,
                    BrandNamePharma,
                    ExhibitHours,
                    startDate,
                    '',
                    closeDate,
                    '',
                    ex.Event__r.GES_Supported_Event__c
                ));
            }
            
        }
        return dispEventWrapper;
    }
    /*
public static string regAttendOnlyQuery() {
Boolean falseValue = false;
String regAttendOnlyQuery = 'select Activity_Level__c, Reg_Attend_Name__c,  GES_Account_Manager__c, GES_Account_Executive__c, ';

regAttendOnlyQuery += ' Event__r.Name_of_Event__c, Event__r.Event_Acronym__c, Event__r.Shipping_City__c, Event__r.GES_Project_Number__c, Event__r.GES_Supported_Event__c,';

regAttendOnlyQuery += ' Event__r.No_of_HCP_s_in_Attendance__c,';

regAttendOnlyQuery += ' Event__r.Shipping_State_Province__c, Event__r.Shipping_Country__c,  Event__r.Event_Start_Date__c, Event__r.Event_End_Date__c,';

regAttendOnlyQuery += ' Event__r.Name_of_the_Facility__c,Event__r.Exhibit_Hours_Day_1__c, Event__r.Exhibit_Hours_Day_2__c, Event__r.Exhibit_Hours_Day_3__c, Event__r.Exhibit_Hours_Day_4__c , Event__r.GES_Account_Manager__c, Event__r.GES_Meeting_Planner__c, Event__r.ID_Supervisor__c, Event__r.GES_Account_Executive__c,';

regAttendOnlyQuery += ' (select Business_Unit__c,Product_Category__c,Therapeutic_Area__c,Business_Unit_Pharma__c,Fiber_Business_Unit__c, Product_Team_Contact__c from CA_Products__r where Cancelled__c =: falseValue) from GT_Reg_Attend_Only__c';
regAttendOnlyQuery += ' where Canceled__c =: falseValue';

return regAttendOnlyQuery;
}

public static List<exhibitListWrapper> populateRegAttendOnlyValues(List<GT_Reg_Attend_Only__c> listRegAttend) {
List<exhibitListWrapper> dispEventWrapper = new List<exhibitListWrapper>();
for(GT_Reg_Attend_Only__c ex: listRegAttend)
{
String brandsConcat = '';
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
if(br.Product_Name__c != null && !brandsConcat.contains(br.Product_Name__c)) {
brandsConcat += br.Product_Name__c+', ';
}
if(br.Product_Category_CrownCastle__c !=null){
BusinessUnitCategory = br.Product_Category_CrownCastle__c;
}
if(br.Therapeutic_Area__c != null && !TherapeuticArea.contains(br.Therapeutic_Area__c)) {
TherapeuticArea += br.Therapeutic_Area__c+', ';
}

if(br.Business_Unit__c != null && !BusinessUnitPharma.contains(br.Business_Unit__c)) {
BusinessUnitPharma += br.Business_Unit__c+', ';
}
if(br.Brand_Name_Pharma__c != null && !BrandNamePharma.contains(br.Brand_Name_Pharma__c)) {
BrandNamePharma += br.Brand_Name_Pharma__c+', ';
}
}
brandsConcat =  brandsConcat.removeEnd(', ');
TherapeuticArea =  TherapeuticArea.removeEnd(', ');

BusinessUnitPharma =  BusinessUnitPharma.removeEnd(', ');
BrandNamePharma =  BrandNamePharma.removeEnd(', ');

if(ex.Event__r.Event_Start_Date__c != null){
List<String> splitDate = string.valueOf(ex.Event__r.Event_Start_Date__c).split('-');
startDate = splitDate[1]+'/'+splitDate[2]+'/'+splitDate[0];
}

if(ex.Event__r.Event_End_Date__c != null){
List<String> splitDate1 = string.valueOf(ex.Event__r.Event_End_Date__c).split('-');
closeDate = splitDate1[1]+'/'+splitDate1[2]+'/'+splitDate1[0];
}

String ExhibitHours = '';
if(ex.Event__r.Exhibit_Hours_Day_1__c != null){
ExhibitHours += 'Exhibit Hours Day 1 : ' + ex.Event__r.Exhibit_Hours_Day_1__c;
}
if(ex.Event__r.Exhibit_Hours_Day_2__c != null){
ExhibitHours += ' ,    ' + 'Exhibit Hours Day 2 : ' + ex.Event__r.Exhibit_Hours_Day_2__c;
}
if(ex.Event__r.Exhibit_Hours_Day_3__c != null){
ExhibitHours += ' ,    ' + 'Exhibit Hours Day 3 : ' + ex.Event__r.Exhibit_Hours_Day_3__c;
}
if(ex.Event__r.Exhibit_Hours_Day_4__c != null){
ExhibitHours += ' ,    ' + 'Exhibit Hours Day 4 : ' + ex.Event__r.Exhibit_Hours_Day_4__c;
}
ExhibitHours.removeStart(' , ');
ExhibitHours.removeEnd(' , ');
system.debug('------ExhibitHours' + ExhibitHours);

List<String> Locations = new List<String>();

if(!String.isBlank(ex.Event__r.Shipping_City__c)){
Locations.add(ex.Event__r.Shipping_City__c);
}
if(!String.isBlank(ex.Event__r.Shipping_State_Province__c)){
Locations.add(ex.Event__r.Shipping_State_Province__c);
}
if(!String.isBlank(ex.Event__r.Shipping_Country__c)){
if(ex.Event__r.Shipping_Country__c != 'United States' && ex.Event__r.Shipping_Country__c != 'US' && ex.Event__r.Shipping_Country__c != 'USA') {
Locations.add(ex.Event__r.Shipping_Country__c);
}
}
Location = String.join(Locations, ', ');

dispEventWrapper.Add(new exhibitListWrapper(
ex.Event__r.Name_of_Event__c,
'',
ex.Event__r.Event_Acronym__c,
'',
null,
'',
ex.Event__r.No_of_HCP_s_in_Attendance__c,
'',
ex.Activity_Level__c, 
ex.GES_Account_Manager__c,
ex.GES_Account_Executive__c,
null,
null,
'',
'Registration/Attend Only',
ex.Event__r.Shipping_Country__c,
Location,
ex.Event__r.Name_of_the_Facility__c,
0,
0,
'',
brandsConcat,
BusinessUnitCategory,
TherapeuticArea,
BusinessUnitPharma,
BrandNamePharma,
ExhibitHours,
startDate,
'',
closeDate,
'',
ex.Event__r.GES_Supported_Event__c
));
}
}
return dispEventWrapper;
}
/*
public static List<exhibitListWrapper> populateMembership(List<GT_Membership__c> listRegAttend) {
List<exhibitListWrapper> dispEventWrapper = new List<exhibitListWrapper>();
for(GT_Membership__c ex: listRegAttend)
{
String brandsConcat = '';
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
if(br.Product_Name__c != null && !brandsConcat.contains(br.Product_Name__c)) {
brandsConcat += br.Product_Name__c+', ';
}
if(br.Product_Category_CrownCastle__c !=null){
BusinessUnitCategory = br.Product_Category_CrownCastle__c;
}
if(br.Therapeutic_Area__c != null && !TherapeuticArea.contains(br.Therapeutic_Area__c)) {
TherapeuticArea += br.Therapeutic_Area__c+', ';
}

if(br.Business_Unit__c != null && !BusinessUnitPharma.contains(br.Business_Unit__c)) {
BusinessUnitPharma += br.Business_Unit__c+', ';
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

if(ex.Event__r.Event_Start_Date__c != null){
List<String> splitDate = string.valueOf(ex.Event__r.Event_Start_Date__c).split('-');
startDate = splitDate[1]+'/'+splitDate[2]+'/'+splitDate[0];
}

if(ex.Event__r.Event_End_Date__c != null){
List<String> splitDate1 = string.valueOf(ex.Event__r.Event_End_Date__c).split('-');
closeDate = splitDate1[1]+'/'+splitDate1[2]+'/'+splitDate1[0];
}
if(ex.Event__r.Congress_Start_Date__c != null){
List<String> splitDate = string.valueOf(ex.Event__r.Congress_Start_Date__c).split('-');
congressStartDate = splitDate[1]+'/'+splitDate[2]+'/'+splitDate[0];
}

if(ex.Event__r.Congress_End_Date__c != null){
List<String> splitDate1 = string.valueOf(ex.Event__r.Congress_End_Date__c).split('-');
congressCloseDate = splitDate1[1]+'/'+splitDate1[2]+'/'+splitDate1[0];
}

String ExhibitHours = '';
if(ex.Event__r.Exhibit_Hours_Day_1__c != null){
ExhibitHours += 'Exhibit Hours Day 1 : ' + ex.Event__r.Exhibit_Hours_Day_1__c;
}
if(ex.Event__r.Exhibit_Hours_Day_2__c != null){
ExhibitHours += ' ,    ' + 'Exhibit Hours Day 2 : ' + ex.Event__r.Exhibit_Hours_Day_2__c;
}
if(ex.Event__r.Exhibit_Hours_Day_3__c != null){
ExhibitHours += ' ,    ' + 'Exhibit Hours Day 3 : ' + ex.Event__r.Exhibit_Hours_Day_3__c;
}
if(ex.Event__r.Exhibit_Hours_Day_4__c != null){
ExhibitHours += ' ,    ' + 'Exhibit Hours Day 4 : ' + ex.Event__r.Exhibit_Hours_Day_4__c;
}
ExhibitHours.removeStart(' , ');
ExhibitHours.removeEnd(' , ');
system.debug('------ExhibitHours' + ExhibitHours);

List<String> Locations = new List<String>();

if(!String.isBlank(ex.Event__r.Shipping_City__c)){
Locations.add(ex.Event__r.Shipping_City__c);
}
if(!String.isBlank(ex.Event__r.Shipping_State_Province__c)){
Locations.add(ex.Event__r.Shipping_State_Province__c);
}
if(!String.isBlank(ex.Event__r.Shipping_Country__c)){
if(ex.Event__r.Shipping_Country__c != 'United States' && ex.Event__r.Shipping_Country__c != 'US' && ex.Event__r.Shipping_Country__c != 'USA') {
Locations.add(ex.Event__r.Shipping_Country__c);
}
}
Location = String.join(Locations, ', ');

//EventLevel = String.isBlank(ex.Event__r.Congress_Level__c) ? ex.Event__r.Event_Level__c : ex.Event__r.Congress_Level__c;

dispEventWrapper.Add(new exhibitListWrapper(
ex.Event__r.Name_of_Event__c,
ex.Event__r.Name_of_Congress__c,
ex.Event__r.Event_Acronym__c,
ex.Event__r.Congress_Acronym__c,
null,
ex.Event__r.Congress_Type__c,
ex.Event__r.No_of_HCP_s_in_Attendance__c,
ex.Event__r.Congress_Website__c,
'', 
ex.GES_Account_Manager__c,
ex.GES_Account_Executive__c,
null,
null,
ex.CC_Project_Manager__c,
'Membership',
ex.Event__r.Shipping_Country__c,
Location,
ex.Event__r.Name_of_the_Facility__c,
0,
0,
'',
brandsConcat,
BusinessUnitCategory,
TherapeuticArea,
BusinessUnitPharma,
BrandNamePharma,
ExhibitHours,
startDate,
congressStartDate,
closeDate,
congressCloseDate,
ex.Event__r.GES_Supported_Event__c
));

}
// System.debug('dispEventWrapper-----'+dispEventWrapper);
return dispEventWrapper;
}

public static string membershipQuery() {
Boolean falseValue = false;
String membershipQueryString = 'select  CA_Main_Event__c,Membership_Name__c, GES_Account_Manager__c, GES_Account_Executive__c, CC_Project_Manager__c, ';

membershipQueryString += ' Event__r.Name_of_Event__c, Event__r.Event_Acronym__c, Event__r.Shipping_City__c, Event__r.GES_Project_Number__c, Event__r.GES_Supported_Event__c,';

membershipQueryString += 'Event__r.Name_Of_Congress__c, Event__r.Congress_Acronym__c,Event__r.Congress_Level__c, Event__r.Congress_Type__c, Event__r.No_of_HCP_s_in_Attendance__c, Event__r.Congress_Website__c, Event__r.Congress_Start_Date__c, Event__r.Congress_End_Date__c,';

membershipQueryString += ' Event__r.Shipping_State_Province__c, Event__r.Shipping_Country__c,  Event__r.Event_Start_Date__c, Event__r.Event_End_Date__c,';

membershipQueryString += ' Event__r.Name_of_the_Facility__c,Event__r.Exhibit_Hours_Day_1__c, Event__r.Exhibit_Hours_Day_2__c, Event__r.Exhibit_Hours_Day_3__c, Event__r.Exhibit_Hours_Day_4__c ,Event__r.GES_Account_Manager__c, Event__r.GES_Meeting_Planner__c, Event__r.ID_Supervisor__c, Event__r.GES_Account_Executive__c,';

membershipQueryString += ' (select Product_Name__c,Product_Category_CrownCastle__c,Therapeutic_Area__c,Business_Unit_Pharma__c,Brand_Name_Pharma__c from Products__r where Canceled__c =: falseValue) from GT_Membership__c';
membershipQueryString += ' where Canceled__c =: falseValue';
return membershipQueryString;
}

public static List<exhibitListWrapper> populateSportingEvet(List<GT_Sporting_Event__c> listRegAttend) {
List<exhibitListWrapper> dispEventWrapper = new List<exhibitListWrapper>();
for(GT_Sporting_Event__c ex: listRegAttend)
{
String brandsConcat = '';
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
if(br.Product_Name__c != null && !brandsConcat.contains(br.Product_Name__c)) {
brandsConcat += br.Product_Name__c+', ';
}
if(br.Product_Category_CrownCastle__c !=null){
BusinessUnitCategory = br.Product_Category_CrownCastle__c;
}
if(br.Therapeutic_Area__c != null && !TherapeuticArea.contains(br.Therapeutic_Area__c)) {
TherapeuticArea += br.Therapeutic_Area__c+', ';
}

if(br.Business_Unit__c != null && !BusinessUnitPharma.contains(br.Business_Unit__c)) {
BusinessUnitPharma += br.Business_Unit__c+', ';
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

if(ex.Event__r.Event_Start_Date__c != null){
List<String> splitDate = string.valueOf(ex.Event__r.Event_Start_Date__c).split('-');
startDate = splitDate[1]+'/'+splitDate[2]+'/'+splitDate[0];
}

if(ex.Event__r.Event_End_Date__c != null){
List<String> splitDate1 = string.valueOf(ex.Event__r.Event_End_Date__c).split('-');
closeDate = splitDate1[1]+'/'+splitDate1[2]+'/'+splitDate1[0];
}

if(ex.Event__r.Congress_Start_Date__c != null){
List<String> splitDate = string.valueOf(ex.Event__r.Congress_Start_Date__c).split('-');
congressStartDate = splitDate[1]+'/'+splitDate[2]+'/'+splitDate[0];
}

if(ex.Event__r.Congress_End_Date__c != null){
List<String> splitDate1 = string.valueOf(ex.Event__r.Congress_End_Date__c).split('-');
congressCloseDate = splitDate1[1]+'/'+splitDate1[2]+'/'+splitDate1[0];
}

String ExhibitHours = '';
system.debug('------ex.Event__r.Exhibit_Hours_Day_1__c' + ex.Event__r.Exhibit_Hours_Day_1__c);
if(ex.Event__r.Exhibit_Hours_Day_1__c != null){
ExhibitHours += 'Exhibit Hours Day 1 : ' + ex.Event__r.Exhibit_Hours_Day_1__c;
}
system.debug('------ex.Event__r.Exhibit_Hours_Day_2__c' + ex.Event__r.Exhibit_Hours_Day_2__c);
if(ex.Event__r.Exhibit_Hours_Day_2__c != null){
ExhibitHours += ' ,    ' + 'Exhibit Hours Day 2 : ' + ex.Event__r.Exhibit_Hours_Day_2__c;
}
system.debug('------ex.Event__r.Exhibit_Hours_Day_3__c' + ex.Event__r.Exhibit_Hours_Day_3__c);
if(ex.Event__r.Exhibit_Hours_Day_3__c != null){
ExhibitHours += ' ,    ' + 'Exhibit Hours Day 3 : ' + ex.Event__r.Exhibit_Hours_Day_3__c;
}
system.debug('------ex.Event__r.Exhibit_Hours_Day_4__c' + ex.Event__r.Exhibit_Hours_Day_4__c);
if(ex.Event__r.Exhibit_Hours_Day_4__c != null){
ExhibitHours += ' ,    ' + 'Exhibit Hours Day 4 : ' + ex.Event__r.Exhibit_Hours_Day_4__c;
}
ExhibitHours.removeStart(' , ');
ExhibitHours.removeEnd(' , ');
system.debug('------ExhibitHours' + ExhibitHours);

List<String> Locations = new List<String>();

if(!String.isBlank(ex.Event__r.Shipping_City__c)){
Locations.add(ex.Event__r.Shipping_City__c);
}
if(!String.isBlank(ex.Event__r.Shipping_State_Province__c)){
Locations.add(ex.Event__r.Shipping_State_Province__c);
}
if(!String.isBlank(ex.Event__r.Shipping_Country__c)){
if(ex.Event__r.Shipping_Country__c != 'United States' && ex.Event__r.Shipping_Country__c != 'US' && ex.Event__r.Shipping_Country__c != 'USA') {
Locations.add(ex.Event__r.Shipping_Country__c);
}
}
Location = String.join(Locations, ', ');

//EventLevel = String.isBlank(ex.Event__r.Congress_Level__c) ? ex.Event__r.Event_Level__c : ex.Event__r.Congress_Level__c;

dispEventWrapper.Add(new exhibitListWrapper(
ex.Event__r.Name_of_Event__c,
ex.Event__r.Name_of_Congress__c,
ex.Event__r.Event_Acronym__c,
ex.Event__r.Congress_Acronym__c,
null,
ex.Event__r.Congress_Type__c,
ex.Event__r.No_of_HCP_s_in_Attendance__c,
ex.Event__r.Congress_Website__c,
'', 
ex.GES_Account_Manager__c,
ex.GES_Account_Executive__c,
null,
null,
ex.CC_Project_Manager__c,
'Sporting Event',
ex.Event__r.Shipping_Country__c,
Location,
ex.Event__r.Name_of_the_Facility__c,
0,
0,
'',
brandsConcat,
BusinessUnitCategory,
TherapeuticArea,
BusinessUnitPharma,
BrandNamePharma,
ExhibitHours,
startDate,
congressStartDate,
closeDate,
congressCloseDate,
ex.Event__r.GES_Supported_Event__c
));

}
//System.debug('dispEventWrapper-----'+dispEventWrapper);
return dispEventWrapper;
}

public static string sportingEventQuery() {
Boolean falseValue = false;
String spEventQueryString = 'select  CA_Main_Event__c, Sporting_event_Name__c, GES_Account_Manager__c, GES_Account_Executive__c, CC_Project_Manager__c, ';

spEventQueryString += ' Event__r.Name_of_Event__c, Event__r.Event_Acronym__c, Event__r.Shipping_City__c, Event__r.GES_Project_Number__c, Event__r.GES_Supported_Event__c,';

spEventQueryString += 'Event__r.Name_Of_Congress__c, Event__r.Congress_Acronym__c,Event__r.Congress_Level__c, Event__r.Congress_Type__c, Event__r.No_of_HCP_s_in_Attendance__c, Event__r.Congress_Website__c, Event__r.Congress_Start_Date__c, Event__r.Congress_End_Date__c,';

spEventQueryString += ' Event__r.Shipping_State_Province__c, Event__r.Shipping_Country__c,  Event__r.Event_Start_Date__c, Event__r.Event_End_Date__c,';

spEventQueryString += ' Event__r.Name_of_the_Facility__c,Event__r.Exhibit_Hours_Day_1__c, Event__r.Exhibit_Hours_Day_2__c, Event__r.Exhibit_Hours_Day_3__c, Event__r.Exhibit_Hours_Day_4__c , Event__r.GES_Account_Manager__c, Event__r.GES_Meeting_Planner__c, Event__r.ID_Supervisor__c, Event__r.GES_Account_Executive__c,';

spEventQueryString += ' (select Product_Name__c,Product_Category_CrownCastle__c,Therapeutic_Area__c,Business_Unit_Pharma__c,Brand_Name_Pharma__c from Products__r where Canceled__c =: falseValue) from GT_Sporting_Event__c';
spEventQueryString += ' where Canceled__c =: falseValue';
return spEventQueryString;
}
*/
    
    public class exhibitListWrapper {
        @AuraEnabled public String Name_Of_Event {get; set;}
        @AuraEnabled public String Name_Of_Congress {get; set;}
        @AuraEnabled public String Event_Acronym {get; set;}
        @AuraEnabled public String Congress_Acronym {get; set;}
        @AuraEnabled public String Congress_Level {get; set;}
        @AuraEnabled public String Congress_Type {get; set;}
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
        @AuraEnabled public String City {get; set;}
        @AuraEnabled public String State{get;set;}
        @AuraEnabled public String Country{get; set;}
        @AuraEnabled public String Facility_Name {get;set;}
        @AuraEnabled public String Booth_Length {get; set;}
        @AuraEnabled public String Booth_Width {get; set;}
        @AuraEnabled public String Booth_Number {get; set;}
        @AuraEnabled public String Brands {get; set;}
        @AuraEnabled public String Business_Unit_Category {get; set;}
        @AuraEnabled public String Therapeutic_Area {get; set;}
        @AuraEnabled public String Business_Unit_Pharma {get; set;}
        @AuraEnabled public String Brand_Name_Pharma {get; set;}
        @AuraEnabled public String Prod_Team_Contact {get; set;}
        @AuraEnabled public String ExhibitHours {get; set;}
        @AuraEnabled public String Event_Manager {get; set;}
        @AuraEnabled public String Congress_Manager {get; set;}
        @AuraEnabled public String Project_Manager {get; set;}
        @AuraEnabled public String GES_Account_Manager {get; set;}        
        @AuraEnabled public String GES_Account_Executive{get; set;}
        @AuraEnabled public String Location {get; set;}
        
        public exhibitListWrapper (String nameOfEvent,String nameOfCongress, String eventAcronym, String congressAcronym,String congressLevel, String congressType, Decimal noHCPAttendance, String congressWebsite, String Level, String GESAccountMgr, String GESAccountExe,String eventManager, String CongressManager, String ProjectManager,
                                   String ActivityType,String Country, String Location, String FacilityName,
                                   Decimal exhibitSize, Decimal exhibitSize1, String boothNo, String brandsList,String BusinessUnitCategory,String TherapeuticArea, String BusinessUnitPharma, String BrandNamePharma, String exhibitHours, String eventStartDate, string congressStartDate, string eventEndDate, string congressEndDate, Boolean GESSupportedEvent)
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
            Congress_End_Date =congressEndDate;
            Facility_Name = FacilityName ;
            Event_Manager = eventManager ;
            Congress_Manager = CongressManager;
            Project_Manager = ProjectManager;
            GES_Supported_Event_Boolean = GESSupportedEvent;
            
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
            Brands = brandsList;
            Business_Unit_Category = BusinessUnitCategory;
            Therapeutic_Area = TherapeuticArea;
            Business_Unit_Pharma = BusinessUnitPharma;
            Brand_Name_Pharma = BrandNamePharma;
            //Prod_Team_Contact=ProdTeamCon;
            this.ExhibitHours = exhibitHours;         
            List<String> brandNames = brandsList.split(',');
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
        }
        public exhibitListWrapper() {}
    }
}