@isTest
public class Emea_StandBatchUploadTest {

    @isTest static void test_Booth_Upload_API()
	{
        Opportunity op1 = CreateOpportunity();
        Booth_Upload_API_User__c testUser = CreateTestUser();
        List<Emea_StandBatchUpload.Emea_StandItemDetails> stands = CreateStands();
        
        CreateCountries();
        
        system.debug('stands: ' + stands);
        Test.startTest();
        Emea_StandBatchUpload.Emea_BoothAPIUpload_Response response = Emea_StandBatchUpload.createBoothUpload(testUser.User_Email__c, 'InvalidPassword', op1.Id, stands);
        
        system.debug('Response Test 1: ' + response);
        
        response = Emea_StandBatchUpload.createBoothUpload(testUser.User_Email__c, 'KeepOut', op1.Id, stands);
        
        system.debug('Response Test 2: ' + response);
            
        
        Test.stopTest();
    }
    
    static List<Emea_StandBatchUpload.Emea_StandItemDetails> CreateStands()
    {
        List<Emea_StandBatchUpload.Emea_StandItemDetails> stands = new List<Emea_StandBatchUpload.Emea_StandItemDetails>();
        Emea_StandBatchUpload.Emea_StandItemDetails stand = new Emea_StandBatchUpload.Emea_StandItemDetails();
        
        stand.CompanyName = 'JSB';
        stand.FirstName = 'Helen';
        stand.LastName = 'Brook';
        stand.Email = 'hjbrook@jsbtextiles.co.uk';
        stand.Address_1 = '10 Brook Street';
        stand.address_2 = '';
        stand.address_3 = '';
        stand.State_County = 'West Midlands';
        stand.PostZip_Code = 'CV5 7GF';
        stand.Country = 'GB';
        stand.Town = 'Coventry';
        stand.Fax = '';
        stand.Stand_Number = 'H76';
        stand.Operational = '';
        stand.Stand_Type = 'Space';
        stand.Booth_Size = 10;
        stand.Booth_Width = '5';
        stand.Booth_Length = '5';
        stand.Phone_Number = '02476 380260';
        stand.Open_Sides = 0;
        stand.WWW = 'www.textiles.com';
        stand.Errors = '';
        stand.Nameboard_Name = 'JSB Textiles';
        stand.Mobile = '079718214547';
        stand.Booth_Height = 0;
        stand.Vat_Number = '87779878';
        stand.Service_Zone = 'Sleep';
        
        stands.add(stand);
        
        Emea_StandBatchUpload.Emea_StandItemDetails stand2 = new Emea_StandBatchUpload.Emea_StandItemDetails();
        
        stand2.CompanyName = 'JSB';
        stand2.FirstName = 'Helen';
        stand2.LastName = 'Brook';
        stand2.Email = '-';
        stand2.Address_1 = '10 Brook Street';
        stand2.address_2 = '';
        stand2.address_3 = '';
        stand2.State_County = 'West Midlands';
        stand2.PostZip_Code = 'CV5 7GF';
        stand2.Country = 'GB';
        stand2.Town = 'Coventry';
        stand2.Fax = '';
        stand2.Stand_Number = 'H76';
        stand2.Operational = '';
        stand2.Stand_Type = 'Space';
        stand2.Booth_Size = 10;
        stand2.Booth_Width = '5';
        stand2.Booth_Length = '5';
        stand2.Phone_Number = '02476 380260';
        stand2.Open_Sides = 0;
        stand2.WWW = 'www.textiles.com';
        stand2.Errors = '';
        stand2.Nameboard_Name = 'JSB Textiles';
        stand2.Mobile = '079718214547';
        stand2.Booth_Height = 0;
        stand2.Vat_Number = '87779878';
        stand2.Service_Zone = 'Sleep';
        stands.add(stand2);
        
        return stands;
    }
    
    static Booth_Upload_API_User__c CreateTestUser()
    {
        Booth_Upload_API_User__c testUser = new Booth_Upload_API_User__c();
        
        testUser.User__c = 'test@ges.com';
        testUser.User_Email__c = 'test@ges.com';
        testUser.User_Password__c = 'KeepOut';
        testUser.Password__c =  'KeepOut';
        Account userAccount = CreateUserAccount();
        testUser.Organiser__c = userAccount.Id;
        
        insert testUser;
        
        return testUser;
    }

	static Account CreateUserAccount()
    {
        Id accRT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('International').getRecordTypeId();
        
        Account account = new Account();

		account.RecordTypeId = accRT;
        
        
        account.EMEA__c = true;
        account.Name = 'GES SDD';
        account.BillingStreet = 'Parkway Business Park, Parkway Dr';
        account.BillingCity = 'Sheffield';
        account.BillingState = 'South Yorkshire';
        account.BillingPostalCode = 'S9 4WN';
        account.BillingCountry = 'UK';
        account.Phone = '+44 114 231 7810';
        
        insert account;
                
        return account;
    }
    
    static Opportunity CreateOpportunity()
	{
		Opportunity op1 = new Opportunity();
		op1.Name = 'opp1';
		op1.stageName = 'oppStage';
		op1.closeDate = Date.today();
	
		insert op1;

		return op1;
	}
    
    static void CreateCountries()
	{
        country_transformation__c country = new country_transformation__c();
        country.name = 'United Kingdom';
        country.Output_Country_Code__c = 'GB';
        insert country;
	}
}