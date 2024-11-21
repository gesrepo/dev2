public with sharing class LC_Connect2ShowCreateController {
    
    /* Developed for the ticket - SAL-891
    * Controller for LC_Connect2ShowCreate Lightning Component.
    * Author - Namratha P - Salesforce developer - SLK Software
    *
    * */
    
    // check if opportunity is associated with any other existing shows
    @AuraEnabled 
    public static Boolean isOpportunityUnique(id OpportunityID){
        Boolean unique;
        List<GC_Connect2_Show__c> uniqueOpportunityLookUp = [SELECT Opportunity__c FROM GC_Connect2_Show__c WHERE Opportunity__c=:OpportunityID LIMIT 10];
        if(uniqueOpportunityLookUp.size() > 0) {
             unique = false;
        }
        else if(uniqueOpportunityLookUp.size() == 0){
             unique = true;
        }
       return unique;
    } 
    
    // get Facility Field when Facility is Filled
    @AuraEnabled 
    public static GC_Connect2_Show__c getFacilityAccFields(id facilityID){
         GC_Connect2_Show__c showFacilityFields = new GC_Connect2_Show__c();
       
        list<Account> facilityFieldList = new list<Account>();
        Account FacilityAccFields ;
        facilityFieldList = [SELECT id,LMS_Facility_ID__c,BillingStreet, BillingCity,
                             BillingPostalCode,BillingState,BillingCountry
                             FROM Account WHERE id =: facilityID LIMIT 1];
        
        if(facilityFieldList.size() > 0){
            FacilityAccFields = facilityFieldList[0];
            String facilityAddressStreet =  FacilityAccFields.BillingStreet;
            String facilityAddressCity =  FacilityAccFields.BillingCity;
            String facilityAddressPostalCode =  FacilityAccFields.BillingPostalCode;
            String facilityAddressState =  FacilityAccFields.BillingState;
            String facilityAddressCountry =  FacilityAccFields.BillingCountry;
            String facilityAddress = facilityAddressStreet;
            facilityAddress += '\r\n';
            facilityAddress += String.isNotBlank(facilityAddressCity) ? ' ' + facilityAddressCity + ',' : '';
            facilityAddress += String.isNotBlank(facilityAddressState) ? ' ' + facilityAddressState : '';
            facilityAddress += String.isNotBlank(facilityAddressPostalCode) ? ' ' + facilityAddressPostalCode : '';
            facilityAddress += String.isNotBlank(facilityAddressCountry) ? '\r\n' + facilityAddressCountry : '';
            
            showFacilityFields.Facility_ID__c = FacilityAccFields.LMS_Facility_ID__c;
            showFacilityFields.Facility_Address__c = facilityAddress;
        }
        return showFacilityFields;
    } 
}