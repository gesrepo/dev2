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
private class TestBatchImportOracleShowBoothContact {

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
                        
        // First Account of Record Type "Facility"
        Account Facility = TestDataUtil.CreateTestFacility(); 
        Test.setMock(WebServiceMock.class, new SalesforceUpsertOrganisationMokup(Facility.id));
        
        //Create Account of Record Type "Firm"
        Account Firm = TestDataUtil.CreateTestFirm();
        
        //Create Account of Record Type "Exhibitor"
        Account Exhibitor = TestDataUtil.CreateTestExhibitor();

        //Create Contact
        //Contact ConNoAccount = TestDataUtil.CreateTestContact();
        Contact ConWithAccount = TestDataUtil.CreateTestContact(Exhibitor.Id);
        
        //Create Show
        Show__c Show = TestDataUtil.CreateTestShow(Firm.Id);
        
        //Then create Show Occurrence
        Opportunity Opp = TestDataUtil.CreateTestSalesRepOpp(Facility.Id, Firm.Id, Show.Id);
        SOPAuthentication__c newAuth = new SOPAuthentication__c();
        newAuth.Name = 'Login Credentials';
        newAuth.Password__c = 'lalalala';
        newAuth.Username__c = 'lalalala';
        insert newAuth;
        
        //Create Booth
        test.startTest();
        Oracle_Show_Booth__c Booth = TestDataUtil.CreateTestBooth(Exhibitor.Id, Opp.Id, Opp.Job_Number__c, Show.Id);
        
        //Create Booth Contact. Use this record to test booth contact update. Booth contact update
        //test should include these tests:
        //1. Update booth contact when contact exists, matches stage contact and contact is not associated to account
        //2. Update booth contact when contact exists, matches stage contact and contact is associated to account
        //3. Update booth contact when contact exists, but contact does not match stage contact
             
        Oracle_Show_Booth_Contact__c BC1 = TestDataUtil.CreateTestBoothContact(
            Booth.Id, //boothId
            ConWithAccount.Id, //conId
            702, //areaCode
            'ROLE', //conRole
            'CONTACT', //conType
            '1', //countryCode
            '1000001', //custBthId
            '0000001', //custConId
            'fnamelname@fakeemail.com', //email
            null, //extension
            null, //fax
            'First Name', //firstName
            'Last Name', //lastName
            '2630000', //phone
            'N', //primaryFlag
            '1000000'); //showOccrCustId. This field does not drive anything.
            
        Oracle_Show_Booth_Contact__c BC2 = TestDataUtil.CreateTestBoothContact(
            Booth.Id, //boothId
            ConWithAccount.Id, //conId
            702, //areaCode
            'ROLE', //conRole
            'CONTACT', //conType
            '1', //countryCode
            '1000001', //custBthId
            '0000002', //custConId
            'fnamelnamewaccount@fakeemail.com', //email
            null, //extension
            null, //fax
            'First Name W Account', //firstName
            'Last Name W Account', //lastName
            '2630000', //phone
            'N', //primaryFlag
            '1000000'); //showOccrCustId. This field does not drive anything.
            
        Oracle_Show_Booth_Contact__c BC31 = TestDataUtil.CreateTestBoothContact(
            Booth.Id, //boothId
            ConWithAccount.Id, //conId
            702, //areaCode
            'ROLE', //conRole
            'CONTACT', //conType
            '1', //countryCode
            '1000001', //custBthId
            '00000031', //custConId
            'fnamelnamewaccount@fakeemail.com', //email
            null, //extension
            null, //fax
            'First Name W Account', //firstName
            'Last Name W Account', //lastName
            '2630000', //phone
            'N', //primaryFlag
            '1000000'); //showOccrCustId. This field does not drive anything.
            
        Oracle_Show_Booth_Contact__c BC32 = TestDataUtil.CreateTestBoothContact(
            Booth.Id, //boothId
            ConWithAccount.Id, //conId
            702, //areaCode
            'ROLE', //conRole
            'CONTACT', //conType
            '1', //countryCode
            '1000001', //custBthId
            '00000032', //custConId
            'fnamelnamewaccount@fakeemail.com', //email
            null, //extension
            null, //fax
            'First Name W Account', //firstName
            'Last Name W Account', //lastName
            '2630000', //phone
            'N', //primaryFlag
            '1000000'); //showOccrCustId. This field does not drive anything.
        
        //Use this booth contact to test ingore of update when a show workbench
        //contact is updated manually in Salesforce.
        Oracle_Show_Booth_Contact__c BC5 = TestDataUtil.CreateTestBoothContact(
            Booth.Id, //boothId
            ConWithAccount.Id, //conId
            702, //areaCode
            'ROLE', //conRole
            'CONTACT', //conType
            '1', //countryCode
            '1000001', //custBthId
            '0000005', //custConId
            'fnamelnamewaccount@fakeemail.com', //email
            null, //extension
            null, //fax
            'First Name W Account', //firstName
            'Last Name W Account', //lastName
            '2630000', //phone
            'N', //primaryFlag
            '1000000'); //showOccrCustId. This field does not drive anything.
            
        BC5.Updated_in_Salesforce__c = true;
        Database.update(BC5);
        
        
        //Use this booth contact to test an update an existing booth contact with invalid booth
        //cust id in staging table
        Oracle_Show_Booth_Contact__c BC4 = TestDataUtil.CreateTestBoothContact(
            Booth.Id, //boothId
            ConWithAccount.Id, //conId
            702, //areaCode
            'ROLE', //conRole
            'CONTACT', //conType
            '1', //countryCode
            '1000001', //custBthId
            '0000004', //custConId
            'fnamelnamewaccount@fakeemail.com', //email
            null, //extension
            null, //fax
            'First Name W Account', //firstName
            'Last Name W Account', //lastName
            '2630000', //phone
            'N', //primaryFlag
            '1000000'); //showOccrCustId. This field does not drive anything.       
       // test.stopTest();
        
        //Update an existing Booth Contact (BC1), where contact info matches stage contact info and
        //contact is not associated to account   
        Staging_Oracle_Show_Booth_Contact__c SBC1 = TestDataUtil.CreateTestStagingBoothContact(
            702, //areaCode
            'ROLE', //conRole
            'CONTACT', //conType
            '1', //countryCode
            '1000001', //custBthId
            '0000001', //custConId
            'fnamelname@fakeemail.com', //email
            null, //extension
            null, //fax
            'First Name', //firstName
            'Last Name', //lastName
            '2630000', //phone
            'Y', //primaryFlag
            '284679', //showOccrCustId
            'New', //interfaceStatus
            '1'); //interfaceBatchNo
            
        //Update an existing Booth Contact (BC2), where contact info matches stage contact info and
        //contact is associated to account      
        Staging_Oracle_Show_Booth_Contact__c SBC2 = TestDataUtil.CreateTestStagingBoothContact(
            702, //areaCode
            'ROLE', //conRole
            'CONTACT', //conType
            '1', //countryCode
            '1000001', //custBthId
            '0000002', //custConId
            'fnamelnamewaccount@fakeemail.com', //email
            null, //extension
            null, //fax
            'First Name W Account', //firstName
            'Last Name W Account', //lastName
            '2630000', //phone
            'Y', //primaryFlag
            '284679', //showOccrCustId
            'New', //interfaceStatus
            '1'); //interfaceBatchNo
            
        //Update an existing Booth Contact (BC31), where existing contact tied to booth contact
        //does not match stage contact info (also test country code not null line # 266) 
        Staging_Oracle_Show_Booth_Contact__c SBC31 = TestDataUtil.CreateTestStagingBoothContact(
            702, //areaCode
            'ROLE', //conRole
            'CONTACT', //conType
            '1', //countryCode
            '1000001', //custBthId
            '00000031', //custConId
            'fnamelnamewaccount12@fakeemail.com', //email
            null, //extension
            null, //fax
            'First Name W Account 12', //firstName
            'Last Name W Account 12', //lastName
            '2630000', //phone
            'Y', //primaryFlag
            '284679', //showOccrCustId
            'New', //interfaceStatus
            '1'); //interfaceBatchNo
            
        //Update an existing Booth Contact (BC32), where existing contact tied to booth contact
        //does not match stage contact info   (also test country code null line # 268) 
        Staging_Oracle_Show_Booth_Contact__c SBC32 = TestDataUtil.CreateTestStagingBoothContact(
            702, //areaCode
            'ROLE', //conRole
            'CONTACT', //conType
            null, //countryCode
            '1000001', //custBthId
            '00000032', //custConId
            'fnamelnamewaccount12@fakeemail.com', //email
            null, //extension
            null, //fax
            'First Name W Account 12', //firstName
            'Last Name W Account 12', //lastName
            '2630000', //phone
            'Y', //primaryFlag
            '284679', //showOccrCustId
            'New', //interfaceStatus
            '1'); //interfaceBatchNo
            
        //Update an existing Booth Contact (BC4), where staging record has invalid
        //cust booth id (BoothId ==  null)
        Staging_Oracle_Show_Booth_Contact__c SBC4 = TestDataUtil.CreateTestStagingBoothContact(
            702, //areaCode
            'ROLE', //conRole
            'CONTACT', //conType
            '1', //countryCode
            //'9000001', //custBthId
            null, //custBthId
            '0000004', //custConId
            'fnamelnamewaccount@fakeemail.com', //email
            null, //extension
            null, //fax
            'First Name W Account', //firstName
            'Last Name W Account', //lastName
            '2630000', //phone
            'Y', //primaryFlag
            '284679', //showOccrCustId
            'New', //interfaceStatus
            '1'); //interfaceBatchNo
        
        // Test update ignore because bc is updated in Salesforce manually
        Staging_Oracle_Show_Booth_Contact__c SBC5 = TestDataUtil.CreateTestStagingBoothContact(
            702, //areaCode
            'ROLE', //conRole
            'CONTACT', //conType
            '1', //countryCode
            '1000001', //custBthId
            '0000005', //custConId
            'fnamelnamewaccount@fakeemail.com', //email
            null, //extension
            null, //fax
            'First Name W Account', //firstName
            'Last Name W Account', //lastName
            '2630000', //phone
            'Y', //primaryFlag
            '1000000', //showOccrCustId
            'New', //interfaceStatus
            '1'); //interfaceBatchNo
        
        // Check successful insert.
        Staging_Oracle_Show_Booth_Contact__c SBCI1 = TestDataUtil.CreateTestStagingBoothContact(
            702, //areaCode
            'ROLE', //conRole
            'CONTACT', //conType
            '1', //countryCode
            '1000001', //custBthId
            '1000001', //custConId
            'leon@areds.com', //email
            null, //extension
            null, //fax
            'Johnny', //firstName
            'Smith', //lastName
            '2630000', //phone
            'Y', //primaryFlag
            '1000001', //showOccrCustId
            'New', //interfaceStatus
            '1'); //interfaceBatchNo
        
        // Create another stage booth contact that will insert successfully, for which the contact
        // already exists.
        Staging_Oracle_Show_Booth_Contact__c SBCI2 = TestDataUtil.CreateTestStagingBoothContact(
            702, //areaCode
            'ROLE', //conRole
            'CONTACT', //conType
            null, //countryCode
            '1000001', //custBthId
            '1000002', //custConId
            'fnamelnamewaccount@fakeemail.com', //email
            null, //extension
            null, //fax
            'First Name W Account', //firstName
            'Last Name W Account', //lastName
            '2630000', //phone
            'Y', //primaryFlag
            '1000001', //showOccrCustId
            'New', //interfaceStatus
            '1'); //interfaceBatchNo    
                
        // Check Failed Insert
        Staging_Oracle_Show_Booth_Contact__c SBCI3 = TestDataUtil.CreateTestStagingBoothContact(
            702, //areaCode
            'ROLE', //conRole
            'CONTACT', //conType
            '1', //countryCode
            '1000003', //custBthId
            '1000003', //custConId
            'leon@areds.com', //email
            null, //extension
            null, //fax
            'Johnny3', //firstName
            'Smith3', //lastName
            '2630000', //phone
            'Y', //primaryFlag
            '1000001', //showOccrCustId
            'New', //interfaceStatus
            '1'); //interfaceBatchNo  
        
       // test.startTest();
                
        BatchImportOracleShowBoothContact BatchBoothContact = new BatchImportOracleShowBoothContact();
        BatchBoothContact.query = 'Select SystemModstamp, SHOW_OCCR_CUST_ID__c, PRIMARY_FLAG__c, PHONE__c, OwnerId, Name, LastModifiedDate, LastModifiedById, LAST_UPDATE_DATE__c, LAST_NAME__c, IsDeleted, Interface_Status__c, Interface_Process_Attempts__c, Interface_Error_Message__c, Interface_Batch_Number__c, Id, FIRST_NAME__c, FAX__c, EXTENSION__c, EMAIL_ADDRESS__c, CurrencyIsoCode, CreatedDate, CreatedById, CUST_CONT_ID__c, CUST_BTH_ID__c, CREATION_DATE__c, COUNTRY_CODE__c, CONTACT_TYPE__c, CONTACT_ROLE__c, AREA_CODE__c, SHOW_ID__c, BOOTH_NUMBER__c, CUSTOMER_NAME__c From Staging_Oracle_Show_Booth_Contact__c Where Interface_Status__c In (\'New\') Limit 200';      
        
        ID BatchprocessId = Database.executeBatch(BatchBoothContact, 200);
        
        test.stopTest();
                
        System.abortJob(BatchprocessId);
        
                
    }

}