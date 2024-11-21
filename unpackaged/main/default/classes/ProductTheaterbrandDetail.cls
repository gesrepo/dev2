public class ProductTheaterbrandDetail 
{
     Brand__c br=new Brand__c();
     Public Brand__c getbr(){
      return br;
    }
    public string ptrbrid{get;set;}
    public string ptrbrName{get;set;}
    public string ProductTheaterid{get;set;}
    public string prtName{get;set;}
    public string congid{get;set;}
    public string congName{get;set;}
    public ProductTheaterbrandDetail()
    {
        ptrbrid=System.currentPageReference().getParameters().get('ptrbrandid'); 
        system.debug('ptrbrid id'+ ptrbrid);
        ptrbrName=System.currentPageReference().getParameters().get('ptrbrandName'); 
        system.debug('ptrbrName '+ ptrbrName);
        ProductTheaterid=System.currentPageReference().getParameters().get('ProductTheaterid'); 
        system.debug('ProductTheaterid '+ ProductTheaterid);
        prtName=System.currentPageReference().getParameters().get('prtName'); 
        system.debug('prtName'+ prtName);
        congid=System.currentPageReference().getParameters().get('congid'); 
        system.debug('congid'+ congid);
        congName=System.currentPageReference().getParameters().get('congName'); 
        system.debug('congName '+ congName);
        br=[select id,Name,Finance_Coordinator__c,CurrencyISOCode,GES_Connect_Corporate_Accounts__c,GES_Congress_Manager__c ,Brand_Name__c,Brand_Category__c,Business_Unit__c,Congress_Lead__c,Brand_Team_Contact__c,COE_Supported__c,Sponsorship_Costs_Estimated__c,Budget_Owner__c,Funding_Owner__c,Cost_Center__c,Product_Theater_Costs_Estimated__c,Product_Theater_Costs_Actual__c,Funding_Provider_Department__c,Funding_Provider_Region__c,Canceled__c, Cancelled_Date__c, Reason_for_Cancellation__c, Contact_Not_Listed__c, Funding_Provider_Brand__c, Company_Code__c  from Brand__c where id=:ptrbrid];
    }
     public PageReference BrandSave()
    {
        //ExhibitBrandEdit?exhibitid=a6Rc0000000D7nSEAS&brandId=a6Sc0000000Ct6PEAS&exhibitName=&congid=a6Qc00000007lxTEAQ&congName=GCA-0201
        //brandId=a6Sc0000000Ct6PEAS&congid=a6Qc00000007lxTEAQ&congName=GCA-0201&exhibitid=a6Rc0000000D7nSEAS&exhibitName=null
        return new PageReference(GC_PageUtil.CheckApexDomain() + '/ProductTheaterbrandEdit?ProductTheaterid='+ProductTheaterid+'&brandId='+br.Id+'&producttherName='+prtName+'&congid='+congid+'&congName='+congName);
    }

     public PageReference BrandCancel()
    {
        //ExhibitDetails?congressid=a6Qc00000007lxTEAQ&congressName=GCA-0201&exhibitid=a6Rc0000000D7nSEAS
        //return new PageReference(GC_PageUtil.CheckApexDomain() + '/SponsorshipBrandDetail?sponbrandid='sponid+'&congName='+congName+);
        //return null;
        return new PageReference(GC_PageUtil.CheckApexDomain() + '/ProductTheaterDetail?congid='+congid+'&prtName='+prtName+'&producttherid='+ProductTheaterid+'&congName='+congName);
    }
}