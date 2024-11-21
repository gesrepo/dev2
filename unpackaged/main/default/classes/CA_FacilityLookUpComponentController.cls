public class CA_FacilityLookUpComponentController {
    
    @AuraEnabled
    public static List<Account> getAccounts(string searchText) {
        string query = 'SELECT Id, Name, BillingCity, BillingPostalCode, BillingCountry, BillingState, ShippingStreet,shippingCountry,shippingPostalCode,shippingState,shippingCity FROM Account ';
        if( String.isNotBlank(searchText)){
            query += 'WHERE Name LIKE \'%'+ searchText + '%\'';
        }
        query +=' AND RecordType.Name= \'Facility\'';
        query += ' LIMIT 50';
        List<Account> accs = Database.Query(query);
        return accs;
    }
    
    @AuraEnabled
    public static List<GC_Connect2_Show__c> getProjectCentralShows(string searchText) {
        string query = 'SELECT Id, Name, Show_Name__c, Show_ID__c, Show_Start_Date__c, Show_End_Date__c,Registration_Location__c, Facility__c, Facility_Address__c, Show_Website__c,Facility_lk__r.Name,Facility_Address_City__c,Facility_Address_Country__c,FacilityAddressPostalCode__c,Facility_Address_State__c,FacilityAddressStreet__c  FROM GC_Connect2_Show__c ';
        if( String.isNotBlank(searchText)){
            query += 'WHERE Show_Name__c LIKE \'%'+ searchText + '%\' OR Show_ID__c LIKE \'%'+ searchText + '%\'';
        }
        //query +=' AND RecordType.Name= \'Facility\'';
        query += ' LIMIT 50';
        List<GC_Connect2_Show__c> pCShows = Database.Query(query);
        system.debug('pCShows'+pCShows);
        system.debug('pCShows size'+pCShows.size());
        return pCShows;
    }
}