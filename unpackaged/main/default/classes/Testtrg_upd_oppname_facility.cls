@isTest
private class Testtrg_upd_oppname_facility {
  
  
    
    static testMethod void myUnitTest() {
    
            
           
      Id FacilityRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Facility').getRecordTypeId();
      Id FirmRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Firm').getRecordTypeId();
      Id SalesRepRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('AV - Master').getRecordTypeId();
                   
      Id profid = Userinfo.getProfileID();
      
      
      //Create Facility Account
      Account Facility = new Account();
      Facility.Name = 'MyTestFacilityName';
      Facility.Type = 'Customer';
      Facility.GES_Status__c = 'None of the above';
      Facility.LMS_Facility_ID__c = 'ICSCCS';
      Facility.BillingStreet = '950 Grier Dr';
      Facility.BillingCity = 'Las Vegas';
      Facility.BillingPostalCode = '89119-0000';
      Facility.BillingState = 'NV';
      Facility.BillingCountry = 'US';
      Facility.RecordTypeId = FacilityRecordTypeId;
              
      Database.insert(Facility);
      Facility.LMS_Facility_ID__c = 'ICSCCS';
      Database.update(Facility);
     
       
                      
      //Create Firm Account
      Account Firm = new Account();
      Firm.Name = 'SONY ENTERTAINMENT INC';
      Firm.Phone = '7022631500';
      Firm.BillingStreet = '950 Grier Dr';
      Firm.BillingCity = 'Las Vegas';
      Firm.BillingPostalCode = '89119-0000';
      Firm.BillingState = 'NV';
      Firm.BillingCountry = 'US';
      Firm.RecordTypeId = FirmRecordTypeId;
      Firm.LMS_Facility_ID__c = 'STISC';
      
      Database.insert(Firm);
      Firm.LMS_Facility_ID__c = 'STISC';
      Database.update(Firm);
            
      //Create Show
      Show__c Show = new Show__c();
      Show.Account__c = Firm.Id;
      Show.Name ='NDEP Central Meeting';
      Show.Show_Type__c = 'Education';
      Show.Show_ID__c = 'NDEPCM';
      
      Database.insert(Show);  
      
       Map<Id, String> facilityNamesMap = new Map<Id, String>();
         if(Firm.LMS_Facility_ID__c != Facility.LMS_Facility_ID__c)
        {
                facilityNamesMap.put(Facility.id, Facility.LMS_Facility_ID__c);
            
        }
    }


         }