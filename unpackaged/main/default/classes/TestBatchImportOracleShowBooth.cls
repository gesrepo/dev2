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
private class TestBatchImportOracleShowBooth {

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
        // TO DO: implement unit test
        
        // Retrieve the Salesforce Id for User and Sales Rep
        Id OwnerId = UserInfo.getUserId();
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

        SOPAuthentication__c newAuth = new SOPAuthentication__c();
        newAuth.Name = 'Login Credentials';
        newAuth.Password__c = 'lalalala';
        newAuth.Username__c = 'lalalala';
        insert newAuth;
        
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
        
        //Then create Booth
        Staging_Oracle_Show_Booth__c StageBooth11 = new Staging_Oracle_Show_Booth__c();
        
        StageBooth11.CUST_ACCOUNT_ID__c = Firm.ORACLE_AR_CUST_ACCOUNT_ID__c;
        StageBooth11.PROJECT_NUMBER__c = Opp1.Job_Number__c; 
        StageBooth11.BOOTH_ID__c = '2000001';
        StageBooth11.BOOTH_CREATION_DATE__c = DateTime.now();
        StageBooth11.BOOTH_LAST_UPDATE_DATE__c = DateTime.now();
        StageBooth11.BOOTH_LENGTH__c = 10;
        StageBooth11.BOOTH_NUMBER__c = '100';
        StageBooth11.BOOTH_SHARED_FLAG__c = 'Y';
        StageBooth11.BOOTH_SIZE__c = 100;
        StageBooth11.BOOTH_TYPE__c = 'Inline';
        StageBooth11.BOOTH_WIDTH__c = 10;
        StageBooth11.ED_FLAG__c = 'Y';
        StageBooth11.INACTIVE_FLAG__c = 'N';
        StageBooth11.SHOW_ID__c = 'CES';
        StageBooth11.THIRD_PARTY_FLAG__c = 'Y';
        StageBooth11.SHOW_ORG_FLAG__c = 'Y';
        
        StageBooth11.Interface_Status__c = 'New';
        StageBooth11.Interface_Batch_Number__c = '1';
        
        Database.insert(StageBooth11);
        
        // Test a valid update. This cust_booth_id__c must exist
        // for coverage
        Staging_Oracle_Show_Booth__c StageBooth21 = new Staging_Oracle_Show_Booth__c();
        
        StageBooth21.CUST_ACCOUNT_ID__c = '502795';
        StageBooth21.PROJECT_NUMBER__c = '011004327'; 
        StageBooth21.BOOTH_ID__c = '351139';
        StageBooth21.BOOTH_CREATION_DATE__c = DateTime.now();
        StageBooth21.BOOTH_LAST_UPDATE_DATE__c = DateTime.now();
        StageBooth21.BOOTH_LENGTH__c = 10;
        StageBooth21.BOOTH_NUMBER__c = '100';
        StageBooth21.BOOTH_SHARED_FLAG__c = 'Y';
        StageBooth21.BOOTH_SIZE__c = 100;
        StageBooth21.BOOTH_TYPE__c = 'Inline';
        StageBooth21.BOOTH_WIDTH__c = 10;
        StageBooth21.ED_FLAG__c = null;
        StageBooth21.INACTIVE_FLAG__c = null;
        StageBooth21.SHOW_ID__c = 'CES';
        StageBooth21.THIRD_PARTY_FLAG__c = null;
        StageBooth21.SHOW_ORG_FLAG__c = null;
        
        StageBooth21.Interface_Status__c = 'New';
        StageBooth21.Interface_Batch_Number__c = '1';
        
        Database.insert(StageBooth21);
        
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
        StageBooth2.BOOTH_SHARED_FLAG__c = null;
        StageBooth2.BOOTH_SIZE__c = 100;
        StageBooth2.BOOTH_TYPE__c = 'Inline';
        StageBooth2.BOOTH_WIDTH__c = 10;
        StageBooth2.ED_FLAG__c = null;
        StageBooth2.INACTIVE_FLAG__c = null;
        StageBooth2.SHOW_ID__c = 'CES';
        StageBooth2.THIRD_PARTY_FLAG__c = null;
        StageBooth2.SHOW_ORG_FLAG__c = null;
        
        StageBooth2.Interface_Status__c = 'New';
        StageBooth2.Interface_Batch_Number__c = '1';
        
        Database.insert(StageBooth2);
                
        test.startTest();
                
        // Test Insert of new customers and insert failures
        BatchImportOracleShowBooth BatchShowBooth = new BatchImportOracleShowBooth();
        
        String query = 'Select s.ZONE__c, s.THIRD_PARTY_FLAG__c, s.SystemModstamp, s.SHOW_ORG_FLAG__c, s.SHOW_OCCR_ID__c, s.SHOW_OCCR_CUST_ID__c, s.SHOW_ID__c, s.SERVICE_ZONE__c, s.PROJECT_NUMBER__c, s.PROJECT_NAME__c, s.OwnerId, s.Name, s.MASTER_FACILITY_HEADER_ID__c, s.LastModifiedDate, s.LastModifiedById, s.IsDeleted, s.Interface_Status__c, s.Interface_Process_Attempts__c, s.Interface_Error_Message__c, s.Interface_Batch_Number__c, s.Id, s.INVOICE_HOLD_FLAG__c, s.INACTIVE_FLAG__c, s.FACILITY_ID__c, s.FACILITY_HEADER_ID__c, s.EXHIBITOR_STATUS5__c, s.EXHIBITOR_STATUS4__c, s.EXHIBITOR_STATUS3__c, s.EXHIBITOR_STATUS2__c, s.EXHIBITOR_STATUS1__c, s.EXHIBITOR_FLAG__c, s.EVENT_CITY__c, s.ED_FLAG__c, s.CurrencyIsoCode, s.CreatedDate, s.CreatedById, s.CUST_ACCOUNT_ID__c, s.CUSTOMER_NAME__c, s.BOOTH_WIDTH__c, s.BOOTH_TYPE__c, s.BOOTH_SIZE__c, s.BOOTH_SHARED_FLAG__c, s.BOOTH_NUMBER__c, s.BOOTH_LENGTH__c, s.BOOTH_LAST_UPDATE_DATE__c, s.BOOTH_ID__c, s.BOOTH_CREATION_DATE__c, s.Show_Package__c  From Staging_Oracle_Show_Booth__c s Where s.Interface_Status__c In (\'New\') Limit 200';
        BatchShowBooth.query = query;
        
        ID BatchprocessId = Database.executeBatch(BatchShowBooth, 200);
        
        // Update Booth -- invalid update so cause update failure -- account does not exist
        Staging_Oracle_Show_Booth__c StageBooth3 = new Staging_Oracle_Show_Booth__c();
        
        StageBooth3.CUST_ACCOUNT_ID__c = '90000002';
        StageBooth3.PROJECT_NUMBER__c = Opp1.Job_Number__c; 
        StageBooth3.BOOTH_ID__c = '1000001';
        StageBooth3.BOOTH_CREATION_DATE__c = DateTime.now();
        StageBooth3.BOOTH_LAST_UPDATE_DATE__c = DateTime.now();
        StageBooth3.BOOTH_LENGTH__c = 10;
        StageBooth3.BOOTH_NUMBER__c = '100';
        StageBooth3.BOOTH_SHARED_FLAG__c = 'Y';
        StageBooth3.BOOTH_SIZE__c = 100;
        StageBooth3.BOOTH_TYPE__c = 'Inline';
        StageBooth3.BOOTH_WIDTH__c = 10;
        StageBooth3.ED_FLAG__c = null;
        StageBooth3.INACTIVE_FLAG__c = null;
        StageBooth3.SHOW_ID__c = 'CES';
        StageBooth3.THIRD_PARTY_FLAG__c = null;
        StageBooth3.SHOW_ORG_FLAG__c = null;
        
        StageBooth3.Interface_Status__c = 'New';
        StageBooth3.Interface_Batch_Number__c = '1';
        
        Database.insert(StageBooth3);
        
        //Update existing booth
        Staging_Oracle_Show_Booth__c StageBooth12 = new Staging_Oracle_Show_Booth__c();
        StageBooth12.CUST_ACCOUNT_ID__c = Firm.ORACLE_AR_CUST_ACCOUNT_ID__c;
        StageBooth12.PROJECT_NUMBER__c = Opp1.Job_Number__c; 
        StageBooth12.BOOTH_ID__c = '2000001';
        StageBooth12.BOOTH_CREATION_DATE__c = DateTime.now();
        StageBooth12.BOOTH_LAST_UPDATE_DATE__c = DateTime.now();
        StageBooth12.BOOTH_LENGTH__c = 10;
        StageBooth12.BOOTH_NUMBER__c = '100';
        StageBooth12.BOOTH_SHARED_FLAG__c = 'Y';
        StageBooth12.BOOTH_SIZE__c = 100;
        StageBooth12.BOOTH_TYPE__c = 'Inline';
        StageBooth12.BOOTH_WIDTH__c = 10;
        //StageBooth12.ED_FLAG__c = null;
        //StageBooth12.INACTIVE_FLAG__c = null;
        StageBooth12.SHOW_ID__c = 'CES';
        //StageBooth12.THIRD_PARTY_FLAG__c =  null;
        //StageBooth12.SHOW_ORG_FLAG__c = null;
        
        StageBooth12.Interface_Status__c = 'New';
        StageBooth12.Interface_Batch_Number__c = '1';
        
        Database.insert(StageBooth12);
 
        BatchprocessId = Database.executeBatch(BatchShowBooth, 200);
        
        //Account Facility1 = TestDataUtil.CreateTestFacility();
        //Test.setMock(WebServiceMock.class, new SalesforceUpsertOrganisationMokup(Facility.id));
       // Account Firm1 = TestDataUtil.CreateTestFirm();
        Account Exhibitor = TestDataUtil.CreateTestExhibitor();
      //  Show__c Show1 = TestDataUtil.CreateTestShow(Firm1.Id);
      //  Opportunity SalesRepOpp1 = TestDataUtil.CreateTestSalesRepOpp(Facility1.Id, Firm1.Id, Show1.Id);
        
        Oracle_Show_Booth__c Booth = new  Oracle_Show_Booth__c();
        Booth.Account__c = Exhibitor.Id;
        Booth.Show_Occurrence__c = opp1.Id;        
        Booth.CUST_ACCOUNT_ID__c = '100001';
        Booth.BOOTH_ID__c = '1000001';
        Booth.ED_FLAG__c = false;
        Booth.INACTIVE_FLAG__c = false;            
        Booth.PROJECT_NUMBER__c = opp1.Job_Number__c;
        Booth.SHOW_ID__c = Show.Show_ID__c;
        Booth.THIRD_PARTY_FLAG__c = false;
        Booth.SHOW_ORG_FLAG__c =  false;     
        Booth.Name =opp1.Job_Number__c+ '' + Booth.CUST_ACCOUNT_ID__c;
        if (Booth.Name != null) {
        if (Booth.Name.length() > 80 )
                Booth.Name = Booth.Name.substring(0,80);
        
        Booth.BOOTH_CREATION_DATE__c = DateTime.now();
        Booth.BOOTH_LAST_UPDATE_DATE__c = DateTime.now();
        Booth.BOOTH_LENGTH__c = 10;
        Booth.BOOTH_NUMBER__c = '10001';
        Booth.BOOTH_SHARED_FLAG__c = 'N';
        Booth.BOOTH_SIZE__c = 100;
        Booth.BOOTH_TYPE__c = 'INLINE';
        Booth.BOOTH_WIDTH__c = 10;
        booth.EXHIBITOR_STATUS1__c = 'Package 24';
        booth.EXHIBITOR_STATUS2__c = 'Freight Pkg 3';
        booth.EXHIBITOR_STATUS3__c = 'Freight Pkg 4';
        booth.EXHIBITOR_STATUS4__c = 'White Star';
        booth.EXHIBITOR_STATUS5__c = null;
        booth.Show_Package__c = '2 Plastic Chairs';
        }
       // Booth.EMEA__c = True;    
        insert Booth;
        
        Booth.SHOW_ORG_FLAG__c =  true; 
        update Booth;
        
        test.stopTest();
        
        System.abortJob(BatchprocessId);
    }
}