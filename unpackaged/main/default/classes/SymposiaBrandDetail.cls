public class SymposiaBrandDetail 
{
     Brand__c br=new Brand__c();
     Public Brand__c getbr(){
      return br;
    }
    public string symbrid{get;set;}
    public string symbrName{get;set;}
    public string symid{get;set;}
    public string symName{get;set;}
    public string congid{get;set;}
    public string congName{get;set;}
    public SymposiaBrandDetail()
    {
        symbrid=System.currentPageReference().getParameters().get('symbrandid'); 
        system.debug('symbrid id'+ symbrid);
        symbrName=System.currentPageReference().getParameters().get('SymposiaName'); 
        system.debug('symbrName id'+ symbrName);
        symid=System.currentPageReference().getParameters().get('symid'); 
        system.debug('symid id'+ symbrName);
        symName=System.currentPageReference().getParameters().get('symName'); 
        system.debug('symName id'+ symbrName);
        congid=System.currentPageReference().getParameters().get('congid'); 
        system.debug('Cong id'+ congid);
        congName=System.currentPageReference().getParameters().get('congName'); 
        system.debug('congName id'+ congName);
        br=[select id,Name,GES_Connect_Corporate_Accounts__c,CurrencyISOCode,Finance_Coordinator__c,Brand_Name__c,Symposia_Actual_Cost__c,Symposia_Estimated_Cost__c,Brand_Category__c,Business_Unit__c,Congress_Lead__c,Brand_Team_Contact__c,GES_Congress_Manager__c,COE_Supported__c,Sponsorship_Budget_Estimated__c,Sponsorship_Budget_Actual__c,Budget_Owner__c,Funding_Owner__c,Cost_Center__c,Funding_Provider_Region__c, Funding_Provider_Department__c,Canceled__c, Cancelled_Date__c, Reason_for_Cancellation__c, Contact_Not_Listed__c, Funding_Provider_Brand__c, Company_Code__c from Brand__c where id=:symbrid];
    }
    public PageReference BrandSave()
    {
        //ExhibitBrandEdit?exhibitid=a6Rc0000000D7nSEAS&brandId=a6Sc0000000Ct6PEAS&exhibitName=&congid=a6Qc00000007lxTEAQ&congName=GCA-0201
        //brandId=a6Sc0000000Ct6PEAS&congid=a6Qc00000007lxTEAQ&congName=GCA-0201&exhibitid=a6Rc0000000D7nSEAS&exhibitName=null
        return new PageReference(GC_PageUtil.CheckApexDomain() + '/SymposiaBrandEdit?symid='+symid+'&brandId='+br.Id+'&symName='+symName+'&congid='+congid+'&congName='+congName);
    }

     public PageReference BrandCancel()
    {
        //ExhibitDetails?congressid=a6Qc00000007lxTEAQ&congressName=GCA-0201&exhibitid=a6Rc0000000D7nSEAS
        //return new PageReference(GC_PageUtil.CheckApexDomain() + '/SponsorshipBrandDetail?sponbrandid='sponid+'&congName='+congName+);
        //return null;
        return new PageReference(GC_PageUtil.CheckApexDomain() + '/SymposiaDetails?congid='+congid+'&SymposiaName='+symName+'&symid='+symid+'&congName='+congName);
    }
}