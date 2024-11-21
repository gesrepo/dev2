public class MeetingRoomEdit
{
    public Boolean cancelReason {get;set;} 
    public String displayFlag {get;set;}
    public id congid{get;set;}
    public string congName{get;set;}
    public string mrid{get;set;}
    Exhibit__c es=new Exhibit__c();    
    public Meeting_Room__c mr=new Meeting_Room__c();
    public String toClone {get;set;}
    GES_Connect_Corporate_Accounts__c a=new GES_Connect_Corporate_Accounts__c();
    Public Meeting_Room__c getmr(){
        return mr;
    }
     public MeetingRoomEdit(ApexPages.StandardController controller) {
        congid = System.currentPageReference().getParameters().get('congid'); 
        congName = System.currentPageReference().getParameters().get('congName'); 
        mrid= System.currentPageReference().getParameters().get('mrid'); 
        toClone = System.currentPageReference().getParameters().get('toClone');
        system.debug('Cong id'+ congid);    
        system.debug('mr id'+ mrid);            
        if (String.isNotBlank(mrid))
        {
            Meeting_Room__c currentMeeting_Room =[select id,Name,Activity_Level__c,Activity_Not_Confirmed__c,Congress_Lead__c,Congress__c,GES_Project_Number__c,Meeting_Room_Date__c,Meeting_Room_Lead__c,Meeting_Room_Location__c, Meeting_Room_Name__c,Meeting_Room_Number__c,Meeting_Room_Time__c,Canceled__c,CanceledDate__c,Cancel_Reason__c,GES_Project_Manager__c, GES_Account_Manager__c, GES_Account_Executive__c, I_D_Supervisor__c , GES_Congress_Manager__c, Agency_Name__c, Agency_Contact_Name__c, Agency_Contact_Phone__c, Agency_Contact_E_mail__c, Meeting_Room_Use__c,AV__c,Day_1_Close_date_time__c,Day_1_Open_date_time__c,Day_2_Close_date_time__c,Day_2_Open_date_time__c,Day_3_Close_date_time__c, Day_3_Open_date_time__c, Day_4_Close_date_time__c, Day_4_Open_date_time__c, Day_5_Close_date_time__c, Day_5_Open_date_time__c, F_B__c, Furnitire__c, Internet__c, Meeting_Room_Notes__c,I_D_Name_Other__c, MR_Type__c from Meeting_Room__c where id=:mrid];
            mr= new Meeting_Room__c();
            
            if(toClone=='true'){
                mr= currentMeeting_Room.Clone(false, true,false,false);
                mr.Activity_Not_Confirmed__c = true;
                
            }else{
                mr = currentMeeting_Room;
                
            }  
            
            if(mr.Canceled__c == True)
            {
                cancelReason = True;
            }
            else
            {
                cancelReason = False;
            }
        }
        else
        {
            cancelReason = False;
            mr.Congress__c=congid;
        }   
    }

    Public GES_Connect_Corporate_Accounts__c geta(){
        return a;
    }
    Public PageReference MeetingRoomSave(){
        system.debug(mr);
        
        system.debug('GCN Id'+congid);
        upsert mr;
        if(toClone=='true'){
            List<Brand__c> listBrandToInsert = new List<Brand__c > ();
            for(Brand__c b : [select id,Name,Brand_Name__c,GES_Connect_Corporate_Accounts__c,GES_Congress_Manager__c,Brand_Category__c,Congress_Lead__c,Business_Unit__c,COE_Supported__c,Exhibit_Instance__c,Createddate,lastmodifieddate,Canceled__c from Brand__c where Canceled__c = false AND Meeting_Room__c =:mrid]) {
                Brand__c brand = b.clone(false, true);
                brand.Meeting_Room__c = mr.id;
                listBrandToInsert.add(brand);
            }
            insert listBrandToInsert;
            Meeting_Room__c varCloned= [ SELECT Id, Name,Meeting_Room_Name__c, Congress__c,Congress__r.Name from Meeting_Room__c where Id =:mr.id];
            congid= varCloned.Congress__c;
            congName= varCloned.Congress__r.Name;
            
        }
        
        PageReference MeetingRoomdetail;
        if(string.isNotBlank(mrid)){
            MeetingRoomdetail= new PageReference('/apex/MeetingRoomDetails');
        }else{
            MeetingRoomdetail= new PageReference('/apex/MeetingRoomBrandEdit');
            MeetingRoomDetail.getParameters().put('autoBrand','true');
        }
        MeetingRoomdetail.getParameters().put('mrid',String.valueOf(mr.id));  
        MeetingRoomdetail.getParameters().put('mrName',String.valueOf(mr.Name));  
        MeetingRoomdetail.getParameters().put('congid',String.valueOf(congid));  
        MeetingRoomdetail.getParameters().put('congName',String.valueOf(congName));  
        MeetingRoomdetail.setRedirect(true);
        return MeetingRoomdetail;       
    }
    public PageReference meetingCancel()
    {
       PageReference MeetingRoomdetail= new PageReference('/apex/MeetingRoomDetails');
        MeetingRoomdetail.getParameters().put('mrid',String.valueOf(mr.id));  
        //MeetingRoomdetail.getParameters().put('mrName',String.valueOf(mr.Name));  
        MeetingRoomdetail.getParameters().put('congid',String.valueOf(congid));  
        MeetingRoomdetail.getParameters().put('congName',String.valueOf(congName));  
        MeetingRoomdetail.setRedirect(true);
        return MeetingRoomdetail;       
    }
    
    public PageReference cancelOperation() 
    {
        system.debug('Entered cancelOperation');
        if(mr.Canceled__c == True)
        {
            cancelReason = true;
            mr.CanceledDate__c = Date.today();
        }
        else
        {
            cancelReason = false;
            mr.CanceledDate__c = null;
            mr.Cancel_Reason__c = null;
        }
        
        return null;
    } 
    
   /* public PageReference displayOtherSupervisor(){
    system.debug('Entered displayOtherSupervisor');
        if(mr.I_D_Supervisor__c=='Other'){
            system.debug('displayFlag is false');
            displayFlag = 'true';
            system.debug('displayFlag ==='+displayFlag);
        }
        else{
            displayFlag = 'false';
            system.debug('displayFlag ==='+displayFlag);
        }
        return null;
    } */
}