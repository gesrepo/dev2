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
private class TestBatchPurgeOracleStagingObjects {

     public class SalesforceUpsertOrganisationMokup implements WebServiceMock {
        String sfID;
        public SalesforceUpsertOrganisationMokup(String SalesforceID) {
            sfID = SalesforceID;
        }

        public void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {

        SOP_VIAD_V2.SalesforceUpsertOrganisationResult suor = new SOP_VIAD_V2.SalesforceUpsertOrganisationResult();
        suor.EUSopID = 43621;
        suor.MESopID = 23231;
        suor.SalesforceID = this.sfID;
        suor.UKSopID = 23212;
        SOP_VIAD_V2.SalesforceUpsertOrganisationResponse_element respElement = new SOP_VIAD_V2.SalesforceUpsertOrganisationResponse_element();
        respElement.SalesforceUpsertOrganisationResult = suor;
        response.put('response_x', respElement); 
        }
    }

    static testMethod void myUnitTest() {

        //Retrieve User (for Owner)
        ID OwnerId = UserInfo.getUserId();

        /* Start Test Data for Staging Customer */
        
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
        
        /* End Test Data for Staging Customer */
        
        /* Start Test Data for Staging Show Booth */
        // Retrieve the Salesforce Id for Sales Rep
        Id SalesRepId = UserInfo.getUserId();
        
        //Determine RecordTypeId of "Sales Rep Show Occurrence" Opportunity record type.
        RecordType RTOpp = [Select Id From RecordType Where SObjectType = 'Opportunity' And Name = 'Sales Rep Show Occurrence'];
        Id SalesRepShowOccRecordTypeId = RTOpp.Id;
        
        //Determine RecordTypeId of "Facility" Account record type.
        RecordType RTAccFac = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Facility'];
        Id FacilityRecordTypeId = RTAccFac.Id;
        
        //Determine RecordTypeId of "Firm" Account record type.
        RecordType RTAccFirm = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Firm'];
        Id FirmRecordTypeId = RTAccFirm.Id;         
         
        // First create Facility
        Account Facility = new Account();
        Facility.Sales_Person__c = SalesRepId;
        Facility.Name = 'MyTestFacilityName';
        Facility.Type = 'Hotel';
        Facility.GES_Status__c = 'Preferred';
        Facility.LMS_Facility_ID__c = 'ABCFAC';
        Facility.BillingStreet = '950 Grier Dr';
        Facility.BillingCity = 'Las Vegas';
        Facility.BillingPostalCode = '89119-0000';
        Facility.BillingState = 'Nevada';
        Facility.BillingCountry = 'US';
        Facility.RecordTypeId = FacilityRecordTypeId;
        database.insert(Facility);  

        Test.setMock(WebServiceMock.class, new SalesforceUpsertOrganisationMokup(Facility.id));
        
        //Create Account of Record Type "Firm"
        Account Firm = new Account();
        Firm.ORACLE_AR_CUST_ACCOUNT_ID__c = '10000001';
        Firm.Sales_Person__c = SalesRepId;
        Firm.Name = 'MyTestExhibitorName';
        Firm.Phone = '7022631500';
        Firm.BillingStreet = '950 Grier Dr';
        Firm.BillingCity = 'Las Vegas';
        Firm.BillingPostalCode = '89119-0000';
        Firm.BillingState = 'Nevada';
        Firm.BillingCountry = 'US';
        Firm.RecordTypeId = FirmRecordTypeId;
        database.insert(Firm);
        
        //Create Show
        Show__c Show = new Show__c();
        Show.Sales_Person__c = SalesRepId;
        Show.Account__c = Firm.Id;
        Show.Name ='MyTestShow001';
        Show.Show_Type__c = 'Food Sector';
        Show.Show_ID__c = '123456';
        database.insert(Show);
        
        //Then create Show Occurrence
        Opportunity Opp1 = new Opportunity();
       
        Opp1.Job_Number__c = '20121231';
        Opp1.OwnerId = OwnerId;
        Opp1.Sales_Person__c = SalesRepId;
        Opp1.Sales_Location__c = '110- Las Vegas';
        Opp1.Name = 'MyTestShow # 1';
        Opp1.Prime_Contractor__c = null;
        Opp1.Production_Location__c = '110- Las Vegas';
        Opp1.Facility__c = Facility.Id;
        Opp1.StageName = 'SL1';
        Opp1.Amount = 1000;
        Opp1.Probability = 25;
        Opp1.Type = 'ITYFTY';
        Opp1.New_Repeat__c = 'New';
        Opp1.Frequency__c = 'B1';
        Opp1.AccountId = Firm.Id;
        Opp1.Show_Name__c = Show.Id;
        Opp1.RecordTypeId = SalesRepShowOccRecordTypeId;
        
        Opp1.Show_Open_Date__c = Date.newInstance(2012,12,1);
        Opp1.Show_Close_Date__c = Date.newInstance(2012,12,2);
        Opp1.CloseDate = Date.newInstance(2012,12,2);
        
        Database.insert(Opp1);
        
        //Then create Booth
        Staging_Oracle_Show_Booth__c StageBooth1 = new Staging_Oracle_Show_Booth__c();
        
        StageBooth1.CUST_ACCOUNT_ID__c = Firm.ORACLE_AR_CUST_ACCOUNT_ID__c;
        StageBooth1.PROJECT_NUMBER__c = Opp1.Job_Number__c; 
        StageBooth1.BOOTH_ID__c = '1000001';
        StageBooth1.BOOTH_CREATION_DATE__c = DateTime.now();
        StageBooth1.BOOTH_LAST_UPDATE_DATE__c = DateTime.now();
        StageBooth1.BOOTH_LENGTH__c = 10;
        StageBooth1.BOOTH_NUMBER__c = '100';
        StageBooth1.BOOTH_SHARED_FLAG__c = 'Y';
        StageBooth1.BOOTH_SIZE__c = 100;
        StageBooth1.BOOTH_TYPE__c = 'Inline';
        StageBooth1.BOOTH_WIDTH__c = 10;
        StageBooth1.ED_FLAG__c = 'Y';
        StageBooth1.INACTIVE_FLAG__c = 'N';
        StageBooth1.SHOW_ID__c = 'CES';
        StageBooth1.THIRD_PARTY_FLAG__c = 'Y';
        StageBooth1.SHOW_ORG_FLAG__c = 'Y';
        
        StageBooth1.Interface_Status__c = 'New';
        StageBooth1.Interface_Batch_Number__c = '1';
        
        Database.insert(StageBooth1);
        
        //Then create Booth to test failed insert. Note here Project Number is not valid
        //i.e. it does not exist and Booth ID is different from that created before.
        Staging_Oracle_Show_Booth__c StageBooth2 = new Staging_Oracle_Show_Booth__c();
        
        StageBooth2.CUST_ACCOUNT_ID__c = Firm.ORACLE_AR_CUST_ACCOUNT_ID__c;
        StageBooth2.PROJECT_NUMBER__c = '100000'; 
        StageBooth2.BOOTH_ID__c = '1000002';
        StageBooth2.BOOTH_CREATION_DATE__c = DateTime.now();
        StageBooth2.BOOTH_LAST_UPDATE_DATE__c = DateTime.now();
        StageBooth2.BOOTH_LENGTH__c = 10;
        StageBooth2.BOOTH_NUMBER__c = '100';
        StageBooth2.BOOTH_SHARED_FLAG__c = 'Y';
        StageBooth2.BOOTH_SIZE__c = 100;
        StageBooth2.BOOTH_TYPE__c = 'Inline';
        StageBooth2.BOOTH_WIDTH__c = 10;
        StageBooth2.ED_FLAG__c = 'Y';
        StageBooth2.INACTIVE_FLAG__c = 'N';
        StageBooth2.SHOW_ID__c = 'CES';
        StageBooth2.THIRD_PARTY_FLAG__c = 'Y';
        StageBooth2.SHOW_ORG_FLAG__c = 'Y';
        
        StageBooth2.Interface_Status__c = 'New';
        StageBooth2.Interface_Batch_Number__c = '1';
        
        Database.insert(StageBooth2);
        
        /* End Test Data for Staging Show Booth */        
        
        /* Start Test Data for Staging Show Booth Contact */
                
        Oracle_Show_Booth__c Booth = new  Oracle_Show_Booth__c();
        
        Booth.Account__c = Firm.Id;
        Booth.Show_Occurrence__c = Opp1.Id;        
        Booth.BOOTH_CREATION_DATE__c = DateTime.now();
        Booth.BOOTH_LAST_UPDATE_DATE__c = DateTime.now();
        Booth.BOOTH_LENGTH__c = 10;
        Booth.BOOTH_NUMBER__c = '10001';
        Booth.BOOTH_SHARED_FLAG__c = 'N';
        Booth.BOOTH_SIZE__c = 100;
        Booth.BOOTH_TYPE__c = 'INLINE';
        Booth.BOOTH_WIDTH__c = 10;
        Booth.CUST_ACCOUNT_ID__c = '100001';
        Booth.BOOTH_ID__c = '1000001';
        Booth.ED_FLAG__c = false;
        Booth.INACTIVE_FLAG__c = false;            
        Booth.PROJECT_NUMBER__c = Opp1.Job_Number__c;
        Booth.SHOW_ID__c = Show.Show_ID__c;
        Booth.THIRD_PARTY_FLAG__c = false;
        Booth.SHOW_ORG_FLAG__c =  false;        
        Database.insert(Booth);      
        
        // Check successful insert
        Staging_Oracle_Show_Booth_Contact__c StgBoothContact1 = new  Staging_Oracle_Show_Booth_Contact__c();
        
        StgBoothContact1.AREA_CODE__c = 702;
        StgBoothContact1.CONTACT_ROLE__c = 'ROLE';
        StgBoothContact1.CONTACT_TYPE__c = 'CONTACT';
        StgBoothContact1.COUNTRY_CODE__c = '1';
        StgBoothContact1.CUST_BTH_ID__c = '1000001';
        StgBoothContact1.CUST_CONT_ID__c = '1000001';
        StgBoothContact1.EMAIL_ADDRESS__c = 'issue@ges.com';
        StgBoothContact1.EXTENSION__c = null;
        StgBoothContact1.FAX__c = null;
        StgBoothContact1.FIRST_NAME__c = 'Johnny';
        StgBoothContact1.LAST_NAME__c = 'Smith';
        StgBoothContact1.PHONE__c = '2630000';
        StgBoothContact1.PRIMARY_FLAG__c = 'Y';
        StgBoothContact1.SHOW_OCCR_CUST_ID__c = '1000001';
        StgBoothContact1.Interface_Status__c = 'New';
        StgBoothContact1.Interface_Batch_Number__c = '1';
        
        Database.insert(StgBoothContact1);        
        
        /* End Test Data for Staging Show Booth Contact */       
        
        String Schedule = '0 0 23 * * ?';
        
        test.startTest();
                
        BatchPurgeOracleStagingObjects BatchPurgeCust = new BatchPurgeOracleStagingObjects();
        BatchPurgeCust.query = 'Select s.Interface_Status__c, s.Interface_Process_Attempts__c, s.Interface_Error_Message__c, s.Interface_Batch_Number__c, s.Id, s.AR_CUST_STATUS__c, s.AR_CUST_LAST_UPDATE_DATE__c, s.AR_CUST_CREATION_DATE__c, s.AR_CUST_ACCOUNT_ID__c, s.AR_CUSTOMER_NAME__c, s.AR_CUSTOMER_DUNS_NUMBER__c, s.AR_CUSTOMER_NUMBER__c, s.AR_ADDR_CUST_ACCT_SITE_ID__c, s.AR_ADDR_CUST_SITE_STATUS__c, s.AR_ADDR_CUST_SITE_CREATION_DATE__c, s.AR_ADDR_CUST_SITE_LAST_UPDATE_DATE__c, s.AR_CUSTOMER_ADDRESS1__c, s.AR_CUSTOMER_ADDRESS2__c, s.AR_CUSTOMER_ADDRESS3__c, s.AR_CUSTOMER_ADDRESS4__c, s.AR_CUSTOMER_CITY__c, s.AR_CUSTOMER_STATE__c, s.AR_CUSTOMER_PROVINCE__c, s.AR_CUSTOMER_POSTAL_CODE__c, s.AR_CUSTOMER_COUNTRY__c, s.AR_ADDR_PARTY_SITE_LOC_ID__c, s.AR_ADDR_PARTY_SITE_LOC_CREATION_DATE__c, s.AR_ADDR_PARTY_SITE_LOC_LAST_UPDATE_DATE__c, s.AR_ADDR_CUST_SITE_USE_STATUS__c, s.AR_ADDR_CUST_SITE_USE_PRIMARY_FLAG__c,  s.AR_ADDR_CUST_SITE_USE_CREATION_DATE__c, s.AR_ADDR_CUST_SITE_USE_LAST_UPDATE_DATE__c From Staging_Oracle_AR_Customer__c s Where s.Interface_Status__c = \'New\'';
        ID BatchprocessId = Database.executeBatch(BatchPurgeCust, 200);
        
        ScheduleBatchPurgeOracleStagingCustomers SchPurgeStgCustomers = new ScheduleBatchPurgeOracleStagingCustomers();
        system.schedule('PurgeOracleStgCustomer', Schedule, SchPurgeStgCustomers);
        
        ScheduleBatchPurgeOracleStgShowBooths SchPurgeStgBooths = new ScheduleBatchPurgeOracleStgShowBooths();
        system.schedule('PurgeOracleStgBooths', Schedule, SchPurgeStgBooths);
        
        ScheduleBatchPurgeOracleStgSwBthContacts SchPurgeStgBoothContacts = new ScheduleBatchPurgeOracleStgSwBthContacts();
        system.schedule('PurgeOracleStgBoothContacts', Schedule, SchPurgeStgBoothContacts); 
        
        test.stopTest();
        
        System.abortJob(BatchprocessId);

    }
}