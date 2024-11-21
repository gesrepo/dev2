public class SponsorshipBrandEdit 
{
    public string sponid{get;set;}
    public string sponName{get;set;}
    public string congid{get;set;}
    public string congName{get;set;}
    public string brandid{get;set;}
    public String cancelReason {get;set;}
    Brand__c br=new Brand__c();
    //changes for SAL-513
    public Map<String, Map<String,String>> mapBrandPicklist;
    public string autoBrand {get;set;}  //SAL-577 rksinha
    public string reuiredStatus {get;set;}  //SAL-577 rksinha
    public SponsorshipBrandEdit()
    {
        sponid=System.currentPageReference().getParameters().get('sponid'); 
        //system.debug('sponid id'+ sponid);
        sponName=System.currentPageReference().getParameters().get('sponName'); 
        //system.debug('sponNameid'+ sponName);
        congid=System.currentPageReference().getParameters().get('congid'); 
        //system.debug('sponNameid'+ congid);
        congName=System.currentPageReference().getParameters().get('congName'); 
        //system.debug('congName '+ congName);
        brandid=System.currentPageReference().getParameters().get('brandid'); 
        //system.debug('brandid'+ brandid);
        autoBrand=System.currentPageReference().getParameters().get('autoBrand');   //SAL-577
        reuiredStatus= 'false';     //SAL-577
        cancelReason='false';       //SAL-577
        mapBrandPicklist= BrandPickList.populatePicklistMap();  //SAL-577
        
        if (String.isNotBlank(brandid)) 
        {
          Brand__c currentBrand =[select id,Name,GES_Connect_Corporate_Accounts__c,CurrencyISOCode,Brand_Name__c,Brand_Category__c,GES_Congress_Manager__c,Business_Unit__c,Congress_Lead__c,Brand_Team_Contact__c,COE_Supported__c,Sponsorship_Costs_Estimated__c,Budget_Owner__c,Finance_Coordinator__c,Funding_Owner__c,Cost_Center__c,Funding_Provider_Department__c,Funding_Provider_Region__c,Sponsorship_Costs_Actual__c, Canceled__c, Cancelled_Date__c, Reason_for_Cancellation__c, Contact_Not_Listed__c, Funding_Provider_Brand__c, Company_Code__c   from Brand__c where id=:brandid];
          br = new Brand__c();
          br =  currentBrand;
          if(currentBrand.Canceled__c == True)
            {
                cancelReason = 'True';
            }
            else
            {
                cancelReason = 'False';
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
    public PageReference sponsorshipBrandSave()
    {
        br.Sponsorship__c=sponid;
        br.GES_Connect_Corporate_Accounts__c=congid;
        //Amarab 03/25/2021 SCA-878 Remove required setting
        //if (br.Brand_Team_Contact__c == null || br.Company_Code__c == null || br.Cost_Center__c == null || br.Funding_Provider_Brand__c == null || br.Funding_Provider_Region__c == null || br.Funding_Provider_Brand__c == null) 
        if (br.Brand_Team_Contact__c == null) 
        {
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR , 'Please make sure the following fields are entered : Brand Team Contact,  Funding Provider Region, Funding Provider Brand, Funding Provider Department, Cost Center & Company Code'));
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR , 'Please make sure the following fields are entered : Brand Team Contact'));
                return null;
        }  
        upsert br;
        PageReference Sponsorshipdetail= new PageReference('/apex/SponsorshipBrandDetail');
        if(autoBrand=='true'){
            Sponsorshipdetail= new PageReference('/apex/SponsorshipDetails');
        }else{
            Sponsorshipdetail= new PageReference('/apex/SponsorshipBrandDetail');
            Sponsorshipdetail.getParameters().put('sponbrandid',String.valueOf(br.id));  
            Sponsorshipdetail.getParameters().put('sponbrandName',String.valueOf(br.Name));
        }
       
        Sponsorshipdetail.getParameters().put('sponid',String.valueOf(sponid));  
        Sponsorshipdetail.getParameters().put('sponName',String.valueOf(sponName));  
        Sponsorshipdetail.getParameters().put('congid',String.valueOf(congid));  
        Sponsorshipdetail.getParameters().put('congName',String.valueOf(congName));  
        Sponsorshipdetail.setRedirect(true);
        return Sponsorshipdetail;       
    }
    Public PageReference BrandCancel()
    {       
        //return new PageReference(GC_PageUtil.CheckApexDomain() + '/ExhibitDetails?congressid='+congid+'&exhibitid='+Exhibitid+'&congressName='+congName);     
        return new PageReference(GC_PageUtil.CheckApexDomain() + '/SponsorshipDetails?congid='+congid+'&sponsorshipName='+sponName+'&sponid='+sponid+'&congName='+congName);
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