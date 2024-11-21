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
private class TestBatchImportOracleCustomer {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
                              
        //Retrieve User (for Owner)
        ID OwnerId = UserInfo.getUserId();

        /*
            Create a stage customer located in US (or USA) to test the insert logic i.e. customer 
            does not already exist in the database. 
            
            Also, to begin with, have the Postal Code field NULL, so that the else portion of 
            the logic based on this field is executed.
        */
        
        Staging_Oracle_AR_Customer__c GoodStgCustUSNullZip = new Staging_Oracle_AR_Customer__c();
        
        GoodStgCustUSNullZip.AR_CUST_ACCOUNT_ID__c = '10000000001';
        GoodStgCustUSNullZip.AR_CUSTOMER_NUMBER__c = '6044';
        GoodStgCustUSNullZip.AR_CUSTOMER_NAME__c = 'METRA CORP USA NULL POSTAL CODE';
        GoodStgCustUSNullZip.AR_CUSTOMER_DUNS_NUMBER__c = 1323804;
        GoodStgCustUSNullZip.AR_CUST_CREATION_DATE__c = DateTime.now();
        GoodStgCustUSNullZip.AR_CUST_LAST_UPDATE_DATE__c = DateTime.now();
        GoodStgCustUSNullZip.AR_CUST_STATUS__c = 'a';
        
        GoodStgCustUSNullZip.AR_CUSTOMER_ADDRESS1__c = '950 Grier Dr';
        GoodStgCustUSNullZip.AR_CUSTOMER_ADDRESS2__c = 'Suite 10';
        GoodStgCustUSNullZip.AR_CUSTOMER_ADDRESS3__c = 'Cube';
        GoodStgCustUSNullZip.AR_CUSTOMER_ADDRESS4__c = 'Address 4'; 
        GoodStgCustUSNullZip.AR_CUSTOMER_CITY__c = 'Las Vegas';
        GoodStgCustUSNullZip.AR_CUSTOMER_STATE__c = 'NV';
        GoodStgCustUSNullZip.AR_CUSTOMER_COUNTRY__c = 'USA';
        
        GoodStgCustUSNullZip.Interface_Status__c = 'New';
        GoodStgCustUSNullZip.Interface_Batch_Number__c = '1';
        
        Database.insert(GoodStgCustUSNullZip);
                
        /*
            Create a stage customer located in US (or USA) to test the insert logic i.e. customer 
            does not already exist in the database. In this case test for Blank Postal Code (instead
            of NULL).
            
            Initialize Postal Code field to Blank, so that the else portion of the logic based on 
            this field is executed.
        */
        
        Staging_Oracle_AR_Customer__c GoodStgCustUSBlankZip = new Staging_Oracle_AR_Customer__c();
        
        GoodStgCustUSBlankZip.AR_CUST_ACCOUNT_ID__c = '10000000002';
        GoodStgCustUSBlankZip.AR_CUSTOMER_NUMBER__c = '6046';
        GoodStgCustUSBlankZip.AR_CUSTOMER_NAME__c = 'METRA CORP USA BLANK POSTAL CODE';
        GoodStgCustUSBlankZip.AR_CUSTOMER_DUNS_NUMBER__c = 1323806;
        GoodStgCustUSBlankZip.AR_CUST_CREATION_DATE__c = DateTime.now();
        GoodStgCustUSBlankZip.AR_CUST_LAST_UPDATE_DATE__c = DateTime.now();
        GoodStgCustUSBlankZip.AR_CUST_STATUS__c = 'a';
        
        GoodStgCustUSBlankZip.AR_CUSTOMER_ADDRESS1__c = '950 Grier Dr';
        GoodStgCustUSBlankZip.AR_CUSTOMER_ADDRESS2__c = 'Suite 10';
        GoodStgCustUSBlankZip.AR_CUSTOMER_ADDRESS3__c = 'Cube';
        GoodStgCustUSBlankZip.AR_CUSTOMER_ADDRESS4__c = 'Address 4'; 
        GoodStgCustUSBlankZip.AR_CUSTOMER_CITY__c = 'Las Vegas';
        GoodStgCustUSBlankZip.AR_CUSTOMER_STATE__c = 'NV';
        GoodStgCustUSBlankZip.AR_CUSTOMER_COUNTRY__c = 'US';
        GoodStgCustUSBlankZip.AR_CUSTOMER_POSTAL_CODE__c = '';
        
        GoodStgCustUSBlankZip.Interface_Status__c = 'New';
        GoodStgCustUSBlankZip.Interface_Batch_Number__c = '1';
        
        Database.insert(GoodStgCustUSBlankZip);
        
        /*
            Create a stage customer address outside US (or USA) to test the insert logic i.e. customer 
            does not already exist in the database. In this case test for NULL Postal Code.
            
            Initialize Postal Code field to NULL, so that the else portion of the logic based on 
            this field is executed. 
            
            NOTE: For Non-USA customers, Null and Blank are processed in the same way.
        */

        Staging_Oracle_AR_Customer__c GoodStgCustForeignNullZip = new Staging_Oracle_AR_Customer__c();
        
        GoodStgCustForeignNullZip.AR_CUST_ACCOUNT_ID__c = '10000000004';
        GoodStgCustForeignNullZip.AR_CUSTOMER_NUMBER__c = '6046';
        GoodStgCustForeignNullZip.AR_CUSTOMER_NAME__c = 'METRA CORP NON USA BLANK POSTAL CODE';
        GoodStgCustForeignNullZip.AR_CUSTOMER_DUNS_NUMBER__c = 1323806;
        GoodStgCustForeignNullZip.AR_CUST_CREATION_DATE__c = DateTime.now();
        GoodStgCustForeignNullZip.AR_CUST_LAST_UPDATE_DATE__c = DateTime.now();
        GoodStgCustForeignNullZip.AR_CUST_STATUS__c = 'a';
        
        GoodStgCustForeignNullZip.AR_CUSTOMER_ADDRESS1__c = '950 Grier Dr';
        GoodStgCustForeignNullZip.AR_CUSTOMER_ADDRESS2__c = 'Suite 10';
        GoodStgCustForeignNullZip.AR_CUSTOMER_ADDRESS3__c = 'Cube';
        GoodStgCustForeignNullZip.AR_CUSTOMER_ADDRESS4__c = 'Address 4'; 
        GoodStgCustForeignNullZip.AR_CUSTOMER_CITY__c = 'Las Vegas';
        GoodStgCustForeignNullZip.AR_CUSTOMER_STATE__c = 'NV';
        GoodStgCustForeignNullZip.AR_CUSTOMER_COUNTRY__c = 'Canada';
        
        GoodStgCustForeignNullZip.Interface_Status__c = 'New';
        GoodStgCustForeignNullZip.Interface_Batch_Number__c = '1';
        
        Database.insert(GoodStgCustForeignNullZip);        
        
        /*
            Create a stage customer located in US (or USA) to test the update logic i.e. customer 
            must already exist as a Salesforce.com Account.
                    
            This tests the code block on postal code else portion on billincountry check for existing
            account.
            
            TODO: This customer must exist for the unit test to get code coverage.  Therefore,
            prior to deploying this code, create a customer in production Org or update
            the AR_CUST_ACCOUNT_ID__c field of any customer to this value in production org.
            
            Alternative, change the line (marked below) to a value of customer id that exists
            in production org.          
        */

        Staging_Oracle_AR_Customer__c GoodExistingStgCustForeignNullZip = new Staging_Oracle_AR_Customer__c();
        
        GoodExistingStgCustForeignNullZip.AR_CUST_ACCOUNT_ID__c = '314087';
        GoodExistingStgCustForeignNullZip.AR_CUSTOMER_NUMBER__c = '6045';
        GoodExistingStgCustForeignNullZip.AR_CUSTOMER_NAME__c = 'METRA CORP NON USA NULL POSTAL CODE';
        GoodExistingStgCustForeignNullZip.AR_CUSTOMER_DUNS_NUMBER__c = 1323805;
        GoodExistingStgCustForeignNullZip.AR_CUST_CREATION_DATE__c = DateTime.now();
        GoodExistingStgCustForeignNullZip.AR_CUST_LAST_UPDATE_DATE__c = DateTime.now();
        GoodExistingStgCustForeignNullZip.AR_CUST_STATUS__c = 'a';
        
        GoodExistingStgCustForeignNullZip.AR_CUSTOMER_ADDRESS1__c = '950 Grier Dr';
        GoodExistingStgCustForeignNullZip.AR_CUSTOMER_ADDRESS2__c = 'Suite 10';
        GoodExistingStgCustForeignNullZip.AR_CUSTOMER_ADDRESS3__c = 'Cube';
        GoodExistingStgCustForeignNullZip.AR_CUSTOMER_ADDRESS4__c = 'Address 4'; 
        GoodExistingStgCustForeignNullZip.AR_CUSTOMER_CITY__c = 'Las Vegas';
        GoodExistingStgCustForeignNullZip.AR_CUSTOMER_STATE__c = 'NV';
        GoodExistingStgCustForeignNullZip.AR_CUSTOMER_COUNTRY__c = 'Canada';
        
        GoodExistingStgCustForeignNullZip.Interface_Status__c = 'New';
        GoodExistingStgCustForeignNullZip.Interface_Batch_Number__c = '1';
        
        Database.insert(GoodExistingStgCustForeignNullZip);        

        /*
            Create a stage customer located in US (or USA) to test the update logic i.e. customer 
            must already exist as a Salesforce.com Account.
            
            This tests the code block on postal code if portion on billincountry check for existing
            account.            
                                    
            TODO: This customer must exist for the unit test to get code coverage.  Therefore,
            prior to deploying this code, create a customer in production Org or update
            the AR_CUST_ACCOUNT_ID__c field of any customer to this value in production org.
            
            Alternative, change the line (marked below) to a value of customer id that exists
            in production org.
        */
        
        Staging_Oracle_AR_Customer__c GoodExistingStgCustUS = new Staging_Oracle_AR_Customer__c();
        
        GoodExistingStgCustUS.AR_CUST_ACCOUNT_ID__c = '8264'; //Update this value to that of an existing customer
        GoodExistingStgCustUS.AR_CUSTOMER_NUMBER__c = '6047';
        GoodExistingStgCustUS.AR_CUSTOMER_NAME__c = 'ABC';
        GoodExistingStgCustUS.AR_CUSTOMER_DUNS_NUMBER__c = 1323807;
        GoodExistingStgCustUS.AR_CUST_CREATION_DATE__c = DateTime.now();
        GoodExistingStgCustUS.AR_CUST_LAST_UPDATE_DATE__c = DateTime.now();
        GoodExistingStgCustUS.AR_CUST_STATUS__c = 'a';
        
        GoodExistingStgCustUS.AR_CUSTOMER_ADDRESS1__c = '950 Grier Dr';
        GoodExistingStgCustUS.AR_CUSTOMER_ADDRESS2__c = 'Suite 10';
        GoodExistingStgCustUS.AR_CUSTOMER_ADDRESS3__c = 'Cube';
        GoodExistingStgCustUS.AR_CUSTOMER_ADDRESS4__c = 'Address 4'; 
        GoodExistingStgCustUS.AR_CUSTOMER_CITY__c = 'Las Vegas';
        GoodExistingStgCustUS.AR_CUSTOMER_STATE__c = 'NV';
        
        GoodExistingStgCustUS.AR_CUSTOMER_COUNTRY__c = 'USA';
        GoodExistingStgCustUS.AR_CUSTOMER_POSTAL_CODE__c = '89119';
        
        GoodExistingStgCustUS.Interface_Status__c = 'New';
        GoodExistingStgCustUS.Interface_Batch_Number__c = '1';
        
        Database.insert(GoodExistingStgCustUS); 

        test.startTest();
                
        // Test Insert of new customers and insert failures
        BatchImportOracleCustomer BatchCustomer = new BatchImportOracleCustomer();
        
        String query = 'Select s.Interface_Status__c, s.Interface_Process_Attempts__c, s.Interface_Error_Message__c, s.Interface_Batch_Number__c, s.Id, s.AR_CUST_STATUS__c, s.AR_CUST_LAST_UPDATE_DATE__c, s.AR_CUST_CREATION_DATE__c, s.AR_CUST_ACCOUNT_ID__c, s.AR_CUSTOMER_NAME__c, s.AR_CUSTOMER_DUNS_NUMBER__c, s.AR_CUSTOMER_NUMBER__c, s.AR_ADDR_CUST_ACCT_SITE_ID__c, s.AR_ADDR_CUST_SITE_STATUS__c, s.AR_ADDR_CUST_SITE_CREATION_DATE__c, s.AR_ADDR_CUST_SITE_LAST_UPDATE_DATE__c, s.AR_CUSTOMER_ADDRESS1__c, s.AR_CUSTOMER_ADDRESS2__c, s.AR_CUSTOMER_ADDRESS3__c, s.AR_CUSTOMER_ADDRESS4__c, s.AR_CUSTOMER_CITY__c, s.AR_CUSTOMER_STATE__c, s.AR_CUSTOMER_PROVINCE__c, s.AR_CUSTOMER_POSTAL_CODE__c, s.AR_CUSTOMER_COUNTRY__c, s.AR_ADDR_PARTY_SITE_LOC_ID__c, s.AR_ADDR_PARTY_SITE_LOC_CREATION_DATE__c, s.AR_ADDR_PARTY_SITE_LOC_LAST_UPDATE_DATE__c, s.AR_ADDR_CUST_SITE_USE_STATUS__c, s.AR_ADDR_CUST_SITE_USE_PRIMARY_FLAG__c,  s.AR_ADDR_CUST_SITE_USE_CREATION_DATE__c, s.AR_ADDR_CUST_SITE_USE_LAST_UPDATE_DATE__c From Staging_Oracle_AR_Customer__c s Where s.Interface_Status__c = \'New\' Limit 200';
        BatchCustomer.query = query;
        
        ID BatchprocessId = Database.executeBatch(BatchCustomer, 200);
               
        // Test Update of existing US and Non US customer with null postal code
        GoodStgCustUSNullZip.Interface_Status__c = 'New';
        GoodStgCustUSNullZip.AR_CUSTOMER_NAME__c = 'METRA CORP USA NULL POSTAL CODE - UPDATED';
        Database.update(GoodStgCustUSNullZip);
        
        BatchprocessId = Database.executeBatch(BatchCustomer, 200);
        
        test.stopTest();
        
        System.abortJob(BatchprocessId);
                                  
    }
    
     static testMethod void myUnitTest1() {
        // TO DO: implement unit test
                              
        //Retrieve User (for Owner)
        ID OwnerId = UserInfo.getUserId();

        /*
            Create a stage customer located in US (or USA) to test the insert logic i.e. customer 
            does not already exist in the database. 
            
            Also, to begin with, have the Postal Code field NULL, so that the else portion of 
            the logic based on this field is executed.
        */
        
        
        
        
        Account acc= new Account();
        acc.name='Test Account';
        acc.ORACLE_AR_CUST_ACCOUNT_ID__c= '10000000001';
        acc.billingcountry='US';
        acc.BillingState='NewYork';
        acc.BillingPostalCode='201010';
        
        Database.insert(acc);
        
        Staging_Oracle_AR_Customer__c GoodStgCustUSNullZip = new Staging_Oracle_AR_Customer__c();
        
        GoodStgCustUSNullZip.AR_CUST_ACCOUNT_ID__c = '10000000001';
        GoodStgCustUSNullZip.AR_CUSTOMER_NUMBER__c = '6044';
        GoodStgCustUSNullZip.AR_CUSTOMER_NAME__c = 'METRA CORP USA NULL POSTAL CODE';
        GoodStgCustUSNullZip.AR_CUSTOMER_DUNS_NUMBER__c = 1323804;
        GoodStgCustUSNullZip.AR_CUST_CREATION_DATE__c = DateTime.now();
        GoodStgCustUSNullZip.AR_CUST_LAST_UPDATE_DATE__c = DateTime.now();
        GoodStgCustUSNullZip.AR_CUST_STATUS__c = 'a';
        
        GoodStgCustUSNullZip.AR_CUSTOMER_ADDRESS1__c = '950 Grier Dr';
        GoodStgCustUSNullZip.AR_CUSTOMER_ADDRESS2__c = 'Suite 10';
        GoodStgCustUSNullZip.AR_CUSTOMER_ADDRESS3__c = 'Cube';
        GoodStgCustUSNullZip.AR_CUSTOMER_ADDRESS4__c = 'Address 4'; 
        GoodStgCustUSNullZip.AR_CUSTOMER_CITY__c = 'Las Vegas';
        GoodStgCustUSNullZip.AR_CUSTOMER_STATE__c = 'NV';
        GoodStgCustUSNullZip.AR_CUSTOMER_COUNTRY__c = 'USA';
        
        GoodStgCustUSNullZip.Interface_Status__c = 'New';
        GoodStgCustUSNullZip.Interface_Batch_Number__c = '1';
        
        Database.insert(GoodStgCustUSNullZip);
        
        
         AR_Customer_Info__c arinfo = new AR_Customer_Info__c();
         arinfo.Name='Test Info';
         arinfo.Oracle_AR_Customer_ID__c='10000000001';
         arinfo.Account__c=acc.id;
         Database.insert(arinfo); 
         
        test.startTest();
                
        // Test Insert of new customers and insert failures
        BatchImportOracleCustomer BatchCustomer = new BatchImportOracleCustomer();
        
        String query = 'Select s.Interface_Status__c, s.Interface_Process_Attempts__c, s.Interface_Error_Message__c, s.Interface_Batch_Number__c, s.Id, s.AR_CUST_STATUS__c, s.AR_CUST_LAST_UPDATE_DATE__c, s.AR_CUST_CREATION_DATE__c, s.AR_CUST_ACCOUNT_ID__c, s.AR_CUSTOMER_NAME__c, s.AR_CUSTOMER_DUNS_NUMBER__c, s.AR_CUSTOMER_NUMBER__c, s.AR_ADDR_CUST_ACCT_SITE_ID__c, s.AR_ADDR_CUST_SITE_STATUS__c, s.AR_ADDR_CUST_SITE_CREATION_DATE__c, s.AR_ADDR_CUST_SITE_LAST_UPDATE_DATE__c, s.AR_CUSTOMER_ADDRESS1__c, s.AR_CUSTOMER_ADDRESS2__c, s.AR_CUSTOMER_ADDRESS3__c, s.AR_CUSTOMER_ADDRESS4__c, s.AR_CUSTOMER_CITY__c, s.AR_CUSTOMER_STATE__c, s.AR_CUSTOMER_PROVINCE__c, s.AR_CUSTOMER_POSTAL_CODE__c, s.AR_CUSTOMER_COUNTRY__c, s.AR_ADDR_PARTY_SITE_LOC_ID__c, s.AR_ADDR_PARTY_SITE_LOC_CREATION_DATE__c, s.AR_ADDR_PARTY_SITE_LOC_LAST_UPDATE_DATE__c, s.AR_ADDR_CUST_SITE_USE_STATUS__c, s.AR_ADDR_CUST_SITE_USE_PRIMARY_FLAG__c,  s.AR_ADDR_CUST_SITE_USE_CREATION_DATE__c, s.AR_ADDR_CUST_SITE_USE_LAST_UPDATE_DATE__c From Staging_Oracle_AR_Customer__c s Where s.Interface_Status__c = \'New\' Limit 200';
        BatchCustomer.query = query;
        
        ID BatchprocessId = Database.executeBatch(BatchCustomer, 200);
               
        // Test Update of existing US and Non US customer with null postal code
        GoodStgCustUSNullZip.Interface_Status__c = 'New';
        GoodStgCustUSNullZip.AR_CUSTOMER_NAME__c = 'METRA CORP USA NULL POSTAL CODE - UPDATED';
        Database.update(GoodStgCustUSNullZip);
        
        BatchprocessId = Database.executeBatch(BatchCustomer, 200);
        
        test.stopTest();
        
        System.abortJob(BatchprocessId);
                                  
    }

}