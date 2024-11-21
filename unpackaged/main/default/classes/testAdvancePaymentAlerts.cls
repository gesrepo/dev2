@isTest
private class testAdvancePaymentAlerts {
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
	static testmethod void test() {
		
		ID SalesRepId = UserInfo.getUserId();
		
        RecordType SalesRepOppRT = [SELECT Id FROM RecordType WHERE SobjectType = 'Opportunity' AND NAME = 'Sales Rep Show Occurrence' LIMIT 1];
        RecordType FirmRT = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND NAME = 'Firm'];
        RecordType FacilityRT = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND NAME = 'Facility'];
        
        
        
        Show__c s = [select id, Show_ID__c, Account__c from Show__c where Show_ID__c != null And Account__c != null limit 1];
        
        Account ac1 = [select id from Account where Id =: s.Account__c limit 1];   
        
        //Create Firm Account
        Account Firm = new Account();
        //Firm.Id = s.Account__c;
        Firm.Sales_Person__c = SalesRepId;
        Firm.Name = 'MyTestFirmName';
        Firm.Type = 'Association'; 
        Firm.LMS_Firm_ID__c = 'FIRM01';
        Firm.BillingStreet = '950 Grier Dr';
        Firm.BillingCity = 'Las Vegas';
        Firm.BillingPostalCode = '89119-1234';
        Firm.BillingState = 'Nevada';
        Firm.BillingCountry = 'US';
        Firm.RecordTypeId = FirmRT.Id;
        
        Database.insert(Firm);

        Test.setMock(WebServiceMock.class, new SalesforceUpsertOrganisationMokup(Firm.id));
        
        //Create Prime Contractor Account
        Account PrimeContractor = new Account();
        PrimeContractor.Sales_Person__c = SalesRepId;
        PrimeContractor.Name = 'MyTestPrimeContractorName';
        PrimeContractor.Type = 'Contractor Competitor'; 
        PrimeContractor.LMS_Firm_ID__c = 'FIRM02';
        PrimeContractor.BillingStreet = '950 Grier Dr';
        PrimeContractor.BillingCity = 'Las Vegas';
        PrimeContractor.BillingPostalCode = '89119-1234';
        PrimeContractor.BillingState = 'Nevada';
        PrimeContractor.BillingCountry = 'US';
        PrimeContractor.RecordTypeId = FirmRT.Id;
        
        Database.insert(PrimeContractor);        
        
                
        //Create Facility
        Account Facility = new Account();
        //Facility.Id = s.Account__c;
        Facility.Sales_Person__c = SalesRepId;
        Facility.Name = 'MyTestFacilityName';
        Facility.Type = 'Hotel'; 
        Facility.GES_Status__c = 'Preferred';
        Facility.LMS_Facility_ID__c = 'GYRNMP';
        Facility.BillingStreet = '950 Grier Dr';
        Facility.BillingCity = 'Las Vegas';
        Facility.BillingPostalCode = '89119-0000';
        Facility.BillingState = 'Nevada';
        Facility.BillingCountry = 'US';
        Facility.RecordTypeId = FacilityRT.Id;
        
        Database.insert(Facility);       
        
        
        //Create Show
        Show__c Show = new Show__c();
        Show.Sales_Person__c = SalesRepId;
        Show.Account__c = Firm.Id;
        Show.Name ='MyTestShow';
        Show.Show_Type__c = 'Food Sector';
        Show.Show_ID__c = '123456';
        
		Database.insert(Show);   
        
        Contact ct1 = new Contact(AccountID=Firm.Id, LastName='test');
        Database.insert(ct1);
         
        Opportunity op1 = new Opportunity (Name='TestOppty', Sales_Person__c=SalesRepId, Show_Name__c = Show.Id,
                                           AccountId=Firm.Id, Prime_Contractor__c=PrimeContractor.Id, StageName='CR', Amount = 100, 
                                           Facility__c=Facility.Id,RecordTypeId = SalesRepOppRT.Id,
                                           New_Repeat__c='New', CloseDate=Date.today().addDays(3));
         									
        Database.insert(op1);
        
        Account_Credit__c acNew = new Account_Credit__c();
        acNew.Account__c = Firm.Id;
        insert acNew;
        
        Advance_Payment__c ap1 = new Advance_Payment__c(Advance_Payment_Due_Date__c = Date.today().addDays(3));
        ap1.Account_Credit__c = acNew.Id;
        ap1.Advance_Payment_Amount__c = 100;
        ap1.Show_Occurrence__c = op1.id;
        ap1.sent5dayNotice__c = false;
        ap1.Date_Paid__c = null;
       
        insert ap1;
        
        Advance_Payment__c ap2 = new Advance_Payment__c(Advance_Payment_Due_Date__c = Date.today().addDays(9));
        ap2.Account_Credit__c = acNew.Id;
        ap2.Advance_Payment_Amount__c = 100;
        ap2.Show_Occurrence__c = op1.id;       
        ap2.sent30dayNotice__c = false;
        ap2.Date_Paid__c = null;
        insert ap2;
        
        Advance_Payment__c ap3 = new Advance_Payment__c(Advance_Payment_Due_Date__c = Date.today().addDays(-2));
        ap3.Account_Credit__c = acNew.Id;
        ap3.Advance_Payment_Amount__c = 100;
        ap3.Show_Occurrence__c = op1.id;       
        ap3.sent30dayNotice__c = false;
        ap3.Date_Paid__c = null;
        insert ap3;
        
        DateTime d0Days = DateTime.now();
		DateTime d5Days = DateTime.now().addDays(5);
		String sd0Days = d0Days.formatGmt('yyyy-MM-dd');
		String sd5Days = d5Days.formatGmt('yyyy-MM-dd');
		
		Batch5dayAdvancePaymentAlert b5 = new Batch5dayAdvancePaymentAlert();
		b5.email = 'sfawcett@astadia.com';
		String query = 'SELECT sent30dayNotice__c, sent5dayNotice__c, Show_Occurrence__r.StageName, Show_Occurrence__r.RecordTypeID';
		query+= ' FROM Advance_Payment__c WHERE sent5dayNotice__c = false';
		query+= ' AND Date_Paid__c = null AND Advance_Payment_Due_Date__c <=' + sd5Days;
		query+= ' AND Advance_Payment_Due_Date__c >= ' + sd0Days;
		b5.query = query;
		Database.executeBatch(b5);
		
		DateTime d30Days = DateTime.now().addDays(30);
		DateTime d6Days = DateTime.now().addDays(6);
		String sd30Days = d30Days.formatGmt('yyyy-MM-dd');
		String sd6Days = d6Days.formatGmt('yyyy-MM-dd');
		
		Batch30dayAdvancePaymentAlert b30 = new Batch30dayAdvancePaymentAlert();
		b30.email = 'sfawcett@astadia.com';
		String query2 = 'SELECT sent30dayNotice__c, sent5dayNotice__c, Show_Occurrence__r.StageName, Show_Occurrence__r.RecordTypeID';
		query2+= ' FROM Advance_Payment__c WHERE sent30dayNotice__c = false';
		query2+= ' AND Date_Paid__c = null AND Advance_Payment_Due_Date__c <=' + sd30Days;
		query2+= ' AND Advance_Payment_Due_Date__c >= ' + sd6Days;
		b30.query = query2;
		Database.executeBatch(b30);
		
		DateTime d0Days1 = DateTime.now();
		String sd0Days1 = d0Days1.formatGmt('yyyy-MM-dd');
		
		BatchPastDueAdvancePaymentAlert pd = new BatchPastDueAdvancePaymentAlert();
		pd.email = 'sfawcett@astadia.com';
		pd.sendWrapUpEmail = false;
		String query3 = 'SELECT sentPastDueNotice__c, Show_Occurrence__r.StageName, Show_Occurrence__r.RecordTypeID';
		query3+= ' FROM Advance_Payment__c WHERE sent5dayNotice__c = false AND sentPastDueNotice__c = false';
		query3+= ' AND Date_Paid__c = null AND Advance_Payment_Due_Date__c <' + sd0Days1;
		pd.query = query3;
		Database.executeBatch(pd);
	}
}