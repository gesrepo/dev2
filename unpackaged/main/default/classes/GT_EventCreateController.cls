public with sharing class GT_EventCreateController {
    
    @AuraEnabled
    public Static String getProfileName(){
        id userId = userinfo.getProfileId();
        LIST<profile> ProfileName = new LIST<profile>();
		ProfileName = [select Name from profile where id = :userId LIMIT 1];
        system.debug(ProfileName[0].Name);
        Return ProfileName[0].Name;
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