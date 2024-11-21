/*************************************************************************************************
Class     :  BoothUploadProcessingBatchTest.cls
Developer :  marian.iovi@vertiba.com
Created   :  -
Modified  :  August 25, 2016
Objective :  This class provides test methods for BoothUploadProcessingBatch.cls

*************************************************************************************************/

@isTest
private class BoothUploadProcessingBatchTest {
    
        @isTest static void test_Booth_Upload()
    {   
        User ADMIN_USER = [SELECT Id FROM User WHERE Profile.Name = 'EMEA System Administrator' AND isActive = true LIMIT 1];
        System.runAs(ADMIN_USER){
            
            Account firm = CreateAccount();
            /*List<Contact> conList = new List<Contact>();
            Contact c1 = new Contact(SOP_Sync__c = true,FirstName = 'Joe',LastName = 'Bloggs',Email='1@1.com',AccountId=firm.Id,MailingPostalCode='qq88 7hh');
            Contact c2 = new Contact(SOP_Sync__c = true,FirstName = 'Jane',LastName = 'Bloggs',Email='1@1.com',AccountId=firm.Id,MailingPostalCode='qq88 7hh');
            conList.add(c1);
            conList.add(c2);
            insert conList;*/
            Show__C show = CreateShow(firm);
            SOPAuthentication__c newAuth = new SOPAuthentication__c();
            newAuth.Name = 'Login Credentials';
            newAuth.Password__c = 'lalalala';
            newAuth.Username__c = 'lalalala';
            insert newAuth;      

            SOPService__c serv = new SOPService__c();
            serv.Name = 'Default';
            serv.URL__c = 'test';
            insert serv;
            
            Test.startTest();   
            Opportunity op1 = CreateOpportunity(show, firm);
            
            /*Oracle_Show_Booth__c oracleBooth = new Oracle_Show_Booth__c();
            oracleBooth.BOOTH_NUMBER__c = '23';
            oracleBooth.Account__c = firm.Id;
            oracleBooth.Name = 'Booth Name';
            oracleBooth.Show_Occurrence__c = op1.Id;
            insert oracleBooth;
            
            Oracle_Show_Booth_Contact__c oracleVar = new Oracle_Show_Booth_Contact__c();
            oracleVar.FIRST_NAME__c = 'Joe';
            oracleVar.LAST_NAME__c = 'Bloggs';
            oracleVar.Mailing_Postal_Code__c ='45345235';
            oracleVar.Oracle_Show_Booth__c = oracleBooth.Id;
            oracleVar.Contact__c = c1.Id;
            insert oracleVar;
            
            Oracle_Show_Booth_Contact__c oracleVar2 = new Oracle_Show_Booth_Contact__c();
            oracleVar2.FIRST_NAME__c = 'Jane';
            oracleVar2.LAST_NAME__c = 'Bloggs';
            oracleVar2.Mailing_Postal_Code__c ='45345235';
            oracleVar2.Oracle_Show_Booth__c = oracleBooth.Id;
            oracleVar2.Contact__c = c2.Id;
            insert oracleVar2;*/
            
            Oracle_Show_Booth__c oracleBooth = new Oracle_Show_Booth__c();
            oracleBooth.BOOTH_NUMBER__c = 'A1234';
            oracleBooth.Account__c = firm.Id;
            oracleBooth.Name = 'Booth Name';
            oracleBooth.Show_Occurrence__c = op1.Id;
            insert oracleBooth;
            
            Booth_Upload__c bu = CreateBoothUpload(op1);
            List<Booth_Staging__c> staging = new List<Booth_Staging__c>();
            CreateCountries();

            Booth_Staging__c b = CreateStaging(bu, 'Company B LTD', 'High street', 'the road', 'the village', 'big town', 'shires', 'qq88 7hh', 'GB', '33', 22, '11', '1@1.com', 'Joe', 'Bloggs', '654654654', '3213213213', 
                                                    'A1234', 'Operational Zone', 'Space', 2, 'www.google.com', 'Company B', '987987987', 44, 'GBqwerty1234', 'asdf2222');
            staging.add(b);
            
            Booth_Staging__c b16 = CreateStaging(bu, 'Company B LTD', 'High street', 'the road', 'the village', 'big town', 'shires', 'qq88 7hh', 'GB', '33', 22, '11', '1@1.com', 'Joe', 'Bloggs', '654654654', '3213213213', 
                                                    'A1234', 'Operational Zone', 'Space', 2, 'www.google.com', 'Company B', '987987987', 44, 'GBqwerty1234', 'asdf2222');
            staging.add(b16);
            
            Booth_Staging__c b2a = CreateStaging(bu, 'Company B LTD', 'High street', 'the road', 'the village', 'big town', 'shires', 'qq88 7hh', 'GB', '33', 22, '11', '1@1.com', 'Jane', 'Bloggs', '654654654', '3213213213', 
                                                    'Not Sure', 'Operational Zone', 'Space', 2, 'www.google.com', 'Company B', '987987987', 44, 'GBqwerty1234', 'asdf2222');
            staging.add(b2a);
            
            Booth_Staging__c b2 = CreateStaging(bu, 'Company B LTD', 'High street', 'the road', 'the village', 'big town', 'shires', 'qq887hh', 'GB', '33', 22, '11', '1@1.com', 'Jane', null, '654654654', '3213213213', 
                                                    'A1235', 'Operational Zone', 'Space', 2, 'www.google.com', 'Company B', null, 44, 'GBqwerty1234', 'asdf2222');
            staging.add(b2);
            
            Booth_Staging__c b3 = CreateStaging(bu, 'Company A LTD', 'High street', 'the road', 'the village', 'big town', 'shires', 'qq88 7hh', 'GB', '33', 22, '11', '1@1.com', null, 'Bloggs', '654654654', '3213213213', 
                                                    'A1', 'Operational Zone', 'Space', 2, 'www.google.com', 'Company B', '987987987', 44, 'GBqwerty1234', 'asdf2222');
            staging.add(b3);
            
            Booth_Staging__c b15 = CreateStaging(bu, 'Company A LTD', 'High street', 'the road', 'the village', 'big town', 'shires', 'qq88 7hh', 'US', '33', 22, '11', '1@1.com', 'Joe', 'Bloggs', '654654654', '3213213213', 
                                                    'A1', 'Operational Zone', 'Space', 2, 'www.google.com', 'Company B', '987987987', 44, 'GBqwerty1234', 'asdf2222');
            staging.add(b15);
            
    //------------------------------------------------------------------------

            //Booth_Upload__c bu2 = CreateBoothUpload(op1);
            Booth_Staging__c b4 = CreateStaging(bu, 'Company B LTD', 'High street', 'the road', 'the village', 'big town', 'shires', 'qq88 7hh', 'GBtrd', '33', 22, '11', '1@1.com', 'Joe', 'Bloggs', '654654654', '3213213213', 
                                                    'A1234', 'Operational Zone', 'Space', 2, 'www.google.com', 'Company B', '987987987', 44, 'GBqwerty1234', 'asdf2222');
            staging.add(b4);

            Booth_Staging__c b5 = CreateStaging(bu, 'Company B LTD', 'High street', 'the road', 'the village', 'big town', 'shires', 'qq88 7hh', 'GB', '33', 22, '11', '1@1.com', 'Jane', 'Bloggs', '654654654', '3213213213', 
                                                    'A1236', 'Operational Zone', 'Space', 2, 'www.google.com', 'Company B', '987987987', 44, 'GBqwerty1234', 'asdf2222');
            staging.add(b5);

    //------------------------------------------------------------------------
            
            //Booth_Upload__c bu3 = CreateBoothUpload(op1);
            Booth_Staging__c b6 = CreateStaging(bu, 'Company B LTD', 'High street', 'the road', 'the village', 'big town', 'shires', 'qq88 7hh', 'GB', '33', 22, '11', '1@1.com', 'Bob', 'Smith', '654654654', '3213213213', 
                                                    'A1234', 'Operational Zone', 'Space', 2, 'www.google.com', 'Company B', '987987987', 44, 'GBqwerty1234', 'asdf2222');
            staging.add(b6);

            Booth_Staging__c b7 = CreateStaging(bu, 'Company B LTD', 'High street', 'the road', 'the village', 'big town', 'shires', 'qq88 7hh', 'GB', '33', 22, '11', '1@1.com', 'Jon', 'Smith', '654654654', '3213213213', 
                                                    'A1236', 'Operational Zone', 'Space', 2, 'www.google.com', 'Company B', '987987987', 44, 'GBqwerty1234', 'asdf2222');
            staging.add(b7);

            Booth_Staging__c b8 = CreateStaging(bu, 'Company B LTD', 'High street', 'the road', 'the village', 'big town', 'shires', 'qq88 7hh', 'GB', '33', 22, '11', '1@1.com', 'Dan', 'Jones', '654654654', '3213213213', 
                                                    'A1237', 'Operational Zone', 'Space', 2, 'www.google.com', 'Company B', '987987987', 44, 'GBqwerty1234', 'asdf2222');
            staging.add(b8);

    //------------------------------------------------------------------------

            //Booth_Upload__c bu4 = CreateBoothUpload(op1);
            Booth_Staging__c b9 = CreateStaging(bu, 'Company B LTD', 'High street', 'the road', 'the village', 'big town', 'shires', 'qq88 7hh', 'GB', '33', 22, '11', '1@1.com', 'Joe', 'Bloggs', '654654654', '3213213213', 
                                                    'A999', 'Operational Zone', 'Space', 2, 'www.google.com', 'Company B', '987987987', 44, 'GBqwerty1234', 'asdf2222');
            staging.add(b9);

            Booth_Staging__c b10 = CreateStaging(bu, 'Company A LTD', 'High street', 'the road', 'the village', 'big town', 'shires', 'qq887hh', 'GB', '33', 22, '11', '1@1.com', 'Joe', 'Bloggs', '654654654', '3213213213', 
                                                    'A2', 'Operational Zone', 'Space', 2, 'www.google.com', 'Company B', '987987987', 44, 'qwerty1234', 'asdf2222');
            staging.add(b10);

    //------------------------------------------------------------------------

            //Booth_Upload__c bu5 = CreateBoothUpload(op1);
            Booth_Staging__c b11 = CreateStaging(bu, 'Company C LTD', 'High street', 'the road', 'the village', 'big town', 'shires', 'qqdsd7hh', 'GB', '33', 22, '11', '1@1.com', 'Joe', 'Bloggs', '654654654', '3213213213', 
                                                    'C1', 'Operational Zone', 'Space', 2, 'www.google.com', 'Company B', '987987987', 44, 'qwerty1234', 'asdf2222');
            staging.add(b11);
            
             Booth_Staging__c b12 = CreateStaging(bu, 'Company C LTD', 'Highstreet', 'the road', 'the village', 'big-town', 'shires', 'qq88 7hh', 'GB', '36', 22, '11', '1@1.com', 'Joe', 'Bloggs', '654654654', '3213213213', 
                                                    '', 'Operational Zone', 'Space', 2, 'www.google.com', 'Company B', '987987987', 44, 'qwerty1234', 'asdf2222');
            staging.add(b12);
            
             Booth_Staging__c b13 = CreateStaging(bu, 'Itssdssdfsdfsdf fun Itssdssdfsdfsdf fun Itssdssdfsdfsdf fun Itssdssdfsdfsdf fun Itssdssdfsdfsdf fun Itssdssdfsdfsdf fun Itssdssdfsdfsdf fun Itssdssdfsdfsdf fun Itssdssdfsdfsdf fun', 'Highstreet', 'the road', 'the village', 'big-town', 'shires', 'qq88 7hh', 'Blabllabkaa', '36', 22, '11', '1@1.com', 'Joe', 'Bloggs', '654654654', '3213213213', 
                                                    'C2', 'Operational Zone', 'Space', 2, 'www.google.com', 'Company B', '987987987', 44, 'qwerty1234', 'asdf2222');
            staging.add(b13);

            Booth_Staging__c b14 = CreateStaging(bu, 'Company C LTD', 'Highstreet', 'the road', 'the village', 'big-town', 'shires', 'qq88 7hh', 'GB', '36', 22, '11', '1dsfsd@1.com', '', '', '654654654', '3213213213', 
                                                    'C3', 'Operational Zone', 'Space', 2, 'www.google.com', 'Company B', '987987987', 44, 'qwerty1234', 'asdf2222');
            staging.add(b14);
            
            insert staging;
            
            
            //Test.startTest();
            system.debug('running test: ' + bu);
            executeBatch(bu);

            /*system.debug('running test: ' + bu2);
            executeBatch(bu2);

            system.debug('running test: ' + bu3);
            executeBatch(bu3);

            system.debug('running test: ' + bu4);
            executeBatch(bu4);

            system.debug('running test: ' + bu5);
            executeBatch(bu5);*/
            Test.stopTest();
        }
        
    }
    
    
    //@isTest static void test_method_one() {

        //Profile profile1 = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        //User testUser = new User(
        //ProfileId = profile1.Id,
        //Username ='DarkKnight@test.com',
        //Alias = 'batman',
        //Email='bruce.wayne@wayneenterprises.com',
        //EmailEncodingKey='UTF-8',
        //Firstname='Bruce',
        //Lastname='Wayne',
        //LanguageLocaleKey='en_US',
        //LocaleSidKey='en_US',
        //TimeZoneSidKey='America/Chicago'
        //);
        //insert(testUser);
        
        //Account acc = new Account();
        //acc.Name = 'My_Company';
        //acc.BillingCountry = 'USA';
        
        //insert acc;
        
        //Contact cont = new Contact();
        //cont.FirstName = 'Cutomer1';
        //cont.LastName = 'Bimbo';
        //cont.MailingPostalCode = '45345235';
        //cont.AccountId = acc.Id;
        //cont.Email = 'Cutomer1.Bimbo@vertibaTest.com';
        
        //insert cont;

        //Opportunity op1 = new Opportunity();
        //op1.Name = 'opp1';
        //op1.stageName = 'oppStage';
        //op1.closeDate = Date.today();
        //insert op1;
        
        //Oracle_Show_Booth__c oracleBooth = new Oracle_Show_Booth__c();
        //oracleBooth.BOOTH_NUMBER__c = '23';
        //oracleBooth.Account__c = acc.Id;
        //oracleBooth.Name = 'Booth Name';
        //oracleBooth.Show_Occurrence__c = op1.Id;
        //insert oracleBooth;
        
        //Oracle_Show_Booth_Contact__c oracleVar = new Oracle_Show_Booth_Contact__c();
        //oracleVar.FIRST_NAME__c = 'Cutomer1';
        //oracleVar.LAST_NAME__c = 'Bimbo';
        //oracleVar.Mailing_Postal_Code__c ='45345235';
        //oracleVar.Oracle_Show_Booth__c = oracleBooth.Id;
        //oracleVar.Contact__c = cont.Id;
        //insert oracleVar;
/*
        Group tgr = new Group();
        tgr.Name = 'EMEA Exhibitor Upload';
        insert tgr;
  */      
        //Booth_Upload__c bu = new Booth_Upload__c();
        //bu.Opportunity__c = op1.id;
        //insert bu;
        //Booth_Staging__c b = new Booth_Staging__c();
        //b.Booth_Upload__c = bu.id;
        //b.Status__c = 'New';
        //insert b;

        //Opportunity op2 = new Opportunity();
        //op2.Name = 'opp2';
        //op2.stageName = 'oppStage2';
        //op2.closeDate = Date.today();
        //insert op2;
        //Booth_Staging__c b2 = new Booth_Staging__c();
        //b2.Booth_Upload__c = bu.id;
        //b2.Status__c = 'New';
        //b2.Company__c = 'My_Company';
        //b2.First_Name__c = 'Cutomer1';
        //b2.Last_Name__c = 'Bimbo';
        //b2.Stand_Number__c = '23';
        //b2.Post_Zip_Code__c = '45345235';
        //b2.Country__c = 'Alabama';
        //insert b2;
        
        //Booth_Staging__c b3 = new Booth_Staging__c();
        //b3.Account_ID__c = acc.Id;
        //b3.Booth_Upload__c = bu.id;
        //b3.Status__c = 'New';
        //b3.Company__c = acc.Name;
        //b3.First_Name__c = 'Cutomer1';
        //b3.Last_Name__c = 'Bimbo';
        //b3.Stand_Number__c = '23';
        //b3.Post_Zip_Code__c = '45345235';
        //b3.Country__c = 'Arizona';
        //insert b3;
        
        //Booth_Staging__c b4 = new Booth_Staging__c();
        //b4.Booth_Upload__c = bu.id;
        //b4.Status__c = 'New';
        //b4.Company__c = 'My_Company1';
        //b4.First_Name__c = 'Customer1';
        //b4.Last_Name__c = 'Bimbo2';
        //b4.Stand_Number__c = '21';
        //b4.Post_Zip_Code__c = '4345235';
        //b4.Country__c = 'Alabama';
        //insert b4;
        
        //Test.startTest();
        //BoothUploadProcessingBatch bupb = new BoothUploadProcessingBatch(bu,'salesforce');
        //Database.executeBatch(bupb);      
        
        //List<Contact> conts = [Select Id, Name from Contact];
        //System.debug('Contacts: ' + conts);
        
        //Test.stopTest();
        
        //List<Contact> conts2 = [Select Id, Name from Contact];
        //System.debug('Contacts2: ' + conts2);
    //}
    
    
    
    static void executeBatch(Booth_Upload__c boothUpload)
    {
        List<Booth_Staging__c> booths = [SELECT Id, Name, Show_Name__c, Status__c, Account_ID__r.Name, Country__c, Address_1__c, Address_2__c, Address_3__c, Agency_Contact__c, 
            Agency_Email__c, Agency_Phone__c, Booth_Height__c, Booth_ID__c, Booth_Length__c, Booth_Size__c, Booth_Width__c, Business_Type__c, City__c, Company__c, 
            Email__c, Exhibitor_Body__c, Exhibitor_GUID__c, Exhibitor_Username__c, Exhibitor_Password__c, 
            Exhibitor_Status__c, Fax__c, First_Name__c, Last_Name__c, Nameboard_Name__c, New_Exhibitor__c, Notes__c, Open_Sides__c, Operations_Zone__c, Package_Type__c, Phone_Number__c, 
            Pillar_Column_Size_c__c, Post_Zip_Code__c, Service_Zone__c, Stand_Number__c, Stand_Type__c, State_County__c, Vat_Number__c, Website__c, Mobile__c, Salutation__c,
            Contractor_Contact__c, Contractor_Email__c, Contact_ID__c, Contractor_Phone__c, Cust_Type__c, Design_Configuration__c, Discount__c
                FROM Booth_Staging__c WHERE Booth_Upload__c = :BoothUpload.Id AND Status__c != 'Confirmed'];

        System.debug('Booths: ' + booths);
        
        BoothUploadProcessingBatch bupb = new BoothUploadProcessingBatch(boothUpload,'salesforce');
        Database.executeBatch(bupb);      
        
    }
    

    static void CreateCountries()
    {
        country_transformation__c country = new country_transformation__c();
        country.name = 'United Kingdom';
        country.Output_Country_Code__c = 'GB';
        insert country;
    }
    
    static Account CreateAccount()
    {
        //Create User Sales Person
        ID SalesRepId = UserInfo.getUserId();
        
        RecordType FirmRecordType = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Firm'];
            Id FirmRecordTypeId = FirmRecordType.Id;
        
        Account Firm = new Account();
            Firm.Sales_Person__c = SalesRepId;
            //Firm.Name = 'SONY ENTERTAINMENT INC';
            Firm.Name = 'Company B LTD';
            Firm.Phone = '7022631500';
            Firm.BillingStreet = '950 Grier Dr';
            Firm.BillingCity = 'Las Vegas';
            //Firm.BillingPostalCode = '89119-0000';
            Firm.BillingPostalCode = 'qq88 7hh';
            Firm.BillingState = 'NV';
            Firm.BillingCountry = 'US';
            Firm.RecordTypeId = FirmRecordTypeId;
            
            insert Firm;
        
        return Firm;
    }
    
    static Show__c CreateShow(Account firm)
    {
        
        //Create User Sales Person
        ID SalesRepId = UserInfo.getUserId();
        
        Show__c show = new Show__c();
            show.Sales_Person__c = SalesRepId;
            show.Account__c = firm.Id;
            show.Name ='International CES';
            show.Show_Type__c = 'Food Sector';
            show.Show_ID__c = '123456';
            show.Sync_with_Marketo__c = true;
            insert show ;
        
        return show;
    }

    static Opportunity CreateOpportunity(Show__c show, Account Firm)
    {
                //Create User Sales Person
        ID SalesRepId = UserInfo.getUserId();
        ID OwnerId = UserInfo.getUserId();

        
                    RecordType FacilityRecordType = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Facility'];
            Id FacilityRecordTypeId = FacilityRecordType.Id;

        
            Account Facility = new Account();
            Facility.Sales_Person__c = SalesRepId;
            Facility.Name = 'MyTestFacilityName';
            Facility.Type = 'Hotel';
            Facility.GES_Status__c = 'Preferred';
            Facility.LMS_Facility_ID__c = 'ABCFAC';
            Facility.BillingStreet = '950 Grier Dr';
            Facility.BillingCity = 'Las Vegas';
            Facility.BillingPostalCode = '89119-0000';
            Facility.BillingState = 'NV';
            Facility.BillingCountry = 'US';
            Facility.RecordTypeId = FacilityRecordTypeId;
            
            insert Facility;
       
        
        Opportunity op1 = new Opportunity();
        Op1.Job_Number__c = '201212313';        
            Op1.OwnerId = OwnerId;   
            Op1.Sales_Person__c = SalesRepId;        
            Op1.Sales_Location__c = '110- Las Vegas';        
            Op1.Name = 'MyTestShow # 1';        
            Op1.Prime_Contractor__c = null;        
            Op1.Production_Location__c = '110- Las Vegas';        
            Op1.Facility__c = Facility.Id;        
            Op1.StageName = 'AV';        
            Op1.Amount = 1000;        
            Op1.Probability = 0;        
            Op1.Type = 'ITYFTY';        
            Op1.New_Repeat__c = 'New';        
            Op1.Frequency__c = 'B1';        
            Op1.AccountId = Firm.Id;       
            Op1.Show_Name__c = Show.Id;        
            Op1.RecordTypeId = SObjectType.Opportunity.getRecordTypeInfosByName().get('Sales Rep Show Occurrence').getRecordTypeId();
            Op1.Show_Open_Date__c = Date.newInstance(DateTime.now().yearGmt()-1,12,1);       
            Op1.Show_Close_Date__c = Date.newInstance(DateTime.now().yearGmt()-1,12,2);        
            Op1.CloseDate = Date.newInstance(DateTime.now().yearGmt()-1,12,2); 
            op1.Requested_Stage__c = '';
        
        //op1.Name = 'opp1';
        //op1.stageName = 'oppStage';
        //op1.closeDate = Date.today();
        //op1.Show_Name__c = show.id;
    
        insert op1;

        return op1;
    }

    static Booth_Upload__c CreateBoothUpload(Opportunity opportunity)
    {
        Booth_Upload__c bu = new Booth_Upload__c();
        bu.Opportunity__c = opportunity.id;
        insert bu;

        return bu;
    }

    static Booth_Staging__c CreateStaging(
        Booth_Upload__c boothUpload,
        string companyName,
        string address1,
        string address2,
        string address3,
        string city,
        string county,
        string postcode,
        string country,
        string length,
        decimal size,
        string width,
        string email,
        string firstname,
        string lastname,
        string phone,
        string fax,
        string standnumber,
        string operationzone,
        string standtype,
        decimal opensides,
        string website,
        string nameboard,
        string mobile,
        decimal height,
        string vatnumber,
        string servicezone
        )
    {
        Booth_Staging__c b = new Booth_Staging__c();
        b.Booth_Upload__c = boothUpload.id;
        b.Status__c = 'New';

        b.Company__c = companyName;

        b.Address_1__c = address1;
        b.Address_2__c = address2; 
        b.Address_3__c = address3;
        b.City__c = city;
        b.State_County__c = county;
        b.Post_Zip_Code__c = postcode;
        b.Country__c = country;
        b.Booth_Length__c = length;
        b.Booth_Size__c = size;
        b.Booth_Width__c = width;
        
        b.Email__c = email;
        b.First_Name__c = firstname;
        b.Last_Name__c = lastname;
        b.Phone_Number__c = phone;
        b.Fax__c     = fax;
        b.Stand_Number__c = standnumber;
        b.Operations_Zone__c = operationzone;
        b.Stand_Type__c = standtype;
        b.Open_Sides__c =  opensides;
        b.Website__c = website;
        
        b.Nameboard_Name__c = nameboard;
        b.Mobile__c = mobile;
        b.Booth_Height__c = height;
        b.Vat_Number__c = vatnumber;
        b.Service_Zone__c = servicezone;

        //insert b;

        return b;
    }
}


//SELECT Id, Name, Show_Name__c, Status__c, Address_1__c, Address_2__c, Address_3__c, 
//Agency_Contact__c, Agency_Email__c, Agency_Phone__c, Booth_Height__c, Booth_ID__c, 
//Booth_Length__c, Booth_Size__c, Booth_Width__c, Business_Type__c, City__c, Company__c,
//Contractor_Contact__c, Contractor_Email__c, Contractor_Phone__c, Country__c, Cust_Type__c, 
//Design_Configuration__c, Discount__c, Email__c, Exhibitor_Body__c, Exhibitor_Status__c, 
//Fax__c, First_Name__c, Last_Name__c, Nameboard_Name__c, New_Exhibitor__c, Notes__c, Open_Sides__c, 
//Operations_Zone__c, Package_Type__c, Phone_Number__c, Pillar_Column_Size_c__c, Post_Zip_Code__c, 
//Service_Zone__c, Stand_Number__c, Stand_Type__c, State_County__c, Vat_Number__c, Website__c 
//FROM Booth_Staging__c WHERE Booth_Upload__c = \'' + BoothUpload.Id + '\' AND Status__c != \'Confirmed\''