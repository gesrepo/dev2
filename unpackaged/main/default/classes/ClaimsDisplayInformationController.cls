public class ClaimsDisplayInformationController {
    public ApexPages.standardController stdController {get; set;}
    public string claimsRecordType {get; set;}
    public Claims__Claim__c claim {get; set;}
    public Claims__Claim__c claim12 {get; set;}
    private Id recordId {get; set;}
    public string fistLastName{get;set;}
    public string BodilyInjury{get;set;}
     public string PropertyDamage{get;set;}
     public string PDcompanyName{get;set;}
    
     public string FacilityDamage{get;set;}
     public string FDCompany{get;set;}
    
     public string Theft{get;set;}
     public string TheftInfo{get;set;}
    
     public string Missing{get;set;}
     public string MissingInfo{get;set;}
    
     public string WCPortal{get;set;}
    public string WCPortalInfo{get;set;}
    
    public string MotorGES{get;set;}
    public string MotorGESInfo{get;set;}
    public string MotorNON{get;set;}
     public string MotorNONGESInfo{get;set;}
    public ClaimsDisplayInformationController(ApexPages.standardController controller){
        this.stdController = controller;
        claim = (Claims__Claim__c)this.stdController.getRecord();
        recordId = (Id)controller.getRecord().id;
        
        claim12=[select id,Record_Type_Name__c,Injured_Party_First_Name__c,Injured_Party_Last_Name__c,Carrier_Claim_No__c,Customer_Company_Name__c,GES_Driver_Full_Name__c,Injured_Employee_First_Name__c,Injured_Employee_Last_Name__c,Driver_First_Name__c,Driver_Last_Name__c,NON_GES_Driver_First_Name__c,NON_GES_Driver_Last_Name__c from Claims__Claim__c where id=:recordId];
        claimsRecordType=claim12.Record_Type_Name__c;
        system.debug('claimsRecordType-------->'+claimsRecordType);
        // headerValue=claim12.Preparer_First_Name__c+ '/' +claim12.Preparer_Last_Name__c;
        /*--------------- This is for Bodiliy Injury Type-----------------------------------*/
        BodilyInjury='BI - INJURED PARTY INFORMATION';
        if(claim12.Injured_Party_First_Name__c!=null && claim12.Injured_Party_Last_Name__c != null && claim12.Carrier_Claim_No__c != null){
            fistLastName = claim12.Injured_Party_Last_Name__c+','+' '+claim12.Injured_Party_First_Name__c+' '+'-'+' '+claim12.Carrier_Claim_No__c;
        }else if(claim12.Injured_Party_First_Name__c == null && claim12.Injured_Party_Last_Name__c != null && claim12.Carrier_Claim_No__c != null){
            fistLastName = claim12.Injured_Party_Last_Name__c+' '+'-'+' '+claim12.Carrier_Claim_No__c;
        }else if(claim12.Injured_Party_Last_Name__c == null && claim12.Injured_Party_First_Name__c!=null && claim12.Carrier_Claim_No__c!= null){
            fistLastName = claim12.Injured_Party_First_Name__c+' '+'-'+' '+claim12.Carrier_Claim_No__c;
        }else if(claim12.Injured_Party_First_Name__c==null && claim12.Injured_Party_Last_Name__c == null && claim12.Carrier_Claim_No__c == null){
            fistLastName ='';
        }
        else if(claim12.Injured_Party_First_Name__c!=null && claim12.Injured_Party_Last_Name__c != null && claim12.Carrier_Claim_No__c == null){
           fistLastName=claim12.Injured_Party_Last_Name__c+','+' '+claim12.Injured_Party_First_Name__c;
        }
        else if(claim12.Injured_Party_Last_Name__c == null && claim12.Injured_Party_First_Name__c!=null && claim12.Carrier_Claim_No__c == null){
            fistLastName=claim12.Injured_Party_First_Name__c;
        }
       else if(claim12.Injured_Party_Last_Name__c != null && claim12.Injured_Party_First_Name__c==null && claim12.Carrier_Claim_No__c == null){
           fistLastName = claim12.Injured_Party_Last_Name__c;
        }
         else if(claim12.Injured_Party_Last_Name__c == null && claim12.Injured_Party_First_Name__c==null && claim12.Carrier_Claim_No__c != null){
           fistLastName = claim12.Carrier_Claim_No__c;
        }
        if(fistLastName != null || fistLastName != ''){
            claim12.Injured_Party_First_Name__c = fistLastName;
        }
      
        
         /*--------------This is for  Property Damage Type-----------*/
        PropertyDamage='PD - Property Damage Information';
        if(claim12.Customer_Company_Name__c!=null){
            PDcompanyName = claim12.Customer_Company_Name__c;
        }else{
             PDcompanyName ='';
        }
        
         /*--------------This is for  Facility Damage Type-----------*/
        
         FacilityDamage='FD - Facility Damage Information';
        if(claim12.Customer_Company_Name__c!=null){
            FDCompany =claim12.Customer_Company_Name__c;
        }else{
             FDCompany ='';
        }
        
        
         /*--------------This is for  Theft Type-----------*/
        
         Theft='Theft Information';
        if(claim12.Customer_Company_Name__c!=null){
            TheftInfo =claim12.Customer_Company_Name__c;
        }else{
             TheftInfo ='';
        }
        
         /*--------------This is for  Missing Type-----------*/
        
         Missing='Missing Information';
        if(claim12.Customer_Company_Name__c!=null){
            MissingInfo =claim12.Customer_Company_Name__c;
        }else{
             MissingInfo ='';
        }
        
         /*--------------This is for  WC Type-----------*/
        WCPortal='WC - Workers Componsation Information';
        if(claim12.Injured_Employee_First_Name__c!=null && claim12.Injured_Employee_Last_Name__c != null && claim12.Carrier_Claim_No__c != null){
            WCPortalInfo =claim12.Injured_Employee_Last_Name__c+','+' '+claim12.Injured_Employee_First_Name__c+' '+'-'+' '+claim12.Carrier_Claim_No__c;
        }else if(claim12.Injured_Employee_First_Name__c == null && claim12.Injured_Employee_Last_Name__c != null && claim12.Carrier_Claim_No__c != null){
            WCPortalInfo =claim12.Injured_Employee_Last_Name__c+' '+'-'+' '+claim12.Carrier_Claim_No__c;
        }else if(claim12.Injured_Employee_Last_Name__c == null && claim12.Injured_Employee_First_Name__c!=null && claim12.Carrier_Claim_No__c!= null){
            WCPortalInfo =claim12.Injured_Employee_First_Name__c+' '+'-'+' '+claim12.Carrier_Claim_No__c;
        }else if(claim12.Injured_Employee_First_Name__c==null && claim12.Injured_Employee_Last_Name__c == null && claim12.Carrier_Claim_No__c == null){
            WCPortalInfo ='';
        }
        else if(claim12.Injured_Employee_First_Name__c!=null && claim12.Injured_Employee_Last_Name__c != null && claim12.Carrier_Claim_No__c == null){
           WCPortalInfo=claim12.Injured_Employee_Last_Name__c+','+' '+claim12.Injured_Employee_First_Name__c;
        }
        else if(claim12.Injured_Employee_Last_Name__c == null && claim12.Injured_Employee_First_Name__c!=null && claim12.Carrier_Claim_No__c == null){
            WCPortalInfo=claim12.Injured_Employee_First_Name__c;
        }
       else if(claim12.Injured_Employee_Last_Name__c != null && claim12.Injured_Employee_First_Name__c==null && claim12.Carrier_Claim_No__c == null){
           WCPortalInfo =claim12.Injured_Employee_Last_Name__c;
        }
         else if(claim12.Injured_Employee_Last_Name__c == null && claim12.Injured_Employee_First_Name__c==null && claim12.Carrier_Claim_No__c != null){
           WCPortalInfo =claim12.Carrier_Claim_No__c;
        }
        if(WCPortalInfo != null || WCPortalInfo != ''){
            claim12.Injured_Employee_First_Name__c = fistLastName;
        }
         /*--------------This is for Motor Vehicle Type-----------*/
         MotorGES='MV -  GES DRIVER INFORMATION';
        MotorNON='MV -NON GES DRIVER INFORMATION';
       /*if(claim12.Driver_First_Name__c!=null && claim12.Driver_Last_Name__c != null){
            MotorGESInfo = '/'+claim12.Driver_First_Name__c+'/'+claim12.Driver_Last_Name__c;
        }else if(claim12.Driver_First_Name__c == null && claim12.Driver_Last_Name__c != null){
            MotorGESInfo = '/'+claim12.Driver_Last_Name__c;
        }else if(claim12.Driver_Last_Name__c == null && claim12.Driver_First_Name__c!=null){
            MotorGESInfo = '/'+claim12.Driver_First_Name__c;
        }else if(claim12.Driver_First_Name__c==null && claim12.Driver_Last_Name__c == null){
            MotorGESInfo ='';
        }
        if(MotorGESInfo != null || MotorGESInfo != ''){
            claim12.Driver_First_Name__c = MotorGESInfo;
        }*/
         if(claim12.Driver_First_Name__c!=null && claim12.Driver_Last_Name__c != null && claim12.Carrier_Claim_No__c != null){
            MotorGESInfo =claim12.Driver_Last_Name__c+','+' '+claim12.Driver_First_Name__c+' '+'-'+' '+claim12.Carrier_Claim_No__c;
        }else if(claim12.Driver_First_Name__c == null && claim12.Driver_Last_Name__c != null && claim12.Carrier_Claim_No__c != null){
            MotorGESInfo =claim12.Driver_Last_Name__c+' '+'-'+' '+claim12.Carrier_Claim_No__c;
        }else if(claim12.Driver_Last_Name__c == null && claim12.Driver_First_Name__c!=null && claim12.Carrier_Claim_No__c!= null){
            MotorGESInfo =claim12.Driver_First_Name__c+' '+'-'+' '+claim12.Carrier_Claim_No__c;
        }else if(claim12.Driver_First_Name__c==null && claim12.Driver_Last_Name__c == null && claim12.Carrier_Claim_No__c == null){
            MotorGESInfo ='';
        }
        else if(claim12.Driver_First_Name__c!=null && claim12.Driver_Last_Name__c != null && claim12.Carrier_Claim_No__c == null){
           MotorGESInfo=claim12.Driver_Last_Name__c+','+' '+claim12.Driver_First_Name__c;
        }
        else if(claim12.Driver_Last_Name__c == null && claim12.Driver_First_Name__c!=null && claim12.Carrier_Claim_No__c == null){
            MotorGESInfo=claim12.Driver_First_Name__c;
        }
       else if(claim12.Driver_Last_Name__c != null && claim12.Driver_First_Name__c==null && claim12.Carrier_Claim_No__c == null){
           MotorGESInfo =claim12.Driver_Last_Name__c;
        }
         else if(claim12.Driver_Last_Name__c == null && claim12.Driver_First_Name__c==null && claim12.Carrier_Claim_No__c != null){
           MotorGESInfo =claim12.Carrier_Claim_No__c;
        }
        if(MotorGESInfo != null || MotorGESInfo != ''){
            claim12.Driver_First_Name__c = MotorGESInfo;
        }
          if(claim12.NON_GES_Driver_First_Name__c!=null && claim12.NON_GES_Driver_Last_Name__c != null && claim12.Carrier_Claim_No__c != null){
            MotorNONGESInfo =claim12.NON_GES_Driver_Last_Name__c+','+' '+claim12.NON_GES_Driver_First_Name__c+' '+'-'+' '+claim12.Carrier_Claim_No__c;
        }else if(claim12.NON_GES_Driver_First_Name__c == null && claim12.NON_GES_Driver_Last_Name__c != null && claim12.Carrier_Claim_No__c != null){
            MotorNONGESInfo =claim12.NON_GES_Driver_Last_Name__c+' '+'-'+' '+claim12.Carrier_Claim_No__c;
        }else if(claim12.NON_GES_Driver_Last_Name__c == null && claim12.NON_GES_Driver_First_Name__c!=null && claim12.Carrier_Claim_No__c!= null){
            MotorNONGESInfo =claim12.NON_GES_Driver_First_Name__c+' '+'-'+' '+claim12.Carrier_Claim_No__c;
        }else if(claim12.NON_GES_Driver_First_Name__c==null && claim12.NON_GES_Driver_Last_Name__c == null && claim12.Carrier_Claim_No__c == null){
            MotorNONGESInfo ='';
        }
        else if(claim12.NON_GES_Driver_First_Name__c!=null && claim12.NON_GES_Driver_Last_Name__c != null && claim12.Carrier_Claim_No__c == null){
           MotorNONGESInfo=claim12.NON_GES_Driver_Last_Name__c+','+' '+claim12.NON_GES_Driver_First_Name__c;
        }
        else if(claim12.NON_GES_Driver_Last_Name__c == null && claim12.NON_GES_Driver_First_Name__c!=null && claim12.Carrier_Claim_No__c == null){
            MotorNONGESInfo=claim12.NON_GES_Driver_First_Name__c;
        }
       else if(claim12.NON_GES_Driver_Last_Name__c != null && claim12.NON_GES_Driver_First_Name__c==null && claim12.Carrier_Claim_No__c == null){
           MotorNONGESInfo =claim12.NON_GES_Driver_Last_Name__c;
        }
         else if(claim12.NON_GES_Driver_Last_Name__c == null && claim12.NON_GES_Driver_First_Name__c==null && claim12.Carrier_Claim_No__c != null){
           MotorNONGESInfo =claim12.Carrier_Claim_No__c;
        }
        if(MotorNONGESInfo != null || MotorNONGESInfo != ''){
            claim12.NON_GES_Driver_First_Name__c = MotorNONGESInfo;
        }
         
    }
}