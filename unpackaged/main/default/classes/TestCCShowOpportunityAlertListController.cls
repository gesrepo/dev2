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
private class TestCCShowOpportunityAlertListController {

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
        
        //Determine RecordTypeId of "Exhibitor" Account record type.
        RecordType RTAccExh = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Exhibitor'];
        Id ExhRecordTypeId = RTAccExh.Id;    
                        
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
        Facility.BillingState = 'NV';
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
        Firm.BillingState = 'NV';
        Firm.BillingCountry = 'US';
        Firm.RecordTypeId = FirmRecordTypeId;
        
        database.insert(Firm);
        
        //Create Account of Record Type "Firm"
        Account Exh = new Account();
        Exh.ORACLE_AR_CUST_ACCOUNT_ID__c = '10000001';
        Exh.Sales_Person__c = SalesRepId;
        Exh.Name = 'MyTestExhibitorName';
        Exh.Phone = '7022631500';
        Exh.BillingStreet = '950 Grier Dr';
        Exh.BillingCity = 'Las Vegas';
        Exh.BillingPostalCode = '89119-0000';
        Exh.BillingState = 'NV';
        Exh.BillingCountry = 'US';
        Exh.RecordTypeId = ExhRecordTypeId;
        
        database.insert(Exh);
        
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
        
        Oracle_Show_Booth__c Booth = new  Oracle_Show_Booth__c();
        
        Booth.Account__c = Exh.Id;
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
        
        Contact Con = new Contact();
        Con.FirstName = 'First Name';
        Con.LastName = 'Last Name';
        Con.Email = 'fnamelname@fakeemail.com';
        
        Database.insert(Con);
        
        Case C1 = new Case();
        C1.Subject = 'Some subject';
        C1.AccountId = Exh.Id;
        C1.Booth__c = Booth.Id;
        C1.ContactId = Con.Id;
        C1.Show_Status__c = '1-Pre';
        C1.Type = 'Billing Error';
        C1.Reason = 'Adv Receiving';
        C1.Customer_Type__c = 'Exhibitor';
        C1.Escalated_To__c = '8 - None';
        C1.Priority = 'Low Priority';
        C1.Status = 'Open';
        C1.Substatus__c = 'None Required';
        
        Database.insert(C1);
                
        Show_Opportunity_Alert__c Alert1 = new Show_Opportunity_Alert__c();
        Alert1.Show_Opportunity__c = Opp1.Id;
        Alert1.Message__c = 'Some alert';
        Alert1.Order__c = 1;
        
        Database.insert(Alert1);
        
        ApexPages.StandardController StdAlertCntl1 = new ApexPages.Standardcontroller(C1);
        CCShowOpportunityAlertListController AlertCntl1 = new CCShowOpportunityAlertListController(StdAlertCntl1); 
        
        AlertCntl1.getAlertsAvailable();
        List<Show_Opportunity_Alert__c> LoAlerts = AlertCntl1.getShowOpportunityAlerts();
                 
    }
}