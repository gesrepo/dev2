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
private class OpportunityListContExtTest {

	private static Account subAcct;
	private static Account acct;
	private static Show__c show;
	private static Opportunity parentOpp;
	private static User u;
	
	public static User createUser(String profileName, String Email) {
		Profile p = [SELECT Id, name FROM Profile WHERE name=:profileName]; 
		User testUser = new User(Alias = 'newUser', Email=Email, 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName=Email);
		return testUser;
	}
   	public static void setupData() {
   		
   		
   		
    	show = new Show__c(name='some show', Show_ID__c='123456');
    	insert show;
    	acct = new Account(name='the account', BillingCountry='US',phone='555-555-5555', BillingStreet='666 wacker',BillingState='MD',BillingCity='Baltimore', BillingPostalCode='20888-4444');
    	subAcct= new Account(name='subAccount', BillingCountry='US',phone='555-555-5555', BillingStreet='666 wacker',BillingState='MD',BillingCity='Baltimore', BillingPostalCode='20888-4444');
    	
    	insert new List<Account>{acct,subAcct};
    	
    	
    	parentOpp = CreateOpportunity('opp1', 'E_D_Projects_Proposal','some stage',acct.id,null);
    	insert parentOpp;
    	
    	Opportunity o1 = CreateOpportunity('opp1', 'E_D_Projects_Proposal','some stage',null,parentOpp.id);
    	Opportunity o2 = CreateOpportunity('opp2', 'E_D_Projects_Read_Only','some stage',null,parentOpp.id);
     	Opportunity o3 = CreateOpportunity('opp3', 'FieldSecurityCR','some stage',null,parentOpp.id);
     	Opportunity o4 = CreateOpportunity('opp4', 'FieldSecurityCV','some stage',null,parentOpp.id);
     	Opportunity o5 = CreateOpportunity('opp5', 'FieldSecurityCV','some stage',null,parentOpp.id);
     	Opportunity o6 = CreateOpportunity('theOpp', 'EMEA_Exhibition','some stage',null,parentOpp.id);
     	Opportunity o7 = CreateOpportunity('theOpp', 'AV','some stage');
     	insert new List<Opportunity> { o1, o2, o3, o4, o5, o6, o7};
     	

    }
    
   
   	static testMethod void testOpp() {
   		u = createUser('System Administrator','someguy@av.com');
   		LOB__c lob1 = new LOB__c(name='av', Picklist_value__c='AV',RTDevName__c='AV');
   		LOB__c lob2 = new LOB__c(name='FieldSecurityCV', Picklist_value__c='Trade Show',RTDevName__c='FieldSecurityCV');
   		LOB__c lob3 = new LOB__c(name='FieldSecurityDB', Picklist_value__c='Trade Show',RTDevName__c='FieldSecurityDB');
   		insert new List <LOB__c> {lob1,lob2,lob3};
   		System.runas(u) {
	   		setupData();
	   		Test.startTest();
	   		ApexPages.StandardController sc = new ApexPages.standardController(parentOpp);
			OpportunityListContExt controller = new OpportunityListContExt(sc);
		//get picklist vals
			controller.getLOB();
			controller.getStages();
			controller.getUsers();
			controller.getAccounts();
			controller.getFacilityCities();
			
			controller.limits=2;
			controller.searchresult();

			controller.nextbtn();
			controller.prvbtn();
	   		controller.fstbtn();
	  		controller.endbtn();
	 		controller.getprv();
		 	controller.getnxt();
			
			
			controller.sortExpression='name';
			
	
			controller.stage='Open';
			controller.searchresult();
			controller.stage='Won';
			controller.newSearchResult();
			controller.stage='Lost';
			controller.newSearchResult();
			//controller.selectedUserID = u.id;
			controller.selectedLOB ='Trade Show';
			controller.selectedAcctID=String.valueOf(subAcct.id);
			controller.searchresult();
			Test.StopTest();
		
   		}
   	}
   	
  	static testMethod void testShow() {
   		setupData();
   		ApexPages.StandardController sc = new ApexPages.standardController(show);
		OpportunityListContExt controller = new OpportunityListContExt(sc);
	//get picklist vals
		controller.getLOB();
		controller.getStages();
		controller.getUsers();
		controller.getAccounts();
		
		controller.searchresult();
		

   	}
   	static testMethod void testAccount() {
   		setupData();
   		ApexPages.StandardController sc = new ApexPages.standardController(acct);
		OpportunityListContExt controller = new OpportunityListContExt(sc);
	//get picklist vals
		controller.getLOB();
		controller.getStages();
		controller.getUsers();
		controller.getAccounts();
		
		controller.searchresult();
		controller.sortExpression='name';
		controller.searchresult();
		
	
		
   	}
   	
   	
   	
		
	private static Opportunity CreateOpportunity(String theName, String rtDevName, String stageName){ 
		return CreateOpportunity(theName, rtDevName, stageName, null, null);
	}
	
	private static Opportunity CreateOpportunity(String theName, String rtDevName, String stageName, ID acctid, ID showOccuranceID){ 
		ID rtID = RecordTypeUtil.getRecordTypeIDByDevName('Opportunity',rtDevName);

		Opportunity o1 = new Opportunity(name =  theName,
								amount=1,
								recordTypeId = rtID, 
								CloseDate = System.today().addYears(1),
								stageName = stageName,
								accountid=  acctid,
								Show_Occurrence__c = showOccuranceID
								//Sales_Person__c=salesperson CreateOccurance.Trigger is faling hti check
								);
		return o1;
		
	}
}