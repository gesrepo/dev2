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
private class TestBatch30dayAdvancePaymentAlert {
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

        //Retrieve User (for Owner)
        ID OwnerId = UserInfo.getUserId();
        
        //Retrieve User Sales Person
        ID SalesRepId = UserInfo.getUserId();

        //Create Facility
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
        Facility.RecordTypeId = '012400000005NYNAA2';
        database.insert(Facility);

        Test.setMock(WebServiceMock.class, new SalesforceUpsertOrganisationMokup(Facility.id));
        
        //Create Account of Record Type "Firm"
        Account Firm = new Account();
        Firm.Sales_Person__c = SalesRepId;
        Firm.Name = 'MyTestExhibitorName';
        Firm.Phone = '7022631500';
        Firm.BillingStreet = '950 Grier Dr';
        Firm.BillingCity = 'Las Vegas';
        Firm.BillingPostalCode = '89119-0000';
        Firm.BillingState = 'Nevada';
        Firm.BillingCountry = 'US';
        Firm.RecordTypeId = '012400000005NYSAA2';
        database.insert(Firm);
                
        //Create Show
        Show__c Show = new Show__c();
        Show.Sales_Person__c = SalesRepId;
        Show.Account__c = Firm.Id;
        Show.Name ='MyTestShow';
        Show.Show_Type__c = 'Food Sector';
        Show.Show_ID__c = '123456';
        database.insert(Show);        
        
        List<RecordType> Rts = [Select Id, Name From RecordType Where SObjectType = 'Opportunity'];
        
        Id RecordTypeId;
        
        for(RecordType rt: Rts)
        {
        	if (rt.Name == 'Sales Rep Show Occurrence')
        		RecordTypeId = rt.Id;
        }
        
        //Create ShowOccurrence
        Opportunity ShowOcc = new Opportunity();
        
        ShowOcc.RecordTypeId = RecordTypeId;
        ShowOcc.OwnerId = OwnerId;
        ShowOcc.Sales_Person__c = SalesRepId;
        ShowOcc.Sales_Location__c = '520- Miami, Orlando, Tampa';
        ShowOcc.Name = 'MyTestShow # 999';
        ShowOcc.Prime_Contractor__c = null;
        ShowOcc.Production_Location__c = '710- Chicago, Cleveland, Milwaukee, St. Louis';
        ShowOcc.Facility__c = Facility.Id;
        ShowOcc.StageName = 'CV';
        ShowOcc.Amount = 1000;
        ShowOcc.Type = 'ITYFTY';
        ShowOcc.New_Repeat__c = 'New';
        ShowOcc.Frequency__c = 'B1';
        ShowOcc.Job_Number_Status__c = 'Open';
        ShowOcc.AccountId = Firm.Id;
        ShowOcc.Show_Name__c = Show.Id;
        
        Date OpenDate = Date.newInstance(DateTime.now().yearGmt()+1, DateTime.now().monthGmt(),DateTime.now().dayGmt());
        Date CloseDate = Date.newInstance(DateTime.now().yearGmt()+1, DateTime.now().monthGmt(),DateTime.now().dayGmt()+1);
        
        ShowOcc.Show_Open_Date__c = OpenDate;
        ShowOcc.Show_Close_Date__c = CloseDate;
        ShowOcc.CloseDate = CloseDate; 
        
        Database.insert(ShowOcc, false);
        
        Account_Credit__c AccountCredit = new Account_Credit__c();
        AccountCredit.Account__c = Firm.Id;
        AccountCredit.Advance_Payments__c = true;
        AccountCredit.Credit_Approver__c = 'VIAD';
        AccountCredit.Credit_Expiration_Date__c = Date.newInstance(DateTime.now().yearGmt()+2, DateTime.now().monthGmt(),DateTime.now().dayGmt());
        AccountCredit.Credit_Notes__c = 'Some notes';
        AccountCredit.Credit_Summary__c = 'B4';
        
        Database.insert(AccountCredit, false);
        
        Advance_Payment__c AdvPayment = new Advance_Payment__c();
        //AdvPayment.Account__c = Firm.Id;
        AdvPayment.Account_Credit__c = AccountCredit.Id;
        AdvPayment.Advance_Payment_Amount__c = 10000;
        AdvPayment.Advance_Payment_Due_Date__c = Date.newInstance(DateTime.now().yearGmt(), DateTime.now().monthGmt(),DateTime.now().dayGmt()+15);
        AdvPayment.Date_Paid__c = null;
        AdvPayment.Sales_Person__c = SalesRepId;
        AdvPayment.Show_Occurrence__c = ShowOcc.Id;
        AdvPayment.sent30dayNotice__c = false;

        Database.insert(AdvPayment, false);
        
        test.startTest();
        
        DateTime d30Days = DateTime.now().addDays(30);
        DateTime d6Days = DateTime.now().addDays(6);
        String sd30Days = d30Days.formatGmt('yyyy-MM-dd');
        String sd6Days = d6Days.formatGmt('yyyy-MM-dd');
         
        Batch30dayAdvancePaymentAlert MyBatch = new Batch30dayAdvancePaymentAlert();
        
		MyBatch.email = 'jvarughese@ges.com';
		MyBatch.sendWrapUpEmail = true;
		String query = 'SELECT sent30dayNotice__c, Show_Occurrence__r.StageName, Show_Occurrence__r.RecordTypeID';
		query += ' FROM Advance_Payment__c WHERE sent30dayNotice__c = false';
		query += ' AND Date_Paid__c = null AND Advance_Payment_Due_Date__c <=' + sd30Days;
		query += ' AND Advance_Payment_Due_Date__c >= ' + sd6Days + ' Limit 200';
		MyBatch.query = query;
        
		ID BatchprocessId = Database.executeBatch(MyBatch, 200);       
		
        test.stopTest();
    }
}