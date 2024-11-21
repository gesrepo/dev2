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
private class TestLinkShowOppController {

  public static testMethod void checkLinkShowOppController(){
    
    // create account
     Account acc = new Account();
     acc.Name = 'Test';
     acc.BillingCity = 'Test';
     acc.BillingStreet = 'Test';
     acc.BillingState = 'AL';
     acc.BillingPostalCode = '12345-0000';
     acc.BillingCountry = 'US';
     
     insert acc;
     
    Account_Credit__c ac = new Account_Credit__c();
    ac.Account__c = acc.Id;
    insert ac;
    
    ApexPages.currentPage().getParameters().put('id',ac.Id);
     
    Link_Show_Opportunities_Controller controller = null;
    
    try{
        controller = new Link_Show_Opportunities_Controller();
    }
    catch(Exception ex){
        system.debug(ex.getMessage());
    }   
    
    controller.init();
    controller.getopp();
    PageReference pr = controller.DoSelect();
    
    PageReference pr1 = controller.DoCancel();
     
  }
  
  public static testMethod void checkAddRemoveOppController()
  {
  	RecordType FirmRecordType = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Firm'];
	Id FirmRecordTypeId = FirmRecordType.Id;
	ID SalesRepId = UserInfo.getUserId();
	
  	Account Firm = new Account(
		Sales_Person__c = SalesRepId,
		Name = 'SONY ENTERTAINMENT INC',
		Phone = '7022631500',
		BillingStreet = '950 Grier Dr',
		BillingCity = 'Las Vegas',
		BillingPostalCode = '89119-0000',
		BillingState = 'NV',
		BillingCountry = 'US',
		RecordTypeId = FirmRecordTypeId
	);
	insert firm;
			
    //Opportunity o = [Select id, Show_Name__c From Opportunity Where (Not RecordType.Name Like 'E%D%') And Show_Name__r.Show_ID__c != null Limit 1];
    Opportunity o = [Select id, Show_Name__c From Opportunity WHERE Show_Name__r.Name = 'International Lingerie Show' Limit 1];
    
    Show_Plan__c sp = new Show_Plan__c();
    sp.Name = 'test';
    sp.Show_Opportunity__c = o.Id;
    sp.DummyNonRelatedOppID__c = o.Id;
    sp.Show_Name__c = o.Show_Name__c;
    insert sp;
    
    ApexPages.currentPage().getParameters().put('id',sp.Id);
     
    Add_Remove_Opportunities_Controller controller = null;
    
    try{
        controller = new Add_Remove_Opportunities_Controller();
    }
    catch(Exception ex){
        system.debug(ex.getMessage());
    }   
    
    controller.init();
    controller.getopp();
    controller.getoppRemove();

    PageReference pr = controller.DoSelect();
    
    PageReference pr1 = controller.DoRemove();
    PageReference pr2 = controller.BackToPlan();
    
    o.amount = 200;
    o.Show_Close_Date__c = system.today();
    o.Production_Location__c = 'test location';
    o.Prime_Contractor__c = firm.Id;
    update o;
        
    o.amount = 400;
    
    update o;
    Opportunity[] opp = new Opportunity[0];
    opp.add(o);
    UpdateShowPlanFields.UpdatePrpoposalDate(sp,opp);
    
    //delete o;
     
  }
}