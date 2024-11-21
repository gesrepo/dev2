/* Class Name: AccountTriggerHandler*/

@isTest
                                
public class Test_AccountTriggerHandler  {

static  testMethod void testMethod1() {

AccountMergeTriggerController__c  m= new AccountMergeTriggerController__c();
m.name='User1';
m.UserName__c='test1@ges.com';
m.IsActive__c=true;
insert m;


RecordType rt = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' and name= 'Exhibitor' LIMIT 1];

    
    Account Acc= new Account();
    Acc.Name= 'Test';
    Acc.BillingStreet= 'Test1';
    Acc.BillingCity= 'Delhi';
    Acc.BillingState= 'New Delhi';
    Acc.BillingPostalCode= '201013';
    Acc.BillingCountry= 'US';
    Acc.EMEA__c = False; 
    Acc.Melissa_Integration_Status__c = 'Success';
    Acc.RecordTypeId = rt.id;
    Acc.GBMS_CustomerID__c ='123456';
    Acc.ORACLE_AR_CUST_NUMBER__c='12345';
    Acc.ORACLE_AR_CUST_ACCOUNT_ID__c='44444';
  //  Acc.Processed_Flag__c=true;
    Test.StartTest();
    insert Acc;
  
    
     List<Quote__c> listQuote = new List<Quote__c>();
    for(Integer i=0;i<16;i++){
        listQuote.add(new Quote__c(
       
                              Account_Id__c = Acc.Id, 
                              Quote_Subject__c = 'Inbound',
                              Source__c = 'Fax',
                              Stage__c='Booked'
        ));  
    }
    insert listQuote;

    map<Id, List<Quote__c>> map1 = new map<Id, List<Quote__c>>(); 
    for(Quote__c t : listQuote)
    {
        map1.put(t.Account_Id__c , new List<Quote__c>{t});
    }
    
    delete Acc;
    
    AR_Customer_Info__c arinfo = new AR_Customer_Info__c();
    arinfo.Deleted_Account_Id__c=Acc.id;
    arinfo.Oracle_AR_Customer_ID__c='44444';
    arinfo.AR_Customer_Number__c='12345';
    arinfo.GBMS_ID__c='123456';
    insert arinfo;
    
    
   
    
Test.StopTest();
    
    

}

static  testMethod void testMethod2() {



List<Account> AccLst= new List<Account>();
    Account Acc= new Account();
    Acc.Name= 'Test';
    Acc.BillingStreet= 'Test1';
    Acc.BillingCity= 'Delhi';
    Acc.BillingState= 'New Delhi';
    Acc.BillingPostalCode= '201013';
    Acc.BillingCountry= 'US';
    Acc.ParentId=Acc.id;
    Acc.parent_duns_number__C='011854507';
    Acc.DunsNumber='199472668';
   // Acc.parent_duns_number__C='000000000';
    Acc.Custom_Parent_Account__c=Acc.id;
    Acc.Processed_Flag__c=false;
    AccLst.add(Acc);
    Test.StartTest();
    insert AccLst;
    
    List<Account> AccLst1= new List<Account>();
    Account Acc1= new Account();
    Acc1.id=Acc.id;
   // Acc1.ParentId=Acc.id;
   // Acc1.Custom_Parent_Account__c=Acc.id;
    Acc1.parent_duns_number__C='049994452';
    Acc1.DunsNumber='828611033';
    Acc1.Processed_Flag__c=true;
    AccLst1.add(Acc1);
    update AccLst1;

   /* DatacloudDandBCompany dbcloud = new DatacloudDandBCompany();
    dbcloud.Name='testdb';
    dbcloud.DunsNumber='12000001';
    dbcloud.ParentOrHqDunsNumber ='3423453';
    insert dbcloud;*/
     
   
    Test.StopTest();

}
    
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

static  testMethod void testMethod3() {
    
    SOPService__c serv = new SOPService__c();
        serv.Name = 'Default';
        serv.URL__c = 'test';
        insert serv;


    RecordType rt = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' and name= 'Exhibitor' LIMIT 1];
  
    SOPAuthentication__c newAuth = new SOPAuthentication__c();
    newAuth.Name = 'Login Credentials';
    newAuth.Password__c = 'lalalala';
    newAuth.Username__c = 'lalalala';
    insert newAuth;      
    
    Account Acc= new Account();
    Acc.Name= 'Test';
    Acc.BillingStreet= 'Test1';
    Acc.BillingCity= 'Delhi';
    Acc.BillingState= 'New Delhi';
    Acc.BillingPostalCode= '201013';
    Acc.BillingCountry= 'US';
    Acc.EMEA__c = False; 
    Acc.Melissa_Integration_Status__c = 'Success';
    Acc.RecordTypeId = rt.id;
    Acc.GBMS_CustomerID__c ='123456';
    Acc.ORACLE_AR_CUST_NUMBER__c='12345';
    Acc.ORACLE_AR_CUST_ACCOUNT_ID__c='44444';
    
    //Acc.EMEA__c = True;
    //Acc.EMEA_Finance_Approved__c = True;
  //  Acc.Processed_Flag__c=true;
    Test.StartTest();
    insert Acc;
    
    
    //Test.setMock(WebServiceMock.class, new SalesforceUpsertOrganisationMokup(Acc.id));
        //try{
        //  SOP_UpsertWrapper.UpsertOrganisation(JSON.serialize(Acc));
        //} catch(Exception e) {

        //}
  
    
   List<Contact > listBooth = new List<Contact>();
    for(Integer i=0;i<16;i++){
        listBooth.add(new Contact (
       
                              AccountId = Acc.Id, 
                              LastName = 'Test Contact',
                             Email = 'test@test.com'
                             
        ));  
    }
    insert listBooth;

    map<Id, List<Contact >> map12 = new map<Id, List<Contact >>(); 
    for(Contact  t : listBooth)
    {
        map12.put(t.AccountId , new List<Contact >{t});
    }
    
    
    delete Acc;
    
    AR_Customer_Info__c arinfo = new AR_Customer_Info__c();
    arinfo.Deleted_Account_Id__c=Acc.id;
    arinfo.Oracle_AR_Customer_ID__c='44444';
    arinfo.AR_Customer_Number__c='12345';
    arinfo.GBMS_ID__c='123456';
    insert arinfo;
    
    
        
Test.StopTest();
    
    

}
   
    static testMethod void test_method_4() 
    {
        SOPService__c serv = new SOPService__c();
        serv.Name = 'Default';
        serv.URL__c = 'test';
        insert serv;
        
        SOPAuthentication__c newAuth = new SOPAuthentication__c();
        newAuth.Name = 'Login Credentials';
        newAuth.Password__c = 'lalalala';
        newAuth.Username__c = 'lalalala';
        insert newAuth;

        String uid = [SELECT Id FROM User WHERE Alias = 'CorpAcct' LIMIT 1].Id;
        Id FirmRTId = ((RecordType)[SELECT Id FROM RecordType WHERE Name = 'Firm' And SObjectType = 'Account']).Id;

        Account acc = new Account();
        acc.Name = 'name-firm';
        acc.RecordTypeId = FirmRTId;
        acc.BillingCity = 'city';
        acc.BillingCountry = 'US';
        acc.BillingState = 'AL';
        acc.BillingPostalCode = '12345-1234';
        acc.BillingStreet = 'street';
        acc.Phone = '12345';
        acc.EMEA__c = True;
        acc.EMEA_Finance_Approved__c = True;
        insert acc;

        SOP_UpsertWrapper suw = new SOP_UpsertWrapper();
        Test.startTest();
        //Test.setMock(WebServiceMock.class, new SalesforceUpsertOrganisationMokup(acc.id));
        
        
        List<Contact > listBooth = new List<Contact>();
        for(Integer i=0;i<16;i++){
            listBooth.add(new Contact (
                
                AccountId = Acc.Id, 
                LastName = 'Test Contact',
                Email = 'test@test.com'
                
            ));  
        }
        insert listBooth;

        map<Id, List<Contact >> map12 = new map<Id, List<Contact >>(); 
        for(Contact  t : listBooth)
        {
            map12.put(t.AccountId , new List<Contact >{t});
        }
    
    
        delete Acc;
    
        AR_Customer_Info__c arinfo = new AR_Customer_Info__c();
        arinfo.Deleted_Account_Id__c=Acc.id;
        arinfo.Oracle_AR_Customer_ID__c='44444';
        arinfo.AR_Customer_Number__c='12345';
        arinfo.GBMS_ID__c='123456';
        insert arinfo;
        Test.stopTest();
    }
    
    static testMethod void test_method_5() 
    {
        Account Facility = TestDataUtil.CreateTestFacility();
        //Test.setMock(WebServiceMock.class, new SalesforceUpsertOrganisationMokup(Facility.id));
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
        test.starttest();
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
       // Booth.EMEA__c = True;    
        insert Booth;
        
        List<Contact > listBooth = new List<Contact>();
        for(Integer i=0;i<16;i++){
            listBooth.add(new Contact (
                AccountId = Facility.Id, 
                LastName = 'Test Contact'+i,
                Email = 'test'+i+'@test.com'
            ));  
        }
        insert listBooth;
        
        Shipping_Address__c ExhibitorAddress = new Shipping_Address__c();
        ExhibitorAddress.Address_1__c = '7000 Bagel Pkwy';
        ExhibitorAddress.City__c = 'Pheonix';
        ExhibitorAddress.State__c = 'AZ';
        ExhibitorAddress.Postal_Code__c = '56044';
        ExhibitorAddress.Country__c = 'United States';
        ExhibitorAddress.Account__c = Exhibitor.Id;
        
        Database.insert(ExhibitorAddress);
        
        Shipping_Address__c ExhibitorAddress2 = new Shipping_Address__c();
        ExhibitorAddress2.Address_1__c = '7150 S Tenaya Way';
        ExhibitorAddress2.City__c = 'Las Vegas';
        ExhibitorAddress2.State__c = 'NV';
        ExhibitorAddress2.Postal_Code__c = '89123';
        ExhibitorAddress2.Country__c = 'United States';
        ExhibitorAddress2.Account__c = Exhibitor.Id;
        
        Database.insert(ExhibitorAddress2);
        
        List<Quote__c> listQuote = new List<Quote__c>();
        for(Integer i=0;i<16;i++){
            listQuote.add(new Quote__c(
                Account_Id__c = Facility.Id, 
                Quote_Subject__c = 'Inbound',
                Source__c = 'Fax',
                Stage__c='Booked',
                Booth__c = Booth.Id,
                Show_Occurrence__c = SalesRepOpp.Id,
                Billing_Contact__c = listBooth[i].Id,
                Origination_Shipping_Address__c = ExhibitorAddress.Id
               // Destination_Shipping_Address__c = ExhibitorAddress.Id
                //Facility__c = Facility.Id,
                //OB_Origination_Shipping_Address__c = ExhibitorAddress2.Id,
                //OB_Destination_Shipping_Address__c = ExhibitorAddress2.Id
                //OB_Facility__c = Facility.Id
            ));  
        }
        insert listQuote;
        test.stoptest();
    }


}