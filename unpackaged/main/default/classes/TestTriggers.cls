@isTest
public class TestTriggers
{ 
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
   static testMethod void testTriggers () 
    {

		ID SalesRepId = UserInfo.getUserId();
		
        RecordType SalesRepOppRT = [SELECT Id FROM RecordType WHERE SobjectType = 'Opportunity' AND NAME = 'Sales Rep Show Occurrence' LIMIT 1];
        RecordType FirmRT = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND NAME = 'Firm'];
        RecordType FacilityRT = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND NAME = 'Facility'];
        
        
		/* Accounts */
        
        //Create Firm Account
        Account Firm = new Account();
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
        Test.setMock(WebServiceMock.class, new SalesforceUpsertOrganisationMokup(Facility.id));     
        
        
        //Create Show
        Show__c Show = new Show__c();
        Show.Sales_Person__c = SalesRepId;
        Show.Account__c = Firm.Id;
        Show.Name ='MyTestShow';
        Show.Show_Type__c = 'Food Sector';
        Show.Show_ID__c = '123456';
        
		Database.insert(Show);   
        
        
        Contact c = new Contact();        
        c.LastName = 'MyLastName'; 
		c.FirstName = 'MyFirstName'; 
		c.AccountId = Firm.Id; 
        
        insert c; 
        
        Opportunity op1 = new Opportunity();                                        
	
		op1.Amount = 100;
		op1.CloseDate = Date.newInstance(DateTime.now().yearGmt(),DateTime.now().monthGmt()+1,1);
		op1.h_85_Negotiation_and_Review__c = Date.newInstance(DateTime.now().yearGmt(),DateTime.now().monthGmt()+1,1);		
		 op1.X95_Contract_Transition_to_Acct_T__c = Date.newInstance(DateTime.now().yearGmt(),DateTime.now().monthGmt()+1,1);
		
		 op1.X80_Verbal_Agreement__c = Date.newInstance(DateTime.now().yearGmt(),DateTime.now().monthGmt()+1,1); 
		 op1.X75_Objectives_Resolved_Questions_Anse__c = Date.newInstance(DateTime.now().yearGmt(),DateTime.now().monthGmt()+1,1); 
		 
		 op1.X70_Proposal_Price__c = Date.newInstance(DateTime.now().yearGmt(),DateTime.now().monthGmt()+1,1); 
		 op1.X65_Present_Proposal_RFP_Response__c = Date.newInstance(DateTime.now().yearGmt(),DateTime.now().monthGmt()+1,1); 
		 op1.X50_Resource_Allocation__c = Date.newInstance(DateTime.now().yearGmt(),DateTime.now().monthGmt()+1,1);
		 
		 op1.X25_Meeting_Scheduled__c = Date.newInstance(DateTime.now().yearGmt(),DateTime.now().monthGmt()+1,1); 
		 op1.X10_Needs_Analysis__c = Date.newInstance(DateTime.now().yearGmt(),DateTime.now().monthGmt()+1,1);
		 op1.X100_Approved_Won__c = Date.newInstance(DateTime.now().yearGmt(),DateTime.now().monthGmt()+1,1);

		 op1.Type = ''; 
		 op1.StageName = 'SL1'; //TODO
		 op1.Show_Open_Date__c = Date.newInstance(DateTime.now().yearGmt(),DateTime.now().monthGmt()+1,1);
		
		 op1.Show_Name__c = Show.Id;
		 
		 op1.Show_Close_Date__c = Date.newInstance(DateTime.now().yearGmt(),DateTime.now().monthGmt()+1,1);
		 op1.Show_Close_Date_Confirmed__c = true;

		 op1.Sales_Person__c = SalesRepId; 
		 op1.Sales_Location__c = '110- Las Vegas';		
		 op1.RecordTypeId = SalesRepOppRT.Id; 
		 op1.Receive_RFP_Date__c = Date.newInstance(DateTime.now().yearGmt(),DateTime.now().monthGmt()+1,1);
		 op1.RFP_Due_Date__c = Date.newInstance(DateTime.now().yearGmt(),DateTime.now().monthGmt()+1,1);
		 op1.Proposal_Sent_Date__c = Date.newInstance(DateTime.now().yearGmt(),DateTime.now().monthGmt()+1,1); 		
		 op1.Presentation_Date__c = Date.newInstance(DateTime.now().yearGmt(),DateTime.now().monthGmt()+1,1); 
		 op1.OwnerId = SalesRepId; 
		  
		 op1.Name = 'MyTestOpty'; 
		 op1.Move_Out__c = Date.newInstance(DateTime.now().yearGmt(),DateTime.now().monthGmt()+1,1); 
		 op1.GES_Move_In__c = Date.newInstance(DateTime.now().yearGmt(),DateTime.now().monthGmt()+1,1); 
		 op1.AccountId = Firm.Id; 
         									
        Database.insert(op1);             //test insert trigger
        
        op1.Amount=200;
        update op1;             //test update trigger
                
        Financials__c f1 = new Financials__c(Name='test', Show_Occurrence__c = op1.Id);
        f1.Name = 'Test';
        insert f1;
        f1.Name = 'test2';
        update f1;
        
        Agreements__c a1 = new Agreements__c(Show_Occurrence__c = op1.Id);
        a1.Name = 'test';
        insert a1;
        a1.Agreement_on_File__c = true;
        update a1; 
        
        Incentives__c i1 = new Incentives__c(Show_Occurrence__c = op1.Id, Incentive__c = 10);
        i1.Name = 'Test';
        insert i1;
        i1.Incentive__c = 20;
        update i1; 
        
        Competitor_Information__c ci1 = new Competitor_Information__c(Show_Occurrence__c = op1.Id);
        ci1.Name = 'Test';
        insert ci1;
        ci1.Strengths__c = 'test';
        update ci1; 
        
    	Show_Occurrence_Public__c  sop = [select id from Show_Occurrence_Public__c limit 1];   	

        
        Account_Credit__c acNew = new Account_Credit__c();
        acNew.Account__c = Firm.Id;
        insert acNew;
        
 		Account_Credit_Opportunity__c acoNew = new Account_Credit_Opportunity__c();
        acoNew.Account_Credit__c = acNew.Id;
        acoNew.Opportunity__c = op1.Id;
        insert acoNew;
        
        Advance_Payment__c ap = new Advance_Payment__c();
        ap.Account_Credit__c = acNew.Id;
        ap.Advance_Payment_Amount__c = 100;
        ap.Show_Occurrence__c = op1.id;
        insert ap;

       
      //Show__c s = [select id, Show_ID__c, Account__c from Show__c where Show_ID__c != null limit 1];   
      //s.Account__c = op1.AccountId;
      //update s;   
      //op1.Show_Name__c = s.Id;
      //update op1;
       Facility.LMS_Facility_ID__c = '123zzz';
       update Facility;
       Show.Show_ID__c = 'zz123z';
       update Show;
      
      //TestTriggers.DoCode();	// Wait for sometime and then delete
      delete op1;				//test update trigger
   }  
   
 
}