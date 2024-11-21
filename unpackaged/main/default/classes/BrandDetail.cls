public class BrandDetail
{
    public string brandId{get;set;}
    public string exhibitName1 {get;set;}
    Brand__c b =new Brand__c();     
    public Brand__c getb()
    {
        return b;
    }

    public BrandDetail(ApexPages.StandardController controller) 
    {
         brandId =System.currentPageReference().getParameters().get('brandid'); 
         exhibitName1 = System.currentPageReference().getParameters().get('exhibitName');
         system.debug('brandId'+ brandId);
         b=[select id,Name,Finance_Coordinator__c,CurrencyIsoCode,Exhibit_Instance__c,Exhibit_Instance__r.Exhibit_Name__c,GES_Connect_Corporate_Accounts__c ,GES_Connect_Corporate_Accounts__r.Name,Brand_Name__c,Brand_Category__c,Business_Unit__c,Congress_Lead__c,Brand_Team_Contact__c,GES_Congress_Manager__c,COE_Supported__c,Booth_Space_Cost_Estimated__c,Booth_Space_Cost_Actual__c,Exhibit_Costs_Estimated__c,Exhibit_Costs_Actual__c,Budget_Owner__c,Cost_Center__c,Sponsorship__c, Funding_Provider_Department__c, Funding_Provider_Region__c,Canceled__c, Cancelled_Date__c, Reason_for_Cancellation__c, Contact_Not_Listed__c, Funding_Provider_Brand__c, Company_Code__c,Estimated_Cost_Origination__c from Brand__c where id=:brandId];
         
    }

    public PageReference BrandSave()
    {
        //ExhibitBrandEdit?exhibitid=a6Rc0000000D7nSEAS&brandId=a6Sc0000000Ct6PEAS&exhibitName=&congid=a6Qc00000007lxTEAQ&congName=GCA-0201
        //brandId=a6Sc0000000Ct6PEAS&congid=a6Qc00000007lxTEAQ&congName=GCA-0201&exhibitid=a6Rc0000000D7nSEAS&exhibitName=null
        return new PageReference(GC_PageUtil.CheckApexDomain() + '/ExhibitBrandEdit?exhibitid='+b.Exhibit_Instance__c+'&brandId='+b.Id+'&exhibitName='+exhibitName1+'&congid='+b.GES_Connect_Corporate_Accounts__c+'&congName='+b.GES_Connect_Corporate_Accounts__r.Name);
    }

     public PageReference BrandCancel()
    {
        //ExhibitDetails?congressid=a6Qc00000007lxTEAQ&congressName=GCA-0201&exhibitid=a6Rc0000000D7nSEAS
        return new PageReference(GC_PageUtil.CheckApexDomain() + '/ExhibitDetails?congressid='+b.GES_Connect_Corporate_Accounts__c+'&congressName='+b.GES_Connect_Corporate_Accounts__r.Name+'&exhibitid='+b.Exhibit_Instance__c);
        //return null;
    }   
      
}