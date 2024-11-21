public class SponsorshipEdit
{ 
    
    public id congid{get;set;}
    public string congName{get;set;}
    public string sponid{get;set;}
    public Sponsorship__c sp {get;set;}
    public Boolean cancelReason {get;set;}
    public String toClone {get;set;}
    
    public Sponsorship__c sps=new Sponsorship__c();
    GES_Connect_Corporate_Accounts__c a=new GES_Connect_Corporate_Accounts__c();
    Public Sponsorship__c getsp(){
        return sp;
    }
    Public GES_Connect_Corporate_Accounts__c geta(){
        return a;
    }
    
    public SponsorshipEdit(ApexPages.StandardController controller)
    {
        congid = System.currentPageReference().getParameters().get('congid'); 
        congName = System.currentPageReference().getParameters().get('congName'); 
        sponid = System.currentPageReference().getParameters().get('sponid'); 
        toClone = System.currentPageReference().getParameters().get('toClone'); 
        system.debug('Cong id'+ congid);    
        system.debug('Cong Name'+ congName);    
        system.debug('Spon id'+ sponid );  
        if(String.isNotBlank(sponid ))
        {
            Sponsorship__c currentSponsorship=[select id,Name,Activity_Level__c,Activity_Not_Confirmed__c,Congress_Lead__c,GES_Congress_Manager__c,Exhibit_Bundled_with_Sponsorsip__c,Sponsorship__c,Sponsorship_Costs_Actual__c,Sponsorship_Costs_Estimated__c,Sponsorship_Name__c,Canceled__c,CanceledDate__c,CancelReason__c,Sponsorship_Notes__c,GES_Account_Manager__c, GES_Account_Executive__c, Agency_Name__c, Agency_Contact_Name__c, Agency_Contact_Phone__c, Agency_Contact_E_mail__c, Sponsorship_Type__c, Alternate_Activity__c, Sponsorship_Registrants__c from Sponsorship__c where id=:sponid ];
            sp = new Sponsorship__c();
            
            if(toClone=='true'){
                sp = currentSponsorship.Clone(false, true,false,false);
                sp.Activity_Not_Confirmed__c = true;
            }
            else{
                sp = currentSponsorship;
            }  
            
            if(currentSponsorship.Canceled__c == True)
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
            sp = new Sponsorship__c();
            cancelReason = False;
            sp.Sponsorship__c=congid;
        }                     
    }
    
    
    Public PageReference SponsorshipSave(){
        //system.debug(sp);
        
        //system.debug('GCN Id'+congid);
        upsert sp;
        if(toClone=='true'){
            List<Brand__c> listBrandToInsert = new List<Brand__c > ();
            for(Brand__c b : [select id,Name,Brand_Name__c,GES_Connect_Corporate_Accounts__c,GES_Congress_Manager__c,Brand_Category__c,Congress_Lead__c,Business_Unit__c,COE_Supported__c,Createddate,lastmodifieddate,Canceled__c from Brand__c where Canceled__c = false AND Sponsorship__c =:sponid]) {
                Brand__c brand = b.clone(false, true);
                brand.Sponsorship__c = sp.id;
                listBrandToInsert.add(brand);
            }
            insert listBrandToInsert;
            Sponsorship__c varCloned= [ SELECT Id, Name, Sponsorship_Name__c, Sponsorship__r.Name from Sponsorship__c where Id =:sp.id];
            congid= varCloned.Sponsorship__c;
            congName= varCloned.Sponsorship__r.Name;
            
        }
        PageReference Sponsorshipdetail;
        if(string.isNotBlank(sponid)){
            Sponsorshipdetail= new PageReference('/apex/SponsorshipDetails');
            
        }else{
            Sponsorshipdetail= new PageReference('/apex/SponsorshipBrandEdit');
            Sponsorshipdetail.getParameters().put('autoBrand','true');  
        }
        Sponsorshipdetail.getParameters().put('sponid',String.valueOf(sp.id));  
        Sponsorshipdetail.getParameters().put('sponName',String.valueOf(sp.Name));  
        Sponsorshipdetail.getParameters().put('congid',String.valueOf(congid));  
        Sponsorshipdetail.getParameters().put('congName',String.valueOf(congName));
        Sponsorshipdetail.setRedirect(true);
        return Sponsorshipdetail;       
    }
    public PageReference sponsorshipCancel(){
        PageReference Sponsorshipdetail= new PageReference('/apex/SponsorshipDetails');
        Sponsorshipdetail.getParameters().put('sponid',String.valueOf(sp.id));  
        Sponsorshipdetail.getParameters().put('congid',String.valueOf(congid));  
        Sponsorshipdetail.getParameters().put('congName',String.valueOf(congName));  
        Sponsorshipdetail.setRedirect(true);
        return Sponsorshipdetail;       
    }
    
    public PageReference cancelOperation() {
        system.debug('Entered cancelOperation');
        if(sp.Canceled__c == True)
        {
            cancelReason = true;
            sp.CanceledDate__c = Date.today();
        }
        else
        {
            cancelReason = false;
            sp.CanceledDate__c = null;
            sp.CancelReason__c = null;
        }
        
        return null;
    } 
}