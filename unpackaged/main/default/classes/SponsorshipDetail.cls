public class SponsorshipDetail
{
    public string sponid{get;set;}
    public string sponName{get;set;}
    public string congid{get;set;}
    public string congName{get;set;}  
    public SponsorshipDetail()    
    {
        
        sponid=System.currentPageReference().getParameters().get('sponid'); 
        system.debug('sponsorshipid id'+ sponid);
        sponName=System.currentPageReference().getParameters().get('sponName'); 
        system.debug('sponsorshipid Name'+ sponName);
        congid=System.currentPageReference().getParameters().get('congid'); 
        system.debug('congid id'+ congid);
        congName=System.currentPageReference().getParameters().get('congName'); 
        system.debug('congName id'+ congName);  
        SponsorData();            
    }
    Sponsorship__c sp=new Sponsorship__c();
  
    Public Sponsorship__c getsp(){
   return sp;
    }
    public PageReference SponsorData()
    {
       if (String.isNotBlank(sponid))
        {
            sp=[select id,Name,Activity_Level__c,Activity_Not_Confirmed__c,Congress_Lead__c,GES_Congress_Manager__c,Exhibit_Bundled_with_Sponsorsip__c,Sponsorship__c,Sponsorship_Costs_Actual__c,Sponsorship_Costs_Estimated__c,Sponsorship_Name__c,Canceled__c,CanceledDate__c,CancelReason__c,Sponsorship_Notes__c, GES_Account_Manager__c, GES_Account_Executive__c, Agency_Name__c, Agency_Contact_Name__c, Agency_Contact_Phone__c, Agency_Contact_E_mail__c, Sponsorship_Type__c, Alternate_Activity__c, Sponsorship_Registrants__c from Sponsorship__c where id=:sponid];       
            brandList();
        }
        return null;    
    }
    public List<Brand__c> brdlist{get;set;}
    public PageReference brandList()
    {
        brdlist=[select id,Name,Brand_Name__c,Brand_Category__c,Business_Unit__c,Createddate,lastmodifieddate,Canceled__c from Brand__c where Sponsorship__c=:sp.id];
        return null;
    }
    public PageReference SponsorshipNewBrand()
    {
        PageReference SponsorshipBrandEdit= new PageReference('/apex/SponsorshipBrandEdit');
        SponsorshipBrandEdit.getParameters().put('sponid',String.valueOf(sp.id));  
        SponsorshipBrandEdit.getParameters().put('sponName',String.valueOf(sp.Name));  
        SponsorshipBrandEdit.getParameters().put('congid',String.valueOf(congid));  
        SponsorshipBrandEdit.getParameters().put('congName',String.valueOf(congName));  
        SponsorshipBrandEdit.setRedirect(true);
        return SponsorshipBrandEdit;               
    }
     
   Public PageReference CongressDetail(){    
    PageReference congressdetail= new PageReference('/apex/Congressdetails');
    congressdetail.getParameters().put('id',String.valueOf(congName));  
        congressdetail.setRedirect(true);
        return congressdetail;
    }
    
     Public PageReference sponsorSave()
    {
        //return new PageReference(GC_PageUtil.CheckApexDomain() + '/Exhibitedit?congressid='+congid+'&sponid='+sponid+'&congressName='+congName);
        return new PageReference(GC_PageUtil.CheckApexDomain() + '/Sponsorshipedit?congid='+congid+'&sponid='+sponid+'&congName='+congName);
    }

    public PageReference sponsorcancel()
    {
        return new PageReference(GC_PageUtil.CheckApexDomain() + '/Congressdetails?id='+congid);
    }
     Public PageReference sponsorClone()
    {
        return new PageReference(GC_PageUtil.CheckApexDomain() + '/Sponsorshipedit?congressid='+congid+'&sponid='+sponid+'&congressName='+congName+'&toClone=true');
    }
    
}