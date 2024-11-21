public class MeetingRoomBrandDetail 
{
     Brand__c br=new Brand__c();
     Public Brand__c getbr(){
      return br;
    }
    public string mrbrid{get;set;}
    public string mrbrName{get;set;}
    public string mrid{get;set;}
    public string mrName{get;set;}
    public string congid{get;set;}
    public string congName{get;set;}
    public MeetingRoomBrandDetail()
    {
        mrbrid=System.currentPageReference().getParameters().get('mrnbrandid'); 
        system.debug('mrbrid id'+ mrbrid);
        //mrbrName=System.currentPageReference().getParameters().get('MeetingRoomName'); 
        system.debug('mrbrName id'+ mrbrName);
        mrid=System.currentPageReference().getParameters().get('mrid'); 
        system.debug('mrid id'+ mrbrName);
        mrName=System.currentPageReference().getParameters().get('mrName'); 
        system.debug('mrName id'+ mrbrName);
        congid=System.currentPageReference().getParameters().get('congid'); 
        system.debug('Cong id'+ congid);
        congName=System.currentPageReference().getParameters().get('congName'); 
        system.debug('congName id'+ congName);
        br=[select id,Name,GES_Connect_Corporate_Accounts__c,CurrencyISOCode,Finance_Coordinator__c,Meeting_Room_Actual_Cost__c,Meeting_Room_Estimated_Cost__c,Brand_Name__c,Brand_Category__c,Business_Unit__c,Congress_Lead__c,Brand_Team_Contact__c,COE_Supported__c,Sponsorship_Budget_Estimated__c,GES_Congress_Manager__c ,Sponsorship_Budget_Actual__c,Budget_Owner__c,Funding_Owner__c,Cost_Center__c, Funding_Provider_Department__c, Funding_Provider_Region__c,Canceled__c, Cancelled_Date__c, Reason_for_Cancellation__c, Contact_Not_Listed__c, Funding_Provider_Brand__c, Company_Code__c,MR_Services_Estimated_Costs__c,MR_Services_Actual_Costs__c,Estimated_Cost_Origination__c from Brand__c where id=:mrbrid];
    }
    public PageReference BrandSave()
    {
        //ExhibitBrandEdit?exhibitid=a6Rc0000000D7nSEAS&brandId=a6Sc0000000Ct6PEAS&exhibitName=&congid=a6Qc00000007lxTEAQ&congName=GCA-0201
        //brandId=a6Sc0000000Ct6PEAS&congid=a6Qc00000007lxTEAQ&congName=GCA-0201&exhibitid=a6Rc0000000D7nSEAS&exhibitName=null
        return new PageReference(GC_PageUtil.CheckApexDomain() + '/MeetingRoomBrandEdit?mrid='+mrid+'&brandId='+br.Id+'&mrName='+mrName+'&congid='+congid+'&congName='+congName);
    }

     public PageReference BrandCancel()
    {
        //ExhibitDetails?congressid=a6Qc00000007lxTEAQ&congressName=GCA-0201&exhibitid=a6Rc0000000D7nSEAS
        //return new PageReference(GC_PageUtil.CheckApexDomain() + '/mrsorshipBrandDetail?mrbrandid='mrid+'&congName='+congName+);
        //return null;
        return new PageReference(GC_PageUtil.CheckApexDomain() + '/MeetingRoomDetails?congid='+congid+'&MeetingRoomName='+mrName+'&mrid='+mrid+'&congName='+congName);
    }
}