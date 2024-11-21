public class ExhibitEdit
{

    public id congid{get;set;}
    public string congName{get;set;}
    public string exhibitId {get;set;}
    public Exhibit__c e {get;set;}
    public Boolean cancelReason {get;set;}
    public String toClone {get;set;}
    //public Brand__c autoBrand{get; set;}
    public Map<String, Map<String,String>> mapBrandPicklist;
    public Exhibit__c es=new Exhibit__c();    
    //Exhibit__c e=new Exhibit__c();
    GES_Connect_Corporate_Accounts__c a=new GES_Connect_Corporate_Accounts__c();
    public PageReference exhibitdetail1;
    Public Exhibit__c gete(){
      return e;
    }
    Public GES_Connect_Corporate_Accounts__c geta(){
        return a;
    }


    public ExhibitEdit(ApexPages.StandardController controller) 
    {   toClone = 'false';
        congid = System.currentPageReference().getParameters().get('congressid'); 
        congName = System.currentPageReference().getParameters().get('congressName');
        exhibitId = System.currentPageReference().getParameters().get('exhibitid');
        toClone = System.currentPageReference().getParameters().get('toClone');
        system.debug('Cong id'+ congid);    
        system.debug('Cong id'+ congName);
        system.debug('exhibitid'+ exhibitid);
       // autoBrand = new Brand__c();
       // populatePicklistMap();
        if (String.isNotBlank(exhibitid)) 
        {
            Exhibit__c currentExhibit = [select Name,Exhibit_Name__c,Activity_Not_Confirmed__c,Activity_Type_Exhibit_Instance_c__c, GES_Project_Number__c,Booth_Length__c,Booth_Width__c,Booth_Size_Units__c,DoD_Properties__c,Booth_Number__c,Activity_Level__c,
            Congress_Lead__c,GES_Congress_Manager__c,Exhibit_Bundled_with_Sponsorsip__c,Medical_Information__c,Disease_State_booth__c,Clinical_Trials_Recruiting__c,E_Permissions__c,HCP_tracking__c,In_booth_promotion__c,
            In_booth_promotion_detail__c,In_booth_hospitality__c,In_booth_hospitality_detail__c,Canceled__c,CanceledDate__c,CancelReason__c, GES_Project_Manager__c, GES_Account_Manager__c, GES_Account_Executive__c, I_D_Supervisor__c, Exhibit_Space_Type__c , Agency_Name__c, Agency_Contact_Name__c, Agency_Contact_Phone__c,
             Agency_Contact_E_mail__c,I_D_Name_Other__c, Booth_Leadership_Type__c, Notes__c, Reason_RE_not_used__c,Staffing_Strategy__c,Quantity_of_Staffers__c, If_not_appropriate_audience_Explanation__c,Reality_Engineering_Utilized__c,Exhibit_Notes__c,CSI_Form_Notes__c, Exhibit_Type__c, Virtual_Engagement_Type__c, Exhibit_Registrants__c  from Exhibit__c where Id =: exhibitid];
             //  726
            e = new Exhibit__c();
            //autoBrand.Brand_Name__c= 'AutoBrand for- ' +e.Name;
            if(toClone=='true'){
                e= currentExhibit.Clone(false, true,false,false);
                e.Activity_Not_Confirmed__c = true;
                
            }else{
                e =  currentExhibit;
                
            }           
            
            if(currentExhibit.Canceled__c == True)
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
            
            e = new Exhibit__c();
            cancelReason = false;
            e.Activity_Type_Exhibit_Instance_c__c = congid;
        }
        
    }
    
     Public PageReference ExhibitSave()
    {
        system.debug(e);        
        upsert e;
        
        
        
        /***** SAL 464 ****/
        if(toClone=='true'){
            List<Brand__c> listBrandToInsert = new List<Brand__c > ();
            for(Brand__c b : [select id,Name,Brand_Name__c,GES_Connect_Corporate_Accounts__c,GES_Congress_Manager__c,Brand_Category__c,Congress_Lead__c,Business_Unit__c,COE_Supported__c,Exhibit_Instance__c,Createddate,lastmodifieddate,Canceled__c from Brand__c where Canceled__c = false AND Exhibit_Instance__c =:exhibitid]) {
                  Brand__c brand = b.clone(false, true);
                   brand.Exhibit_Instance__c = e.id;
                   listBrandToInsert.add(brand);
            }
            insert listBrandToInsert;
            Exhibit__c varCloned= [ SELECT Id, Name, Exhibit_Name__c,Activity_Type_Exhibit_Instance_c__c, Activity_Type_Exhibit_Instance_c__r.Name from Exhibit__c where Id =:e.id];
            congid= varCloned.Activity_Type_Exhibit_Instance_c__c;
            congName= varCloned.Activity_Type_Exhibit_Instance_c__r.Name;
            
        }
        /***** SAL 464 till here****/
        if(String.isNotBlank(exhibitId)){
            exhibitdetail1= new PageReference('/apex/ExhibitDetails');
            exhibitdetail1.getParameters().put('exhibitid',String.valueOf(e.id)); 
            exhibitdetail1.getParameters().put('exhibitName',String.valueOf(e.Name)); 
            exhibitdetail1.getParameters().put('congressid',String.valueOf(congid));  
            exhibitdetail1.getParameters().put('congressName',String.valueOf(congName));
            
        }else{
            exhibitdetail1= new PageReference('/apex/ExhibitBrandEdit');
            exhibitdetail1.getParameters().put('Exhibitid',String.valueOf(e.id)); 
            exhibitdetail1.getParameters().put('exhibitName',String.valueOf(e.Name)); 
            exhibitdetail1.getParameters().put('congid',String.valueOf(congid));  
            exhibitdetail1.getParameters().put('congName',String.valueOf(congName));  
            exhibitdetail1.getParameters().put('autoBrand','true');
        }        
        exhibitdetail1.setRedirect(true);
        return exhibitdetail1;
    }
    public PageReference ExhibitCancel()
    {
        PageReference exhibitdetail= new PageReference('/apex/ExhibitDetails');
        exhibitdetail.getParameters().put('exhibitid',String.valueOf(e.id)); 
        //exhibitdetail.getParameters().put('exhibitName',String.valueOf(e.Name)); 
        exhibitdetail.getParameters().put('congressid',String.valueOf(congid));  
        exhibitdetail.getParameters().put('congressName',String.valueOf(congName));  
        exhibitdetail.setRedirect(true);
        return exhibitdetail;
    }
    
    public PageReference cancelOperation() 
    {
        system.debug('Entered cancelOperation');
        if(e.Canceled__c == True)
        {
            cancelReason = true;
            e.CanceledDate__c = Date.today();
        }
        else
        {
            cancelReason = false;
            e.CanceledDate__c = null;
            e.CancelReason__c = null;
        }
        
        return null;
    } 
    
    
    
    
    
}