@istest
public class ICS_SendEmailClassForApproval_TEST {
     static Account facility=TestDataUtil.CreateTestFacility();
     static Account firm=TestDataUtil.CreateTestFirm();
     static Show__c show=TestDataUtil.CreateTestShow(firm.id);
    @istest
    public static void test1(){
         Map<Id,List<Attachment>> mapAttachments =new Map<Id,List<Attachment>> ();
        Map<String,List<sObject>> emailData=new Map<String,List<sObject>>();
        Customer_Service_Inquiries_ICS__c mapCases=new Customer_Service_Inquiries_ICS__c();
       // mapCases.Customer_Name__c='test1';
        mapCases.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;       
      //  mapCases.Customer__c='10000';
        mapCases.Booth_Area__c='test';
       // mapcases.Justification_for_Adjustment_Request__c='test';
        insert mapCases;
        list<AR_Adjustments__c> ar= new list<AR_Adjustments__c>();
        AR_Adjustments__c a=new AR_Adjustments__c();
        a.Amount__c=1000000;
        a.Sales_Order__c='3001';
        a.AR_Adj_CSI_ID__c=mapCases.id;
        a.LOB__c = 'AUDIO VISUAL';
        insert a;
        ar.add(a);
        emailData.put('prakash.gb2@slkgroup.com',ar);
        system.debug(emailData);
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        mails=ICS_SendEmailClassForApproval.generateEmail(emailData,'all',mapCases,'101010101010', mapAttachments);
        system.debug(mails);
    }
    
    @istest
    public static void test2(){
         Map<Id,List<Attachment>> mapAttachments =new Map<Id,List<Attachment>> ();
        Map<String,List<sObject>> emailData=new Map<String,List<sObject>>();
        Customer_Service_Inquiries_ICS__c mapCases=new Customer_Service_Inquiries_ICS__c();
        //mapCases.Customer_Name__c='test1';
        mapCases.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
        insert mapCases;       
        list<Charges__c> ch=new list<Charges__c>();
        Charges__c c=new Charges__c();
        c.Total_Amount__c=10000;
        c.Last_4_of_CC__c='2001';
        c.Last_4_of_Token__c='3001';
        c.CSI_ICS__c=mapcases.Id;
        insert c;
        ch.add(c);
        emailData.put('prakash.gb2@slkgroup.com',ch);
        system.debug(emailData);
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        mails=ICS_SendEmailClassForApproval.generateEmail(emailData,'all',mapCases,'101010101010', mapAttachments);  
    }

    @istest
    public static void test5(){
         Map<Id,List<Attachment>> mapAttachments =new Map<Id,List<Attachment>> ();
        Map<String,List<sObject>> emailData=new Map<String,List<sObject>>();
        Customer_Service_Inquiries_ICS__c mapCases=new Customer_Service_Inquiries_ICS__c();
        //mapCases.Customer_Name__c='test1';
        mapCases.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
        insert mapCases;
        
        list<Refunds_ICS__c> rf=new list<Refunds_ICS__c>();
        Refunds_ICS__c rfn=new Refunds_ICS__c();
        rfn.Amount__c=100000;
        rfn.Last_4_of_CC__c='1001';
        rfn.Last_4_of_Token__c='2001';
        rfn.CSI_ICS__c=mapCases.id;
        insert rfn;
        rf.add(rfn);
        emailData.put('prakash.gb2@slkgroup.com',rf);
        emailData.put('prakash.gb3@slkgroup.com',rf);
        system.debug(emailData);
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
         mails=ICS_SendEmailClassForApproval.generateEmail(emailData,'all',mapCases,'101010101010', mapAttachments);
    }
    @istest
    public static void test6(){
         Map<Id,List<Attachment>> mapAttachments =new Map<Id,List<Attachment>> ();
        Map<String,List<sObject>> emailData=new Map<String,List<sObject>>();
        Customer_Service_Inquiries_ICS__c mapCases=new Customer_Service_Inquiries_ICS__c();
        //mapCases.Customer_Name__c='test1';
        mapCases.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
        insert mapCases;
        
        list<Payment_Transfer_ICS__c> pt=new list<Payment_Transfer_ICS__c>();
        Payment_Transfer_ICS__c p=new Payment_Transfer_ICS__c();
        p.Transfer_Amount__c=200000;
        p.CSI_ICS_No__c=mapCases.id;
        insert p;
        pt.add(p);
            
        emailData.put('prakash.gb2@slkgroup.com',pt);
        
        system.debug(emailData);
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
         mails=ICS_SendEmailClassForApproval.generateEmail(emailData,'all',mapCases,'101010101010', mapAttachments);  
    }
    
    @istest
    public static void test4(){
         Map<Id,List<Attachment>> mapAttachments =new Map<Id,List<Attachment>> ();
        Map<String,List<sObject>> emailData=new Map<String,List<sObject>>();
        Customer_Service_Inquiries_ICS__c mapCases=new Customer_Service_Inquiries_ICS__c();
        //mapCases.Customer_Name__c='test1';
        mapCases.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
        insert mapCases;
        
        list<Receipt_Reversals__c> rr=new list<Receipt_Reversals__c>();
        Receipt_Reversals__c r=new Receipt_Reversals__c();
        r.Receipt_Reversal_Amount__c=1000000;
        r.CSI_ICS__c=mapCases.id;
        insert r;
        rr.add(r);
        emailData.put('prakash.gb2@slkgroup.com',rr);
        system.debug(emailData);
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        mails=ICS_SendEmailClassForApproval.generateEmail(emailData,'all',mapCases,'101010101010', mapAttachments);   
    }
    
    @istest
    public static void test3(){
        
        Map<String,List<sObject>> emailData=new Map<String,List<sObject>>();
        Map<Id,List<Attachment>> mapAttachments =new Map<Id,List<Attachment>> ();
       // Customer_Service_Inquiries_ICS__c mm =  new Customer_Service_Inquiries_ICS__c();
        Customer_Service_Inquiries_ICS__c mapCases=new Customer_Service_Inquiries_ICS__c();
        //mapCases.Customer_Name__c='test1';
        mapCases.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
        insert mapCases;
        
        list<Credit_Memo_ICS__c> cm=new list<Credit_Memo_ICS__c>();
        Credit_Memo_ICS__c cr=new Credit_Memo_ICS__c();
        cr.Amount__c=100000;
        cr.CSI_ICS__c=mapCases.id;
        cr.Credit_Memo_Reason__c='Discount Given to Customer: CM';
        cr.Sales_Order__c = '1001';
        cr.Credit_LOB__c = 'AUDIO VISUAL';
        cr.Amount_w_psp__c = 2828;
        cr.Tax_Amount__c = 543;
       // cr.Total_Amount__c =653;
       
       
        insert cr;
        Credit_Memo_ICS__c crm = [select  id  , Amount__c , Justification_for_Credit_Memo_Request__c, CSI_ICS__c , Credit_Memo_Reason__c , Sales_Order__c,Credit_LOB__c ,Amount_w_psp__c , Tax_Amount__c , Total_Amount__c from Credit_Memo_ICS__c  where id = :cr.id limit 1  ];
        
        Blob b = Blob.valueOf('Test Data');
        
        Attachment attachment = new Attachment();
        attachment.ParentId = cr.id;
        attachment.Name = 'Test Attachment for Parent';
        attachment.Body = b;
        list<attachment> listOfat =  new list<attachment>(); 
        mapAttachments.put(cr.id ,listOfat  );
        
        cm.add(crm);
        list<sObject> listOfsObject =  new list<sObject>();
        listOfsObject  = (list<sObject>)cm;
        emailData.put('prakash.gb2@slkgroup.com',listOfsObject  );
        system.debug(emailData);
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        mails=ICS_SendEmailClassForApproval.generateEmail(emailData,'all',mapCases,'101010101010', mapAttachments);   
        ICS_SendEmailClassForApproval.currencyFormatTotal(333.00);
        ICS_SendEmailClassForApproval.HistorycurrencyFormat(64664.5);
    }


    
/****   
    @istest
    public static void test5(){
        Map<String,List<sObject>> emailData=new Map<String,List<sObject>>();
        Customer_Service_Inquiries_ICS__c mapCases=new Customer_Service_Inquiries_ICS__c();
        //mapCases.Customer_Name__c='test1';
        mapCases.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
        insert mapCases;
        
        list<Refunds_ICS__c> rf=new list<Refunds_ICS__c>();
        Refunds_ICS__c rfn=new Refunds_ICS__c();
        rfn.Amount__c=100000;
        rfn.Last_4_of_CC__c='1001';
        rfn.Last_4_of_Token__c='2001';
        rfn.CSI_ICS__c=mapCases.id;
        insert rfn;
        rf.add(rfn);
        emailData.put('prakash.gb2@slkgroup.com',rf);
        emailData.put('prakash.gb3@slkgroup.com',rf);
        system.debug(emailData);
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        //mails=ICS_SendEmailClassForApproval.generateEmail(emailData,'all',mapCases,'101010101010');   
    }

    @istest
    public static void test6(){
        Map<String,List<sObject>> emailData=new Map<String,List<sObject>>();
        Customer_Service_Inquiries_ICS__c mapCases=new Customer_Service_Inquiries_ICS__c();
        //mapCases.Customer_Name__c='test1';
        mapCases.Opportunity_Name__c=TestDataUtil.CreateTestSalesRepOpp(facility.id,firm.id,show.id).id;
        insert mapCases;
        
        list<Payment_Transfer_ICS__c> pt=new list<Payment_Transfer_ICS__c>();
        Payment_Transfer_ICS__c p=new Payment_Transfer_ICS__c();
        p.Transfer_Amount__c=200000;
        p.CSI_ICS_No__c=mapCases.id;
        insert p;
        pt.add(p);
            
        emailData.put('prakash.gb2@slkgroup.com',pt);
        
        system.debug(emailData);
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        //mails=ICS_SendEmailClassForApproval.generateEmail(emailData,'all',mapCases,'101010101010');   
    }
****/    
}