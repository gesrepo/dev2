@istest
public class ICS_AR_Adjustments_Approver_Update_TEST {
    static Account facility=TestDataUtil.CreateTestFacility();
    static Account firm=TestDataUtil.CreateTestFirm();
    static Show__c show=TestDataUtil.CreateTestShow(firm.id);
    static List<AR_Adjustments__c> testdata=new List<AR_Adjustments__c>();
    static AR_Adjustments__c sample=new AR_Adjustments__c();

    @istest 
    public static void test1(){
        ICS_Approver_Matrix__c cr=new ICS_Approver_Matrix__c();
        Employees__c e=new Employees__c();
        e.name='sample';
        e.Email_Address__c='sample@sample.com';
        insert e;
        Employees__c e1=new Employees__c();
        e1.name='sample1';
        e1.Email_Address__c='sample1@sample.com';
        insert e1;
        Customer_Service_Inquiries_ICS__c test1=new Customer_Service_Inquiries_ICS__c();
        test1.Sales_Channel__c ='Revenue Show Org';
        //test1.Customer_Name__c='test';
        test1.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
        insert test1;
        cr.Min_Amount__c=null;
        cr.Max_Amount__c=5000;
        cr.LOB_Approver__c=e1.id;
        cr.F_R_Approver__c=e.Id;
        cr.AR1_Approver__c=e1.id;
		cr.CSO_Approver__c=e1.id;
        cr.AR2_Approver__c=e.id;
        cr.Additional_Approver__c=e.id;
        cr.Transaction_Types__c='AR Adjustments';
        cr.Location__c='110- Las Vegas';
        cr.sales_channel__c='Revenue Show Org';
        insert cr;
        sample.AR_Adj_CSI_ID__c=test1.id;
        
        sample.Amount__c=1000;
        testdata.add(sample);
        insert testdata;
        list<AR_Adjustments__c> res_ar=[select  DAM_LOB_Approver__c,DAM_Approver_Email_ID__c, F_R_Approver__c,F_A_Approver_Email__c,
                                        AR1_Approver_Name__c, AR1_Approver_Email__c,	CSO_Approver_Name__c, cso_Approver_Email__c,     
                                        AR2_Approver_Name__c,AR2_Approver_Email__c from AR_Adjustments__c where id in:testdata];
        
    }
    @istest
    public static void test2(){
        ICS_Approver_Matrix__c cr=new ICS_Approver_Matrix__c();
        Employees__c e=new Employees__c();
        e.name='sample';
        e.Email_Address__c='sample@sample.com';
        insert e;
        Employees__c e1=new Employees__c();
        e1.name='sample1';
        e1.Email_Address__c='sample1@sample.com';
        insert e1;
        Customer_Service_Inquiries_ICS__c test1=new Customer_Service_Inquiries_ICS__c();
        test1.Sales_Channel__c ='Revenue Show Org';
        //test1.Customer_Name__c='test';
        test1.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
        insert test1;
        cr.Min_Amount__c=5000;
        cr.Max_Amount__c=null;
        cr.LOB_Approver__c=e1.id;
        cr.F_R_Approver__c=e.Id;
        cr.AR1_Approver__c=e1.id;
		cr.CSO_Approver__c=e1.id;
        cr.AR2_Approver__c=e.id;
        cr.Additional_Approver__c=e.id;
        cr.Transaction_Types__c='AR Adjustments';
        cr.Location__c='110- Las Vegas';
        cr.sales_channel__c='Revenue Show Org';
        insert cr;
        sample.AR_Adj_CSI_ID__c=test1.id;
        sample.Amount__c=6000;
        testdata.add(sample);
        insert testdata;
        list<AR_Adjustments__c> res_ar=[select  DAM_LOB_Approver__c,DAM_Approver_Email_ID__c, F_R_Approver__c,F_A_Approver_Email__c,
                                        AR1_Approver_Name__c, AR1_Approver_Email__c,	CSO_Approver_Name__c, cso_Approver_Email__c,     
                                        AR2_Approver_Name__c,AR2_Approver_Email__c from AR_Adjustments__c where id in:testdata];
        
    }

}