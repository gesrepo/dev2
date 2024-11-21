public class SymposiaEdit
{
    public Boolean cancelReason {get;set;}
    public id congid{get;set;}
    public string congName{get;set;}
    public string symid{get;set;}
    public String toClone {get;set;}
    public Symposia__c sy=new Symposia__c();    
    // Product_Theater__c pt=new Product_Theater__c();
    GES_Connect_Corporate_Accounts__c a=new GES_Connect_Corporate_Accounts__c();
    
    Public Symposia__c getsy(){
        return sy;
    }
    Public GES_Connect_Corporate_Accounts__c geta(){
        return a;
    }
    
    public SymposiaEdit(ApexPages.StandardController controller) {
        congid = System.currentPageReference().getParameters().get('congid'); 
        congName = System.currentPageReference().getParameters().get('congName'); 
        symid= System.currentPageReference().getParameters().get('symid'); 
        toClone = System.currentPageReference().getParameters().get('toClone');
        //system.debug('Cong id'+ congid);    
        //system.debug('Cong Name'+ congName);    
        //system.debug('Symp id'+ symid);    
        if(String.isNotBlank(symid))
        {
            Symposia__c currentSymposia =[select id,Name,CurrencyIsoCode,Activity_Level__c,Activity_Not_Confirmed__c,Congress_Lead__c,GES_Congress_Manager__c,Congress__c,Symposia_Name__c,Symposium_Date__c,Symposium_Lead__c,Symposium_Location__c,Symposium_Time__c,Canceled__c,CanceledDate__c,CancelReason__c, GES_Account_Manager__c, GES_Account_Executive__c, Symposium_Notes__c, Agency_Name__c, Agency_Contact_Name__c, Agency_Contact_Phone__c, Agency_Contact_E_mail__c, Included_w_Sponsorship__c,Symposium_Bundled_w_Sponsorship__c,Chair_Person__c, Symposium_End_Date_and_Time__c,Requested_Symposium_Date_and_Time__c, Speaker_1__c, Speaker_2__c, Speaker_3__c, Speaker_4__c,Meal_included_with_Symposium__c,Reason_RE_not_used__c,Reality_Engineering_Utilized__c,If_not_appropriate_audience_Explanation__c,Symposia_Type__c, Symposia_Registrants__c from Symposia__c where id=:symid]; 
            //          
            sy=new Symposia__c();
            
            if(toClone=='true'){
                sy= currentSymposia.Clone(false, true,false,false);
                sy.Activity_Not_Confirmed__c = true;
                
            }else{
                sy = currentSymposia;
                
            }  
            
            if(sy.Canceled__c == True)
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
            sy.CurrencyIsoCode = GCCA.CurrencyIsoCode;
            cancelReason = False;
            sy.Congress__c=congid;
        }    
    }
    
    
    
    Public PageReference SymposiaSave(){
        //system.debug(sy);
        //system.debug('GCN Id'+congid);
        upsert sy;
        if(toClone=='true'){
            List<Brand__c> listBrandToInsert = new List<Brand__c > ();
            for(Brand__c b : [select id,Name,Brand_Name__c,GES_Connect_Corporate_Accounts__c,GES_Congress_Manager__c,Brand_Category__c,Congress_Lead__c,Business_Unit__c,COE_Supported__c,Exhibit_Instance__c,Createddate,lastmodifieddate,Canceled__c from Brand__c where Canceled__c = false AND Symposia__c =:symid]) {
                Brand__c brand = b.clone(false, true);
                brand.Symposia__c = sy.id;
                listBrandToInsert.add(brand);
            }
            insert listBrandToInsert;
            Symposia__c varCloned= [ SELECT Id, Name,Symposia_Name__c, Congress__c,Congress__r.Name from Symposia__c where Id =:sy.id];
            congid= varCloned.Congress__c;
            congName= varCloned.Congress__r.Name;
        }
        PageReference Symposiadetail= new PageReference('/apex/SymposiaDetails');
        if(string.isNotBlank(symid)){
            Symposiadetail= new PageReference('/apex/SymposiaDetails');
        }else{
            Symposiadetail= new PageReference('/apex/SymposiaBrandEdit');
            Symposiadetail.getParameters().put('autoBrand','true');  
        }
        Symposiadetail.getParameters().put('symid',String.valueOf(sy.id));  
        Symposiadetail.getParameters().put('congid',String.valueOf(congid));  
        Symposiadetail.getParameters().put('congName',String.valueOf(congName));  
        Symposiadetail.getParameters().put('symName',String.valueOf(sy.Name));  
        Symposiadetail.setRedirect(true);
        return Symposiadetail;       
    }
    public PageReference symposiaCancel()
    {    
        PageReference Symposiadetail= new PageReference('/apex/SymposiaDetails');
        Symposiadetail.getParameters().put('symid',String.valueOf(sy.id));  
        Symposiadetail.getParameters().put('congid',String.valueOf(congid));  
        Symposiadetail.getParameters().put('congName',String.valueOf(congName));  
        //Symposiadetail.getParameters().put('symName',String.valueOf(sy.Name));  
        Symposiadetail.setRedirect(true);
        return Symposiadetail;       
    }
    
    public PageReference cancelOperation() 
    {
        system.debug('Entered cancelOperation');
        if(sy.Canceled__c == True)
        {
            cancelReason = true;
            sy.CanceledDate__c = Date.today();
        }
        else
        {
            cancelReason = false;
            sy.CanceledDate__c = null;
            sy.CancelReason__c = null;
        }
        
        return null;
    }
}