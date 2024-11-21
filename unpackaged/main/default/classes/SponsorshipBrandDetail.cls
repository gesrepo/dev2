public class SponsorshipBrandDetail 
{
     Brand__c br=new Brand__c();
     Public Brand__c getbr(){
      return br;
    }
    public string sponbrid{get;set;}
    public string sponbrName{get;set;}
    public string sponid{get;set;}
    public string sponName{get;set;}
    public string congid{get;set;}
    public string congName{get;set;}
    public SponsorshipBrandDetail()
    {
        sponbrid=System.currentPageReference().getParameters().get('sponbrandid'); 
        system.debug('sponbrid id'+ sponbrid);
        sponbrName=System.currentPageReference().getParameters().get('sponsorshipName'); 
        system.debug('sponbrName id'+ sponbrName);
        sponid=System.currentPageReference().getParameters().get('sponid'); 
        system.debug('sponid id'+ sponbrName);
        sponName=System.currentPageReference().getParameters().get('sponName'); 
        system.debug('sponName id'+ sponbrName);
        congid=System.currentPageReference().getParameters().get('congid'); 
        system.debug('Cong id'+ congid);
        congName=System.currentPageReference().getParameters().get('congName'); 
        system.debug('congName id'+ congName);
        br=[select id,Name,GES_Connect_Corporate_Accounts__c,Brand_Name__c,Brand_Category__c,CurrencyISOCode,Business_Unit__c,Finance_Coordinator__c,Congress_Lead__c,Brand_Team_Contact__c,GES_Congress_Manager__c,COE_Supported__c,Sponsorship_Costs_Estimated__c,Budget_Owner__c,Funding_Owner__c,Cost_Center__c,Funding_Provider_Department__c,Funding_Provider_Region__c,Sponsorship_Costs_Actual__c,Canceled__c, Cancelled_Date__c, Reason_for_Cancellation__c, Contact_Not_Listed__c, Funding_Provider_Brand__c, Company_Code__c from Brand__c where id=:sponbrid];
    }
    public PageReference BrandSave()
    {
        //ExhibitBrandEdit?exhibitid=a6Rc0000000D7nSEAS&brandId=a6Sc0000000Ct6PEAS&exhibitName=&congid=a6Qc00000007lxTEAQ&congName=GCA-0201
        //brandId=a6Sc0000000Ct6PEAS&congid=a6Qc00000007lxTEAQ&congName=GCA-0201&exhibitid=a6Rc0000000D7nSEAS&exhibitName=null
        return new PageReference(GC_PageUtil.CheckApexDomain() + '/SponsorshipBrandEdit?sponid='+sponid+'&brandId='+br.Id+'&sponName='+sponName+'&congid='+congid+'&congName='+congName);
    }

     public PageReference BrandCancel()
    {
        //ExhibitDetails?congressid=a6Qc00000007lxTEAQ&congressName=GCA-0201&exhibitid=a6Rc0000000D7nSEAS
        //return new PageReference(GC_PageUtil.CheckApexDomain() + '/SponsorshipBrandDetail?sponbrandid='sponid+'&congName='+congName+);
        //return null;
        return new PageReference(GC_PageUtil.CheckApexDomain() + '/SponsorshipDetails?congid='+congid+'&sponsorshipName='+sponName+'&sponid='+sponid+'&congName='+congName);
    }
}