@isTest
public class GT_FacilityLookupControllerTest {
    
    static TestMethod void testAllMethods() {
        Account testAcc = getTestFacilityAccount();
        List<Account>accounts = GT_FacilityLookupController.getAccounts('Las Vegas');
        System.assertEquals(1, accounts.size());
        System.assertEquals('Las Vegas',  accounts[0].BillingCity);
    }
    
    static Account getTestFacilityAccount() {
        RecordType facilityRT = [Select Id, SobjectType, Name From RecordType WHERE Name = 'Facility' and SobjectType = 'Account' limit 1];
        Account facility = new Account(
            Name = 'Las Vegas Convention Center',
            Phone = '(702) 892-0711',
            Fax = '555-555-5555',
            BillingStreet = '43150 Paradise Rd.',
            BillingCity = 'Las Vegas',
            BillingState = 'NV' ,
            BillingPostalCode = '89109',
            NumberOfEmployees = 200,
            AnnualRevenue = 20000000,
            RecordTypeId = facilityRT.Id);
        insert facility;
        return facility;
    }
}