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
private class TestLogisticsCampaignMemberAssignment{

    @isTest static void testAfterInsertmeth() {
 
      /*  List<Opportunity> opps = GNT_TestUtil.createTestOpportunity(2);
        
        opps[1].StageName = 'TS';
        opps[1].Show_Close_Date__c = System.today() + 60;

       
        insert opps; */
         RecordType facilityRT = [Select Id, SobjectType, Name From RecordType WHERE Name = 'Facility' and SobjectType = 'Account' limit 1];
        RecordType masterShowRT = [Select Id, SobjectType, Name From RecordType WHERE DeveloperName = 'AV_CR' and SobjectType = 'Opportunity' limit 1];
        RecordType fieldSecurityRT = [Select Id from RecordType where DeveloperName = 'FieldSecurityLR' and SobjectType = 'Opportunity'];
        RecordType ExternalContactRT = [Select Id from RecordType where DeveloperName = 'External_Contact' and SobjectType = 'Contact'];
        Account acc = new Account(
            Name = 'Auto Show',
            Phone = '212-460-6659',
            Fax = '212-888-6523',
            BillingStreet = '1201 S Figueroa St.' ,
            BillingCity = 'Los Angeles' ,
            BillingState = 'CA',
            BillingPostalCode = '90015-1308',
            NumberOfEmployees = 500,
            AnnualRevenue = 60000000);
        Account facility = new Account(
            Name = 'Las Vegas Convention Center',
            Phone = '(702) 892-0711',
            Fax = '555-555-5555',
            BillingStreet = '43150 Paradise Rd.',
            BillingCity = 'Las Vegas',
            BillingState = 'NV' ,
            BillingPostalCode = '89109',
            NumberOfEmployees = 200,
            AnnualRevenue = 20000000,
            LMS_Facility_ID__c = '2ks9as',
            RecordTypeId = facilityRT.Id);
        List<Account> accList = new List<Account> {
            acc,
            facility
        };
        insert acclist;
        
         Show__c show = new Show__c(Show_Id__c = 'TESTSH');
       // insert show;    
        
          Opportunity showOpp = new Opportunity(
            Name = 'LA Auto Show',
            AccountId = acc.Id,
            Facility__c = facility.Id,
            CloseDate = System.Today(),
            Show_Close_Date__c = System.Today(),
            StageName = 'CV',
            Amount = 30000,
            Show_Start_Date_Time__c = System.Today() + 12,
            Show_End_Date_Time__c = System.Today() + 17,
            Exhibit_Hall_Hours_Day_1__c = '5:00 PM To 8:00 PM',
            Exhibit_Hall_Hours_Day_2__c = '7:00 AM To 6:30 PM',
            Exhibit_Hall_Hours_Day_3__c = '8:00 AM To 4:00 PM',
            Exhibit_Hall_Hours_Day_4__c = '9:00 AM To 10:00 PM',
            Exhibit_Hall_Hours_Day_5__c = '9:00 AM To 10:00 PM',
            Exhibitor_Move_In_Date__c = System.Today() + 11,
            RecordTypeId = fieldSecurityRT.Id,
            Prime_Contractor__c = acc.Id,           
         Move_Out__c = System.Today() + 14);
           // Show_Name__c = show.Id);
        insert showOpp;


  List<Opportunity> opps = new List<Opportunity>();
        for (Integer i = 0; i < 2; i++) {
            Opportunity opp = new Opportunity(
                Name = 'LA Auto Show',
                AccountId = acc.Id,
                Facility__c = facility.Id,
                CloseDate = System.Today() + 30,
                Show_Close_Date__c = System.Today() + 30,
                StageName = 'CV',
                Amount = 30000,
                Show_Start_Date_Time__c = System.Today() + 12,
                Show_End_Date_Time__c = System.Today() + 17,
                Exhibit_Hall_Hours_Day_1__c = '5:00 PM To 8:00 PM',
                Exhibit_Hall_Hours_Day_2__c = '7:00 AM To 6:30 PM',
                Exhibit_Hall_Hours_Day_3__c = '8:00 AM To 4:00 PM',
                Exhibit_Hall_Hours_Day_4__c = '9:00 AM To 10:00 PM',
                Exhibit_Hall_Hours_Day_5__c = '9:00 AM To 10:00 PM',
                Exhibitor_Move_In_Date__c = System.Today() + 11,
                RecordTypeId = masterShowRT.Id,
                 Move_Out__c = System.Today() + 14);
               // Show_Occurrence__c = showOpp.Id);
            opps.add(opp);
        }
        
        
         /* ------------------------------------------- before ------------------------*/
        ID OwnerId = UserInfo.getUserId();
        
        //Create User Sales Person
        ID SalesRepId = UserInfo.getUserId();
        
        RecordType FacilityRecordType = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Facility'];
        Id FacilityRecordTypeId = FacilityRecordType.Id;
                
        RecordType ExhibitorRecordType = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Exhibitor'];
        Id ExhibitorRecordTypeId = ExhibitorRecordType.Id;
                
        RecordType SalesRepOpportunityRecordType = [Select Id From RecordType Where SObjectType = 'Opportunity' And Name = 'E&D - Projects'];
        Id SalesRepOpportunityRecordTypeId = SalesRepOpportunityRecordType.Id;
     
         List<User> LoUsers = [Select Id, LastName, FirstName, Email From User Where Profile.Name = 'GES Service' And IsActive = true];
        
         CustomUserObject CustUsr = new CustomUserObject();
         
         list<CustomUserObject> LoCustomUsers = new list<CustomUserObject>();
               
               
                  //Create Facility Account
       /* Account Facility = new Account();
        Facility.Sales_Person__c = SalesRepId;
        Facility.Name = 'MyTestFacilityName-LCMA';
        Facility.Type = 'Hotel';
        Facility.GES_Status__c = 'Preferred';
        Facility.LMS_Facility_ID__c = 'ABCFAC';
        Facility.BillingStreet = '950 Grier Dr';
        Facility.BillingCity = 'Las Vegas';
        Facility.BillingPostalCode = '89119-0000';
        Facility.BillingState = 'NV';
        Facility.BillingCountry = 'US';
        Facility.RecordTypeId = FacilityRecordTypeId; */
        
        //Create Exhibitor Account
        Account Exhibitor1 = new Account();
        Exhibitor1.Sales_Person__c = SalesRepId;
        Exhibitor1.Name = 'SONY ENTERTAINMENT INC-LCMA 1';
        Exhibitor1.Phone = '7022631500';
        Exhibitor1.BillingStreet = '950 Grier Dr';
        Exhibitor1.BillingCity = 'Las Vegas';
        Exhibitor1.BillingPostalCode = '89119-0000';
        Exhibitor1.BillingState = 'NV';
        Exhibitor1.BillingCountry = 'US';
        Exhibitor1.RecordTypeId = ExhibitorRecordTypeId;
        
        insert Exhibitor1;
        
        //Create Exhibitor Account
        Account Exhibitor2 = new Account();
        Exhibitor2.Sales_Person__c = SalesRepId;
        Exhibitor2.Name = 'SONY ENTERTAINMENT INC-LCMA 2';
        Exhibitor2.Phone = '7022631500';
        Exhibitor2.BillingStreet = '950 Grier Dr';
        Exhibitor2.BillingCity = 'Las Vegas';
        Exhibitor2.BillingPostalCode = '89119-0000';
        Exhibitor2.BillingState = 'NV';
        Exhibitor2.BillingCountry = 'US';
        Exhibitor2.RecordTypeId = ExhibitorRecordTypeId;
        
        insert Exhibitor2;
        
        //Create Exhibitor Account
        Account Exhibitor3 = new Account();
        Exhibitor3.Sales_Person__c = SalesRepId;
        Exhibitor3.Name = 'SONY ENTERTAINMENT INC-LCMA 3';
        Exhibitor3.Phone = '7022631500';
        Exhibitor3.BillingStreet = '950 Grier Dr';
        Exhibitor3.BillingCity = 'Las Vegas';
        Exhibitor3.BillingPostalCode = '89119-0000';
        Exhibitor3.BillingState = 'NV';
        Exhibitor3.BillingCountry = 'US';
        Exhibitor3.RecordTypeId = ExhibitorRecordTypeId;
        
        insert Exhibitor3;
        
        //Create Exhibitor Account
        Account Exhibitor4 = new Account();
        Exhibitor4.Sales_Person__c = SalesRepId;
        Exhibitor4.Name = 'SONY ENTERTAINMENT INC-LCMA 4';
        Exhibitor4.Phone = '7022631500';
        Exhibitor4.BillingStreet = '950 Grier Dr';
        Exhibitor4.BillingCity = 'Las Vegas';
        Exhibitor4.BillingPostalCode = '89119-0000';
        Exhibitor4.BillingState = 'NV';
        Exhibitor4.BillingCountry = 'US';
        Exhibitor4.RecordTypeId = ExhibitorRecordTypeId;
        
        insert Exhibitor4;
                
        
       
         
        //Create Booth
        Oracle_Show_Booth__c Booth1 = new Oracle_Show_Booth__c();
        
        Booth1.CONTACT_PHONE_AREA_CODE__c = 702;
        Booth1.BOOTH_CREATION_DATE__c = Datetime.now();
        Booth1.BOOTH_ID__c = '1000';
        Booth1.BOOTH_LAST_UPDATE_DATE__c = Datetime.now();
        Booth1.BOOTH_SHARED_FLAG__c = 'Y';
        Booth1.BOOTH_TYPE__c = 'Inline';
        Booth1.BOOTH_NUMBER__c = 'Z1000';
        Booth1.BOOTH_LENGTH__c = 10;
        Booth1.Booth_Name_Searchable__c = '01100531998 SONY ENTERTAINMENT INC-LCMA 1';
        Booth1.BOOTH_SIZE__c = 300;
        Booth1.BOOTH_WIDTH__c = 10;
        Booth1.CONTACT_PHONE_COUNTRY_CODE__c = '1';
        Booth1.CUST_ACCOUNT_ID__c = '10001';
        Booth1.CUST_CONT_ID__c = '10002';
        Booth1.ED_FLAG__c = false;
        Booth1.CONTACT_EMAIL__c = 'integrationissue@ges.com';
        Booth1.Account__c = Exhibitor1.Id;
        Booth1.Exhibitor_Name_Denormalized__c = 'SONY ENTERTAINMENT INC-LCMA 1';
        Booth1.CONTACT_PHONE_EXTENSION__c = 1500;
        Booth1.CONTACT_FAX__c = '7022631501';
        Booth1.CONTACT_FIRST_NAME__c = 'Jimmy';
        Booth1.INACTIVE_FLAG__c = false;
        Booth1.CONTACT_LAST_NAME__c = 'Johnson';
        Booth1.Logistics_Sales_Stage__c = 'Qualification';
        Booth1.CONTACT_PHONE__c = '2631500';
        Booth1.PROJECT_NUMBER__c = '01100531998';
        Booth1.SHOW_ID__c = 'CES';
        Booth1.Show_Name_Denormalized__c = 'International CES';
        //Booth1.Show_Occurrence__c = opps[1].Id; 
        Booth1.Show_Occurrence__c = showOpp.Id;
        Booth1.SHOW_ORG_FLAG__c = false;
        Booth1.THIRD_PARTY_FLAG__c = false;
        
        database.insert(Booth1);
        
        Oracle_Show_Booth__c Booth2 = new Oracle_Show_Booth__c();
        
        Booth2.CONTACT_PHONE_AREA_CODE__c = 702;
        Booth2.BOOTH_CREATION_DATE__c = Datetime.now();
        Booth2.BOOTH_ID__c = '2000';
        Booth2.BOOTH_LAST_UPDATE_DATE__c = Datetime.now();
        Booth2.BOOTH_SHARED_FLAG__c = 'Y';
        Booth2.BOOTH_TYPE__c = 'Inline';
        Booth2.BOOTH_NUMBER__c = 'Z2000';
        Booth2.BOOTH_LENGTH__c = 10;
        Booth2.Booth_Name_Searchable__c = '01100531998 SONY ENTERTAINMENT INC-LCMA 2';
        Booth2.BOOTH_SIZE__c = 400;
        Booth2.BOOTH_WIDTH__c = 10;
        Booth2.CONTACT_PHONE_COUNTRY_CODE__c = '1';
        Booth2.CUST_ACCOUNT_ID__c = '10002';
        Booth2.CUST_CONT_ID__c = '10002';
        Booth2.ED_FLAG__c = false;
        Booth2.CONTACT_EMAIL__c = 'integrationissue@ges.com';
        Booth2.Account__c = Exhibitor2.Id;
        Booth2.Exhibitor_Name_Denormalized__c = 'SONY ENTERTAINMENT INC-LCMA 2';
        Booth2.CONTACT_PHONE_EXTENSION__c = 1500;
        Booth2.CONTACT_FAX__c = '7022631501';
        Booth2.CONTACT_FIRST_NAME__c = 'Jimmy';
        Booth2.INACTIVE_FLAG__c = false;
        Booth2.CONTACT_LAST_NAME__c = 'Johnson';
        Booth2.Logistics_Sales_Stage__c = 'Qualification';
        Booth2.CONTACT_PHONE__c = '2631500';
        Booth2.PROJECT_NUMBER__c = '01100531998';
        Booth2.SHOW_ID__c = 'CES';
        Booth2.Show_Name_Denormalized__c = 'International CES';
        Booth2.Show_Occurrence__c = showOpp.Id;
        Booth2.SHOW_ORG_FLAG__c = false;
        Booth2.THIRD_PARTY_FLAG__c = false;
        
        database.insert(Booth2);
        
        Oracle_Show_Booth__c Booth3 = new Oracle_Show_Booth__c();
        
        Booth3.CONTACT_PHONE_AREA_CODE__c = 702;
        Booth3.BOOTH_CREATION_DATE__c = Datetime.now();
        Booth3.BOOTH_ID__c = '3000';
        Booth3.BOOTH_LAST_UPDATE_DATE__c = Datetime.now();
        Booth3.BOOTH_SHARED_FLAG__c = 'Y';
        Booth3.BOOTH_TYPE__c = 'Inline';
        Booth3.BOOTH_NUMBER__c = 'Z3000';
        Booth3.BOOTH_LENGTH__c = 200;
        Booth3.Booth_Name_Searchable__c = '01100531998 SONY ENTERTAINMENT INC-LCMA 1';
        Booth3.BOOTH_SIZE__c = 100;
        Booth3.BOOTH_WIDTH__c = 10;
        Booth3.CONTACT_PHONE_COUNTRY_CODE__c = '1';
        Booth3.CUST_ACCOUNT_ID__c = '10003';
        Booth3.CUST_CONT_ID__c = '10003';
        Booth3.ED_FLAG__c = false;
        Booth3.CONTACT_EMAIL__c = 'integrationissue@ges.com';
        Booth3.Account__c = Exhibitor3.Id;
        Booth3.Exhibitor_Name_Denormalized__c = 'SONY ENTERTAINMENT INC-LCMA 1';
        Booth3.CONTACT_PHONE_EXTENSION__c = 1500;
        Booth3.CONTACT_FAX__c = '7022631501';
        Booth3.CONTACT_FIRST_NAME__c = 'Jimmy';
        Booth3.INACTIVE_FLAG__c = false;
        Booth3.CONTACT_LAST_NAME__c = 'Johnson';
        Booth3.Logistics_Sales_Stage__c = 'Qualification';
        Booth3.CONTACT_PHONE__c = '2631500';
        Booth3.PROJECT_NUMBER__c = '01100531998';
        Booth3.SHOW_ID__c = 'CES';
        Booth3.Show_Name_Denormalized__c = 'International CES';
        Booth3.Show_Occurrence__c = showOpp.Id;
        Booth3.SHOW_ORG_FLAG__c = false;
        Booth3.THIRD_PARTY_FLAG__c = false;
        
        database.insert(Booth3); 
        
        Oracle_Show_Booth__c Booth4 = new Oracle_Show_Booth__c();
        
        Booth4.CONTACT_PHONE_AREA_CODE__c = 702;
        Booth4.BOOTH_CREATION_DATE__c = Datetime.now();
        Booth4.BOOTH_ID__c = '4000';
        Booth4.BOOTH_LAST_UPDATE_DATE__c = Datetime.now();
        Booth4.BOOTH_SHARED_FLAG__c = 'Y';
        Booth4.BOOTH_TYPE__c = 'Inline';
        Booth4.BOOTH_NUMBER__c = 'Z4000';
        Booth4.BOOTH_LENGTH__c = 10;
        Booth4.Booth_Name_Searchable__c = '01100531998 SONY ENTERTAINMENT INC-LCMA 4';
        Booth4.BOOTH_SIZE__c = 200;
        Booth4.BOOTH_WIDTH__c = 10;
        Booth4.CONTACT_PHONE_COUNTRY_CODE__c = '1';
        Booth4.CUST_ACCOUNT_ID__c = '10004';
        Booth4.CUST_CONT_ID__c = '10004';
        Booth4.ED_FLAG__c = false;
        Booth4.CONTACT_EMAIL__c = 'integrationissue@ges.com';
        Booth4.Account__c = Exhibitor4.Id;
        Booth4.Exhibitor_Name_Denormalized__c = 'SONY ENTERTAINMENT INC-LCMA 1';
        Booth4.CONTACT_PHONE_EXTENSION__c = 1500;
        Booth4.CONTACT_FAX__c = '7022631501';
        Booth4.CONTACT_FIRST_NAME__c = 'Jimmy';
        Booth4.INACTIVE_FLAG__c = false;
        Booth4.CONTACT_LAST_NAME__c = 'Johnson';
        Booth4.Logistics_Sales_Stage__c = 'Qualification';
        Booth4.CONTACT_PHONE__c = '2631500';
        Booth4.PROJECT_NUMBER__c = '01100531998';
        Booth4.SHOW_ID__c = 'CES';
        Booth4.Show_Name_Denormalized__c = 'International CES';
        Booth4.Show_Occurrence__c = showOpp.Id;
        Booth4.SHOW_ORG_FLAG__c = false;
        Booth4.THIRD_PARTY_FLAG__c = false;
        
        database.insert(Booth4); 
        
        Contact Contact1 = new Contact();
        Contact1.FirstName = 'Jim';
        Contact1.LastName = 'Jones';
        Contact1.AccountId = acc.Id;
        Contact1.Email = 'jimjones@fakeges.com';
        Contact1.Phone =  '2631500'; //Amarab 7/26/2017 
        Contact1.RecordTypeId = ExternalContactRT.Id; //Amarab 7/26/2017 
        
        
        database.insert(Contact1);
        
        Contact Contact2 = new Contact();
        Contact2.FirstName = 'Jane';
        Contact2.LastName = 'Jones';
        Contact2.AccountId = acc.Id;
        Contact2.Email = 'janejones@fakeges.com';
        Contact2.Phone =  '2631500'; //Amarab 7/26/2017 
        Contact2.RecordTypeId = ExternalContactRT.Id; //Amarab 7/26/2017
        
        database.insert(Contact2);
        
        Contact Contact3 = new Contact();
        Contact3.FirstName = 'Jake';
        Contact3.LastName = 'Jones';
        Contact3.AccountId = acc.Id;
        Contact3.Email = 'jakejones@fakeges.com';
        Contact3.Phone =  '2631500'; //Amarab 7/26/2017 
        Contact3.RecordTypeId = ExternalContactRT.Id; //Amarab 7/26/2017
        
        database.insert(Contact3);
        
        Contact Contact4 = new Contact();
        Contact4.FirstName = 'Jill';
        Contact4.LastName = 'Jones';
        Contact4.AccountId = acc.Id;
        Contact4.Email = 'jilljones@fakeges.com';
        Contact4.Phone =  '2631500'; //Amarab 7/26/2017 
        Contact4.RecordTypeId = ExternalContactRT.Id; //Amarab 7/26/2017
        
        database.insert(Contact4);        
        
        test.starttest();
        Oracle_Show_Booth_Contact__c BoothContact1 = new Oracle_Show_Booth_Contact__c();
        BoothContact1.AREA_CODE__c = 702;
        BoothContact1.Contact__c = Contact1.Id;
        BoothContact1.CUST_BOOTH_ID__c = Booth1.BOOTH_ID__c;
        BoothContact1.CUST_CONT_ID__c = '1';
        BoothContact1.EMAIL__c = 'jimjones@fakeges.com';
        BoothContact1.FIRST_NAME__c = 'Jim';
        BoothContact1.LAST_NAME__c = 'Jones';
        BoothContact1.Oracle_Show_Booth__c = Booth1.Id;
        BoothContact1.PRIMARY_FLAG__c = 'Y';
        
        database.insert(BoothContact1);
        
        Oracle_Show_Booth_Contact__c BoothContact2 = new Oracle_Show_Booth_Contact__c();
        BoothContact2.AREA_CODE__c = 702;
        BoothContact2.Contact__c = Contact2.Id;
        BoothContact2.CUST_BOOTH_ID__c = Booth2.BOOTH_ID__c;
        BoothContact2.CUST_CONT_ID__c = '2';
        BoothContact2.EMAIL__c = 'janejones@fakeges.com';
        BoothContact2.FIRST_NAME__c = 'Jane';
        BoothContact2.LAST_NAME__c = 'Jones';
        BoothContact2.Oracle_Show_Booth__c = Booth2.Id;
        BoothContact2.PRIMARY_FLAG__c = 'Y';        
        
        database.insert(BoothContact2);
        
        Oracle_Show_Booth_Contact__c BoothContact3 = new Oracle_Show_Booth_Contact__c();
        BoothContact3.AREA_CODE__c = 702;
        BoothContact3.Contact__c = Contact3.Id;
        BoothContact3.CUST_BOOTH_ID__c = Booth3.BOOTH_ID__c;
        BoothContact3.CUST_CONT_ID__c = '3';
        BoothContact3.EMAIL__c = 'jakejones@fakeges.com';
        BoothContact3.FIRST_NAME__c = 'Jake';
        BoothContact3.LAST_NAME__c = 'Jones';
        BoothContact3.Oracle_Show_Booth__c = Booth3.Id;
        BoothContact3.PRIMARY_FLAG__c = 'Y';            
        
        database.insert(BoothContact3);
        
        Oracle_Show_Booth_Contact__c BoothContact4 = new Oracle_Show_Booth_Contact__c();
        BoothContact4.AREA_CODE__c = 702;
        BoothContact4.Contact__c = Contact4.Id;
        BoothContact4.CUST_BOOTH_ID__c = Booth4.BOOTH_ID__c;
        BoothContact4.CUST_CONT_ID__c = '4';
        BoothContact4.EMAIL__c = 'jilljones@fakeges.com';
        BoothContact4.FIRST_NAME__c = 'Jill';
        BoothContact4.LAST_NAME__c = 'Jones';
        BoothContact4.Oracle_Show_Booth__c = Booth4.Id;
        BoothContact3.PRIMARY_FLAG__c = 'Y'; 
        
        database.insert(BoothContact4);
        
        Oracle_Show_Booth_Contact__c BoothContact5 = new Oracle_Show_Booth_Contact__c(); //Duplicate Contact Contact 4 on different Booth
        BoothContact5.AREA_CODE__c = 702;
        BoothContact5.Contact__c = Contact4.Id;
        BoothContact5.CUST_BOOTH_ID__c = Booth3.BOOTH_ID__c;
        BoothContact5.CUST_CONT_ID__c = '31';
        BoothContact5.EMAIL__c = 'jilljones@fakeges.com';
        BoothContact5.FIRST_NAME__c = 'Jill';
        BoothContact5.LAST_NAME__c = 'Jones';
        BoothContact5.Oracle_Show_Booth__c = Booth3.Id; 
        
        database.insert(BoothContact5);         
        
       
        Campaign ParentCamp = new Campaign();
        ParentCamp.OwnerId = LoUsers[0].Id;
        ParentCamp.Name = 'Test Campagign' + showOpp.Id;
        ParentCamp.IsActive = true;
        ParentCamp.Opportunity__c = showOpp.Id;
        
        database.insert(ParentCamp);        
        
        Campaign ChildCamp = new Campaign(); //Tests FetchShowContactCount ChildCampaigns not null loop
        ChildCamp.OwnerId = LoUsers[0].Id;
        ChildCamp.Name = 'Test Child Campagign' + showOpp.Id;
        ChildCamp.IsActive = true;
        ChildCamp.Status = 'Planned';
        ChildCamp.ParentId = ParentCamp.Id;     
        
        database.insert(ChildCamp);
        
        Campaign ChildCamp2 = new Campaign(); //Tests FetchShowContactCount While iterating over LoCampaignMembers - CampId != cm.CampaignId 
        ChildCamp2.OwnerId = LoUsers[0].Id;
        ChildCamp2.Name = 'Test Child Campagign 2' + showOpp.Id;
        ChildCamp2.IsActive = true;
        ChildCamp2.Status = 'Planned';
        ChildCamp2.ParentId = ParentCamp.Id;    
        
        database.insert(ChildCamp2);        
        
        CampaignMember CampaignMember1 = new  CampaignMember(); //Tests FetchShowContactCount ChildCampaignMembers not null loop
        CampaignMember1.ContactId = Contact4.Id;
        CampaignMember1.Booth__c = Booth4.Id;
        CampaignMember1.CampaignId = ChildCamp.Id;
        
        database.insert(CampaignMember1);
        
        
        ApexPages.Pagereference LcmaPage = new ApexPages.Pagereference('/apex/PageLogisticsCampaignMemberAssignment');
        LcmaPage.getParameters().put('id', ParentCamp.Id);
        
        Test.setCurrentPage(LcmaPage);
          try{
        LogisticsCampaignMemberAssignment  Lcma = new  LogisticsCampaignMemberAssignment();
        
        Lcma.setParentCampaign(ParentCamp.Id);
        
        System.assert(Lcma.ParentCampaign.Id != null);
        
        List<SelectOption> DmOptions = Lcma.getDistributionMethodOptions();
        List<SelectOption> PageSizeOptions = Lcma.getPageSizeOptions();
        List<SelectOption> ProfileOptions = Lcma.getProfileOptions();
        List<SelectOption> NSFFilterOperators = Lcma.getNSFFilterOperatorOptions();
        List<SelectOption> UncheckOptions = Lcma.getRowUncheckActionOptions();
        List<SelectOption> CheckOptions = Lcma.getRowCheckActionOptions();
        List<SelectOption> CheckOptions1 = Lcma.getIncludeCustomersDomIntlOptions();
        ApexPages.currentPage().getParameters().put('operator','>');
        Lcma.includCustomersDomIntlChanged();        
        String dm = Lcma.DistributionMethod;
        Lcma.DistributionMethod = 'Count';
        
        String cprofile = Lcma.SelectedProfile;
        
        Lcma.SelectedProfile = 'GES Service'; //'GES Exhibitor Sales Admin'; //This will also test the 'refreshCustomUsersListProfileChanged' method
        //Lcma.SelectedProfile = 'GES Exhibitor Sales';
                
        Integer ps = Lcma.pagesize;
        
        Lcma.SelectAllUsers(Lcma.ShowContactCount);
        
        Lcma.pageSize = 2; //This is also going to test 'UpdatePageSet' method and set pagenumber
        Integer PageNumber = Lcma.pageNumber;
        
        Boolean HasNext = Lcma.HasNext;
        Boolean HasPrevious = Lcma.HasPrevious;
        Boolean HasMultiplePages = Lcma.hasMultiplePages;
        
        System.assert(Lcma.LoCustomUsers.size() > 0);
        System.assert(Lcma.PageSize > 0);
        System.assert(Lcma.PageNumber > 0);
        
        LcmaPage.getParameters().put('CurrentPageNumber','1');
        Lcma.next();
        
        LcmaPage.getParameters().put('CurrentPageNumber','2');
        Lcma.previous();
        
        Lcma.last();
        Lcma.first();
        
        
        Lcma.UnselectAll();
        Lcma.SelectAll();
        
        LcmaPage.getParameters().put('UserId', Lcma.LoCustomUsersPageSet[0].Id);
        LcmaPage.getParameters().put('CheckValue','true');
        Lcma.rowCheckboxChanged();
        
        LcmaPage.getParameters().put('CheckValue','false');
        Lcma.rowCheckboxChanged();
        
        Lcma.rowCountChanged();
        
        LcmaPage.getParameters().put('operator','>');
        Lcma.nsfFilterOperatorChanged();
        
        LcmaPage.getParameters().put('method','count');
        LcmaPage.getParameters().put('count','10');
        LcmaPage.getParameters().put('percent','100');
        Lcma.DistributionMethod = 'COUNT';
        Lcma.distributionMethodChanged();
        
        LcmaPage.getParameters().put('count','1');
        Lcma.DistributionMethod = 'COUNT';
        Lcma.distributionMethodChanged();   
        
        LcmaPage.getParameters().put('method','percent');
        LcmaPage.getParameters().put('count','1');
        LcmaPage.getParameters().put('percent','5');
        Lcma.DistributionMethod = 'PERCENT';
        Lcma.distributionMethodChanged(); 
        
        LcmaPage.getParameters().put('percent','110');
        Lcma.DistributionMethod = 'PERCENT'; 
        Lcma.distributionMethodChanged();
        
       Lcma.FetchShowContactCount(0);
        
        Lcma.NSFValue = null;
        Lcma.FetchShowContactCount(0);
        
        Lcma.NSFValue = 400;
        Lcma.NSFFilterOperator = '>=';
       
       try{ 
          Lcma.FetchShowContactCount(0);
        }catch(exception e){}
        
        Lcma.NSFFilterOperator = '<';
          
        try{ 
         Lcma.FetchShowContactCount(0);
        }catch(exception e){}
        
        Lcma.NSFFilterOperator = '<=';
        try{ 
        Lcma.FetchShowContactCount(0);
        }catch(exception e){}
        
        Lcma.NSFFilterOperator = '=';
      
        try{ 
         Lcma.FetchShowContactCount(0);
        }catch(exception e){}
        
        try{ 
         Lcma.FetchShowContactCount(10);
        }catch(exception e){}
       
        
        ApexPages.PageReference Pg;
        
        Pg = Lcma.Redistribute();
                
        LcmaPage.getParameters().put('nsf','700');
        
         try{
         Lcma.nsfChanged();
        }catch(exception e){}
               
         try{
         Lcma.customersToExcludeChanged();
         }catch(exception e){}
          try{
         Lcma.CreateCampaign(ParentCamp.Id,LoCustomUsers);
          }catch(exception e){}
           try{
         Lcma.CreateCampaignMembers(ParentCamp.Id,LoCustomUsers);
          }catch(exception e){}
         /* try{      
        Lcma.Assign();
         }catch(exception e){}*/
       } catch(exception e){}
        test.stoptest();
       
        
       
    }
    


}