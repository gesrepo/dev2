@isTest(SeeAllData=false)
private class OpportunityTriggerHelperTest {
    
    static List<Opportunity> oppList = new List<Opportunity>();
    @testSetup static void setup(){
        User ADMIN_USER = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
        System.runAs(ADMIN_USER){
            //Create Facility Account
            Account Facility = new Account();
            Facility.Sales_Person__c = UserInfo.getUserId();
            Facility.Name = 'MyTestFacilityName';
            Facility.Type = 'Hotel';
            Facility.GES_Status__c = 'Preferred';
            Facility.LMS_Facility_ID__c = 'ABCFAC';
            Facility.BillingStreet = '950 Grier Dr';
            Facility.BillingCity = 'Las Vegas';
            Facility.BillingPostalCode = '89119-0000';
            Facility.BillingState = 'NV';
            Facility.BillingCountry = 'US';
            //Facility.RecordTypeId = FacilityRecordType.Id;
            Facility.RecordTypeId = SObjectType.Account.getRecordTypeInfosByName().get('Facility').getRecordTypeId();
            insert Facility;
            
            //Create Firm Account
            Account Firm = new Account();
            Firm.Sales_Person__c = UserInfo.getUserId();
            Firm.Name = 'SONY ENTERTAINMENT INC';
            Firm.Phone = '7022631500';
            Firm.BillingStreet = '950 Grier Dr';
            Firm.BillingCity = 'Las Vegas';
            Firm.BillingPostalCode = '89119-0000';
            Firm.BillingState = 'NV';
            Firm.BillingCountry = 'US';
            //Firm.RecordTypeId = FirmRecordType.Id;
            Firm.RecordTypeId = SObjectType.Account.getRecordTypeInfosByName().get('Firm').getRecordTypeId();
            insert Firm;
            
            //create contact
            Contact contact = new Contact();
            contact.LastName = 'Contact';
            contact.FirstName = 'Test';
            contact.Primary_Contact__c = true;
            contact.AccountId = Firm.Id;
            contact.email = 'testcontact@gmail.com';
            insert contact;
            
            Show__c show = TestDataUtil.CreateTestShow(firm.id);
            
            Opportunity SalesRepOpp = TestDataUtil.CreateTestSalesRepOpp(facility.Id, firm.Id, show.Id);
            List<Opportunity> listOpp = new List<Opportunity>();
            Opportunity Opp = new Opportunity();
            Opp.Job_Number__c = '20121231';
            Opp.Sales_Location__c = '110- Las Vegas';
            Opp.Name = 'MyTestShow 2';
            Opp.Prime_Contractor__c = null;
            Opp.Production_Location__c = '110- Las Vegas';
            Opp.Facility__c = facility.Id;
            Opp.StageName = 'SL1';
            Opp.Amount = 1000;
            Opp.Probability = 25;
            Opp.Type = 'ITYFTY';
            Opp.New_Repeat__c = 'New';
            Opp.Frequency__c = 'B1';
            Opp.AccountId = firm.Id;
            Opp.Show_Name__c = show.Id;
            Opp.RecordTypeId = TestDataUtil.OpportunitySalesRepRecordTypeId;        
            Opp.Show_Open_Date__c = Date.today();
            Opp.Show_Close_Date__c = Date.today() + 20;
            Opp.CloseDate = Date.today() + 20;
            //Opp.Show_Occurrence__c = SalesRepOpp.Id;
            listOpp.add(Opp);
            
            Opportunity Opp2 = new Opportunity();
            Opp2.Job_Number__c = '20121231';
            Opp2.Sales_Location__c = '110- Las Vegas';
            Opp2.Name = 'MyTestShow 2';
            Opp2.Prime_Contractor__c = null;
            Opp2.Production_Location__c = '110- Las Vegas';
            Opp2.Facility__c = facility.Id;
            Opp2.StageName = 'SL1';
            Opp2.Amount = 1000;
            Opp2.Probability = 25;
            Opp2.Type = 'ITYFTY';
            Opp2.New_Repeat__c = 'New';
            Opp2.Frequency__c = 'B1';
            Opp2.AccountId = firm.Id;
            Opp2.Show_Name__c = show.Id;
            Opp2.RecordTypeId = TestDataUtil.OpportunitySalesRepRecordTypeId;        
            Opp2.Show_Open_Date__c = Date.today();
            Opp2.Show_Close_Date__c = Date.today() + 20;
            Opp2.CloseDate = Date.today() + 20;
            Opp2.Show_Occurrence__c = SalesRepOpp.Id;
            listOpp.add(Opp2);
            insert listOpp;
            
            //Create Show
            /* Show__c Show = new Show__c();
Show.Sales_Person__c = UserInfo.getUserId();
Show.Account__c = Firm.Id;
Show.Name ='International CES';
Show.Show_Type__c = 'Food Sector';
Show.Show_ID__c = '123456';
Show.Sync_with_Marketo__c = true;
insert Show ;*/
            
            SOPAuthentication__c newAuth = new SOPAuthentication__c();
            newAuth.Name = 'Login Credentials';
            newAuth.Password__c = 'lalalala';
            newAuth.Username__c = 'lalalala';
            insert newAuth;      
            
            SOPService__c serv = new SOPService__c();
            serv.Name = 'Default';
            serv.URL__c = 'test';
            insert serv;  
            
        }
    }
    
    @isTest static void createShowOccurrenceTest1(){
        User ADMIN_USER = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
        System.runAs(ADMIN_USER){
            Account facility = [select Id from Account where RecordTypeId = :SObjectType.Account.getRecordTypeInfosByName().get('Facility').getRecordTypeId()];
            Account firm = [select Id from Account where RecordTypeId = :SObjectType.Account.getRecordTypeInfosByName().get('Firm').getRecordTypeId()];
            Show__c Show = [select Id from Show__c limit 1];
            
            
            
            Opportunity Opp1 = new Opportunity();        
            Opp1.Job_Number__c = '201212313';        
            Opp1.OwnerId = UserInfo.getUserId();   
            Opp1.Sales_Person__c = UserInfo.getUserId();        
            Opp1.Sales_Location__c = '110- Las Vegas';        
            Opp1.Name = 'MyTestShow # 1';
            if (Opp1.Name.length() > 80)
                Opp1.Name = Opp1.Name.substring(0,79);            
            Opp1.Prime_Contractor__c = null;        
            Opp1.Production_Location__c = '110- Las Vegas';        
            Opp1.Facility__c = facility.Id;        
            Opp1.StageName = 'AV';        
            Opp1.Amount = 1000;        
            Opp1.Probability = 0;        
            Opp1.Type = 'ITYFTY';        
            Opp1.New_Repeat__c = 'New';        
            Opp1.Frequency__c = 'B1';        
            Opp1.AccountId = firm.Id;       
            Opp1.Show_Name__c = Show.Id;        
            Opp1.RecordTypeId = SObjectType.Opportunity.getRecordTypeInfosByName().get(Properties.edProjectsRecordTypeName).getRecordTypeId();
            Opp1.Show_Open_Date__c = Date.newInstance(DateTime.now().yearGmt()-1,12,1);       
            Opp1.Show_Close_Date__c = Date.newInstance(DateTime.now().yearGmt()-1,12,2);        
            Opp1.CloseDate = Date.newInstance(DateTime.now().yearGmt()-1,12,2); 
            opp1.Requested_Stage__c = '';
            
            //opp1.Show_Occurrence__c =  opp1.id;
            opp1.Show_Name__c = Show.id;
            try{
                insert opp1;
            }
            catch(Exception e){
                System.debug('Error Message '+e.getMessage() + ' ' + opp1);
            }
            
            Show_Occurrence_Public__c sop = TestDataUtil.createShowOccurrencePublic(opp1);
            insert sop;
            
            Show_Plan__c spl = new Show_Plan__c(Incumbent__c=facility.id,Show_Name__c=Show.id,Show_Opportunity__c=opp1.id,DummyNonRelatedOppID__c = opp1.id,Previous_Occurrence_Revenue__c=1.6,Total_Plan_Revenue__c=0);
            insert spl;
            
            opp1.Account_Plan__c = spl.Id;
            opp1.Prime_Contractor__c = firm.Id;
            update opp1;
            System.debug(opp1);
            Test.startTest();
            Opportunity Oppav = new Opportunity();
            Oppav.Account_Plan__c = spl.id;
            Oppav.Job_Number__c = '201212313';        
            Oppav.OwnerId = UserInfo.getUserId();   
            Oppav.Sales_Person__c = UserInfo.getUserId();        
            Oppav.Sales_Location__c = '110- Las Vegas';        
            Oppav.Name = 'MyTestShow # 2';        
            Oppav.Prime_Contractor__c = null;        
            Oppav.Production_Location__c = '110- Las Vegas';        
            Oppav.Facility__c = facility.Id;        
            Oppav.StageName = 'Done';        
            Oppav.Amount = 1000;        
            Oppav.Probability = 0;        
            Oppav.Type = 'ITYFTY';        
            Oppav.New_Repeat__c = 'New';        
            Oppav.Frequency__c = 'B1';        
            Oppav.AccountId = firm.Id;       
            Oppav.Show_Name__c = Show.Id;        
            Oppav.RecordTypeId = SObjectType.Opportunity.getRecordTypeInfosByName().get(Properties.edProjectsReadOnlyRecordTypeName).getRecordTypeId();                
            Oppav.Show_Open_Date__c = Date.newInstance(DateTime.now().yearGmt()-1,12,1);       
            Oppav.Show_Close_Date__c = Date.newInstance(DateTime.now().yearGmt()-1,12,2);        
            Oppav.CloseDate = Date.newInstance(DateTime.now().yearGmt()-1,12,2); 
            Oppav.Requested_Stage__c = '';
            Oppav.Show_Occurrence__c =  opp1.id;
            Oppav.Show_Name__c = Show.id;
            Oppav.Sync_with_Marketo__c = true;
            //insert Oppav; 
            
            //List<Opportunity> oppList = new List<Opportunity>();
            oppList.add(opp1);
            oppList.add(Oppav);
            set<Id> oppsetId=new Set<Id>();
            oppsetId.add(opp1.Id);
            oppsetId.add(Oppav.Id);
            System.debug('oppList in test class--> '+oppList);
            OpportunityTriggerHelper.rollUpSummaryOnOpportunity(oppsetId);
            OpportunityTriggerHelper.setDataFromAccountReference(oppList);
            OpportunityTriggerHelper.updateOpportunityNamesOnUpdate(oppList);
            OpportunityTriggerHelper.createShowOccurrencesOnInsert(oppList);
            OpportunityTriggerHelper.createShowOccurrencesOnUpdate(oppList);
            OpportunityTriggerHelper.updateOpportunityFieldsBeforeEvent(oppList,oppList);
            OpportunityTriggerHelper.retrieveOpportunityRecordTypeIds();
            //OpportunityTriggerHelper.submitForApproval(oppList);
            OpportunityTriggerHelper.updateShowPlanOnInsert(oppList);
            OpportunityTriggerHelper.updateContactRoleOnUpdate(oppList);
            OpportunityTriggerHelper.updateShowPlanOnDelete(oppList);
            OpportunityTriggerHelper.deleteShowOccurrence(oppList);
            OpportunityTriggerHelper.UpdateProposalDate(spl,oppList);
            Test.stopTest();
        }
    }
    
    @isTest static void createShowOccurrenceTest2(){
        Account firm = [select Id from Account where RecordTypeId = :SObjectType.Account.getRecordTypeInfosByName().get('Firm').getRecordTypeId()];
        User ADMIN_USER = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
        System.runAs(ADMIN_USER){
            
            test.startTest();
            List<Opportunity> repeatValue = [Select Id, Show_Occurrence__c, Frequency__c from Opportunity];
            repeatValue[0].Prime_Contractor__c = firm.Id;
            repeatValue[1].Prime_Contractor__c = firm.Id;
            repeatValue[1].Show_Occurrence__c = repeatValue[0].Id;
            repeatValue[1].Requested_Stage__c = 'SL2';
            update repeatValue;
            test.stopTest();
        }
    }  
    
    @isTest static void createShowOccurrenceTest3(){
        User ADMIN_USER = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
        System.runAs(ADMIN_USER){
            test.startTest();
            List<Opportunity> repeatValue = [Select Id, Show_Occurrence__c, Frequency__c from Opportunity];
            repeatValue[1].Show_Occurrence__c = repeatValue[0].Id;
            repeatValue[1].Requested_Stage__c = 'SL2';
            delete repeatValue;
            test.stopTest();
        }
    }  
    
    @isTest static void createShowOccurrenceTest4(){
        User ADMIN_USER = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
        
        System.runAs(ADMIN_USER){
            Account facility = [select Id from Account where RecordTypeId = :SObjectType.Account.getRecordTypeInfosByName().get('Facility').getRecordTypeId()];
            Account firm = [select Id from Account where RecordTypeId = :SObjectType.Account.getRecordTypeInfosByName().get('Firm').getRecordTypeId()];
            Show__c Show = [select Id from Show__c limit 1];
            //List<Opportunity> OpptyList = [Select Id, Show_Occurrence__c, Frequency__c from Opportunity];
            
            Show_Plan__c spl = new Show_Plan__c(Incumbent__c=facility.id,Show_Name__c=Show.id,Previous_Occurrence_Revenue__c=1.6,Total_Plan_Revenue__c=0);
            insert spl;
            
            List<Opportunity> OpptyList = new List<Opportunity>();
            Opportunity Opp1 = new Opportunity();        
            Opp1.Job_Number__c = '201212313';        
            Opp1.OwnerId = UserInfo.getUserId();   
            Opp1.Sales_Person__c = UserInfo.getUserId();        
            Opp1.Sales_Location__c = '110- Las Vegas';        
            Opp1.Name = 'MyTestShow # 1';
            if (Opp1.Name.length() > 80)
                Opp1.Name = Opp1.Name.substring(0,79);            
            Opp1.Prime_Contractor__c = null;        
            Opp1.Production_Location__c = '110- Las Vegas';        
            Opp1.Facility__c = facility.Id;        
            Opp1.StageName = 'AV';        
            Opp1.Amount = 1000;        
            Opp1.Probability = 0;        
            Opp1.Type = 'ITYFTY';        
            Opp1.New_Repeat__c = 'New';        
            Opp1.Frequency__c = 'B1';        
            Opp1.AccountId = firm.Id;       
            Opp1.Show_Name__c = Show.Id;        
            Opp1.RecordTypeId = SObjectType.Opportunity.getRecordTypeInfosByName().get(Properties.edProjectsRecordTypeName).getRecordTypeId();
            Opp1.Show_Open_Date__c = Date.newInstance(DateTime.now().yearGmt()-1,12,1);       
            Opp1.Show_Close_Date__c = Date.newInstance(DateTime.now().yearGmt()-1,12,2);        
            Opp1.CloseDate = Date.newInstance(DateTime.now().yearGmt()-1,12,2); 
            opp1.Requested_Stage__c = '';
            opp1.Show_Name__c = Show.id;
            opp1.Account_Plan__c = spl.id;
            OpptyList.add(opp1);

            Opportunity Oppav = new Opportunity();
            Oppav.Account_Plan__c = spl.id;
            Oppav.Job_Number__c = '201212313';        
            Oppav.OwnerId = UserInfo.getUserId();   
            Oppav.Sales_Person__c = UserInfo.getUserId();        
            Oppav.Sales_Location__c = '110- Las Vegas';        
            Oppav.Name = 'MyTestShow # 2';        
            Oppav.Prime_Contractor__c = null;        
            Oppav.Production_Location__c = '110- Las Vegas';        
            Oppav.Facility__c = facility.Id;        
            Oppav.StageName = 'Done';        
            Oppav.Amount = 1000;        
            Oppav.Probability = 0;        
            Oppav.Type = 'ITYFTY';        
            Oppav.New_Repeat__c = 'New';        
            Oppav.Frequency__c = 'B1';        
            Oppav.AccountId = firm.Id;       
            Oppav.Show_Name__c = Show.Id;        
            Oppav.RecordTypeId = SObjectType.Opportunity.getRecordTypeInfosByName().get(Properties.edProjectsReadOnlyRecordTypeName).getRecordTypeId();                
            Oppav.Show_Open_Date__c = Date.newInstance(DateTime.now().yearGmt()-1,12,1);       
            Oppav.Show_Close_Date__c = Date.newInstance(DateTime.now().yearGmt()-1,12,2);        
            Oppav.CloseDate = Date.newInstance(DateTime.now().yearGmt()-1,12,2); 
            Oppav.Requested_Stage__c = '';
            Oppav.Show_Occurrence__c =  opp1.id;
            Oppav.Show_Name__c = Show.id;
            Oppav.Sync_with_Marketo__c = true;
            OpptyList.add(Oppav);
            test.startTest();
            insert OpptyList;
			OpportunityTriggerHelper.updateShowPlanOnInsert(OpptyList);
            test.stopTest();
        }
    } 
    
        @isTest static void createShowOccurrenceTest5(){
        User ADMIN_USER = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
        System.runAs(ADMIN_USER){
            Account facility = [select Id from Account where RecordTypeId = :SObjectType.Account.getRecordTypeInfosByName().get('Facility').getRecordTypeId()];
            Account firm = [select Id from Account where RecordTypeId = :SObjectType.Account.getRecordTypeInfosByName().get('Firm').getRecordTypeId()];
            Show__c Show = [select Id from Show__c limit 1];
            
            test.startTest();
            List<Opportunity> repeatValue = [Select Id, Show_Occurrence__c, Frequency__c from Opportunity];
            
            List<Show_Plan__c> spList = new List<Show_Plan__c>();
            Show_Plan__c spl1 = new Show_Plan__c(Incumbent__c=facility.id,Show_Name__c=Show.id,Show_Opportunity__c=repeatValue[0].id,DummyNonRelatedOppID__c = repeatValue[0].id,Previous_Occurrence_Revenue__c=1.6,Total_Plan_Revenue__c=0);
            Show_Plan__c spl2 = new Show_Plan__c(Incumbent__c=facility.id,Show_Name__c=Show.id,Show_Opportunity__c=repeatValue[1].id,DummyNonRelatedOppID__c = repeatValue[1].id,Previous_Occurrence_Revenue__c=1.6,Total_Plan_Revenue__c=0);
            spList.add(spl1);
            spList.add(spl2);
            insert spList;
			
            repeatValue[0].Account_Plan__c=spl1.Id;
            repeatValue[0].Prime_Contractor__c = firm.Id;
            repeatValue[1].Account_Plan__c=spl2.Id;
            repeatValue[1].Prime_Contractor__c = firm.Id;
            repeatValue[1].Show_Occurrence__c = repeatValue[0].Id;
            repeatValue[1].Requested_Stage__c = 'SL2';
            update repeatValue;
            test.stopTest();
        }
    }  
    
    
    @isTest static void onPeakShowTest1(){
        User ADMIN_USER = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
        Id recTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('US_Housing').getRecordTypeId();
        
        System.runAs(ADMIN_USER){
            Account facility = [select Id from Account where RecordTypeId = :SObjectType.Account.getRecordTypeInfosByName().get('Facility').getRecordTypeId()];
            Account firm = [select Id from Account where RecordTypeId = :SObjectType.Account.getRecordTypeInfosByName().get('Firm').getRecordTypeId()];
            Show__c Show = [select Id from Show__c limit 1];
            List<Opportunity> Oppty = [Select Id, Show_Occurrence__c, Frequency__c from Opportunity];
            
            Show_Plan__c spl = new Show_Plan__c(Incumbent__c=facility.id,Show_Name__c=Show.id,Previous_Occurrence_Revenue__c=1.6,Total_Plan_Revenue__c=0);
            insert spl;
            OpportunityTriggerHelper.isFirstTime = true;
            List<Opportunity> OpptyList = new List<Opportunity>();
            Opportunity Opp1 = new Opportunity();        
            Opp1.Job_Number__c = '201212313';        
            Opp1.OwnerId = UserInfo.getUserId();   
            Opp1.Sales_Person__c = UserInfo.getUserId();        
            Opp1.Sales_Location__c = '110- Las Vegas';        
            Opp1.Name = 'MyTestShow # 1';
            if (Opp1.Name.length() > 80)
                Opp1.Name = Opp1.Name.substring(0,79);            
            Opp1.Prime_Contractor__c = null;        
            Opp1.Production_Location__c = '110- Las Vegas';        
            Opp1.Facility__c = facility.Id;        
            Opp1.StageName = 'CV';        
            Opp1.Amount = 1000;        
            Opp1.Probability = 0;        
            Opp1.Type = 'ITYFTY';        
            Opp1.New_Repeat__c = 'New';        
            Opp1.Frequency__c = 'B1';        
            Opp1.AccountId = firm.Id;       
            Opp1.Show_Name__c = Show.Id;        
            Opp1.RecordTypeId = recTypeId;
            Opp1.Show_Open_Date__c = Date.newInstance(DateTime.now().yearGmt()-1,12,1);       
            Opp1.Show_Close_Date__c = Date.newInstance(DateTime.now().yearGmt()-1,12,2);        
            Opp1.CloseDate = Date.newInstance(DateTime.now().yearGmt()-1,12,2); 
            opp1.Requested_Stage__c = '';
            opp1.Show_Name__c = Show.id;
            opp1.Account_Plan__c = spl.id;
            opp1.Show_Occurrence__c = Oppty.get(0).Id;
            OpptyList.add(opp1);

            Opportunity Oppav = new Opportunity();
            Oppav.Account_Plan__c = spl.id;
            Oppav.Job_Number__c = '201212313';        
            Oppav.OwnerId = UserInfo.getUserId();   
            Oppav.Sales_Person__c = UserInfo.getUserId();        
            Oppav.Sales_Location__c = '110- Las Vegas';        
            Oppav.Name = 'MyTestShow # 2';        
            Oppav.Prime_Contractor__c = null;        
            Oppav.Production_Location__c = '110- Las Vegas';        
            Oppav.Facility__c = facility.Id;        
            Oppav.StageName = 'CR';        
            Oppav.Amount = 1000;        
            Oppav.Probability = 0;        
            Oppav.Type = 'ITYFTY';        
            Oppav.New_Repeat__c = 'New';        
            Oppav.Frequency__c = 'B1';        
            Oppav.AccountId = firm.Id;       
            Oppav.Show_Name__c = Show.Id;        
            Oppav.RecordTypeId = recTypeId;                
            Oppav.Show_Open_Date__c = Date.newInstance(DateTime.now().yearGmt()-1,12,1);       
            Oppav.Show_Close_Date__c = Date.newInstance(DateTime.now().yearGmt()-1,12,2);        
            Oppav.CloseDate = Date.newInstance(DateTime.now().yearGmt()-1,12,2); 
            Oppav.Requested_Stage__c = '';
            Oppav.Show_Occurrence__c =  opp1.id;
            Oppav.Show_Name__c = Show.id;
            Oppav.Sync_with_Marketo__c = true;
            Oppav.Show_Occurrence__c = Oppty.get(0).Id;
            OpptyList.add(Oppav);
            test.startTest();
            insert OpptyList;
            test.stopTest();
        }
    }
    
    @isTest static void createOpptyLineItemsTest(){
        User ADMIN_USER = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
        Id recTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('EMEA_Custom_Build').getRecordTypeId();
        EMEA_Custom_Setting__c settings = new EMEA_Custom_Setting__c();
        settings.CreatedById = '0058Z000005d0AdQAI';
        settings.Pricebook2Id__c = '01s40000000EdiJAAS';
        settings.Product_Code__c = 'CONSTRUCTION,EXHIBIT,FREIGHT,GRAPHICS,INSTDISM,INTL,KIOSK,OTHER,PULLPREP,REFURB,SHOWSVCS,TECHNOLOGY';
        insert settings;
        
        System.runAs(ADMIN_USER){
            Account facility = [select Id from Account where RecordTypeId = :SObjectType.Account.getRecordTypeInfosByName().get('Facility').getRecordTypeId()];
            Account firm = [select Id from Account where RecordTypeId = :SObjectType.Account.getRecordTypeInfosByName().get('Firm').getRecordTypeId()];
            Show__c Show = [select Id from Show__c limit 1];
            List<Opportunity> Oppty = [Select Id, Show_Occurrence__c, Frequency__c from Opportunity];
            
            Show_Plan__c spl = new Show_Plan__c(Incumbent__c=facility.id,Show_Name__c=Show.id,Previous_Occurrence_Revenue__c=1.6,Total_Plan_Revenue__c=0);
            insert spl;
            
            /*Product2 prod = new Product2(Name = 'CONSTRUCTION',ProductCode = 'CONSTRUCTION',isActive = true);
            insert prod;
            Id pricebookId = Test.getStandardPricebookId();
        	PricebookEntry pbEntry = new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = prod.Id,UnitPrice = 100.00,IsActive = true,CurrencyIsoCode='EUR');
        	insert pbEntry;*/

            OpportunityTriggerHelper.isFirstTime = true;
            test.startTest();
            List<Opportunity> OpptyList = new List<Opportunity>();
            Opportunity Opp1 = new Opportunity();        
            Opp1.Job_Number__c = '201212313';        
            Opp1.OwnerId = UserInfo.getUserId();   
            Opp1.Sales_Person__c = UserInfo.getUserId();        
            Opp1.Sales_Location__c = '110- Las Vegas';        
            Opp1.Name = 'MyTestShow # 1';
            if (Opp1.Name.length() > 80)
                Opp1.Name = Opp1.Name.substring(0,79);            
            Opp1.Prime_Contractor__c = null;        
            Opp1.Production_Location__c = '110- Las Vegas';        
            Opp1.Facility__c = facility.Id;        
            Opp1.StageName = 'CV';        
            Opp1.Amount = 1000;        
            Opp1.Probability = 0;        
            Opp1.Type = 'ITYFTY';        
            Opp1.New_Repeat__c = 'New';        
            Opp1.Frequency__c = 'B1';        
            Opp1.AccountId = firm.Id;       
            Opp1.Show_Name__c = Show.Id;        
            Opp1.RecordTypeId = recTypeId;
            Opp1.Show_Open_Date__c = Date.newInstance(DateTime.now().yearGmt()-1,12,1);       
            Opp1.Show_Close_Date__c = Date.newInstance(DateTime.now().yearGmt()-1,12,2);        
            Opp1.CloseDate = Date.newInstance(DateTime.now().yearGmt()-1,12,2); 
            Opp1.Requested_Stage__c = '';
            Opp1.Show_Name__c = Show.id;
            Opp1.Account_Plan__c = spl.id;
            Opp1.Show_Occurrence__c = Oppty.get(0).Id;
            opp1.CurrencyIsoCode = 'USD';
            insert Opp1;
            
            Set<Id> oppIds = new Set<Id>{Opp1.Id};
            Set<String> setCurrencyCode = new Set<String>{Opp1.CurrencyIsoCode};
            Map<Id, String> mapOppIdToCurrencyCode = new Map<Id, String>();
            mapOppIdToCurrencyCode.put(Opp1.Id, Opp1.CurrencyIsoCode);
            Map<Id, Opportunity> newMap = new Map<Id, Opportunity>();
            newMap.put(Opp1.Id, Opp1);
            OpportunityTriggerHelper.createOpptyLineItems(setCurrencyCode,mapOppIdToCurrencyCode,newMap, settings);
            OpportunityTriggerHelper.isFirstTime = true;
            Opp1.Requested_Stage__c = 'FI';
            update Opp1;
            OpportunityTriggerHelper.isFirstTime = true;
            Delete Opp1;
            test.stopTest();
        }
    }
}