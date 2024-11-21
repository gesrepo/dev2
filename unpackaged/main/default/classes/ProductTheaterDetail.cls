public class ProductTheaterDetail
{
    public string ProductTheaterid{get;set;}
    public string producttherName{get;set;}
    public string congid{get;set;}
    public string congName{get;set;}
    public Double offset{get{
        TimeZone tz = UserInfo.getTimeZone();
        //Milliseconds to Day
        return tz.getOffset(DateTime.now()) / (1000 * 3600 * 24.0);
    }}
    public string Requested_Product_Theater_Date_and_Time{get; set;}
    public string Product_Theater_Time{get; set;}
    public string Product_Theater_End_Date_and_Time{get; set;}
    public ProductTheaterDetail()    
    {
        
        ProductTheaterid =System.currentPageReference().getParameters().get('producttherid');  
        system.debug('Cong id'+ ProductTheaterid);
        producttherName=System.currentPageReference().getParameters().get('producttherName');  
        system.debug('producttherNameid'+ producttherName);
        congid=System.currentPageReference().getParameters().get('congid');  
        system.debug('Cong id'+ congid);
        congName=System.currentPageReference().getParameters().get('congName');  
        system.debug('congName id'+ congName);    
        if (String.isNotBlank(ProductTheaterid ))
        {    
            pt=[select id,Name,Activity_Level__c,CurrencyIsoCode,Activity_Not_Confirmed__c,GES_Congress_Manager__c,Congress_Lead__c,Congress__c,Product_Theater_Date__c,Product_Theater_Lead__c,Product_Theater_Location__c,Product_Theater_Name__c, Product_Theater_Time__c,Canceled_Date__c,Canceled__c,Cancel_Reason__c, GES_Account_Manager__c, GES_Account_Executive__c, Product_Theater_Notes__c, Agency_Name__c, Agency_Contact_Name__c, Agency_Contact_Phone__c, Agency_Contact_E_mail__c,Chair_Person__c, Product_Theater_End_Date_and_Time__c, Requested_Product_Theater_Date_and_Time__c, Speaker_1__c, Speaker_2__c, Speaker_3__c, Speaker_4__c,Meal_included_with_Product_Theater__c,Reason_RE_not_used__c ,If_not_appropriate_audience_Explanation__c,Reality_Engineering_Utilized__c, PT_Type__c, Product_Theater_Registrants__c from Product_Theater__c where id=:ProductTheaterid ];     
            // , removed , for SCA-726 rsinha
            brandList();
            
            if(pt.Requested_Product_Theater_Date_and_Time__c!=null){
                Requested_Product_Theater_Date_and_Time = pt.Requested_Product_Theater_Date_and_Time__c.format('MMMM d, yyyy  hh:mm a', UserInfo.getTimeZone().toString());
            }else{
                Requested_Product_Theater_Date_and_Time ='';
            }
            
            if(pt.Product_Theater_Time__c!=null){
                Product_Theater_Time = pt.Product_Theater_Time__c.format('MMMM d, yyyy  hh:mm a', UserInfo.getTimeZone().toString());
            }else{
                Product_Theater_Time='';}
            
            if(pt.Product_Theater_End_Date_and_Time__c!=null){
                Product_Theater_End_Date_and_Time= pt.Product_Theater_End_Date_and_Time__c.format('MMMM d, yyyy  hh:mm a', UserInfo.getTimeZone().toString());
            }else{
                Product_Theater_End_Date_and_Time='';}
            
            
        }
        
    }
    Product_Theater__c pt=new Product_Theater__c();
    
    public List<Brand__c> brdlist{get;set;}
    
    public PageReference brandList()
    {
        brdlist=[select id,Name,GES_Connect_Corporate_Accounts__c,GES_Congress_Manager__c ,Brand_Name__c,Brand_Category__c,Business_Unit__c,Congress_Lead__c,Brand_Team_Contact__c,COE_Supported__c,Sponsorship_Costs_Estimated__c,Budget_Owner__c,Funding_Owner__c,Cost_Center__c,Product_Theater_Costs_Estimated__c,Product_Theater_Costs_Actual__c,Createddate,lastmodifieddate,Canceled__c from Brand__c where Product_Theater__c=:pt.id];
        system.debug('Brand List'+brdlist);
        return null;
    }
    Public Product_Theater__c getpt(){
        return pt;
    }
    
    public PageReference ProductTheaterNewBrand()
    {
        PageReference ProductTheaterbrandEdit= new PageReference('/apex/ProductTheaterbrandEdit');
        ProductTheaterbrandEdit.getParameters().put('ProductTheaterid',String.valueOf(pt.id));  
        ProductTheaterbrandEdit.getParameters().put('producttherName',String.valueOf(pt.Name));  
        ProductTheaterbrandEdit.getParameters().put('congid',String.valueOf(congid));  
        ProductTheaterbrandEdit.getParameters().put('congName',String.valueOf(congName));  
        ProductTheaterbrandEdit.setRedirect(true);
        return ProductTheaterbrandEdit;               
    }
    Public PageReference CongressDetail(){    
        PageReference congressdetail= new PageReference('/apex/Congressdetails');
        congressdetail.getParameters().put('id',String.valueOf(congName));  
        congressdetail.setRedirect(true);
        return congressdetail;
    }
    
    Public PageReference prodtthrSave()
    {
        //return new PageReference(GC_PageUtil.CheckApexDomain() + '/Exhibitedit?congressid='+congid+'&exhibitid='+exhibitid+'&congressName='+congName);
        return new PageReference(GC_PageUtil.CheckApexDomain() + '/ProductTheaterEdit?congid='+congid+'&ProductTheaterid='+ProductTheaterid+'&congName='+congName);
    }
    
    public PageReference prodtthrcancel()
    {
        return new PageReference(GC_PageUtil.CheckApexDomain() + '/Congressdetails?id='+congid);
    }
    Public PageReference prodtthrClone()
    {
        return new PageReference(GC_PageUtil.CheckApexDomain() + '/ProductTheaterEdit?congressid='+congid+'&ProductTheaterid='+ProductTheaterid+'&congressName='+congName+'&toClone=true');
    }
}