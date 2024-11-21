public class SOP_VIAD_V2 {
    // MW 24th November 2015
     public class SalesforceUpsertContactRequest {
        public String AssociationType;
        public DateTime Created;
        public String CustomerSalesforceID;
        public DateTime DOB;
        public Boolean DP3rdParty;
        public Boolean DPEmail;
        public Boolean DPFax;
        public Boolean DPGeneral;
        public Boolean DPMail;
        public Boolean DPOther1;
        public Boolean DPOther2;
        public Boolean DPTelephone;
        public String DaytimeTel;
        public String Email;
        public String EveningTel;
        public DateTime ExpiredDate;
        public String Fax;
        public String Forename;
        public Boolean Gender;
        public String IndNotes;
        public String IndXmlData;
        public String Initials;
        public Boolean IsDeleted;
        public Boolean IsDuplicate;
        public String MiddleNames;
        public String Mobile;
        public String OtherComm;
        public Integer OwnerID;
        public String Pager;
        public String Password;
        public String PreviousName;
        public String Qualifications;
        public String RoleDescription;
        public String RoleNotes;
        public Integer RolePriority;
        public Integer RoleType;
        public String RoleXmlData;
        public String SalesforceID;
        public String Surname;
        public String Title;
        public DateTime Updated;
        public String UsedName;
        public String UserName;
        private String[] AssociationType_type_info = new String[]{'AssociationType','www.viad.com/v2',null,'1','1','true'};
        private String[] Created_type_info = new String[]{'Created','www.viad.com/v2',null,'0','1','true'};
        private String[] CustomerSalesforceID_type_info = new String[]{'CustomerSalesforceID','www.viad.com/v2',null,'1','1','true'};
        private String[] DOB_type_info = new String[]{'DOB','www.viad.com/v2',null,'0','1','true'};
        private String[] DP3rdParty_type_info = new String[]{'DP3rdParty','www.viad.com/v2',null,'0','1','true'};
        private String[] DPEmail_type_info = new String[]{'DPEmail','www.viad.com/v2',null,'0','1','true'};
        private String[] DPFax_type_info = new String[]{'DPFax','www.viad.com/v2',null,'0','1','true'};
        private String[] DPGeneral_type_info = new String[]{'DPGeneral','www.viad.com/v2',null,'0','1','true'};
        private String[] DPMail_type_info = new String[]{'DPMail','www.viad.com/v2',null,'0','1','true'};
        private String[] DPOther1_type_info = new String[]{'DPOther1','www.viad.com/v2',null,'0','1','true'};
        private String[] DPOther2_type_info = new String[]{'DPOther2','www.viad.com/v2',null,'0','1','true'};
        private String[] DPTelephone_type_info = new String[]{'DPTelephone','www.viad.com/v2',null,'0','1','true'};
        private String[] DaytimeTel_type_info = new String[]{'DaytimeTel','www.viad.com/v2',null,'0','1','true'};
        private String[] Email_type_info = new String[]{'Email','www.viad.com/v2',null,'0','1','true'};
        private String[] EveningTel_type_info = new String[]{'EveningTel','www.viad.com/v2',null,'0','1','true'};
        private String[] ExpiredDate_type_info = new String[]{'ExpiredDate','www.viad.com/v2',null,'1','1','true'};
        private String[] Fax_type_info = new String[]{'Fax','www.viad.com/v2',null,'0','1','true'};
        private String[] Forename_type_info = new String[]{'Forename','www.viad.com/v2',null,'1','1','true'};
        private String[] Gender_type_info = new String[]{'Gender','www.viad.com/v2',null,'0','1','true'};
        private String[] IndNotes_type_info = new String[]{'IndNotes','www.viad.com/v2',null,'0','1','true'};
        private String[] IndXmlData_type_info = new String[]{'IndXmlData','www.viad.com/v2',null,'0','1','true'};
        private String[] Initials_type_info = new String[]{'Initials','www.viad.com/v2',null,'0','1','true'};
        private String[] IsDeleted_type_info = new String[]{'IsDeleted','www.viad.com/v2',null,'1','1','true'};
        private String[] IsDuplicate_type_info = new String[]{'IsDuplicate','www.viad.com/v2',null,'1','1','true'};
        private String[] MiddleNames_type_info = new String[]{'MiddleNames','www.viad.com/v2',null,'0','1','true'};
        private String[] Mobile_type_info = new String[]{'Mobile','www.viad.com/v2',null,'0','1','true'};
        private String[] OtherComm_type_info = new String[]{'OtherComm','www.viad.com/v2',null,'0','1','true'};
        private String[] OwnerID_type_info = new String[]{'OwnerID','www.viad.com/v2',null,'1','1','true'};
        private String[] Pager_type_info = new String[]{'Pager','www.viad.com/v2',null,'0','1','true'};
        private String[] Password_type_info = new String[]{'Password','www.viad.com/v2',null,'0','1','true'};
        private String[] PreviousName_type_info = new String[]{'PreviousName','www.viad.com/v2',null,'0','1','true'};
        private String[] Qualifications_type_info = new String[]{'Qualifications','www.viad.com/v2',null,'0','1','true'};
        private String[] RoleDescription_type_info = new String[]{'RoleDescription','www.viad.com/v2',null,'0','1','true'};
        private String[] RoleNotes_type_info = new String[]{'RoleNotes','www.viad.com/v2',null,'0','1','true'};
        private String[] RolePriority_type_info = new String[]{'RolePriority','www.viad.com/v2',null,'1','1','true'};
        private String[] RoleType_type_info = new String[]{'RoleType','www.viad.com/v2',null,'1','1','true'};
        private String[] RoleXmlData_type_info = new String[]{'RoleXmlData','www.viad.com/v2',null,'0','1','true'};
        private String[] SalesforceID_type_info = new String[]{'SalesforceID','www.viad.com/v2',null,'1','1','true'};
        private String[] Surname_type_info = new String[]{'Surname','www.viad.com/v2',null,'1','1','true'};
        private String[] Title_type_info = new String[]{'Title','www.viad.com/v2',null,'0','1','true'};
        private String[] Updated_type_info = new String[]{'Updated','www.viad.com/v2',null,'0','1','true'};
        private String[] UsedName_type_info = new String[]{'UsedName','www.viad.com/v2',null,'0','1','true'};
        private String[] UserName_type_info = new String[]{'UserName','www.viad.com/v2',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'www.viad.com/v2','true','false'};
        private String[] field_order_type_info = new String[]{'AssociationType','Created','CustomerSalesforceID','DOB','DP3rdParty','DPEmail','DPFax','DPGeneral','DPMail','DPOther1','DPOther2','DPTelephone','DaytimeTel','Email','EveningTel','ExpiredDate','Fax','Forename','Gender','IndNotes','IndXmlData','Initials','IsDeleted','IsDuplicate','MiddleNames','Mobile','OtherComm','OwnerID','Pager','Password','PreviousName','Qualifications','RoleDescription','RoleNotes','RolePriority','RoleType','RoleXmlData','SalesforceID','Surname','Title','Updated','UsedName','UserName'};
    }
    // MW 24th November 2015
    public class SalesforceUpsertContactResponse_element {
        public String SalesforceUpsertContactResult;
        private String[] SalesforceUpsertContactResult_type_info = new String[]{'SalesforceUpsertContactResult','www.viad.com/v2',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'www.viad.com/v2','true','false'};
        private String[] field_order_type_info = new String[]{'SalesforceUpsertContactResult'};
    }
    // MW 24th November 2015
     public class SalesforceUpsertContact_element {
        public String applicationSessionId;
        public SOP_VIAD_V2.SalesforceUpsertContactRequest salesforceUpsertContactRequest;
        private String[] applicationSessionId_type_info = new String[]{'applicationSessionId','www.viad.com/v2',null,'0','1','true'};
        private String[] salesforceUpsertContactRequest_type_info = new String[]{'salesforceUpsertContactRequest','www.viad.com/v2',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'www.viad.com/v2','true','false'};
        private String[] field_order_type_info = new String[]{'applicationSessionId','salesforceUpsertContactRequest'};
    }
    // MW 24th November 2015
    public class SalesforceUpsertOrganisation_element {
        public String applicationSessionId;
        public SOP_VIAD_V2.SalesforceUpsertOrganisationRequest salesforceUpsertOrganisationRequest;
        private String[] applicationSessionId_type_info = new String[]{'applicationSessionId','www.viad.com/v2',null,'0','1','true'};
        private String[] salesforceUpsertOrganisationRequest_type_info = new String[]{'salesforceUpsertOrganisationRequest','www.viad.com/v2',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'www.viad.com/v2','true','false'};
        private String[] field_order_type_info = new String[]{'applicationSessionId','salesforceUpsertOrganisationRequest'};
    }
    // MW 24th November 2015
    public class SalesforceUpsertOrganisationResponse_element {
        public SOP_VIAD_V2.SalesforceUpsertOrganisationResult SalesforceUpsertOrganisationResult;
        private String[] SalesforceUpsertOrganisationResult_type_info = new String[]{'SalesforceUpsertOrganisationResult','www.viad.com/v2',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'www.viad.com/v2','true','false'};
        private String[] field_order_type_info = new String[]{'SalesforceUpsertOrganisationResult'};
    }
    // MW 24th November 2015
    public class SalesforceUpsertOrganisationRequest {
        public String AddressLine1;
        public String AddressLine2;
        public String AddressLine3;
        public String AddressLine4;
        public String AltOrgName1;
        public String AltOrgName2;
        public String AltOrgName3;
        public String Country;
        public String County;
        public DateTime Created;
        public String CustCategory;
        public String Department;
        public String HouseNumber;
        public Boolean IsDeleted;
        public Boolean IsDuplicate;
        public Boolean NonVatable;
        public String OrgDaytimeTel;
        public String OrgEmail;
        public String OrgEveningTel;
        public String OrgFax;
        public String OrgMobile;
        public String OrgName;
        public String OrgNotes;
        public Integer OrgType;
        public Integer OwnerID;
        public String Postcode;
        public String SalesforceID;
        public String Town;
        public DateTime Updated;
        public String VatNumber;
        private String[] AddressLine1_type_info = new String[]{'AddressLine1','www.viad.com/v2',null,'1','1','true'};
        private String[] AddressLine2_type_info = new String[]{'AddressLine2','www.viad.com/v2',null,'1','1','true'};
        private String[] AddressLine3_type_info = new String[]{'AddressLine3','www.viad.com/v2',null,'1','1','true'};
        private String[] AddressLine4_type_info = new String[]{'AddressLine4','www.viad.com/v2',null,'1','1','true'};
        private String[] AltOrgName1_type_info = new String[]{'AltOrgName1','www.viad.com/v2',null,'0','1','true'};
        private String[] AltOrgName2_type_info = new String[]{'AltOrgName2','www.viad.com/v2',null,'0','1','true'};
        private String[] AltOrgName3_type_info = new String[]{'AltOrgName3','www.viad.com/v2',null,'0','1','true'};
        private String[] Country_type_info = new String[]{'Country','www.viad.com/v2',null,'1','1','true'};
        private String[] County_type_info = new String[]{'County','www.viad.com/v2',null,'1','1','true'};
        private String[] Created_type_info = new String[]{'Created','www.viad.com/v2',null,'0','1','true'};
        private String[] CustCategory_type_info = new String[]{'CustCategory','www.viad.com/v2',null,'1','1','true'};
        private String[] Department_type_info = new String[]{'Department','www.viad.com/v2',null,'0','1','true'};
        private String[] HouseNumber_type_info = new String[]{'HouseNumber','www.viad.com/v2',null,'1','1','true'};
        private String[] IsDeleted_type_info = new String[]{'IsDeleted','www.viad.com/v2',null,'1','1','true'};
        private String[] IsDuplicate_type_info = new String[]{'IsDuplicate','www.viad.com/v2',null,'1','1','true'};
        private String[] NonVatable_type_info = new String[]{'NonVatable','www.viad.com/v2',null,'1','1','true'};
        private String[] OrgDaytimeTel_type_info = new String[]{'OrgDaytimeTel','www.viad.com/v2',null,'0','1','true'};
        private String[] OrgEmail_type_info = new String[]{'OrgEmail','www.viad.com/v2',null,'0','1','true'};
        private String[] OrgEveningTel_type_info = new String[]{'OrgEveningTel','www.viad.com/v2',null,'0','1','true'};
        private String[] OrgFax_type_info = new String[]{'OrgFax','www.viad.com/v2',null,'0','1','true'};
        private String[] OrgMobile_type_info = new String[]{'OrgMobile','www.viad.com/v2',null,'0','1','true'};
        private String[] OrgName_type_info = new String[]{'OrgName','www.viad.com/v2',null,'1','1','true'};
        private String[] OrgNotes_type_info = new String[]{'OrgNotes','www.viad.com/v2',null,'0','1','true'};
        private String[] OrgType_type_info = new String[]{'OrgType','www.viad.com/v2',null,'1','1','true'};
        private String[] OwnerID_type_info = new String[]{'OwnerID','www.viad.com/v2',null,'1','1','true'};
        private String[] Postcode_type_info = new String[]{'Postcode','www.viad.com/v2',null,'1','1','true'};
        private String[] SalesforceID_type_info = new String[]{'SalesforceID','www.viad.com/v2',null,'1','1','true'};
        private String[] Town_type_info = new String[]{'Town','www.viad.com/v2',null,'1','1','true'};
        private String[] Updated_type_info = new String[]{'Updated','www.viad.com/v2',null,'0','1','true'};
        private String[] VatNumber_type_info = new String[]{'VatNumber','www.viad.com/v2',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'www.viad.com/v2','true','false'};
        private String[] field_order_type_info = new String[]{'AddressLine1','AddressLine2','AddressLine3','AddressLine4','AltOrgName1','AltOrgName2','AltOrgName3','Country','County','Created','CustCategory','Department','HouseNumber','IsDeleted','IsDuplicate','NonVatable','OrgDaytimeTel','OrgEmail','OrgEveningTel','OrgFax','OrgMobile','OrgName','OrgNotes','OrgType','OwnerID','Postcode','SalesforceID','Town','Updated','VatNumber'};
    }
    // MW 24th November 2015
     public class SalesforceUpsertOrganisationResult {
        public Integer EUSopID;
        public Integer MESopID;
        public String SalesforceID;
        public Integer UKSopID;
        private String[] EUSopID_type_info = new String[]{'EUSopID','www.viad.com/v2',null,'0','1','true'};
        private String[] MESopID_type_info = new String[]{'MESopID','www.viad.com/v2',null,'0','1','true'};
        private String[] SalesforceID_type_info = new String[]{'SalesforceID','www.viad.com/v2',null,'0','1','true'};
        private String[] UKSopID_type_info = new String[]{'UKSopID','www.viad.com/v2',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'www.viad.com/v2','true','false'};
        private String[] field_order_type_info = new String[]{'EUSopID','MESopID','SalesforceID','UKSopID'};
    }
    /*
    public class OrderLine {
        private String[] apex_schema_type_info = new String[]{'www.viad.com/v2','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class ExternalOrder {
        public String CompanyId;
        public Integer EventID;
        public Integer ExternalOrderID;
        public Integer ExternalSystemID;
        public SOP_VIAD_V2.OrderHeader OrderHeader;
        public SOP_VIAD_V2.ArrayOfOrderLine OrderLines;
        private String[] CompanyId_type_info = new String[]{'CompanyId','www.viad.com/v2',null,'0','1','false'};
        private String[] EventID_type_info = new String[]{'EventID','www.viad.com/v2',null,'0','1','false'};
        private String[] ExternalOrderID_type_info = new String[]{'ExternalOrderID','www.viad.com/v2',null,'0','1','false'};
        private String[] ExternalSystemID_type_info = new String[]{'ExternalSystemID','www.viad.com/v2',null,'0','1','false'};
        private String[] OrderHeader_type_info = new String[]{'OrderHeader','www.viad.com/v2',null,'0','1','true'};
        private String[] OrderLines_type_info = new String[]{'OrderLines','www.viad.com/v2',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'www.viad.com/v2','true','false'};
        private String[] field_order_type_info = new String[]{'CompanyId','EventID','ExternalOrderID','ExternalSystemID','OrderHeader','OrderLines'};
    }
    */
    public class GetCustomerOrders_element {
        public String applicationSessionId;
        public SOP_VIAD_V2.CustomerOrdersRequest customerOrdersRequest;
        private String[] applicationSessionId_type_info = new String[]{'applicationSessionId','www.viad.com/v2',null,'0','1','true'};
        private String[] customerOrdersRequest_type_info = new String[]{'customerOrdersRequest','www.viad.com/v2',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'www.viad.com/v2','true','false'};
        private String[] field_order_type_info = new String[]{'applicationSessionId','customerOrdersRequest'};
    }
    
    public class ArrayOfCustomerOrder {
        public SOP_VIAD_V2.CustomerOrder[] CustomerOrder;
        private String[] CustomerOrder_type_info = new String[]{'CustomerOrder','www.viad.com/v2',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'www.viad.com/v2','true','false'};
        private String[] field_order_type_info = new String[]{'CustomerOrder'};
    }
    /*
    public class ItemsRequest {
        public Integer CatalogueID;
        public String SopInstance;
    }
    public class ArrayOfCatalogue {
        public SOP_VIAD_V2.Catalogue[] Catalogue;

    }
    */
    public class GetOrderSummaryResponse_element {
        public SOP_VIAD_V2.OrderSummary GetOrderSummaryResult;
        private String[] GetOrderSummaryResult_type_info = new String[]{'GetOrderSummaryResult','www.viad.com/v2',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'www.viad.com/v2','true','false'};
        private String[] field_order_type_info = new String[]{'GetOrderSummaryResult'};
    }
    
    public class Catalogue {
        public String CatalogueName;
        public double CurrentPriveVATRate;
        public boolean DisplayEuroLines;
        public boolean DisplayEuroOnly;
        public boolean DisplayEuroTotals;
        public Integer EventID;
        public double ExchangeRate;
        public double HirePriceVATRate;
        public Integer ID;
        public boolean IsDeleted;
        public boolean IsMaster;
        public dateTime StartDate;
        public String XmlData;
    }
    
    public class CustomerOrder {
        public String BasketType;
        public DateTime BasketUpdateDate;
        public Integer BasketVersionNo;
        public Integer ID;
        public String Instance;
        public DateTime InvoiceDate;
        public Integer InvoiceNo;
        public Integer ProjectID;
        public String ProjectName;
        public Double Total;
        private String[] BasketType_type_info = new String[]{'BasketType','www.viad.com/v2',null,'0','1','true'};
        private String[] BasketUpdateDate_type_info = new String[]{'BasketUpdateDate','www.viad.com/v2',null,'0','1','false'};
        private String[] BasketVersionNo_type_info = new String[]{'BasketVersionNo','www.viad.com/v2',null,'0','1','false'};
        private String[] ID_type_info = new String[]{'ID','www.viad.com/v2',null,'0','1','false'};
        private String[] Instance_type_info = new String[]{'Instance','www.viad.com/v2',null,'0','1','true'};
        private String[] InvoiceDate_type_info = new String[]{'InvoiceDate','www.viad.com/v2',null,'0','1','true'};
        private String[] InvoiceNo_type_info = new String[]{'InvoiceNo','www.viad.com/v2',null,'0','1','true'};
        private String[] ProjectID_type_info = new String[]{'ProjectID','www.viad.com/v2',null,'0','1','false'};
        private String[] ProjectName_type_info = new String[]{'ProjectName','www.viad.com/v2',null,'0','1','true'};
        private String[] Total_type_info = new String[]{'Total','www.viad.com/v2',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'www.viad.com/v2','true','false'};
        private String[] field_order_type_info = new String[]{'BasketType','BasketUpdateDate','BasketVersionNo','ID','Instance','InvoiceDate','InvoiceNo','ProjectID','ProjectName','Total'};
    }
    /*
    public class GetStockLevel_element {
        public String applicationSessionId;
        public SOP_VIAD_V2.stockRequest stockRequest;
        private String[] applicationSessionId_type_info = new String[]{'applicationSessionId','www.viad.com/v2',null,'0','1','true'};
        private String[] stockRequest_type_info = new String[]{'stockRequest','www.viad.com/v2',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'www.viad.com/v2','true','false'};
        private String[] field_order_type_info = new String[]{'applicationSessionId','stockRequest'};
    }
    public class OrderHeader {
        private String[] apex_schema_type_info = new String[]{'www.viad.com/v2','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class GetStockLevelResponse_element {
        public Integer GetStockLevelResult;
        private String[] GetStockLevelResult_type_info = new String[]{'GetStockLevelResult','www.viad.com/v2',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'www.viad.com/v2','true','false'};
        private String[] field_order_type_info = new String[]{'GetStockLevelResult'};
    }
    public class BookOrder_element {
        public String applicationSessionId;
        public SOP_VIAD_V2.ExternalOrder externalOrder;
        private String[] applicationSessionId_type_info = new String[]{'applicationSessionId','www.viad.com/v2',null,'0','1','true'};
        private String[] externalOrder_type_info = new String[]{'externalOrder','www.viad.com/v2',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'www.viad.com/v2','true','false'};
        private String[] field_order_type_info = new String[]{'applicationSessionId','externalOrder'};
    }
    */
    public class OrderSummaryRequest {
        public Integer OrderNo;
        public String SopInstance;
        private String[] OrderNo_type_info = new String[]{'OrderNo','www.viad.com/v2',null,'0','1','false'};
        private String[] SopInstance_type_info = new String[]{'SopInstance','www.viad.com/v2',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'www.viad.com/v2','true','false'};
        private String[] field_order_type_info = new String[]{'OrderNo','SopInstance'};
    }
    /*
    public class stockRequest {
        public String CompanyId;
        public DateTime FromDate;
        public String ItemCode;
        public String ServiceCode;
        public DateTime ToDate;
        private String[] CompanyId_type_info = new String[]{'CompanyId','www.viad.com/v2',null,'0','1','false'};
        private String[] FromDate_type_info = new String[]{'FromDate','www.viad.com/v2',null,'0','1','false'};
        private String[] ItemCode_type_info = new String[]{'ItemCode','www.viad.com/v2',null,'0','1','true'};
        private String[] ServiceCode_type_info = new String[]{'ServiceCode','www.viad.com/v2',null,'0','1','true'};
        private String[] ToDate_type_info = new String[]{'ToDate','www.viad.com/v2',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'www.viad.com/v2','true','false'};
        private String[] field_order_type_info = new String[]{'CompanyId','FromDate','ItemCode','ServiceCode','ToDate'};
    }
    public class GetStockLevelFromQueryResponse_element {
        public Integer GetStockLevelFromQueryResult;
        private String[] GetStockLevelFromQueryResult_type_info = new String[]{'GetStockLevelFromQueryResult','www.viad.com/v2',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'www.viad.com/v2','true','false'};
        private String[] field_order_type_info = new String[]{'GetStockLevelFromQueryResult'};
    }
    public class BookOrderResponse_element {
        public Integer BookOrderResult;
        private String[] BookOrderResult_type_info = new String[]{'BookOrderResult','www.viad.com/v2',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'www.viad.com/v2','true','false'};
        private String[] field_order_type_info = new String[]{'BookOrderResult'};
    }
    */
    public class CustomerOrdersRequest {
        public Integer EventID;
        public String SalesforceID;
        public String SopInstance;
        public String Status;
        private String[] EventID_type_info = new String[]{'EventID','www.viad.com/v2',null,'0','1','true'};
        private String[] SalesforceID_type_info = new String[]{'SalesforceID','www.viad.com/v2',null,'0','1','true'};
        private String[] SopInstance_type_info = new String[]{'SopInstance','www.viad.com/v2',null,'0','1','true'};
        private String[] Status_type_info = new String[]{'Status','www.viad.com/v2',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'www.viad.com/v2','true','false'};
        private String[] field_order_type_info = new String[]{'EventID','SalesforceID','SopInstance','Status'};
    }
    public class OrderSummary {
        public String AddressLine1;
        public String AddressLine2;
        public String AddressLine3;
        public String AddressLine4;
        public Integer BasketVersionNo;
        public String CatalogueName;
        public String Contact;
        public String Country;
        public String County;
        public String Customer;
        public DateTime DatePlaced;
        public String Department;
        public Integer EventID;
        public String EventName;
        public Integer InvoiceNo;
        public SOP_Data_Contract.ArrayOfOrderSummaryItem Items;
        public Double NettTotal;
        public Integer OrderNo;
        public String Postcode;
        public String StandNo;
        public String State;
        public Double SurchargesAndDiscounts;
        public Double TotalExcludingtVAT;
        public Double TotalLineItems;
        public String Town;
        public Double VAT;
        private String[] AddressLine1_type_info = new String[]{'AddressLine1','www.viad.com/v2',null,'0','1','true'};
        private String[] AddressLine2_type_info = new String[]{'AddressLine2','www.viad.com/v2',null,'0','1','true'};
        private String[] AddressLine3_type_info = new String[]{'AddressLine3','www.viad.com/v2',null,'0','1','true'};
        private String[] AddressLine4_type_info = new String[]{'AddressLine4','www.viad.com/v2',null,'0','1','true'};
        private String[] BasketVersionNo_type_info = new String[]{'BasketVersionNo','www.viad.com/v2',null,'0','1','false'};
        private String[] CatalogueName_type_info = new String[]{'CatalogueName','www.viad.com/v2',null,'0','1','true'};
        private String[] Contact_type_info = new String[]{'Contact','www.viad.com/v2',null,'0','1','true'};
        private String[] Country_type_info = new String[]{'Country','www.viad.com/v2',null,'0','1','true'};
        private String[] County_type_info = new String[]{'County','www.viad.com/v2',null,'0','1','true'};
        private String[] Customer_type_info = new String[]{'Customer','www.viad.com/v2',null,'0','1','true'};
        private String[] DatePlaced_type_info = new String[]{'DatePlaced','www.viad.com/v2',null,'0','1','false'};
        private String[] Department_type_info = new String[]{'Department','www.viad.com/v2',null,'0','1','true'};
        private String[] EventID_type_info = new String[]{'EventID','www.viad.com/v2',null,'0','1','false'};
        private String[] EventName_type_info = new String[]{'EventName','www.viad.com/v2',null,'0','1','true'};
        private String[] InvoiceNo_type_info = new String[]{'InvoiceNo','www.viad.com/v2',null,'0','1','true'};
        private String[] Items_type_info = new String[]{'Items','www.viad.com/v2',null,'0','1','true'};
        private String[] NettTotal_type_info = new String[]{'NettTotal','www.viad.com/v2',null,'0','1','false'};
        private String[] OrderNo_type_info = new String[]{'OrderNo','www.viad.com/v2',null,'0','1','false'};
        private String[] Postcode_type_info = new String[]{'Postcode','www.viad.com/v2',null,'0','1','true'};
        private String[] StandNo_type_info = new String[]{'StandNo','www.viad.com/v2',null,'0','1','true'};
        private String[] State_type_info = new String[]{'State','www.viad.com/v2',null,'0','1','true'};
        private String[] SurchargesAndDiscounts_type_info = new String[]{'SurchargesAndDiscounts','www.viad.com/v2',null,'0','1','false'};
        private String[] TotalExcludingtVAT_type_info = new String[]{'TotalExcludingtVAT','www.viad.com/v2',null,'0','1','false'};
        private String[] TotalLineItems_type_info = new String[]{'TotalLineItems','www.viad.com/v2',null,'0','1','false'};
        private String[] Town_type_info = new String[]{'Town','www.viad.com/v2',null,'0','1','true'};
        private String[] VAT_type_info = new String[]{'VAT','www.viad.com/v2',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'www.viad.com/v2','true','false'};
        private String[] field_order_type_info = new String[]{'AddressLine1','AddressLine2','AddressLine3','AddressLine4','BasketVersionNo','CatalogueName','Contact','Country','County','Customer','DatePlaced','Department','EventID','EventName','InvoiceNo','Items','NettTotal','OrderNo','Postcode','StandNo','State','SurchargesAndDiscounts','TotalExcludingtVAT','TotalLineItems','Town','VAT'};
    }
    
    public class GetCustomerOrdersResponse_element {
        public SOP_VIAD_V2.ArrayOfCustomerOrder GetCustomerOrdersResult;
        private String[] GetCustomerOrdersResult_type_info = new String[]{'GetCustomerOrdersResult','www.viad.com/v2',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'www.viad.com/v2','true','false'};
        private String[] field_order_type_info = new String[]{'GetCustomerOrdersResult'};
    }
    /*
    public class GetStockLevelFromQuery_element {
        public String applicationSessionId;
        public SOP_VIAD_V2.stockRequest stockRequest;
        private String[] applicationSessionId_type_info = new String[]{'applicationSessionId','www.viad.com/v2',null,'0','1','true'};
        private String[] stockRequest_type_info = new String[]{'stockRequest','www.viad.com/v2',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'www.viad.com/v2','true','false'};
        private String[] field_order_type_info = new String[]{'applicationSessionId','stockRequest'};
    }
    public class ArrayOfOrderLine {
        public SOP_VIAD_V2.OrderLine[] OrderLine;
        private String[] OrderLine_type_info = new String[]{'OrderLine','www.viad.com/v2',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'www.viad.com/v2','true','false'};
        private String[] field_order_type_info = new String[]{'OrderLine'};
    }
    */
    public class GetOrderSummary_element {
        public String applicationSessionId;
        public SOP_VIAD_V2.OrderSummaryRequest orderSummaryRequest;
        private String[] applicationSessionId_type_info = new String[]{'applicationSessionId','www.viad.com/v2',null,'0','1','true'};
        private String[] orderSummaryRequest_type_info = new String[]{'orderSummaryRequest','www.viad.com/v2',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'www.viad.com/v2','true','false'};
        private String[] field_order_type_info = new String[]{'applicationSessionId','orderSummaryRequest'};
    }
    // MW 24th November 2015
    public class SalesforceUpsertOrganisationResponse_elementFuture extends System.WebServiceCalloutFuture {
        public SOP_VIAD_V2.SalesforceUpsertOrganisationResult getValue() {
            SOP_VIAD_V2.SalesforceUpsertOrganisationResponse_element response = (SOP_VIAD_V2.SalesforceUpsertOrganisationResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.SalesforceUpsertOrganisationResult;
        }
    }
    // MW 24th November 2015
    public class SalesforceUpsertContactResponse_elementFuture extends System.WebServiceCalloutFuture {
        public String getValue() {
            SOP_VIAD_V2.SalesforceUpsertContactResponse_element response = (SOP_VIAD_V2.SalesforceUpsertContactResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.SalesforceUpsertContactResult;
        }
    }
    
    public class BasicHttpBinding_ISOPService {
        public String endpoint_x = SOPService__c.getInstance('Default').URL__c;
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://schemas.microsoft.com/2003/10/Serialization/', 'SOP_MS_Serial', 'www.viad.com/v2', 'SOP_VIAD_V2', 'http://schemas.datacontract.org/2004/07/Viad.Services.Public.GES.v2.DataContracts.SOP', 'SOP_Data_Contract', 'www.viad.com', 'SOP_VIAD'};
     
    // MW 24th November 2015
     public SOP_VIAD_V2.SalesforceUpsertOrganisationResponse_elementFuture beginSalesforceUpsertOrganisation(System.Continuation continuation,String applicationSessionId,SOP_VIAD_V2.SalesforceUpsertOrganisationRequest salesforceUpsertOrganisationRequest) {
            SOP_VIAD_V2.SalesforceUpsertOrganisation_element request_x = new SOP_VIAD_V2.SalesforceUpsertOrganisation_element();
            request_x.applicationSessionId = applicationSessionId;
            request_x.salesforceUpsertOrganisationRequest = salesforceUpsertOrganisationRequest;
            if (test.isRunningTest()) return null;

            return (SalesforceUpsertOrganisationResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              SOP_APIIntegration.SalesforceUpsertOrganisationResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'www.viad.com/v2/ISOPService/SalesforceUpsertOrganisation',
              'www.viad.com/v2',
              'SalesforceUpsertOrganisation',
              'www.viad.com/v2',
              'SalesforceUpsertOrganisationResponse',
              'SOP_VIAD_V2.SalesforceUpsertOrganisationResponse_element'}
            );
        }
    // MW 24th November 2015
    public SOP_VIAD_V2.SalesforceUpsertContactResponse_elementFuture beginSalesforceUpsertContact(System.Continuation continuation,String applicationSessionId,SOP_VIAD_V2.SalesforceUpsertContactRequest salesforceUpsertContactRequest) {
            SOP_VIAD_V2.SalesforceUpsertContact_element request_x = new SOP_VIAD_V2.SalesforceUpsertContact_element();
            request_x.applicationSessionId = applicationSessionId;
            request_x.salesforceUpsertContactRequest = salesforceUpsertContactRequest;
            if (test.isRunningTest()) return null;
            
            return (SOP_VIAD_V2.SalesforceUpsertContactResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              SOP_APIIntegration.SalesforceUpsertContactResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'www.viad.com/v2/ISOPService/SalesforceUpsertContact',
              'www.viad.com/v2',
              'SalesforceUpsertContact',
              'www.viad.com/v2',
              'SalesforceUpsertContactResponse',
              'SOP_VIAD_V2.SalesforceUpsertContactResponse_element'}
            );
    }
            
            /*
        public Integer GetStockLevel(String applicationSessionId,SOP_VIAD_V2.stockRequest stockRequest) {
            SOP_VIAD_V2.GetStockLevel_element request_x = new SOP_VIAD_V2.GetStockLevel_element();
            request_x.applicationSessionId = applicationSessionId;
            request_x.stockRequest = stockRequest;
            SOP_VIAD_V2.GetStockLevelResponse_element response_x;
            Map<String, SOP_VIAD_V2.GetStockLevelResponse_element> response_map_x = new Map<String, SOP_VIAD_V2.GetStockLevelResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'www.viad.com/v2/ISOPService/GetStockLevel',
              'www.viad.com/v2',
              'GetStockLevel',
              'www.viad.com/v2',
              'GetStockLevelResponse',
              'SOP_VIAD_V2.GetStockLevelResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.GetStockLevelResult;
        }
        public Integer BookOrder(String applicationSessionId,SOP_VIAD_V2.ExternalOrder externalOrder) {
            SOP_VIAD_V2.BookOrder_element request_x = new SOP_VIAD_V2.BookOrder_element();
            request_x.applicationSessionId = applicationSessionId;
            request_x.externalOrder = externalOrder;
            SOP_VIAD_V2.BookOrderResponse_element response_x;
            Map<String, SOP_VIAD_V2.BookOrderResponse_element> response_map_x = new Map<String, SOP_VIAD_V2.BookOrderResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'www.viad.com/v2/ISOPService/BookOrder',
              'www.viad.com/v2',
              'BookOrder',
              'www.viad.com/v2',
              'BookOrderResponse',
              'SOP_VIAD_V2.BookOrderResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.BookOrderResult;
        }
        public Integer GetStockLevelFromQuery(String applicationSessionId,SOP_VIAD_V2.stockRequest stockRequest) {
            SOP_VIAD_V2.GetStockLevelFromQuery_element request_x = new SOP_VIAD_V2.GetStockLevelFromQuery_element();
            request_x.applicationSessionId = applicationSessionId;
            request_x.stockRequest = stockRequest;
            SOP_VIAD_V2.GetStockLevelFromQueryResponse_element response_x;
            Map<String, SOP_VIAD_V2.GetStockLevelFromQueryResponse_element> response_map_x = new Map<String, SOP_VIAD_V2.GetStockLevelFromQueryResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'www.viad.com/v2/ISOPService/GetStockLevelFromQuery',
              'www.viad.com/v2',
              'GetStockLevelFromQuery',
              'www.viad.com/v2',
              'GetStockLevelFromQueryResponse',
              'SOP_VIAD_V2.GetStockLevelFromQueryResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.GetStockLevelFromQueryResult;
        }
        */
        public SOP_VIAD_V2.SalesforceUpsertOrganisationResult SalesforceUpsertOrganisation(String applicationSessionId,SOP_VIAD_V2.SalesforceUpsertOrganisationRequest salesforceUpsertOrganisationRequest) {
            SOP_VIAD_V2.SalesforceUpsertOrganisation_element request_x = new SOP_VIAD_V2.SalesforceUpsertOrganisation_element();
            request_x.applicationSessionId = applicationSessionId;
            request_x.salesforceUpsertOrganisationRequest = salesforceUpsertOrganisationRequest;
            SOP_VIAD_V2.SalesforceUpsertOrganisationResponse_element response_x;
            Map<String, SOP_VIAD_V2.SalesforceUpsertOrganisationResponse_element> response_map_x = new Map<String, SOP_VIAD_V2.SalesforceUpsertOrganisationResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'www.viad.com/v2/ISOPService/SalesforceUpsertOrganisation',
              'www.viad.com/v2',
              'SalesforceUpsertOrganisation',
              'www.viad.com/v2',
              'SalesforceUpsertOrganisationResponse',
              'SOP_VIAD_V2.SalesforceUpsertOrganisationResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.SalesforceUpsertOrganisationResult;
        }    
        
        // MW 24th November2015
        public String SalesforceUpsertContact(String applicationSessionId,SOP_VIAD_V2.SalesforceUpsertContactRequest salesforceUpsertContactRequest) {
            SOP_VIAD_V2.SalesforceUpsertContact_element request_x = new SOP_VIAD_V2.SalesforceUpsertContact_element();
            request_x.applicationSessionId = applicationSessionId;
            request_x.salesforceUpsertContactRequest = salesforceUpsertContactRequest;
            SOP_VIAD_V2.SalesforceUpsertContactResponse_element response_x;
            Map<String, SOP_VIAD_V2.SalesforceUpsertContactResponse_element> response_map_x = new Map<String, SOP_VIAD_V2.SalesforceUpsertContactResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'www.viad.com/v2/ISOPService/SalesforceUpsertContact',
              'www.viad.com/v2',
              'SalesforceUpsertContact',
              'www.viad.com/v2',
              'SalesforceUpsertContactResponse',
              'SOP_VIAD_V2.SalesforceUpsertContactResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.SalesforceUpsertContactResult;
        }
            
        public SOP_VIAD_V2.ArrayOfCustomerOrder GetCustomerOrders(String applicationSessionId,SOP_VIAD_V2.CustomerOrdersRequest customerOrdersRequest) {
            SOP_VIAD_V2.GetCustomerOrders_element request_x = new SOP_VIAD_V2.GetCustomerOrders_element();
            request_x.applicationSessionId = applicationSessionId;
            request_x.customerOrdersRequest = customerOrdersRequest;
            SOP_VIAD_V2.GetCustomerOrdersResponse_element response_x;
            Map<String, SOP_VIAD_V2.GetCustomerOrdersResponse_element> response_map_x = new Map<String, SOP_VIAD_V2.GetCustomerOrdersResponse_element>();
            response_map_x.put('response_x', response_x);
            //if(!test.isRunningTest()){
                WebServiceCallout.invoke(
                  this,
                  request_x,
                  response_map_x,
                  new String[]{endpoint_x,
                  'www.viad.com/v2/ISOPService/GetCustomerOrders',
                  'www.viad.com/v2',
                  'GetCustomerOrders',
                  'www.viad.com/v2',
                  'GetCustomerOrdersResponse',
                  'SOP_VIAD_V2.GetCustomerOrdersResponse_element'}
                );
                response_x = response_map_x.get('response_x');
            //}
            return response_x.GetCustomerOrdersResult;
        }
        
        public SOP_VIAD_V2.OrderSummary GetOrderSummary(String applicationSessionId,SOP_VIAD_V2.OrderSummaryRequest orderSummaryRequest) {
            SOP_VIAD_V2.GetOrderSummary_element request_x = new SOP_VIAD_V2.GetOrderSummary_element();
            request_x.applicationSessionId = applicationSessionId;
            request_x.orderSummaryRequest = orderSummaryRequest;
            SOP_VIAD_V2.GetOrderSummaryResponse_element response_x;
            Map<String, SOP_VIAD_V2.GetOrderSummaryResponse_element> response_map_x = new Map<String, SOP_VIAD_V2.GetOrderSummaryResponse_element>();
            response_map_x.put('response_x', response_x);
            //if(!test.isRunningTest()){
                WebServiceCallout.invoke(
                  this,
                  request_x,
                  response_map_x,
                  new String[]{endpoint_x,
                  'www.viad.com/v2/ISOPService/GetOrderSummary',
                  'www.viad.com/v2',
                  'GetOrderSummary',
                  'www.viad.com/v2',
                  'GetOrderSummaryResponse',
                  'SOP_VIAD_V2.GetOrderSummaryResponse_element'}
                );
                response_x = response_map_x.get('response_x');
            //}
            //else{
            //    SOP_VIAD_V2.GetOrderSummaryResponse_element ele = new SOP_VIAD_V2.GetOrderSummaryResponse_element();
            //    response_map_x = new Map<String, SOP_VIAD_V2.GetOrderSummaryResponse_element>();
            //    response_map_x.put('response_x', ele);
            //    response_x = response_map_x.get('response_x');
            //}
            return response_x.GetOrderSummaryResult;
        }
    
    
    }
    
}