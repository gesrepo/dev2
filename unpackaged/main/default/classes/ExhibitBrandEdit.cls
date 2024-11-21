public class ExhibitBrandEdit
{
    public string congid{get;set;} 
    public string congName{get;set;}
    public string Exhibitid{get;set;}
    public string ExhibitName{get;set;}
    public string brandId{get;set;}
    public Brand__c b{get;set;} 
    public Boolean cancelReason {get;set;}
    public string autoBrand {get;set;}  //SAL-577 rksinha
    public Map<String, Map<String,String>> mapBrandPicklist;    //changes for SAL-513
    public string reuiredStatus {get;set;}  //SAL-577 rksinha
    
    public ExhibitBrandEdit()
    {   reuiredStatus= 'false';
        congid=System.currentPageReference().getParameters().get('congid'); 
        //system.debug('cong id'+congid);
        Exhibitid=System.currentPageReference().getParameters().get('Exhibitid'); 
        //system.debug('Exhibit id'+Exhibitid);
        ExhibitName=System.currentPageReference().getParameters().get('exhibitName'); 
        //system.debug('Exhibit Name'+ExhibitName);
        congName=System.currentPageReference().getParameters().get('congName'); 
        //system.debug('cong Name'+congName);
        autoBrand=System.currentPageReference().getParameters().get('autoBrand'); //SAL-577
        brandId = System.currentPageReference().getParameters().get('brandId');
        GES_Connect_Corporate_Accounts__c parentCongress = [SELECT Id, Name, CurrencyIsoCode FROM GES_Connect_Corporate_Accounts__c WHERE id=:congid];
        
        mapBrandPicklist= BrandPickList.populatePicklistMap();
        if (String.isNotBlank(brandId)) 
        {
            Brand__c currentBrand = [select Brand_Name__c,CurrencyIsoCode,Brand_Category__c,Business_Unit__c,Congress_Lead__c,
            Brand_Team_Contact__c, Finance_Coordinator__c,GES_Congress_Manager__c,COE_Supported__c,Booth_Space_Cost_Estimated__c,Booth_Space_Cost_Actual__c,
            Exhibit_Costs_Estimated__c,Exhibit_Costs_Actual__c,Budget_Owner__c,Funding_Owner__c,Cost_Center__c, Funding_Provider_Department__c, Funding_Provider_Region__c, Canceled__c, Cancelled_Date__c, Reason_for_Cancellation__c, Contact_Not_Listed__c, Funding_Provider_Brand__c, Company_Code__c,Estimated_Cost_Origination__c  from Brand__c where Id =: brandId];
            b = new Brand__c();
            b =  currentBrand;
            if(currentBrand.Canceled__c == True)
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
            b =new Brand__c();
            cancelReason = false;
        }
        //b.CurrencyIsoCode = parentCongress.CurrencyIsoCode;        
    }
    GES_Connect_Corporate_Accounts__c a=new GES_Connect_Corporate_Accounts__c();
    Exhibit__c e=new Exhibit__c();
    //Brand__c b =new Brand__c();

    Public GES_Connect_Corporate_Accounts__c geta(){
        return a;
        }
    Public Exhibit__c gete(){
       return e;
        }
    Public Brand__c getb(){
        return b;
        }
    Public PageReference BrandSave()
    {
        system.debug(b);
        b.Exhibit_Instance__c=Exhibitid;
        b.GES_Connect_Corporate_Accounts__c=congid;
        //Amarab 03/25/2021 SCA-878 Remove required setting
        //if (b.Brand_Team_Contact__c == null || b.Company_Code__c == null || b.Cost_Center__c == null || b.Funding_Provider_Brand__c == null || b.Funding_Provider_Region__c == null || b.Funding_Provider_Brand__c == null) 
        if (b.Brand_Team_Contact__c == null) 
        {
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR , 'Please make sure the following fields are entered : Brand Team Contact,  Funding Provider Region, Funding Provider Brand, Funding Provider Department, Cost Center & Company Code'));
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR , 'Please make sure the following fields are entered : Brand Team Contact'));
                return null;
        }  
        upsert b;
        PageReference Branddetail;
        if(autoBrand=='true'){
            Branddetail= new PageReference('/apex/ExhibitDetails');
            Branddetail.getParameters().put('exhibitid',String.valueOf(b.Exhibit_Instance__c)); 
            Branddetail.getParameters().put('exhibitName',ExhibitName); 
            Branddetail.getParameters().put('congressid',congid);  
            Branddetail.getParameters().put('congressName',congName);
        }else{
            Branddetail= new PageReference('/apex/ExhibitBrandDetails');
            Branddetail.getParameters().put('brandid',String.valueOf(b.id));
            Branddetail.getParameters().put('exhibitName',String.valueOf(ExhibitName));
        }
          
        Branddetail.setRedirect(true);
        return Branddetail;
    }
    
    Public PageReference BrandCancel()
    {    
        //PageReference exhibitdetail= new PageReference('/apex/ExhibitDetails');
        //exhibitdetail.getParameters().put('id',String.valueOf(congid));  
        //exhibitdetail.setRedirect(true);
        //return exhibitdetail;
        return new PageReference(GC_PageUtil.CheckApexDomain() + '/ExhibitDetails?congressid='+congid+'&Exhibitid='+Exhibitid+'&congressName='+congName);
    }
    
    public PageReference cancelOperation() 
    {
        system.debug('Entered cancelOperation');
        if(b.Canceled__c == True)
        {
            cancelReason  = true;
            b.Cancelled_Date__c = Date.today();
        }
        else if(b.Canceled__c == False)
        {
            cancelReason = false;
            b.Cancelled_Date__c = null;
            b.Reason_for_Cancellation__c = null;
        }
        
        return null;
    } 
    
    public void changeBrandCatandBusUnit() {
        if(mapBrandPicklist.get(b.Brand_Name__c) != null) {
            Map<String, String> mapValues = mapBrandPicklist.get(b.Brand_Name__c);
            for(String s : mapValues.keySet()) {
                b.Brand_Category__c = s;
                b.Business_Unit__c = mapValues.get(s);
            }
            reuiredStatus='true';
        }
    }
}