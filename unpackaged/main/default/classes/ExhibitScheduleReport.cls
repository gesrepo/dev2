global with sharing class ExhibitScheduleReport
{
    public Brand__c bd{get;set;}
    public Date congressDate{get;set;}
    public Date congressToDate{get;set;} 
    public transient List<exhibitListWrapper> dispWrapper{get;set;}
    public transient List<exhibitListWrapper> listDispWrapper;
    Boolean falseValue = false;
    
    //Navigation variables
    Integer counter = 0;//TO track the number of records parsed
    Integer limitSize = 1000;//Number of records to be displayed
    Integer totalSize =0; //To Store the total number of records available
    
    public ExhibitScheduleReport(ApexPages.StandardController controller)
    {
        
        bd=new Brand__c();
        //getOnLoad();
        beginning();        
    }
    
    public PageReference save() 
   {
        return page.ExhibitScheduleExcelDownload;
        
    }
    public PageReference back() 
   {
        return page.ReportsList;
        
    }
    public PageReference ExhibitschDatabrand()
    {
        Boolean falseValue = false;
        dispWrapper = new List<exhibitListWrapper>();
        listDispWrapper = new List<exhibitListWrapper>();
        Set<Id> setCongressId = new Set<Id>();
        Map<Id, List<Exhibit__c>> mapExhibit = new Map<Id, List<Exhibit__c>>();
        Map<Id, List<Sponsorship__c>> mapSponsorship = new Map<Id, List<Sponsorship__c>>();
        Map<Id, List<Product_Theater__c>> mapProductTheater = new Map<Id, List<Product_Theater__c>>();
        Map<Id, List<Symposia__c>> mapSymposia = new Map<Id, List<Symposia__c>>();
        Map<Id, List<Meeting_Room__c>> mapMeetingRoom = new Map<Id, List<Meeting_Room__c>>();
        String query = 'Select GES_Project_Number_For__c,Activity_Type_Exhibit_Instance_c__c,Activity_Type_Exhibit_Instance_c__r.Name_of_Congress__c,Activity_Type_Exhibit_Instance_c__r.Congress_Type__c,Activity_Type_Exhibit_Instance_c__r.Acronym_of_Congress__c,'; 
        query += ' Activity_Level__c,Exhibit_Name__c,Activity_Type_Exhibit_Instance_c__r.Exhibit_Open_Date__c,Activity_Type_Exhibit_Instance_c__r.Exhibit_Close_Date__c,Activity_Type_Exhibit_Instance_c__r.Shipping_City__c,GES_Congress_Manager__c,GES_Account_Manager__c,GES_Account_Executive__c,Congress_Lead__c,';
        query += ' Activity_Type_Exhibit_Instance_c__r.Shipping_State_Province__c,Activity_Type_Exhibit_Instance_c__r.Shipping_Country__c,Activity_Type_Exhibit_Instance_c__r.Facility_Name__c,Booth_Length__c,Booth_Width__c,Booth_Number__c,Activity_Type_Exhibit_Instance_c__r.GES_Account_Manager__c,';
        query += ' Activity_Type_Exhibit_Instance_c__r.GES_Meeting_Planner__c,Activity_Type_Exhibit_Instance_c__r.IDSupervisor__c,Activity_Type_Exhibit_Instance_c__r.GES_Account_Executive__c,';
        query += ' (select Brand_Name__c,GES_Congress_Manager__c,Congress_Lead__c from Brand_Instance__r where Canceled__c =: falseValue) from Exhibit__c';
        query += ' where Canceled__c =: falseValue';
        if(congressDate != null && congressToDate != null) {
            query += ' AND Activity_Type_Exhibit_Instance_c__r.Exhibit_Open_Date__c >=: congressDate AND Activity_Type_Exhibit_Instance_c__r.Exhibit_Close_Date__c <=: congressToDate';
        } else
        if(congressDate != null) {
            query += ' AND Activity_Type_Exhibit_Instance_c__r.Exhibit_Open_Date__c >=: congressDate';
        } else
        if(congressToDate != null) {
            query += ' AND Activity_Type_Exhibit_Instance_c__r.Exhibit_Close_Date__c <=: congressToDate';
        }
        query += ' order by Activity_Type_Exhibit_Instance_c__r.Exhibit_Open_Date__c limit 10000';
        List<Exhibit__c> exhibitList = Database.query(query);
        for(Exhibit__c e : exhibitList) {
            setCongressId.add(e.Activity_Type_Exhibit_Instance_c__c);
            if(!mapExhibit.containsKey(e.Activity_Type_Exhibit_Instance_c__c)) {
                mapExhibit.put(e.Activity_Type_Exhibit_Instance_c__c, new List<Exhibit__c>());
            }
            mapExhibit.get(e.Activity_Type_Exhibit_Instance_c__c).add(e);
        }
        /*****************Get Sponsorship Record****************************/
        String sponsorshipQuery = sponsorshipQuery();
        if(congressDate != null && congressToDate != null) {
            sponsorshipQuery += ' AND Sponsorship__r.Exhibit_Open_Date__c >=: congressDate AND Sponsorship__r.Exhibit_Close_Date__c <=: congressToDate';
        } else
        if(congressDate != null) {
            sponsorshipQuery += ' AND Sponsorship__r.Exhibit_Open_Date__c >=: congressDate';
        } else
        if(congressToDate != null) {
            sponsorshipQuery += ' AND Sponsorship__r.Exhibit_Close_Date__c <=: congressToDate';
        }
        sponsorshipQuery += ' order by Sponsorship__r.Exhibit_Open_Date__c limit 10000';
        List<Sponsorship__c> listSponsorship = Database.query(sponsorshipQuery);
        for(Sponsorship__c e : listSponsorship) {
            setCongressId.add(e.Sponsorship__c);
            if(!mapSponsorship.containsKey(e.Sponsorship__c)) {
                mapSponsorship.put(e.Sponsorship__c, new List<Sponsorship__c>());
            }
            mapSponsorship.get(e.Sponsorship__c).add(e);
        }
        /*********************************************/
        /*********************Get Product Theater Record*********************************/
        String prodTheaterQuery = prodTheaterQuery();
        if(congressDate != null && congressToDate != null) {
            prodTheaterQuery += ' AND Congress__r.Exhibit_Open_Date__c >=: congressDate AND Congress__r.Exhibit_Close_Date__c <=: congressToDate';
        } else
        if(congressDate != null) {
            prodTheaterQuery += ' AND Congress__r.Exhibit_Open_Date__c >=: congressDate';
        } else
        if(congressToDate != null) {
            prodTheaterQuery += ' AND Congress__r.Exhibit_Close_Date__c <=: congressToDate';
        }
        prodTheaterQuery += ' order by Congress__r.Exhibit_Open_Date__c';
        List<Product_Theater__c> listProdTheater = Database.query(prodTheaterQuery);
        for(Product_Theater__c e : listProdTheater) {
            setCongressId.add(e.Congress__c);
            if(!mapProductTheater.containsKey(e.Congress__c)) {
                mapProductTheater.put(e.Congress__c, new List<Product_Theater__c>());
            }
            mapProductTheater.get(e.Congress__c).add(e);
        }
        /******************************************************/
        /*********************Get Symposia Record*********************************/
        String symposiaQuery = symposiaQuery();
        if(congressDate != null && congressToDate != null) {
            symposiaQuery += ' AND Congress__r.Exhibit_Open_Date__c >=: congressDate AND Congress__r.Exhibit_Close_Date__c <=: congressToDate';
        } else
        if(congressDate != null) {
            symposiaQuery += ' AND Congress__r.Exhibit_Open_Date__c >=: congressDate';
        } else
        if(congressToDate != null) {
            symposiaQuery += ' AND Congress__r.Exhibit_Close_Date__c <=: congressToDate';
        }
        symposiaQuery += ' order by Congress__r.Exhibit_Open_Date__c';
        List<Symposia__c> listSymposia = Database.query(symposiaQuery);
        for(Symposia__c e : listSymposia) {
            setCongressId.add(e.Congress__c);
            if(!mapSymposia.containsKey(e.Congress__c)) {
                mapSymposia.put(e.Congress__c, new List<Symposia__c>());
            }
            mapSymposia.get(e.Congress__c).add(e);
        }
        /******************************************************/
        /*********************Get Meeting Room Record*********************************/
        String meetingRoomQuery = meetingRoomQuery();
        if(congressDate != null && congressToDate != null) {
            meetingRoomQuery += ' AND Congress__r.Exhibit_Open_Date__c >=: congressDate AND Congress__r.Exhibit_Close_Date__c <=: congressToDate';
        } else
        if(congressDate != null) {
            meetingRoomQuery += ' AND Congress__r.Exhibit_Open_Date__c >=: congressDate';
        } else
        if(congressToDate != null) {
            meetingRoomQuery += ' AND Congress__r.Exhibit_Close_Date__c <=: congressToDate';
        }
        meetingRoomQuery += ' order by Congress__r.Exhibit_Open_Date__c';
        List<Meeting_Room__c> listMeetingRoom = Database.query(meetingRoomQuery);
        for(Meeting_Room__c e : listMeetingRoom) {
            setCongressId.add(e.Congress__c);
            if(!mapMeetingRoom.containsKey(e.Congress__c)) {
                mapMeetingRoom.put(e.Congress__c, new List<Meeting_Room__c>());
            }
            mapMeetingRoom.get(e.Congress__c).add(e);
        }
        /******************************************************/
        for(Id congressId : setCongressId) {
            if(mapExhibit.get(congressId) != null)
            {
                String brandsConcat = '';
                String cmConcat = '';
                String clConcat = '';
                String startDate = '';
                String closeDate = '';
                for(Exhibit__c ex: mapExhibit.get(congressId))
                {
                    
                    if(ex.Brand_Instance__r.size() > 0)
                    {
                        for(Brand__c br:ex.Brand_Instance__r)
                        {
                            if(br.Brand_Name__c != null && !brandsConcat.contains(br.Brand_Name__c)) {
                                brandsConcat += br.Brand_Name__c+', ';
                            }
                            if(br.GES_Congress_Manager__c!=null && !cmConcat.contains(br.GES_Congress_Manager__c)){
                                cmConcat += br.GES_Congress_Manager__c+', ';
                            }
                            if(br.Congress_Lead__c!=null && !clConcat.contains(br.Congress_Lead__c)){
                                clConcat += br.Congress_Lead__c+', ';
                            }
                          //  clConcat += br.Congress_Lead__c+',';
                        }
                    }
                    brandsConcat =  brandsConcat.removeEnd(', ');
                    cmConcat = cmConcat.removeEnd(', ');
                    clConcat = clConcat.removeEnd(', ');
                    if(ex.Activity_Type_Exhibit_Instance_c__r.Exhibit_Open_Date__c != null)
                    {
                        List<String> splitDate = string.valueOf(ex.Activity_Type_Exhibit_Instance_c__r.Exhibit_Open_Date__c).split('-');
                        startDate = splitDate[1]+'/'+splitDate[2]+'/'+splitDate[0];
                    }
                    
                    if(ex.Activity_Type_Exhibit_Instance_c__r.Exhibit_Close_Date__c != null)
                    {
                        //system.debug('startDate'+startDate);
                        List<String> splitDate1 = string.valueOf(ex.Activity_Type_Exhibit_Instance_c__r.Exhibit_Close_Date__c).split('-');
                        closeDate = splitDate1[1]+'/'+splitDate1[2]+'/'+splitDate1[0];
                    }
                    
                    
                    //system.debug('closeDate +++'+closeDate);
                    listDispWrapper.Add(new exhibitListWrapper(ex.GES_Project_Number_For__c,
                                                           ex.Activity_Type_Exhibit_Instance_c__r.Name_of_Congress__c,
                                                           ex.Activity_Type_Exhibit_Instance_c__r.Acronym_of_Congress__c,
                                                           ex.Activity_Level__c,
                                                           ex.GES_Congress_Manager__c,
                                                           ex.GES_Account_Manager__c,
                                                           ex.GES_Account_Executive__c,
                                                           ex.Congress_Lead__c,
                                                           'Exhibit',
                                                           ex.Activity_Type_Exhibit_Instance_c__r.Shipping_City__c,
                                                           ex.Activity_Type_Exhibit_Instance_c__r.Shipping_State_Province__c,
                                                           ex.Activity_Type_Exhibit_Instance_c__r.Shipping_Country__c,
                                                           ex.Activity_Type_Exhibit_Instance_c__r.Congress_Type__c,
                                                           ex.Activity_Type_Exhibit_Instance_c__r.Facility_Name__c,                                           
                                                           ex.Booth_Length__c,
                                                           ex.Booth_Width__c,
                                                           ex.Booth_Number__c,
                                                           brandsConcat,
                                                           cmConcat,
                                                           clConcat,
                                                           ex.Activity_Type_Exhibit_Instance_c__r.GES_Account_Manager__c,
                                                           ex.Activity_Type_Exhibit_Instance_c__r.GES_Meeting_Planner__c,
                                                           ex.Activity_Type_Exhibit_Instance_c__r.IDSupervisor__c,
                                                           ex.Activity_Type_Exhibit_Instance_c__r.GES_Account_Executive__c,
                                                           startDate,
                                                           closeDate
                                                         ));
                   brandsConcat = '';
                   cmConcat = '';
                   clConcat = '';
                   //system.debug('ex.Activity_Type_Exhibit_Instance_c__r.Exhibit_Open_Date__c'+ex.Activity_Type_Exhibit_Instance_c__r.Exhibit_Open_Date__c);
                }
                //system.debug('dispWrapperList++++'+dispWrapper);
            }
            /******Sponsorship Activity Type******/
            if(mapSponsorship.get(congressId) != null) {
                List<exhibitListWrapper> dispSponsorshipWrapper = populateSponsorshipWrapperValues(mapSponsorship.get(congressId));
                if(dispSponsorshipWrapper.size() > 0) {
                    listDispWrapper.addAll(dispSponsorshipWrapper);
                }
            }
            /******Sponsorship Activity Type Till here******/
            
            /******Product Theater Activity Type******/
            if(mapProductTheater.get(congressId) != null) {
                List<exhibitListWrapper> dispProdTheaterWrapper = populateProdTheaterWrapperValues(mapProductTheater.get(congressId));
                if(dispProdTheaterWrapper.size() > 0) {
                    listDispWrapper.addAll(dispProdTheaterWrapper);
                }
            }
            /******Product Theater Activity Type Till here******/
            
            /******Symposia Activity Type******/
            if(mapSymposia.get(congressId) != null) {
                List<exhibitListWrapper> dispSymposiaWrapper = populateSymposiaWrapperValues(mapSymposia.get(congressId));
                if(dispSymposiaWrapper.size() > 0) {
                    listDispWrapper.addAll(dispSymposiaWrapper);
                }
            }
            /******Symposia Activity Type Till here******/
            
             /******Meeting Room Activity Type******/
            if(mapMeetingRoom.get(congressId) != null) {
                List<exhibitListWrapper> dispMeetingRoomWrapper = populateMRWrapperValues(mapMeetingRoom.get(congressId));
                if(dispMeetingRoomWrapper.size() > 0) {
                    listDispWrapper.addAll(dispMeetingRoomWrapper);
                }
            }
            /******Meeting Room Activity Type Till here******/
        }
        return null;
    }
    
    @RemoteAction
    global static String exportExcelReport(String congressDateStr, String congressToDateStr) {
        Boolean falseValue = false;
        List<exhibitListWrapper> dispWrapper = new List<exhibitListWrapper>();
        Date congressDate;
        Date congressToDate;
        Set<Id> setCongressId = new Set<Id>();
        Map<Id, List<Exhibit__c>> mapExhibit = new Map<Id, List<Exhibit__c>>();
        Map<Id, List<Sponsorship__c>> mapSponsorship = new Map<Id, List<Sponsorship__c>>();
        Map<Id, List<Product_Theater__c>> mapProductTheater = new Map<Id, List<Product_Theater__c>>();
        Map<Id, List<Symposia__c>> mapSymposia = new Map<Id, List<Symposia__c>>();
        Map<Id, List<Meeting_Room__c>> mapMeetingRoom = new Map<Id, List<Meeting_Room__c>>();
        system.debug('congressDateStr==='+congressDateStr);
        if(congressDateStr != null && congressDateStr != '') {
            congressDate = Date.valueof(congressDateStr);
        }
        if(congressToDateStr != null && congressToDateStr != '') {
            congressToDate = Date.valueof(congressToDateStr);
        }
        String query = 'Select GES_Project_Number_For__c,Activity_Type_Exhibit_Instance_c__r.Name_of_Congress__c,Activity_Type_Exhibit_Instance_c__r.Congress_Type__c,Activity_Type_Exhibit_Instance_c__r.Acronym_of_Congress__c,'; 
        query += ' Activity_Level__c,Exhibit_Name__c,Activity_Type_Exhibit_Instance_c__r.Exhibit_Open_Date__c,Activity_Type_Exhibit_Instance_c__r.Exhibit_Close_Date__c,Activity_Type_Exhibit_Instance_c__r.Shipping_City__c,GES_Congress_Manager__c,GES_Account_Manager__c,GES_Account_Executive__c,Congress_Lead__c,';
        query += ' Activity_Type_Exhibit_Instance_c__r.Shipping_State_Province__c,Activity_Type_Exhibit_Instance_c__r.Shipping_Country__c,Activity_Type_Exhibit_Instance_c__r.Facility_Name__c,Booth_Length__c,Booth_Width__c,Booth_Number__c,Activity_Type_Exhibit_Instance_c__r.GES_Account_Manager__c,';
        query += ' Activity_Type_Exhibit_Instance_c__r.GES_Meeting_Planner__c,Activity_Type_Exhibit_Instance_c__r.IDSupervisor__c,Activity_Type_Exhibit_Instance_c__r.GES_Account_Executive__c,';
        query += ' (select Brand_Name__c,GES_Congress_Manager__c,Congress_Lead__c from Brand_Instance__r where Canceled__c =: falseValue) from Exhibit__c';
        query += ' where Canceled__c =: falseValue';
        if(congressDateStr != null && congressDateStr != '' && congressToDateStr != null && congressToDateStr != '') {
            query += ' AND Activity_Type_Exhibit_Instance_c__r.Exhibit_Open_Date__c >=: congressDate AND Activity_Type_Exhibit_Instance_c__r.Exhibit_Close_Date__c <=: congressToDate';
        } else
        if(congressDateStr != null && congressDateStr != '') {
            query += ' AND Activity_Type_Exhibit_Instance_c__r.Exhibit_Open_Date__c >=: congressDate';
        } else
        if(congressToDateStr != null && congressToDateStr != '') {
            query += ' AND Activity_Type_Exhibit_Instance_c__r.Exhibit_Close_Date__c <=: congressToDate';
        }
        query += ' order by Activity_Type_Exhibit_Instance_c__r.Exhibit_Open_Date__c';
        List<Exhibit__c> exhibitList = Database.query(query);
        for(Exhibit__c e : exhibitList) {
            setCongressId.add(e.Activity_Type_Exhibit_Instance_c__c);
            if(!mapExhibit.containsKey(e.Activity_Type_Exhibit_Instance_c__c)) {
                mapExhibit.put(e.Activity_Type_Exhibit_Instance_c__c, new List<Exhibit__c>());
            }
            mapExhibit.get(e.Activity_Type_Exhibit_Instance_c__c).add(e);
        }
        /*****************Get Sponsorship Record****************************/
        String sponsorshipQuery = sponsorshipQuery();
        if(congressDate != null && congressToDate != null) {
            sponsorshipQuery += ' AND Sponsorship__r.Exhibit_Open_Date__c >=: congressDate AND Sponsorship__r.Exhibit_Close_Date__c <=: congressToDate';
        } else
        if(congressDate != null) {
            sponsorshipQuery += ' AND Sponsorship__r.Exhibit_Open_Date__c >=: congressDate';
        } else
        if(congressToDate != null) {
            sponsorshipQuery += ' AND Sponsorship__r.Exhibit_Close_Date__c <=: congressToDate';
        }
        sponsorshipQuery += ' order by Sponsorship__r.Exhibit_Open_Date__c limit 10000';
        List<Sponsorship__c> listSponsorship = Database.query(sponsorshipQuery);
        for(Sponsorship__c e : listSponsorship) {
            setCongressId.add(e.Sponsorship__c);
            if(!mapSponsorship.containsKey(e.Sponsorship__c)) {
                mapSponsorship.put(e.Sponsorship__c, new List<Sponsorship__c>());
            }
            mapSponsorship.get(e.Sponsorship__c).add(e);
        }
        /*********************************************/
        /*********************Get Product Theater Record*********************************/
        String prodTheaterQuery = prodTheaterQuery();
        if(congressDate != null && congressToDate != null) {
            prodTheaterQuery += ' AND Congress__r.Exhibit_Open_Date__c >=: congressDate AND Congress__r.Exhibit_Close_Date__c <=: congressToDate';
        } else
        if(congressDate != null) {
            prodTheaterQuery += ' AND Congress__r.Exhibit_Open_Date__c >=: congressDate';
        } else
        if(congressToDate != null) {
            prodTheaterQuery += ' AND Congress__r.Exhibit_Close_Date__c <=: congressToDate';
        }
        prodTheaterQuery += ' order by Congress__r.Exhibit_Open_Date__c';
        List<Product_Theater__c> listProdTheater = Database.query(prodTheaterQuery);
        for(Product_Theater__c e : listProdTheater) {
            setCongressId.add(e.Congress__c);
            if(!mapProductTheater.containsKey(e.Congress__c)) {
                mapProductTheater.put(e.Congress__c, new List<Product_Theater__c>());
            }
            mapProductTheater.get(e.Congress__c).add(e);
        }
        /******************************************************/
        /*********************Get Symposia Record*********************************/
        String symposiaQuery = symposiaQuery();
        if(congressDate != null && congressToDate != null) {
            symposiaQuery += ' AND Congress__r.Exhibit_Open_Date__c >=: congressDate AND Congress__r.Exhibit_Close_Date__c <=: congressToDate';
        } else
        if(congressDate != null) {
            symposiaQuery += ' AND Congress__r.Exhibit_Open_Date__c >=: congressDate';
        } else
        if(congressToDate != null) {
            symposiaQuery += ' AND Congress__r.Exhibit_Close_Date__c <=: congressToDate';
        }
        symposiaQuery += ' order by Congress__r.Exhibit_Open_Date__c';
        List<Symposia__c> listSymposia = Database.query(symposiaQuery);
        for(Symposia__c e : listSymposia) {
            setCongressId.add(e.Congress__c);
            if(!mapSymposia.containsKey(e.Congress__c)) {
                mapSymposia.put(e.Congress__c, new List<Symposia__c>());
            }
            mapSymposia.get(e.Congress__c).add(e);
        }
        /******************************************************/
        /*********************Get Meeting Room Record*********************************/
        String meetingRoomQuery = meetingRoomQuery();
        if(congressDate != null && congressToDate != null) {
            meetingRoomQuery += ' AND Congress__r.Exhibit_Open_Date__c >=: congressDate AND Congress__r.Exhibit_Close_Date__c <=: congressToDate';
        } else
        if(congressDate != null) {
            meetingRoomQuery += ' AND Congress__r.Exhibit_Open_Date__c >=: congressDate';
        } else
        if(congressToDate != null) {
            meetingRoomQuery += ' AND Congress__r.Exhibit_Close_Date__c <=: congressToDate';
        }
        meetingRoomQuery += ' order by Congress__r.Exhibit_Open_Date__c';
        List<Meeting_Room__c> listMeetingRoom = Database.query(meetingRoomQuery);
        for(Meeting_Room__c e : listMeetingRoom) {
            setCongressId.add(e.Congress__c);
            if(!mapMeetingRoom.containsKey(e.Congress__c)) {
                mapMeetingRoom.put(e.Congress__c, new List<Meeting_Room__c>());
            }
            mapMeetingRoom.get(e.Congress__c).add(e);
        }
        /******************************************************/
       
        for(Id congressId : setCongressId) {
            if(mapExhibit.get(congressId) != null)
            {
                String brandsConcat = '';
                String cmConcat = '';
                String clConcat = '';
                String startDate = '';
                String closeDate = '';
                for(Exhibit__c ex: mapExhibit.get(congressId))
                {
                    
                    if(ex.Brand_Instance__r.size() > 0)
                    {
                        for(Brand__c br:ex.Brand_Instance__r)
                        {
                            if(br.Brand_Name__c != null && !brandsConcat.contains(br.Brand_Name__c)) {
                                brandsConcat += br.Brand_Name__c+', ';
                            }
                            if(br.GES_Congress_Manager__c!=null && !cmConcat.contains(br.GES_Congress_Manager__c)){
                                cmConcat += br.GES_Congress_Manager__c+', ';
                            }
                            if(br.Congress_Lead__c!=null && !clConcat.contains(br.Congress_Lead__c)){
                                clConcat += br.Congress_Lead__c+', ';
                            }
                          //  clConcat += br.Congress_Lead__c+',';
                        }
                    }
                    brandsConcat =  brandsConcat.removeEnd(', ');
                    cmConcat = cmConcat.removeEnd(', ');
                    clConcat = clConcat.removeEnd(', ');
                    if(ex.Activity_Type_Exhibit_Instance_c__r.Exhibit_Open_Date__c != null)
                    {
                        List<String> splitDate = string.valueOf(ex.Activity_Type_Exhibit_Instance_c__r.Exhibit_Open_Date__c).split('-');
                        startDate = splitDate[1]+'/'+splitDate[2]+'/'+splitDate[0];
                    }
                    
                    if(ex.Activity_Type_Exhibit_Instance_c__r.Exhibit_Close_Date__c != null)
                    {
                        //system.debug('startDate'+startDate);
                        List<String> splitDate1 = string.valueOf(ex.Activity_Type_Exhibit_Instance_c__r.Exhibit_Close_Date__c).split('-');
                        closeDate = splitDate1[1]+'/'+splitDate1[2]+'/'+splitDate1[0];
                    }
                    
                    
                    //system.debug('closeDate +++'+closeDate);
                    dispWrapper.Add(new exhibitListWrapper(ex.GES_Project_Number_For__c,
                                                           ex.Activity_Type_Exhibit_Instance_c__r.Name_of_Congress__c,
                                                           ex.Activity_Type_Exhibit_Instance_c__r.Acronym_of_Congress__c,
                                                           ex.Activity_Level__c,
                                                           ex.GES_Congress_Manager__c,
                                                           ex.GES_Account_Manager__c,
                                                           ex.GES_Account_Executive__c,
                                                           ex.Congress_Lead__c,
                                                           'Exhibit',
                                                           ex.Activity_Type_Exhibit_Instance_c__r.Shipping_City__c,
                                                           ex.Activity_Type_Exhibit_Instance_c__r.Shipping_State_Province__c,
                                                           ex.Activity_Type_Exhibit_Instance_c__r.Shipping_Country__c,
                                                           ex.Activity_Type_Exhibit_Instance_c__r.Congress_Type__c,
                                                           ex.Activity_Type_Exhibit_Instance_c__r.Facility_Name__c,                                           
                                                           ex.Booth_Length__c,
                                                           ex.Booth_Width__c,
                                                           ex.Booth_Number__c,
                                                           brandsConcat,
                                                           cmConcat,
                                                           clConcat,
                                                           ex.Activity_Type_Exhibit_Instance_c__r.GES_Account_Manager__c,
                                                           ex.Activity_Type_Exhibit_Instance_c__r.GES_Meeting_Planner__c,
                                                           ex.Activity_Type_Exhibit_Instance_c__r.IDSupervisor__c,
                                                           ex.Activity_Type_Exhibit_Instance_c__r.GES_Account_Executive__c,
                                                           startDate,
                                                           closeDate
                                                           ));
                   brandsConcat = '';
                   cmConcat = '';
                   clConcat = '';
                   //system.debug('ex.Activity_Type_Exhibit_Instance_c__r.Exhibit_Open_Date__c'+ex.Activity_Type_Exhibit_Instance_c__r.Exhibit_Open_Date__c);
                }
                //system.debug('dispWrapperList++++'+dispWrapper);
            }
            /******Sponsorship Activity Type******/
            if(mapSponsorship.get(congressId) != null) {
                List<exhibitListWrapper> dispSponsorshipWrapper = populateSponsorshipWrapperValues(mapSponsorship.get(congressId));
                if(dispSponsorshipWrapper.size() > 0) {
                    dispWrapper.addAll(dispSponsorshipWrapper);
                }
            }
            /******Sponsorship Activity Type Till here******/
            
            /******Product Theater Activity Type******/
            if(mapProductTheater.get(congressId) != null) {
                List<exhibitListWrapper> dispProdTheaterWrapper = populateProdTheaterWrapperValues(mapProductTheater.get(congressId));
                if(dispProdTheaterWrapper.size() > 0) {
                    dispWrapper.addAll(dispProdTheaterWrapper);
                }
            }
            /******Product Theater Activity Type Till here******/
            
            /******Symposia Activity Type******/
            if(mapSymposia.get(congressId) != null) {
                List<exhibitListWrapper> dispSymposiaWrapper = populateSymposiaWrapperValues(mapSymposia.get(congressId));
                if(dispSymposiaWrapper.size() > 0) {
                    dispWrapper.addAll(dispSymposiaWrapper);
                }
            }
            /******Symposia Activity Type Till here******/
            
             /******Meeting Room Activity Type******/
            if(mapMeetingRoom.get(congressId) != null) {
                List<exhibitListWrapper> dispMeetingRoomWrapper = populateMRWrapperValues(mapMeetingRoom.get(congressId));
                if(dispMeetingRoomWrapper.size() > 0) {
                    dispWrapper.addAll(dispMeetingRoomWrapper);
                }
            }
            /******Meeting Room Activity Type Till here******/
        }
        
        String strJSON = JSON.serialize(dispWrapper);
        return strJSON;
    }
    
    public static string sponsorshipQuery() {
        Boolean falseValue = false;
        String sponsorshipQuery = 'select Name,Sponsorship__c,Activity_Level__c,Sponsorship_Name__c,GES_Congress_Manager__c,GES_Account_Manager__c,GES_Account_Executive__c,Congress_Lead__c,';
        sponsorshipQuery += ' Sponsorship__r.Name_of_Congress__c,Sponsorship__r.Acronym_of_Congress__c,Sponsorship__r.Shipping_City__c,Sponsorship__r.GES_Project_Number__c,';
        sponsorshipQuery += ' Sponsorship__r.Shipping_State_Province__c,Sponsorship__r.Shipping_Country__c,Sponsorship__r.Congress_Type__c,Sponsorship__r.Exhibit_Open_Date__c,Sponsorship__r.Exhibit_Close_Date__c,';
        sponsorshipQuery += ' Sponsorship__r.Facility_Name__c,Sponsorship__r.GES_Account_Manager__c,Sponsorship__r.GES_Meeting_Planner__c,Sponsorship__r.IDSupervisor__c,Sponsorship__r.GES_Account_Executive__c,';
        sponsorshipQuery += ' (select Brand_Name__c,GES_Congress_Manager__c,Congress_Lead__c from Brand__r where Canceled__c =: falseValue) from Sponsorship__c';
        sponsorshipQuery += ' where Canceled__c =: falseValue';
        return sponsorshipQuery;
    }
    
    public static List<exhibitListWrapper> populateSponsorshipWrapperValues(List<Sponsorship__c> listSponsorship) {
        List<exhibitListWrapper> dispSponsorshipWrapper = new List<exhibitListWrapper>();
        for(Sponsorship__c ex: listSponsorship)
        {
            String brandsConcat = '';
            String cmConcat = '';
            String clConcat = '';
            String startDate = '';
            String closeDate = '';
            if(ex.Brand__r.size() > 0)
            {
                for(Brand__c br:ex.Brand__r)
                {
                    if(br.Brand_Name__c != null && !brandsConcat.contains(br.Brand_Name__c)) {
                        brandsConcat += br.Brand_Name__c+', ';
                    }
                    if(br.GES_Congress_Manager__c!=null && !cmConcat.contains(br.GES_Congress_Manager__c)){
                        cmConcat += br.GES_Congress_Manager__c+', ';
                    }
                    if(br.Congress_Lead__c!=null && !clConcat.contains(br.Congress_Lead__c)){
                        clConcat += br.Congress_Lead__c+', ';
                    }
                  //  clConcat += br.Congress_Lead__c+', ';
                }
            }
            brandsConcat =  brandsConcat.removeEnd(', ');
            cmConcat = cmConcat.removeEnd(', ');
            clConcat = clConcat.removeEnd(', ');
            
            if(ex.Sponsorship__r.Exhibit_Open_Date__c != null)
            {
                List<String> splitDate = string.valueOf(ex.Sponsorship__r.Exhibit_Open_Date__c).split('-');
                //system.debug('Thest splitDate +++++'+splitDate );
                startDate = splitDate[1]+'/'+splitDate[2]+'/'+splitDate[0];
            }
            
            if(ex.Sponsorship__r.Exhibit_Close_Date__c != null)
            {
                //system.debug('These startDate +++++'+startDate );
                List<String> splitDate1 = string.valueOf(ex.Sponsorship__r.Exhibit_Close_Date__c).split('-');
                //system.debug('Close Date+++++'+splitDate1 );
                closeDate = splitDate1[1]+'/'+splitDate1[2]+'/'+splitDate1[0];
            }
            
            
            //system.debug('closeDate +++++'+closeDate );
            dispSponsorshipWrapper.Add(new exhibitListWrapper(
                                                   String.valueOf(ex.Sponsorship__r.GES_Project_Number__c),
                                                   ex.Sponsorship__r.Name_of_Congress__c,
                                                   ex.Sponsorship__r.Acronym_of_Congress__c,
                                                   ex.Activity_Level__c,
                                                   ex.GES_Congress_Manager__c,
                                                   ex.GES_Account_Manager__c,
                                                   ex.GES_Account_Executive__c,
                                                   ex.Congress_Lead__c,
                                                   'Sponsorship',
                                                   ex.Sponsorship__r.Shipping_City__c,
                                                   ex.Sponsorship__r.Shipping_State_Province__c,
                                                   ex.Sponsorship__r.Shipping_Country__c,
                                                   ex.Sponsorship__r.Congress_Type__c,
                                                   ex.Sponsorship__r.Facility_Name__c,
                                                   0,
                                                   0,
                                                   '',
                                                   brandsConcat,
                                                   cmConcat,
                                                   clConcat,
                                                   ex.Sponsorship__r.GES_Account_Manager__c,
                                                   ex.Sponsorship__r.GES_Meeting_Planner__c,
                                                   ex.Sponsorship__r.IDSupervisor__c,
                                                   ex.Sponsorship__r.GES_Account_Executive__c,
                                                   startDate,
                                                   closeDate
                                                   ));
        }
        return dispSponsorshipWrapper;
    }
    
    public static string prodTheaterQuery() {
        Boolean falseValue = false;
        String prodTheaterQuery = 'select Name,Congress__c,Activity_Level__c,Product_Theater_Name__c,GES_Congress_Manager__c,GES_Account_Manager__c,GES_Account_Executive__c,Congress_Lead__c,';
        prodTheaterQuery += ' Congress__r.Name_of_Congress__c,Congress__r.Acronym_of_Congress__c,Congress__r.Shipping_City__c,Congress__r.GES_Project_Number__c,';
        prodTheaterQuery += ' Congress__r.Shipping_State_Province__c,Congress__r.Shipping_Country__c,Congress__r.Congress_Type__c,Congress__r.Exhibit_Open_Date__c,Congress__r.Exhibit_Close_Date__c,';
        prodTheaterQuery += ' Congress__r.Facility_Name__c,Congress__r.GES_Account_Manager__c,Congress__r.GES_Meeting_Planner__c,Congress__r.IDSupervisor__c,Congress__r.GES_Account_Executive__c,';
        prodTheaterQuery += ' (select Brand_Name__c,GES_Congress_Manager__c,Congress_Lead__c from Brand__r where Canceled__c =: falseValue) from Product_Theater__c';
        prodTheaterQuery += ' where Canceled__c =: falseValue';
        return prodTheaterQuery;
    }
    
    public static List<exhibitListWrapper> populateProdTheaterWrapperValues(List<Product_Theater__c> listProdTheater) {
        List<exhibitListWrapper> dispProdTheaterWrapper = new List<exhibitListWrapper>();
        for(Product_Theater__c ex: listProdTheater)
        {
            String brandsConcat = '';
            String cmConcat = '';
            String clConcat = '';
            String startDate = '';
            String closeDate = '';
            if(ex.Brand__r.size() > 0)
            {
                for(Brand__c br:ex.Brand__r)
                {
                    if(br.Brand_Name__c != null && !brandsConcat.contains(br.Brand_Name__c)) {
                        brandsConcat += br.Brand_Name__c+', ';
                    }
                    if(br.GES_Congress_Manager__c!=null && !cmConcat.contains(br.GES_Congress_Manager__c)){
                        cmConcat += br.GES_Congress_Manager__c+', ';
                    }
                    if(br.Congress_Lead__c!=null && !clConcat.contains(br.Congress_Lead__c)){
                        clConcat += br.Congress_Lead__c+', ';
                    }
                  //  clConcat += br.Congress_Lead__c+', ';
                }
            }
            brandsConcat =  brandsConcat.removeEnd(', ');
            cmConcat = cmConcat.removeEnd(', ');
            clConcat = clConcat.removeEnd(', ');
            
            if(ex.Congress__r.Exhibit_Open_Date__c != null)
            {
                List<String> splitDate = string.valueOf(ex.Congress__r.Exhibit_Open_Date__c).split('-');
                //system.debug('Thest splitDate +++++'+splitDate );
                startDate = splitDate[1]+'/'+splitDate[2]+'/'+splitDate[0];
            }
            
            if(ex.Congress__r.Exhibit_Close_Date__c != null)
            {
                //system.debug('These startDate +++++'+startDate );
                List<String> splitDate1 = string.valueOf(ex.Congress__r.Exhibit_Close_Date__c).split('-');
                //system.debug('Close Date+++++'+splitDate1 );
                closeDate = splitDate1[1]+'/'+splitDate1[2]+'/'+splitDate1[0];
            }
            
            
            //system.debug('closeDate +++++'+closeDate );
            dispProdTheaterWrapper.Add(new exhibitListWrapper(
                                                    String.valueOf(ex.Congress__r.GES_Project_Number__c),
                                                   ex.Congress__r.Name_of_Congress__c,
                                                   ex.Congress__r.Acronym_of_Congress__c,
                                                   ex.Activity_Level__c,
                                                   ex.GES_Congress_Manager__c,
                                                   ex.GES_Account_Manager__c,
                                                   ex.GES_Account_Executive__c,
                                                   ex.Congress_Lead__c,
                                                   'Product Theater',
                                                   ex.Congress__r.Shipping_City__c,
                                                   ex.Congress__r.Shipping_State_Province__c,
                                                   ex.Congress__r.Shipping_Country__c,
                                                   ex.Congress__r.Congress_Type__c,
                                                   ex.Congress__r.Facility_Name__c,
                                                   0,
                                                   0,
                                                   '',
                                                   brandsConcat,
                                                   cmConcat,
                                                   clConcat,
                                                   ex.Congress__r.GES_Account_Manager__c,
                                                   ex.Congress__r.GES_Meeting_Planner__c,
                                                   ex.Congress__r.IDSupervisor__c,
                                                   ex.Congress__r.GES_Account_Executive__c,
                                                   startDate,
                                                   closeDate
                                                   ));
        }
        return dispProdTheaterWrapper;
    }
    
    
    public static string symposiaQuery() {
        Boolean falseValue = false;
        String symposiaQuery = 'select Name,Congress__c,Activity_Level__c,Symposia_Name__c,GES_Congress_Manager__c,GES_Account_Manager__c,GES_Account_Executive__c,Congress_Lead__c,';
        symposiaQuery += ' Congress__r.Name_of_Congress__c,Congress__r.Acronym_of_Congress__c,Congress__r.Shipping_City__c,Congress__r.GES_Project_Number__c,';
        symposiaQuery += ' Congress__r.Shipping_State_Province__c,Congress__r.Shipping_Country__c,Congress__r.Congress_Type__c,Congress__r.Exhibit_Open_Date__c,Congress__r.Exhibit_Close_Date__c,';
        symposiaQuery += ' Congress__r.Facility_Name__c,Congress__r.GES_Account_Manager__c,Congress__r.GES_Meeting_Planner__c,Congress__r.IDSupervisor__c,Congress__r.GES_Account_Executive__c,';
        symposiaQuery += ' (select Brand_Name__c,GES_Congress_Manager__c,Congress_Lead__c from Brand__r where Canceled__c =: falseValue) from Symposia__c';
        symposiaQuery += ' where Canceled__c =: falseValue';
        return symposiaQuery;
    }
    
    public static List<exhibitListWrapper> populateSymposiaWrapperValues(List<Symposia__c> listSymposia) {
        List<exhibitListWrapper> dispSymposiaWrapper = new List<exhibitListWrapper>();
        for(Symposia__c ex: listSymposia)
        {
            String brandsConcat = '';
            String cmConcat = '';
            String clConcat = '';
            String startDate = '';
            String closeDate = '';
            if(ex.Brand__r.size() > 0)
            {
                for(Brand__c br:ex.Brand__r)
                {
                    if(br.Brand_Name__c != null && !brandsConcat.contains(br.Brand_Name__c)) {
                        brandsConcat += br.Brand_Name__c+', ';
                    }
                    if(br.GES_Congress_Manager__c!=null && !cmConcat.contains(br.GES_Congress_Manager__c)){
                        cmConcat += br.GES_Congress_Manager__c+', ';
                    }
                    if(br.Congress_Lead__c!=null && !clConcat.contains(br.Congress_Lead__c)){
                        clConcat += br.Congress_Lead__c+', ';
                    }
                  //  clConcat += br.Congress_Lead__c+', ';
                }
            }
            brandsConcat =  brandsConcat.removeEnd(', ');
            cmConcat = cmConcat.removeEnd(', ');
            clConcat = clConcat.removeEnd(', ');
            
            if(ex.Congress__r.Exhibit_Open_Date__c != null)
            {
                List<String> splitDate = string.valueOf(ex.Congress__r.Exhibit_Open_Date__c).split('-');
                //system.debug('Thest splitDate +++++'+splitDate );
                startDate = splitDate[1]+'/'+splitDate[2]+'/'+splitDate[0];
            }
            
            if(ex.Congress__r.Exhibit_Close_Date__c != null)
            {
                //system.debug('These startDate +++++'+startDate );
                List<String> splitDate1 = string.valueOf(ex.Congress__r.Exhibit_Close_Date__c).split('-');
                //system.debug('Close Date+++++'+splitDate1 );
                closeDate = splitDate1[1]+'/'+splitDate1[2]+'/'+splitDate1[0];
            }
            
            
            //system.debug('closeDate +++++'+closeDate );
            dispSymposiaWrapper.Add(new exhibitListWrapper(
                                                   String.valueOf(ex.Congress__r.GES_Project_Number__c),
                                                   ex.Congress__r.Name_of_Congress__c,
                                                   ex.Congress__r.Acronym_of_Congress__c,
                                                   ex.Activity_Level__c,
                                                   ex.GES_Congress_Manager__c,
                                                   ex.GES_Account_Manager__c,
                                                   ex.GES_Account_Executive__c,
                                                   ex.Congress_Lead__c,
                                                   'Symposia',
                                                   ex.Congress__r.Shipping_City__c,
                                                   ex.Congress__r.Shipping_State_Province__c,
                                                   ex.Congress__r.Shipping_Country__c,
                                                   ex.Congress__r.Congress_Type__c,
                                                   ex.Congress__r.Facility_Name__c,
                                                   0,
                                                   0,
                                                   '',
                                                   brandsConcat,
                                                   cmConcat,
                                                   clConcat,
                                                   ex.Congress__r.GES_Account_Manager__c,
                                                   ex.Congress__r.GES_Meeting_Planner__c,
                                                   ex.Congress__r.IDSupervisor__c,
                                                   ex.Congress__r.GES_Account_Executive__c,
                                                   startDate,
                                                   closeDate
                                                   ));
        }
        return dispSymposiaWrapper;
    }
    
    public static string meetingRoomQuery() {
        Boolean falseValue = false;
        String meetingRoomQuery = 'select Name,Congress__c,Activity_Level__c,Meeting_Room_Name__c,GES_Congress_Manager__c,GES_Account_Manager__c,GES_Account_Executive__c,Congress_Lead__c,';
        meetingRoomQuery += ' Congress__r.Name_of_Congress__c,Congress__r.Acronym_of_Congress__c,Congress__r.Shipping_City__c,Congress__r.GES_Project_Number__c,';
        meetingRoomQuery += ' Congress__r.Shipping_State_Province__c,Congress__r.Shipping_Country__c,Congress__r.Congress_Type__c,Congress__r.Exhibit_Open_Date__c,Congress__r.Exhibit_Close_Date__c,';
        meetingRoomQuery += ' Congress__r.Facility_Name__c,Congress__r.GES_Account_Manager__c,Congress__r.GES_Meeting_Planner__c,Congress__r.IDSupervisor__c,Congress__r.GES_Account_Executive__c,';
        meetingRoomQuery += ' (select Brand_Name__c,GES_Congress_Manager__c,Congress_Lead__c from Brand__r where Canceled__c =: falseValue) from Meeting_Room__c';
        meetingRoomQuery += ' where Canceled__c =: falseValue';
        return meetingRoomQuery;
    }
    
    public static List<exhibitListWrapper> populateMRWrapperValues(List<Meeting_Room__c> listMeetingRoom) {
        List<exhibitListWrapper> dispMeetingRoomWrapper = new List<exhibitListWrapper>();
        for(Meeting_Room__c ex: listMeetingRoom)
        {
            String brandsConcat = '';
            String cmConcat = '';
            String clConcat = '';
            String startDate = '';
            String closeDate = '';
            if(ex.Brand__r.size() > 0)
            {
                for(Brand__c br:ex.Brand__r)
                {
                    if(br.Brand_Name__c != null && !brandsConcat.contains(br.Brand_Name__c)) {
                        brandsConcat += br.Brand_Name__c+', ';
                    }
                    if(br.GES_Congress_Manager__c!=null && !cmConcat.contains(br.GES_Congress_Manager__c)){
                        cmConcat += br.GES_Congress_Manager__c+', ';
                    }
                    if(br.Congress_Lead__c!=null && !clConcat.contains(br.Congress_Lead__c)){
                        clConcat += br.Congress_Lead__c+', ';
                    }
                  //  clConcat += br.Congress_Lead__c+', ';
                }
            }
            brandsConcat =  brandsConcat.removeEnd(', ');
            cmConcat = cmConcat.removeEnd(', ');
            clConcat = clConcat.removeEnd(', ');
            
            if(ex.Congress__r.Exhibit_Open_Date__c != null)
            {
                List<String> splitDate = string.valueOf(ex.Congress__r.Exhibit_Open_Date__c).split('-');
                //system.debug('Thest splitDate +++++'+splitDate );
                startDate = splitDate[1]+'/'+splitDate[2]+'/'+splitDate[0];
            }
            
            if(ex.Congress__r.Exhibit_Close_Date__c != null)
            {
                //system.debug('These startDate +++++'+startDate );
                List<String> splitDate1 = string.valueOf(ex.Congress__r.Exhibit_Close_Date__c).split('-');
                //system.debug('Close Date+++++'+splitDate1 );
                closeDate = splitDate1[1]+'/'+splitDate1[2]+'/'+splitDate1[0];
            }
            
            
            //system.debug('closeDate +++++'+closeDate );
            dispMeetingRoomWrapper.Add(new exhibitListWrapper(
                                                   String.valueOf(ex.Congress__r.GES_Project_Number__c),
                                                   ex.Congress__r.Name_of_Congress__c,
                                                   ex.Congress__r.Acronym_of_Congress__c,
                                                   ex.Activity_Level__c,
                                                   ex.GES_Congress_Manager__c,
                                                   ex.GES_Account_Manager__c,
                                                   ex.GES_Account_Executive__c,
                                                   ex.Congress_Lead__c,
                                                   'Meeting Room',
                                                   ex.Congress__r.Shipping_City__c,
                                                   ex.Congress__r.Shipping_State_Province__c,
                                                   ex.Congress__r.Shipping_Country__c,
                                                   ex.Congress__r.Congress_Type__c,
                                                   ex.Congress__r.Facility_Name__c,
                                                   0,
                                                   0,
                                                   '',
                                                   brandsConcat,
                                                   cmConcat,
                                                   clConcat,
                                                   ex.Congress__r.GES_Account_Manager__c,
                                                   ex.Congress__r.GES_Meeting_Planner__c,
                                                   ex.Congress__r.IDSupervisor__c,
                                                   ex.Congress__r.GES_Account_Executive__c,
                                                   startDate,
                                                   closeDate
                                                   ));
        }
        return dispMeetingRoomWrapper;
    }
    
    //Navigation methods
    public void beginning(){
        ExhibitschDatabrand();
        dispWrapper = new List<exhibitListWrapper>();
        totalSize = listDispWrapper.size();
        counter=0;
        if((counter + limitSize) <= totalSize){
       
            for(Integer i=0;i<limitSize;i++){
                dispWrapper.add(listDispWrapper.get(i));
            }   
           
        } else{
       
            for(Integer i=0;i<totalSize;i++){
                dispWrapper.add(listDispWrapper.get(i));
            }       
           
        }
       
    }
   
    public void next(){
        ExhibitschDatabrand();
        dispWrapper = new List<exhibitListWrapper>();
        counter=counter+limitSize;
       
        if((counter+limitSize) <= totalSize){
            for(Integer i=counter-1;i<(counter+limitSize);i++){
                dispWrapper.add(listDispWrapper.get(i));
            }
        } else{
            for(Integer i=counter;i<totalSize;i++){
                dispWrapper.add(listDispWrapper.get(i));
            }
        }
    }
   
    public void previous(){
        ExhibitschDatabrand();
        dispWrapper = new List<exhibitListWrapper>();

        counter=counter-limitSize;       
       
        for(Integer i=counter;i<(counter+limitSize); i++){
            dispWrapper.add(listDispWrapper.get(i));
        }
    }

    public void last (){
        ExhibitschDatabrand();
        dispWrapper = new List<exhibitListWrapper>();
       
        if(math.mod(totalSize , limitSize) == 0){
            counter = limitSize * ((totalSize/limitSize)-1);
        } else if (math.mod(totalSize , limitSize) != 0){
            counter = limitSize * ((totalSize/limitSize));
        }
       
        for(Integer i=counter-1;i<totalSize-1;i++){
                dispWrapper.add(listDispWrapper.get(i));
        }
       
    }
   
    public Boolean getDisableNext(){
   
        if((counter + limitSize) >= totalSize )
            return true ;
        else
            return false ;
    }
   
    public Boolean getDisablePrevious(){
   
        if(counter == 0)
            return true ;
        else
            return false ;
    } 
    
     public class exhibitListWrapper {
        public String GESProjectNumber {get; set;}
        public String nameOfCongress {get; set;}
        public String acronym {get; set;}
        public String level {get; set;}
        public string GesCongressMgr{get; set;}
        public string GESAccountMgr{get; set;}
        public string GESAccountExe{get; set;}
        public string CongressLd{get; set;}
        public String ActivityType {get; set;}
        public String exhiBitOpenDate {get; set;}
        public String exhiBitCloseDate {get; set;}
        public String city {get; set;}
        public String state{get;set;}
        public String country{get; set;}
        public String CongressType{get; set;}
        public string FacilityName {get;set;}
        public string exhibitSize{get; set;}
        public string exhibitSize1{get; set;}
        public String boothNo {get; set;}
        public String BoothLength{get; set;}
        public String Brands {get; set;}
        public String congressManager {get; set;}
        public String CongressLead {get; set;}
        public String GesAccountmanager {get; set;}
        public String GESMeetingPlanner {get; set;}
        public String IDSupervisor {get; set;}
        public String GESAccountExecutive {get; set;}
        public string address {get; set;}
        public exhibitListWrapper (String GESProjectNumber,String nameOfCongress,String acronym,String Level,String GesCongressMgr,
                                    String GESAccountMgr,String GESAccountExe,String CongressLd,
                                    String ActivityType,String city,String state,String Country,String CongressType,String FacilityName,
                                    Decimal exhibitSize,Decimal exhibitSize1,String boothNo,String Brands,String congressManager,
                                    String CongressLead,String GesAccountmanager,String GESMeetingPlanner,String IDSupervisor,
                                    String GESAccountExecutive,string exhiBitOpenDate ,string exhiBitCloseDate ) 
        {
            if(GESProjectNumber != '0'){
                this.GESProjectNumber= GESProjectNumber;
            }
            this.nameOfCongress = nameOfCongress;
            this.acronym = acronym;
            this.level = level;
            this.GesCongressMgr = GesCongressMgr;
            this.GESAccountMgr = GESAccountMgr;
            this.GESAccountExe = GESAccountExe;
            this.CongressLd = CongressLd;
            this.ActivityType = ActivityType;
            this.exhiBitOpenDate =exhiBitOpenDate ;
            this.exhiBitCloseDate =exhiBitCloseDate ;
            this.city = city;
            this.state = state;
            this.country= country;
            this.CongressType= CongressType;
            this.FacilityName = FacilityName ;
            if(exhibitSize!= 0){
                this.ExhibitSize= String.valueOf(ExhibitSize);
                }else{
                this.ExhibitSize= '';
                }
                
            if(exhibitSize1!= 0){
                this.exhibitSize1= String.valueOf(exhibitSize1);
                }else{
                this.exhibitSize1= '';
                }
            
            
            this.BoothLength= BoothLength;
            this.boothNo = boothNo;
            this.Brands = Brands;
            
            this.congressManager = congressManager;
            
            this.CongressLead = CongressLead; 
            this.GesAccountmanager = GesAccountmanager;
            this.GESMeetingPlanner = GESMeetingPlanner;
            this.IDSupervisor = IDSupervisor;
            this.GESAccountExecutive = GESAccountExecutive; 
            if(city != null && state != null && country != null) {
                if(country != 'United States' && country != 'US' && country != 'USA') {
                    address = city + ', ' + state + ', ' + country;
                } else
                {
                    address = city + ', ' + state;
                }
            }else
            if(city != null && state != null) {
                address = city + ', ' + state;
            }else
            if(city != null && country != null) {
                address = city + ', ' + country;
            }else
            if(state != null && country != null) {
                address = city + ', ' + state;
            }else
            if(city != null) {
                 address = city;
            }else
            if(state != null) {
                 address = state;
            }else
            if(country != null) {
                 address = country ;
            }
        }
    }    
}