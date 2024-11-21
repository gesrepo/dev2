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
private class TestCCXBoothContactDetailsController {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        // First Account of Record Type "Facility"
        Account Facility = TestDataUtil.CreateTestFacility(); 
        
        //Create Account of Record Type "Firm"
        Account Firm = TestDataUtil.CreateTestFirm();
        
        //Create Account of Record Type "Exhibitor"
        Account Exhibitor = TestDataUtil.CreateTestExhibitor();
        
        //Create Show
        Show__c Show = TestDataUtil.CreateTestShow(Firm.Id);
        
        //Then create Show Occurrence
        Opportunity Opp1 = TestDataUtil.CreateTestSalesRepOpp(Facility.Id, Firm.Id, Show.Id);
        
        Test.StartTest();
        //Create Booth
        Oracle_Show_Booth__c Booth = TestDataUtil.CreateTestBooth(Firm.Id, Opp1.Id, Opp1.Job_Number__c, Show.Show_ID__c);
        
        //Create Booth Contact       
        Oracle_Show_Booth_Contact__c BC1 = new Oracle_Show_Booth_Contact__c();
        
        BC1.Oracle_Show_Booth__c = Booth.Id;
        BC1.FIRST_NAME__c = 'Jimm';
        BC1.LAST_NAME__c = 'Smith';
        BC1.EMAIL__c = 'jimmsmith@ges.com';
        BC1.PHONE__c = '7022631500';
        BC1.Mailing_Street__c = '7000 Lindell Street';
        BC1.Mailing_City__c = 'Las Vegas';
        BC1.Mailing_State__c = 'NV';
        BC1.Mailing_Country__c = 'USA';
        BC1.Mailing_Postal_Code__c = '89119';
                    
        ApexPages.StandardController StdController = new ApexPages.Standardcontroller(BC1);
                
        CCXBoothContactDetailsController BCDetailsController = new CCXBoothContactDetailsController(StdController);
        
        //Test.StartTest();
        BCDetailsController.createNew();
        
        
        Contact BC2Contact = new Contact();
        BC2Contact.FirstName = 'Sahara';
        BC2Contact.LastName = 'Jones';
        BC2Contact.Email = 'sjones@ges.com';
        BC2Contact.Phone = '7022631500';
        BC2Contact.MailingStreet = '7000 Lindell Street';
        BC2Contact.MailingCity = 'Las Vegas';
        BC2Contact.MailingState = 'NV';
        BC2Contact.MailingCountry = 'USA';
        BC2Contact.MailingPostalCode = '89119';
        
        Database.insert(BC2Contact);
        
        //Create Booth Contact
        Oracle_Show_Booth_Contact__c BC2 = new Oracle_Show_Booth_Contact__c();
        
        BC2.Oracle_Show_Booth__c = Booth.Id;
        BC2.Contact__c = BC2Contact.Id;
        BC2.FIRST_NAME__c = 'Sahara';
        BC2.LAST_NAME__c = 'Jones';
        BC2.EMAIL__c = 'sjones@ges.com';
        BC2.PHONE__c = '7022631500';
        BC2.Mailing_Street__c = '7000 Lindell Street';
        BC2.Mailing_City__c = 'Las Vegas';
        BC2.Mailing_State__c = 'NV';
        BC2.Mailing_Country__c = 'USA';
        BC2.Mailing_Postal_Code__c = '89119';
        
        ApexPages.StandardController StdController2 = new ApexPages.Standardcontroller(BC2);
        CCXBoothContactDetailsController BCDetailsController2 = new CCXBoothContactDetailsController(StdController2);
       
        BCDetailsController2.createNew();
        
        BCDetailsController.updateExisting();
        
        BCDetailsController.newCase();
                
        Oracle_Show_Booth_Contact__c BC3 = new Oracle_Show_Booth_Contact__c();
        BC3.Oracle_Show_Booth__c = Booth.Id;
        
        ApexPages.StandardController StdController3 = new ApexPages.Standardcontroller(BC3);
        CCXBoothContactDetailsController BCDetailsController3 = new CCXBoothContactDetailsController(StdController3);           

        BCDetailsController3.updateExisting();
        
        ApexPages.Pagereference Pr = BCDetailsController.backToCustomPage();
        Pr = BCDetailsController.backToStandardDetailPage();
        
        Test.StopTest();
   
    }
    
    static testMethod void myUnitTest2() {
        // First Account of Record Type "Facility"
        Account Facility = TestDataUtil.CreateTestFacility(); 
        
        //Create Account of Record Type "Firm"
        Account Firm = TestDataUtil.CreateTestFirm();
        
        //Create Contact
        Contact con = TestDataUtil.CreateTestContact(Firm.Id);
        
        //Create Show
        Show__c Show = TestDataUtil.CreateTestShow(Firm.Id);
        
        //Then create Show Occurrence
        Opportunity Opp1 = TestDataUtil.CreateTestSalesRepOpp(Facility.Id, Firm.Id, Show.Id);
        
        Test.StartTest();
        //Create Booth
        Oracle_Show_Booth__c Booth = TestDataUtil.CreateTestBooth(Firm.Id, Opp1.Id, Opp1.Job_Number__c, Show.Show_ID__c);
        
        //Create Booth Contact       
        Oracle_Show_Booth_Contact__c BC1 = new Oracle_Show_Booth_Contact__c();
        
        BC1.Oracle_Show_Booth__c = Booth.Id;
        BC1.FIRST_NAME__c = 'Jimm';
        BC1.LAST_NAME__c = 'Smith';
        BC1.EMAIL__c = 'jimmsmith@ges.com';
        BC1.PHONE__c = '7022631500';
        BC1.Mailing_Street__c = '7000 Lindell Street';
        BC1.Mailing_City__c = 'Las Vegas';
        BC1.Mailing_State__c = 'NV';
        BC1.Mailing_Country__c = 'USA';
        BC1.Mailing_Postal_Code__c = '89119';
        BC1.Contact__c = con.Id;
        insert BC1;
        
        ApexPages.StandardController StdController = new ApexPages.Standardcontroller(BC1);
        CCXBoothContactDetailsController BCDetailsController = new CCXBoothContactDetailsController(StdController);
        
        //Test.StartTest();
        BCDetailsController.sendToCore();
        Test.stopTest();
    }

}