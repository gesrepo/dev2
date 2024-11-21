public class ProductTheaterEdit
{
    public Boolean cancelReason {get;set;}
    public id congid{get;set;}
    public string congName{get;set;}
    public string ProductTheaterid{get;set;}
    public String toClone {get;set;}
    
    public Product_Theater__c pt=new Product_Theater__c();
    GES_Connect_Corporate_Accounts__c a=new GES_Connect_Corporate_Accounts__c();
    Public Product_Theater__c getpt(){
        return pt;
    }
    Public GES_Connect_Corporate_Accounts__c geta(){
        return a;
    }
    
    public ProductTheaterEdit(ApexPages.StandardController controller) {
        congid = System.currentPageReference().getParameters().get('congid'); 
        congName = System.currentPageReference().getParameters().get('congName'); 
        ProductTheaterid= System.currentPageReference().getParameters().get('ProductTheaterid'); 
        toClone = System.currentPageReference().getParameters().get('toClone');
        system.debug('Cong id'+ congid);    
        system.debug('Cong Name'+ congName); 
        system.debug('ProductTheaterid '+ ProductTheaterid); 
        if(String.isNotBlank(ProductTheaterid))
        {
            
            Product_Theater__c currentProduct_Theater = [select id,Name,Activity_Level__c,CurrencyIsoCode,Activity_Not_Confirmed__c,GES_Congress_Manager__c,Congress_Lead__c,Congress__c,Product_Theater_Date__c,Product_Theater_Lead__c,Product_Theater_Location__c,Product_Theater_Name__c, Product_Theater_Time__c,Canceled_Date__c,Canceled__c,Cancel_Reason__c, GES_Account_Manager__c, GES_Account_Executive__c, Product_Theater_Notes__c, Agency_Name__c, Agency_Contact_Name__c, Agency_Contact_Phone__c, Agency_Contact_E_mail__c,Chair_Person__c, Product_Theater_End_Date_and_Time__c,Reason_RE_not_used__c, If_not_appropriate_audience_Explanation__c,Requested_Product_Theater_Date_and_Time__c, Speaker_1__c, Speaker_2__c, Speaker_3__c, Speaker_4__c,Meal_included_with_Product_Theater__c, Reality_Engineering_Utilized__c, PT_Type__c, Product_Theater_Registrants__c from Product_Theater__c where id=:ProductTheaterid];
            // , for SCA-726 rsinha
            pt = new Product_Theater__c();
            
            if(toClone=='true'){
                pt= currentProduct_Theater.Clone(false, true,false,false);
                pt.Activity_Not_Confirmed__c = true;
                
            }else{
                pt = currentProduct_Theater;
                
            }           
            if(pt.Canceled__c == True)
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
            GES_Connect_Corporate_Accounts__c GCCA = [SELECT Id,CurrencyIsoCode FROM GES_Connect_Corporate_Accounts__c WHERE Id = :congid];
            pt.CurrencyIsoCode = GCCA.CurrencyIsoCode;
            cancelReason = False;
            pt.Congress__c=congid;
        }   
        //e.Activity_Type_Exhibit_Instance_c__c=congid;
        // e.Activity_Type_Exhibit_Instance_c__c=congid;
        
    }
    
    
    Public PageReference ProductTheaterSave(){
        system.debug(pt);
        
        system.debug('GCN Id'+congid);
        upsert pt;
        if(toClone=='true'){
            List<Brand__c> listBrandToInsert = new List<Brand__c > ();
            for(Brand__c b : [select id,Name,Brand_Name__c,GES_Connect_Corporate_Accounts__c,GES_Congress_Manager__c,Brand_Category__c,Congress_Lead__c,Business_Unit__c,COE_Supported__c,Exhibit_Instance__c,Createddate,lastmodifieddate,Canceled__c from Brand__c where Canceled__c = false AND Product_Theater__c =:ProductTheaterid]) {
                Brand__c brand = b.clone(false, true);
                brand.Product_Theater__c = pt.id;
                listBrandToInsert.add(brand);
            }
            insert listBrandToInsert;
            Product_Theater__c varCloned= [ SELECT Id, Name, Product_Theater_Name__c, Congress__c,Congress__r.Name from Product_Theater__c where Id =:pt.id];
            congid= varCloned.Congress__c;
            congName= varCloned.Congress__r.Name;
            
        }
        PageReference ProductTheaterdetail;
        if(string.isNotBlank(ProductTheaterid)){
            ProductTheaterdetail= new PageReference('/apex/ProductTheaterDetail');
            ProductTheaterdetail.getParameters().put('producttherid',String.valueOf(pt.id));  
            ProductTheaterdetail.getParameters().put('producttherName',String.valueOf(pt.Name));  
            ProductTheaterdetail.getParameters().put('congid',String.valueOf(congid));  
            ProductTheaterdetail.getParameters().put('congName',String.valueOf(congName)); 
        }else{
            ProductTheaterdetail= new PageReference('/apex/ProductTheaterBrandEdit');
            ProductTheaterdetail.getParameters().put('ProductTheaterid',String.valueOf(pt.id));  
            ProductTheaterdetail.getParameters().put('producttherName',String.valueOf(pt.Name));  
            ProductTheaterdetail.getParameters().put('congid',String.valueOf(congid));  
            ProductTheaterdetail.getParameters().put('congName',String.valueOf(congName));
            ProductTheaterdetail.getParameters().put('autoBrand','true');
        }
        ProductTheaterdetail.setRedirect(true);
        return ProductTheaterdetail;       
    }
    public PageReference producttherCancel()
    {
        PageReference ProductTheaterdetail= new PageReference('/apex/ProductTheaterDetail');
        ProductTheaterdetail.getParameters().put('producttherid',String.valueOf(pt.id));  
        // ProductTheaterdetail.getParameters().put('producttherName',String.valueOf(pt.Name));  
        ProductTheaterdetail.getParameters().put('congid',String.valueOf(congid));  
        ProductTheaterdetail.getParameters().put('congName',String.valueOf(congName));  
        ProductTheaterdetail.setRedirect(true);
        return ProductTheaterdetail;       
    }
    
    public PageReference cancelOperation() 
    {
        system.debug('Entered cancelOperation');
        if(pt.Canceled__c == True)
        {
            cancelReason = true;
            pt.Canceled_Date__c = Date.today();
        }
        else
        {
            cancelReason = false;
            pt.Canceled_Date__c = null;
            pt.Cancel_Reason__c = null;
        }
        
        return null;
    } 
}