public class SymposiaDetail
{
    public string symid{get;set;}
    public string symName{get;set;}
    public string congid{get;set;}
    public string congName{get;set;}  
    public string exhibitHoursOpenDay1{get; set;}
    public string exhibitHoursOpenDay2{get; set;}
    public Double offset{get{
        TimeZone tz = UserInfo.getTimeZone();
        //Milliseconds to Day
        return tz.getOffset(DateTime.now()) / (1000 * 3600 * 24.0);
    }}
    public SymposiaDetail()    
    {
        symid=System.currentPageReference().getParameters().get('symid'); 
        system.debug('Symposiaid id'+ symid);
        symName=System.currentPageReference().getParameters().get('symName'); 
        system.debug('Symposiaid Name'+ symName);
        congid=System.currentPageReference().getParameters().get('congid'); 
        system.debug('congid id'+ congid);
        congName=System.currentPageReference().getParameters().get('congName'); 
        system.debug('congName id'+ congName);  
        SymposiaData(); 
        
    }
    Symposia__c sy=new Symposia__c();
    
    Public Symposia__c getsy(){
        return sy;
    }
    public PageReference SymposiaData()
    {
        if (String.isNotBlank(symid))
        {
            sy=[select id,Name,Activity_Level__c,CurrencyIsoCode,Activity_Not_Confirmed__c,Congress_Lead__c,GES_Congress_Manager__c,Congress__c,Symposia_Name__c,Symposium_Date__c,Symposium_Lead__c,Symposium_Location__c,Symposium_Time__c,Canceled__c,CanceledDate__c,CancelReason__c, GES_Account_Manager__c, GES_Account_Executive__c, Symposium_Notes__c, Agency_Name__c, Agency_Contact_Name__c, Agency_Contact_Phone__c, Agency_Contact_E_mail__c,Symposium_Bundled_w_Sponsorship__c,Chair_Person__c, Symposium_End_Date_and_Time__c,Requested_Symposium_Date_and_Time__c, Speaker_1__c, Speaker_2__c, Speaker_3__c, Speaker_4__c,Meal_included_with_Symposium__c,Reason_RE_not_used__c,Reality_Engineering_Utilized__c,If_not_appropriate_audience_Explanation__c,Symposia_Type__c, Symposia_Registrants__c from Symposia__c where id=:symid];       
            //
            brandList();
            if(sy.Symposium_Time__c!=null){
                exhibitHoursOpenDay1 = sy.Symposium_Time__c.format('MMMM d, yyyy  hh:mm a', UserInfo.getTimeZone().toString());
            }else{
                exhibitHoursOpenDay1='';
            }
            if(sy.Symposium_End_Date_and_Time__c!=null){
                exhibitHoursOpenDay2 = sy.Symposium_End_Date_and_Time__c.format('MMMM d, yyyy  hh:mm a', UserInfo.getTimeZone().toString());
            }else{
                exhibitHoursOpenDay2='';
            }
        }
        return null;    
    }
    public List<Brand__c> brdlist{get;set;}
    public PageReference brandList()
    {
        brdlist=[select id,Name,Brand_Name__c,Brand_Category__c,Business_Unit__c,Congress_Lead__c,Brand_Team_Contact__c,GES_Congress_Manager__c,COE_Supported__c,Sponsorship_Budget_Estimated__c,Sponsorship_Budget_Actual__c,Createddate,lastmodifieddate,Canceled__c from Brand__c where Symposia__c=:sy.id];
        return null;
    }
    public PageReference SymposiaNewBrand()
    {
        PageReference SymposiaBrandEdit= new PageReference('/apex/SymposiaBrandEdit');
        SymposiaBrandEdit.getParameters().put('symid',String.valueOf(sy.id));  
        SymposiaBrandEdit.getParameters().put('symName',String.valueOf(sy.Name));  
        SymposiaBrandEdit.getParameters().put('congid',String.valueOf(congid));  
        SymposiaBrandEdit.getParameters().put('congName',String.valueOf(congName));  
        SymposiaBrandEdit.setRedirect(true);
        return SymposiaBrandEdit;               
    }
    Public PageReference CongressDetail(){    
        PageReference congressdetail= new PageReference('/apex/Congressdetails');
        congressdetail.getParameters().put('id',String.valueOf(congName));  
        congressdetail.setRedirect(true);
        return congressdetail;
    }
    
    Public PageReference SymposiaSave()
    {
        return new PageReference(GC_PageUtil.CheckApexDomain() + '/Symposiaedit?congid='+congid+'&symid='+symid+'&congName='+congName+'&toClone=false');
    }
    
    public PageReference Symposiacancel()
    {
        return new PageReference(GC_PageUtil.CheckApexDomain() + '/Congressdetails?id='+congid);
    }
    Public PageReference SymposiaClone()
    {
        return new PageReference(GC_PageUtil.CheckApexDomain() + '/Symposiaedit?congressid='+congid+'&symid='+symid+'&congressName='+congName+'&toClone=true');
    }
}