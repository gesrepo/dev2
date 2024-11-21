public class GT_FacilityLookupController {

    @AuraEnabled
    public static List<Account> getAccounts(string searchText) {
        string query = 'SELECT Id, Name, BillingCity, BillingPostalCode, BillingCountry, BillingState, ShippingStreet FROM Account ';
        if( String.isNotBlank(searchText)){
            query += 'WHERE Name LIKE \'%'+ searchText + '%\'';
        }
         query += 'AND recordtype.name = \'facility\' LIMIT 50';
        List<Account> accs = Database.Query(query);
        return accs;
    }
}