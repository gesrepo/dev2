global class ExhibitScheduleBasicReport
{
    public ExhibitScheduleBasicReport()
    {
        gs=new GES_Connect_Corporate_Accounts__c();
        exlst=new List<Exhibit__c>();
        getOnLoad();
    }
    public static Integer LimitSize=100;
    public static Integer OffsetSize= 100; 
    public static Integer size { get; set; }
    public Integer pageNumber = null;
    public transient static List<Exhibit__c> exlst{get;set;}
    public GES_Connect_Corporate_Accounts__c gs{get;set;}

     public static Date todate{get;set;}
    public static Date fromdate{get;set;}
    
    @RemoteAction
    public static List<Exhibit__c> getOnLoad()
    {
       exlst=[select Activity_Type_Exhibit_Instance_c__r.Name_of_Congress__c,
       Activity_Type_Exhibit_Instance_c__r.Acronym_of_Congress__c,Activity_Level__c,
       Activity_Type_Exhibit_Instance_c__r.Exhibit_Open_Date__c,Activity_Type_Exhibit_Instance_c__r.Exhibit_Close_Date__c,
       Activity_Type_Exhibit_Instance_c__r.Advanced_Warehouse_Location_Name__c,Activity_Type_Exhibit_Instance_c__r.Shipping_City__c,Activity_Type_Exhibit_Instance_c__r.Shipping_State_Province__c,
       Activity_Type_Exhibit_Instance_c__r.Shipping_Country__c,Activity_Type_Exhibit_Instance_c__r.Facility_Name__c,Booth_Length__c,Booth_Number__c,
       Booth_Width__c From Exhibit__c  where Canceled__c =: false order by Activity_Type_Exhibit_Instance_c__r.Name_of_Congress__c Asc limit :LimitSize offset :OffsetSize];
        system.debug('select Activity_Type_Exhibit_Instance_c__r.Name_of_Congress__c From Exhibit__c  where Canceled__c =: false order by Activity_Type_Exhibit_Instance_c__r.Name_of_Congress__c Asc limit :'+ LimitSize +' offset :'+OffsetSize);
        return exlst;
    }
    public PageReference back() 
   {
        return page.ReportsList;
        
    }
    public PageReference save() 
   {
        return page.ExhibitScheduleBasicExcelDownload;
        
    }
    
    @remoteAction
        public static List<Exhibit__c> ExhibitSchData(string openDateStr, string closeDateStr)
    {       
        Date lclOpenDate;
        Date lclCloseDate;
        if(openDateStr != null && openDateStr != '') {
            lclOpenDate = Date.valueof(openDateStr);
            system.debug(lclOpenDate);
        }
        if(closeDateStr != null && closeDateStr != '') {
            lclCloseDate = Date.valueof(closeDateStr);
            system.debug(lclCloseDate);
        }
        
       exlst=[SELECT   activity_type_exhibit_instance_c__r.name_of_congress__c, 
         activity_type_exhibit_instance_c__r.acronym_of_congress__c, 
         activity_level__c, 
         activity_type_exhibit_instance_c__r.exhibit_open_date__c, 
         activity_type_exhibit_instance_c__r.exhibit_close_date__c, 
         activity_type_exhibit_instance_c__r.shipping_city__c, 
         activity_type_exhibit_instance_c__r.shipping_state_province__c, 
         activity_type_exhibit_instance_c__r.shipping_country__c, 
         activity_type_exhibit_instance_c__r.facility_name__c, 
         activity_type_exhibit_instance_c__r.advanced_warehouse_location_name__c, 
         booth_length__c, 
         booth_number__c, 
         booth_width__c 
FROM     exhibit__c 
WHERE    canceled__c =false 
AND      ( 
                  activity_type_exhibit_instance_c__r.exhibit_open_date__c>=:lclOpenDate
         AND      activity_type_exhibit_instance_c__r.exhibit_close_date__c<=:lclCloseDate
          )
ORDER BY activity_type_exhibit_instance_c__r.name_of_congress__c ASC limit 9999];
        size=100;
       //system.debug('List of Exhibit'+exlst.size()); 
       system.debug('List of Exhibit'+exlst);  
       return exlst;
    }
    
   
    @RemoteAction
    global static String exportExcelReport(String congressDateStr, String congressToDateStr) {
        Date congressDate;
        Date congressToDate;
        Boolean falseValue = false;
        //system.debug('congressDateStr==='+congressDateStr);
        if(congressDateStr != null && congressDateStr != '') {
            congressDate = Date.valueof(congressDateStr);
        }
        if(congressToDateStr != null && congressToDateStr != '') {
            congressToDate = Date.valueof(congressToDateStr);
        }
        String query = 'Select GES_Project_Number_For__c,Activity_Type_Exhibit_Instance_c__r.Name_of_Congress__c,Activity_Type_Exhibit_Instance_c__r.Congress_Type__c,Activity_Type_Exhibit_Instance_c__r.Acronym_of_Congress__c,'; 
        query += ' Activity_Level__c,Exhibit_Name__c,Activity_Type_Exhibit_Instance_c__r.Exhibit_Open_Date__c,Activity_Type_Exhibit_Instance_c__r.Exhibit_Close_Date__c,Activity_Type_Exhibit_Instance_c__r.Shipping_City__c,';
        query += ' Activity_Type_Exhibit_Instance_c__r.Shipping_State_Province__c,Activity_Type_Exhibit_Instance_c__r.Shipping_Country__c,Activity_Type_Exhibit_Instance_c__r.Facility_Name__c,Booth_Length__c,Booth_Width__c,Booth_Number__c,Activity_Type_Exhibit_Instance_c__r.GES_Account_Manager__c,';
        query += ' Activity_Type_Exhibit_Instance_c__r.GES_Meeting_Planner__c,Activity_Type_Exhibit_Instance_c__r.IDSupervisor__c,Activity_Type_Exhibit_Instance_c__r.GES_Account_Executive__c,';
        query += ' (select Brand_Name__c,GES_Congress_Manager__c,Congress_Lead__c from Brand_Instance__r) from Exhibit__c';
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
        query += ' order by Activity_Type_Exhibit_Instance_c__r.Name_of_Congress__c';
        List<Exhibit__c> exhibitList = Database.query(query);
        String strJSON = JSON.serialize(exhibitList);
        return strJSON;
    }
    
    public static void next(){
        OffsetSize = OffsetSize + LimitSize;
        system.debug(OffsetSize);
        getOnLoad();
    }
    
    public static void previous(){
        OffsetSize = OffsetSize - LimitSize;
        system.debug(OffsetSize);
        getOnLoad();
    }
}