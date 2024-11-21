/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestBatchImportOracleCustomerAddress {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        /*  
            Create a Customer first. Address will be inserted or updated for this customer.
            
            NOTE: The status of this record is going to change to Acct: I after the first
            batch process is invoked.
            
            Therefore, this record will allow testing of code line # 160 in the class 
            BatchImportOracleCustomerAddress.
        */
        
        Staging_Oracle_AR_Customer__c Address1 = new Staging_Oracle_AR_Customer__c();
        
        Address1.AR_ADDR_CUST_ACCT_SITE_ID__c = '10000001';
        Address1.AR_CUST_ACCOUNT_ID__c = '10000001';
        Address1.AR_CUSTOMER_NUMBER__c = '6044';
        Address1.AR_CUSTOMER_NAME__c = 'METRA CORP USA NULL POSTAL CODE';
        Address1.AR_CUSTOMER_DUNS_NUMBER__c = 1323804;
        Address1.AR_CUST_CREATION_DATE__c = DateTime.now();
        Address1.AR_CUST_LAST_UPDATE_DATE__c = DateTime.now();
        Address1.AR_CUST_STATUS__c = 'A';
        
        Address1.AR_CUSTOMER_ADDRESS1__c = '950 Grier Dr';
        Address1.AR_CUSTOMER_ADDRESS2__c = 'Suite 10';
        Address1.AR_CUSTOMER_ADDRESS3__c = 'Cube';
        Address1.AR_CUSTOMER_ADDRESS4__c = 'Address 4'; 
        Address1.AR_CUSTOMER_CITY__c = 'Las Vegas';
        Address1.AR_CUSTOMER_STATE__c = 'NV';
        Address1.AR_CUSTOMER_PROVINCE__c = '';
        Address1.AR_CUSTOMER_COUNTRY__c = 'USA';
        Address1.AR_CUSTOMER_POSTAL_CODE__c = '89119-0000';
        
        Address1.AR_ADDR_CUST_SITE_STATUS__c = 'A';
        Address1.AR_ADDR_CUST_SITE_CREATION_DATE__c = DateTime.now();
        Address1.AR_ADDR_CUST_SITE_LAST_UPDATE_DATE__c = DateTime.now();

        Address1.AR_ADDR_PARTY_SITE_LOC_ID__c = 10000000001.0;
        Address1.AR_ADDR_PARTY_SITE_LOC_CREATION_DATE__c = DateTime.now();
        Address1.AR_ADDR_PARTY_SITE_LOC_LAST_UPDATE_DATE__c = DateTime.now();
            
        Address1.AR_ADDR_CUST_SITE_USE_PRIMARY_FLAG__c = 'Y';
        Address1.AR_ADDR_CUST_SITE_USE_STATUS__c = 'A';
        
        Address1.Interface_Status__c = 'New';
        Address1.Interface_Batch_Number__c = '1';
        
        Database.insert(Address1);
        
        BatchImportOracleCustomer BatchCustomer = new BatchImportOracleCustomer();
        
        String custQuery = 'Select s.Interface_Status__c, s.Interface_Process_Attempts__c, s.Interface_Error_Message__c, s.Interface_Batch_Number__c, s.Id, s.AR_CUST_STATUS__c, s.AR_CUST_LAST_UPDATE_DATE__c, s.AR_CUST_CREATION_DATE__c, s.AR_CUST_ACCOUNT_ID__c, s.AR_CUSTOMER_NAME__c, s.AR_CUSTOMER_DUNS_NUMBER__c, s.AR_CUSTOMER_NUMBER__c, s.AR_ADDR_CUST_ACCT_SITE_ID__c, s.AR_ADDR_CUST_SITE_STATUS__c, s.AR_ADDR_CUST_SITE_CREATION_DATE__c, s.AR_ADDR_CUST_SITE_LAST_UPDATE_DATE__c, s.AR_CUSTOMER_ADDRESS1__c, s.AR_CUSTOMER_ADDRESS2__c, s.AR_CUSTOMER_ADDRESS3__c, s.AR_CUSTOMER_ADDRESS4__c, s.AR_CUSTOMER_CITY__c, s.AR_CUSTOMER_STATE__c, s.AR_CUSTOMER_PROVINCE__c, s.AR_CUSTOMER_POSTAL_CODE__c, s.AR_CUSTOMER_COUNTRY__c, s.AR_ADDR_PARTY_SITE_LOC_ID__c, s.AR_ADDR_PARTY_SITE_LOC_CREATION_DATE__c, s.AR_ADDR_PARTY_SITE_LOC_LAST_UPDATE_DATE__c, s.AR_ADDR_CUST_SITE_USE_STATUS__c, s.AR_ADDR_CUST_SITE_USE_PRIMARY_FLAG__c,  s.AR_ADDR_CUST_SITE_USE_CREATION_DATE__c, s.AR_ADDR_CUST_SITE_USE_LAST_UPDATE_DATE__c From Staging_Oracle_AR_Customer__c s Where s.Interface_Status__c = \'New\'';
        BatchCustomer.query = custQuery;
        
        ID CustBatchprocessId = Database.executeBatch(BatchCustomer, 200);
        
        /*
            This data tests successful address insert and in case where the staging
            record has a starting status of New. This depends on customer to exist.
        */
        
        Staging_Oracle_AR_Customer__c Address2 = new Staging_Oracle_AR_Customer__c();
        
        Address2.AR_ADDR_CUST_ACCT_SITE_ID__c = '10000002';
        Address2.AR_CUST_ACCOUNT_ID__c = '10000001';
        Address2.AR_CUSTOMER_NUMBER__c = '6044';
        Address2.AR_CUSTOMER_NAME__c = 'METRA CORP USA NULL POSTAL CODE';
        Address2.AR_CUSTOMER_DUNS_NUMBER__c = 1323804;
        Address2.AR_CUST_CREATION_DATE__c = DateTime.now();
        Address2.AR_CUST_LAST_UPDATE_DATE__c = DateTime.now();
        Address2.AR_CUST_STATUS__c = 'A';
        
        Address2.AR_CUSTOMER_Address1__c = '955 Kelly Johnson Dr';
        Address2.AR_CUSTOMER_Address2__c = 'Suite 1';
        Address2.AR_CUSTOMER_ADDRESS3__c = '';
        Address2.AR_CUSTOMER_ADDRESS4__c = ''; 
        Address2.AR_CUSTOMER_CITY__c = 'Las Vegas';
        Address2.AR_CUSTOMER_STATE__c = 'NV';
        Address2.AR_CUSTOMER_PROVINCE__c = '';
        Address2.AR_CUSTOMER_COUNTRY__c = 'USA';
        Address2.AR_CUSTOMER_POSTAL_CODE__c = '89119';
        
        Address2.AR_ADDR_CUST_SITE_STATUS__c = 'A';
        Address2.AR_ADDR_CUST_SITE_CREATION_DATE__c = DateTime.now();
        Address2.AR_ADDR_CUST_SITE_LAST_UPDATE_DATE__c = DateTime.now();

        Address2.AR_ADDR_PARTY_SITE_LOC_ID__c = 10000000001.0;
        Address2.AR_ADDR_PARTY_SITE_LOC_CREATION_DATE__c = DateTime.now();
        Address2.AR_ADDR_PARTY_SITE_LOC_LAST_UPDATE_DATE__c = DateTime.now();
            
        Address2.AR_ADDR_CUST_SITE_USE_PRIMARY_FLAG__c = 'Y';
        Address2.AR_ADDR_CUST_SITE_USE_STATUS__c = 'A';
        
        Address2.Interface_Status__c = 'New';
        Address2.Interface_Batch_Number__c = '1';
        
        Database.insert(Address2);        
        
        /*  
            This record will cause insert failure because the customer does not exist. 
            
            NOTE: Since, the beginning status of this record is New, another staging record needs to be 
            created with beginning status as something other than new (e.g. Acc: IF), to test the insert 
            failure and get code coverage for the lines which require beginning status to be other than 
            new.
        */        

        Staging_Oracle_AR_Customer__c Address3 = new Staging_Oracle_AR_Customer__c();
        
        Address3.AR_ADDR_CUST_ACCT_SITE_ID__c = '10000003';
        Address3.AR_CUST_ACCOUNT_ID__c = '10000002';
        Address3.AR_CUSTOMER_NUMBER__c = '6044';
        Address3.AR_CUSTOMER_NAME__c = 'METRA CORP USA NULL POSTAL CODE';
        Address3.AR_CUSTOMER_DUNS_NUMBER__c = 1323804;
        Address3.AR_CUST_CREATION_DATE__c = DateTime.now();
        Address3.AR_CUST_LAST_UPDATE_DATE__c = DateTime.now();
        Address3.AR_CUST_STATUS__c = 'A';
        
        Address3.AR_CUSTOMER_Address1__c = '950 Grier Dr';
        Address3.AR_CUSTOMER_ADDRESS2__c = 'Suite 20';
        Address3.AR_CUSTOMER_ADDRESS3__c = 'Cube';
        Address3.AR_CUSTOMER_ADDRESS4__c = 'Address 4'; 
        Address3.AR_CUSTOMER_CITY__c = 'Las Vegas';
        Address3.AR_CUSTOMER_STATE__c = 'NV';
        Address3.AR_CUSTOMER_PROVINCE__c = '';
        Address3.AR_CUSTOMER_COUNTRY__c = 'USA';
        Address3.AR_CUSTOMER_POSTAL_CODE__c = '';
        
        Address3.AR_ADDR_CUST_SITE_STATUS__c = 'A';
        Address3.AR_ADDR_CUST_SITE_CREATION_DATE__c = DateTime.now();
        Address3.AR_ADDR_CUST_SITE_LAST_UPDATE_DATE__c = DateTime.now();

        Address3.AR_ADDR_PARTY_SITE_LOC_ID__c = 10000000001.0;
        Address3.AR_ADDR_PARTY_SITE_LOC_CREATION_DATE__c = DateTime.now();
        Address3.AR_ADDR_PARTY_SITE_LOC_LAST_UPDATE_DATE__c = DateTime.now();
            
        Address3.AR_ADDR_CUST_SITE_USE_PRIMARY_FLAG__c = 'Y';
        Address3.AR_ADDR_CUST_SITE_USE_STATUS__c = 'A';
        
        Address3.Interface_Status__c = 'New';
        Address3.Interface_Batch_Number__c = '1';
        
        Database.insert(Address3);
        
        /*  
            This record will cause insert failure because the customer does not exist. Note that
            status of this record is other than 'New'. See description in the prior step.
        */ 
                
        Staging_Oracle_AR_Customer__c Address4 = new Staging_Oracle_AR_Customer__c();
        
        Address4.AR_ADDR_CUST_ACCT_SITE_ID__c = '10000004';
        Address4.AR_CUST_ACCOUNT_ID__c = '10000002';
        Address4.AR_CUSTOMER_NUMBER__c = '6044';
        Address4.AR_CUSTOMER_NAME__c = 'METRA CORP USA NULL POSTAL CODE';
        Address4.AR_CUSTOMER_DUNS_NUMBER__c = 1323804;
        Address4.AR_CUST_CREATION_DATE__c = DateTime.now();
        Address4.AR_CUST_LAST_UPDATE_DATE__c = DateTime.now();
        Address4.AR_CUST_STATUS__c = 'A';
        
        Address4.AR_CUSTOMER_Address1__c = '950 Grier Dr';
        Address4.AR_CUSTOMER_ADDRESS2__c = 'Suite 20';
        Address4.AR_CUSTOMER_ADDRESS3__c = 'Cube';
        Address4.AR_CUSTOMER_ADDRESS4__c = 'Address 4'; 
        Address4.AR_CUSTOMER_CITY__c = 'Las Vegas';
        Address4.AR_CUSTOMER_STATE__c = 'NV';
        Address4.AR_CUSTOMER_PROVINCE__c = '';
        Address4.AR_CUSTOMER_COUNTRY__c = 'USA';
        Address4.AR_CUSTOMER_POSTAL_CODE__c = '';
        
        Address4.AR_ADDR_CUST_SITE_STATUS__c = 'A';
        Address4.AR_ADDR_CUST_SITE_CREATION_DATE__c = DateTime.now();
        Address4.AR_ADDR_CUST_SITE_LAST_UPDATE_DATE__c = DateTime.now();

        Address4.AR_ADDR_PARTY_SITE_LOC_ID__c = 10000000001.0;
        Address4.AR_ADDR_PARTY_SITE_LOC_CREATION_DATE__c = DateTime.now();
        Address4.AR_ADDR_PARTY_SITE_LOC_LAST_UPDATE_DATE__c = DateTime.now();
            
        Address4.AR_ADDR_CUST_SITE_USE_PRIMARY_FLAG__c = 'Y';
        Address4.AR_ADDR_CUST_SITE_USE_STATUS__c = 'A';
        
        Address4.Interface_Status__c = 'Acc: I';
        Address4.Interface_Batch_Number__c = '1';
        
        Database.insert(Address4);
        
        // Create two duplicate records, so line 45 "LoDuplicateStageAddresses.add(stageAddress);"  in the code will be covered   
        
        Staging_Oracle_AR_Customer__c Address5 = new Staging_Oracle_AR_Customer__c();
        
        Address5.AR_ADDR_CUST_ACCT_SITE_ID__c = '10000005';
        Address5.AR_CUST_ACCOUNT_ID__c = '10000005';
        Address5.AR_CUSTOMER_NUMBER__c = '6044';
        Address5.AR_CUSTOMER_NAME__c = 'METRA CORP USA NULL POSTAL CODE';
        Address5.AR_CUSTOMER_DUNS_NUMBER__c = 1323804;
        Address5.AR_CUST_CREATION_DATE__c = DateTime.now();
        Address5.AR_CUST_LAST_UPDATE_DATE__c = DateTime.now();
        Address5.AR_CUST_STATUS__c = 'A';
        
        Address5.AR_CUSTOMER_Address1__c = '950 Grier Dr';
        Address5.AR_CUSTOMER_ADDRESS2__c = 'Suite 20';
        Address5.AR_CUSTOMER_ADDRESS3__c = 'Cube';
        Address5.AR_CUSTOMER_ADDRESS4__c = 'Address 4'; 
        Address5.AR_CUSTOMER_CITY__c = 'Las Vegas';
        Address5.AR_CUSTOMER_STATE__c = 'NV';
        Address5.AR_CUSTOMER_PROVINCE__c = '';
        Address5.AR_CUSTOMER_COUNTRY__c = 'USA';
        Address5.AR_CUSTOMER_POSTAL_CODE__c = '';
        
        Address5.AR_ADDR_CUST_SITE_STATUS__c = 'A';
        Address5.AR_ADDR_CUST_SITE_CREATION_DATE__c = DateTime.now();
        Address5.AR_ADDR_CUST_SITE_LAST_UPDATE_DATE__c = DateTime.now();

        Address5.AR_ADDR_PARTY_SITE_LOC_ID__c = 10000000001.0;
        Address5.AR_ADDR_PARTY_SITE_LOC_CREATION_DATE__c = DateTime.now();
        Address5.AR_ADDR_PARTY_SITE_LOC_LAST_UPDATE_DATE__c = DateTime.now();
            
        Address5.AR_ADDR_CUST_SITE_USE_PRIMARY_FLAG__c = 'Y';
        Address5.AR_ADDR_CUST_SITE_USE_STATUS__c = 'A';
        
        Address5.Interface_Status__c = 'New';
        Address5.Interface_Batch_Number__c = '1';
        
        Database.insert(Address5); 
        
        Staging_Oracle_AR_Customer__c Address6 = new Staging_Oracle_AR_Customer__c();
        
        Address6.AR_ADDR_CUST_ACCT_SITE_ID__c = '10000005';
        Address6.AR_CUST_ACCOUNT_ID__c = '10000005';
        Address6.AR_CUSTOMER_NUMBER__c = '6044';
        Address6.AR_CUSTOMER_NAME__c = 'METRA CORP USA NULL POSTAL CODE';
        Address6.AR_CUSTOMER_DUNS_NUMBER__c = 1323804;
        Address6.AR_CUST_CREATION_DATE__c = DateTime.now();
        Address6.AR_CUST_LAST_UPDATE_DATE__c = DateTime.now();
        Address6.AR_CUST_STATUS__c = 'A';
        
        Address6.AR_CUSTOMER_Address1__c = '950 Grier Dr';
        Address6.AR_CUSTOMER_ADDRESS2__c = 'Suite 20';
        Address6.AR_CUSTOMER_ADDRESS3__c = 'Cube';
        Address6.AR_CUSTOMER_ADDRESS4__c = 'Address 4'; 
        Address6.AR_CUSTOMER_CITY__c = 'Las Vegas';
        Address6.AR_CUSTOMER_STATE__c = 'NV';
        Address6.AR_CUSTOMER_PROVINCE__c = '';
        Address6.AR_CUSTOMER_COUNTRY__c = 'USA';
        Address6.AR_CUSTOMER_POSTAL_CODE__c = '';
        
        Address6.AR_ADDR_CUST_SITE_STATUS__c = 'A';
        Address6.AR_ADDR_CUST_SITE_CREATION_DATE__c = DateTime.now();
        Address6.AR_ADDR_CUST_SITE_LAST_UPDATE_DATE__c = DateTime.now();

        Address6.AR_ADDR_PARTY_SITE_LOC_ID__c = 10000000001.0;
        Address6.AR_ADDR_PARTY_SITE_LOC_CREATION_DATE__c = DateTime.now();
        Address6.AR_ADDR_PARTY_SITE_LOC_LAST_UPDATE_DATE__c = DateTime.now();
            
        Address6.AR_ADDR_CUST_SITE_USE_PRIMARY_FLAG__c = 'Y';
        Address6.AR_ADDR_CUST_SITE_USE_STATUS__c = 'A';
        
        Address6.Interface_Status__c = 'Acc: I';
        Address6.Interface_Batch_Number__c = '1';
        
        Database.insert(Address6);  
        
        //To get coverage for line 63 "MoCustAcctIdToAccountId.put(acnt.ORACLE_AR_CUST_ACCOUNT_ID__c, acnt.Id);"  update the
        //ORACLE_AR_CUST_ACCOUNT_ID__c to a value used previously in this test case (e.g. 10000005) 180s LLC
        Account ExistingAccount = [Select Id, ORACLE_AR_CUST_ACCOUNT_ID__c From Account Where Id = '0014000000PTzPA'];             
        
        ExistingAccount.ORACLE_AR_CUST_ACCOUNT_ID__c = '10000005';
        Database.update(ExistingAccount);
        
        //To get coverage for lines 81 through 110, create a record in the Oracle_AR_Customer_Address__c object
        Oracle_AR_Customer_Address__c ExistingAddress = new Oracle_AR_Customer_Address__c();
            
        ExistingAddress.Account__c = '0014000000PTzPA';
        ExistingAddress.AR_CUST_ACCT_SITE_ID__c = '10000005';
        ExistingAddress.AR_CUST_SITE_ADDRESS1__c = '950 Kelly Johnson Dr';
        ExistingAddress.AR_CUST_SITE_ADDRESS2__c = 'Suite 100';
        ExistingAddress.AR_CUST_SITE_ADDRESS3__c = '';
        ExistingAddress.AR_CUST_SITE_ADDRESS4__c = '';
        ExistingAddress.AR_CUST_SITE_CITY__c = 'Las Vegas';
        ExistingAddress.AR_CUST_SITE_STATE__c = 'NV';
        ExistingAddress.AR_CUST_SITE_PROVINCE__c = '';
        ExistingAddress.AR_CUST_SITE_COUNTRY__c = 'USA';
        ExistingAddress.AR_CUST_SITE_POSTAL_CODE__c = '89119';
        ExistingAddress.AR_CUST_SITE_STATUS__c = 'A';
        ExistingAddress.AR_CUST_SITE_CREATION_DATE__c = DateTime.now();
        ExistingAddress.AR_CUST_SITE_LAST_UPDATE_DATE__c = DateTime.now();
         
        ExistingAddress.AR_PARTY_SITE_LOC_ID__c = 10000000005.0;
        ExistingAddress.AR_PARTY_SITE_LOC_CREATION_DATE__c = DateTime.now();
        ExistingAddress.AR_PARTY_SITE_LOC_LAST_UPDATE_DATE__c = DateTime.now();
            
        ExistingAddress.AR_PARTY_SITE_USE_PRIMARY_FLAG__c = 'Y';
        ExistingAddress.AR_PARTY_SITE_USE_STATUS__c = 'A';               
        
        Database.insert(ExistingAddress);
        
        test.startTest();
                
        // Test Insert of new customers and insert failures
        BatchImportOracleCustomerAddress BatchCustomerAddress = new BatchImportOracleCustomerAddress();
        
        String query= 'Select s.Interface_Status__c, s.Interface_Process_Attempts__c, s.Interface_Error_Message__c, s.Interface_Batch_Number__c, s.Id, s.AR_CUST_STATUS__c, s.AR_CUST_LAST_UPDATE_DATE__c, s.AR_CUST_CREATION_DATE__c, s.AR_CUST_ACCOUNT_ID__c, s.AR_CUSTOMER_NAME__c, s.AR_CUSTOMER_DUNS_NUMBER__c, s.AR_CUSTOMER_NUMBER__c, s.AR_ADDR_CUST_ACCT_SITE_ID__c, s.AR_ADDR_CUST_SITE_STATUS__c, s.AR_ADDR_CUST_SITE_CREATION_DATE__c, s.AR_ADDR_CUST_SITE_LAST_UPDATE_DATE__c, s.AR_CUSTOMER_ADDRESS1__c, s.AR_CUSTOMER_ADDRESS2__c, s.AR_CUSTOMER_ADDRESS3__c, s.AR_CUSTOMER_ADDRESS4__c, s.AR_CUSTOMER_CITY__c, s.AR_CUSTOMER_STATE__c, s.AR_CUSTOMER_PROVINCE__c, s.AR_CUSTOMER_POSTAL_CODE__c, s.AR_CUSTOMER_COUNTRY__c, s.AR_ADDR_PARTY_SITE_LOC_ID__c, s.AR_ADDR_PARTY_SITE_LOC_CREATION_DATE__c, s.AR_ADDR_PARTY_SITE_LOC_LAST_UPDATE_DATE__c, s.AR_ADDR_CUST_SITE_USE_STATUS__c, s.AR_ADDR_CUST_SITE_USE_PRIMARY_FLAG__c,  s.AR_ADDR_CUST_SITE_USE_CREATION_DATE__c, s.AR_ADDR_CUST_SITE_USE_LAST_UPDATE_DATE__c From Staging_Oracle_AR_Customer__c s Where s.Interface_Status__c In (\'Acc: U\', \'Acc: I\', \'New\') Limit 200';
        BatchCustomerAddress.query = query;
        
        ID BatchprocessId = Database.executeBatch(BatchCustomerAddress, 200);
        
        //TODO: Can't think of a way to test update failure.
        test.stopTest();
        
        //System.abortJob(BatchprocessId);
        
    }
}