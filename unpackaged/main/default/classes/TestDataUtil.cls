public class TestDataUtil {

       // Retrieve the Salesforce Id for User and Sales Rep
        static Id OwnerId = UserInfo.getUserId();
        static Id SalesRepId = UserInfo.getUserId();
        static Id FacilityRtId;
        static Id FirmRtId;
        static Id ExhRtId;
        static Id OptySalesRepRtId;
        static Id CaseGESUSRtId;
        
        public static Id FacilityRecordTypeId {
            get {
                if (FacilityRtId == null) {
                    //Determine RecordTypeId of "Facility" Account record type.
                    RecordType Rt = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Facility'];
                    FacilityRtId = Rt.Id;
                }
                
                return FacilityRtId;                
            }
        }
        
        public static Id FirmRecordTypeId {
            get {
                if (FirmRtId == null) {
                    //Determine RecordTypeId of "Facility" Account record type.
                    RecordType Rt = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Firm'];
                    FirmRtId = Rt.Id;
                }
                
                return FirmRtId;                
            }
        }
        
        public static Id ExhibitorRecordTypeId {
            get {
                if (ExhRtId == null) {
                    //Determine RecordTypeId of "Facility" Account record type.
                    RecordType Rt = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Exhibitor'];
                    ExhRtId = Rt.Id;
                }
                
                return ExhRtId;             
            }
        }
        
        public static Id OpportunitySalesRepRecordTypeId {
            get {
                if (OptySalesRepRtId == null) {
                    //Determine RecordTypeId of "Facility" Account record type.
                    RecordType Rt = [Select Id From RecordType Where SObjectType = 'Opportunity' And Name = 'Sales Rep Show Occurrence'];
                    OptySalesRepRtId = Rt.Id;
                }
                
                return OptySalesRepRtId;                
            }
        }
        
        /*public static Id CaseGESUSRecordTypeId {
            get {
                if (CaseGESUSRtId == null) {
                    //Determine RecordTypeId of "US Cases" Case record type.
                    RecordType Rt = [Select Id From RecordType Where SObjectType = 'Case' And Name = 'GES US Service'];
                    CaseGESUSRtId = Rt.Id;
                }
                
                return CaseGESUSRtId;             
            }
        }*/
        
        public static Account CreateTestFacility()
        {
            // First create Facility
            Account Facility = new Account();
            Facility.Sales_Person__c = TestDataUtil.SalesRepId;
            Facility.Name = 'MyTestFacilityName';
            Facility.Type = 'Hotel';
            Facility.GES_Status__c = 'Preferred';
            Facility.LMS_Facility_ID__c = 'ABCFAC';
            Facility.BillingStreet = '950 Grier Dr';
            Facility.BillingCity = 'Las Vegas';
            Facility.BillingPostalCode = '89119-0000';
            Facility.BillingState = 'NV';
            Facility.BillingCountry = 'US';
            Facility.RecordTypeId = TestDataUtil.FacilityRecordTypeId;
            
            database.insert(Facility);
            
            return Facility;            
        }
        
        public static Account CreateTestFirm()
        {
            //Create Account of Record Type "Firm"
            Account Firm = new Account();
            Firm.ORACLE_AR_CUST_ACCOUNT_ID__c = '10000001';
            Firm.Sales_Person__c = TestDataUtil.SalesRepId;
            Firm.Name = 'MyTestExhibitorName';
            Firm.Phone = '7022631500';
            Firm.BillingStreet = '950 Grier Dr';
            Firm.BillingCity = 'Las Vegas';
            Firm.BillingPostalCode = '89119-0000';
            Firm.BillingState = 'NV';
            Firm.BillingCountry = 'US';
            Firm.RecordTypeId = TestDataUtil.FirmRecordTypeId;
            
            database.insert(Firm);
            return Firm;      
        }
        
        public static Account CreateTestExhibitor()
        {
            //Create Account of Record Type "Firm"
            Account Exh = new Account();
            Exh.ORACLE_AR_CUST_ACCOUNT_ID__c = '10000001';
            Exh.Sales_Person__c = TestDataUtil.SalesRepId;
            Exh.Name = 'MyTestExhibitorName';
            Exh.Phone = '7022631500';
            Exh.BillingStreet = '950 Grier Dr';
            Exh.BillingCity = 'Las Vegas';
            Exh.BillingPostalCode = '89119-0000';
            Exh.BillingState = 'NV';
            Exh.BillingCountry = 'US';
            Exh.RecordTypeId = TestDataUtil.ExhibitorRecordTypeId;
            
            database.insert(Exh);
            
            return Exh;         
        }
        
        public static Contact CreateTestContact() {
            Account Firm = CreateTestFirm();
            Contact Con = new Contact();
            Con.FirstName = 'First Name';
            Con.LastName = 'Last Name';
            Con.Email = 'fnamelname@fakeemail.com';
            Con.Phone = '7022631500';
            Con.AccountID = firm.Id;
            //Con.CurrencyIsoCode = 'USD - U.S. Dollar';
            Database.insert(Con);
            
            return Con;
        }
        
        public static Contact CreateTestContact(string accountId) {
            Contact Con = new Contact();
            Con.FirstName = 'First Name W Account';
            Con.LastName = 'Last Name W Account';
            Con.Email = 'fnamelnamewaccount@fakeemail.com';
            Con.AccountId = accountId;
            
            Database.insert(Con);
            
            return Con;
        }        

        public static Show__c CreateTestShow(Id firmId)
        {
            //Create Show
            Show__c Show = new Show__c();
            Show.Sales_Person__c = TestDataUtil.SalesRepId;
            Show.Account__c = firmId;
            Show.Name ='MyTestShow001';
            Show.Show_Type__c = 'Food Sector';
            Show.Show_ID__c = '123456';
            
            database.insert(Show);
            
            return Show;
        }
        
        public static Opportunity CreateTestSalesRepOpp(Id facilityId, Id firmId, Id showId)
        {
            //Then create Show Occurrence
            Opportunity Opp = new Opportunity();
           
            Opp.Job_Number__c = '20121231';
            Opp.OwnerId = TestDataUtil.OwnerId;
            Opp.Sales_Person__c = TestDataUtil.SalesRepId;
            Opp.Sales_Location__c = '110- Las Vegas';
            Opp.Name = 'MyTestShow # 1';
            Opp.Prime_Contractor__c = null;
            Opp.Production_Location__c = '110- Las Vegas';
            Opp.Facility__c = facilityId;
            Opp.StageName = 'SL1';
            Opp.Amount = 1000;
            Opp.Probability = 25;
            Opp.Type = 'ITYFTY';
            Opp.New_Repeat__c = 'New';
            Opp.Frequency__c = 'B1';
            Opp.AccountId = firmId;
            Opp.Show_Name__c = showId;
            Opp.RecordTypeId = TestDataUtil.OpportunitySalesRepRecordTypeId;        
            Opp.Show_Open_Date__c = Date.newInstance(2012,12,1);
            Opp.Show_Close_Date__c = Date.newInstance(2012,12,2);
            Opp.CloseDate = Date.newInstance(2012,12,2);
            
            Database.insert(Opp);
            
            return Opp;
        }
        
        public static Oracle_Show_Booth__c CreateTestBooth(Id exhibitorId, Id opportunityId, string jobNumber, string showID) {
            
            Oracle_Show_Booth__c Booth = new  Oracle_Show_Booth__c();
            
            Booth.Account__c = exhibitorId;
            Booth.Show_Occurrence__c = opportunityId;        
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
            Booth.PROJECT_NUMBER__c = jobNumber;
            Booth.SHOW_ID__c = showID;
            Booth.THIRD_PARTY_FLAG__c = false;
            Booth.SHOW_ORG_FLAG__c =  false;        
            
            Database.insert(Booth); 
            
            return Booth;
        }
        
        public static Oracle_Show_Booth_Contact__c CreateTestBoothContact(Id boothId, Id conId, integer areaCode, string conRole, string conType, string countryCode, string custBthId, string custConId, string email, integer extension, string fax, string firstName, string lastName, string phone, string primaryFlag, string showOccrCustId) {
            
            Oracle_Show_Booth_Contact__c BC = new  Oracle_Show_Booth_Contact__c();
            
            BC.Oracle_Show_Booth__c = boothId;
            BC.Contact__c = conId;
            BC.AREA_CODE__c = areaCode;
            BC.CONTACT_ROLE__c = conRole;
            BC.CONTACT_TYPE__c = conType;
            BC.COUNTRY_CODE__c = countryCode;
            BC.CUST_BOOTH_ID__c = custBthId;
            BC.CUST_CONT_ID__c = custConId;
            BC.EMAIL__c = email;
            BC.EXTENSION__c = extension;
            BC.FAX__c = fax;
            BC.FIRST_NAME__c = firstName;
            BC.LAST_NAME__c = lastName;
            BC.PHONE__c = phone;
            BC.PRIMARY_FLAG__c = primaryFlag;
            BC.SHOW_OCCR_CUST_ID__c = showOccrCustId; 
            
            Database.insert(BC); 
            
            return BC;
        }
        
        public static Case CreateTestCase(Id exhibitorId, Id boothId, Id contactId, Id optyId) {
            Case C = new Case();
            //C.RecordTypeId = TestDataUtil.CaseGESUSRecordTypeId;
            c.RecordTypeId = SObjectType.Case.getRecordTypeInfosByName().get('GES US Service').getRecordTypeId();
            C.Subject = 'Some subject';
            C.AccountId = exhibitorId;
            C.Booth__c = boothId;
            C.ContactId = contactId;
            C.Show_Opportunity__c = optyId;
            C.Show_Status__c = '1-Pre';
            C.GES_Type__c = 'Billing Error';
            C.Reason__c = 'Adv Receiving';
            C.Customer_Type__c = 'Exhibitor';
            C.Escalated_To__c = '8 - None';
            C.Priority = 'Low Priority';
            C.Status = 'Open';
            C.Substatus__c = 'None Required';
            
            Database.insert(C);
            
            return C;
        }
        
        public static Task CreateTestOverDueTask(Id whatId, Id whoId)
        {
            Task T = new Task();
            T.WhatId = whatId;
            T.WhoId = whoId;
            T.Type = 'Email';
            T.Subject = 'Some subject';
            T.Description = 'Some description';
            T.ActivityDate = Date.newInstance(2012,10,2);
            
            Database.insert(T);
            
            return T;
        }
        
        public static Staging_Oracle_Show_Booth_Contact__c  CreateTestStagingBoothContact(integer areaCode, string conRole, string conType, string countryCode, string custBthId, string custConId, string email, integer extension, string fax, string firstName, string lastName, string phone, string primaryFlag, string showOccrCustId, string interfaceStatus, string interfaceBatchNo)
        {
            Staging_Oracle_Show_Booth_Contact__c StgBC = new  Staging_Oracle_Show_Booth_Contact__c();
            
            StgBC.AREA_CODE__c = areaCode;
            StgBC.CONTACT_ROLE__c = conRole;
            StgBC.CONTACT_TYPE__c = conType;
            StgBC.COUNTRY_CODE__c = countryCode;
            StgBC.CUST_BTH_ID__c = custBthId;
            StgBC.CUST_CONT_ID__c = custConId;
            StgBC.EMAIL_ADDRESS__c = email;
            StgBC.EXTENSION__c = extension;
            StgBC.FAX__c = fax;
            StgBC.FIRST_NAME__c = firstName;
            StgBC.LAST_NAME__c = lastName;
            StgBC.PHONE__c = phone;
            StgBC.PRIMARY_FLAG__c = primaryFlag;
            StgBC.SHOW_OCCR_CUST_ID__c = showOccrCustId;
            StgBC.Interface_Status__c = interfaceStatus;
            StgBC.Interface_Batch_Number__c = interfaceBatchNo;
            
            Database.insert(StgBC);
            
            return StgBC;
        }
        
    public static Employees__c createTestEmployee() {
        Employees__c emp = new Employees__c(Name = 'Test Employee', Email_Address__c='test@test.com');
        return emp;
    }
    
    public static Customer_Service_Inquiries_ICS__c createTestCustomerServiceInquries() {
        Customer_Service_Inquiries_ICS__c ICS = new Customer_Service_Inquiries_ICS__c(Sales_Channel__c='E&E (Trade Show)');
        //Customer_Name__c='Test Customer',                                                                                         
        return ICS;
    }
    
    public static AR_Adjustments__c createTestARAdjustment(Id CSIId) {
        AR_Adjustments__c arAdj = new AR_Adjustments__c(AR_Adj_CSI_ID__c=CSIId, Amount__c=100, 
                                                       Billing_ID__c = '1001', Sales_Order__c = '2001',LOB__c='AUDIO VISUAL', Justification_for_AR_Adjustment_Request__c='Testing');
        return arAdj;
    }
    
    public static Credit_Memo_ICS__c createTestCreditMemo(Id CSIId) {
        Credit_Memo_ICS__c creditMemo = new Credit_Memo_ICS__c(CSI_ICS__c=CSIId,
                                            Amount_w_psp__c=20000,Tax_Amount__c=200,
                                            Credit_Memo_Reason__c='Bad Debt: CM',Credit_LOB__c='AUDIO VISUAL',
                                            Sales_Channel__c='E&E Logistics (Trade Show)', Justification_for_Credit_Memo_Request__c='testing'   );
        return creditMemo;
    }
    
    public static Refunds_ICS__c createTestRefund(Id CSIId) {
        Refunds_ICS__c refund = new Refunds_ICS__c(CSI_ICS__c=CSIId, Amount__c=100, Last_4_of_CC__c ='1001', Last_4_of_Token__c = '2002', Justification_for_Refunds_Request__c='testing');
        return refund;
    }
    
    public static Receipt_Reversals__c createTestReceiptReversal(Id CSIId) {
        Receipt_Reversals__c receiptReversal = new Receipt_Reversals__c(CSI_ICS__c=CSIId, Receipt_Reversal_Amount__c=100, Justification_for_Receipt_Rvsl_Request__c='testing');
        return receiptReversal;
    }
    
     public static Charges__c createTestCharges(Id CSIId) {
        Charges__c Charges = new Charges__c(CSI_ICS__c=CSIId, Total_Amount__c=100, Justification_for_Charges_Request__c='testing');
        return Charges;
    }
    
     public static Payment_Transfer_ICS__c createTestPaymentTransfer(Id CSIId) {
        Payment_Transfer_ICS__c PaymentTransfer = new Payment_Transfer_ICS__c(CSI_ICS_No__c=CSIId, Transfer_Amount__c=100, Transfer_Amount_No__c=200, Justification_for_Pymt_Transfer_Request__c='testing');
        return PaymentTransfer;
    }
    
    public static ICS_Approver_Matrix__c createTestApproverMatrix(Id empId) {
        ICS_Approver_Matrix__c approverMatrix = new ICS_Approver_Matrix__c(Transaction_Types__c='Credit Memo', Min_Amount__c=0, Max_Amount__c=1000,
                                                    LOB_Approver__c=empId, F_R_Approver__c=empId, AR1_Approver__c=empId, AR2_Approver__c=empId, Additional_Approver__c=empId, 
                                                                           Reason_Code_Category__c='Cat - A', LOB__c = 'AUDIO VISUAL',Sales_Channel__c='E&E (Trade Show)', CSO_Approver__c=empId);
        return approverMatrix;
    }

    public static Show_Occurrence_Public__c createShowOccurrencePublic(Opportunity opp){
        System.debug('@@@ '+opp.Name);
        //System.debug('@@@ '+opp.Name.substring(0,79));
        String oppName = opp.Name;
        if(oppName.length() > 80){
            oppName = opp.Name.substring(0, 79);
        }
        return new Show_Occurrence_Public__c(Name = oppName, Show_Occurrence_Ref__c = opp.Id);
    }

    @isTest static void unitTestDataUtil(){
        
        Account fac = CreateTestFacility();
        Account acc = CreateTestFirm();
        Account exh = CreateTestExhibitor();
        Contact con1 = CreateTestContact();
        Contact con2 = CreateTestContact(acc.Id);
        Show__c show = CreateTestShow(acc.Id);
        Test.startTest();
        Opportunity salesOpp = CreateTestSalesRepOpp(fac.Id,acc.Id,show.Id);
        
        Oracle_Show_Booth__c showBooth = CreateTestBooth(exh.Id,salesOpp.Id,'12345',show.Id);
        String boothId = showBooth.Id;
        String contId = con2.Id;
        Oracle_Show_Booth_Contact__c showBoothContact = CreateTestBoothContact(showBooth.Id,con1.Id,12345,'Account Manager','Test Contact','NV',boothId.subString(0,boothId.length()-3),contId.subString(0,contId.length()-3),'test@test.com',1234,'1234567890','testfirst','testlast','1234567890','Y',contId.subString(0,contId.length()-3));
        Test.stopTest();
        Case c = CreateTestCase(exh.Id,showBooth.Id,con1.Id,salesOpp.Id);
        
        Task testTask = CreateTestOverDueTask(acc.Id,con2.Id);
        createTestEmployee();
        createTestCustomerServiceInquries();
        createShowOccurrencePublic(salesOpp);
        
        
        
    }
}