global class CA_UpdateFacility implements Database.batchable<sObject>, Database.Stateful{
  global Database.QueryLocator start(Database.BatchableContext BC)
  {
      string query ='SELECT Show_Name__c ,Facility_lk__r.ShippingAddress,Facility_Address__c,Facility_lk__r.ShippingCity,Facility_Address_City__c,Facility_lk__r.ShippingPostalCode,FacilityAddressPostalCode__c,Facility_lk__r.ShippingState,Facility_Address_State__c ,Facility_lk__r.ShippingCountry,Facility_Address_Country__c,Facility_lk__r.ShippingStreet,FacilityAddressStreet__c,Facility_lk__r.BillingCity,Facility_lk__r.BillingCountry,Facility_lk__r.BillingPostalCode,Facility_lk__r.BillingState,Facility_lk__r.BillingStreet,Facility_lk__c FROM GC_Connect2_Show__c where IsUpdated__c=FALSE' ;
      //'Select ID from GC_Connect2_Show__c where Facility_Address_City__c=null AND Facility_lk__c !=NULL';
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<GC_Connect2_Show__c>scope )
   {
        LIST<GC_Connect2_Show__c> lstPS=new LIst<GC_Connect2_Show__c>();
        for( GC_Connect2_Show__c ps:scope){
            
            ps.FacilityAddressPostalCode__c=(String.isEmpty(ps.Facility_lk__r.BillingPostalCode)? (ps.Facility_lk__r.ShippingPostalCode):(ps.Facility_lk__r.BillingPostalCode));
            ps.FacilityAddressStreet__c=(String.isEmpty(ps.Facility_lk__r.BillingStreet)? (ps.Facility_lk__r.ShippingStreet):(ps.Facility_lk__r.BillingStreet));
            ps.Facility_Address_City__c=(String.isEmpty(ps.Facility_lk__r.BillingCity)? (ps.Facility_lk__r.ShippingCity):(ps.Facility_lk__r.BillingCity));
            ps.Facility_Address_Country__c=(String.isEmpty(ps.Facility_lk__r.BillingCountry)? (ps.Facility_lk__r.ShippingCountry):(ps.Facility_lk__r.BillingCountry));
            ps.Facility_Address_State__c=(String.isEmpty(ps.Facility_lk__r.BillingState)? (ps.Facility_lk__r.ShippingState):(ps.Facility_lk__r.BillingState));
            ps.IsUpdated__c=TRUE;
            lstPS.add(ps);
        }
        database.update(lstPS);
   }

   global void finish(Database.BatchableContext BC){

   }

}