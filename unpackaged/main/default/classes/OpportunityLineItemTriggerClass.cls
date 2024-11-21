@isTest
public class OpportunityLineItemTriggerClass
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
    static testMethod void testOpportunityLineItemTrigger()
    {
		

		ID SalesRepId = UserInfo.getUserId();
		
        RecordType SalesRepOppRT = [SELECT Id FROM RecordType WHERE SobjectType = 'Opportunity' AND NAME = 'Sales Rep Show Occurrence' LIMIT 1];
        RecordType FirmRT = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND NAME = 'Firm'];
        RecordType FacilityRT = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND NAME = 'Facility'];        
        
        Account acc = new Account();
        acc.Name = 'TEST';
        acc.BillingCity = 'TEST';
        acc.BillingStreet = 'TEST';
        acc.BillingState = 'AL';
        acc.BillingPostalCode = '12345-0000';
        acc.BillingCountry = 'US';
        acc.Phone = '7022631500';
        acc.RecordTypeId = FirmRT.Id;
        insert acc;
        
        Test.setMock(WebServiceMock.class, new SalesforceUpsertOrganisationMokup(acc.id));

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
        
        Opportunity opp = new Opportunity();
        opp.Name = 'TEST';
        opp.StageName = 'Pipeline';
        opp.CloseDate = Date.TODAY();
        opp.AccountId = acc.Id;
        //opp.Sponsor__c = acc.Id;
        //opp.Management_Company__c = acc.Id;
        opp.Prime_Contractor__c = PrimeContractor.Id;
        opp.Advance_Shipping_Site__c = acc.Id;
        insert opp;
        
        Product2 prod = new Product2();
        prod.Name = 'TEST';
        insert prod;
        
        Pricebook2 priceBook = [SELECT Id FROM Pricebook2 where IsStandard = TRUE LIMIT 1];
        
        PricebookEntry pbEntry = new PricebookEntry();
        pbEntry.UnitPrice = 50;
        pbEntry.Product2Id = prod.Id;
        pbEntry.Pricebook2Id = priceBook.Id;
        pbEntry.IsActive=TRUE;
        pbEntry.UseStandardPrice=FALSE;
        insert pbEntry;
        
        OpportunityLineItem lineItem = new OpportunityLineItem();
        lineItem.OpportunityId = opp.Id;
        lineItem.PricebookEntryId = pbEntry.Id;
        
        insert lineItem;
        
        update lineItem;
        
        delete lineItem;
    }
}