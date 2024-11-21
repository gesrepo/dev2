@isTest
                                
public class Test_BoothTriggerHandler  
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
    
    static  testMethod void testMethod1() 
    {
        Account Facility = TestDataUtil.CreateTestFacility();
        Test.setMock(WebServiceMock.class, new SalesforceUpsertOrganisationMokup(Facility.id));
        Account Firm = TestDataUtil.CreateTestFirm();
        Account Exhibitor = TestDataUtil.CreateTestExhibitor();
        Show__c Show = TestDataUtil.CreateTestShow(Firm.Id);
        Opportunity SalesRepOpp = TestDataUtil.CreateTestSalesRepOpp(Facility.Id, Firm.Id, Show.Id);
        
        SOPService__c serv = new SOPService__c();
        serv.Name = 'Default';
        serv.URL__c = 'test';
        insert serv;
        
        SOPAuthentication__c newAuth = new SOPAuthentication__c();
        newAuth.Name = 'Login Credentials';
        newAuth.Password__c = 'lalalala';
        newAuth.Username__c = 'lalalala';
        insert newAuth;
        test.startTest();
        Oracle_Show_Booth__c Booth = new  Oracle_Show_Booth__c();
        Booth.Account__c = Exhibitor.Id;
        Booth.Show_Occurrence__c = SalesRepOpp.Id;        
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
        Booth.PROJECT_NUMBER__c = SalesRepOpp.Job_Number__c;
        Booth.SHOW_ID__c = Show.Show_ID__c;
        Booth.THIRD_PARTY_FLAG__c = false;
        Booth.SHOW_ORG_FLAG__c =  false;
        Booth.INACTIVE_FLAG__c = true;        
        //Booth.EMEA__c = True;    
        insert Booth;
        
        test.stopTest();
    }
    
    static testMethod void testMethod2() 
    {
        List<Opportunity> opp = new List<Opportunity>();
        List<Opportunity> opp1 = new List<Opportunity>();
        List<Show__c> showsList = new List<Show__c>();
        
        Account ac = new Account();
        ac.Name = 'Lucian 452245';
        insert ac;
        
        
        Account Firm = TestDataUtil.CreateTestFirm();
        Show__c Show = TestDataUtil.CreateTestShow(Firm.Id);
        
        Show__c Show1 = new Show__c();
        Show1.Sales_Person__c = UserInfo.getUserId();
        Show1.Account__c = Firm.Id;
        Show1.Name ='MyTestShow004';
        Show1.Show_Type__c = 'Food Sector';
        Show1.Show_ID__c = '987654';
        //insert Show1;
        showsList.add(Show1);
        
        Show__c Show2 = new Show__c();
        Show2.Sales_Person__c = UserInfo.getUserId();
        Show2.Account__c = Firm.Id;
        Show2.Name ='MyTestShow005';
        Show2.Show_Type__c = 'Food Sector';
        Show2.Show_ID__c = '876543';
        //insert Show2;
        showsList.add(Show2);
        
        Show__c Show3 = new Show__c();
        Show3.Sales_Person__c = UserInfo.getUserId();
        Show3.Account__c = Firm.Id;
        Show3.Name ='MyTestShow006';
        Show3.Show_Type__c = 'Food Sector';
        Show3.Show_ID__c = '876547';
        //insert Show3;
        showsList.add(Show3);
        
        Test.starttest();
        
        Opportunity op = new Opportunity();
        op.Show_Name__c = Show.Id;
        op.Amount = 1000;
        op.Name = 'Lucian1 334219';
        op.StageName = 'Prospecting';
        op.CloseDate = Date.today() + 20;
        op.Show_Close_Date__c = Date.today() + 20;
        op.AccountId = Firm.Id;
        op.RecordTypeId = [select Id from RecordType where Name = 'Master Show Occurrence' and SobjectType = 'Opportunity'].id;
        insert op;
        
        //opp1.add(op);
        
        
        Test.stoptest();
        Opportunity op2 = new Opportunity();
        op2.Show_Occurrence__c = op.Id;
        op2.Job_Number__c = '20121231';
            op2.OwnerId = UserInfo.getUserId();
            op2.Sales_Person__c = UserInfo.getUserId();
            op2.Sales_Location__c = '110- Las Vegas';
            op2.Name = 'MyTestShow # 1';
            op2.Prime_Contractor__c = null;
            op2.Production_Location__c = '110- Las Vegas';
            //op2.Facility__c = facilityId;
            op2.StageName = 'SL1';
            op2.Amount = 1000;
            op2.Probability = 25;
            op2.Type = 'ITYFTY';
            op2.New_Repeat__c = 'New';
            op2.Frequency__c = 'B1';
            op2.AccountId = Firm.Id;
            op2.Show_Name__c = Show2.Id;
            op2.RecordTypeId = [select Id from RecordType where Name = 'E&D - Projects - Proposal' and SobjectType = 'Opportunity'].id;        
            op2.Show_Open_Date__c = Date.newInstance(2012,12,1);
            op2.Show_Close_Date__c = Date.newInstance(2012,12,2);
            op2.CloseDate = Date.newInstance(2012,12,2);
        //insert op2;
        opp.add(op2);
        //opp.add(op3);
        
        insert opp;
        
        
    }
    
  /*  static testMethod void testMethod3() 
    {
        Account Firm = TestDataUtil.CreateTestFirm();
        Show__c Show = TestDataUtil.CreateTestShow(Firm.Id);
        
        List<Profile> profile = [Select Id, Name from Profile where Name = :'System Administrator'];
        String firstName = 'test';
        String lastName = 'testlast';
        User newUser = new User();
        newUser.FirstName = firstName;
        newUser.LastName = lastName;
        newUser.Email = 'test@example.com';
        newUser.Phone = '1231231234';
        newUser.LocaleSidKey = 'en_US';
        newUser.Alias = '' + firstName.left(1).toLowerCase() + firstName.left(4).toLowerCase();
        newUser.TimeZoneSidKey = 'America/Los_Angeles';
        newUser.EmailEncodingKey = 'ISO-8859-1';
        newUser.UserName = firstName + '.' + lastName + '@apexTest' + UserInfo.getUsername().substringAfter('@');
        newUser.LanguageLocaleKey = 'en_US';
        newUser.ProfileId = profile[0].Id;
        insert newUser;
        
        User newUser1 = new User();
        String firstName1 = 'tron';
        String lastName1 = 'tronlast';
        newUser1.FirstName = firstName1;
        newUser1.LastName = lastName1;
        newUser1.Email = 'test@example.com';
        newUser1.Phone = '1231231234';
        newUser1.LocaleSidKey = 'en_US';
        newUser1.Alias = '' + firstName1.left(1).toLowerCase() + firstName1.left(4).toLowerCase();
        newUser1.TimeZoneSidKey = 'America/Los_Angeles';
        newUser1.EmailEncodingKey = 'ISO-8859-1';
        newUser1.UserName = firstName1 + '.' + lastName1 + '@apexTest' + UserInfo.getUsername().substringAfter('@');
        newUser1.LanguageLocaleKey = 'en_US';
        newUser1.ProfileId = profile[0].Id;
        newUser1.national_dmu__c = newUser.Id;
        insert newUser1;
        
        System.runAs(newUser1)
        {
            Opportunity op = new Opportunity();
            op.Show_Name__c = Show.Id;
            op.Amount = 1000;
            op.Name = 'Lucian1 334219';
            op.StageName = 'Prospecting';
            op.CloseDate = Date.today() + 20;
            op.Show_Close_Date__c = Date.today() + 20;
            op.AccountId = Firm.Id;
            op.Requested_Stage__c = 'PO';
            op.RFP_Due_Date__c = Date.today()+10;
            op.GC_Account_Manager__c = newUser1.Id;
            op.RecordTypeId = [select Id from RecordType where Name = 'Master Show Occurrence' and SobjectType = 'Opportunity'].id;
            insert op;
            
            TriggerOptimizationUtility.ShowLOBDetails_Handled.clear();
        
            op.Requested_Stage__c = 'PS';
            update op;
        }
    }*/
    
    static testMethod void testMethod4() 
    {
        List<Opportunity> opp = new List<Opportunity>();
        List<Opportunity> opp1 = new List<Opportunity>();
        List<Show__c> showsList = new List<Show__c>();
        
        Account ac = new Account();
        ac.Name = 'Lucian 452245';
        insert ac;
        
        
        Account Firm = TestDataUtil.CreateTestFirm();
        Show__c Show = TestDataUtil.CreateTestShow(Firm.Id);
        
        Show__c Show1 = new Show__c();
        Show1.Sales_Person__c = UserInfo.getUserId();
        Show1.Account__c = Firm.Id;
        Show1.Name ='MyTestShow004';
        Show1.Show_Type__c = 'Food Sector';
        Show1.Show_ID__c = '987654';
        //insert Show1;
        showsList.add(Show1);
        
        Show__c Show2 = new Show__c();
        Show2.Sales_Person__c = UserInfo.getUserId();
        Show2.Account__c = Firm.Id;
        Show2.Name ='MyTestShow005';
        Show2.Show_Type__c = 'Food Sector';
        Show2.Show_ID__c = '876543';
        //insert Show2;
        showsList.add(Show2);
        
        Show__c Show3 = new Show__c();
        Show3.Sales_Person__c = UserInfo.getUserId();
        Show3.Account__c = Firm.Id;
        Show3.Name ='MyTestShow006';
        Show3.Show_Type__c = 'Food Sector';
        Show3.Show_ID__c = '876547';
        //insert Show3;
        showsList.add(Show3);
        
        Test.starttest();
        
        Opportunity op = new Opportunity();
        op.Show_Name__c = Show.Id;
        op.Amount = 1000;
        op.Name = 'Lucian1 334219';
        op.StageName = 'Prospecting';
        op.CloseDate = Date.today() + 20;
        op.Show_Close_Date__c = Date.today() + 20;
        op.AccountId = Firm.Id;
        op.RecordTypeId = [select Id from RecordType where Name = 'Master Show Occurrence' and SobjectType = 'Opportunity'].id;
        insert op;
        
        //opp1.add(op);
        
        Test.stoptest();
        
        Opportunity op2 = new Opportunity();
        op2.Show_Occurrence__c = op.Id;
        op2.Job_Number__c = '20121231';
            op2.OwnerId = UserInfo.getUserId();
            op2.Sales_Person__c = UserInfo.getUserId();
            op2.Sales_Location__c = '110- Las Vegas';
            op2.Name = 'MyTestShow # 1';
            op2.Prime_Contractor__c = null;
            op2.Production_Location__c = '110- Las Vegas';
            //op2.Facility__c = facilityId;
            op2.StageName = 'SL1';
            op2.Amount = 1000;
            op2.Probability = 25;
            op2.Type = 'ITYFTY';
            op2.New_Repeat__c = 'New';
            op2.Frequency__c = 'B1';
            op2.AccountId = Firm.Id;
            op2.Show_Name__c = Show2.Id;
            op2.RecordTypeId = [select Id from RecordType where Name = 'E&D - Projects - Proposal' and SobjectType = 'Opportunity'].id;        
            op2.Show_Open_Date__c = Date.newInstance(2012,12,1);
            op2.Show_Close_Date__c = Date.newInstance(2012,12,2);
            op2.CloseDate = Date.newInstance(2012,12,2);
        //insert op2;
        opp.add(op2);
        //opp.add(op3);
        
        insert opp;
        
        TriggerOptimizationUtility.ShowLOBDetails_Handled.clear();
        
        delete op2;
        
        
    }

    

    static  testMethod void testMethod5() 
    {
        Profile prof = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator'];
        User usr = new User(FirstName = 'Corporate Accounts', LastName ='Corp', ProfileId=prof.Id, Username ='abc@testingo.com', alias ='avvc', 
                        EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Los_Angeles', email = 'abc@abc.com');
        insert usr;
        System.runAs(usr){
        Account Facility = TestDataUtil.CreateTestFacility();
        Test.setMock(WebServiceMock.class, new SalesforceUpsertOrganisationMokup(Facility.id));
        Account Firm = TestDataUtil.CreateTestFirm();
        Account Exhibitor = TestDataUtil.CreateTestExhibitor();
        Show__c Show = TestDataUtil.CreateTestShow(Firm.Id);
        Contact ConWithAccount = TestDataUtil.CreateTestContact(Exhibitor.Id);
        Opportunity SalesRepOpp = TestDataUtil.CreateTestSalesRepOpp(Facility.Id, Firm.Id, Show.Id);
        
        SOPService__c serv = new SOPService__c();
        serv.Name = 'Default';
        serv.URL__c = 'test';
        insert serv;
        
        SOPAuthentication__c newAuth = new SOPAuthentication__c();
        newAuth.Name = 'Login Credentials';
        newAuth.Password__c = 'lalalala';
        newAuth.Username__c = 'lalalala';
        insert newAuth;
        test.startTest();
        Oracle_Show_Booth__c Booth = new  Oracle_Show_Booth__c();
        Booth.Account__c = Exhibitor.Id;
        Booth.Show_Occurrence__c = SalesRepOpp.Id;        
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
        Booth.PROJECT_NUMBER__c = SalesRepOpp.Job_Number__c;
        Booth.SHOW_ID__c = Show.Show_ID__c;
        Booth.THIRD_PARTY_FLAG__c = false;
        Booth.SHOW_ORG_FLAG__c =  false;
        Booth.INACTIVE_FLAG__c = true;        
        //Booth.EMEA__c = True;    
        insert Booth;

        Oracle_Show_Booth_Contact__c BC1 = TestDataUtil.CreateTestBoothContact(
            Booth.Id, //boothId
            ConWithAccount.Id, //conId
            702, //areaCode
            'ROLE', //conRole
            'CONTACT', //conType
            '1', //countryCode
            '1000001', //custBthId
            '0000001', //custConId
            'fnamelname@fakeemail.com', //email
            null, //extension
            null, //fax
            'First Name', //firstName
            'Last Name', //lastName
            '2630000', //phone
            'N', //primaryFlag
            '1000000'); //showOccrCustId. This field does not drive anything.

        Booth.INACTIVE_FLAG__c = false;
        Booth.Name = 'New Name';
        update Booth;

        Booth.INACTIVE_FLAG__c = true;
        Booth.Name = 'New Name';
        update Booth;
        BC1.Email__c = 'fnamelnamea@fakeemail.com';
        update BC1;
        test.stopTest();
    }
    }
   

    
}