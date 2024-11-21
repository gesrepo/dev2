@isTest(seeAllData=true)
public with sharing class BootheContactAllTest {
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

   
    private static testmethod void test1(){

        String uid = [SELECT Id FROM User WHERE Alias = 'CorpAcct' LIMIT 1].Id;
        Id TradeshowRTId = ((RecordType)[SELECT Id FROM RecordType WHERE Name = 'Sales Rep Show Occurrence' And SObjectType = 'Opportunity']).Id;
        Id FirmRTId = ((RecordType)[SELECT Id FROM RecordType WHERE Name = 'Firm' And SObjectType = 'Account']).Id;
        Id ExhibitorRTId = ((RecordType)[SELECT Id FROM RecordType WHERE Name = 'Exhibitor' And SObjectType = 'Account']).Id;

        Account acc = new Account();
        acc.Name = 'name-firm';
        acc.RecordTypeId = FirmRTId;
        acc.BillingCity = 'city';
        acc.BillingCountry = 'US';
        acc.BillingState = 'AL';
        acc.BillingPostalCode = '12345-1234';
        acc.BillingStreet = 'street';
        acc.Phone = '12345';
        insert acc;

        Test.setMock(WebServiceMock.class, new SalesforceUpsertOrganisationMokup(acc.id));
        
        Account exh = new Account();
        exh.Name = 'name-exhibitor';
        exh.RecordTypeId = ExhibitorRTId;
        exh.BillingCity = 'city';
        exh.BillingCountry = 'US';
        exh.BillingState = 'AL';
        exh.BillingPostalCode = '12345-1234';
        exh.BillingStreet = 'street';
        exh.Phone = '12345';
        insert exh;     
        
        Contact c = new Contact();
        c.LastName = 'lname';
        c.OwnerId = uid;
        c.AccountId = exh.Id;
        insert c;

        Campaign cmp = new Campaign();
        cmp.Status = 'In Progress';
        cmp.Name = 'name-12345xYZ'; //Make case different from that in Opportunity Job # just to make sure the trigger code handles it
        insert cmp; 
                
        Opportunity opp = new Opportunity();
        opp.RecordTypeId = TradeshowRTId;
        opp.CloseDate = date.today();
        opp.Name = 'name';
        opp.StageName = 'Closed Won';
        opp.Job_Number__c = '12345XYZ';
        //opp.Prime_Contractor__c = c.Id;
        opp.Amount = 1;
        opp.AccountId = acc.Id;
        insert opp; 
        
        Oracle_Show_Booth__c  b = new Oracle_Show_Booth__c();
        b.Show_Occurrence__c = opp.Id; 
        b.Account__c = exh.Id;
        insert b;
        
        Oracle_Show_Booth_Contact__c bc = new Oracle_Show_Booth_Contact__c();
        bc.Contact__c = c.Id;
        bc.Oracle_Show_Booth__c = b.Id;
        bc.Email__c = 'alex@vertiba.com';
        insert bc;
        
        //This unit test verifies that if the given contact (c) associated with booth contact (bc), is not already
        //a campaign member, it is added to the campaign
        
        System.debug('Campaign Id: ' + cmp.Id + ' Campaign Name: ' + cmp.Name);
        System.debug('Opportunity Id: ' + opp.Id + ' Opportunity Name: ' + opp.Name + ' Opportunity Job #: ' + opp.Job_Number__c);
        System.debug('Booth Id: ' + b.Id + ' Booth  Opportunity Id: ' + b.Show_Occurrence__c);
        System.debug('Booth Contact Id: ' + bc.Id + ' Booth Contact Email: ' + bc.Email__c);        
        
        CampaignMember cm = [SELECT Id, ContactId FROM CampaignMember WHERE CampaignId =: cmp.Id LIMIT 1];
        
        system.assertEquals(cm.ContactId, c.Id);
        
        //This unit test verifies that if the given contact (c1) associated with booth contact (bc1), is already
        //a campaign member, it should not be added to the campaign
        
        Contact c1 = new Contact();
        c1.LastName = 'lnamec1';
        c1.OwnerId = uid;
        c1.AccountId = exh.Id;
        insert c1;
        
        CampaignMember cm1 = new CampaignMember(ContactId = c1.Id, Status='Sent', Booth__c = b.Id, CampaignId = cmp.Id);
        insert cm1;
        
        Oracle_Show_Booth_Contact__c bc1 = new Oracle_Show_Booth_Contact__c();
        bc1.Contact__c = c1.Id;
        bc1.Oracle_Show_Booth__c = b.Id;
        bc1.Email__c = 'alex@vertiba.com';
        insert bc1;         
    }

}