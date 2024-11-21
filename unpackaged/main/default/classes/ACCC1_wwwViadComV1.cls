//Generated by wsdl2apex

public class ACCC1_wwwViadComV1 {
    public class FileCreditCard_element {
        public String applicationSessionId;
        public String customerBoothId;
        public ACCC1_wwwViadComV1.CreditCardInfo creditCardInfo;
        public String billingCategory;
        private String[] applicationSessionId_type_info = new String[]{'applicationSessionId','www.viad.com/v1',null,'0','1','true'};
        private String[] customerBoothId_type_info = new String[]{'customerBoothId','www.viad.com/v1',null,'0','1','true'};
        private String[] creditCardInfo_type_info = new String[]{'creditCardInfo','www.viad.com/v1',null,'0','1','true'};
        private String[] billingCategory_type_info = new String[]{'billingCategory','www.viad.com/v1',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'www.viad.com/v1','true','false'};
        private String[] field_order_type_info = new String[]{'applicationSessionId','customerBoothId','creditCardInfo','billingCategory'};
    }
    public class UpdatePaymentCollection_element {
        public String applicationSessionId;
        public String paymentCollectionId;
        public String customerName;
        public String customerCompanyName;
        public String emailAddress;
        public Decimal balanceDue;
        public String customerBoothID;
        public String customerID;
        public String referenceShowName;
        public String requestingPartyNameOverride;
        public String emailHtmlFormat;
        public String notes;
        public Boolean resendEmail;
        public Boolean refreshExpirationDate;
        private String[] applicationSessionId_type_info = new String[]{'applicationSessionId','www.viad.com/v1',null,'0','1','true'};
        private String[] paymentCollectionId_type_info = new String[]{'paymentCollectionId','www.viad.com/v1',null,'0','1','false'};
        private String[] customerName_type_info = new String[]{'customerName','www.viad.com/v1',null,'0','1','true'};
        private String[] customerCompanyName_type_info = new String[]{'customerCompanyName','www.viad.com/v1',null,'0','1','true'};
        private String[] emailAddress_type_info = new String[]{'emailAddress','www.viad.com/v1',null,'0','1','true'};
        private String[] balanceDue_type_info = new String[]{'balanceDue','www.viad.com/v1',null,'0','1','false'};
        private String[] customerBoothID_type_info = new String[]{'customerBoothID','www.viad.com/v1',null,'0','1','true'};
        private String[] customerID_type_info = new String[]{'customerID','www.viad.com/v1',null,'0','1','true'};
        private String[] referenceShowName_type_info = new String[]{'referenceShowName','www.viad.com/v1',null,'0','1','true'};
        private String[] requestingPartyNameOverride_type_info = new String[]{'requestingPartyNameOverride','www.viad.com/v1',null,'0','1','true'};
        private String[] emailHtmlFormat_type_info = new String[]{'emailHtmlFormat','www.viad.com/v1',null,'0','1','true'};
        private String[] notes_type_info = new String[]{'notes','www.viad.com/v1',null,'0','1','true'};
        private String[] resendEmail_type_info = new String[]{'resendEmail','www.viad.com/v1',null,'0','1','false'};
        private String[] refreshExpirationDate_type_info = new String[]{'refreshExpirationDate','www.viad.com/v1',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'www.viad.com/v1','true','false'};
        private String[] field_order_type_info = new String[]{'applicationSessionId','paymentCollectionId','customerName','customerCompanyName','emailAddress','balanceDue','customerBoothID','customerID','referenceShowName','requestingPartyNameOverride','emailHtmlFormat','notes','resendEmail','refreshExpirationDate'};
    }
    public class FileCreditCardResponse_element {
        public String FileCreditCardResult;
        private String[] FileCreditCardResult_type_info = new String[]{'FileCreditCardResult','www.viad.com/v1',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'www.viad.com/v1','true','false'};
        private String[] field_order_type_info = new String[]{'FileCreditCardResult'};
    }
    public class GetPaymentCollectionResponse_element {
        public ACCC1_wwwViadComV1.PaymentCollectionInfo GetPaymentCollectionResult;
        private String[] GetPaymentCollectionResult_type_info = new String[]{'GetPaymentCollectionResult','www.viad.com/v1',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'www.viad.com/v1','true','false'};
        private String[] field_order_type_info = new String[]{'GetPaymentCollectionResult'};
    }
    public class SubmitPaymentCollectionResponse_element {
        private String[] apex_schema_type_info = new String[]{'www.viad.com/v1','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class UpdatePaymentCollectionResponse_element {
        private String[] apex_schema_type_info = new String[]{'www.viad.com/v1','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class RequestPaymentCollection_element {
        public String applicationSessionId;
        public String customerBoothId;
        public String customerName;
        public String customerCompanyName;
        public String emailAddress;
        public Decimal balanceDue;
        public String referenceShowName;
        public String requestingPartyNameOverride;
        public String emailHtmlFormat;
        public String notes;
        private String[] applicationSessionId_type_info = new String[]{'applicationSessionId','www.viad.com/v1',null,'0','1','true'};
        private String[] customerBoothId_type_info = new String[]{'customerBoothId','www.viad.com/v1',null,'0','1','true'};
        private String[] customerName_type_info = new String[]{'customerName','www.viad.com/v1',null,'0','1','true'};
        private String[] customerCompanyName_type_info = new String[]{'customerCompanyName','www.viad.com/v1',null,'0','1','true'};
        private String[] emailAddress_type_info = new String[]{'emailAddress','www.viad.com/v1',null,'0','1','true'};
        private String[] balanceDue_type_info = new String[]{'balanceDue','www.viad.com/v1',null,'0','1','false'};
        private String[] referenceShowName_type_info = new String[]{'referenceShowName','www.viad.com/v1',null,'0','1','true'};
        private String[] requestingPartyNameOverride_type_info = new String[]{'requestingPartyNameOverride','www.viad.com/v1',null,'0','1','true'};
        private String[] emailHtmlFormat_type_info = new String[]{'emailHtmlFormat','www.viad.com/v1',null,'0','1','true'};
        private String[] notes_type_info = new String[]{'notes','www.viad.com/v1',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'www.viad.com/v1','true','false'};
        private String[] field_order_type_info = new String[]{'applicationSessionId','customerBoothId','customerName','customerCompanyName','emailAddress','balanceDue','referenceShowName','requestingPartyNameOverride','emailHtmlFormat','notes'};
    }
    public class GetPaymentCollection_element {
        public String applicationSessionId;
        public String paymentCollectionId;
        private String[] applicationSessionId_type_info = new String[]{'applicationSessionId','www.viad.com/v1',null,'0','1','true'};
        private String[] paymentCollectionId_type_info = new String[]{'paymentCollectionId','www.viad.com/v1',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'www.viad.com/v1','true','false'};
        private String[] field_order_type_info = new String[]{'applicationSessionId','paymentCollectionId'};
    }
    public class RequestPaymentCollectionResponse_element {
        public String RequestPaymentCollectionResult;
        private String[] RequestPaymentCollectionResult_type_info = new String[]{'RequestPaymentCollectionResult','www.viad.com/v1',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'www.viad.com/v1','true','false'};
        private String[] field_order_type_info = new String[]{'RequestPaymentCollectionResult'};
    }
    public class RequestPaymentCollectionMinimal_element {
        public String applicationSessionId;
        public String customerBoothId;
        public String customerName;
        public String customerCompanyName;
        public String emailAddress;
        public Decimal balanceDue;
        private String[] applicationSessionId_type_info = new String[]{'applicationSessionId','www.viad.com/v1',null,'0','1','true'};
        private String[] customerBoothId_type_info = new String[]{'customerBoothId','www.viad.com/v1',null,'0','1','true'};
        private String[] customerName_type_info = new String[]{'customerName','www.viad.com/v1',null,'0','1','true'};
        private String[] customerCompanyName_type_info = new String[]{'customerCompanyName','www.viad.com/v1',null,'0','1','true'};
        private String[] emailAddress_type_info = new String[]{'emailAddress','www.viad.com/v1',null,'0','1','true'};
        private String[] balanceDue_type_info = new String[]{'balanceDue','www.viad.com/v1',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'www.viad.com/v1','true','false'};
        private String[] field_order_type_info = new String[]{'applicationSessionId','customerBoothId','customerName','customerCompanyName','emailAddress','balanceDue'};
    }
    public class SubmitPaymentCollection_element {
        public String applicationSessionId;
        public String paymentCollectionId;
        public Integer creditCardId;
        private String[] applicationSessionId_type_info = new String[]{'applicationSessionId','www.viad.com/v1',null,'0','1','true'};
        private String[] paymentCollectionId_type_info = new String[]{'paymentCollectionId','www.viad.com/v1',null,'0','1','false'};
        private String[] creditCardId_type_info = new String[]{'creditCardId','www.viad.com/v1',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'www.viad.com/v1','true','false'};
        private String[] field_order_type_info = new String[]{'applicationSessionId','paymentCollectionId','creditCardId'};
    }
    public class CreditCardInfo {
        public String Address;
        public String CardClass;
        public String CardHolderName;
        public String CardName;
        public String CardType;
        public String City;
        public String Country;
        public Integer ExpirationMonth;
        public Integer ExpirationYear;
        public String LastFour;
        public String PostalCode;
        public String State;
        public String Token;
        private String[] Address_type_info = new String[]{'Address','www.viad.com/v1',null,'0','1','true'};
        private String[] CardClass_type_info = new String[]{'CardClass','www.viad.com/v1',null,'0','1','true'};
        private String[] CardHolderName_type_info = new String[]{'CardHolderName','www.viad.com/v1',null,'0','1','true'};
        private String[] CardName_type_info = new String[]{'CardName','www.viad.com/v1',null,'0','1','true'};
        private String[] CardType_type_info = new String[]{'CardType','www.viad.com/v1',null,'0','1','true'};
        private String[] City_type_info = new String[]{'City','www.viad.com/v1',null,'0','1','true'};
        private String[] Country_type_info = new String[]{'Country','www.viad.com/v1',null,'0','1','true'};
        private String[] ExpirationMonth_type_info = new String[]{'ExpirationMonth','www.viad.com/v1',null,'0','1','false'};
        private String[] ExpirationYear_type_info = new String[]{'ExpirationYear','www.viad.com/v1',null,'0','1','false'};
        private String[] LastFour_type_info = new String[]{'LastFour','www.viad.com/v1',null,'0','1','true'};
        private String[] PostalCode_type_info = new String[]{'PostalCode','www.viad.com/v1',null,'0','1','true'};
        private String[] State_type_info = new String[]{'State','www.viad.com/v1',null,'0','1','true'};
        private String[] Token_type_info = new String[]{'Token','www.viad.com/v1',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'www.viad.com/v1','true','false'};
        private String[] field_order_type_info = new String[]{'Address','CardClass','CardHolderName','CardName','CardType','City','Country','ExpirationMonth','ExpirationYear','LastFour','PostalCode','State','Token'};
    }
    public class RequestPaymentCollectionMinimalResponse_element {
        public String RequestPaymentCollectionMinimalResult;
        private String[] RequestPaymentCollectionMinimalResult_type_info = new String[]{'RequestPaymentCollectionMinimalResult','www.viad.com/v1',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'www.viad.com/v1','true','false'};
        private String[] field_order_type_info = new String[]{'RequestPaymentCollectionMinimalResult'};
    }
    public class PaymentCollectionInfo {
        public String CreditCardAddress;
        public String CreditCardCardClass;
        public String CreditCardCardType;
        public String CreditCardCardholderName;
        public String CreditCardCity;
        public String CreditCardCountryAlpha2Code;
        public String CreditCardCountryName;
        public DateTime CreditCardDateModified;
        public String CreditCardEndingWith;
        public Integer CreditCardExpireMonth;
        public Integer CreditCardExpireYear;
        public String CreditCardNickname;
        public String CreditCardPostalCode;
        public String CreditCardState;
        public String CreditCardToken;
        public String CreditCardUserLoginName;
        public Decimal CustomerBalanceDue;
        public String CustomerCompanyName;
        public String CustomerEmailAddress;
        public String CustomerFullName;
        public DateTime DateExpired;
        public DateTime DateFirstViewed;
        public DateTime DateModified;
        public DateTime DateRequested;
        public DateTime DateSubmitted;
        public String ExternalCreditCardID;
        public String ExternalCustomerBoothID;
        public String ExternalCustomerID;
        public String ID;
        public String Notes;
        public String ReferenceShowName;
        public String RequestingApplicationNameOverride;
        private String[] CreditCardAddress_type_info = new String[]{'CreditCardAddress','www.viad.com/v1',null,'0','1','true'};
        private String[] CreditCardCardClass_type_info = new String[]{'CreditCardCardClass','www.viad.com/v1',null,'0','1','true'};
        private String[] CreditCardCardType_type_info = new String[]{'CreditCardCardType','www.viad.com/v1',null,'0','1','true'};
        private String[] CreditCardCardholderName_type_info = new String[]{'CreditCardCardholderName','www.viad.com/v1',null,'0','1','true'};
        private String[] CreditCardCity_type_info = new String[]{'CreditCardCity','www.viad.com/v1',null,'0','1','true'};
        private String[] CreditCardCountryAlpha2Code_type_info = new String[]{'CreditCardCountryAlpha2Code','www.viad.com/v1',null,'0','1','true'};
        private String[] CreditCardCountryName_type_info = new String[]{'CreditCardCountryName','www.viad.com/v1',null,'0','1','true'};
        private String[] CreditCardDateModified_type_info = new String[]{'CreditCardDateModified','www.viad.com/v1',null,'0','1','true'};
        private String[] CreditCardEndingWith_type_info = new String[]{'CreditCardEndingWith','www.viad.com/v1',null,'0','1','true'};
        private String[] CreditCardExpireMonth_type_info = new String[]{'CreditCardExpireMonth','www.viad.com/v1',null,'0','1','true'};
        private String[] CreditCardExpireYear_type_info = new String[]{'CreditCardExpireYear','www.viad.com/v1',null,'0','1','true'};
        private String[] CreditCardNickname_type_info = new String[]{'CreditCardNickname','www.viad.com/v1',null,'0','1','true'};
        private String[] CreditCardPostalCode_type_info = new String[]{'CreditCardPostalCode','www.viad.com/v1',null,'0','1','true'};
        private String[] CreditCardState_type_info = new String[]{'CreditCardState','www.viad.com/v1',null,'0','1','true'};
        private String[] CreditCardToken_type_info = new String[]{'CreditCardToken','www.viad.com/v1',null,'0','1','true'};
        private String[] CreditCardUserLoginName_type_info = new String[]{'CreditCardUserLoginName','www.viad.com/v1',null,'0','1','true'};
        private String[] CustomerBalanceDue_type_info = new String[]{'CustomerBalanceDue','www.viad.com/v1',null,'0','1','false'};
        private String[] CustomerCompanyName_type_info = new String[]{'CustomerCompanyName','www.viad.com/v1',null,'0','1','true'};
        private String[] CustomerEmailAddress_type_info = new String[]{'CustomerEmailAddress','www.viad.com/v1',null,'0','1','true'};
        private String[] CustomerFullName_type_info = new String[]{'CustomerFullName','www.viad.com/v1',null,'0','1','true'};
        private String[] DateExpired_type_info = new String[]{'DateExpired','www.viad.com/v1',null,'0','1','false'};
        private String[] DateFirstViewed_type_info = new String[]{'DateFirstViewed','www.viad.com/v1',null,'0','1','true'};
        private String[] DateModified_type_info = new String[]{'DateModified','www.viad.com/v1',null,'0','1','true'};
        private String[] DateRequested_type_info = new String[]{'DateRequested','www.viad.com/v1',null,'0','1','false'};
        private String[] DateSubmitted_type_info = new String[]{'DateSubmitted','www.viad.com/v1',null,'0','1','true'};
        private String[] ExternalCreditCardID_type_info = new String[]{'ExternalCreditCardID','www.viad.com/v1',null,'0','1','true'};
        private String[] ExternalCustomerBoothID_type_info = new String[]{'ExternalCustomerBoothID','www.viad.com/v1',null,'0','1','true'};
        private String[] ExternalCustomerID_type_info = new String[]{'ExternalCustomerID','www.viad.com/v1',null,'0','1','true'};
        private String[] ID_type_info = new String[]{'ID','www.viad.com/v1',null,'0','1','false'};
        private String[] Notes_type_info = new String[]{'Notes','www.viad.com/v1',null,'0','1','true'};
        private String[] ReferenceShowName_type_info = new String[]{'ReferenceShowName','www.viad.com/v1',null,'0','1','true'};
        private String[] RequestingApplicationNameOverride_type_info = new String[]{'RequestingApplicationNameOverride','www.viad.com/v1',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'www.viad.com/v1','true','false'};
        private String[] field_order_type_info = new String[]{'CreditCardAddress','CreditCardCardClass','CreditCardCardType','CreditCardCardholderName','CreditCardCity','CreditCardCountryAlpha2Code','CreditCardCountryName','CreditCardDateModified','CreditCardEndingWith','CreditCardExpireMonth','CreditCardExpireYear','CreditCardNickname','CreditCardPostalCode','CreditCardState','CreditCardToken','CreditCardUserLoginName','CustomerBalanceDue','CustomerCompanyName','CustomerEmailAddress','CustomerFullName','DateExpired','DateFirstViewed','DateModified','DateRequested','DateSubmitted','ExternalCreditCardID','ExternalCustomerBoothID','ExternalCustomerID','ID','Notes','ReferenceShowName','RequestingApplicationNameOverride'};
    }
    public class BasicHttpBinding_IPaymentCollectionService {
        public String endpoint_x =System.Label.ACCC_Label_PaymentCollection; // 'https://qaapi.viad.com/GES/v1/PaymentCollectionService.svc';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'www.viad.com', 'ACCC1_wwwViadCom', 'http://schemas.microsoft.com/2003/10/Serialization/', 'ACC1_schemasMicrosoftCom200310Serializat', 'www.viad.com/v1', 'ACCC1_wwwViadComV1'};
            public void SubmitPaymentCollection(String applicationSessionId,String paymentCollectionId,Integer creditCardId) {
            ACCC1_wwwViadComV1.SubmitPaymentCollection_element request_x = new ACCC1_wwwViadComV1.SubmitPaymentCollection_element();
            request_x.applicationSessionId = applicationSessionId;
            request_x.paymentCollectionId = paymentCollectionId;
            request_x.creditCardId = creditCardId;
            ACCC1_wwwViadComV1.SubmitPaymentCollectionResponse_element response_x;
            Map<String, ACCC1_wwwViadComV1.SubmitPaymentCollectionResponse_element> response_map_x = new Map<String, ACCC1_wwwViadComV1.SubmitPaymentCollectionResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'www.viad.com/v1/IPaymentCollectionService/SubmitPaymentCollection',
              'www.viad.com/v1',
              'SubmitPaymentCollection',
              'www.viad.com/v1',
              'SubmitPaymentCollectionResponse',
              'ACCC1_wwwViadComV1.SubmitPaymentCollectionResponse_element'}
            );
            response_x = response_map_x.get('response_x');
        }
        public ACCC1_wwwViadComV1.PaymentCollectionInfo GetPaymentCollection(String applicationSessionId,String paymentCollectionId) {
            ACCC1_wwwViadComV1.GetPaymentCollection_element request_x = new ACCC1_wwwViadComV1.GetPaymentCollection_element();
            request_x.applicationSessionId = applicationSessionId;
            request_x.paymentCollectionId = paymentCollectionId;
            ACCC1_wwwViadComV1.GetPaymentCollectionResponse_element response_x;
            Map<String, ACCC1_wwwViadComV1.GetPaymentCollectionResponse_element> response_map_x = new Map<String, ACCC1_wwwViadComV1.GetPaymentCollectionResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'www.viad.com/v1/IPaymentCollectionService/GetPaymentCollection',
              'www.viad.com/v1',
              'GetPaymentCollection',
              'www.viad.com/v1',
              'GetPaymentCollectionResponse',
              'ACCC1_wwwViadComV1.GetPaymentCollectionResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.GetPaymentCollectionResult;
        }
        public String RequestPaymentCollectionMinimal(String applicationSessionId,String customerBoothId,String customerName,String customerCompanyName,String emailAddress,Decimal balanceDue) {
            ACCC1_wwwViadComV1.RequestPaymentCollectionMinimal_element request_x = new ACCC1_wwwViadComV1.RequestPaymentCollectionMinimal_element();
            request_x.applicationSessionId = applicationSessionId;
            request_x.customerBoothId = customerBoothId;
            request_x.customerName = customerName;
            request_x.customerCompanyName = customerCompanyName;
            request_x.emailAddress = emailAddress;
            request_x.balanceDue = balanceDue;
            ACCC1_wwwViadComV1.RequestPaymentCollectionMinimalResponse_element response_x;
            Map<String, ACCC1_wwwViadComV1.RequestPaymentCollectionMinimalResponse_element> response_map_x = new Map<String, ACCC1_wwwViadComV1.RequestPaymentCollectionMinimalResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'www.viad.com/v1/IPaymentCollectionService/RequestPaymentCollectionMinimal',
              'www.viad.com/v1',
              'RequestPaymentCollectionMinimal',
              'www.viad.com/v1',
              'RequestPaymentCollectionMinimalResponse',
              'ACCC1_wwwViadComV1.RequestPaymentCollectionMinimalResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.RequestPaymentCollectionMinimalResult;
        }
        public String RequestPaymentCollection(String applicationSessionId,String customerBoothId,String customerName,String customerCompanyName,String emailAddress,Decimal balanceDue,String referenceShowName,String requestingPartyNameOverride,String emailHtmlFormat,String notes) {
            ACCC1_wwwViadComV1.RequestPaymentCollection_element request_x = new ACCC1_wwwViadComV1.RequestPaymentCollection_element();
            request_x.applicationSessionId = applicationSessionId;
            request_x.customerBoothId = customerBoothId;
            request_x.customerName = customerName;
            request_x.customerCompanyName = customerCompanyName;
            request_x.emailAddress = emailAddress;
            request_x.balanceDue = balanceDue;
            request_x.referenceShowName = referenceShowName;
            request_x.requestingPartyNameOverride = requestingPartyNameOverride;
            request_x.emailHtmlFormat = emailHtmlFormat;
            request_x.notes = notes;
            ACCC1_wwwViadComV1.RequestPaymentCollectionResponse_element response_x = new ACCC1_wwwViadComV1.RequestPaymentCollectionResponse_element();
            Map<String, ACCC1_wwwViadComV1.RequestPaymentCollectionResponse_element> response_map_x = new Map<String, ACCC1_wwwViadComV1.RequestPaymentCollectionResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'www.viad.com/v1/IPaymentCollectionService/RequestPaymentCollection',
              'www.viad.com/v1',
              'RequestPaymentCollection',
              'www.viad.com/v1',
              'RequestPaymentCollectionResponse',
              'ACCC1_wwwViadComV1.RequestPaymentCollectionResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.RequestPaymentCollectionResult;
        }
        public String FileCreditCard(String applicationSessionId,String customerBoothId,ACCC1_wwwViadComV1.CreditCardInfo creditCardInfo,String billingCategory) {
            ACCC1_wwwViadComV1.FileCreditCard_element request_x = new ACCC1_wwwViadComV1.FileCreditCard_element();
            request_x.applicationSessionId = applicationSessionId;
            request_x.customerBoothId = customerBoothId;
            request_x.creditCardInfo = creditCardInfo;
            request_x.billingCategory = billingCategory;
            ACCC1_wwwViadComV1.FileCreditCardResponse_element response_x;
            Map<String, ACCC1_wwwViadComV1.FileCreditCardResponse_element> response_map_x = new Map<String, ACCC1_wwwViadComV1.FileCreditCardResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'www.viad.com/v1/IPaymentCollectionService/FileCreditCard',
              'www.viad.com/v1',
              'FileCreditCard',
              'www.viad.com/v1',
              'FileCreditCardResponse',
              'ACCC1_wwwViadComV1.FileCreditCardResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.FileCreditCardResult;
        }
        public void UpdatePaymentCollection(String applicationSessionId,String paymentCollectionId,String customerName,String customerCompanyName,String emailAddress,Decimal balanceDue,String customerBoothID,String customerID,String referenceShowName,String requestingPartyNameOverride,String emailHtmlFormat,String notes,Boolean resendEmail,Boolean refreshExpirationDate) {
            ACCC1_wwwViadComV1.UpdatePaymentCollection_element request_x = new ACCC1_wwwViadComV1.UpdatePaymentCollection_element();
            request_x.applicationSessionId = applicationSessionId;
            request_x.paymentCollectionId = paymentCollectionId;
            request_x.customerName = customerName;
            request_x.customerCompanyName = customerCompanyName;
            request_x.emailAddress = emailAddress;
            request_x.balanceDue = balanceDue;
            request_x.customerBoothID = customerBoothID;
            request_x.customerID = customerID;
            request_x.referenceShowName = referenceShowName;
            request_x.requestingPartyNameOverride = requestingPartyNameOverride;
            request_x.emailHtmlFormat = emailHtmlFormat;
            request_x.notes = notes;
            request_x.resendEmail = resendEmail;
            request_x.refreshExpirationDate = refreshExpirationDate;
            ACCC1_wwwViadComV1.UpdatePaymentCollectionResponse_element response_x;
            Map<String, ACCC1_wwwViadComV1.UpdatePaymentCollectionResponse_element> response_map_x = new Map<String, ACCC1_wwwViadComV1.UpdatePaymentCollectionResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'www.viad.com/v1/IPaymentCollectionService/UpdatePaymentCollection',
              'www.viad.com/v1',
              'UpdatePaymentCollection',
              'www.viad.com/v1',
              'UpdatePaymentCollectionResponse',
              'ACCC1_wwwViadComV1.UpdatePaymentCollectionResponse_element'}
            );
            response_x = response_map_x.get('response_x');
        }
    }
}