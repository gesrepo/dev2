public class pharmaTemplateApexController {

    @AuraEnabled
    public Static ShowWrapper getShowRelated(String sId) {
        GC_Connect2_Show__c show = null;
        ShowWrapper showWrapper = null;
        
        if(!String.isBlank(sId))
            show = [SELECT Name, Opportunity_Id__c FROM GC_Connect2_Show__c WHERE Id = : sId LIMIT 1];
        Opportunity ExhbOpp = [SELECT Show_Name__r.Name, Show_Name__r.Show_ID__c, Facility__c, Facility__r.Name, Facility__r.BillingStreet, Facility__r.BillingCity, Facility__r.BillingState, Facility__r.BillingCountry, Facility__r.BillingPostalCode, Show_Open_Date__c, Show_Close_Date__c FROM Opportunity WHERE Id = : show.Opportunity_Id__c];
        system.debug(ExhbOpp);
        if(ExhbOpp != null) {
            showWrapper = new ShowWrapper(ExhbOpp.Show_Name__r.Name, ExhbOpp.Show_Name__r.Show_ID__c, ExhbOpp.Facility__r.Name, ExhbOpp.Facility__c,ExhbOpp.Facility__r.BillingStreet,ExhbOpp.Facility__r.BillingCity,ExhbOpp.Facility__r.BillingState,ExhbOpp.Facility__r.BillingCountry,ExhbOpp.Facility__r.BillingPostalCode,ExhbOpp.Show_Open_Date__c,ExhbOpp.Show_Close_Date__c);
        	system.debug(showWrapper);
        }
        else
            showWrapper = new ShowWrapper();
        
        return showWrapper;
    }
    
    @AuraEnabled
    public Static FacilityWrapper getFacilityRelated(String fId) {
        Account acc = null;
        FacilityWrapper facilityWrapper = null;
        
        if(!String.isBlank(fId))
            acc = [SELECT Id, Name, BillingCity, BillingPostalCode, BillingCountry, BillingState, ShippingStreet FROM Account WHERE id=:fId LIMIT 1];
        
        if(acc != null) 
            facilityWrapper = new FacilityWrapper(acc.BillingCity, acc.BillingPostalCode, acc.BillingState, acc.ShippingStreet, acc.Name,acc.BillingCountry);
        
        else
            facilityWrapper = new FacilityWrapper();
        
        return facilityWrapper;
    }
    
    public class ShowWrapper {
        @AuraEnabled public String nameOfEvent {get; set;}
        @AuraEnabled public String eventAcronym {get; set;}
        @AuraEnabled public String nameofFacility {get; set;}
        @AuraEnabled public Id     facilityId {get; set;}
        @AuraEnabled public String shippingStreet {get; set;}
        @AuraEnabled public String shippingCity {get; set;}
        @AuraEnabled public String shippingState {get; set;}
        @AuraEnabled public String shippingCountry {get; set;}
        @AuraEnabled public String shippingZip_PostalCode {get; set;}
        @AuraEnabled public Date   StartDate {get; set;}
        @AuraEnabled public Date   EndDate {get; set;}
        
        // r - received
        ShowWrapper (String rnameOfEvent, String reventAcronym, String rnameofFacility, Id rfacilityId, String rshippingStreet, String rshippingCity, String rshippingState, String rshippingCountry, String rshippingZip_PostalCode, Date rshowStartDate, Date rshowEndDate) {
            nameOfEvent = rnameOfEvent;
            eventAcronym = reventAcronym;
            nameofFacility = rnameofFacility;
            facilityId = rfacilityId;
            shippingStreet = rshippingStreet;
            shippingCity = rshippingCity;
            shippingState = rshippingState;
            shippingZip_PostalCode = rshippingZip_PostalCode;
            shippingCountry = rshippingCountry;
            StartDate = rshowStartDate;
            EndDate = rshowEndDate;
        }
        ShowWrapper(){}
    }
     @AuraEnabled
    public static string cloneRecord(GT_Event__c fieldsOfRecordViewForm){
        Id congressId=fieldsOfRecordViewForm.Id;
         List<GT_Event__c> listToInsert=new List<GT_Event__c>();
        upsert fieldsOfRecordViewForm;
        return fieldsOfRecordViewForm.Id;
    }
    @AuraEnabled
    public static GT_Event__c CalendarValuesCongress(string recordId){
        GT_Event__c congress=[select Exhibit_Open_Date__c,Exhibit_Close_Date__c,Proposed_Registration_Site_Launch_Date__c,Registration_Deadline__c,Congress_Cancellation_Date__c,First_Day_Freight__c,
                               Last_Day_Freight__c,Epa3_Closed_Date__c,Targeted_Move_In_Date_Time__c from GT_Event__c where id=:recordId];
        return congress;
    }
    
    @AuraEnabled
    public static string profileNameOfLoggedInUser(){
          Id profileId = userinfo.getProfileId();
        String profileName = [SELECT Id, Name FROM Profile WHERE Id=:profileId].Name;
        return profileName;
    }
    
    public class FacilityWrapper {
        @AuraEnabled public String Billing_City {get; set;}
        @AuraEnabled public String Billing_Postal {get; set;}
        @AuraEnabled public String Billing_State {get; set;}
        @AuraEnabled public String Shipping_Street {get; set;}
        @AuraEnabled public String Facility_Name {get; set;}
        @AuraEnabled public String Billing_Country {get; set;}
  
        FacilityWrapper (String billCity, String billPostal, String billState, String shipStreet, String accName,String billCountry) {
            Billing_City = (billCity == null) ? '' : billCity;
            Billing_Postal = (billPostal == null) ? '' : billPostal;
            Billing_State = (billState == null) ? '' : billState;
            Shipping_Street	= (shipStreet == null) ? '' : shipStreet;
            Facility_Name = (accName == null) ? '' : accName;
            Billing_Country=(billCountry == null) ? '' : billCountry;
        }
        FacilityWrapper(){}
    }

}