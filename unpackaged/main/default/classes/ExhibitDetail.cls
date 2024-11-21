public class ExhibitDetail
{
    public string congid{get;set;}
    public string congName{get;set;}
    public string exhibitid{get;set;}
    public string exhibitName{get;set;}
    public ExhibitDetail()    
    {        
        congid =System.currentPageReference().getParameters().get('congressid'); 
        congName=System.currentPageReference().getParameters().get('congressName'); 
        exhibitid=System.currentPageReference().getParameters().get('exhibitid'); 
        exhibitName=System.currentPageReference().getParameters().get('exhibitName'); 
        system.debug('Cong id'+ congid);      
        system.debug('Cong Name'+ congName);                
        system.debug('exhibit id'+ exhibitid); 
        system.debug('exhibit Name'+ exhibitName); 
        ExhibitData();
        Exhibitinfo();
    }
    public PageReference Exhibitinfo()
    {
        if(exhibitid!=null){
        system.debug('exhibit id'+ exhibitid);
        e=[select id,Name,Exhibit_Name__c,CurrencyIsoCode,Activity_Not_Confirmed__c,GES_Congress_Manager__c,Congress_Lead__c,GES_Project_Number__c,GES_Project_Number_For__c,Booth_Length__c,Booth_Width__c,Booth_Size_Units__c,DoD_Properties__c,Booth_Number__c,Activity_Level__c,Exhibit_Bundled_with_Sponsorsip__c,Medical_Information__c,Disease_State_booth__c,Clinical_Trials_Recruiting__c,E_Permissions__c,HCP_tracking__c,In_booth_promotion__c,In_booth_promotion_detail__c,In_booth_hospitality__c,In_booth_hospitality_detail__c,Canceled__c,CanceledDate__c,CancelReason__c, GES_Project_Manager__c, GES_Account_Manager__c, GES_Account_Executive__c, I_D_Supervisor__c, Exhibit_Space_Type__c, Agency_Name__c, Agency_Contact_Phone__c, Agency_Contact_Name__c,Reality_Engineering_Utilized__c,
        Agency_Contact_E_mail__c,I_D_Name_Other__c, Booth_Leadership_Type__c, Notes__c,Reason_RE_not_used__c,Staffing_Strategy__c,Quantity_of_Staffers__c, If_not_appropriate_audience_Explanation__c,Exhibit_Notes__c,CSI_Form_Notes__c, Exhibit_Type__c, Virtual_Engagement_Type__c, Exhibit_Registrants__c from Exhibit__c where id=:exhibitid];
         // 726
        exhibitName = e.Name;
        BrandList();
        } 
        return null;
    }
    public PageReference Brandinfo()
    {
        return null;
    }
    public List<Brand__c> brdlst{get;set;}
    public PageReference ExhibitData()
    {
       /* if(congid!=''){
        system.debug('Cong id'+ congid);
        e=[select id,Name,Exhibit_Name__c,GES_Project_Number__c,Booth_Length__c,Booth_Width__c,Booth_Number__c,Activity_Level__c,Exhibit_Bundled_with_Sponsorsip__c,Medical_Information__c,Disease_State_booth__c,Clinical_Trials_Recruiting__c,E_Permissions__c,HCP_tracking__c,In_booth_promotion__c,In_booth_promotion_detail__c,In_booth_hospitality__c,In_booth_hospitality_detail__c,I_D_Name_Other__c from Exhibit__c where id=:congid];
        BrandList();
        }*/
        return null;
    }
    public PageReference BrandList()
    {
        if(congid!='')
        {
        system.debug('cong id 16'+congid);
        system.debug('Exhibit id'+e.Name);
            brdlst=[select id,Name,Brand_Name__c,Brand_Category__c,Business_Unit__c,Exhibit_Instance__c,Createddate,lastmodifieddate,Canceled__c from Brand__c where Exhibit_Instance__c=:e.id];
            system.debug('List of Brand'+brdlst);
        }
        return null;
    }
    Exhibit__c e=new Exhibit__c();
    GES_Connect_Corporate_Accounts__c a=new GES_Connect_Corporate_Accounts__c();
    Public Exhibit__c gete(){
   return e;
    }
    Public GES_Connect_Corporate_Accounts__c geta(){
    return a;
    }
    Public PageReference newBrand(){    
    PageReference NewBrand= new PageReference('/apex/ExhibitBrandEdit');
    NewBrand.getParameters().put('exhibitid',String.valueOf(e.id));  
    NewBrand.getParameters().put('exhibitName',String.valueOf(e.Name));  
    NewBrand.getParameters().put('congid',String.valueOf(congid));
    NewBrand.getParameters().put('congName',String.valueOf(congName));
        NewBrand.setRedirect(true);
        return NewBrand;
    }
    
    Public PageReference CongressDetail(){    
    PageReference congressdetail= new PageReference('/apex/Congressdetails');
    congressdetail.getParameters().put('id',String.valueOf(congName));  
        congressdetail.setRedirect(true);
        return congressdetail;
    }

    Public PageReference ExhibitSave()
    {
        return new PageReference(GC_PageUtil.CheckApexDomain() + '/Exhibitedit?congressid='+congid+'&exhibitid='+exhibitid+'&congressName='+congName);
    }

    public PageReference ExhibitCancel()
    {
        return new PageReference(GC_PageUtil.CheckApexDomain() + '/Congressdetails?id='+congid);
    }
    Public PageReference ExhibitClone()
    {
        return new PageReference(GC_PageUtil.CheckApexDomain() + '/Exhibitedit?congressid='+congid+'&exhibitid='+exhibitid+'&congressName='+congName+'&toClone=true');
    }
}