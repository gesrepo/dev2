public class MeetingRoomDetail
{
    public string mrid{get;set;}
    public string mrName{get;set;}
    public string congid{get;set;}
    public string congName{get;set;}  
    public Double offset{get{
        TimeZone tz = UserInfo.getTimeZone();
        //Milliseconds to Day
        return tz.getOffset(DateTime.now()) / (1000 * 3600 * 24.0);
    }}
    public string OpenDay1{get; set;}
    public string OpenDay2{get; set;}
    public string OpenDay3{get; set;}
    public string OpenDay4{get; set;}
    public string OpenDay5{get; set;}
    public string CloseDay1{get; set;}
    public string CloseDay2{get; set;}
    public string CloseDay3{get; set;}
    public string CloseDay4{get; set;}
    public string CloseDay5{get; set;}
    
    public MeetingRoomDetail()    
    {
        
        mrid=System.currentPageReference().getParameters().get('mrid'); 
        system.debug('MeetingRoomid id'+ mrid);
        mrName=System.currentPageReference().getParameters().get('mrName'); 
        system.debug('MeetingRoomid Name'+ mrName);
        congid=System.currentPageReference().getParameters().get('congid'); 
        system.debug('congid id'+ congid);
        congName=System.currentPageReference().getParameters().get('congName'); 
        system.debug('congName id'+ congName);  
        MeetingRoomData(); 
                
    }
    Meeting_Room__c mr=new Meeting_Room__c();
  
    Public Meeting_Room__c getmr(){
   return mr;
    }
    public PageReference MeetingRoomData()
    {
       if (String.isNotBlank(mrid))
        {
            mr=[select id,Name,Activity_Level__c,Congress__c,Activity_Not_Confirmed__c,GES_Project_Number__c,Meeting_Room_Date__c,Meeting_Room_Lead__c,Meeting_Room_Location__c, Congress_Lead__c,GES_Congress_Manager__c, Meeting_Room_Name__c,Meeting_Room_Number__c,Meeting_Room_Time__c,Canceled__c,CanceledDate__c,Cancel_Reason__c,GES_Project_Manager__c, GES_Account_Manager__c, GES_Account_Executive__c, I_D_Supervisor__c, Agency_Name__c, Agency_Contact_Name__c, Agency_Contact_Phone__c, Agency_Contact_E_mail__c, Meeting_Room_Use__c,AV__c,Day_1_Close_date_time__c,Day_1_Open_date_time__c,Day_2_Close_date_time__c,Day_2_Open_date_time__c,Day_3_Close_date_time__c, Day_3_Open_date_time__c, Day_4_Close_date_time__c, Day_4_Open_date_time__c, Day_5_Close_date_time__c, Day_5_Open_date_time__c, F_B__c, Furnitire__c, Internet__c, Meeting_Room_Notes__c, I_D_Name_Other__c, MR_Type__c  from Meeting_Room__c where id=:mrid];       
            brandList();
            
            if(mr.Day_1_Open_date_time__c!=null){
            OpenDay1 = mr.Day_1_Open_date_time__c.format('MMMM d, yyyy  hh:mm a', UserInfo.getTimeZone().toString());
        }else{
            OpenDay1='';
        }
        if(mr.Day_2_Open_date_time__c!=null){
            OpenDay2 = mr.Day_2_Open_date_time__c.format('MMMM d, yyyy  hh:mm a', UserInfo.getTimeZone().toString());
        }else{
            OpenDay2='';
        }
        if(mr.Day_3_Open_date_time__c!=null){
            OpenDay3 = mr.Day_3_Open_date_time__c.format('MMMM d, yyyy  hh:mm a', UserInfo.getTimeZone().toString());
        }else{
            OpenDay3='';
        }
        if(mr.Day_4_Open_date_time__c!=null){
            OpenDay4 = mr.Day_4_Open_date_time__c.format('MMMM d, yyyy  hh:mm a', UserInfo.getTimeZone().toString());
        }else{
            OpenDay4='';
        }
        if(mr.Day_5_Open_date_time__c!=null){
            OpenDay5 = mr.Day_5_Open_date_time__c.format('MMMM d, yyyy  hh:mm a', UserInfo.getTimeZone().toString());
        }else{
            OpenDay5='';
        }
        if(mr.Day_1_Close_date_time__c!=null){
            CloseDay1 = mr.Day_1_Close_date_time__c.format('MMMM d, yyyy  hh:mm a', UserInfo.getTimeZone().toString());
        }else{
            CloseDay1='';
        }
        if(mr.Day_2_Close_date_time__c!=null){
            CloseDay2 = mr.Day_2_Close_date_time__c.format('MMMM d, yyyy  hh:mm a', UserInfo.getTimeZone().toString());
        }else{
            CloseDay2='';
        }
        if(mr.Day_3_Close_date_time__c!=null){
            CloseDay3 = mr.Day_3_Close_date_time__c.format('MMMM d, yyyy  hh:mm a', UserInfo.getTimeZone().toString());
        }else{
            CloseDay3='';
        }
        if(mr.Day_4_Close_date_time__c!=null){
            CloseDay4 = mr.Day_4_Close_date_time__c.format('MMMM d, yyyy  hh:mm a', UserInfo.getTimeZone().toString());
        }else{
            CloseDay4='';
        }
        if(mr.Day_5_Close_date_time__c!=null){
            CloseDay5 = mr.Day_5_Close_date_time__c.format('MMMM d, yyyy  hh:mm a', UserInfo.getTimeZone().toString());
        }else{
            CloseDay5='';
        }
        }
        return null;    
    }
    public List<Brand__c> brdlist{get;set;}
    public PageReference brandList()
    {
        brdlist=[select id,Name,Brand_Name__c,Brand_Category__c,Business_Unit__c,Congress_Lead__c,GES_Congress_Manager__c,COE_Supported__c,Sponsorship_Budget_Estimated__c,Sponsorship_Budget_Actual__c,Budget_Owner__c,Funding_Owner__c,Cost_Center__c,Createddate,lastmodifieddate, Funding_Provider_Region__c,Canceled__c from Brand__c where Meeting_Room__c =:mr.id];
        return null;
    }
    public PageReference MeetingRoomNewBrand()
    {
        PageReference MeetingRoomBrandEdit= new PageReference('/apex/MeetingRoomBrandEdit');
        MeetingRoomBrandEdit.getParameters().put('mrid',String.valueOf(mr.id));  
        MeetingRoomBrandEdit.getParameters().put('mrName',String.valueOf(mr.Name));  
        MeetingRoomBrandEdit.getParameters().put('congid',String.valueOf(congid));  
        MeetingRoomBrandEdit.getParameters().put('congName',String.valueOf(congName));  
        MeetingRoomBrandEdit.setRedirect(true);
        return MeetingRoomBrandEdit;               
    }
    Public PageReference CongressDetail(){    
    PageReference congressdetail= new PageReference('/apex/Congressdetails');
    congressdetail.getParameters().put('id',String.valueOf(congName));  
        congressdetail.setRedirect(true);
        return congressdetail;
    }
     Public PageReference MeetingRoomSave(){
     return new PageReference(GC_PageUtil.CheckApexDomain() + '/MeetingRoomedit?congid='+congid+'&mrid='+mrid+'&congName='+congName);
    }

    public PageReference MeetingRoomcancel()
    {
        return new PageReference(GC_PageUtil.CheckApexDomain() + '/Congressdetails?id='+congid);
    }
    Public PageReference MeetingRoomClone()
    {
        return new PageReference(GC_PageUtil.CheckApexDomain() + '/MeetingRoomedit?congressid='+congid+'&mrid='+mrid+'&congressName='+congName+'&toClone=true');
    }
}