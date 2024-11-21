public class MeetingRoomBrandEdit 
{
    public string mrid{get;set;}
    public string mrName{get;set;}
    public string congid{get;set;}
    public string congName{get;set;}
    public string brandid{get;set;}
    public String cancelReason {get;set;}
    Brand__c br=new Brand__c();
    //changes for SAL-513
    public Map<String, Map<String,String>> mapBrandPicklist;
    public string autoBrand {get;set;}  //SAL-577 rksinha
    public string reuiredStatus {get;set;}  //SAL-577 rksinha
    public MeetingRoomBrandEdit()
    {   
        mrid=System.currentPageReference().getParameters().get('mrid'); 
       // system.debug('mrid id'+ mrid);
        mrName=System.currentPageReference().getParameters().get('mrName'); 
        //system.debug('mrNameid'+ mrName);
        congid=System.currentPageReference().getParameters().get('congid'); 
        //system.debug('mrNameid'+ congid);
        congName=System.currentPageReference().getParameters().get('congName'); 
        //system.debug('congName '+ congName);
        brandid=System.currentPageReference().getParameters().get('brandid'); 
        //system.debug('brandid'+ brandid);
        autoBrand=System.currentPageReference().getParameters().get('autoBrand');   //SAL-577
        reuiredStatus= 'false';     //SAL-577
        cancelReason='false';
        mapBrandPicklist= BrandPickList.populatePicklistMap();
        if (String.isNotBlank(brandid)) 
        {
          Brand__c currentBrand =[select id,Name,CurrencyISOCode,Sponsorship_Budget_Estimated__c ,Finance_Coordinator__c,Meeting_Room_Actual_Cost__c,Meeting_Room_Estimated_Cost__c,GES_Connect_Corporate_Accounts__c,Brand_Name__c,Brand_Category__c,Business_Unit__c,Congress_Lead__c,Brand_Team_Contact__c,GES_Congress_Manager__c,COE_Supported__c,Sponsorship_Costs_Estimated__c,Sponsorship_Budget_Actual__c,Budget_Owner__c,Funding_Owner__c,Cost_Center__c, Funding_Provider_Department__c, Funding_Provider_Region__c, Canceled__c, Cancelled_Date__c, Reason_for_Cancellation__c, Contact_Not_Listed__c, Funding_Provider_Brand__c, Company_Code__c,MR_Services_Estimated_Costs__c,MR_Services_Actual_Costs__c,Estimated_Cost_Origination__c from Brand__c where id=:brandid];
          br = new Brand__c();
          br =  currentBrand;
          if(currentBrand.Canceled__c == True)
          {
            cancelReason = 'true';
          }
          else
          {
            cancelReason = 'false';
          }
        }
        if(String.isNotBlank(congid)){
            GES_Connect_Corporate_Accounts__c parentCongress = [SELECT Id, Name, CurrencyIsoCode FROM GES_Connect_Corporate_Accounts__c WHERE id=:congid];
            //br.CurrencyIsoCode = parentCongress.CurrencyIsoCode; 
        } 
    }
    Public Brand__c getbr(){
      return br;
    }
    public PageReference MeetingRoomBrandSave()
    {
        br.Meeting_Room__c=mrid;
        br.GES_Connect_Corporate_Accounts__c=congid;
        //Amarab 03/25/2021 SCA-878 Remove required setting
        //if (br.Brand_Team_Contact__c == null || br.Company_Code__c == null || br.Cost_Center__c == null || br.Funding_Provider_Brand__c == null || br.Funding_Provider_Region__c == null || br.Funding_Provider_Brand__c == null) 
        if (br.Brand_Team_Contact__c == null ) 
        {
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR , 'Please make sure the following fields are entered : Brand Team Contact,  Funding Provider Region, Funding Provider Brand, Funding Provider Department, Cost Center & Company Code'));
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR , 'Please make sure the following fields are entered : Brand Team Contact'));
                return null;
        }  
        upsert br;
        PageReference MeetingRoomdetail;
        
        if(autoBrand=='true'){
            MeetingRoomdetail= new PageReference('/apex/MeetingRoomDetails');
        }else{
            MeetingRoomdetail= new PageReference('/apex/MeetingRoomBrandDetail');
            MeetingRoomdetail.getParameters().put('mrnbrandid',String.valueOf(br.id));  
            MeetingRoomdetail.getParameters().put('mrbrandName',String.valueOf(br.Name));
        }
        MeetingRoomdetail.getParameters().put('mrid',String.valueOf(mrid));  
        MeetingRoomdetail.getParameters().put('mrName',String.valueOf(mrName));  
        MeetingRoomdetail.getParameters().put('congid',String.valueOf(congid));  
        MeetingRoomdetail.getParameters().put('congName',String.valueOf(congName));  
        MeetingRoomdetail.setRedirect(true);
        return MeetingRoomdetail;       
    }
    Public PageReference BrandCancel()
    {       
        //return new PageReference(GC_PageUtil.CheckApexDomain() + '/ExhibitDetails?congressid='+congid+'&exhibitid='+Exhibitid+'&congressName='+congName);     
        return new PageReference(GC_PageUtil.CheckApexDomain() + '/MeetingRoomDetails?congid='+congid+'&MeetingRoomName='+mrName+'&mrid='+mrid+'&congName='+congName);
    }
    
    public PageReference cancelOperation() 
    {
        system.debug('Entered cancelOperation');
        if(br.Canceled__c == True)
        {
            cancelReason  = 'true';
            br.Cancelled_Date__c = Date.today();
        }
        else if(br.Canceled__c == False)
        {
            cancelReason = 'false';
            br.Cancelled_Date__c = null;
            br.Reason_for_Cancellation__c = null;
        }
        
        return null;
    } 
    
    //changes for SAL-513
    public void changeBrandCatandBusUnit() {
        if(mapBrandPicklist.get(br.Brand_Name__c) != null) {
            Map<String, String> mapValues = mapBrandPicklist.get(br.Brand_Name__c);
            for(String s : mapValues.keySet()) {
                br.Brand_Category__c = s;
                br.Business_Unit__c = mapValues.get(s);
            }
            reuiredStatus= 'true';      //SAL-577
        }
    }
    
}